<script type="text/javascript">

	var dTable = new Object();
	//guarantors 
	var guarantors = [];
	var Collateral = function() {
			var self = this;
			self.itemName = ko.observable();
			self.description = ko.observable();
			self.itemValue = ko.observable(0);
			self.attachmentUrl = ko.observable();
		};

	//any business owned by the applicant?
	var Business = function() {
			var self = this;
			self.businessName = ko.observable();
			self.natureOfBusiness = ko.observable("Retail");
			self.businessLocation = ko.observable();
			self.numberOfEmployees = ko.observable(0); //no of employees
			self.businessWorth = ko.observable(0); //monetary worth of the business
			self.ursbNumber = ko.observable(); //URSB registration number
		};
	//list of the guarantors
	var GuarantorSelection = function() {
		var self = this;
		self.guarantor = ko.observable();
	};
	var LoanAccount = function() {
		var self = this;
		//application form details
		self.requestedAmount2 = ko.observable(0);
		self.interestRate2 = ko.observable(0);
		self.offSetPeriod2 = ko.observable(0);
		self.installments2 = ko.observable(0);
		self.gracePeriod2 = ko.observable(0);
		
		// Stores an array of selected items
		// Put one item (e.g guarantor) in by default
		self.selectedGuarantors = ko.observableArray(); //[new GuarantorSelection()]
		self.addedCollateral = ko.observableArray(); //[new Collateral()]
		self.member_business = ko.observableArray(); //[new Business()]
		self.loanAccountFees = ko.observableArray();
		
		//filter the guarantors based on the user type and selected client
		self.filteredGuarantors = ko.computed(function() {
			if(self.clientType){
				var clientType = parseInt(self.clientType);
				var clientId = parseInt(self.id);
				return ko.utils.arrayFilter(guarantors, function(guarantor) {
					return (clientId != parseInt(guarantor.id) && parseInt(clientType)==1);
				});
			}
			else{
				return guarantors;
			}
		});		

		self.totalSavings = ko.pureComputed(function() {
			var total = 0;
			$.map(self.selectedGuarantors(), function(selectedGuarantor) {
				if(selectedGuarantor.guarantor()) {
					total += parseFloat("0" + selectedGuarantor.guarantor().savings);
				};
			});
			if(typeof(self.guarantors())!='undefined'){
				$.map(self.guarantors(), function(guarantor) {
					total += parseFloat("0" + guarantor.savings);
				});
			}
			return total;
		});
		self.collateral_items = ko.observableArray();
		self.guarantors = ko.observableArray();
		self.totalCollateral = ko.computed(function() {
			var total = 0;
			if(self.addedCollateral()){
				$.map(self.addedCollateral(), function(collateralItem) {
					if(collateralItem.itemValue()) {
						total += parseFloat("0" + collateralItem.itemValue());
					};
				});
			}
			if(typeof(self.collateral_items())!='undefined'){
				$.map(self.collateral_items(), function(collateral_item) {
					total += parseFloat("0" + collateral_item.itemValue);
				});
			}
			
			return total;
		});
		self.totalShares = ko.pureComputed(function() {
			var sum = 0;
			if(self.selectedGuarantors()){
				$.map(self.selectedGuarantors(), function(selectedGuarantor) {
					if(selectedGuarantor.guarantor()) {
						sum += parseFloat("0" + selectedGuarantor.guarantor().shares);
					};
				});
			}
			
			if(typeof(self.guarantors())!='undefined'){
				$.map(self.guarantors(), function(guarantor) {
					sum += parseFloat("0" + guarantor.shares);
				});
			}
			return sum;
		});
		 
		// Operations
		self.addGuarantor = function() { self.selectedGuarantors.push(new GuarantorSelection()) };
		self.removeGuarantor = function(selectedGuarantor) { self.selectedGuarantors.remove(selectedGuarantor) };
		self.addCollateral = function() { self.addedCollateral.push(new Collateral()) };
		self.removeCollateral = function(addedCollateral) { self.addedCollateral.remove(addedCollateral) };
		self.addBusinnes = function() { self.member_business.push(new Business()); };
		self.removeBusiness = function(business) { self.member_business.remove(business); };
	}
	var ViewModel = function() {
		var self = this;
		
		self.applicationDate = ko.observable('<?php echo date('d-m-Y');?>');
		self.loanProduct = ko.observable();
		self.loanProduct2 = ko.observable();
		self.client = ko.observable(<?php if(isset($client)) echo json_encode($client);?>);
		
		//all members
		<?php if(!isset($client)):?>
		self.clients = ko.observableArray([{"id":1,"clientNames":"Allan James Kintu"}]); 
		self.groups = ko.observableArray([{"groupId":1,"groupNames":"Kiwatule Womens Savings Group"}]); 
		self.clientTypes = ko.observableArray([{"type_id":1,"client_type":"Member"},{"type_id":2,"client_type":"Group Members"}]); 
		<?php endif;?>
		self.groupMembers = ko.observableArray([{"id":1,"groupId":1,"memberNames":"Allan James Kintu"}]);
		self.clientType = ko.observable(<?php if(isset($client)) echo $client['clientType']?>);
		// Stores an array of all the Data for viewing on the page
		self.loanProducts = ko.observableArray([{"id":1,"productName":"Group Savings Loan","description":"Suitable for group savings", "availableTo":"2"}]);
		
		self.productFees = ko.observableArray();
		
		//these are required as the datatable is being loaded
		self.transactionHistory = ko.observableArray(); //for the account transacation history display
		self.account_details = ko.observable();
		
		//this gets loaded when the loan is for approval/editing
		self.loan_account_details = ko.observable();
		self.loanAccountId = ko.observable();
		
		//loan repayment section form
		self.payment_amount = ko.observable(0);
		self.comments = ko.observable("");
		
		//loan account approval section
		self.amountApproved = ko.observable(0);
		self.approvalNotes = ko.observable();
		self.loanAccountStatus = ko.observable();
		
		//loan amount disbursement section
		self.disbursedAmount = ko.observable(0);
		self.disbursementNotes = ko.observable();
		
		self.groupLoanAccounts = ko.observableArray();
		self.curIndex = ko.computed(function(){
			var index = 0;
			$.each(self.groupLoanAccounts(), function(key, loanAccount){
				//check if the current account_details object matches this one
				if(self.account_details()&&self.account_details().id==loanAccount.id){
					index = key+1;
				}
			});
			return index;
		});
		
		// Operations
		//on navigating take the user to the next/previous item in the loan accounts array
		self.nextPrevLoanAccount = function(index) {
			self.account_details(self.groupLoanAccounts()[index]);
			self.loanAccountStatus(null);
		};
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
		
		//filter the loan products based on the client type
		self.filteredLoanProducts = ko.computed(function() {
			var clientType = (self.client()?parseInt(self.client().clientType):(self.account_details()?((self.account_details().groupId&&self.account_details().groupId>0)?2:1):3));
			return ko.utils.arrayFilter(self.loanProducts(), function(loanProduct) {
				return (clientType == parseInt(loanProduct.availableTo) || parseInt(loanProduct.availableTo)==3);
			});
		});
		//pick out loan product based on the product id of the account selected in the table
		self.getLoanProduct = function(loanProductId) {
			return ko.utils.arrayFirst(self.filteredLoanProducts(), function(loanProduct) {
				return (loanProductId == parseInt(loanProduct.id));
			});
		};
		/** when the user selects a particular group, only the members in that group should be returned,
		//when an individual client has been selected, then we return that client object as the only array element
		//There can be 1 or more loan accounts created, depending on the client type selected
		//so we join the join each of the member objects with that of the loan account
		**/
		self.filteredGroupMembers = ko.computed(function() {
			if(self.client()){
				if(parseInt(self.client().clientType)==1){
					return [$.extend(self.client(),new LoanAccount())];
				}
				if(parseInt(self.client().clientType)==2){
					var thisGroupMembers = [];
					ko.utils.arrayForEach(ko.utils.arrayFilter(self.groupMembers(), function(groupMember) {
						return (parseInt(self.client().id)==parseInt(groupMember.groupId));
					}), function(item) {
						thisGroupMembers.push($.extend(item, new LoanAccount()));
					});
					return thisGroupMembers;
				}
			}
			
		});
		//this array mainly applies to the loan application details page
		self.filteredGroupMembers2 = ko.computed(function() {
			if(self.account_details()){
				if(!self.account_details().groupId||self.account_details().groupId==0){
					if(self.account_details().status<4||self.account_details().status==11){
						var loan_account = new LoanAccount();
						
						loan_account.requestedAmount2(self.account_details().requestedAmount); 
						loan_account.interestRate2(self.account_details().interestRate); 
						loan_account.offSetPeriod2(self.account_details().offSetPeriod); 
						loan_account.installments2(self.account_details().installments); 
						loan_account.gracePeriod2(self.account_details().gracePeriod);
						loan_account.collateral_items(self.account_details().collateral_items);
						loan_account.guarantors(self.account_details().guarantors);
						var group_member = $.extend(self.account_details(),loan_account);
						return [group_member];
					}
				}
				else{
					var thisGroupMembers = [];
					ko.utils.arrayForEach(ko.utils.arrayFilter(self.groupLoanAccounts(), function(item) {
						return (parseInt(item.status)<4||parseInt(item.status)==11);
					}), function(groupLoanAccount) {
						var loan_account = new LoanAccount();
						
						loan_account.requestedAmount2(groupLoanAccount.requestedAmount); 
						loan_account.interestRate2(groupLoanAccount.interestRate); 
						loan_account.offSetPeriod2(groupLoanAccount.offSetPeriod); 
						loan_account.installments2(groupLoanAccount.installments); 
						loan_account.gracePeriod2(groupLoanAccount.gracePeriod); 
						//loan_account.collateral_items(groupLoanAccount.collateral_items);
						thisGroupMembers.push($.extend(groupLoanAccount, loan_account));
					});
					return thisGroupMembers;
				}
			}
			
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
		//reset the whole form after saving data in the database
		self.resetForm = function() {
			$("#loanAccountForm")[0].reset();
			self.loanProduct(null);
			self.client(null);
			self.clientType(null);
		
			endDate = moment().format('X'); //get the current time
			dTable['applications'].ajax.reload(null,false);
		};		
		//Retrieve page data from the server
		self.getServerData = function() {
			$.ajax({
				type: "post",
				dataType: "json",
				data:{origin:"loan_account"<?php if(isset($_GET['loanId'])):?>, loanAccountId:<?php echo (int)$_GET['loanId'];?> <?php endif;?>},
				url: "ajax_data.php",
				success: function(response){
					self.loanProducts(response.products);
					self.productFees(response.productFees);
					guarantors=response.guarantors;
					<?php if(!isset($client)):?>
					self.clients(response.clients); self.groups(response.groups); self.groupMembers(response.groupMembers); 
					<?php endif;?>
					<?php if(isset($client)&&$client['clientType']==2):?>self.groupMembers(response.groupMembers);<?php endif;?>
					<?php if(isset($_GET['loanId'])){?>
						var client_data = <?php echo json_encode($client);?>;
						self.account_details($.extend(client_data, response.account_details, {memberBusinesses: <?php echo json_encode($member_business);?>}, {employmentHistory: <?php echo json_encode($member_employment_history);?>}, {relatives: <?php echo json_encode($member_relatives2);?>}));
						self.loanProduct2(self.getLoanProduct(self.account_details().loanProductId));
					<?php } ?>
				}
			})
		};		
		//send the items to the server for saving
		self.save = function(form,event) {
			event.preventDefault();
			var frmdata = new FormData($(form)[0]);
			$.ajax({
				type: "post",
				url: "lib/AddData.php",
				data: frmdata,
				async: false,
				cache: false,
				contentType: false,
				processData: false,
				success: function(response){
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
							endDate = moment().format('X'); //get the current time
							dTable['disbursed'].ajax.reload(function(){
								self.account_details(dTable['disbursed'].row('#loanAcc'+self.account_details().id).data());
								},true);
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
					amountApproved: self.amountApproved(),
					approvalNotes: self.approvalNotes(),
					status: self.loanAccountStatus()
				},
				url: "lib/AddData.php",
				success: function(response){
					var result = parseInt(response)||0;
					if(result){
						showStatusMessage("Success :)" ,"success");
						setTimeout(function(){
							$("#loanAccountApprovalForm")[0].reset();
							$('#approve_loan-modal').modal('hide');
							endDate = moment().format('X'); //get the current time
							dTable['applications'].ajax.reload(null,true);
							self.account_details(null);
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
					disbursedAmount: ((self.account_details()&&self.account_details().status==4)?self.disbursedAmount():undefined),
					disbursementNotes: self.disbursementNotes(),
					status: 5
				},
				url: "lib/AddData.php",
				success: function(response){
					var result = parseInt(response)||0;
					if(result){/*  */
						showStatusMessage("Data successfully saved" ,"success");
						setTimeout(function(){
							$("#loanAccountApprovalForm")[0].reset();
							$('#disburse_loan-modal').modal('hide');
							endDate = moment().format('X'); //get the current time
							dTable['approved'].ajax.reload(null,true);
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
					memberId: (self.account_details()?self.account_details().memberId:undefined),
					clientType: 1,//(self.account_details()?self.account_details().clientType:undefined) 
					status:(self.account_details()?self.account_details().status:undefined),
					groupLoanAccountId:(self.account_details()?self.account_details().groupLoanAccountId:undefined)
				},
				url: "ajax_data.php",
				success: function(response){
					if(response){
						if(edit){
							self.loanAccountId(response.loan_account_details.id);
							self.client({id:self.account_details().memberId, clientNames:self.account_details().clientNames, clientType:1});
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
							self.loanProduct2(self.getLoanProduct(self.account_details().loanProductId));
							if(typeof(self.account_details().groupLoanAccountId)!='undefined'&&(self.account_details().groupLoanAccountId>0)){
								self.groupLoanAccounts(response);
								self.account_details(self.groupLoanAccounts()[self.curIndex()-1]);
							}
							else{
								self.account_details($.extend(self.account_details(),response));
							}
							self.loanAccountStatus(null);//
							//$("#loanProductId2").val(self.account_details().loanProductId);
						}
					}
				}
			});
		};
	};

	var viewModel = new ViewModel();
	viewModel.getServerData();// get data to be populated on the page
	ko.applyBindings(viewModel, $("#loan_account_details")[0]);
	$("#loanAccountForm").validate({submitHandler: viewModel.save});
	$("#editLoanAccountForm").validate({submitHandler: viewModel.save});
	$("#loanPaymentForm").validate({submitHandler: viewModel.makePayment});
	$("#loanAccountApprovalForm").validate({submitHandler: viewModel.approveLoan});
	$("#loanDisbursementForm").validate({submitHandler: viewModel.disburseLoan});
	
	
<!-- Datatables -->

	var user_props = <?php echo json_encode($_SESSION); ?>;
	$(document).ready(function() {
		  var post_data = new Object();
		  <?php if(isset($client)):?>post_data = <?php echo json_encode($client);?>; <?php endif;?>
	var handleDataTableButtons = function() {
		viewModel.account_details(null);
		viewModel.groupLoanAccounts([]);
		var loan_status = parseInt($('#loan_types').val());
			
		post_data.origin = 'loan_accounts';
		post_data.status = loan_status; // status of pending loan applications;
		<?php if(!isset($_GET['grpLId'])):?> //shouldn't query dates if referring to a group loan
			post_data.start_date = startDate;
			post_data.end_date = endDate;
		<?php endif; ?>
		<?php if(isset($_GET['groupId'])):?>post_data.groupId = <?php echo json_encode($_GET['groupId']);?>; <?php endif;?>//this caters for the display of all loans taken by groups
		<?php if(isset($_GET['memberId'])):?>post_data.memberId = <?php echo json_encode($_GET['memberId']);?>; <?php endif;?>//this caters for the display of all loans taken by a member
		<?php if(isset($_GET['grpLId'])):?>post_data.grpLId = <?php echo json_encode($_GET['grpLId']);?>; <?php endif;?>//this caters for the display of loans taken by a group
		
		if(loan_status==1||loan_status==2||loan_status==11||loan_status==12){
			//partial applications/pending approval/closed_rejected/closed_withdrawn
			if(typeof(dTable['applications'])!=='undefined'){
				$(".tab-pane").removeClass("active");
				$("#tab-1").addClass("active");
				dTable['applications'].ajax.reload(null,true);
				$(".table#applications tbody>tr:first").trigger('click');//
			}
			else{
				dTable['applications'] = $('#applications').DataTable({
				  dom: "Bfrtip",
				  "order": [ [4, 'desc' ]],
				  "ajax": {
					  "url":"ajax_data.php",
					  "type": "POST",
					  "data": function(d){
								return post_data;
							}
				  },
				  "initComplete": function(settings, json) {
					  $(".tab-pane").removeClass("active");
					  $("#tab-1").addClass("active");
					  $(".table#applications tbody>tr:first").trigger('click');
				  },
				  columns:[ { data: 'id', render: function ( data, type, full, meta ) {
					  return '<?php if(isset($_SESSION['loans_officer'])){ ?> '+data+' <?php }else{ ?> <a href="member_details.php?memberId='+full.memberId+'&view=loan_accs&loanId='+data+'" title="View details">L'+data+'</a> <?php } ?>'; }
					  },
						{ data: 'clientNames'},
						<?php if(!isset($_GET['groupId'])):?>{ data: 'groupName', render: function( data, type, full, meta ){return data?('<a href="group_details.php?groupId='+full.groupId+'&view=loan_accs" title="View details">'+data+'</a>'):'';}},<?php endif;?>
						<?php if(!isset($_GET['grpLId'])):?>{ data: 'groupLoanAccountId', render: function( data, type, full, meta ){return (data&&data!=0)?('<a href="group_details.php?groupId='+full.groupId+'&view=loan_accs&grpLId='+full.groupLoanAccountId+'" title="View details"> Ref#'+data+'</a>'):'';}},<?php endif;?>
						{ data: 'productName'},
						{ data: 'applicationDate',  render: function ( data, type, full, meta ) {return moment(data, 'X').format('DD-MMM-YYYY');}},
						{ data: 'requestedAmount', render: function ( data, type, full, meta ) {return curr_format(parseInt(data));}} ,
						{ data: 'status', render: function ( data, type, full, meta ) {
							return ((parseInt(data)==1||parseInt(data)==11)?'<a href="#edit_loan_account-modal" class="btn  btn-info btn-sm edit_loan" data-toggle="modal"><i class="fa fa-edit"></i> Update</a>':'')+
							'<a href="#approve_loan-modal" class="btn  btn-warning btn-sm edit_loan" data-toggle="modal"><i class="fa fa-list"></i> Details </a>';}}/* /*  */
						] ,
				  buttons: [
					{
						extend: "copy",
						className: "btn-sm",
						exportOptions: {
							columns: [ 0, 1, 2,3,4,5, 6]
						}
					},
					{
					  extend: "csv",
					  className: "btn-sm",
					  exportOptions: {
							columns: [ 0, 1, 2,3,4,5, 6]
						}
					},
					{
					  extend: "excel",
					  className: "btn-sm",
					  exportOptions: {
							columns: [ 0, 1, 2,3,4,5, 6]
						}
					},
					{
					  extend: "pdfHtml5",
					  className: "btn-sm",
					  exportOptions: {
							columns: [ 0, 1, 2,3,4,5, 6]
						}
					},
					{
					  extend: "print",
					  className: "btn-sm",
					  exportOptions: {
							columns: [ 0, 1, 2,3,4,5, 6]
						}
					},
				  ],
				  responsive: false/*, */
				  
				});
			}
		}
		if(loan_status==16){//rejected loan applications
			if(typeof(dTable['rejected'])!=='undefined'){
				$(".tab-pane").removeClass("active");
				$("#tab-2").addClass("active");
				dTable['rejected'].ajax.reload(null,true);
				$(".table#rejected tbody>tr:first").trigger('click');
			}
			else{
				dTable['rejected'] = $('#rejected').DataTable({
				  dom: "Bfrtip",
				  "order": [ [4, 'asc' ]],
				  "ajax": {
					  "url":"ajax_data.php",
					  "type": "POST",
					  "data": function(d){
								return post_data;
							}
				  },
				  "initComplete": function(settings, json) {
					  $(".tab-pane").removeClass("active");
					  $("#tab-2").addClass("active");
						$(".table#rejected tbody>tr:first").trigger('click');
				  },
				  columns:[ { data: 'id', render: function ( data, type, full, meta ) {
					  return '<?php if(isset($_SESSION['loans_officer'])){ ?> '+data+' <?php }else{ ?> <a href="member_details.php?memberId='+full.memberId+'&view=loan_accs&loanId='+data+'" title="View details">L'+data+'</a> <?php } ?>'; }
					  },
						{ data: 'clientNames'},
						<?php if(!isset($_GET['groupId'])):?>{ data: 'groupName', render: function( data, type, full, meta ){return data?('<a href="group_details.php?groupId='+full.groupId+'&view=loan_accs" title="View details">'+data+'</a>'):'';}},<?php endif;?>
						<?php if(!isset($_GET['grpLId'])):?>{ data: 'groupLoanAccountId', render: function( data, type, full, meta ){return (data&&data!=0)?('<a href="group_details.php?groupId='+full.groupId+'&view=loan_accs&grpLId='+full.groupLoanAccountId+'" title="View details"> Ref#'+data+'</a>'):'';}},<?php endif;?>
						{ data: 'productName'},
						{ data: 'productName'},
						{ data: 'applicationDate',  render: function ( data, type, full, meta ) {return moment(data, 'X').format('DD-MMM-YYYY');}},
						{ data: 'requestedAmount', render: function ( data, type, full, meta ) {return curr_format(parseInt(data));}} ,
						{ data: 'status', render: function ( data, type, full, meta ) {
							return ((parseInt(data)==1||parseInt(data)==11)?'<a href="#edit_loan_account-modal" class="btn  btn-info btn-sm edit_loan" data-toggle="modal"><i class="fa fa-edit"></i> Update</a>':'')+
							'<a href="#approve_loan-modal" class="btn  btn-warning btn-sm edit_loan" data-toggle="modal"><i class="fa fa-list"></i> Details </a>';}}
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
		}
		if(loan_status==3){ //approved loan accounts
			if(typeof(dTable['approved'])!=='undefined'){
				$(".tab-pane").removeClass("active");
				$("#tab-3").addClass("active");
				dTable['approved'].ajax.reload(null,true);
				$(".table#approved tbody>tr:first").trigger('click');
			}
			else{
				dTable['approved'] = $('#approved').DataTable({
				  dom: "Bfrtip",
				  "order": [ [4, 'asc' ]],
				  "ajax": {
					  "url":"ajax_data.php",
					  "type": "POST",
					  "data": function(d){
								return post_data;
							}
				  },
				  "initComplete": function(settings, json) {
					  $(".tab-pane").removeClass("active");
					  $("#tab-3").addClass("active");
						$(".table#approved tbody>tr:first").trigger('click');
				  },
				  columns:[ { data: 'id', render: function ( data, type, full, meta ) {
					  return '<?php if(isset($_SESSION['loans_officer'])){ ?> '+data+' <?php }else{ ?> <a href="member_details.php?memberId='+full.memberId+'&view=loan_accs&loanId='+data+'" title="View details">L'+data+'</a> <?php } ?>'; }
					  },
						{ data: 'clientNames'},
						<?php if(!isset($_GET['groupId'])):?>{ data: 'groupName', render: function( data, type, full, meta ){return data?('<a href="group_details.php?groupId='+full.groupId+'&view=loan_accs" title="View details">'+data+'</a>'):'';}},<?php endif;?>
						<?php if(!isset($_GET['grpLId'])):?>{ data: 'groupLoanAccountId', render: function( data, type, full, meta ){return (data&&data!=0)?('<a href="group_details.php?groupId='+full.groupId+'&view=loan_accs&grpLId='+full.groupLoanAccountId+'" title="View details"> Ref#'+data+'</a>'):'';}},<?php endif;?>
						{ data: 'productName'},
						{ data: 'applicationDate',  render: function ( data, type, full, meta ) {return moment(data, 'X').format('DD-MMM-YYYY');}},
						{ data: 'repaymentsMadeEvery', render: function ( data, type, full, meta ) {return ((full.repaymentsFrequency)*parseInt(data)) + ' ' + getDescription(4,data);}},
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
				  responsive: false/*, */
				  
				});
			}
		}
		if(loan_status==4||loan_status==5||loan_status==13||loan_status==14||loan_status==15){ //disbursed loans
			if(typeof(dTable['disbursed'])!=='undefined'){
				$(".tab-pane").removeClass("active");
				$("#tab-4").addClass("active");
				dTable['disbursed'].ajax.reload(null,true);
				$(".table#disbursed tbody>tr:first").trigger('click');
			}
			else{
				dTable['disbursed'] = $('#disbursed').DataTable({
				  dom: "Bfrtip",
				  <?php if(!isset($client)): ?>
				  "order": [ [3, 'desc' ]],
				  "processing": true,
				  "serverSide": true,
				  "deferRender": true,
				  <?php endif; ?>
				  "ajax": {
					  "url":"<?php if(!isset($client)): ?>server_processing<?php else: ?>ajax_data<?php endif; ?>.php",
					  "type": "POST",
					  "data":  function(d){
								d.<?php if(!isset($client)): ?>page<?php else: ?>origin<?php endif; ?> = 'loan_accounts';
								d.status = loan_status;//status of the loan;
								d.start_date = startDate;
								d.end_date = endDate;
								d.clientType = 3
								<?php if(isset($client)): ?>$.extend(d,post_data);<?php endif; ?>
							}
				  },
				  "initComplete": function(settings, json) {
					  $(".tab-pane").removeClass("active");
					  $("#tab-4").addClass("active");
						$(".table#disbursed tbody>tr:first").trigger('click');
				  },
				  "footerCallback": function (tfoot, data, start, end, display ) {
					var api = this.api(), cols = [5,9,10,11,12,13,14];
					$.each(cols, function(key, val){
						var total = api.column(val).data().sum();
						$(api.column(val).footer()).html( curr_format(Math.round(total)) );
					});
				  },columns:[ { data: 'id', render: function ( data, type, full, meta ) {
				  return '<?php if(isset($_SESSION['loans_officer'])){ ?> '+data+' <?php }else{ ?> <a href="member_details.php?memberId='+full.memberId+'&view=loan_accs&loanId='+data+'" title="View details">L'+data+'</a> <?php } ?>'; }},
						{ data: 'clientNames'},
						{ data: 'groupName', render: function( data, type, full, meta ){return full.groupId?('<a href="group_details.php?id='+full.groupId+'&view=loan_accs&loanId='+full.id+'" title="View details">'+data+'</a>'):'';}},
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
		}
	};
	TableManageButtons = function() {
	  "use strict";
	  return {
		init: function() {
			viewModel.account_details(null);
			handleDataTableButtons();
		}
	  };
	}();
	TableManageButtons.init();
	$('#loan_types').change(TableManageButtons.init);
	//reload the tables every 30 seconds
	//setInterval( TableManageButtons.init, 30000 );
  });
	
	$('.table tbody').on('click', 'tr .delete_me', function () {
		var confirmation = confirm("Are sure you would like to delete this loan application?");
		if(confirmation){
			$.ajax({ // create an AJAX call...
				type: 'POST',
				url: "delete.php",
				data: {id:viewModel.account_details().id, tbl:'loan_account'}, // the file to call
				success: function(response) { // on success..
					showStatusMessage(response, "success");
					setTimeout(function(){
						dTable['applications'].ajax.reload(null,true);
					}, 300);
				}			
			}); 
		}
	});

	$('.table tbody').on('click', 'tr[role=row]', function () {
		var tbl = $(this).parent().parent();
		var dt = dTable[$(tbl).attr("id")];
		var data = dt.row(this).data();
		viewModel.account_details(data);
		viewModel.amountApproved(parseInt(data.requestedAmount));
		/*if(((data.groupLoanAccountId||data.groupLoanAccountId>0)&&viewModel.groupLoanAccounts().length==0)||(!data.groupLoanAccountId||data.groupLoanAccountId==0)){
			console.log('Group Loan Account Id '+data.groupLoanAccountId);
		}*/
		viewModel.getLoanAccountDetails(0);
	});
	 function handleDateRangePicker(start_date, end_date){
		 startDate = start_date;
		 endDate = end_date;
		 TableManageButtons.init();
		/*  var loan_status = parseInt($('#loan_types').val());
		if(loan_status==1||loan_status==2||loan_status==11||loan_status==12){//applications pending approval/rejected
			dTable['applications'].ajax.reload(null,true);
			$(".table#applications tbody>tr:first").trigger('click');
		}
		if(loan_status == 16){//rejected applications
			dTable['rejected'].ajax.reload(null,true);
				$(".table#rejected tbody>tr:first").trigger('click');
		}
		if(loan_status == 3){//approved applications
				dTable['approved'].ajax.reload(null,true);
				$(".table#approved tbody>tr:first").trigger('click');
		}
		if(loan_status==4||loan_status==5||loan_status==13||loan_status==14||loan_status==15){ //disbursed loans
				dTable['disbursed'].ajax.reload(null,true);
				$(".table#disbursed tbody>tr:first").trigger('click');
		} */
	 }
</script>