MXTB=$1
MX=$2
QLOG=$3
QDB=$4
REPORTFILENAME=$5

$MXTB $QLOG create=l "100:if size(v880^*)=23 then v691,'|art|',v100/ else if size(v880^*)=28 then v691,'|ref|',v100/ fi fi" class=100000
$MXTB $QDB create=q "100:(if size(v880^*)=23 then v880^c,'|art|ok'/ else if size(v880^*)=28 then v880^c,'|ref|ok'/ fi  fi),if p(v237) then 'doi'/ fi" class=1000000

$MX l lw=9999 "pft=v1,'|',v999/" now > $REPORTFILENAME.tmp
$MX q lw=9999 "pft=v1,'|',v999/" now >> $REPORTFILENAME.tmp

echo `date '+%Y%m%d %H:%M:%S'`       >> $REPORTFILENAME
cat $REPORTFILENAME.tmp | sort >> $REPORTFILENAME
echo ............................... >> $REPORTFILENAME
