angular.module('closedSales').controller("HomeController",
    function ($scope, LoanProxyService, filterFilter) {
        $scope.filtered = $scope.model = []
        $scope.columns = [
            { 'name': 'sale_id', 'title': 'Sale Id' },
            { 'name': 'site_name', 'title': 'Site' },
            { 'name': 'date_sold', 'title': 'Date Sold' },
            { 'name': 'loan_type', 'title': 'Loan Type' },
            { 'name': 'quality', 'title': 'Quality' },
            { 'name': 'number_of_loans', 'title': 'No. of Loans' },
            { 'name': 'book_value', 'title': 'Book Value' },
            { 'name': 'sales_price', 'title': 'Sales Price' },
            { 'name': 'winning_bidder', 'title': 'Winning Bidder' },
            { 'name': 'address', 'title': 'Address' }
        ]

        /*id, created_at, updated_at */

        $scope.loading = true;

        /************************************************************************************************
        * Data Model Methods
        */

        $scope.onModelLoaded = function (data) {
            $scope.model = data;
            if ($scope.model == null) {
                $scope.model = [];
                return;
            }

            if ($scope.model.length > 0) {
                $scope.loading = false;
            }

            // Initialize the pagination data
            $scope.applyFilter();
        }

        /************************************************************************************************
         * Table Members
         */

        $scope.searchText = '';

        $scope.totalItems = 0;
        $scope.pageSize = 20
        $scope.currentPage = 1;
        $scope.offset = 0;
        $scope.lastShown = 0;

        $scope.orderBy = 'sale_id';

        $scope.applyFilter = function () {
            // Create $scope.filtered and then calculate $scope.totalItems, no racing!
            var a = $scope.filterText($scope.model);

            $scope.filtered = a;
            $scope.totalItems = $scope.filtered.length;
            $scope.currentPage = 1;
            $scope.pageChanged();
        }

        $scope.pageChanged = function () {
            $scope.offset = ($scope.currentPage - 1) * $scope.pageSize
            $scope.lastShown = Math.min($scope.offset + $scope.pageSize + 1, $scope.totalItems);
        };

        $scope.setOrder = function (orderBy) {
            if (orderBy === $scope.orderBy)
                $scope.orderBy = '-' + orderBy;  // Reverse the sort
            else
                $scope.orderBy = orderBy;
        }

        $scope.filterText = function (arr) {
            return filterFilter(arr, $scope.searchText);
        }

        /************************************************************************************************
         * Initialize
         */
        $scope.$watch('searchText', function (term) {
            $scope.applyFilter();
        });

        LoanProxyService.getAll().then($scope.onModelLoaded);
    });