       </div>
		
        </div>
        </div>



    <!-- Mainly scripts -->
    <script src="js/jquery-2.1.1.js"></script>
    <script src="js/bootstrap.min.js"></script>
    <script src="js/plugins/metisMenu/jquery.metisMenu.js"></script>
    <script src="js/plugins/slimscroll/jquery.slimscroll.min.js"></script>
	<script src="js/jquery.validate.min.js" type="text/javascript"></script>
    <!-- Custom and plugin javascript -->
    <script src="js/inspinia.js"></script>
    <script src="js/plugins/pace/pace.min.js"></script>
	<script type="text/javascript" src="js/jquery.priceformat.min.js"></script>
	<?php
	if(in_array("dataTables", $needed_files)){
		?>
		<script src="js/plugins/dataTables/datatables.min.js"></script>
	<?php 
	}
	if(in_array("iCheck", $needed_files)){ ?>
		 <!-- iCheck -->
		<script src="js/plugins/iCheck/icheck.min.js"></script>
		<script>
			$(document).ready(function () {
				$('.i-checks').iCheck({
					checkboxClass: 'icheckbox_square-green',
					radioClass: 'iradio_square-green',
				});
				
				function hideStatusMessageGeneral(){
					document.getElementById('notice_message_general').style.display = 'none'; 
					document.getElementById("notice_general").innerHTML= '';
				}
				function showStatusMessageGeneral(msg, type){
					if(type=="fail"){
						$("#notice_message_general").addClass("alert-danger");
					}else{
						$("#notice_message_general").addClass("alert-success");
					}
					if(msg){
						document.getElementById("notice_general").innerHTML = msg ;
					}else{
						document.getElementById("notice_general").innerHTML ='Processing ';
					}
					document.getElementById("notice_message_general").style.display = 'block';
				}
			});
		</script>
		<?php 
	}
	if(in_array("daterangepicker", $needed_files)){ ?>
		<!-- bootstrap-daterangepicker -->
		
	<?php 
	} 
	if(in_array("Morris", $needed_files)){ ?>
		<!-- Morris -->
		    <script src="js/plugins/morris/raphael-2.1.0.min.js"></script>
		<script src="js/plugins/morris/morris.js"></script>>
	<?php 
	}
	if(in_array("Flot", $needed_files)){ ?>
		<!-- Flot -->
		<script src="js/plugins/flot/jquery.flot.js"></script>
		<script src="js/plugins/flot/jquery.flot.tooltip.min.js"></script>
		<script src="js/plugins/flot/jquery.flot.spline.js"></script>
		<script src="js/plugins/flot/jquery.flot.resize.js"></script>
		<script src="js/plugins/flot/jquery.flot.pie.js"></script>
		<script src="js/plugins/flot/jquery.flot.symbol.js"></script>
		<script src="js/plugins/flot/curvedLines.js"></script>
	<?php 
	}
	if(in_array("Peity", $needed_files)){ ?>
		
		<!-- Peity -->
		<script src="js/plugins/peity/jquery.peity.min.js"></script>
		<script src="js/demo/peity-demo.js"></script>
	<?php 
	}
	if(in_array("Jvectormap", $needed_files)){ ?>	
		 <!-- Jvectormap -->
		<script src="js/plugins/jvectormap/jquery-jvectormap-2.0.2.min.js"></script>
		<script src="js/plugins/jvectormap/jquery-jvectormap-world-mill-en.js"></script>
	<?php 
	}
	if(in_array("Sparkline", $needed_files)){ ?>
		<!-- Sparkline -->
		<script src="js/plugins/sparkline/jquery.sparkline.min.js"></script>
	<?php 
	}
	if(in_array("ChartJS", $needed_files)){ ?>
		<!-- ChartJS-->
		 <script src="js/plugins/chartJs/Chart.min.js"></script>
		<script src="js/demo/chartjs-demo.js"></script>
	<?php 
	}
	if(in_array("c3", $needed_files)){ ?>
	<!-- d3 and c3 charts -->
		<script src="js/plugins/d3/d3.min.js"></script>
		<script src="js/plugins/c3/c3.min.js"></script>
	<?php 
	}
	
	if(in_array("chosen", $needed_files)){ ?>
		  <!-- Chosen -->
		<script src="js/plugins/chosen/chosen.jquery.js"></script>
	<?php 
	}
	if(in_array("colorpicker", $needed_files)){ ?>
		  <!-- Color picker -->
		<script src="js/plugins/colorpicker/bootstrap-colorpicker.min.js"></script>
	<?php 
	}
	if(in_array("JSKnob", $needed_files)){ ?>
		<script src="js/plugins/jsKnob/jquery.knob.js"></script>
	<?php 
	}
	if(in_array("cropper", $needed_files)){ ?>
		<!-- Image cropper -->
		<script src="js/plugins/cropper/cropper.min.js"></script>
	<?php 
	}
	if(in_array("switchery", $needed_files)){ ?>
		 <!-- Switchery -->
		<script src="js/plugins/switchery/switchery.js"></script>
	<?php 
	}
	if(in_array("jasny", $needed_files)){ ?>
		<!-- Input Mask-->
		<script src="js/plugins/jasny/jasny-bootstrap.min.js"></script>
	<?php 
	}
	if(in_array("nouslider", $needed_files)){ ?>
		  <!-- NouSlider -->
		<script src="js/plugins/nouslider/jquery.nouislider.min.js"></script>
	<?php 
	}
	if(in_array("datapicker", $needed_files)){ ?>
		 <!-- Data picker -->
		<script src="js/plugins/datapicker/bootstrap-datepicker.js"></script>
	<?php 
	}
	if(in_array("ionRangeSlider", $needed_files)){ ?>
		<!-- IonRangeSlider -->
		<script src="js/plugins/ionRangeSlider/ion.rangeSlider.min.js"></script>
	<?php 
	}
	if(in_array("clockpicker", $needed_files)){ ?>
		 <!-- Clock picker -->
		<script src="js/plugins/clockpicker/clockpicker.js"></script>
	<?php 
	}
	if(in_array("daterangepicker", $needed_files)){ ?>
			 <!-- Date range picker -->
		<script src="js/plugins/daterangepicker/daterangepicker.js"></script>
	<?php 
	}
	if(in_array("select2", $needed_files)){ ?>
		 <!-- Select2 -->
		<script src="js/plugins/select2/select2.full.min.js"></script>
	<?php 
	}
	if(in_array("touchspin", $needed_files)){ ?>
		  <!-- TouchSpin -->
		<script src="js/plugins/touchspin/jquery.bootstrap-touchspin.min.js"></script>
	<?php 
	}
	if(in_array("steps", $needed_files)){ ?>
		<!-- Steps -->
		<script src="js/plugins/staps/jquery.steps.min.js"></script>
	<?php 
	}
	if(in_array("validate", $needed_files)){ ?>
		<!-- Jquery Validate -->
		<script src="js/plugins/validate/jquery.validate.min.js"></script>
	<?php 
	}
	if(in_array("validate", $needed_files)){ ?>
	  <!-- DROPZONE -->
		<script src="js/plugins/dropzone/dropzone.js"></script>
	<?php 
	}
	if(in_array("summernote", $needed_files)){ ?>
		<!-- SUMMERNOTE -->
		<script src="js/plugins/summernote/summernote.min.js"></script>
	<?php 
	}
	if(in_array("bootstrap-markdown", $needed_files)){ ?>
		  <!-- Bootstrap markdown -->
		<script src="js/plugins/bootstrap-markdown/bootstrap-markdown.js"></script>
		<script src="js/plugins/bootstrap-markdown/markdown.js"></script>
	<?php 
	}
	?>
</body>
</html>