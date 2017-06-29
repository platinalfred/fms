<?php
$curdir = dirname(__FILE__);
require_once($curdir.'/Db.php');
class Expenses extends Db {
	protected static $table_name  = "expense";
	protected static $db_fields = array("expense.id", "expenseType", "amountUsed", "amountDescription","expenseType","staff", "expenseDate", "expenseName", "createdBy", "modifiedBy");
	
	public function findById($id){
		$result = $this->getrec(self::$table_name, "id=".$id, "");
		return !empty($result) ? $result:false;
	}
	
	public function findExpenseType(){
		$result = $this->getfrec(self::$table_name, "expenseType", "id=$id", "");
		if($result){
			
		}
		return !empty($result) ? $result['amount']:false;
	}
	public function findAllExpenses(){
		$result = $this->queryData("SELECT expense.id, expenseName, amountUsed,staff_names, amountDescription, expenseDate FROM expense JOIN expensetypes ON expenseType = expensetypes.id JOIN (SELECT CONCAT(firstname,'', lastname) as staff_names, staff.id from person JOIN staff ON staff.personId = person.id) as staff_details ON staff_details.id = expense.staff ORDER BY expenseDate DESC");
		return !empty($result) ? $result : false;
		
	}
	public function findAll ($where = 1, $orderby = "id DESC", $limit = ""){
		$result_array = $this->getarray(self::$table_name, $where, $orderby, $limit);
		return !empty($result_array) ? $result_array : false;
	}
	
	public function findAmountExpensed($id){
		$result = $this->getfrec(self::$table_name, "amountUsed", "id='$id'", "", "");
		return !empty($result) ? $result['amountUsed']:0;
	}
	
	public function findExpensesSum($where = ""){
		$result = $this->getfrec(self::$table_name, "SUM(`amountUsed`) `amountExpensed`", $where, "", "");
		return !empty($result) ? $result['amountExpensed']:0;
	}
	
	
	public function addExpense($data){
		$data['amountUsed'] = $this->stripCommasOnNumber($data['amountUsed']);
		$fields = array_slice(self::$db_fields, 1);
		if($this->add(self::$table_name, $fields, $this->generateAddFields($fields, $data))){
			return true;
		}
		return false;
	}
	public function updateExpense($data){
		$fields = array_slice(self::$db_fields, 1);
		$id = $data['id'];
		unset($data['id']);
		if($this->update(self::$table_name, $fields, $this->generateAddFields($fields, $data), "id=".$id)){
			return true;
		}
		return false;
	}
	
}
?>