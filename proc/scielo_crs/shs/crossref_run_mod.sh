./crossref_run.sh

echo ""
echo "[TIME-STAMP] `date '+%Y.%m.%d %H:%M:%S'` [:INI:] Copia da base de controle de registros de XRef para SciELO3"
echo "scp ../databases/crossref/* scielo3:/home/scielo/www/bases/doi"
scp ../databases/crossref/* scielo3:/home/scielo/www/bases/doi
scp ../databases/crossref/* scielo3:/home/scielo/www/proc/scielo_crs/databases/crossref
echo "[TIME-STAMP] `date '+%Y.%m.%d %H:%M:%S'` [:FIM:] Copia da base de controle de registros de XRef para SciELO3"
echo ""
echo ""
