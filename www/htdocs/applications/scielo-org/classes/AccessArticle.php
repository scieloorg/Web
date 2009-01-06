<?php 
	class AccessArticle {
	
		function AccessArticle(){
			$pid = null;
			$date = null;
			$count = 0;
		}
		function setPID($value){
			$this->pid = $value;
		}
		function getPID(){
			return $this->pid;
		} 
		function setDate($value){
			$this->date = $value;
		}
		function getDate(){
			return $this->date;
		}
		function setCount($value){
			$this->count = $value;
		}
		function getCount(){
			return $this->count;
		} 
	}
?>