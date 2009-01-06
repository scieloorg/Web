export idate=`date`

export scilista=$1
export initial_date=$2
export REPORT_LOG=$3
export debug=$4
export PROCESSING_RESULT=$5
export REPORT_NUMBERS=$6
export REPORT_DIFF_IN_TXT=$7
export REPORT_DIFF_IN_HTML=$8

if [ ! -d `dirname $REPORT_LOG` ]
then
        mkdir -p `dirname $REPORT_LOG`
fi
cat scielo_lilacs/config/config.bat > temp/convert_and_report.bat
cat scielo_lilacs/tools/config.bat >> temp/convert_and_report.bat
cat scielo_lilacs/conversion/convert_and_report_aux.bat >> temp/convert_and_report.bat

chmod 775 temp/convert_and_report.bat
temp/convert_and_report.bat
