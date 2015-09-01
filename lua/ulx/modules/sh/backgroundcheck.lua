function ulx.backgroundcheck(calling_ply,steamid)
	local banlogs  
	if file.Read("gbanlogs/banlogs.txt","DATA") == "" or nil then
		banlogs = {}
	else
		banlogs = util.JSONToTable(file.Read("gbanlogs/banlogs.txt","DATA"))
	net.Start("devbanlogssvr")
	net.WriteTable(banlogs)
	net.WriteString(steamid)
	net.Send(calling_ply)
	end
end
local backgroundcheck = ulx.command("Utility","ulx idcheck",ulx.backgroundcheck,"!check")
backgroundcheck:addParam{ type=ULib.cmds.StringArg, hint="steamid" } 
backgroundcheck:defaultAccess( ULib.ACCESS_ADMIN )
