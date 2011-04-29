rem InformaLog
rem Parametro 1: nome do batch
rem Parametro 2: dh - informa data e hora / x - sem data e hora
rem Parametro 3..9: Mensagens

call batch/VerifPresencaParametro.bat $0 @$1 nome do batch
call batch/VerifPresencaParametro.bat $0 @$2 dh/x
call batch/VerifPresencaParametro.bat $0 @$3 mensagem

if [ $2 == "dh" ]
then
   $CISIS_DIR/mx tmp count=1 "pft='[VERSAO 2.1]'/,x3,s(date).13/"
   $CISIS_DIR/mx tmp count=1 "pft='[VERSAO 2.1]'/,x3,s(date).13/" >> $INFORMALOG
fi

echo [$1]
echo    $3 $4 $5 $6 $7 $8 $9
echo 

echo [$1] >> $INFORMALOG
echo     $3 $4 $5 $6 $7 $8 $9 >> $INFORMALOG
echo  >> $INFORMALOG
