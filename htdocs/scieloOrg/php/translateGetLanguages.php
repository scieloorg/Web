<?php
    /*  Este script consulta:
     *  http://translate.google.com nos tres idiomas e
     *  http://www.microsofttranslator.com em pt
     *  trazendo a lista de código e rótulo dos idiomas disponíveis para tradução
     *  e gerando a url para tradução para cada tradutor
     *  Este script deve ser modificado quando
     *  houver mudanças nos sites dos tradutores
     */

function str2index($str){
    //var_dump($str);
    $a = array('/é/','/á/','/í/','/ó/','/ú/','/ê/','/ô/','/ã/','/â/','/ñ/');
    $b = array('e','a','i','o','u','e','o','a','a','n');
    $str = preg_replace($a,$b,$str);
    //var_dump($str);
    return strtolower($str);
}
     $interfaceLanguages = array('pt','en','es');

     foreach ($interfaceLanguages as $interfaceLang){
        $availableLanguages = utf8_encode(file_get_contents('http://translate.google.com/?hl='.$interfaceLang));
        $temp_select = explode('<select ', $availableLanguages);
        $temp_select_end = explode('</select>', $temp_select[1]);


        $temp_explode_values = explode('value="', $temp_select_end[0]);
        foreach ($temp_explode_values as $temp_value) {
            $temp_explode_quote = explode('"', $temp_value);

            $langCode = $temp_explode_quote[0];
            if (($langCode!='auto') && ($langCode!='separator') && (strpos($langCode,' ')==0) ){
                $temp_explode_option = explode('</option', $temp_explode_quote[1]);
                $label = explode('>', $temp_explode_option[0]);
                $data[$interfaceLang][$langCode]['label'] = $label[1];
                //$data[$interfaceLang][$langCode]['google'] = 'http://translate.google.com/translate?sl=TEXTLANG&tl='.$langCode.'&u=TEXTSOURCE&skpa=on';
                $data[$interfaceLang][$langCode]['google'] = $langCode;
                $sorted[$interfaceLang][str2index($label[1])]=$langCode;
                //$data[$interfaceLang][$langCode][str2index($label[1])]['google'] = array($label[1],'http://translate.google.com/translate?sl=TEXTLANG&tl='.$langCode.'&u=TEXTSOURCE&skpa=on');
            }
        }
     }
    foreach ($interfaceLanguages as $interfaceLang){
    //var_dump($defFile['windows_live_translator']);
        //$availableLanguages = utf8_decode(file_get_contents('http://www.microsofttranslator.com/'));
        $availableLanguages = file_get_contents('http://www.microsofttranslator.com/');

        $temp1 = explode('var LangPair_ToDDL_keys=[', str_replace("'", '', $availableLanguages));
        $temp2 = explode(']', $temp1[1]);
        $languagesCode = explode(',', $temp2[0]);

        $temp2 = explode('var LangPair_ToDDL_values=[', $temp1[1]);
        $temp3 = explode(']', $temp2[1]);
        $languagesValue = explode(',', $temp3[0]);
        for ($i=2;$i<count($languagesCode);$i++){
            $text = $languagesValue[$i];
            if ($data['pt'][$languagesCode[$i]]['google']){
                $text = $data[$interfaceLang][$languagesCode[$i]]['label'];
            }
            $data[$interfaceLang][$languagesCode[$i]]['label'] = $text;
            //$data[$interfaceLang][$languagesCode[$i]]['win'] = 'http://www.microsofttranslator.com/BV.aspx?ref=AddIn&lp=TEXTLANG_'.$languagesCode[$i].'&a=TEXTSOURCE&skpa=on';
            $data[$interfaceLang][$languagesCode[$i]]['win'] = $languagesCode[$i];
            $sorted[$interfaceLang][str2index($text)]=$languagesCode[$i];
            //$data[$interfaceLang][$languagesCode[$i]][str2index($languagesValue[$i])]['win'] = array($languagesValue[$i],'http://www.microsofttranslator.com/BV.aspx?ref=AddIn&lp=TEXTLANG_'.$languagesCode[$i].'&a=TEXTSOURCE&skpa=on');
        }
     }
     //var_dump($data);

?>
