<?
error_reporting(1);

class Broker {
    var $_articlemeta = 'http://articlemeta.scielo.org/api/v1/';

    function get_document_by_doi($doi) {
        $request_url = $this->_articlemeta.'article/?code='.$doi;

        try {
            $json = file_get_contents($request_url);
        }
        catch (Exception $e) {
            return NULL;
        }

        return json_decode($json);
    }
}
?>