# flutter_ui_component — Copilot Instructions

A Flutter package providing reusable UI components inspired by the Uber Base Design System, with JSON-driven rendering capabilities.

## Tech Stack

- Flutter >= 3.27.0, Dart >= 3.5.0
- Material 3 with custom `UberTheme` (light + dark)
- `json_dynamic_widget` for JSON-driven UI rendering
- `golden_toolkit` for visual regression tests

## Theme System

Single source of truth: `lib/src/theme/uber_theme.dart`

- `UberColorTokens` — static color constants (grayscale, green, blue, red, yellow)
- `UberTypography` — Material 3 type scale (display, headline, title, body, label)
- `UberTheme` — `lightTheme` and `darkTheme` with component themes

**Never hardcode colors or text styles in widgets.** Always use `UberColorTokens`, `Theme.of(context).colorScheme`, or `Theme.of(context).textTheme`.

## Widget Conventions

All custom widgets MUST follow this pattern:

- Class prefix: `Uber` (e.g., `UberElevatedButton`)
- File name: `uber_<snake_case>.dart` in `lib/src/widgets/`
- Size enum: `Uber<Widget>Size { small, medium, large }`
- Variant enum: `Uber<Widget>Variant { primary, secondary, destructive }`
- Include `semanticLabel` parameter for accessibility (TalkBack / VoiceOver)
- Include `enabled` state support
- Use `const` constructors where possible
- Export new widgets via `lib/flutter_ui_component.dart`

## Accessibility (WCAG 2 AA Required)

This is a mobile-only package (Android + iOS). All widgets must meet WCAG 2 AA:

- Every interactive widget must have a `semanticLabel` or `Semantics` wrapper
- Touch targets minimum 48x48 dp
- Color contrast >= 4.5:1 for normal text, >= 3:1 for large text
- Information must not be conveyed by color alone
- Respect `AccessibilityFeatures.reduceMotion`
- Use proper `Semantics` roles: `button`, `header`, `textField`
- State changes must be announced (`enabled`, `selected`, `liveRegion`)

## Code Style

- Follow `flutter_lints` rules (`analysis_options.yaml`)
- Prefer `EdgeInsets.symmetric` / `.only` over `.fromLTRB`
- Prefer `const` wherever possible
- Use `Theme.of(context)` for all colors and typography
- No hardcoded hex colors in widget files

## Available Components

When generating screens or composing UI, reuse these existing widgets instead of raw Material widgets:

| Widget | Type Key (JSON) | Use For |
|--------|-----------------|---------|
| `UberElevatedButton` | `uber_elevated_button` | Primary action buttons |
| `UberTextButton` | `uber_text_button` | Secondary/link-style buttons |
| `UberTextInput` | `uber_text_input` | Text, email, password, multiline inputs |
| `UberAmountInput` | `uber_amount_input` | Currency/numeric inputs |
| `UberRadio` | `uber_radio` | Radio buttons |
| `UberRadioListTile` | `uber_radio_list_tile` | Radio with title/subtitle |

## Commits

Use conventional commits:
```
feat(widgets): add UberCheckbox component
fix(theme): correct dark mode contrast for error state
```

## Widget Development Rules

When creating or modifying widgets, these rules are **non-negotiable**:

1. **No hardcoded colors** — use `Theme.of(context).colorScheme`, never `Color(0xFF...)` or `Colors.*`
2. **No hardcoded text styles** — use `Theme.of(context).textTheme`, never inline `TextStyle(fontSize: ...)`
3. **No hardcoded strings** — all labels, hints, error text come from constructor parameters
4. **No hardcoded sizes** — centralize in getters driven by the size enum, no magic numbers in `build()`
5. **No hardcoded icons** — accept icons as `Widget?` parameters (`prefixIcon`, `suffixIcon`)
6. **No third-party UI libraries** — build on Flutter SDK only (`ElevatedButton`, `InkWell`, `AnimatedContainer`, etc.)
7. **Respect reduced motion** — check `MediaQuery.of(context).accessibleNavigation` for animation durations
8. **Light + dark via theme** — never branch on `Brightness` manually, use `colorScheme` which handles both

Only dependencies already in `pubspec.yaml` are allowed. Adding a new one requires explicit approval.

## Reference Files

- `Agent.md` — LLM guide for JSON-driven UI generation
- `design_agent.md` — Figma JSON to Flutter code generator
- `skills/accessibility/SKILL.md` — Detailed WCAG audit workflow
- `skills/material-theming/SKILL.md` — Theme system guidance
- `skills/widget-development/SKILL.md` — Full widget development guidelines
- `skills/testing/SKILL.md` — Complete test suite guidelines (functionality, golden, a11y, interaction)
