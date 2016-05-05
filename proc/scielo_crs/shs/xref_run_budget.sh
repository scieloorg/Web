#
# This script is the main if there is a budget, otherwise the main script is the xref_run.sh
# This script accepts as parameters ORDER Descending or Ascending
# generates a list of articles sorted by publication date
# calculates the fee depending of the publication date according to the CrossRef policies
# then call xref_run.sh for each article
#

. crossref_config.sh
chmod 775 *.sh

BUDGETID=$1
ORDER=$2
# SELECTIONTYPE must be ALL or ONLY_NEVER_PROCESSED or ONLY_NEVER_SUBMITTED
SELECTIONTYPE=$3
COUNT=$4
ISSNYEAR=$5

$cisis_dir/mx "seq=db_presupuestos.txt " create=$DB_PRESUPUESTOS  now -all
$cisis_dir/mx $DB_PRESUPUESTOS fst=@$conversor_dir/fst/budget.fst fullinv=$DB_PRESUPUESTOS 


SORTEDLIST=$MYTEMP/sortedlist
LIST=$MYTEMP/list


echo Este procesamiento hara un deposito de XML en CrossRef
echo 
echo Lea con atencion la configuracion que sera presentada a seguir
echo 
echo ENTER para seguir o CTRL+C para interrumpir
read
clear
echo Este procesamiento hara un deposito de XML en CrossRef considerando
echo 
echo BASE ARTIGO en $ARTIGO_DB
echo cisis en $cisis_dir
echo

echo VALOR PARA ARTICULOS DESDE DE     $FIRST_YEAR_OF_RECENT_FEE \$ $RECENT_FEE
echo VALOR PARA ARTICULOS ANTERIORES A $FIRST_YEAR_OF_RECENT_FEE \$ $BACKFILES_FEE
echo PARA EL PAGO SERA USADO EL PRESUPUESTO CUYO ID ES $BUDGETID
echo

if [ "@$BUDGETID" == "@" ]
then
	echo ===========  ATENCION ==================
	echo Informe el valor para el primer parametro BUDGETID 
	exit 0
else
	$cisis_dir/mx cipar=$MYCIPFILE DB_PRESUPUESTOS btell=0 "$BUDGETID" "pft=mfn/" now > budgetid
	BXR=`cat budgetid`
	if [ "@$BXR" == "@" ] 
	then
		echo ===========  ATENCION ==================
		echo Informe el valor para el primer parametro BUDGETID. El valor $BUDGETID no esta valido. 
		echo Los valores validos son 
		$cisis_dir/mx cipar=$MYCIPFILE DB_PRESUPUESTOS from=2 "pft=v1/" now 
		exit 0
	fi
fi
if [ "@$ORDER" == "@Descending" ]
then
	echo ARTICULOS MAS RECIENTES PARA LOS MAS ANTIGUOS
else
	if [ "@$ORDER" == "@Ascending" ]
	then
		echo ARTICULOS MAS ANTIGUOS PARA LOS MAS RECIENTES
	else
		echo ===========  ATENCION ==================
		echo Informe el valor para el segundo parametro ORDER Descending o Ascending
	exit 0
	fi
fi
echo 

if [ "@$SELECTIONTYPE" == "@" ]
then
	echo ===========  ATENCION ==================
	echo Informe el valor para el tercer parametro SELECTIONTYPE 
	echo Este parametro sirve para filtrar los articulos que seran procesados
	echo 
	echo Notas
	echo Articulos sometidos son aquellos que fueron ejecutados con exito, sin error de validacion
	echo Articulos procesados son aquellos que fueron ejecutados con y sin exito
	echo 
	echo Valores validos ALL o ONLY_NEVER_PROCESSED o ONLY_NEVER_SUBMITTED
	echo
	echo ALL no filtra nada, procesa a todos, incluso los que ya habian sido sometidos
	echo ONLY_NEVER_SUBMITTED son aquellos jamas procesados y aquellos que tenian errores. 
	echo ONLY_NEVER_PROCESSED son aquellos jamas procesados 
	
	exit 0
else
	if [ "@$SELECTIONTYPE" == "@ALL" ]
	then
		echo Seran procesados TODOS LOS ARTICULOS
	else
		if [ "@$SELECTIONTYPE" == "@ONLY_NEVER_PROCESSED" ]
		then
			echo Seran procesados los articulos jamas procesados
		else
			if [ "@$SELECTIONTYPE" == "@ONLY_NEVER_SUBMITTED" ]
			then
				echo Seran procesados los articulos jamas procesados y los que tenian errores
			fi
		fi
	fi
fi
if [ "@$COUNT" = "@" ]
then
	echo 
	echo ===========  ATENCION ==================
	echo Nota
	echo El cuarto parametro COUNT tambien sirve para filtrar
	echo Es la cantidad de articulos que seran procesados
	echo No es obligatorio pero su ausencia significa que el procesamiento correra a todos los articulos seleccionados 
	echo  o hasta que el presupuesto sea alcanzado, lo que ocurrir antes
	echo El tiempo de procesamiento para cada articulo es de por lo menos 1 segundo
	echo ENTER para seguir o CTRL+C para interrumpir e ingresar el parametro cuatro
	read
fi
###################
# PREPARE THE ENVIROMENT
#

$conversor_dir/shs/xref_prepareEnvBudget.sh $BUDGETID

$cisis_dir/mx cipar=$MYCIPFILE DB_PRESUPUESTOS btell=0 "$BUDGETID" "pft='fecha del presupuesto: 'v3/,'valor del presupuesto: $ ',v2/,'valor usado: $ ',ref(['DB_CTRL_BG']l(['DB_CTRL_BG']'$BUDGETID'),f(val(v2),1,2)),/,'valor disponible: $ ',f(val(v2)-val(ref(['DB_CTRL_BG']l(['DB_CTRL_BG']'$BUDGETID'),v2)),1,2)/" now 
echo

$cisis_dir/mx cipar=$MYCIPFILE DB_PRESUPUESTOS btell=0 "$BUDGETID" "pft=if '$SELECTIONTYPE'='ONLY_NEVER_PROCESSED' then if val(v2) < (val('$BACKFILES_FEE')+val(ref(['DB_CTRL_BG']l(['DB_CTRL_BG']'$BUDGETID'),v2)) ) then 'exit 0'/ fi ,fi" now >WHATTODO

WHATTODO=`cat WHATTODO`
if [ "$WHATTODO" = "exit 0" ]
then
	echo NO EJECUTADO POR VALOR INSUFICIENTE 
else
	BATCHBGID=`cat temp`
	echo Batch id $BATCHBGID

	echo Estando correcta la configuracion ENTER para seguir
	echo Estando incorrecta CTRL+C para interrumpir y corregir el crossref_config.sh

	read

	if [ -f $SORTEDLIST.txt ]
	then
		mv $SORTEDLIST.txt $MYTEMP/lixo
	fi
	echo>$LIST.txt
	###################
	# GENERATE THE SORTED LIST
	#
    # Formato da lista 19881200 S0074-02761988000400023 0.20
    echo Generando el listado, aguarde...

    if [ "@$ISSNYEAR" == "@" ]
    then
        $cisis_dir/mx cipar=$MYCIPFILE ARTIGO_DB btell=0  "tp=h" "proc='a9001{$FIRST_YEAR_OF_RECENT_FEE{a9002{$RECENT_FEE{a9003{$BACKFILES_FEE{a9005{$BUDGETID{a9055{$SELECTIONTYPE{'" lw=9999 "pft=@$conversor_dir/pft/xref_generateList.pft" now > $LIST.txt
    else
    	echo "$cisis_dir/mx cipar=$MYCIPFILE ARTIGO_DB btell=0  \"hr=S$ISSNYEAR$\" \"proc='a9001{$FIRST_YEAR_OF_RECENT_FEE{a9002{$RECENT_FEE{a9003{$BACKFILES_FEE{a9005{$BUDGETID{a9055{$SELECTIONTYPE{'\" lw=9999 \"pft=@$conversor_dir/pft/xref_generateList.pft\" now > $LIST.txt"
        $cisis_dir/mx cipar=$MYCIPFILE ARTIGO_DB btell=0  "hr=S$ISSNYEAR$" "proc='a9001{$FIRST_YEAR_OF_RECENT_FEE{a9002{$RECENT_FEE{a9003{$BACKFILES_FEE{a9005{$BUDGETID{a9055{$SELECTIONTYPE{'" lw=9999 "pft=@$conversor_dir/pft/xref_generateList.pft" now > $LIST.txt
    fi

	if [ "@$ORDER" == "@Ascending" ]
	then
		cat $LIST.txt | sort -u > $SORTEDLIST.txt
	else
		cat $LIST.txt | sort -u -r > $SORTEDLIST.txt
	fi

echo
echo ATENCION
echo Se abrira con vi el listado $SORTEDLIST.txt de lo que va a procesar
echo Se puede editar para retirar lineas o cerrar sin cambios
echo ENTER para seguir CTRL C para interrumpir
read
vi $SORTEDLIST.txt
echo
echo ENTER para seguir CTRL C para interrumpir
read


	###################
	# EXECUTE
	#
	if [ -f $SORTEDLIST.txt ]
	then
		if [ "@$COUNT" = "@" -o "@$COUNT" = "@ALL" ]
		then
			$cisis_dir/mx cipar=$MYCIPFILE "seq=$SORTEDLIST.txt " lw=99999 "pft='$conversor_dir/shs/xref_run_budget_calculateFee.sh ',v3,' $BUDGETID '/,'WHATTODO=\`cat $MYTEMP/WHATTODO\`'/,'if [ \"\$WHATTODO\" == \"doit\" ]'/,'then'/,'  $conversor_dir/shs/xref_run_budget_doit.sh 'v2,' ',v3,' $BUDGETID $BATCHBGID ',mfn/,'else '/,'  $conversor_dir/shs/xref_run_budget_stop.sh $BATCHBGID ',mfn/,'exit 0'/,'fi'/" now > $MYTEMP/xref_run_budget_calculateFee.sh
		else
			$cisis_dir/mx cipar=$MYCIPFILE "seq=$SORTEDLIST.txt " count=$COUNT lw=99999 "pft='$conversor_dir/shs/xref_run_budget_calculateFee.sh ',v3,' $BUDGETID '/,'WHATTODO=\`cat $MYTEMP/WHATTODO\`'/,'if [ \"\$WHATTODO\" == \"doit\" ]'/,'then'/,'  $conversor_dir/shs/xref_run_budget_doit.sh 'v2,' ',v3,' $BUDGETID $BATCHBGID ',mfn/,'else '/,'  $conversor_dir/shs/xref_run_budget_stop.sh $BATCHBGID ',mfn/,'exit 0'/,'fi'/" now > $MYTEMP/xref_run_budget_calculateFee.sh
		fi
		chmod 775 $MYTEMP/xref_run_budget_calculateFee.sh
		$MYTEMP/xref_run_budget_calculateFee.sh
		
	
		
		echo #######################
		echo
		echo   REPORT of BUDGET ID=$BUDGETID 
		echo 
		# $cisis_dir/mx cipar=$MYCIPFILE DB_BATCH_RUN_BUDGET btell=0 "bool=$BUDGETID" lw=9999  "pft=@$conversor_dir/pft/budget_report.pft" now

		if [ ! -d ../output/crossref/report ]
		then
			mkdir -p ../output/crossref/report/
		fi
		$conversor_dir/shs/xref_report.sh $BUDGETID $BATCHBGID> ../output/crossref/report/$BUDGETID_$BATCHBGID.txt
		echo ===========  ATENCION ==================
		echo Lea el informe ../output/crossref/report/$BUDGETID_$BATCHBGID.txt
		echo fin

	fi
fi
