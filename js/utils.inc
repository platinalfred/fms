//format numbers to currency format
function curr_format(n) {
	return n.toString().replace(/./g, function(c, i, a) {
		return i > 0 && c !== "." && (a.length - i) % 3 === 0 ? "," + c : c;
	});
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