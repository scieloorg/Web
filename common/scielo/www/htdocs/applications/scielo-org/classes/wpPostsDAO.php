<?

/*******************************************
*
*
*
*******************************************/

require_once(dirname(__FILE__)."/wpPosts.php");
require_once(dirname(__FILE__)."/../users/DBClass.php");


class wpPostsDAO{

function wpPostsDAO(){
		$DBparams["password"] = "batalha";
		$DBparams["db"] = "blog";
		$DBparams["user"] = "fabio";
		$DBparams["host"] = "localhost";
		$this->_db = new DBClass($DBparams);
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

}
?>