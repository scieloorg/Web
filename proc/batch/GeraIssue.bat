rem export PATH=$PATH:.
rem GeraIssue
rem Parametro 1: path producao SciELO
rem Parametro 2: sigla da revista
rem Parametro 3: volume-numero do issue
rem Parametro 4: acao - se for "del" eh para deletar, se ausente eh caso normal

call batch/GeraIssueHasP.bat $1 $2 $3 $4
#call batch/GeraIssueNoP.bat $1 $2 $3 $4