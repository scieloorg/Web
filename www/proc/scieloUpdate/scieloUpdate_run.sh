. scieloUpdate_config.sh 

cd $caminhoAPL"/www/proc/scieloUpdate" 

rm -rf www/

svn list $svnLocal"/tags"
echo Elija una vesion para prepara paquete o deje en blanco para generar paquete del trunk:
read version

if [ -z $version ]
then
   export file="trunk"
   export version="/trunk"
else
   export file=$version
   export version="/tags/"$version
fi

echo "Bajando archivos de la version "$file
svn export --force $svnLocal$version/www www/

if [ -z $branch ]
then
   echo "Ningun branch configurado para actualizacion"
   branch='default'
else
   echo "Bajando archivo del branch "$branch
   svn export --force $svnLocal/branches/$branch/www www/
   branch="${branch/\//_}"
fi


echo "Comprimindo archivos en scieloMetodologia-$branch-$file.tgz"
tar cfpz scieloMetodologia-$branch-$file.tgz www/

echo "Compiando archivo scieloMetodologia-$branch-$file.tgz para:"$caminhoAPL
cp scieloMetodologia-$branch-$file.tgz $caminhoAPL

echo "Desea descomprimir el archivo en $caminhoAPL (y/n): " 
read copying

if [ $copying == "y" ]
then
   cd $caminhoAPL
   echo "Haciendo backup de version actual en $caminhoAPL"
   export backdate=`date '+%Y%m%d%H%M%S'`
   tar cfzp scieloMetodologia-backup-$backdate.tgz --exclude-from=www/proc/scieloUpdate/exclude.txt www/htdocs www/proc www/cgi-bin
   echo "Descomprimiendo el archivo scieloMetodologia-$branch-$file.tgz en $caminhoAPL"
   tar xfzp scieloMetodologia-$branch-$file.tgz
fi

echo "Atualizando permissões do wxis.exe"
chmod -R 775 www/cgi-bin/wxis.exe
chmod -R 775 www/proc/*.sh

cd $caminhoAPL"/www/proc/scieloUpdate"
