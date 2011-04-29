./CrossRefQuery.bat -f teste.xml -u bireme -p p@s5w0Rd -a live -r xml > r
grep -rs "<?xml"  r

if grep -q "<?xml" r
then
echo 1
else
echo 2
fi
