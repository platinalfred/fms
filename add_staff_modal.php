<style>
 
.wizard-big.wizard > .content{
	 min-height:440px !important;
}
.no_padding{
	padding-left:0px;
}
       
</style>

<div id="add_staff" class="modal  fade" aria-hidden="true" >
	<div class="modal-dialog modal-lg" style="width: 900px !important;">
		<div class="modal-content">
			<div class="modal-body">
				
				<div class="ibox">
					<div class="ibox-title">
						<h2><b>Add  Staff</b></h2>
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
						<form id="form" action="" method="post" name="registration"  class="wizard-big">
							<input type="hidden" name="registered_by" value="<?php echo $_SESSION['StaffId'];?>">
							<input type="hidden" name="added_by" value="<?php echo $_SESSION['StaffId'];?>">
							<input type="hidden" name="date_registered" value="<?php echo time();?>">
							<input type="hidden" name="person_type" value="1">
							<input type="hidden" name="tbl" value="add_staff">
							<h2>Login and staff bio information</h2>
							<fieldset>
								<div class="row">
									<div class="col-lg-11">
										<div class="col-lg-6 no_padding">
											<div class="form-group">
												<label class="col-sm-5 control-label no_padding">Title</label>
												<div class="col-sm-7">
													<select class="form-control m-b" name="title" required>
														<option value="">Choose option</option>
														<option value="Mr" >Mr</option>
														<option value="Mrs">Mrs</option>
														<option value="Dr">Dr</option>
														<option value="Prof">Prof</option>
														<option value="Eng">Eng</option>
													</select>
												</div>
											</div>
										</div>
										<div class="col-lg-6 no_padding">
											<div class="form-group">
												<label class="col-sm-3 control-label no_padding">Branch</label>
												<div class="col-sm-8">
													<select class="form-control m-b" name="branch_id" required >
														<option value="">Please select</option>
														<?php 
														$branch = new Branch();
														$branches = $branch->findAll();
														if($branches){
															foreach($branches as $single){ ?>
																<option value="<?php echo $single['id']; ?>" ><?php echo $single['branch_name']; ?></option>
																<?php
															}
														}
														?>
													</select>
												</div>
											</div>
										</div>
									</div>
									<div class="col-lg-11">
										<div class="col-sm-12">&nbsp;</div>
										<div class="col-lg-12 no_padding">
											<div class="form-group">
												<label class="control-label col-md-3 col-sm-3 col-xs-12 no_padding">User Name <span class="req">*</span></label>
												<div class="col-md-9 col-sm-9 col-xs-12">
													<input id="username" name="username" placeholder="user name" type="text" class="form-control" required>
												</div>
											</div>
										</div>
									</div>
									<div class="col-lg-11" style="margin-top:8px;">
										<div class="col-sm-12 no_padding" >
											<div class="form-group">
												<label class="control-label col-md-3 col-sm-3 col-xs-12 no_padding">Password <span class="req">*</span></label>
												<div class="col-md-9 col-sm-9 col-xs-12">
													<input  id="password" name="password" type="password" class="form-control" required>
												</div>
											</div>
										</div>
									</div>
									<div class="col-lg-11" style="margin-top:8px;">
										<div class="col-sm-12 no_padding" >
											<div class="form-group">
												<label class="control-label col-md-3 col-sm-3 col-xs-12 no_padding">Confirm Password <span class="req">*</span></label>
												<div class="col-md-9 col-sm-9 col-xs-12">
													<input id="password" name="password2"  type="password" class="form-control" required>
												</div>
											</div>
										</div>
									</div>
									<div class="col-lg-11">
										<div class="col-sm-12">&nbsp;</div>
										<div class="col-lg-5">
											<div class="col-sm-12">&nbsp;</div>
											<div class="form-group">
												<label class="col-sm-4 control-label no_padding">Position</label>
												<div class="col-sm-8">
													<select class="form-control m-b" name="position_id" required>
														<option value="">Please select</option>
														<?php 
														$position = new Position();
														$positions = $position->findAll();
														if($positions){
															foreach($positions as $single){ ?>
																<option value="<?php echo $single['id']; ?>" ><?php echo $single['name']; ?></option>
																<?php
															}
														}
														?>
													</select>
												</div>
											</div>
										</div>
										<div class="col-lg-7">
											<div class="form-group">
												<label class="col-sm-3 control-label">Access Level<br/><small class="text-navy">Staff rights will be limited to the access level(s) you assign.</small></label>
												<div class="col-sm-9">
													<?php 
													$access_level = new AccessLevel();
													$access_levels = $access_level->findAll();
													if($access_levels){
														foreach($access_levels as $single){ ?>
															<div class="i-checks"><label> <input name="access_levels[]" type="checkbox" value="<?php echo $single['id']; ?>" required> <i></i> <?php echo $single['name']; ?></label></div>
															<?php
														}
													}
													?>
												</div>
											</div>
										</div>
								
										<div class="col-lg-12">
											<div class="col-sm-12">&nbsp;</div>
											<div class="col-sm-12 no_padding">
												<div class="form-group">
													<div class="col-sm-3 no_padding">
														<label>Name <span class="req">*</span></label>
													</div>
													<div class="col-sm-9 input-group">
														<input type="text" class="form-control" name="lastname" placeholder="Sur Name" required />
														<span class="input-group-btn" style="width:2px;"></span>
														<input type="text" class="form-control" name="firstname" data-msg-require="Please enter name" placeholder="First Name" required/>
														
														<span class="input-group-btn" style="width:2px;"></span>
														<input type="text" class="form-control" name="othername"  placeholder="Other Name" />
													</div>
												</div>
											</div>
											<div class="col-sm-12 no_padding" style="margin-top:8px;margin-bottom:8px;">
												<div class="form-group">
													<div class="col-sm-3 no_padding"><label class="col-lg-12" >Gender</label></div>
													<div class="col-sm-9">
														<label > <input name="gender" class="i-checks" type="radio" value="M" >Male</label>
														<label > <input name="gender" class="i-checks" type="radio" value="F"> Female</label>
													</div>
												</div>											
													
											</div>
											<div class="col-sm-12 no_padding">
												<div class="form-group">
													<label class="col-sm-3 control-label no_padding" >Date of Birth <span class="req">*</span></label>
													<div class="col-sm-9">
														<input id="dateofbirth" name="dateofbirth" type="text" data-mask="99/99/9999" class="form-control" >
														<span class="help-block">(dd/mm/yyyy)</span>
													</div>
												</div>
											</div>
										</div>
									</div>
								</div>

							</fieldset>
							<h2>Identification  Information</h2>
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
															<option value="<?php echo $single['id']; ?>" ><?php echo $single['id_type']; ?></option>
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
												<input id="id_number" name="id_number" type="text" class="form-control" required>
											</div>
										</div>
									</div>
									
									<div class="col-lg-12">&nbsp;</div>
									<div class="col-lg-6">
										<div class="form-group">
											<label >Email </label>
											<input id="email" name="email" type="email" class="form-control ">
											
										</div>
									</div>
									<div class="col-sm-12 ">
											<div class="form-group">
												<div class="col-sm-3 no_padding">
													<label>Telephone <span class="req">*</span></label>
												</div>
												<div class="col-sm-9 input-group">
													<input id="phone" style="width:48%;" type="text" class="form-control" data-mask="(999) 999-9999" placeholder="(073) 000-0000" name="phone" required >
													<input id="phone" style="width:48%; margin-left:10px;" type="text" class="form-control" data-mask="(999) 999-9999" placeholder="(073) 000-0000" name="phone2"  ><span class="help-block"></span>
												</div>
											</div>
										</div>
								</div>
							</fieldset>
							<h2>Residential  Information</h2>
							<fieldset>
								<div class="row">
									<div class="col-lg-3">
										<div class="form-group">
											<label>Physical Address <span class="req">*</span></label>
											<input id="physical_address" name="physical_address" type="text" class="form-control" required>
										</div>
									</div>
									<div class="col-lg-3">
										<div class="form-group">
											<label>Postal Address</label>
											<input id="postal_address" name="postal_address" type="text" class="form-control ">
										</div>
									</div>
									<div class="col-lg-6">
										<div class="form-group">
											<label>District </label>
											<input id="" name="district" type="text" class="form-control">
										</div>
									</div>
									<div class="col-lg-6">
										<div class="form-group">
											<label>County </label>
											<input id="" name="county" type="text" class="form-control">
										</div>
									</div>
									<div class="col-lg-6">
										<div class="form-group">
											<label>Sub County </label>
											<input id="" name="subcounty" type="text" class="form-control">
										</div>
									</div>
									<div class="col-lg-6">
										<div class="form-group">
											<label>Parish </label>
											<input id="" name="parish" type="text" class="form-control">
										</div>
									</div>
									<div class="col-lg-6">
										<label class="control-label">Village</label>
										<input id="" name="village" type="text" class="form-control">
									</div>
								</div>
							</fieldset>
							
							<fieldset>
								<div class="col-lg-12 form-group">
								<label>Comment</label>
								<textarea name="comment" class="form-control " rows="5"></textarea>
								</div>
								
								<div class="col-lg-12 form-group">
									<span class="alert-danger" id="accept_msg"></span>
									<div class="col-lg-1"><input id="acceptTerms" name="acceptTerms" data-msg-require="Accept" type="checkbox" class="i-checks" required> </div>
									<div class="col-lg-10">	<label for="acceptTerms">I accept that all the above staff details are correct.</label></div>
								</div>
								
								
								<div class="col-lg-4 form-group">
									<button class="btn btn-xm btn-primary" type="submit">Submit Staff</button>
								</div>
							</fieldset>
						</form>
					</div>
				</div>
			</div>
		</div>
	</div>	
</div>	
