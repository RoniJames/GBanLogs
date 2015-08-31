net.Receive( "devbanlogssvr", function()
	local banlinfo = net.ReadTable()
	local steamids = net.ReadString()
	GBackgroundCheck2(banlinfo,steamids)
end)
local function settings() 
	net.Start("devbanlogscl")
	net.SendToServer()
end

function GBackgroundCheck2(baninfo,steamid)
local tbltoprint = table.KeysFromValue(baninfo.banlogs,steamid)
local settingstbl = baninfo.settings
local frame = vgui.Create( "DFrame" )
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
