include("gbanlogsconfig.lua")
util.AddNetworkString( "devbanlogscl" )
util.AddNetworkString( "devbanlogssvr" )


hook.Add("PlayerIntitalSpawn","alertadminsonjoincheck",function(ply)
local readlogs = table.KeyFromValue(util.JSONTOTable(file.Read("gbanlogs/banlogs.txt","DATA")), ply:SteamID())
	if alertadminsonjoin and !readlogs == "" and !ply:CheckGroup(glogscheckwhitelist) then
		for k, v in pairs(player.GetAll()) do 
			if v:CheckGroup(groupsthatseetheecho) then
				v:ChatPrint("SERVER: "..ply:Nick().." has been banned before  for ("..readlogs..")")
			end
		end
	end
end)
		
		
		
		
net.Receive( "devbanlogscl", function( ply )
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
			banlogs.target = {}
		else
			banlogs = util.JSONToTable( json )
		end
		if !banlogs.target then
			banlogs.target = {}
		end
		banlogs.target[otime] = {}
		banlogs.target.otime[banlogs] = " [ "..date.." | "..hour.." ] "..nickname.."( "..callid.." ) banned "..target:Nick().."("..target:SteamID()..") for "..bantime.." minute(s) \n Reason: "..reason.." "] = target:SteamID()
		banlogsr = AddECTLogs(banlogs)
		local json2 = util.TableToJSON( banlogsr )
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
			banlogs.target = {}
		else
			banlogs = util.JSONToTable( json )
		end
		if !banlogs.target then
			banlogs.target = {}
		end
		banlogs.target[otime] = {}
		banlogs.target.otime[banlogs] = " [ "..date.." | "..hour.." ] "..nickname.."( "..callid.." ) banned "..target.." for "..time.." minute(s) Reason: "..reason..
		banlogsr = AddECTLogs(banlogs)
		local json2 = util.TableToJSON( banlogsr )
		file.Write( "gbanlogs/banlogs.txt", json2 )		
		print("Ban Added to GBanLogs Ban Archive ;)")
	end

function addsidunbanlog(calling,target)
	local hour = os.date( "%I:%M %p")
	local date = os.date("%m/%d/%Y")
	local otime = os.time()
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
			banlogs.target = {}
		else
			banlogs = util.JSONToTable( json )
		end
		if !banlogs.target then
			banlogs.target = {}
		end
		banlogs.target[otime] = {}
		banlogs.target.otime[banlogs] = " [ "..date.." | "..hour.." ] "..nickname.."( "..id.." ) Unbanned "..target
		banlogs.target
		local json2 = util.TableToJSON( banlogsr )
		
		file.Write( "gbanlogs/banlogs.txt", json2 )	
		print("Unban Added to GBanLogs Ban Archive ;)")		
	end
local function AddECTLogs(number,steamid)
local tbl = {}
	tbl.steamid = {}
	tbl.steamid.number = {}
	tbl.steamid.number.chat = GExtraLogs.chat
	tbl.steamid.number.dmg = GExtraLogs.dmg
	tbl.steamid.number.death = GExtraLogs.death
	local json = util.TableToJSON(tbl)
	file.Write("gbanlogs/etclogs.txt",json)
end
	-- logs
hook.Add("EntityTakeDamage","DMGLOGS4GLOGS",function(target,dmginfo)
	local hour = os.date( "%I:%M %p")
	local date = os.date("%d/%m/%Y")
	if target:IsPlayer() and IsValid(dmginfo:GetAttacker()) and IsValid(target) and dmginfo:GetAttacker():IsPlayer() and !dmginfo:GetDamage() == 0 then
		local targetname = target:Nick()
		local attackername
		local weapon = dmginfo:GetInflictor():GetClass()
		local damage = dmginfo:GetDamage()
		if dmginfo:GetAttacker():IsPlayer() then
			attackername = dmginfo:GetAttacker():Nick()
		else
			attackername = dmginfo:GetAttacker():GetClass()
		end
		if !GExtraLogs then
			GExtraLogs = {}
		end
		if !GExtraLogs.dmg then
			GExtraLogs.dmg = {}
		end
		if GExtraLogs.dmg[os.time()] then
			GExtraLogs.dmg[os.time()+math.Random(0,.9)] = " [ "..date.." | "..hour.." ] "..attackername.."( "..dmginfo:GetAttacker():SteamID().." ) has damaged "..targetname.." for "..damage.." with "..weapon
		else
			GExtraLogs.dmg[os.time()] = " [ "..date.." | "..hour.." ] "..attackername.." has damaged "..targetname.." for "..damage.." with "..weapon
		
		end
	end
end)
hook.Add("PlayerSay","CHTLOGS4GLOGS",function(sender,text)
	local hour = os.date( "%I:%M %p")
	local date = os.date("%d/%m/%Y")
	if !GExtraLogs then
		GExtraLogs = {}
	end
	if !GExtraLogs.dmg then
		GExtraLogs.dmg = {}
	end
	if gdmtbl.chat[os.time()] then
		GExtraLogs.chat[os.time()+math.Random(0,.9)] = " [ "..date.." | "..hour.." ] "..sender:Nick().."( "..sender:SteamID().." ): "..text
	else
		GExtraLogs.chat[os.time()] = " [ "..date.." | "..hour.." ] "..sender:Nick().."( "..sender:SteamID().." ): "..text
	end
end)


hook.Add("PlayerDeath","DTHLOGS4GLOGS",function(victim,inflictor,attacker)
	local hour = os.date( "%I:%M %p")
	local date = os.date("%d/%m/%Y")
	if !GExtraLogs then
		GExtraLogs = {}
	end
	if !GExtraLogs.death then
		GExtraLogs.death = {}
	end
	local vname = victim:Nick()
	local vid = victim:SteamID()
	local iname = attacker:Nick()
	local iid = attacker:SteamID()
	if dmgtbl.death[os.time()] then
	dmgtbl.death[os.time()+math.Random(0,.9)] = " [ "..date.." | "..hour.." ] "..iname.."( "..iid.." ) Killed "..vname"( "..vid.." ) with "..inflictor:GetClass()
	else
		dmgtbl.death[os.time()] = " [ "..date.." | "..hour.." ] "..iname.."( "..iid.." ) Killed "..vname"( "..vid.." ) with "..inflictor:GetClass()
	end
	
	
end)
timer.Create("tabledumpglogs",240,0,function()
	local resettime = os.time() - 240
	for k,v in pairs(GExtraLogs.death) do
		if k < resettime then
			v:Remove()
		end
	end
	for k,v in pairs(GExtraLogs.chat) do
		if k < resetime then
			v:Remove()
		end
	end
	for k,v in pairs(GExtraLogs.dmg) do
		if k < resettime then
			v:Remove()
		end
	end
end)
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
	
	
	
	

