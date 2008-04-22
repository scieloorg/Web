rem @echo off
rem RepoGeraInvIAH4lista
rem Parametro 1: path producao SciELO
rem Parametro 2: seq que contem a lista de bases para inverter

call batch\VerifPresencaParametro.bat %0 @%1 path producao SciELO
call batch\VerifPresencaParametro.bat %0 @%2 seq que contem a lista de bases para inverter

call batch\InformaLog.bat %0 x Gera invertidos do IAH

echo rem RepoGeraInvIAH4lista >temp\RepoGeraInvIAH4lista.bat

%CISIS_DIR%\mx "seq=%2 " lw=9000 "pft='call repo\RepoGeraInvIAH4item.bat ',v1,x1,'r',s(f(val(v1)+100,3,0))*1.2,x1,v2,x1,v3/" now -all >>temp\RepoGeraInvIAH4lista.bat

rem chmod 700 temp\RepoGeraInvIAH4lista.bat

call temp\RepoGeraInvIAH4lista.bat
