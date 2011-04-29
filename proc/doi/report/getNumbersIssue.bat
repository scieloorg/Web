echo Checking $1
if [  -f "$1.cnt" -o -f "$1.iy0" ]
then
	cisis/mx $1 "bool=status=doi and type=$2" count=0 now > temp/doi/number.txt
	cisis/mx $1 "bool=$ and type=$2" count=0 now>> temp/doi/number.txt
	cisis/mx seq=temp/doi/number.txt "pft=if mfn=1 then '$1|$2' fi,if instr(v1,'Hits=')>0 then '|',mid(v1,6,size(v1)) fi" now >> temp/doi/numbersIssues.txt
	cisis/mx $1 count=1 "pft='|',v900" now >> temp/doi/numbersIssues.txt
else
	echo "$1|$2|0|0">>temp/doi/numbersIssues.txt
fi
echo "">>temp/doi/numbersIssues.txt

