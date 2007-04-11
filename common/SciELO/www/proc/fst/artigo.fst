1 0 mpl,'TP=',v706/
2 0 mpl,'IV=',v880,'=',v706/
3 0 mpl,if v706='h' and a(v222) then 'SM=',v35,v65*0.4,s(f(val(v936^o)+10000,2,0))*1.4,'-',s(f(val(v121)+1000,4,0))*1.3/, fi,
3 0 mpl,if v706='old' then 'SM=',v35,s(f(val(v31)+1000,4,0))*1.3,s(f(val(v131)+1000,4,0))*1.3,s(f(val(v32)+1000,4,0))*1.3,s(f(val(v132)+1000,4,0))*1.3,'=',s(f(val(v121)+1000,4,0))*1.3 fi,
4 0 mpl,'PII=',v880,'=',v700/
5 0 mpl,if v706='o' then 'OU=',v880 fi,
6 0 mpl,if v706='f' then 'SF=',v880/, fi,
6 0 mpl,if v706='h' then 'HR=',v880/,|HR=|v881/, fi,
7 0 mpl,if v706='p' then 'ART=',v880 fi,
8 0 mpl,if v706='h' then 'TT=',v35/ fi,
10 0 mpl,if v706='h' then ('AU=',v10^s|, |,v10^n/) fi,
11 0 mpl,if v706='c' then 'MDL=',v880,'=',v701/, fi,
12 0 mpl,if v706='h' then ('AU=',v11^*|, |,v11^d/) fi,
13 0 mpl,if v706='i' then 'Y',v35,v65*0.4,s(f(val(s(v36*4.3))+10000,2,0))*1.4/, fi,
14 0 mpl,if v706='p' and p(v704^l) then 'TLN=',v880,v704^l fi,
15 0 mpl,if v706='h' then 'DTH=',v65*0.4, if v65*4.2 = '00' then, '01', else v65*4.2, fi, '01=',v35,s(f(val(v936^o)+10000,1,0))*1.4,s(f(val(v121)+10000,1,0))*1.4 fi,
16 0 mpl,if v706='c' then 'R=',v880/, fi,
20 0 mpl,if v706='p' and p(v888) then 'RP=',v880 fi,
50 0 mpl,if v706='i' and v32='ahead' then 'AHEAD=',v35 fi