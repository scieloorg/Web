#
# This script is called by xref_run.sh
# This script accepts as parameters ISSN or PID of article, and 
# generates and uploads XML and updates control database XREF_DOI_REPORT
#
. crossref_config.sh

PROCESS_ONLY_NEW=$1
ISSN_OR_PID=$2

if [ "@$ISSN_OR_PID" == "@" ]
then
	$cisis_dir/mx cipar=$MYCIPFILE ARTIGO_DB "btell=0" "hr=$" lw=9999 "proc='d9980a9980{',if p(v891) then v891 else if p(v881) then v881, else v880 fi fi,'{'" "proc=if a(v237) then 'a9090{doit{' else ,if mid(v237,1,instr(v237,'/')-1)='$depositor_prefix' then 'a9090{doit{' fi fi" "pft=if v9090='doit' then '$conversor_dir/shs/xref_generateAndUploadXML.sh ',v9980 ,' DO',ref(['XREF_DOI_REPORT']l(['XREF_DOI_REPORT']'hr=',v9980),if v30<>'error' then 'NOT' fi),' $PROCESS_ONLY_NEW'/ fi" now > $MYTEMP/x.sh
else
	$cisis_dir/mx cipar=$MYCIPFILE ARTIGO_DB "btell=0" "hr=S$ISSN_OR_PID$ or hr=$ISSN_OR_PID$" lw=9999  "proc='d9980a9980{',if p(v891) then v891 else if p(v881) then v881, else v880 fi fi,'{'" "proc=if a(v237) then 'a9090{doit{' else ,if mid(v237,1,instr(v237,'/')-1)='$depositor_prefix' then 'a9090{doit{' fi fi" "pft=if v9090='doit' then '$conversor_dir/shs/xref_generateAndUploadXML.sh ',v9980,' DO',ref(['XREF_DOI_REPORT']l(['XREF_DOI_REPORT']'hr=',v9980),if v30<>'error' then 'NOT' fi),' $PROCESS_ONLY_NEW'/ fi" now > $MYTEMP/x.sh
fi

chmod 775 $MYTEMP/x.sh
$MYTEMP/x.sh

