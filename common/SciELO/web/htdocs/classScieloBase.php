<?php
include ("classRequestVars.php");
include ("class.ScieloTransformer.php");
include ("classDefFile.php");

define("HOST_PORTS_FILE", "ports");

class ScieloBase
{
	// ------------------------------------------------------------------------------------------
	// ------------------------------   Private Data Members   ----------------------------------
	// ------------------------------------------------------------------------------------------

	var $_host = "",
		$_xml = "",
		$_xsl = "",
        $_method = "GET",           // default method GET

		$_homepg = "sci_home";		// default home page script
	var $_param = "";               // default parameters for home page script

	// ------------------------------------------------------------------------------------------
	// -----------------------------   Protected Data Members   ---------------------------------
	// ------------------------------------------------------------------------------------------
	var $_script = "",
        $_deffile = "scielo.def",	// default def file name
        $_debug = "",
		$_def = null,
        $_request = null;

	// ------------------------------------------------------------------------------------------
	// --------------------------------     Constructor     -------------------------------------
	// ------------------------------------------------------------------------------------------

	function ScieloBase ($host)
	{
        $this->_request = new RequestVars ();
		$this->_host = $this->_GetHostNamePort($host);

		// Gets deffile name and homepage script name
		$this->_GetInfoByHost();

        if ( !$this->_request->getRequestValue ("script", $this->_script) ) $this->_script = $this->_homepg;
        $this->_request->getRequestValue ("debug", $this->_debug);
        $this->_debug = strtoupper ($this->_debug);

		// Create a DefFile object to gather information from def file
		$this->_SetDefFileObject();
	}

	// ------------------------------------------------------------------------------------------
	// ----------------------------------   Protected Methods   -----------------------------------
	// ------------------------------------------------------------------------------------------

	/***************************************************************************************
	    Protected Method _GetInfoByHost()

    	Reads "ports" file to obtain the name of the def file and home page, according to
		the http host parameter. Each line represents a new record. Lines beginning with "#"
		are commented (not parsed). The format of the lines is as follows:

		Http-host DefFile HomePage

		eg:
		www.somewhere.org:9090    deffile.def    home

		The Http-Host, DefFile name and HomePage must be separated by spaces or tabs.

		Case the Http-Host is not found in "ports" file uses default DefFile name and
		HomePage.

		Parameters:
			NONE

		Return Value:
			NONE

		Last Change:
			19/06/2001 (Roberto)
	***************************************************************************************/
	function _GetInfoByHost()
	{
		@$ports = file(HOST_PORTS_FILE);

		if ( !is_array($ports) )
		{
			// Coudn't read file. Use defaults.
			return;
		}

		$count = count($ports);

		for ( $i = 0; $i < $count; $i++ )
		{
			if ( !ereg ("^#.*", $ports[$i]) )
			{
				// This line is not a comment
				list ($host_entry, $def_entry, $homepg_entry, $querystr_entry) = split ( "[ \t]+", trim($ports[$i]) );

				if ( $this->_GetHostNamePort($host_entry) == $this->_host)
				{
					// Host found
					if ($def_entry)
					{
						// Def file entry is set
						$this->_deffile = $def_entry;
					}
					if ($homepg_entry)
					{
						// Home page entry is set
						$this->_homepg = $homepg_entry;
					}
					if ($querystr_entry)
					{
						// Default query string for home page is set
						$this->_param = $querystr_entry;
					}
					return;
				}
			}
		}
	}

	/************************************************************************
		Protected Method _GetHostNamePort()

		Converts an ip address :port pair into an host name :port pair.

		Parameter:
			$host - contain the ip address to be converted

		Return value:
			Host name

		Last Change:
			19/06/2001 (Roberto)
	*************************************************************************/
	function _GetHostNamePort($host)
	{
		if ( ereg("([0-9]+\.[0-9]+\.[0-9]+\.[0-9]+)(\:[0-9]+)?", $host, $regs) )
		{
			// If http-host is an ip address (port number is permitted)
			$host = gethostbyaddr($regs[1]) . ( $regs[2] ? "$regs[2]" : "" );
		}

		return strtolower($host);
	}


	/************************************************************************
		Protected Method _SetDefFileObject()

		Create an DefFile based on the deffile and sets some properties.
		Exits script on error.

		Parameter:
			NONE

		Return value:
			NONE

		Last Change:
			19/06/2001 (Roberto)
	*************************************************************************/
	function _SetDefFileObject()
	{
		$this->_def = new DefFile($this->_deffile);

		if ($this->_def->_error)
		{
			echo "Error opening file $this->_deffile<br>\n";
			exit;
		}
	}

	/************************************************************************
		Protected Method _CheckBypassTransformer()

		Checks if the transformer must be bypassed and the generated page
		must be shown directly

		Parameter:
			NONE

		Return value:
			boolean true: Transformation must be bypassed
			boolean false: Transformation must be executed

		Last Change:
			19/06/2001 (Roberto)
	*************************************************************************/
	function _CheckBypassTransformer()
	{
		if ( (!$this->_debug || $this->_debug == 'VERIFICA') && ($this->_script != 'sci_verify') )
		{
			return false;
		}

		return true;
	}

	/************************************************************************
		Protected Method _BypassTransformer()

		If debug is xml then shows the xml file in a textarea. Otherwise,
		shows the corresponding html page directly.

		Parameter:
			NONE

		Return value:
			NONE

		Last Change:
			19/06/2001 (Roberto)
	*************************************************************************/
	function _BypassTransformer()
	{
	
		$fd = fopen ($this->_xml,"r"); 

		if (!$fd) { 
			echo "<br><b>Could not open url:</b> [".$this->_xml."]\n<br>";
			return;
		} 
	
		//$buf = fread($fd,2000000);
		while (!feof($fd)){
				$buf .= fgets ($fd, 4096);
			}

		fclose($fd);

		if ($this->_debug == 'XML')
		{
			echo "<form>\n";
			echo "<b>Generated XML</b><br>\n";
			echo "<TEXTAREA cols=80 rows=20>\n";
	        echo $buf;
			echo "\n</TEXTAREA>\n</form>";

			echo "<b>\$xml</b>=$this->_xml<br>\n";
			echo "<b>\$xsl</b>=$this->_xsl<br>\n";
		}
		else
		{
			echo $buf;
		}
	}

	/************************************************************************
		Protected Method _CheckMaintenance()

		Checks if the maintenance flag is setted.

		Parameter:
			NONE

		Return value:
			boolean (Flag setted - true/ unsetted - false)

		Last Change:
			19/06/2001 (Roberto)
	*************************************************************************/
	function _CheckMaintenance()
	{
		$dbpath = $this->_def->getKeyValue("PATH_DATABASE");
		$ctrlpath = $dbpath . "control.def";

		$control = new DefFile($ctrlpath);

		if (!$control->_error)
		{
		    if ($control->getKeyValue("MAINTENANCE"))
    		{
				return true;
    		}
		}

		return false;
	}

	/************************************************************************
		Protected Method _MaintenancePage()

		Shows the maintenance page according the language.

		Parameter:
			NONE

		Return value:
			NONE

		Last Change:
			19/06/2001 (Roberto)
	*************************************************************************/
	function _MaintenancePage()
	{
                $newPage = "maintain.php?" . $this->_request->getQueryString();

		if ( !$this->_request->getRequestValue ( "lng", $lng ) )
                {
                    $lng = $this->_def->getKeyValue ( "STANDARD_LANG" );
                    $newPage = $newPage . "&lng=" . $lng;
                }
// echo $newPage;
		header ("Location: " . $newPage );
		exit;
	}

	/************************************************************************
		Protected Method _Transform()

		Applies xslt transformation in xml file.

		Parameters:
			NONE

		Return value:
			NONE

		Last Change:
			10/08/2001 (Roberto)
	*************************************************************************/
	function _Transform()
	{
        $result = "";

		// Apply transformer in xml
		$transform = new ScieloXMLTransformer();
		$transform->setXslBaseUri("file://" . $this->_def->getKeyValue("PATH_XSL"));
        $transform->SetPreferedMethod ($this->_method);

		if($transform->setXsl($this->_xsl))
		{
   			if($transform->setXml($this->_xml))
			{

    	 		$transform->transform();

				if ($transform->getError() == 0)
				{
					if (getenv("ENV_SOCKET")=="true"){  //socket
						$result = $transform->getOutput();
					}
					else{
						$result = utf8_decode($transform->getOutput());
					}
	      			}
				else
				{
	   				$result = "<p>Error transforming ".$this->_xml.".</p>\n";
				}
			}
			else
			{
    			$result =  "<p>".$this->_xml.": ".$transform->getError()."</p>\n";
			}
		}

		$transform->destroy();

        return $result;
	}

	/************************************************************************
		Protected Method _CheckAlternateDisplay()

		Checks if there is a need to display an alternative (maintainance/result)
        page to the user.

		Parameters:
			NONE

		Return value:
			NONE

		Last Change:
			10/08/2001 (Roberto)
	*************************************************************************/
    function _CheckAlternateDisplay()
    {
		if ( !$this->_xml)
		{
			echo "XML is not setted.<br>\n";
			exit;
		}

		if ( !$this->_xsl )
		{
			echo "XSL is not setted.<br>\n";
			exit;
		}

		if ( $this->_CheckMaintenance() )
		{
			$this->_MaintenancePage ();
			exit;
		}

		if ( $this->_CheckBypassTransformer() )
		{
			$this->_BypassTransformer($this->_xml);
			exit;
		}
    }
	// ------------------------------------------------------------------------------------------
	// ---------------------------------   Public Methods   -------------------------------------
	// ------------------------------------------------------------------------------------------

	// This method is virtual
	function GenerateXmlUrl()
	{
		$xml = "";
		return $xml;
	}

	// This method is virtual
	function GenerateXslUrl()
	{
		$xsl = "";
		return $xsl;
	}

	/***************************************************************************************
	    Public Method ShowPage()

		Shows transformed page or maintenance page or bypass transformation. Xml url and Xsl
		url must be presset by SetXMLUrl() and SetXSLUrl() functions.

		Parameters:
			NONE

		Return Value:
			NONE

		Last Change:
			10/08/2001 (Roberto)
	***************************************************************************************/
	function ShowPage ()
	{
    	$this->_CheckAlternateDisplay ();
		echo $this->_Transform ();
	}
	//fixed 20041004
	function getPage ()
	{
    	$this->_CheckAlternateDisplay ();
		$page = $this->_Transform ();
		return $page;
	}

	// ------------------------------------------------------------------------------------------
	// --------------------   Public AcessorsMethods (Get/Set Properties) -----------------------
	// ------------------------------------------------------------------------------------------

    function SetPreferedMethod($method)
    {
        $this->_method = strtoupper($method);
    }

    function GetPreferedMethod()
    {
        return $this->_method;
    }

	function SetXMLUrl($xml)
	{
		$this->_xml = $xml;
	}

	function GetXMLUrl()
	{
		return $this->_xml;
	}

	function SetXSLUrl($xsl)
	{
		$this->_xsl = $xsl;
	}

	function GetXSLUrl()
	{
		return $this->_xsl;
	}
}

?>
