export PATH=$PATH:.

rem ===== Aumentar o espaco de variaveis de ambiente
rem CONFIG.SYS
rem 

rem doi/scilista/main

export INFORMALOG=log/GeraDOI.log
export CISIS_DIR=cisis

rem Verifica parametros

echo Execution begin of $0 $1 $2 $3 $4 $5 in  `date`

PROCESS_DATE=`date +%Y%m%d%H%M%S`

call batch/CriaDiretorio.bat temp/
call batch/CriaDiretorio.bat temp/doi/
call batch/CriaDiretorio.bat temp/doi/scilista/

call batch/CriaDiretorio.bat ../bases-work/doi/scilista_create/
call batch/CriaDiretorio.bat ../bases-work/doi/scilista_update

if [ "@$1" = "@" ]
then
	export PATH=$PATH:.>temp/doi/scilista_$PROCESS_DATE/doJournalList.bat
	cisis/mx ../bases-work/title/title lw=9000 "pft=if v50='C' then 'doi/scilista/doJournalList.bat ../bases-work/',v68,'/',v68,x1,v68/ fi" now >>temp/doi/scilista/doJournalList.bat
	chmod 775 temp/doi/scilista/doJournalList.bat
	call temp/doi/scilista/doJournalList.bat
else
	call doi/scilista/doJournalList.bat ../bases-work/$1/$1 $1
fi
call batch/CriaDiretorio.bat temp/doi/bkp/
mv temp/doi/scilista temp/doi/bkp/scilista_$PROCESS_DATE

echo Execution .end. of $0 $1 $2 $3 $4 $5 in  `date`
