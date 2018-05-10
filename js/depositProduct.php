<?php
$depositProductType = new DepositProductType();
$deposit_product_types = $depositProductType->findAll();
?>
    var DepositProductFee = function () {
        var self = this;
        self.productFee = ko.observable();
        self.chargeTrigger = ko.observable(),
        self.feeName = ko.observable(),
        self.amount = ko.observable(),
        self.dateApplicationMethod = ko.observable();
    };

    var DepositProduct = function () {
        var self = this;
        self.dropDowns = new Object();

        self.dropDowns.termTimeUnitOptions = [{id: 1, desc: 'Days'}, {id: 2, desc: 'Weeks'}, {id: 3, desc: 'Months'}];
        self.dropDowns.daysInYearOptions = [{id: 1, desc: 'Actual/365 Fixed(365 days)'}, {id: 2, desc: '30 Day month (360 days)'}];
        self.dropDowns.whenInterestIsPaidOptions = [{id: 1, desc: 'First day of every month'}, {id: 2, desc: 'Date when account was created'}];
        self.dropDowns.accountBalForCalcInterestOptions = [{id: 1, desc: 'Average daily balance'}, {id: 2, desc: 'Minimum balance on a given day'}];

        // Stores all the Data for viewing on the page
        self.productTypes = ko.observableArray(<?php echo json_encode($deposit_product_types); ?>);

        self.existingDepositProductFees = ko.observableArray();
        self.addExistingDepositProductFees = ko.observableArray();
        self.newDepositProductFees = ko.observableArray([new DepositProductFee()]);
        
        self.id = ko.observable();
        self.productType = ko.observable();
        self.defaultInterestRate = ko.observable();
        self.minInterestRate = ko.observable();
        self.maxInterestRate = ko.observable();
        self.interestRateApplicable = ko.observable(0);
        self.reqAttr = ko.pureComputed(function () {
            var required = false;
            if (self.defaultInterestRate() > 0 || self.minInterestRate() > 0 || self.maxInterestRate()) {
                required = true;
            }
            return required;
        });
        
        // Operations
        //1. Add a fee
        self.addNewFee = function () { self.newDepositProductFees.push(new DepositProductFee()); };
        //remove fee
        self.removeNewFee = function (fee) { self.newDepositProductFees.remove(fee); };
        self.removeExistingFee = function (fee) { self.addExistingDepositProductFees.remove(fee); };
        
        //reset the form
        self.resetForm = function () {
            $("#formDepositProduct")[0].reset();
            self.newDepositProductFees.removeAll();
        };
        //whenever editing a deposit product, the fees for the particular product should be populated
        self.id.subscribe(function(newId){
            self.addExistingDepositProductFees.removeAll();
            $.ajax({
                type: "post",
                dataType: "json",
                data: {origin: "deposit_product_feens", depositProductId:newId},
                url: "ajax_requests/ajax_data.php",
                success: function (response) {
                    if (typeof response.depositProductFeens !== 'undefined'){
                        self.addExistingDepositProductFees(response.depositProductFeens);
                    }
                }
            });
        });
        //Update the product fees list
        self.updateDepositProductFees = function () {
            $.ajax({
                type: "post",
                dataType: "json",
                data: {origin: "deposit_product"},
                url: "ajax_requests/ajax_data.php",
                success: function (response) {
                    if (typeof response.existingDepositProductFees != 'undefined'){
                        self.existingDepositProductFees(response.existingDepositProductFees);
                   }					
                }
            })
        };
    };

    var depositProductModel = new DepositProduct();
    depositProductModel.updateDepositProductFees();
    ko.applyBindings(depositProductModel, $("#add_deposit_product-modal")[0]);
    ko.applyBindings(new DepositProductFee(), $("#add_deposit_product_fee-modal")[0]);