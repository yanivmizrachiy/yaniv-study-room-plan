# AUTOMATION.md

## מה נוסף
נוספו שני מסלולי פקודה אמיתיים:

1. workflow_dispatch
2. repository_dispatch

## סקריפט מקומי
scripts/send-room-command.ps1

## דוגמאות

### workflow_dispatch
powershell -ExecutionPolicy Bypass -File .\scripts\send-room-command.ps1 -Command refresh_state -Target yaniv-study-room-plan -Note "בדיקה"

### repository_dispatch
powershell -ExecutionPolicy Bypass -File .\scripts\send-room-command.ps1 -Command check_site -Target yaniv-study-room-plan -Note "dispatch test" -UseRepositoryDispatch

## תוצאה
בכל הרצה נוצר artifact ב-GitHub Actions עם מצב הפקודה.

## קישורים
- אתר חי: https://yanivmizrachiy.github.io/yaniv-study-room-plan/
- Actions: https://github.com/yanivmizrachiy/yaniv-study-room-plan/actions
