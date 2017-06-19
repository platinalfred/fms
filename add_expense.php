<div id="add_expense" class="modal  fade" aria-hidden="true" >
	<div class="modal-dialog modal-lg" style="width: 900px !important;">
		<div class="modal-content">
			<div class="modal-body">
				<div class="row">
					<div class="col-lg-12">
						<div class="ibox">
							<div class="ibox-title">
								<h2>
									Add Expense
								</h2>
								<div class="ibox-tools">
									<a class="collapse-link">
										<i class="fa fa-chevron-up"></i>
									</a>
								</div>
							</div>
							<div class="ibox-content">
								<form id="form" name="register_group" class="wizard-big">
									<input name ="createdBy" type="hidden" value="<?php echo $_SESSION['personId']; ?>">
									<input name ="modifiedBy" type="hidden" value="<?php echo $_SESSION['personId']; ?>">
									<input name ="dateCreated" type="hidden" value="<?php echo time(); ?>">
									<input name ="tbl" type="hidden" value="add_expense">
										
									<h1>Expense Details</h1>
									<fieldset>
										<div class="row">
											<div class="col-lg-8">
												<div class="form-group">
													<label>Expense Type *</label>
													<?php $person->loadList("SELECT * FROM expensetypes", "expense_type", "id", "name"); ?>
													
												</div>
												<div class="form-group">
													<label>Staff *</label>
													<select class="form-control" name="staff">
														<?php 
														$person = new Person();
														$all_staff = $person->queryData("SELECT p.firstname, p.lastname, p.id FROM staff s ,person p WHERE p.id = s.personId");
														if($all_staff){
															foreach($all_staff as $single){ ?>
																<option value="<?php echo $single['id']; ?>" ><?php echo $single['firstname']." ".$single['lastname']; ?></option>
																<?php
															}
														}
														?>
													</select>
												</div>
												<div class="form-group">
													<label>Amount Used *</label>
													<input  name="groupName" type="text" class="form-control required">
												</div>
												<div class="form-group">
													<label>Description</label>
													<textarea  name="description" class="form-control "></textarea>
												</div>
											</div>
										</div>

									</fieldset>
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

            