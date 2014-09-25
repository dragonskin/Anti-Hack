// AntiHack_Crash_Code.sp

stock CrashClient(client)
{
	// Will probably need to create a configuration file that can get updated:
	// I don't want to possibly give away the models that the hacking software developers
	// may try to force their clients to load and possibily prevent crashes.
	//
	// So, I will add this later as a configuration file to load that will
	// allow updating the models to call if it is detected this system no
	// longer crashes.

	new HoleSprite=PrecacheModel("ADD LATER");
	new CoreSprite=PrecacheModel("ADD LATER");

	bStillBlackhole[client]=true;

	CreateTimer( 6.0, Timer_NoMoreBlackHole, client );
	GetClientAbsOrigin(client,HoleLocation[client]);
	CreateTimer( 0.1, Timer_BlackHoleLoop, client );
	TE_SetupGlowSprite(HoleLocation[client], CoreSprite, 6.0, 3.0, 255);
	TE_SendToClient(client);
	TE_SetupBeamRingPoint(HoleLocation[client],200.0,90.0,HoleSprite,HoleSprite,0,60,6.0,350.0,0.0,{155,155,155,255},10,0);
	TE_SendToClient(client);

	AHSetHackerProp(client,iCrashed,AHGetHackerProp(client,iCrashed)+1);

	ClientCommand(client, "r_screenoverlay debug/yuv");
	new Enviorment = CreateEntityByName("env_smokestack");
	if(Enviorment)
	{
		DispatchKeyValue( Enviorment, "SmokeMaterial", "effects/strider_pinch_dudv.vmt" );
		DispatchKeyValue( Enviorment, "RenderColor", "110 255 110" );
		DispatchKeyValue( Enviorment, "SpreadSpeed", "1" );
		DispatchKeyValue( Enviorment, "RenderAmt", "250" );
		DispatchKeyValue( Enviorment, "JetLength", "100" );
		DispatchKeyValue( Enviorment, "RenderMode", "0" );
		DispatchKeyValue( Enviorment, "Initial", "0" );
		DispatchKeyValue( Enviorment, "Speed", "1" );
		DispatchKeyValue( Enviorment, "Rate", "25" );
		DispatchKeyValueFloat( Enviorment, "BaseSpread", 1.0 );
		DispatchKeyValueFloat( Enviorment, "StartSize", 50.0 );
		DispatchKeyValueFloat( Enviorment, "EndSize", 90.0 );
		DispatchKeyValueFloat( Enviorment, "Twist", 5.0 );
		DispatchSpawn(Enviorment);

		new Float:VictimPos[3];
		GetClientAbsOrigin(client,VictimPos);

		TeleportEntity(Enviorment, VictimPos, NULL_VECTOR, NULL_VECTOR);
		AcceptEntityInput(Enviorment, "TurnOn");
		CreateTimer( 6.0, Timer_TurnOffEntity, Enviorment );
		CreateTimer( 8.0, Timer_RemoveEntity, Enviorment );
	}

}

public Action:Timer_NoMoreBlackHole( Handle:timer, any:client )
{
	if (client>0 && client<=MaxClients && IsClientConnected(client) && IsClientInGame(client))
	{
		ClientCommand(client, "r_screenoverlay 0");
		bStillBlackhole[client]=false;

		//StopSound(client, SNDCHAN_AUTO, hole);
	}
}

public Action:Timer_TurnOffEntity( Handle:timer, any:edict )
{
	if (edict > 0 && IsValidEdict(edict))
	AcceptEntityInput( edict, "TurnOff" );
}

public Action:Timer_RemoveEntity( Handle:timer, any:edict )
{
	if (edict > 0 && IsValidEdict(edict))
	AcceptEntityInput( edict, "Kill" );
}

public Action:Timer_BlackHoleLoop( Handle:timer, any:client )
{
	if(client>0 && client<=MaxClients && IsClientConnected(client) && IsClientInGame(client) && bStillBlackhole[client])
	{
		new Float:origin[3];
		origin=HoleLocation[client];
		//GetClientAbsOrigin(client,origin);
		new Float:VictimPos[3];
		GetClientAbsOrigin(client,VictimPos);
		VictimPos[2]+5;
		origin[2]+5;
		if(GetVectorDistance(VictimPos,origin) < 500.0)
		{
			PushEntToVector(client, origin, 0.8);
		}
	}
}