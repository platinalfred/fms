<?php
$curdir = dirname(__FILE__);
require_once($curdir.'/Db.php');
class Loans extends Db {
	protected static $table_name  = "loan";
	protected static $db_fields = array("id", "person_id", "loan_number","branch_number", "loan_type", "loan_date","loan_amount", "loan_amount_word", "interest_rate", "daily_default_amount", "expected_payback", "approved_by", "loan_duration", "comments","loan_agreement_path");
	
	public function findById($id){
		$result = $this->getrec(self::$table_name, "id=".$id, "", "");
		return !empty($result) ? $result:false;
	}
	public function findMemberLoans($where = ""){
		
		$table = "`loan` LEFT JOIN (SELECT COALESCE(SUM(amount),0) `amount_paid`, `loan_id` FROM `loan_repayment` GROUP BY `loan_id`)`payment` ON `loan`.`id` = `payment`.`loan_id`";

		$fields = array("id", "person_id", "loan_number", "branch_number", "loan_type", "loan_date", "loan_end_date","loan_amount", "loan_amount_word", "interest_rate", "daily_default_amount", "expected_payback", "loan_duration", "amount_paid", "daily_default_amount", "default_days(`loan`.`id`, `loan_date`, `loan_end_date`, CURDATE(),`expected_payback`)def_days");
		
		
		$results = $this->getfarray($table, implode(",", $fields), $where, "loan_date DESC", "");
		
		 //$results  = $this->getarray(self::$table_name, "person_id=".$pno, "loan_date DESC", "");
		 return !empty($results) ? $results : false;
	}
	public function findAll($where = 1, $order_by = "loan_date DESC", $limit = ""){
		$result_array = $this->getarray(self::$table_name, $where, $order_by, $limit);
		return !empty($result_array) ? $result_array : false;
	}
	public function findLoans($query){
		$result_array = $this->queryData($query);
		return $result_array;
	}
	public function findLoanType($id){
		 $results  = $this->getfrec("loan_type", "name", "id=".$id, "", "");
		 return !empty($results) ? $results['name'] : false;
	}
	public function findPayments($lid){
		 $results  = $this->getarray("loan_repayment", "loan_id=".$lid, "transaction_date DESC", "");
		 return !empty($results) ? $results : false;
	}
	public function findLoanNumber($id){
		 $results  = $this->getfrec(self::$table_name, "loan_number", "id=".$id, "", "");
		 return !empty($results) ? $results['loan_number'] : false;
	}
	public function findExpectedPayBackAmount($where = 1){
		 $results  = $this->getfrec(self::$table_name, "sum(expected_payback) amount", $where, "", "");
		 return !empty($results) ? ($results['amount']!=NULL?$results['amount'] : 0) : 0;
	}
	public function findAmountPaid($where = 1){
		 $results  = $this->getfrec("loan_repayment", "sum(amount) amount_paid", $where, "", "");
		 return !empty($results) ? ($results['amount_paid']!=NULL?$results['amount_paid'] : 0) : 0;
	}
	public function findDefaultAmount($where = 1){
		 $results  = $this->getfrec(self::$table_name, "default_days(`loan`.`id`, `loan_date`, `loan_end_date`, CURDATE(),`expected_payback`)*`expected_payback`*`daily_default_amount`/100 default_amount", $where, "", "");
		 return !empty($results) ? ($results['default_amount']!=null?$results['default_amount'] : 0) : 0;
	}
	public function findDefaultDays($where = 1){
		 $results  = $this->getfrec(self::$table_name, "default_days(`loan`.`id`, `loan_date`, `loan_end_date`, CURDATE(),`expected_payback`) def_days", $where, "", "");
		 return !empty($results) ? ($results['def_days']!=null?$results['def_days'] : 0) : 0;
	}
	public function isLoanAboutToExpire($id, $duratn){
		$days = $this->findLoanPayBackDays($duratn);
		$six_days_to = $days-14; 
		if($this->count(self::$table_name, "loan_date < DATE_SUB(DATE(now()), INTERVAL ".$six_days_to." DAY) AND id=".$id) > 0){
			return true;
		}
		return false;
	}
	public function findLoanPaymentDuration($duratn){
		 $results  = $this->getfrec("repaymentduration", "name", "id=".$duratn, "", "");
		 return !empty($results) ? $results['name'] : false;
	}
	public function findLoanPayBackDays($duratn){
		 $results  = $this->getfrec("repaymentduration", "payback_days", "id=".$duratn, "", "");
		 return !empty($results) ? $results['payback_days'] : false;
	}
	public function findExpectedPayBackDate($id){
		 $results  = $this->getfrec("repaymentduration", "payback_days", "id=".$id, "", "");
		 if($results){
			return date('j F, Y', strtotime("+".$results['payback_days']." day"));
		 }
		 return false;
	}
	public function updateImage($data){
		if($this->update(self::$table_name, array('photo'), array('photo'=>$data['photo']), "id=".$data['id'])){
			return true;
		}else{
			return false;
		}
	}
	
	public function clearLoan($id, $status = ""){
		if($this->update(self::$table_name, array($field), array($field=>$value), 'id = \''.$id.'\'')){
			return true;
		}else{
			return false;
		}
	}
	public function calculateLoandEndDate($id){
		 $results  = $this->getfrec("repaymentduration", "payback_days", "id=".$id, "", "");
		 if($results){
			return date("Y-m-d H:i:s", strtotime("+".$results['payback_days']." day"));
		 }
		 return false;
	}
	public function findLoanDocuments($lid){
		 $results  = $this->getarray("loan_doccuments", "loan_id=".$lid, "", "");
		 return !empty($results) ? $results : false;
	}
	public function addLoanDocument($data){
		
		$result = $this->add("loan_doccuments", array("loan_id", "name", "doc_path","description"), array("loan_id"=>$data['loan_id'], "name"=>$data['name'], "doc_path"=>$data['doc_path'], "description"=>$data['description']));
		if($result){
			return $result;
		}else{
			return false;
		}
	}
	public function addLoan($data){
		
		$result = $this->add(self::$table_name, array("person_id", "loan_number", "branch_number","loan_type", "loan_date", "loan_end_date", "loan_amount","loan_amount_word", "interest_rate", "expected_payback", "daily_default_amount", "approved_by", "loan_duration", "comments"), array("person_id"=>$data['person_id'], "loan_number"=>$data['loan_number'], "branch_number"=>$data['branch_number'], "loan_type"=>$data['loan_type'],"loan_date"=>$data['loan_date'],"loan_amount"=>$data['loan_amount'], "loan_amount_word"=>$data['loan_amount_word'], "interest_rate"=>$data['interest_rate'],"expected_payback"=>$data['expected_payback'],"daily_default_amount"=>$data['daily_default_amount'], "loan_date"=>$data['loan_date'], "loan_end_date"=>$data['loan_end_date'], "approved_by"=>$data['approved_by'], "loan_duration"=>$data['loan_duration'], "comments"=>$data['comments']));
		if($result){
			return $result;
		}else{
			return false;
		}
	}
	public function addLoanRepayment($data){
		$data['transaction_type'] = 3;
		$data['transaction_date'] = date("Y-m-d");
		$data['approved_by'] = $data['receiving_staff'];
 		$trans_fields = array("transaction_type", "branch_number", "person_id", "amount", "amount_description", "transacted_by", "transaction_date", "approved_by", "comments");
		$trans =  $this->add("transaction", $trans_fields, $this->generateAddFields($trans_fields, $data));
		if($trans){
			$result = $this->add("loan_repayment", array("transaction_id", "branch_number", "loan_id","amount", "transaction_date", "comments", "receiving_staff","transacted_by"), array("person_id"=>$data['person_id'], "transaction_id"=>$trans, "branch_number"=>$data['branch_number'], "loan_id"=>$data['loan_id'],"amount"=>$data['amount'],"transaction_date"=>$data['transaction_date'], "comments"=>$data['comments'], "receiving_staff"=>$data['receiving_staff'],"transacted_by"=>$data['transacted_by']));
			if($result){
				return $result;
			}else{
				return false;
			}
		}
		return false;
	}
	public function deleteLoan($id){
		$this->delete(self::$table_name, "id=".$id);
	}
	public function updateLoan($data){
		$loan_date = $this->formatDate($data['loan_date']);
	
		if($this->update(self::$table_name,array("person_id", "loan_number", "branch_number","loan_type", "loan_date", "loan_end_date", "loan_amount","loan_amount_word", "interest_rate", "expected_payback", "daily_default_amount", "approved_by", "repayment_duration", "comments"), array("person_id"=>$data['person_id'], "loan_number"=>$data['loan_number'], "branch_number"=>$data['branch_number'], "loan_type"=>$data['loan_type'],"loan_date"=>$data['loan_date'],"loan_amount"=>$data['loan_amount'], "loan_amount_word"=>$data['loan_amount_word'], "interest_rate"=>$data['interest_rate'],"expected_payback"=>$data['expected_payback'],"daily_default_amount"=>$data['daily_default_amount'], "loan_date"=>$loan_date, "loan_end_date"=>$loan_date, "approved_by"=>$data['approved_by'], "repayment_duration"=>$data['repayment_duration'], "comments"=>$data['comments']), "id=".$data['id'])){
			return true;
		}else{
			echo "Failed to update";
			return false;
		}
	}
}
?>