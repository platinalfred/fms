<script>//format numbers with thousands separator
function curr_format(n) {
	var formatted = "";
	if(n<0){
		n = n*-1;
		formatted = n.toString().replace(/./g, function(c, i, a) {
			return i > 0 && c !== "." && (a.length - i) % 3 === 0 ? "," + c : c;
		});
		formatted = "("+formatted + ")";
	}else{
		formatted = n.toString().replace(/./g, function(c, i, a) {
			return i > 0 && c !== "." && (a.length - i) % 3 === 0 ? "," + c : c;
		})
	}
	return formatted;
}
//sum up values in an array
function array_total(arr, idx) {
	var total = 0.0;
	$.each(arr, function(key, value){
		total += parseFloat(value[idx]);
	});
	return total;
}
//Bar chart
function draw_bar_chart(url_data){
	$("#barChart").replaceWith('<canvas id="barChart"></canvas>');
	var ctx = $("#barChart").get(0).getContext("2d");
	
	var barChart = new Chart(ctx, {
		type: 'bar',
		data: {
			labels: url_data.labels,
			datasets: url_data.datasets
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

	var lineOptions = {
		scaleShowGridLines: true,
		scaleGridLineColor: "rgba(0,0,0,.05)",
		scaleGridLineWidth: 1,
		bezierCurve: true,
		bezierCurveTension: 0.4,
		pointDot: true,
		pointDotRadius: 4,
		pointDotStrokeWidth: 1,
		pointHitDetectionRadius: 20,
		datasetStroke: true,
		datasetStrokeWidth: 2,
		datasetFill: true,
		responsive: true,
	};
	var lineChart = new Chart(ctx, {
		type: 'line',
		data: url_data,
		options: lineOptions
	});
	/* //var ctx = document.getElementById("lineChart").getContext("2d"); 
	
	var myNewChart = new Chart(ctx).Line(url_data, lineOptions);*/
}
// Pie chart
function draw_pie_chart(url_data){
	$("#pieChart").replaceWith('<canvas id="pieChart"></canvas>');
	var ctx = $("#pieChart").get(0).getContext("2d");
	
	var pieChart = new Chart(ctx, {
		type: 'pie',
		data: url_data,
    options: {
        responsive: true
    }
	});
}

/* Save function called when various buttons with .save are clicked */
function saveData(){
	$(".save").click(function(){
		var fmid = $(this).closest("form");
		var frmdata = fmid.serialize();
		var tbl_id = fmid.attr("id");
		$.ajax({
			url: "save_data.php",
			type: 'POST',
			data: frmdata,
			success: function (response) {
				if($.trim(response) == "success"){
					fmid[0].reset();
					showStatusMessage("Successfully added new record" ,"success");
					setTimeout(function(){
						var dt = dTable[tbl_id];
						dt.ajax.reload();
					}, 2000);
				}else{//"Action not successful"
					showStatusMessage(response, "failed");
				}
				
			}
		});

		return false;
	});
}
	
// Displays an alert message
function showStatusMessage(message='', display_type='success'){
	new PNotify({
		  title: "Alert",
		  text: message,
		  type: display_type,
		  styling: 'bootstrap3',
		  sound: true,
		  hide:true,
		  buttons: {
			closer_hover: false,
		},
		confirm: {
			confirm: true,
			buttons: [{
				text: 'Ok',
				addClass: 'btn-primary',
				click: function(notice) {
					notice.remove();
				}
			},
			null]
		},
		animate: {
			animate: true,
			in_class: 'zoomInLeft',
			out_class: 'zoomOutRight'
		},
		  nonblock: {
			  nonblock: true
		  }
		  
	  });
	
}
/*$(function () {
  $('[data-toggle="tooltip"]').tooltip()
})*/
</script>