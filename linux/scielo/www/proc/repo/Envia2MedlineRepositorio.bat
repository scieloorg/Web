export PATH=$PATH:.

rem Este arquivo é uma chamada para o
rem Envia2MedlineRepositorio.bat .. transf/Envia2MedlineLogOn.txt log/envia2medline.log cria
rem com parametros standards.

clear
echo === ATENCAO ===
echo
echo Este arquivo executara: 
echo
echo Envia2MedlineRepositorio.bat .. transf/Envia2MedlineLogOn.txt log/envia2medline.log cria
echo
echo Tecle CONTROL-C para sair ou ENTER para continuar...

if [ -f repo/repo.seq ]
then 
	$CISIS_DIR/mx seq=repo/repo.seq lw=9999 "pft='call Envia2Medline.bat $1 $2 $3 $4 ',s(f(val(v1)+100000,6,0))*1.5,' r',s(f(val(v1)+100,3,0))*1.2/" now > temp/callEnvia2MedlineRepositorio.bat
	chmod 775 temp/callEnvia2MedlineRepositorio.bat
	call temp/callEnvia2MedlineRepositorio.bat
fi
