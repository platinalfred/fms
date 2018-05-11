<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
        <title>Import CSV</title>
    </head>

    <body>
        <?php
        require_once("../lib/class.db.inc.php");
        require_once("../lib/func.inc.php");
        $db_class = new DB_Stupid();
        if (isset($_POST['submit'])) {
            set_time_limit(8980);
            $filename = $_POST['filename'];

            $handle = fopen("$filename", "r");

            while (($data = fgetcsv($handle, 90048576, ",")) !== FALSE) {
                $data = $db_class->sanitizeAttributes($data);
                $import = "INSERT into  old_invoices(InvoiceID, InvoiceType, CustID, dtInvoice, OrigDocID, dtDue, cySaleOnly) values('$data[0]','$data[1]','$data[2]','$data[3]','$data[4]','$data[5]','$data[6]')";
                mysql_query($import) or die(mysql_error());
            }
            fclose($handle);
            print "Import done";
        } else {

            print "<form action='old_invoices.php' method='post'>";

            print "Type file name to import:<br>";

            print "<input type='text' name='filename' size='20'><br>";

            print "<input type='submit' name='submit' value='submit'></form>";
        }
        ?>
    </body>
</html>