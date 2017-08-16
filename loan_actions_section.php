<!-- If its a loans officer show the forward to branch manager if the status is 2 -->
<?php 
	if(isset($_SESSION['branch_credit'])||isset($_SESSION['management_credit'])||isset($_SESSION['executive_board'])||isset($_SESSION['branch_manager'])||isset($_SESSION['loans_officer'])||isset($_SESSION['admin'])){ ?>
<!-- ko if: status<4 -->
	<a class="btn btn-warning btn-sm" href='#approve_loan-modal' data-toggle="modal"><i class="fa fa-list"></i> Account Details</a>
<!-- /ko -->
<?php }
	if(isset($_SESSION['loans_officer'])||isset($_SESSION['admin'])){ ?>
	<!-- ko if: (status==1||status==11)-->
		<a href="#edit_loan_account-modal" class="btn  btn-info btn-sm edit_loan" data-toggle="modal"><i class="fa fa-edit"></i> Update</a>
	<!-- /ko -->
<?php }
//If its not a loans officer show the payment link
if(isset($_SESSION['accountant'])||isset($_SESSION['admin'])){ ?>
	<!-- ko if: status==5-->
		<a class="btn btn-info btn-sm" href='#make_payment-modal' data-toggle="modal"><i class="fa fa-edit"></i> Make Payment </a>
	<!-- /ko -->
	<!-- ko if: status==4 -->
		<a class="btn btn-warning btn-sm" href='#disburse_loan-modal' data-toggle="modal"><i class="fa fa-money"></i> Disburse Loan </a>
	<!-- /ko -->
<?php }?>