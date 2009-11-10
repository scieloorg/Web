/* posicao apos serial */
 proc('d7001a7001{',f(instr(s(mpu,v702,mpl),'\SERIAL\')+size('\serial\'),1,0),'{')

/* substr a partir de acron  */
   proc('d5000a5000{',mid(v702,val(v7001),size(v702)),'{')
/* posicao de / seguinte  */
   proc('d7002a7002{',f(instr(v5000,'\'),1,0),'{')

/* substr a partir de issueid  */
   proc('d5001a5001{',mid(v5000,val(v7002)+1,size(v702)),'{')
/* posicao de / seguinte  */
   proc('d7003a7003{',f(instr(v5001,'\'),1,0),'{')

/* substr a partir de pasta markup ou xml */
   proc('d5002a5002{',mid(v5001,val(v7003)+1,size(v702)),'{')
/* posicao de / seguinte */
   proc('d7004a7004{',f(instr(v5002,'\'),1,0),'{')

/* arquivo */
   proc('d5003a5003{',mid(v5002,val(v7004)+1,size(v702)),'{')

/* position of the dot before extension */
   proc('d7005a7005{',if mid(v5003,size(v5003)-4,1)='.' then f(size(v5003)-4,1,0) else f(size(v5003)-3,1,0) fi,'{')

 /* diretorio acron/issueid  */
 proc('d4001a4001{',replace(mid(v5000,1, val(v7002) + val(v7003) -1  ),'\','/'),'{')

 /* filename */
 proc('d4000a4000{',mid(v5003,1,val(v7005)-1),'{')
 
 /* extension */
 proc('d4002a4002{',mid(v5003,val(v7005)+1,4),'{')
