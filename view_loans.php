<?php 
	$needed_files = array("iCheck", "knockout","datamask",  "daterangepicker", "moment", "select2", "dataTables", "datepicker");
	$page_title = "Loan Accounts";
	include("include/header.php"); 
	require_once("lib/Libraries.php");
	require_once("loans_page.php");
	include("include/footer.php");
	require_once("js/loanAccount.php");
 ?>