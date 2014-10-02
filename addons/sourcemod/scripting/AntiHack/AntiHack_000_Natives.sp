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

	CreateNative("AHSetHackerProp",Native_AHSetHackerProp);
	CreateNative("AHGetHackerProp",Native_AHGetHackerProp);

	CreateNative("AHSetHackerComment",Native_AHSetHackerComment);
	CreateNative("AHGetHackerComment",Native_AHGetHackerComment);

	g_OnAHPlayerLoadData=CreateGlobalForward("OnAHPlayerLoadData",ET_Ignore,Param_Cell);

	CreateNative("AH_CachedAngle",Native_AH_CachedAngle);
	CreateNative("AH_CachedPosition",Native_AH_CachedPosition);

	g_hOnAHSayCommandFilter       = CreateGlobalForward("OnAHSayCommandFilter", ET_Hook, Param_Cell, Param_String, Param_String);

	g_hOnAHTeamSayCommandFilter       = CreateGlobalForward("OnAHTeamSayCommandFilter", ET_Hook, Param_Cell, Param_String, Param_String);

	new bool:ReturnSomething = AH_Aimbot_Detection_AskPluginLoad2();

	return ReturnSomething;
}

public Native_AHSetHackerProp(Handle:plugin,numParams)
{
	internal_AHSetHackerProp(GetNativeCell(1),AHHackerProp:GetNativeCell(2),GetNativeCell(3));
}

public Native_AHGetHackerProp(Handle:plugin,numParams)
{
	return internal_AHGetHackerProp(GetNativeCell(1),AHHackerProp:GetNativeCell(2));
}

public Native_AHSetHackerComment(Handle:plugin,numParams){
	new client=GetNativeCell(1);
	if (client > 0 && client <= MaxClients)
	{
		new String:sCommentTemp[300];
		GetNativeString(2,sCommentTemp,sizeof(sCommentTemp));

		internal_AHSetHackerComment(client,sCommentTemp);
	}
}
public Native_AHGetHackerComment(Handle:plugin,numParams){
	new client=GetNativeCell(1);
	if (client > 0 && client <= MaxClients)
	{
		new maxlen=GetNativeCell(3);
		new String:TmpString[maxlen];

		internal_AHGetHackerComment(client,TmpString,maxlen);

		SetNativeString(2,TmpString,maxlen);
	}
}
