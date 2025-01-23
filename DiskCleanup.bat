:::::::::::::::::::::::::::::::::::::::::
:: Automatically check & get admin rights
:::::::::::::::::::::::::::::::::::::::::
color f0
ECHO Running Admin shell
:checkPrivileges 
NET FILE 1>NUL 2>NUL
if '%errorlevel%' == '0' ( goto gotPrivileges ) else ( goto getPrivileges ) 
 
:getPrivileges 
if '%1'=='ELEV' (shift & goto gotPrivileges)  
ECHO. 
ECHO **************************************
ECHO Invoking UAC for Privilege Escalation 
ECHO **************************************
 
setlocal DisableDelayedExpansion
set "batchPath=%~0"
setlocal EnableDelayedExpansion
ECHO Set UAC = CreateObject^("Shell.Application"^) > %temp%\OEgetPrivileges.vbs" 
ECHO UAC.ShellExecute "!batchPath!", "ELEV", "", "runas", 1 >> "%temp%\OEgetPrivileges.vbs" 
"%temp%\OEgetPrivileges.vbs" 
exit /B 
 
:gotPrivileges 
::::::::::::::::::::::::::::
:STARTINTRO
::::::::::::::::::::::::::::
cls
@ECHO OFF
color 0A
TITLE TBOK disk cleanup script!
ECHO TBOK automagic disk cleanup script!
ECHO Community effort can be tracked at https://github.com/TheBeardofKnowledge/Scripts-from-my-videos
ECHO Version 11-05-2024
::Purpose of this batch file is to recover as much "safe" used space from your windows system drive
::in order to gain back free space that Windows, other programs, and users themselves have consumed.
ECHO Credits: Because the work we do in IT is often unrecognized, this section will show anyone
ECHO who contributes to the script to improve it.
ECHO TheBeardofKnowledge https://thebeardofknowledge.bio.link/
ECHO CREDIT to.
ECHO ..
ECHO ...
ECHO ....
ECHO .....
ECHO ......
ECHO .......
ECHO ........
ECHO .........
echo ********************************************
ECHO Your Current free space of hard drive:
	fsutil volume diskfree c:
echo ********************************************
TIMEOUT 10

ECHO STARTING CLEANUP PROCESS
::ECHO temporarily closing explorer process to prevent open file handles
::taskkill /f /IM explorer.exe
::commented this out by request to not close open folders, but open file handles won't be deleted.

ECHO disabling hibernation and deleting the hibernation file
	powercfg -h off	

ECHO Deleting unreleased erroneous print jobs
	NET STOP Spooler
	DEL /S /Q /F c:\windows\system32\spool\printers\*.*
	net start spooler

:WindowsUpdatesCleanup
echo STOPPING WINDOWS UPDATE SERVICES
	net stop bits
	net stop wuauserv
	net stop appidsvc
	net stop cryptsvc
	DEL /S /Q /F “%ALLUSERSPROFILE%\Application Data\Microsoft\Network\Downloader\”	>nul 2>&1
	rmdir /S /Q "%systemroot%\SoftwareDistribution"   >nul 2>&1
	rmdir /S /Q "%systemroot%\system32\catroot2"  >nul 2>&1
	DEL /S /Q /F "%WINDIR%\ServiceProfiles\NetworkService\AppData\Local\Microsoft\Windows\DeliveryOptimization\Logs\*.*"  >nul 2>&1
	net start bits
	net start wuauserv
	net start appidsvc
	net start cryptsvc

:CLEANMGR
ECHO Configuring Disk Cleanup registry settings for all safe to delete content

:: Set all the CLEANMGR registry entries for Group #69 -have a sense of humor!
	SET _Group_No=StateFlags0069	>nul 2>&1
	SET _RootKey=HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\VolumeCaches /f	>nul 2>&1

:: Temporary Setup Files
	REG ADD "%_RootKey%\Active Setup Temp Folders" /v %_Group_No% /t REG_DWORD /d 00000002 /f	>nul 2>&1

:: Branch Cache (WAN bandwidth optimization)
	REG ADD "%_RootKey%\BranchCache" /v %_Group_No% /t REG_DWORD /d 00000002 /f	>nul 2>&1

:: Catalog Files for the Content Indexer (deletes all files in the folder c:\catalog.wci)
	REG ADD "%_RootKey%\Content Indexer Cleaner" /v %_Group_No% /t REG_DWORD /d 00000002 /f	>nul 2>&1

:: Delivery Optimization Files (service to share bandwidth for uploading Windows updates)
	REG ADD "%_RootKey%\Delivery Optimization Files" /v %_Group_No% /t REG_DWORD /d 00000002 /f	>nul 2>&1

:: Diagnostic data viewer database files (Windows app that sends data to Microsoft)
	REG ADD "%_RootKey%\Diagnostic Data Viewer database Files" /v %_Group_No% /t REG_DWORD /d 00000002 /f	>nul 2>&1

:: Direct X Shader cache (graphics cache, clearing this can can speed up application load time.)
	REG ADD "%_RootKey%\D3D Shader Cache" /v %_Group_No% /t REG_DWORD /d 00000002 /f	>nul 2>&1

:: Downloaded Program Files (ActiveX controls and Java applets downloaded from the Internet)
	REG ADD "%_RootKey%\Downloaded Program Files" /v %_Group_No% /t REG_DWORD /d 00000002 /f	>nul 2>&1

:: Temporary Internet Files
	REG ADD "%_RootKey%\Internet Cache Files" /v %_Group_No% /t REG_DWORD /d 00000002 /f	>nul 2>&1

:: Language resources Files (unused languages and keyboard layouts)
	REG ADD "%_RootKey%\Language Pack" /v %_Group_No% /t REG_DWORD /d 00000002 /f	>nul 2>&1

:: Offline Files (Web pages)
	REG ADD "%_RootKey%\Offline Pages Files" /v %_Group_No% /t REG_DWORD /d 00000002 /f	>nul 2>&1

:: Old ChkDsk Files
	REG ADD "%_RootKey%\Old ChkDsk Files" /v %_Group_No% /t REG_DWORD /d 00000002 /f	>nul 2>&1

:: Recycle Bin -If you store stuff in recycle bin... shame on you!
	REG ADD "%_RootKey%\Recycle Bin" /v %_Group_No% /t REG_DWORD /d 00000002 /f	>nul 2>&1

:: Retail Demo
	REG ADD "%_RootKey%\RetailDemo Offline Content" /v %_Group_No% /t REG_DWORD /d 00000002 /f	>nul 2>&1

:: Update package Backup Files (old versions)
	REG ADD "%_RootKey%\ServicePack Cleanup" /v %_Group_No% /t REG_DWORD /d 00000002 /f	>nul 2>&1

:: Setup Log files (software install logs)
	REG ADD "%_RootKey%\Setup Log Files" /v %_Group_No% /t REG_DWORD /d 00000002 /f	>nul 2>&1

:: System Error memory dump files (These can be very large if the system has crashed)
	REG ADD "%_RootKey%\System error memory dump files" /v %_Group_No% /t REG_DWORD /d 00000002 /f	>nul 2>&1

:: System Error minidump files (smaller memory crash dumps)
	REG ADD "%_RootKey%\System error minidump files" /v %_Group_No% /t REG_DWORD /d 00000002 /f	>nul 2>&1

:: Temporary Files (%Windir%\Temp and %Windir%\Logs)
	REG ADD "%_RootKey%\Temporary Files" /v %_Group_No% /t REG_DWORD /d 00000002 /f	>nul 2>&1

:: Windows Update Cleanup (old system files not migrated during a Windows Upgrade)
	REG ADD "%_RootKey%\Update Cleanup" /v %_Group_No% /t REG_DWORD /d 00000002 /f	>nul 2>&1

:: Thumbnails (Explorer will recreate thumbnails as each folder is viewed.)
	REG ADD "%_RootKey%\Thumbnail Cache" /v %_Group_No% /t REG_DWORD /d 00000002 /f	>nul 2>&1

:: Windows Defender Antivirus
	REG ADD "%_RootKey%\Windows Defender" /v %_Group_No% /d 2 /t REG_DWORD /f	>nul 2>&1

:: Windows error reports and feedback diagnostics
	REG ADD "%_RootKey%\Windows Error Reporting Files" /v %_Group_No% /t REG_DWORD /d 00000002 /f 	>nul 2>&1

:: Windows Upgrade log files
	REG ADD "%_RootKey%\Windows Upgrade Log Files" /v %_Group_No% /t REG_DWORD /d 00000002 /f	>nul 2>&1
ECHO DiskCleanup registry settings completed
ECHO Running CleanMgr and Waiting for Disk Cleanup to complete, this takes a while - do not close this window!
ECHO Be patient, this process can take a while depending on how much temporary Crap has accummulated in your system...
START CLEANMGR /sagerun:69	>nul 2>&1
START CLEANMGR /verylowdisk /autoclean	>nul 2>&1

:WINTEMPFILECLEANUP
ECHO Deleting all System temporary files
@ECHO OFF
	DEL /S /Q /F "%TMP%\"	>nul 2>&1
	DEL /S /Q /F "%TEMP%\"	>nul 2>&1
	DEL /S /Q /F "%WINDIR%\Temp\"	>nul 2>&1
	DEL /S /Q /F "%WINDIR%\Prefetch\"	>nul 2>&1
	DEL /S /Q /F "%WINDIR%\Logs\CBS\"	>nul 2>&1
	DEL /S /Q /F "%WINDIR%\Logs\DPX\*.log"	>nul 2>&1
	DEL /S /Q /F "%WINDIR%\Logs\DISM\*.log"	>nul 2>&1
	DEL /S /Q /F "%WINDIR%\Logs\MeasuredBoot\*.log"	>nul 2>&1
	DEL /S /Q /F "%WINDIR%\SoftwareDistribution\DataStore\Logs\"	>nul 2>&1
	DEL /S /Q /F "%WINDIR%\runSW.log"	>nul 2>&1
	DEL /S /Q /F "%WINDIR%\system32\sru\*.log"	>nul 2>&1
	DEL /S /Q /F "%WINDIR%\system32\sru\*.dat"	>nul 2>&1
	DEL /S /Q /F "%WINDIR%\LiveKernelReports\*.dmp"	>nul 2>&1


:USERPROFILECLEANUP
ECHO Cleaning up user profiles
setlocal enableextensions
For /d %%u in (c:\users\*) do (
DEL /S /Q /F "%%u\Local Settings\Temp\"	>nul 2>&1
DEL /S /Q /F "%%u\AppData\Local\Temp\"	>nul 2>&1
DEL /S /Q /F "%%u\AppData\Local\Microsoft\Explorer\ThumbCacheToDelete\"	>nul 2>&1
DEL /S /Q /F "%%u\AppData\Local\CrashDumps\" >nul 2>&1
DEL /S /Q /F "%%u\AppData\LocalLow\Microsoft\CryptnetUrlCache\Content\"	>nul 2>&1
DEL /S /Q /F "%%u\AppData\Roaming\Microsoft\Teams\Service Worker\CacheStorage\"	>nul 2>&1
DEL /S /Q /F "%%u\AppData\Local\Microsoft\explorer\thumbcache*"	>nul 2>&1
DEL /S /Q /F "%%u\AppData\Local\CrashDumps\"	>nul 2>&1

)

:WEBBrowsers
@ECHO OFF

 ECHO Removing temporary Internet Browser cache, no user data will be deleted
	taskkill /f /IM "iexplore.exe"	>nul 2>&1
	taskkill /f /IM "msedge.exe"	>nul 2>&1
	taskkill /f /IM "msedgewebview2.exe"	>nul 2>&1
	taskkill /f /IM "chrome.exe">nul 2	>&1
	taskkill /f /IM "firefox.exe">nul 2	>&1

 ECHO cleaning Internet Explorer cache

	C:\Windows\System32\rundll32.exe InetCpl.cpl, ClearMyTracksByProcess 255
	C:\Windows\System32\rundll32.exe InetCpl.cpl, ClearMyTracksByProcess 4351

 ECHO Cleaning Google Chrome Cache

	For /d %%u in (c:\users\*) do (
	del /q /s /f "%%u\AppData\Local\Google\Chrome\User Data\Default\Cache\cache_data\"	>nul 2>&1
	del /q /s /f "%%u\AppData\Local\Google\Chrome\User Data\Default\Code Cache\js\"	>nul 2>&1
	del /q /s /f "%%u\AppData\Local\Google\Chrome\User Data\Default\Service Worker\CacheStorage\"	>nul 2>&1
	del /q /s /f "%%u\AppData\Local\Google\Chrome\User Data\Default\Service Worker\ScriptCache\"	>nul 2>&1
	del /q /s /f "%%u\AppData\Local\Google\Chrome\User Data\Default\Cache\cache_data\data_0\"	>nul 2>&1
	del /q /s /f "%%u\AppData\Local\Google\Chrome\User Data\Default\Cache\cache_data\data_1\"	>nul 2>&1
	del /q /s /f "%%u\AppData\Local\Google\Chrome\User Data\Default\Cache\cache_data\data_2\"	>nul 2>&1
	del /q /s /f "%%u\AppData\Local\Google\Chrome\User Data\Default\Cache\cache_data\data_3\"	>nul 2>&1
	del /q /s /f "%%u\AppData\Local\Google\Chrome\User Data\Profile 1\Cache\cache_data\"	>nul 2>&1
	del /q /s /f "%%u\AppData\Local\Google\Chrome\User Data\Profile 2\Cache\cache_data\"	>nul 2>&1
	del /q /s /f "%%u\AppData\Local\Google\Chrome\User Data\component_crx_cache\"	>nul 2>&1
	del /q /s /f "%%u\AppData\Local\Google\Chrome\User Data\GrShaderCache\"	>nul 2>&1
	del /q /s /f "%%u\AppData\Local\Google\Chrome\User Data\ShaderChache\"	>nul 2>&1
	del /q /s /f "%%u\AppData\Local\Google\Chrome\User Data\Default\gpucache\"	>nul 2>&1
)
ECHO Cleaning Edge -Chromium- Cache

	For /d %%u in (c:\users\*) do (
	del /q /s /f "%%u\AppData\Local\Microsoft\Edge\User Data\Default\Cache\cache_data\" >nul 2>&1
	del /q /s /f "%%u\AppData\Local\Microsoft\Edge\User Data\Default\Code Cache\js\" >nul 2>&1
	del /q /s /f "%%u\AppData\Local\Microsoft\Edge\User Data\Default\Service Worker\CacheStorage\" >nul 2>&1
	del /q /s /f "%%u\AppData\Local\Microsoft\Edge\User Data\Default\Service Worker\ScriptCache\" >nul 2>&1
	del /q /s /f "%%u\AppData\Local\Microsoft\Edge\User Data\Default\Cache\cache_data\data_0\" >nul 2>&1
	del /q /s /f "%%u\AppData\Local\Microsoft\Edge\User Data\Default\Cache\cache_data\data_1\" >nul 2>&1
	del /q /s /f "%%u\AppData\Local\Microsoft\Edge\User Data\Default\Cache\cache_data\data_2\" >nul 2>&1
	del /q /s /f "%%u\AppData\Local\Microsoft\Edge\User Data\Default\Cache\cache_data\data_3\" >nul 2>&1
	del /q /s /f "%%u\AppData\Local\Microsoft\Edge\User Data\Profile 1\Cache\cache_data\" >nul 2>&1
	del /q /s /f "%%u\AppData\Local\Microsoft\Edge\User Data\Profile 1\Service Worker\CacheStorage\" >nul 2>&1
	del /q /s /f "%%u\AppData\Local\Microsoft\Edge\User Data\Profile 1\Code Cache\js\" >nul 2>&1
	del /q /s /f "%%u\AppData\Local\Microsoft\Edge\User Data\Profile 2\Cache\cache_data\" >nul 2>&1
	del /q /s /f "%%u\AppData\Local\Microsoft\Edge\User Data\Profile 2\Service Worker\CacheStorage\" >nul 2>&1
	del /q /s /f "%%u\AppData\Local\Microsoft\Edge\User Data\Profile 2\Code Cache\js\" >nul 2>&1
	del /q /s /f "%%u\AppData\Local\Microsoft\Edge\User Data\component_crx_cache\" >nul 2>&1
	del /q /s /f "%%u\AppData\Local\Microsoft\Edge\User Data\GrShaderCache\" >nul 2>&1
	del /q /s /f "%%u\AppData\Local\Microsoft\Edge\User Data\ShaderChache\" >nul 2>&1
	del /q /s /f "%%u\AppData\Local\Microsoft\Edge\User Data\Default\gpucache\" >nul 2>&1
)
ECHO Re-enabling hibernation
	powercfg -h on
echo ********************************************
ECHO New free space of hard drive:
	fsutil volume diskfree c:
echo ********************************************

	color 0A
ECHO All cleaned up, have a nice day!

	PAUSE











