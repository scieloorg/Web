ACRON=$1
ISSUEID=$2

. ./shs/readconfig.sh

if [ "@$ISSUEID" == "@" ]
then
    echo $1
else
    $MX cipar=$CIPFILE ISSUE btell=0 "SGL_N=$ACRON$ISSUEID" lw=999 "pft='S',v35,v65*0.4,s(f(val(v36*4.3)+10000,1,0))*1/" now
fi
