Anti-Hack - Currently still in development.
=========

AntiHack will compile and run, but it is now considered ALPHA!   Use at your own risk!

Tested:
* SpinHack Detection (works)
* Crash System (TF2 tested & works, other systems still need a crash test)
* Database (creation works) (inserting and updating now works)

Moved Prevent Name copying and unicode filter to a separate plugin that you can find here:
https://forums.alliedmods.net/showthread.php?p=2207177#post2207177

Sourcemod-Plugin. Prefer to keep your players instead of banning them?  Use Anti-Hack.

* SMACS imported and modified (GNU GPL v3 copyright headers included)
* SMACS modified for early detections (High Sensitivity Mode)
* optional (sourcebans)
* High Sensitivity Mode (Detect hacking users before the "acutal detection" or detect them trying to "beat SMACS").
* Uses both the Old Steam ID and the New Steam ID for TF2 Games
* Relies on the User's Account ID instead of Steam ID for the database.
* Filter Hacking Ads
* SpinHack Early Warning System (optional, default off)



Currently still in development.


To-Do-List:
* Need to detect if SMACS is on a server owner's system, and warn them in a log file that they may want to remove certain modules while running Anti-Hack.  Anti-Hack can run along side SMACS, but certain modules will be almost doing the same thing and wasting cpu power.
* Add Eye Angles Checking module w/ High Sensitivity Mode
* Create Convars to allow server owners to toggle on/off any system (spinhack detection, aimbot detection, etc)
* Add Anti-Wall hacking module
* Add webpage access feature w/ admin controls & comments
* -- Extra features for webpanel: instant server control adjustment (requires rcon access), Live Feedback from server (requires java console application [opensource]), email notifications, include charts for the data, add ranking (ranks based on how sure the server is that the person is hacking), allow some records to be public display
* Add High-Sensitivity Tracking to the database (including the variables used for each track count)
* Add ability for admins to "see thru walls" only while in spectator mode (TF2 only) -- helps admins identify wall hackers on your server.   Hackers whom tend to "know" players coming around a corner or not.


https://github.com/War3Evo/Anti-Hack/wiki/Configuration-(server.cfg)
