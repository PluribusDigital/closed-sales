
// This service fakes a connection to a server by using a timeout to fake an asynchronous call
angular.module('closedSales').factory('LoanProxyService',
    function ($http, $rootScope, $q) {
        $rootScope.loanServiceData = null;

        var service = {
            loadCache: function () {
                var deferred = $q.defer();

                $http.get('api/loans.json', {}).then(function (response) {
                    $rootScope.loanServiceData = response.data;
                    deferred.resolve(response.data);
                }, function (response) {
                    console.log('error when calling loan endpoint');
                    console.log(response);
                    deferred.reject();
                })

                return deferred.promise;
            },

            getAll: function () {
                if ($rootScope.loanServiceData == null) {
                    return this.loadCache();
                }
                else {
                    var deferred = $q.defer();

                    $timeout(20).then(function () {
                        deferred.resolve($rootScope.loanServiceData);
                    });

                    return deferred.promise;
                }
            }
        };

        return service;
    });
