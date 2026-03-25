---
name: widget-development
description: Build UI components from scratch or from Figma design JSON — no hardcoded values, use Flutter-native widgets, follow project conventions
allowed-tools: Read, Edit, Write, Glob, Grep, Bash, Agent
argument-hint: "[widget name or Figma JSON path] — e.g. 'checkbox', '/path/to/design.json'"
---

# Widget Development Guidelines

You are a Flutter widget developer for the `flutter_ui_component` package. When building new or modifying existing widgets, follow every rule in this document.

Widgets can be developed from:
1. **A description** — the user describes what they need
2. **A Figma design JSON** — the user provides a JSON file exported from Figma
3. **A design document** — the user provides a PDF, DOCX, or text description of a UI to build

## Hard Rules — Never Break These

### 1. No Hardcoded Colors

```dart
// WRONG
color: Color(0xFF276EF1)
// CORRECT
color: Theme.of(context).colorScheme.secondary
```

If a color doesn't exist in `ColorScheme`, add it to `UberColorTokens` and wire it through `UberTheme`.

### 2. No Hardcoded Text Styles

```dart
// WRONG
style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500)
// CORRECT
style: Theme.of(context).textTheme.titleMedium
```

Use `.copyWith()` on a theme style for minor overrides.

### 3. No Hardcoded Strings / Labels

```dart
// WRONG
Text('Submit')
// CORRECT — passed via constructor
Text(widget.label)
```

Error messages, placeholders, labels, and button text must all be configurable.

### 4. No Hardcoded Sizes

Sizes, padding, and spacing must be derived from the widget's size enum or theme, not magic numbers in the build method. Centralize them in computed getters.

```dart
// WRONG — magic numbers in build()
padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
// CORRECT — centralized in getters driven by size enum
EdgeInsets get _padding => switch (widget.size) { ... };
```

### 5. Flutter-Native Only — No Third-Party UI Libraries

Use only Flutter SDK widgets as building blocks. Only dependencies already in `pubspec.yaml` are allowed. Adding a new dependency requires explicit user approval.

### 6. No Hardcoded Icons

```dart
// WRONG
Icon(Icons.error, color: Colors.red)
// CORRECT
final Widget? prefixIcon;  // accept as parameter
```

## Widget Structure

### File & Class Naming

```
File:    lib/src/widgets/uber_<snake_case>.dart
Class:   Uber<PascalCase>
Size:    Uber<Widget>Size { small, medium, large }
Variant: Uber<Widget>Variant { primary, secondary, destructive }
```

### Required Constructor Pattern

Every widget must include: `super.key`, required functional params, configuration (size/variant with defaults), state (`enabled`, `isLoading`), and `semanticLabel`.

```dart
class UberNewWidget extends StatefulWidget {
  const UberNewWidget({
    super.key,
    required this.onPressed,
    required this.child,
    this.size = UberNewWidgetSize.medium,
    this.variant = UberNewWidgetVariant.primary,
    this.enabled = true,
    this.isLoading = false,
    this.semanticLabel,
  });
  // ... fields, createState()
}
```

### State, Semantics, Animation

Use `StatefulWidget` with internal hover/press tracking and centralized style getters. Wrap widget root in `Semantics`. Use `AnimatedContainer` for transitions and respect `reduceMotion`.

For full patterns, read `skills/widget-development/reference.md` § State Management Pattern, § Semantics Example, § Animation Example.

### Light + Dark Theme Support

Never branch on brightness manually. Just use `Theme.of(context).colorScheme` — the theme system handles light/dark mapping.

```dart
// WRONG
final isDark = Theme.of(context).brightness == Brightness.dark;
// CORRECT
final color = Theme.of(context).colorScheme.onSurface;
```

## Building from Figma Design JSON

When the user provides a Figma JSON file path, read and parse it to generate the widget.

### Step 1 — Read & Classify

| Signal | Classification |
|--------|---------------|
| Root type is `COMPONENT` or `COMPONENT_SET` | **UI Element** |
| Root `FRAME` at device size (360-430 x 640-932) | **Screen** |
| Name matches `*Button*`, `*Input*`, `*Card*`, etc. | **UI Element** |
| Name matches `*Screen*`, `*Page*`, `*View*`, etc. | **Screen** |
| Default | **UI Element** |

### Step 2 — Map Figma Properties to Flutter

Key mappings (brief):
- `layoutMode: "VERTICAL"` -> `Column`, `"HORIZONTAL"` -> `Row`, `null` -> `Stack`
- `itemSpacing` -> `SizedBox` between children
- `padding*` -> `EdgeInsets`
- Colors -> map RGBA floats to `colorScheme` roles, never hex
- Typography -> map fontSize+fontWeight to `textTheme` tokens
- Corner radius -> `BorderRadius.circular(N)`
- Effects -> `BoxShadow` with `Theme.of(context).shadowColor`

For full mapping tables, read `skills/widget-development/reference.md` § Figma JSON Mapping Tables.

### Step 3 — Match Existing Components (for Screens)

| Figma Child Pattern | Use This Widget |
|---------------------|-----------------|
| Filled rect + centered text + tap | `UberElevatedButton` |
| Transparent + colored text + tap | `UberTextButton` |
| Rounded rect + placeholder + input | `UberTextInput` |
| Currency symbol + numeric input | `UberAmountInput` |
| Circle indicator + label + group | `UberRadio` / `UberRadioListTile` |
| None of the above | Build with Flutter primitives |

### Step 4 — Generate Widget Code

Apply **all Hard Rules**: colors from theme, typography from textTheme, spacing from size enum getters, labels from constructor params. Extract size variants from Figma component sets.

For a complete example walkthrough, read `skills/widget-development/reference.md` § Figma JSON Example Walkthrough.

## Available Component Library

Widgets: `UberElevatedButton`, `UberTextButton`, `UberTextInput`, `UberAmountInput`, `UberRadio<T>`, `UberRadioListTile<T>`.

When building Screens, reuse these instead of raw Material widgets for any matching pattern.

For full API reference (constructors, params, size tables, Figma detection heuristics), read `skills/widget-development/reference.md` § Component Library.

## JSON Widget System

This package supports JSON-driven UI rendering via `json_dynamic_widget`. Every widget must also be registered as a JSON builder.

### Registered JSON Types

| Widget | JSON Type |
|--------|-----------|
| `UberTextButton` | `uber_text_button` |
| `UberElevatedButton` | `uber_elevated_button` |
| `UberAmountInput` | `uber_amount_input` |
| `UberTextInput` | `uber_text_input` |
| `UberRadio` | `uber_radio` |
| `UberRadioListTile` | `uber_radio_list_tile` |

### JSON Structure

```json
{ "type": "<json_type>", "args": { "label": "...", "variant": "primary", "size": "medium" } }
```

Layout types: `column`, `row`, `container`, `sized_box`, `wrap`, `expanded`, `padding`.

### Registering a New JSON Builder

1. Create builder class in `lib/src/json/` with `type`, `fromDynamic`, and `buildCustom`
2. Register in `UberJsonWidgetBuilders.builders`

For full JSON args reference and builder registration code, read `skills/widget-development/reference.md` § JSON Component Args Reference, § Registering a New Widget as JSON Builder.

## Export

After creating a new widget, add the export to `lib/flutter_ui_component.dart`:

```dart
export 'src/widgets/uber_new_widget.dart';
```

## Checklist Before Done

**Hard Rules:**
- [ ] No hardcoded colors, text styles, strings, sizes, or icons
- [ ] No third-party UI dependencies

**Structure:**
- [ ] `semanticLabel` param, `enabled` state, size enum, variant enum (if applicable)
- [ ] `AnimatedContainer` transitions, respects `reduceMotion`
- [ ] Light + dark theme via `colorScheme`
- [ ] Exported in `lib/flutter_ui_component.dart`
- [ ] File naming: `uber_<name>.dart`

**JSON Widget System:**
- [ ] JSON builder in `lib/src/json/`, registered in `UberJsonWidgetBuilders.builders`
- [ ] JSON args match constructor params, type follows `uber_<snake_case>`

**Figma JSON (when building from design):**
- [ ] JSON read and classified (UI Element vs Screen)
- [ ] Colors -> `colorScheme`, typography -> `textTheme`, spacing -> size enum getters
- [ ] Figma text replaced with constructor params, existing widgets reused for screens
