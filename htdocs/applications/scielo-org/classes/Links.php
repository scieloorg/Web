<?php 
	ini_set("include_path",".");
	require_once(dirname(__FILE__)."/LinksDAO.php");

	define("PAGE_SIZE",3);

	class Links {
	
		function setLink_id($value){
			$this->_data['link_id'] = $value;
		}
		function getLink_id(){
			return $this->_data['link_id'];
		}
		function setUser_id($value){
			$this->_data['user_id'] = $value;
		}
		function getUser_id(){
			return $this->_data['user_id'];
		} 
		function setName($value){
			$this->_data['name'] = $value;
		}
		function getName(){
			return $this->_data['name'];
		}
		function setUrl($value){
			$this->_data['url'] = $value;
		}
		function getUrl(){
			return $this->_data['url'];
		}
		function setDescription($value){
			$this->_data['description'] = $value;
		}
		function getDescription(){
			return $this->_data['description'];
		} 
		function setInHome($value){
			$this->_data['in_home'] = $value;
		}
		function getInHome(){
			return $this->_data['in_home'];
		}
		function setRate($value){
			$this->_data['rate'] = $value;
		}
		function getRate(){
			return $this->_data['rate'];
		}

		function linkExists(){
			$linkDAO = new LinksDAO();
			$result = $linkDAO->linkExist($this);
			if($result){
				return true;
			}else{
				return false;
			}
		}

		function addLink(){
			if(!$this->linkExists()){
				$linkDAO = new LinksDAO();
				$linkDAO->AddLink($this);
			}
		}

		function loadLink(){
			$linkDAO = new LinksDAO();
			$a = $linkDAO->getLink($this->getPID());

			$this->setLink_id($a->getLink_id());
			$this->setUser_id($a->getUser_id());
			$this->setName($a->getName());
			$this->setUrl($a->getUrl());
			$this->setDescription($a->getDescription());
			$this->setInHome($a->getInHome());
			$this->setRate($a->getRate());
		}
		
		function getTotalPages($itensPerPage = PAGE_SIZE){
		    $linkDAO = new LinksDAO();
		    $total = $linkDAO->getTotalItens($this);
		    return ceil ($total/$itensPerPage);
		}
		
		function getLinkList($page,$params){
			$linkDAO = new LinksDAO();
			$count = PAGE_SIZE;
			$from = $count * $page;
			return $linkDAO->getLinkList($this,$from,$count,$params);
		}

		function getInHomeLinks(){
			$linkDAO = new LinksDAO();
			$linkList = $linkDAO->getInHomeLinks($this);
			return $linkList;
		}

		function getLink(){
			$linkDAO = new LinksDAO();
			$linkItem = $linkDAO->getLink($this);
			return $linkItem;
		}
		
		function updateLink(){
			$linkDAO = new LinksDAO();
			$result = $linkDAO->updateLink($this);
			return $result;
		}
		
		function updateLinkRate(){
			$linkDAO = new LinksDAO();
			$result = $linkDAO->UpdateLinkRate($this);
			return $result;
		}
		
		function removeLink(){
			$linkDAO = new LinksDAO();
			$result = $linkDAO->removeLink($this);
			return $result;
		}
		
		function deleteFromHome(){
			$linkDAO = new LinksDAO();
			$result = $linkDAO->deleteFromHome($this);
			return $result;
		}

		function addInHome(){
			$linkDAO = new LinksDAO();
			$result = $linkDAO->addInHome($this);
			return $result;
		}

	}
?>
