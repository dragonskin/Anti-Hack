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

// word filtering system
new Blocked_Players_ID[MAXPLAYERS + 1];
new Handle:g_hPotientalThreatWords;
new Handle:h_antihack_filter_location;
new Handle:h_antihack_Efilter;
new bool:ExtremeFiltering=false;

new Handle:h_antihack_ban;
new bool:AllowBans=false;

new Handle:h_antihack_name_ban;
new bool:AllowNameBans=true;

new Handle:h_antihack_filter_ban;
new bool:AllowFilterBans=true;

// crash code
new bool:bStillBlackhole[MAXPLAYERS + 1];
new Float:HoleLocation[MAXPLAYERS + 1][3];

new Handle:h_AutosaveTime;

// Database
new Handle:hDB; // the database handle
new Handle:h_DatabaseName; // used for configurations
new String:g_sDatabaseName[32]={"antihack"};
new AntiHackSQLType:g_SQLType;
new bool:CanLoadDataBase=false;

// Forwards
new Handle:g_OnAHPlayerLoadData;
// Say and Team Say command filters
new Handle:g_hOnAHSayCommandFilter;
new Handle:g_hOnAHTeamSayCommandFilter;

// Saving Stuff
new Float:g_fAutosaveTime=300.0;
new Handle:h_SaveEnabled;
new bool:g_bSaveEnabled=true;

// Libraries
new bool:ircrelay_exists=false;
new bool:sourcebans_exists=false;

// Player Properties
new p_properties[MAXPLAYERS+1][AHHackerProp];
new String:p_properties_comment[MAXPLAYERS+1][300];


// High Sensitivity Mode
new Handle:h_HighSensitivityModeEnabled;
new bool:g_bHighSensitivityModeEnabled=false;

// SpinHack
new Handle:h_antihack_spinhack_crash;
new g_iCrash_OnSpinHack=2;
new Handle:h_antihack_spinhack_warning;
new bool:g_bSpinhack_warning=true;
new g_iSpinhack_Detections[MAXPLAYERS + 1];
