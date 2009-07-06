#
# This script is called by xref_run.sh
# This script accepts as parameters ISSN or PID of article, and 
# generates and uploads XML and updates control database XREF_DOI_REPORT
#
. crossref_config.sh


ISSN_OR_PID=$1

if [ "@$ISSN_OR_PID" == "@" ]
then
	$cisis_dir/mx cipar=$MYCIPFILE ARTIGO_DB "btell=0" "hr=$" lw=9999 "pft='$conversor_dir/shs/xref_generateAndUploadXML.sh ',if p(v881) then v881, else v880 fi/" now > $MYTEMP/x.sh
else
	$cisis_dir/mx cipar=$MYCIPFILE ARTIGO_DB "btell=0" "hr=S$ISSN_OR_PID$ or hr=$ISSN_OR_PID$" lw=9999 "pft='$conversor_dir/shs/xref_generateAndUploadXML.sh ',if p(v881) then v881, else v880 fi/" now > $MYTEMP/x.sh
fi

chmod 775 $MYTEMP/x.sh
$MYTEMP/x.sh

