<!-- Knockout js -->
<script src="js/knockout/knockout-min.js"></script>
<script type="text/javascript">
	<?php include_once("utils.inc");?> //utility functions
	var dropDowns = new Object();
	dropDowns.termTimeUnitOptions = [{id:1,desc:'Days'},{id:2,desc:'Weeks'},{id:3,desc:'Months'}];
	dropDowns.daysInYearOptions = [{id:1,desc:'Actual/365 Fixed(365 days)'},{id:2,desc:'30 Day month (360 days)'}];
	dropDowns.whenInterestIsPaidOptions = [{id:1,desc:'First day of every month'},{id:2,desc:'Date when account was created'}];
	dropDowns.accountBalForCalcInterestOptions = [{id:1,desc:'Average daily balance'},{id:2,desc:'Minimum balance on a given day'}];
	dropDowns.chargeTriggerOptions = [{id:1,desc:'Manual'},{id:2,desc:'Monthly Fee'}];
	dropDowns.dateApplicationMethodOptions = [{id:1,desc:'Monthly from Activation'},{id:2,desc:'Monthly from Start of Month'}];
	
	var ProductFee = function() {
			var self = this;
			self.chargeTrigger = ko.observable(),
			self.feeName = ko.observable(),
			self.amount = ko.observable(),
			self.dateApplicationMethod = ko.observable();
		};
	
	var Product = function() {
		var self = this;
		self.productFees = ko.observableArray();
		self.availableToCb = ko.observableArray();
		// Stores an array of all the Data for viewing on the page
		self.productTypes = ko.observableArray([{"typeName":"Regular Savings","description":"A basic savings account where a client may perform regular deposit and withdrawals and accrue interest over time"}]);
		self.productType = ko.observable();
		self.interestRateApplicable = ko.observable(false);
		self.allowArbitraryFee = ko.observable(false);
		self.reqAttr = ko.pureComputed(function() {
			var required = false;
			if(self.defaultInterestRate()>0||self.minInterestRate()>0 ||self.maxInterestRate()){
				required = true;
			}
			return required;
		});
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
			$("#depProductForm").reset();
		};
		//Update the product types list
		self.updateProductTypes = function() {
			$.ajax({
				type: "post",
				dataType: "json",
				data:{origin:"deposit_product"},
				url: "ajax_data.php",
				success: function(response){
					// Now use this data to update the view models, 
					// and Knockout will update the UI automatically 
					self.productTypes(response);					
				}
			})
		};
		
		self.productName = ko.observable();
		self.recommededDepositAmount = ko.observable(0);
		self.maxWithdrawalAmount = ko.observable(0);
		self.defaultOpeningBal = ko.observable();
		self.minOpeningBal = ko.observable();
		self.maxOpeningBal = ko.observable();
		self.defaultTermLength = ko.observable();
		self.minTermLength = ko.observable();
		self.maxTermLength = ko.observable();
		self.termTimeUnit = ko.observable();
		self.interestPaid = self.interestRateApplicable();
		self.defaultInterestRate = ko.observable();
		self.minInterestRate = ko.observable();
		self.maxInterestRate = ko.observable();
		self.perNoOfDays = ko.observable();
		self.accountBalForCalcInterest = ko.observable();
		self.whenInterestIsPaid = ko.observable();
		self.daysInYear = ko.observable();
		
		//send the items to the server for saving
		self.save = function(form) {
			var feePostData = $.map(self.productFees(), function(fee) {
				return fee.feeName() ? {
					feeName: fee.feeName(),
					amount: fee.amount(),
					chargeTrigger: fee.chargeTrigger()?fee.chargeTrigger().id:undefined,
					dateApplicationMethod: fee.dateApplicationMethod()?fee.dateApplicationMethod().id:undefined
				} : undefined
			});
			// ko.utils.stringifyJson(postData);
			//To actually transmit to server as a regular form post, write this: ko.utils.postJson($("#productForm")[0], self.productTypes);
			$.ajax({
				type: "post",
				data:{
					productName : self.productName(),
					productType : self.productType()?self.productType().id:undefined,
					availableTo : self.availableTo,
					recommededDepositAmount : self.recommededDepositAmount(),
					maxWithdrawalAmount : self.maxWithdrawalAmount(),
					defaultOpeningBal : self.defaultOpeningBal(),
					minOpeningBal : self.minOpeningBal(),
					maxOpeningBal : self.maxOpeningBal(),
					defaultTermLength : self.defaultTermLength(),
					minTermLength : self.minTermLength(),
					maxTermLength : self.maxTermLength(),
					termTimeUnit : self.termTimeUnit()?self.termTimeUnit().id:undefined,
					interestPaid : self.interestPaid,
					defaultInterestRate : self.defaultInterestRate(),
					minInterestRate : self.minInterestRate(),
					maxInterestRate : self.maxInterestRate(),
					perNoOfDays : self.perNoOfDays(),
					accountBalForCalcInterest : self.accountBalForCalcInterest()?self.accountBalForCalcInterest().id:undefined,
					whenInterestIsPaid : self.whenInterestIsPaid()?self.whenInterestIsPaid().id:undefined,
					daysInYear : self.daysInYear()?self.daysInYear().id:undefined,
					allowArbitraryFees : self.allowArbitraryFee,
					origin : "deposit_product"
				},
				url: "lib/AddData.php",
				success: function(response){
					// if it was an OK response, get the id of the inserted product and insert the product fees
					var result = parseInt(response)||0;
					if(/* result &&  */self.productFees().length>0){
						$.ajax({
							type: "post",
							data:{feePostData:feePostData, productId: result, origin: "deposit_product_fee"},
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

	var productModel = new Product();
	ko.applyBindings(productModel);
	$("#depProductForm").validate({ submitHandler: productModel.save });//
</script>