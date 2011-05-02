rem GeraIssuesReport
rem Parametro 1: scilista
rem Parametro 2: resultado
rem Parametro 3: formato xml ou seq
rem Parametro 4: selecao de registros por status doi ou not_doi ou all
rem Parametro 4: selecao de registros por tipo art ou ref

echo Execution begin of $0 $1 $2 $3 $4 $5 $6 in  `date`

rem Verifica parametros
call batch/VerifPresencaParametro.bat $0 @$1 scilista
call batch/VerifPresencaParametro.bat $0 @$2 resultado
call batch/VerifPresencaParametro.bat $0 @$3 formato xml ou seq
call batch/VerifPresencaParametro.bat $0 @$4 selecao de registros por status doi ou not_doi ou all
call batch/VerifPresencaParametro.bat $0 @$5 selecao de registros por tipo art ou ref


rem Inicializa variaveis
PROCESS_DATE=`date +%Y%m%d%H%M%S`

call batch/CriaDiretorio.bat temp/
call batch/CriaDiretorio.bat temp/doi/

call batch/CriaDiretorio.bat temp/doi/report/

cisis/mx "seq=$1 " lw=9000 "pft=if p(v1) and p(v2) then 'doi/report/GeraIssueReport.bat ',v1,x1,v2,x1,'$2',x1,'$3',x1,'$4',x1,'$5'/ fi" now >temp/doi/report/GeraIssuesReport.bat

chmod 700 temp/doi/report/GeraIssuesReport.bat
call temp/doi/report/GeraIssuesReport.bat

mv temp/doi/report/ temp/doi/bkp/report_$PROCESS_DATE/
echo Execution end of $0 $1 $2 $3 $4 $5 in  `date`
