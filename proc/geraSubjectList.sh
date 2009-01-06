# ------------------------------------------------------------------------- #
# geraSubjectList.sh - Gera Indice de titulos por areas de interesse
# ------------------------------------------------------------------------- #
#    corrente : ../proc
#     entrada : nenhum parametro
#               base newcode em ../serial
#               base title em ../bases-work/title
#       saida : Indices gerados em ../bases-work/
#                 serareaEN - Indice em ingles
#                 serareaES - Indice em espanhol
#                 serareaPT - Indice em portugues
#     chamada : geraSubjectList.sh
#     exemplo : geraSubjectList.sh
#  observacao : 
# comentarios : 
# ------------------------------------------------------------------------- #
#   Data    Resp              Comment
# 20060609  AOT/RM            Edicao original
# 20060612  FJLopes           Adapatacao para processamento em linha
#

echo "==> INI geraSubjectList.sh"
COMECO=`date +%s`

CISIS_DIR=cisis

$CISIS_DIR/mx ../serial/code/newcode btell=0 "EN-Study area" "pft=(v2/)" lw=999 now >temp/xstudyareas
$CISIS_DIR/mx seq=temp/xstudyareas -all now create=temp/ENstudyareas
$CISIS_DIR/mx temp/ENstudyareas "fst=1 0 v1^c" fullinv/ansi=temp/ENstudyareas

$CISIS_DIR/mx ../serial/code/newcode btell=0 "ES-Study area" "pft=(v2/)" lw=999 now >temp/xstudyareas
$CISIS_DIR/mx seq=temp/xstudyareas -all now create=temp/ESstudyareas
$CISIS_DIR/mx temp/ESstudyareas "fst=1 0 v1^c" fullinv/ansi=temp/ESstudyareas

$CISIS_DIR/mx ../serial/code/newcode btell=0 "PT-Study area" "pft=(v2/)" lw=999 now >temp/xstudyareas
$CISIS_DIR/mx seq=temp/xstudyareas -all now create=temp/PTstudyareas
$CISIS_DIR/mx temp/PTstudyareas "fst=1 0 v1^c" fullinv/ansi=temp/PTstudyareas

# Limpa area de trabalho
rm temp/xstudyareas

# Gera invertido por idioma
$CISIS_DIR/mx ../bases-work/title/title "proc='a3000|EN|'"  fst=@fst/serarea3000.fst  fullinv/ansi=../bases-work/title/serareaEN
$CISIS_DIR/mx ../bases-work/title/title "proc='a3000|ES|'"  fst=@fst/serarea3000.fst  fullinv/ansi=../bases-work/title/serareaES
$CISIS_DIR/mx ../bases-work/title/title "proc='a3000|PT|'"  fst=@fst/serarea3000.fst  fullinv/ansi=../bases-work/title/serareaPT

rm temp/ENstudyareas.*
rm temp/ESstudyareas.*
rm temp/PTstudyareas.*

echo "==> FIM geraSubjectList.sh"
TERMINO=`date +%s`
echo Tempo de execucao de geraSubjectList.sh: `expr $TERMINO - $COMECO`
