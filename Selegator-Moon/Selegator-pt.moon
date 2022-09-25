export script_name = 'Seleccionador'
export script_description = 'Selecciona/navega na grelha de legenda'

aegisub.register_macro script_name..'/Estilo seleccionado/Seleccionar Todos', script_description, (subs, sel, act) ->
    lookforstyle = subs[act].style
    if #sel>1
        [i for i in *sel when subs[i].style==lookforstyle]
    else
        [k for k,s in ipairs subs when s.style==lookforstyle]

aegisub.register_macro script_name..'/Estilo seleccionado/Anterior', '', (subs, sel, act) ->
    lookforstyle = subs[act].style
    for i = act-1,1,-1
        return if subs[i].class!='dialogue'
        if subs[i].style==lookforstyle
            return {i}

aegisub.register_macro script_name..'/Estilo seleccionado/Próximo', '', (subs, sel, act) ->
    lookforstyle = subs[act].style
    for i = act+1,#subs
        if subs[i].style==lookforstyle
            return {i}

aegisub.register_macro script_name..'/Estilo seleccionado/Primeiro do bloco', '', (subs, sel, act) ->
    lookforstyle = subs[act].style
    for i = act-1,1,-1
        if subs[i].class!='dialogue' or subs[i].style!=lookforstyle
            return {i+1}

aegisub.register_macro script_name..'/Estilo seleccionado/Último do bloco', '', (subs, sel, act) ->
    lookforstyle = subs[act].style
    for i = act+1,#subs
        if subs[i].style!=lookforstyle
            return {i-1}
    {#subs}

aegisub.register_macro script_name..'/Estilo seleccionado/Seleccionar bloco', '', (subs, sel, act) ->
    lookforstyle = subs[act].style
    first, last = act, #subs
    for i = act-1,1,-1
        if subs[i].class!='dialogue' or subs[i].style!=lookforstyle
            first = i + 1
            break
    for i = act+1,#subs
        if subs[i].class!='dialogue' or subs[i].style!=lookforstyle
            last = i - 1
            break
    [i for i=first,last]

aegisub.register_macro script_name..'/Seleccionar até ao início', 'Ao contrário do atalho Shift-Home, isto preserva a linha activa', (subs, sel, act) ->
    [i for i = 1,act when subs[i].class=='dialogue']

aegisub.register_macro script_name..'/Seleccionar até ao fim', 'Ao contrário do atalho Shift-End, isto preserva a linha activa', (subs, sel, act) ->
    [i for i = act,#subs when subs[i].class=='dialogue']
