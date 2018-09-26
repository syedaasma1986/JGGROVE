//global variable to acccess scope of this controller outside this js file.
var editSalesUserScope;

app.controller('EditUserController', function ($scope, $compile, $http, $timeout, $filter) {
    applyFunctions($scope, $compile, $http, $timeout,$filter);

});

function getUsersWithSearchandPagingM($http, methodName, filters) {
    return $http.post(url + methodName, filters);
};


function applyFunctions($scope, $compile, $http, $timeout , $filter) {

    $scope.UserIds = [];
    $scope.EditSalesUsers = [];
    $scope.SearchDesignationId;

    $scope.page = 0;
    $scope.pagesCount = 0;
    $scope.Currentpage = 0;
    $scope.TotalRecords = 0;


    $scope.loader = {
        loading: false,
    };
    
    $scope.onEditUserBindEnd = function () {
        $timeout(function () {
            GetSequences();
        }, 1);
    };

    
    $scope.getEditUsers = function (page) {

        $scope.loader.loading = true;
        $scope.page = page || 0;

        //get all Customers
        getUsersWithSearchandPagingM($http, "GetEditSalesPopupUsersWithPaging", { PageIndex: $scope.page, PageSize: 20, UserIds: $scope.UserIds.join(), Status: '', DesignationId: 0, SortExpression: '' }).then(function (data) {
            
            //console.log(data.data.d);

            var results = data.data.d;
           // console.log(results);
            $scope.EditSalesUsers = JSON.parse(results);
            $scope.loader.loading = false;
            //$scope.page = results.RecordCount.PageIndex;
            //$scope.TotalRecords = results.RecordCount.TotalRecords;
            //$scope.pagesCount = results.RecordCount.TotalPages;
           
            //console.log('Counting Data...');
            //console.log(results.RecordCount.PageIndex);
            //console.log(results.RecordCount.TotalRecords);
            //console.log(results.RecordCount.TotalPages);

        });
    };
      

    $scope.SetEditUsersForSearch = function (value) {        
        $scope.UserIds.push(value);
    };

    $scope.refreshTasks = function () {
      
       $scope.getEditUsers();
       
    };

    initializeOnAjaxUpdate($scope, $compile, $http, $timeout, $filter);

    editSalesUserScope = $scope;

}

function initializeOnAjaxUpdate(scope, compile, http, timeout,filter) {
    
    Sys.WebForms.PageRequestManager.getInstance().add_endRequest(function () {
        var elem = angular.element(document.getElementById("divEditUserNG"));
        compile(elem.children())(scope);
        scope.$apply();
        applyFunctions(scope, compile, http, timeout,filter);
    });

}
