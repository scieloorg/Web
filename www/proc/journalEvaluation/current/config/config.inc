
TEMPLATE=200910
PARAM_SELECT_BY_YEAR=2008
PARAM_SELECT_BY_RECENT=

MX=lindG4/mx
MXTB=lindG4/mxtb

FILE_CONFIG=journalEvaluation/current/config/config.inc
FILE_CIPAR=journalEvaluation/current/config/avaliacao.cip
FILE_LOG=log/je_permanencia.log

FILE_SELECTED_ISSUES=temp/je_selected_issues

TITLELIST=temp/je_permanencia_scilista.lst

PATH_OUTPUT=/home/scielo/www/htdocs/teste/journalEvaluation/current/data/$TEMPLATE

PATHL_LIST_MODULE=journalEvaluation/common/list
PATH_AFF_MODULE=journalEvaluation/common/aff

PATH_CURRENT_SHELLS=journalEvaluation/current/linux
PATH_CURRENT=journalEvaluation/current

PATH_TEMPLATE=journalEvaluation/current/template/$TEMPLATE
PATH_GZM=journalEvaluation/common/gizmo

PATH_COMMON_SHELLS=journalEvaluation/common/linux
PATH_COMMON=journalEvaluation/common
PATH_LANG_REPORTS=../bases-work/lang/report
PATH_DATE_DIFF=journalEvaluation/common/calculateDateDiff


DOCTOPIC=journalEvaluation/common/gizmo/doctopic.seq

REL_PATH_OUTPUT=/teste/journalEvaluation/current/data/$TEMPLATE
JournalFileName=journaldata.xls

HTML_FILE_OUTPUT=$PATH_OUTPUT/journals.htm
JOURNAL_EDBOARD_HTML_PATH=/home/scielo/www/htdocs/revistas/

#AFFLISTCOMPLETA=journalEvaluation/common/gizmo/affcompleta
DB_v70_completa=journalEvaluation/common/gizmo/v70_completa
DB_v70=journalEvaluation/common/gizmo/v70
SEQ_DB_v70=$DB_v70.seq

PATH_DOCTOPIC_SHELLS=journalEvaluation/common/linux
TITLE=../bases/title/title
TITLE_LANGS=temp/je_title_langs
GZM_ISSN=temp/je_gzm_issn
GZM_DOCTOPIC=temp/je_gzm_doctopic
GZM_OT=temp/je_gzm_ot
GZM_LANG=temp/je_gzm_lang
GZM_TAB2PIPE=temp/je_gzm_tab2pipe
GZM_PIPE2TAB=temp/je_gzm_pipe2tab

DB_DATES=temp/je_dates