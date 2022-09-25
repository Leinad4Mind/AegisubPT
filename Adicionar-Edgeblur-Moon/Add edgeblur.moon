--[[
 Copyright (c) 2022, Leinad4Mind
 All rights reserved®.

 Um grande agradecimento a todos os meus amigos
 que sempre me apoiaram, e a toda a comunidade
 de anime portuguesa.
--]]

export script_name = "Add edgeblur"
export script_description = "Aplica as expressões \\blur1.5 nas legendas"
export script_author = "Leinad4Mind"
export script_version = "1.0"
export script_modified = "09 Maio 2022"

require "re"

aegisub.register_macro script_name, script_description, (subs, sel) ->
    for i in *sel
        l = subs[i]
        s = l.text
        if s and not re.match(s,"\\{[^}]*\\\\(?:be|blur)\\d",re.ICASE)
            l.text = if s\match("^%s*{") then s\gsub("^(%s*{)","%1\\blur1.5") else "{\\blur1.5}"..s
            subs[i] = l
    sel
