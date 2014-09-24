// AntiHack_000_OnClientConnected.sp

public OnClientConnected(client)
{
	if(!IsFakeClient(client))
	{
		TrackNameChanges[client]=0;
		TrackNameChangesTriggered[client]=false;
	}
}

