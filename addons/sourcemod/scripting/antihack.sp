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

	HookEvent("player_changename", Event_player_changename, EventHookMode_Pre);

	g_hPotientalThreatWords = CreateArray(32);

	h_antihack_ban=CreateConVar("antihack_ban","1","1 - Enabled / 0 - Disable\nAllow AntiHack to automatically choose certain bans.");

	h_antihack_wordsearch_location=CreateConVar("antihack_wordsearch_location","configs/Potiental_Threat_Words.cfg","default location:\nconfigs/Potiental_Threat_Words.cfg\nOn our server the location ends up being:\n/addons/sourcemod/configs/Potiental_Threat_Words.cfg");

	h_antihack_wordsearch_extremefilter=CreateConVar("antihack_wordsearch_extremefilter","0","1 - Enabled / 0 - Disable\nUses Extreme Fitlering Methods.");

	h_antihack_prevent_name_copying=CreateConVar("antihack_prevent_name_copying","1","1 - Enabled / 0 - Disable\nUses Extreme Fitlering Methods.");

	ClientHUD = CreateHudSynchronizer();
	CreateTimer(0.1,ClientAim,_,TIMER_REPEAT);

	HookConVarChange(h_antihack_wordsearch_extremefilter,    ConVarChanged_ConVars);
}

public ConVarChanged_ConVars(Handle:convar, const String:oldValue[], const String:newValue[])
{
	if(convar      == h_antihack_wordsearch_extremefilter)
		ExtremeFiltering = bool:StringToInt(newValue);
	else if(convar == h_antihack_ban)
		AllowBans = bool:StringToInt(newValue);
}

public OnMapStart()
{
	PrintToServer("OnMapStart");
}

public OnAllPluginsLoaded() //called once only, will not call again when map changes
{
	new smac_version = StringToInt(SMAC_VERSION);
	if(smac_version < 0.8.5.1) then SetFailState("[AntiHack] You must have at least SMAC version 0.8.5.1 or higher.");

	g_hCvarAimbotBan = FindConVar("smac_aimbot_ban");

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

		if (word_blocked == 0) return AH_Filter_Normal;

		if (word_blocked > 0 && Blocked_Players_ID[client]<=3)
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
							CPrintToChat(r,"{cyan}[WARNING] {crimson}%s {white}has %d more chances before AntiHack acts against them! {cyan}Word was blocked and logged!", player_name, (3-Blocked_Players_ID[client]));
						}
					}
				}
			}
			return AH_Filter_Warning;
		}

		if (word_blocked > 0 && Blocked_Players_ID[client]>3)
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
				player_team = team_list[player_team_index];

				new player_userid = GetClientUserId(client);
				PrintToChat(client,"\"%s<%d><%s><%s>\" say \"%s\"", player_name, player_userid, player_authid, player_team, user_command[start_index]);

				LogToGame("\"%s<%d><%s><%s>\" say \"%s\"", player_name, player_userid, player_authid, player_team, user_command[start_index]);
				LogMessage("\"%s<%d><%s><%s>\" say \"%s\"", player_name, player_userid, player_authid, player_team, user_command[start_index]);
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

public Action:Event_player_changename(Handle:event,  const String:name[], bool:dontBroadcast)
{
	new userid = GetEventInt(event, "userid");
	new client = GetClientOfUserId(userid);

	new String:sNewName[132];

	GetEventString(event, "newname", sNewName, 131);

	if(ValidPlayer(client) && !IsFakeClient(client))
	{
		if(TrackNameChangesTriggered[client]==true)
		{
			new String:sNameBuffer[138];
			IntToString(userid, sNameBuffer, sizeof(sNameBuffer));
			if(!StrEqual(sNewName,sNameBuffer))
			{
				//Sv_namechange_cooldown_seconds
				//ServerCommand("sm_rcon sm_rename \"%s\" \"%s\"",sNewName,sTmpName);

				ServerCommand("sm_rcon sv_namechange_cooldown_seconds 0");
				Format(sNameBuffer,137,"UserID-%s",sNameBuffer);
				SetClientInfo(client, "name", sNameBuffer);

				CreateTimer(1.0,StopAllNameChanging,_);
				SetEventBroadcast(event, true);
			}
			return Plugin_Continue;
		}
		if(!IsClientNameValid(client) && TrackNameChangesTriggered[client]==false)
		{
			// PRINT INFO TO CHAT
			new String:steamid[64];
			GetClientAuthString(client, steamid, sizeof(steamid));
			//CPrintToChatAll("{cyan}Name Change: {crimson}%s {deeppink}%s",sNewName,steamid);
			TrackNameChanges[client]++;
		}
		if(TrackNameChanges[client]>2 && GetConVarInt(s_enable)>0 && TrackNameChangesTriggered[client]==false)
		{
			new String:steamid[64];
			GetClientAuthString(client, steamid, sizeof(steamid));
			CPrintToChatAll("{cyan}Unicode Name Change: {crimson}%s {deeppink}%s",sNewName,steamid);

			//SetPlayerSpawnCamper(client);
			AHSetHackerProp(client,bIsHacker,true);
			AHSetHackerProp(client,bAntiAimbot,true);
			//W3AntiHackerNotifyAdmins(const String:fmt[],any:...);
			AHAntiHackerLog("%s %s set to AntiAimbot for changing Unicode name too many times!",sNewName,steamid);


			CPrintToChatAll("{cyan}%s has changed his/her name too many times.",sNewName);
			CPrintToChatAll("{cyan}AntiHack gives him/her a permenant name.");

			new String:sNameBuffer[138];
			IntToString(userid, sNameBuffer, sizeof(sNameBuffer));


			ServerCommand("sm_rcon sv_namechange_cooldown_seconds 0");
			Format(sNameBuffer,137,"UserID-%s",sNameBuffer);
			SetClientInfo(client, "name", sNameBuffer);

			CPrintToChatAll("{deeppink}%s User's name will now be: %s",sNewName,sNameBuffer);

			CreateTimer(1.0,StopAllNameChanging,_);

			Log("Set To AntiAimbot: %s UserID-%s STEAMID: %s",sNewName,sNameBuffer,steamid);

			TrackNameChangesTriggered[client]=true;
		}
	}
	return Plugin_Continue;
}

public Action:StopAllNameChanging( Handle:timer, any:client )
{
	ServerCommand("sm_rcon sv_namechange_cooldown_seconds 20");
	new userid = GetClientUserId(client);
	ServerCommand("sm_crashclient_2 #%d",userid);
}
