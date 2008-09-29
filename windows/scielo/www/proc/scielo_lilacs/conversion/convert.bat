set scilista=%1
set initial_date=%2
set report=%3
set debug=%4

echo Executing %0 scilista=%1 initial_date=%2 report=%3 debug=%4
if not exist %scilista% goto FAILURE

	%mx% %title% lw=9999 "pft=if instr(v450,'LILACS')>0 or l(['%liltitle%']v400)>0 then ' ',v400,' ',v68 fi" now> %allowed%

	echo Titulos LILACS > %report%
	%mx% %title% lw=9999 "pft=if instr(v450,'LILACS')>0 or l(['%liltitle%']v400)>0 then v400,' ',v100\ fi" now>> %report%
	
	%mx% null count=0 create=%myissue% now -all
	%mx% $issue lw=9999 "proc=if l(['%liltitle%']v35)>0 and instr(v32,'ahead')=0 and instr(v32,'review')=0 then 'a91{',date,'{' else 'd*' fi" append=%myissue% now -all
	%mx% %myissue% "fst=@scielo_lilacs\conversion\fst\myissue.fst" fullinv=%myissue%


	scielo_lilacs\tools\createDB.bat %ctrl_issue% scielo_lilacs\conversion\fst\ctrl_issue.fst 
	scielo_lilacs\tools\createDB.bat %ctrl_conversion% scielo_lilacs\conversion\fst\ctrl_conversion.fst 
	scielo_lilacs\tools\createDB.bat %basePreLILACSEXPRESS% scielo_lilacs\conversion\fst\PreLILACSEXPRESS.fst   
	scielo_lilacs\tools\createDB.bat %templilxp% scielo_lilacs\conversion\fst\PreLILACSEXPRESS.fst reset 

	
	echo exporting...
	%wxis% IsisScript=scielo_lilacs\conversion\generatePreLILACSEXPRESS.xis scilista=%scilista% myissue=%myissue% allowed=%allowed% initial_date=%initial_date% tempLILACSEXPRESS=%templilxp% proc_path=%proc_path% debug=%debug%  cip=%cip% >> %report%
	
	echo Indexing %ctrl_issue%
	%mx% %ctrl_issue% "fst=@scielo_lilacs\conversion\fst\ctrl_issue.fst" fullinv=%ctrl_issue%

	echo Indexing %ctrl_conversion%
	%mx% %ctrl_conversion% "fst=@scielo_lilacs\conversion\fst\ctrl_conversion.fst" fullinv=%ctrl_conversion%

	echo Indexing %basePreLILACSEXPRESS%
	%mx% %basePreLILACSEXPRESS% "fst=@scielo_lilacs\conversion\fst\PreLILACSEXPRESS.fst" fullinv=%basePreLILACSEXPRESS%	
	
GOTO END

:FAILURE
echo Missing scilista %scilista%

:END