<!-- Knockout js -->
<script src="js/knockout/knockout-min.js"></script>
<script type="text/javascript">
	<?php include_once("utils.inc");?> //utility functions
	
	var ProductFee = function() {
			var self = this;
			self.requiredFee = ko.observable(0);
			self.feeName = ko.observable();
			self.feeType = ko.observable();
			self.amount = ko.observable();
			self.amountCalculatedAs = ko.observable();
		};
	
	var Product = function() {
		var self = this;

		//variables for the dropdowns
		self.daysOfYearOptions = [{id:1,desc:'Actual/365 Fixed(365 days)'},{id:2,desc:'30 Day month (360 days)'}];
		self.intialAccountStateOptions = [{"id":1, "desc":"Pending Approval"},{"id":1, "desc":"Partial Application"}];
		self.taxCalculationMethodOptions = [{"id":1, "desc":"Inclusive"},{"id":2, "desc":"Exclusive"}];
		self.penaltyCalculationMethodOptions = [{"id":1, "desc":"No penalty"},{"id":2, "desc":"(Overdue Principal + Overdue Interest)*# of Late Days * Penalty Rate"}];
		self.repaymentsMadeEveryOptions = [{id:1,desc:'Day'},{id:2,desc:'Week'},{id:3,desc:'Month'}];
		self.taxRateSourceOptions = [{id:1,desc:'Day'},{id:2,desc:'Week'},{id:3,desc:'Month'}];
		

		self.amountCalculatedAsOptions = [{id:1,desc:'Percentage'},{id:2,desc:'Fixed Amount'}];
		
		self.productFees = ko.observableArray();
		
		//actual observables for the page
		
		self.availableToCb = ko.observableArray();
		
		// Stores an array of all the Data for viewing on the page
		self.productTypes = ko.observableArray([{"id":1, "typeName":"Fixed Term Loan","description":"A Fixed interest rate which allows accurate prediction of future payments"},{"id":2, "typeName":"Dynamic Term Loan","description":"Allows dynamic calculation of the interest rate, and thus, future payments"}]);
		
		self.feeTypesOptions = ko.observableArray([{"id":1, "description":"Fixed fee"}]);
		
		self.productType = ko.observable();
		self.active = ko.observable(false);
		self.taxApplicable = ko.observable(0);
		self.penaltyApplicable = ko.observable(1);
		self.taxRateSource = ko.observable();
		self.taxCalculationMethod = ko.observable();
		self.penaltyCalculationMethod = ko.observable();
		self.linkToDepositAccount = ko.observable(1);
		
		self.productName = ko.observable();
		self.description = ko.observable();
		self.active = ko.observable(0);
		self.defAmount = ko.observable();
		self.minAmount = ko.observable();
		self.maxAmount = ko.observable();
		self.maxTranches = ko.observable(1);
		self.defInterest = ko.observable();
		self.minInterest = ko.observable();
		self.maxInterest = ko.observable();
		self.repaymentsFrequency = ko.observable();
		self.repaymentsMadeEvery = ko.observable();
		self.defRepaymentInstallments = ko.observable();
		self.minRepaymentInstallments = ko.observable();
		self.maxRepaymentInstallments = ko.observable();
		self.daysOfYear = ko.observable();
		self.intialAccountState = ko.observable();
		self.defGracePeriod = ko.observable();
		self.minGracePeriod = ko.observable();
		self.maxGracePeriod = ko.observable();
		self.minCollateralRequired = ko.observable();
		self.minGuarantorsRequired = ko.observable();
		self.defaultOffSet = ko.observable();
		self.minOffSet = ko.observable();
		self.maxOffSet = ko.observable();
		self.penaltyApplicable = ko.observable(0);
		
		// Operations
		//set options value afterwards
		self.setOptionValue = function(option, item, key) {
			if (item === undefined) {
				option.value = "";
			} else {
				option.value = item[key];
			}
		};
		self.availableTo = function() {
			var total = 0;
			$.each(self.availableToCb(), function(k, v) {
				total += parseInt(v);
			})
			return total;
		};
		//Add a fee
		self.addFee = function() { self.productFees.push(new ProductFee()) };
		//remove fee
		self.removeFee = function(fee) {
			self.productFees.remove(fee);
		};
		//reset the form
		self.resetForm = function() {
			self.productFees(null);
			$("#loanProductForm").reset();
		};
		//Update the product types list
		self.updateProductTypes = function() {
			$.ajax({
				type: "post",
				dataType: "json",
				data:{origin:"loan_product"},
				url: "ajax_data.php",
				success: function(response){
					// Now use this data to update the view models, 
					// and Knockout will update the UI automatically
					if(response.length>0){
						self.productTypes(response.productTypes);					
						self.feeTypes(response.feeTypes);
					}					
				}
			})
		};
		
		//send the items to the server for saving
		self.save = function(form) {
			var feePostData = $.map(self.productFees(), function(fee) {
				return fee.feeName() ? {
					feeType: fee.feeType()?fee.feeType().id:undefined,
					feeName: fee.feeName(),
					amount: fee.amount(),
					amountCalculatedAs: fee.amountCalculatedAs()?fee.amountCalculatedAs().id:undefined,
					requiredFee: fee.requiredFee()
				} : undefined
			});
			// ko.utils.stringifyJson(postData);
			//To actually transmit to server as a regular form post, write this: ko.utils.postJson($("#productForm")[0], self.productTypes);
			$.ajax({
				type: "post",
				data:{
					productName : self.productName(),
					description : self.description(),
					productType : self.productType()?self.productType().id:undefined,
					active : self.active(),
					availableTo : self.availableTo,
					defAmount : self.defAmount(),
					minAmount : self.minAmount(),
					maxAmount : self.maxAmount(),
					maxTranches : self.maxTranches(),
					defInterest : self.defInterest(),
					minGracePeriod : self.minInterest(),
					maxInterest : self.maxInterest(),
					repaymentsFrequency : self.repaymentsFrequency(),
					repaymentsMadeEvery : self.repaymentsMadeEvery()?self.repaymentsMadeEvery().id:undefined,
					defRepaymentInstallments : self.defRepaymentInstallments(),
					minRepaymentInstallments : self.minRepaymentInstallments(),
					maxRepaymentInstallments : self.maxRepaymentInstallments(),
					daysOfYear : self.daysOfYear()?self.daysOfYear().id:undefined,
					intialAccountState : self.intialAccountState()?self.intialAccountState().id:undefined,
					defGracePeriod : self.defGracePeriod(),
					minGracePeriod : self.minGracePeriod(),
					maxGracePeriod : self.maxGracePeriod(),
					minCollateralRequired : self.minCollateralRequired(),
					minGuarantorsRequired : self.minGuarantorsRequired(),
					defaultOffSet : self.defaultOffSet(),
					minOffSet : self.minOffSet(),
					maxOffSet : self.maxOffSet(),
					penaltyApplicable : self.penaltyApplicable(),
					taxRateSource : self.taxRateSource()?self.taxRateSource().id:undefined,
					taxCalculationMethod : (self.taxCalculationMethod()?self.taxCalculationMethod().id:undefined),
					penaltyCalculationMethod : (self.penaltyCalculationMethod()?self.penaltyCalculationMethod().id:undefined),
					linkToDepositAccount : self.linkToDepositAccount(),
					origin : "loan_product"
				},
				url: "lib/AddData.php",
				success: function(response){
					// if it was an OK response, get the id of the inserted product and insert the product fees
					var result = parseInt(response)||0;
					if(result &&  /* */self.productFees().length>0){
						$.ajax({
							type: "post",
							data:{feePostData:feePostData, productId: result, origin: "loann_product_fee"},
							url: "lib/AddData.php",
							success: function(innerResponse){
								if(innerResponse===true){
									self.resetForm();
								}
								else{
									console.log(innerResponse);
								}							
							}
						});
					}else{
						console.log(response);
					}
										
				}
			});
			
		};
		self.updateProductTypes();//
	};

	var loanModel = new Product();
	ko.applyBindings(loanModel);
	$("#loanProductForm").validate({ submitHandler: loanModel.save });//
</script>