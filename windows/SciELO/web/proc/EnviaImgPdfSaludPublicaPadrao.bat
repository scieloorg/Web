@echo off
rem Este arquivo é uma chamada para o 
rem EnviaImgPdfScielo.bat com parâmetros STANDARD

cls

echo === ATENCAO ===
echo Este arquivo fara a transferencia das imagens/pdfs das seguintes revistas
echo.
echo Tecle CONTROL-C para sair ou ENTER para verificar as revistas...

pause > nul

notepad \scielo\serial\scilista.lst

cls
echo === ATENCAO ===
echo.
echo Sera executado o seguinte comando:
echo EnviaImgPdfScielo.bat \scielo transf\EnviaImgPdfLogOnSaludPublica.txt log\EnviaImgPdfSaludPublicaPadrao.log cria \scielo\web\htdocs
echo.
echo Tecle CONTROL-C para sair ou ENTER para continuar...

pause > nul

EnviaImgPdfScielo.bat \scielo transf\EnviaImgPdfLogOnSaludPublica.txt log\EnviaImgPdfSaludPublicaPadrao.log cria \scielo\web\htdocs

