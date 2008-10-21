#!/bin/bash

. conf.sh

if [ ! -f /home/scielo/www/bases-devel/projfapesp/projfapesp.mst ] ; then
        $cisis_dir/mx seq=/dev/null create=$fapesp_db/projfapesp
	cp ../formats/projfapesp.fst $fapesp_db/projfapesp.fst
       #$cisis_dir/mx $fapesp_db/projfapesp fst=@$fapesp_db/projfapesp.fst fullinv=$fapesp_db/projfapesp -all now
fi

######################################################################
#Remove possiveis arquivos temporarios
######################################################################
rm -rf projfapesp_temp.sh
rm -rf projfapespdb_temp.seq

######################################################################
#Gera Base Temporaria
######################################################################
$cisis_dir/mx iso=$iso_filename "pft=lw(0),(mid(v8[1],instr(v8[1],'S'),23),'|',v900/)" now >> projfapespdb_temp.seq
$cisis_dir/mx seq=projfapespdb_temp.seq create=$fapesp_db/projfapesp_temp -all now
$cisis_dir/mx $fapesp_db/projfapesp_temp "fst=11 0 v1,v2^*/" fullinv=$fapesp_db/projfapesp_temp 

######################################################################
#Gera Base de Projetos
######################################################################
$cisis_dir/mx null create=$fapesp_db/projfapesp count=0 now
$cisis_dir/mx iso=$iso_filename create=$filename now -all
$cisis_dir/mx $filename lw=999999 "pft='./appendpft_aux.sh $cisis_dir/mx $filename ',mfn,' ',mid(v8,instr(v8,'S'),23),' $fapesp_db/projfapesp $fapesp_db/projfapesp_temp'/" now >> projfapesp_temp.sh

######################################################################
#Executa o script que efetua o append na base
######################################################################
chmod +x projfapesp_temp.sh
./projfapesp_temp.sh

$cisis_dir/mx $fapesp_db/projfapesp fst=@$fapesp_db/projfapesp.fst fullinv=$fapesp_db/projfapesp -all now

######################################################################
#Remove arquivos temporarios
######################################################################
rm -rf projfapesp_temp.sh
rm -rf projfapespdb_temp.seq
rm -rf ../iso/*mst
rm -rf ../iso/*xrf