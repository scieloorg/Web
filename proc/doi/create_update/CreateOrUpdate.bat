
export PATH=$PATH:.
export CISIS_DIR=cisis

rem parametro 1 base doi
rem parametro 2 pid
rem parametro 3 doi
rem parametro 4 status
rem parametro 5 origem do dado
rem parametro 6 copy or append
echo Execution begin of $0 $1 $2 $3 $4 $5 $6 $7 $8 in  `date`


if [ "@$6" = "@copy" ]
then
	cisis/mx $1 btell=0 "bool=$2" count=1 "proc='d*a1{$2{',if '$4'='doi' then 'a2{$3{' fi,'a3{$4{a900{$5{'" "proc=@doi/prc/doi_create_register.prc" copy=$1 now -all
else
	echo do nothing > temp/doi/proc/x.seq
	cisis/mx seq=temp/doi/proc/x.seq count=1 "proc='d*a1{$2{',if '$4'='doi' then 'a2{$3{' fi,'a3{$4{a900{$5{'" "proc=@doi/prc/doi_create_register.prc" append=$1 now -all
fi
echo Execution end of $0 $1 $2 $3 $4 $5 $6 $7 $8 in  `date`