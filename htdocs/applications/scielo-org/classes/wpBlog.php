<?php
/*********************************************************
*
* Classe do objeto blog
*
**********************************************************/

require_once(dirname(__FILE__)."/wpBlogDAO.php");

class wpBlog{

	function wpBlog(){
	
	}	
	
	function setID($value){
		$this->_data['id'] = $value;
	}
	function getID(){
		return $this->_data['id'];
	} 
	function setPath($value){
		$this->_data['path'] = "/blog/".$value."/";
	}
	function getPath(){
		return $this->_data['path'];
	}	

}//end class
?>