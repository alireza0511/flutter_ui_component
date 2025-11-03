// import 'package:json_dynamic_widget/json_dynamic_widget.dart';
// import '../widgets/uber_text_button.dart';
// import '../widgets/uber_elevated_button.dart';
// import '../widgets/uber_amount_input.dart';
// import '../widgets/uber_text_input.dart';
// import '../widgets/uber_radio.dart';

// class UberJsonWidgetBuilders {
//   static Map<String, JsonWidgetBuilder> get builders => {
//     'uber_text_button': const UberTextButtonBuilder(),
//     'uber_elevated_button': const UberElevatedButtonBuilder(),
//     'uber_amount_input': const UberAmountInputBuilder(),
//     'uber_text_input': const UberTextInputBuilder(),
//     'uber_radio': const UberRadioBuilder(),
//     'uber_radio_list_tile': const UberRadioListTileBuilder(),
//   };
// }

// class UberTextButtonBuilder extends JsonWidgetBuilder {
//   const UberTextButtonBuilder({
//     super.args = const {},
//   }) : super(
//           numSupportedChildren: 1,
//         );

//   @override
//   String get type => 'uber_text_button';

//   @override
//   JsonWidgetModel createModel({
//     required Map<String, dynamic> args,
//     required JsonWidgetRegistry registry,
//     List<JsonWidgetModel>? children,
//   }) {
//     return JsonWidgetModel.fromDynamic(
//       {
//         'type': type,
//         'args': args,
//         'children': children?.map((e) => e.toJson()).toList(),
//       },
//       registry: registry,
//     )!;
//   }

//   @override
//   Widget buildCustom({
//     ChildWidgetBuilder? childBuilder,
//     required BuildContext context,
//     required JsonWidgetData data,
//     Key? key,
//   }) {
//     return UberTextButton(
//       key: key,
//       onPressed: () {
//         final action = data.jsonWidgetArgs['onPressed'] as String?;
//         if (action != null) {
//           _handleAction(context, action);
//         }
//       },
//       variant: _parseTextButtonVariant(data.jsonWidgetArgs['variant']),
//       size: _parseTextButtonSize(data.jsonWidgetArgs['size']),
//       isLoading: data.jsonWidgetArgs['isLoading'] ?? false,
//       enabled: data.jsonWidgetArgs['enabled'] ?? true,
//       fullWidth: data.jsonWidgetArgs['fullWidth'] ?? false,
//       semanticLabel: data.jsonWidgetArgs['semanticLabel'],
//       child: data.jsonWidgetChildren?.isNotEmpty == true
//           ? data.jsonWidgetChildren!.first.build(
//               childBuilder: childBuilder,
//               context: context,
//             )
//           : Text(data.jsonWidgetArgs['label'] ?? 'Button'),
//     );
//   }

//   UberTextButtonVariant _parseTextButtonVariant(String? variant) {
//     switch (variant) {
//       case 'secondary':
//         return UberTextButtonVariant.secondary;
//       case 'destructive':
//         return UberTextButtonVariant.destructive;
//       default:
//         return UberTextButtonVariant.primary;
//     }
//   }

//   UberTextButtonSize _parseTextButtonSize(String? size) {
//     switch (size) {
//       case 'small':
//         return UberTextButtonSize.small;
//       case 'large':
//         return UberTextButtonSize.large;
//       default:
//         return UberTextButtonSize.medium;
//     }
//   }

//   void _handleAction(BuildContext context, String action) {
//     switch (action) {
//       case 'show_snackbar':
//         ScaffoldMessenger.of(context).showSnackBar(
//           const SnackBar(content: Text('Button pressed!')),
//         );
//         break;
//       case 'navigate_back':
//         Navigator.of(context).maybePop();
//         break;
//       default:
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(content: Text('Action: $action')),
//         );
//     }
//   }
// }

// class UberElevatedButtonBuilder extends JsonWidgetBuilder {
//   const UberElevatedButtonBuilder({
//     super.args = const {},
//   }) : super(
//           numSupportedChildren: 1,
//         );

//   @override
//   String get type => 'uber_elevated_button';

//   @override
//   JsonWidgetModel createModel({
//     required Map<String, dynamic> args,
//     required JsonWidgetRegistry registry,
//     List<JsonWidgetModel>? children,
//   }) {
//     return JsonWidgetModel.fromDynamic(
//       {
//         'type': type,
//         'args': args,
//         'children': children?.map((e) => e.toJson()).toList(),
//       },
//       registry: registry,
//     )!;
//   }

//   @override
//   Widget buildCustom({
//     ChildWidgetBuilder? childBuilder,
//     required BuildContext context,
//     required JsonWidgetData data,
//     Key? key,
//   }) {
//     return UberElevatedButton(
//       key: key,
//       onPressed: () {
//         final action = data.jsonWidgetArgs['onPressed'] as String?;
//         if (action != null) {
//           _handleAction(context, action);
//         }
//       },
//       variant: _parseElevatedButtonVariant(data.jsonWidgetArgs['variant']),
//       size: _parseElevatedButtonSize(data.jsonWidgetArgs['size']),
//       isLoading: data.jsonWidgetArgs['isLoading'] ?? false,
//       enabled: data.jsonWidgetArgs['enabled'] ?? true,
//       fullWidth: data.jsonWidgetArgs['fullWidth'] ?? false,
//       semanticLabel: data.jsonWidgetArgs['semanticLabel'],
//       child: data.jsonWidgetChildren?.isNotEmpty == true
//           ? data.jsonWidgetChildren!.first.build(
//               childBuilder: childBuilder,
//               context: context,
//             )
//           : Text(data.jsonWidgetArgs['label'] ?? 'Button'),
//     );
//   }

//   UberElevatedButtonVariant _parseElevatedButtonVariant(String? variant) {
//     switch (variant) {
//       case 'secondary':
//         return UberElevatedButtonVariant.secondary;
//       case 'destructive':
//         return UberElevatedButtonVariant.destructive;
//       default:
//         return UberElevatedButtonVariant.primary;
//     }
//   }

//   UberElevatedButtonSize _parseElevatedButtonSize(String? size) {
//     switch (size) {
//       case 'small':
//         return UberElevatedButtonSize.small;
//       case 'large':
//         return UberElevatedButtonSize.large;
//       default:
//         return UberElevatedButtonSize.medium;
//     }
//   }

//   void _handleAction(BuildContext context, String action) {
//     switch (action) {
//       case 'show_snackbar':
//         ScaffoldMessenger.of(context).showSnackBar(
//           const SnackBar(content: Text('Elevated button pressed!')),
//         );
//         break;
//       case 'navigate_back':
//         Navigator.of(context).maybePop();
//         break;
//       default:
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(content: Text('Action: $action')),
//         );
//     }
//   }
// }

// class UberAmountInputBuilder extends JsonWidgetBuilder {
//   const UberAmountInputBuilder({
//     super.args = const {},
//   });

//   @override
//   String get type => 'uber_amount_input';

//   @override
//   JsonWidgetModel createModel({
//     required Map<String, dynamic> args,
//     required JsonWidgetRegistry registry,
//     List<JsonWidgetModel>? children,
//   }) {
//     return JsonWidgetModel.fromDynamic(
//       {
//         'type': type,
//         'args': args,
//         'children': children?.map((e) => e.toJson()).toList(),
//       },
//       registry: registry,
//     )!;
//   }

//   @override
//   Widget buildCustom({
//     ChildWidgetBuilder? childBuilder,
//     required BuildContext context,
//     required JsonWidgetData data,
//     Key? key,
//   }) {
//     return UberAmountInput(
//       key: key,
//       onChanged: (value) {
//         // Handle amount change
//         print('Amount changed: $value');
//       },
//       initialValue: data.jsonWidgetArgs['initialValue']?.toDouble(),
//       label: data.jsonWidgetArgs['label'],
//       hintText: data.jsonWidgetArgs['hintText'],
//       helperText: data.jsonWidgetArgs['helperText'],
//       errorText: data.jsonWidgetArgs['errorText'],
//       enabled: data.jsonWidgetArgs['enabled'] ?? true,
//       currency: data.jsonWidgetArgs['currency'] ?? '\$',
//       maxDecimalPlaces: data.jsonWidgetArgs['maxDecimalPlaces'] ?? 2,
//       maxAmount: data.jsonWidgetArgs['maxAmount']?.toDouble(),
//       minAmount: data.jsonWidgetArgs['minAmount']?.toDouble(),
//       semanticLabel: data.jsonWidgetArgs['semanticLabel'],
//     );
//   }
// }

// class UberTextInputBuilder extends JsonWidgetBuilder {
//   const UberTextInputBuilder({
//     super.args = const {},
//   });

//   @override
//   String get type => 'uber_text_input';

//   @override
//   JsonWidgetModel createModel({
//     required Map<String, dynamic> args,
//     required JsonWidgetRegistry registry,
//     List<JsonWidgetModel>? children,
//   }) {
//     return JsonWidgetModel.fromDynamic(
//       {
//         'type': type,
//         'args': args,
//         'children': children?.map((e) => e.toJson()).toList(),
//       },
//       registry: registry,
//     )!;
//   }

//   @override
//   Widget buildCustom({
//     ChildWidgetBuilder? childBuilder,
//     required BuildContext context,
//     required JsonWidgetData data,
//     Key? key,
//   }) {
//     return UberTextInput(
//       key: key,
//       onChanged: (value) {
//         // Handle text change
//         print('Text changed: $value');
//       },
//       initialValue: data.jsonWidgetArgs['initialValue'],
//       label: data.jsonWidgetArgs['label'],
//       hintText: data.jsonWidgetArgs['hintText'],
//       helperText: data.jsonWidgetArgs['helperText'],
//       errorText: data.jsonWidgetArgs['errorText'],
//       enabled: data.jsonWidgetArgs['enabled'] ?? true,
//       type: _parseTextInputType(data.jsonWidgetArgs['type']),
//       maxLength: data.jsonWidgetArgs['maxLength'],
//       maxLines: data.jsonWidgetArgs['maxLines'],
//       minLines: data.jsonWidgetArgs['minLines'],
//       semanticLabel: data.jsonWidgetArgs['semanticLabel'],
//       textAlign: _parseTextAlign(data.jsonWidgetArgs['textAlign']),
//       textCapitalization: _parseTextCapitalization(data.jsonWidgetArgs['textCapitalization']),
//     );
//   }

//   UberTextInputType _parseTextInputType(String? type) {
//     switch (type) {
//       case 'email':
//         return UberTextInputType.email;
//       case 'password':
//         return UberTextInputType.password;
//       case 'multiline':
//         return UberTextInputType.multiline;
//       default:
//         return UberTextInputType.text;
//     }
//   }

//   TextAlign _parseTextAlign(String? align) {
//     switch (align) {
//       case 'center':
//         return TextAlign.center;
//       case 'right':
//         return TextAlign.right;
//       case 'justify':
//         return TextAlign.justify;
//       default:
//         return TextAlign.start;
//     }
//   }

//   TextCapitalization _parseTextCapitalization(String? capitalization) {
//     switch (capitalization) {
//       case 'words':
//         return TextCapitalization.words;
//       case 'sentences':
//         return TextCapitalization.sentences;
//       case 'characters':
//         return TextCapitalization.characters;
//       default:
//         return TextCapitalization.none;
//     }
//   }
// }

// class UberRadioBuilder extends JsonWidgetBuilder {
//   const UberRadioBuilder({
//     super.args = const {},
//   });

//   @override
//   String get type => 'uber_radio';

//   @override
//   JsonWidgetModel createModel({
//     required Map<String, dynamic> args,
//     required JsonWidgetRegistry registry,
//     List<JsonWidgetModel>? children,
//   }) {
//     return JsonWidgetModel.fromDynamic(
//       {
//         'type': type,
//         'args': args,
//         'children': children?.map((e) => e.toJson()).toList(),
//       },
//       registry: registry,
//     )!;
//   }

//   @override
//   Widget buildCustom({
//     ChildWidgetBuilder? childBuilder,
//     required BuildContext context,
//     required JsonWidgetData data,
//     Key? key,
//   }) {
//     return UberRadio<String>(
//       key: key,
//       value: data.jsonWidgetArgs['value'] ?? '',
//       groupValue: data.jsonWidgetArgs['groupValue'],
//       onChanged: (value) {
//         // Handle radio selection
//         print('Radio selected: $value');
//       },
//       enabled: data.jsonWidgetArgs['enabled'] ?? true,
//       semanticLabel: data.jsonWidgetArgs['semanticLabel'],
//     );
//   }
// }

// class UberRadioListTileBuilder extends JsonWidgetBuilder {
//   const UberRadioListTileBuilder({
//     super.args = const {},
//   }) : super(
//           numSupportedChildren: 2,
//         );

//   @override
//   String get type => 'uber_radio_list_tile';

//   @override
//   JsonWidgetModel createModel({
//     required Map<String, dynamic> args,
//     required JsonWidgetRegistry registry,
//     List<JsonWidgetModel>? children,
//   }) {
//     return JsonWidgetModel.fromDynamic(
//       {
//         'type': type,
//         'args': args,
//         'children': children?.map((e) => e.toJson()).toList(),
//       },
//       registry: registry,
//     )!;
//   }

//   @override
//   Widget buildCustom({
//     ChildWidgetBuilder? childBuilder,
//     required BuildContext context,
//     required JsonWidgetData data,
//     Key? key,
//   }) {
//     Widget? title;
//     Widget? subtitle;

//     if (data.jsonWidgetChildren?.isNotEmpty == true) {
//       title = data.jsonWidgetChildren![0].build(
//         childBuilder: childBuilder,
//         context: context,
//       );
//       if (data.jsonWidgetChildren!.length > 1) {
//         subtitle = data.jsonWidgetChildren![1].build(
//           childBuilder: childBuilder,
//           context: context,
//         );
//       }
//     }

//     return UberRadioListTile<String>(
//       key: key,
//       value: data.jsonWidgetArgs['value'] ?? '',
//       groupValue: data.jsonWidgetArgs['groupValue'],
//       onChanged: (value) {
//         // Handle radio selection
//         print('Radio list tile selected: $value');
//       },
//       title: title ?? Text(data.jsonWidgetArgs['title'] ?? ''),
//       subtitle: subtitle ?? (data.jsonWidgetArgs['subtitle'] != null ? Text(data.jsonWidgetArgs['subtitle']) : null),
//       enabled: data.jsonWidgetArgs['enabled'] ?? true,
//       semanticLabel: data.jsonWidgetArgs['semanticLabel'],
//     );
//   }
// }