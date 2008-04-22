rem @echo off
rem GeraInvIAH
rem Parametro 1: repositorio
rem Parametro 2: search.fst para gerar
rem Parametro 3: searchp.fst para gerar
rem Parametro 4: issn opcional


export PATH=$PATH:.
export INFORMALOG=log/GeraScielo.log
export CISIS_DIR=cisis

call batch/VerifPresencaParametro.bat $0 @$1 repositorio
call batch/VerifPresencaParametro.bat $0 @$2 search.fst para gerar
call batch/VerifPresencaParametro.bat $0 @$3 searchp.fst para gerar

echo Generate FST
if [ "@$4" == "@" ] 
then
echo sem issn
	$CISIS_DIR/mx "seq=temp/search.xxx!" lw=99999 "proc='a9000{$1{'" "pft=@repo/repo_proc_repo.prc" now> $2
	$CISIS_DIR/mx "seq=temp/searchp.xxx!" lw=99999 "proc='a9000{$1{'" "pft=@repo/repo_proc_repo.prc" now> $3
else
echo com issn $4
	$CISIS_DIR/mx "seq=temp/search.xxx!" lw=99999 "proc='a9000{$1{a9001{$4{'" "pft=@repo/repo_proc_repo_issn.prc" now> $2
	$CISIS_DIR/mx "seq=temp/searchp.xxx!" lw=99999 "proc='a9000{$1{a9001{$4{'" "pft=@repo/repo_proc_repo_issn.prc" now> $3
fi

