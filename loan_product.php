			<div class="row">
                <div class="col-lg-12">
                    <div class="ibox float-e-margins">
                        <div class="ibox-title">
                            <h5>Loan Product <small>Create loan product</small></h5>
                            <div class="ibox-tools">
                                <a class="" data-dismiss="modal">
                                    <i class="fa fa-times lg" style="color:red;"></i>
                                </a>
                                <!-- <a class="dropdown-toggle" data-toggle="dropdown" href="#">
                                    <i class="fa fa-wrench"></i>
                                </a>
                                <ul class="dropdown-menu dropdown-user">
                                    <li><a href="#">Config option 1</a>
                                    </li>
                                    <li><a href="#">Config option 2</a>
                                    </li>
                                </ul>
                                <a class="close-link">
                                    <i class="fa fa-times"></i>
                                </a> -->
                            </div>
                        </div>
                        <div class="ibox-content">
                            <form id="loanProductForm" class="form-horizontal">
                                <div class="form-group">
									<label class="col-sm-1 control-label" for="productName">Product Name</label>
                                    <div class="col-sm-4"><input type="text" class="form-control input-sm" name="productName" id="productName" data-bind="value: productName" data-msg-required="Product name is required" required></div>
									<label class="control-label col-sm-2">Description</label>
                                    <div class="col-sm-5">
                                        <textarea id="description" name="description" class="form-control required" data-msg-required="Product description is required" data-bind="value: description"> </textarea>
									</div>
                                </div>
                                <div class="hr-line-dashed"></div>
                                <div class="form-group">
									<label class="control-label col-sm-2">Availabe To</label>
                                    <div class="col-sm-4">
										<label class="checkbox-inline"> <input type="checkbox" value="1" id="availableToindividuals" name="availableTo" data-bind="checked: availableToCb"> Individual Clients </label> <label class="checkbox-inline">
                                        <input type="checkbox" value="2" id="availableToGroups" name="availableTo" data-bind="checked: availableToCb"> Groups </label>
									</div>

                                    <div class="col-sm-6">
										<label class="control-label">Type of Loan Product</label>
										<select class="form-control required" id="productType" name="productType" data-bind='options: productTypes, optionsText: "typeName", optionsCaption: "Select...", optionsAfterRender: setOptionValue("id"), value: productType' data-msg-required="Loan product type is required">
										</select>
										<div data-bind="with: productType"><span class="help-block-none"><small data-bind="text: description">Product description goes here.</small></span></div>
                                    </div>
                                </div>
                                <div class="hr-line-dashed"></div>
                                <div class="form-group">
										<label class="control-label col-sm-1">Product State</label>
                                    <div class="col-sm-2">
										<div class="i-checks"><label title="Select if this product should be made active"> <input type="checkbox" data-bind="checked: active" value="1"> <i></i> Active </label></div>
                                    </div>
									<label class="control-label col-sm-3">Initial Account State</label>
                                    <div class="col-sm-6">
										<select class="form-control required" id="initialAccountState" name="initialAccountState" data-bind='options: initialAccountStateOptions, optionsText: "desc", optionsCaption: "Select...", optionsAfterRender: setOptionValue("id"), value: initialAccountState' data-msg-required="Initial Account State is required">
										</select>
                                    </div>
                                </div>
                                <div class="hr-line-dashed"></div>
                                <div class="form-group">
									<div class="col-md-12">
										<div><label class="control-label">Loan Amount Constraints</label>
										</div>
										<div>
											<label class="col-sm-1 control-label">Default</label><div class="col-sm-3"><input type="number" class="form-control input-sm" name="defAmount" id="defAmount" data-bind="value: defAmount"></div><label class="col-sm-1 control-label">Min</label><div class="col-sm-3"><input type="number" class="form-control input-sm" id="minAmount" name="minAmount" data-bind="value: minAmount"></div><label class="col-sm-1 control-label">Max</label><div class="col-sm-3"><input type="number" class="form-control input-sm" name="maxAmount" id="maxAmount" data-bind="value: maxAmount"></div>
										</div>
									</div>
                                </div>
                                <div class="form-group">
									<label class="col-sm-2 control-label">Max Tranches <sup data-toggle="tooltip" title="Specify if the loan amount can be disbursed in multiple tranches" data-placement="right"><i class="fa fa-question-circle"></i><sup></label>

                                    <div class="col-sm-2"><input type="number" placeholder="days" class="form-control input-sm " name="maxTranches" id="maxTranches" data-bind="value: maxTranches" data-msg-required="Number of days is required"/></div><label class="col-sm-1 control-label"> #</label><div class="col-sm-6"></div>
                                </div>
                                <div class="hr-line-dashed"></div>
								<!--Found at https://support.mambu.com/customer/en/portal/articles/1162103-setting-up-new-loan-products -->
                                <div class="form-group">
									<div class="col-md-12">
										<div><label class="control-label">Interest Rate Constraints(%)</label>
										</div>
										<div>
											<label class="col-sm-1 control-label">Default</label><div class="col-sm-3"><input type="text" class="form-control input-sm" name="defInterest" id="defInterest" data-bind="value: defInterest" data-rule-min="0" data-rule-max="100"></div><label class="col-sm-1 control-label">Min</label><div class="col-sm-3"><input type="text" class="form-control input-sm" id="minInterest" name="minInterest" data-bind="value: minInterest" data-rule-min="0" data-rule-max="100"></div><label class="col-sm-1 control-label">Max</label><div class="col-sm-3"><input type="text" class="form-control input-sm" name="maxInterest" id="maxInterest" data-bind="value: maxInterest" data-rule-min="0" data-rule-max="100"></div>
										</div>
									</div>
                                </div>
                                <div class="hr-line-dashed"></div>
								<div><h3><i>Repayment scheduling</i></h3></div>
                                <div class="form-group">
									<div class="col-md-4">
										<p>Payment Interval Method: <strong>Interval</strong></p>
									</div>
									<div class="col-md-8">
											<label class="col-sm-6 control-label">Repayments are made every <sup data-toggle="tooltip" title='Suppose you want the repayments to be made every two weeks.Enter the number (2 in this example) > select "weeks" from the dropdown list. This will define the period between repayments.' data-placement='right' ><i class="fa fa-question-circle"></i></sup></label>
											<div class="col-sm-2"><input type="number" class="form-control input-sm" name="repaymentsFrequency" id="repaymentsFrequency" data-bind="value: repaymentsFrequency"></div>
											<div class="col-sm-4">
											<select class="form-control" id="repaymentsMadeEvery" name="repaymentsMadeEvery" data-bind='css: {required: repaymentsFrequency()}, optionsAfterRender: setOptionValue("id"), options: repaymentsMadeEveryOptions, optionsText: "desc", optionsCaption: "Select...", value: repaymentsMadeEvery' data-msg-required="Time unit is required">
											</select>
									</div>
                                </div>
                                <div class="form-group">
									<div class="col-md-12">
										<div><label class="control-label">Installments Constraints(#)</label>
										</div>
										<div>
											<label class="col-sm-1 control-label">Default</label><div class="col-sm-3"><input type="number" class="form-control input-sm" name="defRepaymentInstallments" id="defRepaymentInstallments" data-bind="value: defRepaymentInstallments"></div><label class="col-sm-1 control-label">Min</label><div class="col-sm-3"><input type="number" class="form-control input-sm" id="minRepaymentInstallments" name="minRepaymentInstallments" data-bind="value: minRepaymentInstallments"></div><label class="col-sm-1 control-label">Max</label><div class="col-sm-3"><input type="number" class="form-control input-sm" name="maxRepaymentInstallments" id="maxRepaymentInstallments" data-bind="value: maxRepaymentInstallments"></div>
										</div>
									</div>
                                </div>
                                <div class="hr-line-dashed"></div>
                                <div class="form-group">
									<div class="col-md-12">
										<div><label class="control-label">First Due Date Offset Constraints (days) <sup data-toggle="tooltip" title="Set the constraints for the number of offset days that can be established for the first repayment date when creating an account" data-placement="right"><i class="fa fa-question-circle"></i></sup></label>
										</div>
										<div>
											<label class="col-sm-1 control-label">Default</label><div class="col-sm-3"><input type="number" class="form-control input-sm" name="defOffSet" id="defOffSet" data-bind="value: defOffSet"></div><label class="col-sm-1 control-label">Min</label><div class="col-sm-3"><input type="number" class="form-control input-sm" id="minOffSet" name="minOffSet" data-bind="value: minOffSet"></div><label class="col-sm-1 control-label">Max</label><div class="col-sm-3"><input type="number" class="form-control input-sm" name="maxOffSet" id="maxOffSet" data-bind="value: maxOffSet"></div>
										</div>
									</div>
                                </div>
                                <div class="hr-line-dashed"></div>
                                <div class="form-group">
									<div class="col-md-12">
										<div><label class="control-label">Grace Period Constraints</label>
										</div>
										<div>
											<label class="col-sm-1 control-label">Default</label><div class="col-sm-3"><input type="number" class="form-control input-sm" name="defGracePeriod" id="defGracePeriod" data-bind="value: defGracePeriod"></div><label class="col-sm-1 control-label">Min</label><div class="col-sm-3"><input type="number" class="form-control input-sm" id="minGracePeriod" name="minGracePeriod" data-bind="value: minGracePeriod"></div><label class="col-sm-1 control-label">Max</label><div class="col-sm-3"><input type="number" class="form-control input-sm" name="maxGracePeriod" id="maxGracePeriod" data-bind="value: maxGracePeriod"></div>
										</div>
									</div>
                                </div>
                                <div class="hr-line-dashed"></div>
                                <div class="form-group">
										<label class="control-label col-sm-3">Minimum number of guarantors</label>
                                    <div class="col-sm-2">
										<input type="number" name="minGuarantors" id="minGuarantors" class="form-control input-sm" data-bind="value: minGuarantors" >
                                    </div>
										<label class="control-label col-sm-4">Minimum Collateral Amount Required</label>
                                    <div class="col-sm-3">
										<input type="number" name="minCollateral" id="minCollateral" data-bind="value: minCollateral" class="form-control input-sm">
                                    </div>
                                </div>
                                <div class="hr-line-dashed"></div>
                                <div class="form-group">
									<div class="col-sm-6">
											<div class="i-checks"><label> <input type="checkbox" data-bind="checked: linkToDepositAccount"> Link to Deposit Account <sup data-toggle="tooltip" title="Linking accounts allows you to have loan repayments being automatically made from a client's deposit account. Given that a deposit account is being used as source for repayments, on the day the repayment becomes due, the amount is automatically transferred from the deposit account as a repayment on the loan account" data-placement="right"><i class="fa fa-question-circle"></i><sup></label></div>
									</div>
									<div class="col-sm-6">
										<!--div class="i-checks"><label> <input type="checkbox" data-bind="checked: penaltyApplicable" value="1"> Penalties Applicable <sup data-toggle="tooltip" title="Select for more product penalty settings" data-placement="right"><i class="fa fa-question-circle"></i></sup></label></div-->
									</div>
                                </div>
                                <div class="hr-line-dashed"></div>
                                <div class="form-group">
                                    <div class="col-md-12">
										<label class="control-label col-sm-4">Penalty Calculation Method</label>
										<div class="col-sm-6">
											<select class="form-control required" id="penaltyCalculationMethod" name="penaltyCalculationMethod" data-bind='options: penaltyCalculationMethodOptions, optionsText: "methodDescription", optionsCaption: "Select...", optionsAfterRender: setOptionValue("id"), value: penaltyCalculationMethod' data-msg-required="Penalty Calculation Method is required">
										</select>
										</div>
										<div class="col-sm-2">
										</div>
                                    </div>
                                </div>
                                <div class="form-group" data-bind="visible: penCalcMethId">
                                    <div class="col-md-6">
										<label class="col-sm-6">Penalty Tolerance Period</label>
										<div class="col-sm-5"><input type="number" class="form-control input-sm" name="penaltyTolerancePeriod" id="penaltyTolerancePeriod" data-bind="value: penaltyTolerancePeriod"></div><label class="col-sm-1">Days</label>
                                    </div>
                                    <div class="col-md-6">
										<label class="col-sm-5">How is the penalty rate charged</label>
										<label class="col-sm-3">% per</label>
										<div class="col-sm-4">
											<select class="form-control" id="penaltyRateChargedPer" name="penaltyRateChargedPer" data-bind='css: {required: penaltyTolerancePeriod()}, options: taxRateSourceOptions, optionsText: "desc", optionsCaption: "Select...", optionsAfterRender: setOptionValue("id"), value: penaltyRateChargedPer'>
										</select>
										</div>
                                    </div>
                                </div>
                                <div class="form-group" data-bind="visible: penCalcMethId">
                                    <div class="col-md-4">
										<label class="control-label">Default Penalty Rate</label>
										<div class="col-sm-9"><input type="number" class="form-control input-sm" name="defPenaltyRate" id="defPenaltyRate" data-bind="value: defPenaltyRate" data-rule-min="0" data-rule-max="100"></div><label class="col-sm-1">%</label>
                                    </div>
                                    <div class="col-md-4">
										<label class="control-label">Min Penalty Rate</label>
										<div class="col-sm-9"><input type="number" class="form-control input-sm" id="minPenaltyRate" name="minPenaltyRate" data-bind="value: minPenaltyRate" data-rule-min="0" data-rule-max="100"></div><label class="col-sm-1">%</label>
                                    </div>
                                    <div class="col-md-4">
										<label class="control-label">Max Penalty Rate</label>
										<div class="col-sm-9"><input type="number" class="form-control input-sm" name="maxPenaltyRate" id="maxPenaltyRate" data-bind="value: maxPenaltyRate" data-rule-min="0" data-rule-max="100"></div><label class="col-sm-1">%</label>
                                    </div>
                                </div>
                                <div class="hr-line-dashed"></div>
                                <div class="form-group">
                                    <div class="col-sm-3">
										<label class="control-label">Tax Rate source</label>
                                    </div>
                                    <div class="col-sm-3">
										<select class="form-control" id="taxRateSource" name="taxRateSource" data-bind='options: taxRateSourceOptions, optionsText: "desc", optionsCaption: "Select...", optionsAfterRender: setOptionValue("id"), value: taxRateSource'>
										</select>
                                    </div>
                                    <div class="col-sm-3">
										<label class="control-label">Tax Calculation Method</label>
                                    </div>
                                    <div class="col-sm-3">
										<select class="form-control" id="taxCalculationMethod" name="taxCalculationMethod" data-bind='options: taxCalculationMethodOptions, optionsText: "desc", optionsCaption: "Select...", optionsAfterRender: setOptionValue("id"), value: taxCalculationMethod'>
										</select>
                                    </div>
                                </div>
                                </div>
                                <div class="hr-line-dashed"></div>
								<div class="form-group" data-bind="visible: existingLoanProductFees().length > 0">
									<div class="table-responsive">
										<table class="table table-condensed table-stripped">
											<thead>
												<tr>
													<th>Choose</th>
													<th>Name</th>
													<th>Amount, Flat(UGX)</th>
													<th>Fee Type</th>
													<th>Amount Calculated As</th>
													<th>Required Fee?</th>
												</tr>
											</thead>
											<tbody data-bind="foreach: $root.existingLoanProductFees">
												<tr>
													<td><input class="icheckbox_square-green" style="position: relative;" name="fee" type="checkbox" data-bind="attr:{value: id}, checked: $parent.productFee" /></td>
													<td data-bind='text: feeName'></td>
													<td data-bind='text: curr_format(amount)'></td>
													<td data-bind='text: feeTypeName'></td>
													<td data-bind='text: $root.getAmountCalculatedAsOption(amountCalculatedAs)'></td>
													<td data-bind='text: $root.requiredFunctionNot(requiredFee)'></td>
												</tr>
											</tbody>
										</table>
									</div>
								</div>
                                <div class="hr-line-dashed"></div>
								<div class="form-group" data-bind="visible: newLoanProductFees().length > 0">
									<div class="table-responsive">
										<table class="table table-condensed">
											<thead>
												<tr>
													<th>Name</th>
													<th>Amount, Flat(UGX)</th>
													<th>Fee Type</th>
													<th>Amount Calculated As</th>
													<th>Required Fee?</th>
													<th>&nbsp;</th>
												</tr>
											</thead>
											<tbody data-bind="foreach: $root.newLoanProductFees">
												<tr>
													<td><input class="form-control input-sm required" name="feeName[]" data-bind='value: feeName, uniqueName: true' data-msg-required="Fee name is required" required/></td>
													<td><input class="form-control input-sm required" name="amount[]" type="number" data-bind='value: amount' required/></td>
													<td><select class="form-control" id="feeType" name="feeType" data-bind='options: $parent.feeTypesOptions, optionsText: "description", optionsCaption: "Select...", , optionsAfterRender: $parent.setOptionValue("id"), value: feeType' data-msg-required="Fee type is required">
													</select></td>
													<td><select class="form-control " id="amountCalculatedAs" name="amountCalculatedAs" data-bind='options: $parent.amountCalculatedAsOptions, optionsText: "desc", , optionsAfterRender: $root.setOptionValue("id"), optionsCaption: "Select...", value: $parent.amountCalculatedAs'>
													</select><!-- to be used later , css: {required:id==2} --></td>
													<td><input class="form-control input-sm required" name="requiredFee[]" type="checkbox" data-bind='checked: requiredFee' required/></td>
													<td><span title="Remove fee" class="btn text-danger" data-bind='click: $root.removeFee'><i class="fa fa-minus"></i></span></td>
												</tr>
											</tbody>
										</table>
									</div>
                                </div>
                                <div class="form-group">
                                    <span class="btn btn-info btn-sm pull-right" data-bind='click: addFee'><i class="fa fa-plus"></i> New fee</span>
                                </div>
                                <div class="hr-line-dashed"></div>
                                <div class="form-group">
                                    <div class="col-sm-4 col-sm-offset-2">
                                        <button class="btn btn-warning" type="reset">Cancel</button>
                                        <button class="btn btn-primary" type="submit">Submit</button>
                                    </div>
                                </div>
                            </form>
                        </div>
                    </div>
                </div>
			</div>