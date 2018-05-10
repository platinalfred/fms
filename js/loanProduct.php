   var LoanProductFee = function () {
        var self = this;
        self.productFee = ko.observable();
    };

    var LoanProduct = function () {
        var self = this;

        //variables for the dropdowns
        self.daysOfYearOptions = [{id: 1, desc: 'Actual/365 Fixed(365 days)'}, {id: 2, desc: '30 Day month (360 days)'}];
        self.initialAccountStateOptions = [{"id": 1, "desc": "Pending Approval"}];
        self.taxCalculationMethodOptions = [{"id": 1, "desc": "Inclusive"}, {"id": 2, "desc": "Exclusive"}];
        self.penaltyCalculationMethodOptions = ko.observableArray([{"id": 1, "methodDescription": "No penalty"}, {"id": 2, "methodDescription": "(Overdue Principal + Overdue Interest)*# of Late Days * Penalty Rate"}]);
        self.repaymentsMadeEveryOptions = [{id: 1, desc: 'Day(s)'}, {id: 2, desc: 'Week(s)'}, {id: 3, desc: 'Month(s)'}];
        self.penaltyChargeRate = [{id: 1, desc: 'Day'}, {id: 2, desc: 'Week'}, {id: 3, desc: 'Month'}];
        self.taxRateSourceOptions = [{id: 1, desc: 'URA'}, {id: 2, desc: 'GOVT'}, {id: 3, desc: 'District'}];


        self.existingLoanProductFees = ko.observableArray();
        self.addExistingLoanProductFees = ko.observableArray();
        self.newLoanProductFees = ko.observableArray([new LoanProductFee()]);


        // Stores an array of all the Data for viewing on the page
        self.productTypes = ko.observableArray([{"id": 1, "typeName": "Fixed Term Loan", "description": "A Fixed interest rate which allows accurate prediction of future payments"}, {"id": 2, "typeName": "Dynamic Term Loan", "description": "Allows dynamic calculation of the interest rate, and thus, future payments"}]);

        self.id = ko.observable();
        self.productType = ko.observable();
        self.repaymentsFrequency = ko.observable();

        /*self.taxApplicable = ko.observable(0);
        self.taxRateSource = ko.observable();
        self.taxCalculationMethod = ko.observable();*/
        self.penaltyCalculationMethod = ko.observable();
        self.penaltyTolerancePeriod = ko.observable();

        // Operations
        
        //Add a fee
        self.addNewFee = function () { self.newLoanProductFees.push(new LoanProductFee()); };
        //remove fee
        self.removeNewFee = function (fee) { self.newLoanProductFees.remove(fee); };
        self.removeExistingFee = function (fee) { self.addExistingLoanProductFees.remove(fee); };
        //reset the form
        self.resetForm = function () {
            /* if(self.newLoanProductFees())self.newLoanProductFees(null);*/
            $("#loanProductForm")[0].reset();
            self.newLoanProductFees.removeAll();
            self.productType(null);
            //self.updateLoanProductTypes();
        };
        //Update the product types list
        self.updateLoanProductTypes = function () {
            $.ajax({
                type: "post",
                dataType: "json",
                data: {origin: "loan_product"},
                url: "ajax_requests/ajax_data.php",
                success: function (response) {
                    // Now use this data to update the view models, 
                    // and Knockout will update the UI automatically
                    //if(response.length>0){
                    if (response.loanProductTypes)
                        self.productTypes(response.loanProductTypes);
                    if (response.penaltyCalculationMethods)
                        self.penaltyCalculationMethodOptions(response.penaltyCalculationMethods);
                    //if(response.taxRateSources) self.taxRateSourceOptions(response.taxRateSources);
                    if (response.existingProductFees)
                        self.existingLoanProductFees(response.existingProductFees);
                    //}					
                }
            })
        };
        //whenever editing a loan product, the fees for the particular product should be populated
        self.id.subscribe(function(newId){
            self.addExistingLoanProductFees.removeAll();
            $.ajax({
                type: "post",
                dataType: "json",
                data: {origin: "loan_product_feens", loanProductId:newId},
                url: "ajax_requests/ajax_data.php",
                success: function (response) {
                    if (typeof response.productFeens !== 'undefined'){
                        self.addExistingLoanProductFees(response.productFeens);
                    }
                }
            });
        });

    };

    var loanProductModel = new LoanProduct();
    ko.applyBindings(loanProductModel, $("#add_loan_product-modal")[0]);
    loanProductModel.updateLoanProductTypes();
    $("#loanProductForm").validate();
    
    /*
    * Loan Product Fees Object, applies to the section of loan product fees
    */
    var LoanProductFees = function () {
        var self = this;
        
        self.feeTypesOptions = ko.observableArray([{"id": 1, "description": "Fixed fee"}]);
        //Update the product fee types list
        $.ajax({
            type: "post",
            dataType: "json",
            data: {origin: "loan_product_fee_types"},
            url: "ajax_requests/ajax_data.php",
            success: function (response) {
                if (response.feeTypes)
                {
                     self.feeTypesOptions(response.feeTypes);
                }
            }
        });

    };
    var loanProductFeesModel = new LoanProductFees();
    ko.applyBindings(loanProductFeesModel, $("#add_loan_product_fee-modal")[0]);