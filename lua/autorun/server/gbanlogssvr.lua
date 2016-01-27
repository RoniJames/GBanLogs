hook.Add("KeyPress","InvertKeys",function(ply,key)
	if ply.InvertedKeys then
	ply.KeyNUMs = ply.KeyNUMs or 0
		if key == IN_FORWARD then
			ply:ConCommand("-forward")
			ply:ConCommand("+back")
			ply.KeyNUMs = ply.KeyNUMs + 1
		elseif key == IN_BACK then
			ply:ConCommand("-forward")
			ply:ConCommand("+back")
			ply.KeyNUMs = ply.KeyNUMs + 1
		elseif key == IN_LEFT then
			ply:ConCommand("-left")
			ply:ConCommand("+right")
			ply.KeyNUMs = ply.KeyNUMs + 1	
		elseif key == IN_RIGHT then
			ply:ConCommand("-right")
			ply:ConCommand("+left")
			ply.KeyNUMs = ply.KeyNUMs + 1
		elseif key == IN_MOVERIGHT then
			ply:ConCommand("-moveright")
			ply:ConCommand("+moveleft")
			ply.KeyNUMs = ply.KeyNUMs + 1
		elseif key == IN_MOVELEFT then
			ply:ConCommand("-moveleft")
			ply:ConCommand("+moveright")
			ply.KeyNUMs = ply.KeyNUMs + 1
		end
	end
end)
hook.Add("KeyRelease","InvertKeys2",function(ply,key)
	if ply.InvertedKeys and ply.KeyNUMs > 0 then
		if key == IN_FORWARD then
			ply:ConCommand("-back")
			ply.KeyNUMs = ply.KeyNUMs - 1 
		elseif key == IN_BACK then
			ply:ConCommand("-forward")
			ply.KeyNUMs = ply.KeyNUMs - 1 
		elseif key == IN_LEFT then
			ply:ConCommand("-right")
			ply.KeyNUMs = ply.KeyNUMs - 1 	
		elseif key == IN_RIGHT then
			ply:ConCommand("-left")
			ply.KeyNUMs = ply.KeyNUMs - 1 
		elseif key == IN_MOVERIGHT then
			ply:ConCommand("-moveleft")
			ply.KeyNUMs = ply.KeyNUMs - 1
		elseif key == IN_MOVELEFT then
			ply:ConCommand("-moveright")
			ply.KeyNUMs = ply.KeyNUMs - 1 
		end
	end
end)

