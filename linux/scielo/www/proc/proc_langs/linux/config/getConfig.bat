export my_mx=$1
$my_mx seq=proc_langs/text-langs.def lw=9999 "pft=if p(v1) or size(v1)>0 then 'export ',v1 fi,#" now > proc_langs/config.bat
