<div id="add_group" class="modal  fade" aria-hidden="true" >
	<div class="modal-dialog modal-lg" style="width: 900px !important;">
		<div class="modal-content">
			<div class="modal-body">
				<div class="row">
					<div class="col-lg-12">
						<div class="ibox">
							<div class="ibox-title">
								<h2>
									Add Member Group
								</h2>
								<div class="ibox-tools">
									<a class="collapse-link">
										<i class="fa fa-chevron-up"></i>
									</a>
								</div>
							</div>
							<div class="ibox-content">
								
								<p>
									Valid group should have atleast two registered members
								</p>

								<form id="form" name="register_group" class="wizard-big">
									<input name ="createdBy" type="hidden" value="<?php echo $_SESSION['personId']; ?>">
									<input name ="modifiedBy" type="hidden" value="<?php echo $_SESSION['personId']; ?>">
									<input name ="dateCreated" type="hidden" value="<?php echo time(); ?>">
									<input name ="tbl" type="hidden" value="add_group">
										
									<h1>Group Details</h1>
									<fieldset>
										<div class="row">
											<div class="col-lg-8">
												<div class="form-group">
													<label>Group Name *</label>
													<input  name="groupName" type="text" class="form-control required">
												</div>
												<div class="form-group">
													<label>Group Description</label>
													<textarea  name="description" class="form-control "></textarea>
												</div>
											</div>
										</div>

									</fieldset>
									<h1>Group members</h1>
									<!--ko with: GroupMember -->
										<fieldset>
											<p>
												Attach members to this group
											</p>
											<div class="row">
												<div class="form-group">
													<div class="table-responsive">
														<table  class="table table-striped table-condensed table-hover">
															<thead>
																<tr>
																	<th>Member</th>
																	<th>&nbsp;</th>
																</tr>
															</thead>
															<tbody data-bind='foreach: $root.group_members'>
																<tr>
																	<td>
																		<select data-bind='attr:{name:"members["+$index()+"][memberId]"}, options: $root.sacco_members, optionsText: "memberNames", optionsCaption: "Select member...", optionsAfterRender: $root.setOptionValue("id")' class="form-control"> </select>
																	</td>
																	
																	<td>
																		<span title="Remove item" class="btn text-danger" data-bind='click: $root.removeMember'><i class="fa fa-minus"></i></span>
																	</td>
																</tr>
															</tbody>
														</table>
													</div>
													<div class="col-sm-3">
													<a data-bind='click: $root.addMember' class="btn btn-info btn-sm"><i class="fa fa-plus"></i> Add another member</a></div>
												</div>
											</div>
										</fieldset>
									<!-- /ko -->
									<div class="form-group">
										<div class="col-sm-6 col-sm-offset-3">
											<button class="btn btn-primary" type="submit">Submit</button>
										</div>
									</div>
								</form>
							</div>
						</div>
					</div>
				</div>
			</div>
		</div>
	</div>
</div>

            