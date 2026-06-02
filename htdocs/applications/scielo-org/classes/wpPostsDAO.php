<?
require_once(dirname(__FILE__)."/wpPosts.php");
require_once(dirname(__FILE__)."/../users/DBClassBlog.php");

class wpPostsDAO{

function wpPostsDAO(){
	
//	$fileDef = parse_ini_file(dirname(__FILE__)."/../../../scielo.def.php");
//		$DBparams["password"] = $fileDef["DB_USER_BLOG_PASSWORD"];
//		$DBparams["db"] = $fileDef["DB_BLOG"];
//		$DBparams["user"] = $fileDef["DB_USER_BLOG"];
//		$DBparams["host"] = $fileDef["DB_HOST_BLOG"];
//		$this->_db = new DBClass($DBparams);
		$this->_db = new DBClassBlog();
}

function __construct(){
	$this->wpPostsDAO();
}

function sqlText($value){
	return mysql_real_escape_string($value, $this->_db->_conn);
}

function sqlInt($value){
	return intval($value);
}

function addPost($post,$blogId){
	$strsql = "INSERT INTO wp_".$this->sqlInt($blogId)."_posts (
		post_author,
		post_date, 
		post_date_gmt, 
		post_content, 
		post_title, 
		post_category, 
		post_status, 
		comment_status, 
		ping_status,
		post_name,
		guid,
		post_modified,
		post_modified_gmt,
		post_parent,
		menu_order,
		comment_count
		) 
		VALUES (".$this->sqlInt($post->getPostAuth()).",'"
		.$this->sqlText($post->getPostDate())."','"
		.$this->sqlText($post->getPostDateGmt())."','"
		.$this->sqlText($post->getPostContent())."','"
		.$this->sqlText($post->getPostTitle())."',"
		.$this->sqlInt($post->getPostCategory()).",'"
		.$this->sqlText($post->getPostStatus())."','"
		.$this->sqlText($post->getCommentStatus())."','"
		.$this->sqlText($post->getPingStatus())."','"
		.$this->sqlText($post->getPostName())."','"
		.$this->sqlText($post->getPostGuid())."','"
		.$this->sqlText($post->getPostModified())."','"
		.$this->sqlText($post->getPostModifiedGmt())."',"
		.$this->sqlInt($post->getPostParent()).","
		.$this->sqlInt($post->getMenuOrder()).","
		.$this->sqlInt($post->getCommentCount()).""
		.")";
		$result = $this->_db->databaseExecInsert($strsql);

		$this->_db->fechaConexao();
		return $result;
		

	}

	function getLastComment($blogID,$commentID){
		$strsql = "SELECT comment_author,comment_content from wp_".$this->sqlInt($blogID)."_comments where comment_ID=".$this->sqlInt($commentID);

		$arr = $this->_db->databaseQuery($strsql);

		$this->_db->fechaConexao();

		return $arr;

	}

}
?>
