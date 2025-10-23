# Project Handoff Guide

## Quick Start

### For Humans
1. Check current project state:
   ```powershell
   .\manage-state.ps1 -Action status
   ```
2. Review `state.json` for latest project status
3. Read `WORKFLOW.md` for process documentation
4. Check `session_activity_log.txt` for detailed history

### For Automated Systems
1. Parse `state.json` for machine-readable project state
2. Use REST endpoints (if implemented) or direct file access
3. Monitor file changes through git hooks or filesystem watches
4. Update state using the management script:
   ```powershell
   .\manage-state.ps1 -Action complete-task -TaskId "TASK-001" -Description "Automated task completion"
   ```

## State Management

### File Structure
- `state.json`: Machine-readable project state
- `session_activity_log.txt`: Human-readable activity log
- `WORKFLOW.md`: Process documentation
- `manage-state.ps1`: Automation script
- `HANDOFF.md`: This guide

### State File Format (state.json)
```json
{
  "projectState": {
    "lastUpdated": "ISO-8601 timestamp",
    "repository": {},
    "workspaceStructure": {},
    "progress": {
      "lastAction": "string",
      "completedTasks": [],
      "currentState": "string"
    },
    "nextActions": []
  },
  "metadata": {}
}
```

## Continuity Procedures

### Resuming Work (Human)
1. Pull latest changes from repository
2. Run status check:
   ```powershell
   .\manage-state.ps1 -Action status
   ```
3. Review "Next Actions" in status output
4. Pick up from last completed task in `state.json`

### Resuming Work (Automated)
1. Poll or watch `state.json` for changes
2. Parse current state and next actions
3. Execute next action based on priority
4. Update state using management script
5. Commit changes back to repository

## Automation Integration

### REST API (if implemented)
- GET /api/state - Current project state
- POST /api/tasks - Complete a task
- GET /api/next-actions - Get prioritized tasks

### File-based Integration
1. Watch `state.json` for changes
2. Parse JSON structure
3. Execute actions based on `nextActions` array
4. Update state using `manage-state.ps1`

### Git Hooks (recommended)
1. Set up post-commit hook to update state
2. Set up pre-push hook to validate state
3. Use post-merge hook to check for state conflicts

## Troubleshooting

### Common Issues
1. State file conflicts
   - Resolution: Use git merge strategies
   - Fallback: Manual merge using `session_activity_log.txt`

2. Automation script errors
   - Check PowerShell execution policy
   - Verify file permissions
   - Review error logs

### Recovery Procedures
1. From state corruption:
   ```powershell
   git checkout main -- state.json
   .\manage-state.ps1 -Action status
   ```

2. From incomplete task:
   - Review `session_activity_log.txt`
   - Reset state to last known good
   - Resume from last completed task

## Contact

For issues or questions:
- Repository: nicholas-mccrady/jmprecison_biz_landingpage
- Branch: main

## Version History

- 1.0.0 (2025-10-23)
  - Initial handoff documentation
  - Added state management system
  - Created automation scripts