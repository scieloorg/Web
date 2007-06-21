@echo off
rem Este arquivo é uma chamada para o 
rem EnviaBasesScielo.bat com parâmetros STANDARD

cls

echo === ATENCAO ===
echo Este arquivo fara a transferencia das bases das seguintes revistas
echo.
echo Tecle CONTROL-C para sair ou ENTER para verificar as revistas...

pause > nul

notepad \scielo\serial\scilista.lst

cls
echo === ATENCAO ===
echo.
echo Sera executado o seguinte comando:
echo EnviaBasesScielo.bat \scielo transf\EnviaBasesLogOn.txt log\EnviaBasesScieloPadrao.log cria
echo.
echo Tecle CONTROL-C para sair ou ENTER para continuar...

pause > nul

EnviaBasesScieloParaWindows.bat \scielo transf\EnviaBasesLogOn.txt log\EnviaBasesScieloPadrao.log cria

