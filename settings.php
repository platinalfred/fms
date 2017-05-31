<?php 
/*
	include specific plugin files that you need on a page by  adding the names as below in the array
	dataTables, ChartJs,iCheck,daterangepicker,clockpicker,colorpicker,datapicker,easypiechart,fullcalendar,idle-timer,morris, nouslider, summernote,validate,wow,video,touchspin,Sparkline,Flot, Peity, Jvectormap, touchspin, select2, daterangepicker, clockpicker, ionRangeSlider, datapicker, nouslider, jasny, switchery, cropper, colorpicker, steps, dropzone, bootstrap-markdown
*/
$needed_files = array("dataTables", "iCheck", "jasny", "knockout");
$page_title = "Settings";
include("include/header.php");
require_once("lib/Libraries.php");
?>
	<div class="row wrapper border-bottom white-bg page-heading">
		<div class="col-lg-12  m-b-md" style="padding-top:10px;">
			<div class="tabs-container">
				<ul class="nav nav-tabs">
					<li class="active"><a data-toggle="tab" href="#tab-20" href="#">Loan Products</a></li>
					<li><a data-toggle="tab" href="#tab-21" href="#">Deposit Products</a></li>
					<li><a data-toggle="tab" href="#tab-1" href="#">Person Types</a></li>
					<li class=""><a data-toggle="tab" href="#tab-2" href="#">Account Types</a></li>
					<li class=""><a data-toggle="tab" href="#tab-3" href="#">Branches</a></li>
					<li class=""><a data-toggle="tab" href="#tab-5" href="#">Access Levels</a></li>
					<li class=""><a data-toggle="tab" href="#tab-6" href="#">Id Card Types</a></li>
					<li class="dropdown">
						<a class="dropdown-toggle" data-toggle="dropdown" href="#">More <b class="caret"></b></a>
						<ul class="dropdown-menu">
							<!--<li class=""><a data-toggle="tab" role="tab" href="#tab-11" href="#">Loan Types</a></li>-->
							<li class=""><a data-toggle="tab" href="#tab-7" href="#">Income Sources</a></li>
							<li class=""><a data-toggle="tab" href="#tab-8" href="#">Individual Types</a></li>
							<li class=""><a data-toggle="tab" href="#tab-9" href="#">Loan Product Types</a></li>
							<li class=""><a data-toggle="tab" role="tab" href="#tab-12" href="#">Penalty Calculation Method</a></li>
							<li class=""><a data-toggle="tab" role="tab" href="#tab-13" href="#">Loan Product Penalties</a></li>
							<li class=""><a data-toggle="tab" role="tab" href="#tab-14" href="#">Relationhip Types </a></li>
							<li class=""><a data-toggle="tab" role="tab" href="#tab-15" href="#">Repayment Duration</a></li>
							<li class=""><a data-toggle="tab" role="tab" href="#tab-16" href="#">Security Types</a></li>
							<li class=""><a data-toggle="tab" role="tab" href="#tab-17" href="#">Positions</a></li>
							<li class=""><a data-toggle="tab" role="tab" href="#tab-18" href="#">Address Type</a></li>
							<li class=""><a data-toggle="tab" role="tab" href="#tab-19" href="#">Marital Status</a></li>
						</ul>
					</li>
				</ul>
				<div class="tab-content">
					<!---  Person Type Start   --->
					<div id="tab-1" class="tab-pane">
						<div class="panel-body">
							<div class="col-lg-2 col-offset-sm-8">
								<div class="text-center">
									<a data-toggle="modal" class="btn btn-primary" href="#person_type"><i class="fa fa-plus"></i> Add person type</a>
								</div>
								<div id="person_type" class="modal fade" aria-hidden="true">
									<div class="modal-dialog">
										<div class="modal-content">
											<div class="modal-body">
												<div class="alert  alert-dismissable " id="notice_message"  style="display:none;">
													<button aria-hidden="true" data-dismiss="alert" class="close" type="button">×</button>
													<div id="notice"></div>
												</div>
												<div class="row">
													<div class="col-sm-12">
														<p>Add Person Type.</p>
														<div class="ibox-content">
															<form class="form-horizontal" method="post" action="save_data.php" id="personTypeTable">
																<input name="tbl" value="person_type" type="hidden">
																<div class="form-group"><label class="col-lg-2 control-label">Name</label>
																	<div class="col-lg-10"><input name="name" type="text" placeholder="Name" class="form-control"> <span class="help-block m-b-none">Name of the person type.</span>
																	</div>
																</div>
																<div class="form-group"><label class="col-lg-2 control-label">Description</label>
																	<div class="col-lg-10"><textarea name="description" placeholder="Description" class="form-control"></textarea></div>
																</div>
																<div class="form-group">
																	<div class="col-lg-offset-2 col-lg-10">
																		<button class="btn btn-sm btn-primary save" type="button"><i class="ti-save"></i>Submit</button>
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
								<div id="edit_person_type" class="modal fade" aria-hidden="true">
									<div class="modal-dialog">
										<div class="modal-content">
											<div class="modal-body">
												
											</div>
										</div>
									</div>
								</div>
							</div>
							<div class="col-lg-12" style="margin-top:10px;">
								<div class="ibox-content">
									<div class="table-responsive">
										<table class="table table-striped table-bordered table-hover" id="person_types">
											<thead>
											<tr>
												<th>Name</th>
												<th>Description</th>
												<th></th>
											</tr>
											</thead>
											<tbody>
												
											</tbody>
											<tfoot>
												<tr>
													<th>Name</th>
													<th>Description</th>
													<th></th>
												</tr>
											</tfoot>
										</table>
									</div>
								</div>
							</div>
							
						</div>
					</div>
					<!-- Account Type -->
					<div id="tab-2" class="tab-pane">
						<div class="panel-body">
							<div class="col-lg-2 col-offset-sm-8">
								<div class="text-center">
									<a data-toggle="modal" class="btn btn-primary" href="#account_type"><i class="fa fa-plus"></i> Add Account type</a>
								</div>
								<div id="account_type" class="modal fade" aria-hidden="true">
									<div class="modal-dialog">
										<div class="modal-content">
											<div class="modal-body">
												<div class="alert  alert-dismissable " id="notice_message"  style="display:none;">
													<button aria-hidden="true" data-dismiss="alert" class="close" type="button">×</button>
													<div id="notice"></div>
												</div>
												<div class="row">
													<div class="col-sm-12">
														<p>Add Account Type.</p>
														<div class="ibox-content">
															<form class="form-horizontal" method="post" id="tblAccountType"> 
																<input type="hidden" name="tbl" value="account_type">
																<div class="form-group"><label class="col-lg-2 control-label">Title</label>
																	<div class="col-lg-10"><input name="title" type="text" placeholder="Name" class="form-control"> <span class="help-block m-b-none">Account type name.</span>
																	</div>
																</div>
																<div class="form-group"><label class="col-lg-2 control-label">Minimum Balance</label>
																	<div class="col-lg-10"><input id="minimum_balance" name="minimum_balance" type="text"  class="form-control"> <span class="help-block m-b-none">The minimum balance an account holder should keep on the account.</span>
																	</div>
																</div>
																<div class="form-group"><label class="col-lg-2 control-label">Description</label>
																	<div class="col-lg-10"><textarea  name="description" placeholder="Description" class="form-control"></textarea></div>
																</div>
																<div class="form-group">
																	<div class="col-lg-offset-2 col-lg-10">
																		<button class="btn btn-sm btn-primary save" type="button">Submit</button>
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
							<div class="col-lg-12" style="margin-top:10px;">
								<div class="ibox-content">
									<div class="table-responsive">
										<table class="table table-striped table-bordered table-hover" id="account_types">
											<thead>
											<tr>
												<th>Name</th>
												<th>Minimum Balance</th>
												<th>Description</th>
												<th></th>
											</tr>
											</thead>
											<tbody>
												
											</tbody>
										</table>
									</div>
								</div>
							</div>
							
						</div>
					</div>
					<!-- Branch -->
					<div id="tab-3" class="tab-pane">
						<div class="panel-body">
							<div class="col-lg-2 col-offset-sm-8">
								<div class="text-center">
									<a data-toggle="modal" class="btn btn-primary" href="#branches"><i class="fa fa-plus"></i> Add Branch</a>
								</div>
								<div id="branches" class="modal fade" aria-hidden="true">
									<div class="modal-dialog">
										<div class="modal-content">
											<div class="modal-body">
												<div class="row">
													<div class="col-sm-12">
														<p>Add Branch.</p>
														<div class="ibox-content">
															<form class="form-horizontal" method="post" id="tblbranch">
																<input type="hidden" name="tbl" value="branch">
																<div class="form-group"><label class="col-lg-2 control-label">Branch Name</label>
																	<div class="col-lg-10"><input type="text" name="branch_name"  placeholder="Branch Name" class="form-control"> 
																	</div>
																</div>
																
																<div class="form-group"><label class="col-lg-2 control-label"> Office Phone</label>
																	<div class="col-sm-10">
																		<input type="text" class="form-control" data-mask="(999) 999-9999" placeholder="" name="office_phone">
																		<span class="help-block">(073) 000-0000</span>
																	</div>
																	
																</div>
																<div class="form-group"><label class="col-lg-2 control-label">Email Address</label>
																	<div class="col-lg-10"><input type="email" name="email_address"  placeholder="mail@example.com" class="form-control"> 
																	</div>
																</div>
																<div class="form-group"><label class="col-lg-2 control-label">Physical Address</label>
																	<div class="col-lg-10"><textarea  name="physical_address" placeholder="Physical Address" class="form-control"></textarea></div>
																</div>
																<div class="form-group"><label class="col-lg-2 control-label">Postal Address</label>
																	<div class="col-lg-10"><input type="text" name="postal_address"  placeholder="Postal Address" class="form-control"> 
																	</div>
																</div>
																<div class="form-group">
																	<div class="col-lg-offset-2 col-lg-10">
																		<button class="btn btn-sm btn-primary save" type="button">Submit</button>
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
							<div class="col-lg-12" style="margin-top:10px;">
								<div class="ibox-content">
									<div class="table-responsive">
										<table class="table table-striped table-bordered table-hover" id="branches_tbl">
											<thead>
											<tr>
												<th>Branch Name</th>
												<th>Office Phone</th>
												<th>Email Address</th>
												<th>Physical Address</th>
												<th>Postal Address</th>
												<th></th>
											</tr>
											</thead>
											<tbody>
												
											</tbody>
										</table>
									</div>
								</div>
							</div>
							
						</div>
					</div>
					<!-- Access Level -->
					<div id="tab-5" class="tab-pane ">
						<div class="panel-body">
							<div class="col-lg-2 col-offset-sm-8">
								<div class="text-center">
									<a data-toggle="modal" class="btn btn-primary" href="#access_level"><i class="fa fa-plus"></i> Add Access Level</a>
								</div>
								<div id="access_level" class="modal fade" aria-hidden="true">
									<div class="modal-dialog">
										<div class="modal-content">
											<div class="modal-body">
												<div class="row">
													<div class="col-sm-12">
														<p>Add Access Level.</p>
														<div class="ibox-content">
															<form class="form-horizontal" method="post" id="tblAccessLevel">
																<input type="hidden" name="tbl" value="access_level">
																<div class="form-group"><label class="col-lg-2 control-label">Name</label>

																	<div class="col-lg-10"><input name="name" type="text" placeholder="Name" class="form-control"> <span class="help-block m-b-none">Access Level name (e.g Administrator).</span>
																	</div>
																</div>
																<div class="form-group"><label class="col-lg-2 control-label">Description</label>
																	<div class="col-lg-10"><textarea name="description" placeholder="Description" class="form-control"></textarea></div>
																</div>
																<div class="form-group">
																	<div class="col-lg-offset-2 col-lg-10">
																		<button class="btn btn-sm btn-primary save" type="button">Submit</button>
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
							<div class="col-lg-12" style="margin-top:10px;">
								<div class="ibox-content">
									<div class="table-responsive">
										<table class="table table-striped table-bordered table-hover" id="access_levels" >
											<thead>
											<tr>
												<th>Name</th>
												<th>Description</th>
												<th></th>
											</tr>
											</thead>
											<tbody>
												
											</tbody>
											<tfoot>
												<tr>
													<th>Name</th>
													<th>Description</th>
													<th></th>
												</tr>
											</tfoot>
										</table>
									</div>
								</div>
							</div>
							
						</div>
					</div>
					<!-- Id Card Type-->
					<div id="tab-6" class="tab-pane ">
						<div class="panel-body">
							<div class="col-lg-2 col-offset-sm-8">
								<div class="text-center">
									<a data-toggle="modal" class="btn btn-primary" href="#id_card_type"><i class="fa fa-plus"></i> Add Id Card Type</a>
								</div>
								<div id="id_card_type" class="modal fade" aria-hidden="true">
									<div class="modal-dialog">
										<div class="modal-content">
											<div class="modal-body">
												<div class="row">
													<div class="col-sm-12">
														<p>Add ID Card Type</p>
														<div class="ibox-content">
															<form class="form-horizontal" method="post" id="tblCardType">
																<input type="hidden" name="tbl" value="id_card_type">
																<div class="form-group"><label class="col-lg-2 control-label">Name</label>

																	<div class="col-lg-10"><input name="id_type" type="text" placeholder="Name" class="form-control"> <span class="help-block m-b-none">ID card Type (e.g National ID).</span>
																	</div>
																</div>
																<div class="form-group"><label class="col-lg-2 control-label">Description</label>
																	<div class="col-lg-10"><textarea name="description" placeholder="Description" class="form-control"></textarea></div>
																</div>
																<div class="form-group">
																	<div class="col-lg-offset-2 col-lg-10">
																		<button class="btn btn-sm btn-primary save" type="button">Submit</button>
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
							<div class="col-lg-12" style="margin-top:10px;">
								<div class="ibox-content">
									<div class="table-responsive">
										<table class="table table-striped table-bordered table-hover" id="id_card_types" >
											<thead>
											<tr>
												<th>Name</th>
												<th>Description</th>
												<th></th>
											</tr>
											</thead>
											<tbody>
												
											</tbody>
											<tfoot>
												<tr>
													<th>Name</th>
													<th>Description</th>
													<th></th>
												</tr>
											</tfoot>
										</table>
									</div>
								</div>
							</div>
							
						</div>
					</div>
					<!-- Income Source -->
					<div id="tab-7" class="tab-pane ">
						<div class="panel-body">
							<div class="col-lg-2 col-offset-sm-8">
								<div class="text-center">
									<a data-toggle="modal" class="btn btn-primary" href="#income_source"><i class="fa fa-plus"></i> Add Income Source</a>
								</div>
								<div id="income_source" class="modal fade" aria-hidden="true">
									<div class="modal-dialog">
										<div class="modal-content">
											<div class="modal-body">
												<div class="row">
													<div class="col-sm-12">
														<p>Add Income Source.</p>
														<div class="ibox-content">
															<form class="form-horizontal" method="post" id="tblIncomeSource">
																<input name="tbl" value="income_source" type="hidden">
																<div class="form-group"><label class="col-lg-2 control-label">Name</label>
																	<div class="col-lg-10"><input name="name" type="text" placeholder="Name" class="form-control"> <span class="help-block m-b-none">Add source of organization income.</span>
																	</div>
																</div>
																<div class="form-group"><label class="col-lg-2 control-label">Description</label>
																	<div class="col-lg-10"><textarea name="description" placeholder="Description" class="form-control"></textarea></div>
																</div>
																<div class="form-group">
																	<div class="col-lg-offset-2 col-lg-10">
																		<button class="btn btn-sm btn-primary save" type="button">Submit</button>
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
							<div class="col-lg-12" style="margin-top:10px;">
								<div class="ibox-content">
									<div class="table-responsive">
										<table class="table table-striped table-bordered table-hover" id="income_sources">
											<thead>
											<tr>
												<th>Name</th>
												<th>Description</th>
												<th></th>
											</tr>
											</thead>
											<tbody>
												
											</tbody>
											<tfoot>
												<tr>
													<th>Name</th>
													<th>Description</th>
													<th></th>
												</tr>
											</tfoot>
										</table>
									</div>
								</div>
							</div>
							
						</div>
					</div>
					<!-- Individual Type -->
					<div id="tab-8" class="tab-pane ">
						<div class="panel-body">
							<div class="col-lg-2 col-offset-sm-8">
								<div class="text-center">
									<a data-toggle="modal" class="btn btn-primary" href="#individual_type"><i class="fa fa-plus"></i> Add Individual type</a>
								</div>
								<div id="individual_type" class="modal fade" aria-hidden="true">
									<div class="modal-dialog">
										<div class="modal-content">
											<div class="modal-body">
												<div class="row">
													<div class="col-sm-12">
														<p>Add Individual Type.</p>
														<div class="ibox-content">
															<form class="form-horizontal" method="post" id="tblIndividualType">
																<input type="hidden" name="tbl" value="individual_type">
																<div class="form-group"><label class="col-lg-2 control-label">Name</label>

																	<div class="col-lg-10"><input name="name" type="text" placeholder="Name" class="form-control"> <span class="help-block m-b-none">Specify the forms by which an individual can be registered (e.g Member Only).</span>
																	</div>
																</div>
																<div class="form-group"><label class="col-lg-2 control-label">Description</label>
																	<div class="col-lg-10"><textarea name="description" placeholder="Description" class="form-control"></textarea></div>
																</div>
																<div class="form-group">
																	<div class="col-lg-offset-2 col-lg-10">
																		<button class="btn btn-sm btn-primary save" type="button">Submit</button>
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
							<div class="col-lg-12" style="margin-top:10px;">
								<div class="ibox-content">
									<div class="table-responsive">
										<table class="table table-striped table-bordered table-hover" id="individual_types" >
											<thead>
											<tr>
												<th>Name</th>
												<th>Description</th>
												<th></th>
											</tr>
											</thead>
											<tbody>
												
											</tbody>
											<tfoot>
												<tr>
													<th>Name</th>
													<th>Description</th>
													<th></th>
												</tr>
											</tfoot>
										</table>
									</div>
								</div>
							</div>
							
						</div>
					</div>
					<!-- Loan Product Type -->
					<div id="tab-9" class="tab-pane">
						<div class="panel-body">
							<div class="col-lg-2 col-offset-sm-8">
								<div class="text-center">
									<a data-toggle="modal" class="btn btn-primary" href="#loan_product_type"><i class="fa fa-plus"></i> Add Loan Product type</a>
								</div>
								<div id="loan_product_type" class="modal fade" aria-hidden="true">
									<div class="modal-dialog">
										<div class="modal-content">
											<div class="modal-body">
												<div class="row">
													<div class="col-sm-12">
														<p>Add Loan Product Type.</p>
														<div class="ibox-content">
															<form class="form-horizontal" method="post" id="tblLoanProductType">
																<input type="hidden" name="tbl" value="loan_product_type">
																<input type="hidden" name="dateCreated" value="<?php echo time(); ?>">
																<input type="hidden" name="dateModified" value="<?php echo time(); ?>">				
																<input type="hidden" name="createdBy" value="<?php echo $_SESSION['user_id']; ?>">
																<input type="hidden" name="modifiedBy" value="<?php echo $_SESSION['user_id']; ?>">
																<div class="form-group"><label class="col-lg-2 control-label">Title</label>

																	<div class="col-lg-10"><input name="title" type="text" placeholder="Name" class="form-control"> 
																	</div>
																</div>
																<div class="form-group"><label class="col-lg-2 control-label">Description</label>
																	<div class="col-lg-10"><textarea name="description" placeholder="Description" class="form-control"></textarea></div>
																</div>
																<div class="form-group">
																	<div class="col-lg-offset-2 col-lg-10">
																		<button class="btn btn-sm btn-primary save" type="button">Submit</button>
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
							<div class="col-lg-12" style="margin-top:10px;">
								<div class="ibox-content">
									<div class="table-responsive">
										<table class="table table-striped table-bordered table-hover" id="loan_product_types">
											<thead>
											<tr>
												<th>Name</th>
												<th>Description</th>
												<th></th>
											</tr>
											</thead>
											<tbody></tbody>
											<tfoot>
												<tr>
													<th>Name</th>
													<th>Description</th>
													<th></th>
												</tr>
											</tfoot>
										</table>
									</div>
								</div>
							</div>
							
						</div>
					</div>
					<!-- Penalty Calculation Method Start -->		
					<div id="tab-12" class="tab-pane ">
						<div class="panel-body">
							<div class="col-lg-2 col-offset-sm-8">
								<div class="text-center">
									<a data-toggle="modal" class="btn btn-primary" href="#penalty"><i class="fa fa-plus"></i>Add Penalty Calculation Method</a>
								</div>
								<div id="penalty" class="modal fade" aria-hidden="true">
									<div class="modal-dialog">
										<div class="modal-content">
											<div class="modal-body">
												<div class="row">
													<div class="col-sm-12">
														<p>Add penalty  Calculation Method</p>
														<div class="ibox-content">
															<form class="form-horizontal" id="tblPenaltyCalculation">
																<input type="hidden" name="tbl" value="penality_calculation">
																<input type="hidden" name="dateCreated" value="<?php echo time(); ?>">
																<input type="hidden" name="dateModified" value="<?php echo time(); ?>">				
																<input type="hidden" name="createdBy" value="<?php echo $_SESSION['user_id']; ?>">
																<input type="hidden" name="modifiedBy" value="<?php echo $_SESSION['user_id']; ?>">
																<div class="form-group"><label class="col-lg-2 control-label">Title</label>

																	<div class="col-lg-10"><input name="methodDescription" type="text" placeholder="Penalty Title" class="form-control"> <span class="help-block m-b-none">Title of the penalty.</span>
																	</div>
																</div>
																
																<div class="form-group">
																	<div class="col-lg-offset-2 col-lg-10">
																		<button class="btn btn-lg btn-primary save" type="button">Submit</button>
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
							
							
							<div class="col-lg-12" style="margin-top:10px;">
								<div class="ibox-content">
									<div class="table-responsive">
										<table class="table table-striped table-bordered table-hover" id="penalty_calculations">
											<thead>
											<tr>
												<th>Method</th>
												<th>Date Created</th>
												<th></th>
											</tr>
											</thead>
											<tbody>
												
											</tbody>
											<tfoot>
												<tr>
													<th>Method</th>
													<th>Date Created</th>
													<th></th>
												</tr>
											</tfoot>
										</table>
									</div>
								</div>
							</div>
							
						</div>
					</div>
					<!-- Loan Product Penalty Start -->	
					<div id="tab-13" class="tab-pane ">
						<div class="panel-body">
							<div class="col-lg-2 col-offset-sm-8">
								<div class="text-center">
									<a data-toggle="modal" class="btn btn-primary" href="#loan_product_penalty"><i class="fa fa-plus"></i> Add Loan Product Penalty</a>
								</div>
								<div id="loan_product_penalty" class="modal fade" aria-hidden="true">
									<div class="modal-dialog">
										<div class="modal-content">
											<div class="modal-body">
												<div class="row">
													<div class="col-sm-12">
														<p>Add Loan Product Penalty</p>
														<div class="ibox-content">
															<form class="form-horizontal" id="tblLoanProductPenalty">
																<input type="hidden" name="tbl" value="loan_product_penalty">
																<div class="form-group"><label class="col-lg-2 control-label">Penalty </label>
																	<div class="col-lg-10">
																		<select class="form-control m-b" name="account">
																			<?php 
																			$penalty_calculation_method = new PenaltyCalculationMethod(); 
																			$all_penalties = $penalty_calculation_method->findAll(); 
																			if($all_penalties){
																				foreach($all_penalties as $single){ ?>
																					<option value="<?php echo $single['id']; ?>"><?php echo $single['methodDescription']; ?></option>
																				<?php	
																				}
																			} ?>
																		</select>
																	</div>
																</div>
																<div class="form-group"><label class="col-lg-2 control-label">Description</label>
																	<div class="col-lg-10"><textarea  placeholder="Description" class="form-control"></textarea></div>
																</div>
																<div class="form-group"><label class="col-lg-2 control-label">Penalty Charged AS</label>
																	<div class="col-lg-5">
																		<div class="i-checks"><label> <input type="radio" value="option1" name="a"> <i></i> (%) </label></div>
																		<div class="i-checks"><label> <input type="radio" checked="" value="option2" name="a"> <i></i>(Amount) </label></div>
																	</div>
																</div>
																 <div class="form-group"><label class="col-sm-2 control-label">Penalty Tolerance Period</label>
																	<div class="col-sm-10"><input type="number" placeholder="placeholder" class="form-control">Days</div>
																</div>
																<h3>Default Penalty Rate (UGX)</h3>
																<div class="col-sm-10">
																	<div class="form-group "><label class="col-sm-2 control-label">Deafault</label>
																		<div class="col-sm-5"><input name="defmount" type="text" class="form-control"></div>
																	</div>
																	<div class="form-group "><label class="col-sm-2 control-label">Min</label>
																		<div class="col-sm-5"><input id="minAmount" name="minAmount" type="text" class="form-control"></div>
																	</div>	
																	<div class="form-group"><label class="col-sm-2 control-label">Max</label>
																		<div class="col-sm-5"><input id="maxAmount" name="maxAmount" type="text" class="form-control"></div>
																	</div>	
																</div>
																<div class="form-group">
																	<div class="col-lg-offset-2 col-lg-10">
																		<button class="btn btn-sm btn-primary save" type="button">Submit</button>
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
							<div class="col-lg-12" style="margin-top:10px;">
								<div class="ibox-content">
									<div class="table-responsive">
										<table class="table table-striped table-bordered table-hover" id="loan_product_penalties">
											<thead>
											<tr>
												<th>Description</th>
												<th>Penalty</th>
												<th>penaltyChargedAs</th>
												<th>penaltyTolerancePeriod</th>
												<th>defaultAmount</th>
												<th>minAmount</th>
												<th>maxAmount</th>
												<th></th>
											</tr>
											</thead>
											<tbody>
												
											</tbody>
											<tfoot>
												<th>Description</th>
												<th>Penalty</th>
												<th>penaltyChargedAs</th>
												<th>penaltyTolerancePeriod</th>
												<th>defaultAmount</th>
												<th>minAmount</th>
												<th>maxAmount</th>
												<th></th>
											</tfoot>
										</table>
									</div>
								</div>
							</div>
							
						</div>
					</div>
					<!--End Loan Product penality-->
					<!-- Relationhip Type-->
					<div id="tab-14" class="tab-pane">
						<div class="panel-body">
							<div class="col-lg-2 col-offset-sm-8">
								<div class="text-center">
									<a data-toggle="modal" class="btn btn-primary" href="#relation_type"><i class="fa fa-plus"></i> Add Relationhip type</a>
								</div>
								<div id="relation_type" class="modal fade" aria-hidden="true">
									<div class="modal-dialog">
										<div class="modal-content">
											<div class="modal-body">
												<div class="row">
													<div class="col-sm-12">
														<p>Add Relationhip Type.</p>
														<div class="ibox-content">
															<form class="form-horizontal" id="tblRelationType">
																<input type="hidden" name="tbl"  value="relation_type">
																<div class="form-group"><label class="col-lg-2 control-label">Name</label>
																	<div class="col-lg-10"><input type="text" name="rel_type" placeholder="Name" class="form-control"> 
																	</div>
																</div>
																<div class="form-group"><label class="col-lg-2 control-label">Description</label>
																	<div class="col-lg-10"><textarea  name="description" placeholder="Description" class="form-control"></textarea></div>
																</div>
																<div class="form-group">
																	<div class="col-lg-offset-2 col-lg-10">
																		<button class="btn btn-sm btn-primary save" type="button">Submit</button>
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
							<div class="col-lg-12" style="margin-top:10px;">
								<div class="ibox-content">
									<div class="table-responsive">
										<table class="table table-striped table-bordered table-hover" id="relationship_types">
											<thead>
											<tr>
												<th>Type</th>
												<th>Description</th>
												<th></th>
											</tr>
											</thead>
											<tbody></tbody>
											<tfoot>
												<tr>
													<th>Type</th>
													<th>Description</th>
													<th></th>
												</tr>
											</tfoot>
										</table>
									</div>
								</div>
							</div>
							
						</div>
					</div>
					<!-- End Security Type-->
					<!-- Repayment Duration -->
					<div id="tab-15" class="tab-pane">
						<div class="panel-body">
							<div class="col-lg-2 col-offset-sm-8">
								<div class="text-center">
									<a data-toggle="modal" class="btn btn-primary" href="#loan_repayment_duration"><i class="fa fa-plus"></i> Add repayment duration</a>
								</div>
								<div id="loan_repayment_duration" class="modal fade" aria-hidden="true">
									<div class="modal-dialog">
										<div class="modal-content">
											<div class="modal-body">
												<div class="row">
													<div class="col-sm-12">
														<p>Add repayment duration.</p>
														<div class="ibox-content">
															<form class="form-horizontal" id="tblRepaymentDuration">
																<input type="hidden" name="tbl" value="repayment_duration">
																<div class="form-group"><label class="col-lg-2 control-label">Name</label>
																	<div class="col-lg-10"><input type="text" name="name" placeholder="Name" class="form-control"> <span class="help-block m-b-none">Name of the person type.</span>
																	</div>
																</div>
																<div class="form-group"><label class="col-lg-2 control-label">Pay Back Days</label>
																	<div class="col-lg-10"><input type="number" name="no_of_days" placeholder="Name" class="form-control"> <span class="help-block m-b-none">Numbe of days to pay back a loan.</span>
																	</div>
																</div>
																<div class="form-group">
																	<div class="col-lg-offset-2 col-lg-10">
																		<button class="btn btn-sm btn-primary save" type="button">Submit</button>
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
							<div class="col-lg-12" style="margin-top:10px;">
								<div class="ibox-content">
									<div class="table-responsive">
										<table class="table table-striped table-bordered table-hover" id="loan_repayment_durations">
											<thead>
											<tr>
												<th>Name</th>
												<th>Pay Back Days</th>
												<th></th>
											</tr>
											</thead>
											<tbody></tbody>
											<tfoot>
												<tr>
													<th>Name</th>
													<th>Pay Back Days</th>
													<th></th>
												</tr>
											</tfoot>
										</table>
									</div>
								</div>
							</div>
							
						</div>
					</div>
					<!-- End repayment duration--->
					<!-- Security Type-->
					<div id="tab-16" class="tab-pane">
						<div class="panel-body">
							<div class="col-lg-2 col-offset-sm-8">
								<div class="text-center">
									<a data-toggle="modal" class="btn btn-primary" href="#security_type"><i class="fa fa-plus"></i> Add Security type</a>
								</div>
								<div id="security_type" class="modal fade" aria-hidden="true">
									<div class="modal-dialog">
										<div class="modal-content">
											<div class="modal-body">
												<div class="row">
													<div class="col-sm-12">
														<p>Add Security Type.</p>
														<div class="ibox-content">
															<form class="form-horizontal" id="tblSecurityType">
																<input type="hidden" name="tbl"  value="security_type">
																<div class="form-group"><label class="col-lg-2 control-label">Name</label>
																	<div class="col-lg-10"><input type="text" name="name" placeholder="Name" class="form-control"> 
																	</div>
																</div>
																<div class="form-group"><label class="col-lg-2 control-label">Description</label>
																	<div class="col-lg-10"><textarea  name="description" placeholder="Description" class="form-control"></textarea></div>
																</div>
																<div class="form-group">
																	<div class="col-lg-offset-2 col-lg-10">
																		<button class="btn btn-sm btn-primary save" type="button">Submit</button>
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
							<div class="col-lg-12" style="margin-top:10px;">
								<div class="ibox-content">
									<div class="table-responsive">
										<table class="table table-striped table-bordered table-hover" id="security_types">
											<thead>
											<tr>
												<th>Name</th>
												<th>Description</th>
												<th></th>
											</tr>
											</thead>
											<tbody></tbody>
											<tfoot>
												<tr>
													<th>Name</th>
													<th>Description</th>
													<th></th>
												</tr>
											</tfoot>
										</table>
									</div>
								</div>
							</div>
							
						</div>
					</div>
					<!-- End Security Type-->
					<!-- Position -->
					<div id="tab-17" class="tab-pane">
						<div class="panel-body">
							<div class="col-lg-2 col-offset-sm-8">
								<div class="text-center">
									<a data-toggle="modal" class="btn btn-primary" href="#position"><i class="fa fa-plus"></i> Add Position</a>
								</div>
								<div id="position" class="modal fade" aria-hidden="true">
									<div class="modal-dialog">
										<div class="modal-content">
											<div class="modal-body">
												<div class="row">
													<div class="col-sm-12">
														<p>Add Position</p>
														<div class="ibox-content">
															<form class="form-horizontal" id="tblPosition">
																<input type="hidden" name="tbl"  value="position">
																<div class="form-group"><label class="col-lg-2 control-label">Name</label>
																	<div class="col-lg-10"><input type="text" name="name" placeholder="Name" class="form-control"> 
																	</div>
																</div>
																<div class="form-group"><label class="col-lg-2 control-label">Description</label>
																	<div class="col-lg-10"><textarea  name="description" placeholder="Description" class="form-control"></textarea></div>
																</div>
																<div class="form-group">
																	<div class="col-lg-offset-2 col-lg-10">
																		<button class="btn btn-sm btn-primary save" type="button">Submit</button>
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
							<div class="col-lg-12" style="margin-top:10px;">
								<div class="ibox-content">
									<div class="table-responsive">
										<table class="table table-striped table-bordered table-hover" id="positions">
											<thead>
											<tr>
												<th>Name</th>
												<th>Description</th>
												<th></th>
											</tr>
											</thead>
											<tbody></tbody>
											<tfoot>
												<tr>
													<th>Name</th>
													<th>Description</th>
													<th></th>
												</tr>
											</tfoot>
										</table>
									</div>
								</div>
							</div>
							
						</div>
					</div>
					<!-- End Position -->
					
					<!-- Adress Type -->
					<div id="tab-18" class="tab-pane">
						<div class="panel-body">
							<div class="col-lg-2 col-offset-sm-8">
								<div class="text-center">
									<a data-toggle="modal" class="btn btn-primary" href="#address_type"><i class="fa fa-plus"></i> Add Adress Type</a>
								</div>
								<div id="address_type" class="modal fade" aria-hidden="true">
									<div class="modal-dialog">
										<div class="modal-content">
											<div class="modal-body">
												<div class="row">
													<div class="col-sm-12">
														<p>Add  Adress Type</p>
														<div class="ibox-content">
															<form class="form-horizontal" id="tblAdressType">
																<input type="hidden" name="tbl"  value="address_type">
																<div class="form-group"><label class="col-lg-2 control-label">Type</label>
																	<div class="col-lg-10"><input type="text" name="address_type" placeholder="Adress Type" class="form-control"> 
																	</div>
																</div>
																<div class="form-group"><label class="col-lg-2 control-label">Description</label>
																	<div class="col-lg-10"><textarea  name="description" placeholder="Description" class="form-control"></textarea></div>
																</div>
																<div class="form-group">
																	<div class="col-lg-offset-2 col-lg-10">
																		<button class="btn btn-sm btn-primary save" type="button">Submit</button>
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
							<div class="col-lg-12" style="margin-top:10px;">
								<div class="ibox-content">
									<div class="table-responsive">
										<table class="table table-striped table-bordered table-hover" id="adress_types">
											<thead>
											<tr>
												<th>Name</th>
												<th>Description</th>
												<th>Edit / Delete</th>
											</tr>
											</thead>
											<tbody></tbody>
											<tfoot>
												<tr>
													<th>Name</th>
													<th>Description</th>
													<th></th>
												</tr>
											</tfoot>
										</table>
									</div>
								</div>
							</div>
							
						</div>
					</div>
					<!-- End Adress Type -->
					<!-- Marital Status -->
					<div id="tab-19" class="tab-pane">
						<div class="panel-body">
							<div class="col-lg-2 col-offset-sm-8">
								<div class="text-center">
									<a data-toggle="modal" class="btn btn-primary" href="#marital_status"><i class="fa fa-plus"></i> Add Marital Status</a>
								</div>
								<div id="marital_status" class="modal fade" aria-hidden="true">
									<div class="modal-dialog">
										<div class="modal-content">
											<div class="modal-body">
												<div class="row">
													<div class="col-sm-12">
														<p>Add  Marital Status</p>
														<div class="ibox-content">
															<form class="form-horizontal" id="tblMaritalStatus">
																<input type="hidden" name="tbl"  value="marital_status">
																<div class="form-group"><label class="col-lg-2 control-label">Name</label>
																	<div class="col-lg-10"><input type="text" name="name" placeholder="Adress Type" class="form-control"> 
																	</div>
																</div>
																<div class="form-group"><label class="col-lg-2 control-label">Description</label>
																	<div class="col-lg-10"><textarea  name="description" placeholder="Description" class="form-control"></textarea></div>
																</div>
																<div class="form-group">
																	<div class="col-lg-offset-2 col-lg-10">
																		<button class="btn btn-sm btn-primary save" type="button">Submit</button>
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
							<div class="col-lg-12" style="margin-top:10px;">
								<div class="ibox-content">
									<div class="table-responsive">
										<table class="table table-striped table-bordered table-hover" id="marital-status">
											<thead>
											<tr>
												<th>Name</th>
												<th>Description</th>
												<th>Edit / Delete</th>
											</tr>
											</thead>
											<tbody></tbody>
											<tfoot>
												<tr>
													<th>Name</th>
													<th>Description</th>
													<th></th>
												</tr>
											</tfoot>
										</table>
									</div>
								</div>
							</div>
							
						</div>
					</div>
					<!-- End Marital Status -->
					<!-- Loan Products -->
					<div id="tab-20" class="tab-pane active">
						<div class="panel-body">
							<div class="col-lg-2 col-offset-sm-8">
								<div class="text-center">
									<a data-toggle="modal" class="btn btn-primary" href="#loan_products"><i class="fa fa-plus"></i> Add Loan Product</a>
								</div>
								<div id="loan_products" class="modal fade" aria-hidden="true">
									<div class="modal-dialog modal-lg">
										<div class="modal-content">
											<div class="modal-body">
												<?php include_once("loan_product.php");?>
											</div>
										</div>
									</div>
								</div>
								
							</div>
							<div class="col-lg-12" style="margin-top:10px;">
								<div class="ibox-content">
									<div class="table-responsive">
										<table class="table table-striped table-bordered table-hover" id="loan-product">
											<thead>
												<tr>
													<th>Name</th>
													<th>Description</th>
													<th>Product Type</th>
													<th>Edit / Delete</th>
												</tr>
											</thead>
											<tbody></tbody>
											<tfoot>
												<tr>
													<th>Name</th>
													<th>Description</th>
													<th>Product Type</th>
													<th></th>
												</tr>
											</tfoot>
										</table>
									</div>
								</div>
							</div>
							
						</div>
					</div>
					<!-- End Loan Products -->
					<!-- Deposit Products -->
					<div id="tab-21" class="tab-pane">
						<div class="panel-body">
							<div class="col-lg-2 col-offset-sm-8">
								<div class="text-center">
									<a data-toggle="modal" class="btn btn-primary" href="#deposit_product"><i class="fa fa-plus"></i> Add Deposit Product</a>
								</div>
								<div id="deposit_product" class="modal fade" aria-hidden="true">
									<div class="modal-dialog modal-lg">
										<div class="modal-content">
											<div class="modal-body">
												<?php include_once("deposit_product.php");?>
											</div>
										</div>
									</div>
								</div>
								
							</div>
							<div class="col-lg-12" style="margin-top:10px;">
								<div class="ibox-content">
									<div class="table-responsive">
										<table class="table table-striped table-bordered table-hover" id="deposit-product">
											<thead>
												<tr>
													<th>Name</th>
													<th>Description</th>
													<th>Product Type</th>
													<th>Edit / Delete</th>
												</tr>
											</thead>
											<tbody></tbody>
											<tfoot>
												<tr>
													<th>Name</th>
													<th>Description</th>
													<th>Product Type</th>
													<th></th>
												</tr>
											</tfoot>
										</table>
									</div>
								</div>
							</div>
							
						</div>
					</div>
					<!-- End Loan Products -->
				</div>
			</div>
		</div>
	</div>
<?php
include("include/footer.php"); 
include("js/settings_js.php");
?>