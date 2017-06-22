<style>
 
.wizard-big.wizard > .content{
	 min-height:440px !important;
}
.no_padding{
	padding-left:0px;
}
       
</style>
<script>
function addCommas(nStr){
    var sep = ',';
    nStr += '';
    x = nStr.split('.');
    x1 = x[0];
    x2 = x.length > 1 ? '.' + x[1] : '';
    var rgx = /(\d+)(\d{3})/;
    while (rgx.test(x1)) {
        x1 = x1.replace(rgx, '$1' + sep + '$2');
    }
    return x1 + x2;
}
</script>
<div id="update_member" class="modal  fade" aria-hidden="true" >
	<div class="modal-dialog modal-lg" style="width: 900px !important;">
		<div class="modal-content">
			<div class="modal-body">
				
				<div class="ibox">
					<div class="ibox-title">
						<h1><strong>Update Member</strong></h1>
						<div class="ibox-tools">
							<a class="collapse-link">
								<i class="fa fa-chevron-up"></i>
							</a>
							<a class="" >
                                <i class="fa fa-times lg" data-dismiss="modal" style="color:red;"></i>
                            </a>
						</div>
					</div>
					<div class="ibox-content">
						
						<form id="form1" action="" method="post" name="registration"  class="wizard-big">
							<input type="hidden" name="modifiedBy" value="<?php echo $_SESSION['personId'];?>">
							<input type="hidden" name="tbl" value="update_member">
							<h1>Demographic Information</h1>
							<fieldset>
								<div class="row">
									<div class="col-lg-6">
										<div class="form-group">
											<label class="col-sm-4 control-label no_padding">Title</label>
											<div class="col-sm-7">
												<select class="form-control m-b" name="title" required>
													<option <?php if($member_data['title'] == "Mr"){ echo "selected"; } ?> value="Mr" >Mr.</option>
													<option <?php if($member_data['title'] == "Mrs"){echo "selected"; } ?> value="Mrs">Mrs.</option>
													<option <?php if($member_data['title'] == "Dr"){echo "selected"; } ?> value="Dr">Dr.</option>
													<option <?php if($member_data['title'] == "Prof"){echo "selected"; } ?> value="Prof">Prof.</option>
												</select>
											</div>
										</div>
									</div>	
									<div class="col-lg-6">
										<div class="form-group">
											<label class="col-sm-3 control-label no_padding">Member Type</label>
											<div class="col-sm-7">
												<select class="form-control m-b" name="memberType" >
													<option <?php if($member_data['memberType'] == 0){echo "checked"; } ?> value="0	">Member Only</option>
													<option <?php if($member_data['memberType'] == 1){echo "checked"; } ?> value="1">Member and Share Holder</option>
												</select>
											</div>
										</div>
									</div>
									<div class="col-lg-10">
										<div class="col-sm-12">&nbsp;</div>
											<div class="col-sm-12 no_padding">
											<div class="form-group">
												<div class="col-sm-3 no_padding">
													<label style=""class="">Name <span class="req">*</span></label>
												</div>
												<div class="col-sm-9">
													<input type="text" value="<?php echo $member_data['firstname']; ?>" class="form-control" name="firstname" data-msg-require="Please enter name" placeholder="First Name" required/>
													<span class="input-group-btn" style="width:2px;"></span>
													<input type="text" value="<?php echo $member_data['lastname']; ?>" class="form-control" name="lastname" placeholder="Last Name" required />
													<span class="input-group-btn" style="width:2px;"></span>
													<input type="text" value="<?php echo $member_data['othername']; ?>" class="form-control" name="othername"  placeholder="Other Name" />
												</div>
											</div>
										</div>
										<div class="col-sm-7 no_padding" style="margin-top:8px;margin-bottom:8px;">
											<div class="form-group">
												<div class="col-sm-5 no_padding"><label class="col-lg-12" >Gender</label></div>
												<div class="col-sm-7">
													<label > <input name="gender" <?php if($member_data['gender'] == "M"){echo "checked"; } ?> class="i-checks" type="radio" value="M" >Male</label>
													<label > <input name="gender" <?php if($member_data['gender'] == "F"){echo "checked"; } ?> class="i-checks" type="radio" value="F"> Female</label>
												</div>
											</div>											
												
										</div>
										<div class="col-sm-5">
											<div class="form-group">
												<label class="col-sm-3 control-label no_padding">Marital Status</label>
												<div class="col-sm-9">
													<select class="form-control m-b" name="marital_status" >
														<option <?php if($member_data['marital_status'] == "Single"){echo "selected"; } ?> value="Single">Single</option>
														<option <?php if($member_data['marital_status'] == "Married"){echo "selected"; } ?> value="Married">Married</option>
														<option <?php if($member_data['marital_status'] == "Divorced"){echo "selected"; } ?> value="Divorced">Divorced</option>
														<option <?php if($member_data['marital_status'] == "Windowed"){echo "selected"; } ?> value="Windowed">Windowed</option>
													</select>
												</div>
											</div>
										</div>
										<div class="col-sm-12 no_padding">
											<div class="form-group">
												<label class="col-sm-3 control-label no_padding" >Date of Birth <span class="req">*</span></label>
												<div class="col-sm-9">
													<input id="dateofbirth" value="<?php echo $member_data['dateofbirth']; ?>" name="dateofbirth" type="text" data-mask="99/99/9999" class="form-control" >
													<span class="help-block">(dd/mm/yyyy)</span>
												</div>
											</div>
										</div>
										<div class="col-sm-12 no_padding">
											<div class="form-group">
												<label class="col-sm-3 control-label no_padding" >Occupation</label>
												<div class="col-sm-9">
													<input  name="occupation" value="<?php echo $member_data['occupation']; ?>" type="text" class="form-control">
												</div>
											</div>
										</div>
									</div>
									<!--
									<div class="col-lg-4">
										<div class="text-center">
											<div style="margin-top: 20px">
												<i class="fa fa-sign-in" style="font-size: 180px;color: #e5e5e5 "></i>
											</div>
										</div>
									</div> -->
								</div>

							</fieldset>
							<h1>Identification  Information</h1>
							<fieldset>
								<div class="row">
									<div class="col-lg-6">
										<div class="item form-group">
											<label class="control-label col-md-3 col-sm-3 col-xs-12 no_padding" for="id_type">ID Type <span class="required">*</span>
											</label>
											<div class="col-md-9 col-sm-9 col-xs-12">
												<select class="form-control m-b" name="id_type" required >
													<option>Please select</option>
													<?php 
													$idcardtype = new IdCardType();
													$all_id_cardtype = $idcardtype->findAll();
													if($all_id_cardtype){
														foreach($all_id_cardtype as $single){ ?>
															<option <?php if($member_data['id_type'] == $single['id']){ echo "selected"; } ?> value="<?php echo $single['id']; ?>" ><?php echo $single['id_type']; ?></option>
															<?php
														}
													}
													?>
												</select>
											</div>
										</div>
									</div>
									<div class="col-lg-6">
										<div class="form-group">
											<label class="control-label col-md-3 col-sm-3 col-xs-12 no_padding">Id Number <span class="req">*</span></label>
											<div class="col-md-9 col-sm-9 col-xs-12">
												<input name="id_number" type="text" value="<?php echo $member_data['id_number']; ?>" class="form-control" required>
											</div>
										</div>
									</div>
									<div class="col-lg-12">&nbsp;</div>
									<div class="col-lg-6">
										<div class="form-group">
											<label>Credit Reference Bureau Card Number (CRB )</label>
											<input  name="CRB_card_no" value="<?php echo $member_data['CRB_card_no']; ?>" type="text" class="form-control ">
										</div>
									</div>
									<div class="col-lg-12">&nbsp;</div>
									<div class="col-lg-6">
										<div class="form-group">
											<label >Email </label>
											<input id="email" name="email" value="<?php echo $member_data['email']; ?>" type="email" class="form-control ">
											
										</div>
									</div>
									<div class="col-lg-6">
										<div class="form-group">
											<label>Telephone <span class="req">*</span></label>
											<input id="phone" value="<?php echo $member_data['phone']; ?>" type="text" class="form-control" data-mask="(999) 999-9999" placeholder="" name="phone"required ><span class="help-block">(073) 000-0000</span>
										</div>
									</div>
									<div class="col-lg-3">
										<div class="form-group">
											<label>Physical Address <span class="req">*</span></label>
											<input id="physical_address" value="<?php echo $member_data['physical_address']; ?>" name="physical_address" type="text" class="form-control" required>
										</div>
									</div>
									<div class="col-lg-3">
										<div class="form-group">
											<label>Postal Address</label>
											<input id="postal_address" value="<?php echo $member_data['postal_address']; ?>" name="postal_address" type="text" class="form-control ">
										</div>
									</div>
									<div class="col-lg-6">
										<div class="form-group">
											<label>District </label>
											<input id="" name="district" value="<?php echo $member_data['district']; ?>" type="text" class="form-control">
										</div>
									</div>
									<div class="col-lg-6">
										<div class="form-group">
											<label>County </label>
											<input id="" name="county" value="<?php echo $member_data['county']; ?>" type="text" class="form-control">
										</div>
									</div>
									<div class="col-lg-6">
										<div class="form-group">
											<label>Sub County </label>
											<input id="" name="subcounty" value="<?php echo $member_data['subcounty']; ?>" type="text" class="form-control">
										</div>
									</div>
									<div class="col-lg-6">
										<div class="form-group">
											<label>Parish </label>
											<input id="" name="parish" value="<?php echo $member_data['parish']; ?>" type="text" class="form-control">
										</div>
									</div>
									<div class="col-lg-6">
										<label class="control-label">Village</label>
										<input id="" name="village" value="<?php echo $member_data['village']; ?>" type="text" class="form-control">
									</div>
								</div>
							</fieldset>
							
							<h1>Business</h1>
							<fieldset>
								<div class="row" data-bind="foreach: $root.member_business2">
									<h3 data-bind="text:'business '+($index()+1)"></h3>
									<div class="col-lg-3">
										<div class="form-group">
											<label>Name of Business</label>
											<input   data-bind="attr: {name:'business['+$index()+'][businessName]', value: businessName}"  type="text" class="form-control">
										</div>
									</div>
									<div class="col-lg-3">
										<div class="form-group">
											<label>Business Type</label>
											<input   data-bind="attr: {name:'business['+$index()+'][natureOfBusiness]', value: natureOfBusiness}"  type="text" class="form-control">
										</div>
									</div>
									<div class="col-lg-3">
										<div class="form-group">
											<label>Business Location</label>
											<input data-bind="attr: {name:'business['+$index()+'][businessLocation]',value: businessLocation}" type="text" class="form-control ">
										</div>
									</div>
									<div class="col-lg-2">
										<div class="form-group">
											<label>Number Of Employees</label>
											<input data-bind="attr: {name:'business['+$index()+'][numberOfEmployees]', value:numberOfEmployees}"  type="text" class="form-control athousand_separator">
										</div>
									</div>
									<div class="col-lg-2">
										<div class="form-group">
											<label>Business Worth</label>
											<input data-bind="attr: {name:'business['+$index()+'][businessWorth]', value:businessWorth}"  type="text" class="form-control athousand_separator">
										</div>
									</div>
									<div class="col-lg-2">
										<div class="form-group">
											<label>URSB Number</label>
											<input data-bind="attr: {name:'business['+$index()+'][ursbNumber]', value:ursbNumber}"  type="text" class="form-control athousand_separator">
										</div>
									</div>
									<div class="col-lg-1"><span title="Remove employer" class="btn text-danger btn-lg" data-bind='click: $root.removeEmployment'><i class="fa fa-minus"></i></span></div>
									<div class="clearboth"></div>
								</div>
								<div class="row" data-bind="foreach: $root.member_business">
									<h3 data-bind="text:'Employer '+($index()+$root.member_business2().length+1)"></h3>
									<div class="col-lg-3">
										<div class="form-group">
											<label>Name of Business</label>
											<input   data-bind="attr: {name:'business['+($index()+$root.member_business2().length+1)'][businessName]'}"  type="text" class="form-control">
										</div>
										
									</div>
									<div class="col-lg-3">
										<div class="form-group">
											<label>Business Location</label>
											<input data-bind="attr: {name:'business['+($index()+$root.member_business2().length+1)+'][businessLocation]',value: businessLocation}" type="text" class="form-control ">
										</div>
									</div>
									<div class="col-lg-3">
										<div class="form-group">
											<label>Number Of Employees</label>
											<input data-bind="attr: {name:'business['+($index()+$root.member_business2().length+1)+'][numberOfEmployees]', value:numberOfEmployees}"  type="text" class="form-control athousand_separator">
										</div>
									</div>
									<div class="col-lg-2">
										<div class="form-group">
											<label>Business Worth</label>
											<input data-bind="attr: {name:'business['+($index()+$root.member_business2().length+1)+'][businessWorth]', value:businessWorth}"  type="text" class="form-control athousand_separator">
										</div>
									</div>
									<div class="col-lg-2">
										<div class="form-group">
											<label>URSB Number</label>
											<input data-bind="attr: {name:'business['+($index()+$root.member_business2().length+1)+'][ursbNumber]', value:ursbNumber}"  type="text" class="form-control athousand_separator">
										</div>
									</div>
									<div class="col-lg-1"><span title="Remove employer" class="btn text-danger btn-lg" data-bind='click: $root.removeBusiness'><i class="fa fa-minus"></i></span></div>
									<div class="clearboth"></div>
								</div>
								<div class="row">
									<div class="clearboth"></div>
									<div class="col-lg-12">
										 <div class="form-group">
											<span class="btn btn-info btn-sm pull-right" data-bind='click: addBusinnes'><i class="fa fa-plus"></i> Add more</span>
										</div>
									</div>
								</div>
							<fieldset>
							<h1>Employment</h1>
							<fieldset>
								<div class="row" data-bind="foreach: $root.member_employment2">
									<h3 data-bind="text:'Employer '+($index()+1)"></h3>
									<div class="col-lg-3">
										<div class="form-group">
											<label>Name of Employer</label>
											<input   data-bind="attr: {name:'employment['+$index()+'][employer]', value: employer}"  type="text" class="form-control">
										</div>
									</div>
									<div class="col-lg-3">
										<div class="form-group">
											<label>Number of years with Employer</label>
											<input  data-bind="attr: {name:'employment['+$index()+'][years_of_employment]', value: years_of_employment}"  type="number" class="form-control ">
										</div>
									</div>
									<div class="col-lg-3">
										<div class="form-group">
											<label>Nature of employment</label>
											<input data-bind="attr: {name:'employment['+$index()+'][nature_of_employment]',value: nature_of_employment}" type="text" class="form-control ">
										</div>
									</div>
									<div class="col-lg-2">
										<div class="form-group">
											<label>Monthly Salary</label>
											<input data-bind="attr: {name:'employment['+$index()+'][monthlySalary]', value:monthlySalary}"  type="text" class="form-control athousand_separator">
										</div>
									</div>
									<div class="col-lg-1"><span title="Remove employer" class="btn text-danger btn-lg" data-bind='click: $root.removeEmployment'><i class="fa fa-minus"></i></span></div>
									<div class="clearboth"></div>
								</div>
								<div class="row" data-bind="foreach: $root.member_employment">
									<h3 data-bind="text:'Employer '+($index()+$root.member_employment2().length+1)"></h3>
									<div class="col-lg-3">
										<div class="form-group">
											<label>Name of Employer</label>
											<input   data-bind="attr: {name:'employment['+($index()+$root.member_employment2().length+1)+'][employer]'}"  type="text" class="form-control">
										</div>
									</div>
									<div class="col-lg-3">
										<div class="form-group">
											<label>Number of years with Employer</label>
											<input  data-bind="attr: {name:'employment['+($index()+$root.member_employment2().length+1)+'][years_of_employment]'}"  type="number" class="form-control ">
										</div>
									</div>
									<div class="col-lg-3">
										<div class="form-group">
											<label>Nature of employment</label>
											<input data-bind="attr: {name:'employment['+($index()+$root.member_employment2().length+1)+'][nature_of_employment]'}" type="text" class="form-control ">
										</div>
									</div>
									<div class="col-lg-2">
										<div class="form-group">
											<label>Monthly Salary</label>
											<input data-bind="attr: {name:'employment['+($index()+$root.member_employment2().length+1)+'][monthlySalary]'}"  type="text" class="form-control athousand_separator">
										</div>
									</div>
									<div class="col-lg-1"><span title="Remove employer" class="btn text-danger btn-lg" data-bind='click: $root.removeEmployment'><i class="fa fa-minus"></i></span></div>
									<div class="clearboth"></div>
								</div>
								<div class="row">
									<div class="clearboth"></div>
									<div class="col-lg-12">
										 <div class="form-group">
											<span class="btn btn-info btn-sm pull-right" data-bind='click: addEmployment'><i class="fa fa-plus"></i> Add more</span>
										</div>
									</div>
								</div>
							<fieldset>
							
							<h1>Relatives</h1>
							
							<fieldset>
								<div class="row" data-bind="foreach: $root.member_relatives2">
									
									<h3 data-bind="text:'Relative '+($index()+init)"></h3>
									<div class="col-lg-3">
										<div class="form-group">
											<label>Relationship</label>
											<select class="form-control"  data-bind="attr: {name:'relative['+$index()+'][relationship]'}, options: relationships, optionsText: 'rel_type', optionsCaption: 'Select...', optionsValue: 'id', value: relationship" data-msg-required="Relationship is required"></select>
										</div>
									</div>
									<div class="col-sm-3">
										<div class="form-group"><label class="col-lg-12" >Gender</label>
											<label > <input  data-bind="attr: {name:'relative['+$index()+'][relative_gender]'}, value: relative_gender, checked: relative_gender" class="i-checks" type="radio" value="1"  >Male</label>
											<label > <input  data-bind="attr: {name:'relative['+$index()+'][relative_gender]'}, value: relative_gender, checked: relative_gender"  class="i-checks" type="radio" value="0" > Female</label>
										</div>
									</div>
									<div class="col-lg-3">
										 <div class="form-group">
											<label  >Is Direct Next of Kin?</label>
											<label > <input  class="i-checks" type="radio" value="1" data-bind="attr: {name:'relative['+$index()+'][is_next_of_kin]'}, checked: is_next_of_kin">Yes</label>
											<label > <input data-bind="attr: {name:'relative['+$index()+'][is_next_of_kin]'}, checked: is_next_of_kin, " class="i-checks" type="radio" value="0" > No</label>
										
										</div>
									</div>
									<div class="col-lg-12">
										<div class="form-group">
											<div class="col-sm-2 no_padding">
												<label style=""class="">Name <span class="req">*</span></label>
											</div>
											<div class="col-sm-9">
												<div class="col-sm-4">
													<input type="text" class="form-control" placeholder="First Name" data-bind="attr: {name:'relative['+$index()+'][first_name]'}, value: first_name" />
													<span class="input-group-btn" style="width:2px;"></span>
												</div>
												<div class="col-sm-4">
													<input type="text" class="form-control" data-bind="attr: {name:'relative['+$index()+'][last_name]'}, value: last_name" placeholder="Last Name" />
													<span class="input-group-btn" style="width:2px;"></span>
												</div>
												<div class="col-sm-4">
													<input type="text" class="form-control" data-bind="attr: {name:'relative['+$index()+'][other_names]'}, value: other_names"   placeholder="Other Name" />
												</div>
											</div>
										</div>
									</div>
									<div class="col-lg-3">
										<div class="form-group">
											<label>Address</label>
											<input id=""  data-bind="attr: {name:'relative['+$index()+'][address]'}, value: address" type="text" class="form-control " >
										</div>
									</div>
									<div class="col-lg-3">
										<div class="form-group">
											<label>Address 2</label>
											<input  type="text" class="form-control"  data-bind="attr: {name:'relative['+$index()+'][address2]'}, value: address2">
										</div>
									</div>
									<div class="col-lg-3">
										<div class="form-group">
											<label>Phone </label>
											<input ="relative[]['telephone']" data-mask="(999) 999-9999" data-bind="attr: {name:'relative['+$index()+'][telephone]'}, value: telephone" type="text" class="form-control ">
										</div>
									</div>
									<div class="col-lg-3"><span title="Remove relative" class="btn text-danger btn-lg" data-bind='click: $root.removeRelative2'><i class="fa fa-minus"></i></span></div>
									<div class="clearboth"></div>
									
										
								</div>
								<div class="row" data-bind="foreach: $root.member_relatives">
									<h3 data-bind="text:'Relative '+($index()+$root.member_relatives2().length+1)"></h3>
									<div class="col-lg-3">
										<div class="form-group">
											<label>Relationship</label>
											<select class="form-control"  data-bind="attr: {name:'relative['+($index()+$root.member_relatives2().length)+'][relationship]'}, options: relationships, optionsText: 'rel_type', optionsCaption: 'Select...', , optionsAfterRender: $parent.setOptionValue('id'), value: relationship" data-msg-required="Relationship is required"></select>
										</div>
									</div>
									<div class="col-sm-3">
										<div class="form-group"><label class="col-lg-12" >Gender</label>
											<label > <input  data-bind="attr: {name:'relative['+($index()+$root.member_relatives2().length)+'][relative_gender]'}, value: relative_gender" class="i-checks" type="radio" value="1"  >Male</label>
											<label > <input  data-bind="attr: {name:'relative['+($index()+$root.member_relatives2().length)+'][relative_gender]'}, value: relative_gender"  class="i-checks" type="radio" value="0" > Female</label>
										</div>
									</div>
									<div class="col-lg-3">
										 <div class="form-group">
											<label  >Is Direct Next of Kin?</label>
											<label > <input  class="i-checks" type="radio" value="1" data-bind="attr: {name:'relative['+($index()+$root.member_relatives2().length)+'][is_next_of_kin]'}, checked: is_next_of_kin">Yes</label>
											<label > <input data-bind="attr: {name:'relative['+($index()+$root.member_relatives2().length)+'][is_next_of_kin]'}, checked: is_next_of_kin" class="i-checks" type="radio" value="0" > No</label>
										
										</div>
									</div>
									<div class="col-lg-12">
										<div class="form-group">
											<div class="col-sm-2 no_padding">
												<label style=""class="">Name <span class="req">*</span></label>
											</div>
											<div class="col-sm-9">
												<div class="col-sm-4">
													<input type="text" class="form-control" placeholder="First Name" data-bind="attr: {name:'relative['+($index()+$root.member_relatives2().length)+'][first_name]'}, value: first_name" />
													<span class="input-group-btn" style="width:2px;"></span>
												</div>
												<div class="col-sm-4">
													<input type="text" class="form-control" data-bind="attr: {name:'relative['+($index()+$root.member_relatives2().length)+'][last_name]'}, value: last_name" placeholder="Last Name" />
													<span class="input-group-btn" style="width:2px;"></span>
												</div>
												<div class="col-sm-4">
													<input type="text" class="form-control" data-bind="attr: {name:'relative['+($index()+$root.member_relatives2().length)+'][other_names]'}, value: other_names"   placeholder="Other Name" />
												</div>
											</div>
										</div>
									</div>
									<div class="col-lg-3">
										<div class="form-group">
											<label>Address</label>
											<input id=""  data-bind="attr: {name:'relative['+($index()+$root.member_relatives2().length)+'][address]'}, value: address" type="text" class="form-control " >
										</div>
									</div>
									<div class="col-lg-3">
										<div class="form-group">
											<label>Address 2</label>
											<input  type="text" class="form-control"  data-bind="attr: {name:'relative['+($index()+$root.member_relatives2().length)+'][address2]'}, value: address2">
										</div>
									</div>
									<div class="col-lg-3">
										<div class="form-group">
											<label>Phone </label>
											<input data-mask="(999) 999-9999" data-bind="attr: {name:'relative['+($index()+$root.member_relatives2().length)+'][telephone]'}, value: telephone" type="text" class="form-control ">
										</div>
									</div>
									<div class="col-lg-3"><span title="Remove relative" class="btn text-danger btn-lg" data-bind='click: $root.removeRelative'><i class="fa fa-minus"></i></span></div>
									<div class="clearboth"></div>
									
										
								</div>
								<div class="row">
									<div class="clearboth"></div>
									<div class="col-lg-12">
										 <div class="form-group">
											<span class="btn btn-info btn-sm pull-right" data-bind='click: addRelative'><i class="fa fa-plus"></i> Add more</span>
										</div>
									</div>
								</div>
								
							</fieldset>
							<h1>Dependants</h1>
							<fieldset>
								<div class="row">
									<div class="col-lg-6">
										<div class="form-group">
											<label>Number of Children </label>
											<input id="children_no" name="children_no" type="number" class="form-control">
										</div>
									</div>
									<div class="col-lg-6">
										<div class="form-group">
											<label>Number of Dependents</label>
											<input id="no_of_dependents" name="dependants_no" type="number" class="form-control ">
										</div>
									</div>
									
								</div>
								
							</fieldset>
							
							<h1>Finish</h1>
							<fieldset>
								<label>Comment</label>
								<textarea name="comment" class="form-control " rows="5"><?php echo $member_data['comment']; ?></textarea>
								
								<div class="row" style="margin-top:10px;">
									<div class="col-lg-12">
										<span class="alert-danger" id="accept_msg"></span>
										<div class="col-lg-1"><input id="acceptTerms" name="acceptTerms" type="radio" class="i-checks" required> </div><br/>
									<div class="col-lg-12">	<label for="acceptTerms">I Accept that all member details captured are correct.</label></div>
									</div>
								</div>
								
								<div class="col-lg-4">
									<button class="btn btn-lg btn-primary" type="submit">Update Member</button>
								</div>
							</fieldset>
						</form>
					</div>
				</div>
			</div>
		</div>
	</div>	
</div>	
