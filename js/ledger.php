<script type="text/javascript">

	var ViewModel = function() {
		var self = this;
		
		self.ledger_data = ko.observable();
		
		//Retrieve page data from the server
		self.getLedgerData = function() {
			$.ajax({
				type: "post",
				dataType: "json",
				data:{origin:"ledger"<?php if(isset($_GET['id'])):?>, id:<?php echo $_GET['id'];?>, clientType:<?php echo $client['clientType'];?> <?php endif;?>},
				url: "ajax_data.php",
				success: function(response){
					self.ledger_data(response);
				}
			})
		};		
	};

	var viewModel = new ViewModel();
	viewModel.getLedgerData();// get data to be populated on the page
	ko.applyBindings(viewModel, $("#ledger")[0]);
	
</script>