export PATH=$PATH:.

rem Este arquivo eh uma chamada para o
rem Envia2MedlineCompactados.bat .. transf/Envia2MedlineCompactadosLogOn.txt log/envia2medlinecompactadosFTP.log cria
rem com parametros padronizados.

clear
echo === ATENCAO ===
echo
echo Este arquivo executara: 
echo
echo Envia2MedlineCompactados.bat .. transf/Envia2MedlineCompactadosLogOn.txt log/envia2medlinecompactadosFTP.log cria
echo
echo Tecle CONTROL-C para sair ou ENTER para continuar...

call Envia2MedlineCompactados.bat .. transf/Envia2MedlineCompactadosLogOn.txt log/envia2medlinecompactadosFTP.log cria

