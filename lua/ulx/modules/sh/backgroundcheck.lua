function ulx.backgroundcheck(calling_ply,steamid)
	local banlogs = util.JSONToTable(file.Read("goku/banlogs.txt","DATA"))
	net.Start("devbanlogssvr")
	net.WriteTable(banlogs)
	net.WriteString(steamid)
	net.Send(calling_ply)
end
local backgroundcheck = ulx.command("Utility","ulx idcheck",ulx.backgroundcheck,"!check")
backgroundcheck:addParam{ type=ULib.cmds.StringArg, hint="steamid" } 
backgroundcheck:defaultAccess( ULib.ACCESS_ADMIN )