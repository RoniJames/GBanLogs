net.Receive( "devbanlogssvr", function()
	local banlinfo = net.ReadTable()
	local steamids = net.ReadString()
	GBackgroundCheck2(banlinfo,steamids)
end)
local function sendsettings(tbl) 
	net.Start("devbanlogscl")
	net.WriteTable(tbl)
	net.SendToServer()
end

function GBackgroundCheck2(baninfo,steamid)
local tbltoprint = table.KeysFromValue(baninfo.banlogs,steamid)
local settingstbl = baninfo or {}
local frame = vgui.Create( "DFrame" )
frame:SetSize( 900, 400 )
frame:SetTitle("GBanLogs")
frame:Center()
frame:MakePopup()
	local sheet = vgui.Create( "DColumnSheet", frame )
	sheet:Dock( FILL )
	shouldsettings = false
	if table.HasValue(baninfo.cansettings,LocalPlayer():GetUserGroup()) then
	shouldsettings = true
	elseif !baninfo.cansettings and LocalPlayer():IsSuperAdmin() then
	shouldsettings = true
	end
	if shouldsettings then
	local settings = vgui.Create( "DPanel", sheet )
	settings:Dock( FILL )
	settings.Paint = function( self, w, h ) draw.RoundedBox( 4, 0, 0, w, h, Color( 162, 87, 222 ) ) end
	sheet:AddSheet( "Settings", settings, "icon16/bullet_red.png" )
		local cansee = vgui.Create("DCheckBox",settings)
		cansee:SetPos(25,50)
		cansee:SetValue(0)
	function cansee:onChange(val)
	settingstbl.shouldecho = val
	end
		local canseehint = vgui.Create("DLabel",settings)
		canseehint:SetSize(400,25)
		canseehint:SetText(" - Check this if you want the server to inform admins of previous offenders")
		canseehint:SetPos(25,26)
		canseehint:SetDark( 1 )
		local canseeghint = vgui.Create("DLabel",settings)
		canseeghint:SetSize(400,25)
		canseeghint:SetText(" - Lowest group that should see the echo (Any groups above this will gain access as well)")
		canseeghint:SetPos(25,75)
		canseeghint:SetDark( 1 )
		local canseeg = vgui.Create("DTextEntry",settings)
		canseeg:SetPos(25,100)
		canseeg:SetSize(200,17)
		function canseeg:onChange(str) 
		settingstbl.canseeecho = str
		end
		local saveb = vgui.Create("DButton",settings)
		saveb:SetPos(335,250)
		saveb:SetSize(50,25)
		saveb:SetText("Save")
		function saveb:DoClicked()
		sendsettings(settingstbl)
		end
	end
	for k, v in pairs(tbltoprint)do 
	local panel = vgui.Create( "DPanel", sheet )
	panel:Dock( FILL )
	panel.Paint = function( self, w, h ) draw.RoundedBox( 4, 0, 0, w, h, Color( 255, 255, 255 ) ) end
	sheet:AddSheet( "Incident "..k, panel, "icon16/bullet_red.png" )
		local label = vgui.Create( "DLabel", panel )
		label:SetText( v )
		label:SetDark( 1 )
		label:SetFont( "Trebuchet18" )
		label:SizeToContents()
	end
end
