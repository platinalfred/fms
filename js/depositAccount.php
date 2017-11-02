<!-- Datatables -->
<script>
var dTable = new Object();
$(document).ready(function() {
	var handleDataTableButtons = function() {
	  if ($("#datatable-buttons").length) {
		dTable = $('#datatable-buttons').DataTable({
		  dom: "Bfrtip",
		  "order": [ [1, 'asc' ]],
		  "processing": true,
		  "serverSide": true,
		  "deferRender": true,
		  "ajax": {
			  "url":"server_processing.php",
			  "type": "POST",
			  "data":  function(d){
					d.page = 'deposit_accounts';
					<?php if(isset($client)):?> d.clientId=<?php echo isset($client['id'])?$client['id']:"undefined";?>; <?php endif;?>
					d.clientType = <?php echo isset($client['clientType'])?"'{$client['clientType']}'":0; ?>; //specify the type of the client (group/member) here;
					d.start_date = startDate;
					d.end_date = endDate;
				}
		  },
		   "initComplete": function(settings, json) {
				$(".table tbody>tr:first").trigger('click');
		  },
		  "footerCallback": function (tfoot, data, start, end, display ) {
            var api = this.api(), cols = [4,5];
			$.each(cols, function(key, val){
				var total = api.column(val).data().sum();
				$(api.column(val).footer()).html( curr_format(total) );
			});
		  },columns:[ { data: 'id', render: function ( data, type, full, meta ) {
			  var page = "";
			  if(full.clientType==1){
				  page = "member_details.php?memberId=";
			  }
			  if(full.clientType==2){
				  page = "group_details.php?groupId=";
			  }
			  return '<a href="'+page+full.clientId+'&view=savings_accs&depAcId='+data+'" title="View details">BFS'+data+'</a>';}},
				{ data: 'clientNames'},
				{ data: 'productName'},
				{ data: 'dateCreated',  render: function ( data, type, full, meta ) {return moment(data, 'X').format('DD-MMM-YYYY');}},
				{ data: 'sumDeposited', render: function ( data, type, full, meta ) {return curr_format(parseInt(data?data:0));}},
				{ data: 'sumWithdrawn', render: function ( data, type, full, meta ) {return curr_format(parseInt(data?data:0));}}
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
	$('.table tbody').on('click', 'tr ', function () {
		var data = dTable.row(this).data();
		depositAccountModel.account_details(data);
		//ajax to retrieve transactions history
		if(data){
			getTransactionHistory(data.id);
		}
	});
});
 function getTransactionHistory(depositAccountId){
	 $.ajax({
		url: "ajax_data.php",
		data: {id:depositAccountId, origin:'member_savings', start_date:startDate, end_date:endDate},
		type: 'POST',
		dataType: 'json',
		success: function (response) {
			depositAccountModel.transactionHistory(response);			
		}
	});
 }
</script>
<script type="text/javascript">
	
	var DepositAccount = function() {
		var self = this;
		
		//these are required as the datatable is being loaded
		self.transactionHistory = ko.observableArray(); //for a deposit account transacation history display
		self.account_details = ko.observable();
		
		//then these for the deposit entry form
		self.deposit_amount = ko.observable(0);
		self.comments = ko.observable("");
		
		//then these are for the main page
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
		self.openingBal = ko.observable(self.depositProduct()?self.depositProduct().defaultOpeningBal:0);
		self.termLength = ko.observable(self.depositProduct()?self.depositProduct().defaultTermLength:0);
		self.interestRate = ko.observable(self.depositProduct()?self.depositProduct().defaultInterestRate:0);
		self.startDate = ko.observable(startDate);
		self.endDate = ko.observable(endDate);
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
			self.depositProduct(null);
			self.openingBal(0);
			self.termLength(0);
			self.interestRate(0);
			endDate = moment().format('X'); //get the current time
			handleDateRangePicker(startDate, endDate);
		};
		
		//Retrieve page data from the server
		self.getServerData = function() {
			$.ajax({
				type: "post",
				dataType: "json",
				data:{origin:"deposit_account"<?php if(isset($_GET['depAcId'])):?>, depositAccountId:<?php echo $_GET['depAcId'];?>, start_date:self.startDate, end_date:self.endDate <?php endif;?>},
				url: "ajax_data.php",
				success: function(response){
					self.depositProducts(response.products);
					self.productFees(response.productFees);
					<?php if(!isset($client)):?>self.customers(response.customers); <?php endif;?>
					<?php if(isset($_GET['depAcId'])){
						$clientId = isset($client['memberId'])?$client['memberId']:(isset($client['groupId'])?$client['groupId']:"");
						$client['clientId'] = $clientId;
						unset($client['id'],$clientId);?>
						var client_data = <?php echo json_encode($client);?>;
						self.account_details($.extend(client_data, response.account_details));
					<?php } ?>
				}
			})
		};
		
		self.addDeposit = function(){
			$.ajax({
				type: "post",
				dataType: "json",
				data:{
					origin:"add_deposit",
					depositAccountId:(self.account_details()?self.account_details().id:undefined),
					amount: self.deposit_amount(),
					comment: self.comments()
				},
				url: "lib/AddData.php",
				success: function(response){
					var result = parseInt(response)||0;
					if(result){
						showStatusMessage("Data successfully saved" ,"success");
						setTimeout(function(){
							$("#enterDepositForm")[0].reset();
							self.deposit_amount(0);
							//If you are in the account details page
							<?php if(isset($_GET['depAcId'])): ?>
								self.getServerData();
								dTable.ajax.reload();
							<?php else: ?>
								//If you are on all accounts page
								getTransactionHistory(self.account_details().id);
								dTable.ajax.reload(function(){
									//Reload the current selected account
									self.account_details(dTable.row("#dep_"+self.account_details().id).data());
								}, false);
							<?php endif; ?>
							
						}, 3000);
					}else{
						showStatusMessage("Error encountered while saving data: \n"+response ,"failed");
					}
				}
			});
		};
		
		self.addWithdraw = function(){
			$.ajax({
				type: "post",
				dataType: "json",
				data:{
					origin:"add_withdraw",
					depositAccountId:(self.account_details()?self.account_details().id:undefined),
					amount: self.deposit_amount(),
					comment: self.comments()
				},
				url: "lib/AddData.php",
				success: function(response){
					var result = parseInt(response)||0;
					if(result){/*  */
						showStatusMessage("Data successfully saved" ,"success");
						setTimeout(function(){
							$("#enterWithdrawForm")[0].reset();
							self.deposit_amount(0);
							<?php if(isset($_GET['depAcId'])): ?>
								self.getServerData();
								dTable.ajax.reload();
							<?php else: ?>
								getTransactionHistory(self.account_details().id);
								dTable.ajax.reload(
									function(){
									self.account_details(dTable.row("#dep_"+self.account_details().id).data());
								}, false);
							<?php endif; ?>
								//After reloading the data table there is need to 
								
						}, 4000);
					}else{
						showStatusMessage("Error encountered while saving data: \n"+response ,"failed");
					}
				}
			});
		};
		
		//send the items to the server for saving
		self.save = function(form) {			
			$.ajax({
				type: "post",
				data:{
					depositProductId : (self.depositProduct()?self.depositProduct().id:undefined),
					clientId : (self.client()?self.client().id:undefined),
					clientType : (self.client()?self.client().clientType:undefined),
					recomDepositAmount : (self.depositProduct()?self.depositProduct().recommededDepositAmount:undefined),
					maxWithdrawalAmount : (self.depositProduct()?self.depositProduct().maxWithdrawalAmount:undefined),
					openingBalance : self.openingBal(),
					termLength : self.termLength(),
					interestRate : self.interestRate(),
					feePostData:self.productFees(),
					origin : "deposit_account"
				},
				//dataType:'json',
				url: "lib/AddData.php",
				success: function(response){
					var result = parseInt(response)||0;
					if(result>0){
						showStatusMessage("Data successfully saved" ,"success");
						setTimeout(function(){
							self.resetForm();
						}, 3000);
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

	var depositAccountModel = new DepositAccount();
	depositAccountModel.getServerData();// get data to be populated on the page
	ko.applyBindings(depositAccountModel, $("#deposit_account_details")[0]);
	$("#enterDepositForm").validate({ submitHandler: depositAccountModel.addDeposit });
	$("#enterWithdrawForm").validate({ submitHandler: depositAccountModel.addWithdraw });
	$("#depAccountForm").validate({ submitHandler: depositAccountModel.save });//, $("#deposit_account_form")[0]
	
	
	function handleDateRangePicker(start_date, end_date){
			depositAccountModel.startDate(start_date);
			depositAccountModel.endDate(end_date);
			depositAccountModel.getServerData();
			dTable.ajax.reload(null, true);
	 }
	</script>