<?


require_once(dirname(__FILE__)."/wpBlog.php");
require_once(dirname(__FILE__)."/../users/DBClass.php");


class wpBlogDAO{

function wpBlogDAO(){
		$DBparams["password"] = "batalha";
		$DBparams["db"] = "blog";
		$DBparams["user"] = "fabio";
		$DBparams["host"] = "localhost";
		$this->_db = new DBClass($DBparams);
}

function getBlogIdByName($acron){
	$acron = "/blog/".$acron."/";
	$strsql = "SELECT blog_id from blog.wp_blogs where path='".$acron."'";

		$arr = $this->_db->databaseQuery($strsql);
		$blogId = $arr[0]["blog_id"];

		return $blogId;
	}


function getBlogByName($acron){
	$acron = "/blog/".$acron."/";
	$strsql = "SELECT blog_id from blog.wp_blogs where path='".$acron."'";

		$arr = $this->_db->databaseQuery($strsql);

		if($arr){
			return true;
		}else{
			return false;
		}
	}
}
?>