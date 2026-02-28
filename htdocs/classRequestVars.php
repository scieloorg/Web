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
        global $HTTP_GET_VARS, $HTTP_POST_VARS, $REQUEST_URI, $SCRIPT_NAME;

        if (strpos($REQUEST_URI, "?") === false)
        {
            $QSCnav = $REQUEST_URI;
            $QSCscript = $SCRIPT_NAME;
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

            $this->_request = array_merge($HTTP_GET_VARS, $HTTP_POST_VARS, $QSCArray);
        }
        else
        {
            $this->_request = array_merge($HTTP_GET_VARS, $HTTP_POST_VARS);
        }

        if (!isset($this->_request['lng']) || strpos("|en|pt|es|", $this->_request['lng']) == 0) {
            $this->_request['lng'] = "en";
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
