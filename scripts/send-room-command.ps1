param(
  [ValidateSet("refresh_state","open_repo","check_site","export_state","sync_docs")]
  [string]$Command = "refresh_state",

  [string]$Target = "yaniv-study-room-plan",

  [string]$Note = "local powershell trigger",

  [switch]$UseRepositoryDispatch
)

$ErrorActionPreference = "Stop"
[Console]::OutputEncoding = [System.Text.UTF8Encoding]::new()

$Repo = "yanivmizrachiy/yaniv-study-room-plan"

try {
  gh auth status | Out-Null
} catch {
  Write-Host "gh לא מחובר. תריץ קודם gh auth login" -ForegroundColor Red
  exit 1
}

if ($UseRepositoryDispatch) {
  $payload = @{
    event_type = "room_command"
    client_payload = @{
      command = $Command
      target  = $Target
      note    = $Note
      source  = "local-powershell"
      sent_at = (Get-Date).ToString("s")
    }
  } | ConvertTo-Json -Depth 6 -Compress

  $tmp = Join-Path $env:TEMP "room-command-dispatch.json"
  $payload | Set-Content -Path $tmp -Encoding UTF8

  gh api "repos/$Repo/dispatches" --method POST --input $tmp
  Write-Host ""
  Write-Host "repository_dispatch נשלח בהצלחה." -ForegroundColor Green
  Write-Host "Repo: https://github.com/$Repo" -ForegroundColor Cyan
  Write-Host "Actions: https://github.com/$Repo/actions" -ForegroundColor Cyan
  exit 0
}

gh workflow run "room-command.yml" --repo $Repo -f command=$Command -f target=$Target -f note="$Note"

Write-Host ""
Write-Host "workflow_dispatch נשלח בהצלחה." -ForegroundColor Green
Write-Host "Repo: https://github.com/$Repo" -ForegroundColor Cyan
Write-Host "Actions: https://github.com/$Repo/actions" -ForegroundColor Cyan
