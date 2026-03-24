---
name: material-theming
description: Create and modify Material 3 themes using the UberTheme system (colors, typography, component themes, light/dark)
allowed-tools: Read, Edit, Write, Glob, Grep, Bash, Agent
argument-hint: "[action] — e.g. 'add dark mode', 'update colors', 'add component theme'"
---

# Material Theming for flutter_ui_component

You are a Material 3 theming expert for the `flutter_ui_component` package. When invoked, help the user create, modify, or extend the theme system.

## Core Standards

1. **Single Source of Truth** — `UberTheme` in `lib/src/theme/uber_theme.dart` is the only place themes are defined.
2. **ColorScheme First** — All colors flow through `ColorScheme`. Never hardcode colors in widgets.
3. **TextTheme Integration** — All typography flows through `TextTheme` via `UberTypography`.
4. **Light + Dark** — Every theme change must be applied to both `lightTheme` and `darkTheme`.
5. **Token-Based** — Use `UberColorTokens` constants, not raw hex values.

## Color System

### UberColorTokens

All color constants live in `UberColorTokens` (`lib/src/theme/uber_theme.dart`):

```
Grayscale: primary900 (#000) → primary50 (#F5F5F5)
Green:     green900 (#0E7722) → green100 (#F4FDF7)
Blue:      blue900 (#042C5C) → blue100 (#ECF4FD)
Red:       red900 (#7F1D1D) → red100 (#FEF2F2)
Yellow:    yellow900 (#92400E) → yellow100 (#FFFBEB)
System:    white, background, surface, onPrimary, onSurface, outline
```

### Adding New Colors

When the user needs a new color:

1. Add it to `UberColorTokens` as a `static const Color`
2. Follow the naming pattern: `{hue}{shade}` (e.g., `purple700`)
3. Provide the full shade scale (100-900) if it's a new hue
4. Wire it into `ColorScheme` if it maps to a semantic role

```dart
// In UberColorTokens:
static const Color purple900 = Color(0xFF4C1D95);
static const Color purple700 = Color(0xFF6D28D9);
// ... full scale
static const Color purple100 = Color(0xFFF5F3FF);
```

### ColorScheme Mapping

Light theme:
```
primary       → primary900 (black)
secondary     → blue700
tertiary      → green700
surface       → white
error         → red600
outline       → primary100 (E0E0E0)
```

Dark theme:
```
primary       → white
secondary     → blue400
tertiary      → green400
surface       → primary900 (black)
error         → red400
outline       → primary600
```

## Typography System

### UberTypography

Material 3 type scale using system defaults:

| Token | Size | Weight |
|-------|------|--------|
| `displayLarge` | 57 | w400 |
| `displayMedium` | 45 | w400 |
| `displaySmall` | 36 | w400 |
| `headlineLarge` | 32 | w400 |
| `headlineMedium` | 28 | w400 |
| `headlineSmall` | 24 | w400 |
| `titleLarge` | 22 | w500 |
| `titleMedium` | 16 | w500 |
| `titleSmall` | 14 | w500 |
| `bodyLarge` | 16 | w400 |
| `bodyMedium` | 14 | w400 |
| `bodySmall` | 12 | w400 |
| `labelLarge` | 14 | w500 |
| `labelMedium` | 12 | w500 |
| `labelSmall` | 11 | w500 |

### Adding Custom Fonts

1. Add font files to `assets/fonts/`
2. Register in `pubspec.yaml` under `flutter.fonts`
3. Update `UberTypography` to include `fontFamily`

```dart
static const TextStyle bodyLarge = TextStyle(
  fontFamily: 'UberMove',
  fontSize: 16,
  fontWeight: FontWeight.w400,
  letterSpacing: 0.15,
  height: 1.50,
);
```

## Component Themes

The theme configures these component themes:

### ElevatedButton
```dart
elevatedButtonTheme: ElevatedButtonThemeData(
  style: ElevatedButton.styleFrom(
    elevation: 0,
    shadowColor: Colors.transparent,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
    textStyle: UberTypography.labelLarge,
  ),
)
```

### TextButton
```dart
textButtonTheme: TextButtonThemeData(
  style: TextButton.styleFrom(
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
    textStyle: UberTypography.labelLarge,
  ),
)
```

### InputDecoration
```dart
inputDecorationTheme: InputDecorationTheme(
  border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
  contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
  // Light: outline color = UberColorTokens.outline
  // Dark: outline color = UberColorTokens.primary600
  // Focus: blue700 (light) / blue400 (dark), width 2
  // Error: red600 (light) / red400 (dark)
)
```

### Radio
```dart
radioTheme: RadioThemeData(
  fillColor: WidgetStateProperty.resolveWith<Color>((states) {
    if (states.contains(WidgetState.selected)) {
      return /* blue700 (light) / blue400 (dark) */;
    }
    return /* outline (light) / primary600 (dark) */;
  }),
)
```

### Adding a New Component Theme

When adding theme support for a new widget:

1. Define the `ThemeData` extension in both `lightTheme` and `darkTheme`
2. Use `UberColorTokens` for all color values
3. Use `UberTypography` for all text styles
4. Ensure the widget reads from theme: `Theme.of(context)`

```dart
// Example: Adding AppBar theme
appBarTheme: AppBarThemeData(
  backgroundColor: UberColorTokens.surface,  // or primary900 for dark
  foregroundColor: UberColorTokens.onSurface,
  elevation: 0,
  titleTextStyle: UberTypography.titleLarge.copyWith(
    color: UberColorTokens.onSurface,
  ),
),
```

## Spacing System

The project uses direct values for spacing. Recommended spacing scale:

| Name | Value | Usage |
|------|-------|-------|
| `xs` | 4 | Tight internal spacing |
| `sm` | 8 | Default internal spacing |
| `md` | 16 | Between related elements |
| `lg` | 24 | Between sections |
| `xl` | 32 | Page margins, major sections |
| `xxl` | 48 | Hero spacing |

### EdgeInsets Preferences

```dart
// PREFER .symmetric and .only
EdgeInsets.symmetric(horizontal: 24, vertical: 16)
EdgeInsets.only(left: 16, top: 8)

// AVOID .fromLTRB (hard to read)
EdgeInsets.fromLTRB(16, 8, 16, 8)  // use symmetric instead

// USE .all for uniform padding
EdgeInsets.all(16)
```

## Quick Reference

### When to modify UberColorTokens
- Adding a new brand color or color palette
- The design system introduces new semantic colors

### When to modify UberTypography
- Changing the font family
- Adjusting the type scale
- Adding custom text styles beyond Material 3 defaults

### When to modify UberTheme
- Changing how colors map to Material `ColorScheme` roles
- Adding/modifying component themes (buttons, inputs, cards, etc.)
- Adjusting elevation, shape, or motion defaults

### Theme Usage in Widgets
```dart
// Access colors
final colorScheme = Theme.of(context).colorScheme;
final primaryColor = colorScheme.primary;

// Access typography
final textTheme = Theme.of(context).textTheme;
final headlineStyle = textTheme.headlineMedium;

// Access specific component theme
final buttonStyle = Theme.of(context).elevatedButtonTheme.style;
```
