export idate=`date`

export scilista=$1
export initial_date=$2
export report=$3
export debug=$4
export reportQuantity=$5
export reportErrorsTxt=$6
export reportErrors=$7

if [ ! -d `dirname $report` ]
then
        mkdir -p `dirname $report`
fi
cat scielo_lilacs/tools/config.bat > temp/convert_and_report.bat
cat scielo_lilacs/config/config.bat >> temp/convert_and_report.bat
cat scielo_lilacs/conversion/convert_and_report_aux.bat >> temp/convert_and_report.bat

chmod 775 temp/convert_and_report.bat
temp/convert_and_report.bat
