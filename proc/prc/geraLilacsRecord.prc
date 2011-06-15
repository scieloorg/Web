,if v706='l' then
	,'d8',
	,if ref(['TITLE']l(['TITLE']'LOC='v35),mid(v691,3,1))='1' then
		,'a8{',replace(v8,'scielo.br','scielosp.org'),'{',
	,else
		,'a8{',v8,'{',
	,fi
	,'a778{^sS',v35,v65*0.4,s(f(10000+val(ref(1,v36*4.3)),2,0))*1.4,s(f(100000+val(v121),2,0))*1.5,'{',
,else 
	,'d*d.',
,fi,
