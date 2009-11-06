 proc('d4000a4000{',f(instr(s(mpu,v702,mpl),'\MARKUP\'),1,0),'{')
 proc('d4002a4002{',f(instr(s(mpu,v702,mpl),'\SERIAL\')+size('\SERIAL\'),1,0),'{')
 /* valor entre serial e markup ou seja acronimo e issueid  */
 proc('d4000d4002d4001a4001{',replace(mid(v702,val(v4002),val(v4000)-val(v4002)),'\','/'),'{')

  /* filename */
 proc('d4002a4002{',mid(v702,instr(s(mpu,v702,mpl),'\MARKUP\')+size('\markup\'),size(v702)),'{')
 proc('d4000a4000{',mid(v4002,1,instr(v4002,'.htm')-1),'{')
 proc('d4002a4002{',mid(v4002,instr(v4002,'.htm')+1,4),'{')
