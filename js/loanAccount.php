<script type="text/javascript">
$(".athousand_separator").keyup(function(){
	alert("Hello");
});
	var Collateral = function() {
			var self = this;
			self.itemName = ko.observable();
			self.description = ko.observable();
			self.itemValue = ko.observable();
			self.attachmentUrl = ko.observable();
		};
	//list of the guarantors
	var GuarantorSelection = function() {
		var self = this;
		self.guarantor = ko.observable();
	};
	var LoanAccount = function() {
		var self = this;
		
		//these are required as the datatable is being loaded
		self.transactionHistory = ko.observableArray(); //for the account transacation history display
		self.account_details = ko.observable();
		
		//this gets loaded when the loan is for approval/editing
		self.edit_client = ko.observable(0);
		self.loan_account_details = ko.observable();
		self.loanAccountId = ko.observable();
		
		//loan repayment section form
		self.payment_amount = ko.observable(0);
		self.comments = ko.observable("");
		
		//loan account approval section
		self.amountApproved = ko.observable(0);
		self.approvalNotes = ko.observable();
		self.applicationStatus = ko.observable(3);
		
		//loan amount disbursement section
		self.disbursedAmount = ko.observable(0);
		self.disbursementNotes = ko.observable();
		
		//guarantors 
		self.guarantors = ko.observableArray();
		// Stores an array of selectedGuarantors
		self.selectedGuarantors = ko.observableArray([new GuarantorSelection()]);
		self.addedCollateral = ko.observableArray([new Collateral()]);
		// Put one guarantor in by default
		self.totalSavings = ko.pureComputed(function() {
			var total = 0;
			$.map(self.selectedGuarantors(), function(selectedGuarantor) {
				if(selectedGuarantor.guarantor()) {
					total += parseFloat("0" + selectedGuarantor.guarantor().savings);
				};
			});
			return total;
		});
		self.totalCollateral = ko.pureComputed(function() {
			var total = 0;
			$.map(self.addedCollateral(), function(collateralItem) {
				if(collateralItem.itemValue()) {
					total += parseFloat("0" + collateralItem.itemValue());
				};
			});
			return total;
		});
		self.totalShares = ko.pureComputed(function() {
			var sum = 0;
			$.map(self.selectedGuarantors(), function(selectedGuarantor) {
				if(selectedGuarantor.guarantor()) {
					sum += parseFloat("0" + selectedGuarantor.guarantor().shares);
				};
			});
			return sum;
		});
		 
		// Operations
		self.addGuarantor = function() { self.selectedGuarantors.push(new GuarantorSelection()) };
		self.removeGuarantor = function(selectedGuarantor) { self.selectedGuarantors.remove(selectedGuarantor) };
		self.addCollateral = function() { self.addedCollateral.push(new Collateral()) };
		self.removeCollateral = function(addedCollateral) { self.addedCollateral.remove(addedCollateral) };
		
		<?php if(!isset($client)):?>self.customers = ko.observableArray([{"id":1,"clientNames":"Kiwatule Womens Savings Group","clientType":2}]); <?php endif;?>
		// Stores an array of all the Data for viewing on the page
		self.loanProducts = ko.observableArray([{"id":1,"productName":"Group Savings Loan","description":"Suitable for group savings", "availableTo":"2"}]);
		self.productFees = ko.observableArray();
		self.loanAccountFees = ko.observableArray();
		
		self.loanProduct = ko.observable();
		self.client = ko.observable(<?php if(isset($client)) echo json_encode($client);?>);
		self.requestedAmount = ko.observable(0);
		self.interestRate = ko.observable(0);
		self.applicationDate = ko.observable(moment().format('DD-MM-YYYY'));
		self.offSetPeriod = ko.observable(0);
		self.installments = ko.observable(0);
		self.gracePeriod = ko.observable(0);
		
		// Operations
		//set options value afterwards
		self.setOptionValue = function(propId) {
			return function (option, item) {
				if (item === undefined) {
					option.value = "";
				} else {
					option.value = item[propId];
				}
			}
		};
		
		//filter the loan products based on the user type
		self.filteredLoanProducts = ko.computed(function() {
			var clientType = (self.client()?parseInt(self.client().clientType):3);
			return ko.utils.arrayFilter(self.loanProducts(), function(loanProduct) {
				//console.log(loanProduct.availableTo);
				return (clientType == parseInt(loanProduct.availableTo) || parseInt(loanProduct.availableTo)==3);
			});
		});
		//filter the loan product fees based on the currently selected product id
		self.filteredLoanProductFees = ko.computed(function() {
			if(self.loanProduct()){
				var loanProductId = parseInt(self.loanProduct().id);
				return ko.utils.arrayFilter(self.productFees(), function(productFee) {
					return (loanProductId == parseInt(productFee.loanProductId));
				});
			}
			else{
				return self.productFees();
			}
		});
		//filter the guarantors based on the user type and current client selected
		self.filteredGuarantors = ko.computed(function() {
			if(self.client()){
				var clientType = parseInt(self.client().clientType);
				var clientId = parseInt(self.client().id);
				return ko.utils.arrayFilter(self.guarantors(), function(guarantor) {
					return (clientId != parseInt(guarantor.id) && parseInt(clientType)==1);
				});
			}
			else{
				return self.guarantors();
			}
			
		});
		
		//reset the whole form after saving data in the database
		self.resetForm = function() {
			//self.client(null);
			//self.loanProduct(null);//
			$("#loanAccountForm")[0].reset();
			dTable['applications'].ajax.reload();
		};
		
		//Retrieve page data from the server
		self.getServerData = function() {
			$.ajax({
				type: "post",
				dataType: "json",
				data:{origin:"loan_account"<?php if(isset($_GET['loanId'])):?>, loanAccountId:<?php echo $_GET['loanId'];?> <?php endif;?>},
				url: "ajax_data.php",
				success: function(response){
					self.loanProducts(response.products);
					self.productFees(response.productFees);
					self.guarantors(response.guarantors);
					<?php if(!isset($client)):?>self.customers(response.customers); <?php endif;?>
					<?php if(isset($_GET['loanId'])){
						$clientId = $client['id'];
						$client['clientId'] = $client['id'];
						unset($client['id'],$clientId);?>
						var client_data = <?php echo json_encode($client);?>;
						self.account_details($.extend(client_data, response.account_details));
					<?php } ?>
				}
			})
		};
		
		//send the items to the server for saving
		self.save = function(form) {
			var guarantors = $.map(self.selectedGuarantors(), function(current_guarantor) {
				return current_guarantor.guarantor() ? {
					id: current_guarantor.guarantor().id
				} : undefined
			});
			$.ajax({
				type: "post",
				data:{
					id : self.loanAccountId(),
					clientId : (self.client()?self.client().id:undefined),
					clientType : (self.client()?self.client().clientType:undefined),
					status : (self.loanProduct()?self.loanProduct().initialAccountState:undefined),
					loanProductId : (self.loanProduct()?self.loanProduct().id:undefined),
					requestedAmount : self.requestedAmount(),
					applicationDate : moment(self.applicationDate(), 'DD-MM-YYYY').format('X'),
					interestRate : self.interestRate(),
					offSetPeriod : self.offSetPeriod(),
					gracePeriod : self.gracePeriod(),
					repaymentsFrequency : self.loanProduct()?self.loanProduct().repaymentsFrequency:undefined,
					repaymentsMadeEvery : self.loanProduct()?self.loanProduct().repaymentsMadeEvery:undefined,
					installments : self.installments(),
					penaltyCalculationMethodId : self.loanProduct()?self.loanProduct().penaltyCalculationMethodId:undefined,
					penaltyTolerancePeriod : self.loanProduct()?self.loanProduct().penaltyTolerancePeriod:undefined,
					penaltyRateChargedPer : self.loanProduct()?self.loanProduct().penaltyRateChargedPer:undefined,
					penaltyRate : self.loanProduct()?self.loanProduct().penaltyRate:undefined,
					linkToDepositAccount : self.loanProduct()?self.loanProduct().linkToDepositAccount:undefined,
					guarantors:guarantors,//the chosen guarantors
					feePostData:self.filteredLoanProductFees(), //the applicable fees
					collateral:self.addedCollateral(), //the applicable fees
					origin : "loan_account"
				},
				url: "lib/AddData.php",
				success: function(response){
					// if it was an OK response, get the id of the inserted product and insert the product fees
					var result = parseInt(response)||0;
					if(result){
							showStatusMessage("Data successfully saved" ,"success");
							setTimeout(function(){
								self.resetForm();
							}, 3000);
					}else{
						showStatusMessage("Error encountered while saving data, try again: \n"+response ,"failed");
					}
										
				}
			});
			
		};
		
		self.makePayment = function(){
			$.ajax({
				type: "post",
				dataType: "json",
				data:{
					origin:"make_loan_payment",
					loanAccountId:(self.account_details()?self.account_details().id:undefined),
					amount: self.payment_amount(),
					comments: self.comments()
				},
				url: "lib/AddData.php",
				success: function(response){
					var result = parseInt(response)||0;
					if(result){/*  */
						showStatusMessage("Data successfully saved" ,"success");
						setTimeout(function(){
							$("#loanPaymentForm")[0].reset();
							dTable['approved'].ajax.reload(function(){
								self.account_details(dTable['approved'].row('#loanAcc'+self.account_details().id).data());
								},false);
							getTransactionHistory(self.account_details().id);
						}, 3000);
					}else{
						showStatusMessage("Error encountered while saving data: \n"+response ,"failed");
					}
				}
			});
		};
		
		self.approveLoan = function(){
			$.ajax({
				type: "post",
				dataType: "json",
				data:{
					origin:"approve_loan",
					id:(self.account_details()?self.account_details().id:undefined),
					amountApproved: self.applicationStatus()==3?self.amountApproved():undefined,
					approvalNotes: self.approvalNotes(),
					status: self.applicationStatus()
				},
				url: "lib/AddData.php",
				success: function(response){
					var result = parseInt(response)||0;
					if(result){/*  */
						showStatusMessage("Data successfully saved" ,"success");
						setTimeout(function(){
							$("#loanAccountApprovalForm")[0].reset();
							dTable['applications'].ajax.reload();
							dTable['approved'].ajax.reload();
							dTable['rejected'].ajax.reload();
							self.account_details(null);
							$('#approve_loan-modal').modal('hide');
						}, 3000);
					}else{
						showStatusMessage("Error encountered while approving: \n"+response ,"fail");
					}
				}
			});
		};
		self.disburseLoan = function(){
			$.ajax({
				type: "post",
				dataType: "json",
				data:{
					origin:"disburse_loan",
					id:(self.account_details()?self.account_details().id:undefined),
					disbursedAmount: self.applicationStatus()==3?self.disbursedAmount():undefined,
					disbursementNotes: self.disbursementNotes(),
					status: 4
				},
				url: "lib/AddData.php",
				success: function(response){
					var result = parseInt(response)||0;
					if(result){/*  */
						showStatusMessage("Data successfully saved" ,"success");
						setTimeout(function(){
							$("#loanAccountApprovalForm")[0].reset();
							dTable['applications'].ajax.reload();
							dTable['approved'].ajax.reload();
							dTable['rejected'].ajax.reload();
							$('#disburse_loan-modal').modal('hide');
						}, 3000);
					}else{
						showStatusMessage("Error encountered while approving: \n"+response ,"fail");
					}
				}
			});
		};
		self.getLoanAccountDetails = function(edit){
			$.ajax({
				type: "post",
				dataType: "json",
				data:{
					origin:"loan_application_details",
					id:(self.account_details()?self.account_details().id:undefined),
					edit_loan:edit,
					clientId: (self.account_details()?self.account_details().clientId:undefined),
					clientType: (self.account_details()?self.account_details().clientType:undefined)
				},
				url: "ajax_data.php",
				success: function(response){
					if(response){
						if(edit){
							self.loanAccountId(response.loan_account_details.id);
							self.client({id:self.account_details().clientId, clientNames:self.account_details().clientNames, clientType:self.account_details().clientType});
							self.loanProduct(response.loan_product);
							self.selectedGuarantors(response.guarantors);
							//self.addedCollateral(response.collateral_items);
							self.requestedAmount(response.loan_account_details.requestedAmount);
							self.interestRate(response.loan_account_details.interestRate);
							self.offSetPeriod(response.loan_account_details.offSetPeriod);
							self.gracePeriod(response.loan_account_details.gracePeriod);
							self.installments(response.loan_account_details.installments);
							self.applicationDate(moment(response.loan_account_details.applicationDate,'X').format('DD-MM-YYYY'));
						}
						else{
							self.loan_account_details(response);
						}
					}
				}
			});
		};
	};

	var loanAccountModel = new LoanAccount();
	loanAccountModel.getServerData();// get data to be populated on the page
	ko.applyBindings(loanAccountModel, $("#loan_account_details")[0]);
	$("#loanAccountForm").validate({submitHandler: loanAccountModel.save});
	$("#loanPaymentForm").validate({submitHandler: loanAccountModel.makePayment});
	$("#loanAccountApprovalForm").validate({submitHandler: loanAccountModel.approveLoan});
	$("#loanDisbursementForm").validate({submitHandler: loanAccountModel.disburseLoan});
	
	
<!-- Datatables -->

	var user_props = <?php echo json_encode($_SESSION); ?>;
	var dTable = new Object();
	$(document).ready(function() {
		
		  var post_data = new Object();
		  <?php if(isset($client)):?>post_data =<?php echo json_encode($client);?>; <?php endif;?>
	var handleDataTableButtons = function() {
		switch(parseInt($('#loan_types').val())){
			case 1: //applications pending approval
				  if(typeof(dTable['applications'])!=='undefined'){
					$(".tab-pane").removeClass("active");
					$("#tab-1").addClass("active");
					$(".table#applications tbody>tr:first").trigger('click');
				  }
				  else{
					dTable['applications'] = $('#applications').DataTable({
					  dom: "Bfrtip",
					  "order": [ [3, 'desc' ]],
					  "ajax": {
						  "url":"ajax_data.php",
						  "type": "POST",
						  "data": function(d){
									d.origin = 'loan_accounts';
									d.status = 1; // status of pending loan applications;
									d.start_date = startDate;
									d.end_date = endDate;
									$.extend(d,post_data);
								}
					  },
					  "initComplete": function(settings, json) {
						  $(".tab-pane").removeClass("active");
						  $("#tab-1").addClass("active");
						  $(".table#applications tbody>tr:first").trigger('click');
					  },
					  columns:[ { data: 'loanNo', render: function ( data, type, full, meta ) {
						  var page = "";
						  if(full.clientType==1){
							  page = "member_details.php?id=";
						  }
						  if(full.clientType==2){
							  page = "sacco_group_details.php?id=";
						  }
						  return '<a href="'+page+full.clientId+'&view=loan_accs&loanId='+full.id+'" title="View details">'+data+'</a>';}
						  },
							{ data: 'clientNames'},
							{ data: 'productName'},
							{ data: 'applicationDate',  render: function ( data, type, full, meta ) {return moment(data, 'X').format('DD-MMM-YYYY');}},
							{ data: 'requestedAmount', render: function ( data, type, full, meta ) {return curr_format(parseInt(data));}}/*  ,
							{ data: 'id', render: function ( data, type, full, meta ) {
								var authorized =  false;
								var role = '<?php echo $_SESSION['branch_credit']; ?>';
								return 
							<?php if((isset($_SESSION['branch_credit'])&&$_SESSION['branch_credit'])||(isset($_SESSION['management_credit'])&&$_SESSION['management_credit'])||(isset($_SESSION['executive_board'])&&$_SESSION['executive_board'])){?>
								/* if(user_props['branch_credit']==true && parseInt(full.requestedAmount)<1000001){
									authorized = true;
								}
								if(user_props['management_credit']==true && parseInt(full.requestedAmount)>1000000&&parseInt(full.requestedAmount)<5000001){
									authorized = true;
								}
								if(user_props['executive_board']==true && parseInt(full.requestedAmount)>5000000){
									authorized = true;
								} '<a href="#'+(authorized?'approve_loan':'')+'-modal" class="btn  btn-warning btn-sm edit_loan" data-toggle="modal"><i class="fa fa-edit"></i> '+(authorized?'Approve':'Edit')+' </a>'
								'<a href="#approve_loan-modal" class="btn  btn-warning btn-sm edit_loan" data-toggle="modal"><i class="fa fa-edit"></i> Approve </a>'
							<?php } ?> +'';}} */
							] ,
					  buttons: [
						{
						  extend: "copy",
						  className: "btn-sm"
						},
						{
						  extend: "csv",
						  className: "btn-sm"
						},
						{
						  extend: "excel",
						  className: "btn-sm"
						},
						{
						  extend: "pdfHtml5",
						  className: "btn-sm"
						},
						{
						  extend: "print",
						  className: "btn-sm"
						},
					  ],
					  responsive: true/*, */
					  
					});
				  }
			break;
			case 2: //rejected loan applications
				if(typeof(dTable['rejected'])!=='undefined'){
					$(".tab-pane").removeClass("active");
					$("#tab-2").addClass("active");
					$(".table#rejected tbody>tr:first").trigger('click');
				}
				else{
					dTable['rejected'] = $('#rejected').DataTable({
					  dom: "Bfrtip",
					  "order": [ [3, 'asc' ]],
					  "ajax": {
						  "url":"ajax_data.php",
						  "type": "POST",
						  "data": function(d){
									d.origin = 'loan_accounts';
									d.status = 2; // status of a rejected loan;
									d.start_date = startDate;
									d.end_date = endDate;
									$.extend(d,post_data);
								}
					  },
					  "initComplete": function(settings, json) {
						  $(".tab-pane").removeClass("active");
						  $("#tab-2").addClass("active");
							$(".table#rejected tbody>tr:first").trigger('click');
					  },
					  columns:[ { data: 'loanNo', render: function ( data, type, full, meta ) {
						  var page = "";
						  if(full.clientType==1){
							  page = "member_details.php?id=";
						  }
						  if(full.clientType==2){
							  page = "sacco_group_details.php?id=";
						  }
						  return '<a href="'+page+full.clientId+'&view=loan_accs&loanId='+full.id+'" title="View details">'+data+'</a>';}},
							{ data: 'clientNames'},
							{ data: 'productName'},
							{ data: 'applicationDate',  render: function ( data, type, full, meta ) {return moment(data, 'X').format('DD-MMM-YYYY');}},
							{ data: 'requestedAmount', render: function ( data, type, full, meta ) {return curr_format(parseInt(data));}}
							] ,
					  buttons: [
						{
						  extend: "copy",
						  className: "btn-sm"
						},
						{
						  extend: "csv",
						  className: "btn-sm"
						},
						{
						  extend: "excel",
						  className: "btn-sm"
						},
						{
						  extend: "pdfHtml5",
						  className: "btn-sm"
						},
						{
						  extend: "print",
						  className: "btn-sm"
						},
					  ],
					  responsive: true/*, */
					  
					});	
				}
			break;
			case 3: //approved loan accounts
				if(typeof(dTable['approved'])!=='undefined'){
					$(".tab-pane").removeClass("active");
					$("#tab-3").addClass("active");
					$(".table#approved tbody>tr:first").trigger('click');
				}
				else{
					dTable['approved'] = $('#approved').DataTable({
					  dom: "Bfrtip",
					  "order": [ [3, 'asc' ]],
					  "ajax": {
						  "url":"ajax_data.php",
						  "type": "POST",
						  "data": function(d){
									d.origin = 'loan_accounts';
									d.status = 3; // status of an approved loans;
									d.start_date = startDate;
									d.end_date = endDate;
									$.extend(d,post_data);
								}
					  },
					  "initComplete": function(settings, json) {
						  $(".tab-pane").removeClass("active");
						  $("#tab-3").addClass("active");
							$(".table#approved tbody>tr:first").trigger('click');
					  },
					  columns:[ { data: 'loanNo', render: function ( data, type, full, meta ) {
						  var page = "";
						  if(full.clientType==1){
							  page = "member_details.php?id=";
						  }
						  if(full.clientType==2){
							  page = "sacco_group_details.php?id=";
						  }
						  return '<a href="'+page+full.clientId+'&view=loan_accs&loanId='+full.id+'" title="View details">'+data+'</a>';}},
							{ data: 'clientNames'},
							{ data: 'productName'},
							{ data: 'applicationDate',  render: function ( data, type, full, meta ) {return moment(data, 'X').format('DD-MMM-YYYY');}},
							{ data: 'repaymentsMadeEvery', render: function ( data, type, full, meta ) {return ((full.repaymentsFrequency)*parseInt(full.repaymentsFrequency)) + ' ' + getDescription(4,data);}},
							{ data: 'requestedAmount', render: function ( data, type, full, meta ) {return curr_format(parseInt(data));}},
							{ data: 'amountApproved', render: function ( data, type, full, meta ) {return curr_format(parseInt(data));}}
							] ,
					  buttons: [
						{
						  extend: "copy",
						  className: "btn-sm"
						},
						{
						  extend: "csv",
						  className: "btn-sm"
						},
						{
						  extend: "excel",
						  className: "btn-sm"
						},
						{
						  extend: "pdfHtml5",
						  className: "btn-sm"
						},
						{
						  extend: "print",
						  className: "btn-sm"
						},
					  ],
					  responsive: true/*, */
					  
					});
				}
			break;
			case 4: //disbursed loans
				if(typeof(dTable['disbursed'])!=='undefined'){
					$(".tab-pane").removeClass("active");
					$("#tab-4").addClass("active");
					$(".table#disbursed tbody>tr:first").trigger('click');
				}
				else{
					dTable['disbursed'] = $('#disbursed').DataTable({
					  dom: "Bfrtip",
					  <?php if(!isset($client)): ?>
					  "order": [ [3, 'asc' ]],
					  "processing": true,
					  "serverSide": true,
					  "deferRender": true,
					  <?php endif; ?>
					  "ajax": {
						  "url":"<?php if(!isset($client)): ?>server_processing<?php else: ?>ajax_data<?php endif; ?>.php",
						  "type": "POST",
						  "data":  function(d){
									d.<?php if(!isset($client)): ?>page<?php else: ?>origin<?php endif; ?> = 'loan_accounts';
									d.status = 4;//status of the loan;
									d.start_date = startDate;
									d.end_date = endDate;
									<?php if(isset($client)): ?>$.extend(d,post_data);<?php endif; ?>
								}
					  },
					  "initComplete": function(settings, json) {
						  $(".tab-pane").removeClass("active");
						  $("#tab-4").addClass("active");
							$(".table#disbursed tbody>tr:first").trigger('click');
					  },
					  "footerCallback": function (tfoot, data, start, end, display ) {
						var api = this.api(), cols = [4,8,9,10,11,12,13];
						$.each(cols, function(key, val){
							var total = api.column(val).data().sum();
							$(api.column(val).footer()).html( curr_format(total) );
						});
					  },columns:[ { data: 'loanNo', render: function ( data, type, full, meta ) {
						  var page = "";
						  if(full.clientType==1){
							  page = "member_details.php?id=";
						  }
						  if(full.clientType==2){
							  page = "sacco_group_details.php?id=";
						  }
						  return '<a href="'+page+full.clientId+'&view=loan_accs&loanId='+full.id+'" title="View details">'+data+'</a>';}},
							{ data: 'clientNames'},
							{ data: 'productName'},
							{ data: 'disbursementDate',  render: function ( data, type, full, meta ) {return moment(data, 'X').format('DD-MMM-YYYY');}},
							{ data: 'disbursedAmount', render: function ( data, type, full, meta ) {return curr_format(parseInt(data));}},
							{ data: 'installments', render: function ( data, type, full, meta ) {return curr_format(parseInt(data));}},
							{ data: 'repaymentsMadeEvery', render: function ( data, type, full, meta ) {return ((full.repaymentsFrequency)*parseInt(full.installments)) + ' ' + getDescription(4,data);}},
							{ data: 'interestRate'},
							{ data: 'disbursedAmount', render: function ( data, type, full, meta ) {return curr_format(parseInt(data)/parseInt(full.installments));}},
							{ data: 'interest', render: function ( data, type, full, meta ) {return curr_format(parseInt(data)/parseInt(full.installments));}},
							{ data: 'interest', render: function ( data, type, full, meta ) {return curr_format((parseInt(data)/parseInt(full.installments))+parseInt(full.disbursedAmount)/parseInt(full.installments));}},
							{ data: 'interest', render: function ( data, type, full, meta ) {return curr_format(parseInt(data));}},
							{ data: 'disbursedAmount', render: function ( data, type, full, meta ) {return curr_format(parseInt(data)+parseInt(full.interest));}},
							{ data: 'amountPaid', render: function ( data, type, full, meta ) {return data?curr_format(parseInt(data)):0;}}
							] ,
					  buttons: [
						{
						  extend: "copy",
						  className: "btn-sm"
						},
						{
						  extend: "csv",
						  className: "btn-sm"
						},
						{
						  extend: "excel",
						  className: "btn-sm"
						},
						{
						  extend: "pdfHtml5",
						  className: "btn-sm"
						},
						{
						  extend: "print",
						  className: "btn-sm"
						},
					  ],
					  responsive: true/*, */
					  
					});
				}
			break;
			default:
			break;
		}
	};
	TableManageButtons = function() {
	  "use strict";
	  return {
		init: function() {
			loanAccountModel.account_details(null);
		  handleDataTableButtons();
		}
	  };
	}();
	TableManageButtons.init();
	$('#loan_types').change(TableManageButtons.init);
  });
	  
	$('.table tbody').on('click', 'tr .delete_me', function () {
		var confirmation = confirm("Are sure you would like to delete this loan application?");
		if(confirmation){
			var tbl;
			var id;
			var d_id = $(this).attr("id")
			var arr = d_id.split("-");
			id = arr[0];//This is the row id
			tbl = arr[1]; //This is the table to delete from 
			 $.ajax({ // create an AJAX call...
				type: 'POST',
				url: "delete.php",
				data: {id:id, tbl:tbl}, // the file to call
				success: function(response) { // on success..
					showStatusMessage(response, "success");
					setTimeout(function(){
						dTable['applications'].ajax.reload();
					}, 300);
				}			
			}); 
		}
	});
	$('.table#applications').on('click', '.edit_loan', function () {
		<?php if(!isset($_GET['loanId'])):?>
		var row = $(this).closest("tr[role=row]");
		if(row.length == 0){
			row = $(this).closest("tr").prev();
		}
		var data = dTable['applications'].row(row).data() ;
		<?php endif;?>
		//var loanAccountId = <?php if(isset($_GET['loanId'])):?><?php echo $_GET['loanId']; else:?>data.id<?php endif;?>;
		var editing = 0
		<?php if((isset($_SESSION['loan_officer'])&&$_SESSION['loan_officer'])):?>editing = 1; loanAccountModel.edit_client(1);<?php endif;?>
		loanAccountModel.getLoanAccountDetails(editing);
	});

	$('.table tbody').on('click', 'tr[role=row]', function () {
		var tbl = $(this).parent().parent();
		var dt = dTable[$(tbl).attr("id")];
		var data = dt.row(this).data();
		loanAccountModel.account_details(data);
		loanAccountModel.amountApproved(parseInt(data.requestedAmount));
		//ajax to retrieve transactions history//
		getTransactionHistory(data.id);
	});
	
	 function getTransactionHistory(loanAccountId){
		 $.ajax({
			url: "ajax_data.php",
			data: {id:loanAccountId, origin:'loan_account_transactions'},
			type: 'POST',
			dataType: 'json',
			success: function (response) {
				loanAccountModel.transactionHistory(response);			
			}
		});
	 }
	
	 function handleDateRangePicker(start_date, end_date){
		 startDate = start_date;
		 endDate = end_date;
		switch(parseInt($('#loan_types').val())){
			case 1: //applications pending approval
				dTable['applications'].ajax.reload();
				$(".table#applications tbody>tr:first").trigger('click');
			break;
			case 2: //rejected applications
				dTable['rejected'].ajax.reload();
				$(".table#rejected tbody>tr:first").trigger('click');
			break;
			case 3: //approved applications
				dTable['approved'].ajax.reload();
				$(".table#approved tbody>tr:first").trigger('click');
			break;
			case 4: //disbursed loans
				dTable['disbursed'].ajax.reload();
				$(".table#disbursed tbody>tr:first").trigger('click');
			break;
			default:
		}
	 }
</script>