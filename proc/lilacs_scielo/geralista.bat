%mx% iso=%1 "proc='d32a32{',replace(v32,'/','-'),'{'" "pft='mioc v'v31,if v32*0.1<>'^' then 'n',v32^*,fi,|s|v32^s,/" now | sort /R >temp\lista.txt
%mx% seq=temp\lista.txt create=temp\lista now -all
echo 1
%mx% temp\lista "pft=if mfn=1 then v1/ else if v1<>ref(mfn-1,v1) then v1/ fi fi" now > temp\lista.txt
%mx% seq=temp\lista.txt create=temp\lista now -all
echo 2
%mx%  cipar=lilacs_scielo\config\cipar.cip temp\lista "pft=if ref(['CTRL_ISSUE']l(['CTRL_ISSUE']replace(v1,' ','')),v90)<>'DONE' then v1/ fi" now | sort /R > %2
echo 3
%mx% cipar=lilacs_scielo\config\cipar.cip  temp\lista "pft=if ref(['CTRL_ISSUE']l(['CTRL_ISSUE']replace(v1,' ','')),v90)='DONE' then v1,' reprocess'/ fi" now | sort /R>> %2

echo lista criada %2

