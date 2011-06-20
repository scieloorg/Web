rem export PATH=$PATH:.
rem GeraNewcodeAux
rem Parametro 1: path producao SciELO
rem Parametro 2: path diret?io tempor?io

call batch/VerifPresencaParametro.bat $0 @$1 path producao Scielo
call batch/VerifPresencaParametro.bat $0 @$2 diretorio temporario

call batch/InformaLog.bat $0 x Gera Newcode Auxiliar

rem call batch/VerifExisteBase.bat $1/code/newcode
rem call batch/GeraInvertido.bat $1/code/newcode fst/newcode.fst $1/code/newcode

if [ ! -f $1/code/code.mst ]
then
    if [ -f gizmo/code.iso ]
    then
        call batch/Iso2Master.bat gizmo/code.iso $1/code/code
    fi
fi

call batch/VerifExisteBase.bat $1/code/code
call batch/GeraInvertido.bat $1/code/code fst/newcode.fst $1/code/code


$CISIS_DIR/mx $1/code/code btell=0 "pt-study area" pft=@pft/sa.pft now > $2/sa_pt.seq
$CISIS_DIR/mx seq=$2/sa_pt.seq create=$2/sa_pt -all now
$CISIS_DIR/mx $2/sa_pt fst=@fst/sa.fst fullinv/ansi=$2/sa_pt -all now

$CISIS_DIR/mx $1/code/code btell=0 "es-study area" pft=@pft/sa.pft now > $2/sa_es.seq
$CISIS_DIR/mx seq=$2/sa_es.seq create=$2/sa_es -all now
$CISIS_DIR/mx $2/sa_es fst=@fst/sa.fst fullinv/ansi=$2/sa_es -all now
