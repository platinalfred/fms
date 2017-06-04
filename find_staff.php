<?php 
require_once("lib/Libraries.php");
require_once("lib/DatatablesJSON.php");

// Create instance of DataTable class
$data_table = new DataTable();
$primary_key = $columns = $table = $where = $group_by = "";
if ( isset($_POST['page']) && $_POST['page'] == "view_staff" ) {
	
	//members, person, person relative, person employment, account,
	$table = "`staff` JOIN `person` ON `staff`.`personId` = `person`.`id`"; 
	$primary_key = "`staff`.`id`";
	$columns = array( "`person`.`id`","`person`.`person_number`", "`firstname`", "`lastname`", "`othername`", "`phone`", "`id_number`" ,"`dateAdded`", "`dateofbirth`", "`gender`", "`email`", "`postal_address`", "`physical_address`", "`branch_id`" );
}

if ( isset($_POST['page']) && strlen($_POST['page'])>0) {
	// Get the data
	$data_table->get($table, $primary_key, $columns, $where, $group_by);
}
?>