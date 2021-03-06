<script type="text/javascript">
    var Dashboard = function () {
        var self = this;
        // Stores an array of all the Data for viewing in the Dashboard
        self.dashboardData = ko.observable({"figures": {"no_members": "0", "portfolio": "0"}, "percents": {"members_percent": 10}, "tables": {"income": [], "expenses": []}});
        self.startDate = ko.observable(startDate);
        self.endDate = ko.observable(endDate);

        // Operations
        self.updateData = function () {
            $.ajax({
                type: "post",
                dataType: "json",
                data: {start_date: self.startDate, end_date: self.endDate, origin: "dashboard"},
                url: "ajax_requests/ajax_data.php",
                success: function (response) {
                    // Now use this data to update the view models, 
                    // and Knockout will update the UI automatically 
                    self.dashboardData(response);

                    if (response.graph_data) {
                        draw_pie_chart(response.pie_chart_data);
                        draw_line_highchart(response.graph_data);//
                    }

                }
            })
        };
    };

    var dashModel = new Dashboard();
    dashModel.updateData();
    ko.applyBindings(dashModel);

    function handleDateRangePicker(start_date, end_date) {
        dashModel.startDate(start_date);
        dashModel.endDate(end_date);
        dashModel.updateData();
    }
</script>