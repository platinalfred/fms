<?php 
/* $show_table_js = false;
require_once("lib/Loans.php");
require_once("lib/Accounts.php");
require_once("lib/Shares.php"); */
require_once("lib/Income.php");
require_once("lib/Expenses.php");
require_once("lib/Dashboard.php");
require_once("lib/Member.php");

$start_date = isset($_POST['start_date'])?$_POST['start_date']:date('Y-m-d',strtotime("-30 day"));
$end_date = isset($_POST['end_date'])?$_POST['end_date']:date('Y-m-d');

if(isset($_POST['origin'])&&$_POST['origin']=='dashboard'){
	$member = new Member();
	$dashboard = new Dashboard();
	$expense = new Expenses();
	$income = new Income();
	/* $loan = new Loans();
	$share = new Shares();
	$accounts = new Accounts(); */
	
	//set the respective variables to be received from the calling page
	$figures = $tables = $percents = array();
	//No of members
	//1 in this period
	$figures['no_members'] = $member->noOfMembers("(`dateAdded` BETWEEN ".$start_date." AND ".$end_date.") AND active=1");
	//before this period
	$members_b4 = $member->noOfMembers("(`dateAdded` < ".$start_date.") AND active=1");
	$percents['members_percent'] = $members_b4>0?round(($figures['no_members']/$members_b4)*100,2):0;

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
	$percents['loan_payments_percent'] = $loan_payments_b4>0?round((($loan_payments_b4 - $figures['loan_payments'])/$loan_payments_b4)*100,2):0;

	//Total pending loans
	//1 in this period
	$figures['pending_loans'] = $dashboard->getCountOfLoans("(`applicationDate` BETWEEN ".$end_date." AND ".$end_date.") AND `status`=1");
	//before this period
	$pending_loans_b4 = $dashboard->getCountOfLoans("(`applicationDate` BETWEEN ".$end_date." AND ".$end_date.") AND `status`=1");
	//percentage increase/decrease
	$percents['pending_loans'] = $pending_loans_b4>0?round(($figures['pending_loans']/$pending_loans_b4)*100,2):0;

	//Total partial application loans
	//1 in this period
	$figures['partial_loans'] = $dashboard->getCountOfLoans("(`applicationDate` BETWEEN ".$end_date." AND ".$end_date.") AND `status`=2");
	//before this period
	$partial_loans_b4 = $dashboard->getCountOfLoans("(`applicationDate` BETWEEN ".$end_date." AND ".$end_date.") AND `status`=2");
	//percentage increase/decrease
	$percents['partial_loans'] = $partial_loans_b4>0?round(($figures['partial_loans']/$partial_loans_b4)*100,2):0;

	//Total approved loans
	//1 in this period
	$figures['approved_loans'] = $dashboard->getCountOfLoans("(`disbursementDate` BETWEEN ".$end_date." AND ".$end_date.") AND `status`=3");
	//before this period
	$approved_loans_b4 = $dashboard->getCountOfLoans("(`disbursementDate` BETWEEN ".$end_date." AND ".$end_date.") AND `status`=3");
	//percentage increase/decrease
	$percents['approved_loans'] = $approved_loans_b4>0?round(($figures['approved_loans']/$approved_loans_b4)*100,2):0;

	//Income
	$tables['income'] = $income->findAll("`dateAdded` BETWEEN ".$start_date." AND ".$end_date, "amount DESC", "10");

	//Expenses"
	$tables['expenses'] = $expense->findAllExpenses("`expenseDate` BETWEEN ".$start_date." AND ".$end_date, "amountUsed DESC", "10");

	/* 

	//line and barchart
	$_result['lineBarChart'] = getGraphData($start_date, $end_date);
	//pie chart
	$_result['pieChart'][] = $dashboard->getSumOfLoans("`loan_date` <= '".$end_date."' AND ((`expected_payback`/TIMESTAMPDIFF(MONTH,loan_date,loan_end_date))*TIMESTAMPDIFF(MONTH,loan_date,'".$end_date."')) <= COALESCE((SELECT SUM(`amount`) FROM `loan_repayment` WHERE `loan_id` = `loan`.`id` AND `transaction_date` <= '".$end_date."'),0)");
	$_result['pieChart'][] = $dashboard->getSumOfLoans("`loan_date` <= '".$end_date."' AND ((`expected_payback`/TIMESTAMPDIFF(MONTH,loan_date,loan_end_date))*TIMESTAMPDIFF(MONTH,loan_date,'".$end_date."')) > COALESCE((SELECT SUM(`amount`) `paid_amount` FROM `loan_repayment` WHERE `loan_id` = `loan`.`id` AND `transaction_date` <= '".$end_date."'),0)");

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
	$percents['p_loans_percent'] = $p_loans_b4>0?round((($p_loans_b4 - $figures['p_loans'])/$p_loans_b4)*100,2):0;

	//Withdraws
	//1 in this period
	$figures['withdraws'] = ($accounts->findAccountBalance("`transaction_type`=2 AND `transaction_date` BETWEEN '".$start_date."' AND '".$end_date."'")*-1);
	
	//before this period  
	$withdraws_b4 = ($accounts->findAccountBalance("`transaction_type`=2 AND `transaction_date` < '".$start_date."'")*-1);
	//percentage increase/decrease
	$percents['withdraws_percent'] = $withdraws_b4>0?round((($withdraws_b4 - $figures['withdraws'])/$withdraws_b4)*100,2):0;

	//Deposits
	//1 in this period
	$figures['deposits'] = $accounts->findAccountBalance("`transaction_type`=1 AND `transaction_date` BETWEEN '".$start_date."' AND '".$end_date."'");
	
	//before this period  
	$withdraws_b4 = $accounts->findAccountBalance("`transaction_type`=1 AND `transaction_date` < '".$start_date."'");
	//percentage increase/decrease
	$percents['deposits_percent'] = $withdraws_b4>0?round((($withdraws_b4 - $figures['withdraws'])/$withdraws_b4)*100,2):0; */

	$_result['figures'] = $figures;
	$_result['percents'] = $percents;
	$_result['tables'] = $tables;//

	echo json_encode($_result);
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
	//arrays with data for the past i days/months
	$shares_sum_graph_data = $loans_sum_graph_data = $subscriptions_sum_graph_data = $data_points = array();
	$shares_count_graph_data = $loans_count_graph_data = $subscriptions_count_graph_data = array();
	$_end = new DateTime(date("Y-m-d",$end_date));
	$period = new DatePeriod( new DateTime(date("Y-m-d",$start_date)), new DateInterval('P1D'), $_end );
	$period_dates = iterator_to_array($period);
	
	//if days are 7 or less
	if($days == 0 || $days <8){
		$period = new DatePeriod( new DateTime(date("Y-m-d",$start_date)), new DateInterval('P1D'), $_end->modify( '+1 day' ) );
		foreach($period as $date){
			$loans_sum_graph_data[] = $dashboard->getSumOfLoans("`loan_end_date` >='{$date->format("Y-m-d")}'");
			$shares_sum_graph_data[] = $dashboard->getSumOfShares("`date_paid`='{$date->format("Y-m-d")}' ");
			$subscriptions_sum_graph_data[] = $dashboard->getSumOfSubscriptions("`date_paid`='{$date->format("Y-m-d")}' ");
			$loans_count_graph_data[] = $dashboard->getCountOfLoans("`loan_end_date` >='{$date->format("Y-m-d")}'");
			$shares_count_graph_data[] = $dashboard->getCountOfShares("`date_paid`='{$date->format("Y-m-d")}' ");
			$subscriptions_count_graph_data[] = $dashboard->getCountOfSubscriptions("`date_paid`='{$date->format("Y-m-d")}' ");
			$data_points[] = date('D, j/n', strtotime($date->format("Y-m-d")));
		}
	}
	elseif($days > 7 && $days <31){
		/*split the days into weeks
		*generate an array holding the start and end dates of the given period
		*/
		
		$weeks = array();
		$index = 0;
		$weeks[$index]['start'] = $start_date;
		if(date('N',strtotime($start_date))==7){
			$weeks[$index++]['end'] = $start_date;
		}
		for($i = $index; $i<count($period_dates);$i++){
			$period_date = $period_dates[$i];
			if($period_date->format('N')==1){
				$weeks[$index]['start'] = $period_date->format('Y-m-d');
			}
			if($period_date->format('N')==7){
				$weeks[$index++]['end'] = $period_date->format('Y-m-d');
			}
		}
		$weeks[$index]['end'] = $end_date;
		if(date('N',strtotime($end_date))==1){
			$weeks[$index]['start'] = $end_date;
			$weeks[$index]['end'] = $end_date;
		}
		
		foreach($weeks as $week){
			$between = "BETWEEN '".$week['start']."' AND '".$week['end']."')";
			$loans_sum_graph_data[] = $dashboard->getSumOfLoans("`loan_date` <= '".$week['end']."' AND `active` = 1");
			$shares_sum_graph_data[] = $dashboard->getSumOfShares("(`date_paid` ".$between);
			$subscriptions_sum_graph_data[] = $dashboard->getSumOfSubscriptions("(`date_paid` ".$between);
			$loans_count_graph_data[] = $dashboard->getCountOfLoans("`loan_date` <= '".$week['end']."' AND `active` = 1");
			$shares_count_graph_data[] = $dashboard->getCountOfShares("(`date_paid` ".$between);
			$subscriptions_count_graph_data[] = $dashboard->getCountOfSubscriptions("(`date_paid` ".$between);
			$data_points[] = date('j/M', strtotime($week['start']))."-".date('j/M', strtotime($week['end']));
		}
	}
	elseif($days > 30){
		/*split the days into months
		*generate an array holding the start and end dates of the given period
		*/
		
		$months = array();
		$index = 0;
		$months[$index]['start'] = $start_date;
		if(date('j',strtotime($start_date))==date('t',strtotime($start_date))){
			$months[$index++]['end'] = $start_date;
		}
		for($i = $index; $i<count($period_dates);$i++){
			$period_date = $period_dates[$i];
			if($period_date->format('j')==1){
				$months[$index]['start'] = $period_date->format('Y-m-d');
			}
			if($period_date->format('j')==$period_date->format('t')){
				$months[$index++]['end'] = $period_date->format('Y-m-d');
			}
		}
		$months[$index]['end'] = $end_date;
		if(date('j',strtotime($end_date)) == date('t',strtotime($end_date))){
			$months[$index]['start'] = $end_date;
			$months[$index]['end'] = $end_date;
		}
		foreach($months as $month){
			$between = "BETWEEN '".$month['start']."' AND '".$month['end']."')";
			$loans_sum_graph_data[] = $dashboard->getSumOfLoans("`loan_date` <= '".$month['end']."' AND `active` = 1");
			$shares_sum_graph_data[] = $dashboard->getSumOfShares("(`date_paid` ".$between);
			$subscriptions_sum_graph_data[] = $dashboard->getSumOfSubscriptions("(`date_paid` ".$between);
			$loans_count_graph_data[] = $dashboard->getCountOfLoans("`loan_date` <= '".$month['end']."' AND `active` = 1");
			$shares_count_graph_data[] = $dashboard->getCountOfShares("(`date_paid` ".$between);
			$subscriptions_count_graph_data[] = $dashboard->getCountOfSubscriptions("(`date_paid` ".$between);
			$data_points[] = date('M, Y', strtotime($month['start']));
		}
	}
	$graph_data['loans_sum'] = $loans_sum_graph_data;
	$graph_data['shares_sum'] = $shares_sum_graph_data;
	$graph_data['subscriptions_sum'] = $subscriptions_sum_graph_data;
	$graph_data['loans_count'] = $loans_count_graph_data;
	$graph_data['shares_count'] = $shares_count_graph_data;
	$graph_data['subscriptions_count'] = $subscriptions_count_graph_data;
	$graph_data['data_points'] = $data_points;
	return $graph_data;
}	
?>