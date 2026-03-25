# Widget Development — Reference

## State Management Pattern

Use `StatefulWidget` with internal hover/press tracking:

```dart
class _UberNewWidgetState extends State<UberNewWidget> {
  bool _isHovered = false;
  bool _isPressed = false;

  // Centralized style getters — all driven by theme + enums
  Color _backgroundColor(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final base = switch (widget.variant) {
      UberNewWidgetVariant.primary     => colorScheme.primary,
      UberNewWidgetVariant.secondary   => colorScheme.secondary,
      UberNewWidgetVariant.destructive => colorScheme.error,
    };

    if (!widget.enabled) return base.withOpacity(0.12);
    if (_isPressed) return base.withOpacity(0.8);
    if (_isHovered) return base.withOpacity(0.9);
    return base;
  }

  TextStyle? _textStyle(BuildContext context) {
    return switch (widget.size) {
      UberNewWidgetSize.small  => Theme.of(context).textTheme.labelMedium,
      UberNewWidgetSize.medium => Theme.of(context).textTheme.labelLarge,
      UberNewWidgetSize.large  => Theme.of(context).textTheme.titleMedium,
    };
  }
}
```

## Semantics Example

Wrap the widget root in `Semantics` for TalkBack/VoiceOver:

```dart
@override
Widget build(BuildContext context) {
  return Semantics(
    label: widget.semanticLabel,
    button: true,  // set appropriate role
    enabled: widget.enabled,
    child: /* ... */,
  );
}
```

## Animation Example

Use `AnimatedContainer` or `AnimatedDefaultTextStyle` for state transitions. Keep durations consistent:

```dart
AnimatedContainer(
  duration: const Duration(milliseconds: 150),
  curve: Curves.easeInOut,
  // ...
)
```

Respect reduced motion:

```dart
final reduceMotion = MediaQuery.of(context).accessibleNavigation;
final duration = reduceMotion
    ? Duration.zero
    : const Duration(milliseconds: 150);
```

## Figma JSON Mapping Tables

### Layout

| Figma | Flutter |
|-------|---------|
| `layoutMode: "VERTICAL"` | `Column` |
| `layoutMode: "HORIZONTAL"` | `Row` |
| `layoutMode: null` | `Stack` |
| `itemSpacing: N` | `SizedBox(height: N)` or `SizedBox(width: N)` between children |
| `paddingLeft/Right/Top/Bottom` | `EdgeInsets.only(...)` or `.symmetric(...)` |

### Alignment

| Figma `primaryAxisAlignItems` | Flutter `MainAxisAlignment` |
|------|---------|
| `MIN` | `.start` |
| `CENTER` | `.center` |
| `MAX` | `.end` |
| `SPACE_BETWEEN` | `.spaceBetween` |

| Figma `counterAxisAlignItems` | Flutter `CrossAxisAlignment` |
|------|---------|
| `MIN` | `.start` |
| `CENTER` | `.center` |
| `MAX` | `.end` |
| `STRETCH` | `.stretch` |

### Sizing

| Figma | Flutter |
|-------|---------|
| `primaryAxisSizingMode: "AUTO"` / `"HUG"` | `MainAxisSize.min` |
| `primaryAxisSizingMode: "FIXED"` | `MainAxisSize.max` or explicit `SizedBox` |
| `counterAxisSizingMode: "FIXED"` | `SizedBox(width: N)` or `SizedBox(height: N)` |

### Colors — Map to Theme, Not Hex

Figma colors are RGBA floats (0.0–1.0). **Do NOT convert to hardcoded `Color()` values.** Map to the closest `UberColorTokens` or `ColorScheme` role:

| Figma Color (approx.) | Map To |
|------------------------|--------|
| `r:0, g:0, b:0` (black) | `colorScheme.primary` (light) / `colorScheme.onSurface` |
| `r:1, g:1, b:1` (white) | `colorScheme.surface` / `colorScheme.onPrimary` |
| `r:0.96, g:0.96, b:0.96` (light gray) | `colorScheme.surfaceContainerHighest` |
| `r:0.88, g:0.88, b:0.88` (border gray) | `colorScheme.outline` |
| `r:0.15, g:0.33, b:0.64` (blue) | `colorScheme.secondary` |
| `r:0.93, g:0.27, b:0.27` (red) | `colorScheme.error` |

If a Figma color doesn't match any existing token, ask the user before adding a new one to `UberColorTokens`.

### Typography — Map to TextTheme, Not Raw Sizes

| Figma fontSize + fontWeight | Map To |
|-----------------------------|--------|
| 57px, w400 | `textTheme.displayLarge` |
| 45px, w400 | `textTheme.displayMedium` |
| 36px, w400 | `textTheme.displaySmall` |
| 32px, w400 | `textTheme.headlineLarge` |
| 28px, w400 | `textTheme.headlineMedium` |
| 24px, w400 | `textTheme.headlineSmall` |
| 22px, w500 | `textTheme.titleLarge` |
| 16px, w500 | `textTheme.titleMedium` |
| 14px, w500 | `textTheme.titleSmall` |
| 16px, w400 | `textTheme.bodyLarge` |
| 14px, w400 | `textTheme.bodyMedium` |
| 12px, w400 | `textTheme.bodySmall` |
| 14px, w500 | `textTheme.labelLarge` |
| 12px, w500 | `textTheme.labelMedium` |
| 11px, w500 | `textTheme.labelSmall` |

If the Figma text doesn't match exactly, use the closest token with `.copyWith()`.

### Corner Radius

```dart
// Figma: "cornerRadius": 8
BorderRadius.circular(8)

// Figma: individual corners "rectangleCornerRadii": [8, 8, 0, 0]
BorderRadius.only(
  topLeft: Radius.circular(8),
  topRight: Radius.circular(8),
)
```

### Effects

```dart
// Figma: DROP_SHADOW { color: {r:0,g:0,b:0,a:0.1}, offset: {x:0,y:2}, radius: 4 }
BoxShadow(
  color: Theme.of(context).shadowColor.withOpacity(0.1), // NOT hardcoded Color
  offset: const Offset(0, 2),
  blurRadius: 4,
)
```

## Figma JSON Example Walkthrough

Given this Figma JSON for a card component:

```json
{
  "type": "COMPONENT",
  "name": "InfoCard",
  "cornerRadius": 12,
  "layoutMode": "VERTICAL",
  "itemSpacing": 8,
  "paddingLeft": 16, "paddingRight": 16,
  "paddingTop": 12, "paddingBottom": 12,
  "fills": [{ "type": "SOLID", "color": { "r": 1, "g": 1, "b": 1, "a": 1 } }],
  "effects": [{ "type": "DROP_SHADOW", "color": { "r": 0, "g": 0, "b": 0, "a": 0.08 }, "offset": { "x": 0, "y": 1 }, "radius": 3 }],
  "children": [
    { "type": "TEXT", "name": "Title", "characters": "Card Title", "style": { "fontSize": 16, "fontWeight": 500 } },
    { "type": "TEXT", "name": "Description", "characters": "Some description text", "style": { "fontSize": 14, "fontWeight": 400 } }
  ]
}
```

**Classification:** UI Element (root is `COMPONENT`, shallow hierarchy)

**Generated widget** (following all Hard Rules):

```dart
class UberInfoCard extends StatelessWidget {
  const UberInfoCard({
    super.key,
    required this.title,       // NOT hardcoded "Card Title"
    required this.description, // NOT hardcoded "Some description text"
    this.onTap,
    this.semanticLabel,
  });

  final String title;
  final String description;
  final VoidCallback? onTap;
  final String? semanticLabel;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Semantics(
      label: semanticLabel,
      child: Material(
        color: colorScheme.surface,         // NOT Color(0xFFFFFFFF)
        borderRadius: BorderRadius.circular(12),
        elevation: 1,
        shadowColor: colorScheme.shadow,    // NOT Color.fromRGBO(0,0,0,0.08)
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(12),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(title, style: textTheme.titleMedium),   // NOT TextStyle(fontSize: 16, fontWeight: w500)
                const SizedBox(height: 8),
                Text(description, style: textTheme.bodyMedium), // NOT TextStyle(fontSize: 14, fontWeight: w400)
              ],
            ),
          ),
        ),
      ),
    );
  }
}
```

Notice: every Figma value mapped to theme — zero hardcoded colors, fonts, or labels.

## Component Library

When building **Screens** or composing UI, you MUST reuse these existing widgets instead of raw Material widgets for any matching UI pattern.

### UberElevatedButton

Primary action button with elevation.

```dart
UberElevatedButton(
  onPressed: () {},
  child: Text('Label'),
  size: UberElevatedButtonSize.medium,       // small | medium | large
  variant: UberElevatedButtonVariant.primary, // primary | secondary | destructive
  isLoading: false,
  enabled: true,
  fullWidth: false,
  semanticLabel: 'Submit',
)
```

| Size | Padding | Min Height |
|------|---------|------------|
| `small` | H:16 V:8 | 32 |
| `medium` | H:20 V:12 | 40 |
| `large` | H:24 V:16 | 48 |

### UberTextButton

Lightweight text-only button for secondary actions.

```dart
UberTextButton(
  onPressed: () {},
  child: Text('Cancel'),
  size: UberTextButtonSize.medium,
  variant: UberTextButtonVariant.primary,
  isLoading: false,
  enabled: true,
  fullWidth: false,
  semanticLabel: 'Cancel',
)
```

### UberTextInput

General-purpose text input field.

```dart
UberTextInput(
  onChanged: (value) {},
  label: 'Email',
  hintText: 'Enter email',
  helperText: null,
  errorText: null,
  enabled: true,
  type: UberTextInputType.text,  // text | email | password | multiline
  maxLength: null,
  maxLines: null,
  minLines: null,
  prefixIcon: null,
  suffixIcon: null,
  validator: null,
  semanticLabel: null,
  initialValue: null,
  controller: null,
  focusNode: null,
  autofocus: false,
  textAlign: TextAlign.start,
  textCapitalization: TextCapitalization.none,
  inputFormatters: null,
)
```

**Input type detection from Figma:**

| Figma Clue | UberTextInputType |
|------------|-------------------|
| Name/placeholder contains "email" | `email` |
| Name contains "password" or has `***` | `password` |
| Height > 100 or name contains "description"/"comment"/"message" | `multiline` |
| Default | `text` |

### UberAmountInput

Specialized currency/numeric input.

```dart
UberAmountInput(
  onChanged: (value) {},
  label: 'Amount',
  hintText: 'Enter amount',
  helperText: null,
  errorText: null,
  enabled: true,
  currency: '\$',
  maxDecimalPlaces: 2,
  maxAmount: null,
  minAmount: null,
  semanticLabel: null,
  initialValue: null,
  controller: null,
  focusNode: null,
  autofocus: false,
  textAlign: TextAlign.start,
)
```

**Use when:** Figma input shows a currency symbol prefix (`$`, `EUR`, `GBP`) or name contains "amount", "price", "cost", "payment", "balance".

### UberRadio\<T\> / UberRadioListTile\<T\>

Single selection radio buttons.

```dart
// Basic radio
UberRadio<String>(
  value: 'option1',
  groupValue: selectedValue,
  onChanged: (val) {},
  enabled: true,
  semanticLabel: 'Option 1',
)

// Radio with title and subtitle
UberRadioListTile<String>(
  value: 'option1',
  groupValue: selectedValue,
  onChanged: (val) {},
  title: Text('Option 1'),
  subtitle: Text('Description'),
  enabled: true,
  contentPadding: null,
  semanticLabel: 'Option 1',
)
```

## JSON Component Args Reference

### uber_elevated_button / uber_text_button

```json
{
  "type": "uber_elevated_button",
  "args": {
    "label": "Submit",
    "variant": "primary",
    "size": "large",
    "onPressed": "submit_form",
    "isLoading": false,
    "enabled": true,
    "fullWidth": true,
    "semanticLabel": "Submit the form"
  }
}
```

### uber_text_input

```json
{
  "type": "uber_text_input",
  "args": {
    "label": "Email",
    "hintText": "you@example.com",
    "type": "email",
    "maxLength": 50,
    "maxLines": null,
    "minLines": null,
    "textCapitalization": "none",
    "textAlign": "start",
    "semanticLabel": "Enter your email"
  }
}
```

### uber_amount_input

```json
{
  "type": "uber_amount_input",
  "args": {
    "label": "Amount",
    "hintText": "Enter amount",
    "currency": "$",
    "minAmount": 1,
    "maxAmount": 10000,
    "maxDecimalPlaces": 2,
    "semanticLabel": "Enter payment amount"
  }
}
```

### uber_radio_list_tile

```json
{
  "type": "uber_radio_list_tile",
  "args": {
    "value": "option1",
    "groupValue": "option1",
    "title": "Option Title",
    "subtitle": "Option description",
    "semanticLabel": "Select option 1"
  }
}
```

### Layout Widgets in JSON

Use standard Flutter layout widgets to structure JSON-driven UIs:

```json
{
  "type": "column",
  "args": {
    "crossAxisAlignment": "stretch",
    "mainAxisSize": "min"
  },
  "children": [
    { "type": "uber_text_input", "args": { "label": "Name", "hintText": "Full name" } },
    { "type": "sized_box", "args": { "height": 16 } },
    { "type": "uber_text_input", "args": { "label": "Email", "type": "email" } },
    { "type": "sized_box", "args": { "height": 24 } },
    { "type": "uber_elevated_button", "args": { "label": "Submit", "fullWidth": true } }
  ]
}
```

Available layout types: `column`, `row`, `container`, `sized_box`, `wrap`, `expanded`, `padding`.

## Registering a New Widget as JSON Builder

When creating a new widget, also register it for JSON rendering:

1. Create a builder class in `lib/src/json/`:

```dart
class UberNewWidgetBuilder extends JsonWidgetBuilder {
  const UberNewWidgetBuilder({required super.args});

  static const type = 'uber_new_widget';

  static UberNewWidgetBuilder fromDynamic(dynamic map, {JsonWidgetRegistry? registry}) {
    // Parse args from JSON map
    return UberNewWidgetBuilder(args: map);
  }

  @override
  Widget buildCustom({
    ChildWidgetBuilder? childBuilder,
    required BuildContext context,
    required JsonWidgetData data,
    Key? key,
  }) {
    return UberNewWidget(
      key: key,
      // Map JSON args to widget params
    );
  }
}
```

2. Register in `UberJsonWidgetBuilders.builders`:

```dart
static Map<String, JsonWidgetBuilderContainer> builders = {
  // ... existing builders
  UberNewWidgetBuilder.type: JsonWidgetBuilderContainer(
    builder: UberNewWidgetBuilder.fromDynamic,
  ),
};
```

### Action Handlers

Available actions for JSON `onPressed`:
- `"show_snackbar"` — display a confirmation message
- `"navigate_back"` — navigate to previous screen
- Custom actions can be registered as needed
