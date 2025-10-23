# State Management Script for jmprecison_biz_landingpage
# Handles project state updates and transitions for both human and automated processes

param(
    [Parameter(Mandatory=$false)]
    [string]$Action = "status",
    [Parameter(Mandatory=$false)]
    [string]$Description = "",
    [Parameter(Mandatory=$false)]
    [string]$TaskId = ""
)

$STATE_FILE = "state.json"
$LOG_FILE = "session_activity_log.txt"
 $WEB_ROOT = Get-Location

function Start-LocalPreview {
    <#
    Starts a local preview by opening index.html in the default browser.
    Approved verb: Start
    #>
    $indexPath = Join-Path $WEB_ROOT "index.html"
    if (Test-Path $indexPath) {
        Start-Process $indexPath
        Write-Host "Opened local preview: $indexPath" -ForegroundColor Cyan
    } else {
        Write-Host "index.html not found in current directory." -ForegroundColor Yellow
    }
}

function Get-NextWebActions {
    <#
    Retrieves the next web-related actions from the project state.
    Approved verb: Get
    #>
    $state = Get-ProjectState
    Write-Host "Next web actions:" -ForegroundColor Cyan
    $state.projectState.nextActions | Where-Object { $_.id -like 'WEB-*' } | ForEach-Object {
        Write-Host "- [$($_.id)] $($_.description) (priority $($_.priority))"
    }
}

function Get-ProjectState {
    if (Test-Path $STATE_FILE) {
        $state = Get-Content $STATE_FILE | ConvertFrom-Json
        return $state
    }
    throw "State file not found. Project may need initialization."
}

function Update-ProjectState {
    param(
        [Parameter(Mandatory=$true)]
        [PSCustomObject]$State
    )
    $State.projectState.lastUpdated = (Get-Date).ToUniversalTime().ToString("o")
    $State | ConvertTo-Json -Depth 10 | Set-Content $STATE_FILE
}

function Add-TaskCompletion {
    param(
        [Parameter(Mandatory=$true)][string]$Description,
        [Parameter(Mandatory=$true)][string]$TaskId,
        [string]$ArtifactPath = ""
    )

    $state = Get-ProjectState
    $newTask = [PSCustomObject]@{
        id = $TaskId
        description = $Description
        timestamp = (Get-Date).ToUniversalTime().ToString("o")
        artifact = $null
    }

    if ($ArtifactPath) {
        $newTask.artifact = $ArtifactPath
    }

    $state.projectState.progress.completedTasks += $newTask
    $state.projectState.progress.lastAction = $Description
    Update-ProjectState $state

    # Also append to session log with artifact info
    $logEntry = @"

Task Completion Entry:
ID: $TaskId
Description: $Description
Time: $((Get-Date).ToUniversalTime().ToString("o"))
Artifact: $ArtifactPath
"@
    Add-Content $LOG_FILE $logEntry
}

function Show-ProjectStatus {
    $state = Get-ProjectState
    Write-Host "`nProject Status:" -ForegroundColor Cyan
    Write-Host "Last Updated: $($state.projectState.lastUpdated)"
    Write-Host "Current State: $($state.projectState.progress.lastAction)"
    Write-Host "`nNext Actions:" -ForegroundColor Yellow
    $state.projectState.nextActions | ForEach-Object {
        Write-Host "- [$($_.id)] $($_.description)"
    }
    Write-Host "`nCompleted Tasks:" -ForegroundColor Green
    $state.projectState.progress.completedTasks | ForEach-Object {
        Write-Host "- [$($_.id)] $($_.description) @ $($_.timestamp)"
    }
}

# Main execution
switch ($Action) {
    "status" { Show-ProjectStatus }
    "complete-task" { 
        if ($TaskId -and $Description) {
            Add-TaskCompletion -TaskId $TaskId -Description $Description -ArtifactPath ""
            Write-Host "Task $TaskId completed and recorded." -ForegroundColor Green
        } else {
            Write-Host "Error: TaskId and Description required for task completion" -ForegroundColor Red
        }
    }
    "preview" { Start-LocalPreview }
    "list-web-actions" { Get-NextWebActions }
    default { Write-Host "Unknown action. Use 'status' or 'complete-task'" -ForegroundColor Red }
}