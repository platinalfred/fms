<div class="row">
    <div class="col-lg-12">
        <div class="ibox float-e-margins">
            <div class="ibox-title">
                <h5>Loan Product <small>Create loan product</small></h5>
                <div class="ibox-tools">
                    <a class="" data-dismiss="modal">
                        <i class="fa fa-times lg" style="color:red;"></i>
                    </a>
                </div>
            </div>
            <div class="ibox-content">
                <form id="formLoanProduct" class="form-horizontal" >
                    <input type="hidden" name="id" data-bind="value: id"/>
                    <input type="hidden" name="tbl" value="tblLoanProduct"/>
                    <div class="form-group">
                        <label class="col-sm-2 control-label" for="productName">Product Name</label>
                        <div class="col-sm-4"><input type="text" class="form-control input-sm" name="productName" id="productName" data-msg-required="Product name is required" required></div>
                        <label class="control-label col-sm-1">Description</label>
                        <div class="col-sm-5">
                            <textarea id="description" name="description" class="form-control required" data-msg-required="Product description is required"> </textarea>
                        </div>
                    </div>
                    <div class="hr-line-dashed"></div>
                    <div class="form-group">

                        <div class="col-sm-6">
                            <label class="control-label">Available To</label>
                            <select class="form-control required" id="availableTo" name="availableTo" data-bind='options: clientTypes, optionsText: "clientTypeName", optionsCaption: "Select...", optionsAfterRender: setOptionValue("id")' data-msg-required="Select an option">
                            </select>
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
                        <label class="control-label col-sm-2">Product State</label>
                        <div class="col-sm-2">
                            <select class="form-control required" name="active" value="1">
                                <option value="1">Active</option>
                                <option value="0">Inactive</option>
                            </select>
                        </div>
                        <label class="control-label col-sm-3">Initial Account State</label>
                        <div class="col-sm-5">
                            <select class="form-control required" id="initialAccountState" name="initialAccountState" data-bind='options: initialAccountStateOptions, optionsText: "desc", optionsCaption: "Select...", optionsAfterRender: setOptionValue("id")' data-msg-required="Initial Account State is required">
                            </select>
                        </div>
                    </div>
                    <div class="hr-line-dashed"></div>
                    <div class="form-group">
                        <div class="col-md-12">
                            <div><label class="control-label">Loan Amount Constraints</label>
                            </div>
                            <div>
                                <label class="col-sm-1 control-label">Default</label>
                                <div class="col-sm-3"><input type="number" class="form-control input-sm" name="defAmount" id="defAmount"></div>
                                <label class="col-sm-1 control-label">Min</label>
                                <div class="col-sm-3"><input type="number" class="form-control input-sm" id="minAmount" name="minAmount"></div>
                                <label class="col-sm-1 control-label">Max</label>
                                <div class="col-sm-3"><input type="number" class="form-control input-sm" name="maxAmount" id="maxAmount"></div>
                            </div>
                        </div>
                    </div>
                    <div class="form-group">
                        <label class="col-sm-2 control-label">Max Tranches <sup data-toggle="tooltip" title="Specify if the loan amount can be disbursed in multiple tranches" data-placement="right"><i class="fa fa-question-circle"></i></sup></label>

                        <div class="col-sm-2">
                            <input type="number" placeholder="tranches" class="form-control input-sm " name="maxTranches" id="maxTranches" data-msg-required="Number of trenches is required"/>
                        </div>
                        <label class="col-sm-1 control-label"> #</label>
                        <div class="col-sm-6"></div>
                    </div>
                    <div class="hr-line-dashed"></div>
                    <!--Found at https://support.mambu.com/customer/en/portal/articles/1162103-setting-up-new-loan-products -->
                    <div class="form-group">
                        <div class="col-md-12">
                            <div><label class="control-label">Interest Rate Constraints(% p.a)</label>
                            </div>
                            <div>
                                <label class="col-sm-1 control-label">Default</label>
                                <div class="col-sm-3">
                                    <input  type="number" class="form-control input-sm" name="defInterest" id="defInterest" data-rule-min="0" data-rule-max="999">
                                </div>
                                <label class="col-sm-1 control-label">Min</label>
                                <div class="col-sm-3">
                                    <input type="number" class="form-control input-sm" id="minInterest" name="minInterest" data-rule-min="0" data-rule-max="999">
                                </div>
                                <label class="col-sm-1 control-label">Max</label>
                                <div class="col-sm-3">
                                    <input type="number" class="form-control input-sm" name="maxInterest" id="maxInterest" data-rule-min="0" data-rule-max="999">
                                </div>
                            </div>
                        </div>
                    </div>
                    <div class="hr-line-dashed"></div>
                    <div><h3><i>Repayment scheduling</i></h3></div>
                    <div class="form-group">
                        <div class="col-md-3">
                            <p>Payment Interval Method: <strong>Interval</strong></p>
                        </div>
                        <div class="col-md-9">
                            <label class="col-sm-5 control-label">
                                Repayments are made every 
                                <sup data-toggle="tooltip" title='Suppose you want the repayments to be made every two weeks.Enter the number (2 in this example) > select "weeks" from the dropdown list. This will define the period between repayments.' data-placement='right' ><i class="fa fa-question-circle"></i></sup>
                            </label>
                            <div class="col-sm-3">
                                <input type="number" class="form-control input-sm" name="repaymentsFrequency" id="repaymentsFrequency" data-bind="value: repaymentsFrequency" data-msg-min="Number must be greater than 0" data-rule-min="1" data-msg-required="Enter a number" required />
                            </div>
                            <div class="col-sm-4">
                                <select class="form-control" id="repaymentsMadeEvery" name="repaymentsMadeEvery" data-bind='css: {required: repaymentsFrequency()}, optionsAfterRender: setOptionValue("id"), options: repaymentsMadeEveryOptions, optionsText: "desc", optionsCaption: "Select..."' data-msg-required="Time unit is required" required >
                                </select>
                            </div>
                        </div>
                        <div class="form-group">
                            <div class="col-md-12">
                                <div><label class="control-label">Installments Constraints(#)</label>
                                </div>
                                <div>
                                    <label class="col-sm-1 control-label">Default</label>
                                    <div class="col-sm-3">
                                        <input type="number" class="form-control input-sm" name="defRepaymentInstallments" id="defRepaymentInstallments" >
                                    </div>
                                    <label class="col-sm-1 control-label">Min</label>
                                    <div class="col-sm-3">
                                        <input type="number" class="form-control input-sm" id="minRepaymentInstallments" name="minRepaymentInstallments">
                                    </div>
                                    <label class="col-sm-1 control-label">Max</label>
                                    <div class="col-sm-3">
                                        <input type="number" class="form-control input-sm" name="maxRepaymentInstallments" id="maxRepaymentInstallments">
                                    </div>
                                </div>
                            </div>
                        </div>
                        <div class="hr-line-dashed"></div>
                        <div class="form-group">
                            <div class="col-md-12">
                                <div>
                                    <label class="control-label">First Due Date Offset Constraints (days) <sup data-toggle="tooltip" title="Set the constraints for the number of offset days that can be established for the first repayment date when creating an account" data-placement="right"><i class="fa fa-question-circle"></i></sup></label>
                                </div>
                                <div>
                                    <label class="col-sm-1 control-label">Default</label>
                                    <div class="col-sm-3">
                                        <input type="number" class="form-control input-sm" name="defOffSet" id="defOffSet">
                                    </div>
                                    <label class="col-sm-1 control-label">Min</label>
                                    <div class="col-sm-3">
                                        <input type="number" class="form-control input-sm" id="minOffSet" name="minOffSet">
                                    </div>
                                    <label class="col-sm-1 control-label">Max</label>
                                    <div class="col-sm-3">
                                        <input type="number" class="form-control input-sm" name="maxOffSet" id="maxOffSet">
                                    </div>
                                </div>
                            </div>
                        </div>
                        <div class="hr-line-dashed"></div>
                        <div class="form-group">
                            <div class="col-md-12">
                                <div>
                                    <label class="control-label">Grace Period Constraints</label>
                                </div>
                                <div>
                                    <label class="col-sm-1 control-label">Default</label>
                                    <div class="col-sm-3">
                                        <input type="number" class="form-control input-sm" name="defGracePeriod" id="defGracePeriod">
                                    </div>
                                    <label class="col-sm-1 control-label">Min</label>
                                    <div class="col-sm-3">
                                        <input type="number" class="form-control input-sm" id="minGracePeriod" name="minGracePeriod">
                                    </div>
                                    <label class="col-sm-1 control-label">Max</label>
                                    <div class="col-sm-3">
                                        <input type="number" class="form-control input-sm" name="maxGracePeriod" id="maxGracePeriod">
                                    </div>
                                </div>
                            </div>
                        </div>
                        <div class="hr-line-dashed"></div>
                        <div class="form-group">
                            <label class="control-label col-sm-3">Minimum number of guarantors</label>
                            <div class="col-sm-2">
                                <input type="number" name="minGuarantors" id="minGuarantors" class="form-control input-sm" >
                            </div>
                            <label class="control-label col-sm-4">Minimum Collateral Amount Required (%)</label>
                            <div class="col-sm-3">
                                <input type="number" name="minCollateral" id="minCollateral" class="form-control input-sm" data-rule-min="0" data-rule-max="100">
                            </div>
                        </div>
                        <div class="hr-line-dashed"></div>
                        <div class="form-group">
                            <div class="col-sm-6">
                                <div>
                                    <label>
                                        <input type="checkbox" value="1"> Link to Deposit Account
                                        <sup data-toggle="tooltip" title="Linking accounts allows you to have loan repayments being automatically made from a client's deposit account. Given that a deposit account is being used as source for repayments, on the day the repayment becomes due, the amount is automatically transferred from the deposit account as a repayment on the loan account" data-placement="right">
                                            <i class="fa fa-question-circle"></i>
                                        </sup>
                                    </label>
                                </div>
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
                                    <select class="form-control required" id="penaltyCalculationMethodId" name="penaltyCalculationMethodId" data-bind='options: penaltyCalculationMethodOptions, optionsText: "methodDescription", optionsCaption: "Select...", optionsAfterRender: setOptionValue("id"), value: penaltyCalculationMethod' data-msg-required="Penalty Calculation Method is required">
                                    </select>
                                </div>
                                <div class="col-sm-2">
                                </div>
                            </div>
                        </div>
                        <div class="form-group" data-bind="visible: (typeof penaltyCalculationMethod() !== 'undefined'&&penaltyCalculationMethod().id==1)">
                            <div class="col-md-6">
                                <label class="col-sm-6">Penalty Tolerance Period</label>
                                <div class="col-sm-5"><input type="number" class="form-control input-sm" name="penaltyTolerancePeriod" id="penaltyTolerancePeriod" data-bind="value: penaltyTolerancePeriod" data-msg-required="Field is required" required /></div><label class="col-sm-1">Days</label>
                            </div>
                            <div class="col-md-6">
                                <label class="col-sm-5">How is the penalty rate charged</label>
                                <label class="col-sm-3">% per</label>
                                <div class="col-sm-4">
                                    <select class="form-control" id="penaltyRateChargedPer" name="penaltyRateChargedPer" data-bind='css: {required: penaltyTolerancePeriod()}, options: penaltyChargeRate, optionsText: "desc", optionsCaption: "Select...", optionsAfterRender: setOptionValue("id")' data-msg-required="Period is required" required >
                                    </select>
                                </div>
                            </div>
                        </div>
                        <div class="form-group" data-bind="visible: (typeof penaltyCalculationMethod() !== 'undefined'&&penaltyCalculationMethod().id==1)">
                            <div class="col-md-4">
                                <label class="control-label">Default Penalty Rate</label>
                                <div class="col-sm-9"><input type="text" class="form-control input-sm" name="defPenaltyRate" id="defPenaltyRate" data-rule-min="0" data-rule-max="100" required /></div><label class="col-sm-1">%</label>
                            </div>
                            <div class="col-md-4">
                                <label class="control-label">Min Penalty Rate</label>
                                <div class="col-sm-9"><input type="text" class="form-control input-sm" id="minPenaltyRate" name="minPenaltyRate" data-rule-min="0" data-rule-max="100"/></div><label class="col-sm-1">%</label>
                            </div>
                            <div class="col-md-4">
                                <label class="control-label">Max Penalty Rate</label>
                                <div class="col-sm-9"><input type="text" class="form-control input-sm" name="maxPenaltyRate" id="maxPenaltyRate" data-rule-min="0" data-rule-max="100"/></div><label class="col-sm-1">%</label>
                            </div>
                        </div>
                        <div class="hr-line-dashed"></div>
                        <!-- TEMPORARILY ADDED FOR TAXES-->
                        <!--<input type="hidden" name="taxRateSource">
                        <input type="hidden" name="taxCalculationMethod">
                        
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
</div>-->
                    </div>
                    <div class="hr-line-dashed"></div>
                    <!--ko if: existingLoanProductFees().length > 0 || existingLoanProductFees().length > 0-->
                    <div class="form-group">
                        <div class="table-responsive">
                            <table class="table table-condensed table-stripped">
                                <thead>
                                    <tr>
                                        <th>Loan Fee</th>
                                        <th>Fee Type</th>
                                        <th>Amount Calculated As</th>
                                        <th>Rate/Amount</th>
                                        <th>Required Fee?</th>
                                        <th>&nbsp;</th>
                                    </tr>
                                </thead>
                                <tbody>
                                <!--ko foreach: addExistingLoanProductFees -->
                                    <tr>
                                        <td>
                                            <span data-bind='text: feeName'> </span>
                                            <!-- The hidden input is applicable in the case when we are editing the product, when this field is visible it implies this is for editing-->
                                            <input type="hidden" data-bind="value: id" name="existingLoanProductFees[]"/>
                                        </td>
                                        <td data-bind="text: feeTypeName">
                                        </td>
                                        <td data-bind='text: getAmountCalculatedAsOption(amountCalculatedAs)'></td>
                                        <td data-bind='text: curr_format(amount)'></td>
                                        <td data-bind='text: parseInt(requiredFee)===0?"No":"Yes"'></td>
                                        <td title="Remove fee" class="btn text-danger" data-bind='click: $root.removeExistingFee'><i class="fa fa-minus"></i></td>
                                    </tr>
                                <!--/ko-->
                                <!--ko if: filteredExistingLoanProductFees().length -->
                                <!--ko foreach: newLoanProductFees -->
                                    <tr>
                                        <td>
                                            <select class="form-control" data-bind="options: $parent.filteredExistingLoanProductFees(), optionsText: 'feeName', optionsAfterRender: setOptionValue('id'), optionsCaption: 'Select...', attr: {name:'newLoanProductFees['+$index()+'][loanProductFeeId]'}, value: productFee">
                                            </select>
                                        </td>
                                        <td data-bind='with: productFee'>
                                            <span data-bind='text: feeTypeName'>
                                            </span>
                                        </td>
                                        <td data-bind='with: productFee'><span data-bind='text: getAmountCalculatedAsOption(amountCalculatedAs)'></span></td>
                                        <td data-bind='with: productFee'><span data-bind='text: curr_format(amount)'></span></td>
                                        <td data-bind='with: productFee'><span data-bind='text: parseInt(requiredFee)===0?"No":"Yes"'></span></td>
                                        <td title="Remove fee" class="btn text-danger" data-bind='click: $root.removeNewFee'><i class="fa fa-minus"></i></td>
                                    </tr>
                                <!--/ko-->
                                <!--/ko-->
                                </tbody>
                            </table>
                        </div>
                    </div>
					<!--ko if: filteredExistingLoanProductFees().length -->
                    <div class="form-group">
                        <span class="btn btn-info btn-sm pull-right" data-bind='click: addNewFee'><i class="fa fa-plus"></i> Add fee</span>
                    </div>
                                <!--/ko-->
                    <!--/ko-->
                    <div class="hr-line-dashed"></div>
                    <div class="form-group">
                        <div class="col-sm-4 col-sm-offset-2">
                            <button class="btn btn-warning" type="reset">Cancel</button>
                            <button class="btn btn-primary save" type="submit">Submit</button>
                        </div>
                    </div>
                </form>
            </div>
        </div>
    </div>
</div>