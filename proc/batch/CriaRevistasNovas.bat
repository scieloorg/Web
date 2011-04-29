rem CriaRevistasNovas
rem Parametro 1: path producao SciELO

call batch/VerifPresencaParametro.bat $0 @$1 path producao SciELO

call batch/GeraInvertido.bat ../bases-work/title/title fst/codigoRevista.fst temp/codigoRevista
$CISIS_DIR/mx "seq=scilista.lst " lw=9000 "pft=if p(v1) and l(['temp/codigoRevista']v1) > 0 then 'call batch/CriaRevistaNova.bat $1',x1,v1/ fi" now >temp/CriaRevistasNovas.bat
batch/ifErrorLevel.bat $? batch/AchouErro.bat $0 mx seq:scilista.lst_ lw:9000 pft:call_batch_CriaRevistaNova.bat
chmod 700 temp/CriaRevistasNovas.bat
call temp/CriaRevistasNovas.bat
