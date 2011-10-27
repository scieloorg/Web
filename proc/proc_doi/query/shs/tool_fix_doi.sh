../../cisis/mx ../../../bases-work/doi/query create=fixed_query now -all
../../cisis/mx ../../../bases-work/doi/query "tp=j and doi=10.1590$" "proc='d880',(if size(v880^*)=23 then if v237[1]:v880^* then 'a880{',v880,'{' fi else 'a880{',v880,'{' fi)" copy=fixed_query now -all
