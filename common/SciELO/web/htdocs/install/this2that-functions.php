<?php

function showArgsSyntax ( )
{

	$usage = "
Usage: this2that.php [<options>] <parameters>
	
Options: [-ifn] [-R] [-t] [-v]
	-ifn = ignore case (file name) - mostly useful for WINDOWS platform
	-R = recursive folder
	-t = test list of files
	-v = version number
	
Parameters: [dir=<directory>] file=<file> find=<text> replace=<text>
	dir = directory specification
	file = file name specification (accepts wildcards)
	find = text to be find in each file
	replace = text to replace text found in each file
	
";

	return $usage;
}

function translatePattern ( $pattern )
{
	$translated = "^" . $pattern;
	$translated = str_replace(".","\.",$translated);
	$translated = str_replace("*",".*",$translated);
	$translated = str_replace("?",".",$translated);
	return $translated;
}

function showResult ( $file, $isReadable, $isWritable, $bytesWritten, $test_only )
{
	$message = "";

	$message .= $isReadable ? 'r' : '-';
	$message .= $isWritable ? 'w' : '-';
	$message .= " ";
	$message .= $file;
	if ( !$test_only )
	{
		$message .= " (" . $bytesWritten . " bytes written)";
	}
	$message .= "\r\n";

	return $message;
}

function getFileContent ( $file )
{
	$fp = fopen($file,"r");
	if ( $fp )
	{
		$fileContent = fread($fp,filesize($file));
	}
	fclose($fp);

	return $fileContent;
}

function putFileContent ( $file, $fileContent )
{
	$fp = fopen($file,"w");
	if ( $fp )
	{
		$bytesWritten = fwrite($fp,$fileContent);
	}
	fclose($fp);

	return $bytesWritten;
}

function findReplace ( $file, $find, $replace, $test_only )
{
	$isReadable = is_readable($file);
	$isWritable = is_writable($file);
	$bytesWritten = 0;
	
	if ( $isWritable )
	{
		$fileContent = getFileContent($file);
		$fileContent = str_replace($find,$replace,$fileContent);
		if ( !$test_only )
		{
			$bytesWritten = putFileContent($file,$fileContent);
		}
	}

	return showResult($file,$isReadable,$isWritable,$bytesWritten,$test_only);
}

function listDir ( $dir, $filePattern, $find, $replace, $ignore_case, $recursive_folder, $test_only )
{
	$message = "";
	$isReadable = is_readable($dir);
	$isWritable = is_writable($dir);
//	if ( !$isReadable || !$isWritable )
	if ( !$isReadable )
	{
		return showResult(realpath($dir),$isReadable,$isWritable,0,$test_only);
	}

	$dirP = @opendir($dir);
	if ( !$dirP )
	{
		return "";
	}
	do {
		$entry = readdir($dirP);
		if ( $entry )
		{
			$dirList[] = $entry;
		}
	} while ( $entry );
	closedir($dirP);

	foreach ( $dirList as $entry )
	{
		if ( $recursive_folder )
		{
			$callPath = realpath($dir . "/" . $entry);
			if ( is_dir($callPath) )
			{
				if ( $entry != "." && $entry != ".." )
				{
					$message .= listDir($dir . "/" . $entry,$filePattern,$find,$replace,$ignore_case,$recursive_folder,$test_only);
				}
			}
		}
		if ( is_file($dir . "/" . $entry) )
		{
			if ( $ignore_case )
			{
				$fileMatch = eregi($filePattern,$entry);
			}
			else
			{
				$fileMatch = ereg($filePattern,$entry);
			}
			if ( $fileMatch )
			{
				$replaceFile = realpath($dir . "/" . $entry);
				$message .= findReplace($replaceFile,$find,$replace,$test_only);
			}
		}
	}

	return $message;
}

function this2that ( $dir, $file, $find, $replace, $options )
{
	$message = "";
	$ignore_case = false;
	$recursive_folder = false;
	$test_only = false;

	foreach ($options as $value)
	{
		switch ($value)
		{
		case "-ifn":
			$ignore_case = true;
			break;
	   case "-R":
			$recursive_folder = true;
			break;
   	case "-t":
			$test_only = true;
			break;
   	case "-v":
			exit("0.4");
			break;
		}
	}
	
	if ( !isset($file) || !isset($find) || !isset($replace) )
	{
		return showArgsSyntax();
	}
	$file = trim($file);
	if ( $file == "" )
	{
		exit("Invalid file specification!");
	}
	
	if ( !isset($dir) )
	{
		$dir = getcwd();
	}
	$dir = realpath($dir);
	if ( !file_exists($dir) )
	{
		exit("Invalid directory: \"" . $dir . "\"\n");
	}
	
	$filePattern = translatePattern($file);

	$message .= listDir($dir,$filePattern,$find,$replace,$ignore_case,$recursive_folder,$test_only);

	return $message;
}

?> 
