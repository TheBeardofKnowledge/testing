        _ **  WHY 2 FILES, WHICH ONE DO I RUN?**_

:  DISKCLEANUP.BAT IS THE CLEAN VERSION WITH ONLY STATUS MESSAGES SHOWN ON SCREEN WHILE RUNNING - RECOMMENDED  :
:                                                                                                              :
:  DISKCLEANUP-RAW.BAT IS THE SAME ACTIONS, BUT VERBOSE, AND WILL SHOW COMPLETE CURRENT STATUS AND ANY ERRORS. :

Aren't you tired of Windows and programs leaving everything old all over your drive and taking up unnecessary space? 
  Yeah, me too, so I started doing something about it... this script.

  The target use for this is home and work computers running Windows 7, 8, 10, and 11 (no servers)
The idea is to only remove what won't negatively affect a Windows Workstations while reclaiming as much free space as possible.
When it comes to web browser files, I opted to only delete cache, as many users depend on cookies and autofill data.

This has been made as an accumulation of a lot of testing, and adding to the script until 
it covered as much "safe to delete" temporary files as possible for the most commonly seen situations.
This is solely based on my experience, so if perhaps you know of something else that I missed
and you would like to see covered or added in here, shoot me some info here or on social media.
You can find all my socials and contact info on my profile page.
                                      
	**|SCRIPT WALKTHROUGH |**
					
The script itself is commented in each section, comments are indicated by :: at the beginning, but heres the full monty explanation...

:checkPriveleges - Checks for admin rights, and if the script is unelevated, moves to elevation

:getPrivileges - elevates in order to clean properly using powershell command

:StartIntro - Simple display of text on screen providing some information and credits to those who help improve the script.  A "shout out" if you will, with a 10 second timeout before it continues.

:outdatedhibernatefile - This disables Windows hibernation, also known as "Fast Startup" and deletes the hibernation file. This Windows feature dumps ram to disk for restarts and also "deep sleep" modes, however, the feature was created when all computers had spinning disks. When you warm boot your computer, everything in the hibernation file is restored to RAM and your system is presumably "ready faster".  Issue here is files are only replaced with "fresh copies" when you cold boot a system, which can cause issues. Disabling this will ensure only fresh copies are loaded when you start your system.

:badprintjobs - exactly what it sounds like... leftover unprinted jobs that stay in your system because windows doesn't remove them, ever! This clears out all print jobs held by windows.

:fontcache - Clears out the windows font cache so that all fonts are loaded from their perspective font file when used... clears graphical issues

:WindowsUpdatesCleanup - Let's face it, Microsoft is a hoarder when it comes to Windows Updates, it will store them in your system in case any other computers on your network need them, so that they can be shared over your network vs downloading from microsoft... a resource saver for Microsoft, a storage eater for end users. While this is an OK idea, it is rarely used, so we are clearing that out from their respective folders.  It stops all windows updates and related services, clears the files, then starts up the same windows update services so it can ready to update your computer.

:WindowsTempFilesCleanup - Exactly as it sounds... deletes all known temp files used by windows temporary directories and files.  These files really never get expunged on their own, but Windows starts over on these when empty, so don't worry.

:userprofilecleanup - many of the things you run, install and use when logged into windows also use a temp directory in your profile folder or file to work from, but same as the above, it's never cleaned. This remove them and allows fresh copies to be rebuilt automatically when you actually need them.  These are all the commmon directories I know of.

:therecyclebinisnotafolder - tongue in cheek on the name there because yes... you would be surprised how many people dont clear our their recycle bin. This clears it so windows immediately recreates it, but empty.

:userprogramscachecleanup - Beginning of the section dedicated to clearing out common program cache from often use software that ends up glitching because of bad/outdated cache.
More will be added as requests come up... for now it does itunes, microsoft teams, outlook, and for corporate pc's; SCCM cache.

:itunes - deletes the stored update downloads that are used to update itunes... because they don't get deleted, ever.

:freakenmicrosoftteams - yes, the worldwide program that is both loved and hated very often suffers from cache problems... things like not showing messages, marking you offline, etc.  This clears out the folders recommended by Microsoft to have teams perform a full refresh of the session.

:outlookcache - not often, but it happens that outlook operations stay stuck in limbo due to a cache sync problem.  This will clear the cache. 

:WebBrowsers - clears all from common web browsers.internet explorer (yes, your system still has it for "IE compatibility mode") For Microsoft Edge Chromium, and of course Chrome itself I only have it deleting cache, as I found too many people depended on cookies, history, and autofill data to do a full clear. Because the web browsers save cache data per user, the script runs a for each loop on each user directory.  Firefox I am still working on because it controls its cache in a differrent manner.

:CleanMgr - This configures and uses Microsofts built-in disk cleanup tool with all available options enabled.  First it creates a "SageSet" Registry entries are added to the system to ensure all options enabled, then the ulitity is run with those enabled with "sagerun".

:restorepointscleanup
and
:PreviousWindowsInstalls - these sections are a little controversial because it will delete any previous system restore points and previous windows installations.  Why is it controvercial, and why did I leave a confirmation prompt?  Because you should have a choice on these in case you're unsure about the stability of a recent update or upgrade.



