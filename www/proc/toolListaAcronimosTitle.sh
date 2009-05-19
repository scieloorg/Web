# ------------------------------------------------------------------------- #
# ListaAcronimosTitle.sh - Listas os acronimos das revistas na TITLE
# ------------------------------------------------------------------------- #
#      Entrada: Base de dados title no diretorio bases-work
#               PARM1 indicador de status do titulo
#        Saida: Lista de acronimos no standard-out
#      Chamada: ListaTitulosColecao.sh
#     Corrente: diretorio 'proc' dentro da estrutura SciELO
# Dependencias: 
#  Observacoes: Se o status for c deseja listar soh corrente, senao todos
# ------------------------------------------------------------------------- #
#   DATA    Responsavel       Comentario
# 20060415  FJLopes/MBottura  Edicao original
# 20060512  FJLopes           Alteracao de nome da rotina (ListaTitulosColecao)
#                             Insercao de controles de monitoracao de processos
#

TPR="start"
#. log

CISIS_DIR=cisis

# Verifica se existe a base title
if [ ! -s "../bases-work/title/title.xrf" ]
then
  TPR="fatal"
  MSG="[SCLERR] TITLE not found"
  #. log
fi

# Efetua a listagem conforme parametro
TPR="iffatal"
MSG="Lista acronimos na title"
if [ "$1" = "c" -o "$1" = "C" ]
then
	$CISIS_DIR/mx ../bases-work/title/title "pft=if s(mpu,v50,mpl)='C' then v68/ fi" now |sort
	#. log
else
	$CISIS_DIR/mx ../bases-work/title/title "pft=v68/" now |sort
	#. log
fi

TPR="end"
#. log
