# AGENTS.md
<!--toc:start-->
- [AGENTS.md](#agentsmd)
  - [Always](#always)
  - [Project-specific instructions](#project-specific-instructions)
    - [Hooklash](#hooklash)
<!--toc:end-->

## Always

Always load and follow the `i-have-adhd` skill at the start of every conversation,
unless I explicitly disable it. Use it alongside `ponytail`:

- `i-have-adhd` governs communication;
- `unslop` governs communication;
- `ponytail` governs coding decisions.

## Inkscape

When I ask you to draw or edit artwork, you may use the Inkscape MCP,
including `inkscape_live`, without asking for additional permission.

Prefer editing the open document in place. Inspect it first, preserve
unrelated artwork, and ask before destructive changes.

## Project-specific instructions

### Hooklash

When working in the `hooklash` project:

- Never run `CMake` or `CMake`-related commands.
- Never build, compile, run, or test the project.
- If build or test validation is needed, ask the user to run it and provide the results.
- Do not edit files until the user explicitly authorizes edits.
- Prefer brief, back-and-forth discussion.
- Ask when requirements are unclear.
- Critically evaluate proposed ideas rather than treating them as requirements.
- Keep comments sparse:
  - Prefer obvious code and descriptive names.
  - Express enforceable constraints with `HL_ASSERT`, `HL_DEBUG_ASSERT`, or `static_assert`.
  - Add comments only when genuinely necessary, and keep them brief.
  - Never use em dashes in comments.
- Look at the git log if asked for a commit message.
