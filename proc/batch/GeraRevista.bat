rem export PATH=$PATH:.
rem GeraRevista
rem Parametro 1: path producao Scielo
rem Parametro 2: codigo da revista
rem Parametro 3: path site Scielo

call batch/VerifPresencaParametro.bat $0 @$1 path producao SciELO
call batch/VerifPresencaParametro.bat $0 @$2 codigo da revista
call batch/VerifPresencaParametro.bat $0 @$3 path site Scielo

call batch/InformaLog.bat $0 x Gera revista $2
call batch/CriaDiretorio.bat ../bases-work/$2
call batch/DeletaArquivo.bat ../bases-work/$2/$2.mst
call batch/DeletaArquivo.bat ../bases-work/$2/$2.xrf
$CISIS_DIR/mx ../bases-work/artigo/artigo "bool=$2" "join=$3/bases/artigo/artigo='mfn='mfn" now -all append=../bases-work/$2/$2
batch/ifErrorLevel.bat $? batch/AchouErro.bat $0 mx geracao da revista
