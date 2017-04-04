<?php
$curdir = dirname(__FILE__);
require_once($curdir.'/Db.php');
class Branch extends Db {
	protected static $table_name  = "branch";
	protected static $db_fields = array("id","branch_number","branch_name","physical_address","office_phone", "postal_address","email_address");
	
	public function findById($id){
		$result = $this->getrec(self::$table_name, "id=".$id, "", "");
		return !empty($result) ? $result:false;
	}
	public function findByBranchNo($bno){
		$result = $this->getrec(self::$table_name, "branch_number=".$bno, "", "");
		return !empty($result) ? $result:false;
	}
	public function createNewBranchNumber(){
		$r = $this->findRecentId();
		$no = 0;
		$branch_no = "";
		if($r){
			$no =  $r+1 ;
			$branch_no  = sprintf("%05d", $no);
		}else{
			$no++;
			$branch_no =  sprintf("%05d", $no);
		}
		return "BR".$branch_no;
	}
	public function findRecentId(){
		$result = $this->getfrec(self::$table_name, "id", "", "id DESC", "");
		return !empty($result) ? $result['id']:false;
	}
	public function findAll(){
		$result_array = $this->getarray(self::$table_name, "","id DESC", "");
		return !empty($result_array) ? $result_array : false;
	}
	public function findBranchNameByNumber($bno){
		$result = $this->getrec(self::$table_name, "branch_name", "branch_number='$pno'", "", "");
		return !empty($result) ? $result['branch_name'] :false;
	}
	public function doesBranchNoExist($bno){
		return $this->countRecords(self::$table_name, "branch_name='.$bno.'");
	}
	public function addBranch($data){
		if($this->doesBranchNoExist($data['branch_number']) > 0){
			$data['branch_number'] = $this->createNewBranchNumber();
		}
		$fields = array_slice(self::$db_fields, 1);
		if($this->add(self::$table_name, $fields, $this->generateAddFields($fields, $data))){
			return true;
		}
		return false;
	}
	public function updateBranch($data){
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