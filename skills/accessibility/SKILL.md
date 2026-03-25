---
name: accessibility
description: Audit and fix mobile Flutter accessibility (WCAG 2 AA required) — screen readers, keyboard, Voice Access, Switch Access, Assistive Access, display accommodations
allowed-tools: Read, Edit, Write, Glob, Grep, Bash, Agent
argument-hint: "[platform] [service] [level] — e.g. 'android', 'ios keyboard', 'android voice-access', 'AAA'"
---

# Mobile Accessibility Audit & Remediation

You are a mobile accessibility expert for the `flutter_ui_component` package. This skill targets **Android** and **iOS** only. When invoked, audit and fix issues across **all** accessibility services — not just screen readers.

## Target Compliance

- **WCAG 2 AA is the required baseline.** All widgets MUST pass Level A + AA.
- **WCAG 2 AAA is optional.** Only audit for AAA if the user explicitly requests it.

## Accessibility Services Covered

| Category | Android | iOS |
|----------|---------|-----|
| **Screen Readers** | TalkBack | VoiceOver |
| **Voice Control** | Voice Access | Voice Control |
| **Switch Navigation** | Switch Access | Switch Control |
| **Keyboard** | Physical keyboard, D-pad | Physical keyboard, Full Keyboard Access |
| **Simplified UI** | — | Assistive Access |
| **Display** | Font size, High contrast, Color correction, Magnification | Dynamic Type, Bold Text, Increase Contrast, Zoom |
| **Motor / Touch** | Touch & hold delay | Touch Accommodations, AssistiveTouch |
| **Reduce Motion** | Remove animations | Reduce Motion |

For detailed platform gesture tables and Flutter mappings, read `skills/accessibility/reference.md` § Accessibility Services Reference.

## Core Principle — Prefer Flutter's Built-in Semantics

**Avoid wrapping widgets with custom `Semantics` unless absolutely necessary.** Flutter's built-in widgets already provide correct semantic roles, states, and announcements. Wrapping them overrides framework behavior, risks duplicates, and adds maintenance burden.

Use custom `Semantics` only for: custom-painted widgets, `MergeSemantics` composites, live regions, `ExcludeSemantics` on decorative elements, and custom sort order.

For detailed examples, read `skills/accessibility/reference.md` § Built-in Semantics — When to Use Custom Semantics.

## Hard Rules

### Every image must be accessible or explicitly decorative

```dart
// WRONG — screen reader says nothing
Image.asset('assets/logo.png')
// CORRECT — meaningful image
Image.asset('assets/profile.png', semanticLabel: 'Profile photo of John Doe')
// CORRECT — decorative image
Image.asset('assets/wave.png', excludeFromSemantics: true)
```

### Never use GestureDetector for tap targets

`GestureDetector` does NOT receive keyboard focus, Switch Access scanning, or Voice Access targeting.

```dart
// WRONG — unreachable via keyboard, switch, or voice
GestureDetector(onTap: _onTap, child: Text('Click me'))
// CORRECT — focusable, keyboard-activatable, scannable
InkWell(onTap: _onTap, child: Text('Click me'))
```

### Icon-only buttons must have tooltip or semanticLabel

```dart
// WRONG — no accessible name
IconButton(onPressed: _delete, icon: Icon(Icons.delete))
// CORRECT — tooltip serves as accessible name AND visible hint
IconButton(onPressed: _delete, icon: Icon(Icons.delete), tooltip: 'Delete item')
```

### Never use ExcludeSemantics on non-decorative content

```dart
// CORRECT — decorative divider
ExcludeSemantics(child: Divider())
// WRONG — this icon conveys error state
ExcludeSemantics(child: Icon(Icons.error, color: Colors.red))
```

### Never wrap Text in fixed-height containers

```dart
// WRONG — clips at large font sizes
SizedBox(height: 48, child: Text('Clipped at 200%'))
// CORRECT — grows with text
ConstrainedBox(constraints: BoxConstraints(minHeight: 48), child: Text('Grows'))
```

### Focus must not trigger unexpected context changes

```dart
// WRONG — navigates on focus
Focus(onFocusChange: (f) { if (f) Navigator.push(...); }, child: ListTile(...))
// CORRECT — action on explicit activation
ElevatedButton(onPressed: _submitForm, child: Text('Submit'))
```

### Interactive elements must have correct semantic roles

Use built-in Material widgets (they declare roles automatically). If custom widgets are unavoidable, declare roles via `Semantics`.

### Additional hard rules (no code needed)

- **Icon/graphic contrast**: Non-text UI components require 3:1 minimum against background.
- **Orientation**: Support both portrait and landscape — never lock orientation.
- **No overlapping controls**: Adequate spacing between adjacent touch targets.

For anti-pattern examples, read `skills/accessibility/reference.md` § Anti-patterns.

## Core Standards

1. **Use Flutter's Built-in Semantics First** — only add custom `Semantics` for edge cases.
2. **Semantic Labels** — use widget's own `semanticLabel` parameter.
3. **Touch Targets** — minimum 48x48 dp (Android) / 44x44 pt (iOS).
4. **Keyboard & Focus** — all interactive widgets focusable via Tab, Enter/Space to activate, visible focus indicators (3:1 contrast).
5. **Voice Access** — all elements need visible labels or accessible names for "tap [label]".
6. **Switch Access** — all widgets reachable via linear scanning, no traps.
7. **Content Grouping** — related elements grouped via `MergeSemantics`; distinct actions stay separate.
8. **Screen Reader Announcements** — widgets announce role, name, and state changes.
9. **Color Independence** — never convey info by color alone; provide text/icon alternatives.
10. **Animation Safety** — respect `MediaQuery.disableAnimations` and `reduceMotion`.
11. **Contrast** — normal text >= 4.5:1, large text >= 3:1, non-text UI >= 3:1.
12. **Text Scaling** — support up to 200% without clipping; avoid fixed-height text containers.
13. **Orientation** — support both portrait and landscape; no information loss on rotation.
14. **Assistive Access (iOS)** — clear labels, large targets, simple interaction patterns.

## Workflow

### Phase 1 — Platform & Service Selection

Ask which platform(s): **Android**, **iOS**, or **Both** (default). Optionally focus on a specific service.

### Phase 2 — Conformance Level

Default to **AA**. Include AAA only if user explicitly asks.

### Phase 3 — Audit

Scan `lib/src/widgets/` and check each widget against the checklist below.

#### Required Checklist — WCAG 2 AA

**Screen Readers:**
- [ ] All images/icons have `semanticLabel` or `excludeFromSemantics: true`
- [ ] Interactive elements have accessible names and correct semantic roles
- [ ] State changes announced via widget-native semantics
- [ ] Related content grouped with `MergeSemantics`
- [ ] Logical reading order; no redundant `Semantics` wrappers

**Keyboard:**
- [ ] All interactive widgets focusable via Tab; focus order matches visual layout
- [ ] Visible focus indicators with 3:1 contrast
- [ ] No context changes on focus; no focus traps
- [ ] Buttons activate with Enter/Space; dialogs dismiss with Escape
- [ ] No `GestureDetector`-only interactive elements

**Voice Control:**
- [ ] All interactive elements have visible/accessible labels (unique, descriptive)
- [ ] Every icon-only button has `tooltip` or `semanticLabel`

**Switch Access:**
- [ ] All interactive widgets in scan order; none skipped
- [ ] Related elements grouped logically; no time-limited interactions

**Touch & Motor:**
- [ ] Touch targets >= 48x48 dp; no overlapping controls
- [ ] Custom gestures have accessible alternatives

**Display & Visual:**
- [ ] Text contrast >= 4.5:1 (normal) / 3:1 (large); non-text >= 3:1
- [ ] Info not conveyed by color alone
- [ ] No fixed-height containers wrapping Text; scales to 200%
- [ ] Both orientations supported; no info loss on rotation
- [ ] `ExcludeSemantics` only on decorative content
- [ ] Respects `MediaQuery.disableAnimations`; no 3+ flashes/sec

**Input & Forms:**
- [ ] Error messages include suggestion text, not just color
- [ ] Labels for all inputs; consistent navigation patterns

For the optional AAA checklist, read `skills/accessibility/reference.md` § Optional Checklist — WCAG 2 AAA.

### Phase 4 — Remediation

Group fixes by severity:

| Severity | Description |
|----------|-------------|
| **CRITICAL** | Blocks access entirely (missing semantics, no focus) |
| **MAJOR** | Significant barrier (poor contrast, small touch targets) |
| **MINOR** | Inconvenience (missing helper text, suboptimal focus order) |

For the full audit report template, read `skills/accessibility/reference.md` § Audit Report Format.

## Project-Specific Guidance

For detailed patterns (semantic labels, touch target fixes, screen reader patterns, focus/navigation order, theme contrast pairs, component list), read `skills/accessibility/reference.md` § Project-Specific Guidance.

## Testing Recommendations

For automated test examples and full manual testing tables (screen readers, keyboard, voice control, switch access, display accommodations), read `skills/accessibility/reference.md` § Testing Recommendations.
