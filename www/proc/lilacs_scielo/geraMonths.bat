
cisis\mx seq=lilacs_scielo\gizmo\month.seq "pft=v1,'|',v2/,v3,'|',v2/" now > month.txt
cisis\mx seq=month.txt create=lilacs_scielo\gizmo\month_2pt now -all

cisis\mx seq=lilacs_scielo\gizmo\month.seq "pft=v1,'|',v3/,v2,'|',v3/" now > month.txt
cisis\mx seq=month.txt create=lilacs_scielo\gizmo\month_2es now -all

cisis\mx seq=lilacs_scielo\gizmo\month.seq "pft=v2,'|',v1/,v3,'|',v1/" now > month.txt
cisis\mx seq=month.txt create=lilacs_scielo\gizmo\month_2en now -all

