export PATH=$PATH:.

rem ===== Aumentar o espaco de variaveis de ambiente
rem CONFIG.SYS
rem 

rem doi/create_update/ReadScilista.bat
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
export INFORMALOG=$3
export CISIS_DIR=cisis
PROCESS_DATE=`date +%Y%m%d%H%M%S`

call doi/corrige_update/GeraIssuesDOI.bat $1 $2 $3 $4 $5 $6 
echo Execution end of $0 $1 $2 $3 $4 $5 $6  in  `date`