rem @echo off
rem GeraInvIAH
rem Parametro 1: repositorio
rem Parametro 2: search.fst para gerar
rem Parametro 3: searchp.fst para gerar
rem Parametro 4: issn opcional

call batch\VerifPresencaParametro.bat %0 @%1 repositorio
call batch\VerifPresencaParametro.bat %0 @%2 search.fst para gerar
call batch\VerifPresencaParametro.bat %0 @%3 searchp.fst para gerar

echo Generate FST
if "@%4"=="@"  goto SKIP_FST_REPO
%CISIS_DIR%\mx "seq=temp\search.xxxç" lw=99999 "pft=replace(v1,`then`,` and v268='%1' and v35='%4' then`)/" now> %2
%CISIS_DIR%\mx "seq=temp\searchp.xxxç" lw=99999 "pft=replace(v1,`then`,` and v268='%1' and v35='%4' then`)/" now> %3
goto REPOGENFST_END

:SKIP_FST_REPO
%CISIS_DIR%\mx "seq=temp\search.xxxç" lw=99999 "pft=replace(v1,`then`,` and v268='%1' then`)/" now> %2
%CISIS_DIR%\mx "seq=temp\searchp.xxxç" lw=99999 "pft=replace(v1,`then`,` and v268='%1' then`)/" now> %3

:REPOGENFST_END
