export PATH=$PATH:.

rem ===== Aumentar o espaco de variaveis de ambiente
rem CONFIG.SYS
rem 

rem AtualizaScieloOnLine
rem Parametro 1: diretorio bases do ambiente de testes - area de testes
rem Parametro 2: diretorio bases do ambiente onLine - area online - producao liberada
rem Parametro 3: arquivo de log
rem Parametro 4: cria / adiciona

rem Inicializa variaveis
export INFORMALOG=log/AtualizaScieloOnLine.log
export CISIS_DIR=cisis

rem Verifica parametros
call batch/VerifPresencaParametro.bat $0 @$1 diretorio bases do ambiente de testes
call batch/VerifPresencaParametro.bat $0 @$2 diretorio bases do ambiente onLine
call batch/VerifPresencaParametro.bat $0 @$3 arquivo de LOG
call batch/VerifPresencaParametro.bat $0 @$4 opcao do LOG: cria/adiciona

if [ "$4" == "cria" ]
then
   call batch/DeletaArquivo.bat $3
fi
export INFORMALOG=$3

call batch/InformaLog.bat $0 dh ===Inicio===

call batch/CopiaDiretorio.bat $1/title $2
call batch/CopiaDiretorio.bat $1/artigo $2
call batch/CopiaDiretorio.bat $1/newissue $2
call batch/CopiaDiretorio.bat $1/issue $2
call batch/CopiaDiretorio.bat $1/iah $2

call batch/InformaLog.bat $0 dh ===Fim===
