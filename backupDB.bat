@echo off
for /f "tokens=2 delims==" %%I in ('"wmic os get localdatetime /value"') do set datetime=%%I
set datetime=%datetime:~0,8%_%datetime:~8,6%
set PGPASSWORD=1234
pg_dump -U postgres -h localhost -p 5432 -d unit_manage_service -F c -b -v -f "C:\backupDB\unit_manage_service_%datetime%.backup"
