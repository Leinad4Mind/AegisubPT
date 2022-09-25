--[[
 Copyright (c) 2012, Leinad4Mind
 All rights reserved®.
 
 Baseado em diversos scripts
 
 Um grande agradecimento a todos os meus amigos
 que sempre me apoiaram, e a toda a comunidade
 de anime portuguesa.
--]]

script_name = "Modificar Estilo do Personagem"
script_description = "Modificar o estilo de determinado personagem"
script_author = "Leinad4Mind"
script_version = "1.4"
script_modified = "12 de Outubro 2012"

function col_estilos(legendas)
	local n, estilos = 0, {}
	for i=1, #legendas do
		local sub = legendas[i]
		if sub.class == "style" then
			n = n + 1
			estilos[n] = sub.name
		end
	end
	return estilos
end

function create_config(legendas)
	local estilos = col_estilos(legendas)
	local conf = {
			[1] = { class = "dropdown"; name = "chosen"; x = 0, y = 0; width = 5; height = 1; items = {"(Estilos Existentes)"}; value = "" }
			,
			[2] = {name = "txt"; class = "textbox"; x= 0; y = 2 ; width = 5; height = 1; text = "" }
			,
			[3] = { class = "label"; x = 0; y = 1; height = 1; width = 4; label = "-| Escreva um dos estilos existentes e depois copie-o |-" }
			}

	for i,w in pairs(estilos) do
		table.insert(conf[1].items,w)
	end
	return conf
	end

	local conf_t = {
				[1] = { class = "label"; x = 0; y = 0; height = 1; width = 4; label = "-| Desenvolvido por Leinad4Mind |-" }
				,
				[2] = { name = "choice"; class = "dropdown"; x = 1; y = 1; height = 1; width = 3; items = {}; value = ""}
				,
				[3] = { class = "label"; x = 0; y = 1; height = 1; width = 1; label = " Seleccione o nome do Personagem" }
				,
				[5] = { class = "label"; x = 0; y = 2; height = 1; width = 1; label = " Introduza o Estilo " }
				,
				[6] = {name = "txt1"; class = "textbox"; x= 0; y = 3 ; width = 4; height = 1; text = "" }
				}

	function change_tag(legendas,config)
		for i = 1, #legendas do
			local l = legendas[i]	
			if l.actor == config.choice
				then l.style = config.txt1 
			end
			legendas[i] = l
		end
	end

	function add_tags(estilos, legendas)
			conf_t[2].items = {}
			local stylex = {}
			for i = 1, #legendas do
			linex = legendas[i]
	if  linex.class == "dialogue" and not  linex.comment then
				if  linex.actor ~= "" and not stylex[linex.actor] then stylex[ linex.actor] = true
				table.insert(conf_t[2].items,linex.actor )	
				end
	end 
			end
	end

	function Add_Cenas(legendas, config)
		local subs = {}
				for i = 1, #legendas do
						linex = legendas[i]
			if linex.class == "dialogue" and not linex.comment  and
									linex.actor == config.choice  then
						table.insert(subs, i, config)
		end	
				end
		change_tag(legendas,config,subs )
	end

	function load_macro_add(legendas)
	add_tags(estilos, legendas)
	ok, config = aegisub.dialog.display(create_config(legendas),{"OK"})
	Chang, config = aegisub.dialog.display(conf_t,{"Modificar","Cancelar"})

	if Chang == "Modificar" then
		Add_Cenas(legendas, config)
		aegisub.set_undo_point(script_name)
	end
end

aegisub.register_macro(script_name,script_description,load_macro_add)
