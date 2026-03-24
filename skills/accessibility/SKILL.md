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

This skill addresses **all** mobile accessibility services, not just screen readers:

| Category | Android | iOS |
|----------|---------|-----|
| **Screen Readers** | TalkBack | VoiceOver |
| **Voice Control** | Voice Access | Voice Control |
| **Switch Navigation** | Switch Access | Switch Control |
| **Keyboard / External Input** | Physical keyboard, D-pad | Physical keyboard, Full Keyboard Access |
| **Simplified UI** | — | Assistive Access |
| **Display Accommodations** | Font size, Display size, High contrast, Color correction, Magnification | Dynamic Type, Bold Text, Increase Contrast, Reduce Transparency, Zoom |
| **Motor / Touch** | Touch & hold delay, Interaction controls | Touch Accommodations, AssistiveTouch |
| **Reduce Motion** | Remove animations | Reduce Motion |

Every widget must work correctly with **all** of these services, not just TalkBack/VoiceOver.

## Core Principle — Prefer Flutter's Built-in Semantics

**Avoid wrapping widgets with custom `Semantics` unless absolutely necessary.**

Flutter's built-in widgets (`ElevatedButton`, `TextField`, `Checkbox`, `Radio`, `Switch`, `Slider`, `ListTile`, etc.) already provide correct semantic roles, states, and announcements to TalkBack and VoiceOver. When you wrap them with a `Semantics` widget, you **override** the framework's behavior. This means:

- You lose automatic updates when Flutter improves OS-level accessibility mappings in future releases.
- You risk announcing incorrect or duplicate information.
- You take on the maintenance burden of keeping semantics in sync with platform changes.

### When to use built-in semantics (the default)

Use the widget's own accessibility parameters:

```dart
// CORRECT — Flutter handles the semantic role, state, and announcement
ElevatedButton(
  onPressed: _submit,
  child: Text('Submit'),  // TalkBack/VoiceOver reads "Submit, Button"
)

// CORRECT — use the widget's semanticLabel param for a custom label
UberElevatedButton(
  onPressed: _submit,
  semanticLabel: 'Submit payment',  // overrides the label, keeps the role
  child: Text('Submit'),
)

// CORRECT — TextField already announces as text field
TextField(
  decoration: InputDecoration(labelText: 'Email'),  // reads "Email, Text field"
)

// CORRECT — Radio already announces checked state
Radio<String>(
  value: 'option1',
  groupValue: selected,
  onChanged: _onChanged,  // reads "Option 1, Radio button, checked/unchecked"
)
```

### When custom `Semantics` IS justified (edge cases only)

Only wrap with `Semantics` when there is **no Flutter widget** that provides the behavior you need:

1. **Custom-painted widgets** — `CustomPaint` or `Canvas`-based widgets have no semantics at all.
2. **Composite widgets read as one unit** — Use `MergeSemantics` when an icon + text should be announced as a single element.
3. **Live regions for dynamic content** — Wrap with `Semantics(liveRegion: true)` for error messages or status changes that must auto-announce.
4. **Excluding decorative elements** — Use `ExcludeSemantics` for purely decorative images/dividers.
5. **Custom sort order** — Use `Semantics(sortKey: OrdinalSortKey(n))` only when the visual order doesn't match the logical reading order and layout changes can't fix it.

```dart
// JUSTIFIED — CustomPaint has zero built-in semantics
Semantics(
  label: 'Rating: 4 out of 5 stars',
  child: CustomPaint(painter: StarRatingPainter(rating: 4)),
)

// JUSTIFIED — decorative divider should be skipped
ExcludeSemantics(
  child: Divider(),
)

// JUSTIFIED — error message must auto-announce when it appears
Semantics(
  liveRegion: true,
  child: Text(errorMessage),
)
```

### Hard Rules — Always Enforce

#### Every image must be accessible or explicitly decorative

All `Image`, `Image.asset`, `Image.network`, `Icon`, and `SvgPicture` widgets must either:
- Have a `semanticLabel` describing the content, OR
- Be marked as decorative with `excludeFromSemantics: true`

There is no middle ground. An unlabeled image is invisible to screen readers, Voice Access, and Switch Access — but still takes up space, confusing the experience.

```dart
// CORRECT — meaningful image with label
Image.asset(
  'assets/profile.png',
  semanticLabel: 'Profile photo of John Doe',
)

// CORRECT — decorative image excluded
Image.asset(
  'assets/decorative_wave.png',
  excludeFromSemantics: true, // purely visual, no meaning
)

// CORRECT — icon with label
Icon(Icons.delete, semanticsLabel: 'Delete')

// WRONG — image with no semantic info at all
Image.asset('assets/logo.png')  // screen reader says nothing, voice user can't reference it
```

#### Never use GestureDetector for tap targets

`GestureDetector` is pointer-only. It does NOT receive keyboard focus, does NOT appear in Switch Access scanning, and does NOT work with Voice Access. Always use Material interactive widgets.

```dart
// WRONG — unreachable via keyboard, switch, or voice
GestureDetector(
  onTap: _onTap,
  child: Container(child: Text('Click me')),
)

// CORRECT — focusable, keyboard-activatable, scannable, voice-targetable
InkWell(
  onTap: _onTap,
  child: Container(child: Text('Click me')),
)

// ALSO CORRECT — use the appropriate Material widget
ElevatedButton(onPressed: _onTap, child: Text('Click me'))
TextButton(onPressed: _onTap, child: Text('Click me'))
IconButton(onPressed: _onTap, icon: Icon(Icons.add), tooltip: 'Add item')
```

The only acceptable use of `GestureDetector` is for non-interactive gestures (e.g., detecting swipe direction for a custom scroll physics) that have an accessible alternative.

#### Icon-only buttons must have tooltip or semanticLabel

Screen readers, Voice Access, and Switch Access have no way to convey the purpose of an icon-only button without a text label. Every `IconButton` must have a `tooltip` (preferred — also gives sighted users a hover hint) or at minimum an `Icon` with `semanticsLabel`.

```dart
// WRONG — screen reader says nothing, voice user can't say "tap [???]"
IconButton(
  onPressed: _delete,
  icon: Icon(Icons.delete),
)

// CORRECT — tooltip serves as accessible name AND visible hint
IconButton(
  onPressed: _delete,
  icon: Icon(Icons.delete),
  tooltip: 'Delete item',
)

// ALSO CORRECT — semanticsLabel on the Icon itself
IconButton(
  onPressed: _delete,
  icon: Icon(Icons.delete, semanticLabel: 'Delete item'),
)
```

#### Never use ExcludeSemantics on non-decorative content

`ExcludeSemantics` completely hides the wrapped widget from all assistive technology — screen readers, Voice Access, Switch Access, and keyboard focus. Only use it for **purely decorative** elements (background patterns, dividers, ornamental icons).

If content conveys any meaning at all — a status indicator, an avatar with a name, an informational icon — it is NOT decorative and must NOT be excluded.

```dart
// CORRECT — decorative divider, no meaning
ExcludeSemantics(child: Divider())

// CORRECT — decorative background pattern
ExcludeSemantics(child: Image.asset('assets/bg_pattern.png'))

// WRONG — this icon conveys error state, hiding it loses information
ExcludeSemantics(
  child: Icon(Icons.error, color: Colors.red),  // user won't know there's an error
)

// WRONG — this image is the user's profile, it has meaning
ExcludeSemantics(
  child: CircleAvatar(backgroundImage: NetworkImage(user.photoUrl)),
)

// CORRECT — give it a label instead
CircleAvatar(
  backgroundImage: NetworkImage(user.photoUrl),
  child: Semantics(label: 'Profile photo of ${user.name}', child: Container()),
)
```

#### Never wrap Text in fixed-height containers

`SizedBox(height: N)` or `Container(height: N)` around text will clip content when users set system font size to 150-200% (Android Display size, iOS Dynamic Type). Always use `minHeight` constraints so the container grows with the text.

```dart
// WRONG — text clips at large font sizes
SizedBox(
  height: 48,
  child: Center(child: Text('This will be clipped at 200% font')),
)

// WRONG — same problem with Container
Container(
  height: 32,
  child: Text('Clipped label'),
)

// CORRECT — minimum height, grows with text
ConstrainedBox(
  constraints: const BoxConstraints(minHeight: 48),
  child: Center(child: Text('This grows with font size')),
)

// CORRECT — no height constraint at all (let content dictate size)
Padding(
  padding: const EdgeInsets.symmetric(vertical: 12),
  child: Text('Natural height'),
)
```

#### Icon and graphical element contrast must meet 3:1

Non-text UI components (icons, chart elements, form field borders, custom graphics) require a minimum 3:1 contrast ratio against their background. This is separate from text contrast (4.5:1). Icons that fail this threshold are invisible to users with low vision — including those using color correction or high contrast modes.


#### Focus must not trigger unexpected context changes

When a widget receives focus (via Tab, Switch Access scan, or screen reader navigation), it must NOT automatically trigger side effects like navigation, form submission, dialog opening, or content changes. Focus is for **reading and selecting**, not for **acting**.

```dart
// WRONG — navigates away just because the element got focus
Focus(
  onFocusChange: (hasFocus) {
    if (hasFocus) Navigator.push(context, ...); // unexpected navigation on focus
  },
  child: ListTile(...),
)

// WRONG — submits form on focus
Focus(
  onFocusChange: (hasFocus) {
    if (hasFocus) _submitForm(); // action on focus, not on activation
  },
  child: Text('Submit'),
)

// CORRECT — action happens on explicit activation (tap/Enter/Space)
ElevatedButton(
  onPressed: _submitForm, // only fires on deliberate activation
  child: Text('Submit'),
)
```

#### Interactive elements must have correct semantic roles

All interactive widgets must expose the correct role (button, text field, checkbox, etc.) to assistive technology. Using built-in Flutter Material widgets guarantees this. If you build custom interactive elements, they MUST declare their role via `Semantics`.

```dart
// WRONG — custom interactive widget with no role
GestureDetector(
  onTap: _toggle,
  child: Container(
    color: isOn ? Colors.green : Colors.grey,
    child: Text(isOn ? 'ON' : 'OFF'),
  ),
)

// CORRECT — use the built-in widget that declares the role
Switch(value: isOn, onChanged: _toggle)

// CORRECT — if custom widget is unavoidable, declare the role
Semantics(
  toggled: isOn,
  label: 'Power',
  child: GestureDetector(...), // still prefer InkWell, but role is declared
)
```

#### App must support both screen orientations

Do not lock the app to a single orientation. Users with motor impairments may have devices mounted in a fixed position (landscape or portrait). Content must remain usable and consistent in both orientations — no content loss, no layout breakage.


#### Interactive controls must not overlap

Touch targets must have adequate spacing so they don't overlap each other. Overlapping controls cause accidental activations for all users and are especially problematic for users with motor impairments, Voice Access (ambiguous target regions), and Switch Access.

```dart
// WRONG — buttons stacked with no spacing, targets overlap
Row(
  children: [
    IconButton(onPressed: _edit, icon: Icon(Icons.edit), tooltip: 'Edit'),
    IconButton(onPressed: _delete, icon: Icon(Icons.delete), tooltip: 'Delete'),
  ],
)

// CORRECT — adequate spacing between targets
Row(
  children: [
    IconButton(onPressed: _edit, icon: Icon(Icons.edit), tooltip: 'Edit'),
    const SizedBox(width: 8),
    IconButton(onPressed: _delete, icon: Icon(Icons.delete), tooltip: 'Delete'),
  ],
)
```

### Anti-patterns — flag these during audit

```dart
// WRONG — ElevatedButton already announces as "Button"
Semantics(
  button: true,  // redundant, Flutter does this
  label: 'Submit',
  child: ElevatedButton(
    onPressed: _submit,
    child: Text('Submit'),  // now announced twice or conflicts
  ),
)

// WRONG — TextField already announces as "Text field"
Semantics(
  textField: true,  // redundant
  label: 'Email',
  child: TextField(
    decoration: InputDecoration(labelText: 'Email'),  // duplicate label
  ),
)

// WRONG — wrapping Radio overrides its built-in checked/unchecked state
Semantics(
  checked: isSelected,  // Radio already does this
  child: Radio<String>(value: 'a', groupValue: selected, onChanged: _onChanged),
)
```

## Core Standards

1. **Use Flutter's Built-in Semantics First** — Rely on widget-native accessibility. Only add custom `Semantics` for edge cases listed above. This ensures future Flutter updates automatically improve OS compatibility across all services.
2. **Semantic Labels** — Use the widget's own `semanticLabel` parameter. Screen readers, Voice Access, and Switch Access all depend on this to identify elements.
3. **Touch Targets** — Minimum 48x48 dp for all tappable elements (Material guideline). iOS Human Interface Guidelines recommend 44x44 pt. This affects touch, Switch Access hit areas, and Voice Access target recognition.
4. **Keyboard & Focus Navigation** — All interactive widgets must be focusable and operable via external keyboard (Tab/Shift+Tab to navigate, Enter/Space to activate). Focus order must be logical. Focus indicators must be **clearly visible** — the focus ring/highlight must have sufficient contrast (3:1 minimum against adjacent colors) so users can always see which element is focused. Never hide or remove focus indicators.
5. **Voice Access / Voice Control** — All interactive elements must have visible labels or accessible names so users can say "tap [label]" to activate them. Unlabeled elements are invisible to voice control.
6. **Switch Access / Switch Control** — Widgets must be reachable via linear scanning. No element should be skipped or trapped. Group related elements logically so scanning is efficient.
7. **Content Grouping** — Related elements (icon + label, avatar + name, title + subtitle) should be grouped using `MergeSemantics` or read as a single semantic node. This prevents screen readers from announcing fragments and reduces Switch Access scan targets. Conversely, distinct interactive elements must NOT be merged — each action needs its own semantic node.
8. **Screen Reader Announcements** — Widgets must announce role, name, and state changes. Prefer Flutter's built-in announcements over manual `Semantics` properties.
9. **Color Independence** — Information must not be conveyed by color alone. Provide text, icons, or patterns as secondary indicators.
10. **Animation & Motion Safety** — Respect `MediaQuery.disableAnimations` and `AccessibilityFeatures.reduceMotion`. Never auto-play animations that cannot be paused.
11. **Contrast Ratios** — Normal text: >= 4.5:1. Large text (18sp+ or 14sp bold): >= 3:1. Non-text UI components (icons, borders, graphical elements): >= 3:1.
12. **Text Scaling / Dynamic Type** — Widgets must support system font size scaling (Android Display size, iOS Dynamic Type) up to 200% without content clipping, truncation, or layout breakage. Use `MediaQuery.textScaleFactor` awareness. Avoid fixed-height containers around text.
13. **Screen Orientation** — App must support both portrait and landscape. Do not lock orientation. Content must remain consistent and usable in both orientations with no information loss.
14. **Assistive Access (iOS)** — Widgets should work in the simplified, large-target UI mode. This means: clear labels, large touch targets, and simple interaction patterns (no complex gestures required).

## Accessibility Services Reference

### Screen Readers

| Feature | Android (TalkBack) | iOS (VoiceOver) |
|---------|-------------------|-----------------|
| Activation | Double-tap | Double-tap |
| Navigation | Swipe right/left | Swipe right/left |
| Scroll | Two-finger swipe | Three-finger swipe |
| Back/Escape | Two-finger swipe down-then-left | Two-finger scrub (Z gesture) |
| Read all | Three-finger swipe up | Two-finger swipe down |
| Focus ring | Green rectangle | Black rounded rectangle |

#### Flutter Semantics → Screen Reader Mapping

| `Semantics` property | TalkBack announcement | VoiceOver announcement |
|----------------------|----------------------|----------------------|
| `label` | Read as element name | Read as element name |
| `hint` | "Double tap to..." | "Double tap to..." |
| `button: true` | Appends "Button" | Appends "Button" |
| `header: true` | Appends "Heading" | Appends "Heading" |
| `textField: true` | "Edit box" | "Text field" |
| `enabled: false` | "Disabled" | "Dimmed" |
| `liveRegion: true` | Auto-announces changes | Auto-announces changes |
| `value` | Reads current value | Reads current value |

### Keyboard / External Input

Users with motor impairments or external keyboards must be able to operate the entire UI without touch.

| Action | Android Keyboard | iOS Keyboard |
|--------|-----------------|--------------|
| Move focus forward | Tab | Tab |
| Move focus backward | Shift+Tab | Shift+Tab |
| Activate button/link | Enter or Space | Enter or Space |
| Toggle checkbox/switch | Space | Space |
| Navigate radio group | Arrow keys | Arrow keys |
| Scroll | Arrow keys / Page Up/Down | Arrow keys |
| Dismiss dialog/sheet | Escape | Escape |
| Open dropdown/picker | Enter or Space | Enter or Space |

**Flutter requirements:**
- All interactive widgets must receive focus via `Tab` key
- Focus indicator (highlight ring) must be visible — never hide it
- Focus must not get trapped in any widget — Escape must dismiss overlays
- Focus order must match visual layout order
- `FocusableActionDetector` or built-in Material widgets handle this — don't break it

```dart
// CORRECT — Material widgets are keyboard-navigable by default
ElevatedButton(onPressed: _submit, child: Text('Submit'))
// Already responds to Tab focus + Enter/Space activation

// WRONG — GestureDetector is NOT keyboard-accessible
GestureDetector(
  onTap: _submit,
  child: Container(child: Text('Submit')), // can't be focused or activated via keyboard
)

// FIX — use InkWell or wrap in Focus + keyboard handler
InkWell(
  onTap: _submit,
  child: Container(child: Text('Submit')), // focusable + keyboard-activatable
)
```

### Voice Access / Voice Control

Users speak commands like "tap Submit" or "tap 3" to interact with the UI.

| Feature | Android (Voice Access) | iOS (Voice Control) |
|---------|----------------------|---------------------|
| Activate by label | "Tap [label]" | "Tap [label]" |
| Show numbers | "Show numbers" (shows overlay numbers) | "Show numbers" |
| Show grid | "Show grid" | "Show grid" |
| Scroll | "Scroll down/up" | "Scroll down/up" |
| Type text | "Type [text]" | "Type [text]" |
| Go back | "Go back" | "Go back" |

**Flutter requirements:**
- Every interactive element MUST have a visible text label or an accessible name — unlabeled elements cannot be activated by voice
- Labels must be **unique and descriptive** within the visible screen — if two buttons say "Submit", voice users can't distinguish them
- Icon-only buttons MUST have `semanticLabel` — voice users have no way to refer to them otherwise
- Avoid custom gesture-only interactions (long press, swipe to delete) without an accessible alternative

```dart
// WRONG — icon button with no label, voice user can't say "tap [???]"
IconButton(
  onPressed: _delete,
  icon: Icon(Icons.delete),
)

// CORRECT — voice user says "tap Delete item"
IconButton(
  onPressed: _delete,
  icon: Icon(Icons.delete),
  tooltip: 'Delete item', // serves as accessible name AND voice target
)
```

### Switch Access / Switch Control

Users navigate sequentially through focusable elements using one or two switches (physical buttons, head movements, etc.).

| Feature | Android (Switch Access) | iOS (Switch Control) |
|---------|------------------------|---------------------|
| Scanning mode | Linear or row-column | Item, Point, or Manual |
| Select item | Switch press | Switch press |
| Move to next | Auto-scan or switch | Auto-scan or switch |
| Scroll | Select scroll action from menu | Select scroll action |

**Flutter requirements:**
- All interactive widgets must appear in the focus/scan order
- No element should be skippable or unreachable
- Group related elements so scanning is efficient (e.g., a card with title + subtitle + button should scan as logical units, not individual text nodes)
- Avoid time-limited interactions — switch users are slower
- Keep the number of focusable elements reasonable — too many small targets makes scanning tedious

```dart
// GOOD — MergeSemantics reduces scan targets for related content
MergeSemantics(
  child: ListTile(
    leading: Icon(Icons.account_circle),
    title: Text('John Doe'),
    subtitle: Text('john@example.com'),
    onTap: _openProfile,
  ),
)
```

### Display Accommodations

| Setting | Android | iOS | Flutter Impact |
|---------|---------|-----|----------------|
| **Large text** | Font size (Settings) | Dynamic Type | `MediaQuery.textScaleFactor` — layouts must not clip |
| **Bold text** | Bold text (Settings) | Bold Text | `MediaQuery.boldText` — respect system bold preference |
| **High contrast** | High contrast text | Increase Contrast | `MediaQuery.highContrast` — can increase border/text weight |
| **Reduce transparency** | — | Reduce Transparency | `MediaQuery.reduceTransparency` — avoid transparent overlays |
| **Color correction** | Color correction modes | Color Filters | Don't rely on color alone — provide text/icon alternatives |
| **Magnification** | Magnification gesture | Zoom | Ensure content is not cut off when zoomed |
| **Reduce motion** | Remove animations | Reduce Motion | `MediaQuery.disableAnimations` / `accessibleNavigation` |

```dart
// Text scaling — don't use fixed-height containers around text
// WRONG — text will overflow at large font sizes
SizedBox(
  height: 48,
  child: Text('Long label that will be clipped at 200% font size'),
)

// CORRECT — let height grow with text
ConstrainedBox(
  constraints: const BoxConstraints(minHeight: 48),
  child: Text('Label grows with font size'),
)

// Reduce motion
final reduceMotion = MediaQuery.of(context).disableAnimations;
final duration = reduceMotion
    ? Duration.zero
    : const Duration(milliseconds: 150);

// High contrast — optionally increase visual emphasis
final highContrast = MediaQuery.of(context).highContrast;

// Bold text
final boldText = MediaQuery.of(context).boldText;
```

## Workflow

### Phase 1 — Platform & Service Selection

Ask which mobile platform(s) to audit:
- **Android** — TalkBack, Voice Access, Switch Access, Keyboard, Display settings
- **iOS** — VoiceOver, Voice Control, Switch Control, Full Keyboard Access, Assistive Access, Dynamic Type
- **Both** (default)

Optionally focus on a specific service (e.g., "keyboard only", "voice access"). Default is **all services**.

### Phase 2 — Conformance Level

Default to **AA** (required). Only include AAA checks if the user explicitly asks.

### Phase 3 — Audit

Scan the codebase for issues. Check each widget file in `lib/src/widgets/` and report findings.

#### Required Checklist — WCAG 2 AA

**Screen Readers (TalkBack / VoiceOver):**
- [ ] All images/icons have `semanticLabel` OR `excludeFromSemantics: true` — no unlabeled images
- [ ] Interactive elements have accessible names announced correctly
- [ ] All interactive elements expose correct semantic role (button, text field, checkbox, etc.) — use built-in widgets or declare via `Semantics`
- [ ] Widgets announce correct role via built-in behavior (not redundant `Semantics` wrappers)
- [ ] State changes announced via widget-native semantics (`enabled`, `selected`, `checked`)
- [ ] Related content grouped with `MergeSemantics` — icon+label, avatar+name read as single unit
- [ ] Content has logical reading order for swipe navigation
- [ ] No unnecessary `Semantics` wrappers (flag as anti-pattern)

**Keyboard / External Input:**
- [ ] All interactive widgets are focusable via Tab key
- [ ] Focus order matches visual layout order
- [ ] Focus indicator (ring/highlight) is visible on every focusable element with sufficient contrast (3:1)
- [ ] Focus does NOT trigger unexpected context changes (no navigation, submission, or dialog on focus alone)
- [ ] Buttons/links activate with Enter or Space
- [ ] Radio groups navigable with Arrow keys
- [ ] Dialogs/sheets dismissible with Escape
- [ ] Focus is not trapped — user can always navigate away
- [ ] No `GestureDetector`-only interactive elements (use `InkWell` or Material widgets)

**Voice Access / Voice Control:**
- [ ] All interactive elements have visible text labels or accessible names
- [ ] Labels are unique and descriptive within the visible screen
- [ ] Every icon-only button has `tooltip` (preferred) or `semanticLabel` — no unlabeled icon buttons
- [ ] No gesture-only interactions without an accessible alternative

**Switch Access / Switch Control:**
- [ ] All interactive widgets appear in the scan order
- [ ] No elements are skipped or unreachable
- [ ] Related elements grouped logically (e.g., `MergeSemantics` for list items)
- [ ] No time-limited interactions

**Touch & Motor:**
- [ ] Touch targets >= 48x48 dp (Android) / 44x44 pt (iOS)
- [ ] Interactive controls do not overlap — adequate spacing between adjacent targets
- [ ] Custom gestures have accessible alternatives (no swipe-only/long-press-only actions)

**Display & Visual:**
- [ ] Text color contrast >= 4.5:1 for normal text, >= 3:1 for large text
- [ ] Non-text element contrast (icons, borders, graphical components) >= 3:1 against background
- [ ] Information not conveyed by color alone — text/icon/pattern alternatives provided
- [ ] No fixed-height containers (`SizedBox(height:)`, `Container(height:)`) wrapping Text — use `minHeight` constraints
- [ ] Text scales up to 200% without clipping, truncation, or layout breakage
- [ ] Content works in both portrait and landscape orientations — no orientation lock
- [ ] Content remains consistent across orientations — no information lost when rotated
- [ ] `ExcludeSemantics` only used on purely decorative content — never on meaningful icons, images, or status indicators
- [ ] Respects `MediaQuery.disableAnimations` / `accessibleNavigation`
- [ ] No content flashes more than 3 times per second

**Input & Forms:**
- [ ] Error identification includes suggestion text, not just color
- [ ] Labels or instructions for all user inputs
- [ ] Consistent navigation patterns across screens

#### Optional Checklist — WCAG 2 AAA (only when requested)

- [ ] Enhanced contrast >= 7:1 for normal text, >= 4.5:1 for large text
- [ ] No timing restrictions on interactions
- [ ] Re-authentication without data loss
- [ ] Respects `MediaQuery.highContrast` and `MediaQuery.boldText`

### Phase 4 — Remediation

For each issue found, provide a fix. Group fixes by severity:

| Severity | Description |
|----------|-------------|
| **CRITICAL** | Blocks access entirely (missing semantics on buttons, no focus) |
| **MAJOR** | Significant barrier (poor contrast, small touch targets) |
| **MINOR** | Inconvenience (missing helper text, suboptimal focus order) |

## Project-Specific Guidance

### Available Components

This package provides these widgets — ensure all meet the target WCAG level:

- `UberElevatedButton` — has `semanticLabel` param
- `UberTextButton` — has `semanticLabel` param
- `UberTextInput` — has `semanticLabel` param, needs label association
- `UberAmountInput` — has `semanticLabel` param, needs currency announcement
- `UberRadio` / `UberRadioListTile` — has `semanticLabel` param, needs group semantics

### Theme System

Use `UberColorTokens` from `lib/src/theme/uber_theme.dart` for color references when checking contrast:

```
High contrast pairs (light theme):
  primary900 (#000000) on white (#FFFFFF) → 21:1 ✓
  primary600 (#333333) on white → 12.6:1 ✓
  primary400 (#767676) on white → 4.5:1 ✓ (AA minimum)
  primary300 (#999999) on white → 2.9:1 ✗ (fails AA)

  blue700 (#0653A2) on white → 7.1:1 ✓
  red600 (#EF4444) on white → 3.9:1 ✗ (fails AA for small text)
  green700 (#06D742) on white → 2.3:1 ✗ (fails AA)
```

### Semantic Label Patterns

```dart
// Buttons — describe the action
semanticLabel: 'Submit payment of \$50.00'

// Inputs — describe what to enter
semanticLabel: 'Enter your email address'

// Radio — describe the option and group
semanticLabel: 'Select basic plan, option 1 of 3'

// Amount — include currency context
semanticLabel: 'Enter amount in US dollars'
```

### Touch Target Fix Pattern

```dart
// Minimum 48x48 dp (Android Material) / 44x44 pt (iOS HIG)
// Use 48 to satisfy both platforms:
ConstrainedBox(
  constraints: const BoxConstraints(
    minWidth: 48,
    minHeight: 48,
  ),
  child: /* existing widget */,
)
```

### Screen Reader Patterns — Prefer Built-in

```dart
// PREFERRED — use widget's own semanticLabel, not a Semantics wrapper
UberElevatedButton(
  onPressed: _submit,
  semanticLabel: 'Submit payment',  // Flutter adds "Button" role automatically
  child: Text('Submit'),
)

// PREFERRED — TextField label is the accessible name automatically
UberTextInput(
  label: 'Email address',  // TalkBack/VoiceOver reads "Email address, Text field"
  onChanged: _onChanged,
)

// EDGE CASE — live region for dynamic error (justified use of Semantics)
Semantics(
  liveRegion: true,  // auto-announces when errorMessage changes
  child: Text(errorMessage),
)

// EDGE CASE — merge icon + text into one announcement
MergeSemantics(
  child: Row(
    children: [
      Icon(Icons.error, semanticsLabel: ''),  // exclude icon from reading
      Text('Invalid email address'),
    ],
  ),
)
```

### Focus & Navigation Order

Prefer fixing the **widget order in the tree** so it matches the logical reading order. Only use `OrdinalSortKey` as a last resort when layout constraints prevent reordering.

```dart
// PREFERRED — natural tree order matches reading order (no Semantics needed)
Column(
  children: [
    Text('Form Title'),           // read 1st
    UberTextInput(/* email */),   // read 2nd
    UberTextInput(/* password */),// read 3rd
    UberElevatedButton(/* submit */), // read 4th
  ],
)

// LAST RESORT — only when layout makes natural order impossible
Semantics(
  sortKey: OrdinalSortKey(0),
  child: Text('Form Title'),
),
```

## Audit Report Format

After completing the audit, output a report:

```
## Mobile Accessibility Audit Report
**Level:** AA (required) | **Platform:** Android + iOS | **Services:** All | **Date:** YYYY-MM-DD

### Summary
- CRITICAL: N issues
- MAJOR: N issues
- MINOR: N issues

### Findings

#### [CRITICAL] Missing semantic label on IconButton
**File:** lib/src/widgets/uber_toolbar.dart:L42
**Issue:** Icon-only button has no tooltip or semanticLabel
**Affects:** Screen readers (no announcement), Voice Access (can't activate by name), Switch Access (no label in scan)
**Fix:** Add `tooltip: 'Delete item'` to IconButton
**WCAG:** 1.1.1 Non-text Content (Level A)

#### [MAJOR] GestureDetector not keyboard-accessible
**File:** lib/src/widgets/uber_card.dart:L78
**Issue:** Card uses GestureDetector for tap — not focusable via Tab key, no Enter/Space activation
**Affects:** Keyboard users, Switch Access
**Fix:** Replace with InkWell
**WCAG:** 2.1.1 Keyboard (Level A)

#### [MAJOR] Fixed-height container clips text at large font sizes
**File:** lib/src/widgets/uber_badge.dart:L33
**Issue:** SizedBox(height: 24) clips text when system font size is set to 200%
**Affects:** Users with Display size / Dynamic Type set to large
**Fix:** Use ConstrainedBox(constraints: BoxConstraints(minHeight: 24))
**WCAG:** 1.4.4 Resize Text (Level AA)

...

### Passed Checks
- [✓] Touch targets meet 48dp minimum
- [✓] Focus indicators visible on all interactive elements
- [✓] Tab order matches visual order
- [✓] Voice Access can activate all buttons by label
- [✓] Reduce Motion respected — no animations when disabled
...
```

## Testing Recommendations

After fixes, suggest the user run automated tests and manual screen reader tests.

### Automated Widget Tests

```dart
testWidgets('widget meets mobile accessibility guidelines', (tester) async {
  final handle = tester.ensureSemantics();
  await tester.pumpWidget(MaterialApp(home: Scaffold(body: MyWidget())));

  // Check semantic labels exist (required for TalkBack/VoiceOver)
  expect(find.bySemanticsLabel('Expected label'), findsOneWidget);

  // Check touch target size (48dp for Android, 44pt for iOS)
  final size = tester.getSize(find.byType(MyWidget));
  expect(size.width, greaterThanOrEqualTo(48));
  expect(size.height, greaterThanOrEqualTo(48));

  // Verify semantic roles
  final semantics = tester.getSemantics(find.byType(MyWidget));
  expect(semantics.hasFlag(SemanticsFlag.isButton), isTrue);

  handle.dispose();
});
```

### Manual Testing — All Accessibility Services

Recommend the user verify on real devices across all services:

#### Screen Readers

| Test | Android (TalkBack) | iOS (VoiceOver) |
|------|---------|-----|
| Enable | Settings > Accessibility > TalkBack | Settings > Accessibility > VoiceOver |
| Navigate all elements | Swipe right through entire screen | Swipe right through entire screen |
| Activate buttons | Double-tap | Double-tap |
| Fill text fields | Double-tap to focus, type | Double-tap to focus, type |
| Verify announcements | Each element reads name + role + state | Each element reads name + role + state |
| Check reading order | Swipe order matches visual order | Swipe order matches visual order |

#### Keyboard Navigation

| Test | Android | iOS |
|------|---------|-----|
| Enable | Connect physical keyboard | Connect physical keyboard (or enable Full Keyboard Access) |
| Tab through all elements | Tab moves focus forward through every interactive element | Same |
| Reverse tab | Shift+Tab moves focus backward | Same |
| Activate buttons | Enter or Space triggers onPressed | Same |
| Navigate radios | Arrow keys move within radio group | Same |
| Dismiss overlays | Escape closes dialogs/bottom sheets | Same |
| Focus visible | Every focused element has a visible ring/highlight | Same |
| No traps | Can always Tab away from any element | Same |

#### Voice Control

| Test | Android (Voice Access) | iOS (Voice Control) |
|------|---------|-----|
| Enable | Settings > Accessibility > Voice Access | Settings > Accessibility > Voice Control |
| Activate by label | Say "Tap Submit" — correct button activates | Same |
| Show numbers | Say "Show numbers" — all interactive elements get a number | Same |
| Icon buttons | Say "Tap [tooltip]" — icon button activates | Same |
| Text input | Say "Tap Email" then "Type hello" | Same |
| Unique labels | No ambiguity when two elements share the same label | Same |

#### Switch Access

| Test | Android (Switch Access) | iOS (Switch Control) |
|------|---------|-----|
| Enable | Settings > Accessibility > Switch Access | Settings > Accessibility > Switch Control |
| Scan all elements | Every interactive element is reachable via scanning | Same |
| Activate element | Switch press selects highlighted element | Same |
| No skipped elements | Nothing is unreachable | Same |
| No time pressure | Interactions don't time out during scanning | Same |

#### Display Accommodations

| Test | Android | iOS |
|------|---------|-----|
| Large text | Settings > Display > Font size → max | Settings > Display > Text Size → max (or Dynamic Type) |
| Verify no clipping | All text visible, no overflow, layout intact | Same |
| Bold text | Settings > Accessibility > Bold text | Settings > Display > Bold Text |
| Reduce motion | Settings > Accessibility > Remove animations | Settings > Accessibility > Reduce Motion |
| Verify no animations | Transitions are instant, no auto-playing motion | Same |
| High contrast | Settings > Accessibility > High contrast text | Settings > Accessibility > Increase Contrast |
| Color correction | Settings > Accessibility > Color correction | Settings > Accessibility > Color Filters |
| Verify without color | Information still understandable without color | Same |
