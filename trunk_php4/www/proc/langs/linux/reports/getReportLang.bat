. $1

$BATCHES_PATH/reports/common/generateReport.bat $1 temp/langs_report_base.txt $ ISSN=NO YEAR=NO DOCTOPIC=NO
$BATCHES_PATH/reports/common/generateReport.bat $1 temp/langs_report_doctopic.txt $ ISSN=NO YEAR=NO DOCTOPIC=YES

#$BATCHES_PATH/reports/common/generateReport.bat $1 temp/langs_report_year.txt $ ISSN=NO YEAR=YES DOCTOPIC=NO
#$BATCHES_PATH/reports/common/generateReport.bat $1 temp/langs_report_year_doctopic.txt $ ISSN=NO YEAR=YES DOCTOPIC=YES

$MX $TITLE lw=9999 "pft='$BATCHES_PATH/reports/common/generateReport.bat $1 temp/langs_report_',v68,'.txt hr=S',v400,'$ ISSN=NO YEAR=NO DOCTOPIC=NO'/,'$BATCHES_PATH/reports/common/generateReport.bat $1 temp/langs_report_',v68,'_doctopic.txt hr=S',v400,'$ ISSN=NO YEAR=NO DOCTOPIC=YES'/'$BATCHES_PATH/reports/common/generateReport.bat $1 temp/langs_report_',v68,'_year.txt hr=S',v400,'$ ISSN=NO YEAR=YES DOCTOPIC=NO'/,'$BATCHES_PATH/reports/common/generateReport.bat $1 temp/langs_report_',v68,'_year_doctopic.txt hr=S',v400,'$ ISSN=NO YEAR=YES DOCTOPIC=YES'/" now > temp/langs_report_by_issn.bat

chmod 775 temp/langs_report_by_issn.bat
./temp/langs_report_by_issn.bat
