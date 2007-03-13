<?php 
	ini_set("include_path",".");
	require_once(dirname(__FILE__)."/ArticleDAO.php");

	class Article {
	
		function Article(){
		
		}
		function setPID($value){
			$this->_data['pid'] = $value;
		}
		function getPID(){
			return $this->_data['pid'];
		} 
		function setPublicationDate($value){
			$this->_data['publication_date'] = $value;
		}
		function getPublicationDate(){
			return $this->_data['publication_date'];
		} 
		function setRelevance($value){
			$this->_data['relevance'] = $value;
		}
		function getRelevance(){
			return $this->_data['relevance'];
		} 
		
		function setURL($value){
			$this->_data['URL'] = $value;
		}
		function getURL(){
			return $this->_data['URL'];
		} 
		function setTitle($value, $lang=''){
			if ($lang){
				$this->_data['title'][$lang] = $value;
			} else {
				$this->_data['title'] = $value;
			}
		}
		function getTitle($lang=''){
			if ($lang){
				return $this->_data['title'][$lang];
			} else {
				return $this->_data['title'];
			}
		} 
		function setSerial($value){
			$this->_data['serial'] = $value;
		}
		function getSerial(){
			return $this->_data['serial'];
		} 
		function setVolume($value){
			$this->_data['vol'] = $value;
		}
		function getVolume(){
			return $this->_data['vol'];
		} 
		function setNumber($value){
			$this->_data['n'] = $value;
		}
		function getSuppl(){
			return $this->_data['s'];
		} 
		function setSuppl($value){
			$this->_data['s'] = $value;
		}
		function getNumber(){
			return $this->_data['n'];
		} 
		function setYear($value){
			$this->_data['year'] = $value;
		}
		function getYear(){
			return $this->_data['year'];
		} 
		function setAuthorXML($value){
			$this->_data['authorXML'] = mysql_escape_string($value);
		}
		function getAuthorXML(){
			return $this->_data['authorXML'];
		} 
		function setKeywordXML($value){
			$this->_data['keywordXML'] = mysql_escape_string($value);
		}
		function getKeywordXML(){
			return $this->_data['keywordXML'];
		}

		function articleExists(){
			$articleDAO = new ArticleDAO();
			$result = $articleDAO->getArticle($this->getPID());
			if($result->getPID()){
				return true;
			}else{
				return false;
			}
		}

		function addArticle(){
			if(!$this->articleExists()){
				$articleDAO = new ArticleDAO();
				$articleDAO->AddArticle($this);
			}
		}

		function getCitedList(){
			$articleDAO = new ArticleDAO();
			return($articleDAO->getCitedList($this));
		}

		function getAccessStatistics(){
			$articleDAO = new ArticleDAO();
			return($articleDAO->getAccessStatistics($this));
		}

		function loadArticle(){
			$articleDAO = new ArticleDAO();
			$a = $articleDAO->getArticle($this->getPID());

			$this->setPID($a->getPID());
			$this->setURL($a->getURL());
			$this->setTitle($a->getTitle());
			$this->setSerial($a->getSerial());
			$this->setVolume($a->getVolume());
			$this->setNumber($a->getNumber());
			$this->setSuppl($a->getSuppl());
			$this->setYear($a->getYear());
			$this->setAuthorXML($a->getAuthorXML());
			$this->setKeywordXML($a->getKeywordXML());
		}

	}
?>