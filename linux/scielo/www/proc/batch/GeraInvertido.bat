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
#$CISIS_DIR/mx $1 gizmo=gizmo/Accent fst=@$2 fullinv/ansi=$INVBASE now -all
#batch/ifErrorLevel.bat $? batch/AchouErro.bat $0 mx $1 fst:@$2 fullinv:$INVBASE

echo $1> temp/GeraInvertido.in
echo gizmo=gizmo/Accent>> temp/GeraInvertido.in
echo fst=@$2>> temp/GeraInvertido.in
#echo convert=ansi>> temp/GeraInvertido.in
#echo ln1=$INVBASE.ln1>> temp/GeraInvertido.in
#echo ln2=$INVBASE.ln2>> temp/GeraInvertido.in
#echo +fix>> temp/GeraInvertido.in
#echo now>> temp/GeraInvertido.in
#echo -all>> temp/GeraInvertido.in
echo fullinv=$INVBASE>> temp/GeraInvertido.in
echo actab=tab/acans.tab>> temp/GeraInvertido.in
echo uctab=tab/ucans.tab>> temp/GeraInvertido.in
echo tell=10000>> temp/GeraInvertido.in
$CISIS_DIR/mx in=temp/GeraInvertido.in
batch/ifErrorLevel.bat $? batch/AchouErro.bat $0 inversao com fst:@$2

#batch/sortT.bat $INVBASE.lk1 $INVBASE.ln1
#batch/sortT.bat $INVBASE.lk2 $INVBASE.ln2

### ==>> $CISIS_DIR/ifload $INVBASE $INVBASE.lk1 $INVBASE.lk2 +fix -reset
#$CISIS_DIR/ifload $INVBASE $INVBASE.lk1 $INVBASE.lk2  master=$1 +fix/m
#batch/ifErrorLevel.bat $? batch/AchouErro.bat $0 carga das chaves

call batch/DeletaArquivo.bat $INVBASE.ln1
call batch/DeletaArquivo.bat $INVBASE.ln2
call batch/DeletaArquivo.bat $INVBASE.lk1
call batch/DeletaArquivo.bat $INVBASE.lk2
