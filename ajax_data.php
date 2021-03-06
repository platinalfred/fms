<?php 
/* $show_table_js = false;
require_once("lib/Shares.php"); */
require_once("lib/Libraries.php");
session_start();
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
			$deposit_account = new DepositAccount();
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
			$figures['total_shares'] = $dashboard->getSumOfShares("(`datePaid` BETWEEN ".$start_date." AND ".$end_date.")");
			//before this period
			$total_shares_b4 = $dashboard->getSumOfShares("(`datePaid` < ".$start_date.")");
			//percentage increase/decrease
			$percents['shares_percent'] = ($total_shares_b4>0&&$figures['total_shares']>0)?round(($figures['total_shares']/$total_shares_b4)*100,2):($figures['total_shares']>0?100:0);

			//Total amount of paid subscriptions
			//1 in this period
			$figures['total_scptions'] = $dashboard->getSumOfSubscriptions("(`datePaid` BETWEEN ".$start_date." AND ".$end_date.")");
			//before this period
			$total_scptions_b4 = $dashboard->getSumOfSubscriptions("(`datePaid` < ".$start_date.")");
			//percentage increase/decrease
			$percents['scptions_percent'] = ($total_scptions_b4>0&&$figures['total_scptions']>0)?round(($figures['total_scptions']/$total_scptions_b4)*100,2):($figures['total_scptions']>0?100:0);

			//Total loan portfolio
			//1 in this period
			$figures['loan_portfolio'] = $dashboard->getSumOfLoans("`disbursementDate` BETWEEN ".$start_date." AND ".$end_date);
			//before this period
			$loan_portfolio_b4 = $dashboard->getSumOfLoans("(`disbursementDate` < ".$start_date.")");
			//percentage increase/decrease
			$percents['loan_portfolio'] = ($loan_portfolio_b4>0&&$figures['loan_portfolio']>0)?round(($figures['loan_portfolio']/$loan_portfolio_b4)*100,2):($figures['loan_portfolio']>0?100:0);

			//Total expected interest
			//1 in this period
			$figures['loan_interest'] = $dashboard->getSumOfInterest("`disbursementDate` BETWEEN ".$start_date." AND ".$end_date);
			//before this period
			$loan_portfolio_b4 = $dashboard->getSumOfInterest("(`disbursementDate` < ".$start_date.")");
			//percentage increase/decrease
			$percents['loan_interest'] = ($loan_portfolio_b4>0&&$figures['loan_interest']>0)?round(($figures['loan_interest']/$loan_portfolio_b4)*100,2):($figures['loan_interest']>0?100:0);

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
			$figures['pending_loans'] = $dashboard->getCountOfLoans("(`applicationDate` BETWEEN ".$start_date." AND ".$end_date.") AND `status`=3");
			//before this period
			$pending_loans_b4 = $dashboard->getCountOfLoans("(`applicationDate` BETWEEN ".$start_date." AND ".$end_date.") AND `status`=3");
			//percentage increase/decrease
			$percents['pending_loans'] = ($pending_loans_b4>0&&$figures['pending_loans']>0)?round(($figures['pending_loans']/$pending_loans_b4)*100,2):($figures['pending_loans']>0?100:0);

			//Total rejected loans
			//1 in this period
			$figures['rejected_loans'] = $dashboard->getCountOfLoans("(`approvalDate` BETWEEN ".$start_date." AND ".$end_date.") AND `status`=11");
			//before this period
			$rejected_loans_b4 = $dashboard->getCountOfLoans("(`approvalDate` BETWEEN ".$start_date." AND ".$end_date.") AND `status`=11");
			//percentage increase/decrease
			$percents['rejected_loans'] = ($rejected_loans_b4>0&&$figures['rejected_loans']>0)?round(($figures['rejected_loans']/$rejected_loans_b4)*100,2):($figures['rejected_loans']>0?100:0);

			//Total approveded loans
			//1 in this period
			$figures['approved_loans'] = $dashboard->getCountOfLoans("(`approvalDate` BETWEEN ".$start_date." AND ".$end_date.") AND `status`=4");
			//before this period
			$approved_loans_b4 = $dashboard->getCountOfLoans("(`approvalDate` BETWEEN ".$start_date." AND ".$end_date.") AND `status`=4");
			//percentage increase/decrease
			$percents['approved_loans'] = ($approved_loans_b4>0&&$figures['approved_loans']>0)?round(($figures['approved_loans']/$approved_loans_b4)*100,2):($figures['approved_loans']>0?100:0);

			//Total disbursed loans
			//1 in this period
			$figures['disbursed_loans'] = $dashboard->getCountOfLoans("(`disbursementDate` BETWEEN ".$start_date." AND ".$end_date.") AND `status`=5");
			//before this period
			$disbursed_loans_b4 = $dashboard->getCountOfLoans("(`disbursementDate` BETWEEN ".$start_date." AND ".$end_date.") AND `status`=5");
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
			$tables['income'] = $income->findOtherIncome("`dateAdded` BETWEEN ".$start_date." AND ".$end_date, "amount DESC", 10);
			//Savings
			$tables['savings'] = $deposit_account->findRecentDeposits($start_date, $end_date, 10);
			//$tables['savings'] = $depositAccount->findRecentDeposits($start_date, $end_date, 10);

			//Expenses"
			$tables['expenses'] = $expense->findAllExpenses("`expenseDate` BETWEEN ".$start_date." AND ".$end_date, 10);
			
			$tables['loan_products'] = $loan_account_obj->findLoans($start_date, $end_date, 10);

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
						
						$data['subscriptions'] = $subscriptionsObj->findSubscriptionAmount('memberId='.$member_id. ($between?" AND (datePaid ".$between:""));
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
					
					$data['deposits'] = empty($deposit_account_ids_array) ? 0 : $depositAccountTransactionObj->getMoneySum("1 ". ($between?" AND (dateCreated ".$between:""), $deposit_account_ids_array);
					$data['withdraws'] = empty($deposit_account_ids_array) ? 0 :  $depositAccountTransactionObj->getMoneySum("2 ". ($between?" AND (dateCreated ".$between:""), $deposit_account_ids_array);
					$data['deposit_account_fees'] = empty($deposit_account_ids_array) ? 0 :  $depositAccountFeeObj->getSum(($between?"(dateCreated ".$between:"1 "),$deposit_account_ids_array);
					$data['disbursedLoan'] = empty($loan_account_ids_array) ? array('loanAmount'=>0,'interestAmount'=>0) :  $loanAccountObj->getSumOfFields(($between?"(`disbursementDate` ".$between:"1"),$loan_account_ids_array);
					$data['loan_payments'] = empty($loan_account_ids_array) ? 0 :  $loanAccountPaymentObj->getPaidAmount(($between?"(`transactionDate` ".$between:"1"),$loan_account_ids_array);
					$data['loan_account_fees'] = empty($loan_account_ids_array) ? 0 :  $loanAccountFeeObj->getSum(($between?"(`dateCreated` ".$between:"1 "),$loan_account_ids_array);
					$data['opening_balances'] = empty($deposit_account_ids_array)?0:$depositAccountObj->getSumOfFields(($between?"(`dateCreated` ".$between:"1 "), $deposit_account_ids_array);
				}
			}else{
				$sharesObj = new Shares();
				$subscriptionsObj = new Subscription();
				$expensesObj = new Expenses();
				$incomeObj = new Income();
				$data['subscriptions'] = $subscriptionsObj->findSubscriptionAmount(($between?"(datePaid ".$between:""));
				$data['shares'] = $sharesObj->findShareAmount(($between?"(`datePaid` ".$between:""));
				$data['expenses'] = $expensesObj->findExpensesSum(($between?"(`expenseDate` ".$between:""));
				$data['other_income_sources'] = $incomeObj->findIncomeSum(($between?"(`dateAdded` ".$between:""));
				$data['opening_balances'] = $depositAccountObj->getSumOfFields(($between?"(`dateCreated` ".$between:"1 "), $deposit_account_ids_array);
				
				
				
				$data['deposits'] = $depositAccountTransactionObj->getMoneySum("1 ". ($between?" AND (`dateCreated` ".$between:""),  $deposit_account_ids_array);
				$data['withdraws'] = $depositAccountTransactionObj->getMoneySum("2 ". ($between?" AND (`dateCreated` ".$between:""),  $deposit_account_ids_array);
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
			//$saccoGroupObj = new SaccoGroup();
			
			if(!isset($_POST['grpLId'])){
				$availableTo = "`availableTo` IN ".((isset($_POST['groupId'])&&is_numeric($_POST['groupId']))?"(2,3)":"(1,3)");
				$data['products'] = $loanProductObj->findAll($availableTo);
			}
			$data['productFees'] = $productFeeObj->findAllLPFDetails();
			if(isset($_POST['loanAccountId'])&&is_numeric($_POST['loanAccountId'])){
				$loanAccountObj = new LoanAccount();
				$collateralObj = new LoanCollateral();
				$loanAccountFeeObj = new LoanAccountFee();
				
				$data['account_details'] = $loanAccountObj->findAllDetailsById($_POST['loanAccountId']);
				$data['account_details']['statement'] = $loanAccountObj->getStatement($_POST['loanAccountId']);
				$data['account_details']['guarantors'] = $guarantorObj->getLoanGuarantors($_POST['loanAccountId']);
				$data['account_details']['collateral_items'] = $collateralObj->findAll("`loanAccountId`=".$_POST['loanAccountId']);
				$data['account_details']['loan_account_fees'] = $loanAccountFeeObj->findAllDetailsByLoanAccountId($_POST['loanAccountId']);
			}else{
				$where = "";
				if((isset($_POST['groupId'])&&is_numeric($_POST['groupId']))&&(isset($_POST['grpLId'])&&is_numeric($_POST['grpLId']))){
					$where = "`member`.`id` IN (SELECT `memberId` FROM `group_members` WHERE `groupId` = {$_POST['groupId']}) AND `member`.`id` NOT IN (SELECT `memberId` FROM `loan_account` WHERE `groupLoanAccountId` = {$_POST['grpLId']})";
					
					//get the loan product for this group loan
					$loan_product = $loanProductObj->getGroupLoanProduct($_POST['grpLId']);
					$data['product'] = $loanProductObj->findById($loan_product['loanProductId']);
				}
				else{
					$data['guarantors'] = $guarantorObj->getLoanGuarantors();
				}
				if(!isset($_POST['memberId'])){
					$memberObj = new Member();
					$data['clients'] = $memberObj->findSelectList($where);
				}
			}
			//$data['groups'] = $saccoGroupObj->findSelectList();
			//$data['groupMembers'] = $saccoGroupObj->findGroupMembers();
			
			echo json_encode($data);
		break;
		case 'loan_report':
			$loanReportObj = new LoanAccount();
			$data['data'] = $loanReportObj->getReport($start_date,$end_date, $_POST['client_type'], $_POST['category']);
			echo json_encode($data);
		break;
		case 'loan_product_report':
			$loanReportObj = new LoanAccount();
			$data['data'] = $loanReportObj->findLoans($start_date, $end_date);
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
			$oanAccountObj = new LoanAccount();
			$where = "1";
			if(isset($_POST['status']) && is_numeric($_POST['status'])){
				$where = "`status`=".$_POST['status'];
			}
			if((isset($_POST['start_date'])&& strlen($_POST['start_date'])>1) && (isset($_POST['end_date'])&& strlen($_POST['end_date'])>1)){
				$action_date = (in_array($_POST['status'],array(5,13,14,15,16)))?"disbursementDate":((in_array($_POST['status'],array(4)))?"approvalDate":"applicationDate");
				
				$where .= " AND (`".($action_date)."` BETWEEN ".$_POST['start_date']." AND ".$_POST['end_date'].")";
			}
			if(isset($_POST['memberId'])){
				$where .= " AND `memberId`=".$_POST['memberId'];
			}
			if(isset($_POST['groupId'])&&is_numeric($_POST['groupId'])){
				$where .= " AND `groupId`=".$_POST['groupId'];
			}
			if(isset($_POST['grpLId'])&&is_numeric($_POST['grpLId'])){//this caters for the display of loans taken in groups
				$where .= " AND `groupLoanAccountId`=".$_POST['grpLId'];
			}
			if(isset($_POST['status']) && ($_POST['status']==4||$_POST['status']==5)){
				$output['data'] = $oanAccountObj->getApprovedLoans($where);
			}else{
				if(isset($_POST['status']) && $_POST['status']==3){
					if(!isset($_SESSION['admin'])){
						if(isset($_SESSION['branch_credit']) && $_SESSION['branch_credit']){
							 $where .= " AND `requestedAmount` < 1000001";
						 }else if(isset($_SESSION['management_credit'])&& $_SESSION['management_credit']){
							$where .= " AND (`requestedAmount` BETWEEN 1000000 AND 5000001)";
						}elseif(isset($_SESSION['executive_board'])&& $_SESSION['executive_board']){
							$where .= " AND `requestedAmount` > 5000000";
						}
					}
				}
				//echo $where;
				$output['data'] = $oanAccountObj->getApplications($where);
			}
			echo json_encode($output);
		break;
		case 'group_loan_accounts':
				$loanAccountObj = new LoanAccount();
				$where = "";
				if(isset($_POST['groupId'])){
					$where = "`saccoGroupId` = {$_POST['groupId']}";
				}
				$output['data'] = $loanAccountObj->getGroupLoanAccounts($where);
			echo json_encode($output);
		break;
		case 'group_loan_ref_accounts': //loan accounts of a particular ref id
				$loanAccountObj = new LoanAccount();
				$where = "";
				if(isset($_POST['grpLId'])){
					$where = "`groupLoanAccountId` = {$_POST['grpLId']}";
				}
				$output = $loanAccountObj->getApplications($where);
			echo json_encode($output);
		break;
		case 'loan_application_details':
			if(isset($_POST['id'])&&$_POST['id']&&isset($_POST['memberId'])){
				$loanAccountId = $_POST['id'];
				$memberId = $_POST['memberId'];
				$data = array();
				//is this a group loan, then retrieve all the other member loans for approval purposes
				/* if(isset($_POST['groupLoanAccountId'])&&is_numeric($_POST['groupLoanAccountId'])&&($_POST['groupLoanAccountId']>0)&&isset($_POST['status'])&&is_numeric($_POST['status'])&&(in_array($_POST['status'],array(1,2,3,4)))){
					$loan_account_obj = new LoanAccount();
					$data = $loan_account_obj->getApplications("`groupLoanAccountId`=".$_POST['groupLoanAccountId']);
					foreach($data as $key=>$loanAccount){
						$guarantorObj = new Guarantor();
						$data[$key]['guarantors'] = $guarantorObj->getLoanGuarantors($loanAccount['id']);
						
						//is the loan disbursed, if so show any payments that have been made
						if(isset($_POST['status'])&&is_numeric($_POST['status'])&&in_array($loanAccount['status'],array(5,6))){
							$loan_account_transaction_obj = new LoanRepayment();
							$data[$key]['transactionHistory'] = $loan_account_transaction_obj->getTransactionHistory($loanAccount['id']);
						}
						//any approvals/forwarding
						$loan_account_approvals_obj = new LoanAccountApproval();
						$data[$key]['approvals'] = $loan_account_approvals_obj->getLoanAccountApprovals("`loanAccountId`=".$loanAccount['id']);
						
						
						$personObj = new Person();
						$memberObj = new Member();
						$loanAccountFeeObj = new LoanAccountFee();
						
						$memberData = $memberObj->findById($loanAccount['memberId']);
						$data[$key]['member_details'] = $personObj->findById($memberData['personId']);
						$data[$key]['relatives'] = $personObj->findPersonRelatives($memberData['personId']);
						$data[$key]['employmentHistory'] = $personObj->findPersonEmploymentHistory($memberData['personId']);
						$data[$key]['loan_account_fees'] = $loanAccountFeeObj->findAllDetailsByLoanAccountId($loanAccount['id']);
						$data[$key]['memberBusinesses'] = $personObj->findMemberBusiness($memberData['personId']);
					}
				}else{ */
					$loanAccountFeeObj = new LoanAccountFee();
					$personObj = new Person();
					$memberObj = new Member();
					$loanAccountObj = new LoanAccount();
					$loan_account_approvals_obj = new LoanAccountApproval();
					
					$data = $loanAccountObj->findById($loanAccountId);
					
					if(( isset($_POST['groupLoanAccountId']) && !is_numeric($_POST['groupLoanAccountId']) )||!isset($_POST['groupLoanAccountId'])){
						$guarantorObj = new Guarantor();
						$collateralObj = new LoanCollateral();
						$data['guarantors'] = $guarantorObj->getLoanGuarantors($loanAccountId);
						$data['collateral_items'] = $collateralObj->findAll("`loanAccountId`=".$loanAccountId);
					}
					
					//any approvals/forwarding
					$data['approvals'] = $loan_account_approvals_obj->getLoanAccountApprovals("`loanAccountId`=".$loanAccountId);
					
					//is the loan disbursed, if so show any payments that have been made
					if(isset($_POST['status'])&&is_numeric($_POST['status'])&&in_array($_POST['status'],array(5,6))){
						$loan_account_transaction_obj = new LoanRepayment();
						$data['transactionHistory'] = $loan_account_transaction_obj->getTransactionHistory($_POST['id']);
					}
					
					$data['loan_account_fees'] = $loanAccountFeeObj->findAllDetailsByLoanAccountId($loanAccountId);
					$memberData = $memberObj->findById($memberId);
					$data['member_details'] = $personObj->findById($memberData['personId']);
					$data['relatives'] = $personObj->findPersonRelatives($memberData['personId']);
					$data['employmentHistory'] = $personObj->findPersonEmploymentHistory($memberData['personId']);
					$data['memberBusinesses'] = $personObj->findMemberBusiness($memberData['personId']);
				//}
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
	if($days == 0 || $days < 8 ){
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
		if($loan_products){
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
		if($loan_products){
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
	if($loan_products){
		foreach($loan_products as $product){
			$products_sum += $total_amount = $dashboard->getSumOfLoans("(`disbursementDate` ".$between." AND `loanProductId`=".$product['id']);
			$pie_chart_data['series']['data'][] = array('name'=>$product['productName'],'y'=>$total_amount);
		}//
		
		$pie_chart_data['title']['text'] = "Total product sales ".date('j M, y',$start_date)." - ".date('j M, y',$end_date);
	}
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