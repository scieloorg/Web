export PATH=$PATH:.

rem ===== Aumentar o espaco de variaveis de ambiente
rem CONFIG.SYS
rem 

rem doi/scilista/doJournalList
rem Parametro 1: journal database in bases-work
rem Parametro 2: journal acron

rem Inicializa variaveis

export INFORMALOG=log/sclista_doJournalList.log
export CISIS_DIR=cisis

echo Execution begin of $0 $1 $2 $3 $4 $5 in  `date`
rem Verifica parametros
call batch/VerifPresencaParametro.bat $0 @$1 journal database in bases-work
call batch/VerifPresencaParametro.bat $0 @$2 journal acron


if [ -f "$1.xrf" ]
then
	echo exist $1.xrf
	PROCESS_DATE=`date +%Y%m%d%H%M%S`
	call batch/CriaDiretorio.bat temp/doi/scilista_doJournalList_$PROCESS_DATE/
	call batch/CriaDiretorio.bat ../bases-work/doi/scilista_create/
	call batch/CriaDiretorio.bat ../bases-work/doi/scilista_update/

	rem cisis/mx $1 btell=0 "$ and not (I=$)" count=1 lw=99999 "pft='cisis/mx $1 fst=@fst/Fasciculo.fst fullinv=$1'/" now> temp/doi/inv_$2_$PROCESS_DATE.bat
	echo temp/doi/inv_$2_$PROCESS_DATE.bat

	if [ -f temp/doi/inv_$2_$PROCESS_DATE.bat ] 
	then
		echo Execute temp/doi/inv_$2_$PROCESS_DATE.bat
		chmod 775 temp/doi/inv_$2_$PROCESS_DATE.bat
		temp/doi/inv_$2_$PROCESS_DATE.bat
	fi
	rm -r temp/doi/inv_$2_$PROCESS_DATE.bat

	rm ../bases-work/doi/scilista_create/$2.txt
	rm ../bases-work/doi/scilista_update/$2.txt

	cisis/mx $1 btell=0 lw=9000 "I=$" "pft='call doi/scilista/doIssueList.bat $2 ',|v|v31,|n|v32,|s|v131,|s|v132/" now >temp/doi/scilista_doJournalList_$PROCESS_DATE/doIssueList.bat

	chmod 775 temp/doi/scilista_doJournalList_$PROCESS_DATE/doIssueList.bat
	echo Execute temp/doi/scilista_doJournalList_$PROCESS_DATE/doIssueList.bat 
	call temp/doi/scilista_doJournalList_$PROCESS_DATE/doIssueList.bat 
	rm -rf temp/doi/scilista_doJournalList_$PROCESS_DATE
else 
	echo WARNING: $1 does not exist
fi
echo Execution .end. of $0 $1 $2 $3 $4 $5 in  `date`
