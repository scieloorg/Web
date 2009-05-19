rem AppendMaster
rem Parametro 1: base de entrada
rem Parametro 2: base de saida
rem Parametro 3: nome da proc [opcional]

call batch/VerifPresencaParametro.bat $0 @$1 base de entrada
call batch/VerifExisteBase.bat $1
call batch/VerifPresencaParametro.bat $0 @$2 base de saida

echo -all>temp/AppendMaster.in
if [ $# == 3 ]
then
   echo proc=@$3 >>temp/AppendMaster.in
fi

call batch/InformaLog.bat $0 x Append Master: $1 em:$2
$CISIS_DIR/mx $1 append=$2 now in=temp/AppendMaster.in
batch/ifErrorLevel.bat $? batch/AchouErro.bat $0 mx $1 append:$2 [proc:$3]
