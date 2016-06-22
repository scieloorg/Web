export PATH=$PATH:.
export CISIS_DIR=cisis

rem parametro 1 base deposit
rem parametro 2 chaves
rem parametro 3 title
rem parametro 4 issue
rem parametro 5 art ou ref
rem parametro 6 nome scilista resutado



echo Execution begin of $0 $1 $2 $3 $4 $5 $6 $7 $8 in  `date`

PROCESS_DATE=`date +%Y%m%d%H%M%S`
export INFORMALOG=temp\doi\scilista.log

if [ "@$6" = "@" ] 
then
	export SCILISTA=../bases-work/doi/scilista/deposit/$5.txt
else
	export SCILISTA=$6
fi

rm -rf ../bases-work/doi/scilista/deposit/*

call batch/CriaDiretorio.bat temp/
call batch/CriaDiretorio.bat temp/doi
call batch/CriaDiretorio.bat temp/doi/scilista/

call batch/CriaDiretorio.bat ../bases-work/doi/
call batch/CriaDiretorio.bat ../bases-work/doi/scilista

call batch/CriaDiretorio.bat ../bases-work/doi/scilista/deposit/

echo "" > $SCILISTA

cisis/mx $1 btell=0 "bool=$ and not (st=error)" lw=9999 "pft=if ref(['$4']l(['$4'],'Y',v880*1.17),|v|v31,|s|v131,|n|v32,|s|v132)<>'' then ' doi/scilista/deposit/doIssue.bat ',ref(['$3']l(['$3'],'LOC=',v880*1.9),v68),' ',ref(['$4']l(['$4'],'Y',v880*1.17),|v|v31,|s|v131,|n|v32,|s|v132),' S',v880*1.17,' $5 $SCILISTA'/ fi" now | sort -u > temp/doi/scilista/x.bat

chmod 770 temp/doi/scilista/x.bat
temp/doi/scilista/x.bat

cp $SCILISTA ../bases-work/doi/scilista/deposit

echo Created the scilista $SCILISTA

echo Execution .end. of $0 $1 $2 $3 $4 $5 $6 $7 $8 in  `date`
