rem findEntities
rem Parametro 1: mx
rem Parametro 2: base artigo
rem Parametro 3: diretorio de temporarios
rem Parametro 4: mz
rem Parametro 5: base accent
rem Parametro 6: lista entidades faltantes


echo zera %3\h
%1 null count=0 create=%3\h

echo zera  create=%3\has_ent
%1 null count=0 create=%3\has_ent

echo Cria base apenas com registros h
%1 %2 btell=0 "bool=HR=$" append=%3\h now -all

echo Cria base com registros h que tenham entidades
%1 %3\h "text=&#" append=%3\has_ent now -all
echo Inverte campos com entidades

%1 %3\has_ent actab=checkEntities\private\isisac.tab fst=@checkEntities\private\entities4.fst fullinv=%3\candidatos_entities_inv

%1 %5 actab=checkEntities\private\isisac.tab "fst=1 0,v1/" fullinv=%3\accent

echo Obtem lista de entidades
%4 %3\candidatos_entities_inv "from=&#" "to=&#99999;" now> %3\found_entities.txt

echo Lista de entidades nao identificadas

%1 seq=%3\found_entities.txt "pft=if l(['%3\accent'],v1)=0 then v1/ fi" now > %3\missing_entities.txt

echo SE HOUVER UMA LISTA DE ENTIDADES NAO IDENTIFICADAS
echo INFORMAR ROBERTA OU FRANCISCO 
echo QUE EXISTEM NOVAS ENTIDADES EM %6

more %3\missing_entities.txt >> %6

more %6
