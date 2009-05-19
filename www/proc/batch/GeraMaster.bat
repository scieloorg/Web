rem GeraMaster
rem Parametro 1: base de entrada
rem Parametro 2: base de saida
rem Parametro 3: nome da proc [opcional]

call batch/VerifPresencaParametro.bat $0 @$1 base de entrada
call batch/VerifPresencaParametro.bat $0 @$2 base de saida

call batch/VerifExisteBase.bat $1
call batch/DeletaArquivo.bat $2.mst
call batch/DeletaArquivo.bat $2.xrf

echo -all>temp/GeraMaster.in
if [ $# == 3 ]
then
   echo proc=@$3 >>temp/GeraMaster.in
fi

call batch/InformaLog.bat $0 x Gera master: $2
$CISIS_DIR/mx $1 append=$2 now in=temp/GeraMaster.in 
batch/ifErrorLevel.bat $? batch/AchouErro.bat $0 mx $1 append:$2 [proc:$3]
