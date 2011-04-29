export PATH=$PATH:.

rem Este arquivo é uma chamada para o
rem Envia2LogAcesso.bat .. transf/Envia2LogAcesso.txt log/envia2LogAcesso.log
rem com parametros standards.

clear
echo === ATENCAO ===
echo
echo Este arquivo executara:
echo
echo Envia2LogAcesso.bat .. transf/Envia2LogAcesso.txt log/envia2LogAcesso.log
echo
echo Tecle CONTROL-C para sair ou ENTER para continuar...

call Envia2LogAcesso.bat .. transf/Envia2LogAcesso.txt log/envia2LogAcesso.log
