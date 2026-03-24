param(
  [string]$Url = "https://yanivmizrachiy.github.io/yaniv-study-room-plan/"
)

$ErrorActionPreference = "Stop"
[Console]::OutputEncoding = [System.Text.UTF8Encoding]::new()

try {
  $r = Invoke-WebRequest -Uri $Url -UseBasicParsing -TimeoutSec 30
  $ok = $r.StatusCode -eq 200
  $hasHebrew = $r.Content -match "חדר" -or $r.Content -match "יניב" -or $r.Content -match "GitHub"
  $result = [pscustomobject]@{
    url = $Url
    status_code = $r.StatusCode
    ok = $ok
    content_length = $r.Content.Length
    contains_expected_text = $hasHebrew
    checked_at = (Get-Date).ToString("s")
  }
  $result | ConvertTo-Json -Depth 5 | Set-Content -Path ".\state\last-site-check.json" -Encoding UTF8
  $result | Format-List
  if (-not $ok) { exit 2 }
} catch {
  $err = [pscustomobject]@{
    url = $Url
    ok = $false
    error = $_.Exception.Message
    checked_at = (Get-Date).ToString("s")
  }
  $err | ConvertTo-Json -Depth 5 | Set-Content -Path ".\state\last-site-check.json" -Encoding UTF8
  $err | Format-List
  exit 1
}
