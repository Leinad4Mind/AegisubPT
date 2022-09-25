-- Por Leinad4Mind
--

script_name = "Adicionar Itálicos"
script_description = "Adicionar itálicos nas linhas seleccionadas"
script_author = "Leinad4Mind"
script_version = "1.0"
script_modified = "24 Setembro 2012"

function italico(subs, sel)
    for _, i in ipairs(sel) do
        local linha = subs[i]
        linha.text = linha.text:gsub("(.+)", "{\\i1}"..linha.text.."{\\i0}")
        subs[i] = linha
    end
    aegisub.set_undo_point("\""..script_name.."\"")
end

aegisub.register_macro(script_name, script_description, italico)

