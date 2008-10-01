@echo off
rem FIXME
export DB_CONTROL=../bases-work/lang/control
export PROC_DIR=/home/scielo/www/proc/

export LANG_DATABASE_PATH_SO=`grep "LANG_DATABASE_PATH=" proc_langs/text-langs.def | cut -d "=" -f "2"`
export LANG_DATABASE_PATH=`echo $LANG_DATABASE_PATH_SO | tr "/" "-"`


echo export LANG_DATABASE_PATH_SO=$LANG_DATABASE_PATH_SO >proc_langs/temp_GeraIfmerge.bat
echo export LANG_DATABASE_PATH=$LANG_DATABASE_PATH >>proc_langs/temp_GeraIfmerge.bat

echo cd $LANG_DATABASE_PATH_SO >> proc_langs/temp_GeraIfmerge.bat
cisis/mx $DB_CONTROL lw=9999 count=1 "pft=if mfn=1 then '/bases/scl.000/proc/cisis/ifmerge lang/lang ' fi" now >> proc_langs/temp_GeraIfmerge.bat

cisis/mx $DB_CONTROL "bool=path=$" now
cisis/mx $DB_CONTROL btell=0 "bool=path=$LANG_DATABASE_PATH" lw=9999 "pft=v1,' '" now >> proc_langs/temp_GeraIfmerge.bat
echo  +mstxrf >>proc_langs/temp_GeraIfmerge.bat

echo Execute the lines between begin and end
echo begin
more proc_langs/temp_GeraIfmerge.bat
echo end
call proc_langs/temp_GeraIfmerge.bat

