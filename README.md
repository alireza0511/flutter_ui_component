# Flutter UI Component

A comprehensive Flutter package providing reusable UI components inspired by the Uber Base Design System. Built with Material 3 foundation and designed for both light and dark themes.

## Features

✨ **Five Core Components:**
- **UberTextButton** - Lightweight buttons for secondary actions
- **UberElevatedButton** - Primary action buttons with elevation
- **UberAmountInput** - Specialized input field for currency amounts
- **UberTextInput** - Versatile text input fields for various data types
- **UberRadio** - Single selection radio buttons with list tile support

🎨 **Design System:**
- Uber Base Design System inspired color tokens
- Material 3 foundation with proper elevation and shadows
- Comprehensive typography scale
- Light and dark theme support
- High contrast mode compatibility

🧪 **Testing:**
- Comprehensive unit tests for all components
- Accessibility tests with proper semantics
- Golden tests for visual regression testing
- Support for screen readers and keyboard navigation

♿ **Accessibility:**
- WCAG compliant contrast ratios
- Proper semantic labels and roles
- Keyboard navigation support
- Screen reader optimized
- Focus management

## Installation

Add this package to your `pubspec.yaml`:

```yaml
dependencies:
  flutter_ui_component: ^1.0.0
```

Run:
```bash
flutter pub get
```

## Usage

### Basic Setup

Import the package and apply the theme:

```dart
import 'package:flutter/material.dart';
import 'package:flutter_ui_component/flutter_ui_component.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'My App',
      theme: UberTheme.lightTheme,
      darkTheme: UberTheme.darkTheme,
      home: MyHomePage(),
    );
  }
}
```

### Components

#### UberTextButton

```dart
UberTextButton(
  onPressed: () => print('Button pressed'),
  variant: UberTextButtonVariant.primary,
  size: UberTextButtonSize.medium,
  child: Text('Click me'),
)
```

**Properties:**
- `onPressed`: Callback function
- `variant`: `primary`, `secondary`, `destructive`
- `size`: `small`, `medium`, `large`
- `isLoading`: Shows loading indicator
- `enabled`: Enable/disable button
- `fullWidth`: Expand to full width
- `semanticLabel`: Accessibility label

#### UberElevatedButton

```dart
UberElevatedButton(
  onPressed: () => print('Button pressed'),
  variant: UberElevatedButtonVariant.primary,
  size: UberElevatedButtonSize.medium,
  child: Text('Elevated Action'),
)
```

**Properties:**
- Same as UberTextButton
- Includes elevation and shadow effects

#### UberAmountInput

```dart
UberAmountInput(
  onChanged: (value) => print('Amount: \$value'),
  label: 'Enter Amount',
  currency: '\$',
  minAmount: 5.0,
  maxAmount: 1000.0,
  maxDecimalPlaces: 2,
)
```

**Properties:**
- `onChanged`: Callback with parsed amount
- `currency`: Currency symbol (default: '\$')
- `minAmount`/`maxAmount`: Validation limits
- `maxDecimalPlaces`: Decimal precision
- `label`, `hintText`, `helperText`, `errorText`
- `enabled`: Enable/disable input

#### UberTextInput

```dart
UberTextInput(
  onChanged: (value) => print('Text: \$value'),
  label: 'Enter Text',
  type: UberTextInputType.text,
  validator: (value) => value?.isEmpty == true ? 'Required' : null,
)
```

**Input Types:**
- `text`: Standard text input
- `email`: Email input with validation
- `password`: Password input with visibility toggle
- `multiline`: Multi-line text area

**Properties:**
- `onChanged`: Callback with current text
- `type`: Input type
- `validator`: Custom validation function
- `maxLength`: Character limit
- `prefixIcon`/`suffixIcon`: Icons
- `textCapitalization`: Text formatting

#### UberRadio

```dart
UberRadio<String>(
  value: 'option1',
  groupValue: selectedValue,
  onChanged: (value) => setState(() => selectedValue = value),
)

// Or use UberRadioListTile for better UX
UberRadioListTile<String>(
  value: 'option1',
  groupValue: selectedValue,
  onChanged: (value) => setState(() => selectedValue = value),
  title: Text('Option 1'),
  subtitle: Text('Description of option 1'),
)
```

**Properties:**
- `value`: This option's value
- `groupValue`: Currently selected value
- `onChanged`: Selection callback
- `enabled`: Enable/disable option
- For list tiles: `title`, `subtitle`, `contentPadding`

## Theming

The package includes comprehensive theming support:

```dart
// Use predefined themes
MaterialApp(
  theme: UberTheme.lightTheme,
  darkTheme: UberTheme.darkTheme,
  themeMode: ThemeMode.system,
)

// Access color tokens
Container(
  color: UberColorTokens.primary900,
  child: Text(
    'Custom text',
    style: UberTypography.bodyLarge,
  ),
)
```

### Color Tokens

The package provides extensive color tokens:
- **Primary**: `primary50` to `primary900`
- **Semantic Colors**: `green`, `blue`, `red`, `yellow` variants
- **System Colors**: `white`, `background`, `surface`, `outline`

### Typography

Consistent typography scale following Material 3:
- **Display**: `displayLarge`, `displayMedium`, `displaySmall`
- **Headline**: `headlineLarge`, `headlineMedium`, `headlineSmall`
- **Title**: `titleLarge`, `titleMedium`, `titleSmall`
- **Body**: `bodyLarge`, `bodyMedium`, `bodySmall`
- **Label**: `labelLarge`, `labelMedium`, `labelSmall`

## Example

Run the example app to see all components in action:

```bash
cd example
flutter run
```

The example app demonstrates:
- All component variants and states
- Light/dark theme switching
- Interactive component behavior
- Accessibility features
- Responsive layout

## Testing

The package includes comprehensive tests:

```bash
# Run all tests
flutter test

# Run specific test suites
flutter test test/unit/
flutter test test/accessibility/
flutter test test/golden/
```

### Test Coverage
- **Unit Tests**: Component behavior and state management
- **Accessibility Tests**: WCAG compliance and semantics
- **Golden Tests**: Visual regression testing
- **Integration Tests**: Component interaction

## Contributing

1. Fork the repository
2. Create a feature branch
3. Add tests for new functionality
4. Ensure all tests pass
5. Update documentation
6. Submit a pull request

## Accessibility

This package prioritizes accessibility:

- ✅ WCAG 2.1 AA compliant
- ✅ Screen reader support
- ✅ Keyboard navigation
- ✅ High contrast mode
- ✅ Proper focus management
- ✅ Semantic labels and roles

## Browser Support

Optimized for web deployment:
- ✅ Chrome, Firefox, Safari, Edge
- ✅ Mobile browsers
- ✅ Responsive design
- ✅ Touch and mouse interaction

## Requirements

- Flutter >=3.27.0
- Dart >=3.5.0
- Material 3 support

## License

MIT License - see LICENSE file for details.

## Changelog

### 1.0.0
- Initial release
- Five core UI components
- Comprehensive theming system
- Full test coverage
- Accessibility compliance
- Example application
