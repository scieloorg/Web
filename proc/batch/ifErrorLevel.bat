rem ifErrorLevel
rem Parametro 1: codigo de erro
rem Parametro 2..9: acoes em caso de erro

if [ $1 -ne 0 ]
then
   $2 $3 $4 $5 $6 $7 $8 $9
fi
