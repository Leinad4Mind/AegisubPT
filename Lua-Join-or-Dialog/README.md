Join-or-Dialog-Lua-Aegisub
==============================
  
  Este script inclui 2 macros:
  
  1. Concatenar duas linhas com \\N (quebra de linha)
  
    l1: Hello, my name is John.

    l2: I think I've met you before.
    
    -> Hello, my name is John.\NI think I've met you before.
    
  2. Criar diálogo a partir de duas linhas adicionado –
  
    l1: Hello, my name is John.

    l2: Nice to meet you! I'm Frank.
    
    -> – Hello, my name is John.\N– Nice to meet you! I'm Frank.


Por fazer
-----------------
* Creio que já está tudo feito, mas estarei disposto a melhorar se houver dicas para tal.


Como instalar
--------------

Load Automático

1. Transferir join-or-dialogue.lua
2. Colocar esse ficheiro na pasta _autoload_ situada dentro da pasta _automation_ que por sua vez está presenta na sua pasta de instalação do aegisub


Load Manual

1. Transferir join-or-dialogue.lua e guarde-o onde bem desejar
2. Com o Aegisub aberto, quando desejar usá-lo terá de clicar em Automatização -> Automatização...
3. Clicar de seguida em _Adicionar_ e ir ao local onde se encontra o join-or-dialogue.lua


Como usar
---------

Basta executar esta automatização.
