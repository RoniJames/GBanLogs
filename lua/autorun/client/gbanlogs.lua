net.Receive( "devbanlogssvr", function()
	local baninfo = net.ReadTable()
	GBackgroundCheck2(baninfo)
end)
local function sendsettings(tbl) 
	net.Start("devbanlogscl")
	net.WriteTable(tbl)
	net.SendToServer()
end

function GBackgroundCheck2(baninfo)
local settingstbl = {}
local frame = vgui.Create( "DFrame" )
frame.Paint = function( self, w, h ) draw.RoundedBox( 4, 0, 0, w, h, Color( 161, 0, 0,230 ) ) end
frame:SetSize( 900, 400 )
frame:SetTitle("GBanLogs")
frame:Center()
frame:MakePopup()
	local sheet = vgui.Create( "DColumnSheet", frame )
	sheet:Dock( FILL )
--	local settings = vgui.Create( "DPanel", sheet )
--	settings:Dock( FILL )
--	settings.Paint = function( self, w, h ) draw.RoundedBox( 4, 0, 0, w, h, Color( 255, 255, 255 ) ) end
--	sheet:AddSheet( "Settings", settings, "icon16/bullet_red.png" )
--		local cansee = vgui.Create("DCheckBox",settings)
--		cansee:SetPos(25,50)
--		cansee:SetValue(0)
--		local function cansee:onChange(val)
--			settingstbl.shouldecho = val
--		end
--		local canseehint = vgui.Create("DLabel",settings)
--		canseehint:SizeToContent()
--		canseehint:SetText("Check this if you want the server to inform admins of previous offenders")
--		canseehint:SetPos(25,70)
	--	local canseeg = vgui.Create("DTextEntry",settings)
--		canseeg:SetPos(40,50)
--		canseeg:SetSize(70,85)
--		canseeg:SetText("Lowest group that should see the echo (Any groups above this will also see the echo)")
--		local function canseeg:onChange(str)
--			settingstbl.canseeecho = str
--		end
--		local saveb = vgui.Create("DButton",settings)
--		settings:SetSize(25,25)
--		settings:SetText("Save")
--		settings.DoClicked = function()
--			sendsettings(settingstbl)
	for k, v in pairs(baninfo.banlogs) do
	local collectlogs = v.otime - 240
	local txttoprint
	local icon
	local bool = true
	if !v.adminid == "Console" then
		if v.type == "Ban" then
			txttoprint = " Date/Time: "..v.date.." | "..v.hour.."\n "..v.adminname.."( "..v.adminid.." ) banned "..v.targetname.."( "..v.targetid.." ) for "..v.bantime.."\n Reason: "..v.areason
			icon = "icon16/flag_red.png"
		elseif v.type == "Unban" then
			txttoprint = " Date/Time: "..v.date.." | "..v.hour.."\n "..v.adminname.."( "..v.adminid.." ) unbanned "..v.targetid
			icon = "icon16/flag_green.png"
		else
			txttoprint = " Date/Time: "..v.date.." | "..v.hour.."\n "..v.adminname.."( "..v.adminid.." ) banned "..v.targetid.." for "..v.bantime.." \n Reason: "..v.areason
			icon = "icon16/flag_red.png"
		end
	else
		if v.type == "Ban" then
			txttoprint = " Date/Time: "..v.date.." | "..v.hour.."\n "..v.adminname.."  banned "..v.targetname.."( "..v.targetid.." ) for "..v.bantime.."\n Reason: "..v.areason
			icon = "icon16/flag_red.png"
		elseif v.type == "Unban" then
			bool = false
			txttoprint = " Date/Time: "..v.date.." | "..v.hour.."\n "..v.adminname.." unbanned "..v.targetid
			icon = "icon16/flag_green.png"
		else
			txttoprint = " Date/Time: "..v.date.." | "..v.hour.."\n "..v.adminname.." banned "..v.targetid.." for "..v.bantime.." \n Reason: "..v.areason
			icon = "icon16/flag_red.png"
		end
	end
		local panel = vgui.Create( "DPanel", sheet )
		panel:Dock( FILL )
		panel.Paint = function( self, w, h ) draw.RoundedBox( 4, 0, 0, w, h, Color( 0, 0, 225,255 ) ) end
		sheet:AddSheet( v.type, panel, icon )
		local isheet = vgui.Create( "DPropertySheet",panel )
		isheet:Dock( FILL )
		local bpanel = vgui.Create("DPanel", isheet)
		bpanel:Dock(FILL)
		bpanel.Paint = function( self, w, h ) draw.RoundedBox( 4, 0, 0, w, h, Color( 255, 255, 255 ) ) end
		isheet:AddSheet( "BanLogs", bpanel, "icon16/bullet_red.png" )
		local bnlogs = vgui.Create("DLabel", bpanel)
		bnlogs:SetText(txttoprint)
		bnlogs:SetFont( "Trebuchet18" )
		bnlogs:SizeToContents()
		bnlogs:SetDark(1)
		if bool then
		local i2panel = vgui.Create("DPanel", isheet )
		i2panel:Dock( FILL )
		i2panel.Paint = function( self, w, h ) draw.RoundedBox( 4, 0, 0, w, h, Color( 255, 255, 255 ) ) end
		isheet:AddSheet( "Logs", i2panel, "icon16/report.png" )
		local nlist = vgui.Create( "DListView",i2panel )
		nlist:SetMultiSelect( false )
		nlist:Dock( FILL )
		function nlist:DoDoubleClick( line )
			SetClipboardText(logstbl[line])
			chat.AddText(logstbl[line].." copied to clipboard!")
		end
		local star = nlist:AddColumn( "*" )
		star.m_iMaxWidth = 20
		local tim = nlist:AddColumn( "Time" )
		tim.m_iMaxWidth = 60
		local typ = nlist:AddColumn( "Type" )
		typ.m_iMaxWidth = 50
		nlist:AddColumn( "Log" )
		local counter = 0
		local logstbl = {}
		for t,e in pairs(baninfo.etc) do
		local ShouldStar
		local TextToPrint
		local arole
		local trole
		local red
		local blue
		local nline
		table.SortByMember( e, "otime" )
		e.otime = e.otime or 0
			if v.otime >= e.otime and e.otime >= collectlogs then
				if e.targetrole == ROLE_TRAITOR then
					trole = "T"
				elseif e.targetrole == ROLE_INNOCENT then
					trole = "I"
				elseif e.targetrole == ROLE_DETECTIVE then
					trole = "D"
				else
					trole = "Spec/Prep"
				end
				if e.attackerrole == ROLE_TRAITOR then
					arole = "T"
				elseif e.attackerrole == ROLE_INNOCENT then
					arole = "I"
				elseif e.attackerrole == ROLE_DETECTIVE then
					arole = "D"
				else
					arole = "Spec/Prep"
				end
				if e.targetid == v.targetid then
					ShouldStar = "*"
					blue = true
				else
					ShouldStar = " "
				end
				if e.type == "Damage" then
					TextToPrint = "["..trole.."]"..e.aname.."( "..e.targetid.." ) has damaged ["..arole.."]"..e.victimname.."( "..e.victimid.." ) for "..e.dmg.." with "..e.weapon
					if trole == arole then
						ShouldStar = "*"
						red = true
					end
					if trole == "D" and arole == "I" then
						ShouldStar = "*"
						red = true
					elseif trole == "I" and arole == "D" then
						ShouldStar = "*"
						red = true
					end
				elseif e.type == "Death" then
					TextToPrint = "["..trole.."]"..e.attackername.."( "..e.targetid.." ) has killed ["..arole.."]"..e.victimname.."( "..e.victimid.." ) with "..e.weapon
					if trole == arole then
						ShouldStar = "*"
						red = true
					end
					if trole == "D" and arole == "I" then
						ShouldStar = "*"
						red = true
					elseif trole == "I" and arole == "D" then
						ShouldStar = "*"
						red = true
					end
				elseif e.type == "Chat" then
					TextToPrint = e.sendername.."( "..e.targetid.." ): "..e.message
				end
				nlist:AddLine(ShouldStar,e.hour,e.type,TextToPrint)	
				counter = counter+1
				logstbl[counter] = TextToPrint
				if red and blue then
					nline = nlist:GetLine(counter)
					function nline:Paint( w, h )
						draw.RoundedBox( 0, 0, 0, w, h, Color( 169, 23, 209, 200 ) )
					end
				elseif red then
					nline = nlist:GetLine(counter)
					function nline:Paint(w,h)
						draw.RoundedBox( 0, 0, 0, w, h, Color( 200, 0, 0, 200 ))
					end
				elseif blue then
					nline = nlist:GetLine(counter)
					function nline:Paint(w,h)
						draw.RoundedBox( 0, 0, 0, w, h, Color( 0, 0, 200, 200 ))
					end
				end
			end
		end
	end
end
end

function GMessage(msg,type,seconds)
	seconds = seconds or 5
	local hint = vgui.Create("DNotify")
	hint:SetPos(875,400)
	hint:SetSize(400,200)
	hint:SetLife(5)
	local font
	if type then
		if type == "large" then
			font = "DermaLarge"
		elseif type == "chat" then
			font = "ChatFont"
		elseif type == "hud" then
			font = "HudHintTextLarge"
		end
	else
		font = "ChatFont"
	end
	local text = vgui.Create("DLabel",hint)
	text:Dock(FILL)
	text:SetWrap( true )
	text:SetText( msg )
	text:SetFont(font)
	text:SetTextColor( Color( 255, 0, 0, 240 ) )
	hint:AddItem(text)
end

function GReportFrame()
	local frame = vgui.Create("DFrame")
	frame:Center()
	frame:SetSize(900,400)
	frame:SetTitle("Report a player")
	frame:MakePopup()
	--
	local counter = vgui.Create("DLabel",frame)
	counter:SetText("100")
	counter:SetPos(100,200)
	--
	local insert = vgui.Create("DTextEntry",frame)
	insert:SetText("Insert Report Details")
	insert:SetPos(50,50)
	insert.OnChange = function() 
		local txt = insert:GetText()
		counter:SetText(tostring(100-#txt))
	end
	--
	local send = vgui.Create("DButton",frame)
	send:SetPos(200,100)
	send:SetText("Report!")
	send.OnClick = function()
		if #insert:GetText() > 100 then 
			GMessage("[GReport]: You have more characters than the max amount","hud")
		elseif #insert:GetText() < 10 then
			GMessage("[GReport]: Describe the incident in more detail","hud")
		else
			net.Start()
			net.WriteString(insert:GetText())
			net.SendToServer()
		end
	end
end
