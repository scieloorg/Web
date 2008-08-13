echo Parameter 1 mx
echo Parameter 2 dbscielo
echo Parameter 3 dbLILACSEXPRESS
echo Parameter 4 result
echo Parameter 5 from
echo Parameter 6 count

export src=../bases-work/scielo_lilacs/regL
export dest=../bases-work/scielo_lilacs/reg8
export report=temp/scielo_lilacs_report.htm
export path=scielo_lilacs/

cisis.lind/wxis IsisScript=scielo_lilacs/checking/checking_conversion_scielo_lilacs.xis proc_path=$path dbsource=$src dbdestination=$dest result=$report from=10760 count=20 debug=On

