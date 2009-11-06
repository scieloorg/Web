
TEMPLATE=200910
PARAM_SELECT_BY_YEAR=2008
PARAM_SELECT_BY_RECENT=

CPFILE=journalEvaluation/current/config/avaliacao.cip
FILE_CONFIG=journalEvaluation/current/config/config.inc
AVALLOG=log/avaliacao_permanencia.log
FILE_SELECTED_ISSUES=temp/journalEvaluation_selected_issues.txt
SCILISTA=temp/avaliacao_permanencia_scilista.lst

MX=lindG4/mx

PATH_TEMPLATE=journalEvaluation/current/template/$TEMPLATE
PATH_GZM=journalEvaluation/common/gizmo
PATH_SHELL=journalEvaluation/current/linux
PATH_COMMON=journalEvaluation/common
PATH_LANG_REPORTS=temp

DOCTOPIC=journalEvaluation/common/gizmo/doctopic.seq

OUTPUT_PATH=/home/scielo/www/htdocs/teste/journalEvaluation/current/data/$TEMPLATE
REL_OUTPUT_PATH=/teste/journalEvaluation/current/data/$TEMPLATE
JournalFileName=journaldata.txt

HTML_FILE_OUTPUT=$OUTPUT_PATH/journals.htm
JOURNAL_EDBOARD_HTML_PATH=/home/scielo/www/htdocs/revistas/

AFFLISTCOMPLETA=journalEvaluation/common/gizmo/affcompleta
AFFSEQ=temp/v70.seq

SEQFILEALLISSUESELECTED=temp/allissuesselected.txt

PATH_DOCTOPIC_SHELLS=journalEvaluation/common/linux
TITLE=../bases/title/title
TITLE_LANGS=temp/je_title_langs
GZM_ISSN=temp/je_gzm_issn
GZM_DOCTOPIC=temp/je_gzm_doctopic
GZM_OT=temp/je_gzm_ot
GZM_LANG=temp/je_gzm_lang
GZM_TAB=temp/je_gzm_tab

DB_DATES=$PATH_COMMON/tables/dates