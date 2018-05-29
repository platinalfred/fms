<?php 
/* $show_table_js = false;
require_once("lib/Shares.php"); */
require_once("../lib/Libraries.php");
/* 
$start_date = isset($_POST['start_date'])?$_POST['start_date']:strtotime("-30 day");
$end_date = isset($_POST['end_date'])?$_POST['end_date']:time(); */
if(isset($_POST['group'])&& $_POST['group']=='view_members'){
	$memberObj = new Member();
	$where = "";
	if(isset($_POST['groupId'])&&is_numeric($_POST['groupId'])){
		$where = "`member`.`id` NOT IN (SELECT `memberId` FROM `group_members` WHERE `groupId` = {$_POST['groupId']})";
	}
	$members = $memberObj->findAll($where);
	$data['customers'] = $members;
	echo json_encode($data);
}