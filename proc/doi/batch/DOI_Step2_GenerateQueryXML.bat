export PATH=$PATH:.
export CISIS_DIR=cisis
rem Este arquivo é uma chamada para o 
rem batch/GenerateDOI_Query.bat

rem echo === ATENCAO ===
rem echo 
rem echo Este arquivo executara o seguinte comando
rem echo batch/GenerateDOI_Query.bat base_artigo
rem echo 
rem echo Tecle CONTROL-C para sair ou ENTER para continuar...
rem read pause

rem ===== Aumentar o espaco de variaveis de ambiente
rem CONFIG.SYS

rem batch/GenerateDOI_Query
rem Parametro 1: arquivo_xml
rem Parametro 2: e-mail
rem Parametro 3: base 
rem Parametro 4: seq com pid

rem Inicializa variaveis
rem arquivo=`date +%Y%m%d%H%M%S`
tdy=`date +%Y%m%d%H%M%S`

rem Verifica parametros
call batch/VerifPresencaParametro.bat $0 @$1 arquivo_xml
call batch/VerifPresencaParametro.bat $0 @$2 e-mail
call batch/VerifPresencaParametro.bat $0 @$3 base
call batch/VerifPresencaParametro.bat $0 @$4 seq com pid

echo Execution begin of $0 $1 $2 $3 $4 $5 in  `date`

echo "<?xml version=\"1.0\" encoding=\"UTF-8\"?>" > $1
echo "<query_batch version=\"2.0\" xmlns=\"http://www.crossref.org/qschema/2.0\" xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\">" >> $1
echo "<head>" >> $1
echo "<email_address>$2</email_address>" >> $1
echo "<doi_batch_id>scielo_$tdy</doi_batch_id>" >> $1
echo "</head>" >> $1
echo "<body>" >> $1

cisis/mx seq=$4 mfrl=4000 "proc=proc('R$3,',f(l(['$3'],'D='v1),1,0)),proc('Gdoi/gizmo/ans2utf')" lw=999999 "pft=@doi/pft/doi_query.pft" now >> $1

echo \</body\> >> $1
echo \</query_batch\> >> $1
echo >> $1
echo Execution end of $0 $1 $2 $3 $4 $5 in  `date`