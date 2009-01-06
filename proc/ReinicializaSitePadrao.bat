export PATH=$PATH:.
rem Este arquivo é uma chamada para os processos
rem ReinicializaSite.bat e ExtraiRevistasArtigo.bat
rem com parâmetros STANDARD

clear
echo === ATENCAO ===
echo 
echo Este arquivo executara os seguintes comandos
echo ReinicializaSite.bat .. .. log/ReinicializaSite.log adiciona
echo ExtraiRevistasArtigo.bat .. .. log/ExtraiRevistasArtigo.log adiciona
echo 


./ReinicializaSite.bat .. .. log/ReinicializaSite.log cria
./ExtraiRevistasArtigo.bat .. .. log/ExtraiRevistasArtigo.log cria
