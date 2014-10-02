// AntiHack_Configuration.sp

public AntiHack_Configuration_OnPluginStart()
{
	h_DatabaseName=							CreateConVar("ah_database",										"antihack");
	h_SaveEnabled=							CreateConVar("ah_save_enabled",									"1");
	h_AutosaveTime=							CreateConVar("ah_autosavetime",									"300.0");
	h_CheckForUnicodeNames = 				CreateConVar("ah_check_unicode_name_changing",					"2","0 - Disables\nDoes not filter the name, but checks if they name contains banned unicode characters and allows up to X number of times before Anti-Hack takes action.");
	h_Prevent_name_copying = 				CreateConVar("ah_prevent_name_copying",							"1","1 - Enabled / 0 - Disable\nRemoves all non alpha-numeric characters and checks for name copying.\nIt is more aggressive than the Unicode Checker");

	h_antihack_ban=							CreateConVar("ah_ban",											"0","1 - Enabled / 0 - Disable\nAllow AntiHack to ban players it can not control.");
	h_antihack_name_ban=					CreateConVar("ah_name_ban",										"0","1 - Enabled / 0 - Disable\nAllow AntiHack to ban players for having hacking advertisement in their names.");

	h_antihack_filter_location=				CreateConVar("ah_wordsearch_location",							"configs/hacking_advertisment_filter.cfg","default location:\nconfigs/hacking_advertisment_filter.cfg\nOn our server the location ends up being:\n/addons/sourcemod/configs/Potiental_Threat_Words.cfg");
	h_antihack_Efilter=						CreateConVar("ah_wordsearch_extremefilter",						"0","1 - Enabled / 0 - Disable\nUses Extreme Fitlering Methods.");

	h_antihack_spinhack_crash=				CreateConVar("ah_spinhack_crash",								"2","0 - Disable\nAllow AntiHack to crash clients whom spinhack after X number of times.");

	h_antihack_spinhack_warning=			CreateConVar("ah_spinhack_early_warning",						"0","1 - Enabled / 0 - Disable\nAnti-Hack will alert admins ahead of time about possible spinhack,\nbefore the actual detection.");

	// Disabled by default.
	// High Sensitivity Mode is designed as a early warning system,
	// to give admins a heads up before the actual detection.
	h_HighSensitivityModeEnabled=			CreateConVar("antihacker_hs_enabled",					"0");

	HookConVarChange(h_antihack_Efilter,					wordsearch_convar_changed);
	HookConVarChange(h_antihack_ban,						ban_convar_changed);
	HookConVarChange(h_antihack_name_ban,					name_ban_convar_changed);
	HookConVarChange(h_CheckForUnicodeNames,				CheckForUnicodeNames_convar_changed);
	HookConVarChange(h_DatabaseName,						DatabaseName_convar_changed);
	HookConVarChange(h_AutosaveTime,						autosavetime_convar_changed);
	HookConVarChange(h_SaveEnabled,							save_enabled_convar_changed);
	HookConVarChange(h_antihack_filter_location,			filter_location_convar_changed);
	HookConVarChange(h_Prevent_name_copying,				prevent_name_copying_convar_changed);
	HookConVarChange(h_HighSensitivityModeEnabled,			hs_enabled_convar_changed);
	HookConVarChange(h_antihack_spinhack_crash,				spinhack_crash_convar_changed);
	HookConVarChange(h_antihack_spinhack_warning,			spinhack_warning_convar_changed);
}

public spinhack_warning_convar_changed(Handle:convar, const String:oldValue[], const String:newValue[])
{
	if(convar == h_antihack_spinhack_warning)
		g_bSpinhack_warning = bool:StringToInt(newValue);
}

public spinhack_crash_convar_changed(Handle:convar, const String:oldValue[], const String:newValue[])
{
	if(convar == h_antihack_spinhack_crash)
		g_iCrash_OnSpinHack = bool:StringToInt(newValue);
}

public prevent_name_copying_convar_changed(Handle:convar, const String:oldValue[], const String:newValue[])
{
	if(convar == h_Prevent_name_copying)
		g_bPrevent_name_copying = bool:StringToInt(newValue);
}

public filter_location_convar_changed(Handle:convar, const String:oldValue[], const String:newValue[])
{
	if(convar == h_antihack_filter_location)
		if(FileExists(newValue)) strcopy(g_sAntihack_filter_location,sizeof(g_sAntihack_filter_location),newValue);
}

public hs_enabled_convar_changed(Handle:convar, const String:oldValue[], const String:newValue[])
{
	if(convar == h_HighSensitivityModeEnabled)
		g_bHighSensitivityModeEnabled = bool:StringToInt(newValue);
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

public name_ban_convar_changed(Handle:convar, const String:oldValue[], const String:newValue[])
{
	if(convar == h_antihack_name_ban)
		AllowNameBans = bool:StringToInt(newValue);
}

public ban_convar_changed(Handle:convar, const String:oldValue[], const String:newValue[])
{
	if(convar == h_antihack_ban)
		AllowBans = bool:StringToInt(newValue);
}

public CheckForUnicodeNames_convar_changed(Handle:convar, const String:oldValue[], const String:newValue[])
{
	if(convar == h_CheckForUnicodeNames)
		g_iCheckForUnicodeNames = StringToInt(newValue);
}

public DatabaseName_convar_changed(Handle:convar, const String:oldValue[], const String:newValue[])
{
	if(convar == h_DatabaseName)
		strcopy(g_sDatabaseName, sizeof(g_sDatabaseName), newValue);
}

