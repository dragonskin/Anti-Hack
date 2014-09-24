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

#if defined _antihack_included
  #endinput
#endif
#define _antihack_included

enum FilterType
{
	AH_Filter_Normal,
	AH_Filter_Warning,
	AH_Filter_Block,
	AH_Filter_Ban
}

enum AHHackerProp
{
	iPlayerID,
	iFirstTimeHacked,
	iLastTimeHacked,
	bool:bIsHacker,
	bool:bAntiAimbot,
	bool:bChanceOnHit,
	bool:bNoDamage,
	iAimbotCount,
	iSpinhackCount,
	iEyeAnglesCount,
	iChangingInterfaceCount,
	iChangingTimerCount,
	iRewritingMovementCommandsCount,
	iChangingViewAnglesAimbotCount,
	iCrashed
}

// STOCKS


// NATIVES NATIVES NATIVES NATIVES NATIVES NATIVES NATIVES NATIVES NATIVES NATIVES
// NATIVES NATIVES NATIVES NATIVES NATIVES NATIVES NATIVES NATIVES NATIVES NATIVES
// NATIVES NATIVES NATIVES NATIVES NATIVES NATIVES NATIVES NATIVES NATIVES NATIVES
// NATIVES NATIVES NATIVES NATIVES NATIVES NATIVES NATIVES NATIVES NATIVES NATIVES
// NATIVES NATIVES NATIVES NATIVES NATIVES NATIVES NATIVES NATIVES NATIVES NATIVES
// NATIVES NATIVES NATIVES NATIVES NATIVES NATIVES NATIVES NATIVES NATIVES NATIVES
// NATIVES NATIVES NATIVES NATIVES NATIVES NATIVES NATIVES NATIVES NATIVES NATIVES
// NATIVES NATIVES NATIVES NATIVES NATIVES NATIVES NATIVES NATIVES NATIVES NATIVES
// NATIVES NATIVES NATIVES NATIVES NATIVES NATIVES NATIVES NATIVES NATIVES NATIVES
// NATIVES NATIVES NATIVES NATIVES NATIVES NATIVES NATIVES NATIVES NATIVES NATIVES
// NATIVES NATIVES NATIVES NATIVES NATIVES NATIVES NATIVES NATIVES NATIVES NATIVES
// NATIVES NATIVES NATIVES NATIVES NATIVES NATIVES NATIVES NATIVES NATIVES NATIVES
// NATIVES NATIVES NATIVES NATIVES NATIVES NATIVES NATIVES NATIVES NATIVES NATIVES
// NATIVES NATIVES NATIVES NATIVES NATIVES NATIVES NATIVES NATIVES NATIVES NATIVES

/**
 * Checks say command
 * OnAHSayCommandFilter has a ascii filter, that filters all characters that are not 32 - 126 ascii
 * See http://www.asciitable.com/
 *
 * @param client:			Client index
 * @param RawString: 		unfiltered string
 * @param FilteredString:	filtered string (ascii 32 - 126 is allowed)
 * @return:					return any kind of return, except Plugin_Continue to stop message.
 */
forward Action:OnAHSayCommandFilter(client,String:RawString[],String:FilteredString[]);

/**
 * Checks Team say command
 * OnAHTeamSayCommandFilter has a ascii filter, that filters all characters that are not 32 - 126 ascii
 * See http://www.asciitable.com/
 *
 * @param client:			Client index
 * @param RawString: 		unfiltered string
 * @param FilteredString:	filtered string (ascii 32 - 126 is allowed)
 * @return:					return any kind of return, except Plugin_Continue to stop message.
 */
forward Action:OnAHTeamSayCommandFilter(client,String:RawString[],String:FilteredString[]);

/**
 * Get last cached player eye angle.
 * @param client: Client index
 * @param angle[3]: Output array
 * @noreturn
 */
native AH_CachedAngle(client,Float:angle[3]);

/**
 * Get last cached player position.
 * @param client: Client index
 * @param position[3]: Output array
 * @noreturn
 */
native AH_CachedPosition(client,Float:position[3]);

native AHSetHackerProp(client,AHHackerProp:property,any:value);
native any:AHGetHackerProp(client,AHHackerProp:property);

// STOCKS STOCKS STOCKS STOCKS STOCKS STOCKS STOCKS STOCKS STOCKS STOCKS STOCKS
// STOCKS STOCKS STOCKS STOCKS STOCKS STOCKS STOCKS STOCKS STOCKS STOCKS STOCKS
// STOCKS STOCKS STOCKS STOCKS STOCKS STOCKS STOCKS STOCKS STOCKS STOCKS STOCKS
// STOCKS STOCKS STOCKS STOCKS STOCKS STOCKS STOCKS STOCKS STOCKS STOCKS STOCKS
// STOCKS STOCKS STOCKS STOCKS STOCKS STOCKS STOCKS STOCKS STOCKS STOCKS STOCKS


public SharedPlugin:__pl_antihack =
{
	name = "antihack",
	file = "antihack.smx",
#if defined REQUIRE_PLUGIN
	required = 1,
#else
	required = 0,
#endif
};

#if !defined REQUIRE_PLUGIN
public __pl_antihack_SetNTVOptional()
{
	MarkNativeAsOptional("AH_PotentialThreat");
}
#endif
