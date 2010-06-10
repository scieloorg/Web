<?php
/*********************************************************
*
* Classe do objeto posts
*
**********************************************************/

require_once(dirname(__FILE__)."/wpPostsDAO.php");

class wpPosts{

	function wpPosts(){
	
	}	
	
	function setID($value){
		$this->_data['id'] = $value;
	}
	function getID(){
		return $this->_data['id'];
	} 
	function setPostName($value){
		$this->_data['postName'] = $value;
	}
	function getPostName(){
		return $this->_data['postName'];
	}	
	function setPostGuid($value){
		$this->_data['postGuide'] = $value;
	}
	function getPostGuid(){
		return $this->_data['postGuide'];
	}
	function setPostDate($value){
		$this->_data['postDate'] = $value;
	}
	function getPostDate(){
		return $this->_data['postDate'];
	} 
	function setPostTitle($value){
		$this->_data['postTitle'] = $value;
	}
	function getPostTitle(){
		return $this->_data['postTitle'];
	}
	function setPostAuth($value){
		$this->_data['postAuth'] = $value;
	}
	function getPostAuth(){
		return $this->_data['postAuth'];
	}
	function setPostDateGmt($value){
		$this->_data['postDateGmt'] = $value;
	}
	function getPostDateGmt(){
		return $this->_data['postDateGmt'];
	}
	function setPostContent($value){
		$this->_data['postContent'] = $value;
	}
	function getPostContent(){
		return $this->_data['postContent'];
	}
	function setPostCategory($value){
		$this->_data['postCategory'] = $value;
	}
	function getPostCategory(){
		return $this->_data['postCategory'];
	}
	function setPostStatus($value){
		$this->_data['postStatus'] = $value;
	}
	function getPostStatus(){
		return $this->_data['postStatus'];
	}
	function setPingStatus($value){
		$this->_data['pingStatus'] = $value;
	}
	function getPingStatus(){
		return $this->_data['pingStatus'];
	}
	function setPostModified($value){
		$this->_data['postModified'] = $value;
	}
	function getPostModified(){
		return $this->_data['postModified'];
	}
	function setPostModifiedGmt($value){
		$this->_data['postModifiedGmt'] = $value;
	}
	function getPostModifiedGmt(){
		return $this->_data['postModifiedGmt'];
	}
	function setPostParent($value){
		$this->_data['postParent'] = $value;
	}
	function getPostParent(){
		return $this->_data['postParent'];
	}
	function setMenuOrder($value){
		$this->_data['menuOrder'] = $value;
	}
	function getMenuOrder(){
		return $this->_data['menuOrder'];
	}
	function setCommentCount($value){
		$this->_data['commentCount'] = $value;
	}
	function getCommentCount(){
		return $this->_data['commentCount'];
	}
	function setCommentStatus($value){
		$this->_data['commentStatus'] = $value;
	}
	function getCommentStatus(){
		return $this->_data['commentStatus'];
	}

}//end class
?>