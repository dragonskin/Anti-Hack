// AntiHack_Aimbot_Detection.sp

/*
	Anti-Hack

	Copyright (c) 2014  El Diablo <diablo@war3evo.info>

	Antihack is free software: you may copy, redistribute
	and/or modify it under the terms of the GNU General Public License as
	published by the Free Software Foundation, either version 3 of the
	License, or (at your option) any later version.

	This file is distributed in the hope that it will be useful, but
	WITHOUT ANY WARRANTY; without even the implied warranty of
	MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
	General Public License for more details.

	You should have received a copy of the GNU General Public License
	along with this program.  If not, see <http://www.gnu.org/licenses/>.

	This file incorporates work covered by the following copyright and
	permission notice:

	SourceMod Anti-Cheat
	Copyright (C) 2011-2013 SMAC Development Team

	This program is free software: you can redistribute it and/or modify
	it under the terms of the GNU General Public License as published by
	the Free Software Foundation, either version 3 of the License, or
	(at your option) any later version.

	This program is distributed in the hope that it will be useful,
	but WITHOUT ANY WARRANTY; without even the implied warranty of
	MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
	GNU General Public License for more details.

	You should have received a copy of the GNU General Public License
	along with this program.  If not, see <http://www.gnu.org/licenses/>.

	This file incorporates work covered by the following copyright and
	permission notice:

	Kigen's Anti-Cheat Module
	Copyright (C) 2007-2011 CodingDirect LLC

	This program is free software: you can redistribute it and/or modify
	it under the terms of the GNU General Public License as published by
	the Free Software Foundation, either version 3 of the License, or
	(at your option) any later version.

	This program is distributed in the hope that it will be useful,
	but WITHOUT ANY WARRANTY; without even the implied warranty of
	MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
	GNU General Public License for more details.

	You should have received a copy of the GNU General Public License
	along with this program.  If not, see <http://www.gnu.org/licenses/>.
*/

public bool:AH_Aimbot_Detection_AskPluginLoad2()
{
	// Optional dependencies.
	MarkNativeAsOptional("SBBanPlayer");
	MarkNativeAsOptional("IRC_MsgFlaggedChannels");
	MarkNativeAsOptional("IRC_Broadcast");

	return true;
}

public AH_Aimbot_Detection_OnPluginStart()
{
	// Store no more than 500ms worth of angle history.
	if ((g_iMaxAngleHistory = TIME_TO_TICK(0.5)) > sizeof(g_fEyeAngles[]))
	{
		g_iMaxAngleHistory = sizeof(g_fEyeAngles[]);
	}

	// Weapons to ignore when analyzing.
	g_IgnoreWeapons = CreateTrie();

	switch (AH_GetGame())
	{
		case AHGame_CSS:
		{
			SetTrieValue(g_IgnoreWeapons, "weapon_knife", 1);
		}
		case AHGame_CSGO:
		{
			SetTrieValue(g_IgnoreWeapons, "weapon_knife", 1);
			SetTrieValue(g_IgnoreWeapons, "weapon_taser", 1);
		}
		case AHGame_DODS:
		{
			SetTrieValue(g_IgnoreWeapons, "weapon_spade", 1);
			SetTrieValue(g_IgnoreWeapons, "weapon_amerknife", 1);
		}
		case AHGame_TF2:
		{
			SetTrieValue(g_IgnoreWeapons, "tf_weapon_bottle", 1);
			SetTrieValue(g_IgnoreWeapons, "tf_weapon_sword", 1);
			SetTrieValue(g_IgnoreWeapons, "tf_weapon_wrench", 1);
			SetTrieValue(g_IgnoreWeapons, "tf_weapon_robot_arm", 1);
			SetTrieValue(g_IgnoreWeapons, "tf_weapon_fists", 1);
			SetTrieValue(g_IgnoreWeapons, "tf_weapon_bonesaw", 1);
			SetTrieValue(g_IgnoreWeapons, "tf_weapon_fireaxe", 1);
			SetTrieValue(g_IgnoreWeapons, "tf_weapon_bat", 1);
			SetTrieValue(g_IgnoreWeapons, "tf_weapon_bat_wood", 1);
			SetTrieValue(g_IgnoreWeapons, "tf_weapon_bat_fish", 1);
			SetTrieValue(g_IgnoreWeapons, "tf_weapon_club", 1);
			SetTrieValue(g_IgnoreWeapons, "tf_weapon_shovel", 1);
			SetTrieValue(g_IgnoreWeapons, "tf_weapon_knife", 1);
			SetTrieValue(g_IgnoreWeapons, "tf_weapon_stickbomb", 1);
			SetTrieValue(g_IgnoreWeapons, "tf_weapon_katana", 1);
			SetTrieValue(g_IgnoreWeapons, "tf_weapon_flamethrower", 1);
		}
		case AHGame_HL2DM:
		{
			SetTrieValue(g_IgnoreWeapons, "weapon_crowbar", 1);
			SetTrieValue(g_IgnoreWeapons, "weapon_stunstick", 1);
		}
	}

	// Hooks.
	HookEntityOutput("trigger_teleport", "OnEndTouch", Teleport_OnEndTouch);
	HookEvent("player_spawn", Event_PlayerSpawn, EventHookMode_Post);

	if (GAMETF)
	{
		HookEvent("player_death", TF2_Event_PlayerDeath, EventHookMode_Post);
	}
	else if (!HookEventEx("entity_killed", Event_EntityKilled, EventHookMode_Post))
	{
		HookEvent("player_death", Event_PlayerDeath, EventHookMode_Post);
	}
}

public AH_Aimbot_Detection_OnClientPutInServer(client)
{
	if (IsClientNew(client))
	{
		g_iAimDetections[client] = 0;
		Aimbot_ClearAngles(client);
	}
}

public Teleport_OnEndTouch(const String:output[], caller, activator, Float:delay)
{
	/* A client is being teleported in the map. */
	if (IS_CLIENT(activator) && IsClientConnected(activator))
	{
		Aimbot_ClearAngles(activator);
		CreateTimer(0.1 + delay, Timer_ClearAngles, GetClientUserId(activator), TIMER_FLAG_NO_MAPCHANGE);
	}
}

public Event_PlayerSpawn(Handle:event, const String:name[], bool:dontBroadcast)
{
	new userid = GetEventInt(event, "userid");
	new client = GetClientOfUserId(userid);

	if (IS_CLIENT(client))
	{
		Aimbot_ClearAngles(client);
		CreateTimer(0.1, Timer_ClearAngles, userid, TIMER_FLAG_NO_MAPCHANGE);
	}
}

public Event_PlayerDeath(Handle:event, const String:name[], bool:dontBroadcast)
{
	decl String:sWeapon[32];
	GetEventString(event, "weapon", sWeapon, sizeof(sWeapon));

	if (GetTrieValue(g_IgnoreWeapons, sWeapon, dummy))
		return;

	new victim = GetClientOfUserId(GetEventInt(event, "userid"));
	new attacker = GetClientOfUserId(GetEventInt(event, "attacker"));

	if (IS_CLIENT(victim) && IS_CLIENT(attacker) && victim != attacker && IsClientInGame(victim) && IsClientInGame(attacker))
	{
		decl Float:vVictim[3], Float:vAttacker[3];
		GetClientAbsOrigin(victim, vVictim);
		GetClientAbsOrigin(attacker, vAttacker);

		if (GetVectorDistance(vVictim, vAttacker) >= AIM_MIN_DISTANCE)
		{
			Aimbot_AnalyzeAngles(attacker);
		}
	}
}

public Event_EntityKilled(Handle:event, const String:name[], bool:dontBroadcast)
{
	/* (OB Only) Inflictor support lets us ignore non-bullet weapons. */
	new victim = GetEventInt(event, "entindex_killed");
	new attacker = GetEventInt(event, "entindex_attacker");
	new inflictor = GetEventInt(event, "entindex_inflictor");

	if (IS_CLIENT(victim) && IS_CLIENT(attacker) && victim != attacker && attacker == inflictor && IsClientInGame(victim) && IsClientInGame(attacker))
	{
		decl String:sWeapon[32];
		GetClientWeapon(attacker, sWeapon, sizeof(sWeapon));

		if (GetTrieValue(g_IgnoreWeapons, sWeapon, dummy))
			return;

		decl Float:vVictim[3], Float:vAttacker[3];
		GetClientAbsOrigin(victim, vVictim);
		GetClientAbsOrigin(attacker, vAttacker);

		if (GetVectorDistance(vVictim, vAttacker) >= AIM_MIN_DISTANCE)
		{
			Aimbot_AnalyzeAngles(attacker);
		}
	}
}

public TF2_Event_PlayerDeath(Handle:event, const String:name[], bool:dontBroadcast)
{
	/* TF2 custom death event */
	new victim = GetClientOfUserId(GetEventInt(event, "userid"));
	new attacker = GetClientOfUserId(GetEventInt(event, "attacker"));
	new inflictor = GetEventInt(event, "inflictor_entindex");

	if (IS_CLIENT(victim) && IS_CLIENT(attacker) && victim != attacker && attacker == inflictor && IsClientInGame(victim) && IsClientInGame(attacker))
	{
		decl String:sWeapon[32];
		GetClientWeapon(attacker, sWeapon, sizeof(sWeapon));

		if (GetTrieValue(g_IgnoreWeapons, sWeapon, dummy))
			return;

		decl Float:vVictim[3], Float:vAttacker[3];
		GetClientAbsOrigin(victim, vVictim);
		GetClientAbsOrigin(attacker, vAttacker);

		if (GetVectorDistance(vVictim, vAttacker) >= AIM_MIN_DISTANCE)
		{
			Aimbot_AnalyzeAngles(attacker);
		}
	}
}

public Action:Timer_ClearAngles(Handle:timer, any:userid)
{
	/* Delayed because the client's angles can sometimes "spin" after being teleported. */
	new client = GetClientOfUserId(userid);

	if (IS_CLIENT(client))
	{
		Aimbot_ClearAngles(client);
	}

	return Plugin_Stop;
}

public Action:Timer_DecreaseCount(Handle:timer, any:userid)
{
	/* Decrease the detection count by 1. */
	new client = GetClientOfUserId(userid);

	if (IS_CLIENT(client) && g_iAimDetections[client])
	{
		g_iAimDetections[client]--;
	}

	return Plugin_Stop;
}

public Action:Aimbot_Detection_OnPlayerRunCmd(client, &buttons, &impulse, Float:vel[3], Float:angles[3], &weapon)
{
	g_fEyeAngles[client][g_iEyeIndex[client]] = angles;

	if (++g_iEyeIndex[client] == g_iMaxAngleHistory)
	{
		g_iEyeIndex[client] = 0;
	}

	return Plugin_Continue;
}

Aimbot_AnalyzeAngles(client)
{
	/* Analyze the client to see if their angles snapped. */
	decl Float:vLastAngles[3], Float:vAngles[3], Float:fAngleDiff;
	new idx = g_iEyeIndex[client];

	for (new i = 0; i < g_iMaxAngleHistory; i++)
	{
		if (idx == g_iMaxAngleHistory)
		{
			idx = 0;
		}

		if (IsVectorZero(g_fEyeAngles[client][idx]))
		{
			break;
		}

		// Nothing to compare on the first iteration.
		if (i == 0)
		{
			vLastAngles = g_fEyeAngles[client][idx];
			idx++;
			continue;
		}

		vAngles = g_fEyeAngles[client][idx];
		fAngleDiff = GetVectorDistance(vLastAngles, vAngles);

		// If the difference is being reported higher than 180, get the 'real' value.
		if (fAngleDiff > 180)
		{
			fAngleDiff = FloatAbs(fAngleDiff - 360);
		}

		if (fAngleDiff > AIM_ANGLE_CHANGE)
		{
			Aimbot_Detected(client, fAngleDiff,false);
			break;
		}
		else if (fAngleDiff > AIM_ANGLE_CHANGE_HS)
		{
			Aimbot_Detected(client, fAngleDiff,true);
			break;
		}


		vLastAngles = vAngles;
		idx++;
	}
}

Aimbot_Detected(client, const Float:deviation, bool:HighSensitivity)
{
	// Extra checks must be done here because of data coming from two events.
	if (IsFakeClient(client) || !IsPlayerAlive(client))
		return;

	switch (AH_GetGame())
	{
		case AHGame_L4D:
		{
			if (GetClientTeam(client) != 2 || L4D_IsSurvivorBusy(client))
				return;
		}
		case AHGame_L4D2:
		{
			if (GetClientTeam(client) != 2 || L4D2_IsSurvivorBusy(client))
				return;
		}
		case AHGame_ND:
		{
			if (ND_IsPlayerCommander(client))
				return;
		}
	}

	if(!HighSensitivity)
	{
		decl String:sWeapon[32];
		GetClientWeapon(client, sWeapon, sizeof(sWeapon));

		// Expire this detection after 10 minutes.
		CreateTimer(600.0, Timer_DecreaseCount, GetClientUserId(client));

		// Ignore the first detection as it's just as likely to be a false positive.
		if (++g_iAimDetections[client] > 1)
		{
			IncreaseAimBotCount(client);

			decl String:sClientName[128];
			GetClientName(client,sClientName,sizeof(sClientName));

			decl String:sSteamID[64],String:sSteamID2[64];

			GetClientAuthString(client, sSteamID2, sizeof(sSteamID2));
			strcopy(sSteamID, sizeof(sSteamID), sSteamID2);
			if(GAMETF)
			{
				if(Convert_UniqueID_TO_SteamID(sSteamID2))
				{
					NotifyAdmins("%s %s %s is suspected of using an aimbot. (Detection #%i | Deviation: %.0f° | Weapon: %s)", sClientName, sSteamID, sSteamID2, g_iAimDetections[client], deviation, sWeapon);
					AntiHackLog("%s %s %s is suspected of using an aimbot. (Detection #%i | Deviation: %.0f° | Weapon: %s)", sClientName, sSteamID, sSteamID2, g_iAimDetections[client], deviation, sWeapon);
				}
				else if(Convert_SteamID_TO_UniqueID(sSteamID2))
				{
					NotifyAdmins("%s %s %s is suspected of using an aimbot. (Detection #%i | Deviation: %.0f° | Weapon: %s)", sClientName, sSteamID, sSteamID2, g_iAimDetections[client], deviation, sWeapon);
					AntiHackLog("%s %s %s is suspected of using an aimbot. (Detection #%i | Deviation: %.0f° | Weapon: %s)", sClientName, sSteamID, sSteamID2, g_iAimDetections[client], deviation, sWeapon);
				}
				else
				{
					NotifyAdmins("%s %s is suspected of using an aimbot. (Detection #%i | Deviation: %.0f° | Weapon: %s)", sClientName, sSteamID, g_iAimDetections[client], deviation, sWeapon);
					AntiHackLog("%s %s is suspected of using an aimbot. (Detection #%i | Deviation: %.0f° | Weapon: %s)", sClientName, sSteamID, g_iAimDetections[client], deviation, sWeapon);
				}
			}
			else
			{
				NotifyAdmins("%s %s is suspected of using an aimbot. (Detection #%i | Deviation: %.0f° | Weapon: %s)", sClientName, sSteamID, g_iAimDetections[client], deviation, sWeapon);
				AntiHackLog("%s %s is suspected of using an aimbot. (Detection #%i | Deviation: %.0f° | Weapon: %s)", sClientName, sSteamID, g_iAimDetections[client], deviation, sWeapon);
			}

			if (g_iAimbotBan && g_iAimDetections[client] >= g_iAimbotBan)
			{
				//LogAction(client, "was banned for using an aimbot.");
				//Ban(client, "Aimbot Detected");

				// Take Action
			}
		}
	}
	else if(g_bHighSensitivityModeEnabled && HighSensitivity)
	{
		// CHEAT DETECTED!
		IncreaseHSAimBotCount(client);

		if(!AHGetHackerProp(client,bAntiAimbot) && !AHGetHackerProp(client,bChanceOnHit) && !AHGetHackerProp(client,bNoDamage))
		{
			decl String:sWeapon[32];
			GetClientWeapon(client, sWeapon, sizeof(sWeapon));

			decl String:sClientName[128];
			GetClientName(client,sClientName,sizeof(sClientName));

			decl String:sSteamID[64],String:sSteamID2[64];

			GetClientAuthString(client, sSteamID2, sizeof(sSteamID2));
			strcopy(sSteamID, sizeof(sSteamID), sSteamID2);
			if(GAMETF)
			{
				if(Convert_UniqueID_TO_SteamID(sSteamID2))
				{
					NotifyAdmins("%s %s %s [HIGH SENITIVITY] (Detection #%i | Deviation: %.0f° | Weapon: %s)", sClientName, sSteamID, sSteamID2, g_iAimDetections[client], deviation, sWeapon);
					AntiHackLog("%s %s %s [HIGH SENITIVITY] (Detection #%i | Deviation: %.0f° | Weapon: %s)", sClientName, sSteamID, sSteamID2, g_iAimDetections[client], deviation, sWeapon);
				}
				else if(Convert_SteamID_TO_UniqueID(sSteamID2))
				{
					NotifyAdmins("%s %s %s [HIGH SENITIVITY] (Detection #%i | Deviation: %.0f° | Weapon: %s)", sClientName, sSteamID, sSteamID2, g_iAimDetections[client], deviation, sWeapon);
					AntiHackLog("%s %s %s [HIGH SENITIVITY] (Detection #%i | Deviation: %.0f° | Weapon: %s)", sClientName, sSteamID, sSteamID2, g_iAimDetections[client], deviation, sWeapon);
				}
				else
				{
					NotifyAdmins("%s %s [HIGH SENITIVITY] (Detection #%i | Deviation: %.0f° | Weapon: %s)", sClientName, sSteamID, g_iAimDetections[client], deviation, sWeapon);
					AntiHackLog("%s %s [HIGH SENITIVITY] (Detection #%i | Deviation: %.0f° | Weapon: %s)", sClientName, sSteamID, g_iAimDetections[client], deviation, sWeapon);
				}
			}
			else
			{
				NotifyAdmins("%s %s [HIGH SENITIVITY] (Detection #%i | Deviation: %.0f° | Weapon: %s)", sClientName, sSteamID, g_iAimDetections[client], deviation, sWeapon);
				AntiHackLog("%s %s [HIGH SENITIVITY] (Detection #%i | Deviation: %.0f° | Weapon: %s)", sClientName, sSteamID, g_iAimDetections[client], deviation, sWeapon);
			}
		}
	}
}

Aimbot_ClearAngles(client)
{
	/* Clear angle history and reset the index. */
	g_iEyeIndex[client] = 0;

	for (new i = 0; i < g_iMaxAngleHistory; i++)
	{
		ZeroVector(g_fEyeAngles[client][i]);
	}
}
