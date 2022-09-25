--[[
 Copyright (c) 2012-2022, Leinad4Mind
 All rights reserved®.
 
 Um grande agradecimento a todos os meus amigos
 que sempre me apoiaram, e a toda a comunidade
 de anime portuguesa.
--]]

script_name = "Corrigir SRT"
script_description = "Adiciona espaço onde existe reticências no início da frase. Corrige os hífens. Corrige as aspas. Corrige I por l. Corrige á por à. Corrige a quando é há. Corrige concerteza para Com certeza. Corrige Porfavor para Por Favor. Aplica estilo 'Música' com todas as suas regras. E corrige problema de linhas sobrepostas existentes nos SRTs."
script_author = "Leinad4Mind"
script_version = "4.2"

include("karaskel.lua")

function corrigir(subs,sel)
	for i = 1,#subs do
        local line = subs[i]
        if line.class == "dialogue" then
            line.i = i + 1
			-- Espaços
			line.text = line.text:gsub("^({.-}*)(%.%.%.)([^ ^\{^\\])","%1%2 %3")
			line.text = line.text:gsub("^({.-}*)(%.%.%.)(.-)\\N({.-})(.-)(%.%.%.)([^ ^\{^\\])","%1%2%3\\N%4%5%6 %7")
			line.text = line.text:gsub("^({.-}*)(%.%.%.)(.-)\\N(.-)(%.%.%.)([^ ^\{^\\])","%1%2%3\\N%4%5 %6")
			line.text = line.text:gsub("^({.-}*)(.-)\\N(.-)(%.%.%.)([^ ^\{^\\])","%1%2\\N%3%4 %5")
			-- Hífens
			line.text = line.text:gsub("- ([^ ])","– %1")
			line.text = line.text:gsub("^-([^ ])","– %1")
			line.text = line.text:gsub("(\\[Nn])-([^ ])","%1– %2")
			line.text = line.text:gsub("^({.-}+)-([^ ])","%1– %2")
			-- '' por " 
			line.text = line.text:gsub("''","\"")
			--I por l
			line.text = line.text:gsub("-I([^ ])","-l%1")
			line.text = line.text:gsub("([aeiouáéíóúà])It","%1lt")
			-- á por à e
			line.text = line.text:gsub("^á ([^ ])","à %1")
			line.text = line.text:gsub("^Á ([^ ])","À %1")
			line.text = line.text:gsub("([^ ]) á ([^ ])","%1 à %2")
			line.text = line.text:gsub("([^ ]) Á ([^ ])","%1 À %2")
			--line.text = line.text:gsub("^ás ([^ ])","às %1")
			--line.text = line.text:gsub("^Ás ([^ ])","Às %1")
			--line.text = line.text:gsub("^ÁS ([^ ])","ÀS %1")
			--line.text = line.text:gsub("([^ ]) ás ([^ ])","%1 às %2")
			--line.text = line.text:gsub("([^ ]) Ás ([^ ])","%1 Às %2")
			--line.text = line.text:gsub("([^ ]) ÁS ([^ ])","%1 ÀS %2")
			line.text = line.text:gsub("(\\[Nn])á ([^ ])","%1à %2")
			--line.text = line.text:gsub("(\\[Nn])ás ([^ ])","%1às %2")
			line.text = line.text:gsub("(\\[Nn])Á ([^ ])","%1À %2")
			--line.text = line.text:gsub("(\\[Nn])Ás ([^ ])","%1Às %2")
			--line.text = line.text:gsub("(\\[Nn])ÁS ([^ ])","%1ÀS %2")
			
			--a muito tempo por há muito tempo
			--line.text = line.text:gsub("^({.-}*)a (muito%|bastante%|algum%|pouco%|um) tempo","%1há %2 tempo")
			line.text = line.text:gsub("^({.-}*)a muito tempo","%1há muito tempo")
			line.text = line.text:gsub("^({.-}*)a bastante tempo","%1há bastante tempo")
			line.text = line.text:gsub("^({.-}*)a algum tempo","%1há algum tempo")
			line.text = line.text:gsub("^({.-}*)a pouco tempo","%1há pouco tempo")
			line.text = line.text:gsub("^({.-}*)a um tempo","%1há um tempo")
			line.text = line.text:gsub("^({.-}*)a uns tempo","%1há uns tempos")
			--horas
			line.text = line.text:gsub("^({.-}*)a umas horas","%1há umas horas")
			line.text = line.text:gsub("^({.-}*)a poucas horas","%1há poucas horas")
			line.text = line.text:gsub("^({.-}*)a algumas horas","%1há algumas horas")
			line.text = line.text:gsub("^({.-}*)a bastantes horas","%1há bastantes horas")
			line.text = line.text:gsub("^({.-}*)a muitas horas","%1há muitas horas")
			--minutos
			line.text = line.text:gsub("^({.-}*)a uns minutos","%1há uns minutos")
			line.text = line.text:gsub("^({.-}*)a poucos minutos","%1há poucos minutos")
			line.text = line.text:gsub("^({.-}*)a alguns minutos","%1há alguns minutos")
			line.text = line.text:gsub("^({.-}*)a bastantes minutos","%1há bastantes minutos")
			line.text = line.text:gsub("^({.-}*)a muitos minutos","%1há muitos minutos")
			--segundos
			line.text = line.text:gsub("^({.-}*)a uns segundos","%1há uns segundos")
			line.text = line.text:gsub("^({.-}*)a poucos segundos","%1há poucos segundos")
			line.text = line.text:gsub("^({.-}*)a alguns segundos","%1há alguns segundos")
			line.text = line.text:gsub("^({.-}*)a bastantes segundos","%1há bastantes segundos")
			line.text = line.text:gsub("^({.-}*)a muitos segundos","%1há muitos segundos")

			--concerteza para com certeza
			line.text = line.text:gsub("^({.-}*)concerteza","%1com certeza")
			line.text = line.text:gsub("^({.-}*)Concerteza","%1Com certeza")
			--Porfavor para Por favor
			line.text = line.text:gsub("^({.-}*)porfavor","%1por favor")
			line.text = line.text:gsub("^({.-}*)Porfavor","%1Por favor")
			
			--Colocar estilo musica em todas linhas com ♪ e caso exista \N alinha a 2º linha correctamente.
			local b = string.find(line.text,"♪")
			local c = string.find(line.text,"\\N")
			local d = string.find(line.text,"\\i1")
			local z = string.find(line.text,"\\alpha")
			if b then --se tiver simbolo musical faz
				if c and not z then -- se tiver 2 linhas e ainda n tiver sido aplicado entao
					if d then -- aplica com italico
						line.text = line.text:gsub("^({.-}*)♪ ({.-})(.-)\\N(.-)","%1♪ %2%3\\N{\\alpha&HFF&}♪ {\\r}%1%2%4")
					else -- senao aplica sem italico
						line.text = line.text:gsub("^({.-}*)♪ (.-)\\N(.-)","%1♪ %2%3\\N{\\alpha&HFF&}♪ {\\r}%1%3")
					end
				end
				line.style = "Música"
			end
		end
        subs[i] = line
    end
	--Corrigir timing pro roca que ele é chato...
		--PROBLEMA
		--Dialogue: 0,0:32:18.74,0:32:21.96,Default,,0000,0000,0000,,texto antes
		--Dialogue: 0,0:32:21.96,0:32:22.29,Default,,0000,0000,0000,,texto test depois\Ntexto antes
		--Dialogue: 0,0:32:22.29,0:32:24.90,Default,,0000,0000,0000,,texto test depois

		--RESULTADO
		--Dialogue: 0,0:32:18.74,0:32:21.96,Default,,0000,0000,0000,,texto antes
		--Dialogue: 0,0:32:21.96,0:32:24.90,Default,,0000,0000,0000,,texto test depois
		
	for i=#subs,1,-1 do --#sel = numero total das linhas e vai do fim da legenda pro inicio
		local line = subs[i]
		local del = i
		local dur = 800 -- duracao maxima em ms, que a linha poderá ter
		if line.class == "dialogue" then
		line.duration = line.end_time - line.start_time --cria a duracao... senao tinha de carregar o karaskel.preproc_line -.-
			if line.text ~= "" and line.duration < dur then -- se duracao for menor que 800ms = 0:00:00.80 entao
				if i > 1 and i < #subs then -- se não for a 1º linha nem a última então
					local antes = subs[i-1]		--buscar linha anterior
					local depois = subs[i+1]	--buscar linha posterior
					confirmar = line.text == depois.text.."\\N"..antes.text --comparar se a linha actual (line.text) contém ambas as linhas.
					--aegisub.debug.out(2, "Debug: '%s' \n", confirmar)
					especial = antes.text:gsub("^({.-}+)(.-)","%2")
					tags = line.text == depois.text.."\\N"..especial --comparar se a linha actual (line.text) contém ambas as linhas.
					--{\be1\blur1}♪ {\i1}O amor distante vou buscar{\i} ♪
					music_antes = antes.text:gsub("^({.-}+)♪ ({.-})(.-)({.-}) ♪$","%3")
					music_depois = depois.text:gsub("^({.-}+)♪ ({.-})(.-)({.-}) ♪$","%3")
					--{\be1\blur1}♪ {\i1}Está numa estrela para nos guiar\N{\alpha&HFF&}♪ {\r\i1\be1\blur1}O amor distante vou buscar{\i} ♪
					music_actual = line.text:gsub("^({.-}+)♪ ({.-})(.-)\\N({.-})♪ ({.-}+)(.-)({.-}) ♪$","%3\\N%6")
					musicas = music_actual == music_depois.."\\N"..music_antes --comparar se a linha actual (line.text) contém ambas as linhas.				
					if confirmar or tags or musicas then --se realmente contiver então
						depois.start_time = antes.end_time -- torna os tempos continuos
						subs[i+1] = depois --insere o tempo alterado na legenda
						subs.delete(del) --apaga a linha que mete nojo
					end
				end
			end
		end
	end
end

aegisub.register_macro(script_name, script_description, corrigir)
aegisub.register_filter(script_name, script_description, 0, corrigir)
