<?php 
	class ArticleRequests {
	
		function ArticleRequests(){
		
		}
		function setLang($value){
			$this->_data['lang'] = $value;
		}
		function getLang(){
			return $this->_data['lang'];
		} 
		function setNumberOfRequests($value){
			$this->_data['req'] = $value;
		}
		function getNumberOfRequests(){
			return $this->_data['req'];
		} 
		function setYear($value){
			$this->_data['year'] = $value;
		}
		function getYear(){
			return $this->_data['year'];
		} 
		function setMonth($value){
			$this->_data['month'] = $value;
		}
		function getMonth(){
			return $this->_data['month'];
		} 
	}
?>