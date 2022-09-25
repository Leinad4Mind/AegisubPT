--[[
 Copyright (c) 2012, Leinad4Mind ~ MangAnime
 All rights reserved®.
 
 Um grande agradecimento a todos os meus amigos
 que sempre me apoiaram, e a toda a comunidade
 de anime portuguesa.
--]]

script_name = "Fad & Blur"
script_author = "Leinad4Mind"
script_description = "Aplica as expressões 'fad' e 'blur' nas legendas."
script_version = "1.0"
script_modified = "24 Setembro 2012"

function FadBlur(subtitles, selected_lines, active_line)
for r, i in ipairs(selected_lines) do
		local l = subtitles[i]
		   l.text = "{\\blur2.5\\fad(85,85)}" .. l.text 
	   ---> OS VALORES ACIMA PODEM SER MODIFICADOS A TEU GOSTO <---
          subtitles[i] = l 
end
      aegisub.progress.task("..:: A Aplicar ::.")
	aegisub.set_undo_point("Fad & Blur: Produzido em Portugal! :P")
end

aegisub.register_macro("Aplicar Fad && Blur", "Fad && Blur", FadBlur)
