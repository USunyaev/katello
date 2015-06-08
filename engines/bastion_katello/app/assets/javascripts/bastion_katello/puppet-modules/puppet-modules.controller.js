(function () {
    'use strict';

    /**
     * @ngdoc controller
     * @name  Bastion.puppet-modules.controller:PuppetModulesController
     *
     * @description
     *   Handles fetching puppet modules content and populating Nutupane based on the current
     *   ui-router state.
     */
    function PuppetModulesController($scope, Nutupane, PuppetModule, CurrentOrganization) {
        var nutupane;

        var params = {
            'organization_id': CurrentOrganization,
            'sort_by': 'name',
            'sort_order': 'ASC'
        };

        nutupane = new Nutupane(PuppetModule, params);
        $scope.table = nutupane.table;

        $scope.table.closeItem = function () {
            $scope.transitionTo('puppet-modules.index');
        };
    }

    angular
        .module('Bastion.puppet-modules')
        .controller('PuppetModulesController', PuppetModulesController);

    PuppetModulesController.$inject = ['$scope', 'Nutupane', 'PuppetModule', 'CurrentOrganization'];

})();
