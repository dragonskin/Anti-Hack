// AntiHack_000_OnClientAuthorized.sp

public OnClientAuthorized(client, const String:auth[])
{
	OnAHDatabasePlayerAuthed(client, auth);
}
