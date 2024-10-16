--[[
 Copyright (c) 2019-2024, fmmagalhaes & Leinad4Mind
 All rights reserved®.
--]]

script_name = "Hífen para Travessão"
script_description = "Substitui hífen por travessão nos diálogos"
script_author = "fmmagalhaes & Leinad4Mind"
script_version = "1.3"

function replace_hypen(subs)

	for i=1, #subs do
        local line = subs[i]
		if line.class == "dialogue" then
			-- en dash / meia-risca – (em uso)
			-- em dash / travessão  —
			line.text = line.text:gsub("^- ?(.*)","– %1")
			line.text = line.text:gsub("^({.-}+ ?)-(.*)","%1– %2")
			line.text = line.text:gsub("(\\[Nn] ?)- ?(.*)","%1– %2")
			line.text = line.text:gsub("(\\[Nn] ?{.-}+)- ?(.*)","%1– %2")
			subs[i] = line
		end
	end

	aegisub.set_undo_point(script_name)
end

aegisub.register_macro(script_name, script_description, replace_hypen)