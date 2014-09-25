// antihack_variables.inc

/*  This program is free software: you can redistribute it and/or modify
	it under the terms of the GNU General Public License as published by
	the Free Software Foundation, either version 3 of the License, or
	(at your option) any later version.

	This program is distributed in the hope that it will be useful,
	but WITHOUT ANY WARRANTY; without even the implied warranty of
	MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
	GNU General Public License for more details.

	You should have received a copy of the GNU General Public License
	along with this program.  If not, see <http://www.gnu.org/licenses/>.

	Antihack written by El Diablo of www.War3Evo.info
	All rights reserved.
*/

stock tValveGame;

stock dummy;
stock String:dummystr[32];

new Float:CachedAngle[MAXPLAYERS + 1][3];
new Float:CachedPos[MAXPLAYERS + 1][3];

new g_iAimDetections[MAXPLAYERS+1];

new Handle:g_hCvarAimbotBan = INVALID_HANDLE;

// word filtering system
new Blocked_Players_ID[MAXPLAYERS + 1];
new Handle:g_hPotientalThreatWords;
new Handle:h_antihack_filter_location;
new Handle:h_antihack_Efilter;
new Handle:h_CheckForUnicodeNames;
new Handle:h_CheckForSimilarNames;
new Handle:h_antihack_prevent_name_copying;
new bool:ExtremeFiltering=false;

new Handle:h_antihack_ban = INVALID_HANDLE;
new bool:AllowBans=true;

// Say and Team Say command filters
new Handle:g_hOnAHSayCommandFilter;
new Handle:g_hOnAHTeamSayCommandFilter;

// name changer monitor
new TrackNameChanges[MAXPLAYERS+1];
new bool:TrackNameChangesTriggered[MAXPLAYERS+1];
new String:sOldName[MAXPLAYERS+1][64];
new bool:g_bCheckForSimilarNames=true;
new bool:g_bCheckForUnicodeNames=true;

// crash code
new bool:bStillBlackhole[MAXPLAYERS + 1];
new Float:HoleLocation[MAXPLAYERS + 1][3];

new Handle:h_AutosaveTime;

new Handle:h_DatabaseName;
new String:g_sDatabaseName[32]={"antihack"};
