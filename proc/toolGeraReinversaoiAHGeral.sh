#!/bin/bash
# ------------------------------------------------------------------------- #
# toolGeraReinversaoiAHGeral - Gera todos os indices de iAH
# ------------------------------------------------------------------------- #
#      Entrada : FST no subdiretorio fsts
#        Saida : Invertidos gerados no diretorio iAH de bases-work
#     Corrente : .../proc
# Dependencias : 
#  Observacoes : Cria o ambiente de operacao das rotinas padrao do pacote
#                SciELO para efetuar chamada a batch/GeraInvIAHProc.bat
#                ATENCAO: Nao reinverte sob o diretorio library
#                Como subproduto resulta acronimos.lst em temp
# ------------------------------------------------------------------------- #
#   DATA    Responsaveis      Comantarios
# 20060505  MBottura/FJLopes  Edicao Original
# 20071018  FJLopes           Revisao de formas
#

TPR="start"
#. log

echo "[TIME-STAMP] `date '+%Y.%m.%d %H:%M:%S'` [:INI:] $0 $1 $2 $3 $4 $5"

export PATH=$PATH:.
export INFORMALOG=log/GeraScielo.log
export CISIS_DIR=cisis

# Obtem lista de acronimos de revistas para inversao (na pratica)
ls ../bases-work/iah/*/search.cnt|cut -d "/" -f "4" | grep -v "library" |sort > temp/acronimos.lst

for i in `cat temp/acronimos.lst`
do
	echo "rm ../bases-work/iah/$i/*.[ciln]??"
	rm ../bases-work/iah/$i/*.[ciln]??
done

# Gera base de dados com o conteudo da lista obtida, acronimos no campo 1
TPR="iffatal"
MSG="Gera lista de revistas presentes"
$CISIS_DIR/mx seq=temp/acronimos.lst create=temp/colecoes -all now tell=1
#. log

# Chama rotina de geracao de invertidos do iAH
# call batch/GeraInvIAHProc.bat .. temp/colecoes
call batch/GeraInvIAH.bat .. temp/colecoes

# Limpa areas de trabalho
rm temp/colecoes.*

echo "[TIME-STAMP] `date '+%Y.%m.%d %H:%M:%S'` [:FIM:] $0 $1 $2 $3 $4 $5"

TPR="end"
#. log
