nclude("gokubanlogsconfig.lua")
util.AddNetworkString( "devbanlogscl" )
util.AddNetworkString( "devbanlogssvr" )




hook.Add("PlayerIntitalSpawn","alertadminsonjoincheck",function(ply)
local readlogs = table.KeyFromValue(util.JSONTOTable(file.Read("goku/banlogs.txt","DATA")), ply:SteamID())
	if alertadminsonjoin == true and !readlogs == nil and !ply:CheckGroup(glogscheckwhitelist)  then
		for k, v in pairs(player.GetAll()) do 
			if v:CheckGroup(groupsthatseetheecho) then
				v:ChatPrint("SERVER: "..ply:Nick().." has been banned before "  for ("..readlogs..")")
			end
		end
	end
end)
		
		
		
		
net.Receive( "devbanlogscl", function( ply )
	if ply:IsAdmin() then
--		devbanlogsfunc(ply)
	else
		ply:ChatPrint("You do not have access to the ban logs")
	end
end)
	
function devbanlogsfunc(ply)
	local baninfo = util.JSONToTable(file.Read("goku/banlogs.txt"))
	net.Start("devbanlogssvr")
	net.WriteTable(baninfo)
	net.Send(ply)
end

function addbanlog(calling,bantime,target,reason)
	if !file.IsDir("goku","DATA") then
		file.CreateDir("goku")
		return
	end
		if reason = nil then
		reason = "Reason Unspecified"
		return
	end
local json = file.Read("goku/banlogs.txt", "DATA")
		local banlogs = util.JSONToTable( json ) or {}

		banlogs[calling:Nick().."("..calling:SteamID()..") banned "..target:Nick().."("..target:SteamID()..") for "..bantime.."("..reason..")"] = target:SteamID()
		local json = util.TableToJSON( banlogs )
		file.Write( "goku/banlogs.txt", json )		
		print("Ban Added to Goku's Ban Archive ;)")
	end

function addsidbanlog(calling,time,target,reason)
	if !file.IsDir("goku","DATA") then
		file.CreateDir("goku")
		return 
	end
	if reason = nil then
		reason = "Reason Unspecified"
		return
	end
local json = file.Read("goku/banlogs.txt", "DATA")

		local banlogs = util.JSONToTable( json ) or {}

		banlogs[calling:Nick().."("..calling:SteamID()..") banned "..target.." for "..time.."("..reason..")"] = target
	local json = util.TableToJSON( banlogs )
		
		file.Write( "goku/banlogs.txt", json )		
		print("Ban Added to Goku's Ban Archive ;)")
	end

function addsidunbanlog(calling,target)
	if !file.IsDir("goku","DATA") then
		file.CreateDir("goku")
		return 
	end
		local json = file.Read("goku/banlogs.txt", "DATA")
		local banlogs = util.JSONToTable( json ) or {}

		banlogs[calling:Nick().."("..calling:SteamID()..") Unbanned "..target] = target

		local json = util.TableToJSON( banlogs )
		
		file.Write( "goku/banlogs.txt", json )	
		print("Unban Added to Goku's Ban Archive ;)")		
	end
