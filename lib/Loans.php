<?php
$curdir = dirname(__FILE__);
require_once($curdir.'/Db.php');
class Loans extends Db {
	protected static $table_name  = "loan";
	protected static $db_fields = array("id", "person_number", "loan_number","branch_number", "loan_type", "loan_date","loan_amount", "loan_amount_word", "interest_rate", "daily_default_amount", "expected_payback", "approved_by", "loan_duration", "comments"," loan_agreement_path");
	
	public function findById($id){
		$result = $this->getRecord(self::$table_name, "id=".$id, "");
		return !empty($result) ? $result:false;
	}
	public function findMemberLoans($pno){
		 $results  = $this->getarray(self::$table_name, "person_number=".$pno, "", "");
		 return !empty($results) ? $results : false;
	}
	public function findAll($where = 1, $order_by = "loan_date DESC", $limit = ""){
		$result_array = $this->getarray(self::$table_name, $where, $order_by, $limit);
		return !empty($result_array) ? $result_array : false;
	}
	public function findLoanType($type){
		 $results  = $this->getfrec("loantype", "name", "id=".$type, "", "");
		 return !empty($results) ? $results['name'] : false;
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
	public function addLoan($data){
		
		$result = $this->add(self::$table_name, array("person_number", "loan_number", "branch_number","loan_type", "loan_date", "loan_end_date", "loan_amount","loan_amount_word", "interest_rate", "expected_payback", "daily_default_amount", "approved_by", "loan_duration", "comments"), array("person_number"=>$data['person_number'], "loan_number"=>$data['loan_number'], "branch_number"=>$data['branch_number'], "loan_type"=>$data['loan_type'],"loan_date"=>$data['loan_date'],"loan_amount"=>$data['loan_amount'], "loan_amount_word"=>$data['loan_amount_word'], "interest_rate"=>$data['interest_rate'],"expected_payback"=>$data['expected_payback'],"daily_default_amount"=>$data['daily_default_amount'], "loan_date"=>$data['loan_date'], "loan_end_date"=>$data['loan_end_date'], "approved_by"=>$data['approved_by'], "loan_duration"=>$data['loan_duration'], "comments"=>$data['comments']));
		if($result){
			return $result;
		}else{
			return false;
		}
	}
	public function deleteLoan($id){
		$this->delete(self::$table_name, "id=".$id);
	}
	public function updateLoan($data){
		$loan_date = $this->formatDate($data['loan_date']);
	
		if($this->update(self::$table_name,array("person_number", "loan_number", "branch_number","loan_type", "loan_date", "loan_end_date", "loan_amount","loan_amount_word", "interest_rate", "expected_payback", "daily_default_amount", "approved_by", "repayment_duration", "comments"), array("person_number"=>$data['person_number'], "loan_number"=>$data['loan_number'], "branch_number"=>$data['branch_number'], "loan_type"=>$data['loan_type'],"loan_date"=>$data['loan_date'],"loan_amount"=>$data['loan_amount'], "loan_amount_word"=>$data['loan_amount_word'], "interest_rate"=>$data['interest_rate'],"expected_payback"=>$data['expected_payback'],"daily_default_amount"=>$data['daily_default_amount'], "loan_date"=>$loan_date, "loan_end_date"=>$loan_date, "approved_by"=>$data['approved_by'], "repayment_duration"=>$data['repayment_duration'], "comments"=>$data['comments']), "id=".$data['id'])){
			return true;
		}else{
			echo "Failed to update";
			return false;
		}
	}
}
?>