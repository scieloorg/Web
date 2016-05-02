/*
depositor_prefix: v8000
$XREF_DOI_REPORT: v8001
$DB_BILL: v8002
$MYTEMP/alldoi: v8003
*/
'a9880{',if p(v237) and v237:v8000 then v880 else v880 fi,'{',
'a9030{',ref([v8001]l([v8001]'HR='v880),v10*0.8,'|',v30),
        ,ref([v8001]l([v8001]'HR='v881),v10*0.8,'|',v30),'{',
'a9002{',ref([v8002]l([v8002]v880),v3*0.4,'|',v2),
         ref([v8002]l([v8002]v881),v3*0.4,'|',v2),'{',
'a9237{',ref([v8003]l([v8003]'PID=',v880),v91*0.8,'|',v1),
         ref([v8003]l([v8003]'PID=',v881),v91*0.8,'|',v1),'{',
