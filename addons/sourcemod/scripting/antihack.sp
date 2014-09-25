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

// for crash code
#include <sdktools_tempents>
#include <sdktools_tempents_stocks>
#include <sdktools_engine>
#include <sdktools_functions>
#include <sdktools_entinput>

#tryinclude <sourcebans>

#include "AntiHack/include/antihack_interface.inc"

#include "AntiHack/AntiHack_000_Natives.sp"
#include "AntiHack/AntiHack_000_OnClientConnected.sp"
#include "AntiHack/AntiHack_000_OnClientDisconnect.sp"
#include "AntiHack/AntiHack_000_OnClientPutInServer.sp"
#include "AntiHack/AntiHack_000_OnGameFrame.sp"
#include "AntiHack/AntiHack_Configuration.sp"
#include "AntiHack/AntiHack_Crash_Code.sp"
#include "AntiHack/AntiHack_Name_Monitoring.sp"
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

	PrintToServer("[ANTIHACK] Plugin finished loading.\n-------------------END OnPluginStart-------------------");

	// AntiHack_Name_Monitoring.sp
	new UserMsg:umOnDebugP = GetUserMessageId("SayText2");
	if (umOnDebugP != INVALID_MESSAGE_ID)
	{
		HookUserMessage(umOnDebugP, OnDebugP, true);
	}
	else
	{
		LogError("[SCP] This mod appears not to support SayText2.  Plugin disabled.");
		SetFailState("Error hooking usermessage saytext2");
	}

	RegConsoleCmd("say",          AH_SayCommand);
	RegConsoleCmd("say_team",     AH_TeamSayCommand);

	HookEvent("player_changename", Event_player_changename, EventHookMode_Pre);

	g_hPotientalThreatWords = CreateArray(32);

	ClientHUD = CreateHudSynchronizer();
	CreateTimer(0.1,ClientAim,_,TIMER_REPEAT);

	AntiHack_Configuration_OnPluginStart();
}

public OnMapStart()
{
	// Default Name Change in seconds
	PrintToServer("OnMapStart");
	ServerCommand("sm_rcon sv_namechange_cooldown_seconds 20");
}

public OnAllPluginsLoaded() //called once only, will not call again when map changes
{
	new Handle:smac_version = FindConVar("smac_aimbot_ban");

	if(smac_version!=INVALID_HANDLE)
	{
		new String:TmpString[32];
		GetConVarString(smac_version, TmpString, sizeof(TmpString));
		CloseHandle(smac_version);
		if(!StrEqual(TmpString,"0.8.5.1")) LogMessage("[AntiHack] Anti-Hack has only been tested on SMAC version 0.8.5.1, using any other version may cause problems.");
	}
	else
	{
		CloseHandle(smac_version);
		SetFailState("[AntiHack] AntiHack Requires SMACS to function.");
		CloseHandle(smac_version);
	}
	CloseHandle(smac_version);

	g_hCvarAimbotBan = FindConVar("smac_aimbot_ban");

	PrintToServer("OnAllPluginsLoaded");

	SetConVarInt(g_hCvarAimbotBan, 0);

	//CreateTimer(GetConVarFloat(h_AutosaveTime),DoAutosave);
}

public Action:ClientAim(Handle:timer,any:userid)
{
	for(new client=1;client<=MaxClients;client++)
	{
		if(ValidPlayer(client))
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

public Action:SMAC_OnCheatDetected(client, const String:module[], DetectionType:type, Handle:info)
{
	if(ValidPlayer(client))
	{
		switch (type)
		{
			case Detection_Aimbot:
			{
				++g_iAimDetections[client];
				IncreaseAimBotCount(client);

				return Plugin_Handled;
			}
		}
	}
	return Plugin_Continue;
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

public FilterType:filter_words(client, String:user_command[192])
{
	if (client)
	{
		//decl String:user_command[192];
		//GetCmdArgString(user_command, 192);

		// THIS PART NOT FINISHED YET.. STILL IN PROGRESS
		// THIS PART NOT FINISHED YET.. STILL IN PROGRESS
		// THIS PART NOT FINISHED YET.. STILL IN PROGRESS
		// THIS PART NOT FINISHED YET.. STILL IN PROGRESS

		FilterSentence(user_command,ExtremeFiltering);

		new is_blocked_word=0;

		decl String:TmpStr[32];
		for(new i = 0; i < GetArraySize(g_hPotientalThreatWords); i++)
		{
			GetArrayString(g_hPotientalThreatWords, i, TmpStr, sizeof(TmpStr));

			if(ExtremeFiltering)
			{
				FilterSentence(TmpStr,ExtremeFiltering);
			}

			if(StrEqual(user_command,TmpStr))
			{
				is_blocked_word=1;
				break;
			}
		}

		if (is_blocked_word == 0) return AH_Filter_Normal;

		if (is_blocked_word > 0 && Blocked_Players_ID[client]<=3)
		{
			if ((!IsFakeClient(client)) && (IsClientConnected(client)))
			{

				Blocked_Players_ID[client]++;

				new String:player_name[64];
				if (!GetClientName(client, player_name, 64))
				{
					strcopy(player_name, 64, "UNKNOWN");
				}

				new String:player_authid[64];
				if (!GetClientAuthString(client, player_authid, 64))
				{
					strcopy(player_authid, 64, "UNKNOWN");
				}

				Convert_UniqueID_TO_SteamID(player_authid);

				new player_team_index = GetClientTeam(client);
				new String:player_team[64];
				strcopy(player_team, sizeof(player_team), Team_List[player_team_index]);

				new player_userid = GetClientUserId(client);
				LogToGame("\"%s<%d><%s><%s>\" say \"%s\"", player_name, player_userid, player_authid, player_team, user_command);
				LogMessage("\"%s<%d><%s><%s>\" say \"%s\"", player_name, player_userid, player_authid, player_team, user_command);

				for(new r = 1; r <= MaxClients; r++)
				{
					if (r>0 && r<=MaxClients && IsClientConnected(r) && IsClientInGame(r) && !IsFakeClient(r))
					{
						new AdminId:ident = GetUserAdmin(r);
						if (GetAdminFlag(ident, Admin_Kick))
						{
							CPrintToChat(r,"{cyan}[WARNING] {crimson}%s {white}has %d more chances before AntiHack acts against them! {cyan}Word was blocked and logged!", player_name, (3-Blocked_Players_ID[client]));
						}
					}
				}
			}
			return AH_Filter_Warning;
		}

		if (is_blocked_word > 0 && Blocked_Players_ID[client]>3)
		{
			if ((!IsFakeClient(client)) && (IsClientConnected(client)))
			{

				new String:player_name[64];
				if (!GetClientName(client, player_name, 64))
				{
					strcopy(player_name, 64, "UNKNOWN");
				}

				new String:player_authid[64];
				if (!GetClientAuthString(client, player_authid, 64))
				{
					strcopy(player_authid, 64, "UNKNOWN");
				}

				Convert_UniqueID_TO_SteamID(player_authid);

				new player_team_index = GetClientTeam(client);
				new String:player_team[64];
				strcopy(player_team, sizeof(player_team), Team_List[player_team_index]);

				new player_userid = GetClientUserId(client);
				PrintToChat(client,"\"%s<%d><%s><%s>\" say \"%s\"", player_name, player_userid, player_authid, player_team, user_command);

				LogToGame("\"%s<%d><%s><%s>\" say \"%s\"", player_name, player_userid, player_authid, player_team, user_command);
				LogMessage("\"%s<%d><%s><%s>\" say \"%s\"", player_name, player_userid, player_authid, player_team, user_command);
				//RegAdminCmd("sm_ban", CommandBan, ADMFLAG_BAN, "sm_ban <#userid|name> <minutes|0> [reason]", "sourcebans");
				//RegAdminCmd("sm_addban", CommandAddBan, ADMFLAG_RCON, "sm_addban <time> <steamid> [reason]", "sourcebans");
				//PrintToChat(client,"BAN");

#if defined _sourcebans_included
				if(AllowBans)
				{
					SBBanPlayer(0, client, 0, "You win a free ban by AntiHack!");
				}
				//ServerCommand("sm_addban 0 %s \"check antihack logs\"",player_authid);
#endif
				KickClient(client, "CONGRATS!!! YOU WIN A...");
			}
			return AH_Filter_Ban;
		}
	}
	return AH_Filter_Normal;
}

public Action:AH_SayCommand(client,args)
{
	if (client)
	{
		decl String:msg[192],String:filtered_command[192];
		GetCmdArgString(msg, 192);

		strcopy(filtered_command, 192, msg);

		if(filter_words(client, filtered_command)==AH_Filter_Normal)
		{
			new Action:returnVal = Plugin_Continue;
			Call_StartForward(g_hOnAHSayCommandFilter);
			Call_PushCell(client);
			Call_PushString(msg);
			Call_PushString(filtered_command);
			Call_Finish(_:returnVal);
			if(returnVal != Plugin_Continue)
			{
				return Plugin_Handled;
			}
		}
	}
	return Plugin_Continue;
}
public Action:AH_TeamSayCommand(client,args)
{
	if (client)
	{
		decl String:msg[192],String:filtered_command[192];
		GetCmdArgString(msg, 192);

		strcopy(filtered_command, 192, msg);

		if(filter_words(client, filtered_command)==AH_Filter_Normal)
		{
			new Action:returnVal = Plugin_Continue;
			Call_StartForward(g_hOnAHTeamSayCommandFilter);
			Call_PushCell(client);
			Call_PushString(msg);
			Call_PushString(filtered_command);
			Call_Finish(_:returnVal);
			if(returnVal != Plugin_Continue)
			{
				return Plugin_Handled;
			}
		}
	}
	return Plugin_Continue;
}
