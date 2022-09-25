-- Por Youka-LeSaint e modificado por Leinad4Mind
-- WE'RE AWESOME!

script_author = "Youka-LeSaint e Leinad4Mind"
script_version = "1.4"
script_name = "Macol v" .. script_version
script_description = "Colecção de Macros v" .. script_version
script_modified = "20 de Setembro 2012"

include("karaskel.lua")

-------------------------------------
--  -----------------------------  --
--  ----- POSITION MODIFIER -----  --
--  -----------------------------  --
-------------------------------------

-- function: create_shift_config.
-- purpose: create config structure for shift GUI.
-- @subs: table containing subtitles.
-- @meta: metatable.
-- return: config structure.

function create_shift_config(subs,meta)
	conf = {
		to = {
			class = "label",
			x = 0, y = 0, width = 4, height = 2,
			label = "Deslocar a expressão \\pos, \\move, \\org de todas as linhas seleccionadas\\npelos valores introduzidos em x e y."
		},
		tx = {
			class = "label",
			x = 0, y = 2, width = 1, height = 1,
			label = "x:"
		},
		ty = {
			class = "label",
			x = 0, y = 3, width = 1, height = 1,
			label = "y:"
		},
		tx2 = {
			class = "label",
			x = 3, y = 2, width = 1, height = 1,
			label = string.format("(mín.%d/máx.%d)",(-2)*meta.res_x,2*meta.res_x)
		},
		ty2 = {
			class = "label",
			x = 3, y = 3, width = 1, height = 1,
			label = string.format("(mín.%d/máx.%d)",(-2)*meta.res_y,2*meta.res_y)
		},
		x = {
			class = "floatedit", name = "x",
			x = 1, y = 2, width = 2, height = 1,
			value = 0.00, hint = "Mover coordenada x"
		},		
		y = {
			class = "floatedit", name = "y",
			x = 1, y = 3, width = 2, height = 1,
			value = 0.00, hint = "Mover coordenada y"
		}		
					
	}
	return conf
end

-- function: load_macro_shift.
-- purpose: shift non rectangular \\clip or \\iclip tags with the values given in config.
-- @subs: table containing subtitles.
-- @sel: indexes of selected subtitle lines.
-- return: nothing.

function load_macro_shift(subs,sel)
	meta, styles = karaskel.collect_head(subs)
	repeat
		local shift = {"Mover","Cancelar"}
		sh, config = aegisub.dialog.display(create_shift_config(subs,meta),shift)
		local testlimit = (config.x <= 2*meta.res_x and config.x >= (-2)*meta.res_x and config.y <= 2*meta.res_y and config.y >= (-2)*meta.res_y)
	until (testlimit and (config.x ~= 0 or config.y ~= 0)) or sh ~= "Mover"
	if sh=="Mover" then
		shift_all_tags(subs,sel,config)
		aegisub.set_undo_point(string.format("Mover x=%g e y=%g",config.x,config.y))
	end
end





-- function: activate_macro_shift.
-- purpose: Check if Position Modifier should be available on selected lines.
--          Position Modifier is available if all selected lines contain \\pos, \\move, \\org tags
-- @subs: table containing subtitles.
-- @sel: indexes of selected subtitle lines.
-- return: boolean that represents if Position Modifier is available on this text.

function activate_macro_shift(subs, sel)
	for x, i in ipairs(sel) do
		local sub = subs[i]
		local test = test_shift(sub.text)
		if not test then return false end
	end
	return true
end



-- function: test_shift.
-- purpose: Check if Position Modifier should be available on a line.
--          Position Modifier is available if the line contains \\pos, \\move, or \\org tags
-- @test: text to check.
-- return: boolean that represents if Position Modifier is available on this text.

function test_shift(text)
	local p1 = text:match("\\\\pos%(([%d%.%-%s]+),([%d%.%-%s]+)%)")
	local m1 = text:match("\\\\move%(([%d%.%-%s]+),([%d%.%-%s]+),([%d%.%-%s]+),([%d%.%-%s]+)%)")
	local mm1 = text:match("\\\\move%(([%d%.%-%s]+),([%d%.%-%s]+),([%d%.%-%s]+),([%d%.%-%s]+),([%d%s]+),([%d%s]+)%)")
	local o1 = text:match("\\\\org%(([%d%.%-%s]+),([%d%.%-%s]+)%)")
	if p1 ~= nil or m1 ~= nil or mm1 ~= nil or o1 ~= nil then return true end
	return false
end



-- function: shift_all_tags.
-- purpose: shift tags with the values given in config.
-- @subs: table containing subtitles.
-- @sel: indexes of selected subtitle lines.
-- @config: structure containing 2 float fields (x, y) with x and y shit values.
-- return: nothing.

function shift_all_tags(subs,sel,config)
	for x, i in ipairs(sel) do
		local sub1 = subs[i]
		
		sub1 = shift_pos_tags_singleline(sub1,config)
		sub1 = shift_move_tags_singleline(sub1,config)
		sub1 = shift_org_tags_singleline(sub1,config)
		sub1 = shift_clip_tags_singleline(sub1,config)
		
		subs[i] = sub1
	end
end



-------------------------------------------------
-------------- Main Shift Functions -------------
-------------------------------------------------


-- function: shift_pos_tags_singleline.
-- purpose: shift \\pos tags with the values given in config.
-- @sub: subtitle to modify.
-- @config: structure containing 2 float fields (x, y) with x and y shit values.
-- return: modified sub.

function shift_pos_tags_singleline(sub,config)

	local sub1 = sub
	local line = sub1.text
	-- first change \\pos to \\pos1 --
	line = line:gsub("\\\\pos","\\\\pos1")
	-- defining local variables
	local x1, x2, newpos

	x1, y1 = line:match("\\\\pos1%(([%d%.%-%s]+),([%d%.%-%s]+)%)")

	while x1 ~= nil do
		x1, y1 = tonumber(x1), tonumber(y1)
		x1 = x1 + config.x
		y1 = y1 + config.y
		newpos = string.format("\\\\pos(%g,%g)",x1,y1)

		line = line:gsub("\\\\pos1%(([%d%.%-%s]+),([%d%.%-%s]+)%)",newpos,1)

		-- Search for other \\pos1 tags
		x1, y1 = line:match("\\\\pos1%(([%d%.%-%s]+),([%d%.%-%s]+)%)")
	end

	sub1.text = line

	return sub1
end



-- function: shift_move_tags_singleline.
-- purpose: shift \\move tags with the values given in config.
-- @sub: subtitle to modify.
-- @config: structure containing 2 float fields (x, y) with x and y shit values.
-- return: modified sub.

function shift_move_tags_singleline(sub,config)

	local sub1 = sub
	local line = sub1.text
	-- first change \\move to \\move1--
	line = line:gsub("\\\\move","\\\\move1")
	-- defining local variables
	local x1, x2, y1, y2, t1, t2, newmov

	x1, y1, x2, y2, t1, t2 = line:match("\\\\move1%(([%d%.%-%s]+),([%d%.%-%s]+),([%d%.%-%s]+),([%d%.%-%s]+),([%d%s]+),([%d%s]+)%)")

	while x1 ~= nil do

		x1, y1, x2, y2, t1, t2 = tonumber(x1), tonumber(y1), tonumber(x2), tonumber(y2), tonumber(t1), tonumber(t2)


		x1 = x1 + config.x
		y1 = y1 + config.y
		x2 = x2 + config.x
		y2 = y2 + config.y			
		newmov = string.format("\\\\move(%g,%g,%g,%g,%g,%g)",x1,y1,x2,y2,t1,t2)

		line = line:gsub("\\\\move1%(([%d%.%-%s]+),([%d%.%-%s]+),([%d%.%-%s]+),([%d%.%-%s]+),([%d%s]+),([%d%s]+)%)",newmov,1)

		-- Search for other \\move1 tags
		x1, y1, x2, y2, t1, t2 = line:match("\\\\move1%(([%d%.%-%s]+),([%d%.%-%s]+),([%d%.%-%s]+),([%d%.%-%s]+),([%d%s]+),([%d%s]+)%)")
	end

	x1, y1, x2, y2 = line:match("\\\\move1%(([%d%.%-%s]+),([%d%.%-%s]+),([%d%.%-%s]+),([%d%.%-%s]+)%)")

	while x1 ~= nil do

		x1, y1, x2, y2 = tonumber(x1), tonumber(y1), tonumber(x2), tonumber(y2)
		x1 = x1 + config.x
		y1 = y1 + config.y
		x2 = x2 + config.x
		y2 = y2 + config.y			
		newmov = string.format("\\\\move(%g,%g,%g,%g)",x1,y1,x2,y2)

		line = line:gsub("\\\\move1%(([%d%.%-%s]+),([%d%.%-%s]+),([%d%.%-%s]+),([%d%.%-%s]+)%)",newmov,1)

		-- Search for other \\move1 tags
		x1, y1, x2, y2 = line:match("\\\\move1%(([%d%.%-%s]+),([%d%.%-%s]+),([%d%.%-%s]+),([%d%.%-%s]+)%)")
	end

	sub1.text = line

	return sub1
end



-- function: shift_org_tags_singleline
-- purpose: shift \\org tags with the values given in config
-- @sub: table containing subtitles
-- @config: structure containing 2 float fields (x, y) with x and y shit values.
-- return: modified sub.

function shift_org_tags_singleline(sub,config)

	local sub1 = sub
	local line = sub1.text
	-- first change \\org to \\org1 --
	line = line:gsub("\\\\org","\\\\org1")
	-- defining local variables
	local x1, x2, neworg

	x1, y1 = line:match("\\\\org1%(([%d%.%-%s]+),([%d%.%-%s]+)")

	while x1 ~= nil do

		x1, y1 = tonumber(x1), tonumber(y1)		
		x1 = x1 + config.x
		y1 = y1 + config.y
		neworg = string.format("\\\\org(%g,%g)",x1,y1)

		line = line:gsub("\\\\org1%(([%d%.%-%s]+),([%d%.%-%s]+)%)",neworg,1)

		-- Search for other \\org1 tags
		x1, y1 = line:match("\\\\org1%(([%d%.%-%s]+),([%d%.%-%s]+)%)")
	end

	sub1.text = line	
	return sub1
end



-- function: shift_clip_tags_singleline
-- purpose: shift \\clip and \\iclip tags with the values given in config
-- @sub: table containing subtitles
-- @config: structure containing 2 float fields (x, y) with x and y shit values.
-- return: modified sub.

function shift_clip_tags_singleline(sub,config)
	local sub1 = sub
	
	-- process line on both clip tags
	sub1 = shift_clip_tags_priv(sub,config,"clip")
	sub1 = shift_clip_tags_priv(sub,config,"iclip")
	sub1 = shift_clip_tags_advanced_priv(sub,config,"clip")
	sub1 = shift_clip_tags_advanced_priv(sub,config,"iclip")
	
	return sub1
end


--------------------------------
--------- SubFunctions ---------
--------------------------------


-- function: shift_clip_tags_priv.
-- purpose: shift rectangular \\clip or \\iclip (depending on tagname) tags with the values given in config.
-- @sub: table containing subtitles.
-- @config: structure containing 2 float fields (x, y) with x and y shit values.
-- @tagname: legal value-> "clip" or "iclip".
-- return: modified sub.

function shift_clip_tags_priv(sub,config,tagname)

	local sub1 = sub
	local line = sub1.text
	-- first change \\clip to \\clip1 or \\iclip to \\iclip1 (depending on tagname) --
	line = line:gsub("\\\\" .. tagname,"\\\\" .. tagname .. "1")
	-- defining local variables
	local x1, x2, y1, y2, newclip

	x1, y1, x2, y2 = line:match("\\\\" .. tagname .. "1%(([%d%.%-%s]+),([%d%.%-%s]+),([%d%.%-%s]+),([%d%.%-%s]+)%)")

	while x1 ~= nil do

		x1, y1, x2, y2 = tonumber(x1), tonumber(y1), tonumber(x2), tonumber(y2)
		x1 = x1 + config.x
		y1 = y1 + config.y
		x2 = x2 + config.x
		y2 = y2 + config.y			
		newclip = string.format("\\\\" .. tagname .. "(%g,%g,%g,%g)",x1,y1,x2,y2)

		line = line:gsub("\\\\" .. tagname .. "1%(([%d%.%-%s]+),([%d%.%-%s]+),([%d%.%-%s]+),([%d%.%-%s]+)%)",newclip,1)

		-- Search for other \\clip1 tags
		x1, y1, x2, y2 = line:match("\\\\" .. tagname .. "1%(([%d%.%-%s]+),([%d%.%-%s]+),([%d%.%-%s]+),([%d%.%-%s]+)%)")
	end

	-- change remaining \\clip1 to \\clip or \\iclip1 to \\iclip (depending on tagname) --
	line = line:gsub("\\\\" .. tagname .. "1","\\\\" .. tagname)

	sub1.text = line
	
	return sub1
end


-- function: shift_clip_tags_advanced_priv.
-- purpose: shift vector \\clip or \\iclip (depending on tagname) tags with the values given in config.
-- @sub: table containing subtitles.
-- @config: structure containing 2 float fields (x, y) with x and y shit values.
-- @tagname: legal value-> "clip" or "iclip".
-- return: modified sub.

function shift_clip_tags_advanced_priv(sub,config,tagname)

	local sub1 = sub
	local line = sub1.text
	local origtag, origtag2, newtag, withscale
	-- first change \\clip to \\clip1 or \\iclip to \\iclip1 (depending on tagname) --
	line = line:gsub("\\\\" .. tagname,"\\\\" .. tagname .. "1")

	local idstart, idend, idpat
	
	withscale = true
	idstart, idend = line:find("\\\\" .. tagname .. "1%(%s*%d+%s*%,%s*m[bml%d%.%-%s]+")	
	-- can match beginning of rectangular clip, but won't be shifted (comma replacement makes each word not numerical).
	
	if idstart==nil then
		idstart, idend = line:find("\\\\" .. tagname .. "1%(%s*m[bml%d%.%-%s]+")
		-- aegisub.log(4,"withscale\\n")
		withscale=false
	end 

	while idstart ~= nil do

		origtag = string.sub(line,idstart,idend)
		-- aegisub.log(4,origtag .. "\\n")
		
		local typecoord, val

		typecoord=1
		newtag=nil

		if withscale then
			origtag2 = origtag:gsub("%s*%,%s*","%,")
		else
			origtag2=origtag
		end
		
		for word in string.words(origtag2) do 

			-- aegisub.log(4,word .. "\\n")
			val = tonumber(word)
			if val == nil then

				val = word

			else

				if typecoord == 1 then
					val = val + config.x
					typecoord=2
				else
					val = val + config.y
					typecoord=1
				end

				val = string.format("%g",val)

			end

			if newtag == nil then

				newtag = val

			else

				newtag = newtag .. " " .. val

			end

		end

		newtag = newtag:gsub("\\\\" .. tagname .. "1","\\\\" .. tagname)

		origtag = origtag:gsub("(%W)", "%%%1")
		newtag = newtag:gsub("(%W)", "%%%1")

		line = line:gsub(origtag, newtag)

		withscale=true
		idstart, idend = line:find("\\\\" .. tagname .. "1%(%s*%d+%s*%,[bml%d%.%-%s]+")
		
		if idstart==nil then
			idstart, idend = line:find("\\\\" .. tagname .. "1%(m[bml%d%.%-%s]+")				
			withscale=false
		end 
	end

	-- change remaining \\clip1 to \\clip and \\iclip1 to \\iclip --
	line = line:gsub("\\\\clip1","\\\\clip")
	line = line:gsub("\\\\iclip1","\\\\iclip")

	sub1.text = line

	return sub1
end


------------------------------------
--  ----------------------------  --
--  ----- ACCELERATED MOVE -----  --
--  ----------------------------  --
------------------------------------


-- function: create_accel_config.
-- purpose: create config structure for Accelerated Move GUI.
-- return: config structure.

function create_accel_config()

	conf = {
		tt = {
			class = "label",
			x = 0, y = 0, width = 2, height = 2,
			label = "Transforma expressões \\move em animação frame-a-frame com expressões \\pos.\\nTrabalha com expressões \\org e \\clip, e aceleração."
		},
		fstt = {
			class = "label",
			x = 0, y = 2, width = 1, height = 1,
			label = "Passo Frame:"
		},
		fst = {
			class = "intedit", name = "step",
			x = 1, y = 2, width = 1, height = 1,
			value = 1, min = 1 , max = 5,
			hint = "Passo Frame"
		},
		acct = {
			class = "label",
			x = 0, y = 3, width = 1, height = 1,
			label = "Aceleração (\\\\t tag definition\\):         "
		},
		acc = {
			class = "floatedit", name = "macc",
			x = 1, y = 3, width = 1, height = 1,
			value = 1, hint = "Aceleração de objectos em movimento"
		},
		expos = {
			class = "checkbox", name = "expos",
			label = "Forçar pos exacta para primeira e última frame.",
			x = 0, y = 4, width = 2, height = 1,
			value = false, hint = "Força a obter a pos exacta para a primeira e última frame (a expressão \\move não faz isso)"
		}
	}
	return conf
end


-- function: load_macro_accel.
-- purpose: add tags to specific lines.
-- @subs: table containing subtitles.
-- @sel: indexes of selected subtitle lines.
-- return: nothing.

function load_macro_accel(subs,sel)

	repeat
		local split = {"Mover!","Cancelar"}
		sp, config = aegisub.dialog.display(create_accel_config(),split)
	until sp ~= "Mover!" or (config.macc > 0 and config.macc <= 100)
	if sp == "Mover!" then
		acc_tag(subs,sel,config)
		--acc_mov(subs,sel,config)
		aegisub.set_undo_point("Movimento Transformado")
	end
end


-- function: activate_macro_pos.
-- purpose: Check if Accelerated Move should be available on selected lines.
-- @subs: table containing subtitles.
-- @sel: indexes of selected subtitle lines.
-- return: boolean that represents if Accelerated Move is available on this text.

function activate_macro_accel(subs,sel)

	-- First check if a video is loaded
	local vidsize = aegisub.video_size() 

	if vidsize == nil then return false end
	
	for x, i in ipairs(sel) do
		local sub = subs[i]
		local test = test_accel(sub.text)
		if not test then return false end
	end
	return true
end



-- function: test_accel.
-- purpose: Check if Accelerated Move should be available on a line.
--          Accelerated Move is available if the line contains \\move tag
-- @test: text to check.
-- return: boolean that represents if Position Modifier is available on this text.

function test_accel(text)

	local m1 = text:match("\\\\move%(([%d%.%-%s]+),([%d%.%-%s]+),([%d%.%-%s]+),([%d%.%-%s]+)%)")
	
	if m1 ~= nil then return true end
	return nil
end



-- function: acc_tag.
-- purpose: split selected lines into per frame animation (handle acceleration, and \\org and \\clip tags).
-- @subs: table containing subtitles.
-- @sel: indexes of selected subtitle lines.
-- @config: config structure.
-- return: nothing.

function acc_tag(subs,sel,config)

	local ppi, pi = 0, 0

	for x, i in ipairs(sel) do
		local mx1, my1, mx2, my2, stepx, stepy
		local idframestart, idframeend, crtstarttime, crtendtime, globstarttime, globendtime, globidstart
		local nbframes, nbiter, t
		local a = subs[i+ppi]
		pi = i+ppi
	
		-- Calculate boundaries --
		idframestart = aegisub.frame_from_ms(a.start_time)
		idframeend = aegisub.frame_from_ms(a.end_time)
			
		nbiter = math.ceil(idframeend-idframestart)/config.step
			
		globstarttime = aegisub.ms_from_frame(idframestart)
		globendtime = aegisub.ms_from_frame(idframeend)

		globidstart = idframestart
		crtstarttime = globstarttime
		
		-- Read basic move --
		mx1, my1, mx2, my2 = a.text:match("\\\\move%(([%d%.%-%s]+),([%d%.%-%s]+),([%d%.%-%s]+),([%d%.%-%s]+)%)")
		mx1, my1, mx2, my2 = tonumber(mx1), tonumber(my1), tonumber(mx2), tonumber(my2)
		stepx, stepy = mx2 - mx1, my2 - my1

		-- Append lines --
		local c, origline, newpos
		
		origline = a.text
		newpos = string.format("\\\\pos(%g,%g)",mx1,my1)
		origline = origline:gsub("\\\\move%(([%d%.%-%s]+),([%d%.%-%s]+),([%d%.%-%s]+),([%d%.%-%s]+)%)",newpos)

		-- Create shift structure --
		shift = {}
		
		
		for ifor1 = 0, nbiter-1 do
		
			c = table.copy(a)
			ppi = ppi+1
			crtendtime = math.min(globendtime, aegisub.ms_from_frame(idframestart + ifor1 * config.step + 1))
			
			-- Initialize subtitle --
			c.start_time = crtstarttime
			c.end_time = crtendtime
			c.text = origline
			
			-- Adjust crtstarttime to take progress into account --
			if config.expos then
				-- force first and last frame to get exact values
				crtstarttime = crtstarttime + (crtendtime-crtstarttime)*ifor1/(nbiter-1)
			else
				-- classic adjust : used for \\move tags
				crtstarttime = (crtstarttime + crtendtime)/2
			end
			
			-- Calculate progress and shift values --
			t = ((crtstarttime-globstarttime)/(globendtime-globstarttime))^config.macc			
			
			-- aegisub.log(4, "macc: " .. config.macc .. "\\n")
			-- aegisub.log(4, "t: " .. t .. "\\n")
			
			-- shift tags --
			shift.x = stepx*t
			shift.y = stepy*t
			
			c = shift_pos_tags_singleline(c,shift)
			c = shift_org_tags_singleline(c,shift)
			c = shift_clip_tags_singleline(c,shift)
			c.effect = "linha acelerada"
			c.comment = false
			
			subs[-i-ppi] = c
			
			crtstarttime = crtendtime
		end
		
		a.comment = true
		subs[pi] = a
	end
end

---------------------------------------------------------------------
---- Macro Registrations - need to stay at the end of the script ----
---------------------------------------------------------------------
aegisub.register_macro("Modificador de Posição", "Altera pos/move/org/clip ao introduzir valores x e y.", load_macro_shift, activate_macro_shift)
aegisub.register_macro("Acelerar Movimento","Criar movimento com aceleração usando múltimplas linhas com \\pos", load_macro_accel, activate_macro_accel)