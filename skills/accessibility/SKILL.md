---
name: accessibility
description: Audit and fix mobile Flutter widget accessibility (WCAG 2 AA required, AAA optional) for Android TalkBack and iOS VoiceOver
allowed-tools: Read, Edit, Write, Glob, Grep, Bash, Agent
argument-hint: "[platform] [level] — e.g. 'android', 'ios', 'android AAA'"
---

# Mobile Accessibility Audit & Remediation

You are a mobile accessibility expert for the `flutter_ui_component` package. This skill targets **Android** and **iOS** only. When invoked, guide the user through an accessibility audit and fix issues in the codebase.

## Target Compliance

- **WCAG 2 AA is the required baseline.** All widgets MUST pass Level A + AA.
- **WCAG 2 AAA is optional.** Only audit for AAA if the user explicitly requests it.

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

1. **Use Flutter's Built-in Semantics First** — Rely on widget-native accessibility. Only add custom `Semantics` for edge cases listed above. This ensures future Flutter updates automatically improve OS compatibility.
2. **Semantic Labels** — Use the widget's own `semanticLabel` parameter. Screen readers (TalkBack / VoiceOver) depend on this.
3. **Touch Targets** — Minimum 48x48 dp for all tappable elements (Material guideline). iOS Human Interface Guidelines recommend 44x44 pt.
4. **Screen Reader Announcements** — Widgets must announce role, name, and state changes. Prefer Flutter's built-in announcements over manual `Semantics` properties.
5. **Color Independence** — Information must not be conveyed by color alone.
6. **Animation Safety** — Respect `MediaQuery.disableAnimations` and `AccessibilityFeatures.reduceMotion`.
7. **Contrast Ratios** — Normal text: >= 4.5:1. Large text (18sp+ or 14sp bold): >= 3:1.

## Mobile Screen Reader Reference

| Feature | Android (TalkBack) | iOS (VoiceOver) |
|---------|-------------------|-----------------|
| Activation | Double-tap | Double-tap |
| Navigation | Swipe right/left | Swipe right/left |
| Scroll | Two-finger swipe | Three-finger swipe |
| Back/Escape | Two-finger swipe down-then-left | Two-finger scrub (Z gesture) |
| Read all | Three-finger swipe up | Two-finger swipe down |
| Focus ring | Green rectangle | Black rounded rectangle |

### Flutter Semantics → Screen Reader Mapping

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

## Workflow

### Phase 1 — Platform Selection

Ask which mobile platform(s) to audit:
- **Android** — TalkBack, Switch Access
- **iOS** — VoiceOver, Switch Control
- **Both** (default)

### Phase 2 — Conformance Level

Default to **AA** (required). Only include AAA checks if the user explicitly asks.

### Phase 3 — Audit

Scan the codebase for issues. Check each widget file in `lib/src/widgets/` and report findings.

#### Required Checklist — WCAG 2 AA

**Level A criteria:**
- [ ] All images/icons have text alternatives (via widget's own `semanticLabel` param)
- [ ] Interactive elements have accessible names announced by TalkBack/VoiceOver
- [ ] Touch targets >= 48x48 dp (Android) / 44x44 pt (iOS)
- [ ] Content has logical reading order for swipe navigation
- [ ] No content flashes more than 3 times per second
- [ ] Widgets announce correct role via their built-in behavior (not redundant `Semantics` wrappers)
- [ ] State changes announced via widget-native semantics (`enabled`, `selected`, `checked`)
- [ ] Custom gestures have accessible alternatives
- [ ] No unnecessary `Semantics` wrappers on widgets that already handle accessibility (flag as anti-pattern)

**Level AA criteria (on top of A):**
- [ ] Color contrast >= 4.5:1 for normal text, >= 3:1 for large text
- [ ] Text resizes up to 200% without loss of content or overflow
- [ ] Error identification includes suggestion text, not just color
- [ ] Labels or instructions for all user inputs
- [ ] Consistent navigation patterns across screens
- [ ] Focus is not trapped — user can navigate away from any element

#### Optional Checklist — WCAG 2 AAA (only when requested)

- [ ] Enhanced contrast >= 7:1 for normal text, >= 4.5:1 for large text
- [ ] No timing restrictions on interactions
- [ ] Re-authentication without data loss

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
**Level:** AA (required) | **Platform:** Android + iOS | **Date:** YYYY-MM-DD

### Summary
- CRITICAL: N issues
- MAJOR: N issues
- MINOR: N issues

### Findings

#### [CRITICAL] Missing semantic label on UberElevatedButton
**File:** lib/src/widgets/uber_elevated_button.dart:L42
**Issue:** Button has no default semantic fallback when semanticLabel is null
**Fix:** Add fallback to child text content via Semantics widget
**WCAG:** 1.1.1 Non-text Content (Level A)

...

### Passed Checks
- [✓] Touch targets meet 48dp minimum
- [✓] Focus indicators visible
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

### Manual Screen Reader Testing

Recommend the user verify on real devices:

| Test | Android | iOS |
|------|---------|-----|
| Enable screen reader | Settings > Accessibility > TalkBack | Settings > Accessibility > VoiceOver |
| Navigate all elements | Swipe right through entire screen | Swipe right through entire screen |
| Activate buttons | Double-tap | Double-tap |
| Fill text fields | Double-tap to focus, type | Double-tap to focus, type |
| Verify announcements | Check each element reads name + role + state | Check each element reads name + role + state |
| Check focus order | Swipe order matches visual order | Swipe order matches visual order |
