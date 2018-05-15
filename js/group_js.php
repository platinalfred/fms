<script>
$(document).ready(function(){
    /* PICK DATA FOR DATA TABLE  */
    var  dTable;
    var handleDataTableButtons = function() {
        if ($("#groupTable").length ) {
            dTable = $('#groupTable').DataTable({
                dom: "lfrtipB",
                "processing": true,
                "serverSide": true,
                "deferRender": true,
                "order": [[ 0, 'DESC' ]],
                "ajax": {
                    "url":"ajax_requests/find_data.php",
                    "dataType": "JSON",
                    "type": "POST",
                    "data":  function(d){
                        d.page = 'view_groups';
                        d.active = 1;
                    }
                },
                "initComplete": function(settings, json) {
                    $(".table#groupTable tbody>tr:first").trigger('click');
                    ko.applyBindings(groupModel);
                },
                "columnDefs": [ {
                        "targets": [0],
                        "orderable": false,
                        "searchable": false
                    } , {
                        "targets": [0],
                        "orderable": false
                    }],
                columns:[
                    { data: 'id'},
                    { data: 'groupName'},
                    { data: 'description'}
                    <?php  //if(isset($_SESSION['accountant']) || isset($_SESSION['admin'])){ ?>,
                    { data: 'id', render: function ( data, type, full, meta ) {
                            var anchor_class = (full.noMembers?'turn_off':'delete_me');
                            var itag_class = (full.noMembers?'power-off':'trash text-danger');
                            var anchor_title = (full.noMembers?'Deactivate':'Delete');
                            return ' <div class="btn-group">'
                            +'<a class="btn btn-xs btn-warning" href="group_details.php?groupId='+ data +'&view=loan_accs"><i class="fa fa-list"></i> Details</a>'
                            +'<a style="margin-left:15px;"class="btn btn-xs btn-default '+anchor_class+'" id="'+data+'" title="'+anchor_title+' group"><i class="fa fa-'+itag_class+'"></i></a></button>'
                            +'</div>';}
                    }
                 ] ,
                 buttons: [
                 {
                    extend: "copy",
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
                      ]
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
	//Delete Group
	$('#groupTable').on('click', 'tr .delete_me', function () {
                           de_lete_activate_group(this, "delete_me", "le");
                   });
	$('#groupTable').on('click', 'tr .turn_off', function () {
                           de_lete_activate_group(this, "turn_off", "activa");
                   });
	$('#groupTable').on('click', 'tr .edit_group', function () {
                            var id = $(this).attr("id");
                            $('#DescModal').removeData('bs.modal');
                            $('#DescModal').modal({remote: 'edit_group.php?id=' + id });
                            $('#DescModal').modal('show');
                   });
	$('#groupTable').on('click', 'tr', function () {
                        var data = dTable.row(this).data();
                        groupModel.group_details(data);
                        //ajax to retrieve other member details
                        //findGroupDetails(data.id);
	});
        function de_lete_activate_group(element, class_opt, msg){
            group_id = $(element).attr("id");
            var confirmation = confirm("Are you sure you would like to de"+msg+"te this group?");
            if(confirmation){
                $.ajax({
                    url: "ajax_requests/delete.php?tbl=saccogroup&id="+group_id+"&class="+class_opt,
                    type: 'GET',
                    success: function (response) {
                        if($.trim(response) == "success"){
                            showStatusMessage("Successfully de"+msg+"ted group" ,"success");
                            setTimeout(function(){
                                if($(element).parents('tr').length){
                                    dTable.ajax.reload();
                                }else{
                                    window.location = "groups.php";
                                }
                            }, 2000);
                        }else{
                            showStatusMessage(response, "fail");
                        }
                    }
                });
            }
        }
	function findGroupDetails(id){
		$.ajax({
			url: "ajax_requests/find_group_details.php?id="+id,
			type: 'GET',
			dataType: 'json',
			success: function (response) {
				if(response.group_members != "false" || response.group_members.length > 0){
					groupModel.all_group_members(response.group_members);
				}
			}
		});
	}
	
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
	// It has the name attribute "registration"
	$("form[name='register_group']").validate({
		// Specify validation rules
		rules: {
		  // The key name on the left side is the name attribute
		  // of an input field. Validation rules are defined
		  // on the right side
		  groupName: "required"
		},
		errorPlacement: function(error, element) {
			error.insertAfter(element);
		  
		},
		// Specify validation error messages
		messages: {
		  groupName: "Please give this group a name",
		},
		// Make sure the form is submitted to the destination defined
		// in the "action" attribute of the form when valid
		submitHandler: function(form, event) {
			event.preventDefault();
			enableDisableButton(form, true);
			/* if(){
				
			}else{ */
				var form =  $("form[name='register_group']");
				var frmdata = form.serialize();
				$.ajax({
					url: "ajax_requests/save_data.php",
					type: 'POST',
					data: frmdata,
					success: function (response) {
						if($.trim(response) == "success"){
							showStatusMessage("Successfully added new record" ,"success");
							form[0].reset();
							//groupModel.group_members(null);
							if(typeof dTable != 'undefined')
								dTable.ajax.reload();
							
						}else{
							showStatusMessage(response, "fail");
						}
						enableDisableButton(form, false);
					}
				});
			//}
		}
	});
});
	 
var GroupMember = function() {
	var self = this;
}
var Group = function() {
	var self = this;
	self.sacco_members = ko.observableArray();
	self.group_details = ko.observableArray();
	self.all_group_members = ko.observableArray();
	self.serverGroupMembers = ko.observableArray(<?=(!empty($data['group_members'])?json_encode($data['group_members']):'')?>);
	self.group_members = ko.observableArray([new GroupMember()]);
	self.addMember = function() { self.group_members.push(new GroupMember()) };
	self.removeMember = function(selected_member) { self.group_members.remove(selected_member); };
	//Operations
	//set options value afterwards
	self.setOptionValue = function(propId) {
		return function (option, item) {
			if (item === undefined) {
				option.value = "";
			} else {
				option.value = item[propId];
			}
		}
	};
	//Retrieve page data from the server
	self.findMembers = function() { 
		$.ajax({
			url: "ajax_requests/all_members.php",
			type: 'POST',
			data:{group:"view_members"<?php if(isset($_GET['groupId'])&&is_numeric($_GET['groupId'])){?>,groupId:<?=$_GET['groupId']?><?php }?>},
			dataType: 'json',
			success: function (data) {
				groupModel.sacco_members(data.customers);			
			}
		});
	};
}
var groupModel = new Group();
groupModel.findMembers();
<?php if(isset($_GET['groupId'])){?> ko.applyBindings(groupModel, $("#register_group")[0]) <?php } ?>;
</script>