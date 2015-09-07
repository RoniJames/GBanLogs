include("gbanlogsconfig.lua")
util.AddNetworkString( "devbanlogscl" )
util.AddNetworkString( "devbanlogssvr" )


hook.Add("PlayerIntitalSpawn","alertadminsonjoincheck",function(ply)
local readlogs = table.KeyFromValue(util.JSONTOTable(file.Read("gbanlogs/banlogs.txt","DATA").banlogs), ply:SteamID())
	if alertadminsonjoin and readlogs and !ply:CheckGroup(glogscheckwhitelist) then
		for k, v in pairs(player.GetAll()) do 
			if v:CheckGroup(groupsthatseetheecho) then
				v:ChatPrint("SERVER: "..ply:Nick().." has been banned before  for ("..readlogs..")")
			end
		end
	end
end)
		
		
		
		
net.Receive( "devbanlogscl", function( ply )
local tbl = util.JSONToTable(file.Read("gbanlogs/banlogs.txt","DATA"))
if table.HasValue(tbl.cansettings,ply:GetUserGroup()) then
	shouldwrite = true
elseif !tbl.cansettings and ply:IsSuperAdmin() then
	shouldwrite = true
	end
	if shouldwrite then
	local settings = net.ReadTable()
	if !file.IsDir("gbanlogs","DATA") then
		file.CreateDir("gbanlogs")
	end
	tbl.color = settings.color or 255,255,255
	tbl.canseeecho = settings.canseeecho or "superadmin"
	tbl.shouldecho = settings.shouldecho or true
	tbl.cansettings = settings.cansettings
	file.Write("gbanlogs/banlogs.txt",tbl)
	else 
		ply:ChatPrint("You do not have access to this command")
	end
end)
	-- all the required functions
function devbanlogsfunc(ply)
	local baninfo = util.JSONToTable(file.Read("gbanlogs/banlogs.txt"))
	net.Start("devbanlogssvr")
	net.WriteTable(baninfo)
	net.Send(ply)
end

function addbanlog(calling,bantime,target,reason)
	local hour = os.date( "%I:%M %p")
	local date = os.date("%m/%d/%Y")
	if !file.IsDir("gbanlogs","DATA") then
		file.CreateDir("gbanlogs")
	end
		if !reason then
		reason = "Reason Unspecified"
	end
	local nickname = "(Console)"
	if IsValid(calling) then
		nickname = calling:Nick()
	end
	local callid = "Console"
	if IsValid(calling) then
		callid = calling:SteamID()
	end
		local json = file.Read("gbanlogs/banlogs.txt", "DATA")
		local banlogs
		if !json then
			banlogs = {}
			banlogs.banlogs = {}
		else
			banlogs = util.JSONToTable( json )
		end
		if !banlogs.banlogs then
			banlogs.banlogs = {}
		end
		banlogs.banlogs[" [ "..date.." | "..hour.." ] "..nickname.."( "..callid.." ) banned "..target:Nick().."("..target:SteamID()..") for "..bantime.." minute(s) \n Reason: "..reason.." "] = target:SteamID()
		local json2 = util.TableToJSON( banlogs )
		file.Write( "gbanlogs/banlogs.txt", json2 )		
		print("Ban Added to GBanLogs Ban Archive ;)")
	end

function addsidbanlog(calling,time,target,reason)
	local hour = os.date( "%I:%M %p")
	local date = os.date("%d/%m/%Y")
	if !file.IsDir("gbanlogs","DATA") then
		file.CreateDir("gbanlogs")
	end
	local nickname = "(Console)"
	if IsValid(calling) then
		nickname = calling:Nick()
	end
	local callid = "Console"
	if IsValid(calling) then
		callid = calling:SteamID()
	end
	if reason == "" then
		reason = "Reason Unspecified"
	end
		local json = file.Read("gbanlogs/banlogs.txt", "DATA")
		local banlogs
		if !json then
			banlogs = {}
			banlogs.banlogs = {}
		else
			banlogs = util.JSONToTable( json )
		end
		if !banlogs.banlogs then
			banlogs.banlogs = {}
		end
		banlogs.banlogs[" [ "..date.." | "..hour.." ] "..nickname.."( "..callid.." ) banned "..target.." for "..time.." minute(s)\n Reason: "..reason.." "] = target
	local json2 = util.TableToJSON( banlogs )
		
		file.Write( "gbanlogs/banlogs.txt", json2 )		
		print("Ban Added to GBanLogs Ban Archive ;)")
	end

function addsidunbanlog(calling,target)
	local hour = os.date( "%I:%M %p")
	local date = os.date("%m/%d/%Y")
	if !file.IsDir("gbanlogs","DATA") then
		file.CreateDir("gbanlogs")
	end
	local nickname = "(Console)"
	if IsValid(calling) then
		nickname = calling:Nick()
	end
	local callid = "Console"
	if IsValid(calling) then
		callid = calling:SteamID()
	end

		local json = file.Read("gbanlogs/banlogs.txt", "DATA")
		local banlogs
		if !json then
			banlogs = {}
			banlogs.banlogs = {}
		else
			banlogs = util.JSONToTable( json )
		end
		if !banlogs.banlogs then
			banlogs.banlogs = {}
		end
		
		banlogs.banlogs[" [ "..date..":"..hour.." ] "..nickname.."( "..callid.." ) Unbanned "..target] = target

		local json2 = util.TableToJSON( banlogs )
		
		file.Write( "gbanlogs/banlogs.txt", json2 )	
		print("Unban Added to GBanLogs Ban Archive ;)")		
	end
	
function ULib.kickban( ply, time, reason, admin )
	if not time or type( time ) ~= "number" then
		time = 0
	end
	ULib.addBan( ply:SteamID(), time, reason, ply:Name(), admin, true )
	addbanlog(admin,time,ply,reason)
	-- Load our currently banned users so we don't overwrite them
	if ULib.fileExists( "cfg/banned_user.cfg" ) then
		ULib.execFile( "cfg/banned_user.cfg" )
	end
end

function ULib.unban( steamid, admin )

	--Default banlist
	if ULib.fileExists( "cfg/banned_user.cfg" ) then
		ULib.execFile( "cfg/banned_user.cfg" )
	end
	ULib.queueFunctionCall( game.ConsoleCommand, "removeid " .. steamid .. ";writeid\n" ) -- Execute after done loading bans
	--ULib banlist
	ULib.bans[ steamid ] = nil
	ULib.fileWrite( ULib.BANS_FILE, ULib.makeKeyValues( ULib.bans ) )
	addsidunbanlog(admin,steamid)
end
	
	
function ULib.addBan( steamid, time, reason, name, admin, alreadybanned )
	local strTime = time ~= 0 and string.format( "for %s minute(s)", time ) or "permanently"
	local showReason = string.format( "Banned %s: %s", strTime, reason )

	local players = player.GetAll()
	for i=1, #players do
		if players[ i ]:SteamID() == steamid then
			ULib.kick( players[ i ], showReason, admin )
		end
	end

	-- Remove all semicolons from the reason to prevent command injection
	showReason = string.gsub(showReason, ";", "")

	-- This redundant kick code is to ensure they're kicked -- even if they're joining
	game.ConsoleCommand( string.format( "kickid %s %s\n", steamid, showReason or "" ) )
	game.ConsoleCommand( string.format( "banid %f %s kick\n", time, steamid ) )
	game.ConsoleCommand( "writeid\n" )

	local admin_name
	if admin then
		admin_name = "(Console)"
		if admin:IsValid() then
			admin_name = string.format( "%s(%s)", admin:Name(), admin:SteamID() )
		end
	end

	local t = {}
	if ULib.bans[ steamid ] then
		t = ULib.bans[ steamid ]
		t.modified_admin = admin_name
		t.modified_time = os.time()
	else
		t.admin = admin_name
	end
	t.time = t.time or os.time()
	if time > 0 then
		t.unban = ( ( time * 60 ) + os.time() )
	else
		t.unban = 0
	end
	if reason then
		t.reason = reason
	end
	if name then
		t.name = name
	end
	ULib.bans[ steamid ] = t
	ULib.fileWrite( ULib.BANS_FILE, ULib.makeKeyValues( ULib.bans ) )
	if !alreadybanned then
	addsidbanlog(admin,time,steamid,reason)
	end
end
	
	
