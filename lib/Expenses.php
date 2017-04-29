<?php
$curdir = dirname(__FILE__);
require_once($curdir.'/Db.php');
class Expenses extends Db {
	protected static $table_name  = "expense LEFT JOIN expensetypes ON expenseType = expensetypes.id";
	protected static $db_fields = array("expense.id", "amountUsed", "amountDescription","expenseType","staff", "expenseDate", "description", "expenseName");
	
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
	public function findAllExpenses($where = 1, $orderby = "id DESC", $limit = ""){
		$result_array = $this->getarray(self::$table_name, $where, $orderby, $limit);
		return !empty($result_array) ? $result_array : false;
	}
	
	public function findAmountExpensed($id){
		$result = $this->getfrec(self::$table_name, "amountUsed", "id='$id'", "");
		return !empty($result) ? $result['amountUsed']:false;
	}
	
	
	public function addWithExpense($data){
		$fields = array_slice(1, self::$db_fields);
		if($this->add(self::$table_name, $fields, $this->generateAddFields($fields, $data))){
			return true;
		}
		return false;
	}
	public function updateExpense($data){
		$fields = array_slice(1, self::$db_fields);
		$id = $data['id'];
		unset($data['id']);
		if($this->update(self::$table_name, $fields, $this->generateAddFields($fields, $data), "id=".$id)){
			return true;
		}
		return false;
	}
	
}
?>