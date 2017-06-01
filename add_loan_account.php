	<?php 
		$needed_files = array("iCheck", "jasny", "knockout" , "moment"  , "datepicker" /* , "steps", "chosen" */);
		$page_title = "New Loan Account";
		include("include/header.php"); 
		require_once("lib/Libraries.php");
	?>
			<div class="row" id="loan_account_form">
                <div class="col-lg-12">
                    <div class="ibox float-e-margins">
                        <div class="ibox-title">
                            <h5>Loan Application <small>Create loan Account</small></h5>
                        </div>
                        <div class="ibox-content">
                            <form id="loanAccountForm" class="form-horizontal wizard-big">
                                <h1>Loan Account</h1>
                                <fieldset>
                                    <h2>Account Information</h2>
									<div class="row">
										<div class="form-group">
										<?php if(!isset($client)):?>
											<div class="col-sm-6">
												<label class="control-label">Customer/Member Group</label>
													<select data-placeholder="Select customer/member group..." class="form-control chosen-select" data-bind='options: customers, optionsText: "clientNames", optionsCaption: "Select customer/member group...", optionsAfterRender: setOptionValue("id"), value: client' data-msg-required="Client name is required" required>
													</select>
											</div>
										<?php endif;?>
										</div>
										<div class="form-group">
											<div class="col-md-6" data-bind='with: client'>
												<label class="control-label">Product</label>
												<select class="form-control" id="loanProduct" name="loanProduct" data-bind='options: $root.filteredLoanProducts, optionsText: "productName", optionsCaption: "Select product...", optionsAfterRender: $root.setOptionValue("id"), value: $root.loanProduct' data-msg-required="Loan product is required" required>
												<span class="help-block m-b-none">
												<small data-bind="text: description">Product description goes here.</small>
												</span>
												</select>
											</div>
											<div class="col-md-6" data-bind="with: loanProduct">
												<div class="col-sm-2">
												</div>
												<div class="col-sm-4">
													<div>&nbsp;</div>
													<label class="control-label">Application Date</label>
												</div>
												<div class="col-sm-6">
													<label class="control-label">&nbsp;</label>
													<div class="input-group date" data-provide="datepicker" data-date-format="dd-mm-yyyy">
														<input type="text" class="form-control" name="applicationDate" id="applicationDate" data-bind='value: $root.applicationDate' required>
														<div class="input-group-addon">
															<span class="fa fa-calendar"></span>
														</div>
													</div>
												</div>
											</div>
										</div>
										<div data-bind="with: loanProduct">
											<div class="hr-line-dashed"></div>
											<div class="form-group">
												<label class="col-md-3 control-label">Loan Amount</label>
												<div class="col-md-3">
													<input type="number" class="form-control input-sm" name="requestedAmount" id="requestedAmount" data-bind='value: $root.requestedAmount, attr: {"data-rule-min":(parseFloat(minAmount)>0?minAmount:null), "data-rule-max": (parseFloat(maxAmount)>0?maxAmount:null), "data-msg-min":"Loan amount is less than "+minAmount, "data-msg-max":"Loan amount is more than "+maxAmount}'/>
													<div>
														<label class="col-sm-4" data-bind="visible: parseFloat(minAmount)>0">Min</label>
														<label class="col-sm-2" data-bind="visible: parseFloat(minAmount)>0, text: minAmount"></label>
														<label class="col-sm-4" data-bind='visible: parseFloat(maxAmount)>0'>Max</label>
														<label class="col-sm-2" data-bind="visible: parseFloat(maxAmount)>0, text: maxAmount"></label>
													</div>
												</div>
												<label class="col-md-3 control-label">Interest Rate</label>
												<div class="col-md-3">
													<input type="number" class="form-control input-sm" name="interestRate" id="interestRate" data-bind='value: $root.interestRate, attr: {"data-rule-min":(parseFloat(minInterest)>0?minInterest:null), "data-rule-max": (parseFloat(maxInterest)>0?maxInterest:null), "data-msg-min":"Interest Rate is less than "+minInterest, "data-msg-max":"Interest Rate is more than "+maxInterest}'/>
													<div>
														<label class="col-sm-4" data-bind="visible: parseFloat(minInterest)>0">Min</label>
														<label class="col-sm-2" data-bind="visible: parseFloat(minInterest)>0, text: minInterest"></label>
														<label class="col-sm-4" data-bind='visible: parseFloat(maxInterest)>0'>Max</label>
														<label class="col-sm-2" data-bind="visible: parseFloat(maxInterest)>0, text: maxInterest"></label>
													</div>
												</div>
											</div>
											<div class="hr-line-dashed"></div>
											<div class="form-group">
												<label class="col-md-3 control-label">First installment Offset Period <sup data-toggle="tooltip" title="Period of time before which a client can start paying up the loan amount" data-placement="right"><i class="fa fa-question-circle"></i><sup></label>
												<div class="col-md-3">
													<input type="number" class="form-control input-sm" name="offSetPeriod" id="offSetPeriod" data-bind='value: $root.offSetPeriod, attr: {"data-rule-min":(parseFloat(minOffSet)>0?minOffSet:null), "data-rule-max": (parseFloat(maxOffSet)>0?maxOffSet:null), "data-msg-min":"Offset period is less than "+minOffSet, "data-msg-max":"Offset period is more than "+maxOffSet}'>
													<div>
														<label class="col-sm-4" data-bind="visible: parseFloat(minOffSet)>0">Min</label>
														<label class="col-sm-2" data-bind="visible: parseFloat(minOffSet)>0, text: minOffSet"></label>
														<label class="col-sm-4" data-bind="visible: parseFloat(maxOffSet)>0">Max</label>
														<label class="col-sm-2" data-bind="visible: parseFloat(maxOffSet)>0, text: maxOffSet"></label>
													</div>
												</div>
												<label class="col-md-3 control-label">Grace Period <sup data-toggle="tooltip" title="Number of days the client is given to pay up upon default of the payment contract" data-placement="right"><i class="fa fa-question-circle"></i><sup></label>
												<div class="col-md-3">
													<input type="number" class="form-control input-sm" name="gracePeriod" id="gracePeriod" data-bind='value: $root.gracePeriod, attr: {"data-rule-min":(parseFloat(minGracePeriod)>0?minGracePeriod:null), "data-rule-max": (parseFloat(maxGracePeriod)>0?maxGracePeriod:null), "data-msg-min":"Grace Period is less than "+minGracePeriod, "data-msg-max":"Grace Period is more than "+maxGracePeriod}'>
													<div>
														<label class="col-sm-4" data-bind="visible: parseFloat(minGracePeriod)>0">Min</label>
														<label class="col-sm-2" data-bind="visible: parseFloat(minGracePeriod)>0, text: minGracePeriod"></label>
														<label class="col-sm-4" data-bind="visible: parseFloat(maxGracePeriod)>0">Max</label>
														<label class="col-sm-2" data-bind="visible: parseFloat(maxGracePeriod)>0, text: maxGracePeriod"></label>
													</div>
												</div>
											</div>
											<div class="hr-line-dashed"></div>
											<div class="form-group">
												<label class="col-md-3 control-label">Repayment Installments</label>
												<div class="col-md-3">
													<input type="number" class="form-control input-sm" name="installments" id="installments" data-bind='value: $root.installments, attr: {"data-rule-min":(parseFloat(minRepaymentInstallments)>0?minRepaymentInstallments:null), "data-rule-max": (parseFloat(maxRepaymentInstallments)>0?maxRepaymentInstallments:null), "data-msg-min":"Repayment Installments than "+minRepaymentInstallments, "data-msg-max":"Repayment Installments more than "+maxRepaymentInstallments}'>
													<div>
														<label class="col-sm-4" data-bind="visible: parseFloat(minRepaymentInstallments)>0">Min</label>
														<label class="col-sm-2" data-bind="visible: parseFloat(minRepaymentInstallments)>0, text: minRepaymentInstallments"></label>
														<label class="col-sm-4" data-bind="visible: parseFloat(maxRepaymentInstallments)>0">Max</label>
														<label class="col-sm-2" data-bind="visible: parseFloat(maxRepaymentInstallments)>0, text: maxRepaymentInstallments"></label>
													</div>
												</div>
												<div class="col-md-6"> </div>
											</div>
										</div>
									</div>

                                </fieldset>
								<!--ko with: loanProduct -->
								<h1>Loan Fees</h1>
								<fieldset>
									<h2>Applicable Fees</h2>
									<div class="row">
										<div class="form-group">
											<div class="table-responsive" data-bind="visible: $root.productFees().length > 0">
												<table class="table table-condensed">
													<thead>
														<tr>
															<th>Choose</th>
															<th>Name</th>
															<th>Amount(UGX)</th>
															<th>Fee Type</th>
															<th>Amount Calculated As</th>
														</tr>
													</thead>
													<tbody data-bind="foreach: $root.productFees">
														<tr>
															<td><input class="icheckbox_square-green" style="position: relative;" name="fee" type="checkbox" data-bind="checkedValue: $data, checked: $root.loanAccountFees" /></td>
															<td data-bind='text: feeName'></td>
															<td data-bind='text: curr_format(amount)'></td>
															<td data-bind='text: feeTypeName'></td>
															<td data-bind='text: getDescription(5, $data.amountCalculatedAs)'></td>
														</tr>
													</tbody>
												</table>
											</div>
										</div>
									</div>
								</fieldset>
								<!-- /ko -->
								<!--ko with: loanProduct -->
								<!--ko if: (parseInt($root.client.clientType)==1) -->
								<h1>Guarantors</h1>
								<fieldset>
									<h2>Choose Guarantors</h2>
									<div class="row">
										<div class="form-group">
											<div class="table-responsive">
												<table  class="table table-striped table-condensed table-hover">
													<thead>
														<tr>
															<th>Member</th>
															<th class='contact'>Phone</th>
															<th>Shares</th>
															<th>Savings</th>
															<th>&nbsp;</th>
														</tr>
													</thead>
													<tbody data-bind='foreach: $root.selectedGuarantors'>
														<tr>
															<td>
																<select data-bind='options: $root.filteredGuarantors, optionsText: "memberNames", optionsCaption: "Select guarantor...", value: guarantor' class="form-control"> </select>
															</td>
															<td class='phone' data-bind='with: guarantor'>
																<span data-bind='text: phone' > </span>
															</td>
															<td class='shares' data-bind='with: guarantor'>
																<span data-bind='text: shares'> </span>
															</td>
															<td class='savings' data-bind='with: guarantor'>
																<span data-bind='text: savings'> </span>
																<input name="guarantor[]" data-bind='value: person_number' type="hidden"/>
															</td>
															<td>
																<a href='#' data-bind='click: $root.removeGuarantor' title="Remove"><span class="fa fa-times red"></span></a>
															</td>
														</tr>
													</tbody>
												</table>
											</div>
											<div class="col-sm-3">
											<a data-bind='click: $root.addGuarantor, enable: $root.selectedGuarantors().length < $root.loanProduct.minGuarantors' class="btn btn-info btn-sm"><i class="fa fa-plus"></i>Add Guarantor</a></div>
											<div class="col-sm-3">Min <span data-bind='text: $root.loanProduct.minGuarantors'> </span></div>
											<div class="col-sm-3">Total shares: <span data-bind='text: $root.totalShares()'> </span></div>
											<div class="col-sm-3">Total savings: <span data-bind='text: $root.totalSavings()'> </span></div>
										</div>
									</div>
								</fieldset>
								<!-- /ko -->
								<!-- /ko -->
                                <div class="form-group">
                                    <div class="col-sm-4 col-sm-offset-2">
                                        <button class="btn btn-warning" type="reset">Cancel</button>
                                        <button class="btn btn-primary" type="submit" data-bind="enable: loanProduct">Submit</button>
                                    </div>
                                </div>
                            </form>
                        </div>
                    </div>
                </div>
            </div>	
<?php
 include("include/footer.php");
 require_once("js/loanAccount.php");
 ?>