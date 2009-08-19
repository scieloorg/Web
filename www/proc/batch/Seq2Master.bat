rem export PATH=$PATH:.
rem Seq2Master.bat
rem Parametro 1: arquivo seq
rem Parametro 2: delimitador pipe ou space
rem Parametro 3: base a ser gerada
rem Parametro 4: proc [opcional]

call batch/VerifPresencaParametro.bat $0 @$1 arquivo seq
call batch/VerifExisteArquivo.bat $1
call batch/VerifPresencaParametro.bat $0 @$2 delimitador pipe space
call batch/VerifPresencaParametro.bat $0 @$3 base_de_dados a ser gerada

echo -all>temp/Seq2Master.in
if [ $# == 4 ]
then
   echo proc=@$4 >>temp/Seq2Master.in
fi

call batch/InformaLog.bat $0 x Gera Master: $3
if [ "$2" == "pipe" ]
then
   $CISIS_DIR/mx mfrl=30000 seq=$1 create=$3 now in=temp/Seq2Master.in
   batch/ifErrorLevel.bat $? batch/AchouErro.bat $0 mx seq:$1 create:$3 [proc:@$4]
fi

if [ "$2" == "space" ]
then
   $CISIS_DIR/mx mfrl=30000 "seq=$1 " create=$3 now in=temp/Seq2Master.in
   batch/ifErrorLevel.bat $? batch/AchouErro.bat $0 mx seq:$1 create:$3 [proc:@$4]
fi
