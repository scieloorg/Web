. langs/config/config.inc

SCILISTA=$1
./$BATCHES_PATH/genDBLang/main.bat $SCILISTA
./$BATCHES_PATH/reports/generateLangReports.bat
