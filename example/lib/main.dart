import 'package:flutter/material.dart';
import 'package:flutter_ui_component/flutter_ui_component.dart';
import 'screens/json_preview_screen.dart';

void main() {


  runApp(const ExampleApp());
}

class ExampleApp extends StatefulWidget {
  const ExampleApp({super.key});

  @override
  State<ExampleApp> createState() => _ExampleAppState();
}

class _ExampleAppState extends State<ExampleApp> {
  bool _isDarkMode = false;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter UI Component Demo',
      theme: _isDarkMode ? UberTheme.darkTheme : UberTheme.lightTheme,
      home: ComponentShowcase(
        isDarkMode: _isDarkMode,
        onThemeToggle: () {
          setState(() {
            _isDarkMode = !_isDarkMode;
          });
        },
      ),
      debugShowCheckedModeBanner: false,
    );
  }
}

class ComponentShowcase extends StatefulWidget {
  const ComponentShowcase({
    super.key,
    required this.isDarkMode,
    required this.onThemeToggle,
  });

  final bool isDarkMode;
  final VoidCallback onThemeToggle;

  @override
  State<ComponentShowcase> createState() => _ComponentShowcaseState();
}

class _ComponentShowcaseState extends State<ComponentShowcase> {
  String _textInputValue = '';
  double? _amountValue;
  String? _selectedRadioValue = 'option1';
  bool _isLoading = false;

  void _simulateLoading() {
    setState(() {
      _isLoading = true;
    });
    
    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('Flutter UI Components'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.code),
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => const JsonPreviewScreen(),
                ),
              );
            },
            tooltip: 'JSON Preview',
          ),
          IconButton(
            icon: Icon(widget.isDarkMode ? Icons.light_mode : Icons.dark_mode),
            onPressed: widget.onThemeToggle,
            tooltip: 'Toggle theme',
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Text(
                'Uber Base Design System Components',
                style: theme.textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(height: 8),
            Center(
              child: Text(
                'A comprehensive Flutter package with Material 3 foundation',
                style: theme.textTheme.bodyLarge?.copyWith(
                  color: theme.colorScheme.onSurface.withOpacity(0.7),
                ),
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(height: 32),
            
            _buildSection(
              context,
              'Text Buttons',
              'Lightweight buttons for secondary actions',
              [
                _buildSubsection(context, 'Variants', [
                  Wrap(
                    spacing: 12,
                    runSpacing: 12,
                    children: [
                      UberTextButton(
                        onPressed: () => _showSnackBar(context, 'Primary text button pressed'),
                        variant: UberTextButtonVariant.primary,
                        child: const Text('Primary'),
                      ),
                      UberTextButton(
                        onPressed: () => _showSnackBar(context, 'Secondary text button pressed'),
                        variant: UberTextButtonVariant.secondary,
                        child: const Text('Secondary'),
                      ),
                      UberTextButton(
                        onPressed: () => _showSnackBar(context, 'Destructive text button pressed'),
                        variant: UberTextButtonVariant.destructive,
                        child: const Text('Delete'),
                      ),
                    ],
                  ),
                ]),
                _buildSubsection(context, 'Sizes', [
                  Wrap(
                    spacing: 12,
                    runSpacing: 12,
                    children: [
                      UberTextButton(
                        onPressed: () => _showSnackBar(context, 'Small button pressed'),
                        size: UberTextButtonSize.small,
                        child: const Text('Small'),
                      ),
                      UberTextButton(
                        onPressed: () => _showSnackBar(context, 'Medium button pressed'),
                        size: UberTextButtonSize.medium,
                        child: const Text('Medium'),
                      ),
                      UberTextButton(
                        onPressed: () => _showSnackBar(context, 'Large button pressed'),
                        size: UberTextButtonSize.large,
                        child: const Text('Large'),
                      ),
                    ],
                  ),
                ]),
                _buildSubsection(context, 'States', [
                  Wrap(
                    spacing: 12,
                    runSpacing: 12,
                    children: [
                      UberTextButton(
                        onPressed: () => _showSnackBar(context, 'Default button pressed'),
                        child: const Text('Default'),
                      ),
                      UberTextButton(
                        onPressed: null,
                        enabled: false,
                        child: const Text('Disabled'),
                      ),
                      UberTextButton(
                        onPressed: _simulateLoading,
                        isLoading: _isLoading,
                        child: const Text('Loading'),
                      ),
                    ],
                  ),
                ]),
                _buildSubsection(context, 'Full Width', [
                  UberTextButton(
                    onPressed: () => _showSnackBar(context, 'Full width button pressed'),
                    fullWidth: true,
                    child: const Text('Full Width Button'),
                  ),
                ]),
              ],
            ),
            
            const SizedBox(height: 40),
            
            _buildSection(
              context,
              'Elevated Buttons',
              'Primary action buttons with elevation',
              [
                _buildSubsection(context, 'Variants', [
                  Wrap(
                    spacing: 12,
                    runSpacing: 12,
                    children: [
                      UberElevatedButton(
                        onPressed: () => _showSnackBar(context, 'Primary elevated button pressed'),
                        variant: UberElevatedButtonVariant.primary,
                        child: const Text('Primary'),
                      ),
                      UberElevatedButton(
                        onPressed: () => _showSnackBar(context, 'Secondary elevated button pressed'),
                        variant: UberElevatedButtonVariant.secondary,
                        child: const Text('Secondary'),
                      ),
                      UberElevatedButton(
                        onPressed: () => _showSnackBar(context, 'Destructive elevated button pressed'),
                        variant: UberElevatedButtonVariant.destructive,
                        child: const Text('Delete'),
                      ),
                    ],
                  ),
                ]),
                _buildSubsection(context, 'Sizes', [
                  Wrap(
                    spacing: 12,
                    runSpacing: 12,
                    children: [
                      UberElevatedButton(
                        onPressed: () => _showSnackBar(context, 'Small elevated button pressed'),
                        size: UberElevatedButtonSize.small,
                        child: const Text('Small'),
                      ),
                      UberElevatedButton(
                        onPressed: () => _showSnackBar(context, 'Medium elevated button pressed'),
                        size: UberElevatedButtonSize.medium,
                        child: const Text('Medium'),
                      ),
                      UberElevatedButton(
                        onPressed: () => _showSnackBar(context, 'Large elevated button pressed'),
                        size: UberElevatedButtonSize.large,
                        child: const Text('Large'),
                      ),
                    ],
                  ),
                ]),
                _buildSubsection(context, 'States', [
                  Wrap(
                    spacing: 12,
                    runSpacing: 12,
                    children: [
                      UberElevatedButton(
                        onPressed: () => _showSnackBar(context, 'Default elevated button pressed'),
                        child: const Text('Default'),
                      ),
                      UberElevatedButton(
                        onPressed: null,
                        enabled: false,
                        child: const Text('Disabled'),
                      ),
                      UberElevatedButton(
                        onPressed: _simulateLoading,
                        isLoading: _isLoading,
                        child: const Text('Loading'),
                      ),
                    ],
                  ),
                ]),
                _buildSubsection(context, 'Full Width', [
                  UberElevatedButton(
                    onPressed: () => _showSnackBar(context, 'Full width elevated button pressed'),
                    fullWidth: true,
                    child: const Text('Full Width Button'),
                  ),
                ]),
              ],
            ),
            
            const SizedBox(height: 40),
            
            _buildSection(
              context,
              'Amount Input',
              'Specialized input field for currency amounts',
              [
                _buildSubsection(context, 'Basic Usage', [
                  UberAmountInput(
                    onChanged: (value) {
                      setState(() {
                        _amountValue = value;
                      });
                    },
                    label: 'Amount',
                    hintText: 'Enter amount',
                    helperText: 'Minimum \$5.00',
                    minAmount: 5.0,
                    maxAmount: 1000.0,
                  ),
                  if (_amountValue != null) ...[
                    const SizedBox(height: 8),
                    Text(
                      'Current value: \$${_amountValue!.toStringAsFixed(2)}',
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: theme.colorScheme.primary,
                      ),
                    ),
                  ],
                ]),
                _buildSubsection(context, 'Different Currencies', [
                  UberAmountInput(
                    onChanged: (value) {},
                    label: 'Euro Amount',
                    currency: '€',
                    initialValue: 42.50,
                  ),
                  const SizedBox(height: 16),
                  UberAmountInput(
                    onChanged: (value) {},
                    label: 'Pound Amount',
                    currency: '£',
                    initialValue: 25.75,
                  ),
                ]),
                _buildSubsection(context, 'States', [
                  UberAmountInput(
                    onChanged: (value) {},
                    label: 'Disabled Amount',
                    enabled: false,
                    initialValue: 100.0,
                  ),
                  const SizedBox(height: 16),
                  UberAmountInput(
                    onChanged: (value) {},
                    label: 'Amount with Error',
                    errorText: 'Amount is required',
                  ),
                ]),
              ],
            ),
            
            const SizedBox(height: 40),
            
            _buildSection(
              context,
              'Text Input',
              'Versatile text input fields for various data types',
              [
                _buildSubsection(context, 'Input Types', [
                  UberTextInput(
                    onChanged: (value) {
                      setState(() {
                        _textInputValue = value;
                      });
                    },
                    label: 'Name',
                    hintText: 'Enter your name',
                    type: UberTextInputType.text,
                    prefixIcon: const Icon(Icons.person),
                  ),
                  const SizedBox(height: 16),
                  UberTextInput(
                    onChanged: (value) {},
                    label: 'Email',
                    hintText: 'Enter your email',
                    type: UberTextInputType.email,
                    prefixIcon: const Icon(Icons.email),
                  ),
                  const SizedBox(height: 16),
                  UberTextInput(
                    onChanged: (value) {},
                    label: 'Password',
                    hintText: 'Enter your password',
                    type: UberTextInputType.password,
                    prefixIcon: const Icon(Icons.lock),
                  ),
                  const SizedBox(height: 16),
                  UberTextInput(
                    onChanged: (value) {},
                    label: 'Comments',
                    hintText: 'Enter your comments',
                    type: UberTextInputType.multiline,
                    prefixIcon: const Icon(Icons.comment),
                  ),
                  if (_textInputValue.isNotEmpty) ...[
                    const SizedBox(height: 8),
                    Text(
                      'You entered: $_textInputValue',
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: theme.colorScheme.primary,
                      ),
                    ),
                  ],
                ]),
                _buildSubsection(context, 'Validation', [
                  UberTextInput(
                    onChanged: (value) {},
                    label: 'Username',
                    hintText: 'Minimum 3 characters',
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Username is required';
                      }
                      if (value.length < 3) {
                        return 'Username must be at least 3 characters';
                      }
                      return null;
                    },
                  ),
                ]),
                _buildSubsection(context, 'Character Limit', [
                  UberTextInput(
                    onChanged: (value) {},
                    label: 'Short Description',
                    hintText: 'Maximum 50 characters',
                    maxLength: 50,
                  ),
                ]),
                _buildSubsection(context, 'States', [
                  UberTextInput(
                    onChanged: (value) {},
                    label: 'Disabled Input',
                    enabled: false,
                    initialValue: 'This field is disabled',
                  ),
                  const SizedBox(height: 16),
                  UberTextInput(
                    onChanged: (value) {},
                    label: 'Input with Error',
                    errorText: 'This field has an error',
                    initialValue: 'Invalid value',
                  ),
                ]),
              ],
            ),
            
            const SizedBox(height: 40),
            
            _buildSection(
              context,
              'Radio Buttons',
              'Single selection from multiple options',
              [
                _buildSubsection(context, 'Basic Radio Group', [
                  Column(
                    children: [
                      Row(
                        children: [
                          UberRadio<String>(
                            value: 'option1',
                            groupValue: _selectedRadioValue,
                            onChanged: (value) {
                              setState(() {
                                _selectedRadioValue = value;
                              });
                            },
                          ),
                          const SizedBox(width: 8),
                          const Text('Option 1'),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          UberRadio<String>(
                            value: 'option2',
                            groupValue: _selectedRadioValue,
                            onChanged: (value) {
                              setState(() {
                                _selectedRadioValue = value;
                              });
                            },
                          ),
                          const SizedBox(width: 8),
                          const Text('Option 2'),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          UberRadio<String>(
                            value: 'option3',
                            groupValue: _selectedRadioValue,
                            onChanged: null,
                            enabled: false,
                          ),
                          const SizedBox(width: 8),
                          const Text('Option 3 (Disabled)'),
                        ],
                      ),
                    ],
                  ),
                  if (_selectedRadioValue != null) ...[
                    const SizedBox(height: 16),
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: theme.colorScheme.primaryContainer,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        'Selected: $_selectedRadioValue',
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: theme.colorScheme.onPrimaryContainer,
                        ),
                      ),
                    ),
                  ],
                ]),
                _buildSubsection(context, 'Radio List Tiles', [
                  UberRadioListTile<String>(
                    value: 'list_option1',
                    groupValue: _selectedRadioValue,
                    onChanged: (value) {
                      setState(() {
                        _selectedRadioValue = value;
                      });
                    },
                    title: const Text('Premium Plan'),
                    subtitle: const Text('Full access to all features - \$29.99/month'),
                  ),
                  UberRadioListTile<String>(
                    value: 'list_option2',
                    groupValue: _selectedRadioValue,
                    onChanged: (value) {
                      setState(() {
                        _selectedRadioValue = value;
                      });
                    },
                    title: const Text('Basic Plan'),
                    subtitle: const Text('Limited features - \$9.99/month'),
                  ),
                  UberRadioListTile<String>(
                    value: 'list_option3',
                    groupValue: _selectedRadioValue,
                    onChanged: (value) {
                      setState(() {
                        _selectedRadioValue = value;
                      });
                    },
                    title: const Text('Free Plan'),
                    subtitle: const Text('Basic features only - Free'),
                  ),
                ]),
              ],
            ),
            
            const SizedBox(height: 40),
            
            _buildSection(
              context,
              'Theme Showcase',
              'Components in different themes',
              [
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    border: Border.all(color: theme.colorScheme.outline),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    children: [
                      Text(
                        'Current Theme: ${widget.isDarkMode ? 'Dark' : 'Light'}',
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 16),
                      Row(
                        children: [
                          Expanded(
                            child: UberElevatedButton(
                              onPressed: widget.onThemeToggle,
                              child: Text('Switch to ${widget.isDarkMode ? 'Light' : 'Dark'} Theme'),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'All components automatically adapt to the current theme with proper contrast ratios and accessibility support.',
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: theme.colorScheme.onSurface.withOpacity(0.7),
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              ],
            ),
            
            const SizedBox(height: 40),
            
            Center(
              child: Column(
                children: [
                  Text(
                    'Made with Flutter & Material 3',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.onSurface.withOpacity(0.6),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Inspired by Uber Base Design System',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.onSurface.withOpacity(0.6),
                    ),
                  ),
                ],
              ),
            ),
            
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  Widget _buildSection(BuildContext context, String title, String description, List<Widget> children) {
    final theme = Theme.of(context);
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: theme.textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          description,
          style: theme.textTheme.bodyMedium?.copyWith(
            color: theme.colorScheme.onSurface.withOpacity(0.7),
          ),
        ),
        const SizedBox(height: 20),
        ...children,
      ],
    );
  }

  Widget _buildSubsection(BuildContext context, String title, List<Widget> children) {
    final theme = Theme.of(context);
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (title.isNotEmpty) ...[
          Text(
            title,
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 12),
        ],
        ...children,
        const SizedBox(height: 24),
      ],
    );
  }

  void _showSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: const Duration(seconds: 2),
      ),
    );
  }
}