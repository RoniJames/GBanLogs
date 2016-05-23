util.AddNetworkString("RequestServerBroadcast")
net.Receive("RequestServerBroadcast",function(len,ply)
	local tbl = net.ReadTable()
	if ply.NextSongBroadcast > os.time() then
		ply:ChatPrint("You wait 5 minutes in between song broadcasts")
	else
		BroadcastVoteEvent = true
		for k,v in pairs(player.GetAll()) do 
			if !v.NoMusic then
				v:SendLua("GMusicFrame("..tbl.SName..")")
			end
		end
	end
end)
