. crossref_config.sh

mv $XREF_DOI_REPORT.fst ../fst/temp.fst
rm $XREF_DOI_REPORT.*
cp ../fst/temp.fst $XREF_DOI_REPORT.fst

rm $DB_BILL.* $DB_BG.*
rm -rf ../output/crossref/
