<?php
$curdir = dirname(__FILE__);
require_once($curdir.'/Db.php');
class LoanAccount extends Db {
	protected static $table_name  = "loan_account";
	protected static $table_fields = array("id", "loanNo", "branch_id", "status", "loanProductId", "requestedAmount", "applicationDate", "disbursedAmount", "disbursementDate", "interestRate", "offSetPeriod", "gracePeriod", "repaymentsFrequency", "repaymentsMadeEvery", "installments", "penaltyCalculationMethodId", "penaltyTolerancePeriod", "penaltyRateChargedPer", "penaltyRate", "linkToDepositAccount", "comments", "createdBy", "dateCreated", "modifiedBy", "dateModified");
	
	protected static $member_sql = "SELECT `members`.`id` `clientId`, loanAccountId, CONCAT(`firstname`,' ',`lastname`,' ',`othername`) `clientNames`, 1 `clientType` FROM `member_loan_account` JOIN (SELECT `member`.`id`, `firstname`, `lastname`, `othername` FROM `member` JOIN `person` ON `member`.`personId`=`person`.`id`)`members` ON `memberId` = `members`.`id`";
	
	protected static $saccogroup_sql = "SELECT `saccogroup`.`id` `clientId`, `loanAccountId`, `groupName` `clientNames`, 2 as `clientType` FROM `group_loan_account` JOIN `saccogroup` ON `saccoGroupId` = `saccogroup`.`id`";
	
	protected static $loan_payments_sql = "(SELECT `loanAccountId`, COUNT(`id`)`paidInstallments`, COALESCE(SUM(amount),0) `amountPaid`  FROM `loan_repayment` GROUP BY `loanAccountId`) `loan_payments`";
	
	protected static $loan_fees_sql = "(SELECT  COALESCE(SUM(feeAmount),0) `feesPaid`, `loanAccountId` FROM `loan_account_fee` GROUP BY `loanAccountId`) loan_fees";
	
	public function findById($id){
		$result = $this->getrec(self::$table_name, "id=".$id, "", "");
		return !empty($result) ? $result:false;
	}
	
	public function findAll($where = 1){
		$result_array = $this->getarray(self::$table_name, $where, "", "");
		return !empty($result_array) ? $result_array : false;
	}
	
	public function findAllDetailsById($id){
		$fields = array( "`loan_account`.`id`", "`loanNo`", "`status`", "`productName`", "`requestedAmount`", "`applicationDate`", "`amountApproved`" , "`approvedBy`", "`approvalNotes`", "`approvalDate`", "`amountPaid`" , "`disbursedAmount`", "`disbursementDate`", "`disbursementNotes`", "`interestRate`", "`offSetPeriod`", "`gracePeriod`", "`loan_account`.`repaymentsFrequency`", "`loan_account`.`repaymentsMadeEvery`", "`installments`", "`loan_account`.`penaltyCalculationMethodId`", "`loan_account`.`penaltyTolerancePeriod`", "`loan_account`.`penaltyRateChargedPer`", "`penaltyRate`", "`loan_account`.`linkToDepositAccount`", "`comments`", "`loan_account`.`createdBy`", "`loan_account`.`dateCreated`");
		
		$table = self::$table_name." JOIN `loan_products` ON `loan_account`.`loanProductId` = `loan_products`.`id` LEFT JOIN ". self::$loan_payments_sql. " ON `loan_account`.`id` = `loan_payments`.`loanAccountId`";
		
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
		$fields = array( "`loan_account`.`id`", "`loanNo`", "`clientNames`", "`clientId`", "`clientType`", "`productName`", "`requestedAmount`", "`disbursedAmount`", "`amountApproved`", "`applicationDate`", "`offSetPeriod`" , "`loan_account`.`repaymentsFrequency`" , "`loan_account`.`repaymentsMadeEvery`" , "`status`" , "`approvalNotes`" , "`installments`" );
		
		$member_group_union_sql = self::$member_sql. " UNION ". self::$saccogroup_sql;
		
		$table = self::$table_name." JOIN (".$member_group_union_sql.") `clients` ON `clients`.`loanAccountId` = `loan_account`.`id` JOIN `loan_products` ON `loan_account`.`loanProductId` = `loan_products`.`id`";
	
		$result_array = $this->getfarray($table, implode(",",$fields), $where, "`clientNames`", "");
		return !empty($result_array) ? $result_array : false;
	}
	
	public function getApprovedLoans($where = 1){
		$fields = array( "`loan_account`.`id`", "`loanNo`", "`status`", "`clientNames`", "`clientType`", "`clientId`", "`productName`", "`requestedAmount`", "`disbursedAmount`", "`applicationDate`", "`offSetPeriod`", "`amountApproved`" , "`approvalNotes`" ,"`loan_account`.`repaymentsFrequency`" , "`loan_account`.`repaymentsMadeEvery`" , "`installments`" , "`amountPaid`" , "`interestRate`" , " `disbursedAmount`*(`interestRate`/100) `interest`" );
		
		$member_group_union_sql = self::$member_sql. " UNION ". self::$saccogroup_sql;
		
		$table = self::$table_name." JOIN (".$member_group_union_sql.") `clients` ON `clients`.`loanAccountId` = `loan_account`.`id` JOIN `loan_products` ON `loan_account`.`loanProductId` = `loan_products`.`id` LEFT JOIN ". self::$loan_payments_sql. " ON `loan_account`.`id` = `loan_payments`.`loanAccountId`";
	
		$result_array = $this->getfarray($table, implode(",",$fields), $where, "`clientNames`", "");
		return !empty($result_array) ? $result_array : false;
	}
	public function getReportIndividual($where = 1){
		$fields = array( "`loan_account`.`id`", "`loanNo`", "`status`", "`clientNames`", "`clientType`", "`clientId`", "`disbursedAmount`", "`installments`" , "`paidInstallments`" , "(`installments`-`paidInstallments`)`balInstallments`" , "`feesPaid`" , "`amountPaid`" , " (`disbursedAmount`*(`interestRate`/100)/`installments`) `interest`" , " ((`disbursedAmount`*(`interestRate`/100)/`installments`)*`paidInstallments`) `interestPaid`",  " `disbursedAmount`*(`interestRate`/100) `expInterest`", "COALESCE((`disbursedAmount`/`installments`),0)`principle`", "(COALESCE((`disbursedAmount`/`installments`),0)*`paidInstallments`) `paidPrinciple`" );
		
		$member_group_union_sql = self::$member_sql;
		
		$table = self::$table_name." JOIN (".$member_group_union_sql.") `clients` ON `clients`.`loanAccountId` = `loan_account`.`id` LEFT JOIN ". self::$loan_payments_sql. " ON `loan_account`.`id` = `loan_payments`.`loanAccountId` LEFT JOIN ". self::$loan_fees_sql. " ON `loan_account`.`id` = `loan_fees`.`loanAccountId`";
		
		$result_array = $this->getfarray($table, implode(",",$fields), $where, "`clientNames`", "");
		return $result_array;
	}
	public function getReportGroup($where = 1){
		$fields = array( "`loan_account`.`id`", "`loanNo`", "`status`", "`clientNames`", "`clientType`", "`clientId`", "`disbursedAmount`", "`installments`" , "`paidInstallments`" , "(`installments`-`paidInstallments`)`balInstallments`" , "`feesPaid`" , "`amountPaid`" , " (`disbursedAmount`*(`interestRate`/100)/`installments`) `interest`" , " ((`disbursedAmount`*(`interestRate`/100)/`installments`)*`paidInstallments`) `interestPaid`",  " `disbursedAmount`*(`interestRate`/100) `expInterest`", "COALESCE((`disbursedAmount`/`installments`),0)`principle`", "(COALESCE((`disbursedAmount`/`installments`),0)*`paidInstallments`) `paidPrinciple`" );
		
		$member_group_union_sql = self::$saccogroup_sql;
		
		$table = self::$table_name." JOIN (".$member_group_union_sql.") `clients` ON `clients`.`loanAccountId` = `loan_account`.`id` LEFT JOIN ". self::$loan_payments_sql. " ON `loan_account`.`id` = `loan_payments`.`loanAccountId` LEFT JOIN ". self::$loan_fees_sql. " ON `loan_account`.`id` = `loan_fees`.`loanAccountId`";
		
		$result_array = $this->getfarray($table, implode(",",$fields), $where, "`clientNames`", "");
		return $result_array;
	}
	public function getReport($start_date, $end_date, $client_type = 0, $category = 1){
		$between = "BETWEEN FROM_UNIXTIME($start_date) AND FROM_UNIXTIME($end_date)";
		$due_date = "GetDueDate(FROM_UNIXTIME(`disbursementDate`),`installments`,`repaymentsMadeEvery`,`repaymentsFrequency`,FROM_UNIXTIME($start_date),FROM_UNIXTIME($end_date))";
		
		$fields = array( "`loan_account`.`id`", "`loanNo`", "`status`", "`clientNames`", "`clientType`", "`clientId`", "`disbursedAmount`", "`installments`" , "`paidInstallments`" , "(`installments`-`paidInstallments`)`balInstallments`" , "`feesPaid`" , "`amountPaid`" , " (`disbursedAmount`*(`interestRate`/100)/`installments`) `interest`" , " ((`disbursedAmount`*(`interestRate`/100)/`installments`)*`paidInstallments`) `interestPaid`",  " `disbursedAmount`*(`interestRate`/100) `expInterest`", "COALESCE((`disbursedAmount`/`installments`),0)`principle`", "(COALESCE((`disbursedAmount`/`installments`),0)*`paidInstallments`) `paidPrinciple`", "$due_date `due_date`" );
		$where = ""; $payments_sql = self::$loan_payments_sql;
		//specification of the category of loans to be returned
		switch($category){
			case 1: //active loans
				$where .= "`status`=4";
			break;
			case 2: //performing loans
			break;
			case 3: //non performing loans
				$immediate_date = "ImmediateDueDate(FROM_UNIXTIME(`disbursementDate`),`installments`,`repaymentsMadeEvery`,`repaymentsFrequency`,FROM_UNIXTIME($end_date))";
				$timestamp_diff_sql = "(CASE `repaymentsMadeEvery`
					WHEN 1 THEN TIMESTAMPDIFF(DAY,FROM_UNIXTIME(`disbursementDate`),$immediate_date)
					WHEN 2 THEN TIMESTAMPDIFF(WEEK,FROM_UNIXTIME(`disbursementDate`),$immediate_date)
					WHEN 3 THEN TIMESTAMPDIFF(MONTH,FROM_UNIXTIME(`disbursementDate`),$immediate_date)
					END)";
				
				$payments_sql = "(SELECT `loanAccountId`, COUNT(`id`)`paidInstallments`, COALESCE(SUM(amount),0) `amountPaid`  FROM `loan_repayment` WHERE `transactionDate` <= $end_date GROUP BY `loanAccountId`) `loan_payments`";
				
				$where .= "$immediate_date IS NOT NULL AND ((`disbursedAmount`*(`interestRate`/100)/`installments`)+COALESCE((`disbursedAmount`/`installments`),0))*$timestamp_diff_sql>`amountPaid`";
			break;
			case 4: //due loans
				$timestamp_diff_sql = "(CASE `repaymentsMadeEvery`
					WHEN 1 THEN TIMESTAMPDIFF(DAY,FROM_UNIXTIME(`disbursementDate`),$due_date)
					WHEN 2 THEN TIMESTAMPDIFF(WEEK,FROM_UNIXTIME(`disbursementDate`),$due_date)
					WHEN 3 THEN TIMESTAMPDIFF(MONTH,FROM_UNIXTIME(`disbursementDate`),$due_date)
					END)";
				$where .= "$due_date IS NOT NULL AND ((`disbursedAmount`*(`interestRate`/100)/`installments`)+COALESCE((`disbursedAmount`/`installments`),0))*$timestamp_diff_sql>`amountPaid`";
			break;
			default;
		}
		
		$member_group_union_sql = $client_type==1?(self::$member_sql):($client_type==2?(self::$saccogroup_sql):(self::$member_sql. " UNION ". self::$saccogroup_sql));
		
		$table = self::$table_name." JOIN (".$member_group_union_sql.") `clients` ON `clients`.`loanAccountId` = `loan_account`.`id` LEFT JOIN ". $payments_sql. " ON `loan_account`.`id` = `loan_payments`.`loanAccountId` LEFT JOIN ". self::$loan_fees_sql. " ON `loan_account`.`id` = `loan_fees`.`loanAccountId`";
		
		$result_array = $this->getfarray($table, implode(",",$fields), $where, "`clientNames`", "");
		return $result_array;
	}
	
	public function getStatement($loanAccountId){
		$fields = array( "`ref`", "`transactionType`", "`amount`", "`desc`", "`transactionDate`" );
		
		$loan_repayments = "SELECT `id` `ref`,2 `transactionType`, `amount`,`comments` `desc`,`transactionDate` FROM `loan_repayment` WHERE `loanAccountId`=".$loanAccountId;
		
		$account_fees_sql = "SELECT `loan_account_fee`.`id` `ref`,2 `transactionType`,`feeAmount` `amount`, `desc`, `loan_account_fee`.`dateCreated` `transactionDate` FROM `loan_account_fee` JOIN (SELECT `loan_product_feen`.`id`,`loanProductId`, `feeName` `desc` FROM `loan_product_feen` JOIN `loan_product_fee` ON `loan_product_fee`.`id`=`loan_product_feen`.`loanProductFeeId`) `product_fees` ON `loan_account_fee`.`loanProductFeenId`=`product_fees`.`id` WHERE `loanAccountId`=".$loanAccountId;
		
		$loan_account_penalties_sql = "SELECT `id` `ref`,2 `transactionType`, `amount`,CONCAT(`daysDelayed`, ' days (delay)' )`desc`,`dateCreated` `transactionDate` FROM `loan_account_penalty` WHERE `loanAccountId`=".$loanAccountId;
		
		$loan_account_sql = "SELECT `id` `ref`,1 `transactionType`, `disbursedAmount` `amount`,'Disbursed amount' `desc`,`disbursementDate` `transactionDate` FROM `loan_account` WHERE `id`=".$loanAccountId;
		
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
			$where .= " AND`id` IN (".substr($in_part_string, 0, -1).")";
		}
		$result_array = $this->getfrec(self::$table_name, implode(",",$fields), $where, "", "");
		return !empty($result_array) ? $result_array : false;
	}
		
	public function addLoanAccount($data){
		$fields = array_slice(self::$table_fields, 1);
		$result = $this->add(self::$table_name, $fields, $this->generateAddFields($fields, $data));
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