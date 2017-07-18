
			<div class="col-lg-12">
				<div class="ibox">
					<div class="ibox-title" style="border-top:none;">
						<h5>Member Subscription</h5>
						<div class="ibox-tools">
							<a class="collapse-link">
								<i class="fa fa-chevron-down"></i>
							</a>
						</div>
					</div>
					<div class="ibox-content collapse in">
						<div class="table-responsive">
							<table id="general_subscription" class="table table-bordered">
								<thead>
									<tr>
										<?php 
										$header_keys = array("Member", "Amount", "Subscription Year", "Date Subscribed");
										foreach($header_keys as $key){ ?>
											<th><?php echo $key; ?></th>
											<?php 
										} ?>
									</tr>
								</thead>
								<tbody>
								</tbody>
								<tfoot>
									<tr><?php foreach($header_keys as $key){ ?>
											<th><?php echo ""; ?></th>
											<?php 
										} ?>
									</tr>
								</tfoot>
								
							</table>
						</div>
					</div>
				</div>
			</div>