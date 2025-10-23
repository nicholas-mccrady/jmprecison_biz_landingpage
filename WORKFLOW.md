WORKFLOW - jmprecison_biz_landingpage

Last updated: 2025-10-23
Author: nicholas mccrady

Purpose
- Describe the process used during this coding session so another developer or automation can pick up work.
- Enable seamless handoff between human developers and automated systems.

Quick summary (contract)
- Inputs: repository files (HTML, CSS, assets), user requests (deliverables), current branch (main).
- Outputs: 
  - `session_activity_log.txt`: Human-readable activity log
  - `WORKFLOW.md`: Process documentation
  - `state.json`: Machine-readable project state
  - `manage-state.ps1`: State management automation
  - `HANDOFF.md`: Detailed handoff guide
- Success criteria: 
  - Deliverables created and tracked in state.json
  - Todo list updated and reflected in project state
  - Files placed at repo root with proper state management
  - State can be resumed by human or automated system
- Error modes: 
  - File write permission failures
  - State file conflicts
  - Unexpected workspace layout
  - PowerShell execution policy restrictions

High-level steps
1) Receive user request and clarify deliverables.
2) Check/initialize project state using manage-state.ps1
3) Create and manage a todo list representing tasks.
4) Produce artifacts and update state after each significant change.
5) Update todo statuses and report progress.

State Management Integration
1. Before starting work:
   ```powershell
   .\manage-state.ps1 -Action status
   ```
2. After completing a task:
   ```powershell
   .\manage-state.ps1 -Action complete-task -TaskId "TASK-001" -Description "Task description"
   ```
3. State file (`state.json`) tracks:
   - Last known good state
   - Completed tasks
   - Next actions
   - Project metadata

Web project specifics
- Main files to edit: `index.html` (content), `assets/css/styles.css` (styles), `assets/img` (images).
- Quick preview: run `.\manage-state.ps1 -Action preview` to open `index.html` in your default browser.
- Typical web next actions include editing copy in `index.html`, adjusting responsive CSS in `assets/css/styles.css`, and adding/optimizing images under `assets/img`.


Detailed workflow (for future sessions)
1. Start session
   - Check out current branch and workspace.
   - Run quick repo scan (file list and key files: `index.html`, `README.md`, `assets/`).

2. Capture requirements
   - Read the user's request fully.
   - Convert into a concrete todo list with numbered tasks.
   - Mark ONE todo as in-progress.

3. Execute tasks iteratively
   - For each in-progress todo:
     a) Gather needed context (read files) using the code editor or tools.
     b) Make minimal, focused edits.
     c) Validate edits (lint/build/tests when applicable).
     d) Mark todo completed and move to the next.

4. Create documentation and handoff artifacts
   - Produce a session activity log with timestamps, files changed, and annotations.
   - Produce a workflow document capturing the steps taken and recommended next steps.

5. Finalize and report
   - Ensure all todos are completed or blocked with clear notes.
   - Commit or instruct the user to commit changes, if desired.
   - Provide a short summary of what changed and how to run/verify.

Roles and responsibilities
- Agent: gather context, create artifacts, update todos, run quick validations.
- Human (you): review changes, run deeper tests, commit and push changes to remote, make business decisions.

Triggers and when to run this workflow
- New user request to modify or document the repo.
- Preparing handoff to another developer or automation.

Acceptance criteria
- Artifacts exist at repository root: `session_activity_log.txt` and `WORKFLOW.md`.
- All todos are either "completed" or have clear blocking notes.
- No syntax errors introduced by edits (if edited files are code).

Edge cases and mitigations
- Missing workspace files: abort and ask for paths or create placeholder files.
- Permission errors writing files: report error with OS details and suggest running editor with appropriate permissions.
- Long-running build/test steps: run only quick checks and report that full CI should be run remotely.

Automation suggestions
- Add a small script `scripts/generate-session-log.js` to automatically append session entries.
- Use a CI job to run lint/tests after edits and block merges on failures.

Next steps for this session
- Mark workflow todo as completed once the user confirms they don't want further edits.
- Optionally commit the new files and push to remote branch (requires user's git credentials and consent).

State Recovery and Continuity
1. If state becomes corrupted:
   - Use git to restore last known good state
   - Check activity log for manual reconciliation
   - Resume from last completed task

2. For automated systems:
   - Poll or watch state.json for changes
   - Parse next actions array
   - Execute tasks based on priority
   - Update state via management script
   - Commit changes back to repository

3. For human developers:
   - Always check state before starting work
   - Update state after completing tasks
   - Follow handoff procedures in HANDOFF.md
   - Commit state files together

Contact and handoff notes
- This file plus `state.json` and `HANDOFF.md` are required for handoff
- See `HANDOFF.md` for detailed continuity procedures
- Use `manage-state.ps1` for all state transitions
