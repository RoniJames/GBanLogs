function GSendMessage(msg)
	local hint = vgui.Create("DNotify")
	hint:SetPos(ScrW()+50,ScrH()+100)
	hint:SetSize(300)
	--
	local frame = vgui.Create("DFrame",hint)
	frame:Dock(FILL)
	--
	local text = vgui.Create("DLabel",frame)
	text:SetText(msg)
	--
end

function GReportFrame(tbl)
	local frame = vgui.Create("DFrame")
	frame:Center()
	frame:SetTitle("Report a player")
	--
	local counter = vgui.Create("DLabel",frame)
	counter:SetText("100")
	counter:SetPos(100,200)
	--
	local insert = vgui.Create("DTextEntry")
	insert:SetText("Insert Report Details")
	insert:SetPos(50,50)
	insert.OnChange = function() 
		local txt = insert:GetText()
		counter:SetText(#txt-
