
<div id="add_loan_account-modal" class="modal fade" aria-hidden="true">
	<div class="modal-dialog modal-lg">
		<div class="modal-content">
			<div class="modal-body">
			<div class="row" id="loan_account_form">
                <div class="col-lg-12">
                    <div class="ibox float-e-margins">
                        <div class="ibox-title">
                            <h5>Loan Application <small>Create loan Account</small></h5>
                            <div class="ibox-tools">
                                <a class="" data-dismiss="modal">
                                    <i class="fa fa-times lg"></i>
                                </a>
                            </div>
                        </div>
                        <div class="ibox-content">
                            <form id="loanAccountForm" class="form-horizontal wizard-big">
                                <h1>Loan Account <small>Account Information</small></h1>
                                <fieldset>
                                    
									<div class="row">
										<?php 
										if(!isset($client)):?>
										<div class="form-group">
											<div class="col-md-6">
												<label class="control-label">Customer/Member Group</label>
												<div data-bind="if: $root.edit_client()==0">
													<select data-placeholder="Select customer/member group..." class="form-control chosen-select" data-bind='options: customers, optionsText: "clientNames", optionsCaption: "Select customer/member group...", optionsAfterRender: setOptionValue("id"), value: client' data-msg-required="Client name is required" required>
													</select>
												</div>
												<div data-bind="if: $root.edit_client()==1">
													<div data-bind='with: client'><span data-bind="text: clientNames"></span></div>
												</div>
											</div>
										</div>
										<?php endif;?>
										<div class="form-group">
											<div class="col-md-6" data-bind='with: client'>
												<label class="control-label">Product</label>
												<div data-bind="if: $root.edit_client()==0">
												<select class="form-control" id="loanProduct" name="loanProduct" data-bind='options: $root.filteredLoanProducts, optionsText: "productName", optionsCaption: "Select product...", optionsAfterRender: $root.setOptionValue("id"), value: $root.loanProduct' data-msg-required="Loan product is required" required>
												</select>
												<span class="help-block m-b-none" data-bind="with: $root.loanProduct">
												<small data-bind="text: description">Product description goes here.</small>
												</span>
												</div>
												<div data-bind="if: $root.edit_client()==1">
													<div data-bind='with: $root.loanProduct'><span data-bind="text: productName"></span>
													<span class="help-block m-b-none"><small data-bind="text: '('+description+')'"></small></span></div>
												</div>
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
													<input type="number"  class="athousand_separator form-control input-sm" name="requestedAmount" id="requestedAmount" data-bind='value: $root.requestedAmount, attr: {"data-rule-min":(parseFloat(minAmount)>0?minAmount:null), "data-rule-max": (parseFloat(maxAmount)>0?maxAmount:null), "data-msg-min":"Loan amount is less than "+curr_format(parseInt(minAmount)), "data-msg-max":"Loan amount is more than "+curr_format(parseInt(maxAmount)), value:defAmount}'/>
													<div>
														<label class="col-sm-2" data-bind="visible: parseFloat(minAmount)>0">Min</label>
														<label class="col-sm-4" data-bind="visible: parseFloat(minAmount)>0, text: curr_format(parseInt(minAmount))"></label>
														<label class="col-sm-2" data-bind='visible: parseFloat(maxAmount)>0'>Max</label>
														<label class="col-sm-4" data-bind="visible: parseFloat(maxAmount)>0, text: curr_format(parseInt(maxAmount))"></label>
													</div>
												</div>
												<label class="col-md-3 control-label">Interest Rate</label>
												<div class="col-md-3">
													<input type="number" class="form-control input-sm" name="interestRate" id="interestRate" data-bind='value: $root.interestRate, attr: {"data-rule-min":(parseFloat(minInterest)>0?minInterest:null), "data-rule-max": (parseFloat(maxInterest)>0?maxInterest:null), "data-msg-min":"Interest Rate is less than "+minInterest, "data-msg-max":"Interest Rate is more than "+maxInterest, value:defInterest}'/>
													<div>
														<label class="col-sm-2" data-bind="visible: parseFloat(minInterest)>0">Min</label>
														<label class="col-sm-4" data-bind="visible: parseFloat(minInterest)>0, text: minInterest"></label>
														<label class="col-sm-2" data-bind='visible: parseFloat(maxInterest)>0'>Max</label>
														<label class="col-sm-4" data-bind="visible: parseFloat(maxInterest)>0, text: maxInterest"></label>
													</div>
												</div>
											</div>
											<div class="hr-line-dashed"></div>
											<div class="form-group">
												<label class="col-md-3 control-label">First installment Offset Period <sup data-toggle="tooltip" title="Period of time before which a client can start paying up the loan amount" data-placement="right"><i class="fa fa-question-circle"></i></sup></label>
												<div class="col-md-3">
													<input type="number" class="form-control input-sm" name="offSetPeriod" id="offSetPeriod" data-bind='value: $root.offSetPeriod, attr: {"data-rule-min":(parseFloat(minOffSet)>0?minOffSet:null), "data-rule-max": (parseFloat(maxOffSet)>0?maxOffSet:null), "data-msg-min":"Offset period is less than "+minOffSet, "data-msg-max":"Offset period is more than "+maxOffSet, value:defOffSet}'>
													<div>
														<label class="col-sm-2" data-bind="visible: parseFloat(minOffSet)>0">Min</label>
														<label class="col-sm-4" data-bind="visible: parseFloat(minOffSet)>0, text: minOffSet"></label>
														<label class="col-sm-2" data-bind="visible: parseFloat(maxOffSet)>0">Max</label>
														<label class="col-sm-4" data-bind="visible: parseFloat(maxOffSet)>0, text: maxOffSet"></label>
													</div>
												</div>
												<label class="col-md-3 control-label">Grace Period <sup data-toggle="tooltip" title="Number of days the client is given to pay up upon default of the payment contract" data-placement="right"><i class="fa fa-question-circle"></i></sup></label>
												<div class="col-md-3">
													<input type="number" class="form-control input-sm" name="gracePeriod" id="gracePeriod" data-bind='value: $root.gracePeriod, attr: {"data-rule-min":(parseFloat(minGracePeriod)>0?minGracePeriod:null), "data-rule-max": (parseFloat(maxGracePeriod)>0?maxGracePeriod:null), "data-msg-min":"Grace Period is less than "+minGracePeriod, "data-msg-max":"Grace Period is more than "+maxGracePeriod, value:defGracePeriod}'>
													<div>
														<label class="col-sm-2" data-bind="visible: parseFloat(minGracePeriod)>0">Min</label>
														<label class="col-sm-4" data-bind="visible: parseFloat(minGracePeriod)>0, text: minGracePeriod"></label>
														<label class="col-sm-2" data-bind="visible: parseFloat(maxGracePeriod)>0">Max</label>
														<label class="col-sm-4" data-bind="visible: parseFloat(maxGracePeriod)>0, text: maxGracePeriod"></label>
													</div>
												</div>
											</div>
											<div class="hr-line-dashed"></div>
											<div class="form-group">
												<label class="col-md-3 control-label">Repayment Installments</label>
												<div class="col-md-3">
													<input type="number" class="form-control input-sm" name="installments" id="installments" data-bind='value: $root.installments, attr: {"data-rule-min":(parseFloat(minRepaymentInstallments)>0?minRepaymentInstallments:null), "data-rule-max": (parseFloat(maxRepaymentInstallments)>0?maxRepaymentInstallments:null), "data-msg-min":"Repayment Installments less than "+minRepaymentInstallments, "data-msg-max":"Repayment Installments more than "+maxRepaymentInstallments, value:defRepaymentInstallments}' required />
													<div>
														<label class="col-sm-2" data-bind="visible: parseFloat(minRepaymentInstallments)>0">Min</label>
														<label class="col-sm-4" data-bind="visible: parseFloat(minRepaymentInstallments)>0, text: minRepaymentInstallments"></label>
														<label class="col-sm-2" data-bind="visible: parseFloat(maxRepaymentInstallments)>0">Max</label>
														<label class="col-sm-4" data-bind="visible: parseFloat(maxRepaymentInstallments)>0, text: maxRepaymentInstallments"></label>
													</div>
												</div>
												<div class="col-md-6"><label class="control-label"></label><label>made every <span data-bind="text: repaymentsFrequency +' '+getDescription(4,repaymentsMadeEvery)"></span></label></div>
											</div>
										</div>
									</div>

                                </fieldset>
								<!--ko with: loanProduct -->
								<!--ko if: $root.filteredLoanProductFees().length>0 -->
								<h1>Loan Fees <small>Applicable Fees (<span data-bind="text: $root.filteredLoanProductFees().length"></span>)</small></h1>
								<fieldset>
									
									<div class="row">
										<div class="form-group">
											<div class="table-responsive">
												<table class="table table-condensed">
													<thead>
														<tr>
															<th>Choose</th>
															<th>Name</th>
															<th>Rate</th>
															<th>Rate As</th>
															<th>Amount(UGX)</th>
														</tr>
													</thead>
													<tbody data-bind="foreach: $root.filteredLoanProductFees">
														<tr>
															<td><input class="icheckbox_square-green" style="position: relative;" name="fee" type="checkbox" data-bind="checkedValue: $data, checked: $root.loanAccountFees" /></td>
															<td data-bind='text: feeName'></td>
															<td data-bind='text: curr_format(amount)'></td>
															<td data-bind='text: getDescription(5, $data.amountCalculatedAs)'></td>
															<td data-bind='text: getFeeAmount($root.requestedAmount(), amount, $data.amountCalculatedAs)'></td>
														</tr>
													</tbody>
												</table>
											</div>
										</div>
									</div>
								</fieldset>
								<!-- /ko -->
								<!-- /ko -->
								<!--ko with: loanProduct -->
								<!--ko if: ((parseInt($root.client().clientType)==1)&&$root.filteredGuarantors().length>0) -->
								<h1>Guarantors <small>Choose Guarantors</small></h1>
								<fieldset>
									
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
																<select data-bind='options: $root.filteredGuarantors, optionsText: "memberNames", optionsValue, "id", optionsCaption: "Select guarantor...", value: guarantor' class="form-control"> </select>
															</td>
															<td class='phone' data-bind='with: guarantor'>
																<span data-bind='text: phone' > </span>
															</td>
															<td class='shares' data-bind='with: guarantor'>
																<span data-bind='text: shares'> </span>
															</td>
															<td class='savings' data-bind='with: guarantor'>
																<span data-bind='text: savings'> </span>
																<input name="guarantor[]" data-bind='value: id' type="hidden"/>
															</td>
															<td>
																<span title="Remove item" class="btn text-danger" data-bind='click: $root.removeGuarantor'><i class="fa fa-minus"></i></span>
															</td>
														</tr>
													</tbody>
												</table>
											</div>
											<div class="col-sm-3">
											<a data-bind='click: $root.addGuarantor, enable: $root.selectedGuarantors().length < $root.loanProduct.minGuarantors' class="btn btn-info btn-sm"><i class="fa fa-plus"></i>Add Guarantor</a></div>
											<div class="col-sm-3">Minimum: <span data-bind='text: $root.loanProduct().minGuarantors'> </span></div>
											<div class="col-sm-3">Total shares: <span data-bind='text: $root.totalShares()'> </span></div>
											<div class="col-sm-3">Total savings: <span data-bind='text: $root.totalSavings()'> </span></div>
										</div>
									</div>
								</fieldset>
								<!-- /ko -->
								<!-- /ko -->
								<!--ko with: loanProduct -->
								<!--ko if: (parseInt($root.client().clientType)==1) -->
								<h1>Collateral <small>Add Collateral</small></h1>
								<fieldset>
									<div class="row">
										<div class="hr-line-dashed"></div>
										<div class="form-group" data-bind="visible: $root.addedCollateral().length > 0">
											<!--div class="col-md-12">
												<div class="col-sm-6">Total Collateral: UGX <span data-bind="text: curr_format($root.totalCollateral()), css: {'text-danger': $root.totalCollateral()<(($root.loanProduct().minCollateral/100)*($root.requestedAmount()+($root.requestedAmount()*$root.interestRate()/100))), 'text-info': $root.totalCollateral()>(($root.loanProduct().minCollateral/100)*(($root.requestedAmount()+$root.requestedAmount()*$root.interestRate()/100)))}"></span> <i  data-bind="css: {'fa fa-check text-info':$root.totalCollateral()>(($root.loanProduct().minCollateral/100)*($root.requestedAmount()+($root.requestedAmount()*$root.interestRate()/100)))}"></i></div>
												<div class="col-sm-6" class="text-info">
												Required Minimum: UGX <span data-bind='text: curr_format(parseInt(($root.loanProduct().minCollateral/100)*($root.requestedAmount()+($root.requestedAmount()*$root.interestRate()/100))))+" at a rate of "+$root.loanProduct().minCollateral+"%"'> </span>
												</div>
											</div>
											<div class="hr-line-dashed"></div-->
											<div class="table-responsive">
												<table class="table table-condensed">
													<thead>
														<tr>
															<th>Item Name</th>
															<th>Description</th>
															<th>Item Value</th>
															<th>Attachment</th>
															<th>&nbsp;</th>
														</tr>
													</thead>
													<tbody data-bind="foreach: $root.addedCollateral">
														<tr>
															<td><input class="form-control input-sm" name="itemName[]" data-bind='value: itemName' data-msg-required="Item name is required" required/></td>
															<td><textarea class="form-control input-sm" name="description[]" data-bind='value: description' required></textarea></td>
															<td><input class="form-control input-sm" name="itemValue[]" type="number" data-bind='value: itemValue' required/></td>
															<td><input class="input-sm" name="attachmentUrl[]" type="file" data-bind='value: attachmentUrl'/></td>
															<td><span title="Remove item" class="btn text-danger" data-bind='click: $root.removeCollateral'><i class="fa fa-minus"></i></span></td>
														</tr>
													</tbody>
												</table>
											</div>
										</div>
										<div class="form-group">
											<div class="col-sm-12">
											<span class="btn btn-info btn-sm pull-right" data-bind='click: $root.addCollateral'><i class="fa fa-plus"></i> Add Item</span>
											</div>
										</div>
									</div>
								</fieldset>
								<!-- /ko -->
								<!-- /ko -->
                                <div class="form-group">
                                    <div class="col-sm-6 col-sm-offset-2">
                                        <button class="btn btn-warning" type="reset">Cancel</button>
                                        <button class="btn btn-primary" type="submit" data-bind="enable: loanProduct">Submit</button>
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