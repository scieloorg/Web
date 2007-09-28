@echo off
rem Envia2LilacsPadrao

set CISIS_DIR=cisis

rem Verifica parametros

call notepad lillista.lst

cls
echo === ATENCAO ===
echo.
echo Sera executado o seguinte comando:
echo Envia2LilacsPadrao.bat
echo.
echo Tecle CONTROL-C para sair ou ENTER para continuar...

pause > nul

if not exist lillista.lst goto ERRO
%CISIS_DIR%\mx "seq=lillista.lst " lw=9000 pft=@pft\lillista.pft now >temp\GeraEnvio2Lilacs.bat
if errorlevel==1 batch\AchouErro.bat %0 mx criacao temp\GeraEnvio2Lilacs.bat

call temp\GeraEnvio2Lilacs.bat
goto FIM

:ERRO
echo Erro no processo.

:FIM
echo FIM
