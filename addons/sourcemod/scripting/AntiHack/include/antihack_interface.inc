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
			SetFailState("AHInitNativesForwards did not return true, possible failure");
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

	RegPluginLibrary("antihack");

	return APLRes_Success;
}
/**********************
 * Implement this if you have natives/forwards
 */
forward bool:AHInitNativesForwards();

stock eGameNumberValve:AH_GetGame()
{
	return eGameNumberValve:tValveGame;
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
	new eGameNumberValve:AH_Game_Detection = AH_GetGame();

	return (AH_Game_Detection == AHGame_CSS || AH_Game_Detection == AHGame_CSGO);
}
// These games support <color>
stock bool:GameCOLOR()
{
	new eGameNumberValve:AH_Game_Detection = AH_GetGame();

	return (AH_Game_Detection == AHGame_CSS
	|| AH_Game_Detection == AHGame_CSGO
	|| AH_Game_Detection == AHGame_TF2
	|| AH_Game_Detection == AHGame_HL2DM
	|| AH_Game_Detection == AHGame_DODS
	|| AH_Game_Detection == AHGame_L4D
	|| AH_Game_Detection == AHGame_L4D2);
}

// NATIVES NATIVES NATIVES NATIVES NATIVES NATIVES NATIVES NATIVES NATIVES NATIVES
// NATIVES NATIVES NATIVES NATIVES NATIVES NATIVES NATIVES NATIVES NATIVES NATIVES
// NATIVES NATIVES NATIVES NATIVES NATIVES NATIVES NATIVES NATIVES NATIVES NATIVES
// NATIVES NATIVES NATIVES NATIVES NATIVES NATIVES NATIVES NATIVES NATIVES NATIVES
// NATIVES NATIVES NATIVES NATIVES NATIVES NATIVES NATIVES NATIVES NATIVES NATIVES
// NATIVES NATIVES NATIVES NATIVES NATIVES NATIVES NATIVES NATIVES NATIVES NATIVES
// NATIVES NATIVES NATIVES NATIVES NATIVES NATIVES NATIVES NATIVES NATIVES NATIVES
// NATIVES NATIVES NATIVES NATIVES NATIVES NATIVES NATIVES NATIVES NATIVES NATIVES
// NATIVES NATIVES NATIVES NATIVES NATIVES NATIVES NATIVES NATIVES NATIVES NATIVES
// NATIVES NATIVES NATIVES NATIVES NATIVES NATIVES NATIVES NATIVES NATIVES NATIVES
// NATIVES NATIVES NATIVES NATIVES NATIVES NATIVES NATIVES NATIVES NATIVES NATIVES
// NATIVES NATIVES NATIVES NATIVES NATIVES NATIVES NATIVES NATIVES NATIVES NATIVES
// NATIVES NATIVES NATIVES NATIVES NATIVES NATIVES NATIVES NATIVES NATIVES NATIVES
// NATIVES NATIVES NATIVES NATIVES NATIVES NATIVES NATIVES NATIVES NATIVES NATIVES


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

stock internal_AHSetHackerComment(client,String:ssComment[])
{
	strcopy(p_properties_comment[client], 299, ssComment);
}

stock internal_AHGetHackerComment(client,String:ssComment[],maxlen)
{
	return strcopy(ssComment, maxlen, p_properties_comment[client]);
}

stock internal_AHSetHackerProp(client,AHHackerProp:AHproperty,any:SetProp)
{
	if (client > 0 && client <= MaxClients)
	{
		p_properties[client][AHproperty]=SetProp;
	}
}

stock any:internal_AHGetHackerProp(client,AHHackerProp:AHproperty)
{
	if (client > 0 && client <= MaxClients)
	{
		return p_properties[client][AHproperty];
	}
	else
		return 0;
}

stock bool:Convert_SteamID_TO_UniqueID(String:sIDinfo[64])
{
	if(StrContains(sIDinfo,"STEAM_")>-1)
	{
		new String:sBuffer[3][64];
		ExplodeString(sIDinfo, ":", sBuffer, 3, 64, true);
		new aInt=StringToInt(sBuffer[1]);
		new bInt=StringToInt(sBuffer[2]);
		new cInt=bInt*2+aInt;
		Format(sIDinfo,sizeof(sIDinfo),"[U:1:%d]",cInt);
		return true;
	}
	return false;
}

stock bool:Convert_UniqueID_TO_SteamID(String:sIDinfo[64])
{
	if(StrContains(sIDinfo,"[U:")>-1)
	{
		new String:sBuffer[3][64];
		ExplodeString(sIDinfo, ":", sBuffer, 3, 64, true);
		new cInt=StringToInt(sBuffer[2]);
		new aInt;
		//if C is even
		if(cInt % 2 == 0)
		{
			aInt=0;
		}
		else
		{
			aInt=1;
		}
		new bInt=cInt/2;
		Format(sIDinfo,sizeof(sIDinfo),"STEAM_0:%d:%d",aInt,bInt);
		return true;
	}
	return false;
}

stock bool:GetClientAuthString_OldStyle(client, String:authStringDest[], strSize, bool:validate = true)
{
		new accountID = GetSteamAccountID(client, validate);

		if(accountID == 0)
				return false;

		new accountType = (accountID % 2);
		accountID /= 2

		FormatEx(authStringDest, strSize, "STEAM_0:%i:%i", accountType, accountID);
		return true;
}

stock PushEntToVector( edict, Float:pos1[3], Float:power )
{
	new Float:pos2[3], Float:main_origin[3], Float:velo1[3], Float:velo2[3];
	GetEntPropVector(edict, Prop_Send, "m_vecOrigin", pos2);

	main_origin[0] = pos1[0] - pos2[0], main_origin[1] = pos1[1] - pos2[1], main_origin[2] = pos1[2] - pos2[2];
	velo1[0] += 0, velo1[1] += 0, velo1[2] += 300;

	velo2[0] = main_origin[0] * ( 100 * power );
	velo2[1] = main_origin[1] * ( 100 * power );
	velo2[2] = main_origin[2] * ( 100 * power );

	TeleportEntity( edict, NULL_VECTOR, NULL_VECTOR, velo1 );
	TeleportEntity( edict, NULL_VECTOR, NULL_VECTOR, velo2 );
}

stock AntiHackLog(const String:reason[]="", any:...)
{
	new String:szFile[256];

	decl String:LogThis[2048];
	VFormat(LogThis, sizeof(LogThis), reason, 2);

	decl String:date[32];
	FormatTime(date, sizeof(date), "%m_%d_%y");

	BuildPath(Path_SM, szFile, sizeof(szFile), "logs/antihack_%s.log", date);
	LogToFile(szFile, LogThis);
}

stock NotifyAdmins(const String:reason[]="", any:...)
{
	decl String:LogThis[2048];
	VFormat(LogThis, sizeof(LogThis), reason, 2);

	for(new r = 1; r <= MaxClients; r++)
	{
		if (IsClientInGame(r) && CheckCommandAccess(r, "antihack_admin_notices", ADMFLAG_GENERIC, true))
		{
			if(GAMECOLOR)
			{
				CPrintToChat(r,"{red}[ANTIHACK] %s", LogThis);
			}
			else
			{
				//Don't think I need this, but keeping it here just in case
				//CRemoveTags(LogThis);
				PrintToChat(r,"[ANTIHACK] %s", LogThis);
			}
		}
	}
	NotifyIRC(LogThis);
}

stock bool:ValidPlayer(client,bool:check_alive=false,bool:alivecheckbyhealth=false) {
	if(client>0 && client<=MaxClients && IsClientConnected(client) && IsClientInGame(client))
	{
		if(check_alive && !IsPlayerAlive(client))
		{
			return false;
		}
		if(alivecheckbyhealth&&GetClientHealth(client)<1) {
			return false;
		}
		return true;
	}
	return false;
}

stock  bool:IsClientNameValid(client)
{
	decl String:sName[MAX_NAME_LENGTH], String:sChar;
	new bool:bWhiteSpace = true;

	GetClientName(client, sName, sizeof(sName));
	new iSize = strlen(sName);

	if (iSize < 1 || sName[0] == '&' || IsCharSpace(sName[0]) || IsCharSpace(sName[iSize-1]))
	{
		return false;
	}

	for (new i = 0; i < iSize; i++)
	{
		sChar = sName[i];

		if (!IsCharSpace(sChar))
		{
			bWhiteSpace = false;
		}

		// Check unicode characters.
		new bytes = IsCharMB(sChar);

		if (bytes > 1)
		{
			if (!IsMBCharValid(sName[i], bytes))
			{
				return false;
			}
			else
			{
				i += bytes - 1;
				continue;
			}
		}
		else if (sChar < 32 || sChar == '%' || sChar == 0x7F)
		{
			return false;
		}
	}

	if (bWhiteSpace)
	{
		return false;
	}

	return true;
}

stock bool:IsMBCharValid(const String:mbchar[], numbytes)
{
	/*
	* A blacklist of unicode characters.
	* Mostly a variation of zero-width and spaces.
	*/
	new char;

	// Ugly but fast for covering ranges.
	if (numbytes == 2)
	{
		char = mbchar[0];

		if (char == 0xC2)
		{
			char = mbchar[1];

			// U+0080 to U+00A0
			if (char >= 0x80 && char <= 0xA0)
			{
				return false;
			}
		}
	}
	else if (numbytes == 3)
	{
		char = mbchar[0];

		if (char == 0xE1)
		{
			char = mbchar[1];

			if (char == 0x85)
			{
				char = mbchar[2];

				// U+115F and U+1160
				if (char == 0x9F || char == 0xA0)
				{
					return false;
				}
			}
		}
		else if (char == 0xE2)
		{
			char = mbchar[1];

			if (char == 0x80)
			{
				char = mbchar[2];

				// U+2000 to U+200F
				if (char >= 0x80 && char <= 0x8F)
				{
					return false;
				}

				// U+2028 to U+202F
				else if (char >= 0xA8 && char <= 0xAF)
				{
					return false;
				}
			}
			else if (char == 0x81)
			{
				char = mbchar[2];

				// U+205F to U+206F
				if (char >= 0x9F && char <= 0xAF)
				{
					return false;
				}
			}
		}
		else if (char == 0xE3)
		{
			char = mbchar[1];

			if (char == 0x80)
			{
				char = mbchar[2];

				// U+3000
				if (char == 0x80)
				{
					return false;
				}
			}
			else if (char == 0x85)
			{
				char = mbchar[2];

				// U+3164
				if (char == 0xA4)
				{
					return false;
				}
			}
		}
		else if (char == 0xEF)
		{
			char = mbchar[1];

			if (char == 0xBB)
			{
				char = mbchar[2];

				// U+FEFF
				if (char == 0xBF)
				{
					return false;
				}
			}
			else if (char == 0xBE)
			{
				char = mbchar[2];

				// U+FFA0
				if (char == 0xA0)
				{
					return false;
				}
			}
			else if (char == 0xBB)
			{
				char = mbchar[2];

				// U+FFF9 to U+FFFF
				if (char >= 0xB9)
				{
					return false;
				}
			}
		}
	}

	return true;
}

stock FilterSentence(String:message[],bool:extremefilter=false,bool:RemoveWhiteSpace=false) {
	new charMax = strlen(message);
	new charIndex;
	new copyPos = 0;

	new String:strippedString[192];

	for (charIndex = 0; charIndex < charMax; charIndex++) {
		// Reach end of string. Break.
		if (message[copyPos] == 0) {
			strippedString[copyPos] = 0;
			break;
		}

		if (GetCharBytes(message[charIndex])>1)
		{
			continue;
		}

		if(RemoveWhiteSpace && IsCharSpace(message[charIndex]))
		{
			continue;
		}

		if(extremefilter && IsAlphaNumeric(message[charIndex]))
		{
			strippedString[copyPos] = message[charIndex];
			copyPos++;
			continue;
		}

		// Found a normal character. Copy.
		if (!extremefilter && IsNormalCharacter(message[charIndex])) {
			strippedString[copyPos] = message[charIndex];
			copyPos++;
			continue;
		}
	}

	// Copy back to passing parameter.
	strcopy(message, 192, strippedString);
}

stock bool:IsAlphaNumeric(characterNum) {
	return ((characterNum >= 48 && characterNum <=57)
		||  (characterNum >= 65 && characterNum <=90)
		||  (characterNum >= 97 && characterNum <=122));
}

stock bool:IsNormalCharacter(characterNum) {
	return (characterNum > 31 && characterNum < 127);
}

stock IsBlockedWord(client, String: command[])
{
	new blocked_word = 0;
	new word_index = 0;

	new String:sStrName[128];
	GetClientName(client, sStrName, sizeof(sStrName));

	while ((blocked_word == 0) && (word_index < sizeof(blocked_words))) {
		if (strcmp(command, blocked_words[word_index]) == 0) {
			blocked_word++;
		}
		else if (StrContains(command, blocked_words[word_index], false)>-1) {
			blocked_word++;
		}
		else if (StrContains(sStrName, blocked_words[word_index], false)>-1) {
			blocked_word++;
		}
		word_index++;
	}
	if (blocked_word > 0) {
		return 1;
	}
	return 0;
}

stock bool:IsPotientalThreatWord(String:PossibleThreatWord[])
{
	decl String:TmpStr[32];
	for(new i = 0; i < GetArraySize(g_hPotientalThreatWords); i++)
	{
		GetArrayString(g_hPotientalThreatWords, i, TmpStr, sizeof(TmpStr));

		if(ExtremeFiltering)
		{
			FilterSentence(TmpStr,ExtremeFiltering);
		}

		if(StrContains(PossibleThreatWord,TmpStr,false)>=0)
		{
			return true;
		}
	}
	return false;
}

stock AStrToLower(String:buffer[])
{
	new len = strlen(buffer);
	for(new i = 0; i < len; i++)
	{
		buffer[i] = CharToLower(buffer[i]);
	}
}

stock bool:ParseFile()
{
	decl String:path[PLATFORM_MAX_PATH];

	new String:sAntihack_filter_location[PLATFORM_MAX_PATH];

	GetConVarString(h_antihack_filter_location, sAntihack_filter_location, sizeof(sAntihack_filter_location));

	BuildPath(Path_SM,path,sizeof(path),sAntihack_filter_location);

	/* Return true if an update was available. */
	new Handle:kv = CreateKeyValues("AntiHack");

	if (!FileToKeyValues(kv, path))
	{
		CloseHandle(kv);
		return false;
	}

	ClearArray(g_hPotientalThreatWords);

	new String:sBuffer[32];

	if (KvJumpToKey(kv, "WordsSearch"))
	{
		if (KvGotoFirstSubKey(kv, false))
		{
			do
			{
				if(KvGetSectionName(kv, sBuffer, sizeof(sBuffer)))
				{
					if(AddStringOnly(g_hPotientalThreatWords,sBuffer))
					{
						PrintToServer("Adding hack ad words: %s",sBuffer);
						AntiHackLog("Adding hack ad words: %s",sBuffer);
					}
					else
					{
						PrintToServer("Could not ad words: %s",sBuffer);
						AntiHackLog("Could not ad words: %s",sBuffer);
					}
				}

			} while (KvGotoNextKey(kv, false));
			KvGoBack(kv);
		}

		KvGoBack(kv);
	}

	CloseHandle(kv);

	return true;
}

stock AddStringOnly(Handle:handleString, const String:key[])
{
	new String:TmpStr[32];
	for(new i = 0; i < GetArraySize(handleString); i++)
	{
		GetArrayString(handleString, i, TmpStr, sizeof(TmpStr));
		// If duplicate, return
		if(strcmp(TmpStr, key) == 0)
		{
			return i;
		}
	}
	new String:sTmpStr[32];
	strcopy(sTmpStr, sizeof(sTmpStr), key);
	TrimString(sTmpStr);
	AStrToLower(sTmpStr);

	PushArrayString(handleString, sTmpStr);
	//DP("String: %s",key);

	return -1;
}

stock IncreaseHSAimBotCount(client)
{
	AHSetHackerProp(client,iHSAimbotCount,AHGetHackerProp(client,iHSAimbotCount)+1);
}

stock DecreaseHSAimBotCount(client)
{
	if(AHGetHackerProp(client,iHSAimbotCount)>0)
	{
		AHSetHackerProp(client,iHSAimbotCount,AHGetHackerProp(client,iHSAimbotCount)-1);
	}
}

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
public bool:SQL_FastQueryLogOnError(Handle:DB,const String:query[]) {
	if(!SQL_FastQuery(DB,query)) {
		new String:error[256];
		SQL_GetError(DB, error, sizeof(error));
		LogError("SQLFastQuery Query: %s",query);
		LogError("SQLFastQuery Error: %s",error);
		return false;
	}
	return true;
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



