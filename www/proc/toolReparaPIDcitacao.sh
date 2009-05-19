# ------------------------------------------------------------------------- #
# ReparaPIDcitacao.sh - Corrige ma formacao de PID dos registros R
# ------------------------------------------------------------------------- #
#      Entrada: PARM1 com o acronimo da revista a tratar
#               Base de dados de revista no diretorio bases-work
#        Saida: Base de dados de revista no diretorio bases-work reparada
#      Chamada: ReparaPIDcitacao.sh <acronimo_da_revista>
#     Corrente: diretorio 'proc' dentro da estrutura SciELO
# Dependencias: Existencia de ReparaPIDcitacao.prc no diretorio prc
#  Observacoes: 
# ------------------------------------------------------------------------- #
#   DATA    Responsavel       Comentario
# 20060317  FJLopes/MBottura  Edicao original
#
echo "Inicio de reparos nos PIDs de citacao do SciELO.BR - Revista $1"

# Verifica se existe a base da revista a ser reparada
if [ ! -s "../bases-work/${1}/${1}.xrf" ]
then
  echo "fatal - Base de dados nao localizada $1"
  exit 1
fi

# Garante inexistencia do arquivo rascunho
echo "Garante area de trabalho!"
if [ -f "../bases-work/$1/CHwork.xrf" ]
then
  rm ../bases-work/$1/CHwork.*
fi

# Efetua uma copia de emergencia da base da revista
echo "Manda copia de reserva da base de dados da revista $1"
cp -p ../bases-work/$1/$1.xrf temp/${1}.xrf
cp -p ../bases-work/$1/$1.xrf ../bases-work/$1/${1}.res.xrf
if [ "$?" -ne 0 ]
then
  exit 1
fi
cp -p ../bases-work/$1/$1.mst temp/${1}.mst
cp -p ../bases-work/$1/$1.mst ../bases-work/$1/${1}.res.mst
if [ "$?" -ne 0 ]
then
  exit 1
fi

# Repara (se necessario) o PID dos registros de citacao colocando resultado em uma nova base (limpa)
echo "Remonta a base reparando numa area de rascunho"
echo "mstxl=4">gigabase.cip
cisis/mx cipar=gigabase.cip ../bases-work/$1/$1 "proc=@prc/ReparaPIDcitacao.prc" "proc='s'" append=../bases-work/$1/CHwork -all now tell=10000
if [ "$?" -ne 0 ]
then
  echo "fatal - Retomando a copia reserva de $1"
  mv ../bases-work/$1/${1}.res.xrf ../bases-work/$1/$1.xrf
  mv ../bases-work/$1/${1}.res.mst ../bases-work/$1/$1.mst
  exit 1
fi

# Passa a base limpa e corrigida para uso oficial na revista
echo "Remontou a base com sucesso, passa a nova base para producao"
mv ../bases-work/$1/CHwork.xrf ../bases-work/$1/$1.xrf
mv ../bases-work/$1/CHwork.mst ../bases-work/$1/$1.mst

# Gera invertido de localizacao de fasciculos da revista
echo "Regera o invertido da base da revista $1"
cisis/mx ../bases-work/$1/$1 fst=@fst/Fasciculo.fst fullinv=../bases-work/$1/$1 tell=10000
if [ "$?" -ne 0 ]
then
  echo "fatal - Invertendo a base da revista $1"
  exit 1
fi

echo "Limpa a area de trabalho $1"
rm ../bases-work/$1/$1.res.xrf
rm ../bases-work/$1/$1.res.mst
rm temp/$1.xrf
rm temp/$1.mst
rm gigabase.cip

echo "Termino de reparos nos PIDs de citacao do SciELO.BR - Revista $1"
