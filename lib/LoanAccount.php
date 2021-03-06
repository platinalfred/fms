<?php
$curdir = dirname(__FILE__);
require_once($curdir.'/Db.php');
class LoanAccount extends Db {
	protected static $table_name  = "loan_account";
	protected static $table_fields = array("id", "loanNo", "branch_id", "memberId", "groupLoanAccountId", "status", "loanProductId", "requestedAmount", "applicationDate", "disbursedAmount", "disbursementDate", "interestRate", "offSetPeriod", "gracePeriod", "repaymentsFrequency", "repaymentsMadeEvery", "installments", "penaltyCalculationMethodId", "penaltyTolerancePeriod", "penaltyRateChargedPer", "penaltyRate", "linkToDepositAccount", "comments", "createdBy", "dateCreated", "modifiedBy", "dateModified");
	
	protected static $member_sql = "SELECT `member`.`id`, CONCAT(`firstname`,' ',`lastname`,' ',`othername`) `clientNames`, `gender` FROM `member` JOIN `person` ON `member`.`personId`=`person`.`id`";

	protected static $saccogroup_sql2 = "SELECT `group_loan_account`.`id`, `saccogroup`.`id` `groupId`, `groupName` FROM `group_loan_account` JOIN `saccogroup` ON `saccoGroupId` = `saccogroup`.`id`";
	
	protected static $loan_payments_sql = "(SELECT `loanAccountId`, COUNT(`id`)`paidInstallments`, COALESCE(SUM(amount),0) `amountPaid`  FROM `loan_repayment` GROUP BY `loanAccountId`) `loan_payments`";
	
	protected static $loan_fees_sql = "(SELECT  COALESCE(SUM(feeAmount),0) `feesPaid`, `loanAccountId` FROM `loan_account_fee` GROUP BY `loanAccountId`) loan_fees";
	
	protected static $staff_sql = " JOIN (SELECT `staff`.`id`,CONCAT(`lastname`,' ',`firstname`)`staffNames` FROM `staff` JOIN `person` ON `staff`.`personId`=`person`.`id` ) `staff_details` ON `loan_account`.`createdBy`=`staff_details`.`id`";
	protected static $staff_sql2 = " LEFT JOIN (SELECT `staff`.`id`,CONCAT(`lastname`,' ',`firstname`)`staffNamesApproved` FROM `staff` JOIN `person` ON `staff`.`personId`=`person`.`id` ) `staff_details2` ON `loan_account`.`approvedBy`=`staff_details2`.`id`";
	
	public function findById($id){
		$result = $this->getrec(self::$table_name, "id=".$id, "", "");
		return !empty($result) ? $result:false;
	}
	public function findLoans($start_date, $end_date, $limit=""){
		if($limit != ""){
			$limit = "LIMIT ".$limit;
		}else{
			$limit  = "";
		}
		$products_sql = "SELECT `productName`, COALESCE(SUM(`disbursedAmount`),0) `loan_amount`, SUM(((`disbursedAmount`*(`interestRate`/100))*`installments`)/getPeriodAspect(`loan_account`.`repaymentsMadeEvery`)) `interest`, SUM(COALESCE(`paidAmount`,0))  `paidAmount` FROM `loan_products` LEFT JOIN `loan_account` ON `loan_account`.`loanProductId` = `loan_products`.`id` LEFT JOIN (SELECT SUM(`amount`) `paidAmount`, `loanAccountId` FROM `loan_repayment` WHERE `transactionDate` <= ".$end_date." GROUP BY `loanAccountId`) `payments` ON `loan_account`.`id`=`payments`.`loanAccountId` WHERE (`disbursementDate` BETWEEN ".$start_date." AND ".$end_date.") AND `status`=5 GROUP BY `productName` ORDER BY `productName`".$limit;
		$result_array = $this->queryData($products_sql);
		return $result_array;
	}
	public function findAll($where = 1){
		$result_array = $this->getarray(self::$table_name, $where, "", "");
		return !empty($result_array) ? $result_array : false;
	}
	
	public function findAllDetailsById($id){
		$fields = array( "`loan_account`.`id`", "`loanNo`", "`status`", "`productName`", "`loan_products`.`id` loanProductId", "`groupLoanAccountId`", "`groupId`", "`groupName`", "`requestedAmount`", "`applicationDate`", "`amountApproved`" , "`approvedBy`", "`approvalNotes`", "`approvalDate`", "`amountPaid`" , "`disbursedAmount`", "`disbursementDate`", "`disbursementNotes`", "`interestRate`", "`offSetPeriod`", "`gracePeriod`", "`loan_account`.`repaymentsFrequency`", "`loan_account`.`repaymentsMadeEvery`", "`installments`", "`loan_account`.`penaltyCalculationMethodId`", "`loan_account`.`penaltyTolerancePeriod`", "`loan_account`.`penaltyRateChargedPer`", "`penaltyRate`", "`loan_account`.`linkToDepositAccount`", "`comments`", "`staffNames`" ,"`staffNamesApproved`" ,"`loan_account`.`createdBy`", "`loan_account`.`dateCreated`", " `requestedAmount`*(`interestRate`/100) `interest`" );
		
		$table = self::$table_name." JOIN `loan_products` ON `loan_account`.`loanProductId` = `loan_products`.`id` LEFT JOIN ". self::$loan_payments_sql. " ON `loan_account`.`id` = `loan_payments`.`loanAccountId` LEFT JOIN (".self::$saccogroup_sql2.") `sacco_loan_acc_group` ON `sacco_loan_acc_group`.`id`=`groupLoanAccountId`".self::$staff_sql.self::$staff_sql2;
		
		$result = $this->getfrec($table, implode(",",$fields), "`loan_account`.`id`=".$id, "", "");
		return $result;
	}
	
	public function getLoanAmounts($where = ""){
			$in_part_string = "";
			$where_clause = "";
		if(is_array($where)){
			foreach($where as $depositAccount){
				$in_part_string .= $depositAccount['loanAccountId'].",";
			}
			$where_clause .= " AND `id` IN (".substr($in_part_string, 0, -1).")";
		}
		$fields = "COALESCE(SUM(`amountApproved`),0) `approved`, COALESCE(SUM(`disbursedAmount`),0) `disbursed`, COALESCE(SUM(`interestRate`),0) `interest`";
		$result_array = $this->getfrec(self::$table_name, $fields, $where, "", "");
		return !empty($result_array) ? $result_array : false;
	}
	
	public function getApplications($where = 1){
		$fields = array( "`loan_account`.`id`", "`loanNo`", "`clientNames`", "`gender`", "`memberId`", "`productName`", "`groupLoanAccountId`", "`groupId`", "`groupName`", "`requestedAmount`", "`disbursedAmount`", "`amountApproved`", "`applicationDate`", "`offSetPeriod`" , "`gracePeriod`" , "`loan_account`.`repaymentsFrequency`" , "`loan_account`.`repaymentsMadeEvery`" , "`status`" , "`approvalNotes`" , "`comments`" , "`loan_account`.`createdBy`" , "`staffNames`" ,"`installments`" , "`interestRate`", "`loan_products`.`id` loanProductId" /*, " `requestedAmount`*(`interestRate`/100) `interest`"*/,"(((`requestedAmount`*(`interestRate`/100))*`installments`)/getPeriodAspect(`loan_account`.`repaymentsMadeEvery`)) `interest`" );
		
		
		$table = self::$table_name." JOIN (".self::$member_sql.") `clients` ON `clients`.`id` = `memberId` JOIN `loan_products` ON `loan_account`.`loanProductId` = `loan_products`.`id` LEFT JOIN (".self::$saccogroup_sql2.") `sacco_loan_acc_group` ON `sacco_loan_acc_group`.`id`=`groupLoanAccountId` ".self::$staff_sql;
	
		$result_array = $this->getfarray($table, implode(",",$fields), $where, "`clientNames`", "");
		return !empty($result_array) ? $result_array : false;
	}
	
	public function getApprovedLoans($where = 1){
		$fields = array( "`loan_account`.`id`", "`loanNo`", "`status`", "`clientNames`", "`memberId`", "`productName`", "`groupLoanAccountId`", "`groupId`", "`groupName`", "`requestedAmount`", "`disbursedAmount`", "`approvalDate`", "`applicationDate`", "`offSetPeriod`", "`gracePeriod`" , "`amountApproved`" , "`approvalNotes`" , "`comments`" , "`loan_account`.`createdBy`" ,"`loan_account`.`repaymentsFrequency`" , "`loan_account`.`repaymentsMadeEvery`" , "`installments`" , "`amountPaid`" , "`interestRate`" , "`staffNames`" ,"`loan_products`.`id` loanProductId" /*,"`disbursedAmount`*(`interestRate`/100) `interest`"*/,"(((`disbursedAmount`*(`interestRate`/100))*`installments`)/getPeriodAspect(`loan_account`.`repaymentsMadeEvery`)) `interest`" );
		
		$table = self::$table_name." JOIN (".self::$member_sql.") `clients` ON `clients`.`id` = `memberId` LEFT JOIN (".self::$saccogroup_sql2.") `sacco_loan_acc_group` ON `sacco_loan_acc_group`.`id`=`groupLoanAccountId` JOIN `loan_products` ON `loan_account`.`loanProductId` = `loan_products`.`id` LEFT JOIN ". self::$loan_payments_sql. " ON `loan_account`.`id` = `loan_payments`.`loanAccountId`".self::$staff_sql;
	
		$result_array = $this->getfarray($table, implode(",",$fields), $where, "`clientNames`", "");
		return !empty($result_array) ? $result_array : false;
	}
	
	public function getGroupLoanAccounts($where = 1){
		$fields = "`group_loan_account`.`id`, `group_loan_account`.`dateCreated` `appnDate`, `saccoGroupId`, `productName`, COALESCE(`maxAmount`,0) `maxAmount`, COALESCE(`noMembers`,0) `noMembers`, COALESCE(`loanAmount`,0)`loanAmount`";
		
		$table = "`group_loan_account` JOIN `loan_products` ON `loan_products`.`id` = `loanProductId` LEFT JOIN (SELECT `groupLoanAccountId`, COUNT(`id`) `noMembers`, SUM(`loan_account`.`requestedAmount`) `loanAmount` FROM `loan_account` WHERE `groupLoanAccountId` > 0 GROUP BY `groupLoanAccountId`) `loanAccount` ON `loanAccount`.`groupLoanAccountId` = `group_loan_account`.`id`";
		//$table = "`group_loan_account` JOIN `loan_products` ON `loan_products`.`id` = `loanProductId` LEFT JOIN (SELECT `id`, `groupLoanAccountId`, COUNT(`id`) `noMembers`, SUM(`loan_account`.`requestedAmount`) `loanAmount` FROM `loan_account` WHERE `groupLoanAccountId` > 0 GROUP BY `groupLoanAccountId`) `loanAccount` ON `loanAccount`.`groupLoanAccountId` = `group_loan_account`.`id`";
	
		$result_array = $this->getfarray($table, $fields, $where, "", "");
		return !empty($result_array) ? $result_array : false;
	}
	public function getReport($start_date, $end_date, $client_type = 0, $category = 1){
		$between = "BETWEEN FROM_UNIXTIME($start_date) AND FROM_UNIXTIME($end_date)";
		$due_date = "GetDueDate(FROM_UNIXTIME(`disbursementDate`),`installments`,`repaymentsMadeEvery`,`repaymentsFrequency`,FROM_UNIXTIME($start_date),FROM_UNIXTIME($end_date))";
		$immediate_date = "ImmediateDueDate(FROM_UNIXTIME(`disbursementDate`),`installments`,`repaymentsMadeEvery`,`repaymentsFrequency`,FROM_UNIXTIME($end_date))";
		$timestamp_diff_sql = "(CASE `repaymentsMadeEvery`
			WHEN 1 THEN TIMESTAMPDIFF(DAY,FROM_UNIXTIME(`disbursementDate`),$immediate_date)
			WHEN 2 THEN TIMESTAMPDIFF(WEEK,FROM_UNIXTIME(`disbursementDate`),$immediate_date)
			WHEN 3 THEN TIMESTAMPDIFF(MONTH,FROM_UNIXTIME(`disbursementDate`),$immediate_date)
			END)";
		
		$fields = array( "`loan_account`.`id`, `loanNo`, `status`, `clientNames`, `memberId`, `disbursementDate`, `disbursedAmount`, `installments`, COALESCE(`paidInstallments`, 0) `paidInstallments`, (`installments`-COALESCE(`paidInstallments`, 0))`balInstallments`, `feesPaid`, `amountPaid`, (((`disbursedAmount`*(`interestRate`/100))*`installments`)/getPeriodAspect(`repaymentsMadeEvery`)) `interest`, `repaymentsMadeEvery`, COALESCE((`disbursedAmount`/`installments`),0)`principle`, (COALESCE((`disbursedAmount`/`installments`),0)*COALESCE(`paidInstallments`, 0)) `paidPrinciple`, `groupLoanAccountId`, `groupId`, `groupName`, $due_date `due_date`" );
		$where = ""; $payments_sql = self::$loan_payments_sql;
		//specification of the category of loans to be returned
		switch($category){
			case 1: //active loans
				$where .= "`status`=5";
			break;
			case 2: //performing loans
				
				$payments_sql = "(SELECT `loanAccountId`, COUNT(`id`)`paidInstallments`, COALESCE(SUM(amount),0) `amountPaid`  FROM `loan_repayment` WHERE `transactionDate` <= $end_date GROUP BY `loanAccountId`) `loan_payments`";
				
				$where .= "`status`=5 AND $immediate_date IS NOT NULL AND (((`disbursedAmount`*(`interestRate`/100)/`installments`)+COALESCE((`disbursedAmount`/`installments`),0))*$timestamp_diff_sql)<=`amountPaid`";
			break;
			case 3: //non performing loans
				
				$payments_sql = "(SELECT `loanAccountId`, COUNT(`id`)`paidInstallments`, COALESCE(SUM(amount),0) `amountPaid`  FROM `loan_repayment` WHERE `transactionDate` <= $end_date GROUP BY `loanAccountId`) `loan_payments`";
				
				$where .= "`status` IN (5,6) AND $immediate_date IS NOT NULL AND (((`disbursedAmount`*(`interestRate`/100)/`installments`)+COALESCE((`disbursedAmount`/`installments`),0))*$timestamp_diff_sql)>`amountPaid`";
			break;
			case 4: //due loans
				$timestamp_diff_sql = "(CASE `repaymentsMadeEvery`
					WHEN 1 THEN TIMESTAMPDIFF(DAY,FROM_UNIXTIME(`disbursementDate`),$due_date)
					WHEN 2 THEN TIMESTAMPDIFF(WEEK,FROM_UNIXTIME(`disbursementDate`),$due_date)
					WHEN 3 THEN TIMESTAMPDIFF(MONTH,FROM_UNIXTIME(`disbursementDate`),$due_date)
					END)";
				$where .= "`status` IN (5,6) AND $due_date IS NOT NULL AND (((`disbursedAmount`*(`interestRate`/100)/`installments`)+COALESCE((`disbursedAmount`/`installments`),0))*$timestamp_diff_sql)>`amountPaid`";
			break;
			default;
			$where .= "`status` IN (5,6) ";
		}
		
		$saccogroups_sql = "JOIN (".self::$saccogroup_sql2.") `sacco_loan_acc_group` ON `sacco_loan_acc_group`.`id`=`groupLoanAccountId`"; //this will  be the case when we have to view only member loans
		if(($client_type!=1&&$client_type!=2)||$client_type!=2){//otherwise, when we want to view both member and group loans
			$saccogroups_sql = "LEFT ".$saccogroups_sql;
		}
		if($client_type==2){//and if we want to view group loans only
			$where .= " AND (`groupLoanAccountId` IS NULL OR `groupLoanAccountId`=0)";
		}
		
		$table = self::$table_name." JOIN (".self::$member_sql.") `clients` ON `clients`.`id` = `memberId` $saccogroups_sql LEFT JOIN ". $payments_sql. " ON `loan_account`.`id` = `loan_payments`.`loanAccountId` LEFT JOIN ". self::$loan_fees_sql. " ON `loan_account`.`id` = `loan_fees`.`loanAccountId`";
		
		$result_array = $this->getfarray($table, implode(",",$fields), $where, "`clientNames`", "");
		return $result_array;
	}
	
	public function getStatement($loanAccountId){
		$fields = array( "`ref`", "`transactionType`", "`amount`", "`desc`", "`transactionDate`" );
		
		$loan_repayments = "SELECT `id` `ref`,2 `transactionType`, `amount`,`comments` `desc`,`transactionDate` FROM `loan_repayment` WHERE `loanAccountId`=".$loanAccountId;
		
		$account_fees_sql = "SELECT `loan_account_fee`.`id` `ref`,2 `transactionType`,`feeAmount` `amount`, `desc`, `loan_account_fee`.`dateCreated` `transactionDate` FROM `loan_account_fee` JOIN (SELECT `loan_product_feen`.`id`,`loanProductId`, `feeName` `desc` FROM `loan_product_feen` JOIN `loan_product_fee` ON `loan_product_fee`.`id`=`loan_product_feen`.`loanProductFeeId`) `product_fees` ON `loan_account_fee`.`loanProductFeenId`=`product_fees`.`id` WHERE `loanAccountId`=".$loanAccountId;
		
		$loan_account_penalties_sql = "SELECT `id` `ref`,2 `transactionType`, `amount`,CONCAT(`daysDelayed`, ' days (delay)' )`desc`,`dateCreated` `transactionDate` FROM `loan_account_penalty` WHERE `loanAccountId`=".$loanAccountId;
		
		$loan_account_sql = "SELECT `id` `ref`,1 `transactionType`, `disbursedAmount` `amount`,'Disbursed amount' `desc`,`disbursementDate` `transactionDate` FROM `loan_account` WHERE (`disbursementDate` IS NOT NULL OR `disbursementDate` >0) AND `id`=".$loanAccountId;
		
		$account_statement_sql = $loan_repayments." UNION ".$account_fees_sql." UNION ".$loan_account_penalties_sql." UNION ".$loan_account_sql. " ORDER BY `transactionDate`";
		
		return $result_array = $this->queryData($account_statement_sql);
	}
	
	public function getSumOfFields($where1 = "1 ", $loanAccountIds = false){
		$fields = array( "COALESCE(SUM(`disbursedAmount`),0) `loanAmount`", "(`disbursedAmount`*(`interestRate`/100)/`installments`) `interestAmount`" );
		$where = $where1;
		$in_part_string = "";
		if(is_array($loanAccountIds)){
			foreach($loanAccountIds as $loanAccount){
				$in_part_string .= $loanAccount['loanAccountId'].",";
			}
			$where .= " AND `id` IN (".substr($in_part_string, 0, -1).")";
		}
		$result_array = $this->getfrec(self::$table_name, implode(",",$fields), $where, "", "");
		return !empty($result_array) ? $result_array : false;
	}
		
	public function addLoanAccount($data){
		$fields = array_slice(self::$table_fields, 1);
		//$result = $this->add(self::$table_name, $fields, $this->generateAddFields($fields, $data));
		$result = $this->addSpecial(self::$table_name, $data);
		return $result;
	}
	
	public function updateLoanAccount($data){
		$fields = array_slice(self::$table_fields, 1);
		$id = $data['id'];
		unset($data['id']);
		return $this->updateSpecial(self::$table_name, $data, "id=".$id);
	}
	
	public function deleteLoanAccount($id){
		$this->delete(self::$table_name, "id=".$id);
	}
}
?>