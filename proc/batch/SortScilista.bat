rem SortScilista
rem rem Parametro 1: arquivo scilista original
rem rem Parametro 2: arquivo scilista destino
rem rem Objetivo:    Fazer com que os 'pr' sejam os primeiros individuos da lista de processamento

call batch/VerifPresencaParametro.bat $0 @$1 nome do arquivo scilista original
call batch/VerifExisteArquivo.bat $1
call batch/VerifPresencaParametro.bat $0 @$2 nome do arquivo scilista destino

call batch/InformaLog.bat $0 x Sort scilista: $1 $2

$CISIS_DIR/mx "seq=$1 " "pft=if size(v1)>0 then if v2:'pr' then      v1,' ',v2 if v3>'' then ' ',v3 fi / fi fi" now  > $2
$CISIS_DIR/mx "seq=$1 " "pft=if size(v1)>0 then if v2:'pr' then else v1,' ',v2 if v3>'' then ' ',v3 fi / fi fi" now >> $2

$CISIS_DIR/mx null count=1 "pft=#" now >> $2
