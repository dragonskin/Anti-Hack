// antihack_constants.inc

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
*/

enum EventDeathType
{
	TF2_Event_PlayerDeath = 0,
	Event_EntityKilled,
	Event_PlayerDeath,
}


enum AntiHackSQLType
{
	SQLType_Unknown = 0,
	SQLType_MySQL,
	SQLType_SQLite,
}

// Games that AntiHack Supports
enum eGameNumberValve {
	AHGame_Unknown = 0,
	AHGame_CSS,
	AHGame_TF2,
	AHGame_DODS,
	AHGame_INSMOD,
	AHGame_L4D,
	AHGame_L4D2,
	AHGame_HL2DM,
	AHGame_FOF,
	AHGame_GMOD,
	AHGame_HL2CTF,
	AHGame_HIDDEN,
	AHGame_ND,
	AHGame_CSGO,
};

stock const String:Team_List[][] = {
	"Unassigned",
	"Spectator",
	"Team Red",
	"Team Blue",
	"Unknown"
};

// Use these like a boolean
#define GAMEINSMOD GameINSMOD()
#define GAMEDOD GameDOD()
#define GAMEHL2DM GameHL2DM()
#define GAMECS GameCS()
#define GAMETF GameTF()
#define GAMEL4D1 GameL4D1()
#define GAMEL4D2 GameL4D2()
#define GAMEL4DANY GameL4DAny()
#define GAMECSGO GameCSGO()
#define GAMECSANY GameCSANY()
// games that supports <color>
#define GAMECOLOR GameCOLOR()
