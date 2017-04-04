<?php
$curdir = dirname(__FILE__);
require_once($curdir.'/Db.php');
class Accounts extends Db {
	protected static $table_name  = "accounts";
	protected static $db_fields = array("id", "account_number", "person_number", "balance", "status","created_by", "date_created");
	
	public function findById($id){
		$result = $this->getrec(self::$table_name, "id=".$id, "");
		return !empty($result) ? $result:false;
	}
	public function getName(){
        return $this->name; 
    }
	
    public function getBalance(){
			
        if(($this->balance) > 0){
            return $this -> balance;

        } else if(($this->balance) <= 0 ){
            return 'Balance is empty '; 
        }else{
            return 'error'; 
        }   
    }
        public function Deposit($amount){

        $this->balance = $this->balance + $amount;  
    }
	public function findMinimumBalance(){
		$result = $this->getfrec("other_settings", "minimum_balance", "", "", "1");
		return !empty($result) ? $result['minimum_balance'] : false;
	}

    public function Withdraw($amount){

        if(($this->balance) < $amount){
            echo 'Not enough funds to withdraw. ';

        } else{
            $this->balance = $this->balance - $amount;  
        }
    }   
	public function findByAccountBalance($pno){
		$result = $this->getrec(self::$table_name,"balance", "person_number=".$pno, "", "");
		return !empty($result) ? $result['balance']:false;
	}
	public function findByAccountNumber($accno){
		$result = $this->getrec(self::$table_name, "account_number='$accno'", "");
		return !empty($result) ? $result:false;
	}
	public function findByPersonNumber($pno){
		$result = $this->getrec(self::$table_name, "person_number=".$pno, "");
		return !empty($result) ? $result:false;
	}
	public function findTransactionByPersonNumber($pno){
		$results = $this->getarray("transaction", "person_number=".$pno, "", "");
		return !empty($results) ? $results : false;
	}
	public function findAllTransactions(){
		$results = $this->getarray("transaction", "", "", "");
		return !empty($results) ? $results : false;
	}
	public function findTransactionByDateRange($date1, $date2, $pno){
		$results = $this->getarray("transaction", "person_number=".$pno." AND transaction_date BETWEEN \"".$date1."\" AND \"".$date2." 23:59:59.999\"", "", "");
		return !empty($results) ? $results : false;
	}
	public function findAccountNoByPersonNumber($pno){
		$result = $this->getfrec(self::$table_name,"account_number",  "person_number=".$pno, "", "");
		return !empty($result) ? $result['account_number'] : false;
	}
	public function findAccountNamesByPersonNumber($pno){
		$result = $this->getfrec("person","firstname, lastname, othername",  "id=".$pno, "", "");
		return !empty($result) ? $result:false;
	}
	public function findAll(){
		$result_array = $this->getarray(self::$table_name, "","id DESC", "");
		return !empty($result_array) ? $result_array : false;
	}
	public function findMemberDeposits($pno){
		$result_array = $this->getarray("transaction", "person_number=".$pno." AND transaction_type=1","id DESC", "");
		return !empty($result_array) ? $result_array : false;
	}
	public function findAccountCredit($accno){
		$result = $this->getfrec(self::$table_name, "credit", "account_number='$accno'", "");
		return !empty($result) ? $result['credit']:false;
	}
	public function findDateOpened($id){
		$result = $this->getfrec(self::$table_name, "date_created", "account_number='$accno'", "");
		return !empty($result) ? $result['date_created']:false;
	}
	public function findAccountCreator($id){
		$result = $this->getfrec(self::$table_name, "created_by", "account_number='$accno'", "");
		return !empty($result) ? $result['created_by']:false;
	}
	
	//This function will add deposit transaction and later add an increment to the account balance
	public function addDeposit($data){
		$data['transaction_type'] = 1;
		$data['transaction_date'] = date("Y-m-d");
		$trans_fields = array("transaction_type", "branch_number", "person_number", "amount", "amount_description", "transacted_by", "transaction_date", "approved_by", "comments");
		$trans =  $this->add("transaction", $trans_fields, $this->generateAddFields($trans_fields, $data));
		if($trans){
			$account_balance = $this->findByAccountBalance($data['person_number']);
			$total_balance = $account_balance + $data['amount'];
			$accno = $data['account_number'];
			if($this->update(self::$table_name, array("balance"), array("balance"=>$total_balance), "account_number=".$accno)){
				return true;
			}
		}
		return false;
	}
	//This function will add deposit transaction and later add an increment to the account balance
	public function addWithdraw($data){
		$data['transaction_type'] = 2;
		$data['transaction_date'] = date("Y-m-d");
		$data['amount'] = (-1*(int)$data['amount']);
		$trans_fields = array("transaction_type", "branch_number", "person_number", "amount", "amount_description", "transacted_by", "transaction_date", "approved_by", "comments");
		$trans =  $this->add("transaction", $trans_fields, $this->generateAddFields($trans_fields, $data));
		if($trans){
			$account_balance = $this->findByAccountBalance($data['person_number']);
			$total_balance = $account_balance + $data['amount'];
			$accno = $data['account_number'];
			if($this->update(self::$table_name, array("balance"), array("balance"=>$total_balance), "account_number=".$accno)){
				return true;
			}
		}
		return false;
	}
	public function addAccount($data){
		$fields = array_slice(self::$db_fields, 1);
		if($this->add(self::$table_name, $fields, $this->generateAddFields($fields, $data))){
			return true;
		}
		return false;
	}
	public function updateAccount($data){
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