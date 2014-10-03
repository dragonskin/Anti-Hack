// AntiHack_Word_Filter.sp

public OnClientPostAdminCheck(client)
{
	if(ValidPlayer(client))
	{
		new String:sStrName[128];
		GetClientName(client, sStrName, sizeof(sStrName));

		if(IsPotientalThreatWord(sStrName))
		{
				if(sourcebans_exists && AllowNameBans)
				{
#if defined _sourcebans_included
					if(SOURCEBANS_AVAILABLE())
					{
						new String:player_authid[64];
						if (!GetClientAuthString(client, player_authid, 64))
						{
							strcopy(player_authid, 64, "UNKNOWN");
						}

						Convert_UniqueID_TO_SteamID(player_authid);
						AntiHackLog("Banned %s %s for having a Potiental Threat Word in thier name!", sStrName, player_authid);
						SBBanPlayer(0, client, 0, "BANNED!");
					}
#endif
				}
				else
				{
					new String:player_authid[64];
					if (!GetClientAuthString(client, player_authid, 64))
					{
						strcopy(player_authid, 64, "UNKNOWN");
					}

					Convert_UniqueID_TO_SteamID(player_authid);

					NotifyAdmins("%s %s for has a Potiental Threat Word in thier name!", sStrName, player_authid);
				}
			//KickClient(client, "");
			//ServerCommand("sm_addban 0 %s \"BANNED!!!\"",player_authid);
		}
	}
}

public FilterType:filter_words(client, String:user_command[])
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

		if(IsPotientalThreatWord(user_command)) is_blocked_word=1;

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
				AntiHackLog("\"%s<%d><%s><%s>\" say \"%s\"", player_name, player_userid, player_authid, player_team, user_command);
				//LogMessage("\"%s<%d><%s><%s>\" say \"%s\"", player_name, player_userid, player_authid, player_team, user_command);

				for(new r = 1; r <= MaxClients; r++)
				{
					if (IsClientInGame(r) && CheckCommandAccess(r, "antihack_admin_notices", ADMFLAG_GENERIC, true))
					{
						if (GAMECOLOR)
						{
							CPrintToChat(r,"{cyan}[WARNING] {crimson}%s {white}has %d more chances before AntiHack acts against them! {cyan}Word was blocked and logged!", player_name, (3-Blocked_Players_ID[client]));
						}
						else
						{
							PrintToChat(r,"[WARNING] %s has %d more chances before AntiHack acts against them! Word was blocked and logged!", player_name, (3-Blocked_Players_ID[client]));
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

				AntiHackLog("\"%s<%d><%s><%s>\" say \"%s\"", player_name, player_userid, player_authid, player_team, user_command);
				//LogMessage("\"%s<%d><%s><%s>\" say \"%s\"", player_name, player_userid, player_authid, player_team, user_command);
				//RegAdminCmd("sm_ban", CommandBan, ADMFLAG_BAN, "sm_ban <#userid|name> <minutes|0> [reason]", "sourcebans");
				//RegAdminCmd("sm_addban", CommandAddBan, ADMFLAG_RCON, "sm_addban <time> <steamid> [reason]", "sourcebans");
				//PrintToChat(client,"BAN");

				if(sourcebans_exists && AllowBans)
				{
					if(SOURCEBANS_AVAILABLE())
					{
						SBBanPlayer(0, client, 0, "BANNED!");
					}
				}
				//ServerCommand("sm_addban 0 %s \"check antihack logs\"",player_authid);

				//KickClient(client, "CONGRATS!!! YOU WIN A...");
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

		//if(StrContains(msg,"testcrash")>=0)
		//{
			//PrintToChatAll(msg);
			//CrashClient(client);
			//return Plugin_Continue;
		//}

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
		else return Plugin_Handled;
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
		else return Plugin_Handled;
	}
	return Plugin_Continue;
}
