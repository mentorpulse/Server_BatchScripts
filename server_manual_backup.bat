@echo off
setlocal enabledelayedexpansion

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

:: Backup Character Database
echo Backing up the acore_characters database...
".\mysql\bin\mysqldump.exe" -h %MYSQL_HOST% -P %MYSQL_PORT% -u %MYSQL_USER% -p%MYSQL_PASS% acore_characters > "%BACKUP_DIR%\%CHARACTERS_BACKUP_FILE%"
if %errorlevel% equ 0 (
    echo acore_characters backup successful! Saved as "%BACKUP_DIR%\%CHARACTERS_BACKUP_FILE%"
) else (
    echo acore_characters backup failed.
    pause
    exit /b 1
)

:: Backup Auth Database
echo Backing up the acore_auth database...
".\mysql\bin\mysqldump.exe" -h %MYSQL_HOST% -P %MYSQL_PORT% -u %MYSQL_USER% -p%MYSQL_PASS% acore_auth > "%BACKUP_DIR%\%AUTH_BACKUP_FILE%"
if %errorlevel% equ 0 (
    echo acore_auth backup successful! Saved as "%BACKUP_DIR%\%AUTH_BACKUP_FILE%"
) else (
    echo acore_auth backup failed.
    pause
    exit /b 1
)

echo All backups completed successfully.
pause
exit
