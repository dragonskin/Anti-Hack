// antihack_constants.inc

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

stock String:Potiental_Threat_Words[][32] = {"LMAOBOX",
										"GET LMAOBOX!",
										"WWW.LMAOBOX.NET",
										"TMCheats",
										"AimJunkies",
										"AvengedCheats",
										"weebly",
										"AIMWARE"};

enum AntiHackSQLType
{
	SQLType_Unknown = 0,
	SQLType_MySQL,
	SQLType_SQLite,
}

// Games that AntiHack Supports
enum eGameNumberValve {
	AHGame_Unknown = 0,
	AHGame_CSS,
	AHGame_TF2,
	AHGame_DODS,
	AHGame_INSMOD,
	AHGame_L4D,
	AHGame_L4D2,
	AHGame_HL2DM,
	AHGame_FOF,
	AHGame_GMOD,
	AHGame_HL2CTF,
	AHGame_HIDDEN,
	AHGame_ND,
	AHGame_CSGO,
};

enum AHHackerProp
{
	iPlayerID,
	iFirstTimeHacked,
	iLastTimeHacked,
	bool:bIsHacker,
	bool:bAntiAimbot,
	bool:bChanceOnHit,
	bool:bNoDamage,
	iAimbotCount,
	iSpinhackCount,
	iEyeAnglesCount,
	iChangingInterfaceCount,
	iChangingTimerCount,
	iRewritingMovementCommandsCount,
	iChangingViewAnglesAimbotCount,
	iCrashed,
}

enum Potential_Threat
{
	// For new possible threats that are experiemental and should be ignored
	PT_Experimental = 0,

	// Possible Potiental Threats
	Aim_PT,
	Eye_PT
	Spin_PT,

	// Commands Misuse Potential Threats
	Command_Rewrite_PT,
	Command_Changing_Timer_PT,
	Command_Changing_Interface_PT,

	// Lists of Bans from the internet
	EAC_Potential_Threat,
	ESEA_Potential_Threat,
};

