---
name: testing
description: Generate complete test suites for UI components — functionality, golden, accessibility, and interaction tests
allowed-tools: Read, Edit, Write, Glob, Grep, Bash, Agent
argument-hint: "[widget name] — e.g. 'UberCheckbox', 'UberCard', 'account_card'"
---

# UI Component Testing

You are a testing expert for the `flutter_ui_component` package. When invoked, generate a **complete test suite** for a widget. Every UI component must have all four test categories before it is considered tested.

## Required Test Categories

| Category | Purpose | Location |
|----------|---------|----------|
| **Functionality** | Rendering, props, callbacks, state changes | `test/unit/<widget>_test.dart` |
| **Golden** | Visual regression — screenshot comparison | `test/golden/golden_test.dart` |
| **Accessibility** | TalkBack/VoiceOver, tap targets, contrast | `test/accessibility/accessibility_test.dart` |
| **Interaction** | Tap, hover, press, focus, disable, loading | Included in functionality tests |

## Test Directory Structure

```
test/
├── unit/
│   ├── uber_<widget>_test.dart          ← functionality + interaction
│   └── account_list/
│       ├── test_helpers.dart            ← shared test utilities
│       ├── models/                      ← data model tests
│       ├── presenters/                  ← presenter/dialog tests
│       └── widgets/                     ← widget-specific tests
├── golden/
│   ├── golden_test.dart                 ← all golden tests in one file
│   └── goldens/                         ← generated screenshot PNGs
├── accessibility/
│   └── accessibility_test.dart          ← all a11y tests in one file
└── flutter_ui_component_test.dart       ← package-level smoke test
```

## Setup Pattern

Always wrap widgets with `MaterialApp` + `UberTheme` + `Scaffold`:

```dart
await tester.pumpWidget(
  MaterialApp(
    theme: UberTheme.lightTheme,
    home: Scaffold(body: UberNewWidget(/* ... */)),
  ),
);
```

**Always test with `UberTheme.lightTheme`.** Add dark theme golden tests separately.

---

## 1. Functionality Tests

File: `test/unit/uber_<widget>_test.dart`

Test rendering with default props, all size variants, all style variants, callback invocation, disabled state, loading state, and fullWidth (if applicable).

For full test patterns, read `skills/testing/reference.md` § Functionality Tests.

### Checklist — Functionality

- [ ] Renders with default props
- [ ] All size variants render
- [ ] All style variants render
- [ ] Callback fires on tap
- [ ] Disabled state blocks interaction
- [ ] Loading state shows indicator and blocks interaction
- [ ] fullWidth stretches correctly (if applicable)
- [ ] Custom child widget renders

---

## 2. Golden Tests

File: `test/golden/golden_test.dart` (append to existing file)

Golden tests use `golden_toolkit` with `DeviceBuilder` for device-specific screenshot comparison. Create builder helpers (`_buildNewWidgetVariants()`, `_buildNewWidgetStates()`, `_buildNewWidgetDarkTheme()`) that return a fully wrapped `MaterialApp` widget tree.

For full DeviceBuilder patterns and builder helpers, read `skills/testing/reference.md` § Golden Tests.

### Running & Updating Goldens

```bash
flutter test test/golden/                 # compare against existing
flutter test --update-goldens test/golden/ # regenerate after intentional changes
```

### Checklist — Golden

- [ ] All variants captured (primary, secondary, destructive)
- [ ] All sizes captured (small, medium, large)
- [ ] All states captured (default, disabled, loading)
- [ ] Light theme screenshot
- [ ] Dark theme screenshot
- [ ] Golden PNGs stored in `test/golden/goldens/`

---

## 3. Accessibility Tests

File: `test/accessibility/accessibility_test.dart` (append to existing file)

Use Flutter's built-in accessibility guidelines (`androidTapTargetGuideline`, `iOSTapTargetGuideline`, `labeledTapTargetGuideline`, `textContrastGuideline`). These test what TalkBack and VoiceOver will actually see. Do NOT add redundant `Semantics` wrappers — fix the widget instead.

For full test patterns and the built-in guidelines reference table, read `skills/testing/reference.md` § Accessibility Tests.

### Checklist — Accessibility

- [ ] Passes `androidTapTargetGuideline` (48x48 dp)
- [ ] Passes `iOSTapTargetGuideline` (44x44 pt)
- [ ] Passes `labeledTapTargetGuideline`
- [ ] Passes `textContrastGuideline`
- [ ] `semanticLabel` is announced correctly
- [ ] Tap action exposed to screen readers
- [ ] Disabled state announced (TalkBack: "Disabled", VoiceOver: "Dimmed")
- [ ] Works without explicit `semanticLabel` (falls back to child text)

---

## 4. Interaction Tests

Included in the functionality test file. Cover user interaction states: tap down/up visual feedback, disabled gesture blocking, loading gesture blocking.

For full test patterns, read `skills/testing/reference.md` § Interaction Tests.

### Checklist — Interaction

- [ ] Tap triggers callback
- [ ] Tap down shows pressed visual state
- [ ] Tap up/cancel resets visual state
- [ ] Disabled widget ignores all gestures
- [ ] Loading widget ignores all gestures

---

## Complete Checklist — All Four Categories

Before a widget is considered fully tested:

### Functionality
- [ ] Default rendering
- [ ] All size variants
- [ ] All style variants
- [ ] Callback invocation
- [ ] Disabled state
- [ ] Loading state
- [ ] fullWidth (if applicable)

### Golden
- [ ] Variants screenshot (light)
- [ ] Sizes screenshot (light)
- [ ] States screenshot (light)
- [ ] Dark theme screenshot
- [ ] Goldens updated: `flutter test --update-goldens test/golden/`

### Accessibility
- [ ] `androidTapTargetGuideline`
- [ ] `iOSTapTargetGuideline`
- [ ] `labeledTapTargetGuideline`
- [ ] `textContrastGuideline`
- [ ] Semantic label announced
- [ ] Semantic actions exposed
- [ ] Disabled state announced
- [ ] Falls back gracefully without explicit `semanticLabel`

### Interaction
- [ ] Tap down/up visual feedback
- [ ] Disabled ignores gestures
- [ ] Loading ignores gestures

### Run All

```bash
flutter test                              # all tests
flutter test test/unit/                   # functionality only
flutter test test/golden/                 # golden only
flutter test test/accessibility/          # a11y only
flutter test --update-goldens test/golden/ # regenerate goldens
```
