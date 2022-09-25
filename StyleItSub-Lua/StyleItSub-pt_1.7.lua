-- Por Ghasan Al-Sakkaf (Gh.S) & Leinad4Mind
-- WE'RE AWESOME!
--

script_name = "StyleItSub"
script_description = "Uma macro com uma simples interface, que permite adicionar estilos personalizados a palavras específicas."
script_author = "Ghasan Al-Sakkaf (Gh.S) & Leinad4Mind"
script_version = "1.7"
script_modified = "22 Setembro 2011"

function styleIt(subtitles, selected_lines, active_line)

	local before
	local clrdef
	local l

	local t = {		{class="label", x=1, y=0, label="\nNome/Palavra\n"},
					{class="edit", name="edit1", hint="Introduza palavra. Com distinção entre maiúsculas e minúsculas.", x=0, y=0},
					{class="checkbox", name="chkcolor", hint="Check if you want to apply the custom color.", x=0, y=1, label = "Color:"},
					{class="color", name="color1", hint="Escolha a cor.", x=1, y=1},
					{class="checkbox", name="chkcus", hint="Check if you want to apply the custom changes.", x=0, y=2, label = "Custom:"},
					{class="edit", name="edit2", hint="Colocar antes um {\\tag}", x=1, y=2}
				}
		
	local pushbut, values = aegisub.dialog.display(t)
	
	if (values.chkcolor == false and values.chkcus == false) or pushbut == false or values.edit1 == "" then
		aegisub.progress.set(100)
	else
	
		if values.chkcolor == true and values.chkcus == false then
			clrdef = string.sub(values.color1,2,7)
			before = string.format("{\\1c&H%s&}", clrdef)
		elseif values.chkcolor == false and values.chkcus == true then
			before = values.edit2
		else
			clrdef = string.sub(values.color1,2,7)
			before = string.format("{\\1c&H%s&}", clrdef) .. values.edit2
		end
		
		for _,i in ipairs(selected_lines) do
			l = subtitles[i]
			l.text = string.gsub(l.text,values.edit1,string.format("%s%s{\\r}",before,values.edit1))
			subtitles[i] = l
		end
		
	end
		
	aegisub.set_undo_point(script_name)
		
end

aegisub.register_macro(script_name, script_description, styleIt)
