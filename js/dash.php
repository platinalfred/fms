<!-- Knockout js -->
<script src="js/knockout/knockout-min.js"></script>
<script src="js/moment/min/moment.min.js"></script>
<script src="js/plugins/daterangepicker/daterangepicker.js"></script>
<script type="text/javascript">
	<?php include_once("utils.inc");?> //utility functions
	var Dashboard = function() {
		var self = this;
		// Stores an array of all the Data for viewing in the Dashboard
		self.dashboardData = ko.observable({"figures":{"no_members":"0"},"percents":{"members_percent":10},"tables":{"income":[],"expenses":[]}});
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
				}
			})
		};
		self.updateData();
	};

	var dashModel = new Dashboard();
	ko.applyBindings(dashModel);
	
 $(document).ready(function() {
	function getDashboardData(startDate, endDate){
		$.ajax({
			type: "post",
			dataType: "json",
			data:{start_date:startDate, end_date:endDate, origin:"dashboard"},
			url: "ajax_data.php",
			success: function(response){
				// Now use this data to update the view models, 
				// and Knockout will update the UI automatically 
				dashboardData = response;
				/*draw_bar_chart(response.lineBarChart);
				draw_line_chart(response.lineBarChart);
				//draw the pie chart
				draw_pie_chart(response.pieChart);
				$.each(response.figures, function(key, value){
					$("#"+key).html(value);
				});
				//iterate over the percentages
				$.each(response.percents, function(key, value){
					var cur_ele = $("#"+key);
					if(parseFloat(value)>=0){
						$(cur_ele).removeClass("red fa-sort-desc").addClass("green fa-sort-asc").html(value+"%");
					}
					else{
						$(cur_ele).removeClass("green fa-sort-asc").addClass("red fa-sort-desc").html(value+"%");
					}
				});
				var elements = ["nploans","ploans","actvloans"];
				//draw the tables
				 $.each(elements, function(key, value){
					$("#"+value).html(draw_loans_table(response.tables[value]));
				});
				*/
			}
		});
	}
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
	//Bar chart
	function draw_bar_chart(url_data){
		$("#barChart").replaceWith('<canvas id="barChart"></canvas>');
		var ctx = $("#barChart").get(0).getContext("2d");
		var barChart = new Chart(ctx, {
			type: 'bar',
			data: {
				labels: url_data.data_points,
				datasets: [{
					label: 'Loans',
					backgroundColor: "#26B99A",
					data: url_data.loans_count
				}, {
					label: 'Shares',
					backgroundColor: "#03586A",
					data: url_data.shares_count
				}, {
					label: 'Subscriptions',
					backgroundColor: "#B9264A",
					data: url_data.subscriptions_count
				}]
			},
			options: {
				scales: {
					yAxes: [{
					  ticks: {
						beginAtZero: true
					  }
					}]
				}
			}
		});
	}
	// Line chart
	function draw_line_chart(url_data){
		$("#lineChart").replaceWith('<canvas id="lineChart"></canvas>');
		var ctx = $("#lineChart").get(0).getContext("2d");
		var lineChart = new Chart(ctx, {
			type: 'line',
			data: {
				labels: url_data.data_points,
				datasets: [{
					label: "Loans",
					backgroundColor: "rgba(38, 185, 154, 0.31)",
					borderColor: "rgba(38, 185, 154, 0.7)",
					pointBorderColor: "rgba(38, 185, 154, 0.7)",
					pointBackgroundColor: "rgba(38, 185, 154, 0.7)",
					pointHoverBackgroundColor: "#fff",
					pointHoverBorderColor: "rgba(220,220,220,1)",
					pointBorderWidth: 1,
					data: url_data.loans_sum
				}, {
					label: "Subscriptions",
					backgroundColor: "rgba(3, 88, 106, 0.3)",
					borderColor: "rgba(3, 88, 106, 0.70)",
					pointBorderColor: "rgba(3, 88, 106, 0.70)",
					pointBackgroundColor: "rgba(3, 88, 106, 0.70)",
					pointHoverBackgroundColor: "#fff",
					pointHoverBorderColor: "rgba(151,187,205,1)",
					pointBorderWidth: 1,
					data: url_data.subscriptions_sum
				}]
			},
		});
	}
	// Pie chart
	function draw_pie_chart(url_data){
		$("#pieChart").replaceWith('<canvas id="pieChart"></canvas>');
		var ctx = $("#pieChart").get(0).getContext("2d");
		var data = {
			datasets: [{
			  data: url_data,
			  backgroundColor: [
				"#356AA0",
				"#B54C4C"
			  ],
			  label: 'Loans' // for legend
			}],
			labels: [
			  "Perf. Loans",
			  "NP Loans"
			]
		};
		
		var pieChart = new Chart(ctx, {
			data: data,
			type: 'pie',
			otpions: {
			  legend: false
			}
		});
	}
	<?php include_once("daterangepicker.inc");?> //daterangepicker function
 });
</script>