

'd*',

,proc('d9000a9000{',

,if p(v9999) then
	,if l([v9999]'hr='v880)=0 then
		,'doit',
	,fi
,else
		,'doit',
,fi
,'{'),
,if v9000='doit' then
	,'a91{',date,'{',
	,'a880{',v880,'{',
	,'a31{',v31,'{',
	,'a32{',v32,'{',
	,|a131{|v131|{|,
	,|a132{|v132|{|,
	,'a40{',v40,'{',
	,(|a83{|v83^l|{|),
	,'a702{',v702,'{',
	,'a700{',replace(replace(replace(replace(replace(mid(v702,instr(v702,'\serial\')+8,size(v702)),'.html',''),'.htm',''),'.xml',''),'\markup\','\'),'\','/'),'{',
,fi



