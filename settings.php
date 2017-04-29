<?php 
session_start();
include("includes/header.php"); 
require_once("lib/Forms.php");
?>
<div class="wrapper wrapper-content  animated fadeInRight">
	<div class="row wrapper border-bottom white-bg page-heading">
		<div class="col-lg-12  m-b-md" style="padding-top:10px;">
			<div class="tabs-container">
				<ul class="nav nav-tabs">
					<li class="active"><a data-toggle="tab" href="#tab-1" href="#">Person Types</a></li>
					<li class=""><a data-toggle="tab" href="#tab-2" href="#">Account Types</a></li>
					<li class=""><a data-toggle="tab" href="#tab-3" href="#">Branches</a></li>
					<li class=""><a data-toggle="tab" href="#tab-4" href="#">Access Levels</a></li>
					<li class=""><a data-toggle="tab" href="#tab-6" href="#">Id Card Types</a></li>
					<li class=""><a data-toggle="tab" href="#tab-7" href="#">Income Sources</a></li>
					<li class=""><a data-toggle="tab" href="#tab-8" href="#">Individual Types</a></li>
					<li class=""><a data-toggle="tab" href="#tab-9" href="#">Loan Product Types</a></li>
					<li class=""><a data-toggle="tab" href="#tab-10"href="#">Loan Products</a></li>
					<li class=""><a data-toggle="tab" href="#tab-11" href="#">Loan Types</a></li>
					<li class=""><a data-toggle="tab" href="#tab-12" href="#">Penalty</a></li>
					<li class=""><a data-toggle="tab" href="#tab-13" href="#">Position</a></li>
					<li class=""><a data-toggle="tab" href="#tab-14" href="#">Relationhip Types</a></li>
					<li class=""><a data-toggle="tab" href="#tab-15" href="#">Repayment Duration</a></li>
					<li class=""><a data-toggle="tab" href="#tab-16" href="#">Security Types </a></li>
				</ul>
				<div class="tab-content">
<!---  Person Type Start                                                      --->
					<div id="tab-1" class="tab-pane active">
						<div class="panel-body">
							<div class="col-lg-2 col-offset-sm-8">
								<div class="text-center">
									<a data-toggle="modal" class="btn btn-primary" href="#person_type"><i class="fa fa-plus"></i> Add person type</a>
								</div>
								<div id="person_type" class="modal fade" aria-hidden="true">
									<div class="modal-dialog">
										<div class="modal-content">
											<div class="modal-body">
												<div class="row">
													<div class="col-sm-12">
														<p>Add Person Type.</p>
														<div class="ibox-content">
															<form class="form-horizontal">
																<input name="person_type" type="hidden">
																<div class="form-group"><label class="col-lg-2 control-label">Name</label>

																	<div class="col-lg-10"><input name="name" type="text" placeholder="Name" class="form-control"> <span class="help-block m-b-none">Name of the person type.</span>
																	</div>
																</div>
																<div class="form-group"><label class="col-lg-2 control-label">Description</label>
																	<div class="col-lg-10"><textarea name="description" placeholder="Description" class="form-control"></textarea></div>
																</div>
																<div class="form-group">
																	<div class="col-lg-offset-2 col-lg-10">
																		<button class="btn btn-sm btn-white save" type="submit">Submit</button>
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
					</div>
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
												<div class="row">
													<div class="col-sm-12">
														<p>Add Account Type.</p>
														<div class="ibox-content">
															<form class="form-horizontal"> 
																<input type="hidden" name="account_type">
																<div class="form-group"><label class="col-lg-2 control-label">Name</label>
																	<div class="col-lg-10"><input name="name" type="text" placeholder="Name" class="form-control"> <span class="help-block m-b-none">Account type name.</span>
																	</div>
																</div>
																<div class="form-group"><label class="col-lg-2 control-label">Minimum Balance</label>
																	<div class="col-lg-10"><input name="minimum_balance" type="text" placeholder="Minimum Balance" class="form-control"> <span class="help-block m-b-none">The minimum balance an account holder should keep on the account.</span>
																	</div>
																</div>
																<div class="form-group"><label class="col-lg-2 control-label">Description</label>
																	<div class="col-lg-10"><textarea  name="description" placeholder="Description" class="form-control"></textarea></div>
																</div>
																<div class="form-group">
																	<div class="col-lg-offset-2 col-lg-10">
																		<button class="btn btn-sm btn-white save" type="submit">Submit</button>
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
					</div>
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
															<form class="form-horizontal">
																<input type="hidden" name="branch">
																<div class="form-group"><label class="col-lg-2 control-label">Branch Name</label>
																	<div class="col-lg-10"><input type="text" name="branch_name"  placeholder="Branch Name" class="form-control"> 
																	</div>
																</div>
																<div class="form-group"><label class="col-lg-2 control-label"> Office Phone</label>
																	<div class="col-lg-10"><input type="text" name="office_phone"  placeholder="Office Phone" class="form-control"> 
																	</div>
																</div>
																<div class="form-group"><label class="col-lg-2 control-label">Email Address</label>
																	<div class="col-lg-10"><input type="text" name="email_address"  placeholder="Email Address" class="form-control"> 
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
																		<button class="btn btn-sm btn-white" type="submit">Submit</button>
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
					</div>
					<div id="tab-4" class="tab-pane ">
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
															<form class="form-horizontal">
																<input type="hidden" name="access_level">
																<div class="form-group"><label class="col-lg-2 control-label">Name</label>

																	<div class="col-lg-10"><input name="name" type="text" placeholder="Name" class="form-control"> <span class="help-block m-b-none">Access Level name (e.g Administrator).</span>
																	</div>
																</div>
																<div class="form-group"><label class="col-lg-2 control-label">Description</label>
																	<div class="col-lg-10"><textarea name="description" placeholder="Description" class="form-control"></textarea></div>
																</div>
																<div class="form-group">
																	<div class="col-lg-offset-2 col-lg-10">
																		<button class="btn btn-sm btn-white" type="submit">Submit</button>
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
					</div>
					<div id="tab-6" class="tab-pane">
						<div class="panel-body">
							<div class="col-lg-2 col-offset-sm-8">
								<div class="text-center">
									<a data-toggle="modal" class="btn btn-primary" href="#id_card_type"><i class="fa fa-plus"></i> Add ID Card type</a>
								</div>
								<div id="id_card_type" class="modal fade" aria-hidden="true">
									<div class="modal-dialog">
										<div class="modal-content">
											<div class="modal-body">
												<div class="row">
													<div class="col-sm-12">
														<p>Add ID Card Type.</p>
														<div class="ibox-content">
															<form class="form-horizontal">
																<input type="hidden" name="id_card_type">
																<div class="form-group"><label class="col-lg-2 control-label">Id Type Name</label>

																	<div class="col-lg-10"><input type="text" name="id_type" placeholder="Id Card Type" class="form-control"> <span class="help-block m-b-none">Type of the card identifying an individual( e.g Passport).</span>
																	</div>
																</div>
																<div class="form-group">
																	<div class="col-lg-offset-2 col-lg-10">
																		<button class="btn btn-sm btn-white save" type="submit">Submit</button>
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
					</div>
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
															<form class="form-horizontal">
																<input name="income_source" type="hidden">
																<div class="form-group"><label class="col-lg-2 control-label">Name</label>
																	<div class="col-lg-10"><input name="name" type="text" placeholder="Name" class="form-control"> <span class="help-block m-b-none">Add source of organization income.</span>
																	</div>
																</div>
																<div class="form-group"><label class="col-lg-2 control-label">Description</label>
																	<div class="col-lg-10"><textarea name="description" placeholder="Description" class="form-control"></textarea></div>
																</div>
																<div class="form-group">
																	<div class="col-lg-offset-2 col-lg-10">
																		<button class="btn btn-sm btn-white" type="submit">Submit</button>
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
					</div>
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
															<form class="form-horizontal">
																<input type="hidden" name="individual_type">
																<div class="form-group"><label class="col-lg-2 control-label">Name</label>

																	<div class="col-lg-10"><input name="name" type="text" placeholder="Name" class="form-control"> <span class="help-block m-b-none">Specify the forms by which an individual can be registered (e.g Member Only).</span>
																	</div>
																</div>
																<div class="form-group"><label class="col-lg-2 control-label">Description</label>
																	<div class="col-lg-10"><textarea name="description" placeholder="Description" class="form-control"></textarea></div>
																</div>
																<div class="form-group">
																	<div class="col-lg-offset-2 col-lg-10">
																		<button class="btn btn-sm btn-white" type="submit">Submit</button>
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
					</div>
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
															<form class="form-horizontal">
																<input type="hidden" name="loan_product_type">
																<input type="hidden" name="dateCreated" value="<?php echo time(); ?>">
																<input type="hidden" name="dateModified" value="<?php echo time(); ?>">				
																<input type="hidden" name="createdBy" value="<?php echo $_SESSION['user_id']; ?>">
																<input type="hidden" name="modifiedBy" value="<?php echo $_SESSION['user_id']; ?>">
																
																<div class="form-group"><label class="col-lg-2 control-label">Description</label>
																	<div class="col-lg-10"><textarea name="description" placeholder="Description" class="form-control"></textarea></div>
																</div>
																<div class="form-group">
																	<div class="col-lg-offset-2 col-lg-10">
																		<button class="btn btn-sm btn-white" type="submit">Submit</button>
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
					</div>
					<div id="tab-10" class="tab-pane">
						<div class="panel-body">
							<div class="col-lg-2 col-offset-sm-8">
								<div class="text-center">
									<a data-toggle="modal" class="btn btn-primary" href="#loan_product"><i class="fa fa-plus"></i> Add Loan Product</a>
								</div>
								<div id="loan_product" class="modal fade" aria-hidden="true">
									<div class="modal-dialog">
										<div class="modal-content">
											<div class="modal-body">
												<div class="row">
													<div class="col-sm-12">
														<p>Add Loan Product.</p>
														<div class="ibox-content">
															<form class="form-horizontal">
																<input type="hidden" name="loan_product">
																<div class="form-group"><label class="col-lg-2 control-label">Name</label>
																	<div class="col-lg-10"><input type="text" name="name" placeholder="Name" class="form-control"> <span class="help-block m-b-none">Name of the loan product.</span>
																	</div>
																</div>
																<div class="form-group"><label class="col-lg-2 control-label">Description</label>
																	<div class="col-lg-10"><textarea  name="description" placeholder="Description" class="form-control"></textarea></div>
																</div>
																<div class="form-group">
																	<label class="col-sm-2 control-label">Product Type</label>
																	<div class="col-sm-10">
																		<select class="form-control m-b" name="account">
																			<option>option 1</option>
																			<option>option 2</option>
																			<option>option 3</option>
																			<option>option 4</option>
																		</select>
																	</div>
																</div>
																<div class="form-group "><label class="col-sm-2 control-label">Minimum Ammount</label>
																	<div class="col-sm-10"><input name="minAmount" type="text" class="form-control"></div>
																</div>
																<div class="form-group"><label class="col-sm-2 control-label">Maximum Ammount</label>
																	<div class="col-sm-10"><input name="maxAmount" type="text" class="form-control"></div>
																</div>
																<div class="form-group"><label class="col-sm-2 control-label">Minimum Interest Rate</label>
																	<div class="col-sm-10"><input name="minInterest" type="text" class="form-control"></div>
																</div>
																<div class="form-group"><label class="col-sm-2 control-label">Maximum Interest Rate</label>
																	<div class="col-sm-10"><input name="maxiInterest" type="text" class="form-control"></div>
																</div>
																<div class="form-group "><label class="col-sm-2 control-label">RepaymentMadeEvery</label>
																	<div class="col-sm-10"><input name="repaymentsMadeEvery" type="text" class="form-control"></div>
																</div>
																<div class="form-group">
																	<div class="col-lg-offset-2 col-lg-10">
																		<button class="btn btn-sm btn-white" type="submit">Submit</button>
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
					</div>
					<div id="tab-11" class="tab-pane">
						<div class="panel-body">
							<div class="col-lg-2 col-offset-sm-8">
								<div class="text-center">
									<a data-toggle="modal" class="btn btn-primary" href="#modal-form"><i class="fa fa-plus"></i> Add person type</a>
								</div>
								<div id="modal-form" class="modal fade" aria-hidden="true">
									<div class="modal-dialog">
										<div class="modal-content">
											<div class="modal-body">
												<div class="row">
													<div class="col-sm-12">
														<p>Add Person Type.</p>
														<div class="ibox-content">
															<form class="form-horizontal">
																<div class="form-group"><label class="col-lg-2 control-label">Name</label>

																	<div class="col-lg-10"><input type="text" placeholder="Name" class="form-control"> <span class="help-block m-b-none">Name of the person type.</span>
																	</div>
																</div>
																<div class="form-group"><label class="col-lg-2 control-label">Description</label>
																	<div class="col-lg-10"><textarea  placeholder="Description" class="form-control"></textarea></div>
																</div>
																<div class="form-group">
																	<div class="col-lg-offset-2 col-lg-10">
																		<button class="btn btn-sm btn-white" type="submit">Submit</button>
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
					</div>
					<div id="tab-12" class="tab-pane ">
						<div class="panel-body">
							<div class="col-lg-2 col-offset-sm-8">
								<div class="text-center">
									<a data-toggle="modal" class="btn btn-primary" href="#modal-form"><i class="fa fa-plus"></i> Add person type</a>
								</div>
								<div id="modal-form" class="modal fade" aria-hidden="true">
									<div class="modal-dialog">
										<div class="modal-content">
											<div class="modal-body">
												<div class="row">
													<div class="col-sm-12">
														<p>Add Person Type.</p>
														<div class="ibox-content">
															<form class="form-horizontal">
																<div class="form-group"><label class="col-lg-2 control-label">Name</label>

																	<div class="col-lg-10"><input type="text" placeholder="Name" class="form-control"> <span class="help-block m-b-none">Name of the person type.</span>
																	</div>
																</div>
																<div class="form-group"><label class="col-lg-2 control-label">Description</label>
																	<div class="col-lg-10"><textarea  placeholder="Description" class="form-control"></textarea></div>
																</div>
																<div class="form-group">
																	<div class="col-lg-offset-2 col-lg-10">
																		<button class="btn btn-sm btn-white" type="submit">Submit</button>
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
					</div>
					<div id="tab-13" class="tab-pane ">
						<div class="panel-body">
							<div class="col-lg-2 col-offset-sm-8">
								<div class="text-center">
									<a data-toggle="modal" class="btn btn-primary" href="#modal-form"><i class="fa fa-plus"></i> Add person type</a>
								</div>
								<div id="modal-form" class="modal fade" aria-hidden="true">
									<div class="modal-dialog">
										<div class="modal-content">
											<div class="modal-body">
												<div class="row">
													<div class="col-sm-12">
														<p>Add Person Type.</p>
														<div class="ibox-content">
															<form class="form-horizontal">
																<div class="form-group"><label class="col-lg-2 control-label">Name</label>

																	<div class="col-lg-10"><input type="text" placeholder="Name" class="form-control"> <span class="help-block m-b-none">Name of the person type.</span>
																	</div>
																</div>
																<div class="form-group"><label class="col-lg-2 control-label">Description</label>
																	<div class="col-lg-10"><textarea  placeholder="Description" class="form-control"></textarea></div>
																</div>
																<div class="form-group">
																	<div class="col-lg-offset-2 col-lg-10">
																		<button class="btn btn-sm btn-white" type="submit">Submit</button>
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
					</div>
					<div id="tab-14" class="tab-pane ">
						<div class="panel-body">
							<div class="col-lg-2 col-offset-sm-8">
								<div class="text-center">
									<a data-toggle="modal" class="btn btn-primary" href="#modal-form"><i class="fa fa-plus"></i> Add person type</a>
								</div>
								<div id="modal-form" class="modal fade" aria-hidden="true">
									<div class="modal-dialog">
										<div class="modal-content">
											<div class="modal-body">
												<div class="row">
													<div class="col-sm-12">
														<p>Add Person Type.</p>
														<div class="ibox-content">
															<form class="form-horizontal">
																<div class="form-group"><label class="col-lg-2 control-label">Name</label>

																	<div class="col-lg-10"><input type="text" placeholder="Name" class="form-control"> <span class="help-block m-b-none">Name of the person type.</span>
																	</div>
																</div>
																<div class="form-group"><label class="col-lg-2 control-label">Description</label>
																	<div class="col-lg-10"><textarea  placeholder="Description" class="form-control"></textarea></div>
																</div>
																<div class="form-group">
																	<div class="col-lg-offset-2 col-lg-10">
																		<button class="btn btn-sm btn-white" type="submit">Submit</button>
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
					</div>
					<div id="tab-15" class="tab-pane">
						<div class="panel-body">
							<div class="col-lg-2 col-offset-sm-8">
								<div class="text-center">
									<a data-toggle="modal" class="btn btn-primary" href="#modal-form"><i class="fa fa-plus"></i> Add person type</a>
								</div>
								<div id="modal-form" class="modal fade" aria-hidden="true">
									<div class="modal-dialog">
										<div class="modal-content">
											<div class="modal-body">
												<div class="row">
													<div class="col-sm-12">
														<p>Add Person Type.</p>
														<div class="ibox-content">
															<form class="form-horizontal">
																<div class="form-group"><label class="col-lg-2 control-label">Name</label>

																	<div class="col-lg-10"><input type="text" placeholder="Name" class="form-control"> <span class="help-block m-b-none">Name of the person type.</span>
																	</div>
																</div>
																<div class="form-group"><label class="col-lg-2 control-label">Description</label>
																	<div class="col-lg-10"><textarea  placeholder="Description" class="form-control"></textarea></div>
																</div>
																<div class="form-group">
																	<div class="col-lg-offset-2 col-lg-10">
																		<button class="btn btn-sm btn-white" type="submit">Submit</button>
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
					</div>
					<div id="tab-16" class="tab-pane">
						<div class="panel-body">
							<div class="col-lg-2 col-offset-sm-8">
								<div class="text-center">
									<a data-toggle="modal" class="btn btn-primary" href="#modal-form"><i class="fa fa-plus"></i> Add person type</a>
								</div>
								<div id="modal-form" class="modal fade" aria-hidden="true">
									<div class="modal-dialog">
										<div class="modal-content">
											<div class="modal-body">
												<div class="row">
													<div class="col-sm-12">
														<p>Add Person Type.</p>
														<div class="ibox-content">
															<form class="form-horizontal">
																<div class="form-group"><label class="col-lg-2 control-label">Name</label>

																	<div class="col-lg-10"><input type="text" placeholder="Name" class="form-control"> <span class="help-block m-b-none">Name of the person type.</span>
																	</div>
																</div>
																<div class="form-group"><label class="col-lg-2 control-label">Description</label>
																	<div class="col-lg-10"><textarea  placeholder="Description" class="form-control"></textarea></div>
																</div>
																<div class="form-group">
																	<div class="col-lg-offset-2 col-lg-10">
																		<button class="btn btn-sm btn-white" type="submit">Submit</button>
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
					</div>
					
				</div>


			</div>
		</div>
	</div>
</div>
<?php
include("includes/footer.php"); 
?>