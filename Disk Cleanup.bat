:::::::::::::::::::::::::::::::::::::::::
:: Automatically check & get admin rights
:::::::::::::::::::::::::::::::::::::::::
CLS 
ECHO.
ECHO =============================
ECHO Running Admin shell
ECHO =============================
 
:checkPrivileges 
NET FILE 1>NUL 2>NUL
	if '%errorlevel%' == '0' ( goto gotPrivileges ) else ( goto getPrivileges ) 
:getPrivileges
::method 1 - using powershell
@echo off
    :: Not elevated, so re-run with elevation
    powershell -Command "Start-Process cmd -ArgumentList '/c %~s0 %*' -Verb RunAs"
    exit /b
)
:gotPrivileges 
::::::::::::::::::::::::::::
:START
::::::::::::::::::::::::::::
@ECHO OFF
TITLE The Beard of Knowledge automagic disk cleanup script.
::PUBLISHER: Community effort can be tracked at https://github.com/TheBeardofKnowledge/Scripts-from-my-videos
ECHO Version 10-28-2024
::Purpose of this batch file is to recover as much "safe" used space from your windows system drive
::in order to gain back free space that Windows, other programs, and users themselves have consumed.
::Credits: Because the work we do in IT is often unrecognized, this section will not show in the command.
::TheBeardofKnowledge-https://thebeardofknowledge.bio.link/
::
::
::
::
::
::
::
echo *******************************************************************************
ECHO Current free space of hard drive:
	fsutil volume diskfree c:
echo *******************************************************************************
ECHO STARTING CLEANUP PROCESS
::ECHO temporarily closing explorer process to prevent open file handles
::taskkill /f /IM explorer.exe
::commented this out by request to not close open folders, but open file handles wont be deleted.

ECHO disabling hibernation and deleting the hibernation file
	powercfg -h off

:WINDOWS TEMP FILE CLEANUP
@ECHO OFF
ECHO Deleting all temporary files
	DEL /S /Q /F "%TMP%\*.*"
	DEL /S /Q /F "%TEMP%\*.*"
	DEL /S /Q /F "%WINDIR%\Temp\*.*"
	DEL /S /Q /F "%WINDIR%\Prefetch\*.* 
	DEL /S /Q /F "%WINDIR%\Logs\CBS\*.* 
::ECHO Deleting unreleased erroneous print jobs
::	NET STOP Spooler
::	DEL c:\windows\system32\spool\printers\*.* /f /q
::	net start spooler

:USER PROFILE CLEANUP
For /d %u in ("c:\users\*") do
DEL /S /Q /F "%u\Local Settings\Temp\"
DEL /S /Q /F "%u\AppData\Local\Temp\"

:Windows Updates Cleanup
net stop bits
net stop wuauserv
net stop appidsvc
net stop cryptsvc
@ECHO OFF
Del “%ALLUSERSPROFILE%\Application Data\Microsoft\Network\Downloader\*.*”
rmdir %systemroot%\SoftwareDistribution /S /Q
rmdir %systemroot%\system32\\catroot2 /S /Q
net start bits
net start wuauserv
net start appidsvc
net start cryptsvc

:Disk Cleanup with CLEANMGR

REM Configuring Disk Cleanup registry settings for all safe to delete content

:: Set all the CLEANMGR registry entries for Group #69 -have a sense of humor!

SET _Group_No=StateFlags0069

SET _RootKey=HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\VolumeCaches

:: Temporary Setup Files
REG ADD "%_RootKey%\Active Setup Temp Folders" /v %_Group_No% /t REG_DWORD /d 00000002 /f

:: Branch Cache (WAN bandwidth optimization)
REG ADD "%_RootKey%\BranchCache" /v %_Group_No% /t REG_DWORD /d 00000002 /f

:: Catalog Files for the Content Indexer (deletes all files in the folder c:\catalog.wci)
REG ADD "%_RootKey%\Content Indexer Cleaner" /v %_Group_No% /t REG_DWORD /d 00000002 /f

:: Delivery Optimization Files (service to share bandwidth for uploading Windows updates)
REG ADD "%_RootKey%\Delivery Optimization Files" /v %_Group_No% /t REG_DWORD /d 00000002 /f

:: Diagnostic data viewer database files (Windows app that sends data to Microsoft)
REG ADD "%_RootKey%\Diagnostic Data Viewer database Files" /v %_Group_No% /t REG_DWORD /d 00000002 /f

:: Direct X Shader cache (graphics cache, clearing this can can speed up application load time.)
REG ADD "%_RootKey%\D3D Shader Cache" /v %_Group_No% /t REG_DWORD /d 00000002 /f

:: Downloaded Program Files (ActiveX controls and Java applets downloaded from the Internet)
REG ADD "%_RootKey%\Downloaded Program Files" /v %_Group_No% /t REG_DWORD /d 00000002 /f

:: Temporary Internet Files
REG ADD "%_RootKey%\Internet Cache Files" /v %_Group_No% /t REG_DWORD /d 00000002 /f

:: Language resources Files (unused languages and keyboard layouts)
REG ADD "%_RootKey%\Language Pack" /v %_Group_No% /t REG_DWORD /d 00000002

:: Offline Files (Web pages)
REG ADD "%_RootKey%\Offline Pages Files" /v %_Group_No% /t REG_DWORD /d 00000002 /f

:: Old ChkDsk Files
REG ADD "%_RootKey%\Old ChkDsk Files" /v %_Group_No% /t REG_DWORD /d 00000002 /f

:: Recycle Bin -If you store stuff in recycle bin... shame on you!
REG ADD "%_RootKey%\Recycle Bin" /v %_Group_No% /t REG_DWORD /d 00000002 /f

:: Retail Demo
REG ADD "%_RootKey%\RetailDemo Offline Content" /v %_Group_No% /t REG_DWORD /d 00000002 /f

:: Update package Backup Files (old versions)
REG ADD "%_RootKey%\ServicePack Cleanup" /v %_Group_No% /t REG_DWORD /d 00000002 /f

:: Setup Log files (software install logs)
REG ADD "%_RootKey%\Setup Log Files" /v %_Group_No% /t REG_DWORD /d 00000002 /f

:: System Error memory dump files (These can be very large if the system has crashed)
REG ADD "%_RootKey%\System error memory dump files" /v %_Group_No% /t REG_DWORD /d 00000002 /f

:: System Error minidump files (smaller memory crash dumps)
REG ADD "%_RootKey%\System error minidump files" /v %_Group_No% /t REG_DWORD /d 00000002 /f

:: Temporary Files (%Windir%\Temp and %Windir%\Logs)
REG ADD "%_RootKey%\Temporary Files" /v %_Group_No% /t REG_DWORD /d 00000002 /f

:: Windows Update Cleanup (old system files not migrated during a Windows Upgrade)
REG ADD "%_RootKey%\Update Cleanup" /v %_Group_No% /t REG_DWORD /d 00000002 /f

:: Thumbnails (Explorer will recreate thumbnails as each folder is viewed.)
REG ADD "%_RootKey%\Thumbnail Cache" /v %_Group_No% /t REG_DWORD /d 00000002 /f

:: Windows Defender Antivirus
REG ADD "%_RootKey%\Windows Defender" /v %_Group_No% /d 2 /t REG_DWORD /f

:: Windows error reports and feedback diagnostics
REG ADD "%_RootKey%\Windows Error Reporting Files" /v %_Group_No% /t REG_DWORD /d 00000002 /f

:: Windows Upgrade log files
REG ADD "%_RootKey%\Windows Upgrade Log Files" /v %_Group_No% /t REG_DWORD /d 00000002 /f

ECHO Waiting for Disk Cleanup to complete - do not close this window.
CLEANMGR /sagerun:69
CLEANMGR /verylowdisk /autoclean

::ECHO Removing temporary Internet Browser cache, no user data will be deleted
::	taskkill /f /IM iexplore.exe
::	taskkill /f /IM msedge.exe
::	taskkill /f /IM msedgewebview2.exe
::	taskkill /f /IM chrome.exe
::	taskkill /f /IM firefox.exe
::ECHO cleaning Internet Explorer cache
	C:\Windows\System32\rundll32.exe InetCpl.cpl, ClearMyTracksByProcess 255
	C:\Windows\System32\rundll32.exe InetCpl.cpl, ClearMyTracksByProcess 4351


::ECHO Starting the explorer process back up
	::explorer.exe

REM ECHO Reenabling hibernation
REM powercfg -h on
color f2
echo *******************************************************************************
ECHO New free space of hard drive:
fsutil volume diskfree c:
echo *******************************************************************************
ECHO All cleaned up, have a nice day!
PAUSE


