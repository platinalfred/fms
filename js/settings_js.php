<script>
    var dTable = {};
    $(document).ready(function () {
<?php include("depositProduct.php"); ?>
<?php include("loanProduct.php"); ?>
        /* Delete whenever a Delete Button has been clicked */
        $('.table tbody').on('click', 'tr .delete_me', function () {
            var confirmation = confirm("Are you sure you would like to delete this item?");
            if (confirmation) {
                var tbl;
                var id;
                var d_id = $(this).attr("id")
                var arr = d_id.split("-");
                id = arr[0];//This is the row id
                tbl = arr[1]; //This is the table to delete from 
                var dttbl = arr[2];//Table to reload
                $.ajax({// create an AJAX call...
                    url: "ajax_requests/delete.php?id=" + id + "&tbl=" + tbl, // the file to call
                    success: function (response) { // on success..
                        showStatusMessage(response, "success");
                        setTimeout(function () {
                            var dt = dTable[dttbl];
                            dt.ajax.reload();
                        }, 300);
                    }
                });
            }
        });
        /* ====  END COMMON FUNCTIONS ==== */
        var handleDataTableButtons = function () {
            var btns_setup = [
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
                        }
                    ];
            /* -- Person Type Data Table --- */
            if ($("#tblExpenseType").length) {
                dTable['tblExpenseType'] = $('#tblExpenseType').DataTable({
                    dom: "lfrtipB",
                    "processing": true,
                    /*"serverSide": true,
                     "deferRender": true,
                     "order": [[ 1, 'asc' ]],*/
                    "ajax": {
                        "url": "ajax_requests/settings_data.php",
                        "dataType": "JSON",
                        "type": "POST",
                        "data": function (d) {
                            d.tbl = 'tblExpenseType';
                            //d.start_date = getStartDate();
                            //d.end_date = getEndDate();
                        }
                    }, "columnDefs": [{
                            "targets": [2],
                            "orderable": false,
                            "searchable": false
                        }/* , {
                         "targets": [0],
                         "orderable": false
                         } */],
                    "autoWidth": false,
                    columns: [{data: 'name'},
                        {data: 'description'}, //, render: function ( data, type, full, meta ) {return full.firstname + ' ' + full.othername + ' ' + full.lastname;}
                        //{ data: 'date_added', render: function ( data, type, full, meta ) {return moment(data).format('LL');}},

                        {data: 'id', render: function (data, type, full, meta) {
                                return '<a data-toggle="modal" href="#add_expense_type-modal"  id="' + data + '-ExpenseType" data-toggle="modal" class="btn btn-white btn-sm edit_me"><i class="fa fa-pencil"></i> Edit </a><span id="' + data + '-ExpenseType-del" class="btn btn-danger btn-sm delete_me"><i class="fa fa-trash-o"></i> Deleted</span>';
                            }}

                    ],
                    buttons: btns_setup,
                    responsive: true,
                });
                //$("#datatable-buttons").DataTable();
            }
            /*-- End Expense Type--*/
            /* -- Person Type Data Table --- */
            if ($("#tblPersonType").length) {
                dTable['tblPersonType'] = $('#tblPersonType').DataTable({
                    dom: "lfrtipB",
                    "processing": true,
                    /*"serverSide": true,
                     "deferRender": true,
                     "order": [[ 1, 'asc' ]],*/
                    "ajax": {
                        "url": "ajax_requests/settings_data.php",
                        "dataType": "JSON",
                        "type": "POST",
                        "data": function (d) {
                            d.tbl = 'tblPersonType';
                            //d.start_date = getStartDate();
                            //d.end_date = getEndDate();
                        }
                    }, "columnDefs": [{
                            "targets": [2],
                            "orderable": false,
                            "searchable": false
                        }/* , {
                         "targets": [0],
                         "orderable": false
                         } */],
                    "autoWidth": false,
                    columns: [{data: 'name'},
                        {data: 'description'}, //, render: function ( data, type, full, meta ) {return full.firstname + ' ' + full.othername + ' ' + full.lastname;}
                        //{ data: 'date_added', render: function ( data, type, full, meta ) {return moment(data).format('LL');}},

                        {data: 'id', render: function (data, type, full, meta) {
                                return '<a id="' + data + '-PersonType" data-toggle="modal" href="#add_person_type-modal" class="btn btn-white btn-sm edit_me"><i class="fa fa-pencil"></i> Edit </a><span id="' + data + '-PersonType-del" class="btn btn-danger btn-sm delete_me"><i class="fa fa-trash-o"></i> Deleted</span>';
                            }}

                    ],
                    buttons: btns_setup,
                    responsive: true,
                });
                //$("#datatable-buttons").DataTable();
            }
            /*-- End Person Type--*/
            /*-- --*/
            if ($("#tblAccountType").length) {
                dTable['tblAccountType'] = $('#tblAccountType').DataTable({
                    dom: "lfrtipB",
                    "processing": true,
                    /*"serverSide": true,
                     "deferRender": true,
                     "order": [[ 1, 'asc' ]],*/
                    "ajax": {
                        "url": "ajax_requests/settings_data.php",
                        "dataType": "JSON",
                        "type": "POST",
                        "data": function (d) {
                            d.tbl = 'tblAccountType';
                            //d.start_date = getStartDate();
                            //d.end_date = getEndDate();
                        }
                    }, "columnDefs": [{
                            "targets": [2],
                            "orderable": false,
                            "searchable": false
                        }/* , {
                         "targets": [0],
                         "orderable": false
                         } */],
                    "autoWidth": false,
                    columns: [{data: 'title'},
                        {data: 'minimum_balance'},
                        {data: 'description'},

                        {data: 'id', render: function (data, type, full, meta) {
                                return '<a  id="' + data + '-AccountType" data-toggle="modal" href="#add_account_type-modal" class="btn btn-white btn-sm edit_me"><i class="fa fa-pencil"></i> Edit </a><span id="' + data + '-AccountType-del" class="btn btn-danger btn-sm delete_me"><i class="fa fa-trash-o"></i> Deleted</span>';
                            }}

                    ],
                    buttons: btns_setup,
                    responsive: true,
                });
                //$("#datatable-buttons").DataTable();
            }
            /*End --Account Type */
            /*Branches */
            if ($("#tblBranch").length) {
                dTable['tblBranch'] = $('#tblBranch').DataTable({
                    dom: "lfrtipB",
                    "processing": true,
                    /*"serverSide": true,
                     "deferRender": true,
                     "order": [[ 1, 'asc' ]],*/
                    "ajax": {
                        "url": "ajax_requests/settings_data.php",
                        "dataType": "JSON",
                        "type": "POST",
                        "data": function (d) {
                            d.tbl = 'tblBranch';
                            //d.start_date = getStartDate();
                            //d.end_date = getEndDate();
                        }
                    }, "columnDefs": [{
                            "targets": [2],
                            "orderable": false,
                            "searchable": false
                        }/* , {
                         "targets": [0],
                         "orderable": false
                         } */],
                    "autoWidth": false,
                    columns: [{data: 'branch_name'},
                        {data: 'office_phone'},
                        {data: 'email_address'},
                        {data: 'physical_address'},
                        {data: 'postal_address'},
                        {data: 'id', render: function (data, type, full, meta) {
                                return '<a id="' + data + '-Branch" data-toggle="modal" href="#add_branch-modal" class="btn btn-white btn-sm edit_me"><i class="fa fa-pencil"></i> Edit </a><span id="' + data + '-Branch-del" class="btn btn-danger btn-sm delete_me"><i class="fa fa-trash-o"></i> Deleted</span>';
                            }}

                    ],
                    buttons: btns_setup,
                    responsive: true,
                });
                //$("#datatable-buttons").DataTable();
            }
            /*End Branches- --*/
            /*ACCESS LEVEL */
            if ($("#tblAccessLevel").length) {
                dTable['tblAccessLevel'] = $('#tblAccessLevel').DataTable({
                    dom: "lfrtipB",
                    "processing": true,
                    "ajax": {
                        "url": "ajax_requests/settings_data.php",
                        "dataType": "JSON",
                        "type": "POST",
                        "data": function (d) {
                            d.tbl = 'tblAccessLevel';
                            //d.start_date = getStartDate();
                            //d.end_date = getEndDate();
                        }
                    }, "columnDefs": [{
                            "targets": [2],
                            "orderable": false,
                            "searchable": false
                        }/* , {
                         "targets": [0],
                         "orderable": false
                         } */],
                    "autoWidth": false,
                    columns: [{data: 'name'},
                        {data: 'description'},
                        {data: 'id', render: function (data, type, full, meta) {
                                return '<a data-toggle="modal" href="#add_access_level-modal" id="'+data+'-AccessLevel" class="btn btn-white btn-sm edit_me"><i class="fa fa-pencil"></i> Edit </a>';}}//<span id="'+data+'-access_level-tblbranch" class="btn btn-danger btn-sm delete_me"><i class="fa fa-trash-o"></i> Deleted</span>

                    ],
                    buttons: btns_setup,
                    responsive: true,
                });
                //$("#datatable-buttons").DataTable();
            }
            /*End Access Level- --*/
            /*INCOME SOURCES  */
            if ($("#tblIncomeSource").length) {
                dTable['tblIncomeSource'] = $('#tblIncomeSource').DataTable({
                    dom: "lfrtipB",
                    "processing": true,
                    "ajax": {
                        "url": "ajax_requests/settings_data.php",
                        "dataType": "JSON",
                        "type": "POST",
                        "data": function (d) {
                            d.tbl = 'tblIncomeSource';
                            //d.start_date = getStartDate();
                            //d.end_date = getEndDate();
                        }
                    }, "columnDefs": [{
                            "targets": [2],
                            "orderable": false,
                            "searchable": false
                        }/* , {
                         "targets": [0],
                         "orderable": false
                         } */],
                    "autoWidth": false,
                    columns: [{data: 'name'},
                        {data: 'description'},
                        {data: 'id', render: function (data, type, full, meta) {
                                return '<a data-toggle="modal" href="#add_income_source-modal" id="' + data + '-IncomeSource" class="btn btn-white btn-sm edit_me"><i class="fa fa-pencil"></i> Edit </a><span id="' + data + '-IncomeSource-del"   class="btn btn-danger btn-sm delete_me"><i class="fa fa-trash-o"></i> Deleted</span>';
                            }}

                    ],
                    buttons: btns_setup,
                    responsive: true,
                });
                //$("#datatable-buttons").DataTable();
            }
            /*END INCOME SOURCES - --*/
            /*individual types  */
            if ($("#tblIndividualType").length) {
                dTable['tblIndividualType'] = $('#tblIndividualType').DataTable({
                    dom: "lfrtipB",
                    "processing": true,
                    "ajax": {
                        "url": "ajax_requests/settings_data.php",
                        "dataType": "JSON",
                        "type": "POST",
                        "data": function (d) {
                            d.tbl = 'tblIndividualType';
                            //d.start_date = getStartDate();
                            //d.end_date = getEndDate();
                        }
                    }, "columnDefs": [{
                            "targets": [2],
                            "orderable": false,
                            "searchable": false
                        }/* , {
                         "targets": [0],
                         "orderable": false
                         } */],
                    "autoWidth": false,
                    columns: [{data: 'name'},
                        {data: 'description'},
                        {data: 'id', render: function (data, type, full, meta) {
                                return '<a data-toggle="modal" id="' + data + '-IndividualType" href="#add_individual_type-modal" class="btn btn-white btn-sm edit_me"><i class="fa fa-pencil"></i> Edit </a><span id="' + data + '-IndividualType-del" class="btn btn-danger btn-sm delete_me"><i class="fa fa-trash-o"></i> Deleted</span>';
                            }}

                    ],
                    buttons: btns_setup,
                    responsive: true,
                });
                //$("#datatable-buttons").DataTable();
            }
            /*END individual_types - --*/
            /*LOAN types  */
            if ($("#tblLoanType").length) {
                dTable['tblLoanType'] = $('#tblLoanType').DataTable({
                    dom: "lfrtipB",
                    "processing": true,
                    "ajax": {
                        "url": "ajax_requests/settings_data.php",
                        "dataType": "JSON",
                        "type": "POST",
                        "data": function (d) {
                            d.tbl = 'tblLoanType';
                            //d.start_date = getStartDate();
                            //d.end_date = getEndDate();
                        }
                    }, "columnDefs": [{
                            "targets": [2],
                            "orderable": false,
                            "searchable": false
                        }/* , {
                         "targets": [0],
                         "orderable": false
                         } */],
                    "autoWidth": false,
                    columns: [{data: 'name'},
                        {data: 'description'},
                        {data: 'id', render: function (data, type, full, meta) {
                                return '<a data-toggle="modal" href="#add_loan_type-modal" id="' + data + '-LoanType" class="btn btn-white btn-sm"><i class="fa fa-pencil"></i> Edit </a><span id="' + data + '-LoanType-del" class="btn btn-danger btn-sm delete_me"><i class="fa fa-trash-o"></i> Deleted</span>';
                            }}

                    ],
                    buttons: btns_setup,
                    responsive: true,
                });
                //$("#datatable-buttons").DataTable();
            }
            /*END individual_types - --*/
            /*penalty_calculations  */
            if ($("#tblPenaltyCalculationMethod").length) {
                dTable['tblPenaltyCalculationMethod'] = $('#tblPenaltyCalculationMethod').DataTable({
                    dom: "lfrtipB",
                    "processing": true,
                    "ajax": {
                        "url": "ajax_requests/settings_data.php",
                        "dataType": "JSON",
                        "type": "POST",
                        "data": function (d) {
                            d.tbl = 'tblPenaltyCalculationMethod';
                            //d.start_date = getStartDate();
                            //d.end_date = getEndDate();
                        }
                    }, "columnDefs": [{
                            "targets": [2],
                            "orderable": false,
                            "searchable": false
                        }/* , {
                         "targets": [0],
                         "orderable": false
                         } */],
                    "autoWidth": false,
                    columns: [{data: 'methodDescription'},
                        {data: 'dateCreated', render: function (data, type, full, meta) {
                                return moment(data, "YYYY-MM-DD").format('LL');
                            }},
                        {data: 'id', render: function (data, type, full, meta) {
                                return '<a data-toggle="modal" href="#add_penalty_calculation_method-modal" id="'+data+'-PenaltyCalculationMethod" class="btn btn-white btn-sm"><i class="fa fa-pencil"></i> Edit </a><span id="' + data + '-PenaltyCalculationMethod-del" class="btn btn-danger btn-sm delete_me"><i class="fa fa-trash-o"></i> Deleted</span>';
                            }}

                    ],
                    buttons: btns_setup,
                    responsive: true,
                });
                //$("#datatable-buttons").DataTable();
            }
            /*END penalty_calculations - --*/
            if ($("#tblLoanProductPenalty").length) {
                dTable['tblLoanProductPenalty'] = $('#tblLoanProductPenalty').DataTable({
                    dom: "lfrtipB",
                    "processing": true,
                    "ajax": {
                        "url": "ajax_requests/settings_data.php",
                        "dataType": "JSON",
                        "type": "POST",
                        "data": function (d) {
                            d.tbl = 'tblLoanProductPenalty';
                            //d.start_date = getStartDate();
                            //d.end_date = getEndDate();
                        }
                    }, "columnDefs": [{
                            "targets": [2],
                            "orderable": false,
                            "searchable": false
                        }/* , {
                         "targets": [0],
                         "orderable": false
                         } */],
                    "autoWidth": false,
                    columns: [{data: 'description'},
                        {data: 'penaltyChargedAs'},
                        {data: 'penaltyTolerancePeriod'},
                        {data: 'defaultAmount'},
                        {data: 'minAmount'},
                        {data: 'maxAmount'},
                        {data: 'id', render: function (data, type, full, meta) {
                                return '<a data-toggle="modal" href="#add_loan_product_penalty-modal" id="'+data+'-LoanProductPenalty" class="btn btn-white btn-sm"><i class="fa fa-pencil"></i> Edit </a><span id="' + data + '-LoanProductPenalty-del" class="btn btn-danger btn-sm delete_me"><i class="fa fa-trash-o"></i> Deleted</span>';}}

                    ],
                    buttons: btns_setup,
                    responsive: true,
                });
                //$("#datatable-buttons").DataTable();
            }
            /*END Product PENALTY - --*/
            /*Position */
            if ($("#tblPosition").length) {
                dTable['tblPosition'] = $('#tblPosition').DataTable({
                    dom: "lfrtipB",
                    "processing": true,
                    "ajax": {
                        "url": "ajax_requests/settings_data.php",
                        "dataType": "JSON",
                        "type": "POST",
                        "data": function (d) {
                            d.tbl = 'tblPosition';
                            //d.start_date = getStartDate();
                            //d.end_date = getEndDate();
                        }
                    }, "columnDefs": [{
                            "targets": [2],
                            "orderable": false,
                            "searchable": false
                        }/* , {
                         "targets": [0],
                         "orderable": false
                         } */],
                    "autoWidth": false,
                    columns: [{data: 'name'},
                        {data: 'access_level'},
                        {data: 'description'},
                        {data: 'id', render: function (data, type, full, meta) {
                                return '<a data-toggle="modal" id="' + data + '-Position" href="#add_position-modal" class="btn btn-white btn-sm edit_me"><i class="fa fa-pencil"></i> Edit </a><span id="' + data + '-Position-del" class="btn btn-danger btn-sm delete_me"><i class="fa fa-trash-o"></i> Deleted</span>';
                            }}

                    ],
                    buttons: btns_setup,
                    responsive: true,
                });
                //$("#datatable-buttons").DataTable();
            }
            /*END Position- --*/
            /*Id Card Types */
            if ($("#tblIdCardType").length) {
                dTable['tblIdCardType'] = $('#tblIdCardType').DataTable({
                    dom: "lfrtipB",
                    "processing": true,
                    "ajax": {
                        "url": "ajax_requests/settings_data.php",
                        "dataType": "JSON",
                        "type": "POST",
                        "data": function (d) {
                            d.tbl = 'tblIdCardType';
                            //d.start_date = getStartDate();
                            //d.end_date = getEndDate();
                        }
                    }, "columnDefs": [{
                            "targets": [2],
                            "orderable": false,
                            "searchable": false
                        }/* , {
                         "targets": [0],
                         "orderable": false
                         } */],
                    "autoWidth": false,
                    columns: [{data: 'id_type'},
                        {data: 'description'},
                        {data: 'id', render: function (data, type, full, meta) {
                                return '<a data-toggle="modal" id="' + data + '-IdCardType" href="#add_id_card_type-modal" class="btn btn-white btn-sm edit_me"><i class="fa fa-pencil"></i> Edit </a><span id="' + data + '-IdCardType-del" class="btn btn-danger btn-sm delete_me"><i class="fa fa-trash-o"></i> Deleted</span>';
                            }}

                    ],
                    buttons: btns_setup,
                    responsive: true,
                });
                //$("#datatable-buttons").DataTable();
            }
            /*END Card Types- --*/
            /*Loan Product Types */
            if ($("#tblLoanProductType").length) {
                dTable['tblLoanProductType'] = $('#tblLoanProductType').DataTable({
                    dom: "lfrtipB",
                    "processing": true,
                    "ajax": {
                        "url": "ajax_requests/settings_data.php",
                        "dataType": "JSON",
                        "type": "POST",
                        "data": function (d) {
                            d.tbl = 'tblLoanProductType';
                            //d.start_date = getStartDate();
                            //d.end_date = getEndDate();
                        }
                    }, "columnDefs": [{
                            "targets": [2],
                            "orderable": false,
                            "searchable": false
                        }/* , {
                         "targets": [0],
                         "orderable": false
                         } */],
                    "autoWidth": false,
                    columns: [{data: 'typeName'},
                        {data: 'description'},
                        {data: 'id', render: function (data, type, full, meta) {
                                return '<a data-toggle="modal" id="' + data + '-LoanProductType" href="#add_loan_product_type-modal" class="btn btn-white btn-sm edit_me"><i class="fa fa-pencil"></i> Edit </a><span id="' + data + '-LoanProductType-del" class="btn btn-danger btn-sm delete_me"><i class="fa fa-trash-o"></i> Deleted</span>';
                            }}

                    ],
                    buttons: btns_setup,
                    responsive: true,
                });
                //$("#datatable-buttons").DataTable();
            }
            /*END Loan Product Types- --*/
            /* Security Type */
            if ($("#tblSecurityType").length) {
                dTable['tblSecurityType'] = $('#tblSecurityType').DataTable({
                    dom: "lfrtipB",
                    "processing": true,
                    "ajax": {
                        "url": "ajax_requests/settings_data.php",
                        "dataType": "JSON",
                        "type": "POST",
                        "data": function (d) {
                            d.tbl = 'tblSecurityType';
                            //d.start_date = getStartDate();
                            //d.end_date = getEndDate();
                        }
                    }, "columnDefs": [{
                            "targets": [2],
                            "orderable": false,
                            "searchable": false
                        }/* , {
                         "targets": [0],
                         "orderable": false
                         } */],
                    "autoWidth": false,
                    columns: [{data: 'name'},
                        {data: 'description'},
                        {data: 'id', render: function (data, type, full, meta) {
                                return '<a data-toggle="modal" id="' + data + '-SecurityType" href="#add_security_type-modal" class="btn btn-white btn-sm edit_me"><i class="fa fa-pencil"></i> Edit </a><span id="' + data + '-SecurityType-del"  class="btn btn-danger btn-sm delete_me"><i class="fa fa-trash-o"></i> Deleted</span>';
                            }}

                    ],
                    buttons: btns_setup,
                    responsive: true,
                });
                //$("#datatable-buttons").DataTable();
            }
            /*END Sec Types- --*/
            /* Relationship Type */
            if ($("#tblRelationshipType").length) {
                dTable['tblRelationshipType'] = $('#tblRelationshipType').DataTable({
                    dom: "lfrtipB",
                    "processing": true,
                    "ajax": {
                        "url": "ajax_requests/settings_data.php",
                        "dataType": "JSON",
                        "type": "POST",
                        "data": function (d) {
                            d.tbl = 'tblRelationshipType';
                            //d.start_date = getStartDate();
                            //d.end_date = getEndDate();
                        }
                    }, "columnDefs": [{
                            "targets": [2],
                            "orderable": false,
                            "searchable": false
                        }/* , {
                         "targets": [0],
                         "orderable": false
                         } */],
                    "autoWidth": false,
                    columns: [{data: 'rel_type'},
                        {data: 'description'},
                        {data: 'id', render: function (data, type, full, meta) {
                                return '<a data-toggle="modal" id="' + data + '-RelationshipType" href="#add_relationship_type-modal" class="btn btn-white btn-sm edit_me"><i class="fa fa-pencil"></i> Edit </a><span id="' + data + '-RelationshipType-del" class="btn btn-danger btn-sm delete_me"><i class="fa fa-trash-o"></i> Deleted</span>';
                            }}

                    ],
                    buttons: btns_setup,
                    responsive: true,
                });
                //$("#datatable-buttons").DataTable();
            }
            /*END relationship Types- --*/
            /* Address Type */
            if ($("#tblAddressType").length) {
                dTable['tblAddressType'] = $('#tblAddressType').DataTable({
                    dom: "lfrtipB",
                    "processing": true,
                    "ajax": {
                        "url": "ajax_requests/settings_data.php",
                        "dataType": "JSON",
                        "type": "POST",
                        "data": function (d) {
                            d.tbl = 'tblAddressType';
                            //d.start_date = getStartDate();
                            //d.end_date = getEndDate();
                        }
                    }, "columnDefs": [{
                            "targets": [2],
                            "orderable": false,
                            "searchable": false
                        }/* , {
                         "targets": [0],
                         "orderable": false
                         } */],
                    "autoWidth": false,
                    columns: [{data: 'address_type'},
                        {data: 'description'},
                        {data: 'id', render: function (data, type, full, meta) {
                                return '<a data-toggle="modal" href="#add_address_type-modal" id="' + data + '-AddressType" class="btn btn-white btn-sm"><i class="fa fa-pencil"></i> Edit </a><span id="' + data + '-AddressType-del" class="btn btn-danger btn-sm delete_me"><i class="fa fa-trash-o"></i> Deleted</span>';
                            }}

                    ],
                    buttons: btns_setup,
                    responsive: true,
                });
                //$("#datatable-buttons").DataTable();
            }
            /*End Address Types- --*/
            /* Marital Status */
            if ($("#tblMaritalStatus").length) {
                dTable['tblMaritalStatus'] = $('#tblMaritalStatus').DataTable({
                    dom: "lfrtipB",
                    "processing": true,
                    "ajax": {
                        "url": "ajax_requests/settings_data.php",
                        "dataType": "JSON",
                        "type": "POST",
                        "data": function (d) {
                            d.tbl = 'tblMaritalStatus';
                            //d.start_date = getStartDate();
                            //d.end_date = getEndDate();
                        }
                    }, "columnDefs": [{
                            "targets": [2],
                            "orderable": false,
                            "searchable": false
                        }/* , {
                         "targets": [0],
                         "orderable": false
                         } */],
                    "autoWidth": false,
                    columns: [{data: 'name'},
                        {data: 'description'},
                        {data: 'id', render: function (data, type, full, meta) {
                                return '<a data-toggle="modal" id="' + data + '-MaritalStatus" href="#add_marital_status-modal" class="btn btn-white btn-sm edit_me"><i class="fa fa-pencil"></i> Edit </a><span id="' + data + '-MaritalStatus-del" class="btn btn-danger btn-sm delete_me"><i class="fa fa-trash-o"></i> Deleted</span>';
                            }}

                    ],
                    buttons: btns_setup,
                    responsive: true,
                });
                //$("#datatable-buttons").DataTable();
            }
            /*End Marital Status --*/
            /* Loan Product */
            if ($("#tblLoanProduct").length) {
                dTable['tblLoanProduct'] = $('#tblLoanProduct').DataTable({
                    dom: "lfrtipB",
                    "processing": true,
                    "ajax": {
                        "url": "ajax_requests/settings_data.php",
                        "dataType": "JSON",
                        "type": "POST",
                        "data": function (d) {
                            d.tbl = 'tblLoanProduct';
                        }
                    }, "columnDefs": [{
                            "targets": [3],
                            "orderable": false,
                            "searchable": false
                        }/* , {
                         "targets": [0],
                         "orderable": false
                         } */],
                    "autoWidth": false,
                    columns: [{data: 'productName'},
                        {data: 'description'},
                        {data: 'typeName'},
                        {data: 'id', render: function (data, type, full, meta) {
                                display_text = '<a data-toggle="modal" href="#add_loan_product-modal" id="' + data + '-LoanProduct" class="btn btn-white btn-xs edit_me"><i class="fa fa-pencil"></i> </a>'
                                        +'<a href="loan_product.php?id=' + data + '" class="btn btn-default btn-xs"><i class="fa fa-list"></i> </a>'
                                        +'<span id="' + data + '-LoanProduct-del" class="btn btn-danger btn-xs delete_me"><i class="fa fa-trash-o"></i> </span>';
                                return display_text;
                            }
                        }

                    ],
                    buttons: btns_setup,
                    responsive: true,
                });
                //$("#datatable-buttons").DataTable();
            }
            /*End Loan Product- --*/
            /* Loan Product Fees*/
            if ($("#tblLoanProductFee").length) {
                dTable['tblLoanProductFee'] = $('#tblLoanProductFee').DataTable({
                    dom: "lfrtipB",
                    "processing": true,
                    "ajax": {
                        "url": "ajax_requests/settings_data.php",
                        "dataType": "JSON",
                        "type": "POST",
                        "data": function (d) {
                            d.tbl = 'tblLoanProductFee';
                        }
                    }, "columnDefs": [{
                            "targets": [5],
                            "orderable": false,
                            "searchable": false
                        }],
                    "autoWidth": false,
                    columns: [{data: 'feeName'},
                        {data: 'feeTypeName'},
                        {data: 'amountCalculatedAs', render: function(data, type, full, meta){ return getAmountCalculatedAsOption(data);}},
                        {data: 'amount', render: function(data, type, full, meta){ return curr_format(data);}},
                        {data: 'requiredFee', render: function(data, type, full, meta){ return parseInt(data)===0?"No":"Yes";}},
                        {data: 'id', render: function (data, type, full, meta) {
                                display_text = '<a data-toggle="modal" href="#add_loan_product_fee-modal" id="' + data + '-LoanProductFee" class="btn btn-white btn-xs edit_me"><i class="fa fa-pencil"></i> </a>'
                                        +'<span id="' + data + '-LoanProductFee-del" class="btn btn-danger btn-xs delete_me"><i class="fa fa-trash-o"></i> </span>';
                                return display_text;
                            }
                        }

                    ],
                    buttons: btns_setup,
                    responsive: true,
                });
                //$("#datatable-buttons").DataTable();
            }
            /*End Loan Product Fees- --*/
            /* Deposit Product */
            if ($("#tblDepositProduct").length) {
                dTable['tblDepositProduct'] = $('#tblDepositProduct').DataTable({
                    dom: "lfrtipB",
                    "processing": true,
                    "ajax": {
                        "url": "ajax_requests/settings_data.php",
                        "dataType": "JSON",
                        "type": "POST",
                        "data": function (d) {
                            d.tbl = 'tblDepositProduct';
                            //d.start_date = getStartDate();
                            //d.end_date = getEndDate();
                        }
                    }, "columnDefs": [{
                            "targets": [3],
                            "orderable": false,
                            "searchable": false
                        }/* , {
                         "targets": [0],
                         "orderable": false
                         } */],
                    "autoWidth": false,
                    columns: [{data: 'productName'},
                        {data: 'description'},
                        {data: 'typeName'},
                        {data: 'id', render: function (data, type, full, meta) {
                                return '<a data-toggle="modal" href="#add_deposit_product-modal" id="' + data + '-DepositProduct" class="btn btn-white btn-sm edit_me"><i class="fa fa-pencil"></i> Edit </a><span id="' + data + '-DepositProduct-del" class="btn btn-danger btn-sm delete_me"><i class="fa fa-trash-o"></i> Deleted</span>';
                            }}

                    ],
                    buttons: btns_setup,
                    responsive: true,
                });
                //$("#datatable-buttons").DataTable();
            }
            /*End Deposit Product- --*/
            /* Deposit Product Fees*/
            if ($("#tblDepositProductFee").length) {
                dTable['tblDepositProductFee'] = $('#tblDepositProductFee').DataTable({
                    dom: "lfrtipB",
                    "processing": true,
                    "ajax": {
                        "url": "ajax_requests/settings_data.php",
                        "dataType": "JSON",
                        "type": "POST",
                        "data": function (d) {
                            d.tbl = 'tblDepositProductFee';
                        }
                    }, "columnDefs": [{
                            "targets": [4],
                            "orderable": false,
                            "searchable": false
                        }],
                    "autoWidth": false,
                    columns: [{data: 'feeName'},
                        {data: 'amount', render: function(data, type, full, meta){ return curr_format(data);}},
                        {data: 'chargeTrigger', render: function(data, type, full, meta){ return getDescription(2, data);}},
                        {data: 'dateApplicationMethod', render: function(data, type, full, meta){ return data?getDescription(3, data):'';}},
                        {data: 'id', render: function (data, type, full, meta) {
                                display_text = '<a data-toggle="modal" href="#add_deposit_product_fee-modal" id="' + data + '-DepositProductFee" class="btn btn-white btn-xs edit_me"><i class="fa fa-pencil"></i> </a>'
                                        +'<span id="' + data + '-DepositProductFee-del" class="btn btn-danger btn-xs delete_me"><i class="fa fa-trash-o"></i> </span>';
                                return display_text;
                            }
                        }

                    ],
                    buttons: btns_setup,
                    responsive: true,
                });
                //$("#datatable-buttons").DataTable();
            }
            /*End Deposit Product Fees- --*/
        };
        TableManageButtons = function () {
            "use strict";
            return {
                init: function () {
                    handleDataTableButtons();
                }
            };
        }();

        TableManageButtons.init();

        /* Editing Several tables */
        $('.table tbody').on('click', 'tr .edit_me', function () {
            //id="'+data+'-person_type-personTypeTable" 

            var tbl, id, frm, dt;
            var d_id = $(this).attr("id");
            var arr = d_id.split("-");
            id = arr[0]; //The data (row) unique id 
            tbl = "tbl" + arr[1]; // The table, 
            frm = "form" + arr[1]; //The form id
            dt = dTable[tbl];
            var row = $(this).parent().parent();
            edit_data(dt.row(row).data(), frm);

        });
        /*  */

    });
    //ko.applyBindings({ depositProductModel: depositProductModel, loanProductModel: loanProductModel });
</script>