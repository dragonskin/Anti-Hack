// AntiHack_000_OnClientDisconnect.sp

public OnClientDisconnect(client)
{
	AH_Database_OnClientDisconnect(client);
	SpinHack_Detection_OnClientDisconnect(client);
}

