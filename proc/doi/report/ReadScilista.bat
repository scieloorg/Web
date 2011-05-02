export PATH=$PATH:.

rem ===== Aumentar o espaco de variaveis de ambiente
rem CONFIG.SYS
rem 

rem doi/report/ReadScilista.bat
rem Parametro 1: scilista
rem Parametro 2: resultado
rem Parametro 3: formato xml ou seq
rem Parametro 4: status all or not_doi or doi
rem Parametro 5: status selecao de tipo de registro art ou ref

echo Execution begin of $0 $1 $2 $3 $4 $5 in  `date`

rem Verifica parametros
call batch/VerifPresencaParametro.bat $0 @$1 scilista
call batch/VerifPresencaParametro.bat $0 @$2 resultado
call batch/VerifPresencaParametro.bat $0 @$3 formato xml ou seq
call batch/VerifPresencaParametro.bat $0 @$4 status all or not_doi or doi
call batch/VerifPresencaParametro.bat $0 @$5 selecao de tipo de registro art ou ref ou all

rem Inicializa variaveis
export INFORMALOG=temp\doi\ReadScilista.log
export CISIS_DIR=cisis
PROCESS_DATE=`date +%Y%m%d%H%M%S`

if [ $3 == "xml" ]
then
	echo "<result date=\"`date`\">" > $2
fi

if [ -f "$1" ]
then
	call batch/CriaDiretorio.bat temp/doi/report/

	call doi/report/GeraIssuesReport.bat $1 $2 $3 $4 $5
else 
	if [ $3 == "xml" ]
	then
		echo "\<message type=\"error\"\>scilista $1 is missing...</message\>" >> $2
	else
		echo Error: scilista $1 is missing... >> $2
	fi
fi
if [ $3 == "xml" ]
then
	echo "</result>" >> $2
fi
echo Execution end of $0 $1 $2 $3 $4 $5 in  `date`