<?php
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
    $volnum = implode(' ', array($data['issue']['vol'], $data['issue']['num']));
    if (trim($volnum)){
        array_push($meta, $volnum);   
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

function load_issue_meta($url){
    $xml_meta = file_get_contents($url);
    $issue = new SimpleXMLElement($xml_meta);
    $meta = array();
    $meta['issue'] = array();
    $meta['issue']['journal_abbrev_title'] = $issue->TITLEGROUP->SHORTTITLE;
    $meta['issue']['vol'] = $issue->ISSUE->STRIP->VOL;
    $meta['issue']['num'] = $issue->ISSUE->STRIP->NUM;
    $meta['issue']['city'] = $issue->ISSUE->STRIP->CITY;
    $meta['issue']['month'] = $issue->ISSUE->STRIP->MONTH;
    $meta['issue']['year'] = $issue->ISSUE->SECTION->YEAR;
    $meta['issue']['id'] = substr($issue->ISSUE->SECTION->ARTICLE->attributes()->PID, 0 , 18);
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
        $response = file_get_contents($url);
        $m->add($url, $response, $ttl);
    }

    $m->close();
    return $response;
}

function get_press_releases_by_pid($pid, $lng){
    #$json = json_decode(file_get_contents('fixture_prs.json'), true);
    $json = json_decode(quering_api('fixture_prs.json'), true);
    #$request_url = $journal_manager_api+'article_pid/'+$pid;
    #$request_url = $journal_manager_api+'issue_pid/'+$pid;
    #$request_url = $journal_manager_api+'journal_pid/'+$pid;

    #$json = json_decode(file_get_contents($request_url), true);
    $prs = array('article'=>array(), 'issue'=>array()) ;
    foreach ($json as $itempr){
        $pr = array();
        $pr['created_at'] = $itempr['created_at'];
        $pr['id'] = $itempr['id'];
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
    $json = json_decode(quering_api('fixture_pr_id.json'), true);
    #$request_url = $journal_manager_api+'article_pid/'+$pid;
    #$request_url = $journal_manager_api+'issue_pid/'+$pid;
    #$json = json_decode(file_get_contents($request_url), true);
    $itempr = $json[0];
    $pr = array();
    $pr['created_at'] = $itempr['created_at'];
    $pr['id'] = $itempr['id'];
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
        $xml_url = 'http://vm.scielo.br/scielo.php?debug=xml&pid='.$pid.'&script=sci_issuetoc';
        $meta = load_issue_meta($xml_url);
        $meta['citation'] = citation_display($meta);
        $result['meta'] = array($meta);
    }

    return $result;
}
?>