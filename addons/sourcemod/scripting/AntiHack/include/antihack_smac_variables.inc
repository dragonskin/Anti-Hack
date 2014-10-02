// antihack_smac_interface.inc

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

new Float:AIM_ANGLE_CHANGE = 45.0;		// Max angle change that a player should snap
new Float:AIM_MIN_DISTANCE = 200.0;		// Minimum distance acceptable for a detection.

// not used at this time
//new AIM_BAN_MIN = 4;				// Minimum number of detections before an auto-ban is allowed


// High Sensitivity Mode:
new Float:AIM_ANGLE_CHANGE_HS = 30.0;

//new Float:g_iAimbotHS_Min_Distance = 100.0;

//new Handle:g_hCvarAimbotBan = INVALID_HANDLE;
new Handle:g_IgnoreWeapons = INVALID_HANDLE;

new Float:g_fEyeAngles[MAXPLAYERS+1][64][3];
new g_iEyeIndex[MAXPLAYERS+1];

new g_iAimDetections[MAXPLAYERS+1];
new g_iAimbotBan = 0;
new g_iMaxAngleHistory;
