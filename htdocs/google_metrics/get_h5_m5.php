<?php
header('Content-type: text/json');

function read_h5_m5_csv($csv_file){
    $file_handle = fopen($csv_file, 'r');
    $lines_of_csv = array();
    while (!feof($file_handle) ) {
        $csv_fields = fgetcsv($file_handle, 1024, ",", '"');
        $issn = $csv_fields[0];
        $year = $csv_fields[1];
        $h5 = $csv_fields[3];
        $m5 = $csv_fields[4];
        $url =$csv_fields[5];
        $lines_of_csv[$issn] = array('year'=>$year, 'h5'=>$h5, 'm5'=>$m5,'url'=>$url);
    }
    fclose($file_handle);
    return $lines_of_csv;
}

$serial_json = '';

$issn = strtolower($_GET['issn']);
$callback_function = $_GET['callback'];

if ( isset($issn) ){
    $csv_lines = read_h5_m5_csv("journals_url.csv");
    $serial_data = $csv_lines[$issn];
    $serial_json = json_encode($serial_data);
}

if ( isset($callback_function) ){
    $serial_json = $callback_function . "(". $serial_json . ")";
}

print $serial_json;

?>