if "@%3" == "@reset" %mx% null count=0 create=%1 now -all	
if not exist %1 %mx% null count=0 create=%1 now -all	
	
%mx% %1 "fst=@%2" fullinv=%1
