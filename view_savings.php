	<?php 
		$needed_files = array("iCheck", "knockout", "daterangepicker", "moment", "dataTables");
		$page_title = "Savings Accounts";
		include("include/header.php"); 
		require_once("lib/Libraries.php");
		require_once("savings_page.php");
		include("include/footer.php");
		include("js/depositAccount.php");
 ?>