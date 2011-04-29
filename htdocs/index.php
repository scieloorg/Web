<?php

        $redirect = "./scielo.php/scielo.php?script=sci_serial&pid=1808-2394&lng=en&nrm=iso";
        if ($_REQUEST['lang'])
                $redirect .= "?lang=" . $_REQUEST['lang'];

        header("Location: " . $redirect);
?>