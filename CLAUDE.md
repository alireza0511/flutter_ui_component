# flutter_ui_component

A Flutter package providing reusable UI components inspired by the Uber Base Design System, with JSON-driven rendering capabilities.

## Repository Structure

```
├── CLAUDE.md                    ← You are here
├── lib/
│   ├── flutter_ui_component.dart   ← Package exports
│   └── src/
│       ├── theme/
│       │   └── uber_theme.dart     ← UberColorTokens, UberTypography, UberTheme
│       ├── widgets/
│       │   ├── uber_elevated_button.dart
│       │   ├── uber_text_button.dart
│       │   ├── uber_text_input.dart
│       │   ├── uber_amount_input.dart
│       │   ├── uber_radio.dart
│       │   └── account_list/       ← Account selection feature
│       └── json/                   ← JSON widget builders
├── skills/
│   ├── accessibility/
│   │   └── SKILL.md                ← WCAG audit & remediation
│   ├── material-theming/
│   │   └── SKILL.md                ← Theme system guidance
│   ├── widget-development/
│   │   └── SKILL.md                ← UI component development rules
│   └── testing/
│       └── SKILL.md                ← Test suite generation
├── test/                           ← Unit & widget tests
├── example/                        ← Example app
└── docs/                           ← Documentation
```

## Skills

Skills are specialized prompts that provide domain expertise. Invoke them by reading the relevant `SKILL.md` file and following its instructions.

| Skill | Path | Description |
|-------|------|-------------|
| `accessibility` | `skills/accessibility/SKILL.md` | WCAG 2 AA audit & remediation (mobile) |
| `material-theming` | `skills/material-theming/SKILL.md` | Theme system creation & modification |
| `widget-development` | `skills/widget-development/SKILL.md` | Build widgets from description, Figma JSON, or design docs + JSON widget system |
| `testing` | `skills/testing/SKILL.md` | Complete test suites: functionality, golden, a11y, interaction |

### Adding a New Skill

1. Create `skills/<skill-name>/SKILL.md` with frontmatter:
   ```yaml
   ---
   name: skill-name
   description: One-line description
   allowed-tools: Read, Edit, Write, Glob, Grep, Bash, Agent
   argument-hint: "[optional] usage hint"
   ---
   ```
2. Add the skill to the table above
3. Write the skill content with: core standards, workflow, project-specific guidance

## Tech Stack

- **Flutter** >= 3.27.0, **Dart** >= 3.5.0
- **Material 3** with `UberTheme` (light + dark)
- **json_dynamic_widget** for JSON-driven UI rendering
- **golden_toolkit** for visual regression tests

## Architecture

### Theme System

Single source of truth in `lib/src/theme/uber_theme.dart`:
- `UberColorTokens` — static color constants (grayscale, green, blue, red, yellow)
- `UberTypography` — Material 3 type scale
- `UberTheme` — `lightTheme` and `darkTheme` with component themes

### Widget Conventions

All custom widgets follow this pattern:
- Prefix: `Uber` (e.g., `UberElevatedButton`)
- Files: `uber_<snake_case>.dart` in `lib/src/widgets/`
- Enums for size: `Uber<Widget>Size { small, medium, large }`
- Enums for variant: `Uber<Widget>Variant { primary, secondary, destructive }`
- Required `semanticLabel` parameter for accessibility
- Support `enabled` state
- Use `UberColorTokens` and theme — no hardcoded colors
- Export via `lib/flutter_ui_component.dart`

### JSON Widget System

Components register as JSON builders via `UberJsonWidgetBuilders` for dynamic rendering. Types: `uber_text_button`, `uber_elevated_button`, `uber_amount_input`, `uber_text_input`, `uber_radio`, `uber_radio_list_tile`.

## Development

### Running Tests

```bash
flutter test
```

### Code Style

- Follow `flutter_lints` rules (`analysis_options.yaml`)
- Use `const` constructors where possible
- Prefer `EdgeInsets.symmetric` / `.only` over `.fromLTRB`
- Use `Theme.of(context)` — never hardcode colors or text styles in widgets

### Commits

Use conventional commits:
```
feat(widgets): add UberCheckbox component
fix(theme): correct dark mode contrast for error state
docs(skills): add testing skill
```
