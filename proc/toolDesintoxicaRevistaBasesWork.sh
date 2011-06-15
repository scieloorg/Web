#!/bin/sh
# ------------------------------------------------------------------------- # 
# toolDesintoxicaRevistaBasesWork.sh - Regera Master e Invertido
# ------------------------------------------------------------------------- #
#      Entrada: Acronimo da revista a ser operada
#        Saida: Base da revista "compactada" e reinvertida
#     Corrente: /bases/sss.nnn/proc
#      Chamada: ./toolDesintoxicaRevistaBasesWork.sh <REVISTA>
# Dependencias: fst/Fasciculo.fst
#  Comentarios: O processo prove a delecao dos diretorios dos issues da
#                  revista, seguido da regeracao integral da base e por
#                  fim a reinversao da base
#  Observacoes: A estrutura de diretorios esperada eh:
#                       /bases/sss.nnn
#                               |
#                               +--- proc
#                               |      |
#                               |      +--- batch
#                               |      +--- cisis
#                               |      +--- avaliacao
#                               |      +--- fst
#                               |      +--- gizmo
#                               |      +--- lista
#                               |      +--- log
#                               |      +--- newproc
#                               |      +--- pft
#                               |      +--- prc
#                               |      +--- outs
#                               |      +--- scielo_gsc
#                               |      +--- tab
#                               |      +--- temp
#                               |      +--- transf
#                               .      .    .
#                               .      .    .
#                               .      .    .
#                               |      +--- xsl
#                               +--- bases-work
#                               |      |
#                               |      +--- artigo
#                               |      +--- doi
#                               |      +--- iah
#                               |      +--- issue
#                               |      +--- newissue
#                               |      +--- title
#                               |      +--- REVISTA1
#                               |      +--- REVISTA2
#                               |      +--- REVISTA3
#                               .      .    .
#                               .      .    .
#                               .      .    .
#                               |      +--- REVISTAn
#                               +--- bases
#                               |      |
#                               |      +--- Acid1
#                               |      +--- Afil1
#                               |      +--- afiliacao
#                               |      +--- Aorg1
#                               |      +--- aotpxa1
#                               |      +--- artigo
#                               |      +--- doi
#                               |      +--- iah
#                               |      +--- issue
#                               |      +--- lattes
#                               |      +--- medline
#                               |      +--- newissue
#                               |      +--- stop
#                               |      +--- title
#                               |      +--- tab
#                               +--- serial
#                               |      |
#                               |      +--- code
#                               |      +--- issue
#                               |      +--- title
#                               +--- scibiblio
#                               |      |
#                               |      +---
#                               +--- avaliacao
#                                      |
#                                      +---
#        Notas: 
# ------------------------------------------------------------------------- #
#   DATA    Responsaveis      Comentarios
# 20070308  MBottura/FJLopes  Edicao original
#

# ------------------------------------------------------------------------- #
#                                  Funcoes                                  #
# ------------------------------------------------------------------------- #
# NOMEFUNCAO - Finalidade da funcao
# Param #1 - ...
# Param #2 - ...

# ------------------------------------------------------------------------- #

TPR="start"
#. log

# Ajustes de ambiente operativo

HINIC=`date '+%s'`
HRINI=`date '+%Y.%m.%d %H:%M:%S'`
echo "Em `date '+%Y.%m.%d %H:%M:%S'` iniciando  $0 $1 $2 $3 $4 $5"

echo "mxtl=4"       > SCI.cip
export CIPAR=SCI.cip

# ------------------------------------------------------------------------- #
# Eliminacao de diretorios de issues

ls -d ../bases-work/${1}/v[0-9]* | xargs rm -rf

# ------------------------------------------------------------------------- #
# Copia de seguranca das bases e invertidos

if [ -d "temp/${1}" ]
then
  rm -rf temp/${1}
fi
mkdir temp/${1}
cp ../bases-work/${1}/${1}.* temp/${1}

rm ../bases-work/${1}/${1}.l*
rm ../bases-work/${1}/${1}.i*
rm ../bases-work/${1}/${1}.n*
rm ../bases-work/${1}/${1}.cnt

# ------------------------------------------------------------------------- #
# Efetua copia limpa da base com inversao simultanea

cisis/mxcp ../bases-work/${1}/${1} create=temp/work$$ clean log=temp/${1}.log tell=10000
# TRAP para execucao defectiva
if [ $? -ne 0 ]
then
  # Efetua RESTORE da copia de seguranca
  cp temp/${1}/* ../bases-work/${1}/
  exit 1
fi

cisis/mx temp/work$$ "proc='s'" create=../bases-work/${1}/${1} "fst=@fst/Fasciculo.fst" "fullinv=../bases-work/${1}/${1}" tell=10000
if [ $? -ne 0 ]
then
  # Efetua RESTORE da copia de seguranca
  cp temp/${1}/* ../bases-work/${1}/
  exit 1
fi

# ------------------------------------------------------------------------- #
# Limpa areas de trabalho

rm -rf temp/${1}
rm temp/work$$.*

#mv ../bases-work/bwho/bwho.mst ../bases-work/bwho/work.mst
#mv ../bases-work/bwho/bwho.xrf ../bases-work/bwho/work.xrf
#cisis/mx ../bases-work/bwho/work "proc='s'" create=../bases-work/bwho/bwho -all now tell=10000
#cisis/mx ../bases-work/bwho/bwho fst=@fst/Fasciculo.fst fullinv=../bases-work/bwho/bwho tell=10000

# ------------------------------------------------------------------------- #
# Contabiliza tempo de processamento e gera relato da ultima execucao
echo ""
echo "Em `date '+%Y.%m.%d %H:%M:%S'` terminando $0 $1 $2 $3 $4 $5"
HRFIM=`date '+%Y.%m.%d %H:%M:%S'`
HFINI=`date '+%s'`
TPROC=`expr $HFINI - $HINIC`
echo "Tempo decorrido: $TPROC"

# Determina onde escrever o tempo de execucao (nivel 2 em diante neste caso - $LGRAIZ/$LGPRD)
#  Obs: cada repeticao de /[^/]* nos coloca mais um nivel abaixo na arvore
LGDTC=`pwd`
# Determina o primeiro diretorio da arvore do diretorio corrente
LGRAIZ=/`echo "$LGDTC" | cut -d/ -f2`
# Determina o nome do diretorio de segundo nivel da arvore do diretorio corrente
LGPRD=`expr "$LGDTC" : '/[^/]*/\([^/]*\)'`
# Determina o nome do diretorio de terceiro nivel da arvore do diretorio corrente
LGBAS=`expr "$LGDTC" : '/[^/]*/[^/]*/\([^/]*\)'`
# Determina o nome do Shell chamado (sem o eventual path)
LGPRC=`expr "/$0" : '.*/\(.*\)'`

#echo "Tempo de execucao de $0 em $HRINI: $TPROC [s]">>$LGRAIZ/$LGPRD/$LGPRC.tim

echo "Tempo transcorrido: $TPROC [s]"

echo " <INICIO_PROC SINCE=\"19700101 000000\" UNIT=\"SEC\">${HINIC}</INICIO_PROC>" >outs/duracao_${1}_.txt
echo " <FIM_PROC SINCE=\"19700101 000000\" UNIT=\"SEC\">${HFINI}</FIM_PROC>" >>     outs/duracao_${1}_.txt
echo " <DURACAO_PROC UNIT=\"SEC\">${TPROC}</DURACAO_PROC>" >>                       outs/duracao_${1}_.txt

unset HINIC
unset HFINI
unset TPROC

TPR="end"
#. log
