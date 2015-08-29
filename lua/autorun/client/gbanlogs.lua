net.Receive( "devbanlogssvr", function()
	local banlinfo = net.ReadTable()
	local steamids = net.ReadString()
	GBackgroundCheck(banlinfo,steamids)
end)
--concommand.Add("banlogs", function() 
--	net.Start("devbanlogscl")
--	net.SendToServer()
--end)

	function GBackgroundCheck(baninfo,steamid)
	local tbltoprint = table.KeysFromValue(baninfo,steamid)
	local tableintxt = table.ToString(tbltoprint,"Previous Offences",true)
	local Frame = vgui.Create( "DFrame" )
	Frame:SetPos( 5, 40 )
	Frame:SetSize( 600, 600 )
	Frame:SetTitle( "Previous Offences" )
	Frame:SetVisible( true )
	Frame:SetDraggable( true )
	Frame:ShowCloseButton( true )
	Frame:MakePopup()
	Frame.Paint = function( self, w, h ) -- 'function Frame:Paint( w, h )' works too
	draw.RoundedBox( 0, 0, 0, w, h, Color( 51, 87, 213, 240 ) ) -- Draw a red box instead of the frame
end
		local DLabel = vgui.Create( "DLabel", Frame )
		DLabel:SetText( tableintxt )
		DLabel:SetPos( 5,20 )
		DLabel:SetDark( 1 )
		DLabel:SetFont( "Trebuchet18" )
		DLabel:SizeToContents()
end
	
