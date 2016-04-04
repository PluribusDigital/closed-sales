LOANS_API_BASE_URL = 'http://localhost:8080/api/v1/loans'

// This service fakes a connection to a server by using a timeout to fake an asynchronous call
angular.module('closedSales').factory('LoanProxyService',
    function ($http, $q) {
        var service = {
            getAll: function () {
                var deferred = $q.defer();
                $http.get(LOANS_API_BASE_URL, {}).then(function (response) {
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
