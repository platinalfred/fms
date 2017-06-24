<script type="text/javascript">
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
		
		//this gets loaded when the loan is for approval
		self.loan_account_details = ko.observable();
		
		//loan repayment section form
		self.payment_amount = ko.observable(0);
		self.comments = ko.observable("");
		
		//loan account approval section
		self.amountApproved = ko.observable(0);
		self.approvalNotes = ko.observable();
		self.applicationStatus = ko.observable(3);
		
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
			//self.loanProduct(null);
			$("#loanAccountForm")[0].reset();
			dTable['applications'].ajax.reload();
		};
		
		//Retrieve page data from the server
		self.getServerData = function() {
			$.ajax({
				type: "post",
				dataType: "json",
				data:{origin:"loan_account"},
				url: "ajax_data.php",
				success: function(response){
					self.loanProducts(response.products);
					self.productFees(response.productFees);
					self.guarantors(response.guarantors);
					<?php if(!isset($client)):?>self.customers(response.customers); <?php endif;?>
				}
			})
		};
		
		//send the items to the server for saving
		self.save = function(form) {
			$.ajax({
				type: "post",
				data:{
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
					guarantors:self.selectedGuarantors(),//the chosen guarantors
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
							dTable['approved'].ajax.reload();
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
						}, 3000);
					}else{
						showStatusMessage("Error encountered while approving: \n"+response ,"fail");
					}
				}
			});
		};
		self.getLoanAccountDetails = function(){
			$.ajax({
				type: "post",
				dataType: "json",
				data:{
					origin:"loan_application_details",
					id:(self.account_details()?self.account_details().id:undefined),
					clientId: (self.account_details()?self.account_details().clientId:undefined),
					clientType: (self.account_details()?self.account_details().clientType:undefined)
				},
				url: "ajax_data.php",
				success: function(response){
					if(response){
						self.loan_account_details(response);
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
	
	
<!-- Datatables -->


	var user_props = <?php echo json_encode($_SESSION); ?>;
	var dTable = new Object();
	$(document).ready(function() {
		  var post_data = new Object();
		  <?php if(isset($client)):?> post_data=<?php echo json_encode($client);?>; <?php endif;?>
	var handleDataTableButtons = function() {
	  if ($("#applications").length) {
		  post_data['origin']='loan_applications';
		dTable['applications'] = $('#applications').DataTable({
		  dom: "Bfrtip",
		  "order": [ [3, 'asc' ]],
		  "ajax": {
			  "url":"ajax_data.php",
			  "type": "POST",
			  "data":  post_data
		  },
		  columns:[ { data: 'loanNo', render: function ( data, type, full, meta ) {return '<a href="members.php?client_id='+full.clientId+'&clientType='+full.clientType+'&loanId='+full.id+'" title="View details">'+data+'</a>';}},
				{ data: 'clientNames'},
				{ data: 'productName'},
				{ data: 'applicationDate',  render: function ( data, type, full, meta ) {return moment(data, 'X').format('DD-MMM-YYYY');}},
				{ data: 'requestedAmount', render: function ( data, type, full, meta ) {return curr_format(parseInt(data));}} 
				<?php if((isset($_SESSION['branch_credit'])&&$_SESSION['branch_credit'])||(isset($_SESSION['management_credit'])&&$_SESSION['management_credit'])||(isset($_SESSION['executive_board'])&&$_SESSION['executive_board'])){?>,
				{ data: 'id', render: function ( data, type, full, meta ) {
					var authorized =  false;
					if(user_props['branch_credit']&&parseInt(full.requestedAmount)<1000001){
						authorized = true;
					}
					if(user_props['management_credit']&&parseInt(full.requestedAmount)>1000000&&parseInt(full.requestedAmount)<5000001){
						authorized = true;
					}
					if(user_props['executive_board']&&parseInt(full.requestedAmount)>5000000){
						authorized = true;
					}
					return authorized?'<a href="#approve_loan-modal" class="btn  btn-warning btn-sm edit_me" data-toggle="modal"><i class="fa fa-edit"></i> Approve </a>':'';}}
				<?php }?>
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
		//$("#datatable-buttons").DataTable();
	  }
	  if ($("#rejected").length) {
		  post_data['origin']='rejected';
		  post_data['type']=<?php echo isset($_GET['type'])?"'{$_GET['type']}'":0; ?>;
		  
		dTable['rejected'] = $('#rejected').DataTable({
		  dom: "Bfrtip",
		  "order": [ [3, 'asc' ]],
		  "ajax": {
			  "url":"ajax_data.php",
			  "type": "POST",
			  "data":  post_data
		  },
		  columns:[ { data: 'loanNo', render: function ( data, type, full, meta ) {return '<a href="members.php?client_id='+full.clientId+'&clientType='+full.clientType+'&loanId='+full.id+'" title="View details">'+data+'</a>';}},
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
	  if ($("#approved").length) {
		  post_data['origin']='loan_accounts';
		  post_data['status']=3;
		dTable['approved'] = $('#approved').DataTable({
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
			  "data":  <?php if(!isset($client)): ?>function(d){
				d.page = 'loan_accounts';
				d.type = <?php echo isset($_GET['type'])?"'{$_GET['type']}'":0; ?>; //loan_type for the datatable;
				d.start_date = <?php echo isset($_GET['s_dt'])?"'{$_GET['s_dt']}'":"moment().subtract(30, 'days').format('X')"; ?>;
				d.end_date = <?php echo isset($_GET['e_dt'])?"'{$_GET['e_dt']}'":"moment().format('X')"; ?>;
				}
				<?php else: ?> post_data<?php endif; ?>
		  },
		  "initComplete": function(settings, json) {
				$(".table#approved tbody>tr:first").trigger('click');
		  },
		  "footerCallback": function (tfoot, data, start, end, display ) {
            var api = this.api(), cols = [5,6,7];
			$.each(cols, function(key, val){
				var total = api.column(val).data().sum();
				$(api.column(val).footer()).html( curr_format(total) );
			});
		  },columns:[ { data: 'loanNo', render: function ( data, type, full, meta ) {return '<a href="members.php?client_id='+full.clientId+'&clientType='+full.clientType+'&loanId='+full.id+'" title="View details">'+data+'</a>';}},
				{ data: 'clientNames'},
				{ data: 'productName'},
				{ data: 'applicationDate',  render: function ( data, type, full, meta ) {return moment(data, 'X').format('DD-MMM-YYYY');}},
				{ data: 'repaymentsMadeEvery', render: function ( data, type, full, meta ) {return ((full.repaymentsFrequency)*parseInt(full.repaymentsFrequency)) + ' ' + getDescription(4,data);}},
				{ data: 'requestedAmount', render: function ( data, type, full, meta ) {return curr_format(parseInt(data));}},
				{ data: 'amountPaid', render: function ( data, type, full, meta ) {return curr_format(parseInt(data));}},
				{ data: 'interest', render: function ( data, type, full, meta ) {return curr_format(parseInt(data));}}
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
		//$("#datatable-buttons").DataTable();
	  }
	};
	TableManageButtons = function() {
	  "use strict";
	  return {
		init: function() {
		  handleDataTableButtons();
		}
	  };
	}();
	TableManageButtons.init();
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
	$('.table#applications tbody').on('click', 'tr .edit_me', function () {
		var row = $(this).closest("tr[role=row]");
		if(row.length == 0){
			row = $(this).closest("tr").prev();
		}
		loanAccountModel.getLoanAccountDetails();
		edit_data(dTable['applications'].row(row).data(), "loanAccountApprovalForm"); 
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
</script>