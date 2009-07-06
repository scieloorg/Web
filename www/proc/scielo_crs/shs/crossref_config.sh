# ------------------------------------------------------------------------- #
# variaveis com caminho para bases de dados utilizadas no processmento.
# ------------------------------------------------------------------------- #
export scielo_dir="/home/scielo/www"
export scielo_proc="/home/scielo/www/proc"
export database_dir="$scielo_dir/bases"
export conversor_dir="$scielo_dir/proc/scielo_crs"
export cisis_dir="$scielo_dir/proc/lindG4" 

#JAVA RUNTIME ENVIRONMENT VARS
export JAVA_HOME=/home/scielo/www/proc/transform/java1_5_0/jre1.5.0_06

#variaveis com dados de conexao ao crossref
crossrefUserName=xxx
crossrefPassword=xxx
depositor_institution=BIREME/PAHO/WHO
depositor_prefix=10.1590
depositor_email=bireme.crossref@gmail.com
depositor_url=www.scielo.br

# 
MYCIPFILE=$conversor_dir/shs/xref.cip
MYTEMP=$scielo_proc/temp

#BASES DE DADOS
XREF_DOI_REPORT=$conversor_dir/databases/crossref/crossref_DOIReport
XREF_DB_PATH=$conversor_dir/databases/crossref
DB_BILL=$XREF_DB_PATH/bill
DB_BG=$XREF_DB_PATH/budget

# BUDGET
# taxa para artigos recentes
RECENT_FEE=1.2
# primeiro ano considerado de artigos recentes
# All Current records (2007-2009). So, 2007
FIRST_YEAR_OF_RECENT_FEE=2007
# taxa para artigos anteriores a FIRST_YEAR_OF_RECENT_FEE
BACKFILES_FEE=0.20
# valor em dolar disponivel
BUDGET=3
# contador de BUDGET
BUDGETID=1
BUDGETDATE=20090706

#SERVERS NAME
#informar os nomes dos servidores de cada ambiente para que no final 
#do processamento a base de relatório seja copiada para cada um deles
#é necessário ter uma chave para o usuário que roda o processamento em cada 
#um dos servidores e o serviço de SCP deve estar instalado nos servidores.
#export scieloteste=scielo3
#export scielohomol=scielohm1
#export scieloprodu=scieloprod
# ------------------------------------------------------------------------- #
