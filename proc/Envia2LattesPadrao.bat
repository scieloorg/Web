export PATH=$PATH:.

rem Este arquivo é uma chamada para o
rem Envia2Lattes.bat .. transf/Envia2LattesLogOn.txt log/envia2lattes.log cria
rem com parametros standards.

clear
echo === ATENCAO ===
echo
echo Este arquivo executara: 
echo
echo Envia2Lattes.bat .. transf/Envia2LattesLogOn.txt log/envia2lattes.log cria
echo
echo Tecle CONTROL-C para sair ou ENTER para continuar...

read pause

call Envia2Lattes.bat .. transf/Envia2LattesLogOn.txt log/envia2lattes.log cria
