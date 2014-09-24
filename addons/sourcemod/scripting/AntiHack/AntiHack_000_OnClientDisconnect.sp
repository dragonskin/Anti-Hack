// AntiHack_000_OnClientDisconnect.sp

public OnClientDisconnect(client)
{
	if(!IsFakeClient(client))
	{
		TrackNameChanges[client]=0;
		TrackNameChangesTriggered[client]=false;
	}
}

