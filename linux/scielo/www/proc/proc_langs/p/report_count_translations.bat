rm $4_original.txt 
rm $4_no_translation.txt
rm $4_at_least_one_translation.txt
rm $4_only_translations.txt 
rm $4_all.txt

$1 $2/title/title lw=9999 "proc='a9001{$1{a9003{$3{a9004{$4{'" "pft=@proc_langs/pft/query_journal.pft" now> temp/proc_langs_getData.bat
chmod 775 temp/proc_langs_getData.bat
./temp/proc_langs_getData.bat 

echo Originais
cat $4_original.txt | wc -l

echo no_translation
cat $4_no_translation.txt | wc -l

echo at_least_one_translation
cat $4_at_least_one_translation.txt | wc -l

echo only_translations
cat $4_only_translations.txt | wc -l

echo all
cat $4_all.txt | wc -l
