. unittest_configure.sh

##########################
# GERANDO LISTA DE ISS´s da base TITLE com Status = C
##########################
./unittest_generateISSNList.sh

php unittest_iahGeral.php 

##########################
# REMOVENDO TEMPORARIOS
##########################
rm -f issnList.txt
