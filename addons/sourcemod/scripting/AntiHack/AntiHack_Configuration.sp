// AntiHack_Configuration.sp

public AntiHack_Configuration_OnPluginStart()
{
	h_DatabaseName=							CreateConVar("ah_database",										"antihack");
	h_SaveEnabled=							CreateConVar("ah_save_enabled",									"1");
	h_AutosaveTime=							CreateConVar("ah_autosavetime",									"300.0");

	h_antihack_ban=							CreateConVar("ah_ban",											"0","1 - Enabled / 0 - Disable\nAllow AntiHack to ban players it can not control.");
	h_antihack_name_ban=					CreateConVar("ah_name_ban",										"1","1 - Enabled / 0 - Disable\nAllow AntiHack to ban players for having hacking advertisement in their names.");
	h_antihack_filter_ban=					CreateConVar("ah_filter_ban",									"1","1 - Enabled / 0 - Disable\nAllow AntiHack to ban players for having hacking advertisement in their text.");

	h_antihack_filter_location=				CreateConVar("ah_wordsearch_location",							"configs/antihack/hacking_advertisment_filter.cfg","default location:\nconfigs/antihack/hacking_advertisment_filter.cfg\nOn our server the location ends up being:\n/addons/sourcemod/configs/Potiental_Threat_Words.cfg");
	h_antihack_Efilter=						CreateConVar("ah_wordsearch_extremefilter",						"0","1 - Enabled / 0 - Disable\nUses Extreme Fitlering Methods.");

	h_antihack_spinhack_crash=				CreateConVar("ah_spinhack_crash",								"2","0 - Disable\nAllow AntiHack to crash clients whom spinhack at X number of times.");

	h_antihack_spinhack_warning=			CreateConVar("ah_spinhack_early_warning",						"1","1 - Enabled / 0 - Disable\nAnti-Hack will alert admins ahead of time about possible spinhack,\nbefore the actual detection.");

	// Disabled by default.
	// High Sensitivity Mode is designed as a early warning system,
	// to give admins a heads up before the actual detection.
	h_HighSensitivityModeEnabled=			CreateConVar("antihacker_hs_enabled",					"0");

	HookConVarChange(h_antihack_Efilter,					wordsearch_convar_changed);
	HookConVarChange(h_antihack_ban,						ban_convar_changed);
	HookConVarChange(h_antihack_name_ban,					name_ban_convar_changed);
	HookConVarChange(h_antihack_filter_ban,					filter_ban_convar_changed);
	HookConVarChange(h_DatabaseName,						DatabaseName_convar_changed);
	HookConVarChange(h_AutosaveTime,						autosavetime_convar_changed);
	HookConVarChange(h_SaveEnabled,							save_enabled_convar_changed);
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

public filter_ban_convar_changed(Handle:convar, const String:oldValue[], const String:newValue[])
{
	if(convar == h_antihack_filter_ban)
		AllowFilterBans = bool:StringToInt(newValue);
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

public DatabaseName_convar_changed(Handle:convar, const String:oldValue[], const String:newValue[])
{
	if(convar == h_DatabaseName)
		strcopy(g_sDatabaseName, sizeof(g_sDatabaseName), newValue);
}

