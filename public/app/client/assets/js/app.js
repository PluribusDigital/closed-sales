(function() {
  'use strict';

  angular.module('closedSales', [
    'ui.router',
    'ngAnimate',
    'ui.bootstrap',

    //foundation
    'foundation',
    'foundation.dynamicRouting',
    'foundation.dynamicRouting.animations'
  ])
    .config(config)
    .run(run)
  ;

  config.$inject = ['$urlRouterProvider', '$locationProvider'];

  function config($urlProvider, $locationProvider) {
    $urlProvider.otherwise('/');

    $locationProvider.html5Mode({
      enabled:false,
      requireBase: false
    });

    $locationProvider.hashPrefix('!');
  }

  function run() {
    FastClick.attach(document.body);
  }

})();

// There is already a limitTo filter built-into angular,
// Here is a startFrom filter
// Credit to: http://stackoverflow.com/users/1397051/andy-joslin
angular.module('closedSales').filter('startFrom', function () {
    return function (input, start) {
        start = +start; //parse to int
        return input.slice(start);
    }
});