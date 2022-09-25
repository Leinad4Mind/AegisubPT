-- Por Youka e Leinad4Mind
-- WE'RE AWESOME!
--

script_name = "Tremer"
script_description = "Tremer linhas seleccionadas."
script_author = "Youka e Leinad4Mind"
script_version = "1.1"
script_modified = "1 de Outubro 2012"

-- Frame duration in milliseconds
local frame_dur = aegisub.video_size() and (aegisub.ms_from_frame(101)-aegisub.ms_from_frame(1)) / 100 or 41.71

--Deep table copy
function table.copy(t1)
	local t2 = {}
	for i, v in pairs(t1) do
		if type(v) == "table" then
		    t2[i] = table.copy(v)
		else
            t2[i] = v
		end
	end
	return t2
end

--Iterator through frame times
function frames(starts, ends, frame_time)
	local cur_start_time = starts
	local function next_frame()
		if cur_start_time >= ends then
			return nil
		end
		local return_start_time = cur_start_time
		local return_end_time = return_start_time + frame_time <= ends and return_start_time + frame_time or ends
		cur_start_time = return_end_time
		return return_start_time, return_end_time
	end
	return next_frame
end

--Framework
function frame_generator(subs, sel, step, filter)
	local function pos_replace(x, y)
		local x_add, y_add = filter()
		return "\\pos("..(x + x_add)..","..(y + y_add)..")"
	end
	local add = 0
	for _, i in ipairs(sel) do
		local sub = subs[i+add]
		for s, e in frames(sub.start_time, sub.end_time, frame_dur*step) do
			local line = table.copy(sub)
			line.start_time = s
			line.end_time = e
			line.text = line.text:gsub("\\pos%(%s*(%-?[0-9%.]+)%s*,%s*(%-?[0-9%.]+)%s*%)", pos_replace)
			subs.insert(i+add, line)
			add = add + 1
		end
		subs.delete(i+add)
		add = add - 1
	end
end

--Random number filter
function random_filter(x1, y1, x2, y2)
	local decimal_range = 8
	local xa, xb = math.floor( math.min(x1, x2) * decimal_range ), math.floor( math.max(x1, x2) * decimal_range )
	local ya, yb = math.floor( math.min(y1, y2) * decimal_range ), math.floor( math.max(y1, y2) * decimal_range )
	local function get_random()
		return math.random(xa, xb) / decimal_range, math.random(ya, yb) / decimal_range
	end
	return get_random
end

--Random config
local rnd_conf = {
		{
			class = "label",
			x = 0, y = 0, width = 1, height = 1,
			label = "Distância em X:"
		},
		{
			class = "label",
			x = 0, y = 1, width = 1, height = 1,
			label = "Distância em Y:"
		},
		{
			class = "label",
			x = 2, y = 0, width = 1, height = 1,
			label = " - "
		},
		{
			class = "label",
			x = 2, y = 1, width = 1, height = 1,
			label = " - "
		},
		{
			class = "floatedit", name = "x1",
			x = 1, y = 0, width = 1, height = 1,
			hint = "Distância Aleatória Mínima Horizontal", value = 0,
			step = 1
		},
		{
			class = "floatedit", name = "y1",
			x = 1, y = 1, width = 1, height = 1,
			hint = "Distância Aleatória Mínima Vertical", value = 0,
			step = 1
		},
		{
			class = "floatedit", name = "x2",
			x = 3, y = 0, width = 1, height = 1,
			hint = "Distância Aleatória Máxima Horizontal", value = 0,
			step = 1
		},
		{
			class = "floatedit", name = "y2",
			x = 3, y = 1, width = 1, height = 1,
			hint = "Distância Aleatória Máxima Vertical", value = 0,
			step = 1
		}
}

--Random GUI
function random_gui(subs, sel, step)
	aegisub.progress.title (script_name.." - Aleatório")
	local button, conf = aegisub.dialog.display(rnd_conf,{"Aplicar", "Cancelar"})
	if button == "Aplicar" then
		local filter = random_filter(conf.x1, conf.y1, conf.x2, conf.y2)
		frame_generator(subs, sel, step, filter)
		return true
	end
	return false
end

--Position select filter
function selection_filter(t)
	local i = 0
	local function get_selection()
		i = i+1 <= #t and i+1 or 1
		return t[i][1], t[i][2]
	end
	return get_selection
end

--Select config
local function sel_conf()
return {
		{
			class = "label",
			x = 1, y = 0, width = 1, height = 1,
			label = "X"
		},
		{
			class = "label",
			x = 2, y = 0, width = 1, height = 1,
			label = "Y"
		},
		{
			class = "label",
			x = 0, y = 1, width = 1, height = 1,
			label = "Distância 1"
		},
		{
			class = "floatedit", name = "x1",
			x = 1, y = 1, width = 1, height = 1,
			hint = "Distância Horizontal", value = 0,
			step = 1
		},
		{
			class = "floatedit", name = "y1",
			x = 2, y = 1, width = 1, height = 1,
			hint = "Distância Vertical", value = 0,
			step = 1
		}
	}
end

--Select GUI
function add_offset(config)
	if #config < (2 + 3 * 30) then
		local index = (#config - 2) / 3 + 1
		table.insert(config, {
			class = "label",
			x = 0, y = index, width = 1, height = 1,
			label = "Distância "..index
		})
		table.insert(config, {
			class = "floatedit", name = "x"..index,
			x = 1, y = index, width = 1, height = 1,
			hint = "Distância Horizontal", value = 0,
			step = 1
		})
		table.insert(config, {
			class = "floatedit", name = "y"..index,
			x = 2, y = index, width = 1, height = 1,
			hint = "Distância Vertical", value = 0,
			step = 1
		})
	end
end

function remove_offset(config)
	if #config > (5) then
		for i = 1, 3 do
			table.remove(config)
		end
	end
end

function select_gui(subs, sel, step)
	aegisub.progress.title (script_name.." - Seleccione")
	local config = sel_conf()
	local button, tokens
	repeat
		button, tokens = aegisub.dialog.display(config,{"Aplicar", "Adicionar Distância", "Remover Distância", "Cancel"})
		for _, component in ipairs(config) do
			for key, val in pairs(tokens) do
				if component.name and key == component.name then
					component.value = val
				end
			end
		end
		if button == "Adicionar Distância" then add_offset(config) end
		if button == "Remover Distância" then remove_offset(config) end
	until button == "Aplicar" or button == "Cancel"
	if button == "Aplicar" then
		local table_max = 0
		for _, _ in pairs(tokens) do
			table_max = table_max + 1
		end
		local positions = {}
		for i = 1, table_max/2 do 
			table.insert(positions, {tokens["x"..i], tokens["y"..i]})
		end
		local filter = selection_filter(positions)
		frame_generator(subs, sel, step, filter)
		return true
	end
	return false
end

--Switch config
local switch_conf = {
		{
			class = "label",
			x = 0, y = 0, width = 1, height = 1,
			label = "Passos de Frame:"
		},
		{
			class = "intedit", name = "step",
			x = 1, y = 0, width = 1, height = 1,
			hint = "Quantas frames para a próxima posição?",
			value = 1, min = 1
		}
}

--Switch GUI
function switch_gui(subs, sel)
	aegisub.progress.title (script_name)
	aegisub.progress.set(0)
	local button, conf = aegisub.dialog.display(switch_conf,{"Aleatorio", "Seleccione"})
	if button == "Aleatorio" then
		if random_gui(subs, sel, conf.step) then 
			aegisub.set_undo_point("\""..script_name.."\"")
		end
	elseif button == "Seleccione" then
		if select_gui(subs, sel, conf.step) then 
			aegisub.set_undo_point("\""..script_name.."\"")
		end
	end
end

--Test for lines with 0 frames
function test_null_frames(subs, sel)
	for i, si in ipairs(sel) do
		local sub = subs[si]
		if (math.ceil((sub.end_time - sub.start_time) / frame_dur) < 1) then
			return false
		end
	end
	return true
end

--Register macro in aegisub
aegisub.register_macro(script_name, script_description, switch_gui, test_null_frames)
