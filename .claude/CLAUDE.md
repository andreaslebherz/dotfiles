# Global Directives

## Core Communication
- Keep interactions and commit messages ultra-concise. Telegraphic style; prioritize absolute brevity; sacrifice grammar.
- If ambiguous, stop and ask for clarification. Do not guess.

## General Code Style
- Prioritize readability and maintainability over micro-optimizations.
- Never refactor unrelated code outside the scope of the current task.

## Documentation
- Write 'why' comments, not 'what' comments. Explain reasoning; do not narrate code mechanics.
- Mandate Doxygen-style block comments (/** ... */) with @brief tag for all declarations (functions, namespaces, templates). 
- Require explicit @tparam tags for template parameters; prohibit unstructured header comments.

## Dependency Management
- Zero unauthorized dependencies. Never introduce external libraries without explicit permission.
- Always attempt to solve using the language standard library or existing project dependencies.

## Workflow and State
- Plan before coding: Output brief, step-by-step plan for multi-file/complex tasks. Wait for approval before implementation.
- Match existing conventions: Mimic surrounding code style, naming, and file structure, even if contradicting general best practices. Consistency overrides isolated perfection.

## Plans
- At the end of each plan, list unresolved questions concisely. Sacrifice grammar for brevity.
