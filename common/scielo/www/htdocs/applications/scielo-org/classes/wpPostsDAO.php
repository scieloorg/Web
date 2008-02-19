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

function addPost($post,$blogId){
	$strsql = "INSERT INTO wp_".$blogId."_posts (
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
		VALUES (".$post->getPostAuth().",'"
		.$post->getPostDate()."','"
		.$post->getPostDateGmt()."','"
		.$post->getPostContent()."','"
		.$post->getPostTitle()."',"
		.$post->getPostCategory().",'"
		.$post->getPostStatus()."','"
		.$post->getCommentStatus()."','"
		.$post->getPingStatus()."','"
		.$post->getPostName()."','"
		.$post->getPostGuid()."','"
		.$post->getPostModified()."','"
		.$post->getPostModifiedGmt()."',"
		.$post->getPostParent().","
		.$post->getMenuOrder().","
		.$post->getCommentCount().""
		.")";
		$result = $this->_db->databaseExecInsert($strsql);
		return $result;
		

	}

	function getLastComment($blogID,$commentID){
		$strsql = "SELECT comment_author,comment_content from wp_".$blogID."_comments where comment_ID=".$commentID;

		$arr = $this->_db->databaseQuery($strsql);

		return $arr;

	}

}
?>
