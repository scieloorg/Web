if [ "@$1" == "@" ]
then
  sh ./shs/display_report.sh ../../cisis/mxtb ../../cisis/mx ../../../bases-work/doi_query/querylog ../../../bases-work/doi/query report.txt
  echo report.txt
else
  sh ./shs/display_report.sh ../../cisis/mxtb ../../cisis/mx ../../../bases-work/doi_query/querylog ../../../bases-work/doi/query $1 
fi
echo $1
