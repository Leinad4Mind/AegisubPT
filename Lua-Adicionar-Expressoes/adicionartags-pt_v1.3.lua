-- Por Youka e Leinad4Mind
-- Baseado em diversos scripts
-- WE'RE AWESOME!
--

script_name = "Adicionar Expressões"
script_description = "Adicionar Expressões aos Estilos ou Linhas Seleccionadas"
script_author = "Youka e Leinad4Mind"
script_version = "1.3"
script_modified = "24 Setembro 2012"

--Recolhe nomes dos estilos
function collect_styles(subs)
	local n, styles = 0, {}
	for i=1, #subs do
		local sub = subs[i]
		if sub.class == "style" then
			n = n + 1
			styles[n] = sub.name
		end
	end
	return styles
end

--Configuração
function create_config(subs)
	local styles = collect_styles(subs)
	local conf = {
		{
			class = "label",
			x = 1, y = 0, width = 5, height = 1,
			label = "\n...| Desenvolvido por Youka e Leinad4Mind |...\n",
		},
		{
			class = "checkbox", name = "check",
			label = "Adicionar a todo os grupos de expressões da linha?",
			x = 1, y = 1, width = 5, height = 1,
			value = false
		},
		{
			class = "label",
			x = 1, y = 2, width = 1, height = 1,
			label = "Margem:"
		},
		{
			class = "dropdown", name = "margin",
			x = 2, y = 2, width = 5, height = 1,
			items = {"{...", "...}"}, value = "{...", hint = "Adicionar ao início ou fim da expressão?"
		},
		{
			class = "label",
			x = 1, y = 3, width = 1, height = 1,
			label = "Seleccione:"
		},
		{
			class = "dropdown", name = "chosen",
			x = 2, y = 3, width = 5, height = 1,
			items = {"Linhas Seleccionadas"}, value = "Linhas Seleccionadas", hint = "Linhas Seleccionadas ou Estilo Específico?"
		},
		{
			class = "label",
			x = 1, y = 4, width = 1, height = 1,
			label = "Expressões:"
		},
		{
			class = "textbox", name = "txt",
			x = 2, y = 4, width = 12, height = 3,
			hint = "Escreva as expressões a adicionar", text = "\\"
		}
	}
	for i,w in pairs(styles) do
		table.insert(conf[6].items,"Estilo: " .. w)
	end
	return conf
end

--Adiciona expressões ao campo de texto
function change_tag(subs,index,config)
	local a = subs[index]
	if a.text:find("{") and a.text:find("}") then
		if config.check then
			if config.margin == "{..." then
				a.text = a.text:gsub("{", string.format("{%s",config.txt))
			else
				a.text = a.text:gsub("}", string.format("%s}",config.txt))
			end
		else
			if config.margin == "{..." then
				a.text = a.text:gsub("{", string.format("{%s",config.txt),1)
			else
				a.text = a.text:gsub("}", string.format("%s}",config.txt),1)
			end
		end
	else
		a.text = "{" .. config.txt .. "}" .. a.text
	end
	subs[index] = a
end

--Correr pelas linhas escolhidas
function add_tags(subs,sel,config)
	if config.chosen == "Linhas Seleccionadas" then
		for x, i in ipairs(sel) do
			change_tag(subs,i,config)
		end
	else
		for i=1, #subs do
			if subs[i].style == config.chosen:sub(8) then change_tag(subs,i,config) end
		end
	end
end

--Inicialização + GUI
function load_macro_add(subs,sel)
	local config
	repeat
		ok, config = aegisub.dialog.display(create_config(subs),{"Adicionar","Cancelar"})
	until config.txt:sub(1,1) == "\\" or ok ~= "Adicionar"
	if ok == "Adicionar" then
		add_tags(subs,sel,config)
		aegisub.set_undo_point("\""..script_name.."\"")
	end
end

--Registar macro no aegisub
aegisub.register_macro(script_name,script_description,load_macro_add)