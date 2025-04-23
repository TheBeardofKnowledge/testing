::::::::::::::::::::::::::::::::::::::::::::
:: Automatically check & get admin rights ::
::::::::::::::::::::::::::::::::::::::::::::
@ECHO OFF
color f0
ECHO =============================
ECHO Running Admin shell
ECHO =============================
 
:checkPrivileges 
	NET FILE 1>NUL 2>NUL
	if '%errorlevel%' == '0' ( goto gotPrivileges ) else ( goto getPrivileges ) 
:getPrivileges
:: Not elevated, so re-run with elevation
    	powershell -Command "Start-Process cmd -ArgumentList '/c %~s0 %*' -Verb RunAs"
    	exit /b
	)
:gotPrivileges 
::::::::::::::::::::::::::::
:STARTINTRO
::::::::::::::::::::::::::::
::cls
	@ECHO OFF
color
	TITLE The Greatest Disk Cleanup thats Ever Lived! TBOK disk cleanup script!
	ECHO TBOK automagic disk cleanup script!
	ECHO Community effort can be tracked at https://github.com/TheBeardofKnowledge/Scripts-from-my-videos
	ECHO	Purpose of this batch file is to recover as much "safe" free space from your windows system drive
	ECHO	in order to gain back free space that Windows, other programs, and users themselves have consumed.
	ECHO 	Credits: Because the work we do in I.T. is often unrecognized, this section will show anyone
	ECHO 	who contributes to the script to improve it.
	ECHO 	TheBeardofKnowledge https://thebeardofknowledge.bio.link/
	ECHO 	Contribution and Improvements credit on this script goes to the following....
	ECHO 	Thank You to all that have given helpful feedback for improvements!
	ECHO 	Credit...RayneDance.. https://github.com/RayneDance For improving ::chrome/edge profile handling...ThankYou!
	ECHO 	Credit....yourhandle/link here2....................For improving ::xyz....ThankYou!
	ECHO 	Credit.....yourhandle/link here3..................For improving ::xyz.....ThankYou!
	ECHO 	Credit......yourhandle/link here4................For improving ::xyz......ThankYou!
	ECHO 	Credit.......yourhandle/link here5..............For improving ::xyz.......ThankYou!
	ECHO 	Credit........yourhandle/link here6............For improving ::xyz........ThankYou!
	ECHO 	Credit.........yourhandle/link here7..........For improving ::xyz.........ThankYou!
	ECHO 	Credit..........yourhandle/link here8........For improving ::xyz..........ThankYou!
	ECHO 	Credit...........yourhandle/link here9......For improving ::xyz...........ThankYou!
	ECHO 	Credit............yourhandle/link here10...For improving ::xyz............ThankYou!
	ECHO Version 04-22-2025 mm/dd/yyyy
:StartofScript
	echo ********************************************
	ECHO 	Your Current free space of hard drive:
		fsutil volume diskfree c:
	echo ********************************************
	TIMEOUT 10

:OutdatedHibernateFile
	ECHO disabling hibernation and deleting the hibernation file
	ECHO This also disables the Windows Fast Startup and forever "Up Time"
		powercfg -h off	

:BadPrintJobs
	ECHO Deleting unreleased erroneous print jobs
	NET STOP /Y Spooler 
	DEL /S /Q /F %systemdrive%\windows\system32\spool\printers\*.* 
	net start spooler 
	
:fontcache
	Net stop fontcache 
	DEL /S /Q /F %systemdrive%\Windows\ServiceProfiles\LocalService\AppData\Local\*.* /s /q 
	NET start fontcache	

:WindowsUpdatesCleanup
	echo STOPPING WINDOWS UPDATE SERVICES
	net stop bits 
	net stop wuauserv 
	net stop appidsvc 
	net stop cryptsvc 
	DEL /S /Q /F “%ALLUSERSPROFILE%\Application Data\Microsoft\Network\Downloader\”	
	rmdir /S /Q "%systemroot%\SoftwareDistribution" 
	rmdir /S /Q "%systemroot%\system32\catroot2" 
::commented out the below line because rolling back updates is needed, and it's usually only 1-2Gb.  If you don't care about rolling back updates (DANGER Will Robinson), remove the :: in front of the next line.	
	::rmdir /S /Q "%systemroot%\Installer\$PatchCache$"
	DEL /S /Q /F "systemroot%\ServiceProfiles\NetworkService\AppData\Local\Microsoft\Windows\DeliveryOptimization\Logs\*.*" 
	echo STARTING WINDOWS UPDATE SERVICES AFTER CLEANUP
	net start bits 
	net start wuauserv 
	net start appidsvc 
	net start cryptsvc 

:WindowsTempFilesCleanup
	ECHO Deleting all System temporary files, this may take a while...
	@ECHO OFF
	DEL /S /Q /F "%TMP%\" 	
	DEL /S /Q /F "%TEMP%\" 
	DEL /S /Q /F "%WINDIR%\Temp\" 
	DEL /S /Q /F "%WINDIR%\Prefetch\" 
	DEL /S /Q /F "%WINDIR%\Logs\CBS\" 
	DEL /S /Q /F "%WINDIR%\Logs\DPX\*.log" 
	DEL /S /Q /F "%WINDIR%\Logs\DISM\*.log" 
	DEL /S /Q /F "%WINDIR%\Logs\MeasuredBoot\*.log" 
	DEL /S /Q /F "%WINDIR%\SoftwareDistribution\DataStore\Logs\" 
	DEL /S /Q /F "%WINDIR%\runSW.log" 
	DEL /S /Q /F "%WINDIR%\system32\sru\*.log" 
	DEL /S /Q /F "%WINDIR%\system32\sru\*.dat" 
	DEL /S /Q /F "%WINDIR%\LiveKernelReports\*.dmp"	
	DEL /S /Q /F "%WINDIR%\appcompat\backuptest\" 
	
:UserProfileCleanup
	ECHO Cleaning up user profiles
	setlocal enableextensions
	For /d %%u in (c:\users\*) do (
	DEL /S /Q /F "%%u\Local Settings\Temp\*.*"	
	DEL /S /Q /F "%%u\AppData\Local\Temp\*.*"	
	DEL /S /Q /F "%%u\AppData\Local\Microsoft\Explorer\ThumbCacheToDelete\*.*"	
	DEL /S /Q /F "%%u\AppData\Local\CrashDumps\*.*" 	
	DEL /S /Q /F "%%u\AppData\LocalLow\Microsoft\CryptnetUrlCache\Content\*.*"	
	DEL /S /Q /F "%%u\AppData\Roaming\Microsoft\Teams\Service Worker\CacheStorage\*.*"	
	DEL /S /Q /F "%%u\AppData\Local\Microsoft\explorer\thumbcache*"	
	DEL /S /Q /F "%%u\AppData\Local\CrashDumps\*.*"	
	)
:TheRecycleBinIsNotAfolder
	ECHO Emptying the recycle bin... you weren't ACTUALLY storing stuff in there, were you? I hope not.
	rd /s /q %systemdrive%\$Recycle.bin	
:UserProgramsCacheCleanup
	Echo Cleaning up cache from programs that are space hogs
:iTunes
	ECHO Clearing iTunes cached installers, iOS device firmware cache for all users
	taskkill /f /IM itunes.exe 
	RD /S /Q "%systemdrive%\ProgramData\Apple Inc\Installer Cache"	
	For /d %%u in (c:\users\*) do (
	RD /S /Q "%%u\AppData\roaming\Apple Computer\iTunes\iPhone Software Updates"	
	RD /S /Q "%%u\AppData\roaming\Apple Computer\iTunes\iPod Software Updates"	
	)
ECHO iOS device Backups cleanup
	set /p a=Do you wish to also delete any existing mobile phone iTunes device backups? [Y/N]?
	if /I "%a%" EQU "Y" goto iOSbackups
	if /I "%a%" EQU "N" goto FreakenMicrosoftTeams
:iOSbackups
	For /d %%u in (c:\users\*) do (
	RD /S /Q "%%u\AppData\roaming\Apple Computer\MobileSync\Backup"	
	)
:FreakenMicrosoftTeams
	ECHO Clearing Microsoft Teams Cache for all users
	%systemdrive%\windows\system32\taskkill /F /IM teams.exe 
	%systemdrive%\windows\system32\taskkill /F /IM ms-teams.exe 
	For /d %%u in (c:\users\*) do (
	RD /S /Q "%%u\AppData\roaming\microsoft\teams"			
	RD /S /Q "%%u\AppData\roaming\microsoft\teams\blob_storage"	
	RD /S /Q "%%u\AppData\roaming\microsoft\teams\cache"		
	RD /S /Q "%%u\AppData\roaming\microsoft\teams\databases"	
	RD /S /Q "%%u\AppData\roaming\microsoft\teams\gpucache"		
	RD /S /Q "%%u\AppData\roaming\microsoft\teams\indexeddb"	
	RD /S /Q "%%u\AppData\roaming\microsoft\teams\Local Storage"	
	RD /S /Q "%%u\AppData\roaming\microsoft\teams\tmp"		
	RD /S /Q "%%u\AppData\Local\Packages\MSTeams_8wekyb3d8bbwe"	
	)

:OutlookCache
	ECHO Clearing Outlook Cache
	%systemdrive%\windows\system32\taskkill /F /IM outlook.exe 
	For /d %%u in (c:\users\*) do (
	RD /S /Q "%%u\AppData\Microsoft\Outlook\RoamCache\"	 
	)	
::SCCM	
::commented this out because SCCM doesn't rebuild cache if deleted manually and will fail to show/install software.
::Will update to use powershell command using date/time and will have validations.
::Reserved for SCCM cleanup powershell invoke script
::	ECHO Cleaning CCM Cache
::	DEL /S /Q /F "%systemdrive%\windows\ccmcache\"	 

:WEbBrowsers
	ECHO IExplore, Edge, Chrome, and Edgewebview Web browsers will be closed in order to clean all cache, remember CTRL+SHIFT+T to restore your browsing sessions.
	PAUSE
	ECHO Terminating Browsers and Removing temporary Internet Browser cache, no user data will be deleted
	taskkill /f /IM "iexplore.exe" 
	taskkill /f /IM "msedge.exe" 
	taskkill /f /IM "msedgewebview2.exe" 
	taskkill /f /IM "chrome.exe" 

:InternetExploder
 ECHO Cleaning Internet Explorer cache
	%systemdrive%\Windows\System32\rundll32.exe InetCpl.cpl, ClearMyTracksByProcess 255 
	%systemdrive%\Windows\System32\rundll32.exe InetCpl.cpl, ClearMyTracksByProcess 4351 

:GoogleChrome
 ECHO Cleaning Google Chrome Cache

	SETLOCAL EnableDelayedExpansion
	For /d %%u in ("%systemdrive%\users\*") do (
	SET "chromeDataDir=%%u\AppData\Local\Google\Chrome\User Data"
	SET "folderListFile=!TEMP!\chrome_profiles.txt"

	REM Find the matching folders and store them in the temporary file
	FOR /D %%A IN ("!chromeDataDir!\Default" "!chromeDataDir!\Profile *") DO (
	ECHO %%~nA>> "!folderListFile!"
	)

	IF EXIST "!folderListFile!" (
	FOR /F "usebackq tokens=*" %%B IN ("!folderListFile!") DO (
		del /q /s /f "!chromeDataDir!\%%B\Cache\cache_data\"	
		del /q /s /f "!chromeDataDir!\%%B\Code Cache\js\"	
		del /q /s /f "!chromeDataDir!\%%B\Code Cache\wasm\"	
		del /q /s /f "!chromeDataDir!\%%B\Service Worker\CacheStorage\"	
		del /q /s /f "!chromeDataDir!\%%B\Service Worker\ScriptCache\"	
		del /q /s /f "!chromeDataDir!\%%B\gpucache\"	
			)
		)
		del /q /s /f "!chromeDataDir!\component_crx_cache\"	
		del /q /s /f "!chromeDataDir!\GrShaderCache\"	
		del /q /s /f "!chromeDataDir!\ShaderChache\"	

		REM Clean up the temporary file after each profile is processed
    	IF EXIST "!folderListFile!" DEL /Q /F "!folderListFile!"
	)
	ENDLOCAL
		
:EdgeChromiumCache
ECHO Cleaning Edge -Chromium- Cache
	SETLOCAL EnableDelayedExpansion
	For /d %%u in ("%systemdrive%\users\*") do (
	SET "edgeDataDir=%%u\AppData\Local\Microsoft\Edge\User Data"
	SET "folderListFile=!TEMP!\edge_profiles.txt"

	REM Find the matching folders and store them in the temporary file
	FOR /D %%A IN ("!edgeDataDir!\Default" "!edgeDataDir!\Profile *") DO (
	ECHO %%~nA>> "!folderListFile!"
	)

	IF EXIST "!folderListFile!" (
	FOR /F "usebackq tokens=*" %%B IN ("!folderListFile!") DO (
		del /q /s /f "!edgeDataDir!\%%B\Cache\cache_data\"	
		del /q /s /f "!edgeDataDir!\%%B\Code Cache\js\"	
		del /q /s /f "!edgeDataDir!\%%B\Code Cache\wasm\"	
		del /q /s /f "!edgeDataDir!\%%B\Service Worker\CacheStorage\"	
		del /q /s /f "!edgeDataDir!\%%B\Service Worker\ScriptCache\"	
		del /q /s /f "!edgeDataDir!\%%B\gpucache\"	
			)
		)
		del /q /s /f "!edgeDataDir!\component_crx_cache\"	
		del /q /s /f "!edgeDataDir!\GrShaderCache\"	
		del /q /s /f "!edgeDataDir!\ShaderChache\"	

		REM Clean up the temporary file after each profile is processed
    	IF EXIST "!folderListFile!" DEL /Q /F "!folderListFile!"
	)
	ENDLOCAL

:FireFoxCacheWorkInProgress
::	taskkill /f /IM "firefox.exe" 
::	
::	For /d %%u in (%systemdrive%\users\*) do
::	cd /d "%%u\AppData\Local\Mozilla\Firefox\Profiles"
::
::	for /d %%a in (*.default) do (
::	if exist %%a (
::	for /D %%p in (%%a\cache2) do rmdir "%%p" /S /Q > NUL 2> NUL
::	del %%a\cache2\* /F /Q /S > NUL 2> NUL
::	for /D %%p in (%%a\startupCache) do rmdir "%%p" /S /Q > NUL 2> NUL
::	del %%a\startupCache\* /F /Q /S > NUL 2> NUL
::	for /D %%p in (%%a\jumpListCache) do rmdir "%%p" /S /Q > NUL 2> NUL
::	del %%a\jumpListCache\* /F /Q /S > NUL 2> NUL
::	for /D %%p in (%%a\OfflineCache) do rmdir "%%p" /S /Q > NUL 2> NUL
::	del %%a\OfflineCache\* /F /Q /S > NUL 2> NUL
::		)
::	)
::
::	for /d %%a in (*.default-release) do (
::	if exist %%a (
::	for /D %%p in (%%a\cache2) do rmdir "%%p" /S /Q > NUL 2> NUL
::	del %%a\cache2\* /F /Q /S > NUL 2> NUL
::	for /D %%p in (%%a\startupCache) do rmdir "%%p" /S /Q > NUL 2> NUL
::	del %%a\startupCache\* /F /Q /S > NUL 2> NUL
::	for /D %%p in (%%a\jumpListCache) do rmdir "%%p" /S /Q > NUL 2> NUL
::	del %%a\jumpListCache\* /F /Q /S > NUL 2> NUL
::	for /D %%p in (%%a\OfflineCache) do rmdir "%%p" /S /Q > NUL 2> NUL
::	del %%a\OfflineCache\* /F /Q /S > NUL 2> NUL
::		)
::	)

:CLEANMGR
	ECHO Configuring Disk Cleanup registry settings for all safe to delete content

:: Set all the CLEANMGR registry entries for Group #69 -have a sense of humor!
	SET _Group_No=StateFlags0069	
	SET _RootKey=HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\VolumeCaches /f	

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
	REG ADD "%_RootKey%\Language Pack" /v %_Group_No% /t REG_DWORD /d 00000002 /f	

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
ECHO DiskCleanup registry settings completed
ECHO Running CleanMgr and Waiting for Disk Cleanup to complete, this takes a while - do not close this window!
	START /wait CLEANMGR /sagerun:69 
ECHO Be patient, this process can take a while depending on how much temporary Crap has accummulated in your system...
	START /wait CLEANMGR /verylowdisk /autoclean	


:RestorePointsCleaup
	ECHO	//////////////////////////////////////////////////////////////////////////////////////
	ECHO	/////  Warning! To Maximize Free Space, Windows Restore Points and old Windows   /////
	ECHO	/////  installs Cleanup process is about to begin.  You will NOT be able to      /////
	ECHO	/////  restore your pc to a previous date / installation if you type Y.          /////
	ECHO	//////////////////////////////////////////////////////////////////////////////////////
	set /p c=Are you sure you wish to continue? [Y/N]?
	if /I "%c%" EQU "Y" goto removeRestorePoints
	if /I "%c%" EQU "N" goto hibernation
:removeRestorePoints
	vssadmin delete shadows /all 
::The next line can be enabled by removing the "::" if you want the system to create a new restore point.
::wmic.exe /Namespace:\\root\default Path SystemRestore Call CreateRestorePoint "AfterDiskCleanup", 100, 7 

:PreviousWindowsInstalls
	ECHO Removing any previous Windows Installations found.
:Windows.old
::The obvious Windows.old folder that is visible
	IF exist "%systemDrive%\Windows.old" (
	takeown /F "%systemDrive%\Windows.old" /A /R /D Y 
	icacls "%systemdrive%\Windows.old" /grant *S-1-5-32-544:F /T /C /Q 
	RD /s /q %systemdrive%\$Windows.old 
	) else goto windowsbt
:Windowsbt
::$Windows.~BT hidden folder
	IF exist "%systemDrive%\$Windows.~BT" (
	takeown /F "%systemDrive%\$Windows.~BT" /A /R /D Y 
	icacls %systemdrive%\$Windows.~BT\*.* /T /grant administrators:F 
	RD /s /q %systemDrive%\$Windows.`BT 
	) else goto Windowsws
:Windowsws
::$Windows.~WS hidden folder
IF exist "%systemdrive%\Windows.~WS" (
	takeown /F "%systemDrive%\$Windows.~WS" /A /R /D Y 
	icacls %systemdrive%\$Windows.~WS\*.* /T /grant administrators:F 
	RD /s /q %systemDrive%\$Windows.~WS 
	) else (
	ECHO No previous windows version folders found
	)

:hibernation
::	Reasons to leave Hibernation/Fast Startup/Hybrid Shutdown disabled on desktops...
::	1. Most modern PC's come with an SSD or m.2 drive and fast startup is not required.
::	2. Hybrid shutdown/hibernation/fast startup often causes Windows Updates to NOT install properly.
::	3. "system up time" timer in task manager keeps running with this enabled.
::	.
::	1 Reason to enable on a laptop:
::	Only good thing from Hibernate/Fast Startup is if your Laptop/Tablet battery dies while in sleep/standby mode...
::	your open files are saved because the laptop will wake, save data in ram to hibernation file, then shutdown.
	SetLocal EnableExtensions
:detectchassis
	Set "Type=" & For /F EOL^=- %%G In ('
	 %SystemRoot%\System32\WindowsPowerShell\v1.0\powershell.exe -NoProfile -Command
	 "(Get-CimInstance -Query 'Select * From CIM_Chassis').ChassisTypes"^
	 " | Select-Object -Property @{ Label = '-'; Expression = { Switch ($_) {"^
 	" { '3', '4', '5', '6', '7', '13', '15', '16', '24' -Eq $_ } { 'Desktop' };"^
 	" { '8', '9', '10', '11', '12', '14', '18', '21', '30', '31', '32' -Eq $_ } { 'Laptop' };"^
	 " default { '' } } } }" 2^>NUL') Do Set Type=%%G
	If Not Defined Type GoTo END
	Set Type
		if /i "%Type%"=="Laptop" goto laptop
		if /i "%Type%"=="Desktop" goto desktop
:laptop
	ECHO Laptop detected - enabling hibernation mode
	powercfg -h on
	goto EOF
:desktop
	ECHO Desktop detected - disabling hibernation mode
	powercfg -h off
	WAIT /10
:END	
echo ********************************************
ECHO New free space of hard drive:
	fsutil volume diskfree c:
echo ********************************************

	color 0A
ECHO All cleaned up, have a nice day!

	PAUSE










