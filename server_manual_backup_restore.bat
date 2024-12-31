@echo off
setlocal enabledelayedexpansion

:: MySQL Configuration
set "MYSQL_HOST=127.0.0.1"
set "MYSQL_USER=acore"
set "MYSQL_PASS=acore"
set "MYSQL_PORT=3306"

:: Backup Directory (Where Your Backup Files are Stored)
set "SCRIPT_DRIVE=%~d0"
set "BACKUP_DIR=%SCRIPT_DRIVE%\AshenOrder_Repack\AshenOrder_Backups"

:: Backup File Names (Modify to Match Your Backup Files)
set "CHARACTERS_BACKUP_FILE=acore_characters_backup.sql"
set "AUTH_BACKUP_FILE=acore_auth_backup.sql"

:: Change to the script directory to ensure relative paths work
cd /d "%~dp0"

:: Restore Characters Database
if exist "%BACKUP_DIR%\%CHARACTERS_BACKUP_FILE%" (
    echo Restoring acore_characters database from backup...
    ".\mysql\bin\mysql.exe" -h %MYSQL_HOST% -P %MYSQL_PORT% -u %MYSQL_USER% -p%MYSQL_PASS% acore_characters < "%BACKUP_DIR%\%CHARACTERS_BACKUP_FILE%"
    if %errorlevel% equ 0 (
        echo acore_characters database restored successfully.
    ) else (
        echo Failed to restore acore_characters database.
        pause
        exit /b 1
    )
) else (
    echo Backup file for acore_characters not found: "%BACKUP_DIR%\%CHARACTERS_BACKUP_FILE%"
    pause
    exit /b 1
)

:: Restore Auth Database
if exist "%BACKUP_DIR%\%AUTH_BACKUP_FILE%" (
    echo Restoring acore_auth database from backup...
    ".\mysql\bin\mysql.exe" -h %MYSQL_HOST% -P %MYSQL_PORT% -u %MYSQL_USER% -p%MYSQL_PASS% acore_auth < "%BACKUP_DIR%\%AUTH_BACKUP_FILE%"
    if %errorlevel% equ 0 (
        echo acore_auth database restored successfully.
    ) else (
        echo Failed to restore acore_auth database.
        pause
        exit /b 1
    )
) else (
    echo Backup file for acore_auth not found: "%BACKUP_DIR%\%AUTH_BACKUP_FILE%"
    pause
    exit /b 1
)

echo All databases restored successfully.
pause
exit
