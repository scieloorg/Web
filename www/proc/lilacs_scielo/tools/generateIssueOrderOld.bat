
set issues=..\bases-aux\lilacs-scielo\input\issues.mioc

cisis\mx %issues% fst=@lilacs_scielo\conversion\fst\issues.fst fullinv=%issues%
..\cgi-bin\wxis IsisScript=lilacs_scielo\tools\generateIssueOrder.xis issuesdb=%issues% 
cisis\mx %issues% fst=@lilacs_scielo\conversion\fst\issues.fst fullinv=%issues%
