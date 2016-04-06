LOANS_API_BASE_URL = '/api/v1/loans.json'
METADATA_URL = '/api/v1/schemas/loans'

// This service fakes a connection to a server by using a timeout to fake an asynchronous call
angular.module('closedSales').factory('LoanProxyService',
    function ($http, $q) {
        var service = {
            defaultParams: function() {
                return {
                    'page_size': 20,
                    'page_number': 1,
                    'order_by': 'date_sold'
                };
            },

            metadata: function () {

                var deferred = $q.defer();
                $http.get(METADATA_URL).then(function (response) {
                    var ranges = {};
                    response.data.data.attributes.fields.forEach(function (f) {
                        ranges[f.name] = f;
                    });

                    deferred.resolve(ranges);
                }, function (response) {
                    console.log('Error when calling loan endpoint');
                    console.log(response);
                    deferred.reject();
                })

                return deferred.promise;
            },

            search: function (params) {
                var options = {
                    'params': this.buildQueryParams(params)
                };

                var deferred = $q.defer();
                $http.get(LOANS_API_BASE_URL, options).then(function (response) {
                    var x = {
                        'data': response.data.data,
                        'params': angular.extend({}, params, response.data.meta)
                    };

                    deferred.resolve(x);
                }, function (response) {
                    console.log('Error when calling loan endpoint');
                    console.log(response);
                    deferred.reject();
                })

                return deferred.promise;
            },

            buildQueryParams: function (p) {
                var result = {
                    'page[size]': p.page_size,
                    'page[number]': p.page_number,
                    'sort': p.order_by
                };

                if ('search_text' in p && p.search_text)
                    result['filter[string][sale_id,site_name,winning_bidder,address]'] = p.search_text;

                if ('quality' in p && p.quality)
                    result['filter[exact][quality]'] = p.quality;

                if ('loan_type' in p && p.loan_type)
                    result['filter[exact][loan_type]'] = p.loan_type;

                if ('book_value_low' in p || 'book_value_high' in p) {
                    var low = ('book_value_low' in p) ? p.book_value_low : 0;
                    var high = ('book_value_high' in p) ? p.book_value_high : 999999999;

                    result['filter[range][book_value]'] = low + ',' + high;
                }

                if ('sales_price_low' in p || 'sales_price_high' in p) {
                    var low = ('sales_price_low' in p) ? p.sales_price_low : 0;
                    var high = ('sales_price_high' in p) ? p.sales_price_high : 999999999;

                    result['filter[range][sales_price]'] = low + ',' + high;
                }

                if ('date_sold_low' in p || 'date_sold_high' in p) {
                    var low = ('date_sold_low' in p) ? p.date_sold_low.toISOString() : '1900-01-01';
                    var high = ('date_sold_high' in p) ? p.date_sold_high.toISOString() : '2100-12-31';

                    result['filter[range][date_sold]'] = low + ',' + high;
                }

                return result;
            },

            buildDownloadParams: function (p) {
                var result = this.buildQueryParams(p);
                result['page[size]'] = p.total_count;

                return result;
            }
        };

        return service;
    });
