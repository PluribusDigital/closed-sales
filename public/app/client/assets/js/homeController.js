angular.module('closedSales').controller("HomeController",
    function ($scope, LoanProxyService) {
        $scope.model = []
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

        $scope.params = LoanProxyService.defaultParams();
        $scope.downloadParams = LoanProxyService.buildDownloadParams($scope.params);
        $scope.offset = 0;
        $scope.lastShown = 0;

        $scope.loading = true;
        $scope.showPagination = true;
        $scope.showAdvancedSearch = false;

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
            var p = $scope.params = data.params;
            if (p.total_count == 0) {
                $scope.offset = 0;
                $scope.lastShown = 0;
                $scope.showPagination = false;
            }
            else {
                $scope.offset = ((p.page_number - 1) * p.page_size) + 1;
                $scope.lastShown = Math.min(p.total_count, p.page_number * p.page_size);
                $scope.showPagination = p.total_count > p.page_size;
            }

            $scope.downloadParams = LoanProxyService.buildDownloadParams($scope.params);
        }

        /************************************************************************************************
         * Pagination Members
         */

        $scope.refresh = function () {
            $scope.loading = true;
            LoanProxyService.search($scope.params).then($scope.onModelLoaded);
        }

        $scope.setOrder = function (orderBy) {
            if (orderBy === $scope.params.order_by)
                $scope.params.order_by = '-' + orderBy;  // Reverse the sort
            else
                $scope.params.order_by = orderBy;
            $scope.refresh();
        }

        $scope.cellAlign = function (column) {
            return ("align" in column) ? column.align : "left";
        }

        /************************************************************************************************
         * Initialize
         */
        $scope.$watch('params.search_text', function (term) {
            $scope.refresh();
        });

        $scope.refresh();
    });