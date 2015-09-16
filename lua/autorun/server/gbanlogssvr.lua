include("GBanLogsConfig.lua")

util.AddNetworkString("GReportConfirm")
util.AddNetworkString( "devbanlogscl" )
util.AddNetworkString( "devbanlogssvr" )
util.AddNetworkString( "GReportAPlayerNet" )
hook.Add("PlayerIntitalSpawn","alertadminsonjoincheck",function(ply)
GBSetings.ReportMax[ply:SteamID()] = 0
local readlogs = util.JSONToTable(file.Read("gbanlogs/blogs.txt","DATA"))
if !GBSettings.ShouldUseSpecificGroups then
	if GBSettings.EchoEnabled and !readlogs == "" and !ply:CheckGroup(GBSettings.ShouldShow) and readlogs[ply:SteamID()] then
		for k, v in pairs(player.GetAll()) do 
			if v:CheckGroup(GBSettings.CanSee) then
				v:ChatPrint("SERVER: "..ply:Nick().." has been banned before type !review to see why")
				GBSettings.LastBanned = ply:SteamID()
			end
		end
	end
else
	if GBSettings.EchoEnabled and !readlogs == "" and !table.HasValue(GBSettings.SpecificShouldNotShow,ply:GetUserGroup()) and readlogs[ply:SteamID()] then
		for k, v in pairs(player.GetAll()) do 
			if table.HasValue(GBSettings.SpecificCanSee,v:GetUserGroup()) then
				v:ChatPrint("[GBanLogs]: "..ply:Nick().." has been banned before type !review to see why")
				GBSettings.LastBanned = ply:SteamID()
			end
		end
	end
end
end
)
		
	
	
	
net.Receive( "GReportAPlayerNet", function( ply )
	if GBSettings.ReportMax < 3 then
		local txt = net.ReadString()
		ReportAPlayer(ply,txt)
	end
end)

local function ReportAPlayer(call,msg,rep_ply)
local tbl
	if !file.IsDir("greports","DATA") then
		file.CreateDir("greports")
	end
	local json = file.Read("greports/records.txt")
	if !json then
		tbl = {}
	else
		tbl = util.JSONToTable(json)
	end
	local tnum = #tbl + 1
	tbl[tnum] = {msg = msg, sid = rep_ply:SteamID()}
	AddECTLogs(tnum)
	net.Start("GReportConfirm")
	net.WriteString(tostring(tnum))
	net.Send(call)
end

local function devbanlogsfunc(ply)
	local baninfo = util.JSONToTable(file.Read("gbanlogs/blogs.txt"))
	net.Start("devbanlogssvr")
	net.WriteTable(baninfo)
	net.Send(ply)
end
local function AddECTLogs(steamid)
local json2 = file.Read("gbanlogs/etclogs/"..steamid..".txt","DATA")
local tbl
	if !json2 then
		tbl = {}
	else
		tbl = util.JSONToTable(json2)
	end
	tbl[steamid] = GExtraLogs or {}
	local json = util.TableToJSON(tbl)
	file.Write("gbanlogs/etclogs/"..steamid..".txt",json)
end
function addbanlog(calling,bantime,target,reason)
	local hour = os.date( "%I:%M %p")
	local date = os.date("%m/%d/%Y")
	local targetid = target:SteamID()
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
	local json = file.Read("gbanlogs/bans/"..targetid..".txt","DATA")
	local banlogs
		if !json then
			banlogs = {}
			banlogs[targetid] = {}
		else
			banlogs = util.JSONToTable(json)
		end
		if !banlogs then
			banlogs = {}
		end
		banlogs[targetid] = banlogs[targetid] or {}
		local newentry = {adminname = nickname,adminid = callid, targetname = target:Nick(),targetid = targetid,areason = reason,date = date,hour = hour,bantime = bantime,otime = os.time(),type = "Ban" }
		banlogs[target][#banlogs[targetsid] + 1] = newentry
		local json2 = util.TableToJSON( banlogs )
		file.Write( "gbanlogs/bans/"..targetid..".txt", json2 )	
		AddECTLogs(target:SteamID())		
		print("Ban Added to GBanLogs Ban Archive ;)")
end

function addsidbanlog(calling,time,target,reason)
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
	if reason == "" then
		reason = "Reason Unspecified"
	end
local json = file.Read("gbanlogs/bans/"..target..".txt","DATA")
local banlogs
		if !json then
			banlogs = {}
			banlogs[target] = {}
		else
			banlogs = util.JSONToTable(json)
		end
		if !banlogs then
			banlogs = {}
		end
		banlogs[target] = banlogs[target] or {}
		local newentry = {adminname = nickname,adminid = callid, targetid = target,areason = reason,bantime = time,date = date,hour = hour,otime = os.time(),type = "IDBan" }
		banlogs[target][#banlogs[target] + 1] = newentry
		PrintTable(banlogs)
		local json2 = util.TableToJSON( banlogs )
		file.Write( "gbanlogs/bans/"..target..".txt", json2 )		
		AddECTLogs(target)
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
local json = file.Read("gbanlogs/bans/"..target..".txt","DATA")
local banlogs
		if !json then
			banlogs = {}
			banlogs[target] = {}
		else
			banlogs = util.JSONToTable(json)
		end
		if !banlogs then
			banlogs = {}
		end
		banlogs[target] = banlogs[target] or {}
		local newentry = {adminname = nickname,adminid = callid, targetid = target,date = date,hour = hour,otime = os.time(),type = "Unban" }
		banlogs[target][#banlogs[target] + 1] = newentry
		local json2 = util.TableToJSON( banlogs )
--		AddECTLogs(target)
		file.Write( "gbanlogs/bans/"..target..".txt", json2 )	
		print("Unban Added to GBanLogs Ban Archive ;)")		
	end

	-- LogHooks
hook.Add("EntityTakeDamage","DMGLOGS4GLOGS",function(target,dmginfo)
	local hour = os.date( "%I:%M %p")
	if IsValid(target) and IsValid(dmginfo:GetAttacker()) and target:IsPlayer() and dmginfo:GetDamage() > 0 and GetRoundState() == ROUND_ACTIVE then
		local targetname = target:Nick()
		local attackername
		local weapon = dmginfo:GetInflictor():GetClass()
		local damage = dmginfo:GetDamage()
		local vid = target:SteamID()
		local arole 
		local trole = target:GetRole()
		local aid
		if dmginfo:GetAttacker():IsPlayer() then
			arole = dmginfo:GetAttacker():GetRole()
			aid = dmginfo:GetAttacker():SteamID()
			attackername = dmginfo:GetAttacker():Nick()
		else
			arole = "W"
			attackername = dmginfo:GetAttacker():GetClass()
			aid = "None Player"
		end

		GExtraLogs = GExtraLogs or {}
		local newentry = {aname = attackername,targetrole = trole,attackerrole = arole,targetid = aid,victimid = vid , victimname = target:Nick(),dmg = dmginfo:GetDamage(),weapon = weapon, otime = os.time(),hour = hour, type = "Damage"}
		GExtraLogs[#GExtraLogs + 1] = newentry
		
	end
end)
hook.Add("PlayerSay","CHTLOGS4GLOGS",function(sender,text)
	local hour = os.date( "%I:%M %p")
	local otime = os.time()
	local sendern
	local senderi
	if IsValid(sender) then
		sendern = sender:Nick()
		senderi = sender:SteamID()
	else
		sendern = "Console"
		senderi = "Console"
	end
	GExtraLogs = GExtraLogs or {}
	local newentry = {sendername = sendern,targetid = senderi,message = text, otime = otime,hour = hour, type = "Chat"}
	GExtraLogs[#GExtraLogs + 1] = newentry

	--	print("Chat Added") previously used for debugging
end)


hook.Add("PlayerDeath","DTHLOGS4GLOGS",function(victim,inflictor,attacker)
if GetRoundState() == ROUND_ACTIVE then
	local hour = os.date( "%I:%M %p")
	local newentry
	if !GExtraLogs then
		GExtraLogs = {}
	end
	if !GExtraLogs.death then
		GExtraLogs.death = {}
	end
	local vname = victim:Nick()
	local vid = victim:SteamID()
	local arole
	local trole = victim:GetRole()
	local iname
	local iid
	if IsValid(attacker) and attacker:IsPlayer() then
		arole = attacker:GetRole()
		iname = attacker:Nick()
		iid = attacker:SteamID()
	else
		arole = "W"
		iid = "World/Unknown"
		iname = "World/Unknown"
	end
	newentry = {attackername = iname,targetrole = trole,attackerrole = arole,targetid = iid,victimid = vid , victimname = vname,weapon = inflictor:GetClass(), otime = os.time(),hour = hour, date = date, type = "Death"}
	GExtraLogs[#GExtraLogs + 1] = newentry

--	print("Death Added") previously used for debugging
	
	
end
end)
timer.Create("tabledumpglogs",240,0,function()
if GExtraLogs then
	local resettime = os.time() - 240
	for k,v in pairs(GExtraLogs) do
	v.otime = v.otime or 0
		if v.otime < resettime then
			table.remove( v )
		end
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
	
	
	
	

