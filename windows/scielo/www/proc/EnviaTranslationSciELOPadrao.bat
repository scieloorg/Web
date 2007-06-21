@echo off
rem Este arquivo é uma chamada para o 
rem EnviaTranslationScielo.bat com parâmetros STANDARD

cls

echo === ATENCAO ===
echo Este arquivo fara a transferencia dos arquivos Translation das seguintes revistas
echo.
echo Tecle CONTROL-C para sair ou ENTER para verificar as revistas...

pause > nul

notepad \scielo\serial\translation.lst

cls
echo === ATENCAO ===
echo.
echo Sera executado o seguinte comando:
echo EnviaTranslationScielo.bat \scielo transf\EnviaTranslationLogOn.txt log\EnviaTranslationScieloPadrao.log cria \scielo\web\htdocs
echo.
echo Tecle CONTROL-C para sair ou ENTER para continuar...

pause > nul

EnviaTranslationScielo.bat \scielo transf\EnviaTranslationLogOn.txt log\EnviaTranslationScieloPadrao.log cria \scielo\web\bases

