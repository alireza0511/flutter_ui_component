import 'dart:convert';
import 'package:example/screens/source.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:json_dynamic_widget/json_dynamic_widget.dart';
import 'package:flutter_ui_component/flutter_ui_component.dart';

class JsonPreviewScreen extends StatefulWidget {
  const JsonPreviewScreen({super.key});

  @override
  State<JsonPreviewScreen> createState() => _JsonPreviewScreenState();
}

class _JsonPreviewScreenState extends State<JsonPreviewScreen> {
  final TextEditingController _jsonController = TextEditingController();
  final FocusNode _jsonFocusNode = FocusNode();
  bool _isDarkMode = false;
  String? _errorMessage;
  JsonWidgetData? _widgetData;
  bool _isLoading = false;

  // Default JSON examples
final Map<String, String> _examples =
{ 'Simple Text':  '''{
  "type": "scaffold",
  "args": {
    "appBar": {
      "type": "app_bar",
      "args": {
        "title": {
          "type": "text",
          "args": {
            "text": "Rich Text"
          }
        }
      }
    },
    "body": {
      "type": "center",
      "args": {
        "child": {
          "type": "rich_text",
          "args": {
            "text": {
              "children": [
                {
                  "text": "Hello "
                },
                {
                  "style": {
                    "fontSize": 20.0,
                    "fontWeight": "bold"
                  },
                  "text": "RICH TEXT"
                },
                {
                  "text": " World!"
                }
              ],
              "style": {
                "color": "#000000",
                "fontSize": 12.0
              }
            }
          }
        }
      }
    }
  }
}'''};
  final Map<String, String> _examples2 = {
    'Form Layout': '''{
  "type": "column",
  "args": {
    "crossAxisAlignment": "start",
    "mainAxisSize": "min"
  },
  "children": [
    {
      "type": "uber_text_input",
      "args": {
        "label": "Full Name",
        "hintText": "Enter your full name",
        "type": "text"
      }
    },
    {
      "type": "sized_box",
      "args": {
        "height": 16
      }
    },
    {
      "type": "uber_text_input",
      "args": {
        "label": "Email",
        "hintText": "Enter your email",
        "type": "email"
      }
    },
    {
      "type": "sized_box",
      "args": {
        "height": 16
      }
    },
    {
      "type": "uber_amount_input",
      "args": {
        "label": "Budget",
        "hintText": "Enter your budget",
        "currency": "\$",
        "minAmount": 100,
        "maxAmount": 10000
      }
    },
    {
      "type": "sized_box",
      "args": {
        "height": 24
      }
    },
    {
      "type": "uber_elevated_button",
      "args": {
        "label": "Submit Form",
        "variant": "primary",
        "fullWidth": true,
        "onPressed": "show_snackbar"
      }
    }
  ]
}''',
    'Button Gallery': '''{
  "type": "column",
  "args": {
    "crossAxisAlignment": "start",
    "mainAxisSize": "min"
  },
  "children": [
    {
      "type": "text",
      "args": {
        "data": "Text Buttons",
        "style": {
          "fontSize": 18,
          "fontWeight": "bold"
        }
      }
    },
    {
      "type": "sized_box",
      "args": {
        "height": 12
      }
    },
    {
      "type": "wrap",
      "args": {
        "spacing": 8,
        "runSpacing": 8
      },
      "children": [
        {
          "type": "uber_text_button",
          "args": {
            "label": "Primary",
            "variant": "primary",
            "onPressed": "show_snackbar"
          }
        },
        {
          "type": "uber_text_button",
          "args": {
            "label": "Secondary",
            "variant": "secondary",
            "onPressed": "show_snackbar"
          }
        },
        {
          "type": "uber_text_button",
          "args": {
            "label": "Destructive",
            "variant": "destructive",
            "onPressed": "show_snackbar"
          }
        }
      ]
    },
    {
      "type": "sized_box",
      "args": {
        "height": 20
      }
    },
    {
      "type": "text",
      "args": {
        "data": "Elevated Buttons",
        "style": {
          "fontSize": 18,
          "fontWeight": "bold"
        }
      }
    },
    {
      "type": "sized_box",
      "args": {
        "height": 12
      }
    },
    {
      "type": "wrap",
      "args": {
        "spacing": 8,
        "runSpacing": 8
      },
      "children": [
        {
          "type": "uber_elevated_button",
          "args": {
            "label": "Primary",
            "variant": "primary",
            "onPressed": "show_snackbar"
          }
        },
        {
          "type": "uber_elevated_button",
          "args": {
            "label": "Secondary",
            "variant": "secondary",
            "onPressed": "show_snackbar"
          }
        },
        {
          "type": "uber_elevated_button",
          "args": {
            "label": "Destructive",
            "variant": "destructive",
            "onPressed": "show_snackbar"
          }
        }
      ]
    }
  ]
}''',
    'Radio Selection': '''{
  "type": "column",
  "args": {
    "crossAxisAlignment": "start",
    "mainAxisSize": "min"
  },
  "children": [
    {
      "type": "text",
      "args": {
        "data": "Choose your plan:",
        "style": {
          "fontSize": 18,
          "fontWeight": "bold"
        }
      }
    },
    {
      "type": "sized_box",
      "args": {
        "height": 16
      }
    },
    {
      "type": "uber_radio_list_tile",
      "args": {
        "value": "basic",
        "groupValue": "basic",
        "title": "Basic Plan",
        "subtitle": "Perfect for getting started - \$9.99/month"
      }
    },
    {
      "type": "uber_radio_list_tile",
      "args": {
        "value": "premium",
        "groupValue": "basic",
        "title": "Premium Plan",
        "subtitle": "Full access to all features - \$29.99/month"
      }
    },
    {
      "type": "uber_radio_list_tile",
      "args": {
        "value": "enterprise",
        "groupValue": "basic",
        "title": "Enterprise Plan",
        "subtitle": "Custom solutions for large teams - Contact us"
      }
    }
  ]
}''',
  };

  @override
  void initState() {
    super.initState();
    // Ensure the registry is initialized
    JsonWidgetRegistry.instance;
    // Load the first example by default
    // _loadExample(_examples.values.first);
    _loadExample(examples.values.first);
  }

  @override
  void dispose() {
    _jsonController.dispose();
    _jsonFocusNode.dispose();
    super.dispose();
  }

  void _loadExample(String jsonString) {
    _jsonController.text = _formatJson(jsonString);
    _parseJson();
  }

  String _formatJson(String jsonString) {
    try {
      final decoded = json.decode(jsonString);
      return const JsonEncoder.withIndent('  ').convert(decoded);
    } catch (e) {
      return jsonString;
    }
  }

  void _parseJson() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final jsonString = _jsonController.text.trim();
      if (jsonString.isEmpty) {
        setState(() {
          _widgetData = null;
          _isLoading = false;
        });
        return;
      }

      final decoded = json.decode(jsonString);
      final widgetData = JsonWidgetData.fromDynamic(
        decoded,
        registry: JsonWidgetRegistry.instance,
      );
      
      setState(() {
        _widgetData = widgetData;
        _errorMessage = null;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _errorMessage = 'JSON Error: ${e.toString()}';
        _widgetData = null;
        _isLoading = false;
      });
    }
  }

  void _resetJson() {
    _jsonController.clear();
    setState(() {
      _widgetData = null;
      _errorMessage = null;
    });
  }

  Widget _buildManualWidget() {
    try {
      final jsonString = _jsonController.text.trim();
      if (jsonString.isEmpty) return const Text('No JSON');
      
      final decoded = json.decode(jsonString);
      return _buildWidgetFromJson(decoded);
    } catch (e) {
      return Text('Error: $e');
    }
  }
  
  Widget _buildWidgetFromJson(Map<String, dynamic> json) {
    final type = json['type'] as String?;
    final args = json['args'] as Map<String, dynamic>? ?? {};
    
    switch (type) {
      case 'container':
        return Container(
          height: args['height']?.toDouble(),
          width: args['width']?.toDouble(),
          color: _parseColor(args['color']),
          child: args['child'] != null ? _buildWidgetFromJson(args['child']) : null,
        );
      case 'text':
        return Text(
          args['data'] ?? '',
          style: TextStyle(
            color: _parseColor(args['style']?['color']) ?? Colors.black,
            fontSize: args['style']?['fontSize']?.toDouble() ?? 14,
          ),
        );
      case 'center':
        return Center(
          child: args['child'] != null ? _buildWidgetFromJson(args['child']) : null,
        );
      default:
        return Text('Unknown widget type: $type');
    }
  }
  
  Color? _parseColor(dynamic color) {
    if (color == null) return null;
    if (color == 'blue') return Colors.blue;
    if (color == 'red') return Colors.red;
    if (color == 'green') return Colors.green;
    return null;
  }

  void _copyJsonToClipboard() {
    Clipboard.setData(ClipboardData(text: _jsonController.text));
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('JSON copied to clipboard')),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = _isDarkMode ? UberTheme.darkTheme : UberTheme.lightTheme;
    
    return MaterialApp(
      theme: theme,
      home: Scaffold(
        appBar: AppBar(
          title: const Text('JSON UI Preview'),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () => Navigator.of(context).pop(),
          ),
          actions: [
            IconButton(
              icon: Icon(_isDarkMode ? Icons.light_mode : Icons.dark_mode),
              onPressed: () {
                setState(() {
                  _isDarkMode = !_isDarkMode;
                });
              },
              tooltip: 'Toggle theme',
            ),
            PopupMenuButton<String>(
              icon: const Icon(Icons.code),
              tooltip: 'Load Example',
              onSelected: (example) {
                _loadExample(_examples[example]!);
              },
              itemBuilder: (context) {
                return _examples.keys.map((String example) {
                  return PopupMenuItem<String>(
                    value: example,
                    child: Text(example),
                  );
                }).toList();
              },
            ),
          ],
        ),
        body: LayoutBuilder(
          builder: (context, constraints) {
            final isWideScreen = constraints.maxWidth > 800;
            
            if (isWideScreen) {
              return Row(
                children: [
                  Expanded(
                    flex: 1,
                    child: _buildJsonEditor(),
                  ),
                  const VerticalDivider(width: 1),
                  Expanded(
                    flex: 1,
                    child: _buildPreview(),
                  ),
                ],
              );
            } else {
              return Column(
                children: [
                  Expanded(
                    child: _buildJsonEditor(),
                  ),
                  const Divider(height: 1),
                  Expanded(
                    child: _buildPreview(),
                  ),
                ],
              );
            }
          },
        ),
        floatingActionButton: FloatingActionButton.extended(
          onPressed: _parseJson,
          icon: const Icon(Icons.refresh),
          label: const Text('Update Preview'),
        ),
      ),
    );
  }

  Widget _buildJsonEditor() {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                'JSON Editor',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const Spacer(),
              IconButton(
                icon: const Icon(Icons.copy),
                onPressed: _copyJsonToClipboard,
                tooltip: 'Copy JSON',
              ),
              IconButton(
                icon: const Icon(Icons.clear),
                onPressed: _resetJson,
                tooltip: 'Clear JSON',
              ),
            ],
          ),
          const SizedBox(height: 12),
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                border: Border.all(
                  color: Theme.of(context).colorScheme.outline,
                ),
                borderRadius: BorderRadius.circular(8),
              ),
              child: TextField(
                controller: _jsonController,
                focusNode: _jsonFocusNode,
                maxLines: null,
                expands: true,
                style: const TextStyle(
                  fontFamily: 'monospace',
                  fontSize: 14,
                ),
                decoration: const InputDecoration(
                  hintText: 'Paste or type your JSON here...',
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.all(16),
                ),
                onChanged: (_) => _parseJson(),
              ),
            ),
          ),
          if (_errorMessage != null) ...[
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.errorContainer,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.error,
                    color: Theme.of(context).colorScheme.onErrorContainer,
                    size: 20,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      _errorMessage!,
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.onErrorContainer,
                        fontSize: 12,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildPreview() {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Live Preview',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),
          Expanded(
            child: Container(
              width: double.infinity,
              decoration: BoxDecoration(
                border: Border.all(
                  color: Theme.of(context).colorScheme.outline,
                ),
                borderRadius: BorderRadius.circular(8),
              ),
              child: _buildPreviewContent(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPreviewContent() {
    if (_isLoading) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    if (_errorMessage != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.error_outline,
              size: 48,
              color: Theme.of(context).colorScheme.error,
            ),
            const SizedBox(height: 16),
            Text(
              'Invalid JSON',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                color: Theme.of(context).colorScheme.error,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Fix the JSON syntax to see the preview',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
              ),
            ),
          ],
        ),
      );
    }

    if (_widgetData == null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.code,
              size: 48,
              color: Theme.of(context).colorScheme.onSurface.withOpacity(0.5),
            ),
            const SizedBox(height: 16),
            Text(
              'No Preview Available',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                color: Theme.of(context).colorScheme.onSurface.withOpacity(0.5),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Enter valid JSON to see the widget preview',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: Theme.of(context).colorScheme.onSurface.withOpacity(0.5),
              ),
            ),
          ],
        ),
      );
    }

    try {
      final widget = _widgetData!.build(
        context: context,
      );
      
      return Container(
        width: double.infinity,
        height: double.infinity,
        padding: const EdgeInsets.all(16),
        alignment: Alignment.topLeft,
        color: Colors.grey.withOpacity(0.1), // Light background to see the widget
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
           
            Container(
              width: 300,
              height: 200,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.red, width: 2),
                color: Colors.yellow.withOpacity(0.3),
              ),
              child: Stack(
                children: [
                  // Force the JSON widget to fill the space
                  Positioned.fill(
                    child: Container(
                      color: Colors.white.withOpacity(0.8),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          
                          const SizedBox(height: 10),
                          Expanded(
                            child: Material(
                              color: Colors.transparent,
                              child: DefaultTextStyle(
                                style: const TextStyle(color: Colors.black, fontSize: 16),
                                child: widget ?? const Text('Widget is null'),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  // Test widget to verify the container works
                  Positioned(
                    bottom: 5,
                    right: 5,
                    child: Container(
                      padding: const EdgeInsets.all(4),
                      color: Colors.green,
                      child: const Text('TEST', style: TextStyle(color: Colors.white, fontSize: 10)),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      );
    } catch (e) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.warning,
              size: 48,
              color: Theme.of(context).colorScheme.error,
            ),
            const SizedBox(height: 16),
            Text(
              'Widget Build Error',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                color: Theme.of(context).colorScheme.error,
              ),
            ),
            const SizedBox(height: 8),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Text(
                e.toString(),
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
                ),
              ),
            ),
          ],
        ),
      );
    }
  }
}