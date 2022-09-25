--[[
 Copyright (c) 2012-2022, Leinad4Mind
 All rights reserved®.
 
 Biblioteca (Colecção de Funções) criada por Leinad4Mind.
 Contém diversas funções desenvolvidas principalmente
 por Zheo, conta também com funções de Nande!,
 Nickles, AseDark, Alquimista e DgrayGT.
 Sem eles esta colecção não seria nada.
 
 Qualquer modificação ou alteração que desejes fazer,
 deverás antecipadamente avisar o autor, neste caso, eu.

 A colecção encontra-se na versão 3.0.0, embora possa
 conter alguns erros. Usa com algum cuidado.
 
 Um grande agradecimento a todos os meus amigos
 que sempre me apoiaram, e a toda a comunidade
 de anime portuguesa.
--]]

include('utils.lua')
include('karaskel.lua')

-- ####################
-- ## EXPRESSÔES ASS ##
-- ####################
function b(valor)
	return "\\b" ..math.floor(valor).. ""
end

function i(valor)
	return "\\i" ..math.floor(valor).. ""
end

function u(valor)
	return "\\u" ..math.floor(valor).. ""
end

function s(valor)
	return "\\s" ..math.floor(valor).. ""
end

function bord(valor)
	return "\\bord" ..valor.. ""
end

function shad(valor)
sombraZ =  "\\shad" ..valor.. ""
	return sombraZ
end

function be(valor)
	return "\\be" ..math.floor(valor).. ""
end

function fn(letra)
	return "\\fn" ..letra.. ""
end

function fs(valor)
	return "\\fs" ..math.floor(valor).. ""
end

function fscx(valor)
	return "\\fscx" ..valor.. ""
end

function fscy(valor)
	return "\\fscy" ..valor.. ""
end

function fsp(valor)
	return "\\fsp" ..math.floor(valor).. ""
end

function frx(valor)
	return "\\frx" ..valor.. ""
end

function fry(valor)
	return "\\fry" ..valor.. ""
end

function frz(valor)
	return "\\frz" ..valor.. ""
end

function fr(valor)
	return "\\fr" ..valor.. ""
end

function fe(valor)
	return "\\fe" ..math.floor(valor).. ""
end

function color(tipo, valor)
	return "\\" ..tipo.. "c" ..ConvColor(valor).. ""
end

function estilo(tipo, valor) -- o mesmo que Color()
	return "\\" ..tipo.. "c" ..ConvColor(valor).. ""
end

function cor(tipo, valor) -- o mesmo que Color()
	return "\\" ..tipo.. "c" ..ConvColor(valor).. ""
end

function c(tipo, valor) -- o mesmo que Color()
	return "\\" ..tipo.. "c" ..ConvColor(valor).. ""
end

function al(valor)
	return "\\a" ..math.floor(valor).. ""
end

function an(valor)
	return "\\an" ..math.floor(valor).. ""
end

function alpha(tipo, valor)
	return "\\" ..tipo.. "a&H"..valor.. "&"
end

function a(tipo, valor) -- o mesmo que Alpha()
	return "\\" ..tipo.. "a&H"..valor.. "&"
end

function alpha(valor)
	return "\\alpha&H" ..valor.. "&"
end

function r()
	return "\\r"
end

function t(estilos)
	return "\\t(" ..estilos.. ")"
end

function tt(t1,t2,acel)
	if not t2 and not acel then
		return "" ..math.floor(t1).. ","
	elseif not acel then
		return "" ..math.floor(t1).. "," ..math.floor(t2).. ","
	else
		return "" ..math.floor(t1).. "," ..math.floor(t2).. ","..acel..","
	end
end

function move(valorx1, valory1, valorx2, valory2, ti, tf)
	if not ti and not tf then
		return "\\move(" .. valorx1.. "," ..valory1.. ",".. valorx2..","..valory2..")"
	else
		return "\\move(" .. valorx1.. "," ..valory1.. ",".. valorx2..","..valory2..","..math.floor(ti)..","..math.floor(tf)..")"
	end
end

function pos(valorx, valory)
	return "\\pos(" ..valorx.. "," ..valory.. ")"
end

function org(valorx, valory)
	return "\\org(" ..valorx.. "," ..valory.. ")"
end

function fade(ac1,ac2,ac3,t1,t2,t3,t4)
	return "\\fade(" ..ac1.. "," ..ac2.. "," ..ac3.. "," ..t1.. "," ..t2.. "," ..t3.. "," ..t4.. ")"
end

function fad(valori, valorf)
	return "\\fad(" ..valori.. "," ..valorf.. ")"
end

function p(valor, codigo)
	return "{\\p" ..valor.. "}" ..codigo.. "{\\p0}"
end

function clip(valorx1, valory1, valorx2, valory2)
	return "\\clip(" .. math.floor(valorx1).. "," ..math.floor(valory1).. ",".. math.floor(valorx2)..","..math.floor(valory2)..")"
end

function clipf(valor) --Clip para formas
	return "\\clip(" .. valor ..")"
end


-- ##################################################
-- ## EXPRESSÕES ESPECIAIS ASS (VSFilter 2.39 MOD) ##
-- ##################################################

function fax(valor)
	return "\\fax" ..valor.. ""
end

function fay(valor)
	return "\\fay" ..valor.. ""
end

function xbord(valor)
	return "\\xbord" ..valor.. ""
end

function ybord(valor)
	return "\\ybord" ..valor.. ""
end

function xshad(valor)
	return "\\xshad" ..valor.. ""
end

function yshad(valor)
	return "\\yshad" ..valor.. ""
end

function blur(valor)
	return "\\blur" ..math.floor(valor).. ""
end

function iclip(valorx1, valory1, valorx2, valory2)
	return "\\iclip(" .. math.floor(valorx1).. "," ..math.floor(valory1).. ",".. math.floor(valorx2)..","..math.floor(valory2)..")"
end

function iclipd(valor)
	return "\\iclip(" .. valor ..")"
end

function fsc(valor)
	return "\\fsc(" .. valor ..")"
end

function fsvp(valor)
	return "\\fsvp(" .. valor ..")"
end

function frs(valor)
	return "\\frs(" .. valor ..")"
end

function z(valor)
	return "\\z(" .. valor ..")"
end

function distort(v1, v2, v3, v4, v5, v6)
	return "\\distort(" ..v1.. "," ..v2.. "," ..v3.. "," ..v4.. "," ..v5.. "," ..v6.. ")"
end

function rnd(valor)
	return "\\rnd(" .. valor ..")"
end

function rndx(valor)
	return "\\rndx(" .. valor ..")"
end

function rndy(valor)
	return "\\rndy(" .. valor ..")"
end

function rndz(valor)
	return "\\rndz(" .. valor ..")"
end

function vc(tipo, v1, v2, v3, v4)
va1 = ConvColor(v1)	
va2 = ConvColor(v2)	
va3 = ConvColor(v3)	
va4 = ConvColor(v4)	
	return "\\".. tipo .."vc(" ..va1.. "," ..va2.. "," ..va3.. "," ..va4.. ")"
end

function va(tipo, v1, v2, v3, v4)
	return "\\".. tipo .."va(" ..v1.. "," ..v2.. "," ..v3.. "," ..v4.. ")"
end

function img(tipo, imge, v1, v2)
	if not v1 and not v2 then
		return "\\".. tipo .."img(" ..imge.. ")"
	else
		return "\\".. tipo .."img(" ..imge.. "," ..v1.. "," ..v2.. ")"
	end
end

function mover(valorx1, valory1, valorx2, valory2, ang1, ang2, rad1, rad2, ti, tf) 
	if not ti and not tf then
		return "\\mover(" .. valorx1.. "," ..valory1.. ",".. valorx2..","..valory2..","..ang1.. "," ..ang2.. ",".. rad1..","..rad2..")"
	else
		return "\\mover(" .. valorx1.. "," ..valory1.. ",".. valorx2..","..valory2..","..ang1.. "," ..ang2.. ",".. rad1..","..rad2..","..math.floor(ti)..","..math.floor(tf)..")"
	end
end

function moves3(valorx1, valory1, valorx2, valory2, valorx3, valory3, ti, tf) 
	if not ti and not tf then
		return "\\moves3(" .. valorx1.. "," ..valory1.. ",".. valorx2..","..valory2..",".. valorx3.. "," ..valory3..")"
	else
		return "\\moves3(" .. valorx1.. "," ..valory1.. ",".. valorx2..","..valory2..",".. valorx3.. "," ..valory3..","..math.floor(ti)..","..math.floor(tf)..")"
	end
end

function moves4(valorx1, valory1, valorx2, valory2, valorx3, valory3, valorx4, valory4, ti, tf) 
	if not ti and not tf then
		return "\\moves4(" .. valorx1.. "," ..valory1.. ",".. valorx2..","..valory2..",".. valorx3.. "," ..valory3..",".. valorx4.. "," ..valory4.. ")"
	else
		return "\\moves4(" .. valorx1.. "," ..valory1.. ",".. valorx2..","..valory2..",".. valorx3.. "," ..valory3..",".. valorx4.. "," ..valory4.. ","..math.floor(ti)..","..math.floor(tf)..")"
	end
end

function jitter(v1, v2, v3, v4, v5, v6)
	if not v6 then
		return "\\jitter(" ..v1.. "," ..v2.. "," ..v3.. "," ..v4.. "," ..v5.. ")"
	else
		return "\\jitter(" ..v1.. "," ..v2.. "," ..v3.. "," ..v4.. "," ..v5.. ","..v6..")"
	end
end

function movevc(valorx1, valory1, valorx2, valory2, ti, tf) 
	if not valorx2 and not valory2 and not ti and not tf then
		return "\\movevc(" .. valorx1.. "," ..valory1.. ")"
	elseif not ti and not tf then
		return "\\movevc(" .. valorx1.. "," ..valory1.. ",".. valorx2..","..valory2..")"
	else
		return "\\movevc(" .. valorx1.. "," ..valory1.. ",".. valorx2..","..valory2..","..math.floor(ti)..","..math.floor(tf)..")"
	end
end


-- ########################
-- ## EXPRESSÃO ASS ZHEO ##
-- ########################

function fscxy(valorx, valory)
	if not valory then
		return "\\fscx" ..valorx.. "\\fscy" ..valorx..""
	else
		return "\\fscx" ..valorx.. "\\fscy" ..valory..""
	end
end

-- ###############################
-- ## EXPRESSÃO ASS Leinad4Mind ##
-- ###############################

-- Função de Todas as Cores
function cores(valor1, valor2, valor3, valor4)

local C1=valor1;
local C2=valor2;
local C3=valor3;
local C4=valor4;
local RES="";

-- Se receber as cores como 'AABBCC' adiciona o respectivo código
larval1 = string.len(valor1)
		if larval1 <= 6 then
			C1="&H" ..valor1.. "&"
		end
larval2 = string.len(valor2)
		if larval2 <= 6 then
			C2="&H" ..valor2.. "&"
		end
larval3 = string.len(valor3)
		if larval3<= 6 then
			C3="&H" ..valor3.. "&"
		end
larval4 = string.len(valor4)
		if larval4 <= 6 then
			C4="&H" ..valor4.. "&"
		end

-- Depois de todo código estar como deveria
if valor1 and valor2 and valor3 and valor4 then
	if valor1 ~= "" and valor2 ~= "" and valor3 ~= "" and valor4 ~= "" then
			RES="\\1c" ..C1.."\\2c" ..C2.."\\3c" ..C3.."\\4c" ..C4..""
		elseif valor1 == "" and valor2 ~= "" and valor3 ~= "" and valor4 ~= "" then
			RES="\\2c" ..C2.."\\3c" ..C3.."\\4c" ..C4..""
		elseif valor1 ~= "" and valor2 == "" and valor3 ~= "" and valor4 ~= "" then
			RES="\\1c" ..C1.."\\3c" ..C3.."\\4c" ..C4..""
		elseif valor1 ~= "" and valor2 ~= "" and valor3 == "" and valor4 ~= "" then
			RES="\\1c" ..C1.."\\2c" ..C2.."\\4c" ..C4..""
		elseif valor1 ~= "" and valor2 ~= "" and valor3 ~= "" and valor4 == "" then
			RES="\\1c" ..C1.."\\2c" ..C2.."\\3c" ..C3..""
		elseif valor1 == "" and valor2 == "" and valor3 ~= "" and valor4 ~= "" then
			RES="\\3c" ..C3.."\\4c" ..C4..""
		elseif valor1 ~= "" and valor2 == "" and valor3 == "" and valor4 ~= "" then
			RES="\\1c" ..C1.."\\4c" ..C4..""
		elseif valor1 ~= "" and valor2 == "" and valor3 ~= "" and valor4 == "" then
			RES="\\1c" ..C1.."\\3c" ..C3..""
	end
	
	elseif valor1 and valor2 and valor3 and not valor4 then
		if valor1 ~= "" and valor2 ~= "" and valor3 ~= "" then
				RES="\\1c" ..C1.."\\2c" ..C2.."\\3c" ..C3..""
			elseif valor1 == "" and valor2 ~= "" and valor3 ~= "" then
				RES="\\2c" ..C2.."\\3c" ..C3..""
			elseif valor1 ~= "" and valor2 == "" and valor3 ~= "" then
				RES="\\1c" ..C1.."\\3c" ..C3..""
			elseif valor1 ~= "" and valor2 ~= "" and valor3 == "" then
				RES="\\1c" ..C1.."\\2c" ..C2..""
			elseif valor1 == "" and valor2 ~= "" and valor3 == "" then
				RES="\\2c" ..C2..""
			elseif valor1 == "" and valor2 == "" and valor3 ~= "" then
				RES="\\3c" ..C3..""
		end

	elseif valor1 and valor2 and not valor3 and not valor4 then
		if valor1 ~= "" and valor2 ~= "" then
				RES="\\1c" ..C1.."\\2c" ..C2..""
			elseif valor1 == "" and valor2 ~= "" then
				RES="\\2c" ..C2..""
			elseif valor1 ~= "" and valor2 == "" then
				RES="\\1c" ..C1..""
		end
	
	elseif valor1 and not valor2 and not valor3 and not valor4 then
		if valor1 ~= "" then
			RES="\\1c" ..C1..""
			else
			RES=""
		end
end

return RES

end
-- FIM da Função de Todas as Cores

-- Função de Todas as Cores para line.styleref.color#
function cores3(valor1, valor2, valor3, valor4)

if valor1:gsub("&H(..)......&","%1") == "00" then
	local C1=valor1:gsub("&H00(......&)","&H%1");
else
	local C1=valor1:gsub("&H(..)(......&)","&H%2\\1a&H%1&");
end
if valor2:gsub("&H(..)......&","%1") == "00" then
	local C2=valor2:gsub("&H00(......&)","&H%1");
else
	local C2=valor2:gsub("&H(..)(......&)","&H%2\\2a&H%1&");
end
if valor3:gsub("&H(..)......&","%1") == "00" then
	local C3=valor3:gsub("&H00(......&)","&H%1");
else
	local C3=valor3:gsub("&H(..)(......&)","&H%2\\3a&H%1&");
end
if valor4:gsub("&H(..)......&","%1") == "00" then
	local C4=valor4:gsub("&H00(......&)","&H%1");
else
	local C4=valor4:gsub("&H(..)(......&)","&H%2\\4a&H%1&");
end
	
local RES="";

-- Depois de todo código estar como deveria
if valor1 and valor2 and valor3 and valor4 then
	if valor1 ~= "" and valor2 ~= "" and valor3 ~= "" and valor4 ~= "" then
			RES="\\1c" ..C1.."\\2c" ..C2.."\\3c" ..C3.."\\4c" ..C4..""
		elseif valor1 == "" and valor2 ~= "" and valor3 ~= "" and valor4 ~= "" then
			RES="\\2c" ..C2.."\\3c" ..C3.."\\4c" ..C4..""
		elseif valor1 ~= "" and valor2 == "" and valor3 ~= "" and valor4 ~= "" then
			RES="\\1c" ..C1.."\\3c" ..C3.."\\4c" ..C4..""
		elseif valor1 ~= "" and valor2 ~= "" and valor3 == "" and valor4 ~= "" then
			RES="\\1c" ..C1.."\\2c" ..C2.."\\4c" ..C4..""
		elseif valor1 ~= "" and valor2 ~= "" and valor3 ~= "" and valor4 == "" then
			RES="\\1c" ..C1.."\\2c" ..C2.."\\3c" ..C3..""
		elseif valor1 == "" and valor2 == "" and valor3 ~= "" and valor4 ~= "" then
			RES="\\3c" ..C3.."\\4c" ..C4..""
		elseif valor1 ~= "" and valor2 == "" and valor3 == "" and valor4 ~= "" then
			RES="\\1c" ..C1.."\\4c" ..C4..""
		elseif valor1 ~= "" and valor2 == "" and valor3 ~= "" and valor4 == "" then
			RES="\\1c" ..C1.."\\3c" ..C3..""
	end
	
	elseif valor1 and valor2 and valor3 and not valor4 then
		if valor1 ~= "" and valor2 ~= "" and valor3 ~= "" then
				RES="\\1c" ..C1.."\\2c" ..C2.."\\3c" ..C3..""
			elseif valor1 == "" and valor2 ~= "" and valor3 ~= "" then
				RES="\\2c" ..C2.."\\3c" ..C3..""
			elseif valor1 ~= "" and valor2 == "" and valor3 ~= "" then
				RES="\\1c" ..C1.."\\3c" ..C3..""
			elseif valor1 ~= "" and valor2 ~= "" and valor3 == "" then
				RES="\\1c" ..C1.."\\2c" ..C2..""
			elseif valor1 == "" and valor2 ~= "" and valor3 == "" then
				RES="\\2c" ..C2..""
			elseif valor1 == "" and valor2 == "" and valor3 ~= "" then
				RES="\\3c" ..C3..""
		end

	elseif valor1 and valor2 and not valor3 and not valor4 then
		if valor1 ~= "" and valor2 ~= "" then
				RES="\\1c" ..C1.."\\2c" ..C2..""
			elseif valor1 == "" and valor2 ~= "" then
				RES="\\2c" ..C2..""
			elseif valor1 ~= "" and valor2 == "" then
				RES="\\1c" ..C1..""
		end
	
	elseif valor1 and not valor2 and not valor3 and not valor4 then
		if valor1 ~= "" then
			RES="\\1c" ..C1..""
			else
			RES=""
		end
end

return RES

end
-- FIM da Função de Todas as Cores

function color3(tipo, valor) -- Converte as cores e transparencias do line.styleref.color? para funcionar com o aegis 3.0.0
	if valor:gsub("&H(..)......&","%1") == "00" then
		return valor:gsub("&H00(......&)","\\"..tipo.."c&H%1")
	else
		return valor:gsub("&H(..)(......&)","\\"..tipo.."a&H%1&\\"..tipo.."c&H%2")
	end
end

function estilo3(tipo, valor) -- igual ao color3
	if valor:gsub("&H(..)......&","%1") == "00" then
		return valor:gsub("&H00(......&)","\\"..tipo.."c&H%1")
	else
		return valor:gsub("&H(..)(......&)","\\"..tipo.."a&H%1&\\"..tipo.."c&H%2")
	end
end

function cor3(tipo, valor) -- igual ao color3
	if valor:gsub("&H(..)......&","%1") == "00" then
		return valor:gsub("&H00(......&)","\\"..tipo.."c&H%1")
	else
		return valor:gsub("&H(..)(......&)","\\"..tipo.."a&H%1&\\"..tipo.."c&H%2")
	end
end

function c3(tipo, valor) -- igual ao color3
	if valor:gsub("&H(..)......&","%1") == "00" then
		return valor:gsub("&H00(......&)","\\"..tipo.."c&H%1")
	else
		return valor:gsub("&H(..)(......&)","\\"..tipo.."a&H%1&\\"..tipo.."c&H%2")
	end
end

function frxy(valor)
	return "\\frx" ..valor.. "\\fry" ..valor.. ""
end

function frxz(valor)
	return "\\frx" ..valor.. "\\frz" ..valor.. ""
end

function fryz(valor)
	return "\\fry" ..valor.. "\\frz" ..valor.. ""
end


-- ############
-- ## FORMAS ##
-- ############

-- ## Todas as formas foram separadas desta bilioteca
-- ## e podem-se encontrar em "leinadformas.lua".




-- #######################################
-- ## FUNÇÕES ESPECIAIS POR Leinad4Mind ##
-- #######################################

function ass2conv(tipo,cores)
	local lista = {a = 0, b = 0, c = 0, d=0}
	if string.len(cores) <= 9 then
		local a, b, c = cores:match("&H(%x%x)(%x%x)(%x%x)&")
		lista.a = tonumber(a, 16)
		lista.b = tonumber(b, 16)
		lista.c = tonumber(c, 16)
	else
		local a, b, c, d = cores:match("&H(%x%x)(%x%x)(%x%x)(%x%x)&")
		lista.a = tonumber(a, 16)
		lista.b = tonumber(b, 16)
		lista.c = tonumber(c, 16)
		lista.d = tonumber(d, 16)
	end
	if string.len(cores) <= 9 then
		retorno = string.format("&H%02X%02X%02X&", lista.a, lista.b, lista.c)
	else	if string.format("%02X", lista.a)=="00" then
				retorno = string.format("&H%02X%02X%02X&", lista.b, lista.c, lista.d)
			else
				retorno = string.format("&H%02X%02X%02X&\\"..tipo.."a&H%02X&", lista.b, lista.c, lista.d, lista.a)
			end
	end	
return retorno
end

function kf(valorx,valory,sil,linha)
	--//Calcular a posição inicial e final do clip
	ajuste = 5
	X1 = valorx - (sil / 2 + ajuste)
	X2 = valorx + (sil / 2 + ajuste)
	Y1 = 0
	Y2 = valory + linha + ajuste
		   
	clip_start = clip(X1, Y1, X1 ,Y2)
	clip_end = clip(X1, Y1, X2 ,Y2)
return "\\" ..clip_start..t(clip_end).. ""
end

function altRndRot(dur,interval)
local dir, codestr = 3, "";
if math.random(0,6) == 0 then
		dir = -dir end;
local count = math.ceil(dur/interval);
for i = 1, count do
	codestr = codestr..string.format("\\t(%d,%d,\\frz%g)",(i-1)*interval,i*interval,dir*(math.random(2,29)/5));
	dir = -dir end;
return codestr;
end

-- ################################
-- ## FUNÇÕES ESPECIAIS POR ZHEO ##
-- ################################

function ConvColor(color)
lva1 = string.len(color)
	if lva1 <= 6 then 
		return "&H" ..color.. "&"
	else 
		return "" ..color.. ""
	end
end

function ass2html(cores)
	local lista = {a = 0, b = 0, c = 0, d=0}
	if string.len(cores) <= 9 then
		local a, b, c = cores:match("&H(%x%x)(%x%x)(%x%x)&")
		lista.a = tonumber(a, 16)
		lista.b = tonumber(b, 16)
		lista.c = tonumber(c, 16)
	else
		local a, b, c, d = cores:match("&H(%x%x)(%x%x)(%x%x)(%x%x)&")
		lista.a = tonumber(a, 16)
		lista.b = tonumber(b, 16)
		lista.c = tonumber(c, 16)
		lista.d = tonumber(d, 16)
	end
	if string.len(cores) <= 9 then
		retorno = string.format("&H%02X%02X%02X&", lista.c, lista.b, lista.a)
	else
		retorno = string.format("&H%02X%02X%02X&", lista.d, lista.c, lista.b)
	end	
return retorno
end

function cpf(tipo, cord1, cord2) --Coordenadas Para Formas
	if tipo == 0 then
		espa = ""..""
	else
		espa = tipo.." "
	end
return ""..espa.. math.floor(cord1).. " " .. math.floor(cord2) .. " "
end

function sil(txt)
	if not txt then
		for i = 1, l.kara.n do
			local SIL = l.kara[i].text_stripped
			i = i+1
		end
		return ""..SIL..""
	else
		SIL = txt.text_stripped
		return ""..SIL..""
	end
end

function GetFrame(t)
	return aegisub.frame_from_ms(t)
end

function GetMs(t)
	return aegisub.ms_from_frame(t)
end

function rand(valorn, valorp)
	if not valorn and not valorp then 
		return math.random(999)
	elseif not valorp then
		return math.random(-valorn, valorn)
	end
return math.random(valorn, valorp)    
end

function randa(valorn, valorp) --Random pra Hexadecimais
	if not valorn and not valorp then 
		return string.format("%02X",math.random(255))
	elseif not valorp then
		return string.format("%02X",math.random(-valorn, valorn))
	end
 return string.format("%02X",math.random(valorn, valorp))
end

function RangeColor(tipo, tr, varc1, varc2)
return "\\"..tipo.."c"..interpolate_color(tr, ConvColor(varc1), ConvColor(varc2))..""
end

function RangeAlpha(tipo, tr, varc1, varc2)
lc1 = string.len(varc1)
lc2 = string.len(varc2)
    if lc1 <= 2 or lc2 <= 2 then
        c1m = "&H"..varc1.."&"
        c2m = "&H"..varc2.."&"
    else
        c1m = varc1
        c2m = varc2
    end
	return "\\"..tipo.."a"..interpolate_alpha(tr, c1m, c2m)..""
end

function Glow(valor, bvalor, cvalor)
	return bord(valor)..blur(bvalor)..c(3, cvalor)
end

function GenPosNeg()
genera_pos_neg = math.random(-1,1)
    if genera_pos_neg == 0 then
		genera_pos_neg = 1
    end
	return genera_pos_neg
end

function Curve(intpol, x_ini, y_ini,  x_int1, y_int1, x_int2, y_int2, x_fin, y_fin)
curvx1 = interpolate(intpol, x_ini, x_int1)
curvx2 = interpolate(intpol, curvx1, x_int2)
curvx3 = interpolate(intpol, curvx2, x_fin)
curvy1 = interpolate(intpol, y_ini, y_int1)
curvy2 = interpolate(intpol, curvy1, y_int2)
curvy3 = interpolate(intpol, curvy2, y_fin)
cur_x, cur_y = curvx3, curvy3
	return cur_x, cur_y
end


-- ##################################
-- ## FUNÇÕES ESPECIAIS POR NANDE! ##
-- ##################################

function RandomColor()
colores = {'0','1','2','3','4','5','6','7','8','9','a','b','c','d','e','f'}
rand_color= ""
	for j = 0,5 do
		rand_color = rand_color .. colores[math.random(1,15)]
	end
	return rand_color
end


-- ###################################
-- ## FUNÇÕES ESPECIAIS POR NICKLES ##
-- ###################################

function GenCirculo(radio,centrox,centroy,angulo,movimiento)
 posx=centrox + radio*math.cos(angulo)
 posy=centroy + radio*math.sin(angulo)
 
 if not movimiento then
   return string.format("\\pos(%d,%d)",posx,posy)
 else
   posx1=centrox + (radio+movimiento)*math.cos(angulo)
   posy1=centroy + (radio+movimiento)*math.sin(angulo)
   return string.format("\\move(%d,%d,%d,%d)",posx,posy,posx1,posy1)
 end
end

function GenBucle(base,altura)
area=(math.ceil(base)*math.ceil(altura))/4
	return area
end

function GenElipse(x,y,a,b,angulo)
 posx=x+a*math.cos(angulo)
 posy=y+b*math.sin(angulo)
 return string.format("\\pos(%d,%d)",posx,posy)
end

function GenParabola(x,y,p,angulo,tipo) 
 if not tipo or tipo==1 then
 --parabola Horizontal
  posx=x+(p/2)*((1/math.tan(angulo))^2)
  posy=y+p*(1/math.tan(angulo))
 elseif tipo==2 then
 --parabola vertical
  posx=x+p*(1/math.tan(angulo))
  posy=y+(p/2)*((1/math.tan(angulo))^2)
 end
 return string.format("\\pos(%d,%d)",posx,posy)
end

function GenHiperbola(x,y,a,b,angulo)
 posx=x+a*(1/math.cos(angulo)) 
 posy=y+b*math.tan(angulo)
return string.format("\\pos(%d,%d)",posx,posy)
end

function GenMariposa(x,y,a,b,c,d,angulo) -- Beta
 posx=x+(a*math.sin(angulo))*(math.exp(math.cos(angulo))-(c*math.cos(4*angulo))-(math.sin(angulo/12))^5)
 posy=y+(b*math.cos(angulo))*(math.exp(math.cos(angulo))-(d*math.cos(4*angulo))-(math.sin(angulo/12))^5)
 return string.format("\\pos(%d,%d)",posx,posy)
end

function convAlpha(tipo,valor)
	-- CONFIGURAÇÕES PRÉVIAS
	sin_tipo = false
	if not valor then
		valor = tipo
		sin_tipo = true
		tipo = 1
	end
	
	if tipo < 0 or tipo > 3 then
		tipo = 0
	end
	
	if  type(valor) == "string" then -- PARA ALPHA HEXADECIMAL
		if sin_tipo then
			return "\\alpha&H" ..valor.. "&"
		else
			return "\\"..tipo.."a&H"..valor.."&"	
		end
	else
		if sin_tipo then -- PARA ALPHA DECIMAL
			return "\\alpha"..ass_alpha(valor)..""
		else
			return "\\" ..tipo.. "a"..ass_alpha(valor)..""	
		end	
	end	
end


-- ######################################
-- ## FUNÇÕES ESPECIAIS POR ALQUIMISTA ##
-- ######################################

function GenEspiral(radio,x,y,a,b,angulo)
radio=a + b*(angulo)
-- PASSAR DE POLAR A RECTUANGULAR
posx=x+radio*math.cos(angulo)
posy=y+radio*math.sin(angulo)

	return posx,posy
end

--[[ Espiral de Arquimedes - USO:

l=table.copy(line)
nparticulas=360*2
for z=0,nparticulas do
 angulo=math.rad(z)
 genespiral(radio,x,y,0.005,1,angulo) -- genespiral(radio,x,y,a,b,angulo)
 l.start_time=line.start_time+syl.start_time
 l.end_time=l.start_time+syl.duration
 l.text="{"..an(5)..pos(posx,posy)..color(1,line.styleref.color2)..bord(0).."}"..p(1,'m 0 0 l 1 0 1 1 0 1')
 subs.append(l)
end
]]

function GenCoseno(x,y,angulo,ancho,altura,margenleft)
posx=margenleft+((angulo)*ancho)
posy=y+(math.cos(angulo)*altura)
	return posx,posy
end

--[[ GRAFICAR FUNCION COSENO - USO:
-- http://i.imgur.com/bWHeN.png

ciclo=16/2-- não modificar
nondas=20 -- pode-se alterar (o número de curvas que se deseje)
nparticulas=ciclo*nondas

for z=0,nparticulas do
     if z==0 then
         angulo=0
     end           
     l=table.copy(line)
     fcoseno(x,y,angulo,10,10,20) --fcoseno(x,y,angulo,altura,ancho,margenleft)
     l.text="{"..an(5)..pos(posx,posy)..color(1,'DB7E22')..bord(0).."}"..p(1,Formas(1))
     l.start_time=line.start_time
     l.end_time=line.end_time
     l.layer = 0
     subs.append(l)
     angulo=angulo+(math.pi/8) --(math.pi/8) pode-se alterar, tem que ser em radianos
end
]]

function GenSencos(funcion,angulo,ancho,altura)
if funcion==1 then --seno
	posy=y-(altura*math.sin(angulo)) 
elseif funcion==2 then --coseno
	posy=y-(altura*math.cos(angulo))
end
posx=line.left+(ancho*(angulo))
	return string.format("\\pos(%d,%d)",posx,posy)
end

--[[ GRAFICAR LAS 2 FUNCIONES - USO:
-- http://i.imgur.com/8uJ8s.png

for j=0,1 do
	if j==0 then
		f=1 --seno
	else
		f=2	 --coseno
	end	
	for k=0,80 do
		if k==0 then
			angulo=math.rad(0)
		else
			angulo=angulo + math.rad(22.5)	
		end		
		l=table.copy(line)
		l.text="{"..an(5)..gfuncion(f,angulo,10,15)..color(1,'DB7E22')..bord(0).."}"..p(1,Formas(1))
		l.start_time=line.start_time
		l.end_time=line.end_time
		l.layer = j
		subs.append(l)
	end 
end
]]

function tag2tag(duracao, intervalo, tag1, tag2)
    nintervalo = math.ceil(duracao / intervalo)
    for i = 1, nintervalo do
       tfin = i * intervalo
       if i == 1 then
           ttags, tini = "", 0
       elseif i == nintervalo then
           tfin = duracao
       end
       if  i % 2 == 0 then
          ttags = ttags .. t(tt(tini,tfin) .. tag1)
       else
          ttags = ttags .. t(tt(tini,tfin) .. tag2)
       end
       tini = tfin
    end
return ttags
end

--[[ TAG 2 TAG
### Há que colocar esse zero.
Usando: tag2tag(10, 185, 10, {[0]='be','blur', 'bord'})
Resultado: \t(10,20,be)\t(20,30,blur)\t(30,40,bord)...\t(170,185,blur)

### Forma de uso
	## Primeiro há que atribuir a função a uma variável:

		t2t = tag2tag(line.duration, 200, tags1, tags2)

	tag2tag(<duração>, <intervalo_tempo>, <expressao>, <expressao>)
	## Na duração podes usar diferentes valores, por exemplo

	line.duration
	syl.duration
	400, 500, etc.
	
	## Para os valores de expressões podes usar por exemplo

		tags1 = frz(-8)..fscxy(110)
		tags2 = frz(8)..fscxy(100)
		
	## Depois disso já se pode meter nos efeitos no "l.text".
	
		......
		l.text = "{"..an(5)..pos(x,y)..t2t.."}"..sil()
		......
]]--

function tag2tags(inicio, duracao, intervalo, tags)
    i = 0
    ttags = "" 
    tini = inicio 
    tfin = inicio + intervalo
    ntags = #tags + 1
    num = math.floor((duracao - inicio) / intervalo)
    while tfin <= duracao do
		-- Proibido remover este if, é necessário que
		-- termine sempre com o valor da duração.
        if i == (num-1) then
            tfin = duracao
        end
        ttags = ttags .. t(tt(tini,tfin) .. tags[i%ntags])
        tini = tfin
        -- A linguagem lua não aceita o += :/ Por isso é que gosto de python 
        tfin = tfin + intervalo
        i = i + 1
    end
    return ttags
end


-- ###################################
-- ## FUNÇÕES ESPECIAIS POR ASEDARK ##
-- ###################################

function AutoTimer(TipoDeLinha,Intervalo,Tag,ValorInicialTag,AumentoTag,MaisEMenos)

	local RESULTADO_01 = 0
	RESULTADO_01=""
	local RESULTADO_02 = 0
	RESULTADO_02=""
	local DIRECAO =1

-- AQUI DEFINE-SE OS TIPOS DE LINHA
	for i = 1, l.kara.n do

		local SILABA = l.kara[i];
		local LINEA = l;
		local LINEA_INICIO = LINEA.start_time;
		local SILABA_INICIO = SILABA.start_time;
		local LINEA_DURACION = LINEA.duration;
			
		if TipoDeLinha == TE1 then -- EFEITO DE ENTRADA
		DURACAO =(LINEA_INICIO-800)/Intervalo
		end
		
		if TipoDeLinha == TE2 then -- EFEITO DE SÍLABA ESTATICA 01
		DURACAO =((LINEA_INICIO)/Intervalo)
		end

		if TipoDeLinha == TE3 then -- EFEITO DE SÍLABA ACTIVA
		DURACAO =(LINEA_INICIO+SILABA_INICIO)/Intervalo
		end
		
		if TipoDeLinha == TE4 then -- EFEITO DE SAÍDA
		DURACAO =(LINEA_DURACION)/Intervalo
		end	
	end

local count = math.ceil(DURACAO)
if math.random(0,1) == 0 then
	DIRECAO = -DIRECAO
end
for i = 1, count do
		ValorTagAumento=ValorInicialTag+(i*AumentoTag)
		RESULTADO_01 = RESULTADO_01 .."\\t(" ..(i-1)*Intervalo.. "," ..i*Intervalo.. ",\\" ..Tag..DIRECAO*ValorTagAumento..")"..""
		RESULTADO_02 = RESULTADO_02 .."\\t(" ..(i-1)*Intervalo.. "," ..i*Intervalo.. ",\\" ..Tag..ValorTagAumento..")"..""
		DIRECAO = -DIRECAO
	end
	if MaisEMenos == 1 then
		return RESULTADO_01
	elseif MaisEMenos == 0 then
		return RESULTADO_02
	end
end


function AutoTags(TipoDeLinha,Intervalo,Dados1,Dados2)

	local RESULTADO = 0 
	RESULTADO=""
	local SORTE = 0
	local CONTADOR = 0
	local REGULADOR = 0
 
-- AQUI DEFINE-SE OS TIPOS DE LINHA
	for i = 1, l.kara.n do

		local SILABA = l.kara[i];
		local LINHA = l;
		local LINHA_INICIO = LINHA.start_time;
		local SILABA_INICIO = SILABA.start_time;
		local LINHA_DURACION = LINHA.duration;
		
		if TipoDeLinha == TE1 then -- EFECTO DE ENTRADA
		DURACAO =(LINEA_INICIO-800)/Intervalo
		end
		
		if TipoDeLinha == TE2 then -- EFECTO DE SILABA ESTATICA 01
		DURACAO =((LINHA_INICIO)/Intervalo)
		end

		if TipoDeLinha == TE3 then -- EFECTO DE SILABA ACTIVA
		DURACAO =(LINHA_INICIO+SILABA_INICIO)/Intervalo
		end
		
		if TipoDeLinha == TE4 then -- EFECTO DE SALIDA
		DURACAO =(LINHA_DURACION)/Intervalo
		end
	end
-- >>>>>>>>>>>>>> FIM DOS TIPOS DE LINHA
 local count = math.ceil(DURACAO) 
-- >>>>>>>>>>>>>> CONTENTOR DE TAGS+VALORES [DADOS]
REGULADOR = {Dados1,Dados2}
-- >>>>>>>>>>>>>> FIM DO CONTENTOR
 for i = 1, count do  
    CONTADOR = i
	--|||| 02 DADOS
		if Dados1 and Dados2 then 
					if  CONTADOR%2 ==0 then
								SORTE = REGULADOR[1]
					else
								SORTE = REGULADOR[2]
					end	
		end 
	RESULTADO = RESULTADO .."\\t(" ..(i-1)*Intervalo.. "," ..i*Intervalo.. ",\\" ..SORTE..")".."" 
end   		
return RESULTADO	  		 
end 


function frxyz(valorx,valory,valorz)
	local VAZIO = 0

		if  valorx and valory and valorz and valorx ~=VAZIO and valory ~=VAZIO and valorz ~=VAZIO then --..frxyz(50,60,70)|..frxyz(~=0,~=0,~=0)
			giroXYZ = "\\frx" ..math.floor(valorx).. "\\fry" ..math.floor(valory).. "\\frz" ..math.floor(valorz)..""
			return giroXYZ		
		else
			if not valorz and valorx and valory and valorx ~=VAZIO and valory ~=VAZIO then  --..frxyz(50,60)
				giroXY_1 = "\\frx" ..math.floor(valorx).. "\\fry" ..math.floor(valory).. ""
				return giroXY_1
			end	
			if valorx and valorx ~= 0  and not valory and not valorz then --..frxyz(50)|--..frxyz(~=0)
				giroXYZall = "\\frx" ..math.floor(valorx).. "\\fry" ..math.floor(valorx).. "\\frz" ..math.floor(valorx)..""
				return giroXYZall
			end
			if valorx and valory and valorz and valorx ~=VAZIO and valory ~=VAZIO and valorz == 0 then --..frxyz(50,60,0)
				giroXY = "\\frx" ..math.floor(valorx).. "\\fry" ..math.floor(valory)..""
				return giroXY
			end	
			if valorx and valory and valorz and valorx~=VAZIO and valory == 0 and valorz==0 then --..frxyz(50,0,0)
				giroX = "\\frx" ..math.floor(valorx)..""
				return giroX
			end	
			if valorx and valory and not valorz and valorx~=VAZIO and valory == 0  then --..frxyz(50,0)
				giroX = "\\frx" ..math.floor(valorx)..""
				return giroX
			end	
			if valorx and valory and valorz and valorx ~=VAZIO and valory == 0 and valorz ~=VAZIO then  --..frxyz(50,0,70)
				giroXZ = "\\frx" ..math.floor(valorx).. "\\frz" ..math.floor(valorz)..""
				return giroXZ
			end		
			if valorx and valory and valorz and valorx == 0 and valory ~=VAZIO and valorz ~=VAZIO then --..frxyz(0,60,70)
				giroYZ = "\\fry" ..math.floor(valory).. "\\frz" ..math.floor(valorz)..""
				return giroYZ
			end	
			if valorx and valory and valorz and valorx == 0 and valory ~=VAZIO and valorz == 0 then --..frxyz(0,60,0)
				giroYZ = "\\fry" ..math.floor(valory)..""
				return giroYZ
			end
			if valorx and valory and valorz and valorx == 0 and valory == 0 and valorz ~=VAZIO then --..frxyz(0,0,70)
				giroYZ = "\\frz" ..math.floor(valorz)..""
				return giroYZ
			end							
			if valorx and valory and valorz and valorx == 0  and valory == 0 and valorz == 0 then --..frxyz(0,0,0) -- DESACTIVA TODOS OS TAGS
				giroNotXYZ = "\\frx" ..math.floor(valorx).. "\\fry" ..math.floor(valory).. "\\frz" ..math.floor(valorz)..""
				return giroNotXYZ 
			end
			if valorx and valory and valorx == 0  and valory ==0 and not valorz  then --..frxyz(0,0)
				giroNotXYZ_2 = ""
				return giroNotXYZ_2
			end
			if valorx and valorx == 0  and not valory and not valorz  then --..frxyz(0) -- DESACTIVA TODOS OS TAGS
				giroNotXYZ_3 = "\\frx" ..math.floor(valorx).. "\\fry" ..math.floor(valory).. "\\frz" ..math.floor(valorz)..""
				return giroNotXYZ_3
			end		

		end			
end


-- ###################################
-- ## FUNÇÕES ESPECIAIS POR DgrayGT ##
-- ###################################

-- Modo de Uso:
-- length: la longitud de los rayos, por pixeles desde 0 hasta su gusto xD
-- strength: es la fuerza de los rayos, en porcentaje de 0 hasta 100 
-- scale: es el tamaño final de los rayos, se usa para setear el angulo de los rayos respecto del origen. va de 0 hasta su gusto
-- X & Y: posiciones u origen de los rayos.
-- Mode1 & (OPCIONAL)Mode2: es para controlar los movimientos de los rayos si es que asi lo quisieramos es igual a la alineacion \an1-9,
--  el mode 1 indica la posicion de los rayos inicialmente y el mode2 la posicion final. si no quieren movimiento solo se coloca mode1.
--
-- time1,time2: opciones para cuando usamos la opcion mode2 y da el tiempo que tardan los rayos en moverse de la posicion inicial a la final.
--

function Get_Shine(index,maxloop,strength,scale,x,y,mode1,mode2,time1,time2)
       if not mode2 then
            setmod = "pos"
            else
            setmod = "move"
       end
           set_a = _G.ass_alpha(math.ceil((strength*0.01)*255))
           int_alpha = _G.interpolate_alpha(index/maxloop , set_a , "&HFF&" )
           x_size,y_size = 100+(index*scale) , 100+(index*scale)
           tsh1,tsh2 = 0+(index-1)*2 , 0+(index)*2
            -- MODE 1--
           if mode1 == 1 then
               x_pos,y_pos = x-(index-1) , y+(index-1)
               elseif mode1 == 2 then
                   x_pos,y_pos = x , y+(index-1)
           end
           if mode1 == 3 then
               x_pos,y_pos = x+(index-1) , y+(index-1)
               elseif mode1 == 4 then
                   x_pos,y_pos = x-(index-1) , y
           end
           if mode1 == 5 then
               x_pos,y_pos = x , y
               elseif mode1 == 6 then
               x_pos,y_pos = x+(index-1) , y
           end
           if mode1 == 7 then
               x_pos,y_pos = x-(index-1) , y-(index-1)
               elseif mode1 == 8 then
                   x_pos,y_pos = x , y-(index-1)
           end
           if mode1 == 9 then
                x_pos,y_pos = x+(index-1) , y-(index-1)
           end
           --MODE 2--
           if mode2 == 1 then
               x_pos2,y_pos2 = x-(index-1) , y+(index-1)
               elseif mode2 == 2 then
                   x_pos2,y_pos2 = x , y+(index-1)
           end
           if mode2 == 3 then
               x_pos2,y_pos2 = x+(index-1) , y+(index-1)
               elseif mode2 == 4 then
                   x_pos2,y_pos2 = x-(index-1) , y
           end
           if mode2 == 5 then
               x_pos2,y_pos2 = x , y
               elseif mode2 == 6 then
                   x_pos2,y_pos2 = x+(index-1) , y
           end
           if mode2 == 7 then
               x_pos2,y_pos2 = x-(index-1) , y-(index-1)
               elseif mode2 == 8 then
                   x_pos2,y_pos2 = x , y-(index-1)
           end
           if mode2 == 9 then
                x_pos2,y_pos2 = x+(index-1) , y-(index-1)
           end
           if setmod == "pos" then
               intpos = x_pos..","..y_pos
               shine = "\\"..setmod.."("..intpos..")".."\\alpha&HFF&".."\\fscx"..x_size.."\\fscy"..y_size.."\\t("..tsh1..","..tsh2..",\\alpha"..int_alpha..")"
           elseif setmod == "move" then
               intpos = x_pos..","..y_pos..","..x_pos2..","..y_pos2
               shine = "\\"..setmod.."("..intpos..","..time1..","..time2..")".."\\alpha&HFF&".."\\fscx"..x_size.."\\fscy"..y_size.."\\t("..tsh1..","..tsh2..",\\alpha"..int_alpha..")"
           end
       return shine
  end


-- Modo de Uso:
-- Valst: aca colocamos el intervalo de tiempo que tendra cada tag.
-- Data1: es para poner el primer valor de las variables a generar.
-- Data2: valores para el segundo valor de las variables a generar.
-- 
-- Data3(Opcional): es para setear un valor neutro o sea si hacemos
--  uso de este valor las variables irian desde data1 hasta data3 y
--  de data3 a data 2 sucesivamente (como pueden ver en el video de ejemplo)
--

  function GetVTags(ldur,valst,data1,data2,data3)
   		if not data3 then
   			setmode = 2
   			else
   				setmode = 4
   		end
   		sylvi = "" time1 = 0 index = 0
   		while time1 < ldur do
   			in2=1 index = (index+in2)%setmode
   			if setmode == 2 then
   				if index == 1 then
   					setdata = data1
  						elseif index == 0 then
  							setdata = data2
  				end
  				elseif setmode == 4 then
  					if index == 1 then
  						setdata = data1
  							elseif index == 2 then
  								setdata = data3
  					end
  					if index == 3 then
  						setdata = data2
  							elseif index == 0 then
  								setdata = data3
  					end
  			end
  			val = valst
   			sylvi = sylvi.."\\t("..time1..","..time1+val..","..setdata..")"
   			time1 = time1+val
   		end
   	return sylvi
   end
   
-- Gradiente Horizontal
-- Modo de Uso:
-- degrad4you(cont, maxcont, setn, dgn, color1 , color2 ,  color3, color4 , color5)
-- cont= contador de iterações "j"
-- maxcont= maximo de iterações "maxj"
-- setn= cor a qual aplicaremos gradiente: 1. Primária, 2. Secundária, 3. Borda, 4. Sombra
-- dgn= numero de cores que queremos para o gradiente 2-5
-- color1-5= cores para o gradiente em formato .ass
--

function degrad4you(cont, maxcont, setn, dgn, color1 , color2 ,  color3, color4 , color5)
	Amaxcont=maxcont/(dgn-1) Bcont=cont%Amaxcont== 0 and Amaxcont or cont%Amaxcont
	colorset1=color1 colorset2 =color2
		if cont > Amaxcont then
			colorset1=color2 colorset2=color3
		end
		if cont > Amaxcont*2 then
			colorset1=color3 colorset2=color4
		end
		if cont > Amaxcont*3 then
			colorset1=color4 colorset2=color5
		end
	stcolor=string.format("\\%dc%s",setn,_G.interpolate_color(Bcont/Amaxcont, colorset1, colorset2 ))
	clipping=string.format("\\clip(%d,%d,%d,%d)",math.floor(_G.interpolate((j-1)/maxj, math.floor(line.left-5), math.floor(line.right+5))),0,math.floor(_G.interpolate(j/maxj, math.floor(line.left-5), math.floor(line.right+5))), meta.res_y )

	return clipping .."".. stcolor
end

-- ########################################
-- ## FIM DA BIBLIOTECA LeinadCollection ##
-- ########################################