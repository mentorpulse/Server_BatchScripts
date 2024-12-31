# Windows Batch Script for AshenCore_Repack 

These windows batch scripts are designed for the AshenCore_Repack allowing users to automate several server processes. 
All batch files should be executed from the root of the AshenCore_Repack directory.

server_startup.bat will execute the MySQL server and then check to verify that the MySQL server is up and running by logging into it (script is using the default username and passwords of the Repack). Once the script has verified that the server is running it will perform a backup of the character database and the account database and timestamp the archived files stored in the AshenOrder_Backups directory in the root of the AshenOrder_Repack folder. The script will then execute the authserver.exe and wait a few seconds and then execute worldserver.exe.

server_shutdown will log into the mysql server and perform a backup of the character database and account database and then it will shutdown the authserver.exe, worldserver.exe, and mysql database gracefully. Then it will signal to Windows to shutdown and force close any remaining open processes.

server_manual_backup.bat will automate the task of a manual backup of the character and account databases whenever it is executed.

server_manual_backup_restore will automate the restoration process of the archives stored in the AshenOrder_Backups directory. Just remove the timestamps of the backups that you want to restore and execute the script.



