# flutter_ui_component — Copilot Instructions

A Flutter package providing reusable UI components inspired by the Uber Base Design System, with JSON-driven rendering capabilities.

## Tech Stack

- Flutter >= 3.27.0, Dart >= 3.5.0
- Material 3 with custom `UberTheme` (light + dark)
- `json_dynamic_widget` for JSON-driven UI rendering
- `golden_toolkit` for visual regression tests

## Code Style

- Follow `flutter_lints` rules (`analysis_options.yaml`)
- Prefer `EdgeInsets.symmetric` / `.only` over `.fromLTRB`
- Prefer `const` wherever possible
- Use `Theme.of(context)` for all colors and typography — no hardcoded hex colors
- Use conventional commits: `feat(widgets): add UberCheckbox component`

## Skills — Detailed Guidelines

For detailed rules, patterns, and workflows, refer to the skill files. These are the source of truth:

| Skill | Path | When to read |
|-------|------|--------------|
| **Widget Development** | `skills/widget-development/SKILL.md` | Building or modifying any widget, Figma JSON to code, JSON widget system |
| **Accessibility** | `skills/accessibility/SKILL.md` | Any accessibility work — WCAG 2 AA (required), mobile semantics, TalkBack/VoiceOver |
| **Material Theming** | `skills/material-theming/SKILL.md` | Adding colors, typography, component themes to `UberTheme` |
| **Testing** | `skills/testing/SKILL.md` | Writing tests — functionality, golden, a11y, interaction |
