# Project-specific instructions

When working in the `hooklash` project:

- Never run CMake or CMake-related commands.
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
