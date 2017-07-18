<?php 
/* $show_table_js = false;
require_once("lib/Shares.php"); */
require_once("lib/Libraries.php");

$start_date = isset($_POST['start_date'])?$_POST['start_date']:strtotime("-30 day");
$end_date = isset($_POST['end_date'])?$_POST['end_date']:time();

if(isset($_POST['origin'])){
	switch($_POST['origin']){
		case 'dashboard':
			$member = new Member();
			$dashboard = new Dashboard();
			$loan_account_obj = new LoanAccount();
			$expense = new Expenses();
			$income = new Income();
			$loan = new Loans();
			$deposit_account_transaction_obj = new DepositAccountTransaction();
			/* $share = new Shares(); */
			
			//set the respective variables to be received from the calling page
			$figures = $tables = $percents = array();
			//No of members
			//1 in this period
			$figures['members'] = $member->noOfMembers(" (`dateAdded` BETWEEN ".$start_date." AND ".$end_date.") AND active=1");//
			//before this period
			$members_b4 = $member->noOfMembers(" `dateAdded` < ".$start_date." AND active=1");//(
			$percents['members'] = ($figures['members']>0&&$members_b4>0)?round(($figures['members']/$members_b4)*100,2):($figures['members']>0?100:0);

			//Total amount of paid subscriptions
			//1 in this period
			$figures['total_scptions'] = $dashboard->getCountOfSubscriptions("(`datePaid` BETWEEN ".$start_date." AND ".$end_date.")");
			//before this period
			$total_scptions_b4 = $dashboard->getCountOfSubscriptions("(`datePaid` < ".$start_date.")");
			//percentage increase/decrease
			$percents['scptions_percent'] = ($total_scptions_b4>0&&$figures['total_scptions']>0)?round(($figures['total_scptions']/$total_scptions_b4)*100,2):($figures['total_scptions']>0?100:0);

			//Total loan portfolio
			//1 in this period
			$figures['loan_portfolio'] = $dashboard->getSumOfLoans("`disbursementDate` BETWEEN ".$start_date." AND ".$end_date);
			//before this period
			$loan_portfolio_b4 = $dashboard->getSumOfLoans("(`disbursementDate` < ".$start_date.")");
			//percentage increase/decrease
			$percents['loan_portfolio'] = ($loan_portfolio_b4>0&&$figures['loan_portfolio']>0)?round(($figures['loan_portfolio']/$loan_portfolio_b4)*100,2):($figures['loan_portfolio']>0?100:0);

			//Total loan penalties
			//1 in this period
			$figures['loan_penalty'] = $dashboard->getSumOfLoans("`dateAdded` BETWEEN ".$start_date." AND ".$end_date);
			//before this period
			$loan_penalty_b4 = $dashboard->getSumOfLoans("(`dateAdded` < ".$start_date.")");
			//percentage increase/decrease
			$percents['loan_penalty'] = ($loan_penalty_b4>0&&$figures['loan_penalty']>0)?round(($figures['loan_penalty']/$loan_penalty_b4)*100,2):($figures['loan_penalty']>0?100:0);

			//Total loan payments
			//1 in this period
			$figures['loan_payments'] = $dashboard->getSumOfLoanRepayments("(`transactionDate` BETWEEN ".$start_date." AND ".$end_date.")");// AND `status`=3
			//before this period
			$loan_payments_b4 = $dashboard->getSumOfLoanRepayments("(`transactionDate` < ".$start_date.")");// AND `status`=3
			//percentage increase/decrease
			$percents['loan_payments'] = ($loan_payments_b4>0&&$figures['loan_payments']>0)?round(($figures['loan_payments']/$loan_payments_b4)*100,2):($figures['loan_payments']>0?100:0);

			//Total pending loans
			//1 in this period
			$figures['pending_loans'] = $dashboard->getCountOfLoans("(`applicationDate` BETWEEN ".$start_date." AND ".$end_date.") AND `status`=1");
			//before this period
			$pending_loans_b4 = $dashboard->getCountOfLoans("(`applicationDate` BETWEEN ".$start_date." AND ".$end_date.") AND `status`=1");
			//percentage increase/decrease
			$percents['pending_loans'] = ($pending_loans_b4>0&&$figures['pending_loans']>0)?round(($figures['pending_loans']/$pending_loans_b4)*100,2):($figures['pending_loans']>0?100:0);

			//Total rejected loans
			//1 in this period
			$figures['rejected_loans'] = $dashboard->getCountOfLoans("(`approvalDate` BETWEEN ".$start_date." AND ".$end_date.") AND `status`=2");
			//before this period
			$rejected_loans_b4 = $dashboard->getCountOfLoans("(`approvalDate` BETWEEN ".$start_date." AND ".$end_date.") AND `status`=2");
			//percentage increase/decrease
			$percents['rejected_loans'] = ($rejected_loans_b4>0&&$figures['rejected_loans']>0)?round(($figures['rejected_loans']/$rejected_loans_b4)*100,2):($figures['rejected_loans']>0?100:0);

			//Total approveded loans
			//1 in this period
			$figures['approved_loans'] = $dashboard->getCountOfLoans("(`approvalDate` BETWEEN ".$start_date." AND ".$end_date.") AND `status`=3");
			//before this period
			$approved_loans_b4 = $dashboard->getCountOfLoans("(`approvalDate` BETWEEN ".$start_date." AND ".$end_date.") AND `status`=3");
			//percentage increase/decrease
			$percents['approved_loans'] = ($approved_loans_b4>0&&$figures['approved_loans']>0)?round(($figures['approved_loans']/$approved_loans_b4)*100,2):($figures['approved_loans']>0?100:0);

			//Total disbursed loans
			//1 in this period
			$figures['disbursed_loans'] = $dashboard->getCountOfLoans("(`disbursementDate` BETWEEN ".$start_date." AND ".$end_date.") AND `status`=4");
			//before this period
			$disbursed_loans_b4 = $dashboard->getCountOfLoans("(`disbursementDate` BETWEEN ".$start_date." AND ".$end_date.") AND `status`=4");
			//percentage increase/decrease
			$percents['disbursed_loans'] = ($disbursed_loans_b4>0&&$figures['disbursed_loans']>0)?round(($figures['disbursed_loans']/$disbursed_loans_b4)*100,2):($figures['disbursed_loans']>0?100:0);

			//Withdraws
			//1 in this period
			$withdraws = ($deposit_account_transaction_obj->getMoneySum("2 AND (`dateCreated` BETWEEN ".$start_date." AND ".$end_date.")"));
			//Deposits
			$deposits = $deposit_account_transaction_obj->getMoneySum("1 AND (`dateCreated` BETWEEN ".$start_date." AND ".$end_date.")");
			//before this period 
			
			$deposits_b4 = $deposit_account_transaction_obj->getMoneySum("1 AND `dateCreated` < ".$start_date);
			//before this period  
			$withdraws_b4 = ($deposit_account_transaction_obj->getMoneySum("2 AND `dateCreated` < ".$start_date));
			
			//percentage increase/decrease
			$figures['savings'] = ($deposits - $withdraws);
			$b4 = $deposits_b4-$withdraws_b4;
			//percentage increase/decrease
			//we divide the current savings by the previous in order to get the percentage inc/decrease
			$percents['savings'] = ($figures['savings']>0&&$b4>0)?round((($figures['savings'])/$b4)*100,2):($figures['savings']>0?100:0);

			//Income
			$tables['income'] = $income->findAll("`dateAdded` BETWEEN ".$start_date." AND ".$end_date, "amount DESC", "10");

			//Expenses"
			$tables['expenses'] = $expense->findAllExpenses("`expenseDate` BETWEEN ".$start_date." AND ".$end_date, 10);

			$products_sql = "SELECT `productName`, SUM(`disbursedAmount`) `loan_amount`, SUM(`disbursedAmount`*`interestRate`/100) `interest`, `paidAmount` FROM `loan_products` LEFT JOIN `loan_account` ON `loan_account`.`loanProductId` = `loan_products`.`id` LEFT JOIN (SELECT COALESCE(SUM(`amount`),0) `paidAmount`, `loanAccountId` FROM `loan_repayment` WHERE `transactionDate` <= ".$end_date." GROUP BY `loanAccountId`) `payments` ON `loan_account`.`id`=`payments`.`loanAccountId` WHERE (`disbursementDate` BETWEEN ".$start_date." AND ".$end_date.") AND `status`=4 GROUP BY `productName` ORDER BY `productName`";
			
			$tables['loan_products'] = $loan->findLoans($products_sql);

			//line and barchart
			$barchart = getGraphData($start_date, $end_date);
			if($barchart){
				$_result['graph_data'] = $barchart;
			}

			//pie chart
			$piechart = getPieChartData($start_date, $end_date);
			if($piechart){
				$_result['pie_chart_data'] = $piechart['chart_data'];
				$figures['total_product_sales'] = $piechart['total_product_sales'];
			}
			
			$_result['figures'] = $figures;
			$_result['percents'] = $percents;
			$_result['tables'] = $tables;//

			echo json_encode($_result);
		break;
		case 'deposit_product':
			$depositProductType = new DepositProductType();
			$deposit_product_types = $depositProductType->findAll();
			echo json_encode($deposit_product_types);
		break;
		case 'loan_product':
			$loanProductType = new LoanProductType();
			$loanProductFee = new LoanProductFee();
			$penaltyCalculationMethod = new PenaltyCalculationMethod();
			$feeType = new FeeType();
			
			$data['loanProductTypes'] = $loanProductType->findAll();
			$data['feeTypes'] = $feeType->findAll();
			$data['existingProductFees'] = $loanProductFee->findAll();
			$data['penaltyCalculationMethods'] = $penaltyCalculationMethod->findAll();
			echo json_encode($data);
		break;
		case 'deposit_account':
			$depositProductObj = new DepositProduct();
			$productFeeObj = new DepositProductFee();
			$memberObj = new Member();
			$saccoGroupObj = new SaccoGroup();
			
			$data['products'] = $depositProductObj->findAll();
			$data['productFees'] = $productFeeObj->findAll();
			
			if(isset($_POST['depositAccountId'])&&is_numeric($_POST['depositAccountId'])){
				$depositAccountObj = new DepositAccount();
				$depositAccountTransactionObj = new DepositAccountTransaction();
				$data['account_details'] = $depositAccountObj->findAllDetailsById($_POST['depositAccountId']);
				$data['account_details']['statement'] = $depositAccountTransactionObj->getTransactionHistory($_POST['depositAccountId'], $_POST['start_date'], $_POST['end_date']);
			}else{
				$members = $memberObj->findSelectList();
				$groups = $saccoGroupObj->findSelectList();
				$data['customers'] = array_merge($members,$groups);
			}
			
			echo json_encode($data);
		break;
		case 'ledger':
			$depositAccountObj = new DepositAccount();
			$depositAccountTransactionObj = new DepositAccountTransaction();
			$depositAccountFeeObj = new DepositAccountFee();
			$loanAccountObj = new LoanAccount();
			$loanAccountPaymentObj = new LoanRepayment();
			$loanAccountFeeObj = new LoanAccountFee();
			
			$between = "";
			if((isset($_POST['start_date'])&& strlen($_POST['start_date'])>1) && (isset($_POST['end_date'])&& strlen($_POST['end_date'])>1)){
				$between = " BETWEEN ".$_POST['start_date']." AND ".$_POST['end_date'].")";
			}
			
			$depositAccountIds = $loanAccountIds = $deposit_account_where  = $loan_account_where = "";
			$deposit_account_ids_array = $loan_account_ids_array = false;
			$member_id = 0;
			if(isset($_POST['id'])&&is_numeric($_POST['id'])){
				if(isset($_POST['clientType'])&&is_numeric($_POST['clientType'])){
					switch($_POST['clientType']){
						case 1:
						$member_id = $_POST['id'];
						$sharesObj = new Shares();
						$subscriptionsObj = new Subscription();
						$member_loan_account_obj = new MemberLoanAccount();
						$member_deposit_account_obj = new MemberDepositAccount();
						
						$deposit_account_ids_array = $member_deposit_account_obj->getAccountIds($member_id);
						$loan_account_ids_array = $member_loan_account_obj->getAccountIds($member_id);
						
						$data['subscriptions'] = $subscriptionsObj->findSubscriptionAmount('memberId='.$member_id. ($between?"AND (datePaid ".$between:""));
						$data['shares'] = $sharesObj->findShareAmount('memberId='.$member_id);
						break;
						
						case 2:
						$group_id = $_POST['id'];
						$sacco_group_loan_account_obj = new SaccoGroupLoanAccount();
						$sacco_group_deposit_account_obj = new SaccoGroupDepositAccount();
						$deposit_account_ids_array = $sacco_group_deposit_account_obj->getAccountIds($group_id);
						$loan_account_ids_array = $sacco_group_loan_account_obj->getAccountIds($group_id);
						break;						
					}
					/* if(!empty($deposit_account_ids_array)){
						$depositAccountIds = "(";
						foreach($deposit_account_ids_array as $deposit_account_id_array){
							$depositAccountIds .= $deposit_account_id_array['depositAccountId'].",";
						}
						$depositAccountIds = substr($depositAccountIds,0,-1).")";
					}
					if(!empty($loan_account_ids_array)){
						$depositAccountIds = "(";
						foreach($loan_account_ids_array as $loan_account_id_array){
							$loanAccountIds .= $loan_account_id_array['loanAccountId'].",";
						}
						$loanAccountIds = substr($loanAccountIds,0,-1).")";
					} */
					
					$data['deposits'] = empty($deposit_account_ids_array) ? 0 : $depositAccountTransactionObj->getMoneySum("1 ". ($between?"AND (dateCreated ".$between:""), $deposit_account_ids_array);
					$data['withdraws'] = empty($deposit_account_ids_array) ? 0 :  $depositAccountTransactionObj->getMoneySum("2 ". ($between?"AND (dateCreated ".$between:""), $deposit_account_ids_array);
					$data['deposit_account_fees'] = empty($deposit_account_ids_array) ? 0 :  $depositAccountFeeObj->getSum(($between?"(dateCreated ".$between:"1 "),$deposit_account_ids_array);
					$data['disbursedLoan'] = empty($loan_account_ids_array) ? 0 :  $loanAccountObj->getSumOfFields(($between?"(`disbursementDate` ".$between:"1"),$loan_account_ids_array);
					$data['loan_payments'] = empty($loan_account_ids_array) ? 0 :  $loanAccountPaymentObj->getPaidAmount(($between?"(`transactionDate` ".$between:"1"),$loan_account_ids_array);
					$data['loan_account_fees'] = empty($loan_account_ids_array) ? 0 :  $loanAccountFeeObj->getSum(($between?"(`dateCreated` ".$between:"1 "),$loan_account_ids_array);
				}
			}else{
				$sharesObj = new Shares();
				$subscriptionsObj = new Subscription();
				$expensesObj = new Expenses();
				$data['subscriptions'] = $subscriptionsObj->findSubscriptionAmount(($between?"(datePaid ".$between:""));
				$data['shares'] = $sharesObj->findShareAmount(($between?"(`datePaid` ".$between:""));
				$data['expenses'] = $expensesObj->findExpensesSum(($between?"(`expenseDate` ".$between:""));
				$data['opening_balances'] = $depositAccountObj->getSumOfFields(($between?"(`dateCreated` ".$between:"1 "), $deposit_account_ids_array);
				
				$data['deposits'] = $depositAccountTransactionObj->getMoneySum("1 ". ($between?"AND (`dateCreated` ".$between:""),  $deposit_account_ids_array);
				$data['withdraws'] = $depositAccountTransactionObj->getMoneySum("2 ". ($between?"AND (`dateCreated` ".$between:""),  $deposit_account_ids_array);
				$data['deposit_account_fees'] = $depositAccountFeeObj->getSum(($between?"(dateCreated ".$between:"1 "),$deposit_account_ids_array);
				$data['disbursedLoan'] = $loanAccountObj->getSumOfFields(($between?"(`disbursementDate` ".$between:"1 "),$loan_account_ids_array);
				$data['loan_payments'] = $loanAccountPaymentObj->getPaidAmount(($between?"(`transactionDate` ".$between:"1"),$loan_account_ids_array);
				$data['loan_account_fees'] = $loanAccountFeeObj->getSum(($between?"(`dateCreated` ".$between:"1 "),$loan_account_ids_array);
			}
			echo json_encode($data);
		break;
		case 'loan_account':
			$loanProductObj = new LoanProduct();
			$productFeeObj = new LoanProductFeen();
			$guarantorObj = new Guarantor();
			$saccoGroupObj = new SaccoGroup();
			$memberObj = new Member();
			
			$data['products'] = $loanProductObj->findAll();
			$data['productFees'] = $productFeeObj->findAllLPFDetails();
			$data['guarantors'] = $guarantorObj->getLoanGuarantors();
			if(isset($_POST['loanAccountId'])&&is_numeric($_POST['loanAccountId'])){
				$loanAccountObj = new LoanAccount();
				$data['account_details'] = $loanAccountObj->findAllDetailsById($_POST['loanAccountId']);
				$data['account_details']['statement'] = $loanAccountObj->getStatement($_POST['loanAccountId']);
			}else{
				$members = $memberObj->findSelectList();
				$groups = $saccoGroupObj->findSelectList();
				$data['customers'] = array_merge($members,$groups);
			}
			
			
			echo json_encode($data);
		break;
		case 'loan_report':
			$loanReportObj = new LoanAccount();
			$data['data'] = $loanReportObj->getReport("`status`=4");
			echo json_encode($data);
		break;
		case 'loan_report_individual':
			$loanReportObj = new LoanAccount();
			$data['data'] = $loanReportObj->getReportIndividual("`status`=4");
			echo json_encode($data);
		break;
		case 'loan_report_group':
			$loanReportObj = new LoanAccount();
			$data['data'] = $loanReportObj->getReportGroup("`status`=4");
			echo json_encode($data);
		break;
		case 'loan_products':
			$loanProduct = new LoanProduct();
			$loan_products = $loanProduct->getDtData();
			echo json_encode($loan_products);
		break;
		case 'member_savings':
			if(isset($_POST['id'])&&$_POST['id']){
				$depositAccountId = $_POST['id'];
				$depositAccountTransaction = new DepositAccountTransaction();
				$transactonHistory = $depositAccountTransaction->getCurrentTransactionHistory($depositAccountId);
				echo json_encode($transactonHistory);
			}
		break;
		case 'loan_accounts':
			$loanAccount = new LoanAccount();
			$where = "`status`=".$_POST['status'];
			if((isset($_POST['start_date'])&& strlen($_POST['start_date'])>1) && (isset($_POST['end_date'])&& strlen($_POST['end_date'])>1)){
				$action_date = ($_POST['status']==4)?"disbursementDate":($_POST['status']==3||$_POST['status']==2)?"approvalDate":"applicationDate";
				$where .= " AND (`".($action_date)."` BETWEEN ".$_POST['start_date']." AND ".$_POST['end_date'].")";
			}
			if(isset($_POST['clientType'])&&isset($_POST['id'])){
				$where .= " AND `clientId`=".$_POST['id'];
				$where .= " AND `clientType`=".$_POST['clientType'];
			}
			if($_POST['status']==3||$_POST['status']==4){
				$output['data'] = $loanAccount->getApprovedLoans($where);
			}else{
				$output['data'] = $loanAccount->getApplications($where);
			}
			
			echo json_encode($output);
		break;
		case 'loan_account_transactions':
			$loanAccountId = $_POST['id'];
			$loanAccountTransaction = new LoanRepayment();
			$transactonHistory = $loanAccountTransaction->getTransactionHistory($loanAccountId);
			echo json_encode($transactonHistory);
		break;
		case 'loan_application_details':
			if(isset($_POST['id'])&&$_POST['id']&&isset($_POST['clientType'])&&isset($_POST['clientId'])){
				$loanAccountId = $_POST['id'];
				$clientId = $_POST['clientId'];
				if($_POST['clientType'] == 1){
					$guarantorObj = new Guarantor();
					$collateralObj = new LoanCollateral();
					$data['guarantors'] = $guarantorObj->getLoanGuarantors($loanAccountId);
					$data['collateral_items'] = $collateralObj->findAll("`loanAccountId`=".$loanAccountId);
					if(isset($_POST['edit_loan'])&&$_POST['edit_loan']==1){
						
						$loanAccountObj = new LoanAccount();
						$loanAccountFeeObj = new LoanAccountFee();
						$loanProductObj = new LoanProduct();
						
						$data['loan_account_details'] = $loanAccountObj->findById($loanAccountId);
						$data['loan_product'] = $loanProductObj->findById($data['loan_account_details']['loanProductId']);
						$data['loan_account_fees'] = $loanAccountFeeObj->findAllDetailsByLoanAccountId($loanAccountId);
					}else{
						$personObj = new Person();
						$memberObj = new Member();
						$memberData = $memberObj->findById($clientId);
						$data['member_details'] = $personObj->findById($memberData['personId']);
						$data['relatives'] = $personObj->findPersonRelatives($memberData['personId']);
						$data['employmentHistory'] = $personObj->findPersonEmploymentHistory($memberData['personId']);
					}
				}
				if($_POST['clientType'] == 2){
					$saccoGroupObj = new SaccoGroup();
					$data['groupMembers'] = $saccoGroupObj->findSaccoGroupMembers($clientId);
				}
				echo json_encode($data);
			}
		break;
		case 'general_subscription':
			$subscription = new Subscription();
			$subscription_data['data'] = $subscription->findGeneralSubscriptions();
			echo json_encode($subscription_data);
		break;
		case 'general_shares':
			$shares = new Shares();
			$shares_data['data'] = $shares->findGeneralShares();
			echo json_encode($shares_data);
		break;
		case 'view_members':
			$member = new Member();
			$member_data['data'] = $member->findAll();
			echo json_encode($member_data);
		break;
		default:
		echo json_encode("nothing found");
	}
}


function getGraphData($start_date, $end_date){
	$days = round(($end_date-$start_date)/86400);
	$dashboard = new Dashboard();
	$loanProduct = new LoanProduct();
	
	//arrays with data for the past i days/months
	$graph_data = $data_points = array();
	
	$_end = new DateTime(date("Y-m-d",$end_date));
	//$period = new DatePeriod( new DateTime(date("Y-m-d",$start_date)), new DateInterval('P1D'), $_end );
	$period = new DatePeriod( new DateTime(date("Y-m-d",$start_date)), new DateInterval('P1D'), $_end );
	$period_dates = iterator_to_array($period);
	
	$graph_data['title']['text'] = "Total product sales, ".date('j M, y',$start_date)." - ".date('j M, y',$end_date);
	$graph_data['yAxis']['title']['text'] = "UGX";
	
	$loan_products = $loanProduct->findAll();
	
	//if days are 7 or less
	if($days == 0 || $days <8){
		foreach($loan_products as $product){
			$datasets = array();
			$datasets['name'] = $product['productName'];
			
			foreach($period_dates as $period_date){
				$datasets['data'][] = $dashboard->getSumOfLoans("DAY(FROM_UNIXTIME(`disbursementDate`)) = DAY(FROM_UNIXTIME(".$period_date->getTimestamp().")) AND  `loanProductId`=".$product['id']);
			}
			$graph_data['datasets'][] = $datasets;
		}
		foreach($period_dates as $period_date){
			$data_points[] = $period_date->format("D, j/n");
		}
	}
	elseif($days > 7 && $days <32){
		/*split the days into weeks
		*generate an array holding the start and end dates of the given period
		*/
		$weeks = array();
		$index = 0;
		$weeks[$index]['start'] = $start_date;
		if(date('N',$start_date)==7){
			$weeks[$index++]['end'] = $start_date;
		}
		for($i = $index; $i<count($period_dates);$i++){
			$period_date = $period_dates[$i];
			if($period_date->format('N')==1){
				$weeks[$index]['start'] = $period_date->getTimestamp();
			}
			if($period_date->format('N')==7){
				$weeks[$index++]['end'] = $period_date->getTimestamp();
			}
		}
		$weeks[$index]['end'] = $end_date;
		if(date('N',$end_date)==1){
			$weeks[$index]['start'] = $end_date;
		}
		/* print_r($weeks); */
		foreach($loan_products as $product){
			$datasets = array();
			$datasets['name'] = $product['productName'];
			
			foreach($weeks as $week){
				$between = "BETWEEN ".$week['start']." AND ".$week['end'].")";
				$datasets['data'][] = $dashboard->getSumOfLoans("`disbursementDate` <= ".$week['end']." AND `loanProductId`=".$product['id']);
				$data_points[] = /**/date('j/M', $week['start'])."-".date('j/M', $week['end']);
			}
			$graph_data['datasets'][] = $datasets;
		}
		
	}
	elseif($days > 31){
		/*split the days into months
		*generate an array holding the start and end dates of the given period */
		
		$months = array();
		$index = 0;
		$months[$index]['start'] = $start_date;
		if(date('j',$start_date)==date('t',$start_date)){
			$months[$index++]['end'] = $start_date;
		}
		for($i = $index; $i<count($period_dates);$i++){
			$period_date = $period_dates[$i];
			if($period_date->format('j')==1){
				$months[$index]['start'] = $period_date->format('Y-m-d');
			}
			if($period_date->format('j')==$period_date->format('t')){
				$months[$index++]['end'] = $period_date->getTimestamp();
			}
		}
		$months[$index]['end'] = $end_date;
		if(date('j',$end_date) == date('t',$end_date)){
			$months[$index]['start'] = $end_date;
			$months[$index]['end'] = $end_date;
		}
		foreach($loan_products as $product){
			$datasets = array();
			$datasets['name'] = $product['productName'];
			
			foreach($months as $month){
				$between = "BETWEEN ".$month['start']." AND ".$month['end'].")";
				$datasets['data'][] = $dashboard->getSumOfLoans($between." AND  `loanProductId`=".$product['id']);
				$data_points[] = /*date('M/Y', $week['start'])."-".*/date('M/Y', $month['end']);
			}
			$graph_data['datasets'][] = $datasets;
		}
	}
	if(!empty($graph_data)){
		$graph_data['xAxis']['categories'] = $data_points;
		return $graph_data;
	}
	else return false;	
}

function getPieChartData($start_date, $end_date){
	$dashboard = new Dashboard();
	$loanProduct = new LoanProduct();
	$loan_products = $loanProduct->findAll();
	
	$pie_chart_data = array();
	$products_sum = 0;
	
	$between = "BETWEEN ".$start_date." AND ".$end_date.")";
	$pie_chart_data['series']['name'] = 'Loan Products';
	foreach($loan_products as $product){
		$products_sum += $total_amount = $dashboard->getSumOfLoans("(`disbursementDate` ".$between." AND `loanProductId`=".$product['id']);
		$pie_chart_data['series']['data'][] = array('name'=>$product['productName'],'y'=>$total_amount);
	}//
	$pie_chart_data['title']['text'] = "Total product sales ".date('j M, y',$start_date)." - ".date('j M, y',$end_date);
	
	if($loan_products){
		$pie_chart = array('total_product_sales'=>$products_sum,'chart_data'=>$pie_chart_data);
		return $pie_chart;
	}
	else return false;	
}

function getGraphProps(){
	$datasets = array();
	$datasets['backgroundColor'] = "rgba(".rand(0,255).", ".rand(0,255).", ".rand(0,255).", ".(rand(0,100)/100).")";
	$datasets['borderColor'] = "rgba(".rand(0,255).", ".rand(0,255).", ".rand(0,255).", ".(rand(0,100)/100).")";
	$datasets['pointBackgroundColor'] = "rgba(".rand(0,255).", ".rand(0,255).", ".rand(0,255).", ".(rand(0,100)/100).")";
	$datasets['pointHoverBackgroundColor'] = "#fff";
	$datasets['pointHoverBorderColor'] = "rgba(".rand(0,255).", ".rand(0,255).", ".rand(0,255).", ".(rand(0,100)/100).")";
	$datasets['pointBorderWidth'] = 1;
	/* 
	$datasets['fillColor'] = "rgba(".rand(0,255).", ".rand(0,255).", ".rand(0,255).", ".(rand(0,10)/10).")";
	$datasets['strokeColor'] = "rgba(".rand(0,255).", ".rand(0,255).", ".rand(0,255).", ".(rand(0,10)/10).")";
	$datasets['pointColor'] = "rgba(".rand(0,255).", ".rand(0,255).", ".rand(0,255).", ".(rand(0,10)/10).")";
	$datasets['pointStrokeColor'] = "#fff";
	$datasets['pointHighlightFill'] = "#fff";
	$datasets['pointHighlightStroke'] = "rgba(".rand(0,255).", ".rand(0,255).", ".rand(0,255).", ".(rand(0,10)/10).")"; */
	return $datasets;
}
?>