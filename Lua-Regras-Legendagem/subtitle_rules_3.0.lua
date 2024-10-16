--[[
 Copyright (c) 2024, Leinad4Mind
 All rights reserved®.
 
 Um grande agradecimento a todos os meus amigos
 que sempre me apoiaram, e a toda a comunidade
 de anime portuguesa.
--]]

script_name = "Regras de Legendagem"
script_description = "Corrige várias questões para cumprir as diretrizes de estilo da legendagem."
script_author = "Leinad4Mind"
script_version = "3.0"

include("karaskel.lua")

ADP = aegisub.decode_path
path_rules = ADP("?user").."\\regras_legendagem.conf"
path_presets = ADP("?user").."\\presets.conf"
last_preset_path = ADP("?user").."\\last_preset.conf"

-- Função para verificar se o texto está em maiúsculas
local function is_uppercase_text(text)
    return text == text:upper() and text:match("%S")
end

local function is_narrator(line)
    local lower_actor = line.actor:lower()
    local lower_style = line.style:lower()
    local patterns = {"narrador", "narrator"}

    for _, pattern in ipairs(patterns) do
        if lower_actor:match(pattern) or lower_style:match(pattern) then
            return true
        end
    end
    return false
end

-- Check if the style or actor starts with "music"
local function is_music_style(line)
    local normalized_style = line.style:lower()
    local normalized_actor = line.actor:lower()
    return normalized_style:sub(1, 5) == "music" or normalized_actor:sub(1, 5) == "music"
end

-- Função para converter valores em booleano
local function toboolean(value)
    return value == "true" or value == true
end

-- Função para carregar a configuração do idioma
local function load_language()
    local file = io.open(path_rules, "r")
    if file then
        local lang = file:read("*l")
        file:close()
        return lang
    end
    return nil
end

-- Função para salvar a configuração do idioma
local function save_language(lang)
    local file = io.open(path_rules, "w")
    if file then
        file:write(lang)
        file:close()
    end
end

-- Função para limpar a configuração do idioma
local function clear_language()
    os.remove(path_rules)
end

-- Função para criar um menu de seleção do idioma
local function language_selection_menu()
    local lang = load_language()
    if lang then
        return lang
    end

    local languages = {
        { display = "Português", code = "pt" },
        { display = "English", code = "en" }
    }
    
    local items = {}
    for _, language in ipairs(languages) do
        table.insert(items, language.display)
    end

    local menu = {
        { class = "label", label = "Select Language", x = 0, y = 0, width = 2 },
        { class = "dropdown", name = "language", items = items, value = "Português", x = 0, y = 1, width = 1 }
    }
    
    local button, result = aegisub.dialog.display(menu, {"OK"})
    if button == "OK" then
        local selected_lang = languages[result.language == "Português" and 1 or 2].code
        save_language(selected_lang)
        return selected_lang
    end
    return "pt"
end

-- Função para carregar textos de acordo com o idioma
local function get_localized_strings(language)
    local strings = {}
    if language == "pt" then
        strings.title = "Regras de Legendagem"
        strings.boldify_uppercase = "Adicionar Negrito nas Linhas em Maiúsculas"
        strings.italicize_narrator = "Adicionar Itálico para Linhas com 'narrador' no Campo do Actor"
        strings.hyphen_to_dash = "Substituir Hífen por Travessões"
        strings.dash_type = "Escolha o estilo do traço:"
        strings.three_dots_to_ellipsis = "Substituir três pontos (...) por reticências (…)"
        strings.ensure_line_spacing = "Garantir Espaçamento Mínimo Entre Linhas"
        strings.spacing_threshold = "Limite de espaçamento (ms):"
        strings.video_fps = "FPS do vídeo:"
        strings.apply = "Aplicar"
        strings.cancel = "Cancelar"
        strings.note = "Nota: Espaçamento entre linhas ajustado"
        strings.clear_language = "Limpar Idioma"
        strings.save_preset_name = "Nome do preset:"
        strings.choose_preset = "Escolher Preset"
        strings.save_preset = "Salvar Preset"
        strings.remove_preset = "Remover Preset"
        strings.load_preset = "Carregar Preset"
        strings.handle_music_styles = "Activar Formatação de Música"
    else
        strings.title = "Translation Rules"
        strings.boldify_uppercase = "Boldify uppercase lines"
        strings.italicize_narrator = "Italicize lines with 'narrator' in the actor field"
        strings.hyphen_to_dash = "Replace hyphens with dashes"
        strings.dash_type = "Choose dash type:"
        strings.three_dots_to_ellipsis = "Replace three dots with ellipsis"
        strings.ensure_line_spacing = "Ensure minimum line spacing"
        strings.spacing_threshold = "Spacing threshold (ms):"
        strings.video_fps = "Video FPS:"
        strings.apply = "Apply"
        strings.cancel = "Cancel"
        strings.note = "Note: Line spacing adjusted"
        strings.clear_language = "Clear Language"
        strings.save_preset_name = "Preset name:"
        strings.choose_preset = "Choose Preset"
        strings.save_preset = "Save Preset"
        strings.remove_preset = "Remove Preset"
        strings.load_preset = "Load Preset"
        strings.handle_music_styles = "Enable Music Formatting"
    end
    return strings
end

-- Função para mostrar mensagens ao utilizador
local function show_message(message)
    local msg_menu = {
        { class = "label", label = message, x = 0, y = 0, width = 1 },
    }
    aegisub.dialog.display(msg_menu, {"OK"})
end

-- Função para carregar presets do ficheiro
local function load_presets()
    local presets = {}
    local file = io.open(path_presets, "r")
    if file then
        for line in file:lines() do
            local name, config = line:match("([^:]+): (.+)")
            if name and config then
                presets[name] = {}
                for v in config:gmatch("[^,]+") do
                    table.insert(presets[name], v)
                end
            end
        end
        file:close()
    end
    return presets
end

-- Função para salvar presets
local function save_presets(presets)
    local file = io.open(path_presets, "w")
    if file then
        for name, config in pairs(presets) do
            local preset_string = string.format("%s: %s,%s,%s,%s,%s,%s,%s,%s,%s",
                name,
                tostring(config[1]),
                tostring(config[2]),
                tostring(config[3]),
                tostring(config[4]),
                tostring(config[5]),
                tostring(config[6]),
                tostring(config[7]),
                tostring(config[8]),
                tostring(config[9])
            )
            file:write(preset_string .. "\n")
        end
        file:close()
    end
end

-- Função para salvar o último preset carregado
local function save_last_preset(preset_name)
    local file = io.open(last_preset_path, "w")
    if file then
        file:write(preset_name)
        file:close()
    end
end

-- Função para carregar o último preset
local function load_last_preset()
    local file = io.open(last_preset_path, "r")
    if file then
        local preset_name = file:read("*l")
        file:close()
        return preset_name
    end
    return nil
end

-- Função para carregar e aplicar preset
local function apply_selected_preset(selected_preset, result)
    local presets = load_presets()
    if presets[selected_preset] then
        local config = presets[selected_preset]
        result.boldify_uppercase = toboolean(config[1])
        result.italicize_narrator = toboolean(config[2])
        result.hyphen_to_dash = toboolean(config[3])
        result.dash_style = tostring(config[4])
        result.three_dots_to_ellipsis = toboolean(config[5])
        result.ensure_line_spacing = toboolean(config[6])
        result.spacing_threshold = tonumber(config[7]) -- Ensure this is being read as a number
        result.video_fps = tonumber(config[8]) -- Ensure this is being read as a number
        result.handle_music_styles = toboolean(config[9])
        return true
    end
    return nil
end

-- Função para mostrar o menu com as configurações do preset
local function show_menu_with_preset(config)
    local language = load_language()
    local strings = get_localized_strings(language)
    local presets = load_presets()
    local preset_names = {}
    local dash_styles = { "—", "–", "-" } -- Travessão, Meia-Risca, Hífen

    for name in pairs(presets) do
        table.insert(preset_names, name)
    end

    -- Carregar último preset caso exista
    local last_preset = load_last_preset()

    local menu = {
        { class = "label", label = strings.choose_preset, x = 0, y = 0, width = 3 },
        { class = "dropdown", name = "preset", items = preset_names, value = last_preset or "", x = 0, y = 1, width = 3 },
        { class = "checkbox", name = "boldify_uppercase", label = strings.boldify_uppercase, value = config.boldify_uppercase, x = 0, y = 2, width = 3 },
        { class = "checkbox", name = "italicize_narrator", label = strings.italicize_narrator, value = config.italicize_narrator, x = 0, y = 3, width = 3 },
        { class = "checkbox", name = "hyphen_to_dash", label = strings.hyphen_to_dash, value = config.hyphen_to_dash, x = 0, y = 4, width = 3 },
        { class = "label", label = strings.dash_type, x = 0, y = 5, width = 1 },
        { class = "dropdown", name = "dash_style", items = dash_styles, value = config.dash_style, hint = { "Travessão", "Meia-Risca", "Hífen" }, x = 2, y = 5, width = 2 },
        { class = "checkbox", name = "three_dots_to_ellipsis", label = strings.three_dots_to_ellipsis, value = config.three_dots_to_ellipsis, x = 0, y = 6, width = 3 },
        { class = "checkbox", name = "handle_music_styles", label = "Activar Formatação de Música", value = config.handle_music_styles, x = 0, y = 7, width = 3 },
        { class = "checkbox", name = "ensure_line_spacing", label = strings.ensure_line_spacing, value = config.ensure_line_spacing, x = 0, y = 8, width = 3 },
        { class = "label", label = strings.spacing_threshold, x = 0, y = 9, width = 2 },
        { class = "intedit", name = "spacing_threshold", label = strings.spacing_threshold, value = tostring(config.spacing_threshold), hint = "Espaçamento mínimo entre linhas", x = 2, y = 9, width = 1 },
        { class = "label", label = strings.video_fps, x = 0, y = 10, width = 2 },
        { class = "floatedit", name = "video_fps", label = strings.video_fps, value = tostring(config.video_fps), hint = "FPS do vídeo", x = 2, y = 10, width = 1 },
        { class = "label", label = strings.save_preset_name, x = 0, y = 11, width = 2 },
        { class = "edit", name = "save_preset_name", value = "", x = 2, y = 11, width = 2 },
    }

    local buttons = {strings.apply, strings.cancel, strings.clear_language, strings.save_preset, strings.remove_preset, strings.load_preset}
    local button, result = aegisub.dialog.display(menu, buttons)
    return button, result
end

-- Configuração padrão
local default_config = {
    boldify_uppercase = false,
    italicize_narrator = false,
    hyphen_to_dash = false,
    dash_style = "–",
    three_dots_to_ellipsis = false,
    ensure_line_spacing = false,
    spacing_threshold = 83,
    video_fps = 23.976,
    handle_music_styles = false,
}

-- Função principal
function subtitle_rules(subs, selected_lines, active_line, config)
    -- Carrega a seleção de idioma
    local selected_language = language_selection_menu()

    -- Tente carregar o último preset se o config estiver vazio
    if not config or next(config) == nil then
        config = default_config
        local last_preset_name = load_last_preset()
        if last_preset_name then
            local presets = load_presets()
            if presets[last_preset_name] then
                config = {
                    boldify_uppercase = toboolean(presets[last_preset_name][1]),
                    italicize_narrator = toboolean(presets[last_preset_name][2]),
                    hyphen_to_dash = toboolean(presets[last_preset_name][3]),
                    dash_style = tostring(presets[last_preset_name][4]),
                    three_dots_to_ellipsis = toboolean(presets[last_preset_name][5]),
                    ensure_line_spacing = toboolean(presets[last_preset_name][6]),
                    spacing_threshold = tonumber(presets[last_preset_name][7]),
                    video_fps = tonumber(presets[last_preset_name][8]),
                    handle_music_styles = toboolean(presets[last_preset_name][9]),
                }
            end
        end
    end

    local presets = load_presets()
    local language = load_language()
    local strings = get_localized_strings(language)
    local button, result = show_menu_with_preset(config)

    if button == strings.cancel then return end

    if button == strings.load_preset and result.preset and result.preset ~= "" then
        if apply_selected_preset(result.preset, result) then
            show_message("Preset carregado: " .. result.preset)

            -- guarda último preset carregado
            save_last_preset(result.preset)

            return subtitle_rules(subs, selected_lines, active_line, result) -- Chamar novamente com o config actualizado
        else
            show_message("Erro ao carregar preset.")
        end
    elseif button == strings.save_preset then
        local preset_name = result.save_preset_name
        if preset_name and preset_name ~= "" then
            presets[preset_name] = {
                tostring(result.boldify_uppercase),
                tostring(result.italicize_narrator),
                tostring(result.hyphen_to_dash),
                tostring(result.dash_style),
                tostring(result.three_dots_to_ellipsis),
                tostring(result.ensure_line_spacing),
                tostring(result.spacing_threshold),
                tostring(result.video_fps),
                tostring(result.handle_music_styles)
            }
            save_presets(presets)
            show_message("Preset salvo: " .. preset_name)
            return subtitle_rules(subs, selected_lines, active_line, result) -- Reabre o menu
        else
            show_message("Nome do preset não pode ser vazio.")
        end
    elseif button == strings.remove_preset and result.preset then
        presets[result.preset] = nil
        save_presets(presets)
        show_message("Preset removido: " .. result.preset)
        return subtitle_rules(subs, selected_lines, active_line, result) -- Reabre o menu
    elseif button == strings.clear_language then
        clear_language()
        return
    end

    -- Aplica as regras às linhas
    if button == strings.apply then
        config.boldify_uppercase = toboolean(result.boldify_uppercase)
        config.italicize_narrator = toboolean(result.italicize_narrator)
        config.hyphen_to_dash = toboolean(result.hyphen_to_dash)
        config.dash_style = tostring(result.dash_style)
        config.three_dots_to_ellipsis = toboolean(result.three_dots_to_ellipsis)
        config.ensure_line_spacing = toboolean(result.ensure_line_spacing)
        config.spacing_threshold = tonumber(result.spacing_threshold)
        config.video_fps = tonumber(result.video_fps)
        config.handle_music_styles = toboolean(result.handle_music_styles)
    end

    -- Aplique as regras às linhas, independente de preset ou input manual
    for i = 1, #subs do
        local line = subs[i]
        if line.class == "dialogue" then

            if config.boldify_uppercase and is_uppercase_text(line.text) then
                line.text = "{\\b1}" .. line.text .. "{\\b0}"
            end

            if config.italicize_narrator and is_narrator(line) then
                line.text = "{\\i1}" .. line.text .. "{\\i0}"
            end

            if config.hyphen_to_dash then
                local dash_char = config.dash_style
                -- Substituir caracteres Travessão
                if config.dash_style ~= "—" then
                    line.text = line.text:gsub("^— ?(.*)",dash_char .. " %1")
                    line.text = line.text:gsub("^({.-}+ ?)—(.*)","%1" .. dash_char .. " %2")
                    line.text = line.text:gsub("(\\[Nn] ?)— ?(.*)","%1" .. dash_char .. " %2")
                    line.text = line.text:gsub("(\\[Nn] ?{.-}+)— ?(.*)","%1" .. dash_char .. " %2")
                end
                -- Substituir caracteres Meia-Risca
                if config.dash_style ~= "–" then
                    line.text = line.text:gsub("^– ?(.*)",dash_char .. " %1")
                    line.text = line.text:gsub("^({.-}+ ?)–(.*)","%1" .. dash_char .. " %2")
                    line.text = line.text:gsub("(\\[Nn] ?)– ?(.*)","%1" .. dash_char .. " %2")
                    line.text = line.text:gsub("(\\[Nn] ?{.-}+)– ?(.*)","%1" .. dash_char .. " %2")
                end
                -- Substituir caracteres Hífen
                if config.dash_style ~= "-" then
                    line.text = line.text:gsub("^- ?(.*)",dash_char .. " %1")
                    line.text = line.text:gsub("^({.-}+ ?)-(.*)","%1" .. dash_char .. " %2")
                    line.text = line.text:gsub("(\\[Nn] ?)- ?(.*)","%1" .. dash_char .. " %2")
                    line.text = line.text:gsub("(\\[Nn] ?{.-}+)- ?(.*)","%1" .. dash_char .. " %2")
                end
            end

            if config.three_dots_to_ellipsis then
                line.text = line.text:gsub("%.%.%.", "…")
            end

            if config.ensure_line_spacing then
                if i < #subs then
                    local next_line = subs[i + 1]
                    local time_difference = next_line.start_time - line.end_time

                    -- If the time difference is less than the minimum gap
                    if time_difference < config.spacing_threshold then
                        -- Adjust the start time of the next line
                        next_line.start_time = line.end_time + config.spacing_threshold

                        -- Optionally, adjust end time to maintain duration
                        if next_line.start_time >= next_line.end_time then
                            next_line.end_time = next_line.start_time + (next_line.end_time - next_line.start_time)
                        end
                    end
                end
            end

            -- Adicionando formatação de música
            if config.handle_music_styles then
                local hasMusicSymbolStart = string.find(line.text, "♪")
                local hasMusicSymbolMiddle = string.find(line.text, "♫")
                local hasNewLine = string.find(line.text, "\\N")
                local hasItalic = string.find(line.text, "\\i1")
                local hasMusicAlready = string.find(line.text, "\\alpha")

                -- Call is_music_style with the line argument
                if hasMusicSymbolStart or hasMusicSymbolMiddle or is_music_style(line) then
                    if hasNewLine and not hasMusicAlready then
                        if hasItalic then
                            line.text = line.text:gsub("^({.-}*)♪ ({.-})(.-)\\N(.-)", "%1♪ %2%3\\N{\\alpha&HFF&}♪ {\\r}%1%2%4")
                        else
                            line.text = line.text:gsub("^({.-}*)♪ (.-)\\N(.-)", "%1♪ %2%3\\N{\\alpha&HFF&}♪ {\\r}%1%3")
                        end
                    end
                    -- Insert music symbol at the start and end if needed
                    if is_music_style(line) and not (hasMusicSymbolStart or hasMusicSymbolMiddle) then
                        if not hasNewLine then
                            line.text = "♪ " .. line.text .. " ♪"
                        else
                            line.text = line.text:gsub("^(.-)\\N(.-)", "♪ %1\\N{\\alpha&HFF&}♪ {\\r}%2 ♪")
                        end
                    end
                end
                if hasMusicSymbolStart or hasMusicSymbolMiddle or is_music_style(line) then
                    line.actor = ""
                    line.style = "Música"
                end
            end

            subs[i] = line
        end
    end

    aegisub.set_undo_point(strings.title)
end

aegisub.register_macro(script_name, script_description, subtitle_rules)