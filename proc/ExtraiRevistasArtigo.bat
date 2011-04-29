export PATH=$PATH:.

rem ===== Aumentar o espaco de variaveis de ambiente
rem CONFIG.SYS
rem SHELL=C:/COMMAND.COM /P /E:1024

rem ExtraiRevistasArtigo
rem Parametro 1: path da producao da SciELO
rem Parametro 2: path do site da Scielo
rem Parametro 3: arquivo de log
rem Parametro 4: cria / adiciona

rem Inicializa variaveis
export INFORMALOG=log/ExtraiRevistasArtigo.log
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

call batch/CriaDiretorio.bat ../bases-work/artigo
call batch/CopiaArquivo.bat $2/bases/artigo/artigo.mst ../bases-work/artigo/artigo.mst
call batch/CopiaArquivo.bat $2/bases/artigo/artigo.xrf ../bases-work/artigo/artigo.xrf

call batch/GeraCodigoRev.bat $2/bases/artigo/artigo ../bases-work/artigo/artigo
call batch/GeraInvertido.bat ../bases-work/artigo/artigo fst/GeraCodigoRev.fst ../bases-work/artigo/artigo

call batch/VerifExisteBase.bat $2/bases/title/title
call batch/GeraRevistas.bat $1 $2

call batch/InformaLog.bat $0 dh ===Fim=== LOG gravado em: $INFORMALOG
