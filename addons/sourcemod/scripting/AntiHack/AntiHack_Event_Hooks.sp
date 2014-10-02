// AntiHack_Event_Hooks.sp

public AntiHack_Event_Hooks_OnPluginStart()
{
	// Hooks.
	HookEvent("player_spawn", Event_PlayerSpawn, EventHookMode_Post);

	if (GAMETF)
	{
		HookEvent("player_death", Hook_TF2_Event_PlayerDeath, EventHookMode_Post);
	}
	else if (!HookEventEx("entity_killed", Hook_Event_EntityKilled, EventHookMode_Post))
	{
		HookEvent("player_death", Hook_Event_PlayerDeath, EventHookMode_Post);
	}
}

public Event_PlayerSpawn(Handle:event, const String:name[], bool:dontBroadcast)
{
	new userid = GetEventInt(event, "userid");
	new client = GetClientOfUserId(userid);

	AntiHack_Aimbot_Detection_PlayerSpawn(client);
}

public Hook_Event_PlayerDeath(Handle:event, const String:name[], bool:dontBroadcast)
{
	new victim = GetClientOfUserId(GetEventInt(event, "userid"));
	new attacker = GetClientOfUserId(GetEventInt(event, "attacker"));

	AntiHack_Aimbot_Detection_PlayerDeath(event,victim,attacker,-1,Event_PlayerDeath);
}

public Hook_Event_EntityKilled(Handle:event, const String:name[], bool:dontBroadcast)
{
	new victim = GetEventInt(event, "entindex_killed");
	new attacker = GetEventInt(event, "entindex_attacker");
	new inflictor = GetEventInt(event, "entindex_inflictor");

	AntiHack_Aimbot_Detection_PlayerDeath(event,victim,attacker,inflictor,Event_EntityKilled);
}

public Hook_TF2_Event_PlayerDeath(Handle:event, const String:name[], bool:dontBroadcast)
{
	new victim = GetClientOfUserId(GetEventInt(event, "userid"));
	new attacker = GetClientOfUserId(GetEventInt(event, "attacker"));
	new inflictor = GetEventInt(event, "inflictor_entindex");

	AntiHack_Aimbot_Detection_PlayerDeath(event,victim,attacker,inflictor,TF2_Event_PlayerDeath);
}

