LOANS_API_BASE_URL = 'http://localhost:8080/api/v1/loans.json'

// This service fakes a connection to a server by using a timeout to fake an asynchronous call
angular.module('closedSales').factory('LoanProxyService',
    function ($http, $q) {
        var service = {
            defaultParams: function() {
                return {
                    'page_size': 50,
                    'page_number': 1,
                    'search_text': 'Kans',
                    'order_by': 'date_sold'
                };
            },

            search: function (params) {
                var options = {
                    'params': this.buildPagedParams(params)
                };

                var deferred = $q.defer();
                $http.get(LOANS_API_BASE_URL, options).then(function (response) {
                    var x = {
                        'data': response.data.data,
                        'params': angular.extend({}, params, response.data.meta)
                    };

                    console.log(x.params);

                    deferred.resolve(x);
                }, function (response) {
                    console.log('Error when calling loan endpoint');
                    console.log(response);
                    deferred.reject();
                })

                return deferred.promise;
            },

            buildPagedParams: function (p) {
                return {
                    'filter[string][sale_id,site_name,winning_bidder,address]': p.search_text,
                    'page[size]': p.page_size,
                    'page[number]': p.page_number,
                    'sort': p.order_by
                };
            },

            buildDownloadParams: function (p) {
                return {
                    'filter[string][sale_id,site_name,winning_bidder,address]': p.search_text,
                    'page[size]': p.total_count,
                    'sort': p.order_by
                };
            }
        };

        return service;
    });
