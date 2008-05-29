# ------------------------------------------------------------------------- #
# variaveis com caminho para bases de dados utilizadas no processmento.
# ------------------------------------------------------------------------- #
export scielo_dir="/home/scielo/www"
export scielo_proc="/home/scielo/www/proc"
export database_dir="$scielo_dir/bases"
export conversor_dir="$scielo_dir/proc/scielo_crs"
export cisis_dir="$scielo_dir/proc/cisis" 

#JAVA RUNTIME ENVIRONMENT VARS
export JAVA_HOME=/usr/local/jdk1.5.0_06

#variaveis com dados de conexao ao crossref
export crossrefUserName=
export crossrefPassword=

#SERVERS NAME
#informar os nomes dos servidores de cada ambiente para que no final 
#do processamento a base de relatório seja copiada para cada um deles
#é necessário ter uma chave para o usuário que roda o processamento em cada 
#um dos servidores e o serviço de SCP deve estar instalado nos servidores.
export scieloteste=scielo3
export scielohomol=scielohm1
export scieloprodu=scieloprod
# ------------------------------------------------------------------------- #
