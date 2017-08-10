export PATH=$PATH:.

rem ===== Aumentar o espaco de variaveis de ambiente
rem CONFIG.SYS
rem

rem Envia2Medline
rem Parametro 1: path da producao da SciELO
rem Parametro 2: arquivo com instrucoes de FTP
rem Parametro 3: arquivo de log
rem Parametro 4: cria / adiciona

rem Inicializa variaveis
export INFORMALOG=log/Envia2Medline.log
export CISIS_DIR=cisis

rem Verifica parametros
call batch/VerifPresencaParametro.bat $0 @$1 path producao SciELO
call batch/VerifPresencaParametro.bat $0 @$2 arquivo com instrucoes de FTP
call batch/VerifExisteArquivo.bat $2
call batch/VerifPresencaParametro.bat $0 @$3 arquivo de LOG
call batch/VerifPresencaParametro.bat $0 @$4 opcao do LOG: cria/adiciona

if [ "$4" == "cria" ]; then
   call batch/DeletaArquivo.bat $3
fi
export INFORMALOG=$3

call batch/InformaLog.bat $0 dh ===Inicio===

call batch/CriaDiretorio.bat temp/transf2scielofast

call batch/GeraIso.bat     $1/title/title                  temp/transf2scielofast/title_full.iso
call batch/GeraIso.bat     $1/artigo/artigo                temp/transf2scielofast/artigo_full.iso


call batch/InformaLog.bat $0 x FTP artigo_full, title_full
ftp -n < $2 >> $INFORMALOG

call batch/ifErrorLevel.bat $? batch/AchouErro.bat $0 ftp: $2

call batch/InformaLog.bat $0 dh ===Fim=== LOG gravado em: $INFORMALOG

