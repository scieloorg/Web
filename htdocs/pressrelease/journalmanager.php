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

    $meta_arr = array(implode('; ', $authors),
                      $data['meta']['article']['title'],
                      $data['meta']['issue']['journal_abbrev_title'],
                      $data['meta']['issue']['city'],
                      $data['meta']['issue']['year'],
                      implode(' ', array($data['meta']['issue']['vol'], $data['meta']['issue']['num'])),
                      implode('-', array($data['meta']['article']['fpage'], $data['meta']['article']['lpage'])),
                      );

    $citation = implode( ', ', $meta_arr).'.';
    
    for ($x=1; $x<=count($citation); $x++){
        if ($citation[$x].str_replace(' ','').str_replace('-','') === '') {
            unset($citation[$x]);
        }
    }

    return $citation;
}

function load_article_meta($url){

    $xml_meta = file_get_contents($url."&debug=xml");

    $article = new SimpleXMLElement($xml_meta);

    $article_meta = array();

    $issue = $article->SERIAL->ISSUE;

    $article_meta['issue'] = array();
    $article_meta['issue']['journal_abbrev_title'] = $issue->STRIP->SHORTTITLE;
    $article_meta['issue']['vol'] = $issue->STRIP->VOL;
    $article_meta['issue']['num'] = $issue->STRIP->NUM;
    $article_meta['issue']['city'] = $issue->STRIP->CITY;
    $article_meta['issue']['month'] = $issue->STRIP->MONTH;
    $article_meta['issue']['year'] = $issue->STRIP->YEAR;
    $article_meta['article'] = array();
    $article_meta['article']['title'] = $issue->ARTICLE->TITLE;
    $article_meta['article']['authors'] = $issue->ARTICLE->AUTHORS->AUTH_PERS;
    $article_meta['article']['fpage'] = $issue->ARTICLE->attributes()->FPAGE;
    $article_meta['article']['lpage'] = $issue->ARTICLE->attributes()->LPAGE;

    return $article_meta;
}

function load_issue_meta($url){

    $xml_meta = file_get_contents($url."&debug=xml");

    $issue = new SimpleXMLElement($xml_meta);

    $meta = array();

    $meta['issue'] = array();
    $meta['issue']['journal_abbrev_title'] = $issue->TITLEGROUP->SHORTTITLE;
    $meta['issue']['vol'] = $issue->ISSUE->STRIP->VOL;
    $meta['issue']['num'] = $issue->ISSUE->STRIP->NUM;
    $meta['issue']['city'] = $issue->ISSUE->STRIP->CITY;
    $meta['issue']['month'] = $issue->ISSUE->STRIP->MONTH;
    $meta['issue']['year'] = $issue->ISSUE->STRIP->YEAR;

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

function get_issues_press_releases_bu_issue_id($id){
    $json = json_decode(file_get_contents('fixture_issue.json'), true);

    $result = array();

    foreach ($json["issue_press_releases"] as $prs){
        array_push($result, $prs);
    }

    return $result;
}

function get_press_release($id){
    $json = json_decode(file_get_contents('fixture_pressrelease.json'), true);

    $result = array();

    $result['prs'] = $json;

    if ($jsonp['type'] === 'article'){
        $result['meta'] = load_article_meta($json['url']);
    }else{
        $result['meta'] = load_issue_meta($json['url']);
    }

    $result['citation'] = citation_display($result);

    return $result;
}
?>