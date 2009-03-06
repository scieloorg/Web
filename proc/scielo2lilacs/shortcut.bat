##############################################################################
#
# PROCESSAMENTO DE GERACAO DE REGISTROS LILACS, 
#
#		A PARTIR DE REGISTROS TIPO L DA BASE SCIELO
# 
#		O processamento:
#		0) usa uma base iso com registros L, que eh reinvertida usando scielo2lilacs/fst/src.fst
#		1) le a base de registros L (procurando por reg=l (ele)) 
#		2) gera uma scilista contendo acron issueid issue_pid data_de_publicacao status
#		3) le esta scilista 
#		nota:
#			status = QUALIFIED - pode ser convertido a registro LILACS
#			status = NOT_QUALIFIED_BY_TITLE - não eh um titulo LILACS (sabido por estar ou nao na base LILTITLE)
#			status = NOT_QUALIFIED_BY_DATE - eh um titulo LILACS, mas a data de publicacao o desclassifica por ser antigo.
#			status = NOT_QUALIFIED_ISSUE - sao desconsiderados os issues ahead, review in progress, press release.
#			
#		4) para os itens cujo status=QUALIFIED gera os registros LILACS em uma base,
#			para os demais são apenas registrados na base de controle de números SCILIL_PARM_ctrlIssue
#
#		OBSERVACAO: 
#		a) este processamento NAO inclui registros na base LILACS
#		b) este processamento NAO avalia se o registro já está ou não na base LILACS
#		c) aa base resultante deste processamento eh feito append. Se ha reprocessamento de um numero, seus registros sao apagados, 
#			e ao final são acrescentados os novos.
#		
###############################################################################



#################    CONFIGURACAO INICIO ###########################


# uma base ISO, mas NÃO INDICAR EXTENSAO, que contenha registro L de SciELO cujos registros possam ser recuperados pelo índice "reg=l"
export SCILIL_PARM_SRCDB=/home/scielo/www/bases-aux/scielo-lilacs/input/regL

# somente nome do arquivo que contera a lista de números contidos na base dada
export SCILIL_PARM_list=scilist.scielo2lilacs.txt

# data de publicacao que limita a selecao de registros. Entram na selecao registros cuja data de publicacao sejam superior a dada
export SCILIL_PARM_limit=20080000

# base LILACS resultante. Note sempre é append. Para numeros reprocessados sao apagados seus registros e depois eh feito um append
export SCILIL_PARM_dest=/home/scielo/www/bases-aux/scielo-lilacs/output/scielolilacs

# base sera criada para controlar a conversao de cada artigo. Armazena quais os dados estao inconsistentes.
export SCILIL_PARM_ctrlConversion=/home/scielo/www/bases-aux/scielo-lilacs/ctrl/ctrl_conversion

# base sera criada para controlar o resultado de cada número, inclusive dos números não selecionados, ou seja, 
# títulos nao LILACS, números excluido devido aa data de publicacao, etc.
export SCILIL_PARM_ctrlIssue=/home/scielo/www/bases-aux/scielo-lilacs/ctrl/ctrl_issue

# base resultante do processamento de idiomas, e que server para gerar o campo 8 de url dos textos completos
export SCILIL_PARM_DBLANG=/home/scielo/www/bases-work/artigo/lang

# MX e WXIS compativeis un com o outro
export SCILIL_MX=cisis/mx
export SCILIL_WXIS=cisis/wxis


# localizacao da base title de SciELO
# sera usado o indice LOC=issn
export SRC_TITLES=/home/scielo/www/bases-aux/scielo-lilacs/input/titles

# localizacao da base iso liltitle de LILACS, sem extensao. 
# Esta base sera copiada e sua copia sera reinvertida usando scielo2lilacs/fst/titles.fst
# sera usado o indice LOC=issn
export SRC_LILTITLE=/home/scielo/www/bases-aux/scielo-lilacs/input/liltitle

# localizacao da base iso collections sem extensao
# Esta base sera copiada e sua copia sera reinvertida usando scielo2lilacs/fst/collections.fst
# Sera usada para preencher o codigo do centro e o campo 8 de url dos textos completos
# campo 1 apelido
# campo 2 url
# campo 3 codigo do centro
# campo 4 repetitivo com os issn, a fim de identificar a colecao do periodico
export SRC_COLLECTIONS=/home/scielo/www/bases-aux/scielo-lilacs/input/collections

# LOG DA EXECUCAO DO WXIS
export SCILIL_PARM_WXISLOG=temp/scielo2lilacs_wxislog.txt


#################    CONFIGURACAO FIM ####################



#######################################
# begin Setting Application Variables
#######################################

# base title da SciELO
export SCILIL_GBL_TITLES=$SRC_TITLES

# copia da base iso liltitle de LILACS
export SCILIL_GBL_LILTITLE=temp/scielo2lilacs_liltitle

# copia da base iso collection de LILACS
export SCILIL_GBL_COLLECTIONS=temp/scielo2lilacs_collections

# TABELAS USADAS NA CONVERSAO SCIELO LILACS
export SCILIL_GBL_GIZMOA=scielo2lilacs/input/gizmoa
export SCILIL_GBL_SCIELOTP=scielo2lilacs/input/scielotp

# CIPAR TEMPORARIO
export SCILIL_PARM_cipfile=temp/scielo2lilacs_mycipar.cip



#######################################
# begin Deleting temp
#######################################

#rm ../bases-aux/scielo-lilacs/ctrl/* ../bases-aux/scielo-lilacs/output/* 
rm temp/scielo2lilacs_*

chmod -R 775 scielo2lilacs/linux/*.bat 

#######################################
# begin Creating cipar file $SCILIL_PARM_cipfile
#######################################
if [ -f "$SCILIL_PARM_cipfile" ]
then
	rm $SCILIL_PARM_cipfile
fi
scielo2lilacs/linux/addLineInCip.bat DBLANG $SCILIL_PARM_DBLANG $SCILIL_PARM_cipfile
scielo2lilacs/linux/addLineInCip.bat CTRL_ISSUE $SCILIL_PARM_ctrlIssue $SCILIL_PARM_cipfile
scielo2lilacs/linux/addLineInCip.bat CTRL_CONVERSION $SCILIL_PARM_ctrlConversion $SCILIL_PARM_cipfile
scielo2lilacs/linux/addLineInCip.bat TITLES $SCILIL_GBL_TITLES $SCILIL_PARM_cipfile
scielo2lilacs/linux/addLineInCip.bat LILTITLE $SCILIL_GBL_LILTITLE $SCILIL_PARM_cipfile
scielo2lilacs/linux/addLineInCip.bat LILTITLES $SCILIL_GBL_LILTITLE $SCILIL_PARM_cipfile
scielo2lilacs/linux/addLineInCip.bat COLLECTIONS $SCILIL_GBL_COLLECTIONS $SCILIL_PARM_cipfile
scielo2lilacs/linux/addLineInCip.bat GIZIDIOMA $SCILIL_GBL_GIZMOA $SCILIL_PARM_cipfile
scielo2lilacs/linux/addLineInCip.bat SCIELOTP $SCILIL_GBL_SCIELOTP $SCILIL_PARM_cipfile

#######################################
# begin Copying tables
#######################################
if [ -f $SRC_LILTITLE.iso ] 
then
	export d=`dirname $SCILIL_GBL_LILTITLE`
	
	[ -d $d ] || mkdir -p $d
	cp $SRC_LILTITLE.iso $SCILIL_GBL_LILTITLE.iso
	
fi
if [ -f $SRC_COLLECTIONS.iso ] 
then
	export d=`dirname $SCILIL_GBL_COLLECTIONS`
	
	[ -d $d ] || mkdir -p $d
	cp $SRC_COLLECTIONS.iso $SCILIL_GBL_COLLECTIONS.iso
	
fi


#######################################
# begin Creating masters
#######################################
scielo2lilacs/linux/iso2mst.bat $SCILIL_PARM_SRCDB $SCILIL_MX scielo2lilacs/fst/src.fst
scielo2lilacs/linux/iso2mst.bat $SCILIL_GBL_SCIELOTP $SCILIL_MX scielo2lilacs/fst/scielotp.fst
scielo2lilacs/linux/iso2mst.bat $SCILIL_GBL_GIZMOA $SCILIL_MX
scielo2lilacs/linux/iso2mst.bat $SCILIL_GBL_LILTITLE $SCILIL_MX scielo2lilacs/fst/titles.fst
scielo2lilacs/linux/iso2mst.bat $SCILIL_GBL_COLLECTIONS $SCILIL_MX scielo2lilacs/fst/collections.fst

#######################################
# begin Creating dir
#######################################

export d=`dirname $SCILIL_PARM_dest.mst`
[ -d $d ] || mkdir -p $d

export d=`dirname $SCILIL_PARM_ctrlConversion.mst`
[ -d $d ] || mkdir -p $d

export d=`dirname $SCILIL_PARM_ctrlIssue.mst`
[ -d $d ] || mkdir -p $d



#######################################
# begin Checking databases 2
#######################################

if [ -f "$SCILIL_GBL_TITLES.mst" ]
then
	if [ -f "$SCILIL_GBL_LILTITLE.mst" ]
	then		
		if [ -f "$SCILIL_GBL_COLLECTIONS.mst" ]
		then
			if [ -f "$SCILIL_GBL_SCIELOTP.mst" ]
			then
				if [ -f "$SCILIL_GBL_GIZMOA.mst" ]
				then
						if [ -f "$SCILIL_LIST_DBLANG.mst" ]
						then

							if [ -f "$SCILIL_LIST_SRCDB.mst" ]
							then
								

								#######################################
								# begin Creating scilista $SCILIL_PARM_list
								#######################################
								scielo2lilacs/linux/scilist_generate.bat $SCILIL_PARM_SRCDB $SCILIL_PARM_list $SCILIL_PARM_limit $SCILIL_PARM_cipfile



								#######################################
								# begin Main
								#######################################

								scielo2lilacs/linux/doForList.bat $SCILIL_PARM_list $SCILIL_PARM_SRCDB $SCILIL_PARM_dest $SCILIL_PARM_ctrlConversion $SCILIL_PARM_ctrlIssue $SCILIL_PARM_cipfile $SCILIL_PARM_WXISLOG $SCILIL_PARM_DBLANG 


							else
								echo Missing $SCILIL_LIST_SRCDB
							fi
						else
							echo Missing $SCILIL_LIST_DBLANG
						fi
				else
					echo Missing $SCILIL_GBL_GIZMOA
				fi
			else
				echo Missing $SCILIL_GBL_SCIELOTP
			fi
		else
			echo Missing $SCILIL_GBL_COLLECTIONS
		fi
	else
		echo Missing $SCILIL_GBL_LILTITLE
	fi
else
	echo Missing $SCILIL_GBL_TITLES
fi


