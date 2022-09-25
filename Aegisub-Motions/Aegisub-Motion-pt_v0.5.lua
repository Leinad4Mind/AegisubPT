script_name = "Aegisub-Motion"
script_description = "Um conjunto de ferramentas para simplificar o processo de criar e aplicar dados de 'motion-track' no Aegisub." -- and it might have memory issues. I think.
script_author = "torque"
script_translator = "Leinad4Mind"
script_version = "0.5.0"
local config_file = "aegisub-motion.conf"
local success, re, onetime_init, init_input, parse_input, populateInputBox, dialogPreproc, getSelInfo, spoof_table, extraLineMetrics, ensuretags, frame_by_frame, mochaRatios, possify, orginate, makexypos, clippinate, transformate, scalify, rotate, munch, cleanup, dialog_sort, readconf, writeconf, splitconf, configscope, confmaker, trimnthings, collecttrim, dcos, dacos, dsin, dasin, dtan, datan, fix, check_user_cancelled, conformdialog, makebuttons, windowerr, printmem, debug, warn, round, getvideoname, isvideo
local gui, guiconf, winpaths, encpre, global, alltags, globaltags, importanttags
--[[ Include helper scripts. ]]--
require "karaskel"
if not pcall(require, "clipboard") then error("É necessário a versão do Aegisub ser a 3.0.0 ou uma superior.") end

--[[ Alias commonly used functions with much shorter identifiers.
     As an added bonus, this makes the code more confusing. ]]--
dcp = aegisub.decode_path
sc = string.char

--[[ Detect whether to use *nix or Windows style paths. ]]--
winpaths = not dcp('?data'):match('/')

--[[ Set up interface tables. ]]--
gui = {
  main = {
    linespath = { class = "textbox"; name = "linespath"; hint = "Colar dados ou o caminho para o ficheiro que os contenham. Sem aspas ou \.";
                  x = 0; y = 1; height = 4; width = 10;},
    pref      = { class = "textbox"; name = "pref"; hint = "O prefixo";
                  x = 0; y = 14; height = 3; width = 10; hint = "O directório onde todos os ficheiros gerados são guardados."},
    preflabel = { class = "label"; label = "                  Os ficheiros irão ser guardados neste directório.";
                  x = 0; y = 13; height = 1; width = 10;},
    datalabel = { class = "label"; label = "                       Colar dados ou introduzir um caminho de ficheiros.";
                  x = 0; y = 0; height = 1; width = 10;},
    optlabel  = { class = "label"; label = "Dados a aplicar:";
                  x = 0; y = 6; height = 1; width = 5;},
    rndlabel  = { class = "label"; label = "Arredondamento";
                  x = 7; y = 6; height = 1; width = 3;},
    xpos      = { class = "checkbox"; name = "xpos"; value = true; label = "x";
                  x = 0; y = 7; height = 1; width = 1; hint = "Aplicar os dados da posição x às linhas seleccionadas."},
    ypos      = { class = "checkbox"; name = "ypos"; value = true; label = "y";
                  x = 1; y = 7; height = 1; width = 1; hint = "Aplicar os dados da posição y às linhas seleccionadas."},
    origin    = { class = "checkbox"; name = "origin"; value = false; label = "Org";
                  x = 2; y = 7; height = 1; width = 2; hint = "Mova a origem (org) juntamente com a posição."},
    clip      = { class = "checkbox"; name = "clip"; value = false; label = "Clip";
                  x = 4; y = 7; height = 1; width = 2; hint = "Mova o clip juntamente com a posição (atenção: também irá sofrer dos valores do tamanho (scale) e da rotação se a opção estiver seleccionada)."},
    scale     = { class = "checkbox"; name = "scale"; value = true; label = "Scale";
                  x = 0; y = 8; height = 1; width = 2; hint = "Aplicar os dados de alteração de tamanho (scale) às linhas seleccionadas."},
    border    = { class = "checkbox"; name = "border"; value = true; label = "Borda";
                  x = 2; y = 8; height = 1; width = 2; hint = "Aumentar/Diminuir borda juntamente com a linha (apenas se Tamanho estiver seleccionado)."},
    shadow    = { class = "checkbox"; name = "shadow"; value = true; label = "Sombra";
                  x = 4; y = 8; height = 1; width = 2; hint = "Aumentar/Diminuir sombra juntamente com a linha (apenas se Tamanho estiver seleccionado)."},
    blur      = { class = "checkbox"; name = "blur"; value = true; label = "Blur";
                  x = 4; y = 9; height = 1; width = 2; hint = "Aumentar/Diminuir blur juntamente com a linha (apenas se Tamanho estiver seleccionado; não altera o \\be)."},
    rotation  = { class = "checkbox"; name = "rotation"; value = false; label = "Rotação";
                  x = 0; y = 9; height = 1; width = 3; hint = "Aplicar dados da Rotação linhas seleccionadas."},
    posround  = { class = "intedit"; name = "posround"; value = 2; min = 0; max = 5;
                  x = 7; y = 7; height = 1; width = 3; hint = "Quantas casas decimais de precisão as posições resultantes devem ter."},
    sclround  = { class = "intedit"; name = "sclround"; value = 2; min = 0; max = 5;
                  x = 7; y = 8; height = 1; width = 3; hint = "Quantas casas decimais de precisão os tamanhos (scale) resultantes devem ter (também se aplica a borda, sombra, e blur)."},
    rotround  = { class = "intedit"; name = "rotround"; value = 2; min = 0; max = 5;
                  x = 7; y = 9; height = 1; width = 3; hint = "Quantas casas decimais de precisão as rotações resultantes devem ter."},
    wconfig   = { class = "checkbox"; name = "wconfig"; value = false; label = "Guardar Configuração";
                  x = 0; y = 11; height = 1; width = 4; hint = "Guarda as configurações actuais no ficheiro."},
    relative  = { class = "checkbox"; name = "relative"; value = true; label = "Proporcional (Relative)";
                  x = 4; y = 11; height = 1; width = 3; hint = "Frame de entrada deverá de ser proporcional (relative) à frame de entrada da linha em vez do que de todas as linhas seleccionadas"},
    stframe   = { class = "intedit"; name = "stframe"; value = 1;
                  x = 7; y = 11; height = 1; width = 3; hint = "Frame usada como ponto de partida para os dados de 'motion-track'. \"-1\" corresponde à última frame."},
    vsfscale  = { class = "checkbox"; name = "vsfscale"; value = false; label = "\\t() tamanho (scaling)"; -- hurr durr
                  x = 0; y = 12; height = 1; width = 3; hint = "Uso de transformações encenados para aproximar valores de scale não-inteiros para o vsfilter."},
    linear    = { class = "checkbox"; name = "linear"; value = false; label = "Linear";
                  x = 4; y = 12; height = 1; width = 2; hint = "Uso de transformações e \\move para criar uma transição linear, em vez de frame-por-frame."},
    sortd     = { class = "dropdown"; name = "sortd"; hint = "Ordenar linhas por"; value = "Default"; items = {"Default", "Tempo"};
                  x = 5; y = 5; width = 4; height = 1; hint = "A fim de ordenar as linhas após terem sido rastreadas (tracked)."}, 
    sortlabel = { class = "label"; name = "sortlabel"; label = "      Método de Ordenação:";
                  x = 1; y = 5; width = 4; height = 1;},
  },
  clip = {
    clippath = { class = "textbox"; name = "clippath"; hint = "Colar dados ou introduzir o caminho do ficheiro que o contenha. Sem aspas ou \.";
                 x = 0; y = 1; height = 4; width = 10;},
    label    = { class = "label"; label = "                 Colar dados ou introduzir um caminho de ficheiros.";
                 x = 0; y = 0; height = 1; width = 10;},
    xpos     = { class = "checkbox"; name = "xpos"; value = true; label = "x";
                  x = 0; y = 6; height = 1; width = 1; hint = "Aplicar dados da posição de x nas linhas seleccionadas."},
    ypos     = { class = "checkbox"; name = "ypos"; value = true; label = "y";
                  x = 1; y = 6; height = 1; width = 1; hint = "Aplicar dados da posição de y nas linhas seleccionadas."},
    scale    = { class = "checkbox"; name = "scale"; value = true; label = "Tamanho (Scale)";
                 x = 0; y = 7; height = 1; width = 2;},
    rotation = { class = "checkbox"; name = "rotation"; value = false; label = "Rotação";
                 x = 0; y = 8; height = 1; width = 3;},
    relative = { class = "checkbox"; name = "relative"; value = true; label = "Proporcional (Relative)";
                  x = 4; y = 6; height = 1; width = 3;},
    stframe  = { class = "intedit"; name = "stframe"; value = 1;
                  x = 7; y = 6; height = 1; width = 3;},
  }
}

--[[ Set up encoder presets. ]]--
encpre = {
x264    = '"#{encbin}" --crf 16 --tune fastdecode -i 250 --fps 23.976 --sar 1:1 --index "#{prefix}#{index}.index" --seek #{startf} --frames #{lenf} -o "#{prefix}#{output}[#{startf}-#{endf}].mp4" "#{inpath}#{input}"',
ffmpeg  = '"#{encbin}" -ss #{startt} -t #{lent} -sn -i "#{inpath}#{input}" "#{prefix}#{output}[#{startf}-#{endf}]-%%05d.jpg"',
avs2yuv = 'echo FFVideoSource("#{inpath}#{input}",cachefile="#{prefix}#{index}.index").trim(#{startf},#{endf}).ConvertToRGB.ImageWriter("#{prefix}#{output}-[#{startf}-#{endf}]\\",type="png").ConvertToYV12 > "#{prefix}encode.avs"#{nl}mkdir "#{prefix}#{output}-[#{startf}-#{endf}]"#{nl}"#{encbin}" -o NUL "#{prefix}encode.avs"#{nl}del "#{prefix}encode.avs"',
}

--[[ Set up a table of global options. Defaults included. ]]--
global = {
  prefix   = "?video",
  encoder  = "x264", -- todo: move to trim options
  encbin   = "",     -- same
  gui_trim = true,   -- same
  autocopy = true,
  acfilter = true,
  delsourc = false, 
}
--[[ Set encoding command default based on preset. ]]--
global.enccom = encpre[global.encoder] or ""

--[[ Copy the main GUI with some modifications for the config GUI.
     Helps to lower the amount of code duplication (???) ]]--
gui.conf = table.copy_deep(gui.main)
gui.conf.clippath, gui.conf.linespath, gui.conf.wconfig = nil
gui.conf.encbin, gui.conf.pref = table.copy(gui.conf.pref), nil
gui.conf.encbin.value, gui.conf.encbin.name = global.encbin, "encbin"
gui.conf.encbin.hint = "Caminho completo até ao binário do encoder (a não ser que esteja no teu directório)"
gui.conf.datalabel.label = "       Introduza aqui o caminho para o seu prefixo(incluir barra invertida)."
gui.conf.preflabel.label = "Primeira caixa: caminho para o binário do encoder; Segunda caixa: comandos para o encode."
gui.conf.gui_trim = { class = "checkbox"; value = global.gui_trim; label = "Activar GUI dos Trim"; name = "gui_trim";
                    x = 3; y = 22; height = 1; width = 4; hint = "Activar ou Desactivar a exibição dos Trim na GUI."}
gui.conf.enccom   = { class = "textbox"; value = global.enccom; name = "enccom";
                    x = 0; y = 17; height = 4; width = 10; hint = "Os comandos de encode que serão usados. Se alterares isto, coloque o preset a \"Personalizado\"."}
gui.conf.prefix   = { class = "textbox"; value = global.prefix; name = "prefix";
                    x = 0; y = 1; height = 4; width = 10; hint = "A pasta para onde todos os ficheiros gerados serão guardados."}
gui.conf.encoder  = { class = "dropdown"; value = global.encoder; name = "encoder"; items = {"x264", "ffmpeg", "avs2yuv", "Personalizado"};
                    x = 0; y = 11; height = 1; width = 2; hint = "Escolha um dos encoders da lista (coloque a Personalizado se fizeste alguma modificação aos valores pré-definidos)"}
gui.conf.delsourc = { class = "checkbox"; value = global.delsourc; label = "Apagar"; name = "delsourc";
                    x = 0; y = 21; height = 1; width = 2; hint = "Apaga as linhas originais em vez de as colocar como comentários."}
gui.conf.autocopy = { class = "checkbox"; value = global.autocopy; label = "Copiar Automaticamente"; name = "autocopy";
                    x = 3; y = 21; height = 1; width = 3; hint = "Copia automaticamente o conteúdo do clipboard para a caixa de 'motion-track' aquando da execução do script."}
gui.conf.acfilter = { class = "checkbox"; value = global.acfilter; label = "Copiar Filtro"; name = "acfilter";
                    x = 7; y = 21; height = 1; width = 3; hint = "Apenas copia automaticamente o clipboard se aparentemente contiver dados de 'motion-track'."}

--[[ A table of all override tags that can be looped through.
     For detecting dupes in cleanup. ]]--
alltags = {
  ['xscl']  = "\\fscx([%d%.]+)",
  ['yscl']  = "\\fscy([%d%.]+)",
  ['ali']   = "\\an([1-9])",
  ['zrot']  = "\\frz?([%-%d%.]+)",
  ['bord']  = "\\bord([%d%.]+)",
  ['xbord'] = "\\xbord([%d%.]+)",
  ['ybord'] = "\\ybord([%d%.]+)",
  ['shad']  = "\\shad([%-%d%.]+)",
  ['xshad'] = "\\xshad([%-%d%.]+)",
  ['yshad'] = "\\yshad([%-%d%.]+)",
  ['reset'] = "\\r([^\\}]*)",
  ['alpha'] = "\\alpha&H(%x%x)&",
  ['l1a']   = "\\1a&H(%x%x)&",
  ['l2a']   = "\\2a&H(%x%x)&",
  ['l3a']   = "\\3a&H(%x%x)&",
  ['l4a']   = "\\4a&H(%x%x)&",
  ['l1c']   = "\\c&H(%x+)&",
  ['l1c2']  = "\\1c&H(%x+)&",
  ['l2c']   = "\\2c&H(%x+)&",
  ['l3c']   = "\\3c&H(%x+)&",
  ['l4c']   = "\\4c&H(%x+)&",
  ['clip']  = "\\clip%((.-)%)",
  ['iclip'] = "\\iclip%((.-)%)",
  ['be']    = "\\be([%d%.]+)",
  ['blur']  = "\\blur([%d%.]+)",
  ['fax']   = "\\fax([%-%d%.]+)",
  ['fay']   = "\\fay([%-%d%.]+)"
}

--[[ This is a rather messy table of tags that is used to verify that
     style defaults are inserted at the beginning the selected line(s)
     if the corresponding options are selected. The structure is:
     [tag] = {{"opt1","opt2"}, "style key", don't write}
     where "opt1" and "opt2" are the options that both must be true,
     "style key" is the key to get the style value, and
     don't write specifies not to write the tag if the style default is that value. ]]--
importanttags = { -- scale_x, scale_y, outline, shadow, angle
  ['\\fscx'] = {{"scale","scale"}, "scale_x", 0};
  ['\\fscy'] = {{"scale","scale"}, "scale_y", 0};
  ['\\bord'] = {{"border","scale"}, "outline", 0};
  ['\\shad'] = {{"shadow","scale"}, "shadow", 0};
  ['\\frz']  = {{"rotation","rotation"}, "angle"};
}

--[[ A table of config keys whose values should be written to the
     configurtion file. structure is [header] = {keys...} ]]--
guiconf = {
  main = {
    "sortd",
    "xpos", "ypos", "origin", "clip", "posround",
    "scale", "border", "shadow", "blur", "sclround",
    "rotation", "rotround",
    "relative", "stframe",
    "vsfscale", "linear", --"export",
  },
  clip = {
    "xpos", "ypos", "scale", "rotation",
    "relative","stframe",
  },
}

--[[ Stick the global config keys in the above table. ]]--
for k,v in pairs(global) do table.insert(guiconf,k) end

--[[ Functions for more easily handling angles specified in degrees ]]--
function dcos(a) return math.cos(math.rad(a)) end
function dacos(a) return math.deg(math.acos(a)) end
function dsin(a) return math.sin(math.rad(a)) end
function dasin(a) return math.deg(math.asin(a)) end
function dtan(a) return math.tan(math.rad(a)) end
function datan(y,x) return math.deg(math.atan2(y,x)) end

--[[ Functions for giving the default position of a line, given its alignment
     and margins. ]]--
fix = {
  xpos = {
    function(sx,l,r) return sx-r end;
    function(sx,l,r) return l    end;
    function(sx,l,r) return sx/2 end;
  },
  ypos = {
    function(sy,v) return sy-v end;
    function(sy,v) return sy/2 end;
    function(sy,v) return v    end;
  },
}

function readconf(conf,guitab)
  local valtab = {}
  aegisub.log(5,"A abrir ficheiro de configuração: %s\n",conf)
  local cf = io.open(conf,'r')
  if cf then
    aegisub.log(5,"A ler ficheiro de configuração...\n")
    local thesection
    for line in cf:lines() do
      local section = line:match("#(%w+)")
      if section then
        valtab[section] = {}
        thesection = section
        aegisub.log(5,"Secção: %s\n",thesection)
      elseif thesection == nil then
        return nil
      else
        local key, val = line:splitconf()
        aegisub.log(5,"Leitura: %s -> %s\n", key, tostring(val:tobool()))
        valtab[thesection][key:gsub("^ +","")] = val:tobool()
      end
    end
    cf:close()
    convertfromconf(valtab,guitab)
    return true
  else
    return nil
  end
end

function convertfromconf(valtab,guitab)
  --aegisub.log(5,"%s\n",table.tostring(guitab))
  for section,sectab in pairs(guitab) do
    for ident,value in pairs(valtab[section]) do
      if section == "global" then
        aegisub.log(5,"Definido: global.%s = %s (%s)\n",ident,tostring(value),type(value))
        sectab[ident] = value
      else
        if sectab[ident] then
          aegisub.log(5,"Definido: gui.%s.%s = %s (%s)\n",section,ident,tostring(value),type(value))
          sectab[ident].value = value
        end
      end
    end
  end
end

function writeconf(conf,optab)
  local cf = io.open(conf,'w+')
  if not cf then 
    aegisub.log(0,'Escrita das configurações falhou! Verifique se %s existe e se tem permissões de escrita.\n',cf)
    return nil
  end
  local configlines = {}
  for section,tab in pairs(optab) do
    table.insert(configlines,("#%s\n"):format(section))
    if section == "global" then
      for ident,value in pairs(tab) do
        table.insert(configlines,("  %s:%s\n"):format(ident,tostring(value)))
      end
    else
      for i, field in ipairs(guiconf[section]) do
        if tab[field] ~= nil then -- (e.g. when clipconf == {}, don't overwrite all the config with "nil")
          table.insert(configlines,("  %s:%s\n"):format(field,tostring(tab[field])))
        end
      end
    end
  end
  for i,v in ipairs(configlines) do
    aegisub.log(5,"Escrita: %s -> config\n",v:gsub("^ +",""))
    cf:write(v)
  end
  cf:close()
  aegisub.log(5,"Configuração guardada em %s\n",conf)
  return true
end

function configscope()
  local cf
  if tostring(config_file):match("^[A-Z]:\\") or tostring(config_file):match("^/") or not config_file then
    return config_file
  else
    cf = io.open(dcp("?script/"..config_file))
    if not cf then
      cf = dcp("?user/"..config_file)
    else
      cf:close()
      cf = dcp("?script/"..config_file)
    end
    return cf
  end
end

function string:splitconf()
  local line = self:gsub("[\r\n]*","")
  return line:match("^(.-):(.*)$")
end

function string:tobool()
  local bool = ({['true'] = true, ['false'] = false})[self]
  if bool ~= nil then return bool
    else return self; end
end

function preprocessing(sub, sel)
  for i,v in ipairs(sel) do
    local line = sub[v]
    local a = line.text:match("%{(.-)%}")
    if a then
      local length = line.end_time - line.start_time
      local function fadrep(a,b)
        a, b = tonumber(a), tonumber(b)
        local str = ""
        if a > 0 then str = str..string.format("\\alpha&HFF&\\t(%d,%d,1,\\alpha&H00&)",0,a) end -- there are a bunch of edge cases for which this won't work, I think
        if b > 0 then str = str..string.format("\\t(%d,%d,1,\\alpha&HFF&)",length-b,length) end
        return str
      end
      line.text = line.text:gsub("\\fad%(([%d]+),([%d]+)%)",fadrep)
      local function faderep(a,b,c,d,e,f,g)
        a,b,c,d,e,f,g = tonumber(a),tonumber(b),tonumber(c),tonumber(d),tonumber(e),tonumber(f),tonumber(g)
        return string.format("\\alpha&H%02X&\\t(%d,%d,1,\\alpha&H%02X&)\\t(%d,%d,1,\\alpha&H%02X&)",a,d,e,b,f,g,c)
      end
      line.text:gsub("\\fade%(([%d]+),([%d]+),([%d]+),([%-%d]+),([%-%d]+),([%-%d]+),([%-%d]+)%)",faderep)
    end
    sub[v] = line -- replace
  end
  return information(sub,sel) -- selected line numbers are the same
end

function getinfo(line)
  line.trans = {}
  for a in line.text:gmatch("%{(.-)}") do
    aegisub.log(5,"Encontrado bloco de comentário/sobreposição na linha %d: %s\n",line.hnum,a)
    local function cconv(a,b,c,d,e)
      line.clips = a
      line.clip = string.format("m %d %d l %d %d %d %d %d %d",b,c,d,c,d,e,b,e)
    end
    a:gsub("\\(i?clip)%(([%-%d]+),([%-%d]+),([%-%d]+),([%-%d]+)%)",cconv,1) -- hum
    if not line.clip then
      line.clips, line.sclip, line.clip = a:match("\\(i?clip)%(([%d]*),?(.-)%)")
    end
    if line.clip then
      line.sclip = tonumber(line.sclip) or false
      if line.sclip then line.rescaleclip = true else line.rescaleclip = false; line.sclip = 1 end
      aegisub.log(0,tostring(line.rescaleclip)..'\n')
      aegisub.log(5,"Clip: \\%s(%s,%s)\n",line.clips,line.sclip,line.clip)
    end -- because otherwise it crashes!
    for c in a:gmatch("\\t(%b())") do -- this will return an empty string for t_exp if no exponential factor is specified
      t_start,t_end,t_exp,t_eff = c:sub(2,-2):match("([%-%d]+),([%-%d]+),([%d%.]*),?(.+)")
      t_exp = tonumber(t_exp) or 1 -- set to 1 if unspecified
      table.insert(line.trans,{tonumber(t_start),tonumber(t_end),tonumber(t_exp),t_eff})
      aegisub.log(5,"Linha %d: \\t(%g,%g,%g,%s) encontrado\n",line.hnum,t_start,t_end,t_exp,t_eff)
    end
  end
end

function information(sub, sel)
  printmem("Initial")
  local strt
  for x = 1,#sub do -- so if there are like 10000 different styles then this is probably a really bad idea but I DON'T GIVE A FUCK
    if sub[x].class == "dialogue" then -- BECAUSE I SAID SO
      strt = x-1 -- start line of dialogue subs
      break
    end
  end
  aegisub.progress.title("A Recolher Gajas Boas")
  local accd = {}
  local _ = nil
  accd.meta, accd.styles = karaskel.collect_head(sub, false) -- dump everything I need later into the table so I don't have to pass o9k variables to the other functions
  accd.lines = {}
  accd.endframe = aegisub.frame_from_ms(sub[sel[1]].end_time) -- get the end frame of the first selected line
  accd.startframe = aegisub.frame_from_ms(sub[sel[1]].start_time) -- get the start frame of the first selected line
  local numlines = #sel
  for i = #sel,1,-1 do -- burning cpu cycles like they were no thing
    local opline = sub[sel[i]] -- these are different.
    opline.num = sel[i] -- for inserting lines later
    opline.hnum = opline.num-strt -- humanized number
    karaskel.preproc_line(sub, accd.meta, accd.styles, opline) -- get linewidth/height and margins
    if not opline.effect then opline.effect = "" end
    getinfo(opline)
    opline.startframe, opline.endframe = aegisub.frame_from_ms(opline.start_time), aegisub.frame_from_ms(opline.end_time)
    if opline.comment then opline.is_comment = true else opline.is_comment = false end
    if opline.startframe < accd.startframe then -- make timings flexible. Number of frames total has to match the tracked data but
      aegisub.log(5,"Linha %d: frame de entrada alterou-se de %d para %d\n",opline.num-strt,accd.startframe,opline.startframe)
      accd.startframe = opline.startframe
    end
    if opline.endframe > accd.endframe then -- individual lines can be shorter than the whole scene
      aegisub.log(5,"Linha %d: frame de saída alterou-se de %d para %d\n",opline.num-strt,accd.endframe,opline.endframe)
      accd.endframe = opline.endframe
    end
    if opline.endframe-opline.startframe>1 then
      table.insert(accd.lines,opline)
    end
  end
  local length = #accd.lines
  accd.totframes = accd.endframe - accd.startframe
  assert(#accd.lines>0,"Tens de escolher pelo menos uma linha de duração superior a uma frame.") -- pro error checking
  printmem("Fim do ciclo de repetição preproc")
  return accd
end

function init_input(sub,sel) -- THIS IS PROPRIETARY CODE YOU CANNOT LOOK AT IT
  local setundo = aegisub.set_undo_point
  aegisub.progress.title("A Seleccionar Gajas Boas")
  gui.main.linespath.value = "" -- clear it out
  local accd = preprocessing(sub,sel)
  gui.main.stframe.min = -accd.totframes; gui.main.stframe.max = accd.totframes;
  gui.clip.stframe.min = -accd.totframes; gui.clip.stframe.max = accd.totframes;
  local conf = configscope()
  if conf then
    if not readconf(conf,{ ['main'] = gui.main; ['clip'] = gui.clip; ['global'] = global }) then aegisub.log(0,"Failed to read config!\n") end
  end
  if global.autocopy then
    local paste = clipboard.get() or "" -- if nothing on the clipboard then returns nil
    if global.acfilter then
      if paste:match("^Adobe After Effects 6.0 Keyframe Data") then
        gui.main.linespath.value = paste
      end
    else
      gui.main.linespath.value = paste
    end
  end
  gui.main.pref.value = dcp(global.prefix)
  printmem("GUI startup")
  local button, config = aegisub.dialog.display(gui.main, {"Aplicar","Clip...","Fechar"})
  local clipconf
  if button == "Clip..." then
    button, clipconf = aegisub.dialog.display(gui.clip, {"Aplicar","Cancelar","Fechar"})
  end
  if button == "Aplicar" then
    local clipconf = clipconf or {} -- solve indexing errors
    for i,field in ipairs(guiconf.clip) do
      if clipconf[field] == nil then clipconf[field] = gui.clip[field].value end
    end
    if config.linespath == "" then config.linespath = false end
    if config.wconfig then
      writeconf(conf,{ ['main'] = config; ['clip'] = clipconf; ['global'] = global })
    end
    if config.stframe == 0 then config.stframe = 1 end -- TODO: fix this horrible clusterfuck
    if clipconf.stframe == 0 then clipconf.stframe = 1 end
    if config.xpos or config.ypos then config.position = true end
    config.yconst = not config.ypos; config.xconst = not config.xpos
    if clipconf.xpos or clipconf.ypos then clipconf.position = true end
    clipconf.yconst = not clipconf.ypos; clipconf.xconst = not clipconf.xpos -- TODO: remove unnecessary logic inversion
    if clipconf.clippath == "" or clipconf.clippath == nil then
      if not config.linespath then windowerr(false,"Nenhum dado de 'motion-track' foi fornecido.") end
      clipconf.clippath = false
    else config.clip = false end -- set clip to false if clippath exists
    if config.clip then clipconf.stframe = config.stframe; config.linear = false end
    if clipconf.clippath then config.linear = false end
    aegisub.progress.title("A Afectar Gajas Boas")
    printmem("Aplicar")
    local newsel = frame_by_frame(sub,accd,config,clipconf)
    if munch(sub,newsel) then
      newsel = {}
      for x = 1,#sub do
        if tostring(sub[x].effect):match("^aa%-mou") then
          table.insert(newsel,x)
        end
      end
    end
    aegisub.progress.title("A Reformatar Gajas Boas")
    cleanup(sub,newsel,config)
  elseif button == "Cancelar" then
    init_input(sub,sel) -- this is extremely unideal as it reruns all of the information gathering functions as well.
  else
    aegisub.progress.task("FECHAR")
    aegisub.cancel()
  end
  setundo("Motion Data")
  printmem("A Fechar...")
end

function parse_input(mocha_table,input,shx,shy)
  printmem("A tratados dos dados de entrada...")
  local ftab = {}
  local sect, care = 0, 0
  mocha_table.xpos, mocha_table.ypos, mocha_table.xscl, mocha_table.yscl, mocha_table.zrot = {}, {}, {}, {}, {}
  local datams = io.open(input,"r") -- a terrible idea? Doesn't seem to be so far.
  local datastring = ""
  if datams then
    for line in datams:lines() do
      line = line:gsub("[\r\n]*","") -- FUCK YOU CRLF
      datastring = datastring..line.."\n"
      table.insert(ftab,line) -- dump the lines from the file into a table.
    end 
    datams:close()
  else
    input = input:gsub("[\r]*","") -- SERIOUSLY FUCK THIS SHIT
    datastring = input
    ftab = input:split("\n")
  end
  for _,pattern in ipairs({"Posição","Escala","Rotação","Largura da Source\t%d+","Altura da Source\t%d+","Adobe After Effects 6.0 Keyframe Data"}) do
    windowerr(datastring:match(pattern),'Erro a correr os dados. Era esperado "After Effects Transform Data [anchor point, position, scale and rotation]".')
  end
  local sw = datastring:match("Largura da Source\t([0-9]+)")
  local sh = datastring:match("Altura da Source\t([0-9]+)")
  local xmult = shx/tonumber(sw)
  local ymult = shy/tonumber(sh)
  for keys, valu in ipairs(ftab) do -- idk it might be more flexible now or something
    if not valu:match("^\t") then
      if valu == "Posição" then
        sect = 1
      elseif valu == "Escala" then
        sect = sect + 2
      elseif valu == "Rotação" then
        sect = sect + 4
      else
      end
    else
      if sect == 1 then
        if valu:match("%d") then
          val = valu:split("\t")
          table.insert(mocha_table.xpos,tonumber(val[2])*xmult)
          table.insert(mocha_table.ypos,tonumber(val[3])*ymult)
        end
      elseif sect == 3 then
        if valu:match("%d") then
          val = valu:split("\t")
          table.insert(mocha_table.xscl,tonumber(val[2]))
          table.insert(mocha_table.yscl,tonumber(val[3]))
        end
      elseif sect == 7 then
        if valu:match("%d") then
          val = valu:split("\t")
          table.insert(mocha_table.zrot,-tonumber(val[2]))
        end
      end
    end
  end
  mocha_table.flength = #mocha_table.xpos
  windowerr(mocha_table.flength == #mocha_table.ypos and mocha_table.flength == #mocha_table.xscl and mocha_table.flength == #mocha_table.yscl and mocha_table.flength == #mocha_table.zrot,'Error parsing data. "After Effects Transform Data [anchor point, position, scale and rotation]" expected.')
  for prefix,field in pairs({x = "xpos", y = "ypos", xs = "xscl", ys = "yscl", r = "zrot"}) do
    local dummytab = table.copy(mocha_table[field])
    table.sort(dummytab)
    mocha_table[prefix.."max"], mocha_table[prefix.."min"] = dummytab[#dummytab], dummytab[1]
    aegisub.log(5,"%smax: %g; %smin: %g\n",prefix,mocha_table[prefix.."max"],prefix,mocha_table[prefix.."min"])
  end
  printmem("Fim do tratamento dos dados de entrada!")
end

function windowerr(bool, message)
  if not bool then
    aegisub.dialog.display({{class="label", label=message}},{"ok"})
    error(message)
  end
end

function spoof_table(parsed_table,opts,len)
  local len = len or #parsed_table.xpos
  parsed_table.xpos = parsed_table.xpos or {}
  parsed_table.ypos = parsed_table.ypos or {}
  parsed_table.xscl = parsed_table.xscl or {}
  parsed_table.yscl = parsed_table.yscl or {}
  parsed_table.zrot = parsed_table.zrot or {}
  if not opts.position then
    for k = 1,len do
      parsed_table.xpos[k] = 0
      parsed_table.ypos[k] = 0
    end
  else
    if opts.yconst then
      for k = 1,len do
        parsed_table.ypos[k] = 0
      end
    end
    if opts.xconst then
      for k = 1,len do
        parsed_table.xpos[k] = 0
      end
    end
  end
  if not opts.scale then
    for k = 1,len do
      parsed_table.xscl[k] = 100
      parsed_table.yscl[k] = 100
    end
  end
  if not opts.rotation then
    for k = 1,len do
      parsed_table.zrot[k] = 0
    end
  end
  parsed_table.s = 1
  if opts.reverse then parsed_table.s = parsed_table.flength end
end

function ensuretags(line,opts,styles,dim)
  if line.margin_v ~= 0 then line._v = line.margin_v else line._v = line.styleref.margin_v end
  if line.margin_l ~= 0 then line._l = line.margin_l else line._l = line.styleref.margin_l end
  if line.margin_r ~= 0 then line._r = line.margin_r else line._r = line.styleref.margin_r end
  line.ali = line.text:match("\\an([1-9])") or line.styleref.align
  line.xpos,line.ypos = line.text:match("\\pos%(([%-%d%.]+),([%-%d%.]+)%)")
  if not line.xpos then -- insert position into line if not present.
    line.xpos = fix.xpos[line.ali%3+1](dim.x,line._l,line._r)
    line.ypos = fix.ypos[math.ceil(line.ali/3)](dim.y,line._v)
    line.text = (("{\\pos(%d,%d)}"):format(line.xpos,line.ypos)..line.text):gsub("^({.-)}{","%1")
  end
  line.oxpos,line.oypos = line.text:match("\\org%(([%-%d%.]+),([%-%d%.]+)%)") or line.xpos,line.ypos
  line.origindx,line.origindy = line.xpos - line.oxpos, line.ypos - line.oypos 
  local mergedtext = line.text:gsub("}{","")
  local startblock = mergedtext:match("^{(.-)}")
  local block = ""
  if startblock then
    for tag, str in pairs(importanttags) do
      if opts[str[1][1]] and opts[str[1][2]] and not startblock:match(tag.."[%-%d%.]+") then
        if tonumber(line.styleref[str[2]]) ~= str[3] then 
          block = block..(tag.."%g"):format(line.styleref[str[2]])
        end
      end
    end
    if block:len() > 0 then
      line.text = ("{"..block.."}"..line.text):gsub("^({.-)}{","%1")
    end
  else
    for tag, str in pairs(importanttags) do
      if opts[str[1][1]] and opts[str[1][2]] then
        if tonumber(line.styleref[str[2]]) ~= str[3] then 
          block = block..(tag.."%g"):format(line.styleref[str[2]])
        end
      end
    end
    line.text = "{"..block.."}"..line.text
  end
  function resetti(before,rstyle,rest)
    local styletab = styles[rstyle] or line.styleref -- if \\r[stylename] is not a real style, reverts to regular \r
    local block = ""
    for tag, str in pairs(importanttags) do
      if opts[str[1][1]] and opts[str[1][2]] and not startblock:match(tag.."[%-%d%.]+") then
        if tonumber(line.styleref[str[2]]) ~= str[3] then 
          block = block..(tag.."%g"):format(styletab[str[2]])
        end
      end
    end
    return "{"..before..rstyle..block..rest.."}"
  end
  line.text = line.text:gsub("{([^}]*\\r)([^\\}]*)(.-)}",resetti)
end

function frame_by_frame(sub,accd,opts,clipopts)
  printmem("A Iniciar Ciclo de Repetição Principal")
  local dim = {x = accd.meta.res_x; y = accd.meta.res_y}
  local mocha = {}
  local clipa = {}
  if opts.linespath then
    parse_input(mocha,opts.linespath,accd.meta.res_x,accd.meta.res_y)
    assert(accd.totframes==mocha.flength,string.format("O número de frames seleccionadas (%d) não coincide com os dados de comprimento das linhas de 'motion-track' (%d).",accd.totframes,mocha.flength))
    spoof_table(mocha,opts)
    if not opts.relative then
      if opts.stframe < 0 then
        mocha.start = accd.totframes + opts.stframe + 1
      else
        mocha.start = opts.stframe
      end
    end
    if opts.clip then clipa = mocha end
  end
  if clipopts.clippath then
    parse_input(clipa,clipopts.clippath,accd.meta.res_x,accd.meta.res_y)
    assert(accd.totframes==clipa.flength,string.format("O número de frames seleccionadas (%d) não coincide com os dados de comprimento do clip de 'motion-track' (%d).",accd.totframes,clipa.flength))
    opts.linear = false -- no linear mode with moving clip, sorry
    opts.clip = true -- simplify things a bit
    spoof_table(clipa,clipopts)
    if not opts.linespath then spoof_table(mocha,opts,#clipa.xpos) end
    if not clipopts.relative then
      if clipopts.stframe < 0 then
        clipa.start = accd.totframes + clipopts.stframe + 1
      else
        clipa.start = clipopts.stframe
      end
    end
  end
  for k,v in ipairs(accd.lines) do -- comment lines that were commented in the thingy
    local derp = sub[v.num]
    derp.comment = true
    sub[v.num] = derp
    if not v.is_comment then v.comment = false end
  end
  local _ = nil
  local newlines = {} -- table to stick indices of tracked lines into for cleanup.
  local operations = {} -- create a table and put the necessary functions into it, which will save a lot of if operations in the inner loop. This was the most elegant solution I came up with.
  if opts.position then
    operations["(\\pos)%(([%-%d%.]+,[%-%d%.]+)%)"] = possify
    if opts.origin then
      operations["(\\org)%(([%-%d%.]+,[%-%d%.]+)%)"] = orginate
    end
  end
  if opts.scale then
    if opts.vsfscale and not opts.linear then
      opts.sclround = 2
      operations["(\\fsc[xy])([%d%.]+)"] = VSscalify
    else
      operations["(\\fsc[xy])([%d%.]+)"] = scalify
    end
    if opts.border then
      operations["(\\[xy]?bord)([%d%.]+)"] = scalify
    end
    if opts.shadow then
      operations["(\\[xy]?shad)([%-%d%.]+)"] = scalify
    end
    if opts.blur then
      operations["(\\blur)([%d%.]+)"] = scalify
    end
  end
  if opts.rotation then
    operations["(\\frz?)([%-%d%.]+)"] = rotate
  end
  printmem("Fim da inserção nas tabelas")
  local function linearmodo(currline)
    local one = aegisub.ms_from_frame(aegisub.frame_from_ms(currline.start_time))
    local two = aegisub.ms_from_frame(aegisub.frame_from_ms(currline.start_time)+1)
    local red = currline.start_time
    local blue = currline.end_time
    local three = aegisub.ms_from_frame(aegisub.frame_from_ms(currline.end_time)-1)
    local four = aegisub.ms_from_frame(aegisub.frame_from_ms(currline.end_time))
    local maths = math.floor(one-red+(two-one)/2) -- this voodoo magic gets the time length (in ms) from the start of the first subtitle frame to the actual start of the line time.
    local mathsanswer = math.floor(blue-red+three-blue+(four-three)/2) -- and this voodoo magic is the total length of the line plus the difference (which is negative) between the start of the last frame the line is on and the end time of the line.
    local posmatch, _ = "(\\pos)%(([%-%d%.]+,[%-%d%.]+)%)"
    if operations[posmatch] then
      currline.text = currline.text:gsub(posmatch,function(tag,val)
        local exes, whys = {}, {}
        for i,x in pairs({currline.rstartf,currline.rendf}) do
          local cx,cy = val:match("([%-%d%.]+),([%-%d%.]+)")
          mocha.ratx = mocha.xscl[x]/mocha.xscl[mocha.start]
          mocha.raty = mocha.yscl[x]/mocha.yscl[mocha.start]
          mocha.xdiff = mocha.xpos[x]-mocha.xpos[mocha.start]
          mocha.ydiff = mocha.ypos[x]-mocha.ypos[mocha.start]
          mocha.zrotd = mocha.zrot[x]-mocha.zrot[mocha.start]
          mocha.currx,mocha.curry = mocha.xpos[x],mocha.ypos[x]
          cx,cy = makexypos(tonumber(cx),tonumber(cy),currline.alpha,mocha)
          table.insert(exes,round(cx,opts.posround)); table.insert(whys,round(cy,opts.posround))
        end
        local s = ("\\move(%g,%g,%g,%g,%d,%d)"):format(exes[1],whys[1],exes[2],whys[2],maths,mathsanswer)
        aegisub.log(5,"%s\n",s)
        return s
      end)
      _,operations[posmatch] = operations[posmatch],nil
    end
    for pattern,func in pairs(operations) do -- iterate through the necessary operations
      if aegisub.progress.is_cancelled() then error("User cancelled") end
      currline.text = currline.text:gsub(pattern,function(tag,val) 
        local values = {}
        for i,x in pairs({currline.rstartf,currline.rendf}) do
          mocha.ratx = mocha.xscl[x]/mocha.xscl[mocha.start]
          mocha.raty = mocha.yscl[x]/mocha.yscl[mocha.start]
          mocha.xdiff = mocha.xpos[x]-mocha.xpos[mocha.start]
          mocha.ydiff = mocha.ypos[x]-mocha.ypos[mocha.start]
          mocha.zrotd = mocha.zrot[x]-mocha.zrot[mocha.start]
          mocha.currx,mocha.curry = mocha.xpos[x],mocha.ypos[x]
          table.insert(values,func(val,currline,mocha,opts,tag))
        end
        return ("%s%g\\t(%d,%d,1,%s%g)"):format(tag,values[1],maths,mathsanswer,tag,values[2])
      end)
    end
    sub[currline.num] = currline
    operations[posmatch] = _
  end
  local function nonlinearmodo(currline)
    for x = currline.rendf,currline.rstartf,-1 do -- new inner loop structure
      printmem("Ciclo de Repetição Interno")
      aegisub.progress.title(string.format("A processar frame %g/%g",x,currline.rendf-currline.rstartf+1))
      aegisub.progress.set((x-currline.rstartf)/(currline.rendf-currline.rstartf)*100)
      if aegisub.progress.is_cancelled() then error("Cancelado pelo utilizador") end
      currline.start_time = aegisub.ms_from_frame(accd.startframe+x-1)
      currline.end_time = aegisub.ms_from_frame(accd.startframe+x)
      if not currline.is_comment then -- don't do any math for commented lines.
        currline.time_delta = currline.start_time - aegisub.ms_from_frame(accd.startframe)
        for vk,kv in ipairs(currline.trans) do
          if aegisub.progress.is_cancelled() then error("Cancelado pelo utilizador") end
          currline.text = transformate(currline,kv)
        end
        mocha.ratx = mocha.xscl[x]/mocha.xscl[mocha.start] -- DIVISION IS SLOW
        mocha.raty = mocha.yscl[x]/mocha.yscl[mocha.start]
        mocha.xdiff = mocha.xpos[x]-mocha.xpos[mocha.start]
        mocha.ydiff = mocha.ypos[x]-mocha.ypos[mocha.start]
        mocha.zrotd = mocha.zrot[x]-mocha.zrot[mocha.start]
        mocha.currx,mocha.curry = mocha.xpos[x],mocha.ypos[x]
        for pattern,func in pairs(operations) do -- iterate through the necessary operations
          if aegisub.progress.is_cancelled() then error("Cancelado pelo utilizador") end
          currline.text = currline.text:gsub(pattern,function(tag,val) return tag..func(val,currline,mocha,opts,tag) end)
        end
        if clipa.clipme then
          currline.text = currline.text:gsub("\\i?clip%b()",function(a) return clippinate(currline,clipa,x) end,1)
        end
        currline.text = currline.text:gsub('\1',"")
      end
      sub.insert(currline.num+1,currline)
      currline.text = currline.orgtext
    end
    if global.delsourc then sub.delete(currline.num) end
  end
  local how2proceed = nonlinearmodo
  if opts.linear then
    how2proceed = linearmodo
  end
  for i,currline in ipairs(accd.lines) do
    printmem("Outer loop")
    currline.rstartf = currline.startframe - accd.startframe + 1 -- start frame of line relative to start frame of tracked data
    currline.rendf = currline.endframe - accd.startframe -- end frame of line relative to start frame of tracked data
    if opts.clip and currline.clip then
      clipa.clipme = true
    end
    currline.effect = "aa-mou"..currline.effect
    if opts.relative then
      if opts.stframe < 0 then
        mocha.start = currline.rendf + opts.stframe + 1
      else
        mocha.start = currline.rstartf + opts.stframe - 1
      end
    end
    if clipopts.relative and clipa.clipme then
      if tonumber(clipopts.stframe) < 0 then
        clipa.start = currline.rendf + clipopts.stframe + 1
      else
        clipa.start = currline.rstartf + clipopts.stframe - 1
      end
    end
    ensuretags(currline,opts,accd.styles,dim)
    currline.alpha = -datan(currline.ypos-mocha.ypos[mocha.start],currline.xpos-mocha.xpos[mocha.start])
    if opts.origin then currline.beta = -datan(currline.oypos-mocha.ypos[mocha.start],currline.oxpos-mocha.xpos[mocha.start]) end
    currline.orgtext = currline.text -- tables are passed as references.
    how2proceed(currline)
  end
  for x = #sub,1,-1 do
    if tostring(sub[x].effect):match("^aa%-mou") then
      aegisub.log(5,"Escolho-te a ti, %d!\n",x)
      table.insert(newlines,x) -- seems to work as intended
    end
  end
  return newlines -- yeah mang
end

function possify(pos,line,mocha,opts)
  local oxpos,oypos = pos:match("([%-%d%.]+),([%-%d%.]+)")
  local xpos,ypos = makexypos(tonumber(oxpos),tonumber(oypos),line.alpha,mocha)
  aegisub.log(5,"pos: (%f,%f) -> (%f,%f)\n",oxpos,oypos,xpos,ypos)
  return ("(%g,%g)"):format(round(xpos,opts.posround),round(ypos,opts.posround))
end

function makexypos(xpos,ypos,alpha,mocha)
  local xpos = (xpos + mocha.xdiff)*mocha.ratx + (1 - mocha.ratx)*mocha.currx
  local ypos = (ypos + mocha.ydiff)*mocha.raty + (1 - mocha.raty)*mocha.curry
  local r = math.sqrt((xpos - mocha.currx)^2+(ypos - mocha.curry)^2)
  xpos = mocha.currx + r*dcos(alpha + mocha.zrotd)
  ypos = mocha.curry - r*dsin(alpha + mocha.zrotd)
  return xpos,ypos
end

function orginate(opos,line,mocha,opts) -- this will be changed.
  local oxpos,oypos = opos:match("([%-%d%.]+),([%-%d%.]+)")
  local xpos,ypos = makexypos(tonumber(oxpos),tonumber(oypos),line.alpha,mocha)
  aegisub.log(5,"org: (%f,%f) -> (%f,%f)\n",oxpos,oypos,xpos,ypos)
  return ("(%g,%g)"):format(round(xpos,opts.posround),round(ypos,opts.posround))
end

function clippinate(line,clipa,iter)
  local cx, cy = clipa.xpos[iter], clipa.ypos[iter]
  local ratx, raty = clipa.xscl[iter]/clipa.xscl[clipa.start], clipa.yscl[iter]/clipa.yscl[clipa.start]
  local diffrz = clipa.zrot[iter] - clipa.zrot[clipa.start]
  aegisub.log(5,"cx: %f cy: %f\n",cx,cy)
  aegisub.log(5,"rx: %f ry: %f\n",ratx,raty)
  aegisub.log(5,"frz: %f\n",diffrz)
  local sclfac = 2^(line.sclip-1)
  local clip = ""
  local function xy(x,y)
    local xo,yo = x,y
    x = (tonumber(x) - clipa.xpos[clipa.start]*sclfac)*ratx
    y = (tonumber(y) - clipa.ypos[clipa.start]*sclfac)*raty
    local r = math.sqrt(x^2+y^2)
    local alpha = datan(y,x)
    x = cx*sclfac + r*dcos(alpha-diffrz)
    y = cy*sclfac + r*dsin(alpha-diffrz)
    aegisub.log(5,"Clip: %d %d -> %d %d\n",xo,yo,x,y)
    if line.rescaleclip then
      x = x*1024/sclfac
      y = y*1024/sclfac
    end
    return string.format("%d %d",round(x),round(y))
  end
  clip = line.clip:gsub("([%.%d%-]+) ([%.%d%-]+)",xy)
  if line.rescaleclip then 
    clip = string.format("\\%s(11,%s)",line.clips,clip)
  else
    clip = string.format("\\%s(%s)",line.clips,clip)
  end
  return clip
end

function transformate(line,trans)
  local t_s = trans[1] - line.time_delta
  local t_e = trans[2] - line.time_delta
  aegisub.log(5,"Transformação: %d,%d -> %d,%d\n",trans[1],trans[2],t_s,t_e)
  return line.text:gsub("\\t%b()","\\"..sc(1)..string.format("t(%d,%d,%g,%s)",t_s,t_e,trans[3],trans[4]),1)
end

function scalify(scale,line,mocha,opts,tag)
  local newScale = scale*mocha.ratx -- sudden camelCase for no reason
  aegisub.log(5,"%s: %f -> %f\n",tag:sub(2),scale,newScale)
  return round(newScale,opts.sclround)
end

function VSscalify(scale,line,mocha,opts,tag)
  local newScale = round(scale*mocha.ratx,opts.sclround)
  local lowend, highend, decimal = math.floor(newScale),math.ceil(newScale),newScale%1*(10^opts.sclround)
  local start, send = -decimal, (10^opts.sclround)-decimal
  aegisub.log(5,"%s: %f -> %f\n",tag:sub(2),scale,newScale)
  return ("%d\\t(%d,%d,%s%d)"):format(lowend,start,send,tag,highend)
end

function rotate(rot,line,mocha,opts)
  local zrot = rot + mocha.zrotd
  aegisub.log(5,"frz: -> %f\n",zrot)
  return round(zrot,opts.rotround)
end

function munch(sub,sel)
  local changed = false
  for i,num in ipairs(sel) do
    if aegisub.progress.is_cancelled() then error("Cancelado pelo utilizador") end
    local l1 = sub[num-1]
    local l2 = sub[num]
    if l1.text == l2.text and l1.effect == l2.effect then
      l1.end_time = l2.end_time
      sub[num-1]=l1
      sub.delete(num)
      changed = true
    end
  end
  return changed
end

function cleanup(sub, sel, opts) -- make into its own macro eventually.
  opts = opts or {}
  local linediff
  local function cleantrans(cont) -- internal function because that's the only way to pass the line difference to it
    local t_s, t_e, ex, eff = cont:sub(2,-2):match("([%-%d]+),([%-%d]+),([%d%.]*),?(.+)")
    if tonumber(t_e) <= 0 then return string.format("%s",eff) end -- if the end time is less than or equal to zero, the transformation has finished. Replace it with only its contents.
    if tonumber(t_s) > linediff or tonumber(t_e) < tonumber(t_s) then return "" end -- if the start time is greater than the length of the line, the transform has not yet started, and can be removed from the line.
    if tonumber(ex) == 1 or ex == "" then return string.format("\\t(%s,%s,%s)",t_s,t_e,eff) end -- if the exponential factor is equal to 1 or isn't there, remove it (just makes it look cleaner)
    return string.format("\\t(%s,%s,%s,%s)",t_s,t_e,ex,eff) -- otherwise, return an untouched transform.
  end
  local ns = {}
  for i, v in ipairs(sel) do
    aegisub.progress.title(string.format("Castrar Paneleiros: %d/%d",i,#sel))
    local lnum = sel[#sel-i+1]
    local line = sub[lnum] -- iterate backwards (makes line deletion sane)
    linediff = line.end_time - line.start_time
    line.text = line.text:gsub("}"..sc(6).."{","") -- merge sequential override blocks if they are marked as being the ones we wrote
    line.text = line.text:gsub(sc(6),"") -- remove superfluous marker characters for when there is no override block at the beginning of the original line
    line.text = line.text:gsub("\\t(%b())",cleantrans) -- clean up transformations (remove transformations that have completed)
    line.text = line.text:gsub("{}","") -- I think this is irrelevant. But whatever.
    for a in line.text:gmatch("{(.-)}") do
      aegisub.progress.set(math.random(100)) -- professional progress bars
      local transforms = {}
      line.text = line.text:gsub("\\(i?clip)%(1,m","\\%1(m")
      a = a:gsub("(\\t%b())", function(transform)
          aegisub.log(5,"Limpeza: %s encontrados\n",transform)
          table.insert(transforms,transform)
          return sc(3)
        end)
      for k,v in pairs(alltags) do
        local _, num = a:gsub(v,"")
        --aegisub.log(5,"v: %s, num: %s, a: %s\n",v,num,a)
        a = a:gsub(v,"",num-1)
      end
      for i,trans in ipairs(transforms) do
        a = a:gsub(sc(3),trans,1)
      end
      line.text = line.text:gsub("{.-}",sc(1)..a..sc(2),1) -- I think...
    end
    line.text = line.text:gsub(sc(1),"{")
    line.text = line.text:gsub(sc(2),"}")
    line.effect = line.effect:gsub("aa%-mou","",1)
    sub[lnum] = line
  end
  if opts.sortd ~= "Default" then
    sel = dialog_sort(sub, sel, opts.sortd)
  end
end

function dialog_sort(sub, sel, sor)
  local function compare(a,b)
    if a.key == b.key then
      return a.num < b.num -- solve the disorganized sort problem.
    else
      return a.key < b.key
    end
  end -- local because why not?
  local sortF = ({
    ['Time']   = function(l,n) return { key = l.start_time, num = n, data = l } end;
    ['Actor']  = function(l,n) return { key = l.actor,  num = n, data = l } end;
    ['Effect'] = function(l,n) return { key = l.effect, num = n, data = l } end;
    ['Style']  = function(l,n) return { key = l.style,  num = n, data = l } end;
    ['Layer']  = function(l,n) return { key = l.layer,  num = n, data = l } end; 
  })[sor] -- thanks, tophf
  local lines = {}
  for i,v in ipairs(sel) do
    if aegisub.progress.is_cancelled() then error("Cancelado pelo utilizador") end -- should probably put these in every loop
    local line = sub[v]
    table.insert(lines,sortF(line,v))
  end
  local strt = sel[1] -- not strictly necessary
  table.sort(lines, compare)
  for i, v in ipairs(sel) do
    if aegisub.progress.is_cancelled() then error("Cancelado pelo utilizador") end
    sub.delete(sel[#sel-i+1]) -- BALEET (in reverse because they are not necessarily contiguous)
  end
  sel = {}
  for i, v in ipairs(lines) do
    if aegisub.progress.is_cancelled() then error("Cancelado pelo utilizador") end
    aegisub.progress.title(string.format("Ordenar Gajas Boas: %d/%d",i,#lines))
    aegisub.progress.set(i/#lines*100) 
    aegisub.log(5,"Chave: "..v.key..'\n')
    table.insert(sel,strt+i-1)
    sub.insert(strt+i-1,v.data) -- not sure this is the best place to do this but owell
  end
  return sel
end

function printmem(a)
  aegisub.log(5,"%s memória em uso: %gkB\n",tostring(a),collectgarbage("count"))
end

function round(num, idp) -- borrowed from the lua-users wiki (all of the intelligent code you see in here is)
  local mult = 10^(idp or 0)
  return math.floor(num * mult + 0.5) / mult
end

function string:split(sep) -- borrowed from the lua-users wiki (single character split ONLY)
  local sep, fields = sep or ":", {}
  local pattern = string.format("([^%s]+)", sep)
  self:gsub(pattern, function(c) fields[#fields+1] = c end)
  return fields
end

function table.tostring(t)
  if type(t) ~= 'table' then
    return tostring(t)
  else
    local s = ''
    local i = 1
    while t[i] ~= nil do
      if #s ~= 0 then s = s..', ' end
      s = s..table.tostring(t[i])
      i = i+1
    end
    for k, v in pairs(t) do
      if type(k) ~= 'number' or k > i then
        if #s ~= 0 then s = s..', ' end
        local key = type(k) == 'string' and k or '['..table.tostring(k)..']'
        s = s..key..'='..table.tostring(v)
      end
    end
    return '{'..s..'}'
  end
end

function isvideo() -- a very rudimentary (but hopefully efficient) check to see if there is a video loaded.
  local l = aegisub.video_size() and true or false -- and forces boolean conversion?
  if l then
    return l
  else
    return l,"Validação falhada: não tens nenhum vídeo carregado."
  end
end

aegisub.register_macro("Motion-Tracking - Aplicar", "Aplica às linhas seleccionadas dados propriamente formatados de 'motion-track'.", init_input, isvideo)

function confmaker()
  local valtab = {}
  local conf = configscope()
  if not readconf(conf,{ ['main'] = gui.conf; ['clip'] = gui.clip; ['global'] = global }) then aegisub.log(0,"Config read failed!\n") end
  for key, value in pairs(global) do
    if gui.conf[key] then gui.conf[key].value = value end
  end
  gui.conf.enccom.value = encpre[global.encoder] or gui.conf.enccom.value
  local button, config = aegisub.dialog.display(gui.conf,{"Guardar","Guardar local","Clip...","Fechar"})
  local clipconf
  if button == "Clip..." then
    button, clipconf = aegisub.dialog.display(gui.clip,{"Guardar","Guardar local","Cancelar","Fechar"})
  end
  if tostring(button):match("Guardar") then
    local clipconf = clipconf or {}
    if button == "Guardar local" then conf = dcp("?script/"..config_file) end
    if global.encoder ~= config.encoder then
      config.enccom = encpre[config.encoder] or config.enccom
    end
    for key,value in pairs(global) do
      global[key] = config[key]
      config[key] = nil
    end
    for i,field in ipairs(guiconf.clip) do
      if clipconf[field] == nil then clipconf[field] = gui.clip[field].value end
    end 
    writeconf(conf,{ ['main'] = config; ['clip'] = clipconf; ['global'] = global })
  elseif button == "Cancelar" then
    confmaker()
  else
    aegisub.cancel()
  end
end

if config_file then aegisub.register_macro("Motion-Tracking - Configuração", "Painel de Configuração.", confmaker) end

gui.t = {
  vidlabel = { class = "label"; label = "O caminho para o vídeo carregado";
               x = 0; y = 0; height = 1; width = 30;},
  input    = { class = "textbox"; name = "input";
               x = 0; y = 1; height = 1; width = 30;},
  idxlabel = { class = "label"; label = "O caminho para o ficheiro de index.";
               x = 0; y = 2; height = 1; width = 30;},
  index    = { class = "textbox"; name = "index";
               x = 0; y = 3; height = 1; width = 30;},
  sflabel  = { class = "label"; label = "Frame de entrada";
               x = 0; y = 4; height = 1; width = 15;},
  startf   = { class = "intedit"; name = "startf";
               x = 0; y = 5; height = 1; width = 15;},
  eflabel  = { class = "label"; label = "Framde de saída";
               x = 15; y = 4; height = 1; width = 15;},
  endf     = { class = "intedit"; name = "endf";
               x = 15; y = 5; height = 1; width = 15;},
  oplabel  = { class = "label"; label = "Ficheiro de vídeo a ser criado";
               x = 0; y = 6; height = 1; width = 30;},
  output   = { class = "textbox"; name = "output";
               x = 0; y = 7; height = 1; width = 30;},
}

function collecttrim(sub,sel,tokens)
  tokens.startt, tokens.endt = sub[sel[1]].start_time, sub[sel[1]].end_time
  for i,v in ipairs(sel) do
    local l = sub[v]
    local lst, let = l.start_time, l.end_time
    if lst < tokens.startt then tokens.startt = lst end
    if let > tokens.endt then tokens.endt = let end
  end
  tokens.startf, tokens.endf = aegisub.frame_from_ms(tokens.startt), aegisub.frame_from_ms(tokens.endt)-1
  tokens.lenf = tokens.endf-tokens.startf+1
  tokens.lent = tokens.endt-tokens.startt
end
-- #{encbin} #{input} #{prefix} #{index} #{output} #{startf} #{lenf} #{endf} #{startt} #{lent} #{endt} #{nl}
function getvideoname(sub)
  for x = 1,#sub do
    if sub[x].key == "Video File" then
      return sub[x].value:sub(2)
    end
  end
end

function trimnthings(sub,sel)
  local conf = configscope()
  if conf then
    if not readconf(conf,{ ['global'] = global }) then aegisub.log(0,"Falhou ao ler a configuração!\n") end
  end
  local tokens = {}
  tokens.encbin = global.encbin
  tokens.prefix = dcp(global.prefix)
  tokens.nl = "\n"
  collecttrim(sub,sel,tokens)
  tokens.input = getvideoname(sub):gsub("[A-Z]:\\",""):gsub(".+[^\\/]-[\\/]","")
  assert(not tokens.input:match("?dummy"), "Não são aceites vídeos dummy. És como um nabo.")
  tokens.inpath = dcp("?video/")
  tokens.index = tokens.input:match("(.+)%.[^%.]+$")
  tokens.output = tokens.index -- huh.
  if not global.gui_trim then
    writeandencode(tokens)
  else
    someguiorsmth(tokens)
  end
end

function someguiorsmth(tokens)
  gui.t.input.value = tokens.input
  gui.t.index.value = tokens.index
  gui.t.startf.value = tokens.startf
  gui.t.endf.value = tokens.endf
  gui.t.output.value = tokens.output
  local button, opts = aegisub.dialog.display(gui.t)
  if button then
    for k,v in pairs(opts) do
      tokens[k] = v
    end
    tokens.startt, tokens.endt = aegisub.ms_from_frame(tokens.startf), aegisub.ms_from_frame(tokens.endf)
    tokens.lenf, tokens.lent = tokens.endf-tokens.startf, tokens.endt-tokens.startt
    writeandencode(tokens)
  end
end

function writeandencode(tokens)
  tokens.startt, tokens.endt, tokens.lent = tokens.startt/1000, tokens.endt/1000, tokens.lent/1000
  local function ReplaceTokens(token)
    return tokens[token:sub(2,-2)]
  end
  local encsh = tokens.prefix.."encode.bat"
  local sh = io.open(encsh,"w+")
  assert(sh,"O comando de encode não pode ser escrito. Verifica o prefixo.") -- to solve the 250 byte limit, we write to a self-deleting batch file.
  local ret
  if winpaths then
    sh:write(global.enccom:gsub("#(%b{})",ReplaceTokens)..'\ndel %0')
    sh:close()
    ret = os.execute(('""%s""'):format(encsh)) -- double quotes makes it work on different drives too, apparently
  else
    sh:write(global.enccom:gsub("#(%b{})",ReplaceTokens)..'\ndel $0')
    sh:close()
    ret = os.execute(('sh "%s"'):format(encsh)) -- seems to work4me
  end
  if ret ~= 0 then error(false,"O encode falhou!") end
end

aegisub.register_macro("Motion-Tracking - Criar Trim","Corta e encoda a cena de vídeo actual para se usar no software de motion-tracking.", trimnthings, isvideo)
