rem GeraInvertido
rem Parametro 1: base de dados
rem Parametro 2: fst
rem Parametro 3: nome do invertido

call batch/VerifPresencaParametro.bat $0 @$1 base de dados
call batch/VerifExisteBase.bat $1
call batch/VerifPresencaParametro.bat $0 @$2 fst
call batch/VerifPresencaParametro.bat $0 @$3 invertido a ser gerado
export INVBASE=$3

call batch/InformaLog.bat $0 x Gera invertido: $INVBASE

echo fst=@$2> temp/GeraInvertido.in
echo actab=tabs/acans.tab >> temp/GeraInvertido.in
echo uctab=tabs/ucans.tab >> temp/GeraInvertido.in
echo fullinv=$INVBASE>> temp/GeraInvertido.in
echo tell=15000>> temp/GeraInvertido.in

$CISIS_DIR/mx $1 in=temp/GeraInvertido.in
call batch/ifErrorLevel.bat $? batch/AchouErro.bat $0 inversao pela fst:@$2