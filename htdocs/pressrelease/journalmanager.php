<?php
$journal_manager_api = "http://localhost/api/v1/";
$mencached_host = "localhost:11211";

function citation_display($data){

    $authors  = array();

    foreach ($data['meta']['article']['authors']->AUTHOR as $author){
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

    if ($data['meta']['article']['title']){
        array_push($meta, $data['meta']['article']['title']);   
    }

    if ($data['meta']['issue']['journal_abbrev_title']){
        array_push($meta, $data['meta']['issue']['journal_abbrev_title']);
    }

    if ($data['meta']['issue']['city']){
        array_push($meta, $data['meta']['issue']['city']);
    }

    if ($data['meta']['issue']['year']){
        array_push($meta, $data['meta']['issue']['year']);
    }

    $volnum = implode(' ', array($data['meta']['issue']['vol'], $data['meta']['issue']['num']));
    if (trim($volnum)){
        array_push($meta, $volnum);   
    }

    $pages = implode('-', array($data['meta']['article']['fpage'], $data['meta']['article']['lpage']));
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

function get_articles_press_releases_by_journal_id($id){
    $json = json_decode(file_get_contents('fixture_journal.json'), true);

    $result = array();

    foreach ($json as $journal){
        foreach ($journal["articles_press_releases"] as $prs){
            array_push($result, $prs);
        }
    }

    return $result;
}

function get_issues_press_releases_by_journal_id($id){
    $json = json_decode(file_get_contents('fixture_journal.json'), true);

    $result = array();

    foreach ($json as $journal){
        foreach ($journal["issue_press_releases"] as $prs){
            array_push($result, $prs);
        }
    }

    return $result;
}

function get_articles_press_releases_by_issue_id($id){
    $json = json_decode(file_get_contents('fixture_issue.json'), true);

    $result = array();

    foreach ($json["articles_press_releases"] as $prs){
        array_push($result, $prs);
    }

    return $result;
}

function get_issues_press_releases_by_issue_id($id){
    $json = json_decode(file_get_contents('fixture_issue.json'), true);

    $result = array();

    foreach ($json["issue_press_releases"] as $prs){
        array_push($result, $prs);
    }

    return $result;
}

function get_press_releases_by_issue_id($id){
    $json = json_decode(file_get_contents('fixture_issue.json'), true);

    return $json;
}

function get_press_release($id){
    $json = json_decode(file_get_contents('fixture_pressrelease_article.json'), true);

    $result = array();

    $result['prs'] = $json;

    if ($result['prs']['type'] === 'article'){
        $xml_url = '/scielo.php?debug=xml&pid='.$json[article_pid].'&script=sci_arttext';
        $result['meta'] = load_article_meta($json[$xml_url]);
    }else{
        $xml_url = '/scielo.php?debug=xml&pid='.$json[issue_pid].'&script=sci_arttext';
        $result['meta'] = load_issue_meta($json[$xml_url]);
    }

    $result['citation'] = citation_display($result);

    return $result;
}
?>