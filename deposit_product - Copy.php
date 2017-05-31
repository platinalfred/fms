<?php 
$needed_files = array("daterangepicker", "iCheck", "jasny");

$page_title = "Create Deposit Product";
include("include/header.php"); 
?>
<div class="wrapper wrapper-content">
<div class="row">
                <div class="col-lg-12">
                    <div class="ibox float-e-margins">
                        <div class="ibox-title">
                            <h5>Deposit Product <small>Creating deposit product</small></h5>
                            <div class="ibox-tools">
                                <a class="collapse-link">
                                    <i class="fa fa-chevron-up"></i>
                                </a>
                                <a class="dropdown-toggle" data-toggle="dropdown" href="#">
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
                                </a>
                            </div>
                        </div>
                        <div class="ibox-content">
                            <form id="depProductForm" class="form-horizontal">
                                <div class="form-group">
									<label class="col-sm-2 control-label" for="productName">Product Name</label>
                                    <div class="col-sm-3"><input type="text" class="form-control input-sm" name="productName" id="productName" data-bind="value: productName" data-msg-required="Product name is required" required></div>
									<label class="control-label col-sm-1">Description</label>
                                    <div class="col-sm-6">
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
										<label class="control-label">Type of Deposit Product</label>
										<select class="form-control m-b" id="productType" name="productType" data-bind='options: productTypes, optionsText: "typeName", optionsCaption: "Select...", optionsAfterRender: setOptionValue("id"), value: productType' data-msg-required="Deposit product type is required">
										</select>
										<div data-bind="with: productType"><span class="help-block m-b-none"><small data-bind="text: description">Product description goes here.</small></span></div>
                                    </div>
                                </div>
                                <div class="hr-line-dashed"></div>
                                <div class="form-group">
										<label class="control-label col-sm-3">Recommended Deposit Amount</label>
                                    <div class="col-sm-3">
										<input type="number" name="recommededDepositAmount" id="recommededDepositAmount" class="form-control input-sm" data-bind="value: recommededDepositAmount" >
                                    </div>
										<label class="control-label col-sm-3">Maximum Withdrawal Amount</label>
                                    <div class="col-sm-3">
										<input type="number" name="maxWithdrawalAmount" id="maxWithdrawalAmount" data-bind="value: maxWithdrawalAmount" class="form-control input-sm">
                                    </div>
                                </div>
                                <div class="hr-line-dashed"></div>
                                <div class="form-group">
									<div class="col-sm-12">
											<div class="i-checks"><label title="Select if interest should be paid into the account"> <input type="checkbox" data-bind="checked: interestRateApplicable"> <i></i> Interest paid into account </label></div>
									</div>
                                </div>
                                <div class="form-group" data-bind="visible: interestRateApplicable">
									<div class="col-md-12">
										<div><label class="control-label">Interest Rate Constraints</label>
										</div>
										<div>
											<label class="col-sm-1 control-label">Default</label><div class="col-sm-3"><input type="number" class="form-control input-sm" name="defaultInterest" id="defaultInterest" data-bind="value: defaultInterestRate"></div><label class="col-sm-1 control-label">Min</label><div class="col-sm-3"><input type="number" class="form-control input-sm" id="minInterest" name="minInterest" data-bind="value: minInterestRate"></div><label class="col-sm-1 control-label">Max</label><div class="col-sm-3"><input type="number" class="form-control input-sm" name="maxInterest" id="maxInterest" data-bind="value: maxInterestRate"></div>
										</div>
									</div>
                                </div>
                                <div class="form-group" data-bind="visible: interestRateApplicable">
									<label class="col-sm-1 control-label">Per</label>

                                    <div class="col-sm-2"><input type="number" placeholder="days" class="form-control input-sm " name="perNoOfDays" id="perNoOfDays" data-bind="css: {required:reqAttr()}, value: perNoOfDays"  data-msg-required="Number of days is required"/></div><label class="col-sm-1 control-label"> Days</label><div class="col-sm-8"></div>
                                </div>
                                <div class="form-group" data-bind="visible: interestRateApplicable">
                                    <div class="col-sm-4">
										<label class="control-label">What account balance is used for calculations</label>
										<select class="form-control m-b" id="accountBalForCalcInterest" name="accountBalForCalcInterest" data-bind='options: dropDowns.accountBalForCalcInterestOptions, optionsText: "desc", optionsCaption: "Select...", optionsAfterRender: setOptionValue("id"), value: accountBalForCalcInterest'>
										</select>
                                    </div>
                                    <div class="col-sm-4">
										<label class="control-label">When is the interest paid into the account</label>
										<select class="form-control m-b" id="whenInterestIsPaid" name="whenInterestIsPaid" data-bind='options: dropDowns.whenInterestIsPaidOptions, optionsText: "desc", optionsCaption: "Select...", optionsAfterRender: setOptionValue("id"), value: whenInterestIsPaid'>
										</select>
                                    </div>
                                    <div class="col-sm-4">
										<label class="control-label">Days in year</label>
										<select class="form-control m-b" id="daysInYear" name="daysInYear" data-bind='options: dropDowns.daysInYearOptions, optionsText: "desc", optionsCaption: "Select...", optionsAfterRender: setOptionValue("id"), value: daysInYear'>
										</select>
                                    </div>
                                </div>
                                <div class="form-group" data-bind="visible: interestRateApplicable">
									<div class="col-sm-12">
											<div class="i-checks" title="Apply withholding taxes on the interest paid into account"><label> <input type="checkbox" value="" name="applyWHTonInterest" id="applyWHTonInterest" data-bind="value: applyWHTonInterest"> <i></i> Apply withholding taxes </label></div>
									</div>
                                </div>
                                <div class="hr-line-dashed"></div>
                                <div class="form-group">
									<div class="col-md-12">
										<div><label class="control-label">Opening Balance Constraints</label>
										</div>
										<div>
											<label class="col-sm-1 control-label">Default</label><div class="col-sm-3"><input type="number" class="form-control input-sm" name="defaultOpeningBal" id="defaultOpeningBal" data-bind="value: defaultOpeningBal"></div><label class="col-sm-1 control-label">Min</label><div class="col-sm-3"><input type="number" class="form-control input-sm" id="minOpeningBal" name="minOpeningBal" data-bind="value: minOpeningBal"></div><label class="col-sm-1 control-label">Max</label><div class="col-sm-3"><input type="number" class="form-control input-sm" name="maxOpeningBal" id="maxOpeningBal" data-bind="value: maxOpeningBal"></div>
										</div>
									</div>
                                </div>
                                <div class="hr-line-dashed"></div>
                                <div class="form-group">
									<div class="col-md-12">
										<div><label class="control-label" title="Period of time before which a withdraw can be made">Term Length Constraints</label>
										</div>
										<div>
											<label class="col-sm-1 control-label">Default</label><div class="col-sm-2"><input type="number" class="form-control input-sm" name="defaultTermLength" id="defaultTermLength" data-bind="value: defaultTermLength"></div><label class="col-sm-1 control-label">Min</label><div class="col-sm-2"><input type="number" class="form-control input-sm" id="minTermLength" name="minTermLength" data-bind="value: minTermLength"></div><label class="col-sm-1 control-label">Max</label><div class="col-sm-2"><input type="number" class="form-control input-sm" name="maxTermLength" id="maxTermLength" data-bind="value: maxTermLength"></div>
											<label class="col-sm-1 control-label" title="Unit of time for the term length">Unit</label>
											<div class="col-sm-2">
											<select class="form-control m-b" id="termTimeUnit" name="termTimeUnit" data-bind='options: dropDowns.termTimeUnitOptions, optionsText: "desc", optionsCaption: "Select...", optionsAfterRender: setOptionValue("id"), value: termTimeUnit' data-msg-required="Unit for term length is required">
											</select>
											</div>
										</div>
									</div>
                                </div>
                                <div class="hr-line-dashed"></div>
                                <div class="form-group">
									<div class="col-sm-12">
											<div class="i-checks"><label title="Fees which can be applied manually to the accounts at any point during the deposit account's lifetime and with any given amount"> <input type="checkbox" data-bind="checked: allowArbitraryFee"> <i></i> Allow arbitrary fees </label></div>
									</div>
                                </div>
                                <div class="table-responsive">
									<table class="table table-condensed" data-bind="visible: productFees().length > 0">
										<thead>
											<tr>
												<th>Name</th>
												<th>Amount, Flat(UGX)</th>
												<th title="Method for calculating the day when the fee will be applied">Trigger</th>
												<th>Apply Date Method</th>
												<th>&nbsp;</th>
											</tr>
										</thead>
										<tbody data-bind="foreach: $root.productFees">
											<tr>
												<td><input class="form-control input-sm m-b required" name="feeName[]" data-bind='value: feeName, uniqueName: true' data-msg-required="Fee name is required" required/></td>
												<td><input class="form-control input-sm m-b required" name="amount[]" type="number" data-bind='value: amount' required/></td>
												<td><select class="form-control m-b" id="chargeTrigger" name="chargeTrigger" data-bind='options: dropDowns.chargeTriggerOptions, optionsText: "desc", optionsCaption: "Select...", , optionsAfterRender: $parent.setOptionValue("id"), value: chargeTrigger' data-msg-required="Charge trigger is required">
												</select></td>
												<td data-bind='with: chargeTrigger'><select class="form-control m-b " id="dateApplicationMethod" name="dateApplicationMethod" data-bind='visible: id==2, options: dropDowns.dateApplicationMethodOptions, optionsText: "desc", , optionsAfterRender: $root.setOptionValue("id"), optionsCaption: "Select...", value: $parent.dateApplicationMethod'>
												</select><!-- to be used later , css: {required:id==2} --></td>
												<td><span title="Remove fee" class="btn text-danger" data-bind='click: $root.removeFee'><i class="fa fa-minus"></i></span></td>
											</tr>
										</tbody>
									</table>
                                </div>
                                <div class="form-group">
                                    <span class="btn btn-info btn-sm pull-right" data-bind='click: addFee'><i class="fa fa-plus"></i> Add fee</span>
                                </div>
                                <div class="hr-line-dashed"></div>
                                <div class="form-group">
                                    <div class="col-sm-4 col-sm-offset-2">
                                        <button class="btn btn-warning" type="reset">Cancel</button>
                                        <button class="btn btn-primary" type="submit">Save changes</button>
                                    </div>
                                </div>
                            </form>
                        </div>
                    </div>
                </div>
			</div>
<?php 
	include("include/footer.php"); 
	include("js/depositProduct.php");
?>

 </body>

</html>