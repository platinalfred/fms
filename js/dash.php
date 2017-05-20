<!-- Knockout js -->
<script src="js/knockout/knockout-min.js"></script>
<script src="js/moment/min/moment.min.js"></script>
<script src="js/plugins/daterangepicker/daterangepicker.js"></script>
<script type="text/javascript">
	<?php include_once("utils.inc");?> //utility functions
	var Dashboard = function() {
		var self = this;
		// Stores an array of all the Data for viewing in the Dashboard
		self.dashboardData = ko.observable({"figures":{"no_members":"0","no_members":"0"},"percents":{"members_percent":10},"tables":{"income":[],"expenses":[]}});
		self.startDate = ko.observable(moment().subtract(30, 'days').format('X'));
		self.endDate = ko.observable(moment().format('X'));
		
		// Operations
		self.updateData = function() {
			$.ajax({
				type: "post",
				dataType: "json",
				data:{start_date:self.startDate, end_date:self.endDate, origin:"dashboard"},
				url: "ajax_data.php",
				success: function(response){
					// Now use this data to update the view models, 
					// and Knockout will update the UI automatically 
					self.dashboardData(response);
					
					if(response.graph_data){
						draw_pie_chart(response.pie_chart_data);
						draw_line_chart(response.graph_data);
					}
					
				}
			})
		};
		self.updateData();
	};

	var dashModel = new Dashboard();
	ko.applyBindings(dashModel);
	
 $(document).ready(function() {
	//draw loans table
	function draw_loans_table(loans_data){
		var amount = balance = 0;
		var html_data = "<thead>"+
						"<tr><th>Loan No</th><th>Amount</th><!--th>Balance</th--></tr>"+
					"</thead>"+
					  "<tbody>";
		$.each(loans_data, function(key, value){
		html_data += "<tr>"+
						"<td><a href='member-details.php?member_id="+value.member_id+"&view=client_loan&lid="+value.id+"' title='View details'>"+value.loan_number+"</a></td>"+
						"<td>"+format1(parseInt(value.expected_payback))+"</td>"+
							"</tr>";
							amount += parseInt(value.expected_payback); 
						//balance += parseInt(value.balance);
		});
		html_data += "</tbody>"+
					"<tfoot>"+
						"<tr>"+
						  "<th scope='row'>Total</th>"+
						  "<th>"+format1(amount)+"</th>"+
						  //"<th>"+((balance<0)?"("+format1(balance * -1)+")":format1(balance))+"</th>"+
						"</tr>"+
					  "</tfoot>";
		return html_data;
	}
	<?php include_once("daterangepicker.inc");?> //daterangepicker function
 });
</script>