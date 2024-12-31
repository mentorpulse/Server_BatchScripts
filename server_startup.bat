@echo off
setlocal enabledelayedexpansion

:: General Configuration
set max_retries=12
set delay=10

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

:: Change to the script directory to ensure relative paths work
cd /d "%~dp0"

:: Start MySQL Server
echo Starting MySQL server...
start /min cmd /c ".\mysql\bin\mysqld --standalone --console"
echo Waiting for MySQL server to initialize...
timeout /t 15 >nul

:: Check MySQL Readiness
:check_mysql
set /a retries+=1
echo Attempt #%retries%: Checking MySQL server readiness...
".\mysql\bin\mysqladmin.exe" -h %MYSQL_HOST% -P %MYSQL_PORT% -u %MYSQL_USER% -p%MYSQL_PASS% ping | findstr "mysqld is alive" >nul
if %errorlevel% equ 0 (
    echo MySQL server is ready!
    goto backup_database
) else (
    echo MySQL server is not ready. Retrying in %delay% seconds...
    timeout /t %delay% >nul
    if %retries% geq %max_retries% (
        echo MySQL server is not ready after %max_retries% attempts. Exiting...
        pause
        exit /b 1
    )
    goto check_mysql
)

:backup_database
:: Backup Character Database
echo Backing up the acore_characters database...
".\mysql\bin\mysqldump.exe" -h %MYSQL_HOST% -P %MYSQL_PORT% -u %MYSQL_USER% -p%MYSQL_PASS% acore_characters > "%BACKUP_DIR%\%CHARACTERS_BACKUP_FILE%"
if %errorlevel% equ 0 (
    echo acore_characters backup successful! Saved as "%BACKUP_DIR%\%CHARACTERS_BACKUP_FILE%"
) else (
    echo acore_characters backup failed. Exiting...
    pause
    exit /b 1
)

:: Backup Auth Database
echo Backing up the acore_auth database...
".\mysql\bin\mysqldump.exe" -h %MYSQL_HOST% -P %MYSQL_PORT% -u %MYSQL_USER% -p%MYSQL_PASS% acore_auth > "%BACKUP_DIR%\%AUTH_BACKUP_FILE%"
if %errorlevel% equ 0 (
    echo acore_auth backup successful! Saved as "%BACKUP_DIR%\%AUTH_BACKUP_FILE%"
) else (
    echo acore_auth backup failed. Exiting...
    pause
    exit /b 1
)

:start_authserver
:: Start Authserver
echo Starting Authserver...
start cmd /k "color 2 & title Authserver Window & .\authserver.exe"
timeout /t 30 >nul
echo Authserver started.

:: Start Worldserver
echo Starting Worldserver...
start cmd /k "color 2 & title Worldserver Window & .\worldserver.exe"
timeout /t 30 >nul
echo Worldserver started.

:: Start AutoRestart Batch File
echo Starting AutoRestart script...
start cmd /k "color 2 & title AutoRestart Window & .\Start-AutoRestart.bat"
echo AutoRestart script started.

pause
exit
