       </div>
		<div class="footer">
            <div>
				<strong>Copyright</strong> Buladde Fincial Services &copy; 2017 <?php if(date("Y") != 2017 ){ echo "- ".date("Y"); } ?>
			</div>
        </div>

        </div>
        </div>



    <!-- Mainly scripts -->
    <script src="js/jquery-2.1.1.js"></script>
    <script src="js/bootstrap.min.js"></script>
    <script src="js/plugins/metisMenu/jquery.metisMenu.js"></script>
    <script src="js/plugins/slimscroll/jquery.slimscroll.min.js"></script>

    <!-- Custom and plugin javascript -->
    <script src="js/inspinia.js"></script>
    <script src="js/plugins/pace/pace.min.js"></script>
	<?php 
	if($show_i_check){ ?>
		 <!-- iCheck -->
		<script src="js/plugins/iCheck/icheck.min.js"></script>
		<script>
			$(document).ready(function () {
				$('.i-checks').iCheck({
					checkboxClass: 'icheckbox_square-green',
					radioClass: 'iradio_square-green',
				});
			});
		</script>
	<?php 
	}
	?>
</body>
</html>