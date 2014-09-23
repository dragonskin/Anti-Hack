// AntiHack_000_Natives.sp

public bool:AHInitNativesForwards()
{
	//if(!AntiHack_InitNatives())
	//{
		//LogError("[Antihack] There was a failure in creating the native based functions, definately halting.");
		//return false;
	//}
	//if(!AntiHack_InitForwards())
	//{
		//LogError("[Antihack] There was a failure in creating the forward based functions, definately halting.");
		//return false;
	//}

	CreateNative("AH_CachedAngle",Native_AH_CachedAngle);
	CreateNative("AH_CachedPosition",Native_AH_CachedPosition);

	g_hOnAHSayCommandFilter       = CreateGlobalForward("OnAHSayCommandFilter", ET_Hook, Param_Cell, Param_String, Param_String);

	g_hOnAHTeamSayCommandFilter       = CreateGlobalForward("OnAHTeamSayCommandFilter", ET_Hook, Param_Cell, Param_String, Param_String);

	return true;
}
