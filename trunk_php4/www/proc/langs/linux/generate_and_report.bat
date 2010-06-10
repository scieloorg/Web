. langs/config/config.inc

SCILISTA=$1
YEAR=$2
./$BATCHES_PATH/genDBLang/main.bat $SCILISTA $YEAR
./$BATCHES_PATH/reports/generateLangReports.bat
