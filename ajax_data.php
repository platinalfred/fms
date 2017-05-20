<?php 
/* $show_table_js = false;
require_once("lib/Shares.php"); */
require_once("lib/Accounts.php");
require_once("lib/LoanProduct.php");
require_once("lib/DepositProduct.php");
require_once("lib/Loans.php");
require_once("lib/Income.php");
require_once("lib/Expenses.php");
require_once("lib/Dashboard.php");
require_once("lib/Member.php");

$start_date = isset($_POST['start_date'])?$_POST['start_date']:strtotime("-30 day");
$end_date = isset($_POST['end_date'])?$_POST['end_date']:time();

if(isset($_POST['origin'])&&$_POST['origin']=='dashboard'){
	$member = new Member();
	$dashboard = new Dashboard();
	$expense = new Expenses();
	$income = new Income();
	$loan = new Loans();
	$accounts = new Accounts();
	/* $share = new Shares(); */
	
	//set the respective variables to be received from the calling page
	$figures = $tables = $percents = array();
	//No of members
	//1 in this period
	$figures['members'] = $member->noOfMembers("(`dateAdded` BETWEEN ".$start_date." AND ".$end_date.") AND active=1");
	//before this period
	$members_b4 = $member->noOfMembers("(`dateAdded` < ".$start_date.") AND active=1");
	$percents['members'] = $members_b4>0?round(($figures['members']/$members_b4)*100,2):0;

	//Total amount of paid subscriptions
	//1 in this period
	$figures['total_scptions'] = $dashboard->getCountOfSubscriptions("(`datePaid` BETWEEN ".$start_date." AND ".$end_date.")");
	//before this period
	$total_scptions_b4 = $dashboard->getCountOfSubscriptions("(`datePaid` < ".$start_date.")");
	//percentage increase/decrease
	$percents['scptions_percent'] = $total_scptions_b4>0?round(($figures['total_scptions']/$total_scptions_b4)*100,2):0;

	//Total loan portfolio
	//1 in this period
	$figures['loan_portfolio'] = $dashboard->getCountOfLoans("(`disbursementDate` BETWEEN ".$end_date." AND ".$end_date.")");
	//before this period
	$loan_portfolio_b4 = $dashboard->getSumOfLoans("(`disbursementDate` < ".$start_date.")");
	//percentage increase/decrease
	$percents['loan_portfolio'] = $loan_portfolio_b4>0?round(($figures['loan_portfolio']/$loan_portfolio_b4)*100,2):0;

	//Total loan payments
	//1 in this period
	$figures['loan_payments'] = $dashboard->getCountOfLoanRepayments("(`transactionDate` BETWEEN ".$start_date." AND ".$end_date.") AND `status`=3");
	//before this period
	$loan_payments_b4 = $dashboard->getCountOfLoanRepayments("(`transaction_date` < '".$start_date."') AND `status`=3");
	//percentage increase/decrease
	$percents['loan_payments'] = $loan_payments_b4>0?round((($loan_payments_b4 - $figures['loan_payments'])/$loan_payments_b4)*100,2):0;

	//Total pending loans
	//1 in this period
	$figures['pending_loans'] = $dashboard->getCountOfLoans("(`applicationDate` BETWEEN ".$start_date." AND ".$end_date.") AND `status`=1");
	//before this period
	$pending_loans_b4 = $dashboard->getCountOfLoans("(`applicationDate` BETWEEN ".$start_date." AND ".$end_date.") AND `status`=1");
	//percentage increase/decrease
	$percents['pending_loans'] = $pending_loans_b4>0?round(($figures['pending_loans']/$pending_loans_b4)*100,2):0;

	//Total partial application loans
	//1 in this period
	$figures['partial_loans'] = $dashboard->getCountOfLoans("(`applicationDate` BETWEEN ".$start_date." AND ".$end_date.") AND `status`=2");
	//before this period
	$partial_loans_b4 = $dashboard->getCountOfLoans("(`applicationDate` BETWEEN ".$start_date." AND ".$end_date.") AND `status`=2");
	//percentage increase/decrease
	$percents['partial_loans'] = $partial_loans_b4>0?round(($figures['partial_loans']/$partial_loans_b4)*100,2):0;

	//Total approved loans
	//1 in this period
	$figures['approved_loans'] = $dashboard->getCountOfLoans("(`disbursementDate` BETWEEN ".$start_date." AND ".$end_date.") AND `status`=3");
	//before this period
	$approved_loans_b4 = $dashboard->getCountOfLoans("(`disbursementDate` BETWEEN ".$start_date." AND ".$end_date.") AND `status`=3");
	//percentage increase/decrease
	$percents['approved_loans'] = $approved_loans_b4>0?round(($figures['approved_loans']/$approved_loans_b4)*100,2):0;

	//Withdraws
	//1 in this period
	$withdraws = ($accounts->findAccountBalance("`transaction_type`=2 AND `transaction_date` BETWEEN '".$start_date."' AND '".$end_date."'")*-1);
	//Deposits
	$deposits = $accounts->findAccountBalance("`transaction_type`=1 AND `transaction_date` BETWEEN '".$start_date."' AND '".$end_date."'");
	//before this period 
	
	$deposits_b4 = $accounts->findAccountBalance("`transaction_type`=1 AND `transaction_date` < '".$start_date."'");
	//before this period  
	$withdraws_b4 = ($accounts->findAccountBalance("`transaction_type`=2 AND `transaction_date` < '".$start_date."'")*-1);
	
	//percentage increase/decrease
	$figures['savings'] = ($withdraws - $deposits);
	
	//percentage increase/decrease
	$percents['savings'] = $withdraws_b4>0?round(((($deposits_b4-$withdraws_b4) - $figures['savings'])/$withdraws_b4 - $deposits_b4)*100,2):0;

	//Income
	$tables['income'] = $income->findAll("`dateAdded` BETWEEN ".$start_date." AND ".$end_date, "amount DESC", "10");

	//Expenses"
	$tables['expenses'] = $expense->findAllExpenses("`expenseDate` BETWEEN ".$start_date." AND ".$end_date, "amountUsed DESC", "10");

	$products_sql = "SELECT `productName`, SUM(`loanAmount`) `loan_amount`, SUM(`loanAmount`*`interestRate`/100) `interest`, SUM(`penalty`) `penalties`, `paidAmount` FROM `loan_products` LEFT JOIN `loan_account` ON `loan_account`.`loanProductId` = `loan_product`.`id` LEFT JOIN (SELECT COALESCE(SUM(`amount`),0) `paidAmount`, `loanId` FROM `loan_repayment` WHERE `transaactionDate` <= ".$end_date." GROUP BY `loanId`) `payments` `loan_account`.`id`=`payments`.`loanId` LEFT JOIN (SELECT COALESCE(SUM(`amount`),0) `penalty`, `loanId` FROM `loan_repayment` WHERE `dateCreated` <= ".$end_date." GROUP BY `loanId`) `penalt` ON `loan_account`.`id` = `penalt`.`loanId` WHERE (`disbursementDate` BETWEEN ".$start_date." AND ".$end_date.") AND `status`=3 GROUP BY `productName` ORDER BY `productName`";
	
	$tables['loan_products'] = $loan->findLoans($products_sql);

	/* 
	//query for the loans
	$query = "SELECT `loan`.`id`, `loan`.`loan_number`, `expected_payback`, COALESCE((`expected_payback`- `paid_amount`),`expected_payback`) `balance`, `member`.`id` `member_id` FROM `loan` JOIN `member` ON `member`.`person_number` = `loan`.`person_number` LEFT JOIN (SELECT COALESCE(SUM(amount),0) paid_amount, `loan_id` FROM `loan_repayment` WHERE (`transaction_date` <= '".$end_date."') GROUP BY `loan_id`) `payment` ON `loan`.`id` = `payment`.`loan_id`";

	$order_by_clause = " ORDER BY `balance` DESC LIMIT 10";

	//active loans
	$where_clause =  " WHERE ((`loan_date` <= '".$end_date."') AND `expected_payback` > COALESCE((SELECT SUM(amount) paid_amount FROM `loan_repayment` WHERE (`transaction_date` <= '".$end_date."') AND `loan_id` = `loan`.`id`),0))";

	$tables['actvloans'] = $loan->findLoans($query . $where_clause . $order_by_clause);

	//Non performing loans
	$where_clause = " WHERE (`loan_date` <= '".$end_date."') AND ((`expected_payback`/TIMESTAMPDIFF(MONTH,loan_date,loan_end_date))*TIMESTAMPDIFF(MONTH,loan_date,'".$end_date."')) > COALESCE((SELECT SUM(`amount`) `paid_amount` FROM `loan_repayment` WHERE `loan_id` = `loan`.`id` AND `transaction_date` <= '".$end_date."'),0)";

	$tables['nploans'] = $loan->findLoans($query . $where_clause . $order_by_clause);

	//Performing loans
	$where_clause =  " WHERE (`loan_date` <= '".$end_date."') AND ((`expected_payback`/TIMESTAMPDIFF(MONTH,loan_date,loan_end_date))*TIMESTAMPDIFF(MONTH,loan_date,'".$end_date."')) <= COALESCE((SELECT SUM(`amount`) FROM `loan_repayment` WHERE `loan_id` = `loan`.`id` AND `transaction_date` <= '".$end_date."'),0)";
	$tables['ploans'] = $loan->findLoans($query . $where_clause . $order_by_clause);

	//Total shares bought
	//1 in this period
	$figures['total_shares'] = $dashboard->getCountOfShares("(`date_paid` BETWEEN '".$start_date."' AND '".$end_date."')");
	//before this period
	$total_shares_b4 = $dashboard->getCountOfShares("(`date_paid` < '".$start_date."')");
	//percentage increase/decrease
	$percents['shares_percent'] = $total_shares_b4>0?round((($total_shares_b4 - $figures['total_shares'])/$total_shares_b4)*100,2):0;

	//Due loans
	//1 in this period
	//(`transaction_date` BETWEEN DATE_ADD(loan_date, INTERVAL  TIMESTAMPDIFF(MONTH,loan_date,'".$end_date."') MONTH) AND DATE_ADD(loan_date, INTERVAL  TIMESTAMPDIFF(MONTH,loan_date,'".$end_date."')+1 MONTH)) AND 
	//(`loan_date` <= '".$end_date."') AND (DAY('".$end_date."') >= DAY(`loan_date`)) AND 
	$figures['due_loans'] = $dashboard->getCountOfLoans("`loan`.`id` NOT IN (SELECT loan_id FROM `loan_repayment` WHERE (SELECT COALESCE(SUM(`amount`),0) FROM `loan_repayment` WHERE `transaction_date`<='".$end_date."')< ((loan.expected_payback/TIMESTAMPDIFF(MONTH,loan.loan_date,loan.loan_end_date))*TIMESTAMPDIFF(MONTH,loan_date,'".$end_date."')))");
	
	//before this period  
	//(`transaction_date` BETWEEN DATE_ADD(loan_date, INTERVAL  TIMESTAMPDIFF(MONTH,loan_date,'".$start_date."') MONTH) AND DATE_ADD(loan_date, INTERVAL  TIMESTAMPDIFF(MONTH,loan_date,'".$start_date."')+1 MONTH)) AND 
	$due_loans_b4 = $dashboard->getCountOfLoans("`loan`.`id` NOT IN (SELECT loan_id FROM `loan_repayment` WHERE (SELECT COALESCE(SUM(`amount`),0) FROM `loan_repayment` WHERE `transaction_date`<='".$start_date."')> ((loan.expected_payback/TIMESTAMPDIFF(MONTH,loan.loan_date,loan.loan_end_date))*TIMESTAMPDIFF(MONTH,loan_date,'".$start_date."')))");
	//percentage increase/decrease
	$percents['due_loans_percent'] = $due_loans_b4>0?round((($due_loans_b4 - $figures['due_loans'])/$due_loans_b4)*100,2):0;

	//Non performing loans
	//1 in this period
	//$figures['np_loans'] = $dashboard->getCountOfLoans("`loan`.`id` NOT IN (SELECT loan_id FROM `loan_repayment` WHERE (SELECT COALESCE(SUM(`amount`),0) FROM `loan_repayment` WHERE `transaction_date`<='".$end_date."')< ((loan.expected_payback/TIMESTAMPDIFF(MONTH,loan.loan_date,loan.loan_end_date))*TIMESTAMPDIFF(MONTH,loan_date,'".$end_date."')) AND DATEDIFF('".$end_date."',`transaction_date`)>61)");
	$figures['np_loans'] = $dashboard->getCountOfLoans("(`loan_date` <= '".$end_date."') AND ((`expected_payback`/TIMESTAMPDIFF(MONTH,loan_date,loan_end_date))*TIMESTAMPDIFF(MONTH,loan_date,'".$end_date."')) > COALESCE((SELECT SUM(`amount`) FROM `loan_repayment` WHERE `loan_id` = `loan`.`id` AND `transaction_date` <= '".$end_date."'),0)");
	
	//before this period  
	//$np_loans_b4 = $dashboard->getCountOfLoans("`loan`.`id` NOT IN (SELECT loan_id FROM `loan_repayment` WHERE (SELECT COALESCE(SUM(`amount`),0) FROM `loan_repayment` WHERE `transaction_date`<='".$start_date."')> ((loan.expected_payback/TIMESTAMPDIFF(MONTH,loan.loan_date,loan.loan_end_date))*TIMESTAMPDIFF(MONTH,loan_date,'".$start_date."')) AND DATEDIFF('".$start_date."',`transaction_date`)>61)");
	$np_loans_b4 = $dashboard->getCountOfLoans("(`loan_date` <= '".$start_date."') AND ((`expected_payback`/TIMESTAMPDIFF(MONTH,loan_date,loan_end_date))*TIMESTAMPDIFF(MONTH,loan_date,'".$start_date."')) > COALESCE((SELECT SUM(`amount`) FROM `loan_repayment` WHERE `loan_id` = `loan`.`id` AND `transaction_date` <= '".$start_date."'),0)");
	//percentage increase/decrease
	$percents['np_loans_percent'] = $np_loans_b4>0?round((($np_loans_b4 - $figures['np_loans'])/$np_loans_b4)*100,2):0;

	//Performing loans
	//1 in this period
	//$figures['np_loans'] = $dashboard->getCountOfLoans("`loan`.`id` IN (SELECT loan_id FROM `loan_repayment` WHERE (SELECT COALESCE(SUM(`amount`),0) FROM `loan_repayment` WHERE `transaction_date`<='".$end_date."')< ((loan.expected_payback/TIMESTAMPDIFF(MONTH,loan.loan_date,loan.loan_end_date))*TIMESTAMPDIFF(MONTH,loan_date,'".$end_date."')) AND DATEDIFF('".$end_date."',`transaction_date`)>61)");
	$figures['p_loans'] = $dashboard->getCountOfLoans("(`loan_date` <= '".$end_date."') AND ((`expected_payback`/TIMESTAMPDIFF(MONTH,loan_date,loan_end_date))*TIMESTAMPDIFF(MONTH,loan_date,'".$end_date."'))  <= COALESCE((SELECT SUM(`amount`) `paid_amount` FROM `loan_repayment` WHERE `loan_id` = `loan`.`id` AND `transaction_date` <= '".$end_date."'),0)");
	
	//before this period  
	//$p_loans_b4 = $dashboard->getCountOfLoans("`loan`.`id` IN (SELECT loan_id FROM `loan_repayment` WHERE (SELECT COALESCE(SUM(`amount`),0) FROM `loan_repayment` WHERE `transaction_date`<='".$start_date."')> ((loan.expected_payback/TIMESTAMPDIFF(MONTH,loan.loan_date,loan.loan_end_date))*TIMESTAMPDIFF(MONTH,loan_date,'".$start_date."')) AND DATEDIFF('".$start_date."',`transaction_date`)>61)");
	$p_loans_b4 = $dashboard->getCountOfLoans("(`loan_date` <= '".$start_date."') AND ((`expected_payback`/TIMESTAMPDIFF(MONTH,loan_date,loan_end_date))*TIMESTAMPDIFF(MONTH,loan_date,'".$start_date."'))  <= COALESCE((SELECT SUM(`amount`) `paid_amount` FROM `loan_repayment` WHERE `loan_id` = `loan`.`id` AND `transaction_date` <= '".$start_date."'),0)");
	//percentage increase/decrease
	$percents['p_loans_percent'] = $p_loans_b4>0?round((($p_loans_b4 - $figures['p_loans'])/$p_loans_b4)*100,2):0; */

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
}
elseif(isset($_POST['origin'])&&$_POST['origin']=='deposit_product'){
	
	$depositProductType = new DepositProduct();
	$deposit_product_types = $depositProductType->findAll();
	echo json_encode($deposit_product_types);
}
elseif(isset($_POST['origin'])&&$_POST['origin']=='loan_product'){
	$loanProductType = new LoanProduct();
	$loanProductFee = new LoanProductFees();
	$feeType = new FeeType();
	
	$data['loanProductTypes'] = $loanProductType->findAll();
	$data['feeTypes'] = $feeType->findAll();
	$data['existingProductFees'] = $loanProductFee->findAll();
	echo json_encode($data);
}
else{//(isset($_POST['origin'])&&$_POST['origin']=='client_savings')
	$accounts = new Accounts();
	
	$inner_where= $where = "";
	$opening_bal = 0;
	
	if((isset($_POST['start_date'])&& strlen($_POST['start_date'])>1) && (isset($_POST['end_date'])&& strlen($_POST['end_date'])>1)){
		if(isset($_POST['member_id'])){
			$inner_where = "WHERE (`member`.`id` = ".$_POST['member_id'].")";
		}
		//because the period was selected, lets get the opening balance before then
		//opening balance is the diference between the deposits and withdraws
		$where = " (`transaction_date` < '$start_date')";
		$opening_bal = $accounts->findOpeningBalance($where, $inner_where);
		
		$where = " (`transaction_date` BETWEEN '".$start_date."' AND '".$end_date."')";
		
	}
	
	$_results = $accounts->findAllTransactions($where, $inner_where);
	
	$table_data = array(array('transaction_date' => "Bal b/f",
								'id' => " ",
								'names' => " ",
								'deposit' => 0,
								'withdraw' => 0,
								'balance' => (float)$opening_bal,
								'person_number' => " ",
								'account_number' => " ",
								'transacted_by' => " ")
						);
	
	if($_results){
		foreach($_results as $_result){
			$data = array();
			$data['transaction_date'] =  date("j F, Y", strtotime($_result['transaction_date']));
			$data['id'] =  $_result['id'];
			$data['member_id'] =  $_result['member_id'];
			$data['names'] =  $_result['firstname']." ".$_result['othername']." ".$_result['lastname'];
			$data['deposit'] =  $_result['amount']>=0?(float)$_result['amount']:0;
			$data['withdraw'] =  $_result['amount']<0?(float)($_result['amount']):0;
			$data['balance'] = $opening_bal += $data['deposit'] + $data['withdraw'];
			$data['person_number'] =  $_result['person_number'];
			$data['account_number'] =  $_result['account_number'];
			$data['transacted_by'] =  $_result['transacted_by'];
			
			$table_data[] = $data;
		}
	}
	echo json_encode(array('data' => $table_data));
}


function getGraphData($start_date, $end_date){
	$days = round(($end_date-$start_date)/86400);
	$dashboard = new Dashboard();
	$loanProduct = new LoanProduct();
	
	//arrays with data for the past i days/months
	$graph_data = $data_points = array();
	
	$_end = new DateTime(date("Y-m-d",$end_date));
	$period = new DatePeriod( new DateTime(date("Y-m-d",$start_date)), new DateInterval('P1D'), $_end );
	$period_dates = iterator_to_array($period);
	
	$loan_products = $loanProduct->findAll();
	
	//if days are 7 or less
	if($days == 0 || $days <8){
		$period = new DatePeriod( new DateTime(date("Y-m-d",$start_date)), new DateInterval('P1D'), $_end->modify( '+1 day' ) );
		foreach($loan_products as $product){
			$datasets = array();
			$datasets['label'] = $product['productName'];
			
			foreach($period as $date){
				$datasets['data'][] = $dashboard->getSumOfLoans("`disbursementDate` = ".$date." AND ".$product['id']);
			}
			$graph_data['datasets'][] = array_merge($datasets, getGraphProps());
		}
		foreach($period as $date){
			$data_points[] = $date->format("D, j/n");
		}
	}
	elseif($days > 7 && $days <31){
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
			$weeks[$index]['end'] = $end_date;
		}
		foreach($loan_products as $product){
			$datasets = array();
			$datasets['label'] = $product['productName'];
			
			foreach($weeks as $week){
				$between = "BETWEEN ".$week['start']." AND ".$week['end'].")";
				$datasets['data'][] = $dashboard->getSumOfLoans("`disbursementDate` <= ".$week['end']." AND ".$product['id']);
			}
			$graph_data['datasets'][] = array_merge($datasets, getGraphProps());;
		}
		foreach($weeks as $week){
			$data_points[] = date('j/M', $week['start'])."-".date('j/M', $week['end']);
		}
		
	}
	elseif($days > 30){
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
			$datasets['label'] = $product['productName'];
			
			foreach($months as $month){
				$between = "BETWEEN ".$month['start']." AND ".$month['end'].")";
				$datasets['data'][] = $dashboard->getSumOfLoans($between." AND ".$product['id']);
			}
			$graph_data['datasets'][] = array_merge($datasets, getGraphProps());
		}
		foreach($weeks as $week){
			$data_points[] = date('M, Y', $month['start']);
		}
	}
	if(!empty($graph_data)){
		
		$graph_data['labels'] = $data_points;
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
	foreach($loan_products as $product){
		$pie_chart_data['labels'][] = $product['productName'];
		$products_sum += $total_amount = $dashboard->getSumOfLoans("(`disbursementDate` ".$between." AND ".$product['id']);
		$pie_chart_data['datasets']['data'][] = $total_amount;
		
		$pie_chart_data['datasets']['backgroundColor'][] = "#".dechex(rand(0,15)).dechex(rand(0,15)).dechex(rand(0,15)).dechex(rand(0,15)).dechex(rand(0,15)).dechex(rand(0,15));
	}
	//$pie_chart_data['label'] = "Loan products";
	
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