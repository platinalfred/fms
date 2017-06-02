	
	var LoanProductFee = function() {
			var self = this;
			self.requiredFee = ko.observable(0);
			self.feeName = ko.observable();
			self.feeType = ko.observable();
			self.amount = ko.observable();
			self.amountCalculatedAs = ko.observable();
		};
	
	var LoanProduct = function() {
		var self = this;

		//variables for the dropdowns
		self.daysOfYearOptions = [{id:1,desc:'Actual/365 Fixed(365 days)'},{id:2,desc:'30 Day month (360 days)'}];
		self.initialAccountStateOptions = [{"id":1, "desc":"Pending Approval"},{"id":1, "desc":"Partial Application"}];
		self.taxCalculationMethodOptions = [{"id":1, "desc":"Inclusive"},{"id":2, "desc":"Exclusive"}];
		self.penaltyCalculationMethodOptions = ko.observableArray([{"id":1, "methodDescription":"No penalty"},{"id":2, "methodDescription":"(Overdue Principal + Overdue Interest)*# of Late Days * Penalty Rate"}]);
		self.repaymentsMadeEveryOptions = [{id:1,desc:'Day(s)'},{id:2,desc:'Week(s)'},{id:3,desc:'Month(s)'}];
		self.penaltyChargeRate = [{id:1,desc:'Day'},{id:2,desc:'Week'},{id:3,desc:'Month'}];
		self.taxRateSourceOptions = [{id:1,desc:'URA'},{id:2,desc:'GOVT'},{id:3,desc:'District'}];
		
		self.amountCalculatedAsOptions = [{id:1,desc:'Flat amount'},{id:2,desc:'% of Disbursement Amount'},];
		
		self.existingLoanProductFees = ko.observableArray();
		self.productFee = ko.observableArray();//to be sent to the server
		self.newLoanProductFees = ko.observableArray();
		
		
		//actual observables for the page
		
		self.availableToCb = ko.observableArray();
		
		// Stores an array of all the Data for viewing on the page
		self.productTypes = ko.observableArray([{"id":1, "typeName":"Fixed Term Loan","description":"A Fixed interest rate which allows accurate prediction of future payments"},{"id":2, "typeName":"Dynamic Term Loan","description":"Allows dynamic calculation of the interest rate, and thus, future payments"}]);
		
		self.feeTypesOptions = ko.observableArray([{"id":1, "description":"Fixed fee"}]);
		
		self.productType = ko.observable();
		self.active = ko.observable(1);
		
		self.productName = ko.observable();
		self.description = ko.observable();
		self.defLoanAmount = ko.observable();
		self.minLoanAmount = ko.observable();
		self.maxLoanAmount = ko.observable();
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
		self.initialAccountState = ko.observable();
		self.defGracePeriod = ko.observable();
		self.minGracePeriod = ko.observable();
		self.maxGracePeriod = ko.observable();
		self.minCollateral = ko.observable();
		self.minGuarantors = ko.observable();
		self.defOffSet = ko.observable();
		self.minOffSet = ko.observable();
		self.maxOffSet = ko.observable();
		//self.penaltyApplicable = ko.observable(0);
		self.taxApplicable = ko.observable(0);
		self.taxRateSource = ko.observable();
		self.taxCalculationMethod = ko.observable();
		self.penaltyCalculationMethod = ko.observable();
		self.linkToDepositAccount = ko.observable(1);
		self.penaltyTolerancePeriod = ko.observable();
		self.penaltyRateChargedPer = ko.observable();
		self.defPenaltyRate = ko.observable();
		self.minPenaltyRate = ko.observable();
		self.maxPenaltyRate = ko.observable();
		
		self.penCalcMethId = ko.pureComputed(function(){
			return self.penaltyCalculationMethod()?(self.penaltyCalculationMethod().id>1?1:0):0;
		});
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
		self.availableTo = function() {
			var total = 0;
			$.map(self.availableToCb(), function(val) {
				total += parseInt(val);
			})
			return total;
		};
		//get the amountCalculatedAs value
		self.getAmountCalculatedAsOption = function(amountCAsId) {
			var amountCAs = "Default";
			$.each(self.amountCalculatedAsOptions, function(k, v) {
				if(v.id == parseInt(amountCAsId))
				amountCAs = v.desc;
			})
			return amountCAs;
		};
		//required function or not
		self.requiredFunctionNot = function(key) {
			return parseInt(key)==0?"No":"Yes";
		};
		//Add a fee
		self.addFee = function() { self.newLoanProductFees.push(new LoanProductFee()) };
		//remove fee
		self.removeFee = function(fee) {
			self.newLoanProductFees.remove(fee);
		};
		//reset the form
		self.resetForm = function() {
			/* if(self.newLoanProductFees())self.newLoanProductFees(null);*/
			$("#loanProductForm")[0].reset();
			self.newLoanProductFees.removeAll();
			self.productType(null); 
			//self.updateLoanProductTypes();
		};
		//Update the product types list
		self.updateLoanProductTypes = function() {
			$.ajax({
				type: "post",
				dataType: "json",
				data:{origin:"loan_product"},
				url: "ajax_data.php",
				success: function(response){
					// Now use this data to update the view models, 
					// and Knockout will update the UI automatically
					//if(response.length>0){
						if(response.loanProductTypes) self.productTypes(response.loanProductTypes);
						if(response.penaltyCalculationMethods) self.penaltyCalculationMethodOptions(response.penaltyCalculationMethods);
						if(response.feeTypes) self.feeTypesOptions(response.feeTypes);
						//if(response.taxRateSources) self.taxRateSourceOptions(response.taxRateSources);
						if(response.existingProductFees) self.existingLoanProductFees(response.existingProductFees);
					//}					
				}
			})
		};
		
		//send the items to the server for saving
		self.save = function(form) {
			var feePostData = $.map(self.newLoanProductFees(), function(fee) {
				return fee.feeName() ? {
					feeType: (fee.feeType()?fee.feeType().id:undefined),
					feeName: fee.feeName(),
					amount: fee.amount(),
					amountCalculatedAs: (fee.amountCalculatedAs()?fee.amountCalculatedAs().id:undefined),
					requiredFee: (fee.requiredFee()?1:0)
				} : undefined
			});
			// ko.utils.stringifyJson(postData);
			//To actually transmit to server as a regular form post, write this: ko.utils.postJson($("#productForm")[0], self.productTypes);
			$.ajax({
				type: "post",
				data:{
					productName : self.productName(),
					description : self.description(),
					productType : (self.productType()?self.productType().id:undefined),
					active : (self.active()?1:0),
					availableTo : self.availableTo,
					defAmount : self.defLoanAmount(),
					minAmount : self.minLoanAmount(),
					maxAmount : self.maxLoanAmount(),
					maxTranches : self.maxTranches(),
					defInterest : self.defInterest(),
					minInterest : self.minInterest(),
					maxInterest : self.maxInterest(),
					repaymentsFrequency : self.repaymentsFrequency(),
					repaymentsMadeEvery : self.repaymentsMadeEvery()?self.repaymentsMadeEvery().id:undefined,
					defRepaymentInstallments : self.defRepaymentInstallments(),
					minRepaymentInstallments : self.minRepaymentInstallments(),
					maxRepaymentInstallments : self.maxRepaymentInstallments(),
					initialAccountState : self.initialAccountState()?self.initialAccountState().id:undefined,
					defGracePeriod : self.defGracePeriod(),
					minGracePeriod : self.minGracePeriod(),
					maxGracePeriod : self.maxGracePeriod(),
					minCollateral : self.minCollateral(),
					minGuarantors : self.minGuarantors(),
					defOffSet : self.defOffSet(),
					minOffSet : self.minOffSet(),
					maxOffSet : self.maxOffSet(),
					//penaltyApplicable : (self.penaltyApplicable()?1:0),
					penaltyCalculationMethodId : (self.penaltyCalculationMethod()?self.penaltyCalculationMethod().id:undefined),
					penaltyTolerancePeriod : self.penaltyTolerancePeriod(),
					penaltyRateChargedPer : self.penaltyRateChargedPer()?self.penaltyRateChargedPer().id:undefined,
					defPenaltyRate : self.defPenaltyRate(),
					minPenaltyRate : self.minPenaltyRate(),
					maxPenaltyRate : self.maxPenaltyRate(),
					daysOfYear : self.daysOfYear()?self.daysOfYear().id:undefined,
					taxRateSource : self.taxRateSource()?self.taxRateSource().id:undefined,
					taxCalculationMethod : (self.taxCalculationMethod()?self.taxCalculationMethod().id:undefined),
					linkToDepositAccount : self.linkToDepositAccount(),
					newLoanProductFees:feePostData,
					existingLoanProductFees:self.productFee(),
					origin : "loan_product"
				},
				url: "lib/AddData.php",
				success: function(response){
					// if it was an OK response, get the id of the inserted product and insert the product fees
					var result = parseInt(response)||0;
					if(result){
							showStatusMessage("Data successfully saved" ,"success");
							setTimeout(function(){
								self.resetForm();
								var dt = dTable[tblLoanProduct];
								dt.ajax.reload();
							}, 3000);
					}else{
						console.log(response);
						showStatusMessage("Error saving record: \n" + response, "failed");
					}
										
				}
			});
			
		};
	};

	var loanProductModel = new LoanProduct();
	ko.applyBindings(loanProductModel, $("#loan_products")[0]);
	loanProductModel.updateLoanProductTypes();
	$("#loanProductForm").validate({ submitHandler: loanProductModel.save });