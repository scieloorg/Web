#!/bin/bash
# ------------------------------------------------------------------------- #
# InvGeralRevistas.sh - Gera bath que faz a reinversao de toda a colecao
# ------------------------------------------------------------------------- #
#      Entrada: -
#        Saida: Bases de dados de revistas em bases-work regeradas
#      Chamada: GeraReinversaoGeral.sh
#     Corrente: diretorio 'proc' dentro da estrutura SciELO
# Dependencias: 
#  Observacoes: Soh atua sobre os titulos correntes
#               Nao atua no indice serarea, gerado durante o processamento
# ------------------------------------------------------------------------- #
#   DATA    Responsavel       Comentario
# 20060415  FJLopes/MBottura  Edicao original
# 20060512  FJLopes           Alteracao do nome da rotina
#                             Inclusao de controles de monitoramento de processos
# 20071018  FJLopes           Inclusao de inversao de logo, title, issue e newissue
#

TPR="start"
#. log

echo "[TIME-STAMP] `date '+%Y.%m.%d %H:%M:%S'` [:INI:] Reinversao geral"

CISIS_DIR=cisis

# Levanta a lista de revistas a processar
TPR="iffatal"
MSG="Lista acronimos na Title"
./toolListaAcronimosTitle.sh c > lista/colecao.grl
#. log

# Constroi o shell-script que vai efetivamente efetuar o trabalho
touch temp/reasm-scielo.sh
rm temp/reasm-scielo.sh

# Sequencia de tratamento titulo a titulo da colecao
$CISIS_DIR/mx seq=lista/colecao.grl lw=99999 "pft='rm -f ../bases-work/',v1,'/',v1,'.[ciln]*',/,'./toolReparaPIDcitacao.sh ',v1,/" now >> temp/reasm-scielo.sh

# Sequencia para reinversao de issue
if [ -f ../bases-work/issue/issue.mst ]
then
 echo "rm ../bases-work/issue/*.[ciln]??"                                                                                    >> temp/reasm-scielo.sh
 echo "$CISIS_DIR/mx ../bases-work/issue/issue tell=5000 \"fst=@fst/issue.fst\"    \"fullinv=../bases-work/issue/issue\""    >> temp/reasm-scielo.sh
 echo "$CISIS_DIR/mx ../bases-work/issue/issue tell=5000 \"fst=@fst/facic.fst\"    \"fullinv=../bases-work/issue/facic\""    >> temp/reasm-scielo.sh
 echo "$CISIS_DIR/mx ../bases-work/issue/issue tell=5000 \"fst=@fst/faccount.fst\" \"fullinv=../bases-work/issue/faccount\"" >> temp/reasm-scielo.sh
fi

# Sequencia para reinversao de newissue
if [ -f ../bases-work/newissue/newissue.mst ]
then
 echo "rm ../bases-work/newissue/*.[ciln]??"                                                                                          >> temp/reasm-scielo.sh
 echo "$CISIS_DIR/mx ../bases-work/newissue/newissue tell=1000 \"fst=@fst/newissue.fst\" \"fullinv=../bases-work/newissue/newissue\"" >> temp/reasm-scielo.sh
fi

# Sequencia para reinversao de title
if [ -f ../bases-work/title/title.mst ]
then
 echo "rm ../bases-work/title/*.[ciln]??"                                                                                 >> temp/reasm-scielo.sh
 echo "$CISIS_DIR/mx ../bases-work/title/logo  tell=100 \"fst=@fst/logo.fst\"    \"fullinv=../bases-work/title/logo\""    >> temp/reasm-scielo.sh
 echo "$CISIS_DIR/mx ../bases-work/title/title tell=100 \"fst=@fst/title.fst\"   \"fullinv=../bases-work/title/title\""   >> temp/reasm-scielo.sh
 echo "$CISIS_DIR/mx ../bases-work/title/title tell=100 \"fst=@fst/titsrc.fst\"  \"fullinv=../bases-work/title/titsrc\""  >> temp/reasm-scielo.sh
 echo "$CISIS_DIR/mx ../bases-work/title/title tell=100 \"fst=@fst/titsrcp.fst\" \"fullinv=../bases-work/title/titsrcp\"" >> temp/reasm-scielo.sh
#echo "$CISIS_DIR/mx ../bases-work/title/title tell=100 \"fst=@fst/serarea.fst\" \"fullinv=../bases-work/title/serarea\"" >> temp/reasm-scielo.sh
fi

# Da status de executavel ao shell construido
echo "Permite execucao ao shell gerado"
chmod +x temp/reasm-scielo.sh

## exit 0
# Executa o shell de reconstrucao das bases das revistas do SciELO
echo "Executa o trabalho sujo chamando o shell. Aguarde..."
temp/reasm-scielo.sh
echo "Reconstrucao executada"

echo "[TIME-STAMP] `date '+%Y.%m.%d %H:%M:%S'` [:FIM:] Reinversao geral"

TPR="end"
#. log
