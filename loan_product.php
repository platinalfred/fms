<?php 
$show_table_js = false;
$page_title = "Create Deposit Product";
$daterangepicker = false;
include("includes/header.php"); 
?>
	<div id="page-wrapper" class="gray-bg">
		<div class="row border-bottom">
			<nav class="navbar navbar-static-top white-bg" role="navigation" style="margin-bottom: 0">
				<div class="navbar-header">
					<a class="navbar-minimalize minimalize-styl-2 btn btn-primary " href="#"><i class="fa fa-bars"></i> </a>
					<form role="search" class="navbar-form-custom" action="#">
						<div class="form-group">
							<input type="text" placeholder="Search for something..." class="form-control" name="top-search" id="top-search">
						</div>
					</form>
				</div>
				<ul class="nav navbar-top-links navbar-right">
					<li class="dropdown">
						<a class="dropdown-toggle count-info" data-toggle="dropdown" href="#">
							<i class="fa fa-envelope"></i> <span class="label label-warning">16</span>
						</a>
						<ul class="dropdown-menu dropdown-messages">
							<li>
								<div class="dropdown-messages-box">
									<a href="profile.html" class="pull-left">
										<img alt="image" class="img-circle" src="img/a7.jpg">
									</a>
									<div>
										<small class="pull-right">46h ago</small>
										<strong>Mike Loreipsum</strong> started following <strong>Monica Smith</strong>.
										<br>
										<small class="text-muted">3 days ago at 7:58 pm - 10.06.2014</small>
									</div>
								</div>
							</li>
							<li class="divider"></li>
							<li>
								<div class="dropdown-messages-box">
									<a href="profile.html" class="pull-left">
										<img alt="image" class="img-circle" src="img/a4.jpg">
									</a>
									<div>
										<small class="pull-right text-navy">5h ago</small>
										<strong>Chris Johnatan Overtunk</strong> started following <strong>Monica Smith</strong>.
										<br>
										<small class="text-muted">Yesterday 1:21 pm - 11.06.2014</small>
									</div>
								</div>
							</li>
							<li class="divider"></li>
							<li>
								<div class="dropdown-messages-box">
									<a href="profile.html" class="pull-left">
										<img alt="image" class="img-circle" src="img/profile.jpg">
									</a>
									<div>
										<small class="pull-right">23h ago</small>
										<strong>Monica Smith</strong> love <strong>Kim Smith</strong>.
										<br>
										<small class="text-muted">2 days ago at 2:30 am - 11.06.2014</small>
									</div>
								</div>
							</li>
							<li class="divider"></li>
							<li>
								<div class="text-center link-block">
									<a href="mailbox.html">
										<i class="fa fa-envelope"></i> <strong>Read All Messages</strong>
									</a>
								</div>
							</li>
						</ul>
					</li>
					<li class="dropdown">
						<a class="dropdown-toggle count-info" data-toggle="dropdown" href="#">
							<i class="fa fa-bell"></i> <span class="label label-primary">8</span>
						</a>
						<ul class="dropdown-menu dropdown-alerts">
							<li>
								<a href="mailbox.html">
									<div>
										<i class="fa fa-envelope fa-fw"></i> You have 16 messages
										<span class="pull-right text-muted small">4 minutes ago</span>
									</div>
								</a>
							</li>
							<li class="divider"></li>
							<li>
								<a href="profile.html">
									<div>
										<i class="fa fa-twitter fa-fw"></i> 3 New Followers
										<span class="pull-right text-muted small">12 minutes ago</span>
									</div>
								</a>
							</li>
							<li class="divider"></li>
							<li>
								<a href="grid_options.html">
									<div>
										<i class="fa fa-upload fa-fw"></i> Server Rebooted
										<span class="pull-right text-muted small">4 minutes ago</span>
									</div>
								</a>
							</li>
							<li class="divider"></li>
							<li>
								<div class="text-center link-block">
									<a href="notifications.html">
										<strong>See All Alerts</strong>
										<i class="fa fa-angle-right"></i>
									</a>
								</div>
							</li>
						</ul>
					</li>

					<li>
						<a href="login.html">
							<i class="fa fa-sign-out"></i> Log out
						</a>
					</li>
					<li>
						<a class="right-sidebar-toggle">
							<i class="fa fa-tasks"></i>
						</a>
					</li>
				</ul>

			</nav>
		</div>

		<div class="wrapper wrapper-content">
<div class="row">
                <div class="col-lg-12">
                    <div class="ibox float-e-margins">
                        <div class="ibox-title">
                            <h5>Loan Product <small>Creating loan product</small></h5>
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
                            <form id="loanProductForm" class="form-horizontal">
                                <div class="form-group">
									<label class="col-sm-2 control-label" for="productName">Product Name</label>
                                    <div class="col-sm-10"><input type="text" class="form-control input-sm" name="productName" id="productName" data-bind="value: productName" data-msg-required="Product name is required" required></div>
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
										<select class="form-control m-b" id="productType" name="productType" data-bind='options: productTypes, optionsText: "typeName", optionsCaption: "Select...", optionsAfterRender: setOptionValue("id"), value: productType' data-msg-required="Loan product type is required">
										</select>
										<div data-bind="with: productType"><span class="help-block m-b-none"><small data-bind="text: description">Product description goes here.</small></span></div>
                                    </div>
                                </div>
                                <div class="hr-line-dashed"></div>
                                <div class="form-group">
										<label class="control-label col-sm-1">State</label>
                                    <div class="col-sm-2">
										<div class="i-checks"><label title="Select if this product should be made active"> <input type="checkbox" data-bind="checked: active" value="1"> <i></i> Active </label></div>
                                    </div>
									<label class="control-label col-sm-3">Initial Account State</label>
                                    <div class="col-sm-6">
										<select class="form-control m-b" id="intialAccountState" name="intialAccountState" data-bind='options: intialAccountStateOptions, optionsText: "desc", optionsCaption: "Select...", optionsAfterRender: setOptionValue("id"), value: intialAccountState' data-msg-required="Initial Account State is required">
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
									<label class="col-sm-2 control-label" data-toggle="tooltip" data-original-title="Specify if the loan amount can be disbursed in multiple tranches" data-placement="right">Max Tranches <i class="fa fa-question-circle"></i></label>

                                    <div class="col-sm-2"><input type="number" placeholder="days" class="form-control input-sm " name="maxTranches" id="maxTranches" data-bind="value: maxTranches" data-msg-required="Number of days is required"/></div><label class="col-sm-1 control-label"> #</label><div class="col-sm-6"></div>
                                </div>
                                <div class="hr-line-dashed"></div>
								<!--Found at https://support.mambu.com/customer/en/portal/articles/1162103-setting-up-new-loan-products -->
                                <div class="form-group">
									<div class="col-md-12">
										<div><label class="control-label">Interest Rate Constraints(%)</label>
										</div>
										<div>
											<label class="col-sm-1 control-label">Default</label><div class="col-sm-3"><input type="number" class="form-control input-sm" name="defInterest" id="defInterest" data-bind="value: defInterest"></div><label class="col-sm-1 control-label">Min</label><div class="col-sm-3"><input type="number" class="form-control input-sm" id="minInterest" name="minInterest" data-bind="value: minInterest"></div><label class="col-sm-1 control-label">Max</label><div class="col-sm-3"><input type="number" class="form-control input-sm" name="maxInterest" id="maxInterest" data-bind="value: maxInterest"></div>
										</div>
									</div>
                                </div>
                                <div class="hr-line-dashed"></div>
								<div><h4 class="text-info">Repayment scheduling</h4></div>
                                <div class="form-group">
									<div class="col-md-4">
										<p>Payment Interval Method: <strong>Interval</strong></p>
									</div>
									<div class="col-md-8">
											<label class="col-sm-6 control-label">Repayments are made every <i class="fa fa-question-circle" data-toggle="tooltip" data-original-title='Suppose you want the repayments to be made every two weeks.Enter the number (2 in this example) > select "weeks" from the dropdown list. This will define the period between repayments.' data-placement='right' ></i></label>
											<div class="col-sm-2"><input type="number" class="form-control input-sm" name="repaymentsFrequency" id="repaymentsFrequency" data-bind="value: repaymentsFrequency"></div>
											<div class="col-sm-4">
											<select class="form-control m-b" id="repaymentsMadeEvery" name="repaymentsMadeEvery" data-bind='options: repaymentsMadeEveryOptions, optionsText: "desc", optionsCaption: "Select...", value: repaymentsMadeEvery' data-msg-required="Unit for term length is required">
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
										<div><label class="control-label">First Due Date Offset Constraints (days) <i class="fa fa-question-circle" data-original-title="Set the constraints for the number of offset days that can be established for the first repayment date when creating an account" data-placement="right" data-toggle="tooltip"></i></label>
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
										<input type="number" name="minGuarantorsRequired" id="minGuarantorsRequired" class="form-control input-sm" data-bind="value: minGuarantorsRequired" >
                                    </div>
										<label class="control-label col-sm-4">Minimum Collateral Amount Required</label>
                                    <div class="col-sm-3">
										<input type="number" name="minCollateralRequired" id="minCollateralRequired" data-bind="value: minCollateralRequired" class="form-control input-sm">
                                    </div>
                                </div>
                                <div class="hr-line-dashed"></div>
                                <div class="form-group">
									<div class="col-sm-6">
											<div class="i-checks"><label> <input type="checkbox" data-bind="checked: linkToDepositAccount"> Link to Deposit Account <i class="fa fa-question-circle" data-toggle="tooltip" data-original-title="Linking accounts allows you to have loan repayments being automatically made from a client's deposit account. Given that a deposit account is being used as source for repayments, on the day the repayment becomes due, the amount is automatically transferred from the deposit account as a repayment on the loan account" data-placement="right"></i></label></div>
									</div>
									<div class="col-sm-6">
										<div class="i-checks"><label> <input type="checkbox" data-bind="checked: penaltyApplicable"> Penalties Applicable <i class="fa fa-question-circle" data-toggle="tooltip" data-original-title="Linking accounts allows you to have loan repayments being automatically made from a client's deposit account. Given that a deposit account is being used as source for repayments, on the day the repayment becomes due, the amount is automatically transferred from the deposit account as a repayment on the loan account" data-placement="right"></i></label></div>
									</div>
                                </div>
                                <div class="hr-line-dashed" data-bind="visible: penaltyApplicable"></div>
                                <div class="form-group" data-bind="visible: penaltyApplicable">
                                    <div class="col-md-12">
										<label class="control-label">Penalty Calculation Method</label>
										<select class="form-control m-b" id="penaltyCalculationMethod" name="penaltyCalculationMethod" data-bind='options: penaltyCalculationMethodOptions, optionsText: "desc", optionsCaption: "Select...", optionsAfterRender: setOptionValue("id"), value: penaltyCalculationMethod'>
										</select>
                                    </div>
                                </div>
                                <div class="form-group" data-bind="visible: penaltyApplicable">
                                    <div class="col-md-5">
										<label class="control-label">Penalty Tolerance Period</label>
										<div class="col-sm-9"><input type="number" class="form-control input-sm" name="penaltyTolerancePeriod" id="penaltyTolerancePeriod" data-bind="value: penaltyTolerancePeriod"></div><label class="col-sm-1">Days</label>
                                    </div>
                                    <div class="col-md-7">
										<label class="control-label">How is the penalty rate charged</label>
										<div class="col-sm-7"><input type="number" class="form-control input-sm" name="penaltyRateChargedPer" id="penaltyRateChargedPer" data-bind="value: penaltyRateChargedPer"></div><label class="col-sm-3">% per day</label>
                                    </div>
                                </div>
                                <div class="form-group" data-bind="visible: penaltyApplicable">
                                    <div class="col-md-4">
										<label class="control-label">Default Penalty Rate</label>
										<div class="col-sm-9"><input type="number" class="form-control input-sm" name="defPenaltyRate" id="defPenaltyRate" data-bind="value: defPenaltyRate"></div><label class="col-sm-1">%</label>
                                    </div>
                                    <div class="col-md-4">
										<label class="control-label">Min Penalty Rate</label>
										<div class="col-sm-9"><input type="number" class="form-control input-sm" id="minPenaltyRate" name="minPenaltyRate" data-bind="value: minPenaltyRate"></div><label class="col-sm-1">%</label>
                                    </div>
                                    <div class="col-md-4">
										<label class="control-label">Max Penalty Rate</label>
										<div class="col-sm-9"><input type="number" class="form-control input-sm" name="maxGracePeriod" id="maxGracePeriod" data-bind="value: maxGracePeriod"></div><label class="col-sm-1">%</label>
                                    </div>
                                </div>
                                <div class="hr-line-dashed"></div>
                                <div class="form-group">
                                    <div class="col-sm-3">
										<label class="control-label">Tax Rate source</label>
                                    </div>
                                    <div class="col-sm-3">
										<select class="form-control m-b" id="taxRateSource" name="taxRateSource" data-bind='options: taxRateSourceOptions, optionsText: "desc", optionsCaption: "Select...", optionsAfterRender: setOptionValue("id"), value: taxRateSource'>
										</select>
                                    </div>
                                    <div class="col-sm-3">
										<label class="control-label">Tax Calculation Method</label>
                                    </div>
                                    <div class="col-sm-3">
										<select class="form-control m-b" id="taxCalculationMethod" name="taxCalculationMethod" data-bind='options: taxCalculationMethodOptions, optionsText: "desc", optionsCaption: "Select...", optionsAfterRender: setOptionValue("id"), value: taxCalculationMethod'>
										</select>
                                    </div>
                                </div>
                                </div>
                                <div class="hr-line-dashed"></div>
                                <div class="table-responsive">
									<table class="table table-condensed" data-bind="visible: productFees().length > 0">
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
										<tbody data-bind="foreach: $root.productFees">
											<tr>
												<td><input class="form-control input-sm m-b required" name="feeName[]" data-bind='value: feeName, uniqueName: true' data-msg-required="Fee name is required" required/></td>
												<td><input class="form-control input-sm m-b required" name="amount[]" type="number" data-bind='value: amount' required/></td>
												<td><select class="form-control m-b" id="feeType" name="feeType" data-bind='options: $parent.feeTypesOptions, optionsText: "description", optionsCaption: "Select...", , optionsAfterRender: $parent.setOptionValue("id"), value: feeType' data-msg-required="Fee type is required">
												</select></td>
												<td><select class="form-control m-b " id="amountCalculatedAs" name="amountCalculatedAs" data-bind='options: $parent.amountCalculatedAsOptions, optionsText: "desc", , optionsAfterRender: $root.setOptionValue("id"), optionsCaption: "Select...", value: $parent.amountCalculatedAs'>
												</select><!-- to be used later , css: {required:id==2} --></td>
												<td><input class="form-control input-sm m-b required" name="requiredFee[]" type="checkbox" data-bind='checked: requiredFee' required/></td>
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
                                        <button class="btn btn-primary" type="submit">Submit</button>
                                    </div>
                                </div>
                            </form>
                        </div>
                    </div>
                </div>		</div>
		<div class="footer">
			<div>
				<strong>Copyright</strong> Buladde Financial Services &copy; 2017 <?php if(date("Y") > 2017 ){ echo "- ".date("Y"); } ?>
			</div>
		</div>

	</div>
</div>

    <!-- Mainly scripts -->
    <script src="js/jquery-2.1.1.js"></script>
    <script src="js/bootstrap.min.js"></script>
    <script src="js/plugins/metisMenu/jquery.metisMenu.js"></script>
    <script src="js/plugins/slimscroll/jquery.slimscroll.min.js"></script>


    <!-- Peity -->
    <script src="js/plugins/peity/jquery.peity.min.js"></script>
    <script src="js/demo/peity-demo.js"></script>

    <!-- Custom and plugin javascript -->
    <script src="js/inspinia.js"></script>
    <script src="js/plugins/pace/pace.min.js"></script>

    <!-- jQuery UI -->
    <script src="js/plugins/jquery-ui/jquery-ui.min.js"></script>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/jquery-validate/1.16.0/jquery.validate.min.js"></script>
	<?php 
	include("js/loanProduct.php");
	?>

 </body>

</html>