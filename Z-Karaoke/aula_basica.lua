-- Por Leinad4Mind
-- I KNOW! I KNOW! I'M FUCKING AWESOME!
--
-- ///////////////////////////////////////////////////////////////////////// --
-- ######################### CONFIGURAÇÕES DA MACRO ######################## --
-- ///////////////////////////////////////////////////////////////////////// --

include("karaskel.lua") -- Obrigatório adicionar sempre
include("leinadformas.lua")
include("leinadcollection.lua")


script_name = "Aula Básica de Lua!"
script_description = "Primeiro Ficheiro Lua. Faz uso da LeinadCollection."
script_author = "Leinad4Mind"
script_version = "1.0"

-------------------------- FIM DAS CONFIGURAÇÕES DA MACRO ---------------------
--																	 		 --
-------------------------------- INICIO DOS EFEITOS ---------------------------

-- Função que cria o raio do efeito... NÃO MEXER!!!
function fx_leinad(subs)
	aegisub.progress.task("O efeito está a ser criado... (Aproveita e vai dar uma volta :P")
	local meta, styles = karaskel.collect_head(subs)	
	aegisub.progress.task("A aplicar a merda do teu efeito! LOL xD")
	local i, ai, maxi, maxai = 1, 1, #subs, #subs
	while i <= maxi do
		aegisub.progress.task(string.format("A trabalhar que nem preto (%d/%d)...", ai, maxai))
		aegisub.progress.set((ai-1)/maxai*100)
		local l = subs[i]
		if l.class == "dialogue" and
				not l.comment and
				(l.style == "Default" or l.style == "Karaoke") then	-- Aqui serve para indicar com que estilos é que a nossa função irá trabalhar.
				karaskel.preproc_line(subs, meta, styles, l)
			do_fx(subs, meta, l)
			maxi = maxi - 1
			subs.delete(i)
		else
			i = i + 1
		end
		ai = ai + 1
	end
	aegisub.progress.task("Feito, Terminado, FINITO!")
	aegisub.progress.set(100)
	aegisub.set_undo_point("fx_leinad")
end

--------------------------------- FIM DOS EFEITOS -----------------------------
--																			 --
-- ///////////////////////////////////////////////////////////////////////// --
-- ############################ CONFIGURAÇÃO BÁSICA ######################## --
-- ///////////////////////////////////////////////////////////////////////// --
--																			 --
-- ### CONFIGURAÇÃO DE X-Y E SÍLABAS ###									 --
-------------------------------------------------------------------------------
function do_fx(subs, meta, line)
	for i = 1, line.kara.n do
		local syl = line.kara[i]
		local x=syl.center + line.left
		local y=line.margin_v + 25
		sil(syl) -- Adicionámos a nova função de Sil (Encontra-se na LeinadCollection)
		
-- ####################### FIM DA CONFIGURAÇÃO BÁSICA ###################### --
-- ///////////////////////////////////////////////////////////////////////// --
-- ########################### INÍCIO DOS EFEITOS ########################## --
--
--#EFEITO DE ENTRADA
l = table.copy(line) --Copia as linhas para se usar
l.text = "{"..alpha('FF')..an(5)..move(x+20,y-20,x,y)..bord(0)..fr(-45)..color(1,'FFFFFF')..t(fr(0)..color('191AC3','','','000000')..bord(2)..alpha('00')).."}"..sil() --Efeitos (Onde poderás adicionar os teus efeitos de entrada)
l.start_time = line.start_time-500 --Tempo de Entrada do Efeito (-500 = entrará 0.5 segundos antes do seu tempo.
l.end_time = line.start_time --Tempo de Saída do Efeito
l.layer=0 --Número da Camada... Ou seja, em que nível ficará o Karaoke (Por detrás ou à frente de outros efeitos)
subs.append(l) --Adiciona a linha que foi copiada e modificada à legenda

--
--#SÍLABAS ESTÁTICAS
l = table.copy(line)
l.text = "{"..an(5)..move(x,y,x+rand(20),y+rand(30))..color(1,line.styleref.color1)..bord(0)..t(alpha('ff')).."}" -- Formas(5,8) é uma estrela especial de uma função da biblioteca leinadformas.lua
l.start_time = line.start_time
l.end_time = line.start_time+syl.start_time
l.layer=0
subs.append(l)

--
--#EFEITO DAS SÍLABAS
l = table.copy(line)
l.text = "{"..an(5)..pos(x,y)..color3(1,line.styleref.color1)..bord(0)..fr(360)..t(fr(0)..fry(360)..bord(1)).."}"..sil()
l.start_time=line.start_time+syl.start_time
l.end_time=l.start_time+syl.duration
l.layer = 2
subs.append(l)

--
--#EFEITO DE SAÍDA
l = table.copy(line)
l.text = "{"..an(5)..move(x,y,x+rand(40),y+rand(40))..bord(1)..fry(360)..t(fry(0)..alpha('FF')).."}"..sil()
l.start_time=line.start_time+syl.start_time+syl.duration
l.end_time=l.end_time+200
l.layer = 2
subs.append(l)

-- ############################# FIM DOS EFEITOS ########################### --
	end -- fim do ciclo for
end -- fim da função

-- ###################### REGISTAR MACRO DE EXPORTAÇÃO ##################### --
aegisub.register_macro(script_name, "Aula Básica de LUA! D:", fx_leinad)
aegisub.register_filter(script_name, "Aula Básica de LUA! D:", 2000, fx_leinad)
-- ################### FIM DO REGISTAR MACRO DE EXPORTAÇÃO ################# --