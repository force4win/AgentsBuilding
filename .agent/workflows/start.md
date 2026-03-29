---
description: Syncs the agent with the current project state, MD files, and context.
---
# Resume Development (Universal)
Activation: Manual (/start)

## Steps
1. **Initial Scan**: Read `README.md` to identify the project mission and stack.
2. **Context Discovery**: Search for `.md` files in `.agent/` and the root to understand active rules, skills, and roadmaps.
3. **Context Discovery ALV**: Search for `.md` files in `.alvhere/` and load  `guideLines.md`, `handoff.md`, `PROJECT_CONTEXT.md`, `task.md`
3. **Change Analysis**: Perform a quick scan of the most recently modified files to identify the current "work-in-progress".
4. **Project Status Report**: Summarize for the user:
   - What is the current goal.
   - What was the last thing implemented.
   - What is the next logical task in the roadmap.
5. **Readiness**: Ask the user: "Should I continue with the next task from the Project Architect's roadmap or is there a change of plans?"
