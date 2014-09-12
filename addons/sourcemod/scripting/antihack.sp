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

#define VERSION_NUM "1.0.0.0"
#define AUTHORS "The AntiHack Team"

#define ANTIHACK

#include <sourcemod>
#include "AntiHack/includes/antihack_interface.inc"

public Plugin:myinfo=
{
	name="Antihack",
	author=AUTHORS,
	description="Brings an Easy to use Antihack to the Source engine.",
	version=VERSION_NUM,
};

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

	return true;
}

public OnPluginStart()
{

	PrintToServer("--------------------------OnPluginStart----------------------");

	PrintToServer("[War3Evo] Plugin finished loading.\n-------------------END OnPluginStart-------------------");

}

public OnMapStart()
{
	PrintToServer("OnMapStart");
}

public OnAllPluginsLoaded() //called once only, will not call again when map changes
{
	PrintToServer("OnAllPluginsLoaded");
}

public OnClientPutInServer(client)
{
}

public OnClientDisconnect(client)
{
}
