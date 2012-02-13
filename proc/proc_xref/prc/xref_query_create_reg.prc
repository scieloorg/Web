,'d*', 
,if a(v41) then


,proc('d9005a9005{',

,if size(v9000)>0 then
	,if l([v9000]'pid=',v880^*)>0  then
		,'1',
	,fi,
	,if p(v881) then
		,if l([v9000]'pid=',v881)>0  then
			,'1',
		,fi,	
	,fi
	,if p(v891) then
		,if l([v9000]'pid=',v891)>0  then
			,'1',
		,fi,	
	,fi
,fi,'{'),

,if instr(v9005,'1')=0 then
	'a880{',v880^*,'{',|a881{|v881|{|,|a891{|v891|{|,|a237{|v237|{|,
	,if a(v237) then
		,if size(v9001)>0 then
			,ref([v9001]l([v9001]'pid='v880^*),|a237{|v237|{|),
			,if p(v881) then ref([v9001]l([v9001]'pid='v881),|a237{|v237|{|), fi
			,if p(v891) then ref([v9001]l([v9001]'pid='v891),|a237{|v237|{|), fi
		,fi
		,if size(v9002)>0 then
			,ref([v9002]l([v9002]'PID='v880^*),|a237{|v237|{|),
			,if p(v881) then ref([v9002]l([v9002]'pid='v881),|a237{|v237|{|), fi
			,if p(v891) then ref([v9002]l([v9002]'pid='v891),|a237{|v237|{|), fi
		,fi
	,fi
	,'a300{new{',
	,|a9003{|v9003|{|,|a9004{|v9004|{|,
	,|a691{|v880^c|{|,
,fi

,fi