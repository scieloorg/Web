<?php
declare(strict_types=1);

require_once __DIR__ . '/search_mvp_lib.php';

if (PHP_SAPI !== 'cli') {
    http_response_code(400);
    echo "Run this script in CLI.\n";
    exit(1);
}

$opts = getopt('', [
    'base-url::',
    'lang::',
    'max-serials::',
    'max-issues::',
    'max-articles::',
    'reset::',
]);

$baseUrl = rtrim((string)($opts['base-url'] ?? getenv('SCIELO_MVP_BASE_URL') ?: 'http://127.0.0.1:8090'), '/');
$lang = (string)($opts['lang'] ?? 'en');
$maxSerials = max(1, (int)($opts['max-serials'] ?? 50));
$maxIssues = max(1, (int)($opts['max-issues'] ?? 50));
$maxArticles = max(1, (int)($opts['max-articles'] ?? 5000));
$reset = strtolower((string)($opts['reset'] ?? '1')) !== '0';

$pdo = search_mvp_connect();
if ($reset) {
    $pdo->exec("DELETE FROM search_documents");
}

echo "MVP indexer start\n";
echo "Base URL: {$baseUrl}\n";
echo "Lang: {$lang}\n";

$serialsXmlRaw = search_mvp_http_get(
    "{$baseUrl}/scielo.php?script=sci_alphabetic&lng={$lang}&nrm=iso&debug=xml"
);
$serialsXml = search_mvp_load_xml($serialsXmlRaw);
if (!$serialsXml) {
    fwrite(STDERR, "Failed to load serials XML from sci_alphabetic.\n");
    exit(1);
}

$serialNodes = $serialsXml->xpath('//SERIAL');
if (!$serialNodes) {
    fwrite(STDERR, "No SERIAL nodes found.\n");
    exit(1);
}

$serialCount = 0;
$issueCount = 0;
$articleCount = 0;

foreach ($serialNodes as $serialNode) {
    if ($serialCount >= $maxSerials || $articleCount >= $maxArticles) {
        break;
    }

    $journalIssn = search_mvp_str((string)$serialNode->TITLE['ISSN']);
    $journalTitle = search_mvp_str((string)$serialNode->TITLE);
    if ($journalIssn === '') {
        continue;
    }

    $serialCount++;
    echo "[serial {$serialCount}] {$journalIssn} - {$journalTitle}\n";

    $issuesXmlRaw = search_mvp_http_get(
        "{$baseUrl}/scielo.php?script=sci_issues&pid={$journalIssn}&lng={$lang}&nrm=iso&debug=xml"
    );
    $issuesXml = search_mvp_load_xml($issuesXmlRaw);
    if (!$issuesXml) {
        echo "  - skip: no issues XML\n";
        continue;
    }

    $issueNodes = $issuesXml->xpath('//AVAILISSUES//ISSUE[@SEQ]');
    if (!$issueNodes) {
        echo "  - skip: no ISSUE nodes\n";
        continue;
    }

    $localIssue = 0;
    foreach ($issueNodes as $issueNode) {
        if ($localIssue >= $maxIssues || $articleCount >= $maxArticles) {
            break;
        }
        $issuePid = search_mvp_str((string)$issueNode['SEQ']);
        if ($issuePid === '') {
            $issuePid = search_mvp_str((string)$issueNode['PID']);
        }
        if ($issuePid === '') {
            continue;
        }

        $localIssue++;
        $issueCount++;

        $tocXmlRaw = search_mvp_http_get(
            "{$baseUrl}/scielo.php?script=sci_issuetoc&pid={$issuePid}&lng={$lang}&nrm=iso&debug=xml"
        );
        $tocXml = search_mvp_load_xml($tocXmlRaw);
        if (!$tocXml) {
            continue;
        }

        $articleNodes = $tocXml->xpath('//ARTICLE[@PID]');
        if (!$articleNodes) {
            continue;
        }

        foreach ($articleNodes as $articleNode) {
            if ($articleCount >= $maxArticles) {
                break;
            }
            $pid = search_mvp_str((string)$articleNode['PID']);
            if ($pid === '') {
                continue;
            }

            $abstractXmlRaw = search_mvp_http_get(
                "{$baseUrl}/scielo.php?script=sci_abstract&pid={$pid}&lng={$lang}&nrm=iso&tlng={$lang}&debug=xml"
            );
            $abstractXml = search_mvp_load_xml($abstractXmlRaw);
            if (!$abstractXml) {
                continue;
            }

            $title = search_mvp_extract_text($abstractXml, '//ARTICLE/NOHTML-TITLE');
            if ($title === '') {
                $title = search_mvp_extract_text($abstractXml, '//ARTICLE/TITLE');
            }
            if ($title === '') {
                $title = search_mvp_extract_text($abstractXml, '//TITLEGROUP/TITLE');
            }

            $authors = search_mvp_extract_text($abstractXml, '//ARTICLE/AUTHORS/AUTH_PERS/AUTHOR/SURNAME');
            $abstractText = search_mvp_extract_text($abstractXml, '//ARTICLE/ABSTRACT');
            $pubYearRaw = search_mvp_extract_text($abstractXml, '//ARTICLE/ISSUEINFO/@YEAR');
            $pubYear = ctype_digit($pubYearRaw) ? (int)$pubYearRaw : null;

            $doc = [
                'pid' => $pid,
                'title' => $title,
                'abstract_text' => $abstractText,
                'authors' => $authors,
                'journal_title' => $journalTitle,
                'journal_issn' => $journalIssn,
                'pub_year' => $pubYear,
                'lang' => $lang,
                'article_url' => "/scielo.php?script=sci_arttext&pid={$pid}&lng={$lang}&nrm=iso&tlng={$lang}",
                'abstract_url' => "/scielo.php?script=sci_abstract&pid={$pid}&lng={$lang}&nrm=iso&tlng={$lang}",
                'source_issue_pid' => $issuePid,
            ];

            search_mvp_insert_or_update($pdo, $doc);
            $articleCount++;
            echo "    + {$pid}\n";
        }
    }
}

echo "Done.\n";
echo "Serials indexed: {$serialCount}\n";
echo "Issues visited: {$issueCount}\n";
echo "Articles indexed: {$articleCount}\n";
echo "DB: " . search_mvp_db_path() . "\n";
