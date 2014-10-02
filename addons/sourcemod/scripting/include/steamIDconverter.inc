// steamIDconverter.inc

//18:58 < Phoenix_1> no
//18:58 < Phoenix_1> STEAM_0:A:B --> C = B*2 + A --> U:1:C afaik
//18:58 < Forth> Oh, interesting

// [U:1:C] --> is C odd? if yes then A = 1, else A = 0.  B = C / 2 --> STEAM_0:A:B

// X % 2 == 0 is even

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
	return false
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
