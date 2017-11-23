
<div id="edit_group" class="modal  fade" aria-hidden="true" >
	<div class="modal-dialog modal-lg" style="width: 900px !important;">
		<div class="modal-content">
			<div class="modal-body">
				
				<div class="ibox">
					<div class="ibox-title">
						<h1><strong>Update Group</strong></h1>
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
						<form id="register_group" name="update_group" class="wizard-big">
							<input name ="createdBy" type="hidden" value="<?php echo $_SESSION['personId']; ?>">
							<input name ="modifiedBy" type="hidden" value="<?php echo $_SESSION['personId']; ?>">
							<input name ="id" type="hidden" value="<?php echo $_GET['groupId']; ?>">
							<input name ="dateCreated" type="hidden" value="<?php echo time(); ?>">
							<input name ="tbl" type="hidden" value="update_group">
								
							<h1>Group Details</h1>
							<fieldset>
								<div class="row">
									<div class="col-lg-8">
										<div class="form-group">
											<label>Group Name *</label>
											<input  name="groupName" value="<?php echo $group_data['groupName']; ?>" type="text" class="form-control required">
										</div>
										<div class="form-group">
											<label>Group Description</label>
											<textarea  name="description" class="form-control "><?php echo $group_data['description']; ?> </textarea>
										</div>
									</div>
								</div>

							</fieldset>
							<h1>Group members</h1>
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
																<select data-bind='attr:{name:"members["+$index()+"][memberId]"}, options: $root.sacco_members, optionsText: "memberNames", optionsCaption: "Select member...", optionsAfterRender: $root.setOptionValue("id"), select2: {dropdownParent:"#edit_group" }' class="select2 form-control"  style="width: 250px"> </select>
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
							<div class="form-group">
								<div class="col-sm-6 col-sm-offset-3">
									<button class="btn btn-primary" type="submit" data-bind="enable:$root.group_members().length > 0">Update</button>
								</div>
							</div>
						</form>
					</div>
				</div>
			</div>
		</div>
	</div>
</div>
<script>
</script>