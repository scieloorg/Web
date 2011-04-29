export PATH=$PATH:.

rem ===== Aumentar o espaco de variaveis de ambiente
rem CONFIG.SYS
rem 

rem doi/scilista/doIssueList.bat
rem Parametro 1: journal acron
rem Parametro 2: issue


rem Inicializa variaveis

export INFORMALOG=log/sclista_doIssueList.log
export CISIS_DIR=cisis

echo Execution begin of $0 $1 $2 $3 $4 $5 in  `date`

rem Verifica parametros
call batch/VerifPresencaParametro.bat $0 @$1 journal acron
call batch/VerifPresencaParametro.bat $0 @$2 issue

if [ ! -f ../bases-work/doi/$1/$2/$2.xrf ] 
then
	echo $1 $2>>../bases-work/doi/scilista_create/$1.txt
else
	
	cisis/mx ../bases-work/doi/$1/$2/$2 btell=0 bool=STATUS=DOI count=1 "pft='$1 $2'/" now >temp/doi/scilista/teste2_$1_$2.txt
	echo scilista>> temp/doi/scilista/teste2_$1_$2.txt
	echo end>> temp/doi/scilista/teste2_$1_$2.txt

	cisis/mx seq=temp/doi/scilista/teste2_$1_$2.txt create=temp/doi/scilista/teste2_$1_$2 now -all

	cisis/mx seq=temp/doi/scilista/teste2_$1_$2.txt from=1 count=1 "pft=if v1<>'scilista' then v1/ fi'" now >> ../bases-work/doi/scilista_update/$1.txt
	cisis/mx seq=temp/doi/scilista/teste2_$1_$2.txt from=1 count=1 "pft=if v1='scilista' then '$1 $2'/ fi'" now >> ../bases-work/doi/scilista_create/$1.txt

fi


echo Execution .end. of $0 $1 $2 $3 $4 $5 in  `date`
