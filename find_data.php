<?php
require_once("lib/Libraries.php");
require_once("lib/DatatablesJSON.php");

// Create instance of DataTable class
$data_table = new DataTable();
$primary_key = $columns = $table = $where = $group_by = "";
if ( isset($_POST['page']) && $_POST['page'] == "view_expenses" ) {
	//SELECT expenseName, amountUsed,staff_names, amountDescription, expenseDate FROM expense JOIN expensetypes ON expenseType = expensetypes.id JOIN (SELECT CONCAT(firstname,'', lastname) as staff_names, staff.id from person JOIN staff ON staff.personId = person.id) as staff_details ON staff_details.id = expense.staff ORDER BY expenseDate DESC
	
	//members, person, person relative, person employment, account,
	$table = "`expense` JOIN `expensetypes` ON `expenseType` = `expensetypes`.`id` JOIN (SELECT CONCAT(`firstname`,' ', `lastname`) as staff_names, `staff`.`id` from `person` JOIN `staff` ON staff.personId = person.id) as staff_details ON staff_details.id = expense.staff"; 
	$primary_key = "`expense`.`id`";
	$columns = array( "expenseName", "amountUsed","staff_names", "amountDescription", "expenseDate" );
	$group_by = "expense.expenseDate DESC";
}
if ( isset($_POST['page']) && $_POST['page'] == "view_groups" ) {
		
	//members, person, person relative, person employment, account,
	$table = "saccogroup"; 
	$primary_key = "`saccogroup`.`id`";
	$columns = array("id", "groupName", "description", "dateCreated", "createdBy",  "modifiedBy");
	$group_by = "saccogroup.groupName ASC";
}
if ( isset($_POST['page']) && strlen($_POST['page'])>0) {
	// Get the data
	$data_table->get($table, $primary_key, $columns, $where, $group_by);
}
?>