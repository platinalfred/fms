<div id="approve_loan-modal" class="modal fade" aria-hidden="true">
	<div class="modal-dialog modal-lg">
		<div class="modal-content">
			<div class="modal-body">
				<div class="row">
					<div class="col-lg-12">
						<div class="ibox float-e-margins">
							<div class="ibox-title">
								<h5>Loan application approval <small>&nbsp;</small></h5>
								<div class="ibox-tools">
									<a data-dismiss="modal">
										<i class="fa fa-times"></i>
									</a>
								</div>
							</div>
							<div class="ibox-content">
								<div class="col-.lg-12" data-bind="with: account_details">
									<div class="col-md-12">
										<strong>Details</strong><br/>
										<i data-bind="css: {'fa':1, 'fa-male': clientType==1, 'fa-group': clientType==2}"></i> <span data-bind="text: clientNames"></span>  
										<!--ko if: clientType==1&&$parent.loan_account_details()-->,
										<i class="fa fa-mobile"></i> <span data-bind="text: $parent.loan_account_details().member_details.phone"></span>,  
										<i class="fa fa-at"></i> <span data-bind="text: $parent.loan_account_details().member_details.email"></span>,  
										<i class="fa fa-map-envelope-square"></i> <span data-bind="text: $parent.loan_account_details().member_details.postal_address">Kawempe, Kazo</span>
										<i class="fa fa-map-marker"></i> <span data-bind="text: $parent.loan_account_details().member_details.physical_address">Kawempe, Kazo</span>
										<!--/ko-->
									</div>
									<!--ko if: $parent.loan_account_details()-->
									<div class="col-md-12" data-bind="if: $parent.loan_account_details().guarantors">
										<strong>Guarantors</strong>
										<div class="table-responsive">
											<table class="table table-condensed">
												<thead>
													<tr>
														<th>Names</th>
														<th>Savings</th>
														<th>Shares</th>
														<th>Loans</th>
													</tr>
												</thead>
												<tbody data-bind="foreach: $parent.loan_account_details().guarantors">
													<tr>
														<td data-bind="text: memberNames"></td>
														<td data-bind="text: savings"></td>
														<td data-bind="text: shares"></td>
														<td data-bind="text: outstanding_loan"></td>
													</tr>
												</tbody>
												<tfoot>
													<tr>
														<th>Total (UGX)</th>
														<th data-bind="text: curr_format(parseInt(array_total($parent.loan_account_details().guarantors,2)">&nbsp;</th>
														<th data-bind="text: curr_format(parseInt(array_total($parent.loan_account_details().guarantors,3)">&nbsp;</th>
														<th data-bind="text: curr_format(parseInt(array_total($parent.loan_account_details().guarantors,4)"></th>
													</tr>
												</tfoot>
											</table>
										</div>
									</div>
									<div class="col-md-12" data-bind="if: $parent.loan_account_details().collateral_items">
										<strong>Collateral</strong>
										<div class="table-responsive">
											<table class="table table-condensed">
												<thead>
													<tr>
														<th>Item</th>
														<th>Description</th>
														<th>Item Value</th>
													</tr>
												</thead>
												<tbody data-bind="foreach: $parent.loan_account_details().collateral_items">
													<tr>
														<td data-bind="text: itemName"></td>
														<td data-bind="text: description"></td>
														<td data-bind="text: curr_format(parseInt(itemValue))"></td>
													</tr>
												</tbody>
												<tfoot>
													<tr>
														<th>Total</th>
														<th></th>
														<th data-bind="text: curr_format(parseInt(array_total($parent.loan_account_details().collateral_items,4)))"></th>
													</tr>
												</tfoot>
											</table>
										</div>
									</div>
									<div class="col-md-12" data-bind="if: $parent.loan_account_details().memberBusinesses">
										<strong>Business</strong>
										<div class="table-responsive">
											<table class="table table-condensed">
												<thead>
													<tr>
														<th>Business</th>
														<th>Type</th>
														<th>Location</th>
														<th>No. Employees</th>
														<th>URSB No.</th>
														<th>Business Worth</th>
													</tr>
												</thead>
												<tbody data-bind="foreach: $parent.loan_account_details().memberBusinesses">
													<tr>
														<td data-bind="text: businessName"></td>
														<td data-bind="text: natureOfBusiness"></td>
														<td data-bind="text: businessLocation"></td>
														<td data-bind="text: numberOfEmployees"></td>
														<td data-bind="text: ursbNumber"></td>
														<td data-bind="text: curr_format(parseInt(businessWorth))"></td>
													</tr>
												</tbody>
												<tfoot>
													<tr>
														<th>Total</th>
														<th colspan="4"></th>
														<th data-bind="text: curr_format(parseInt(array_total($parent.loan_account_details().memberBusinesses,5)))"></th>
													</tr>
												</tfoot>
											</table>
										</div>
									</div>
									<div class="col-md-12" data-bind="if: $parent.loan_account_details().relatives">
										<strong>Relatives</strong>
										<div class="table-responsive">
											<table class="table table-condensed">
												<thead>
													<tr>
														<th>Names</th>
														<th>Gender</th>
														<th>Relationship</th>
														<th>Contact</th>
														<th>Address</th>
													</tr>
												</thead>
												<tbody data-bind="foreach: $parent.loan_account_details().relatives">
													<tr>
														<td data-bind="text: first_name + ' ' + last_name + ' ' + other_names"></td>
														<td data-bind="text: relative_gender==1?'Male':'Female'"></td>
														<td data-bind="text: rel_type"></td>
														<td data-bind="text: telephone"></td>
														<td data-bind="text: address + ', ' + address2"></td>
													</tr>
												</tbody>
											</table>
										</div>
									</div>
									<div class="col-md-12" data-bind="if: $parent.loan_account_details().employmentHistory">
										<strong>Relatives</strong>
										<div class="table-responsive">
											<table class="table table-condensed">
												<thead>
													<tr>
														<th>Employer</th>
														<th>Years of employment</th>
														<th>Nature of employment</th>
													</tr>
												</thead>
												<tbody data-bind="foreach: $parent.loan_account_details().employmentHistory">
													<tr>
														<td data-bind="text: employer"></td>
														<td data-bind="text: years_of_employment"></td>
														<td data-bind="text: nature_of_employment"></td>
													</tr>
												</tbody>
											</table>
										</div>
									</div>
									<!--/ko-->
								</div>
								<hr/>
								<div>
									<form class="form-horizontal" id="loanAccountApprovalForm">
										<div class="col-md-5">
										  <div class="form-group" data-bind="with: account_details">
											<label class="control-label col-sm-6">Loan Product</label>
											<p class="col-sm-6" data-bind="text: productName"></p>
										  </div>
										  <div class="form-group" data-bind="with: account_details">
											<label class="control-label col-sm-6">Account No.</label>
											<p class="col-sm-6" data-bind="text: loanNo"></p>
										  </div>
										  <div class="form-group" data-bind="with: account_details">
											<label class="control-label col-sm-6">Amount requested</label>
											<p class="col-sm-6" data-bind="text: 'UGX ' + curr_format(parseInt(requestedAmount))"></p>
										  </div>
										</div>
										<div class="col-md-7">
										  <div class="form-group" data-bind="with: account_details">
											<label class="control-label col-sm-4">Approve/reject</label>
											<div class="col-sm-4">
												<label class="control-label text-danger"><input type="radio" name="status" value="2" data-bind="checked: $parent.applicationStatus"/> Rejected</label>
											</div>
											<div class="col-sm-4">
												<label class="control-label text-info"><input type="radio" name="status" value="3" data-bind="checked: $parent.applicationStatus" required data-msg-required="Please select option"/> Approved</label>
											</div>
										  </div>
										  <div class="form-group" data-bind="with: account_details">
											<label class="control-label col-sm-4" for="amountApproved">Amount approved<span class="required">*</span></label>
											<div class="col-sm-8">
											  <input type="number"  id="amountApproved" name="amountApproved" class="form-control col-sm-7" data-bind='value: $parent.amountApproved, attr: {"data-rule-max":parseInt(requestedAmount), "data-msg-max":"Amount cannot be greater than requested amount "+requestedAmount}' data-msg-required="Enter approved amount" required>
											</div>
										  </div>
										  <div class="form-group">
											<label class="control-label col-sm-4"></label>
											<div class="col-sm-8">
												<i><span data-bind="text: getWords(amountApproved())+' Uganda shillings only'"></span></i>
											</div>
										  </div>
										  <div class="form-group" data-bind="with: account_details">
											<label class="control-label col-sm-4" for="textarea">Justification </label>
											<div class="col-sm-8">
											  <textarea id="approvalNotes"  name="approvalNotes" class="form-control" data-bind="value: approvalNotes" required data-msg-required="Justification is required"></textarea>
											</div>
										  </div>
									  </div>
									  <div class="form-group">
										<div class="col-md-8 col-md-offset-4">
										  <button type="reset" class="btn btn-white">Cancel</button>
										  <button type="submit" class="btn btn-primary">Submit</button>
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
</div>