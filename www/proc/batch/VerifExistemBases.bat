rem VerifExistemBases
rem Parametro 1: path producao SciELO

call batch/VerifPresencaParametro.bat $0 @$1 path producao SciELO

$CISIS_DIR/mx "seq=scilista.lst " lw=9000 "pft=if p(v1) and v3 <> 'del' then 'call batch/VerifExisteBase.bat $1/serial/',v1,'/',v2,'/base/',v2/ fi" now >temp/VerifExistemBases.bat
batch/ifErrorLevel.bat $? batch/AchouErro.bat $0 mx seq:scilista.lst_ lw:9000 pft:call_batch_VerifExisteBase.bat
chmod 700 temp/VerifExistemBases.bat
call temp/VerifExistemBases.bat
