,if p(v38) then
    ,'d38',
    ,if s(mpu,v38,mpl)='ILUS' then
        ,'a38|ilus|'
    ,fi,
    ,if s(mpu,v38,mpl)='MAP' then
        ,'a38|mapas|'
    ,fi,
    ,if s(mpu,v38,mpl)='TAB' then
        ,'a38|tab|'
    ,fi,
    ,if s(mpu,v38,mpl)='GRAF' then
        ,'a38|graf|'
    ,fi,
    ,if s(mpu,v38,mpl)='FIG' then
        ,'a38|ilus|'
    ,fi,
,fi,
,if p(v123) then 
    ,if a(v12) then
	,'a12|Sem dados|',/
    ,fi,
    ,if a(v32) then
	,'a32|Sem dados|',/
    ,fi,
    ,if a(v14) then
	,'a14|Sem dados|',/
    ,fi,
    ,if a(v13) then
	,'a13|Sem dados|',/
    ,fi,
    ,if a(v30) then
	,'a30|Sem dados|',/
    ,fi,
    ,if a(v10) and a(v11) then
	,'a10|sem dados|',/
    ,fi,
    ,if a(v64) then
	,'a64|^as.d|',/
    ,fi,
,fi,