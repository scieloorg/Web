. scieloUpdade_config.sh 

cd $caminhoAPL"/www/proc/scieloUpdate" 

rm -rf www/

svn list $svnLocal"/tags"
echo Elija una vesion para prepara paquete o deje en blanco para generar paquete del trunk:
read version

if [ $version == "" ]
then
   export file="trunk"
   export version="/trunk"
else
   export file=$version
   export version="/tags/"$version
fi

echo "Bajando archivos de la version"$file
svn export --force $svnLocal$version/www www/

echo "Comprimindo archivos en scieloMetodologia-"$file".tgz"
tar cfpz scieloMetodologia-$file.tgz www/

echo "Compiando archivo scieloMetodologia-"$file".tgz para:"$caminhoAPL
cp scieloMetodologia-$file.tgz $caminhoAPL

echo "Desea descomprimir el archivo en $caminhoAPL (y/n): " 
read copying

if [ $copying == "y" ]
then
   cd $caminhoAPL
   echo "Haciendo backup de version actual en $caminhoAPL"
   export backdate=`date '+%Y%m%d%H%M%S'`
   tar cfzp scieloMetodologia-backup-$backdate.tgz www/
   echo "Descomprimiendo el archivo scieloMetodologia-$file.tgz en $caminhoAPL"
   tar xfzp scieloMetodologia-$file.tgz
fi

cd $caminhoAPL"/www/proc/scieloUpdate"
