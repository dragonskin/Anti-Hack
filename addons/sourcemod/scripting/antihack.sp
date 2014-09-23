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

#tryinclude <sourcebans>

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

	RegConsoleCmd("say",          AH_SayCommand);
	RegConsoleCmd("say_team",     AH_TeamSayCommand);

	g_hPotientalThreatWords = CreateArray(32);

	h_antihack_wordsearch_location=CreateConVar("antihack_wordsearch_location","configs/Potiental_Threat_Words.cfg","default location:\nconfigs/Potiental_Threat_Words.cfg\nOn our server the location ends up being:\n/addons/sourcemod/configs/Potiental_Threat_Words.cfg");

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


stock bool:ParseFile()
{
	decl String:path[1024],String:vip_map_file_path[1024];

	GetConVarString(h_vip_matvote_location, vip_map_file_path, sizeof(vip_map_file_path));

	BuildPath(Path_SM,path,sizeof(path),vip_map_file_path);

	/* Return true if an update was available. */
	new Handle:kv = CreateKeyValues("AntiHack");

	if (!FileToKeyValues(kv, path))
	{
		CloseHandle(kv);
		return false;
	}

	ClearArray(g_hMapNames);

	new String:sBuffer[32];

	if (KvJumpToKey(kv, "WordsSearch"))
	{
		if (KvGotoFirstSubKey(kv, false))
		{
			do
			{
				KvGetSectionName(kv, sBuffer, sizeof(sBuffer));
				AddStringOnly(g_hPotientalThreatWords,sBuffer);

			} while (KvGotoNextKey(kv, false));
			KvGoBack(kv);
		}

		KvGoBack(kv);
	}

	CloseHandle(kv);

	return true;
}

public FilterType:filter_words(client, String:user_command[192])
{
	if (client) {

		//decl String:user_command[192];
		//GetCmdArgString(user_command, 192);

		// THIS PART NOT FINISHED YET.. STILL IN PROGRESS
		// THIS PART NOT FINISHED YET.. STILL IN PROGRESS
		// THIS PART NOT FINISHED YET.. STILL IN PROGRESS
		// THIS PART NOT FINISHED YET.. STILL IN PROGRESS


		FilterSentence(user_command);

		//PrintToChat(client,"user_command:%s",user_command)

		new start_index = 0
		new command_length = strlen(user_command);
		if (command_length > 0) {
			if (user_command[0] == 34)	{
				start_index = 1;
				if (user_command[command_length - 1] == 34)	{
					user_command[command_length - 1] = 0;
				}
			}

			if (user_command[start_index] == 47)	{
				start_index++;
			}

			ReplaceString(user_command, 192, ".", "");
			ReplaceString(user_command, 192, "-", "");
			ReplaceString(user_command, 192, ";", "");
			ReplaceString(user_command, 192, ":", "");
			ReplaceString(user_command, 192, "/", "");

			new command_blocked = is_bad_word(user_command[start_index]);
			if (command_blocked > 0) {

				if ((!IsFakeClient(client)) && (IsClientConnected(client))) {
					new String:display_message[192];
					Format(display_message, 192, "\x01 %s", "ERROR! Could not process message.");

					new Handle:hBf;
					hBf = StartMessageOne("SayText2", client);
					if (hBf != INVALID_HANDLE) {
						BfWriteByte(hBf, 1);
						BfWriteByte(hBf, 0);
						BfWriteString(hBf, display_message);
						EndMessage();
					}

					new String:player_name[64];
					if (!GetClientName(client, player_name, 64))	{
						strcopy(player_name, 64, "UNKNOWN");
					}

					new String:player_authid[64];
					if (!GetClientAuthString(client, player_authid, 64)){
						strcopy(player_authid, 64, "UNKNOWN");
					}

					Convert_UniqueID_TO_SteamID(player_authid);

					new player_team_index = GetClientTeam(client);
					new String:player_team[64];
					player_team = team_list[player_team_index];

					new player_userid = GetClientUserId(client);
					LogToGame("\"%s<%d><%s><%s>\" triggered \"bad_language\"", player_name, player_userid, player_authid, player_team);
					LogMessage("\"%s<%d><%s><%s>\" triggered \"bad_language\"", player_name, player_userid, player_authid, player_team);

				}
				return AH_Filter_Block;
			}

			new word_blocked = is_blocked_word(client, user_command[start_index]);
			if (word_blocked > 0 && Blocked_Players_ID[client]<=3) {
				if ((!IsFakeClient(client)) && (IsClientConnected(client))) {

					Blocked_Players_ID[client]++;

					new String:player_name[64];
					if (!GetClientName(client, player_name, 64))	{
						strcopy(player_name, 64, "UNKNOWN");
					}

					new String:player_authid[64];
					if (!GetClientAuthString(client, player_authid, 64)){
						strcopy(player_authid, 64, "UNKNOWN");
					}

					Convert_UniqueID_TO_SteamID(player_authid);

					new player_team_index = GetClientTeam(client);
					new String:player_team[64];
					player_team = team_list[player_team_index];

					new player_userid = GetClientUserId(client);
					LogToGame("\"%s<%d><%s><%s>\" say \"%s\"", player_name, player_userid, player_authid, player_team, user_command[start_index]);
					LogMessage("\"%s<%d><%s><%s>\" say \"%s\"", player_name, player_userid, player_authid, player_team, user_command[start_index]);

					for(new r = 1; r <= MaxClients; r++)
					{
						if (r>0 && r<=MaxClients && IsClientConnected(r) && IsClientInGame(r) && !IsFakeClient(r))
						{
							new AdminId:ident = GetUserAdmin(r);
							if (GetAdminFlag(ident, Admin_Kick))
							{
								CPrintToChat(r,"{cyan}[WARNING] {crimson}%s {white}has %d more chances before they are banned for typing in a ban word! {cyan}Word was blocked and logged!", player_name, (3-Blocked_Players_ID[client]));
							}
						}
					}
				}

				return AH_Filter_Warning;
			}

			if (word_blocked > 0 && Blocked_Players_ID[client]>3) {
				if ((!IsFakeClient(client)) && (IsClientConnected(client))) {

					new String:player_name[64];
					if (!GetClientName(client, player_name, 64))	{
						strcopy(player_name, 64, "UNKNOWN");
					}

					new String:player_authid[64];
					if (!GetClientAuthString(client, player_authid, 64)){
						strcopy(player_authid, 64, "UNKNOWN");
					}

					Convert_UniqueID_TO_SteamID(player_authid);

					new player_team_index = GetClientTeam(client);
					new String:player_team[64];
					player_team = team_list[player_team_index];

					PrintToChat(client,"YOU HAVE BEEN CAUGHT!!!");
					PrintToChat(client,"YOU HAVE BEEN CAUGHT!!!");
					PrintToChat(client,"YOU HAVE BEEN CAUGHT!!!");

					new player_userid = GetClientUserId(client);
					PrintToChat(client,"\"%s<%d><%s><%s>\" say \"%s\"", player_name, player_userid, player_authid, player_team, user_command[start_index]);

					LogToGame("\"%s<%d><%s><%s>\" say \"%s\"", player_name, player_userid, player_authid, player_team, user_command[start_index]);
					LogMessage("\"%s<%d><%s><%s>\" say \"%s\"", player_name, player_userid, player_authid, player_team, user_command[start_index]);
					//RegAdminCmd("sm_ban", CommandBan, ADMFLAG_BAN, "sm_ban <#userid|name> <minutes|0> [reason]", "sourcebans");
					//RegAdminCmd("sm_addban", CommandAddBan, ADMFLAG_RCON, "sm_addban <time> <steamid> [reason]", "sourcebans");
					//PrintToChat(client,"BAN");

					KickClient(client, "YOU HAVE BEEN CAUGHT!!!");
#if defined _sourcebans_included
					ServerCommand("sm_addban 0 %s \"check antihack logs\"",player_authid);
#endif
				}
				return AH_Filter_Ban;
			}
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
