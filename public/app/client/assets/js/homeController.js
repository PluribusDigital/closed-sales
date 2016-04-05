angular.module('closedSales').controller("HomeController",
    function ($scope, LoanProxyService) {
        $scope.filtered = $scope.model = []
        $scope.columns = [
            { 'name': 'sale_id', 'title': 'Sale Id' },
            { 'name': 'site_name', 'title': 'Site' },
            { 'name': 'date_sold', 'title': 'Date Sold', "align": 'right' },
            { 'name': 'loan_type', 'title': 'Loan Type' },
            { 'name': 'quality', 'title': 'Quality' },
            { 'name': 'number_of_loans', 'title': 'No. of Loans', "align": 'right' },
            { 'name': 'book_value', 'title': 'Book Value', "align": 'right' },
            { 'name': 'sales_price', 'title': 'Sales Price', "align": 'right' },
            { 'name': 'winning_bidder', 'title': 'Winning Bidder' },
            { 'name': 'address', 'title': 'Address' }
        ]

        /*id, created_at, updated_at */

        $scope.searchText = '';
        $scope.pageInfo = {'page_number': 1};
        $scope.offset = 0;
        $scope.lastShown = 0;
        $scope.orderBy = 'date_sold';

        $scope.loading = true;

        /************************************************************************************************
        * Data Model Methods
        */

        $scope.onModelLoaded = function (data) {
            $scope.model = [];
            $scope.loading = false;

            data.data.forEach(function (elem) {
                var x = new Object();
                x.id = elem.id;
                Object.keys(elem.attributes).forEach(function (ak) {
                    x[ak] = elem.attributes[ak];
                });
                $scope.model.push(x);
            });

            // Initialize the pagination data
            $scope.pageInfo = data.meta;
            $scope.offset = ((data.meta.page_number - 1) * data.meta.page_size) + 1;
            $scope.lastShown = Math.min(data.meta.total_count, data.meta.page_number * data.meta.page_size);
        }

        /************************************************************************************************
         * Pagination Members
         */

        $scope.refresh = function () {
            $scope.loading = true;

            LoanProxyService.search($scope.searchText,
                $scope.pageInfo.page_number,
                $scope.orderBy)
                .then($scope.onModelLoaded);
        }

        $scope.pageChanged = function () {
            $scope.offset = ($scope.currentPage - 1) * $scope.pageSize
            $scope.lastShown = Math.min($scope.offset + $scope.pageSize + 1, $scope.totalItems);
            $scope.refresh();
        };

        $scope.setOrder = function (orderBy) {
            if (orderBy === $scope.orderBy)
                $scope.orderBy = '-' + orderBy;  // Reverse the sort
            else
                $scope.orderBy = orderBy;
            $scope.refresh();
        }

        $scope.cellAlign = function (column) {
            return ("align" in column) ? column.align : "left";
        }

        /************************************************************************************************
         * Initialize
         */
        $scope.$watch('searchText', function (term) {
            $scope.refresh();
        });

        $scope.refresh();
    });