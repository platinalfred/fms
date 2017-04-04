<?php 
require_once("lib/Db.php");
$db = new Db();
if(isset($_POST)){
	if($db->getLogin($_POST['username'], $_POST['password'])){
		echo "success";
	}else{
		echo "Incorrect Username/Password.";
	}
	
}
?>