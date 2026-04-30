@echo off
setlocal enabledelayedexpansion

where git >nul 2>nul
if errorlevel 1 (
  echo [ERROR] Git is not installed or not in PATH.
  pause
  exit /b 1
)

git rev-parse --is-inside-work-tree >nul 2>nul
if errorlevel 1 (
  echo [ERROR] This folder is not a git repository.
  pause
  exit /b 1
)

for /f "delims=" %%b in ('git rev-parse --abbrev-ref HEAD 2^>nul') do set BRANCH=%%b
if "%BRANCH%"=="" (
  echo [ERROR] Could not detect current branch.
  pause
  exit /b 1
)

echo Current branch: %BRANCH%
echo.
set /p COMMIT_MSG=Enter commit message: 
if "%COMMIT_MSG%"=="" (
  echo [ERROR] Commit message cannot be empty.
  pause
  exit /b 1
)

echo.
echo Staging changes...
git add -A
if errorlevel 1 goto :fail

echo Committing...
git commit -m "%COMMIT_MSG%"
if errorlevel 1 goto :fail

echo Pushing to origin/%BRANCH%...
git push origin %BRANCH%
if errorlevel 1 goto :fail

echo.
echo [OK] Commit and push completed.
pause
exit /b 0

:fail
echo.
echo [ERROR] Command failed. Review output above.
pause
exit /b 1
