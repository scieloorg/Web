export PATH=$PATH:.
export CISIS_DIR=cisis

rem parametro 1 sigla
rem parametro 2 issue
rem parametro 3 range of pid
rem parametro 4 art ou ref
rem parametro 5 scilista a gerar


echo Execution begin of $0 $1 $2 $3 $4 $5 $6 $7 $8 in  `date`

PROCESS_DATE=`date +%Y%m%d%H%M%S`
ISSUE_DOI=../bases-work/doi/$1/$2/$2

#### if [ -f "$ISSUE_DOI.xrf" ]
if [ -s "$ISSUE_DOI.n02" ]
then
	if [ "@$2" = "@nahead" -o "@$2" = "@nreview" ]
	then
		echo $1 $2 $3 >>  ../bases-work/doi/scilista/deposit/$4_$1.txt
		echo $1 $2 $3 >> $5
	else
		cisis/mx $ISSUE_DOI btell=0 "bool=$ and not (TYPE=$4)" count=1 lw=9999 "pft='echo $1 $2 $3 >> ../bases-work/doi/scilista/deposit/$4_$1.txt'/,'echo $1 $2 $3 >> $5'/" now > temp/doi/scilista/gera.bat

		cisis/mx $ISSUE_DOI btell=0 "bool=TYPE=$4 and not (STATUS=DOI)" count=1 lw=9999 "pft='echo $1 $2 $3 >> ../bases-work/doi/scilista/deposit/$4_$1.txt'/,'echo $1 $2 $3 >> $5'/" now > temp/doi/scilista/gera.bat
		chmod 777 temp/doi/scilista/gera.bat
		temp/doi/scilista/gera.bat
	fi
else
	echo $1 $2 $3 >>  ../bases-work/doi/scilista/deposit/$4_$1.txt
	echo $1 $2 $3 >> $5
fi

echo Execution .end.  of $0 $1 $2 $3 $4 $5 $6 $7 $8 in  `date`
