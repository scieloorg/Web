
export idate=`date +%d_%m_%Y_%k_%M_%s`
mkdir $exportPath

export exportdbname=scielo-lilacs_$idate
export exportdb=$exportPath/$exportdbname

scielo_lilacs/tools/createDB.bat $ctrl_exportation scielo_lilacs/export/export.fst 


$mx $ctrl_issue fst=@scielo_lilacs/conversion/fst/ctrl_issue.fst fullinv=$ctrl_issue


echo gera base lilacs express 
$mx $ctrl_issue btell=0 "bool=STATUS=DONE" lw=9999 "proc='d9001d9002d9003a9001{$mx{a9002{$basePreLILACSEXPRESS{a9003{$exportdb{'" "pft=@scielo_lilacs/export/export.pft" now > temp/export_aux.bat
chmod 775 temp/export_aux.bat
temp/export_aux.bat

echo gera base lilacs express iso
$mx $exportdb iso=$exportdb.iso now -all


cp $exportdb.iso temp/$exportdbname.iso
$mx $ctrl_issue iso=temp/control_issue.iso now -all

export foi=temp/foi_$idate.txt

scielo_lilacs/export/filesTransfer.bat $mx $ftp_config $exportdbname.iso control_issue.iso $foi

if [ -f $foi ]
then 
	$mx $ctrl_issue btell=0 "bool=STATUS=DONE" lw=9999 "proc='d90d80a90{EXPORTED{a80{$exportdbname.iso{'" copy=$ctrl_issue now -all
else
	rm -rf $exportdb.*
fi
$mx $ctrl_issue fst=@scielo_lilacs/conversion/fst/ctrl_issue.fst fullinv=$ctrl_issue
rm -rf temp/$exportdbname.iso temp/control_issue.iso
