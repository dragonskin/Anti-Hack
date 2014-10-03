// AntiHack_Database.sp

#define DATABASE_VERSION "1.0.0.0A"

AH_Database_SetPlayerDefaults(client)
{
	internal_AHSetHackerProp(client,iPlayerID,0);
	internal_AHSetHackerProp(client,iFirstTimeHacked,0);
	internal_AHSetHackerProp(client,iLastTimeHacked,0);
	internal_AHSetHackerProp(client,bIsHacker,false);
	internal_AHSetHackerProp(client,bAntiAimbot,false);
	internal_AHSetHackerProp(client,bChanceOnHit,false);
	internal_AHSetHackerProp(client,bNoDamage,false);
	internal_AHSetHackerProp(client,iAimbotCount,0);
	internal_AHSetHackerProp(client,iHSAimbotCount,0);
	internal_AHSetHackerProp(client,iSpinhackCount,0);
	internal_AHSetHackerProp(client,iEyeAnglesCount,0);
	internal_AHSetHackerProp(client,iTamperingButtonsCount,0);
	internal_AHSetHackerProp(client,iTamperingTickcountCount,0);
	internal_AHSetHackerProp(client,iReusingMovementCommandsCount,0);
	internal_AHSetHackerProp(client,iTamperingViewAnglesAimbotCount,0);
	internal_AHSetHackerProp(client,iCrashed,0);
}

///////////////////// DATABASE ///////////////////////////////////////
///////////////////// DATABASE ///////////////////////////////////////
///////////////////// DATABASE ///////////////////////////////////////
///////////////////// DATABASE ///////////////////////////////////////
///////////////////// DATABASE ///////////////////////////////////////
///////////////////// DATABASE ///////////////////////////////////////

public Initialize_SQLTable()
{
	PrintToServer("[ANTIHACK] Initialize_SQLTable");
	if(hDB!=INVALID_HANDLE)
	{
		SQL_LockDatabase(hDB); //non threading operations here, done once on plugin load only, not map change

		//main table
		//new String:shortquery[300];
		//Format(shortquery,sizeof(shortquery),"SELECT * from `antihack_tracking` LIMIT 1");
		new Handle:query=SQL_Query(hDB,"SELECT * from `antihack_tracking` LIMIT 1");

		if(query==INVALID_HANDLE)
		{
			PrintToServer("CREATE TABLE IF NOT EXISTS");

			new String:createtable[3000];
			Format(createtable,sizeof(createtable),
			"CREATE TABLE IF NOT EXISTS `antihack_tracking` ( \
			`player_id` int(10) unsigned NOT NULL AUTO_INCREMENT, \
			`db_version` varchar(9) DEFAULT NULL, \
			`player_name` varchar(300) DEFAULT NULL, \
			`sComment` varchar(300) DEFAULT NULL, \
			`player_auth` int(11) DEFAULT NULL, \
			`steam2id` varchar(64) DEFAULT NULL, \
			`steam3id` varchar(64) DEFAULT NULL, \
			`iFirstTimeHacked` timestamp NOT NULL DEFAULT '0000-00-00 00:00:00', \
			`iLastTimeHacked` timestamp NOT NULL DEFAULT '0000-00-00 00:00:00', \
			`bIsHacker` tinyint(4) DEFAULT NULL, \
			`bAntiAimbot` tinyint(4) DEFAULT NULL, \
			`bChanceOnHit` tinyint(4) DEFAULT NULL, \
			`bNoDamage` tinyint(4) DEFAULT NULL, \
			`iAimbotCount` int(11) DEFAULT NULL, \
			`iHSAimbotCount` int(11) DEFAULT NULL, \
			`iSpinhackCount` int(11) DEFAULT NULL, \
			`iEyeAnglesCount` int(11) DEFAULT NULL, \
			`iTamperingButtonsCount` int(11) DEFAULT NULL, \
			`iTamperingTickcountCount` int(11) DEFAULT NULL, \
			`iReusingMovementCommandsCount` int(11) DEFAULT NULL, \
			`iTamperingViewAnglesAimbotCount` int(11) DEFAULT NULL, \
			`iCrashed` int(11) DEFAULT NULL, \
			PRIMARY KEY (`player_id`), \
			UNIQUE KEY `player_steam_auth` (`player_auth`, `steam2id`, `steam3id`) \
			) ENGINE=InnoDB AUTO_INCREMENT=0 %s",
			g_SQLType==SQLType_MySQL?"DEFAULT CHARACTER SET utf8 COLLATE utf8_unicode_ci":"" );

			if(!SQL_FastQueryLogOnError(hDB,createtable))
			{
				SetFailState("[ANTIHACK] ERROR in the creation of the SQL table antihack_tracking.");
			}
		}
		else
		{
			CloseHandle(query);
		}

		SQL_UnlockDatabase(hDB);
	}
	else
		PrintToServer("hDB invalid 123");

	PrintToServer("[ANTIHACK] Initialize_SQLTable FINISHED");
}

/*
public SQLCallback_CreatePlayerTable(Handle:db, Handle:hndl, const String:error[], any:data)
{
	if (hndl == INVALID_HANDLE)
	{
		AntiHackLog("Error creating race table. %s.", error);
	}
	else
	{
		AntiHackLog("Successfully created / connected to Hacker Database");
	}
}*/

///////////////////// DATABASE: AUTH //////////////////////////////////
///////////////////// DATABASE: AUTH //////////////////////////////////
///////////////////// DATABASE: AUTH //////////////////////////////////
///////////////////// DATABASE: AUTH //////////////////////////////////
///////////////////// DATABASE: AUTH //////////////////////////////////
stock AH_ForceReloadPlayerData(client)
{
	if (ValidPlayer(client))
	{
		new UserAccountID = GetSteamAccountID(client);
		if(hDB) // no bots and steamid
		{
			if(UserAccountID>0 && ValidPlayer(client) && !IsFakeClient(client))
			{
				CanLoadDataBase = true;

				new String:query[256];
				Format(query, sizeof(query), "SELECT player_id FROM `antihack_tracking` WHERE `player_auth` = '%d';", UserAccountID);
				SQL_TQuery(hDB, SQLCallback_PlayerJoin, query, GetClientUserId(client));
				return 1;
			}
		}
		else
		{
			LogError("AH_ForceReloadPlayerData Database Invalid");
		}
	}

	return 0;
}

public OnAHDatabasePlayerAuthed(client, const String:auth[])
{
	//auth	int(11)
	//GetSteamAccountID(client, bool:validate=true);

	new UserAccountID = GetSteamAccountID(client);

	if(hDB) // no bots
	{
		if(UserAccountID>0 && ValidPlayer(client) && !IsFakeClient(client))
		{
			CanLoadDataBase = true;

			new String:query[256];
			Format(query, sizeof(query), "SELECT player_id FROM `antihack_tracking` WHERE `player_auth` = '%d';", UserAccountID);
			SQL_TQuery(hDB, SQLCallback_PlayerJoin, query, GetClientUserId(client));
			return;
		}
	}
	else
	{
		LogError("OnAHDatabasePlayerAuthed() Database Invalid!");
	}
}

public SQLCallback_Void(Handle:db, Handle:hndl, const String:error[], any:userid)
{
	if(hndl == INVALID_HANDLE)
	{
		LogError("SQLCallback_Void: Error looking up player. %s.", error);
	}
}

///////////////////// DATABSE: PLAYERJOIN ////////////////////////////
///////////////////// DATABSE: PLAYERJOIN ////////////////////////////
///////////////////// DATABSE: PLAYERJOIN ////////////////////////////
///////////////////// DATABSE: PLAYERJOIN ////////////////////////////
///////////////////// DATABSE: PLAYERJOIN ////////////////////////////

public SQLCallback_PlayerJoin(Handle:db, Handle:hndl, const String:error[], any:userid)
{
	new client = GetClientOfUserId(userid);
	if(hndl == INVALID_HANDLE)
	{
		LogError("SQLCallback_PlayerJoin: Error looking up player. %s.", error);
		internal_AHSetHackerProp(client,iPlayerID,0);
	}
	else
	{
		//new client = GetClientOfUserId(userid);
		if(client == 0)
		{
			return;
		}
		if(SQL_GetRowCount(hndl) > 0)
		{
			//PrintToServer("SQLCallback_LookupPlayer");
			SQL_FetchRow(hndl);
			internal_AHSetHackerProp(client,iPlayerID,SQL_FetchInt(hndl, 0));
			new String:query[3000];
			Format(query, sizeof(query), "SELECT `sComment`, UNIX_TIMESTAMP(`iFirstTimeHacked`), UNIX_TIMESTAMP(`iLastTimeHacked`), \
			`bIsHacker`, `bAntiAimbot`, `bChanceOnHit`, `bNoDamage`, \
			`iAimbotCount`, `iHSAimbotCount`, `iSpinhackCount`, `iEyeAnglesCount`, \
			`iTamperingButtonsCount`, `iTamperingTickcountCount`, `iReusingMovementCommandsCount`, \
			`iTamperingViewAnglesAimbotCount`, `iCrashed` FROM `antihack_tracking` WHERE `player_id` = '%d';", internal_AHGetHackerProp(client,iPlayerID));
			SQL_TQuery(hDB, SQLCallback_LookupPlayer, query, GetClientUserId(client));
		}
	}
}


///////////////////// DATABASE: REMOVE PLAYER //////////////////////
///////////////////// DATABASE: REMOVE PLAYER //////////////////////
///////////////////// DATABASE: REMOVE PLAYER //////////////////////
///////////////////// DATABASE: REMOVE PLAYER //////////////////////
///////////////////// DATABASE: REMOVE PLAYER //////////////////////

// DELETE FROM `antihack_tracking` WHERE `player_id`='6';

stock AH_AntiHackerDeletePlayer(client)
{
	if (ValidPlayer(client))
	{
		if(AHGetHackerProp(client,iPlayerID) > 0)
		{
			new String:query[256];
			Format(query, sizeof(query), "DELETE FROM `antihack_tracking` WHERE `player_id`='%d';", internal_AHGetHackerProp(client,iPlayerID));
			SQL_TQuery(hDB, SQLCallback_DeletePlayer, query, GetClientUserId(client));
		}
		else
		{
			new String:sTmpName[128];
			GetClientName(client,sTmpName,sizeof(sTmpName));
			NotifyAdmins("%s does not have a valid iPlayerID for the AntiHack Database.",sTmpName);
		}
	}
}
public SQLCallback_DeletePlayer(Handle:db, Handle:hndl, const String:error[], any:userid)
{
	if(hndl == INVALID_HANDLE)
	{
		LogError("Error getting last insert id. %s.", error);
	}
	else
	{
		new client = GetClientOfUserId(userid);
		if(client == 0)
		{
			return;
		}

		AH_Database_SetPlayerDefaults(client);

		new UserAccountID = GetSteamAccountID(client);

		if(UserAccountID>0 && ValidPlayer(client) && !IsFakeClient(client))
		{
			new String:sTmpName[128];
			GetClientName(client,sTmpName,sizeof(sTmpName));
			NotifyAdmins("%s %d successfully deleted from AntiHack Database.",sTmpName,UserAccountID);
		}
		else if(ValidPlayer(client))
		{
			new String:sTmpName[128];
			GetClientName(client,sTmpName,sizeof(sTmpName));
			NotifyAdmins("%s [Unknown SteamAccountID] successfully deleted from AntiHack Database.",sTmpName);
		}
		else
		{
			NotifyAdmins("Userid: %d [Unknown SteamAccountID] successfully deleted from AntiHack Database.",userid);
		}
	}
}



///////////////////// DATABASE: LOAD SAVED DATA //////////////////////
///////////////////// DATABASE: LOAD SAVED DATA //////////////////////
///////////////////// DATABASE: LOAD SAVED DATA //////////////////////
///////////////////// DATABASE: LOAD SAVED DATA //////////////////////
///////////////////// DATABASE: LOAD SAVED DATA //////////////////////

public SQLCallback_LookupPlayer(Handle:owner,Handle:hndl,const String:error[],any:userid)
{
	//SQLCheckForErrors(hndl,error,"T_CallbackSelectPDataRace");
	//PrintToServer("inside SQLCallback_LookupPlayer");

	new client = GetClientOfUserId(userid);

	if(IsFakeClient(client))
	{
		return;
	}

	//if(!ValidPlayer(client))
	//{
		//return;
	//}
	if(client<=0 || client>MaxClients || !IsClientConnected(client) || !IsClientInGame(client) || IsFakeClient(client))
	{
		PrintToServer("INVALID CLIENT SQLCallback_LookupPlayer");
		return;
	}

	//PrintToServer("inside SQLCallback_LookupPlayer after valid player");


	if(hndl == INVALID_HANDLE)
	{
		LogError("SQLCallback_LookupPlayer: Error looking up player. %s.", error);
	}
	else
	{
		//PrintToServer("inside SQLCallback_LookupPlayer after hndl");
		new retrievals;
		//new usefulretrievals;
		while(SQL_MoreRows(hndl))
		{
			//PrintToServer("inside SQLCallback_LookupPlayer after while(SQL_MoreRows(hndl))");
			if(SQL_FetchRow(hndl))
			{ //SQLITE doesnt properly detect ending
				//PrintToServer("inside SQLCallback_LookupPlayer after if(SQL_FetchRow(hndl)){");

				//new bool:tmp_bIsHacker = bool:AHSQLPlayerInt(hndl,"bIsHacker");

				//if(tmp_bIsHacker)
				//{

				new String:sTempString[300];
				if(!AHSQLPlayerString(hndl,"sComment",sTempString,sizeof(sTempString)))
				{
					LogError("[ANTIHACK] Unexpected error loading player sComment. Check DATABASE settings!");
					return;
				}
				internal_AHSetHackerComment(client,sTempString);

				internal_AHSetHackerProp(client,bIsHacker,AHSQLPlayerInt(hndl,"bIsHacker"));

				internal_AHSetHackerProp(client,iFirstTimeHacked,AHSQLPlayerInt(hndl,"UNIX_TIMESTAMP(`iFirstTimeHacked`)"));

				internal_AHSetHackerProp(client,iLastTimeHacked,AHSQLPlayerInt(hndl,"UNIX_TIMESTAMP(`iLastTimeHacked`)"));

				internal_AHSetHackerProp(client,bAntiAimbot,AHSQLPlayerInt(hndl,"bAntiAimbot"));

				internal_AHSetHackerProp(client,bChanceOnHit,AHSQLPlayerInt(hndl,"bChanceOnHit"));

				internal_AHSetHackerProp(client,bNoDamage,AHSQLPlayerInt(hndl,"bNoDamage"));

				internal_AHSetHackerProp(client,iAimbotCount,AHSQLPlayerInt(hndl,"iAimbotCount"));

				internal_AHSetHackerProp(client,iHSAimbotCount,AHSQLPlayerInt(hndl,"iHSAimbotCount"));

				internal_AHSetHackerProp(client,iSpinhackCount,AHSQLPlayerInt(hndl,"iSpinhackCount"));

				internal_AHSetHackerProp(client,iEyeAnglesCount,AHSQLPlayerInt(hndl,"iEyeAnglesCount"));

				internal_AHSetHackerProp(client,iTamperingButtonsCount,AHSQLPlayerInt(hndl,"iTamperingButtonsCount"));

				internal_AHSetHackerProp(client,iTamperingTickcountCount,AHSQLPlayerInt(hndl,"iTamperingTickcountCount"));

				internal_AHSetHackerProp(client,iReusingMovementCommandsCount,AHSQLPlayerInt(hndl,"iReusingMovementCommandsCount"));

				internal_AHSetHackerProp(client,iTamperingViewAnglesAimbotCount,AHSQLPlayerInt(hndl,"iTamperingViewAnglesAimbotCount"));

				internal_AHSetHackerProp(client,iCrashed,AHSQLPlayerInt(hndl,"iCrashed"));

				//usefulretrievals++;
				//}
				retrievals++;
			}
		}
		if(retrievals>0)
		{
			Call_StartForward(g_OnAHPlayerLoadData);
			Call_PushCell(client);
			Call_Finish(dummy);
		}
	}
}

////////////////////// DATABASE: SAVE DATA ///////////////////////////
////////////////////// DATABASE: SAVE DATA ///////////////////////////
////////////////////// DATABASE: SAVE DATA ///////////////////////////
////////////////////// DATABASE: SAVE DATA ///////////////////////////
////////////////////// DATABASE: SAVE DATA ///////////////////////////

public bool:AH_SaveHackerData(client)
{
	if(hDB && ValidPlayer(client) && !IsFakeClient(client) && g_bSaveEnabled)
	{
		new UserAccountID = GetSteamAccountID(client);
		//DP("UserAccountID %d",UserAccountID);
		if(UserAccountID>0)
		{
				PrintToServer("PLAYER ID: %d",internal_AHGetHackerProp(client,iPlayerID));
				if(internal_AHGetHackerProp(client,iPlayerID) > 0)
				{
					//DP("iPlayerID %d",internal_AHGetHackerProp(client,iPlayerID));

					//PrintToServer("BEFORE SQL SAVING");

					new String:sHackerName[128];
					GetClientName(client,sHackerName,sizeof(sHackerName));

					new buffer_len=strlen(sHackerName) * 2 + 1;
					new String:newshortname[buffer_len];
					SQL_EscapeString(hDB,sHackerName,newshortname,buffer_len);

					new String:sNewComment[128];
					AHGetHackerComment(client,sNewComment,sizeof(sNewComment));

					buffer_len=strlen(sNewComment) * 2 + 1;
					new String:newComment[buffer_len];
					SQL_EscapeString(hDB,sNewComment,newComment,buffer_len);

					new String:query[3000];
					Format(query, sizeof(query), "UPDATE antihack_tracking SET player_name='%s', sComment='%s', iFirstTimeHacked=FROM_UNIXTIME('%d'), iLastTimeHacked=FROM_UNIXTIME('%d'), \
					bIsHacker='%d', bAntiAimbot='%d', bChanceOnHit='%d', bNoDamage='%d', iAimbotCount='%d', iHSAimbotCount='%d', iSpinhackCount='%d', iEyeAnglesCount='%d', \
					iTamperingButtonsCount='%d', iTamperingTickcountCount='%d', iReusingMovementCommandsCount='%d', \
					iTamperingViewAnglesAimbotCount='%d', iCrashed='%d' WHERE player_id='%d';", newshortname, newComment, internal_AHGetHackerProp(client,iFirstTimeHacked), internal_AHGetHackerProp(client,iLastTimeHacked),
					internal_AHGetHackerProp(client,bIsHacker), internal_AHGetHackerProp(client,bAntiAimbot), internal_AHGetHackerProp(client,bChanceOnHit),
					internal_AHGetHackerProp(client,bNoDamage), internal_AHGetHackerProp(client,iAimbotCount), internal_AHGetHackerProp(client,iHSAimbotCount), internal_AHGetHackerProp(client,iSpinhackCount),
					internal_AHGetHackerProp(client,iEyeAnglesCount), internal_AHGetHackerProp(client,iTamperingButtonsCount), internal_AHGetHackerProp(client,iTamperingTickcountCount),
					internal_AHGetHackerProp(client,iReusingMovementCommandsCount), internal_AHGetHackerProp(client,iTamperingViewAnglesAimbotCount), internal_AHGetHackerProp(client,iCrashed), internal_AHGetHackerProp(client,iPlayerID));
					SQL_TQuery(hDB, SQLCallback_Void, query, sizeof(query));
					PrintToServer("ANTIHACK: %s",query);

					return true;
				}
				else if(internal_AHGetHackerProp(client,bIsHacker))
				{
					//DP("bIsHacker true");

					AntiHackLog("Create New Hacker Profile");

					internal_AHSetHackerProp(client,iFirstTimeHacked,GetTime());
					internal_AHSetHackerProp(client,iLastTimeHacked,GetTime());

					new String:sHackerName[128];
					GetClientName(client,sHackerName,sizeof(sHackerName));

					new buffer_len=strlen(sHackerName) * 2 + 1;
					new String:newshortname[buffer_len];
					SQL_EscapeString(hDB,sHackerName,newshortname,buffer_len);

					new String:sNewComment[128];
					internal_AHGetHackerComment(client,sNewComment,sizeof(sNewComment));

					buffer_len=strlen(sNewComment) * 2 + 1;
					new String:newComment[buffer_len];
					SQL_EscapeString(hDB,sNewComment,newComment,buffer_len);

					decl String:sSteamID[64],String:sSteamID2[64];

					GetClientAuthString(client, sSteamID2, sizeof(sSteamID2));
					strcopy(sSteamID, sizeof(sSteamID), sSteamID2);
					if(GAMETF)
					{
						if(!Convert_UniqueID_TO_SteamID(sSteamID2))
						{
							Convert_SteamID_TO_UniqueID(sSteamID2);
						}
					}

					new String:query[3000];
					Format(query, sizeof(query), "INSERT INTO `antihack_tracking`(`db_version`, `player_name`, `sComment`, \
					`player_auth`, `steam2id`, `steam3id`, `iFirstTimeHacked`, `iLastTimeHacked`, \
					`bIsHacker`, `bAntiAimbot`, `bChanceOnHit`, `bNoDamage`, \
					`iAimbotCount`, `iHSAimbotCount`, `iSpinhackCount`, `iEyeAnglesCount`, \
					`iTamperingButtonsCount`, `iTamperingTickcountCount`, `iReusingMovementCommandsCount`, \
					`iTamperingViewAnglesAimbotCount`, `iCrashed`) \
					VALUES('%s', '%s', '%s', '%d', '%s', '%s', \
					FROM_UNIXTIME('%d'), FROM_UNIXTIME('%d'), '%d', '%d', '%d', '%d', '%d', '%d', '%d', '%d', '%d', '%d', '%d', '%d', '%d');",
					DATABASE_VERSION, newshortname, newComment,
					UserAccountID, sSteamID, sSteamID2, internal_AHGetHackerProp(client,iFirstTimeHacked), internal_AHGetHackerProp(client,iLastTimeHacked),
					internal_AHGetHackerProp(client,bIsHacker), internal_AHGetHackerProp(client,bAntiAimbot), internal_AHGetHackerProp(client,bChanceOnHit), internal_AHGetHackerProp(client,bNoDamage),
					internal_AHGetHackerProp(client,iAimbotCount), internal_AHGetHackerProp(client,iHSAimbotCount), internal_AHGetHackerProp(client,iSpinhackCount), internal_AHGetHackerProp(client,iEyeAnglesCount),
					internal_AHGetHackerProp(client,iTamperingButtonsCount), internal_AHGetHackerProp(client,iTamperingTickcountCount),
					internal_AHGetHackerProp(client,iReusingMovementCommandsCount), internal_AHGetHackerProp(client,iTamperingViewAnglesAimbotCount),
					internal_AHGetHackerProp(client,iCrashed));
					SQL_TQuery(hDB, SQLCallback_Void, query, sizeof(query));

					AntiHackLog(query);

					Format(query, sizeof(query), "SELECT LAST_INSERT_ID();");
					SQL_TQuery(hDB, SQLCallback_LastInsertID, query, GetClientUserId(client));

					PrintToServer("ANTIHACK: %s",query);

					return true;
				}
		}
	}
	return false;
}
public SQLCallback_LastInsertID(Handle:db, Handle:hndl, const String:error[], any:userid)
{
	if(hndl == INVALID_HANDLE)
	{
		LogError("Error getting last insert id. %s.", error);
	}
	else
	{
		new client = GetClientOfUserId(userid);
		if(client == 0)
		{
			return;
		}

		if(SQL_GetRowCount(hndl) > 0)
		{

			//PrintToServer("SQLCallback_LookupPlayer");
			SQL_FetchRow(hndl);
			internal_AHSetHackerProp(client,iPlayerID,SQL_FetchInt(hndl, 0));
			//DP("AHSetHackerProp(client,iPlayerID,SQL_FetchInt(hndl, 0));  = %d",internal_AHGetHackerProp(client,iPlayerID));
		}
	}
}

stock AH_AntiHackerForceDatabaseSave(client)
{
	if (client > 0 && client <= MaxClients)
	{
		AH_SaveHackerData(client);
		return 1;
	}
	else
		return 0;
}

public Action:DataBase_DoAutosave(Handle:timer,any:data)
{
	if(g_bSaveEnabled && CanLoadDataBase)
	{
		for(new x=1;x<=MaxClients;x++)
		{
			if(ValidPlayer(x) && !IsFakeClient(x))
			{
				AH_SaveHackerData(x);
				//PrintToServer("Player Save Data Timer");
			}
		}
	}
	CreateTimer(g_fAutosaveTime,DataBase_DoAutosave);
}

public AH_Database_OnClientDisconnect(client)
{
	if(CanLoadDataBase && client>0)
	{
		AH_SaveHackerData(client);
	}
	AH_Database_SetPlayerDefaults(client);
}
