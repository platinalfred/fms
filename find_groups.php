<?php 
/* $show_table_js = false;
require_once("lib/Shares.php"); */
require_once("lib/Libraries.php");
/* 
$start_date = isset($_POST['start_date'])?$_POST['start_date']:strtotime("-30 day");
$end_date = isset($_POST['end_date'])?$_POST['end_date']:time(); */
if ( isset($_POST['page']) && $_POST['page'] == "view_group" ) {
	$sacco_group = new SaccoGroup();
	$all_sacco_grp = $sacco_group->findAll();
	$data['data'] = $all_sacco_grp;
	echo json_encode($data);
}

?>