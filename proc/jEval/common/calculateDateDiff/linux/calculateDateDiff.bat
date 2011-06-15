. $1

RANGE_DATE_LIST=$2
FILE_RESULT_DIFF=$3


if [ ! -f "$DB_DATES/dates.mst" ]
then
echo Atualiza tabela de datas
    $PATH_COMMON/linux/seq2mst.bat $1 $PATH_DATE_DIFF/common/dates.seq $DB_DATES
    $MX $DB_DATES fst=@$PATH_DATE_DIFF/common/dates.fst fullinv=$DB_DATES
fi
if [ -f "$FILE_RESULT_DIFF" ]
then
    echo Apaga o resultado
    rm "$FILE_RESULT_DIFF"
fi

echo Cria temp/je_cdd_je_diff
$MX seq=$RANGE_DATE_LIST "proc=if val(v1) < val(v2) then 'd1d2','a1{',v2,'{a2{',v1,'{' fi" create=temp/je_cdd_dates now -all
$MX temp/je_cdd_dates  "proc=@$PATH_DATE_DIFF/common/calculateDateDiff_a3_a4.prc" "proc='a9000{$DB_DATES{'" "proc=@$PATH_DATE_DIFF/common/calculateDateDiff_a5_a6.prc" "proc=if p(v2) then 'a7{',f(val(v5)-val(v6),1,0),'{', fi" create=temp/je_cdd_je_diff now -all
echo Calcula o total
$MX temp/je_cdd_je_diff "tab='x'" now > temp/je_cdd_total.txt
echo >> temp/je_cdd_total.txt
$MXTB temp/je_cdd_je_diff create=temp/je_cdd_soma "100:'soma'" "tab=v7"

echo Lista do menor para o maior
$MX temp/je_cdd_je_diff "pft=s(f(100000000+val(v7),1,0))*1/" now | sort > temp/je_cdd_greater.seq
echo >> temp/je_cdd_greater.seq
$MX seq=temp/je_cdd_greater.seq create=temp/je_cdd_greater now -all

############
# 100 = total
# 200 = menor
# 300 = maior
# 500 = quantidade
# 400 = media
echo Resultado $FILE_RESULT_DIFF
$MX seq=temp/je_cdd_total.txt count=1 "proc='a500{',v2,'{a200{',ref(['temp/je_cdd_greater']1,v1),'{a300{',ref(['temp/je_cdd_greater']val(v2),v1),'{a100{',ref(['temp/je_cdd_soma']1,v999),'{'" "proc='d400a400{',f(val(v100) / val(v500) ,1,0),'{'" "pft='artigos (com datas aceito/recebido válidas)|',v500/,'soma (dias)|',v100/,'menor tempo (dias)|',v200/,'maior tempo (dias)|',v300/,'media de tempo (em dias)|',v400/,#" now >> $FILE_RESULT_DIFF
echo fim

