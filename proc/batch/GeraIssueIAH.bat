rem export PATH=$PATH:.
rem GeraIssueIAH
rem Parametro 1: path producao SciELO

call batch/VerifPresencaParametro.bat $0 @$1 path producao SciELO

call batch/InformaLog.bat $0 x Gera Issue IAH

call batch/DeletaArquivo.bat ../bases-work/issue/issue.mst
call batch/DeletaArquivo.bat ../bases-work/issue/issue.xrf

$CISIS_DIR/mx ../bases-work/artigo/artigo "bool=TP=I" now -all append=../bases-work/issue/issue
batch/ifErrorLevel.bat $? batch/AchouErro.bat $0 Gera Issue IAH
call batch/OrdenaMaster.bat ../bases-work/issue/issue 150 pft/OrdIssue.pft
$CISIS_DIR/mx ../bases-work/issue/issue proc=@prc/issue2.prc now -all copy=../bases-work/issue/issue
batch/ifErrorLevel.bat $? batch/AchouErro.bat $0 ../bases-work/issue/issue proc:@prc/issue2.prc copy:../bases-work/issue/issue

call batch/GeraInvertido.bat ../bases-work/issue/issue fst/issue.fst ../bases-work/issue/issue
