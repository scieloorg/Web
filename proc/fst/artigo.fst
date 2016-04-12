1 0 mpl,'TP=',v706/
2 0 mpl,'IV=',v880,'=',v706/
3 0 mpl,if v706='h' and a(v222) then 'SM=',v880*1.17,'-',v880*18/, fi,
5 0 mpl,if v706='o' then 'OU=',v880 fi,
6 0 mpl,if v706='f' then 'SF=',v880/, fi,
6 0 mpl,if v706='h' then 'HR=',v880/,|HR=|v881/,|HR=|v891/, fi,
6 0 mpl,if v706='h' and v35='0102-7638' then replace(s('HR=',v880),'0102-7638','1678-9741')/, fi, 
6 0 mpl,if v706='h' and v35='1807-0302' then replace(s('HR=',v880),'1807-0302','0101-8205')/, fi, 
6 0 mpl,if v706='h' and v35='1806-1117' then replace(s('HR=',v880),'1806-1117','0102-4744')/, fi, 
6 0 mpl,if v706='h' and v35='1678-4510' then replace(s('HR=',v880),'1678-4510','0100-879X')/, fi, 
6 0 mpl,if v706='h' and p(v41) then 'PR_HR=',v880/ fi, /* indice do registro h pr */
6 0 mpl,if v706='h' and p(v241^t) then (if v241^t='pr' then 'AHPR=',v880/,'PR_LK='v241^i/ fi) fi, /* indice de artigo que tem pr e indice indica o id do pr */
7 0 mpl,if v706='p' then 'ART=',v880 fi,
8 0 mpl,if v706='h' then 'TT=',v35/ fi,
10 0 mpl,if v706='h' and v10>'' then ('AU=',v10^s|, |,v10^n/) fi,
11 0 mpl,if v706='c' then 'MDL=',v880,'=',v701/, fi,
12 0 mpl,if v706='h' and v11>'' then ('AU=',v11^*|, |,v11^d/) fi,
13 0 mpl,if v706='i' then if p(v41) then 'P' else if v32='ahead' or v32='review' then v32*0.1 else 'Y' fi,  fi,ref(mfn+1,v880*1.17)/, fi,
13 0 mpl,if v706='i' and a(v41) then if v32='ahead' or v32='review' then 'Y' fi,ref(mfn+1,v880*1.17)/, fi,
14 0 mpl,if v706='p' and p(v704^l) then 'TLN=',v880,v704^l fi,
15 0 mpl,if v706='h' then 'DTH=',v65*0.4, if v65*4.2 = '00' then, '01', else v65*4.2, fi, '01=',v880*1.9,v880*14 fi,
16 0 mpl,if v706='c' then 'R=',v880/, fi,
20 0 mpl,if v706='p' and p(v888) then 'RP=',v880 fi,
50 0 mpl,if v706='i' and v32='ahead' and a(v41) then 'AHEAD=',v35 fi
50 0 mpl,if v706='i' and v32='review' then 'REVIEW=',v35 fi
60 0 mpl,if v706='i' then 'IDT',v91/, fi 				/* webservices - new_issues - SciELO.org */
90 0 mpl,if v706='h' then 'OAITS=',ref(mfn-1,if p(v93) then if val(v93*0.8) > val(v91) then v93*0.8 else v91 fi else v91 fi),'=',v880*1 fi
241 0 mpl,if v706='h' then (v241^t,v241^i/) fi
770 0 mpl,if v706='h' and v770>'' then ('EC_',v770^*,v770^a/) fi
