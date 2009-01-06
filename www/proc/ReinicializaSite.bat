export PATH=$PATH:.

rem EmptySite.bat
rem Parametro 1: path da producao da SciELO
rem Parametro 2: path do site da Scielo
rem Parametro 3: arquivo de log
rem Parametro 4: cria / adiciona

rem Inicializa variaveis
export INFORMALOG=log/EmptySite.log
export CISIS_DIR=cisis

rem Verifica parametros
call batch/VerifPresencaParametro.bat $0 @$1 path producao SciELO
call batch/VerifPresencaParametro.bat $0 @$2 path site SciELO
call batch/VerifPresencaParametro.bat $0 @$3 arquivo de LOG
call batch/VerifPresencaParametro.bat $0 @$4 opcao do LOG: cria/adiciona

if [ "$4" == "cria" ]
then
   call batch/DeletaArquivo.bat $3
fi
export INFORMALOG=$3
call batch/InformaLog.bat $0 dh ===Inicio===

rm $2/bases/artigo/artigo.*
$CISIS_DIR/mx null count=1 create=$2/bases/artigo/artigo now -all
call batch/CriaInvertido.bat $2/bases/artigo/artigo

call batch/CopiaArquivo.bat $1/serial/title/title.mst $2/bases/title/title.mst
call batch/CopiaArquivo.bat $1/serial/title/title.xrf $2/bases/title/title.xrf

call batch/InformaLog.bat $0 dh ===Fim=== LOG gravado em: $INFORMALOG

