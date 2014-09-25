// AntiHack_000_OnGameFrame.sp

new skipaframe;

public OnGameFrame()
{
	skipaframe--;
	if(skipaframe<0){
		skipaframe=1;
		for(new client=1;client<=MaxClients;client++)
		{
			if(ValidPlayer(client,true))
			{
				GetClientEyeAngles(client,CachedAngle[client]);
				GetClientAbsOrigin(client,CachedPos[client]);
			}
		}
	}
}
