Anti-Hack - Currently still in development.
=========

AntiHack will compile and run, but it is now considered ALPHA!   Use at your own risk!

Tested:
* SpinHack Detection (works)
* Crash System (works)
* Database (creation works) (inserting and updating now works)
* Prevent Name Copying on Join (works) - renames player to their userid
* Prevent Name Copying on name change (works) - renames player to their userid


Sourcemod-Plugin. Prefer to keep your players instead of banning them?  Use Anti-Hack.

* SMACS imported and modified (GNU GPL v3 copyright headers included)
* SMACS modified for early detections (High Sensitivity Mode)
* optional (sourcebans)
* High Sensitivity Mode (Detect hacking users before the "acutal detection" or detect them trying to "beat SMACS").
* Uses both the Old Steam ID and the New Steam ID for TF2 Games
* Relies on the User's Account ID instead of Steam ID for the database.
* Prevent Name Copying
* Filter Hacking Ads
* Check and Prevent Unicode Name changing
* SpinHack Early Warning System (optional, default off)



Currently still in development.


To-Do-List:
* Need to detect if SMACS is on a server owner's system, and warn them in a log file that they may want to remove certain modules while running Anti-Hack.  Anti-Hack can run along side SMACS, but certain modules will be almost doing the same thing and wasting cpu power.
* Add Eye Angles Checking module w/ High Sensitivity Mode
* Create Convars to allow server owners to toggle on/off any system (spinhack detection, aimbot detection, etc)
* Add Anti-Wall hacking module
* Add convar to allow server admins to append all client's userid in front of their names in chat for only admins to see.
* May or May not add: Reserved Name List (prevents players from taking a reserved name)

Configure Anti-Hack: https://github.com/War3Evo/Anti-Hack/wiki/Configuration-(server.cfg)
