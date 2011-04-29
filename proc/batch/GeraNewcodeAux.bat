rem export PATH=$PATH:.
rem GeraNewcodeAux
rem Parametro 1: path producao SciELO
rem Parametro 2: path diretório temporário

call batch/VerifPresencaParametro.bat $0 @$1 path producao Scielo
call batch/VerifPresencaParametro.bat $0 @$2 diretorio temporario

call batch/InformaLog.bat $0 x Gera Newcode Auxiliar

call batch/VerifExisteBase.bat $1/code/newcode

call batch/GeraInvertido.bat $1/code/newcode fst/newcode.fst $1/code/newcode
$CISIS_DIR/mx $1/code/newcode btell=0 "pt-study area" pft=@pft/sa.pft now > $2/sa_pt.seq
$CISIS_DIR/mx seq=$2/sa_pt.seq create=$2/sa_pt -all now
$CISIS_DIR/mx $2/sa_pt fst=@fst/sa.fst fullinv/ansi=$2/sa_pt -all now

$CISIS_DIR/mx $1/code/newcode btell=0 "es-study area" pft=@pft/sa.pft now > $2/sa_es.seq
$CISIS_DIR/mx seq=$2/sa_es.seq create=$2/sa_es -all now
$CISIS_DIR/mx $2/sa_es fst=@fst/sa.fst fullinv/ansi=$2/sa_es -all now
