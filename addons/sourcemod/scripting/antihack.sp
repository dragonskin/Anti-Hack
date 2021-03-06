// antihack.sp

/*  This program is free software: you can redistribute it and/or modify
	it under the terms of the GNU General Public License as published by
	the Free Software Foundation, either version 3 of the License, or
	(at your option) any later version.

	This program is distributed in the hope that it will be useful,
	but WITHOUT ANY WARRANTY; without even the implied warranty of
	MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
	GNU General Public License for more details.

	You should have received a copy of the GNU General Public License
	along with this program.  If not, see <http://www.gnu.org/licenses/>.

	Antihack written by El Diablo of www.War3Evo.info
	All rights reserved.
*/

/*
* File: Antihack.sp
* Description: The main file for Antihack.
* Author: El Diablo
*/
#pragma semicolon 1


#define VERSION_NUM "1.0.0.1A"
#define AUTHORS "The AntiHack Team"

//#define ANTIHACK
#undef REQUIRE_EXTENSIONS

// Headers

enum IrcChannel
{
	IrcChannel_Public  = 1,
	IrcChannel_Private = 2,
	IrcChannel_Both    = 3
}

native SBBanPlayer(client, target, time, String:reason[]);
native IRC_MsgFlaggedChannels(const String:flag[], const String:format[], any:...);
native IRC_Broadcast(IrcChannel:type, const String:format[], any:...);

#include <sourcemod>
#include <antihack>
#include <sdktools>
#include <sdktools_functions>
#include <morecolors>

// for crash code
//#include <sdktools_tempents>
//#include <sdktools_tempents_stocks>
//#include <sdktools_engine>
//#include <sdktools_functions>
//#include <sdktools_entinput>

//#tryinclude <sourcebans>

#include "AntiHack/include/antihack_variables.inc"
#include "AntiHack/include/antihack_constants.inc"

// Note the antihack_smac_*.inc file does not require smac,
// it is just denoting that it contains some smac code:
#include "AntiHack/include/antihack_smac_variables.inc"
#include "AntiHack/include/antihack_smac_interface.inc"

#include "AntiHack/include/antihack_interface.inc"

#include "AntiHack/AntiHack_000_NativesForwards.sp"
#include "AntiHack/AntiHack_000_OnClientAuthorized.sp"
#include "AntiHack/AntiHack_000_OnClientConnected.sp"
#include "AntiHack/AntiHack_000_OnClientDisconnect.sp"
#include "AntiHack/AntiHack_000_OnClientPutInServer.sp"
#include "AntiHack/AntiHack_000_OnGameFrame.sp"
#include "AntiHack/AntiHack_000_OnPlayerRunCmd.sp"
// AntiHack_Aimbot_Detection.sp contains some smac code:
#include "AntiHack/AntiHack_Aimbot_Detection.sp"
#include "AntiHack/AntiHack_Configuration.sp"
#include "AntiHack/AntiHack_Crash_Code.sp"
#include "AntiHack/AntiHack_Database.sp"
#include "AntiHack/AntiHack_DatabaseConnect.sp"
// AntiHack_SpinHack_Detection.sp contains some smac code:
#include "AntiHack/AntiHack_SpinHack_Detection.sp"

#include "AntiHack/AntiHack_Event_Hooks.sp"

#include "AntiHack/AntiHack_Word_Filter.sp"

#include "AntiHack/AntiHack_000_OnClientPostAdminCheck.sp"
//#include "AntiHack/"
//#include "AntiHack/"
//#include "AntiHack/"
//#include "AntiHack/"
//#include "AntiHack/"
//#include "AntiHack/"
//#include "AntiHack/"

//new Handle:ClientHUD;

public Plugin:myinfo=
{
	name="Antihack",
	author=AUTHORS,
	description="Brings an Easy to use Antihack to the Source engine.",
	version=VERSION_NUM,
};

public OnPluginStart()
{
	new String:version[64];
	Format(version,sizeof(version),"%s by %s",VERSION_NUM,AUTHORS);

	CreateConVar("antihack_version",version,"AntiHack version.",FCVAR_PLUGIN|FCVAR_SPONLY|FCVAR_REPLICATED|FCVAR_NOTIFY|FCVAR_DONTRECORD);

	PrintToServer("--------------------------OnPluginStart----------------------");

	PrintToServer("[ANTIHACK] Plugin finished loading.\n-------------------END OnPluginStart-------------------");

	RegConsoleCmd("say",          AH_SayCommand);
	RegConsoleCmd("say_team",     AH_TeamSayCommand);

	g_hPotientalThreatWords = CreateArray(32);

	//CreateTimer(0.1,ClientAim,_,TIMER_REPEAT);

	AntiHack_Configuration_OnPluginStart();

	AH_Aimbot_Detection_OnPluginStart();

	SpinHack_Detection_OnPluginStart();

	AntiHack_Event_Hooks_OnPluginStart();
}

public OnMapStart()
{
	// Default Name Change in seconds
	PrintToServer("OnMapStart");
	ServerCommand("sm_rcon sv_namechange_cooldown_seconds 20");
}


public OnAllPluginsLoaded() //called once only, will not call again when map changes
{
	PrintToServer("OnAllPluginsLoaded *** START");

	if(ConnectToDataBase())
	{
		Initialize_SQLTable();
	}

	CreateTimer(g_fAutosaveTime,DataBase_DoAutosave);

	if(LibraryExists("ircrelay"))
	{
		ircrelay_exists=true;
	}

	if(LibraryExists("sourcebans"))
	{
		sourcebans_exists=true;
	}

	ParseFile();

	PrintToServer("OnAllPluginsLoaded *** END");
}

public OnLibraryAdded(const String:name[])
{
	if(StrEqual(name,"ircrelay"))
	{
		ircrelay_exists=true;
	}
	else if(StrEqual(name,"sourcebans"))
	{
		sourcebans_exists=true;
	}
}

public OnLibraryRemoved(const String:name[])
{
	if(StrEqual(name,"ircrelay"))
	{
		ircrelay_exists=false;
	}
	else if(StrEqual(name,"sourcebans"))
	{
		sourcebans_exists=false;
	}
}
