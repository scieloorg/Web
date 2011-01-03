1 0 mpl,|file=|v1/
880 0 mpl,|hr=|v880/
441 0 mpl,('SUBJ='v441/)
601 0 mpl,(if p(v601) then 'HAS_TRANSLATION='v601^l/ fi)
602 0 mpl,(if p(v601) then 'HAS_PDF='v602^l,if v602^l='' then v40[1] fi/ fi)
940 0 mpl,'LANG='v40/,('LANG='v601^l/),(|LANG=|v602^l/)
40 0 mpl,(|lang=|v2/)
702 0 mpl,if p(v702) then 'file_art=',replace(replace(replace(replace(replace(mid(v702,instr(s(mpu,v702,mpl),'\SERIAL\')+8,size(v702)),'.html',''),'.htm',''),'.xml',''),'\markup\','\'),'\','/'),# fi