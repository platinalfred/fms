<script>
var dTable = new Object();
$(document).ready(function(){
	var handleDataTableButtons = function() {
		/*Loans report */
	  	if ($("#loan_product_report").length) {
			  dTable['tblLoanProductReport'] = $('#loan_product_report').DataTable({
			  dom: "lfrtipB",
			  "processing": true,
			  "ajax": {
				  "url":"ajax_requests/ajax_data.php",
				  "dataType": "JSON",
				  "type": "POST",
				  "data":  function(d){ d.origin = 'loan_product_report', d.start_date = startDate,d.end_date=endDate}
			  },
			  "footerCallback": function (tfoot, data, start, end, display ) {
				var api = this.api();
				//outstandingloan_amountprinciple
				var loan_amount = api.column(1).data().sum();
				var loan_interest = api.column(2).data().sum();
				var paid_amount = api.column(3).data().sum();
				var bal = (parseInt(loan_amount) + parseFloat(loan_interest)) - parseFloat(paid_amount); 
				$(api.column(1).footer()).html( curr_format(loan_amount) );
				$(api.column(2).footer()).html( curr_format(loan_interest) );
				$(api.column(3).footer()).html( curr_format(paid_amount) );
				$(api.column(4).footer()).html( curr_format(bal) );
				
				/* $(api.column(12).footer()).html( curr_format( Number(Math.round(parseFloat((outstanding_principle))+'e2')+'e-2') ) );
				//outstanding interest
				var outstanding_interest = api.column(6).data().sum() - api.column(11).data().sum();
				$(api.column(13).footer()).html( curr_format( Number(Math.round(parseFloat((outstanding_interest))+'e2')+'e-2') ) );
				//total outstanding loan amount
				$(api.column(14).footer()).html( curr_format( Number(Math.round(parseFloat((outstanding_principle + outstanding_interest))+'e2')+'e-2') ) ); */
			  },
			  "autoWidth": false,
			  columns:[
				  { data: 'productName'},
				  { data: 'loan_amount', render: function(data, type, full, meta) {return (data?curr_format(Number(Math.round(parseFloat(data)+'e2')+'e-2')):0);}},
				  { data: 'interest', render: function(data, type, full, meta) {return curr_format(parseInt(data));}},
				  { data: 'paidAmount', render: function(data, type, full, meta) {return data?curr_format(parseInt(data)):0;}},
				  { data: 'paidAmount', render: function(data, type, full, meta) {return data?curr_format((parseInt(full.loan_amount) + parseFloat(full.interest)) - parseInt(data)):0;}}
				] ,
			  buttons: [
				{
				  extend: "copy",
				  className: "btn-sm",
				  className: 'btn-sm'
				},
				{
				  extend: "csv",
				  className: "btn-sm",
				  className: 'btn-sm',
					title: 'BFS Loan Report '
				},
				{
				  extend: "excel",
				  className: "btn-sm",
				  className: 'btn-sm'
				},
				{    extend: "pdfHtml5",
				  className: "btn-sm",
                        title: 'BFS Loan Report',
                        message: 'Date: ',
                        orientation: 'landscape',
                        customize: function ( doc ) {
							$(window.document.body)
							.css( 'font-size', '10pt' );
                            $(window.document.body).find( 'table' )
							.addClass( 'compact' )
							.css( 'font-size', 'inherit' );
                        }
                    },
					{  extend: 'print',
						text: 'Print',
						className: 'btn-sm',
						title: 'BFS Loan Report ',
						orientation: 'landscape',
						customize: function ( doc ) {
							$(window.document.body)
							.css( 'font-size', '10pt' );
							$(window.document.body).find( 'table' )
							.addClass( 'compact' )
							.css( 'font-size', 'inherit' );
						}
					},
					{
					extend: 'colvis',	
					text: 'Choose fields to show <span class="caret"></span>',
					className: 'btn-sm',
					}
			  ],
			  responsive: false
			});
			//$("#datatable-buttons").DataTable();
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
});
 function handleDateRangePicker(start_date, end_date){
	 startDate = start_date;
	 endDate = end_date;
	dTable['tblLoanProductReport'].ajax.reload();
 }
</script>