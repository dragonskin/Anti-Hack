// AntiHack_000_OnClientDisconnect.sp

public OnClientDisconnect(client)
{
	if(!IsFakeClient(client))
	{
		TrackNameChanges[client]=0;
		TrackNameChangesTriggered[client]=false;
	}
	AH_Database_OnClientDisconnect(client);
	SpinHack_Detection_OnClientDisconnect(client);
}

