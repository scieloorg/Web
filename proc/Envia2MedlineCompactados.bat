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

call batch/CriaDiretorio.bat temp/transf2medline

    call batch/GeraIso.bat     $1/bases/title/title                  temp/transf2medline/title.iso
    call batch/GeraIso.bat     $1/bases/issue/issue                  temp/transf2medline/issue.iso
    call batch/GeraIsoBool.bat $1/bases/artigo/artigo TP=i           temp/transf2medline/issues.iso
    call batch/GeraIsoBool.bat $1/bases/artigo/artigo TP=h           temp/transf2medline/artigo.iso   prc/AddV91.prc
    call batch/GeraIsoBool.bat $1/bases/artigo/artigo TP=c           temp/transf2medline/bib4cit.iso
rem call batch/GeraIsoBool.bat $1/bases/artigo/artigo TP=l           temp/transf2medline/artigol.iso
rem call batch/GeraIsoBool.bat $1/bases/artigo/artigo TP=h+TP=c+TP=i temp/transf2medline/artigonp.iso

local=`pwd`
cd temp/transf2medline
tar cvfzp title.iso.tgz title.iso
tar cvfzp issue.iso.tgz issue.iso
tar cvfzp issues.iso.tgz issues.iso
tar cvfzp artigo.iso.tgz artigo.iso
tar cvfzp bib4cit.iso.tgz bib4cit.iso
cd $local

call batch/InformaLog.bat $0 x FTP artigo e bib4cit
ftp -n < $2 >> $INFORMALOG
batch/ifErrorLevel.bat $? batch/AchouErro.bat $0 ftp: $2

call batch/InformaLog.bat $0 dh ===Fim=== LOG gravado em: $INFORMALOG

