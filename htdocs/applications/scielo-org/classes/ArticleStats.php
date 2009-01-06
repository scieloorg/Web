<?php 
	class ArticleStats {
	
	
		function ArticleStats(){
		
		}
		function setStartDate($value){
			$this->_data['start_date'] = $value;
		}
		function getStartDate(){
			return $this->_data['start_date'];
		} 
		function setCurrentDate($value){
			$this->_data['current_date'] = $value;
		}
		function getCurrentDate(){
			return $this->_data['current_date'];
		} 
		function setRequests($value){
			$this->_data['requests'] = $value;
		}
		function getRequests(){
			return $this->_data['requests'];
		} 
		function setPID($value){
			$this->_data['pid'] = $value;
		}
		function getPID(){
			return $this->_data['pid'];
		}
	}
?>