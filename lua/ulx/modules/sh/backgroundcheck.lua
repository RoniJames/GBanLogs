function ulx.backgroundcheck(calling_ply,steamid)
	local banlogs  
	if file.Read("gbanlogs/banlogs.txt","DATA") then
		banlogs = {}
	else
		banlogs = util.JSONToTable(file.Read("gbanlogs/banlogs.txt","DATA"))
	end
	local etc = file.Read("gbanlogs/etclogs.txt","DATA")
	banlogs.etc = etc.steamid
	net.Start("devbanlogssvr")
	net.WriteTable(banlogs)
	net.WriteString(steamid)
	net.Send(calling_ply)
	
end
local backgroundcheck = ulx.command("Utility","ulx idcheck",ulx.backgroundcheck,"!check")
backgroundcheck:addParam{ type=ULib.cmds.StringArg, hint="steamid" } 
backgroundcheck:defaultAccess( ULib.ACCESS_ADMIN )
