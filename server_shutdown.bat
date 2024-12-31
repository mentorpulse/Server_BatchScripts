@echo off
COLOR F

:: Kill AutoRestart Script
echo Attempting to shut down Start-AutoRestart.bat process...
tasklist /FI "WINDOWTITLE eq WoW Server Auto Restarter" | find /I "cmd.exe" >nul
if errorlevel 1 (
    echo Start-AutoRestart.bat is not running.
) else (
    taskkill /FI "WINDOWTITLE eq WoW Server Auto Restarter" /T /F
    echo Start-AutoRestart.bat has been shut down.
)

:: MySQL Configuration
set "MYSQL_HOST=127.0.0.1"
set "MYSQL_USER=acore"
set "MYSQL_PASS=acore"
set "MYSQL_PORT=3306"

:: Dynamic Backup Directory (Based on Script Drive)
set "SCRIPT_DRIVE=%~d0"
set "BACKUP_DIR=%SCRIPT_DRIVE%\AshenOrder_Repack\AshenOrder_Backups"
set "CHARACTERS_BACKUP_FILE=acore_characters_backup_%date:~-4%-%date:~4,2%-%date:~7,2%_%time:~0,2%-%time:~3,2%.sql"
set "AUTH_BACKUP_FILE=acore_auth_backup_%date:~-4%-%date:~4,2%-%date:~7,2%_%time:~0,2%-%time:~3,2%.sql"

:: Ensure Backup Directory Exists
if not exist "%BACKUP_DIR%" mkdir "%BACKUP_DIR%"

:: Perform Backup Before Shutdown
echo Performing backup before shutdown...

:: Backup Characters Database
".\mysql\bin\mysqldump.exe" -h %MYSQL_HOST% -P %MYSQL_PORT% -u %MYSQL_USER% -p%MYSQL_PASS% acore_characters > "%BACKUP_DIR%\%CHARACTERS_BACKUP_FILE%"
if %errorlevel% equ 0 (
    echo Backup of acore_characters database successful! Saved as "%BACKUP_DIR%\%CHARACTERS_BACKUP_FILE%"
) else (
    echo Backup of acore_characters database failed.
    pause
    exit /b 1
)

:: Backup Auth Database
".\mysql\bin\mysqldump.exe" -h %MYSQL_HOST% -P %MYSQL_PORT% -u %MYSQL_USER% -p%MYSQL_PASS% acore_auth > "%BACKUP_DIR%\%AUTH_BACKUP_FILE%"
if %errorlevel% equ 0 (
    echo Backup of acore_auth database successful! Saved as "%BACKUP_DIR%\%AUTH_BACKUP_FILE%"
) else (
    echo Backup of acore_auth database failed.
    pause
    exit /b 1
)

echo Backups completed successfully.

:: Shut down Worldserver
echo Attempting to shut down Worldserver...
tasklist /FI "IMAGENAME eq worldserver.exe" | find /I "worldserver.exe" >nul
if errorlevel 1 (
    echo Worldserver is not running.
) else (
    taskkill /IM worldserver.exe /T /F
    echo Worldserver has been shut down.
)

:: Shut down Authserver
echo Attempting to shut down Authserver...
tasklist /FI "IMAGENAME eq authserver.exe" | find /I "authserver.exe" >nul
if errorlevel 1 (
    echo Authserver is not running.
) else (
    taskkill /IM authserver.exe /T /F
    echo Authserver has been shut down.
)

:: Shut down MySQL Server
echo Attempting to shut down MySQL server...
tasklist /FI "IMAGENAME eq mysqld.exe" | find /I "mysqld.exe" >nul
if errorlevel 1 (
    echo MySQL server is not running.
) else (
    taskkill /IM mysqld.exe /T /F
    echo MySQL server has been shut down.
)

echo All server processes have been shut down.

:: Initiate Windows Shutdown
echo Initiating Windows shutdown...
shutdown /s /f /t 0

exit
