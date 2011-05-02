export PATH=$PATH:.
rem EnviaBasesSciELO
rem Parametro 1: path da producao da SciELO
rem Parametro 2: arquivo de logOn FTP
rem Parametro 3: arquivo de log
rem Parametro 4: cria / adiciona
rem Parametro 5: posicao rede Scielo no campo 691 da title [opcional]

rem Inicializa variaveis
export INFORMALOG=log/EnviaBasesSciELO.log
export CISIS_DIR=cisis

rem Verifica parametros
call batch/VerifPresencaParametro.bat $0 @$1 path da producao da SciELO
call batch/VerifPresencaParametro.bat $0 @$2 arquivo de logOn FTP
call batch/VerifExisteArquivo.bat $2
call batch/VerifPresencaParametro.bat $0 @$3 arquivo de LOG
call batch/VerifPresencaParametro.bat $0 @$4 opcao do LOG: cria/adiciona

if [ "$4" == "cria" ]
then
   call batch/DeletaArquivo.bat $3
fi
export INFORMALOG=$3

call batch/InformaLog.bat $0 dh ===Inicio===

call batch/VerifExisteArquivo.bat $1/serial/scilista.lst
call batch/CopiaArquivo.bat $1/serial/scilista.lst temp/scilista-envia.lst

call batch/ConverteBasesSciELO.bat $1/serial temp/transf2linux $5

rem Gera arquivo de parametros do FTP
call batch/CopiaArquivo.bat $2 temp/EnviaBases.txt
echo lcd temp/transf2linux>> temp/EnviaBases.txt
$CISIS_DIR/mx "seq=temp/scilista-envia.lst " lw=9000 pft=@pft/EnviaBases.pft now >> temp/EnviaBases.txt
batch/ifErrorLevel.bat $? batch/AchouErro.bat $0 mx criacao temp/EnviaBases.txt
echo bye >> temp/EnviaBases.txt

call batch/InformaLog.bat $0 x FTP das bases
ftp -n <temp/EnviaBases.txt >> $INFORMALOG
batch/ifErrorLevel.bat $? batch/AchouErro.bat $0 ftp: temp/EnviaBases.txt

call batch/InformaLog.bat $0 dh ===Fim=== LOG gravado em: $INFORMALOG

