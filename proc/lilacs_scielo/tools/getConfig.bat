set my_mx=%1
%my_mx% seq=%2 lw=9999 "pft=if p(v1) or size(v1)>0 then 'set ',replace(v1,'/','\') fi,#" now > %3

call %3
