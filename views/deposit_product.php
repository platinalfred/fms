<div class="row">
    <div class="col-lg-12">
        <div class="ibox float-e-margins">
            <div class="ibox-title">
                <h5>Deposit Product <small>Create deposit product</small></h5>
                <div class="ibox-tools">
                    <a class="" data-dismiss="modal">
                        <i class="fa fa-times lg" style="color:red;"></i>
                    </a>
                </div>
            </div>
            <div class="ibox-content">
                <form id="formDepositProduct" class="form-horizontal">
                    <input type="hidden" name="id" id="id" data-bind="value: id"/>
                    <input type="hidden" name="tbl" value="tblDepositProduct"/>
                    <div class="form-group">
                        <label class="col-sm-2 control-label" for="productName">Product Name</label>
                        <div class="col-sm-3"><input type="text" class="form-control input-sm" name="productName" id="productName" data-msg-required="Product name is required" required></div>
                        <label class="control-label col-sm-1">Description</label>
                        <div class="col-sm-6">
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
                            <label class="control-label">Type of Deposit Product</label>
                            <select class="form-control" id="productType" name="productType" data-bind='options: productTypes, optionsText: "typeName", optionsCaption: "Select...", optionsAfterRender: setOptionValue("id"), value: productType' data-msg-required="Deposit product type is required">
                            </select>
                            <div data-bind="with: productType"><span class="help-block-none"><small data-bind="text: description">Product description goes here.</small></span></div>
                        </div>
                    </div>
                    <div class="hr-line-dashed"></div>
                    <div class="form-group">
                        <label class="control-label col-sm-3">Recommended Deposit Amount</label>
                        <div class="col-sm-3">
                            <input type="number" name="recommededDepositAmount" id="recommededDepositAmount" class="form-control input-sm" >
                        </div>
                        <label class="control-label col-sm-3">Maximum Withdrawal Amount</label>
                        <div class="col-sm-3">
                            <input type="number" name="maxWithdrawalAmount" id="maxWithdrawalAmount" class="form-control input-sm">
                        </div>
                    </div>
                    <div class="hr-line-dashed"></div>
                    <div class="form-group">
                        <div class="col-sm-12">
                            <div>
                                <label>
                                    <input type="checkbox" value="checked: interestRateApplicable" data-bind="checked: interestRateApplicable"/> Interest paid into account 
                                    <sup data-toggle="tooltip" title="Select if interest should be paid into the account" data-placement="right">
                                        <i class="fa fa-question-circle"></i></sup>
                                </label>
                            </div>
                        </div>
                    </div>
                    <div class="form-group" data-bind="visible: interestRateApplicable">
                        <div class="col-md-12">
                            <div><label class="control-label">Interest Rate Constraints</label>
                            </div>
                            <div>
                                <label class="col-sm-1 control-label">Default</label>
                                <div class="col-sm-3">
                                    <input type="number" class="form-control input-sm" name="defaultInterestRate" id="defaultInterest" data-bind="value: defaultInterestRate">
                                </div>
                                <label class="col-sm-1 control-label">Min</label>
                                <div class="col-sm-3">
                                    <input type="number" class="form-control input-sm" id="minInterest" name="minInterestRate" data-bind="value: minInterestRate">
                                </div>
                                <label class="col-sm-1 control-label">Max</label>
                                <div class="col-sm-3">
                                    <input type="number" class="form-control input-sm" name="maxInterestRate" id="maxInterest" data-bind="value: maxInterestRate">
                                </div>
                            </div>
                        </div>
                    </div>
                    <div class="form-group" data-bind="visible: interestRateApplicable">
                        <label class="col-sm-1 control-label">Per</label>
                        <div class="col-sm-2">
                            <input type="number" placeholder="days" class="form-control input-sm " name="perNoOfDays" id="perNoOfDays" data-bind="css: {required:reqAttr()}, value: perNoOfDays"  data-msg-required="Number of days is required"/>
                        </div>
                        <label class="col-sm-1 control-label"> Days</label>
                        <div class="col-sm-8"></div>
                    </div>
                    <div class="form-group" data-bind="visible: interestRateApplicable">
                        <div class="col-sm-4">
                            <label class="control-label">What account balance is used for calculations</label>
                            <select class="form-control" id="accountBalForCalcInterest" name="accountBalForCalcInterest" data-bind='options: dropDowns.accountBalForCalcInterestOptions, optionsText: "desc", optionsCaption: "Select...", optionsAfterRender: setOptionValue("id"), value: accountBalForCalcInterest'>
                            </select>
                        </div>
                        <div class="col-sm-4">
                            <label class="control-label">When is the interest paid into the account</label>
                            <select class="form-control" id="whenInterestIsPaid" name="whenInterestIsPaid" data-bind='options: dropDowns.whenInterestIsPaidOptions, optionsText: "desc", optionsCaption: "Select...", optionsAfterRender: setOptionValue("id"), value: whenInterestIsPaid'>
                            </select>
                        </div>
                        <div class="col-sm-4">
                            <label class="control-label">Days in year</label>
                            <select class="form-control" id="daysInYear" name="daysInYear" data-bind='options: dropDowns.daysInYearOptions, optionsText: "desc", optionsCaption: "Select...", optionsAfterRender: setOptionValue("id")'>
                            </select>
                        </div>
                    </div>
                    <div class="form-group" data-bind="visible: interestRateApplicable">
                        <div class="col-sm-12">
                            <div>
                                <label>
                                    <input type="checkbox" value="1" name="applyWHTonInterest" id="applyWHTonInterest">Apply withholding taxes
                                    <sup data-toggle="tooltip" title="Apply withholding taxes on the interest paid into account" data-placement="right">
                                        <i class="fa fa-question-circle"></i>
                                    </sup>
                                </label>
                            </div>
                        </div>
                    </div>
                    <div class="hr-line-dashed"></div>
                    <div class="form-group">
                        <div class="col-md-12">
                            <div><label class="control-label">Opening Balance Constraints</label>
                            </div>
                            <div>
                                <label class="col-sm-1 control-label">Default</label><div class="col-sm-3">
                                    <input type="number" class="form-control input-sm" name="defaultOpeningBal" id="defaultOpeningBal">
                                </div>
                                <label class="col-sm-1 control-label">Min</label>
                                <div class="col-sm-3">
                                    <input type="number" class="form-control input-sm" id="minOpeningBal" name="minOpeningBal">
                                </div>
                                <label class="col-sm-1 control-label">Max</label>
                                <div class="col-sm-3">
                                    <input type="number" class="form-control input-sm" name="maxOpeningBal" id="maxOpeningBal">
                                </div>
                            </div>
                        </div>
                    </div>
                    <div class="hr-line-dashed"></div>
                    <div class="form-group">
                        <div class="col-md-12">
                            <div><label class="control-label">Term Length Constraints <sup data-toggle="tooltip" title="Period of time before which a client start withdrawing from the account" data-placement="right"><i class="fa fa-question-circle"></i></sup></label>
                            </div>
                            <div>
                                <label class="col-sm-1 control-label">Default</label>
                                <div class="col-sm-2">
                                    <input type="number" class="form-control input-sm" name="defaultTermLength" id="defaultTermLength">
                                </div>
                                <label class="col-sm-1 control-label">Min</label>
                                <div class="col-sm-2">
                                    <input type="number" class="form-control input-sm" id="minTermLength" name="minTermLength">
                                </div>
                                <label class="col-sm-1 control-label">Max</label>
                                <div class="col-sm-2">
                                    <input type="number" class="form-control input-sm" name="maxTermLength" id="maxTermLength">
                                </div>
                                <label class="col-sm-1 control-label">Unit<sup data-toggle="tooltip" title="Unit of time for the term length" data-placement="right"><i class="fa fa-question-circle"></i></sup></label>
                                <div class="col-sm-2">
                                    <select class="form-control" id="termTimeUnit" name="termTimeUnit" data-bind='options: dropDowns.termTimeUnitOptions, optionsText: "desc", optionsCaption: "Select...", optionsAfterRender: setOptionValue("id")' data-msg-required="Unit for term length is required">
                                    </select>
                                </div>
                            </div>
                        </div>
                    </div>
                    <div class="hr-line-dashed"></div>
                    <div class="form-group">
                        <div class="col-sm-12">
                            <div>
                                <label>
                                    <input type="checkbox" value="1" name="allow_arbitrary_fees"> Allow arbitrary fees 
                                    <sup data-toggle="tooltip" title="Fees which can be applied manually to the accounts at any point during the deposit account's lifetime and with any given amount" data-placement="right">
                                        <i class="fa fa-question-circle"></i>
                                    </sup>
                                </label>
                            </div>
                        </div>
                    </div>
                    <!--ko if: existingDepositProductFees().length > 0 || existingDepositProductFees().length > 0-->
                    <div class="form-group">
                        <div class="table-responsive">
                            <table class="table table-condensed table-stripped">
                                <thead>
                                    <tr>
                                        <th>Name</th>
                                        <th>Amount, Flat(UGX)</th>
                                        <th title="Method for calculating the day when the fee will be applied">Trigger</th>
                                        <th>Date Application Method</th>
                                        <th>&nbsp;</th>
                                    </tr>
                                </thead>
                                <tbody>
                                <!--ko foreach: $root.addExistingDepositProductFees -->
                                    <tr>
                                        <td>
                                            <span data-bind='text: feeName'> </span>
                                            <!-- The hidden input is applicable in the case when we are editing the product, when this field is visible it implies this is for editing-->
                                            <input type="hidden" data-bind="value: id" name="existingDepositProductFees[]"/>
                                        </td>
                                        <td data-bind="text: curr_format(amount)">
                                        </td>
                                        <td data-bind='text: getDescription(2, chargeTrigger)'></td>
                                        <td data-bind='text: dateApplicationMethod?getDescription(3, dateApplicationMethod):""'></td>
                                        <td title="Remove fee" class="btn text-danger" data-bind='click: $parent.removeExistingFee'><i class="fa fa-minus"></i></td>
                                    </tr>
                                <!--/ko-->
                                <!--ko foreach: $root.newDepositProductFees -->
                                    <tr>
                                        <td>
                                            <select class="form-control" data-bind="options: $parent.existingDepositProductFees, optionsText: 'feeName', optionsAfterRender: setOptionValue('id'), optionsCaption: 'Select...', attr: {name:'newDepositProductFees['+$index()+'][depositProductFeeId]'}, value: productFee">
                                            </select>
                                        </td>
                                        <td data-bind='with: productFee'><span data-bind='text: getDescription(2, chargeTrigger)'></span></td>
                                        <td data-bind='with: productFee'><span data-bind="text: curr_format(amount)"></span></td>
                                        <td data-bind='with: productFee'><span data-bind="text: dateApplicationMethod?getDescription(3, dateApplicationMethod)"></span></td>
                                        <td title="Remove fee" class="btn text-danger" data-bind='click: $parent.removeNewFee'><i class="fa fa-minus"></i></td>
                                    </tr>
                                <!--/ko-->
                                </tbody>
                            </table>
                        </div>
                    </div>
                    <div class="form-group">
                        <span class="btn btn-info btn-sm pull-right" data-bind='click: addNewFee'><i class="fa fa-plus"></i> Add fee</span>
                    </div>
                    <!--/ko-->
                    <div class="hr-line-dashed"></div>
                    <div class="form-group">
                        <div class="col-sm-4 col-sm-offset-2">
                            <button class="btn btn-warning" type="reset">Cancel</button>
                            <button class="btn btn-primary save" type="submit">Save changes</button>
                        </div>
                    </div>
                </form>
            </div>
        </div>
    </div>
</div>