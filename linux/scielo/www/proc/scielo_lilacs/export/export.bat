export debug=$1

cat scielo_lilacs/tools/config.bat >  temp/export.bat
cat scielo_lilacs/config/config.bat >> temp/export.bat
cat scielo_lilacs/export/export_aux.bat >> temp/export.bat

chmod 775 temp/export.bat
temp/export.bat