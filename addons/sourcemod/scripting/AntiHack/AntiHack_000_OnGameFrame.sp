// AntiHack_000_OnGameFrame.sp

new skipaframe;

public OnGameFrame()
{
	skipaframe--;
	if(skipaframe<0){
		skipaframe=1;
		if(++HistoryCount >= MaxHistory) HistoryCount=0;
		for(new client=1;client<=MaxClients;client++)
		{
			if(IsValidPlayer(client,true))
			{
				GetClientEyeAngles(client,CachedAngle[client][HistoryCount]);
				GetClientAbsOrigin(client,CachedPos[client][HistoryCount]);
			}
		}
	}
}
