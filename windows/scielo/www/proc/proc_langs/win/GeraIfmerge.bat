@echo off
rem FIXME
set DB_CONTROL=..\bases-work\lang\control
set PROC_DIR=\home\scielo\www\proc\

cisis\mx seq=proc_langs\text-langs.def "pft=if v1:'LANG_DATABASE_PATH' then 'set LANG_DATABASE_PATH_SO=',replace(mid(v1,instr(v1,'=')+1,size(v1)),'/','\')/,'set LANG_DATABASE_PATH=',replace(mid(v1,instr(v1,'=')+1,size(v1)),'/','-')/, fi" now > temp\GeraIfmerge.bat
call temp\GeraIfmerge.bat

echo cd %LANG_DATABASE_PATH_SO% >> temp\GeraIfmerge.bat
cisis\mx %DB_CONTROL% lw=9999 count=1 "pft=if mfn=1 then 'ifmerge lang\lang ' fi" now >> temp\GeraIfmerge.bat

cisis\mx %DB_CONTROL% btell=0 "bool=path=%LANG_DATABASE_PATH%" lw=9999 "pft=replace(v1,'/','\'),' '" now >> temp\GeraIfmerge.bat
echo  +mstxrf >>temp\GeraIfmerge.bat

more temp\GeraIfmerge.bat
call temp\GeraIfmerge.bat

cd %PROC_DIR%
cisis\mx %LANG_DATABASE_PATH_SO%lang\lang now

