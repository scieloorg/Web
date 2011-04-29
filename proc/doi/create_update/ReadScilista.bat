export PATH=$PATH:.

rem ===== Aumentar o espaco de variaveis de ambiente
rem CONFIG.SYS
rem 

rem doi/create_update/ReadScilista.bat
rem Parametro 1: create or update
rem Parametro 2: scilista
rem Parametro 3: prefixo doi
rem Parametro 4: user
rem Parametro 5: password
rem Parametro 6: email
rem Parametro 7: art ou ref
rem Parametro 8: pacote ou individual ou no_query

echo Execution begin of $0 $1 $2 $3 $4 $5 $6 $7 $8 $9 in  `date`
export INFORMALOG=temp\doi\create.log

rem Verifica parametros
call batch/VerifPresencaParametro.bat $0 @$1 create or update
call batch/VerifPresencaParametro.bat $0 @$2 scilista

call batch/VerifPresencaParametro.bat $0 @$3 prefixo doi
call batch/VerifPresencaParametro.bat $0 @$4 user
call batch/VerifPresencaParametro.bat $0 @$5 password
call batch/VerifPresencaParametro.bat $0 @$6 email

call batch/VerifPresencaParametro.bat $0 @$7 art ou ref
call batch/VerifPresencaParametro.bat $0 @$8 pacote ou individual ou no_query

rem Inicializa variaveis
export INFORMALOG=x
export CISIS_DIR=cisis
PROCESS_DATE=`date +%Y%m%d%H%M%S`

if [ -f "$2" ]
then
	call batch/CriaDiretorio.bat temp/
	call batch/CriaDiretorio.bat temp/doi/
	call batch/CriaDiretorio.bat temp/doi/proc
	call batch/CriaDiretorio.bat temp/doi/proc/current/
	rm -rf temp/doi/proc/current/*
	doi/create_update/GeraIssuesDOI.bat $1 $2 $7 $8 $3 $4 $5 $6 
	
	call batch/CriaDiretorio.bat temp/doi/bkp/
	rem mv temp/doi/proc/current temp/doi/bkp/proc_$PROCESS_DATE
else 
	echo ERROR: scilista $2 is missing...
fi
echo Execution end of $0 $1 $2 $3 $4 $5 $6 $7 $8 $9 in  `date`
