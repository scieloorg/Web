rem export PATH=$PATH:.
rem GeraIssueDOI
rem Parametro 1: path producao SciELO
rem Parametro 2: sigla da revista
rem Parametro 3: volume-numero do issue
rem Parametro 4: create or update
rem Parametro 5: registro selecionado


echo Execution begin of $0 $1 $2 $3 $4 $5 in  `date`
call batch/InformaLog.bat $0 x Gera ISSUE_DOI DOI: $2 $3

call batch/VerifPresencaParametro.bat $0 @$1 sigla da revista
call batch/VerifPresencaParametro.bat $0 @$2 volume-numero do issue

call batch/CriaDiretorio.bat ../bases-work/doi/
call batch/CriaDiretorio.bat ../bases-work/doi/$1

export ISSUE_DOI=../bases-work/doi/$1/$2/$2

	cisis/mx $ISSUE_DOI fst=@doi/fst/doi.fst fullinv=$ISSUE_DOI

	cisis/mx $ISSUE_DOI  btell=0 "bool=corrige" "proc='d1a1{10.1590/',v880,'{'"  copy=$ISSUE_DOI now -all
	cisis/mx $ISSUE_DOI fst=@doi/fst/doi.fst fullinv=$ISSUE_DOI

echo Execution end of $0 $1 $2 $3 $4 $5 in  `date`
