rem GeraIssues
rem Parametro 1: path producao SciELO

call batch/VerifPresencaParametro.bat $0 @$1 path producao SciELO

$CISIS_DIR/mx "seq=scilista.lst " lw=9000 "pft=if p(v1) then 'call batch/GeraIssue.bat $1',x1,v1,x1,v2,x1,v3/ fi" now >temp/GeraIssues.bat
batch/ifErrorLevel.bat $? batch/AchouErro.bat $0 mx seq:scilista.lst_ pft:call_batch_GeraIssue.bat
chmod 700 temp/GeraIssues.bat
call temp/GeraIssues.bat
