export PATH=$PATH:.

rem ===== Aumentar o espaco de variaveis de ambiente
rem CONFIG.SYS
rem 

rem Envia2Lattes
rem Parametro 1: path da producao da SciELO
rem Parametro 2: arquivo com instrucoes de FTP
rem Parametro 3: arquivo de log
rem Parametro 4: cria / adiciona

rem Inicializa variaveis
export INFORMALOG=log/Envia2Lattes.log
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

# Apaga massa de dados se o FLAG permitir
[ -s temp/transf2lattes/SciELO.txt ] && rm temp/transf2lattes/SciELO*.txt


call batch/InformaLog.bat $0 dh ===Inicio===

call batch/CriaDiretorio.bat temp/transf2lattes

rem Passo 1
call batch/DeletaArquivo.bat temp/lattes1.xrf
call batch/DeletaArquivo.bat temp/lattes1.mst
$CISIS_DIR/mx ../bases/artigo/artigo "bool=TP=h" "proc=@prc/selectLattes.prc" now -all append=temp/lattes1
batch/ifErrorLevel.bat $? batch/AchouErro.bat $0 Passo 1

rem Passo 2
echo NEWISSUE.*=../bases/newissue/newissue.*> temp/Envia2Lattes.cip
$CISIS_DIR/mx cipar=temp/Envia2Lattes.cip temp/lattes1 gizmo=gizmo/Accent lw=9000 "pft=@pft/tbauth.pft" now > temp/lattes2.seq
batch/ifErrorLevel.bat $? batch/AchouErro.bat $0 Passo 2

rem Passo 3
$CISIS_DIR/mx mfrl=30000 seq=temp/lattes2.seq lw=9000 "pft=@pft/srcauth.pft" now > temp/lattes3.seq
batch/ifErrorLevel.bat $? batch/AchouErro.bat $0 Passo 3

rem Passo 4
call batch/Seq2Master.bat temp/lattes3.seq pipe temp/lattes4
call batch/OrdenaMaster.bat temp/lattes4 50 pft/OrdLattes.pft
call batch/Master2Seq.bat temp/lattes4 pft/lattesTxt.pft temp/transf2lattes/SciELO.txt

gzip -c temp/transf2lattes/SciELO.txt > temp/transf2lattes/SciELO.txt.gz

call batch/InformaLog.bat $0 x FTP lattes
ftp -n <$2 >> $INFORMALOG
batch/ifErrorLevel.bat $? batch/AchouErro.bat $0 ftp: $2

call batch/InformaLog.bat $0 dh ===Fim=== LOG gravado em: $INFORMALOG

