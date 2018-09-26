app.controller('PayRateAdminController', function ($scope, $compile, $http, $timeout) {
    applyFunctions($scope, $compile, $http, $timeout);
});

function getDesignationPayrates($http, methodName, filters) {
    return $http.post(url + methodName, filters);
}

function applyFunctions($scope, $compile, $http, $timeout) {

    $scope.PayRates = [];



    $scope.loader = {
        loading: false,
    };

    $scope.getPayRates = function (DesgId) {

        $scope.loader.loading = true;

        //get all payrates
        getDesignationPayrates($http, "GetDesignationPayrates", { DesignationId: DesgId }).then(function (data) {
            $scope.PayRates = [];
            $scope.loader.loading = false;
            var resultArray = JSON.parse(data.data.d);            
            $scope.PayRates = resultArray;            
            console.log($scope.PayRates);
        });
    };

    $scope.getEmploymentType = function (EmpType) {
        var EmploymentType = "";
        
        switch (EmpType) {
            case 1:
                EmploymentType = "Part Time - Remote";
                break;
            case 2:
                EmploymentType = "Full Time - Remote";
                break;
            case 3:
                EmploymentType = "Part Time - Onsite";
                break;
            case 4:
                EmploymentType = "Full Time - Onsite";
                break;
            case 5:
                EmploymentType = "Internship";
                break;
            case 6:
                EmploymentType = "Temp";
                break;
            case 7:
                EmploymentType = "Sub";
                break;
            default:
                break;
        }
        return EmploymentType;
    }

   // initializeOnAjaxUpdate($scope, $compile, $http, $timeout);

    PayRateScope = $scope;

}

function initializeOnAjaxUpdate(scope, compile, http, timeout) {
    
    Sys.WebForms.PageRequestManager.getInstance().add_endRequest(function () {
        var elem = angular.element(document.getElementById("divPayRateNG"));
        compile(elem.children())(scope);
        scope.$apply();

        applyFunctions(scope, compile, http, timeout);
    });

}

