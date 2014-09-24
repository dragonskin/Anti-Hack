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

new HistoryCount=0;

new Float:CachedAngle[MAXPLAYERS + 1][MaxHistory][3];
new Float:CachedPos[MAXPLAYERS + 1][MaxHistory][3];

new Blocked_Players_ID[MAXPLAYERS + 1];

new g_iAimDetections[MAXPLAYERS+1];

new Handle:g_hCvarAimbotBan = INVALID_HANDLE;

new Handle:g_hPotientalThreatWords = INVALID_HANDLE;

new Handle:h_antihack_wordsearch_location = INVALID_HANDLE;

new Hanlde:h_antihack_wordsearch_extremefilter = INVALID_HANDLE;
new bool:ExtremeFiltering=false;

new Handle:h_antihack_ban = INVALID_HANDLE;
new bool:AllowBans=true;

new Handle:g_hOnAHSayCommandFilter;


new TrackNameChanges[MAXPLAYERS+1];
new bool:TrackNameChangesTriggered[MAXPLAYERS+1];
new String:sOldName[MAXPLAYERS+1][64];
