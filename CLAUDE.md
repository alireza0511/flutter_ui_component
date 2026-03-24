# flutter_ui_component

A Flutter package providing reusable UI components inspired by the Uber Base Design System, with JSON-driven rendering capabilities.

## Repository Structure

```
├── CLAUDE.md                    ← You are here
├── lib/
│   ├── flutter_ui_component.dart   ← Package exports
│   └── src/
│       ├── theme/uber_theme.dart   ← UberColorTokens, UberTypography, UberTheme
│       ├── widgets/                ← All Uber* widget files
│       └── json/                   ← JSON widget builders
├── skills/                         ← Detailed guidelines (source of truth)
│   ├── accessibility/SKILL.md
│   ├── material-theming/SKILL.md
│   ├── widget-development/SKILL.md
│   └── testing/SKILL.md
├── test/
│   ├── unit/                       ← Functionality & interaction tests
│   ├── golden/                     ← Visual regression tests
│   └── accessibility/              ← A11y guideline tests
├── example/                        ← Example app
└── docs/                           ← Documentation
```

## Skills — Source of Truth

Skills contain all detailed rules, patterns, and workflows. **Read the relevant skill before doing any work.** Do not duplicate skill content elsewhere.

| Skill | Path | When to read |
|-------|------|--------------|
| **Widget Development** | `skills/widget-development/SKILL.md` | Building or modifying any widget, Figma JSON to code, JSON widget system, component library reference |
| **Accessibility** | `skills/accessibility/SKILL.md` | Any accessibility work — WCAG 2 AA (required), mobile semantics, TalkBack/VoiceOver |
| **Material Theming** | `skills/material-theming/SKILL.md` | Adding colors, typography, component themes to `UberTheme` |
| **Testing** | `skills/testing/SKILL.md` | Writing tests — functionality, golden, a11y, interaction |

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

## Quick Reference

```bash
flutter test                              # all tests
flutter test test/unit/                   # functionality only
flutter test test/golden/                 # golden only
flutter test test/accessibility/          # a11y only
flutter test --update-goldens test/golden/ # regenerate goldens
```

Code style: `flutter_lints`, `const` constructors, `EdgeInsets.symmetric`/`.only`, `Theme.of(context)` for all colors/typography.

Commits: `feat(widgets): add UberCheckbox`, `fix(theme): correct dark mode contrast`
