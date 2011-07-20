<?php
$n=0;
    $dLimit = array(31,29,31,30,31,30,31,31,30,31,30,31);
        for ($i=0;$i<100;$i++){

            for ($m=1;$m<=12;$m++){
                for ($d=1;$d<=$dLimit[$m-1];$d++){

                    $Y = $i;
                    if (strlen($i) == 1){
                        $Y = "00" . $i;
                    } elseif (strlen($i) == 2){
                        $Y = "0" . $i;
                    }
                    if ($m < 10){
                        $Y .= "0".$m;
                    } else {
                        $Y .=$m;
                    }
                    if ($d < 10){
                        $Y .= "0".$d;
                    } else {
                        $Y .= $d;
                    }
if (($m == 2) && ($d == 29)){
} else {
        $n++;
}
                    echo $Y."|$n\n";
                }
            }
        }
?>
