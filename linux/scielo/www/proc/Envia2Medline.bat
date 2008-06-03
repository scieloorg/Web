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

if [ "$4" == "cria" ]
then
   call batch/DeletaArquivo.bat $3
fi
export INFORMALOG=$3

call batch/InformaLog.bat $0 dh ===Inicio===

call batch/CriaDiretorio.bat temp/transf2medline

call batch/GeraIso.bat $1/bases/issue/issue temp/transf2medline/issue.iso
call batch/GeraIso.bat $1/bases/title/title temp/transf2medline/title.iso
call batch/GeraIsoBool.bat $1/bases/artigo/artigo TP=i temp/transf2medline/issues.iso
call batch/GeraIsoBool.bat $1/bases/artigo/artigo TP=h temp/transf2medline/artigo.iso
call batch/GeraIsoBool.bat $1/bases/artigo/artigo TP=c temp/transf2medline/bib4cit.iso prc/bib4cit.prc

call batch/InformaLog.bat $0 x FTP artigo e bib4cit
ftp -n <$2 >> $INFORMALOG
batch/ifErrorLevel.bat $? batch/AchouErro.bat $0 ftp: $2

call batch/InformaLog.bat $0 dh ===Fim=== LOG gravado em: $INFORMALOG

