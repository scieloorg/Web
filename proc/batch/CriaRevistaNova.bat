rem CriaRevistaNova
rem Parametro 1: path producao Scielo
rem Parametro 2: codigo da revista

call batch/VerifPresencaParametro.bat $0 @$1 path producao Scielo
call batch/VerifPresencaParametro.bat $0 @$2 codigo da revista

call batch/InformaLog.bat $0 x Verifica se existe revista: ../bases-work/$2/$2
call batch/CriaDiretorio.bat ../bases-work/$2

if [ ! -f ../bases-work/$2/$2.mst ]
then
   call batch/InformaLog.bat $0 x Cria revista: ../bases-work/$2/$2
   call batch/CriaMaster.bat ../bases-work/$2/$2
   call batch/CriaInvertido.bat ../bases-work/$2/$2
fi
