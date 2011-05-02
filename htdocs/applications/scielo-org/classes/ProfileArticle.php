<?php 
	class ProfileArticle {
		function getPID(){
			return $this->_data['pid'];
		}
		function setPID($value){
			$this->_data['pid'] = $value;
		}
		function getProfileID(){
			return $this->_data['profile_id'];
		}
		function setProfileID($value){
			$this->_data['profile_id'] = $value;
		}
		function getPublicationDate(){
			return $this->_data['publication_date'];
		}
		function setPublicationDate($value){
			$this->_data['publication_date'] = $value;
		}
		function getRelevance(){
			return $this->_data['relevance'];
		}
		function setRelevance($value){
			$this->_data['relevance'] = $value;
		}
		function getIsNew(){
			return $this->_data['new'];
		}
		function setIsNew($value){
			$this->_data['new'] = $value;
		}
	}
?>
