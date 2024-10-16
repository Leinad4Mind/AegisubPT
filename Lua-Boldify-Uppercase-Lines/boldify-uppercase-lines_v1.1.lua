--[[
 Copyright (c) 2021-2024, fmmagalhaes & Leinad4Mind
 All rights reserved®.
--]]

script_name = "Negrito nas Linhas Maiúsculas"
script_description = "Encontra linhas em maiúscula e adiciona tag negrito às mesmas"
script_author = "fmmagalhaes & Leinad4Mind"
script_version = "1.1"

re = require("re")

function boldify_uppercase_lines(subs)
	for i=1, #subs do
		local line = subs[i]

		if line.class == "dialogue" then 
			local text = line.text

			-- now we check if it's uppercase and it does not have bold tag already
			if is_uppercase_text(text) and not re.match(text, "\\{[^}]*\\\\(?:b)\\d", re.ICASE) then
				line.text = "{\\b1}" .. text .. "{\\b0}"
				subs[i] = line
			end
		end
	end

	aegisub.set_undo_point(script_name)
end

function is_uppercase_text(text)
	local cleanText = text:gsub("{[^}]+}", "") -- remove tags
	cleanText = cleanText:gsub(" *\\[Nn] *"," ") -- remove line breaks
	return cleanText ~= '' and cleanText == cleanText:upper()
end

aegisub.register_macro(script_name, script_description, boldify_uppercase_lines)