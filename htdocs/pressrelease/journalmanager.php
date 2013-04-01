<?php
$journal_manager_api = "http://localhost/api/v1/";

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

    return $article_meta;
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
    $result['meta'] = load_article_meta($json['url']);

    return $result;
}
?>