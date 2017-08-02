<?php
require_once("lib/Libraries.php");
require_once("lib/DatatablesJSON.php");

// Create instance of DataTable class
$data_table = new DataTable();
$primary_key = $columns = $table = $where = $group_by = "";
if ( isset($_POST['page']) && $_POST['page'] == "view_expenses" ) {
	
	//members, person, person relative, person employment, account,
	$table = "`expense` JOIN `expensetypes` ON `expenseType` = `expensetypes`.`id` JOIN (SELECT CONCAT(`firstname`,' ', `lastname`) as staff_names, `staff`.`id` from `person` JOIN `staff` ON staff.personId = person.id) as staff_details ON staff_details.id = expense.staff"; 
	$primary_key = "`expense`.`id`";
	$columns = array( "expenseName", "amountUsed","staff_names", "amountDescription", "expenseDate" );
}
if ( isset($_POST['page']) && $_POST['page'] == "view_income" ) {
	
	//members, person, person relative, person employment, account,
	$table = "`income` JOIN `income_sources` ON `income`.`incomeSource` = `income_sources`.`id`"; 
	$primary_key = "`income`.`id`";
	$columns = array( "income_sources.name as income_source", "amount","income.description", "dateAdded");
}
if ( isset($_POST['page']) && $_POST['page'] == "view_groups" ) {
	$where = "active=1";	
	//members, person, person relative, person employment, account,
	$table = "saccogroup"; 
	$primary_key = "`saccogroup`.`id`";
	$columns = array("id", "groupName", "description", "dateCreated", "createdBy",  "modifiedBy");
	
}
if ( isset($_POST['page']) && $_POST['page'] == "view_members" ) {
	
	if((isset($_POST['start_date'])&& strlen($_POST['start_date'])>1) && (isset($_POST['end_date'])&& strlen($_POST['end_date'])>1)){
		$where = "(`dateAdded` BETWEEN ".$_POST['start_date']." AND ".$_POST['end_date'].")";
	}	
	
	//members, person, person relative, person employment, account,
	$table = "`member` JOIN `person` ON `member`.`personId` = `person`.`id`"; 
	$primary_key = "`member`.`id`";
	$columns = array( "`member`.`id`","`person`.`person_number`", "`person`.`comment`","`firstname`", "`lastname`", "`othername`", "`phone`", "`id_number`" ,"`dateAdded`", "`memberType`", "`dateofbirth`", "`gender`", "`email`", "`postal_address`", "`physical_address`","`personId`", "`date_registered`", "`branch_id`" );
	$group_by = "person.id ";
}
if ( isset($_POST['page']) && $_POST['page'] == "view_staff" ) {
	if((isset($_POST['start_date'])&& strlen($_POST['start_date'])>1) && (isset($_POST['end_date'])&& strlen($_POST['end_date'])>1)){
		$where = "(`dateAdded` BETWEEN ".$_POST['start_date']." AND ".$_POST['end_date'].")";
	}		
	//members, person, person relative, person employment, account,
	//$table = "`staff` JOIN `person` ON `staff`.`personId` = `person`.`id`"; 
	$table = "`staff` JOIN `person` ON `staff`.`personId` = `person`.`id` JOIN `position` ON `staff`.`position_id` = `position`.`id` JOIN `branch` ON `staff`.`branch_id` = `branch`.`id`"; 
	$primary_key = "`staff`.`id`";
	$columns = array( "`staff`.`id`","`person`.`person_number`","`branch`.`branch_name`", "`person`.`comment`","`position`.`name`","`firstname`", "`lastname`", "`othername`", "`status`","`phone`", "`id_number`" ,  "`dateofbirth`","`username`", "`gender`", "`email`", "`person`.`postal_address`", "`person`.`physical_address`","`personId`", "`date_registered`", "`branch_id`" );
	//$columns = array( "`person`.`id`","`person`.`person_number`","`staff`.`id`", "`position`.`name` `position`" , "`username`", "`firstname`", "`lastname`", "`othername`", "`phone`", "`id_number`" ,"`date_added`", "`dateofbirth`", "`gender`", "`email`", "`postal_address`", "`physical_address`", "`branch_id`" );`person`.
	$group_by = "person.id";
}

if ( isset($_POST['page']) && strlen($_POST['page'])>0) {
	// Get the data
	$data_table->get($table, $primary_key, $columns, $where, $group_by);
}
?>