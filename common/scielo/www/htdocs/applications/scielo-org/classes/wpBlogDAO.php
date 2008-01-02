<?


require_once(dirname(__FILE__)."/wpBlog.php");
require_once(dirname(__FILE__)."/../users/DBClass.php");


class wpBlogDAO{

function wpBlogDAO(){
		$fileDef = parse_ini_file(dirname(__FILE__)."/../../../scielo.def");
		$DBparams["password"] = $fileDef["DB_USER_BLOG_PASSWORD"];
		$DBparams["db"] = $fileDef["DB_BLOG"];
		$DBparams["user"] = $fileDef["DB_USER_BLOG"];
		$DBparams["host"] = $fileDef["DB_HOST_BLOG"];
		$this->_db = new DBClass($DBparams);
}

function getBlogIdByName($acron){
	$acron = "/blog/".$acron."/";
	$strsql = "SELECT blog_id from wp_blogs where path='".$acron."'";
		$arr = $this->_db->databaseQuery($strsql);
		$blogId = $arr[0]["blog_id"];

		return $blogId;
	}


function getBlogByName($acron){
	$acron = "/blog/".$acron."/";
	$strsql = "SELECT blog_id from wp_blogs where path='".$acron."'";

		$arr = $this->_db->databaseQuery($strsql);

		if($arr){
			return true;
		}else{
			return false;
		}
	}
}
?>
