rem GeraIsoBool
rem Parametro 1: base
rem Parametro 2: boolean expression
rem Parametro 3: arquivo.iso
rem Parametro 4: proc [opcional]

call batch/VerifPresencaParametro.bat $0 @$1 base a ser lida
call batch/VerifExisteBase.bat $1
call batch/VerifPresencaParametro.bat $0 @$2 boolean expression
call batch/VerifPresencaParametro.bat $0 @$3 nome-do-arquivo-iso a ser gerado

echo -all> temp/GeraIsoBool.in
if [ $# == 4 ]
then
   echo proc=@$4>> temp/GeraIsoBool.in
fi

call batch/InformaLog.bat $0 x Gera arquivo iso: $3
$CISIS_DIR/mx $1 "bool=$2" iso=$3 now in=temp/GeraIsoBool.in
batch/ifErrorLevel.bat $? batch/AchouErro.bat $0 mx $1 bool:$2 iso:$3
