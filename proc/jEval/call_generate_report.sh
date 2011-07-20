OPTIONAL_ACRON_LIST=$1

dos2unix ./tools/list/*.sh
dos2unix ./tools/aff/*.sh
dos2unix ./shs/*.sh

dos2unix ./tools/calculateDateDiff/linux/calculateDateDiff.bat
dos2unix ./tools/aff/getIssuesAff.bat
dos2unix ./common/prepareGizmos.bat
dos2unix ./common/seq2mst.bat
dos2unix ./common/WriteLog.bat

dos2unix ./config/*

sh ./shs/generate_reports.sh $OPTIONAL_ACRON_LIST