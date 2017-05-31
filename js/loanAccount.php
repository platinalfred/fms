<script type="text/javascript">
	var LoanAccountFee = function() {
			var self = this;
			self.loanAccountFee = ko.observable()
	}; /* */
	<?php if(isset($client)): ?>
		<?php if($client['clientType']==1):?>
			//list of the guarantors
			var GuarantorSelection = function() {
				var self = this;
				self.guarantor = ko.observable();
			};
		<?php endif;?>
	<?php endif;?>
	var LoanAccount = function() {
		var self = this;
		
		<?php if(isset($client)): ?>
			<?php if($client['clientType']==1):?>
			//guarantors 
			self.guarantors = ko.observableArray();
			// Stores an array of selectedGuarantors
			self.selectedGuarantors = ko.observableArray([new GuarantorSelection()]);
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
			<?php endif;?>
		<?php else:?>
			self.customers = ko.observableArray([{"id":1,"clientNames":"Kiwatule Womens Savings Group","clientType":2}]);
		<?php endif;?>
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
		
		//reset the whole form after saving data in the database
		self.resetForm = function() {
			$("#loanAccountForm")[0].reset();
		};
		
		//Retrieve page data from the server
		self.getServerData = function() {
			$.ajax({
				type: "post",
				dataType: "json",
				data:{origin:"loan_account"<?php if(isset($client)) {echo ", clientType:".$client['clientType'].", memberId:".$client['id'];}?>},
				url: "ajax_data.php",
				success: function(response){
					self.loanProducts(response.products);
					self.productFees(response.productFees);
					<?php if(isset($client)){
						if($client['clientType']==1){?>
							self.guarantors(response.guarantors);
					<?php } }else{?>
						self.customers(response.customers);
					<?php }?>
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
					applicationDate : moment(self.applicationDate()).format('X'),
					interestRate : self.interestRate(),
					offSetPeriod : self.offSetPeriod(),
					gracePeriod : self.gracePeriod(),
					repaymentsFrequency : self.repaymentsFrequency(),
					repaymentsMadeEvery : self.repaymentsMadeEvery(),
					installments : self.installments(),
					penaltyCalculationMethodId : self.loanProduct()?self.loanProduct().penaltyCalculationMethodId:undefined,
					penaltyTolerancePeriod : self.loanProduct()?self.loanProduct().penaltyTolerancePeriod:undefined,
					penaltyRateChargedPer : self.loanProduct()?self.loanProduct().penaltyRateChargedPer:undefined,
					penaltyRate : self.loanProduct()?self.loanProduct().penaltyRate:undefined,
					linkToDepositAccount : self.loanProduct()?self.loanProduct().linkToDepositAccount:undefined,
					origin : "loan_account"
				},
				url: "lib/AddData.php",
				success: function(response){
					// if it was an OK response, get the id of the inserted product and insert the product fees
					var result = parseInt(response)||0;
					if(result){/*  */
						if(self.loanAccountFees().length>0||self.guarantors().length>0){
							if(self.loanAccountFees().length>0){
								$.ajax({
									type: "post",
									data:{feePostData:self.loanAccountFees(), loanAccountId: result, origin: "loan_account_fee"},
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
							if(self.guarantors().length>0){
								$.ajax({
									type: "post",
									data:{feePostData:self.guarantors(), loanAccountId: result, origin: "loan_account_fee"},
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
					}else{
						showStatusMessage("Error encountered while saving data: \n"+response ,"failed");
						setTimeout(function(){
							self.resetForm();
						}, 3000);
					}
										
				}
			});
			
		};
	};

	var loanAccountModel = new LoanAccount();
	loanAccountModel.getServerData();// get data to be populated on the page
	ko.applyBindings(loanAccountModel, $("#loan_account_form")[0]);
	$("#loanAccountForm").validate({submitHandler: loanAccountModel.save});
    /*$(document).ready(function(){
	$("#loanAccountForm").steps({
				labels: {
					current: "current step:",
					pagination: "Pagination",
					finish: "Submit",
					next: "Next",
					cancel:"Reset",
					previous: "Previous",
					loading: "Loading ..."
				},
				enableCancelButton: true,
				onCanceled: function (event){
					loanAccountModel.resetForm();
				},
				transitionEffect: "slideLeft",
                bodyTag: "fieldset",
                onStepChanging: function (event, currentIndex, newIndex)
                {
                    // Always allow going backward even if the current step contains invalid fields!
                    if (currentIndex > newIndex)
                    {
                        return true;
                    }

                    // Forbid suppressing "Warning" step if the user is to young
                    if (newIndex === 3 && Number($("#age").val()) < 18)
                    {
                        return false;
                    }

                    var form = $(this);

                    // Clean up if user went backward before
                    if (currentIndex < newIndex)
                    {
                        // To remove error styles
                        $(".body:eq(" + newIndex + ") label.error", form).remove();
                        $(".body:eq(" + newIndex + ") .error", form).removeClass("error");
                    }

                    // Disable validation on fields that are disabled or hidden.
                    form.validate().settings.ignore = ":disabled,:hidden";

                    // Start validation; Prevent going forward if false
                    return form.valid();
                },
                onStepChanged: function (event, currentIndex, priorIndex)
                {
                    // Suppress (skip) "Warning" step if the user is old enough.
                    if (currentIndex === 2 && Number($("#age").val()) >= 18)
                    {
                        $(this).steps("next");
                    }

                    // Suppress (skip) "Warning" step if the user is old enough and wants to the previous step.
                    if (currentIndex === 2 && priorIndex === 3)
                    {
                        $(this).steps("previous");
                    }
                },
                onFinishing: function (event, currentIndex)
                {
                    var form = $(this);

                    // Disable validation on fields that are disabled.
                    // At this point it's recommended to do an overall check (mean ignoring only disabled fields)
                    form.validate().settings.ignore = ":disabled";

                    // Start validation; Prevent form submission if false
                    return form.valid();
                },
                onFinished: function (event, currentIndex)
                {
                    var form = $(this);

                    // Submit form input
                    form.submit();
                }
            }).validate({
						submitHandler: loanAccountModel.save,
                        errorPlacement: function (error, element)
                        {
                            element.before(error);
                        }
                    });
       });*/
	</script>