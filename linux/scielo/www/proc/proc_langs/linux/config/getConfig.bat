export my_mx=$1
$my_mx lw=9999 seq=proc_langs/text-langs.def "pft=if p(v1) or size(v1)>0 then 'export ',v1 fi,#" now > proc_langs/config.bat
