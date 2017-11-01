<script>
var dTable = new Object();
var client_type = 3, category = 0;
$(document).ready(function(){
	var handleDataTableButtons = function() {
		/*Loans report */
	  	if ($("#loan_report").length) {
			  dTable['tblLoanReport'] = $('#loan_report').DataTable({
			  dom: "lfrtipB",
			  "processing": true,
			  "ajax": {
				  "url":"ajax_data.php",
				  "dataType": "JSON",
				  "type": "POST",
				  "data":  function(d){ d.origin = 'loan_report', d.start_date = startDate,d.end_date=endDate,d.client_type = client_type,d.category = category}
			  },"columnDefs": [ {
				  "targets": [16],
				  "orderable": false,
				  "visible": false,
				  "searchable": false
			  }],
			  "footerCallback": function (tfoot, data, start, end, display ) {
				  //
				var api = this.api(), cols = [3,4,7,10,11,13];
				$.each(cols, function(key, val){
					var total = api.column(val).data().sum();
					$(api.column(val).footer()).html( curr_format(Number(Math.round(parseFloat(total)+'e2')+'e-2')) );
				});
				//outstanding principle
				var outstanding_principle = api.column(3).data().sum() - api.column(10).data().sum();
				$(api.column(12).footer()).html( curr_format( Number(Math.round(parseFloat((outstanding_principle))+'e2')+'e-2') ) );
				//outstanding interest
				var outstanding_interest = api.column(6).data().sum() - api.column(11).data().sum();
				$(api.column(13).footer()).html( curr_format( Number(Math.round(parseFloat((outstanding_interest))+'e2')+'e-2') ) );
				//total outstanding loan amount
				$(api.column(14).footer()).html( curr_format( Number(Math.round(parseFloat((outstanding_principle + outstanding_interest))+'e2')+'e-2') ) );
				//total miscellaneous income//
				
				var paid_amount = (api.column(16).data().sum());
				
				var loan_amount = (api.column(3).data().sum())+(api.column(6).data().sum());
				
				var misc_income = (paid_amount>loan_amount)?curr_format( Number(Math.round(parseFloat((paid_amount-loan_amount))+'e2')+'e-2') ):0;
				$(api.column(15).footer()).html( misc_income );
			  },
			  "autoWidth": false,
			  columns:[
				  { data: 'loanNo', render: function ( data, type, full, meta ) {
					  var page = "";
					  if(full.clientType==1){
						  page = "member_details.php?id=";
					  }
					  if(full.clientType==2){
						  page = "group_details.php?id=";
					  }
					  return '<?php if(isset($_SESSION['loan_officer'])){ ?> '+data+' <?php }else{ ?> <a href="'+page+full.clientId+'&view=loan_accs&loanId='+full.id+'" title="View details"> L' +full.id+ '</a> <?php } ?>'; }},
				  { data: 'clientNames'},
				  { data: 'disbursementDate', render: function(data, type, full, meta) {return moment(data,'X').format('DD-MMM-YYYY');} },
				  { data: 'disbursedAmount', render: function(data, type, full, meta) {return (data?curr_format(Number(Math.round(parseFloat(data)+'e2')+'e-2')):0);}},
				  { data: 'principle', render: function(data, type, full, meta) {return (data?curr_format(Number(Math.round(parseFloat(data)+'e2')+'e-2')):0);}},

				  { data: 'interest', render: function(data, type, full, meta) {return curr_format(parseInt(data));}},
				  { data: 'expInterest', render: function(data, type, full, meta) {return curr_format(parseInt(data));}},
				  { data: 'feesPaid', render: function(data, type, full, meta) {return data?curr_format(parseInt(data)):0;}},
				  { data: 'paidInstallments', render: function(data, type, full, meta) {return data?curr_format(parseInt(data)):0;}},
				  { data: 'balInstallments'},
				  { data: 'paidPrinciple', render: function(data, type, full, meta) {return (data?curr_format(Number(Math.round(parseFloat(data)+'e2')+'e-2')):0);}},
				  { data: 'interestPaid', render: function(data, type, full, meta) {return (data?curr_format(Number(Math.round(parseFloat(data)+'e2')+'e-2')):0);}},
				  { data: 'paidPrinciple', render: function ( data, type, full, meta ) {return data?curr_format(parseInt(full.disbursedAmount)-parseInt(data)):0;}},
				  { data: 'interestPaid', render: function ( data, type, full, meta ) {
					   return data?curr_format(parseInt(full.expInterest)-(data?parseInt(data):0)):0;}},
				  { data: 'paidPrinciple', render: function ( data, type, full, meta ) {return data?curr_format((parseInt(full.disbursedAmount)-parseInt(data))+(parseInt(full.expInterest)-(full.interestPaid?parseInt(full.interestPaid):0))):0;}},
				  { data: 'amountPaid', render: function(data, type, full, meta) {
						var paid_amount = (data?parseInt(data):0);
						var loan_amount = (full.disbursedAmount?parseInt(full.disbursedAmount):0)+(full.expInterest?parseInt(full.expInterest):0);
						return (paid_amount>loan_amount)?curr_format((paid_amount-loan_amount)):0;
					  }
				  },
				  { data: 'amountPaid'}
					
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
	$('#loan_category').change(function(){handleDateRangePicker(startDate,endDate);});
	$('#client_type').change(function(){handleDateRangePicker(startDate,endDate);});
});
 function handleDateRangePicker(start_date, end_date){
	 startDate = start_date;
	 endDate = end_date;
	client_type = parseInt($('#client_type').val());
	category = parseInt($('#loan_category').val());
	dTable['tblLoanReport'].ajax.reload();
 }
</script>