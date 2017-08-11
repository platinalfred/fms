<div id="add_expense" class="modal  fade" aria-hidden="true" >
	<div class="modal-dialog modal-lg" style="width: 900px !important;">
		<div class="modal-content">
			<div class="modal-body">
				<div class="row">
					<div class="col-lg-12">
						<div class="ibox">
							
							<div class="ibox-content">
								<form id="expense" name="register_expense" class="wizard-big">
									<input name="id"  type="hidden">
									<input name ="createdBy" type="hidden" value="<?php echo $_SESSION['personId']; ?>">
									<input name ="modifiedBy" type="hidden" value="<?php echo $_SESSION['personId']; ?>">
									<input name ="expenseDate" type="hidden" value="<?php echo time(); ?>">
									<input name ="tbl" type="hidden" value="add_expense">
										
									<h1>Add Expense Details</h1>
									<fieldset>
										<div class="row">
											<div class="col-lg-8">
												<div class="form-group">
													<label>Expense Name </label><label class="req">*</label>
													<input  name="expenseName" type="text" class="form-control required">
												</div>
												<div class="form-group">
													<label>Expense Type <span class="req">*</span></label>
													<?php $person->loadList("SELECT * FROM expensetypes", "expenseType", "id", "name"); ?>
													
												</div>
												<div class="form-group">
													<label>Staff </label><label class="req">*</label>
													<select class="form-control" name="staff">
														<option value="" >None selected</option>
														<?php 
														$person = new Person();
														$all_staff = $person->queryData("SELECT p.firstname, p.lastname, s.id as staff_id, p.id FROM staff s ,person p WHERE p.id = s.personId ");
														if($all_staff){ ?>
															
															<?php
															foreach($all_staff as $single){ ?>
																<option value="<?php echo $single['staff_id']; ?>" ><?php echo $single['firstname']." ".$single['lastname']; ?></option>
																<?php
															}
														}
														?>
													</select>
												</div>
												<div class="form-group">
													<label>Amount Used </label><label class="req">*</label>
													<input  name="amountUsed" type="text" class="athousand_separator form-control required">
												</div>
												<div class="form-group">
													<label>Description</label>
													<textarea  name="amountDescription" class="form-control "></textarea>
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

            