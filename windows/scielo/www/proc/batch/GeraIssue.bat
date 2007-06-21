rem @echo off
rem GeraIssue
rem Parametro 1: path producao SciELO
rem Parametro 2: sigla da revista
rem Parametro 3: volume-numero do issue
rem Parametro 4: acao - se for "del" eh para deletar, se ausente eh caso normal

call batch\VerifPresencaParametro.bat %0 @%1 path producao SciELO
call batch\VerifPresencaParametro.bat %0 @%2 sigla da revista
call batch\VerifPresencaParametro.bat %0 @%3 volume-numero do issue

call batch\CriaDiretorio.bat ..\bases-work\%2
set REVISTA=..\bases-work\%2\%2
call batch\CriaDiretorio.bat ..\bases-work\%2\%3
set ISSUE=..\bases-work\%2\%3\%3

call batch\InformaLog.bat %0 x Gera Issue: %2 %3
if "%4" == "del" goto SKIP_REV_APPEND
	rem 1
	%CISIS_DIR%\mx %1\serial\%2\%3\base\%3 gizmo=gizmo\gizmoHTML create=%ISSUE% now -all
	if errorlevel==1 batch\AchouErro.bat %0 mx %1\serial\%2\%3\base\%3 gizmo:gizmo\gizmoHTML create:%ISSUE%
	rem 2
	call batch\GeraInvertido.bat %ISSUE% fst\auxcria799.fst %ISSUE%
	rem 3
	%CISIS_DIR%\mx %ISSUE% proc=@prc\cria799.prc proc=@prc\cria936.prc copy=%ISSUE% now -all
	if errorlevel==1 batch\AchouErro.bat %0 mx %ISSUE% proc:@prc\cria799.prc proc:@prc\cria936.prc copy=%ISSUE%

	rem Este mx eh soh para evitar o erro do mx bool se o master estiver vazio
	echo %3> temp/vol-num.txt
	%CISIS_DIR%\mx tmp count=1 "proc='a4~',cat('temp/vol-num.txt'),'~','a1004~',date,'~'" append=%REVISTA% now -all
	if errorlevel==1 batch\AchouErro.bat %0 Gambiarra...
:SKIP_REV_APPEND

call batch\InformaLog.bat %0 x Deleta issue antigo: %2 %3
call batch\GeraInvertido.bat %REVISTA% fst\Fasciculo.fst %REVISTA%
%CISIS_DIR%\mx %REVISTA% "bool=%3" "proc='d.'" now -all copy=%REVISTA%
if errorlevel==1 batch\AchouErro.bat %0 mx %REVISTA% bool:%3 proc:'d.'

if "%4" == "del" goto NADA_PARA_APPENDAR
   call batch\InformaLog.bat %0 x Adiciona issue na base: %2 %3
   %CISIS_DIR%\mx %ISSUE% proc=@prc\criaPID.prc append=%REVISTA% now -all
   if errorlevel==1 batch\AchouErro.bat %0 mx %ISSUE% proc:@prc\criaPID.prc append:%REVISTA%
:NADA_PARA_APPENDAR

call batch\GeraIso.bat %1\serial\%2\%3\base\%3 %1\serial\%2\%3\base\%2%3.iso
