<?php 
	ini_set("include_path",".");
	require_once(dirname(__FILE__)."/UserDirectoryDAO.php");

	class UserDirectory {
	
		function setDirectory_id($value){
			$this->_data['directory_id'] = $value;
		}
		function getDirectory_id(){
			return $this->_data['directory_id'];
		} 
		function setName($value){
			$this->_data['name'] = $value;
		}
		function getName(){
			return $this->_data['name'];
		} 
		function setOffline($value){
			$this->_data['offline'] = $value;
		}
		function getOffline(){
			return $this->_data['offline'];
		} 
		function setUser_id($value){
			$this->_data['user_id'] = $value;
		}
		function getUser_id(){
			return $this->_data['user_id'];
		}

		function directoryExists(){
			$directoryDAO = new DirectoryDAO();
			$result = $directoryDAO->directoryExist($this);
			if($result){
				return true;
			}else{
				return false;
			}
		}

		function addDirectory(){
			if(!$this->directoryExists()){
				$directoryDAO = new DirectoryDAO();
				$directoryDAO->AddDirectory($this);
			}
		}

		function loadDirectory(){
			$directoryDAO = new DirectoryDAO();
			$a = $directoryDAO->getDirectory($this->getPID());

			$this->setDirectory_id($a->getDirectory_id());
			$this->setName($a->getName());
			$this->setOffline($a->getOffiline());
			$this->setUser_id($a->getUser_id());
		}
		
		function getDirectoryList(){
			$directoryDAO = new DirectoryDAO();
			$directoryList = $directoryDAO->getDirectoryList($this);
			return $directoryList;
		}

		function getDirectory(){
			$directoryDAO = new DirectoryDAO();
			$directoryItem = $directoryDAO->getDirectory($this);
			return $directoryItem;
		}
		
		function updateDirectory(){
			$directoryDAO = new DirectoryDAO();
			$result = $directoryDAO->updateDirectory($this);
			return $result;
		}
		
		function removeDirectoryFromShelf(){
			$directoryDAO = new DirectoryDAO();
			$result = $directoryDAO->removeDirectoryFromShelf($this);
			return $result;
		}

	}
?>