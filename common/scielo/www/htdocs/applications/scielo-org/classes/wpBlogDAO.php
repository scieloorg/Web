<?


require_once(dirname(__FILE__)."/wpBlog.php");
require_once(dirname(__FILE__)."/../users/DBClassBlog.php");


class wpBlogDAO{

function wpBlogDAO(){
//		$fileDef = parse_ini_file(dirname(__FILE__)."/../../../scielo.def");
//		$DBparams["password"] = $fileDef["DB_USER_BLOG_PASSWORD"];
//		$DBparams["db"] = $fileDef["DB_BLOG"];
//		$DBparams["user"] = $fileDef["DB_USER_BLOG"];
//		$DBparams["host"] = $fileDef["DB_HOST_BLOG"];
//		$this->_db = new DBClass($DBparams);
		$this->_db = new DBClassBlog();
}

function getBlogIdByName($acron){
	$acron = "/".$acron."/";
	$strsql = "SELECT blog_id from wp_blogs where path='".$acron."'";

		$arr = $this->_db->databaseQuery($strsql);
		$blogId = $arr[0]["blog_id"];

		return $blogId;
	}


function getBlogByName($acron){
	$acron = "/".$acron."/";
	$strsql = "SELECT blog_id from wp_blogs where path='".$acron."'";

		$arr = $this->_db->databaseQuery($strsql);

		if($arr){
			return true;
		}else{
			return false;
		}
	}

function getCountCommentByPid($PID,$acron){

	$reacron = $this->getBlogIdByName($acron);

	if($reacron!=0){

	$strsql = "SELECT comment_count FROM wp_".$reacron."_posts WHERE post_name='".$PID."'";

		$arr = $this->_db->databaseQuery($strsql);

			if(!isset($arr[0]["comment_count"])){
					return '0';
				}else{
					return $arr[0]["comment_count"];
			}

			}else{
				return '0';
			}
	}



}
?>
