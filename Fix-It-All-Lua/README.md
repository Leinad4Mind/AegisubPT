Fix-It-All-Lua-Aegisub
========================

Corrige imensos problemas existentes nas legendas SRT:
- Adiciona espaço onde existe reticências no início da frase.
- Corrige os hífens.
- Corrige as plicas por aspas. (Erro comum em OCR)
- Corrige I por l. (Erro comum em OCR)
- Corrige á por à.
- Corrige a quando é há.
- Corrige concerteza para com certeza.
- Corrige porfavor para por Favor.
- Aplica estilo 'Música' às linhas que contém o símbolo musical e aplica-o com todas as suas regras.
- Corrige problema de linhas sobrepostas existentes nos SRTs.
-	v5: Corrige espaço antes da "," ou ";".
-	v5: Corrige problema de reticências. Caso haja 2 pontos ou mais que 3 pontos.
-	v5: Corrige problema de duplo espaço.
-	v5: Corrige diversas onomatopeias, de inglês para português, caso o tradutor tenha deixado alguma em inglês.
- v6: Espaços entre digitos foi resolvido.
- v6: Colocação de pontos nos digitos para separa a casa dos mil.
- v6: Correcção de diversos bugs, inclusive do hífen em diversas ocasiões.
- v7: Corrige trás por traz e vice-versa. (atrás e detrás incluído) 
- v7: Corrige policia para polícia e vice-versa. (quase todos os casos)
- v7:Adiciona espaço após pontuação ( . ! ? ) 
- v7: Depois de pontuação . ou ? ou ! coloca maiúscula caso não haja.
- v8: Corrige"o" por "0" e vicer-versa, problema de OCR 
- v8: Correcção de erros comuns, com diversos casos adicionados
- v8: Se frase termina com reticências e se a próxima se iniciar com minúscula, então adiciona reticências no início da próxima. 
- v9: Correcção de erros comuns melhorado, com mais casos
- v9: Correcção da mesóclise dos verbos dar e fazer.
- v1.0 Em vez de se criar a v10 passou a chamar-se Fix It All v1.0
- Criação de Menus para poder fazer corecção de 2 tipos: Legenda Base Brasileira ou Legenda Base Portuguesa
- Várias protecções de palavras adicionadas e vários erros corrigidos.
- v1.1: Correcção de 4 tipos de erro que ainda estavam presentes.
- v1.2: Correcção definitiva da v1.1

Por fazer
-----------------
* Melhorar a colocação dos símbolos musicais em linhas com \N !


Como instalar
--------------

Load Automático

1. Transferir fixitall.lua
2. Colocar esse ficheiro na pasta _autoload_ situada dentro da pasta _automation_ que por sua vez está presenta na sua pasta de instalação do aegisub


Load Manual

1. Transferir fixitall.lua e guarde-o onde bem desejar
2. Com o Aegisub aberto, quando desejar usá-lo terá de clicar em Automatização -> Automatização...
3. Clicar de seguida em _Adicionar_ e ir ao local onde se encontra o fixitall.lua


Como usar
---------

Basta clicar, o processo é totalmente automatico.
