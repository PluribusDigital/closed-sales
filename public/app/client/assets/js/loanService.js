<<<<<<< HEAD
﻿LOANS_API_BASE_URL = 'http://localhost:8080/api/v1/loans.json'
=======
﻿LOANS_API_BASE_URL = '/api/v1/loans.json'
>>>>>>> ffb1c91f9cf6a3b23971d72550a9b3508536c011

// This service fakes a connection to a server by using a timeout to fake an asynchronous call
angular.module('closedSales').factory('LoanProxyService',
    function ($http, $q) {
        var service = {
            search: function (filter, page, sort) {
                var options = {
                    'params': {
                        'filter[string][site_name,winning_bidder,loan_type,quality,address]': filter,
                        'page[size]': '20',
                        'page[number]': page,
                        'sort': sort,
                    }
                };

                var deferred = $q.defer();
                $http.get(LOANS_API_BASE_URL, options).then(function (response) {
                    deferred.resolve(response.data);
                }, function (response) {
                    console.log('Error when calling loan endpoint');
                    console.log(response);
                    deferred.reject();
                })

                return deferred.promise;
            }
        };

        return service;
    });
