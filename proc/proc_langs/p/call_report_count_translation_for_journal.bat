echo Executing for $4
$1 $2/$4/lang lw=9000 "proc='a9001{original{'" "pft=@proc_langs/pft/report_count_translations.pft"  now >> $3_original.txt
$1 $2/$4/lang lw=9000 "proc='a9001{no_translation{'" "pft=@proc_langs/pft/report_count_translations.pft"  now >> $3_no_translation.txt
$1 $2/$4/lang lw=9000 "proc='a9001{at_least_one_translation{'" "pft=@proc_langs/pft/report_count_translations.pft" now >> $3_at_least_one_translation.txt
$1 $2/$4/lang lw=9000 "proc='a9001{only_translations{'" "pft=@proc_langs/pft/report_count_translations.pft"  now >> $3_only_translations.txt
$1 $2/$4/lang lw=9000 "proc='a9001{all{'" "pft=@proc_langs/pft/report_count_translations.pft" now >> $3_all.txt


echo Originais
cat $3_original.txt | wc -l

echo no_translation
cat $3_no_translation.txt | wc -l

echo at_least_one_translation
cat $3_at_least_one_translation.txt | wc -l

echo only_translations
cat $3_only_translations.txt | wc -l

echo all
cat $3_all.txt | wc -l
