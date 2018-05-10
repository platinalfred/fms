<script type="text/javascript">

	var ViewModel = function() {
		var self = this;
		
		self.ledger_data = ko.observable();
		self.startDate = ko.observable(startDate);
		self.endDate = ko.observable(endDate);
		
		//Retrieve page data from the server
		self.getLedgerData = function() {
			$.ajax({
				type: "post",
				dataType: "json",
				data:{start_date:self.startDate, end_date:self.endDate, origin:"ledger"<?php if(isset($_GET['memberId'])):?>, id:<?php echo $_GET['memberId'];?>, clientType:<?php echo $client['clientType'];?> <?php endif;?>},
				url: "ajax_requests/ajax_data.php",
				success: function(response){
					self.ledger_data(response);
				}
			})
		};		
	};

	var viewModel = new ViewModel();
	viewModel.getLedgerData();// get data to be populated on the page
	ko.applyBindings(viewModel, $("#ledger_data")[0]);
	
	function handleDateRangePicker(start_date, end_date){
			viewModel.startDate(start_date);
			viewModel.endDate(end_date);
			viewModel.getLedgerData();
	}
	
</script>