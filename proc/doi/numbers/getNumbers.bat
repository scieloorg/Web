if [ ! -d temp ]
then
	mkdir temp/
fi
if [ ! -d temp/doi ]
then
	mkdir temp/doi
fi

find ../bases-work/doi/* -name "*.mst" | grep -v "controler.mst" > temp/doi/existing.txt
echo > temp/doi/numbersIssues.txt
cisis/mx seq=temp/doi/existing.txt "pft='doi/report/getNumbersIssue.bat ',mid(v1,1,size(v1)-4),' art'/" now > temp/doi/getNumbersIssue.bat
chmod +x temp/doi/getNumbersIssue.bat
temp/doi/getNumbersIssue.bat

mv temp/doi/numbersIssues.txt temp/doi/numbersIssues_.txt
grep -v "^$" temp/doi/numbersIssues_.txt > temp/doi/numbersIssues.txt
rm temp/doi/numbersIssues_.txt

if [ "@$1" == "@" ]
then
	echo Report file temp/doi/numbersIssues.txt 
else
	cp temp/doi/numbersIssues.txt $1
	echo Report file temp/doi/numbersIssues.txt 
fi

