---
name: testing
description: Generate complete test suites for UI components — functionality, golden, accessibility, and interaction tests
allowed-tools: Read, Edit, Write, Glob, Grep, Bash, Agent
argument-hint: "[widget name] — e.g. 'UberCheckbox', 'UberCard', 'account_card'"
---

# UI Component Testing

You are a testing expert for the `flutter_ui_component` package. When invoked, generate a **complete test suite** for a widget. Every UI component must have all four test categories before it is considered tested.

## Required Test Categories

Every widget test suite MUST include these four categories:

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
// Inline setup
await tester.pumpWidget(
  MaterialApp(
    theme: UberTheme.lightTheme,
    home: Scaffold(
      body: UberNewWidget(/* ... */),
    ),
  ),
);

// Or use the helper from test_helpers.dart for account_list widgets
await tester.pumpWidget(wrapInApp(
  UberNewWidget(/* ... */),
));
```

**Always test with `UberTheme.lightTheme`.** Add dark theme golden tests separately.

---

## 1. Functionality Tests

File: `test/unit/uber_<widget>_test.dart`

Every widget must test these scenarios:

### Rendering & Props

```dart
group('UberNewWidget', () {
  testWidgets('renders with default properties', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        theme: UberTheme.lightTheme,
        home: Scaffold(
          body: UberNewWidget(
            onPressed: () {},
            child: const Text('Label'),
          ),
        ),
      ),
    );

    expect(find.text('Label'), findsOneWidget);
    expect(find.byType(UberNewWidget), findsOneWidget);
  });
```

### Size Variants

```dart
  testWidgets('renders all size variants', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        theme: UberTheme.lightTheme,
        home: Scaffold(
          body: Column(
            children: [
              UberNewWidget(
                onPressed: () {},
                size: UberNewWidgetSize.small,
                child: const Text('Small'),
              ),
              UberNewWidget(
                onPressed: () {},
                size: UberNewWidgetSize.medium,
                child: const Text('Medium'),
              ),
              UberNewWidget(
                onPressed: () {},
                size: UberNewWidgetSize.large,
                child: const Text('Large'),
              ),
            ],
          ),
        ),
      ),
    );

    expect(find.text('Small'), findsOneWidget);
    expect(find.text('Medium'), findsOneWidget);
    expect(find.text('Large'), findsOneWidget);
  });
```

### Style Variants

```dart
  testWidgets('renders all style variants', (tester) async {
    // Test primary, secondary, destructive
    // Verify each renders without error
  });
```

### Callback Invocation

```dart
  testWidgets('calls onPressed when tapped', (tester) async {
    bool wasPressed = false;

    await tester.pumpWidget(
      MaterialApp(
        theme: UberTheme.lightTheme,
        home: Scaffold(
          body: UberNewWidget(
            onPressed: () => wasPressed = true,
            child: const Text('Tap Me'),
          ),
        ),
      ),
    );

    await tester.tap(find.byType(UberNewWidget));
    expect(wasPressed, isTrue);
  });
```

### Disabled State

```dart
  testWidgets('does not call onPressed when disabled', (tester) async {
    bool wasPressed = false;

    await tester.pumpWidget(
      MaterialApp(
        theme: UberTheme.lightTheme,
        home: Scaffold(
          body: UberNewWidget(
            onPressed: () => wasPressed = true,
            enabled: false,
            child: const Text('Disabled'),
          ),
        ),
      ),
    );

    await tester.tap(find.byType(UberNewWidget));
    expect(wasPressed, isFalse);
  });
```

### Loading State

```dart
  testWidgets('shows loading indicator when isLoading is true', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        theme: UberTheme.lightTheme,
        home: Scaffold(
          body: UberNewWidget(
            onPressed: () {},
            isLoading: true,
            child: const Text('Loading'),
          ),
        ),
      ),
    );

    expect(find.byType(CircularProgressIndicator), findsOneWidget);
    expect(find.text('Loading'), findsOneWidget);
  });

  testWidgets('does not call onPressed when loading', (tester) async {
    bool wasPressed = false;

    await tester.pumpWidget(
      MaterialApp(
        theme: UberTheme.lightTheme,
        home: Scaffold(
          body: UberNewWidget(
            onPressed: () => wasPressed = true,
            isLoading: true,
            child: const Text('Loading'),
          ),
        ),
      ),
    );

    await tester.tap(find.byType(UberNewWidget));
    expect(wasPressed, isFalse);
  });
```

### fullWidth (if applicable)

```dart
  testWidgets('respects fullWidth property', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        theme: UberTheme.lightTheme,
        home: Scaffold(
          body: SizedBox(
            width: 300,
            child: UberNewWidget(
              onPressed: () {},
              fullWidth: true,
              child: const Text('Full Width'),
            ),
          ),
        ),
      ),
    );

    final sizedBox = tester.widget<SizedBox>(find.ancestor(
      of: find.byType(UberNewWidget),
      matching: find.byType(SizedBox),
    ).first);

    expect(sizedBox.width, equals(double.infinity));
  });
});
```

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

Golden tests use `golden_toolkit` for device-specific screenshot comparison.

### Pattern

```dart
group('UberNewWidget', () {
  testGoldens('new widget variants', (tester) async {
    final builder = DeviceBuilder()
      ..overrideDevicesForAllScenarios(devices: [Device.phone])
      ..addScenario(
        widget: _buildNewWidgetVariants(),
        name: 'new_widget_variants',
      );

    await tester.pumpDeviceBuilder(builder);
    await screenMatchesGolden(tester, 'new_widget_variants');
  });

  testGoldens('new widget sizes', (tester) async {
    final builder = DeviceBuilder()
      ..overrideDevicesForAllScenarios(devices: [Device.phone])
      ..addScenario(
        widget: _buildNewWidgetSizes(),
        name: 'new_widget_sizes',
      );

    await tester.pumpDeviceBuilder(builder);
    await screenMatchesGolden(tester, 'new_widget_sizes');
  });

  testGoldens('new widget states', (tester) async {
    final builder = DeviceBuilder()
      ..overrideDevicesForAllScenarios(devices: [Device.phone])
      ..addScenario(
        widget: _buildNewWidgetStates(),
        name: 'new_widget_states',
      );

    await tester.pumpDeviceBuilder(builder);
    await screenMatchesGolden(tester, 'new_widget_states');
  });

  testGoldens('new widget dark theme', (tester) async {
    final builder = DeviceBuilder()
      ..overrideDevicesForAllScenarios(devices: [Device.phone])
      ..addScenario(
        widget: _buildNewWidgetDarkTheme(),
        name: 'new_widget_dark',
      );

    await tester.pumpDeviceBuilder(builder);
    await screenMatchesGolden(tester, 'new_widget_dark');
  });
});
```

### Builder Helpers

```dart
Widget _buildNewWidgetVariants() {
  return MaterialApp(
    theme: UberTheme.lightTheme,
    home: Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Variants',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            UberNewWidget(
              onPressed: () {},
              variant: UberNewWidgetVariant.primary,
              child: const Text('Primary'),
            ),
            const SizedBox(height: 8),
            UberNewWidget(
              onPressed: () {},
              variant: UberNewWidgetVariant.secondary,
              child: const Text('Secondary'),
            ),
            const SizedBox(height: 8),
            UberNewWidget(
              onPressed: () {},
              variant: UberNewWidgetVariant.destructive,
              child: const Text('Destructive'),
            ),
          ],
        ),
      ),
    ),
  );
}

Widget _buildNewWidgetStates() {
  return MaterialApp(
    theme: UberTheme.lightTheme,
    home: Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('States',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            UberNewWidget(
              onPressed: () {},
              child: const Text('Default'),
            ),
            const SizedBox(height: 8),
            UberNewWidget(
              onPressed: () {},
              enabled: false,
              child: const Text('Disabled'),
            ),
            const SizedBox(height: 8),
            UberNewWidget(
              onPressed: () {},
              isLoading: true,
              child: const Text('Loading'),
            ),
          ],
        ),
      ),
    ),
  );
}

Widget _buildNewWidgetDarkTheme() {
  return MaterialApp(
    theme: UberTheme.darkTheme,  // Dark theme
    home: Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            UberNewWidget(
              onPressed: () {},
              child: const Text('Dark Default'),
            ),
            const SizedBox(height: 8),
            UberNewWidget(
              onPressed: () {},
              enabled: false,
              child: const Text('Dark Disabled'),
            ),
          ],
        ),
      ),
    ),
  );
}
```

### Running & Updating Goldens

```bash
# Run golden tests (compare against existing screenshots)
flutter test test/golden/

# Update golden files after intentional visual changes
flutter test --update-goldens test/golden/
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

Use Flutter's built-in accessibility guidelines. These test what TalkBack and VoiceOver will actually experience.

### Pattern

```dart
group('UberNewWidget accessibility', () {
  testWidgets('meets tap target guidelines', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        theme: UberTheme.lightTheme,
        home: Scaffold(
          body: UberNewWidget(
            onPressed: () {},
            semanticLabel: 'New widget action',
            child: const Text('Label'),
          ),
        ),
      ),
    );

    // Android: 48x48 dp minimum
    await expectLater(tester, meetsGuideline(androidTapTargetGuideline));
    // iOS: 44x44 pt minimum
    await expectLater(tester, meetsGuideline(iOSTapTargetGuideline));
    // All interactive elements have labels
    await expectLater(tester, meetsGuideline(labeledTapTargetGuideline));
    // Text contrast meets WCAG 2 AA
    await expectLater(tester, meetsGuideline(textContrastGuideline));
  });

  testWidgets('has correct semantic label', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        theme: UberTheme.lightTheme,
        home: Scaffold(
          body: UberNewWidget(
            onPressed: () {},
            semanticLabel: 'Submit form',
            child: const Text('Submit'),
          ),
        ),
      ),
    );

    expect(find.bySemanticsLabel('Submit form'), findsOneWidget);
  });

  testWidgets('has correct semantic actions', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        theme: UberTheme.lightTheme,
        home: Scaffold(
          body: UberNewWidget(
            onPressed: () {},
            semanticLabel: 'Action button',
            child: const Text('Action'),
          ),
        ),
      ),
    );

    final semantics = tester.getSemantics(
      find.bySemanticsLabel('Action button'),
    );
    // Verify the widget exposes a tap action to screen readers
    expect(
      semantics.getSemanticsData().hasAction(SemanticsAction.tap),
      isTrue,
    );
  });

  testWidgets('disabled state is announced to screen readers', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        theme: UberTheme.lightTheme,
        home: Scaffold(
          body: UberNewWidget(
            onPressed: () {},
            enabled: false,
            semanticLabel: 'Disabled widget',
            child: const Text('Disabled'),
          ),
        ),
      ),
    );

    final semantics = tester.getSemantics(
      find.bySemanticsLabel('Disabled widget'),
    );
    // TalkBack announces "Disabled", VoiceOver announces "Dimmed"
    expect(
      semantics.getSemanticsData().hasFlag(SemanticsFlag.isEnabled),
      isFalse,
    );
  });

  testWidgets('works without semanticLabel (uses child text)', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        theme: UberTheme.lightTheme,
        home: Scaffold(
          body: UberNewWidget(
            onPressed: () {},
            child: const Text('Fallback Label'),
          ),
        ),
      ),
    );

    // Widget should still be accessible via its child text
    // This verifies Flutter's built-in semantics work without a custom wrapper
    await expectLater(tester, meetsGuideline(labeledTapTargetGuideline));
  });
});
```

### Built-in Guidelines Reference

| Guideline | What it checks |
|-----------|---------------|
| `androidTapTargetGuideline` | Touch targets >= 48x48 dp |
| `iOSTapTargetGuideline` | Touch targets >= 44x44 pt |
| `labeledTapTargetGuideline` | All tappable elements have semantic labels |
| `textContrastGuideline` | Text contrast meets WCAG 2 AA (4.5:1) |

**Important:** These guidelines use Flutter's semantics tree directly — they test what the OS accessibility services (TalkBack/VoiceOver) will actually see. Do NOT add redundant `Semantics` wrappers to make tests pass. If a test fails, fix the widget's built-in accessibility, not the test setup.

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

Included in the functionality test file. Cover user interaction states beyond basic tap.

### Pattern

```dart
group('UberNewWidget interactions', () {
  testWidgets('visual feedback on tap down/up', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        theme: UberTheme.lightTheme,
        home: Scaffold(
          body: UberNewWidget(
            onPressed: () {},
            child: const Text('Press Me'),
          ),
        ),
      ),
    );

    // Simulate press down
    final gesture = await tester.startGesture(
      tester.getCenter(find.byType(UberNewWidget)),
    );
    await tester.pump();

    // Widget should show pressed state (verify via AnimatedContainer, opacity, etc.)
    // ...

    // Release
    await gesture.up();
    await tester.pumpAndSettle();
  });

  testWidgets('no visual feedback when disabled', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        theme: UberTheme.lightTheme,
        home: Scaffold(
          body: UberNewWidget(
            onPressed: () {},
            enabled: false,
            child: const Text('Disabled'),
          ),
        ),
      ),
    );

    final gesture = await tester.startGesture(
      tester.getCenter(find.byType(UberNewWidget)),
    );
    await tester.pump();
    await gesture.up();
    await tester.pumpAndSettle();

    // Verify no state change occurred
  });
});
```

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
