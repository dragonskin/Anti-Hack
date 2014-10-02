// AntiHack_SpinHack_Detection.sp

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

public SpinHack_Detection_OnPluginStart()
{
	CreateTimer(1.0, Timer_CheckSpins, _, TIMER_REPEAT);
}

public SpinHack_Detection_OnClientDisconnect(client)
{
	g_iSpinCount[client] = 0;
	g_fSensitivity[client] = 0.0;
}

public Action:Timer_CheckSpins(Handle:timer)
{
	for (new i = 1; i <= MaxClients; i++)
	{
		if (!IsClientInGame(i) || IsFakeClient(i))
		{
			continue;
		}

		if (g_fAngleDiff[i] > SPIN_ANGLE_CHANGE && IsPlayerAlive(i))
		{
			g_iSpinCount[i]++;

			if (g_iSpinCount[i] == 1)
			{
				QueryClientConVar(i, "sensitivity", Query_MouseCheck, GetClientUserId(i));
			}

			if (g_iSpinCount[i] == SPIN_DETECTIONS && g_fSensitivity[i] <= SPIN_SENSITIVITY)
			{
				Spinhack_Detected(i);
			}

			if (g_bSpinhack_warning && g_iSpinCount[i] == (SPIN_DETECTIONS-5) && g_fSensitivity[i] <= SPIN_SENSITIVITY)
			{
				decl String:sClientName[128];
				GetClientName(client,sClientName,sizeof(sClientName));

				decl String:sSteamID[64],String:sSteamID2[64];

				GetClientAuthString(client, sSteamID2, sizeof(sSteamID2));
				strcopy(sSteamID, sizeof(sSteamID), sSteamID2);
				if(GAMETF)
				{
					if(!Convert_UniqueID_TO_SteamID(sSteamID2))
					{
						Convert_SteamID_TO_UniqueID(sSteamID2);
					}
				}
				NotifyAdmins("[ANTIHACK] Early warning of possible use of spinhack => %s %s %s", sClientName, sSteamID, sSteamID2);
			}
		}
		else
		{
			g_iSpinCount[i] = 0;
		}

		g_fAngleDiff[i] = 0.0;
	}

	return Plugin_Continue;
}

public Query_MouseCheck(QueryCookie:cookie, client, ConVarQueryResult:result, const String:cvarName[], const String:cvarValue[], any:userid)
{
	if (result == ConVarQuery_Okay && GetClientOfUserId(userid) == client)
	{
		g_fSensitivity[client] = StringToFloat(cvarValue);
	}
}

public Action:SpinHack_Detection_OnPlayerRunCmd(client, &buttons, &impulse, Float:vel[3], Float:angles[3], &weapon)
{
	if (!(buttons & IN_LEFT || buttons & IN_RIGHT))
	{
		// Only checking the Z axis here.
		g_fAngleBuffer = FloatAbs(angles[1] - g_fPrevAngle[client]);
		g_fAngleDiff[client] += (g_fAngleBuffer > 180.0) ? (g_fAngleBuffer - 360.0) * -1.0 : g_fAngleBuffer;
		g_fPrevAngle[client] = angles[1];
	}

	return Plugin_Continue;
}

Spinhack_Detected(client)
{
	decl String:sClientName[128];
	GetClientName(client,sClientName,sizeof(sClientName));

	decl String:sSteamID[64],String:sSteamID2[64];

	GetClientAuthString(client, sSteamID2, sizeof(sSteamID2));
	strcopy(sSteamID, sizeof(sSteamID), sSteamID2);
	if(GAMETF)
	{
		if(Convert_UniqueID_TO_SteamID(sSteamID2))
		{
			NotifyAdmins("%s %s %s is suspected of using a spinhack.", sClientName, sSteamID, sSteamID2);
			AntiHackLog("%s %s %s is suspected of using a spinhack.", sClientName, sSteamID, sSteamID2);
		}
		else if(Convert_SteamID_TO_UniqueID(sSteamID2))
		{
			NotifyAdmins("%s %s %s is suspected of using a spinhack.", sClientName, sSteamID, sSteamID2);
			AntiHackLog("%s %s %s is suspected of using a spinhack.", sClientName, sSteamID, sSteamID2);
		}
		else
		{
			NotifyAdmins("%s %s is suspected of using a spinhack.", sClientName, sSteamID);
			AntiHackLog("%s %s is suspected of using a spinhack.", sClientName, sSteamID);
		}
	}
	else
	{
		NotifyAdmins("%s %s is suspected of using a spinhack.", sClientName, sSteamID);
		AntiHackLog("%s %s is suspected of using a spinhack.", sClientName, sSteamID);
	}

	if(g_bCrash_OnSpinHack)
	{
		CrashClient(client);
		AntiHackLog("%s %s >> Crashed Client", sClientName, sSteamID);
	}
}
