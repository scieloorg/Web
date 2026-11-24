<?php

include_once("old2new.inc");

class RequestVars
{
    var $_request = array();

    function __construct()
    {
        $this->RequestVars();
    }

    function RequestVars ()
    {
        $requestUri = isset($_SERVER['REQUEST_URI']) ? $_SERVER['REQUEST_URI'] : '';
        $scriptName = isset($_SERVER['SCRIPT_NAME']) ? $_SERVER['SCRIPT_NAME'] : '';

        if (strpos($requestUri, "?") === false)
        {
            $QSCnav = $requestUri;
            $QSCscript = $scriptName;
            $QSCnav = preg_replace('/^' . preg_quote($QSCscript, '/') . '/', '', $QSCnav);
            $QSCvars = explode("/", $QSCnav);
            $QSCArray = array();

            for ($QSCi = 1; $QSCi < count($QSCvars); $QSCi++)
            {
                $QSCpos = strpos($QSCvars[$QSCi], "_");
                if ($QSCpos)
                {
                    $QSCvar = substr($QSCvars[$QSCi], 0, $QSCpos);
                    $QSCArray[$QSCvar] = substr($QSCvars[$QSCi], $QSCpos + 1);
                }
                else
                {
                    $QSCvar = $QSCvars[$QSCi];
                    $QSCArray[$QSCvar] = "";
                }
            }

            $this->_request = array_merge($_GET, $_POST, $QSCArray);
        }
        else
        {
            $this->_request = array_merge($_GET, $_POST);
        }

        if (isset($this->_request['lng'])) {
            if (!is_string($this->_request['lng'])) {
                unset($this->_request['lng']);
            } else {
                $language = strtolower(trim($this->_request['lng']));
                if (in_array($language, array('en', 'pt', 'es'), true)) {
                    $this->_request['lng'] = $language;
                } else {
                    unset($this->_request['lng']);
                }
            }
        }
    }

    function getRequestValue ($key, &$value)
    {
        if (!isset($this->_request[$key])) return false;

        $value = $this->_request[$key];

        return true;
    }

    function getQueryString ()
    {
        $query = "";
        $count = sizeof($this->_request);

        foreach ($this->_request as $key => $value)
        {
            if (is_array($value))
            {
                $query .= $key . "[]=" . $value[0];

                for ($i = 1; $i < sizeof($value); $i++)
                {
                    $query .= "&" . $key . "[]=" . $value[$i];
                }
            }
            else
            {
                $query .= "$key=$value";
            }

            if (--$count > 0) $query .= "&";
        }

        return $query;
    }
}

?>
