<?php 
require_once("lib/Libraries.php");
require_once("lib/DatatablesJSON.php");

// Create instance of DataTable class
$data_table = new DataTable();
$primary_key = $columns = $table = $where = $group_by = "";
if ( isset($_POST['page']) && $_POST['page'] == "view_members" ) {
	if((isset($_POST['start_date'])&& strlen($_POST['start_date'])>1) && (isset($_POST['end_date'])&& strlen($_POST['end_date'])>1)){
		$where = "(`member`.`date_added` BETWEEN '".$_POST['start_date']."' AND '".$_POST['end_date']."')";
	}
	$table = "`member` JOIN `person` ON `member`.`personId` = `person`.`id` LEFT JOIN (SELECT SUM(`amount`) savings, `person_id` FROM `account_transaction` WHERE `transaction_type`=1 GROUP BY `person_id`) `client_savings` ON `member`.`personId` = `client_savings`.`person_id` LEFT JOIN (SELECT SUM(`amount`) `shares`, `person_id` FROM `shares` GROUP BY `person_id`) `client_shares` ON `member`.`personId` = `client_shares`.`person_id` LEFT JOIN (SELECT COUNT(`id`) `no_loans`, `personNo` FROM `loan_account` GROUP BY `personNo`) `client_loans` ON `member`.`personId` = `client_loans`.`personNo`";
	$primary_key = "`member`.`id`";
	$columns = array( "`person`.`person_number`", "`firstname`", "`lastname`", "`othername`", "`phone`", "`date_added`", "`member_type`", ", `shares`", "`savings`", "`member`.`id` as `member_id`", "`no_loans`", "`dateofbirth`", "`gender`", "`email`", "`postal_address`", "`physical_address`", "`branch_number`" );
}
//list of all the expenses
if ( isset($_POST['page']) && $_POST['page'] == "view_expenses" ) {
	if((isset($_POST['start_date'])&& strlen($_POST['start_date'])>1) && (isset($_POST['end_date'])&& strlen($_POST['end_date'])>1)){
		$where = "(`date_of_expense` BETWEEN '".$_POST['start_date']."' AND '".$_POST['end_date']."')";
	}	
	$table = "`expense` JOIN `person` ON `expense`.`staff` = `person`.`id` JOIN `expensetypes` ON `expense_type` = `expensetypes`.`id`";

	$primary_key = "`expense`.`id`";

	$columns = array( "`person`.`person_number`", "`firstname`", "`lastname`", "`othername`", "`expense`.`id`", "`amount_used`","`expense_type`","`amount_description`", "`date_of_expense`", "`name`", "`description`" );
}
//list of loans
if ( isset($_POST['page']) && $_POST['page'] == "view_loans" ) {
	
	$member_sql = "(SELECT `members`.`id` `clientId`, loanAccountId, CONCAT(`firstname`,' ',`lastname`,' ',`othername`) `clientNames`, 1 `clientType` FROM `member_loan_account` JOIN (SELECT `member`.`id`, `firstname`, `lastname`, `othername` FROM `member` JOIN `person` ON `member`.`personId`=`person`.`id`)`members` ON `memberId` = `members`.`id`)";
	$saccogroup_sql = "(SELECT `saccogroup`.`id` `clientId`, `loanAccountId`, `groupName` `clientNames`, 2 as `clientType` FROM `group_loan_account` JOIN `saccogroup` ON `saccoGroupId` = `saccogroup`.`id`)";
	
	$member_group_union_sql = " ".$member_sql. " UNION ". $saccogroup_sql . " ORDER BY `clientNames`";
	
	$table = "`loan_account` JOIN ($member_group_union_sql) `clients` ON `clients`.`loanAccountId` = `loan_account`.`id` JOIN `loan_products` ON `loan_account`.`loanProductId` = `loan_products`.`id`";
	
	$primary_key = "`loan_account`.`id`";

	$columns = array( "`loan_account`.`id`", "`loanNo`", "`clientNames`", "`productName`", "`requestedAmount`","`interestRate`","`disbursedAmount`", "`applicationDate`", "`offSetPeriod`" , "`loan_account`.`repaymentsFrequency`" , "`loan_account`.`repaymentsMadeEvery`" , "`installments`" );
}
//list of the income transactions
if ( isset($_POST['page']) && $_POST['page'] == "view_income" ) {
	if((isset($_POST['start_date'])&& strlen($_POST['start_date'])>1) && (isset($_POST['end_date'])&& strlen($_POST['end_date'])>1)){
		$where = "(`date_added` BETWEEN '".$_POST['start_date']."' AND '".$_POST['end_date']."')";
	}
	$table = "`income` JOIN `income_sources` ON `income_type` = `income_sources`.`id`";

	$primary_key = "`income`.`id`";

	$columns = array( "`name`", "`amount`", "`income`.`description`", "`date_added`", "`income`.`id`");
}
//list of all the shares held by the clients
if ( isset($_POST['page']) && $_POST['page'] == "view_shares" ) {
	
	if((isset($_POST['start_date'])&& strlen($_POST['start_date'])>1) && (isset($_POST['end_date'])&& strlen($_POST['end_date'])>1)){
		$where = "(`date_paid` BETWEEN '".$_POST['start_date']."' AND '".$_POST['end_date']."')";
	}
	
	$table = "`shares` JOIN `person` ON `shares`.`person_number` = `person`.`id`";
	
	$group_by = "`person_number`";

	$primary_key = "`shares`.`id`";

	$columns = array( "`firstname`", "`lastname`", "`othername`", "`shares`.`person_number`", "SUM(`amount`) `share`");
}
//list of all the client subscriptions
if ( isset($_POST['page']) && $_POST['page'] == "view_subcriptns" ) {
	
	if((isset($_POST['start_date'])&& strlen($_POST['start_date'])>1) && (isset($_POST['end_date'])&& strlen($_POST['end_date'])>1)){
		$where = "(`date_paid` BETWEEN '".$_POST['start_date']."' AND '".$_POST['end_date']."')";
	}
	
	$table = "`subscription` JOIN `person` ON `subscription`.`person_number` = `person`.`id`";
	
	$group_by = "`person_number`";

	$primary_key = "`subscription`.`id`";

	$columns = array( "`firstname`", "`lastname`", "`othername`", "`amount`", "`subscription_year`", "`date_paid`", "`subscription`.`person_number`");
}
//list of all the client loan payments
if ( isset($_POST['page']) && $_POST['page'] == "view_loan_payments" ) {
	
	if((isset($_POST['start_date'])&& strlen($_POST['start_date'])>1) && (isset($_POST['end_date'])&& strlen($_POST['end_date'])>1)){
		$where = "(`transaction_date` BETWEEN '".$_POST['start_date']."' AND '".$_POST['end_date']."')";
	}
	
	$table = "`loan_repayment` JOIN (SELECT `firstname`, `lastname`, `othername`, `loan`.`id`, `loan_number` FROM `loan` JOIN `person` ON `loan`.`person_number` = `person`.`id`) `loan` ON `loan_repayment`.`loan_id` = `loan`.`id`";
	
	$primary_key = "`loan_repayment`.`id`";

	$columns = array( "`firstname`", "`lastname`", "`othername`", "`amount`", "`comments`", "`transaction_date`", "`loan_number`", "`loan_id`");
}
//list of all the member savings
if ( isset($_POST['page']) && $_POST['page'] == "member_savings" ) {
		$where = "transaction_type=1";
	
	if((isset($_POST['start_date'])&& strlen($_POST['start_date'])>1) && (isset($_POST['end_date'])&& strlen($_POST['end_date'])>1)){
		$where .= " AND (`transaction_date` BETWEEN '".$_POST['start_date']."' AND '".$_POST['end_date']."')";
	}	
	$table = "`transaction` JOIN `person` ON `transaction`.`person_number` = `person`.`id`";
	
	$primary_key = "`transaction`.`id`";

	$columns = array( "`firstname`", "`lastname`", "`othername`", "`amount`", "`amount_description`", "`transacted_by`", "`transaction_date`", "`transaction`.`id`");
}
if ( isset($_POST['page']) && strlen($_POST['page'])>0) {
	// Get the data
	$data_table->get($table, $primary_key, $columns, $where, $group_by);
}
?>