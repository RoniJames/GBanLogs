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
local settingstbl = {}
local frame = vgui.Create( "DFrame" )
frame:SetSize( 900, 400 )
frame:SetTitle("GBanLogs")
frame:Center()
frame:MakePopup()
	local sheet = vgui.Create( "DColumnSheet", frame )
	sheet:Dock( FILL )
	local settings = vgui.Create( "DPanel", sheet )
	settings:Dock( FILL )
	settings.Paint = function( self, w, h ) draw.RoundedBox( 4, 0, 0, w, h, Color( 255, 255, 255 ) ) end
	sheet:AddSheet( "Settings", settings, "icon16/bullet_red.png" )
		local cansee = vgui.Create("DCheckBox",settings)
		cansee:SetPos(25,50)
		cansee:SetValue(0)
		local function cansee:onChange(val)
			settingstbl.shouldecho = val
		end
		local canseehint = vgui.Create("DLabel",settings)
		canseehint:SizeToContent()
		canseehint:SetText("Check this if you want the server to inform admins of previous offenders")
		canseehint:SetPos(25,70)
		local canseeg = vgui.Create("DTextEntry",settings)
		canseeg:SetPos(40,50)
		canseeg:SetSize(70,85)
		canseeg:SetText("Lowest group that should see the echo (Any groups above this will also see the echo)")
		local function canseeg:onChange(str)
			settingstbl.canseeecho = str
		end
		local saveb = vgui.Create("DButton",settings)
		settings:SetSize(25,25)
		settings:SetText("Save")
		settings.DoClicked = function()
			sendsettings(settingstbl)
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
