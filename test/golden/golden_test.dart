import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:golden_toolkit/golden_toolkit.dart';
import 'package:flutter_ui_component/flutter_ui_component.dart';

void main() {
  group('Golden Tests', () {
    group('UberTextButton', () {
      testGoldens('text button states', (tester) async {
        final builder = DeviceBuilder()
          ..overrideDevicesForAllScenarios(devices: [Device.phone])
          ..addScenario(
            widget: _buildTextButtonStates(),
            name: 'text_button_states',
          );

        await tester.pumpDeviceBuilder(builder);
        await screenMatchesGolden(tester, 'text_button_states');
      });

      testGoldens('text button variants', (tester) async {
        final builder = DeviceBuilder()
          ..overrideDevicesForAllScenarios(devices: [Device.phone])
          ..addScenario(
            widget: _buildTextButtonVariants(),
            name: 'text_button_variants',
          );

        await tester.pumpDeviceBuilder(builder);
        await screenMatchesGolden(tester, 'text_button_variants');
      });

      testGoldens('text button sizes', (tester) async {
        final builder = DeviceBuilder()
          ..overrideDevicesForAllScenarios(devices: [Device.phone])
          ..addScenario(
            widget: _buildTextButtonSizes(),
            name: 'text_button_sizes',
          );

        await tester.pumpDeviceBuilder(builder);
        await screenMatchesGolden(tester, 'text_button_sizes');
      });
    });

    group('UberElevatedButton', () {
      testGoldens('elevated button states', (tester) async {
        final builder = DeviceBuilder()
          ..overrideDevicesForAllScenarios(devices: [Device.phone])
          ..addScenario(
            widget: _buildElevatedButtonStates(),
            name: 'elevated_button_states',
          );

        await tester.pumpDeviceBuilder(builder);
        await screenMatchesGolden(tester, 'elevated_button_states');
      });

      testGoldens('elevated button variants', (tester) async {
        final builder = DeviceBuilder()
          ..overrideDevicesForAllScenarios(devices: [Device.phone])
          ..addScenario(
            widget: _buildElevatedButtonVariants(),
            name: 'elevated_button_variants',
          );

        await tester.pumpDeviceBuilder(builder);
        await screenMatchesGolden(tester, 'elevated_button_variants');
      });

      testGoldens('elevated button sizes', (tester) async {
        final builder = DeviceBuilder()
          ..overrideDevicesForAllScenarios(devices: [Device.phone])
          ..addScenario(
            widget: _buildElevatedButtonSizes(),
            name: 'elevated_button_sizes',
          );

        await tester.pumpDeviceBuilder(builder);
        await screenMatchesGolden(tester, 'elevated_button_sizes');
      });
    });

    group('UberAmountInput', () {
      testGoldens('amount input states', (tester) async {
        final builder = DeviceBuilder()
          ..overrideDevicesForAllScenarios(devices: [Device.phone])
          ..addScenario(
            widget: _buildAmountInputStates(),
            name: 'amount_input_states',
          );

        await tester.pumpDeviceBuilder(builder);
        await screenMatchesGolden(tester, 'amount_input_states');
      });
    });

    group('UberTextInput', () {
      testGoldens('text input types', (tester) async {
        final builder = DeviceBuilder()
          ..overrideDevicesForAllScenarios(devices: [Device.phone])
          ..addScenario(
            widget: _buildTextInputTypes(),
            name: 'text_input_types',
          );

        await tester.pumpDeviceBuilder(builder);
        await screenMatchesGolden(tester, 'text_input_types');
      });

      testGoldens('text input states', (tester) async {
        final builder = DeviceBuilder()
          ..overrideDevicesForAllScenarios(devices: [Device.phone])
          ..addScenario(
            widget: _buildTextInputStates(),
            name: 'text_input_states',
          );

        await tester.pumpDeviceBuilder(builder);
        await screenMatchesGolden(tester, 'text_input_states');
      });
    });

    group('UberRadio', () {
      testGoldens('radio button states', (tester) async {
        final builder = DeviceBuilder()
          ..overrideDevicesForAllScenarios(devices: [Device.phone])
          ..addScenario(
            widget: _buildRadioStates(),
            name: 'radio_states',
          );

        await tester.pumpDeviceBuilder(builder);
        await screenMatchesGolden(tester, 'radio_states');
      });

      testGoldens('radio list tile', (tester) async {
        final builder = DeviceBuilder()
          ..overrideDevicesForAllScenarios(devices: [Device.phone])
          ..addScenario(
            widget: _buildRadioListTile(),
            name: 'radio_list_tile',
          );

        await tester.pumpDeviceBuilder(builder);
        await screenMatchesGolden(tester, 'radio_list_tile');
      });
    });

    group('Theme Tests', () {
      testGoldens('light theme', (tester) async {
        final builder = DeviceBuilder()
          ..overrideDevicesForAllScenarios(devices: [Device.phone])
          ..addScenario(
            widget: _buildLightThemeComponents(),
            name: 'light_theme',
          );

        await tester.pumpDeviceBuilder(builder);
        await screenMatchesGolden(tester, 'light_theme');
      });

      testGoldens('dark theme', (tester) async {
        final builder = DeviceBuilder()
          ..overrideDevicesForAllScenarios(devices: [Device.phone])
          ..addScenario(
            widget: _buildDarkThemeComponents(),
            name: 'dark_theme',
          );

        await tester.pumpDeviceBuilder(builder);
        await screenMatchesGolden(tester, 'dark_theme');
      });
    });
  });
}

Widget _buildTextButtonStates() {
  return MaterialApp(
    theme: UberTheme.lightTheme,
    home: Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Text Button States', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            UberTextButton(
              onPressed: () {},
              child: const Text('Default'),
            ),
            const SizedBox(height: 8),
            UberTextButton(
              onPressed: () {},
              enabled: false,
              child: const Text('Disabled'),
            ),
            const SizedBox(height: 8),
            UberTextButton(
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

Widget _buildTextButtonVariants() {
  return MaterialApp(
    theme: UberTheme.lightTheme,
    home: Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Text Button Variants', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            UberTextButton(
              onPressed: () {},
              variant: UberTextButtonVariant.primary,
              child: const Text('Primary'),
            ),
            const SizedBox(height: 8),
            UberTextButton(
              onPressed: () {},
              variant: UberTextButtonVariant.secondary,
              child: const Text('Secondary'),
            ),
            const SizedBox(height: 8),
            UberTextButton(
              onPressed: () {},
              variant: UberTextButtonVariant.destructive,
              child: const Text('Destructive'),
            ),
          ],
        ),
      ),
    ),
  );
}

Widget _buildTextButtonSizes() {
  return MaterialApp(
    theme: UberTheme.lightTheme,
    home: Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Text Button Sizes', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            UberTextButton(
              onPressed: () {},
              size: UberTextButtonSize.small,
              child: const Text('Small'),
            ),
            const SizedBox(height: 8),
            UberTextButton(
              onPressed: () {},
              size: UberTextButtonSize.medium,
              child: const Text('Medium'),
            ),
            const SizedBox(height: 8),
            UberTextButton(
              onPressed: () {},
              size: UberTextButtonSize.large,
              child: const Text('Large'),
            ),
          ],
        ),
      ),
    ),
  );
}

Widget _buildElevatedButtonStates() {
  return MaterialApp(
    theme: UberTheme.lightTheme,
    home: Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Elevated Button States', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            UberElevatedButton(
              onPressed: () {},
              child: const Text('Default'),
            ),
            const SizedBox(height: 8),
            UberElevatedButton(
              onPressed: () {},
              enabled: false,
              child: const Text('Disabled'),
            ),
            const SizedBox(height: 8),
            UberElevatedButton(
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

Widget _buildElevatedButtonVariants() {
  return MaterialApp(
    theme: UberTheme.lightTheme,
    home: Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Elevated Button Variants', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            UberElevatedButton(
              onPressed: () {},
              variant: UberElevatedButtonVariant.primary,
              child: const Text('Primary'),
            ),
            const SizedBox(height: 8),
            UberElevatedButton(
              onPressed: () {},
              variant: UberElevatedButtonVariant.secondary,
              child: const Text('Secondary'),
            ),
            const SizedBox(height: 8),
            UberElevatedButton(
              onPressed: () {},
              variant: UberElevatedButtonVariant.destructive,
              child: const Text('Destructive'),
            ),
          ],
        ),
      ),
    ),
  );
}

Widget _buildElevatedButtonSizes() {
  return MaterialApp(
    theme: UberTheme.lightTheme,
    home: Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Elevated Button Sizes', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            UberElevatedButton(
              onPressed: () {},
              size: UberElevatedButtonSize.small,
              child: const Text('Small'),
            ),
            const SizedBox(height: 8),
            UberElevatedButton(
              onPressed: () {},
              size: UberElevatedButtonSize.medium,
              child: const Text('Medium'),
            ),
            const SizedBox(height: 8),
            UberElevatedButton(
              onPressed: () {},
              size: UberElevatedButtonSize.large,
              child: const Text('Large'),
            ),
          ],
        ),
      ),
    ),
  );
}

Widget _buildAmountInputStates() {
  return MaterialApp(
    theme: UberTheme.lightTheme,
    home: Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Amount Input States', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            UberAmountInput(
              onChanged: (value) {},
              label: 'Default',
              hintText: 'Enter amount',
            ),
            const SizedBox(height: 16),
            UberAmountInput(
              onChanged: (value) {},
              label: 'With Value',
              initialValue: 25.50,
            ),
            const SizedBox(height: 16),
            UberAmountInput(
              onChanged: (value) {},
              label: 'Disabled',
              enabled: false,
            ),
            const SizedBox(height: 16),
            UberAmountInput(
              onChanged: (value) {},
              label: 'With Error',
              errorText: 'Invalid amount',
            ),
          ],
        ),
      ),
    ),
  );
}

Widget _buildTextInputTypes() {
  return MaterialApp(
    theme: UberTheme.lightTheme,
    home: Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Text Input Types', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            UberTextInput(
              onChanged: (value) {},
              label: 'Text',
              type: UberTextInputType.text,
            ),
            const SizedBox(height: 16),
            UberTextInput(
              onChanged: (value) {},
              label: 'Email',
              type: UberTextInputType.email,
            ),
            const SizedBox(height: 16),
            UberTextInput(
              onChanged: (value) {},
              label: 'Password',
              type: UberTextInputType.password,
            ),
            const SizedBox(height: 16),
            UberTextInput(
              onChanged: (value) {},
              label: 'Multiline',
              type: UberTextInputType.multiline,
            ),
          ],
        ),
      ),
    ),
  );
}

Widget _buildTextInputStates() {
  return MaterialApp(
    theme: UberTheme.lightTheme,
    home: Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Text Input States', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            UberTextInput(
              onChanged: (value) {},
              label: 'Default',
              hintText: 'Enter text',
            ),
            const SizedBox(height: 16),
            UberTextInput(
              onChanged: (value) {},
              label: 'With Value',
              initialValue: 'Sample text',
            ),
            const SizedBox(height: 16),
            UberTextInput(
              onChanged: (value) {},
              label: 'Disabled',
              enabled: false,
            ),
            const SizedBox(height: 16),
            UberTextInput(
              onChanged: (value) {},
              label: 'With Error',
              errorText: 'Invalid input',
            ),
          ],
        ),
      ),
    ),
  );
}

Widget _buildRadioStates() {
  return MaterialApp(
    theme: UberTheme.lightTheme,
    home: Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Radio Button States', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            Row(
              children: [
                UberRadio<String>(
                  value: 'unselected',
                  groupValue: null,
                  onChanged: (value) {},
                ),
                const SizedBox(width: 16),
                const Text('Unselected'),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                UberRadio<String>(
                  value: 'selected',
                  groupValue: 'selected',
                  onChanged: (value) {},
                ),
                const SizedBox(width: 16),
                const Text('Selected'),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                UberRadio<String>(
                  value: 'disabled',
                  groupValue: null,
                  onChanged: null,
                  enabled: false,
                ),
                const SizedBox(width: 16),
                const Text('Disabled'),
              ],
            ),
          ],
        ),
      ),
    ),
  );
}

Widget _buildRadioListTile() {
  return MaterialApp(
    theme: UberTheme.lightTheme,
    home: Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Radio List Tile', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            UberRadioListTile<String>(
              value: 'option1',
              groupValue: 'option1',
              onChanged: (value) {},
              title: const Text('Selected Option'),
              subtitle: const Text('This option is currently selected'),
            ),
            UberRadioListTile<String>(
              value: 'option2',
              groupValue: 'option1',
              onChanged: (value) {},
              title: const Text('Unselected Option'),
              subtitle: const Text('This option is not selected'),
            ),
            UberRadioListTile<String>(
              value: 'option3',
              groupValue: 'option1',
              onChanged: null,
              enabled: false,
              title: const Text('Disabled Option'),
              subtitle: const Text('This option is disabled'),
            ),
          ],
        ),
      ),
    ),
  );
}

Widget _buildLightThemeComponents() {
  return MaterialApp(
    theme: UberTheme.lightTheme,
    home: Scaffold(
      appBar: AppBar(title: const Text('Light Theme')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            UberElevatedButton(
              onPressed: () {},
              child: const Text('Elevated Button'),
            ),
            const SizedBox(height: 8),
            UberTextButton(
              onPressed: () {},
              child: const Text('Text Button'),
            ),
            const SizedBox(height: 16),
            UberAmountInput(
              onChanged: (value) {},
              label: 'Amount',
              initialValue: 42.50,
            ),
            const SizedBox(height: 16),
            UberTextInput(
              onChanged: (value) {},
              label: 'Text Input',
              initialValue: 'Sample text',
            ),
          ],
        ),
      ),
    ),
  );
}

Widget _buildDarkThemeComponents() {
  return MaterialApp(
    theme: UberTheme.darkTheme,
    home: Scaffold(
      appBar: AppBar(title: const Text('Dark Theme')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            UberElevatedButton(
              onPressed: () {},
              child: const Text('Elevated Button'),
            ),
            const SizedBox(height: 8),
            UberTextButton(
              onPressed: () {},
              child: const Text('Text Button'),
            ),
            const SizedBox(height: 16),
            UberAmountInput(
              onChanged: (value) {},
              label: 'Amount',
              initialValue: 42.50,
            ),
            const SizedBox(height: 16),
            UberTextInput(
              onChanged: (value) {},
              label: 'Text Input',
              initialValue: 'Sample text',
            ),
          ],
        ),
      ),
    ),
  );
}