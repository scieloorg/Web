./CrossRefQuery.bat -f teste.xml -u "${CROSSREF_USERNAME:-bireme}" -p "${CROSSREF_PASSWORD:?CROSSREF_PASSWORD not set}" -a live -r xml > r
grep -rs "<?xml"  r

if grep -q "<?xml" r
then
echo 1
else
echo 2
fi
