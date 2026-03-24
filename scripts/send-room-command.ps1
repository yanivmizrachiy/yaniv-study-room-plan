param(
  [string]$Command = "refresh_state",
  [string]$Target = "yaniv-study-room-plan",
  [string]$Note = "fixed script",
  [switch]$UseRepositoryDispatch
)

$ErrorActionPreference = "Stop"
[Console]::OutputEncoding = [System.Text.UTF8Encoding]::new()

$Repo = "yanivmizrachiy/yaniv-study-room-plan"

gh auth status | Out-Null

if ($UseRepositoryDispatch) {
  $payload = @{
    event_type = "room_command"
    client_payload = @{
      command = $Command
      target  = $Target
      note    = $Note
      source  = "fixed-script"
      sent_at = (Get-Date).ToString("s")
    }
  } | ConvertTo-Json -Depth 6

  $tmp = Join-Path $env:TEMP "dispatch.json"
  $payload | Set-Content $tmp -Encoding UTF8

  gh api "repos/$Repo/dispatches" --method POST --input $tmp

  Write-Host "dispatch נשלח ✔" -ForegroundColor Green
  exit
}

gh workflow run room-command.yml --repo $Repo --ref main -f command=$Command -f target=$Target -f note="$Note"

Write-Host "workflow נשלח ✔" -ForegroundColor Green
