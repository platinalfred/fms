<!-- Datatables -->
<script type="text/javascript">
var dTable = new Object();
var GroupLoanAccountModel = function() {
	var self = this;
	self.memberAccounts = ko.observableArray();
	self.group_loan_account_details = ko.observable();
}
groupLoanAccountModel = new GroupLoanAccountModel();
ko.applyBindings(groupLoanAccountModel, $("#loan_account_details")[0]); //apply the knockout bindings

$(document).ready(function() {
	var handleDataTableButtons = function() {
	  if ($("#groupLoans").length) {
		dTable = $('#groupLoans').DataTable({
		  dom: "Bfrtip",
		  "order": [ [1, 'asc' ]],
		  "ajax": {
			  "url":"ajax_requests/ajax_data.php",
			  "type": "POST",
			  "data":  function(d){
					d.origin = 'group_loan_accounts';
					d.groupId=<?php echo $_GET['groupId'];?>;
					d.start_date = startDate;
					d.end_date = endDate;
				}
		  },
		   "initComplete": function(settings, json) {
				$(".table tbody>tr:first").trigger('click');
		  },
		  "footerCallback": function (tfoot, data, start, end, display ) {
            var api = this.api();
			var total = api.column(4).data().sum();
			$(api.column(4).footer()).html( curr_format(total) );
		  },columns:[ { data: 'id', render: function ( data, type, full, meta ) {
			  return '<a href="group_details.php?groupId='+full.saccoGroupId+'&view=loan_accs&grpLId='+data+'" title="View loan accounts">Ref#'+data+'</a>';}},
				{ data: 'appnDate',  render: function ( data, type, full, meta ) {return moment(data, 'X').format('DD-MMM-YYYY');}},
				{ data: 'productName'},
				{ data: 'maxAmount', render: function ( data, type, full, meta ) {return curr_format(parseInt(data?data:0));}},
				{ data: 'loanAmount', render: function ( data, type, full, meta ) {return curr_format(parseInt(data?data:0));}},
				{ data: 'noMembers', render: function ( data, type, full, meta ) {return '<a href="group_details.php?groupId='+full.saccoGroupId+'&view=loan_accs&grpLId='+full.id+'" title="View loan accounts">'+curr_format(parseInt(data?data:0))+'</a>';}},
				{ data: 'noMembers', render: function ( data, type, full, meta ) {
					return ((parseInt(data)>0)?'<a href="#edit_loan_account-modal" class="btn  btn-info btn-sm edit_loan" data-toggle="modal"><i class="fa fa-edit"></i> Update</a>':'');}}
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
		groupLoanAccountModel.group_loan_account_details(data);
		//ajax to retrieve all member loan accounts in this group loan arrangement
		if(data){
			getMemberAccounts(data.id);
		}
	});
});
 function getMemberAccounts(groupLoanAccountId){
	 $.ajax({
		url: "ajax_requests/fajax_data.php",
		data: {grpLId:groupLoanAccountId, origin:'loan_accounts'},
		type: 'POST',
		dataType: 'json',
		success: function (response) {
			if(response && response.data){
				groupLoanAccountModel.memberAccounts(response.data);
			}			
		}
	});
 }
 
	function handleDateRangePicker(start_date, end_date){
			/* groupLoanAccountModel.startDate(start_date);
			groupLoanAccountModel.endDate(end_date); */
			dTable.ajax.reload(null, true);
	 }
	</script>