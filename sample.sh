#!/usr/bin/env bash
set -euo pipefail

# ─────────────────────────────────────────────
#  Colors & helpers
# ─────────────────────────────────────────────
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
CYAN='\033[0;36m'
BOLD='\033[1m'
RESET='\033[0m'

info()    { echo -e "${CYAN}ℹ  $*${RESET}"; }
success() { echo -e "${GREEN}✔  $*${RESET}"; }
warn()    { echo -e "${YELLOW}⚠  $*${RESET}"; }
error()   { echo -e "${RED}✖  $*${RESET}" >&2; }
header()  { echo -e "\n${BOLD}$*${RESET}"; }

# ─────────────────────────────────────────────
#  Prompt helper (with optional default value)
# ─────────────────────────────────────────────
prompt() {
  local message="$1"
  local default="${2:-}"
  local input

  if [[ -n "$default" ]]; then
    read -rp "$(echo -e "${BOLD}${message}${RESET} [${default}]: ")" input
    echo "${input:-$default}"
  else
    read -rp "$(echo -e "${BOLD}${message}${RESET}: ")" input
    echo "$input"
  fi
}

prompt_secret() {
  local message="$1"
  local input
  read -rsp "$(echo -e "${BOLD}${message}${RESET}: ")" input
  echo
  echo "$input"
}

# ─────────────────────────────────────────────
#  Derive Maven URL path from a local file path
#
#  Expects the path to contain the Maven structure
#  somewhere inside it, e.g.:
#    /some/root/com/entrust/android/my-sdk/1.0.0/my-sdk-1.0.0.aar
#  → com/entrust/android/my-sdk/1.0.0/my-sdk-1.0.0.aar
# ─────────────────────────────────────────────
derive_maven_path() {
  local file_path="$1"

  # Try to find a Maven-structured segment: starts with a reversed-domain
  # path (e.g. com/ org/ io/ net/) somewhere in the path.
  if [[ "$file_path" =~ (com|org|io|net|dev)(/.+)$ ]]; then
    echo "${BASH_REMATCH[1]}${BASH_REMATCH[2]}"
  else
    # Fall back: strip the base_dir prefix supplied by the user
    echo "$file_path" | sed "s|^${BASE_DIR}/||"
  fi
}

# ─────────────────────────────────────────────
#  Push a single file to Artifactory
# ─────────────────────────────────────────────
push_file() {
  local local_path="$1"
  local maven_path="$2"
  local target_url="${ARTIFACTORY_URL}/${REPO_NAME}/${maven_path}"
  local filename
  filename=$(basename "$local_path")
  local http_code

  echo -e "  ${CYAN}↑${RESET} ${filename}"

  http_code=$(curl --silent --output /tmp/artifactory_response.json \
    --write-out "%{http_code}" \
    "${AUTH_HEADER[@]}" \
    -X PUT \
    "$target_url" \
    -T "$local_path")

  if [[ "$http_code" == "201" || "$http_code" == "200" ]]; then
    success "Uploaded → ${target_url}"
  else
    error "Failed (HTTP ${http_code}) → ${target_url}"
    if [[ -f /tmp/artifactory_response.json ]]; then
      echo -e "${RED}$(cat /tmp/artifactory_response.json)${RESET}"
    fi
    FAILED_FILES+=("$local_path")
  fi
}

# ─────────────────────────────────────────────
#  Process one package directory
#  (a directory that contains .aar/.pom/-sources.jar)
# ─────────────────────────────────────────────
process_package_dir() {
  local dir="$1"
  local found=0

  # Supported extensions in priority order
  local extensions=("aar" "pom" "jar" "klib" "zip")

  for ext in "${extensions[@]}"; do
    while IFS= read -r -d '' file; do
      local maven_path
      maven_path=$(derive_maven_path "$file")
      push_file "$file" "$maven_path"
      ((found++)) || true
    done < <(find "$dir" -maxdepth 1 -type f -name "*.${ext}" -print0)
  done

  if [[ "$found" -eq 0 ]]; then
    warn "No publishable files found in: $dir"
  fi
}

# ─────────────────────────────────────────────
#  Verify upload — list files at the version path
# ─────────────────────────────────────────────
verify_upload() {
  local maven_path="$1"     # e.g. com/entrust/android/my-sdk/1.0.0
  local api_url="${ARTIFACTORY_URL}/api/storage/${REPO_NAME}/${maven_path}"

  info "Verifying: ${api_url}"
  curl --silent "${AUTH_HEADER[@]}" "$api_url" | python3 -m json.tool 2>/dev/null \
    || curl --silent "${AUTH_HEADER[@]}" "$api_url"
  echo
}

# ═════════════════════════════════════════════
#  MAIN
# ═════════════════════════════════════════════

header "╔══════════════════════════════════════╗"
header "║   Artifactory Package Pusher  v1.0   ║"
header "╚══════════════════════════════════════╝"

# ── 1. Artifactory connection details ────────
header "① Artifactory Connection"

ARTIFACTORY_URL=$(prompt "Artifactory base URL (no trailing slash)" "https://artifactory.example.com/artifactory")
REPO_NAME=$(prompt "Target repository name" "libs-release-local")

echo
echo -e "${BOLD}Authentication — choose method:${RESET}"
echo "  1) API Key  (recommended)"
echo "  2) Username & Password"
AUTH_METHOD=$(prompt "Choice" "1")

AUTH_HEADER=()
if [[ "$AUTH_METHOD" == "1" ]]; then
  API_KEY=$(prompt_secret "API Key")
  AUTH_HEADER=(-H "X-JFrog-Art-Api: ${API_KEY}")
else
  USERNAME=$(prompt "Username")
  PASSWORD=$(prompt_secret "Password")
  AUTH_HEADER=(-u "${USERNAME}:${PASSWORD}")
fi

# ── 2. Package path(s) ────────────────────────
header "② Package Path(s)"
info "You can enter a single file, a version directory, or a root directory."
info "Example: /path/to/com/entrust/android/digitalcard-light-sdk-release/2.6.0-3"

BASE_DIR=""
PATHS=()

while true; do
  PKG_PATH=$(prompt "Package path (leave empty to finish)")
  [[ -z "$PKG_PATH" ]] && break

  if [[ ! -e "$PKG_PATH" ]]; then
    error "Path does not exist: $PKG_PATH"
    continue
  fi

  # Store the first path's root to help strip prefix when deriving Maven paths
  [[ -z "$BASE_DIR" ]] && BASE_DIR=$(dirname "$PKG_PATH")

  PATHS+=("$PKG_PATH")
  success "Added: $PKG_PATH"
done

if [[ "${#PATHS[@]}" -eq 0 ]]; then
  error "No paths provided. Exiting."
  exit 1
fi

# ── 3. Confirm before pushing ─────────────────
header "③ Summary"
echo -e "  ${BOLD}Artifactory URL :${RESET} ${ARTIFACTORY_URL}"
echo -e "  ${BOLD}Repository      :${RESET} ${REPO_NAME}"
echo -e "  ${BOLD}Packages        :${RESET} ${#PATHS[@]} path(s)"
for p in "${PATHS[@]}"; do
  echo -e "                    • $p"
done

echo
CONFIRM=$(prompt "Proceed with upload? (y/N)" "N")
if [[ ! "$CONFIRM" =~ ^[Yy]$ ]]; then
  warn "Aborted by user."
  exit 0
fi

# ── 4. Upload ─────────────────────────────────
header "④ Uploading"
FAILED_FILES=()

for pkg_path in "${PATHS[@]}"; do
  echo
  info "Processing: ${pkg_path}"

  if [[ -f "$pkg_path" ]]; then
    # Single file
    maven_path=$(derive_maven_path "$pkg_path")
    push_file "$pkg_path" "$maven_path"

  elif [[ -d "$pkg_path" ]]; then
    # Directory — walk recursively looking for version-leaf directories
    # A version-leaf dir contains files (not only sub-dirs)
    while IFS= read -r -d '' leaf_dir; do
      # Only process dirs that contain actual files
      if find "$leaf_dir" -maxdepth 1 -type f | grep -q .; then
        info "  Package dir: ${leaf_dir}"
        process_package_dir "$leaf_dir"
      fi
    done < <(find "$pkg_path" -type d -print0)

    # Also handle files directly in the top-level dir
    process_package_dir "$pkg_path"
  fi
done

# ── 5. Results ────────────────────────────────
header "⑤ Results"

if [[ "${#FAILED_FILES[@]}" -eq 0 ]]; then
  success "All files uploaded successfully!"
else
  error "${#FAILED_FILES[@]} file(s) failed to upload:"
  for f in "${FAILED_FILES[@]}"; do
    echo -e "  ${RED}• $f${RESET}"
  done
fi

# ── 6. Optional verification ──────────────────
echo
VERIFY=$(prompt "Run storage verification on a path? (y/N)" "N")
if [[ "$VERIFY" =~ ^[Yy]$ ]]; then
  VERIFY_PATH=$(prompt "Maven path to verify (e.g. com/entrust/android/my-sdk/1.0.0)")
  verify_upload "$VERIFY_PATH"
fi

success "Done."