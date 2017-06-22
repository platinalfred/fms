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
		
		self.customers = ko.observableArray([{"id":1,"clientNames":"Kiwatule Womens Savings Group","clientType":2}]);
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
					self.customers(response.customers);
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
	ko.applyBindings(loanAccountModel);
	$("#loanAccountForm").validate({submitHandler: loanAccountModel.save});
	$("#loanPaymentForm").validate({submitHandler: loanAccountModel.makePayment});
	$("#loanAccountApprovalForm").validate({submitHandler: loanAccountModel.approveLoan});
</script>