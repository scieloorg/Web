<?php

	function getFromCache($key){
		$ini = parse_ini_file('scielo.def',true);
		$memcache = new Memcache;
		$memcache->connect($ini['CACHE']['SERVER_CACHE'],$ini['CACHE']['SERVER_PORT_CACHE']);
		$result = $memcache->get($key);
		$memcache->close();
		return $result;
	}


	function addToCache($key,$content){
			$ini = parse_ini_file('scielo.def',true);
			$memcache = new Memcache;
			$memcache->connect($ini['CACHE']['SERVER_CACHE'],$ini['CACHE']['SERVER_PORT_CACHE']);
			$result = $memcache->add($key,$content);
			$memcache->close();
	return $result;
	}

	function deleteFromCache($key){
			$ini = parse_ini_file('scielo.def',true);
			$memcache = new Memcache;
			$memcache->connect($ini['CACHE']['SERVER_CACHE'],$ini['CACHE']['SERVER_PORT_CACHE']);
			$result = $memcache->delete($key,10);
			$memcache->close();
			if($result)
				return 'OK';
			else
				return 'ERROR';
	}

	function getStatsFromCache($type='sizes', $slabib=null, $limit=100){
		$ini = parse_ini_file('scielo.def',true);
		$memcache = new Memcache;
		$memcache->connect($ini['CACHE']['SERVER_CACHE'],$ini['CACHE']['SERVER_PORT_CACHE']);
		if($slabib != null){
			$arr = $memcache->getExtendedStats($type,$slabid,$limit);
		}else{
			$arr = $memcache->getExtendedStats($type);
		}
		$saida = '';
		$arr = array_pop($arr);
		$saida .= '<table border="1">';
			foreach($arr as $key => $value){
				$saida .= '<tr>';
				$saida .= '<td>'.$key.'</td>';
				if(is_array($value)){
					$saida .= '<td><table border="1">';
					foreach($value as $k=>$v){
						$saida .= '<tr>';
						$saida .= '<td>'.$k.'</td>';
						$saida .= '<td>'.$v.'</td>';
						$saida .= '</tr>';
					}
					$saida .= '</table></td>';
				}else{
					$saida .= '<td>'.$value.'</td>';
				}
				$saida .= '</tr>';
			}
		$saida .= '</table>';
		$memcache->close();
		return $saida;
	}


?>
