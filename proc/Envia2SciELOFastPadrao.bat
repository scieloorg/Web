export PATH=$PATH:.

rem Este arquivo eh uma chamada para o
rem Envia2Medline.bat .. transf/Envia2MedlinePadrao.txt log/envia2medline.log cria
rem com parametros padronizados.

clear
echo === ATENCAO ===
echo
echo Este arquivo executara: 
echo
echo Envia2SciELOFast.bat ../bases-work transf/Envia2SciELOFastLogOn.txt log/envia2SciELOFast.log cria
echo
echo Tecle CONTROL-C para sair ou ENTER para continuar...

call Envia2Medline.bat ../bases-work transf/envia2SciELOFastLogOn.txt log/envia2SciELOFast.log cria

