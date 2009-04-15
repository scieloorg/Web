rem export PATH=$PATH:.
rem GeraIssueDOI
rem Parametro 1: sigla da revista
rem Parametro 2: volume-numero do issue
rem Parametro 3: reset or update
rem Parametro 4: art ou ref
rem Parametro 5: pacote ou individual ou no_query
rem Parametro 6: intervalo de pid ou user
rem Parametro 7: prefixo doi ou password
rem Parametro 8: email


echo Execution begin of $0 $1 $2 $3 $4 $5 $6 $7 $8 $9 in  `date`
rem call batch/InformaLog.bat $0 x Gera ISSUE_DOI DOI: $1 $2

call batch/VerifPresencaParametro.bat $0 @$1 sigla da revista
call batch/VerifPresencaParametro.bat $0 @$2 volume-numero do issue
call batch/VerifPresencaParametro.bat $0 @$3 reset ou create ou update 
call batch/VerifPresencaParametro.bat $0 @$4 art ou ref

call batch/VerifPresencaParametro.bat $0 @$5 pacote ou individual ou no_query

call batch/VerifPresencaParametro.bat $0 @$6 intervalo de pid ou user
call batch/VerifPresencaParametro.bat $0 @$7 prefixo doi ou password
call batch/VerifPresencaParametro.bat $0 @$8 email


call batch/CriaDiretorio.bat ../bases-work/doi/
call batch/CriaDiretorio.bat ../bases-work/doi/$1


export REVISTA_DOI=../bases-work/doi/$1/$1
call batch/CriaDiretorio.bat ../bases-work/doi/$1/$2
export ISSUE_DOI=../bases-work/doi/$1/$2/$2
export REVISTA=../bases-work/$1/$1
PROCESS_DATE=`date +%Y%m%d%H%M%S`
export BASE_CONTROLE_SUBMISSION=scielo_crs/databases/crossref/crossref_DOIReport

if [ ! -f "../bases-work/doi/controler.xrf" ]
then
   echo "creating/reseting base doi: ../bases-work/doi/controler"
   cisis/mx null count=1 "proc='a1{revista{a2{issue{a3{date{a4{teste{'" copy=../bases-work/doi/controler now -all
   cisis/mx ../bases-work/doi/controler fst=@doi/fst/controler.fst fullinv=../bases-work/doi/controler
else
	rem if not exist revista_issue in controler database then create its record
   	cisis/mx ../bases-work/doi/controler fst=@doi/fst/controler.fst fullinv=../bases-work/doi/controler
	cisis/mx ../bases-work/doi/controler count=1 "proc=if l(['../bases-work/doi/controler'],'$1_$2')=0 then 'd*a1{$1{a2{$2{a3{',date,'{' fi" append=../bases-work/doi/controler now -all

	rem if not exist revista_issue in controler database then invert 
	rm temp/doi/proc/current/inv_controler_$1_3.bat

	cisis/mx ../bases-work/doi/controler count=1 lw=9999 "pft=if l(['../bases-work/doi/controler'],'$1_$2')=0 then 'cisis/mx ../bases-work/doi/controler fst=@doi/fst/controler.fst fullinv=../bases-work/doi/controler'/ else 'echo do nothing'/  fi" now > temp/doi/proc/current/inv_controler_$1_3.bat
	chmod 775 temp/doi/proc/current/inv_controler_$1_3.bat
	echo Execute temp/doi/proc/current/inv_controler_$1_3.bat
	temp/doi/proc/current/inv_controler_$1_3.bat

	rem if exist revista_issue in controler database then update its record
	cisis/mx ../bases-work/doi/controler btell=0 "bool=$1_$2" "proc='d3d4a3{',date,'{'" copy=../bases-work/doi/controler now -all    
fi

if [ ! -f "$ISSUE_DOI.xrf" ]
then
	cisis/mx null count=0 create=$ISSUE_DOI now -all
fi
if [ "@$3" == "@reset" ]
then
	cisis/mx null count=0 create=$ISSUE_DOI now -all
fi
cisis/mx $ISSUE_DOI fst=@doi/fst/doi.fst fullinv=$ISSUE_DOI

if [ "$4" == "art" ]
then
	if [ "$5" == "no_query" ]
	then
		doi/create_update/DOI_CreateDB.bat $7 $ISSUE_DOI $BASE_CONTROLE_SUBMISSION "HR=$6$" $5 $1_$2 $6 $7 $8 
	else
		doi/create_update/DOI_CreateDB.bat $REVISTA $ISSUE_DOI $REVISTA "H=$2" $5 $1_$2 $6 $7 $8 
	fi
else
	doi/create_update/DOI_CreateDB.bat $REVISTA $ISSUE_DOI $REVISTA "R=$2" $5 $1_$2 $6 $7 $8 
fi

cisis/mx ../bases-work/doi/controler btell=0 "bool=$1_$2" "proc='d4a4{',date,'{'" copy=../bases-work/doi/controler now -all
cisis/mx ../bases-work/doi/controler fst=@doi/fst/controler.fst fullinv=../bases-work/doi/controler
    
echo Execution end of $0 $1 $1 $2 $3 $4 $5 $6 $7 $8 $9 in  `date`
