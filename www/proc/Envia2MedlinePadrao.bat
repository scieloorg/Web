export PATH=$PATH:.

rem Este arquivo é uma chamada para o
rem Envia2Medline.bat .. transf/Envia2MedlineLogOn.txt log/envia2medline.log cria
rem com parametros standards.

clear
echo === ATENCAO ===
echo
echo Este arquivo executara: 
echo
echo Envia2Medline.bat .. transf/Envia2MedlineLogOn.txt log/envia2medline.log cria
echo
echo Tecle CONTROL-C para sair ou ENTER para continuar...

read pause

call Envia2Medline.bat .. transf/Envia2MedlineLogOn.txt log/envia2medline.log cria
