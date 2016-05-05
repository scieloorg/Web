#
# Editar db_presupuestos.txt
# Editar crossref_config.sh

# Parameter 1 BUDGETID
# Parameter 2 ORDER Descending for more recent to older or Ascending for older to more recent
# Parameter 3 SELECTIONTYPE must be ALL or ONLY_NEVER_PROCESSED or ONLY_NEVER_SUBMITTED
# Parameter 4 COUNT Quantidade de artigos
./xref_run_budget.sh 1 Descending ONLY_NEVER_PROCESSED 10

