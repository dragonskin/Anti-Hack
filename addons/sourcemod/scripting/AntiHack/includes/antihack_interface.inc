// *************************************************************************
// Antihack
//
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

/**
 * LISTS NATIVES AND FORWARDS, BUT NOT ACTUALLY DEFINES THE CODE
 */

#undef REQUIRE_EXTENSIONS

#include <sourcemod>
#include <antihack>

#include <sdktools_functions>

#tryinclude <morecolors>

#include "AntiHack/includes/antihack_variables.inc"
#include "AntiHack/includes/antihack_constants.inc"


public APLRes:AskPluginLoad2(Handle:plugin,bool:late,String:error[],err_max)
{
	new String:gameDir[64];
	GetGameFolderName(gameDir, sizeof(gameDir));

	if ((StrContains(gameDir, "cstrike", false) == 0)  || (StrContains(gameDir, "cstrike_beta", false) == 0))
	{
		tValveGame = _:AHGame_CSS;
	}
	else if (StrContains(gameDir, "dod", false) == 0)
	{
		tValveGame = _:AHGame_DODS;
	}
	else if(StrContains(gameDir, "insurgency", false) == 0)
	{
		tValveGame = _:AHGame_INSMOD;
	}
	else if(StrContains(gameDir, "hl2mp", false) == 0)
	{
		tValveGame = _:AHGame_HL2DM;
	}
	else if(StrContains(gameDir, "fistful_of_frags", false) == 0)
	{
		tValveGame = _:AHGame_FOF;
	}
	else if(StrContains(gameDir, "garrysmod", false) == 0)
	{
		tValveGame = _:AHGame_GMOD;
	}
	else if(StrContains(gameDir, "hl2ctf", false) == 0)
	{
		tValveGame = _:AHGame_HL2CTF;
	}
	else if(StrContains(gameDir, "hidden", false) == 0)
	{
		tValveGame = _:AHGame_HIDDEN;
	}
	else if(StrContains(gameDir, "nucleardawn", false) == 0)
	{
		tValveGame = _:AHGame_ND;
	}
	else if((StrContains(gameDir, "tf", false) == 0) || (StrContains(gameDir, "tf_beta", false) == 0))
	{
		tValveGame = _:AHGame_TF2;
	}
	else if(StrContains(gameDir, "left4dead2", false) == 0)
	{
		tValveGame = _:AHGame_L4D2;
	}
	else if(StrContains(gameDir, "left4dead", false) == 0)
	{
		tValveGame = _:AHGame_L4D;
	}
	else if(StrContains(gameDir, "csgo", false) == 0)
	{
		tValveGame = _:AHGame_CSGO;
	}
	else
	{
		SetFailState("[AntiHack] Sorry, this game isn't support by AntiHack yet. If you think this is a mistake, you probably renamed your game directory. For example, re-naming cstrike to cstrike2 will cause this error. (folder name: %s)", gameDir);
	}

	new Function:func;
	func=GetFunctionByName(plugin, "AHInitNativesForwards");
	if(func!=INVALID_FUNCTION) {
		Call_StartFunction(plugin, func);
		Call_Finish(dummy);
		if(!dummy) {
			LogError("AHInitNativesForwards did not return true, possible failure");
		}
	}

	PrintToServer("");
	PrintToServer("");
	PrintToServer("    #    #     # ####### ### #     #    #     #####  #    # ");
	PrintToServer("   # #   ##    #    #     #  #     #   # #   #     # #   #  ");
	PrintToServer("  #   #  # #   #    #     #  #     #  #   #  #       #  #   ");
	PrintToServer(" #     # #  #  #    #     #  ####### #     # #       ###    ");
	PrintToServer(" ####### #   # #    #     #  #     # ####### #       #  #   ");
	PrintToServer(" #     # #    ##    #     #  #     # #     # #     # #   #  ");
	PrintToServer(" #     # #     #    #    ### #     # #     #  #####  #    # ");
	PrintToServer("");
	PrintToServer("");

	new String:version[64];
	Format(version,sizeof(version),"%s by %s",VERSION_NUM,AUTHORS);
	CreateConVar("antihack_version",version,"AntiHack version.",FCVAR_PLUGIN|FCVAR_SPONLY|FCVAR_REPLICATED|FCVAR_NOTIFY|FCVAR_DONTRECORD);

	return APLRes_Success;
}
/**********************
 * Implement this if you have natives/forwards
 */
forward bool:AHInitNativesForwards();

stock ValveGameEnum:AH_GetGame()
{
	return ValveGameEnum:tValveGame;
}

stock bool:GameINSMOD()
{
	return AH_GetGame() == AHGame_INSMOD;
}

stock bool:GameDOD()
{
	return AH_GetGame() == AHGame_DODS;
}

stock bool:GameHL2DM()
{
	return AH_GetGame() == AHGame_HL2DM;
}

stock bool:GameCS()
{
	return AH_GetGame() == AHGame_CSS;
}
stock bool:GameTF()
{
	return AH_GetGame() == AHGame_TF2;
}

stock bool:GameL4D1()
{
	return (AH_GetGame() == AHGame_L4D);
}

stock bool:GameL4D2()
{
	return (AH_GetGame() == AHGame_L4D2);
}

stock bool:GameL4DAny()
{
	return (AH_GetGame() == AHGame_L4D || AH_GetGame() == AHGame_L4D2);
}

stock bool:GameCSGO()
{
	return AH_GetGame() == AHGame_CSGO;
}
stock bool:GameCSANY()
{
	new ValveGameEnum:AH_Game_Detection = AH_GetGame();

	return (AH_Game_Detection == AHGame_CSS || AH_Game_Detection == AHGame_CSGO);
}
// These games support <color>
stock bool:GameCOLOR()
{
	new ValveGameEnum:AH_Game_Detection = AH_GetGame();

	return (AH_Game_Detection == AHGame_CSS
	|| AH_Game_Detection == AHGame_CSGO
	|| AH_Game_Detection == AHGame_TF2
	|| AH_Game_Detection == AHGame_HL2DM
	|| AH_Game_Detection == AHGame_DODS
	|| AH_Game_Detection == AHGame_L4D
	|| AH_Game_Detection == AHGame_L4D2);
}

// STOCKS STOCKS STOCKS STOCKS STOCKS STOCKS STOCKS STOCKS STOCKS STOCKS STOCKS
// STOCKS STOCKS STOCKS STOCKS STOCKS STOCKS STOCKS STOCKS STOCKS STOCKS STOCKS
// STOCKS STOCKS STOCKS STOCKS STOCKS STOCKS STOCKS STOCKS STOCKS STOCKS STOCKS
// STOCKS STOCKS STOCKS STOCKS STOCKS STOCKS STOCKS STOCKS STOCKS STOCKS STOCKS
// STOCKS STOCKS STOCKS STOCKS STOCKS STOCKS STOCKS STOCKS STOCKS STOCKS STOCKS
// STOCKS STOCKS STOCKS STOCKS STOCKS STOCKS STOCKS STOCKS STOCKS STOCKS STOCKS
// STOCKS STOCKS STOCKS STOCKS STOCKS STOCKS STOCKS STOCKS STOCKS STOCKS STOCKS
// STOCKS STOCKS STOCKS STOCKS STOCKS STOCKS STOCKS STOCKS STOCKS STOCKS STOCKS
// STOCKS STOCKS STOCKS STOCKS STOCKS STOCKS STOCKS STOCKS STOCKS STOCKS STOCKS
// STOCKS STOCKS STOCKS STOCKS STOCKS STOCKS STOCKS STOCKS STOCKS STOCKS STOCKS
// STOCKS STOCKS STOCKS STOCKS STOCKS STOCKS STOCKS STOCKS STOCKS STOCKS STOCKS
// STOCKS STOCKS STOCKS STOCKS STOCKS STOCKS STOCKS STOCKS STOCKS STOCKS STOCKS
// STOCKS STOCKS STOCKS STOCKS STOCKS STOCKS STOCKS STOCKS STOCKS STOCKS STOCKS
// STOCKS STOCKS STOCKS STOCKS STOCKS STOCKS STOCKS STOCKS STOCKS STOCKS STOCKS
// STOCKS STOCKS STOCKS STOCKS STOCKS STOCKS STOCKS STOCKS STOCKS STOCKS STOCKS

stock IncreaseAimBotCount(client)
{
	AHSetHackerProp(client,iAimbotCount,AHGetHackerProp(client,iAimbotCount)+1);
}

stock DecreaseAimBotCount(client)
{
	if(AHGetHackerProp(client,iAimbotCount)>0)
	{
		AHSetHackerProp(client,iAimbotCount,AHGetHackerProp(client,iAimbotCount)-1);
	}
}

//pass me a trie with key "query" = your query into originalqueryTrie
stock SQLCheckForErrors(Handle:hndl,const String:originalerror[],const String:prependstr[]="",Handle:originalqueryTrie=Handle:0) {
	new String:orignalquerystr[512];
	if(originalqueryTrie) {
		if(!GetTrieString(originalqueryTrie,"query",orignalquerystr,sizeof(orignalquerystr))) {
			LogError("SQLCheckForErrors: originalqueryTrie is not null but key 'query' not set from trie");
		}
		CloseHandle(originalqueryTrie);
		//DP("closed");
	}

	if(!StrEqual("", originalerror))
	LogError("SQL error: [%s] %s QUERY:%s", prependstr, originalerror,orignalquerystr);
	else if(hndl == INVALID_HANDLE)
	{
		decl String:err[512];
		SQL_GetError(hndl, err, sizeof(err));
		LogError("SQLCheckForErrors: [%s] %s QUERY:%s", prependstr, err,orignalquerystr);
	}
}
//fetch using column string
stock AHSQLPlayerString(Handle:query,const String:columnname[],String:out_buffer[],size_out) //fech from query
{
	new column;
	if(SQL_FieldNameToNum(query,columnname,column))
	{
		SQL_FetchString(query,column,out_buffer,size_out);
		return true;
	}
	return false;
}
//fetch using column string
stock AHSQLPlayerInt(Handle:query,const String:columnname[]) //fech from query
{
	new column;
	SQL_FieldNameToNum(query,columnname,column);
	decl String:result[16];
	SQL_FetchString(query,column,result,sizeof(result));
	return StringToInt(result);
}
//fetch using column string
stock AHSQLPlayerFloat(Handle:query,const String:columnname[]) //fech from query
{
	new column;
	SQL_FieldNameToNum(query,columnname,column);
	decl String:result[16];
	SQL_FetchString(query,column,result,sizeof(result));
	return StringToFloat(result);
}

//#define MAX_MESSAGE_LENGTH 250

/**
 * Prints a message in the chat area with [AntiHack] pre-appended.
 * Support color tags: {default}, {green}, {lightgreen}, {red}, {blue}, {olive}.
 *
 * @param client      Client index, pass 0 for message to all.
 * @param szMessage   Message (formatting rules).
 * @return            No return
 */
stock AHChatMessage(client, const String:szMessage[], any:...)
{
	if (client == 0)
	{
		decl String:szBuffer[MAX_MESSAGE_LENGTH];
		for (new i = 1; i <= MaxClients; i++)
		{
			if (IsClientInGame(i) && !IsFakeClient(i))
			{
				SetGlobalTransTarget(i);
				VFormat(szBuffer, sizeof(szBuffer), szMessage, 3);
				if(GAMECOLOR)
				{
					Format(szBuffer, sizeof(szBuffer), "{green}[AntiHack]{default} %s", szBuffer);
					CPrintToChat(i, szBuffer);
				}
				else
				{
					CRemoveTags(szBuffer);
					Format(szBuffer, sizeof(szBuffer), "[AntiHack] %s", szBuffer);
					PrintToChat(i, szBuffer);
				}
			}
		}
	}
	else
	{
		decl String:szBuffer[MAX_MESSAGE_LENGTH];
		SetGlobalTransTarget(client);
		VFormat(szBuffer, sizeof(szBuffer), szMessage, 3);
		if(GAMECOLOR)
		{
			Format(szBuffer, sizeof(szBuffer), "{green}[AntiHack]{default} %s", szBuffer);
			CPrintToChat(client, szBuffer);
		}
		else
		{
			CRemoveTags(szBuffer);
			Format(szBuffer, sizeof(szBuffer), "[AntiHack] %s", szBuffer);
			PrintToChat(client, szBuffer);
		}
	}
}

//returns true/false on a chance cast. 1.0=100%, 0.1 = 10% chance
stock bool:AH_Chance(Float:chancepercent=1.0) {
	return (GetRandomFloat(0.0,1.0)<=chancepercent);
}
stock bool:AHChance(Float:chancepercent=1.0) {
	return (GetRandomFloat(0.0,1.0)<=chancepercent);
}

/**
 * Prints Message to server and all chat
 * For debugging prints
 */
stock DP(const String:szMessage[], any:...)
{

	decl String:szBuffer[1000];

	VFormat(szBuffer, sizeof(szBuffer), szMessage, 2);
	PrintToServer("[DebugP %d] %s",RoundFloat(GetGameTime())%100, szBuffer);
	PrintToChatAll("[DebugP %d] %s",RoundFloat(GetGameTime())%100, szBuffer);

}


/*
STOCKS
By Revan
www.wcs-lagerhaus.de
Version : 1.0
*/

stock SetEntityAimToClient( edict, target)
{
	new Float:spos[3],  Float:epos[3], Float:vecles[3], Float:angles[3];
	GetEntPropVector(edict, Prop_Send, "m_vecOrigin", spos);
	GetClientAbsOrigin( target, epos );
	SubtractVectors( epos, spos, vecles );
	GetVectorAngles( vecles, angles );
	angles[2] = 0.0;
	TeleportEntity( edict, NULL_VECTOR, angles, NULL_VECTOR );
}



