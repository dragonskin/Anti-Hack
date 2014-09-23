// antihack.sp

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

/*
* File: Antihack.sp
* Description: The main file for Antihack.
* Author: El Diablo
*/
#pragma semicolon 1

#define VERSION_NUM "1.0.0.0"
#define AUTHORS "The AntiHack Team"

#define ANTIHACK

#include <sourcemod>
#include <antihack>
#include <smac>
#include "AntiHack/includes/antihack_interface.inc"

#include "AntiHack/AntiHack_000_Natives.sp"
#include "AntiHack/AntiHack_000_OnGameFrame.sp"
#include "AntiHack/AntiHack_Aim_Calculations.sp"
//#include "AntiHack/"
//#include "AntiHack/"
//#include "AntiHack/"
//#include "AntiHack/"
//#include "AntiHack/"
//#include "AntiHack/"

new Handle:ClientHUD;

public Plugin:myinfo=
{
	name="Antihack",
	author=AUTHORS,
	description="Brings an Easy to use Antihack to the Source engine.",
	version=VERSION_NUM,
};

public OnPluginStart()
{

	PrintToServer("--------------------------OnPluginStart----------------------");

	PrintToServer("[War3Evo] Plugin finished loading.\n-------------------END OnPluginStart-------------------");

	ClientHUD = CreateHudSynchronizer();
	CreateTimer(0.1,ClientAim,_,TIMER_REPEAT);

	g_hCvarAimbotBan = FindConVar("smac_aimbot_ban", "0", "Number of aimbot detections before a player is banned. Minimum allowed is 4. (0 = Never ban)", FCVAR_PLUGIN, true, 0.0);
}

public OnMapStart()
{
	PrintToServer("OnMapStart");
}

public OnAllPluginsLoaded() //called once only, will not call again when map changes
{
	new smac_version = StringToInt(SMAC_VERSION);
	if(smac_version < 0.8.5.1) then SetFailState("[AntiHack] You must have at least SMAC version 0.8.5.1 or higher.");

	PrintToServer("OnAllPluginsLoaded");

	SetConVarInt(g_hCvarAimbotBan, 0);
}

public OnClientPutInServer(client)
{
}

public OnClientDisconnect(client)
{
}

public Action:ClientAim(Handle:timer,any:userid)
{
	for(new client=1;client<=MaxClients;client++)
	{
		if(IsValidPlayer(client))
		{
			SetHudTextParams(-1.0, 0.20, 0.1, 255, 0, 0, 255);
			ShowSyncHudText(client, ClientHUD, " Angles: [%.2f] [%.2f] [%.2f] ",CachedAngle[client][0],CachedAngle[client][1],CachedAngle[client][2]);
		}
	}
}

public Native_AH_CachedAngle(Handle:plugin,numParams)
{
	new client=GetNativeCell(1);
	SetNativeArray(2,CachedAngle[client],3);
}

public Native_AH_CachedPosition(Handle:plugin,numParams)
{
	new client=GetNativeCell(1);
	SetNativeArray(2,CachedPos[client],3);
}

public Action:SMAC_CheatDetected(client, DetectionType:type = Detection_Unknown, Handle:info = INVALID_HANDLE)
{
	if(IsValidPlayer(client))
	{
		switch (type)
		{
			case:Detection_Aimbot
			{
				g_iAimDetections[client]++;
				IncreaseAimBotCount(client);
			}
		}
	}
}

public Action:Timer_DecreaseCount(Handle:timer, any:userid)
{
	/* Decrease the detection count by 1. */
	new client = GetClientOfUserId(userid);

	if (IS_CLIENT(client) && g_iAimDetections[client])
	{
		g_iAimDetections[client]--;
	}

	return Plugin_Stop;
}
