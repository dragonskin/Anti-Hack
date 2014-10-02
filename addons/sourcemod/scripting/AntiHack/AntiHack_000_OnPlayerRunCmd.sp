// AntiHack_000_OnPlayerRunCmd.sp

public Action:OnPlayerRunCmd(client, &buttons, &impulse, Float:vel[3], Float:angles[3], &weapon)
{
	new Action:ReturnAction=Plugin_Continue;
	ReturnAction = SpinHack_Detection_OnPlayerRunCmd(client, buttons, impulse, vel, angles, weapon);
	ReturnAction = Aimbot_Detection_OnPlayerRunCmd(client, buttons, impulse, vel, angles, weapon);
	return ReturnAction;
}
