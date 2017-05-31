<script type="text/javascript">
	/* var DepositAccountFee = function() {
			var self = this;
			self.chargeTrigger = ko.observable(),
			self.feeName = ko.observable(),
			self.amount = ko.observable(),
			self.dateApplicationMethod = ko.observable();
	}; */
	
	var DepositAccount = function() {
		var self = this;
		
		self.whenInterestIsPaidOptions = [{id:1,desc:'First day of every month'},{id:2,desc:'Date when account was created'}];
		self.accountBalForCalcInterestOptions = [{id:1,desc:'Average daily balance'},{id:2,desc:'Minimum balance on a given day'}];
		self.chargeTriggerOptions = [{id:1,desc:'Manual'},{id:2,desc:'Monthly Fee'}];
		self.dateApplicationMethodOptions = [{id:1,desc:'Monthly from Activation'},{id:2,desc:'Monthly from Start of Month'}];
		self.termTimeUnitOptions = [{id:1,desc:'Days'},{id:2,desc:'Weeks'},{id:3,desc:'Months'}];
		
		self.customers = ko.observableArray([{"id":1,"clientNames":"Kiwatule Womens Savings Group","clientType":2}]);
		self.productFees = ko.observableArray();
		// Stores an array of all the Data for viewing on the page
		self.depositProducts = ko.observableArray([{"id":1,"productName":"Savings Product","description":"Suitable for group savings", "availableTo":"3"}]);
		
		self.depositProduct = ko.observable();
		self.client = ko.observable(<?php if(isset($client)) echo json_encode($client);?>);
		self.openingBal = ko.observable();
		self.termLength = ko.observable();
		self.interestRate = ko.observable();
		
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
		
		//filter the deposit products based on the user type
		self.filteredDepositProducts = ko.computed(function() {
			var clientType = (self.client()?parseInt(self.client().clientType):3);
			return ko.utils.arrayFilter(self.depositProducts(), function(depositProduct) {
				//console.log(depositProduct.availableTo);
				return (clientType == parseInt(depositProduct.availableTo) || parseInt(depositProduct.availableTo)==3);
			});
		});
		
		//get the desc member element for each of the above arrays
		self.getDescription = function(array_index, id) {
			var arrays = [
				self.whenInterestIsPaidOptions,
				self.accountBalForCalcInterestOptions,
				self.chargeTriggerOptions,
				self.dateApplicationMethodOptions,
				self.termTimeUnitOptions
			];
			var description = "";
			$.each(arrays[array_index], function(k, v) {
				if(v.id == parseInt(id))
				description = v.desc;
			});
			return description;
		};
		
		//reset the whole form
		self.resetForm = function() {
			$("#depAccountForm")[0].reset();
		};
		
		//Retrieve page data from the server
		self.getServerData = function() {
			$.ajax({
				type: "post",
				dataType: "json",
				data:{origin:"deposit_account"},
				url: "ajax_data.php",
				success: function(response){
					self.depositProducts(response.products);
					self.customers(response.customers);
					self.productFees(response.productFees);
				}
			})
		};
		
		//send the items to the server for saving
		self.save = function(form) {			
			$.ajax({
				type: "post",
				data:{
					depositProductId : (self.depositProduct()?self.depositProduct().id:undefined),
					clientId : (self.client()?self.client().id:undefined),
					clientType : (self.client()?self.client().clientType:undefined),
					openingBalance : self.openingBal(),
					termLength : self.termLength(),
					interestRate : self.interestRate(),
					origin : "deposit_account"
				},
				url: "lib/AddData.php",
				success: function(response){
					// if it was an OK response, get the id of the inserted product and insert the product fees
					var result = parseInt(response)||0;
					if(result){/*  */
						if(self.productFees().length>0){
							$.ajax({
								type: "post",
								data:{feePostData:self.productFees(), depositAccountId: result, origin: "deposit_account_fee"},
								url: "lib/AddData.php",
								success: function(innerResponse){
									if(innerResponse===true){
										showStatusMessage("Data successfully saved" ,"success");
										setTimeout(function(){
											self.resetForm();
										}, 3000);
									}
									else{
										//inform the user what went wrong
										showStatusMessage("Error encountered while saving data: \n"+innerResponse ,"failed");
									}						
								}
							});
						}
					}else{
						showStatusMessage("Data successfully saved" ,"success");
						setTimeout(function(){
							self.resetForm();
						}, 3000);
					}
										
				}
			});
			
		};
	};

	var depositAccountModel = new DepositAccount();
	depositAccountModel.getServerData();// get data to be populated on the page
	ko.applyBindings(depositAccountModel, $("#deposit_account_form")[0]);
	$("#depAccountForm").validate({ submitHandler: depositAccountModel.save });//
	</script>