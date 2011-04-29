,if v9014=v9015 then
	,if p(v14) then
		,if p(v14^f) then
			,proc('a9014{',v14^f,'{'),
		,else
			,if instr(v14,'-')>0 then 
				,if size(replace(v14,'-',''))=size(v14)-1 then
					,proc('a9014{',mid(v14,1,instr(v14,'-')-1),'{'),
				,else
					,if size(replace(v14,'-',''))=size(v14)-3 then
						,proc('a9015{',mid(v14,instr(v14,'-')+1,size(v14)),'{'),
						,proc('a9014{',mid(v14,1,instr(v14,'-')),mid(v9015,1,instr(v9015,'-')-1),'{'),
					,else
						,proc('a9014{?{'),
					,fi
				,fi
			,else
				,proc('a9014{',v14,'{'),
			,fi
		,fi

	,fi
	,if a(v9014) or v9014='?' then
		proc('d8814a8814{888888888{'),	
	,else
		/* numerico */
		,proc('d8814a8814{',s(f(val(v9014)+1100000000,9,0))*1,'{'),
	,fi
,else

	,proc('d8814a8814{',s(f(val(v9014)+1000000000,9,0))*1,'{'),	
,fi
