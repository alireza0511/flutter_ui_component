---
name: skill-development
description: Standards for writing SKILL.md files — structure, token budget, and quality guidelines
allowed-tools: Read, Edit, Write, Glob, Grep, Bash, Agent
argument-hint: "[skill name] — e.g. 'navigation', 'state-management'"
---

# Skill Development Standards

You are writing a SKILL.md file for the `flutter_ui_component` project. Follow every rule in this document to produce skills that are effective, consistent, and token-efficient.

## Token Budget

Skills are loaded into the LLM context window on every invocation. Every line costs tokens. Write the minimum needed for correct behavior.

| Rating | Line Count | When appropriate |
|--------|-----------|------------------|
| Ideal | < 150 | Focused, single-concern skills |
| Acceptable | 150–300 | Multi-concern skills with examples |
| Needs justification | 300–500 | Complex domains (e.g., accessibility with platform matrix) |
| Too large | > 500 | Split into multiple skills or compress aggressively |

**Measure before committing:** count lines with `wc -l skills/<name>/SKILL.md`. If over budget, compress.

## Required Structure

Every SKILL.md must have these sections in order:

### 1. Frontmatter (required)

```yaml
---
name: kebab-case-name
description: One sentence — used for skill discovery, be specific
allowed-tools: Read, Edit, Write, Glob, Grep, Bash, Agent
argument-hint: "[what the user passes] — e.g. 'widget name', 'file path'"
---
```

- `description`: Write for search — include key terms a user would type to find this skill.
- `allowed-tools`: Only list tools the skill actually needs. Don't grant `Agent` unless the skill spawns subagents.
- `argument-hint`: Show format and give 1-2 examples. Omit if skill takes no arguments.

### 2. Role Statement (1-2 lines)

State what the agent becomes when this skill is active and what repo it operates on.

```markdown
You are a [role] for the `flutter_ui_component` package. When invoked, [what you do].
```

### 3. Hard Rules (required if applicable)

Non-negotiable constraints. Use imperative voice. Each rule should be:
- One sentence stating the rule
- One WRONG/CORRECT code pair (minimal — 2-4 lines each)

Do NOT list rules that are already in CLAUDE.md or another skill. Reference instead:

```markdown
> All color rules from `skills/widget-development/SKILL.md` § Hard Rules apply here.
```

### 4. Core Content

The domain-specific guidance. This is the main body. Structure varies by skill type but must follow the compression rules below.

### 5. Workflow (required)

Numbered steps the agent follows when the skill is invoked. Keep to 3-7 steps.

### 6. Checklist (required)

Markdown checkbox list of deliverables. The agent checks these before finishing.

## Compression Rules — How to Minimize Tokens

### Tables over prose

```markdown
<!-- WRONG — 6 lines of prose -->
When the Figma layout mode is VERTICAL, use a Column widget. When it is
HORIZONTAL, use a Row. When layout mode is null, use a Stack. The item
spacing maps to SizedBox between children.

<!-- CORRECT — 4 lines, scannable -->
| Figma `layoutMode` | Flutter |
|---------------------|---------|
| `VERTICAL` | `Column` |
| `HORIZONTAL` | `Row` |
| `null` | `Stack` |
```

### One example per pattern, not per variant

Show the pattern once. Don't repeat it for every variant/size/state.

```markdown
<!-- WRONG — repeating the same pattern 3 times -->
Small:  `EdgeInsets.symmetric(horizontal: 16, vertical: 8)`
Medium: `EdgeInsets.symmetric(horizontal: 20, vertical: 12)`
Large:  `EdgeInsets.symmetric(horizontal: 24, vertical: 16)`

<!-- CORRECT — table + one code snippet showing the pattern -->
| Size | H | V | Min Height |
|------|---|---|------------|
| small | 16 | 8 | 32 |
| medium | 20 | 12 | 40 |
| large | 24 | 16 | 48 |
```

### Reference, don't duplicate

If content exists in another skill or CLAUDE.md, point to it:

```markdown
See `skills/testing/SKILL.md` § Golden Tests for the golden test pattern.
```

Never copy-paste sections between skills.

### Code examples: minimal and annotated

- Show only the lines that illustrate the point — not full widget files.
- Use inline comments to explain, not paragraphs above/below.
- Max **one** WRONG/CORRECT pair per rule.
- Omit imports, boilerplate, and obvious setup unless they ARE the point.

```dart
// WRONG
color: Color(0xFF276EF1)

// CORRECT
color: Theme.of(context).colorScheme.secondary
```

Not:

```dart
import 'package:flutter/material.dart';

class MyWidget extends StatelessWidget {
  const MyWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      // Don't do this:
      color: Color(0xFF276EF1),  // hardcoded!
    );
  }
}
```

### Avoid explaining obvious things

Don't explain what Dart syntax does. Don't explain what Flutter widgets are. Only explain project-specific decisions and constraints.

### Use shorthand conventions

| Instead of | Write |
|-----------|-------|
| "the user should" | imperative: "Do X" |
| "it is important to note that" | delete — just state the fact |
| "for example, you might want to" | show the example directly |
| "make sure to always" | "Always X" or just state the rule |
| long parameter explanations | table with param, type, default, description |

## Anti-patterns — Do NOT Do These

| Anti-pattern | Why it wastes tokens | Fix |
|-------------|---------------------|-----|
| Full widget file as example | 30+ lines for one concept | Show only the relevant 3-5 lines |
| Repeating CLAUDE.md rules | Already in context | Reference: "per CLAUDE.md § Code Style" |
| Explaining Flutter basics | Reader is an LLM with Flutter knowledge | State project-specific constraints only |
| Multiple examples for one rule | Redundant after the first | One WRONG/CORRECT pair, max |
| Verbose prose between sections | Filler | Delete — headings and rules are self-explanatory |
| Listing every enum value in prose | "The variants are primary, secondary, and destructive" | Table or just reference the type |
| JSON/config examples that mirror code | Duplication | Show once in whichever form is canonical |

## Quality Checklist for a SKILL.md

- [ ] Frontmatter is complete and `description` is searchable
- [ ] Role statement is 1-2 lines
- [ ] Hard rules use WRONG/CORRECT pairs (2-4 lines each)
- [ ] No content duplicated from CLAUDE.md or other skills
- [ ] Tables used instead of prose where possible
- [ ] One code example per pattern — no variants of the same pattern
- [ ] Code examples show only relevant lines (no boilerplate)
- [ ] Workflow has 3-7 numbered steps
- [ ] Checklist covers all deliverables
- [ ] Total file is under 300 lines (or justified if over)
- [ ] `wc -l` verified before committing

## Workflow — Creating a New Skill

1. **Identify scope** — one skill = one concern. If it covers two unrelated domains, split it.
2. **Check for overlap** — read existing skills and CLAUDE.md. Reference shared content, don't duplicate.
3. **Write frontmatter** — name, description (searchable), tools, argument-hint.
4. **Write hard rules first** — the non-negotiable constraints. One WRONG/CORRECT pair each.
5. **Add core content** — tables, minimal examples, project-specific guidance.
6. **Add workflow + checklist** — how the agent executes, what it verifies.
7. **Compress** — review every line. Delete anything that doesn't change agent behavior. Run `wc -l`.
8. **Register** — add the skill to the table in both `CLAUDE.md` and `.github/copilot-instructions.md`.
