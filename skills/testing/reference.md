# Testing — Reference

## Functionality Tests

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

### fullWidth

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

---

## Golden Tests

### DeviceBuilder Pattern

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

### Golden Builder Helpers

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

---

## Accessibility Tests

### Full Test Pattern

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

---

## Interaction Tests

### Full Test Pattern

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
