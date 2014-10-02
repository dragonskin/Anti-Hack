// AntiHack_DatabaseConnect.sp

public ConnectToDataBase()
{
	PrintToServer("[ANTIHACK] Connecting to Database");
	new String:dbErrorMsg[512];

	hDB=SQL_Connect(g_sDatabaseName,true,dbErrorMsg,sizeof(dbErrorMsg));

	if(!hDB)
	{
		LogError("[ANTIHACK] ERROR: hDB invalid handle, Check SourceMod database config, could not connect. ");
		Format(dbErrorMsg,sizeof(dbErrorMsg),"ERR: Could not connect to DB. \n%s",dbErrorMsg);
		LogError("ERRMSG:(%s)",dbErrorMsg);
	}
	else
	{
		new String:driver_ident[64];
		SQL_ReadDriver(hDB,driver_ident,sizeof(driver_ident));
		if(StrEqual(driver_ident,"mysql",false))
		{
			g_SQLType=SQLType_MySQL;
		}
		else if(StrEqual(driver_ident,"sqlite",false))
		{
			g_SQLType=SQLType_SQLite;
		}
		else
		{
			g_SQLType=SQLType_Unknown;
		}
		PrintToServer("[ANTIHACK] SQL connection successful, driver %s",driver_ident);
		SQL_LockDatabase(hDB);
		SQL_FastQuery(hDB, "SET NAMES \"UTF8\"");
		SQL_UnlockDatabase(hDB);
	}
	return true;
}
