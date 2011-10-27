rem export PATH=$PATH:.
rem GeraNewcodeAux
rem Parametro 1: path producao SciELO
rem Parametro 2: path diret?io tempor?io

call batch/VerifPresencaParametro.bat $0 @$1 path producao Scielo
call batch/VerifPresencaParametro.bat $0 @$2 diretorio temporario

call batch/InformaLog.bat $0 x GeraNewcodeAux Gera Serarea para cada idioma

call batch/VerifExisteBase.bat $1/code/newcode
call batch/GeraInvertido.bat $1/code/newcode fst/newcode.fst $1/code/newcode

if [ -f gizmo/subject.iso ]
then
    call batch/Iso2Master.bat gizmo/subject.iso $2/subject
fi
call batch/VerifExisteBase.bat $2/subject


$CISIS_DIR/mx $2/subject lw=999 "pft='call batch/GeraSerareaLANG.bat $2/subject ',mfn,' ../bases-work/title/title ../bases-work/title/serarea',mpu,v1^l,mpl,' $2'/" now > $2/GeraSerareaLANG.bat
call $2/GeraSerareaLANG.bat

