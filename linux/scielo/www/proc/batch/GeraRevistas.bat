rem GeraRevistas
rem Parametro 1: path producao Scielo
rem Parametro 2: path site Scielo

call batch/VerifPresencaParametro.bat $0 @$1 path producao SciELO
call batch/VerifPresencaParametro.bat $0 @$2 path site SciELO
call batch/VerifExisteBase.bat $2/bases/artigo/artigo

$CISIS_DIR/mx $2/bases/title/title lw=9000 "pft='call batch/GeraRevista.bat $1',x1,v68,x1,'$2'/" now >temp/GeraRevistas.bat
batch/ifErrorLevel.bat $? batch/AchouErro.bat $0 mx $2/bases/title/title lw:9000 pft:call_GeraRevista.bat
chmod 700 temp/GeraRevistas.bat
call temp/GeraRevistas.bat
