// AntiHack_Name_Monitoring.sp

public AntiHack_Name_Monitoring_OnEventSpawn(client,userid)
{
	if(ValidPlayer(client))
	{
		GetClientName(client,sOldName[client],127);

		if(g_bPrevent_name_copying)
		{
			decl String:sTestName1[32],String:sTestName2[32];

			GetClientName(client,sTestName1,sizeof(sTestName1));

			FilterSentence(sTestName1);

			new foundit=false;

			// check for duplicate names
			for(new i = 1; i <= MaxClients; i++)
			{
				//if(ValidPlayer(i) && !IsFakeClient(i))
				if(ValidPlayer(i))
				{
					GetClientName(i,sTestName2,sizeof(sTestName2));
					FilterSentence(sTestName2);
				}
				if(StrEqual(sTestName1,sTestName2))
				{
					foundit=true;
					break;
				}
			}

			if(foundit)
			{
				new String:sNameBuffer[138];
				IntToString(userid, sNameBuffer, sizeof(sNameBuffer));

				ServerCommand("sm_rcon sv_namechange_cooldown_seconds 0");
				Format(sNameBuffer,137,"UserID-%s",sNameBuffer);
				SetClientInfo(client, "name", sNameBuffer);

				CreateTimer(1.0,StopAllNameChanging,_);

				if(GAMECOLOR)
				{
					CPrintToChat(client,"{cyan}Similar names is not allowed on this server.  You have been renamed.");
				}
				else
				{
					PrintToChat(client,"Similar names is not allowed on this server.  You have been renamed.");
				}
			}
		}
	}
}

// Stop all Name change chat
public Action:OnDebugP(UserMsg:msg_id, Handle:hBitBuffer, const clients[], numClients, bool:reliable, bool:init)
{
	// Skip the first two bytes
	BfReadByte(hBitBuffer);
	BfReadByte(hBitBuffer);

	// Read the message
	decl String:strMessage[1024];
	BfReadString(hBitBuffer, strMessage, sizeof(strMessage));

	// If the message equals to the string we want to filter, skip.
	if (StrEqual(strMessage, "#TF_Name_Change")) return Plugin_Handled;

	// Done.
	return Plugin_Continue;
}

public Action:Event_player_changename(Handle:event,  const String:name[], bool:dontBroadcast)
{
	if(!g_bPrevent_name_copying && !g_iCheckForUnicodeNames) return Plugin_Continue;

	new userid = GetEventInt(event, "userid");
	new client = GetClientOfUserId(userid);

	new String:sNewName[132];

	decl String:sTestName1[32],String:sTestName2[32];

	GetEventString(event, "newname", sNewName, 131);

	if(ValidPlayer(client) && !IsFakeClient(client))
	{
		if(g_bPrevent_name_copying)
		{
			GetClientName(client,sTestName1,sizeof(sTestName1));

			FilterSentence(sTestName1);

			new foundit=false;

			// check for duplicate names
			for(new i = 1; i <= MaxClients; i++)
			{
				//if(ValidPlayer(i) && !IsFakeClient(i))
				if(ValidPlayer(i))
				{
					GetClientName(i,sTestName2,sizeof(sTestName2));
					FilterSentence(sTestName2);
				}
				if(StrEqual(sTestName1,sTestName2))
				{
					foundit=true;
					break;
				}
			}

			if(foundit)
			{
				new String:sNameBuffer[138];
				IntToString(userid, sNameBuffer, sizeof(sNameBuffer));

				ServerCommand("sm_rcon sv_namechange_cooldown_seconds 0");
				Format(sNameBuffer,137,"UserID-%s",sNameBuffer);
				SetClientInfo(client, "name", sNameBuffer);

				CreateTimer(1.0,StopAllNameChanging,_);
				SetEventBroadcast(event, true);

				if(GAMECOLOR)
				{
					CPrintToChat(client,"{cyan}Similar names is not allowed on this server.  You have been renamed.");
				}
				else
				{
					PrintToChat(client,"Similar names is not allowed on this server.  You have been renamed.");
				}				return Plugin_Continue;
			}
		}

		if(g_iCheckForUnicodeNames>0)
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
			if(TrackNameChanges[client]>2 && TrackNameChangesTriggered[client]==false)
			{
				new String:steamid[64];
				GetClientAuthString(client, steamid, sizeof(steamid));
				CPrintToChatAll("{cyan}Unicode Name Change: {crimson}%s {deeppink}%s",sNewName,steamid);

				//SetPlayerSpawnCamper(client);
				AHSetHackerProp(client,bIsHacker,true);
				AHSetHackerProp(client,bAntiAimbot,true);
				//AHAntiHackerNotifyAdmins(const String:fmt[],any:...);
				AntiHackLog("%s %s set to AntiAimbot for changing Unicode name too many times!",sNewName,steamid);


				CPrintToChatAll("{cyan}%s has changed his/her name too many times.",sNewName);
				CPrintToChatAll("{cyan}AntiHack gives him/her a permenant name.");

				new String:sNameBuffer[138];
				IntToString(userid, sNameBuffer, sizeof(sNameBuffer));


				ServerCommand("sm_rcon sv_namechange_cooldown_seconds 0");
				Format(sNameBuffer,137,"UserID-%s",sNameBuffer);
				SetClientInfo(client, "name", sNameBuffer);

				CPrintToChatAll("{deeppink}%s User's name will now be: %s",sNewName,sNameBuffer);

				CreateTimer(1.0,StopAllNameChanging,_);

				AntiHackLog("Set To AntiAimbot: %s UserID-%s STEAMID: %s",sNewName,sNameBuffer,steamid);

				TrackNameChangesTriggered[client]=true;
			}
		}
	}
	return Plugin_Continue;
}

public Action:StopAllNameChanging( Handle:timer, any:client )
{
	ServerCommand("sm_rcon sv_namechange_cooldown_seconds 20");
	CrashClient(client);
}

