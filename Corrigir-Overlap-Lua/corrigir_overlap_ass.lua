--[[
 Copyright (c) 2012-2014, Leinad4Mind
 All rights reserved®.
 
 Um grande agradecimento a todos os meus amigos
 que sempre me apoiaram, e a toda a comunidade
 de anime portuguesa.
--]]

script_name = "Corrigir Overlap ASS"
script_description = "Corrige overlap em ASS."
script_author = "Leinad4Mind"
script_version = "1.0"

include("karaskel.lua")

function do_for_selected(sub, sel)
	--Keep in mind that si is the index in sel, while li is the line number in sub
	for li=1, #sub do
		--Read in the line
		if li > 1 and li < #sub then -- se não for a 1º linha nem a última então
			local l = sub[li]
			if l.class == "dialogue" then
				if l.text ~= "" then -- se duracao for menor que 800ms = 0:00:00.80 entao
					local t = l.text
					local e = l.effect
					local a = sub[li-1]
					local d = sub[li+1]
					local del=li+1
					local proceed = false
					local confirmar = false

					if e:match("sobreposto1") then proceed = true end
						if proceed then
							l.end_time = d.end_time -- torna os tempos continuos
							l.text=l.text.."\\N"..d.text
							l.actor=l.actor.." & "..d.actor
							sub[li]=l
							sub.delete(del) --apaga a linha que mete nojo
						end
				end
			end
		end
	end
	aegisub.set_undo_point(script_name)
	return sel
end

  --PROBLEMA
  --Dialogue: 0,0:32:18.74,0:32:21.96,Default,,0000,0000,0000,,texto antes
  --Dialogue: 0,0:32:21.96,0:32:22.29,Default,,0000,0000,0000,,texto test depois\Ntexto antes
  --Dialogue: 0,0:32:22.29,0:32:24.90,Default,,0000,0000,0000,,texto test depois
  --RESULTADO
  --Dialogue: 0,0:32:18.74,0:32:21.96,Default,,0000,0000,0000,,texto antes
  --Dialogue: 0,0:32:21.96,0:32:24.90,Default,,0000,0000,0000,,texto test depois

--This is the main processing function that modifies the subtitles
function macro_function(subtitle, selected, active)
    --Code your function here
    aegisub.set_undo_point(script_name) --Automatic in 3.0 and above, but do it anyway
    return selected --This will preserve your selection (explanation below)
end

--This optional function lets you prevent the user from running the macro on bad input
function macro_validation(subtitle, selected, active)
    --Check if the user has selected valid lines
    --If so, return true. Otherwise, return false
    return true
end

aegisub.register_macro(script_name, script_description, do_for_selected)
aegisub.register_filter(script_name, script_description, 0, do_for_selected)