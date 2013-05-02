<?php
$journal_manager_user = "anonymous";
$journal_manager_token = "f258b2b1fc74e11c738123da61g79b95d8578fbb";
$journal_manager_api = "http://localhost/api/v1/";
$memcached_host = "127.0.0.1:11211";

function citation_display($data){
    $authors  = array();
    foreach ($data['article']['authors']->AUTHOR as $author){
        $name = array();
        if ($author->NAME){
           array_push($name, $author->NAME);
        }
        if ($author->SURNAME){
            array_push($name, $author->SURNAME);
        }
        array_push($authors, implode(', ', $name));
    }
    $meta = array();
    $authors = implode('; ', $authors);
    if ($authors){
        array_push($meta, $authors);
    }
    if ($data['article']['title']){
        array_push($meta, $data['article']['title']);   
    }
    if ($data['issue']['journal_abbrev_title']){
        array_push($meta, $data['issue']['journal_abbrev_title']);
    }
    if ($data['issue']['city']){
        array_push($meta, $data['issue']['city']);
    }
    if ($data['issue']['year']){
        array_push($meta, $data['issue']['year']);
    }

    $volnum = implode(' ', array("v.".$data['issue']['vol'], "n.".$data['issue']['num']));
    if (trim($volnum)){
        array_push($meta, $volnum);   
    }

    $volnum_arr = array();
    if ($data['issue']['vol']){
        array_push($supplvolnum_arr, "v.".$data['issue']['vol']);
    }

    if ($data['issue']['num']){
        array_push($supplvolnum_arr, "n.".$data['issue']['num']);
    }
    
    if (sizeof($volnum_arr) > 0){
            array_push($meta, implode(' ', $volnum));
    }

    $supplvolnum_arr = array();
    if ($data['issue']['suppl_vol']){
        array_push($supplvolnum_arr, "sup.v.".$data['issue']['suppl_vol']);
    }

    if ($data['issue']['suppl_num']){
        array_push($supplvolnum_arr, "sup.n.".$data['issue']['suppl_num']);
    }
    
    if (sizeof($supplvolnum_arr) > 0){
            array_push($meta, implode(' ', $supplvolnum));
    }

    $pages = implode('-', array($data['article']['fpage'], $data['article']['lpage']));
    if (str_replace('-', '', trim($pages))){
        array_push($meta, $pages);   
    }
    $citation = implode( ', ', $meta).'.';
    return $citation;
}

function load_article_meta($url){
    $xml_meta = file_get_contents($url);
    $article = new SimpleXMLElement($xml_meta);
    $meta = array();
    $issue = $article->SERIAL->ISSUE;
    $meta['issue'] = array();
    $meta['issue']['journal_abbrev_title'] = $issue->STRIP->SHORTTITLE;
    $meta['issue']['vol'] = $issue->STRIP->VOL;
    $meta['issue']['num'] = $issue->STRIP->NUM;
    $meta['issue']['city'] = $issue->STRIP->CITY;
    $meta['issue']['month'] = $issue->STRIP->MONTH;
    $meta['issue']['year'] = $issue->STRIP->YEAR;
    $meta['issue']['id'] = substr($issue->ARTICLE->attributes()->PID, 0, 18);
    $meta['article'] = array();
    $meta['article']['title'] = $issue->ARTICLE->TITLE;
    $meta['article']['authors'] = $issue->ARTICLE->AUTHORS->AUTH_PERS;
    $meta['article']['fpage'] = $issue->ARTICLE->attributes()->FPAGE;
    $meta['article']['lpage'] = $issue->ARTICLE->attributes()->LPAGE;
    $meta['article']['id'] = $issue->ARTICLE->attributes()->PID;
    return $meta;
}

function load_issue_meta($issue_meta){
    $meta = array();
    $meta['issue'] = array();
    $meta['issue']['journal_abbrev_title'] = $issue_meta['short_title'];
    $meta['issue']['vol'] = $issue_meta['volume'];
    $meta['issue']['num'] = $issue_meta['number'];
    $meta['issue']['suppl_vol'] = $issue_meta['suppl_volume'];
    $meta['issue']['suppl_num'] = $issue_meta['suppl_number'];
    $meta['issue']['city'] = $issue_meta['publication_city'];
    $meta['issue']['month'] = $issue_meta['publication_start_month'];
    $meta['issue']['year'] = $issue_meta['publication_year'];
    $meta['issue']['id'] = $issue_meta['pid'];
    return $meta;
}

function quering_api($url='fixture_prs.json', $ttl=0){
    global $memcached_host;
    $m = new Memcache();
    $memcache_url = explode(":", $memcached_host);
    $memcache_domain = $memcache_url[0];
    $memcache_port = $memcache_url[1];

    $m->connect($memcache_domain, $memcache_port); 

    $from_cache = $m->get($url);
    if ($from_cache){
        return $from_cache;
    }else{
        $response = file_get_contents($url, true);
        $m->add($url, $response, $ttl);
    }

    $m->close();
    return $response;
}

function issue_label($meta){

    $label_arr = array();

    if ($meta['volume']){
        array_push($label_arr, "v.".$meta['volume']);
    }

    if ($meta['number']){
        array_push($label_arr, "n.".$meta['number']);
    }

    if ($meta['suppl_volume']){
        array_push($label_arr, "suppl v.".$meta['suppl_volume']);
    }

    if ($meta['suppl_number']){
        array_push($label_arr, "suppl n.".$meta['suppl_number']);
    }

    $date = $meta['publication_year']."/".sprintf('%1$02d', $meta["publication_start_month"]);

    $str = $date.' - '.implode(' ', $label_arr);

    return $str;
}

function get_press_releases_by_pid($pid, $lng){
    #$json = json_decode(file_get_contents('fixture_prs.json'), true);
    #$json = json_decode(quering_api('fixture_prs.json'), true);

    if (preg_match("^[0-9]{4}-[0-9]{3}[0-9xX]$", $pid)){
        $request_url = $journal_manager_api+'/pressreleases/?journal_pid='+$pid;
    }elseif (preg_match("^[0-9]{4}-[0-9]{3}[0-9xX][0-2][0-9]{3}[0-9]{4}$", $pid)){
        $request_url = $journal_manager_api+'/pressreleases/?issue_pid='+$pid;    
    }elseif (preg_match("^[0-9]{4}-[0-9]{3}[0-9xX][0-2][0-9]{3}[0-9]{4}[0-9]{5}$", $pid)){
        $request_url = $journal_manager_api+'/pressreleases/?article_pid='+$pid;
    }

    $json = json_decode(quering_api($request_url));

    $prs = array('article'=>array(), 'issue'=>array()) ;

    foreach ($json['objects'] as $itempr){
        $pr = array();
        $pr['created_at'] = $itempr['created_at'];
        $pr['id'] = $itempr['id'];
        $pr['issue_label'] = issue_label($itempr['issue_meta']);
        $pr['number'] = $itempr['number'];
        $type = 'issue';
        if ($itempr['articles']){
            $type = 'article';
            $pr['pid'] = $itempr['articles'];
        }
        $pr['title'] = $itempr['translations'][0]['title'];
        foreach ($itempr['translations'] as $itemtrans){
            if ($itemtrans['language'] === $lng){
                $pr['title'] = $itemtrans['title'];
                continue;
            }

        }
        array_push($prs[$type], $pr);
    }
    $result = json_encode($prs);
    return $result;
}

function get_press_release($id, $pid, $lng){
    #$json = json_decode(file_get_contents('fixture_pr_id.json'), true);
    #$json = json_decode(quering_api('fixture_pr_id.json'), true);

    $request_url = $journal_manager_api+'pressreleases/'+$id;
    $json = json_decode(quering_api($request_url));

    $itempr = $json;
    $pr = array();
    $pr['created_at'] = $itempr['created_at'];
    $pr['id'] = $itempr['id'];
    $pr['issue_label'] = issue_label($itempr['issue_meta']);
    $pr['type'] = 'issue';
    if ($itempr['articles']){
        $pr['type'] = 'article';
        $pr['pid'] = $itempr['articles'][0];
    }
    $pr['title'] = $itempr['translations'][0]['title'];
    $pr['content'] = $itempr['translations'][0]['content'];
    foreach ($itempr['translations'] as $itemtrans){
        if ($itemtrans['language'] === $lng){
            $pr['title'] = $itemtrans['title'];
            $pr['content'] = $itemtrans['content'];
            continue;
        }
    }
    $result = array();
    $result['prs'] = $pr;
    if ($result['prs']['type'] === 'article'){
        $result['meta'] = array();
        foreach (explode(',', $pid) as $article_pid){
            $xml_url = 'http://vm.scielo.br/scielo.php?debug=xml&pid='.$article_pid.'&script=sci_arttext';
            $meta = load_article_meta($xml_url);
            $meta['citation'] = citation_display($meta);
            array_push($result['meta'], $meta);
        }
    }else{
        $itempr['issue_meta']['pid'] = substr($pid, 0, 18);
        $meta = load_issue_meta($itempr['issue_meta']);
        $meta['citation'] = citation_display($meta);
        $result['meta'] = array($meta);
    }

    return $result;
}
?>