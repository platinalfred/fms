<?php 
/* $show_table_js = false;
require_once("lib/Shares.php"); */
require_once("lib/Libraries.php");
/* 
$start_date = isset($_POST['start_date'])?$_POST['start_date']:strtotime("-30 day");
$end_date = isset($_POST['end_date'])?$_POST['end_date']:time(); */
if(isset($_POST['group'])&& $_POST['group']=='view_members'){
	$memberObj = new Member();
	$members = $memberObj->findAll();
	$data['customers'] = $members;
	echo json_encode($data);
}

?>