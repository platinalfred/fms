<?php 
require_once("lib/Libraries.php");
require_once("lib/DatatablesJSON.php");

// Create instance of DataTable class
$data_table = new DataTable();
$primary_key = $columns = $table = $where = $group_by = "";
if ( isset($_POST['page']) && $_POST['page'] == "view_members" ) {
	
	//members, person, person relative, person employment, account,
	$table = "`member` JOIN `person` ON `member`.`personId` = `person`.`id`"; 
	$primary_key = "`member`.`id`";
	$columns = array( "`person`.`id`","`person`.`person_number`", "`person`.`comment`","`firstname`", "`lastname`", "`othername`", "`phone`", "`id_number`" ,"`dateAdded`", "`memberType`", "`dateofbirth`", "`gender`", "`email`", "`postal_address`", "`physical_address`", "`date_registered`", "`branch_id`" );
	$group_by = "person.id DESC";
}

if ( isset($_POST['page']) && strlen($_POST['page'])>0) {
	// Get the data
	$data_table->get($table, $primary_key, $columns, $where, $group_by);
}
?>