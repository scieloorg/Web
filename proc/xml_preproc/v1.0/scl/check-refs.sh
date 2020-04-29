#!/bin/bash
#produz lista de PIDs

# Para executar:
# nohup ./check-refs.sh > check-refs.log &

mx ../bases/artigo/artigo btell=0 tp=h "pft=v880/" -all now lw=0 tell=10000 > pids-br.txt

if [ -f "pids-refs.txt" ] then 	rm pids-refs.txt fi

for pid in $(cat pids-br.txt)
do
echo $pid

    art=$(mx ../bases/artigo/artigo btell=0 HR=$pid "pft=v880'|'v65*0.4'|'v71'|'v12^*[1]*0.30'...'" -all now lw=0)
    ref=$(mx ../bases/artigo/artigo btell=0 "R=$pid$" "pft=v1002/" +hits count=1 -all now lw=0)

echo $art\|$ref >> pids-refs.txt

done
