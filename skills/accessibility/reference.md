# Accessibility — Reference

Detailed reference material for the accessibility skill. See `SKILL.md` for core rules and workflow.

## Built-in Semantics — When to Use Custom Semantics

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

## Anti-patterns

Flag these during audit — wrapping built-in widgets with redundant `Semantics`:

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

#### Flutter Semantics to Screen Reader Mapping

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
// WRONG
SizedBox(height: 48, child: Text('Clipped at 200% font size'))

// CORRECT
ConstrainedBox(
  constraints: const BoxConstraints(minHeight: 48),
  child: Text('Label grows with font size'),
)

// Reduce motion
final reduceMotion = MediaQuery.of(context).disableAnimations;
final duration = reduceMotion ? Duration.zero : const Duration(milliseconds: 150);

// High contrast
final highContrast = MediaQuery.of(context).highContrast;

// Bold text
final boldText = MediaQuery.of(context).boldText;
```

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
  constraints: const BoxConstraints(minWidth: 48, minHeight: 48),
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

## Optional Checklist — WCAG 2 AAA

Only when explicitly requested:

- [ ] Enhanced contrast >= 7:1 for normal text, >= 4.5:1 for large text
- [ ] No timing restrictions on interactions
- [ ] Re-authentication without data loss
- [ ] Respects `MediaQuery.highContrast` and `MediaQuery.boldText`
