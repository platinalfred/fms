	<?php 
		$needed_files = array("iCheck", "knockout","headerdaterangepicker", "daterangepicker", "moment", "dataTables", "select2");
		$page_title = "Savings Accounts";
		include("include/header.php"); 
		require_once("lib/Libraries.php");
		require_once("savings_page.php");
		include("include/footer.php");
		include("js/depositAccount.php");
 ?>