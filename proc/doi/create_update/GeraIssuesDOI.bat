rem GeraIssuesDOI
rem Parametro 1: create or update
rem Parametro 2: scilista
rem Parametro 3: art ou ref
rem Parametro 4: pacote ou individual ou no_query
rem Parametro 5: prefixo doi
rem Parametro 6: user
rem Parametro 7: password
rem Parametro 8: email


echo Execution begin of $0 $1 $2 $3 $4 $5 $6 $7 $8 $9 in  `date`

rem Verifica parametros
call batch/VerifPresencaParametro.bat $0 @$1 create or update
call batch/VerifPresencaParametro.bat $0 @$2 scilista
call batch/VerifPresencaParametro.bat $0 @$3 art ou ref

call batch/VerifPresencaParametro.bat $0 @$4 pacote ou individual ou no_query
call batch/VerifPresencaParametro.bat $0 @$5 prefixo doi
call batch/VerifPresencaParametro.bat $0 @$6 user
call batch/VerifPresencaParametro.bat $0 @$7 password
call batch/VerifPresencaParametro.bat $0 @$8 email


rem Inicializa variaveis
PROCESS_DATE=`date +%Y%m%d%H%M%S`

cisis/mx "seq=$2 " lw=9000 "pft=if p(v1) and p(v2) then 'doi/create_update/GeraIssueDOI.bat ',v1,x1,v2,x1,'$1',x1,'$3 $4 ',,if '$4'<>'no_query' then '$6 $7 $8' else v3,' $5 $8' fi/, fi" now >temp/doi/proc/current/GeraIssuesDOI.bat

chmod 700 temp/doi/proc/current/GeraIssuesDOI.bat
call temp/doi/proc/current/GeraIssuesDOI.bat

echo Execution end of $0 $1 $2 $3 $4 $5 $6 $7 $8 $9 in  `date`
