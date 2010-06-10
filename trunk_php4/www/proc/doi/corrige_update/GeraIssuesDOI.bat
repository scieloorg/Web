rem GeraIssuesDOI
rem Parametro 1: create or update
rem Parametro 2: scilista
rem Parametro 3: arquivo de log
rem Parametro 4: path da producao da SciELO
rem Parametro 5: path do site da Scielo
rem Parametro 6: registro selecionado

echo Execution begin of $0 $1 $2 $3 $4 $5 $6 in  `date`

rem Verifica parametros
call batch/VerifPresencaParametro.bat $0 @$1 scilista

rem Inicializa variaveis
PROCESS_DATE=`date +%Y%m%d%H%M%S`

call batch/CriaDiretorio.bat temp/
call batch/CriaDiretorio.bat temp/doi/
call batch/CriaDiretorio.bat temp/doi/xml/
call batch/CriaDiretorio.bat temp/doi/xml/query
call batch/CriaDiretorio.bat temp/doi/xml/query_result/
call batch/CriaDiretorio.bat temp/doi/xml/query_result/success/

call batch/CriaDiretorio.bat temp/doi/proc/
call batch/CriaDiretorio.bat temp/doi/proc/corrige_update/

cisis/mx "seq=$1 " lw=9000 "pft=if p(v1) and p(v2) then 'doi/corrige_update/GeraIssueDOI.bat 'v1,x1,v2/ fi" now >temp/doi/proc/corrige_update/GeraIssuesDOI.bat

chmod 700 temp/doi/proc/corrige_update/GeraIssuesDOI.bat
call temp/doi/proc/corrige_update/GeraIssuesDOI.bat

rm -rf temp/doi/proc/corrige_update/
echo Execution end of $0 $1 $2 $3 $4 $5 in  `date`
