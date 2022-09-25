--[[
 Copyright (c) 2012-2013, Leinad4Mind
 All rights reserved®.
 
 Um grande agradecimento a todos os meus amigos
 que sempre me apoiaram, e a toda a comunidade
 de anime portuguesa.
--]]

script_name = "Adicionar Negritos SRT"
script_description = "Adicionar Negritos nas linhas seleccionadas para as legendas SRT"
script_author = "Leinad4Mind"
script_version = "2.1"
script_modified = "20 de Outubro 2013"

re = require("re")

function add_bold(subs, sel)
  for _index_0 = 1, #sel do
    local i = sel[_index_0]
    local l = subs[i]
    local s = l.text
    if s and not re.match(s, "\\{[^}]*\\\\(?:b)\\d", re.ICASE) then
      if s:match("^%s*{") then
        l.text = s:gsub("^(%s*{)(.-)(}%s*)$", "%1\\b1%2\\b0%3")
      else
        l.text = "{\\b1}" .. s .. "{\\b0}"
      end
      subs[i] = l
    end
  end
  return sel
end

return aegisub.register_macro(script_name, script_description, add_bold)