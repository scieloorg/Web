export PATH=$PATH:.

rem ===== Aumentar o espaco de variaveis de ambiente
rem CONFIG.SYS
rem 

rem GeraSciELO
rem Parametro 1: path da producao da SciELO
rem Parametro 2: path do site da Scielo
rem Parametro 3: arquivo de log
rem Parametro 4: cria / adiciona

rem Inicializa variaveis

export INFORMALOG=log/GeraScielo.log
export CISIS_DIR=cisis
export CIPAR=tabs/GIGA032.cip

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

call batch/VerifExisteArquivo.bat $1/serial/scilista.lst

call batch/VerifExistemBases.bat $1

call batch/InformaLog.bat $0 dh ===Fim=== LOG gravado em: $INFORMALOG
