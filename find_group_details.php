<?php 
require_once("lib/Libraries.php");
$sacco_group = new SaccoGroup();
$person = new Person();
$data = array();
if(isset($_GET['id'])){
	$gid = $_GET['id']; //person id
	$data['group_members'] = $sacco_group->findGroupMembers($gid);
}
echo json_encode($data);
?>