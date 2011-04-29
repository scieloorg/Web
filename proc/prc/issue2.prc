,'d5',
,'d6',

,if s(v35)<>ref(mfn+1,s(v35)) then
    ,'a5{last{',
,fi,


,if s(v35) = s( ref(mfn-1,v35) ) then
   ,'a6{',
   ,if val(ref(mfn-1,v6))+1 < 10 then
       ,'00',f(val(ref(mfn-1,v6))+1,1,0),
   ,else
       ,if val(ref(mfn-1,v6))+1 < 100 then
           ,'0',f(val(ref(mfn-1,v6))+1,2,0),
       ,else
           ,f(val(ref(mfn-1,v6))+1,3,0),
       ,fi,
   ,fi,
   ,'{',
,else,
   ,'a6{001{', 
,fi,
