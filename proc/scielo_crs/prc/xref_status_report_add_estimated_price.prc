
/*
#1 0 mpl,'PID='v1
#2 0 mpl,'PUBDATE='v2
#3 0 mpl,'DEPOSIT_DATE='v3
#4 0 mpl,'DEPOSIT_STATUS='v4
#6 0 mpl,'ERRTYPE='v6
#7 0 mpl,'BILL_DATE='v7
#8 0 mpl,'BILL_PRICE='v8
#9 0 mpl,'DISPLAY_DATE='v9
#10 0 mpl,'DISPLAY_DOI='v10
*/

,if a(v7) then 
    ,proc('d11',
		,if v4 = 'new' then
			,'a11{',v3,'{a13{deposit{',
		,else
			,if v4 = 'update' then
				,if v9 <> '' then
					,if val(v9) < val(v4) then
						,'a11{',v9,'{a13{display{',
					,else
						,'a11{',v3,'{a13{redeposit{',
					,fi
				,else
					,'a11{',v3,'{a13{redeposit{',
				,fi
			,else
				,if v9 <> '' then
					,'a11{',v9,'{a13{display{',
				,else
					,'a11{',s(date)*0.4,'{a13{estimative{'
				,fi
			,fi
		,fi    	
    	)
	,if p(v11) then
		,'a12{',if val(v11)-val(v2) > 2 then v8005 else v8006 fi,'{'
	,fi
,else
	,'a11{',v7,'{'
	,'a13{deposit{'
	,'a12{',v8,'{'

,fi
