<?php
    /*
     *  executar: SOMENTE QUANDO HOUVER A ATUALIZAÇÃO NOS TRADUTORES(GOOGLE/WIN)
     *            QUANTO A NOVOS IDIOMAS, OU MESMO LINKS.
     *  saída:    na tela um script php que instancia um array $html(en, pt, es)
     *            com apresentacao de idiomas x google x windows
     *            em formato de tabela dividida em duas colunas.
     *            A saída deve ser copiada para o translateView.php
     *  modificar: caso a apresentação dos links seja diferente
     */
    include('translateGetLanguages.php');
    //$data[$interfaceLang][$languagesCode[$i]]['win'] = 'http://www.microsofttranslator.com/BV.aspx?ref=AddIn&lp=TEXTLANG_'.$languagesCode[$i].'&a=TEXTSOURCE&skpa=on';
    //$sorted[$interfaceLang][$text]=$languagesCode[$i];

    echo '<?php';

    echo "\n";
    echo '/* ';
    echo "\n";
    //var_dump($data);
    //var_dump($sorted);
    echo ' */ ';
    echo "\n";
    foreach ($interfaceLanguages as $iLang){
        $ss = $sorted[$iLang];
        ksort($ss);
        reset($ss);
        $n = count($ss) / 2;



        $print .= '$html['.'"'.$iLang.'"'.']=';
        $print .= "'";
        
        $print .= '<p>';

        $print .= '<table id="translations">';
        // $print .= '<tr><th></th><th>Google</th><th>Windows</th><th></th><th>Google</th><th>Windows</th></tr>';


	   $class = 1;	
        for ($i=0;$i<$n;$i++) {
            $val = current($ss);
		 $class = -1 * $class; 

		 $className = 1 + $class;
            $print .= '<tr class="r'.$className.'">';
            $print .= '<td class="lang">'.$data[$iLang][$val]['label'].'</td>';
            $print .= '<td>';
            if ($data[$iLang][$val]['google']){
                $print .= '<a href="/scieloOrg/php/translateCallAndLog.php?translator=google&tlang=TEXTLANG&tlang2='.$data[$iLang][$val]['google'].'&lang=LANG&pid=PID&script=SCRIPT&url=TEXTSOURCE"  target="_blank"  ">Google</a>';
            }
            $print .= '</td>';
            $print .= '<td>';
            if ($data[$iLang][$val]['win']){
                //$print .= '<a href="'.$data[$iLang][$val]['win'].'"  target="_blank"  style="color:black;">x</a>';
                $print .= '<a href="/scieloOrg/php/translateCallAndLog.php?translator=win&tlang=TEXTLANG&tlang2='.$data[$iLang][$val]['win'].'&lang=LANG&pid=PID&script=SCRIPT&url=TEXTSOURCE"  target="_blank"  ">Windows</a>';
            }
            $print .= '</td>';
            $print .= '<td class="break">';
            $print .= '</td>';

            next($ss);
            $val = current($ss);
            $print .= '<td class="lang">'.$data[$iLang][$val]['label'].'</td>';
            $print .= '<td>';
            if ($data[$iLang][$val]['google']){
                $print .= '<a href="/scieloOrg/php/translateCallAndLog.php?translator=google&tlang=TEXTLANG&tlang2='.$data[$iLang][$val]['google'].'&lang=LANG&pid=PID&script=SCRIPT&url=TEXTSOURCE"  target="_blank" >Google</a>';
            }
            $print .= '</td>';
            $print .= '<td>';
            if ($data[$iLang][$val]['win']){
                $print .= '<a href="/scieloOrg/php/translateCallAndLog.php?translator=win&tlang=TEXTLANG&tlang2='.$data[$iLang][$val]['win'].'&lang=LANG&pid=PID&script=SCRIPT&url=TEXTSOURCE"  target="_blank"  >Windows</a>';
            }
            $print .= '</td>';

            next($ss);

            $print .= '</tr>';
        }
        
        $print .= '</table>';

        $print .= '</p>';
        $print .= "'";
        $print .= ";";
        $print .= "\n";

    }
    //var_dump( $print );
    echo $print ;
    echo '?>';
    echo "\n";

?>
