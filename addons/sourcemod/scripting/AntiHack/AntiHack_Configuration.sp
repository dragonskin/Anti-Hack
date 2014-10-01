// AntiHack_Configuration.sp

public AntiHack_Configuration_OnPluginStart()
{
	h_DatabaseName=							CreateConVar("antihacker_database",						"antihack");
	h_SaveEnabled=							CreateConVar("antihacker_save_enabled",					"1");
	h_AutosaveTime=							CreateConVar("antihacker_autosavetime",					"300.0");
	h_CheckForUnicodeNames = 				CreateConVar("antihack_prevent_unicode_name_changing",	"1","1 - Enabled / 0 - Disable\nDoes not filter the name, but checks if they name contains banned unicode characters.");
	h_CheckForSimilarNames = 				CreateConVar("antihack_prevent_similar_names",			"1","1 - Enabled / 0 - Disable\nRemoves all non alpha-numeric characters and checks for similar names.\nIt is more aggressive than the Unicode Checker");
	h_antihack_ban=							CreateConVar("antihack_ban",							"1","1 - Enabled / 0 - Disable\nAllow AntiHack to automatically choose certain bans.");
	h_antihack_filter_location=				CreateConVar("antihack_wordsearch_location",			"configs/hacking_advertisment_filter.cfg","default location:\nconfigs/hacking_advertisment_filter.cfg\nOn our server the location ends up being:\n/addons/sourcemod/configs/Potiental_Threat_Words.cfg");
	h_antihack_Efilter=						CreateConVar("antihack_wordsearch_extremefilter",		"0","1 - Enabled / 0 - Disable\nUses Extreme Fitlering Methods.");
	h_antihack_prevent_name_copying=		CreateConVar("antihack_prevent_name_copying",			"1","1 - Enabled / 0 - Disable\nUses Extreme Fitlering Methods.");

	HookConVarChange(h_antihack_Efilter,					wordsearch_convar_changed);
	HookConVarChange(h_antihack_ban,						ban_convar_changed);
	HookConVarChange(h_CheckForSimilarNames,				CheckForSimilarNames_convar_changed);
	HookConVarChange(h_CheckForUnicodeNames,				CheckForUnicodeNames_convar_changed);
	HookConVarChange(h_DatabaseName,						DatabaseName_convar_changed);
	HookConVarChange(h_AutosaveTime,						autosavetime_convar_changed);
	HookConVarChange(h_SaveEnabled,							save_enabled_convar_changed);
}

public save_enabled_convar_changed(Handle:convar, const String:oldValue[], const String:newValue[])
{
	if(convar == h_SaveEnabled)
		g_bSaveEnabled = bool:StringToInt(newValue);
}

public autosavetime_convar_changed(Handle:convar, const String:oldValue[], const String:newValue[])
{
	if(convar == h_AutosaveTime)
		g_fAutosaveTime = StringToFloat(newValue);
}

public wordsearch_convar_changed(Handle:convar, const String:oldValue[], const String:newValue[])
{
	if(convar == h_antihack_Efilter)
		ExtremeFiltering = bool:StringToInt(newValue);
}

public ban_convar_changed(Handle:convar, const String:oldValue[], const String:newValue[])
{
	if(convar == h_antihack_ban)
		AllowBans = bool:StringToInt(newValue);
}

public CheckForSimilarNames_convar_changed(Handle:convar, const String:oldValue[], const String:newValue[])
{
	if(convar == h_CheckForSimilarNames)
		g_bCheckForSimilarNames = bool:StringToInt(newValue);
}

public CheckForUnicodeNames_convar_changed(Handle:convar, const String:oldValue[], const String:newValue[])
{
	if(convar == h_CheckForUnicodeNames)
		g_bCheckForUnicodeNames = bool:StringToInt(newValue);
}

public DatabaseName_convar_changed(Handle:convar, const String:oldValue[], const String:newValue[])
{
	if(convar == h_DatabaseName)
		strcopy(g_sDatabaseName, sizeof(g_sDatabaseName), newValue);
}

