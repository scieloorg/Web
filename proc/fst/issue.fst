1 0 mpl,if v5='last' then 'last=',v35 fi/
2 0 mpl,'all=',v35,s(f(val(v31)+1000,4,0))*1.3,s(f(val(v131)+1000,4,0))*1.3,s(f(val(v32)+1000,4,0))*1.3,s(f(val(v132)+1000,4,0))*1.3,/,
3 0 mpl,'seq=',v35,'-',v6/,
4 0 mpl,if p(v41) then 'P' else if v32='ahead' or v32='review' then v32*0.1 else 'Y' fi,  fi,v35,v65*0.4,s(f(val(s(v36*4.3))+10000,2,0))*1.4/,
4 0 mpl,if a(v41) and (v32='ahead' or v32='review') then 'Y' fi,v35,v65*0.4,s(f(val(s(v36*4.3))+10000,2,0))*1.4/,
5 0 mpl,v91/	/* webservices - new_issues - SciELO.org */
6 0 mpl,'SGL_N=',v930,|v|v31,|s|v131,|n|v32,|s|v132/
7 0 mpl,'SGL=',v930/
