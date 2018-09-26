app.controller('ClosedTaskController', function ($scope, $compile, $http, $timeout, $filter) {
    applyFunctionsClosedTask($scope, $compile, $http, $timeout, $filter);
});
function getAllClosedTasksWithSearchandPaging($http, methodName, filters) {
    return $http.post(url + methodName, filters);
};

function applyFunctionsClosedTask($scope, $compile, $http, $timeout , $filter) {

    $scope.ClosedTask = [];
    $scope.vSearch = "";

    $scope.loaderClosedTask = {
        loading: false,
    };
    
    $scope.pageClosedTask = 0;
    $scope.pagesCountClosedTask = 0;
    $scope.CurrentpageClosedTask = 0;
    $scope.TotalRecordsClosedTask = 0;
    
    $scope.getClosedTasks = function (page) {
            console.log("Closed Task called....");
            $scope.loaderClosedTask.loading = true;
            $scope.pageClosedTask = page || 0

            // make it blank so StaffTask grid don't bind.
            $scope.Tasks = [];

            //debugger;
            //get all Customers
            getAllClosedTasksWithSearchandPaging($http, "GetAllClosedTasks", { page: $scope.pageClosedTask, pageSize: sequenceScope.pageSize, DesignationIDs: sequenceScope.UserSelectedDesigIdsClosedTaks, userid: sequenceScope.UserId, TaskUserStatus: sequenceScope.UserStatus, vSearch: $scope.vSearch }).then(function (data) {
                
                $scope.loaderClosedTask.loading = false;
                //$scope.DesignationSelectModel = [];
                var resultArray = JSON.parse(data.data.d);
                var results = resultArray.TasksData;
                //console.log("type of tasks is");
                //console.log(typeof results.Tasks);
                //console.log(results.Tasks);
                $scope.pageClosedTask = results.RecordCount.PageIndex;
                $scope.TotalRecordsClosedTask = results.RecordCount.TotalRecords;
                $scope.pagesCountClosedTask = results.RecordCount.TotalPages;
                $scope.ClosedTask = $scope.correctDataforAngularClosedTaks(results.Tasks);
                //$scope.TaskSelected = $scope.TechTasks[0];                
                if ($scope.TotalRecordsClosedTask > 0) {
                    $('#noDataCT').hide();
                }
                else {
                    $('#noDataCT').fadeIn(500);
                }
            });
    };

    $scope.onClosedTaskEnd = function () {
        var totalUser = 0;
        var totalITLead = 0;
        $timeout(function () {
            $('#ContentPlaceHolder1_grdTaskClosed tbody tr').each(function (i, item) {
                var content = $(this).children('td.TotalHours').html();

                var user = 0;
                var itlead = 0;

                if (content != null) {
                    if (content.split(',')[0] != undefined && content.split(',')[0].indexOf('ITLead') >= 0) {
                        itlead = content.split(',')[0].match(/(\d+)/g);
                        totalITLead += itlead != null ? parseInt(itlead[0]) != undefined ? parseInt(itlead[0]) : 0 : 0;
                    }
                    else if (content.split(',')[0] != undefined && content.split(',')[0].indexOf('User') >= 0) {
                        user = content.split(',')[0].match(/(\d+)/g);
                        totalUser += user != null ? parseInt(user[0]) != undefined ? parseInt(user[0]) : 0 : 0;
                    }

                    if (content.split(',')[1] != undefined && content.split(',')[1].indexOf('User') >= 0) {
                        user = content.split(',')[1].match(/(\d+)/g);
                        totalUser += user != null ? parseInt(user[0]) != undefined ? parseInt(user[0]) : 0 : 0;
                    }
                    else if (content.split(',')[1] != undefined && content.split(',')[1].indexOf('ITLead') >= 0) {
                        itlead = content.split(',')[1].match(/(\d+)/g);
                        totalITLead += itlead != null ? parseInt(itlead[0]) != undefined ? parseInt(itlead[0]) : 0 : 0;
                    }
                }

                
            });
            //$('#ContentPlaceHolder1_grdTaskClosed tbody').append('<tr><td style="width:100px;"></td><td style="width:100px;"></td><td style="width:300px;"></td><td style="width:100px;text-align:center"><b>(Total) IT Lead: ' + totalITLead + ', User: ' + totalUser + '</b></td><td style="width:120px;"></td></tr>');
            console.log(totalITLead);
            sequenceScopeClosedTasks.totalITLead = totalITLead;
            sequenceScopeClosedTasks.totalUser = totalUser;
            console.log(totalUser);
        }, 2);
    }

    $scope.SetDesignForSearch = function (value, isReload) {
        $scope.UserSelectedDesigIdsClosedTaks = [];
        $scope.UserSelectedDesigIdsClosedTaks.push(value);
        //if (isRemove) {
        //    $scope.UserSelectedDesigIds.pop(value);
        //}
        //else { // if element is to be added
        //    if ($scope.UserSelectedDesigIds.indexOf(value) === -1) {//check if value is not already added then only add it.
        //        $scope.UserSelectedDesigIds.push(value);
        //    }
        //}
        if (isReload) {
            $scope.getClosedTasks();
        }

    };

    $scope.refreshClosedTask = function () {
        $scope.getClosedTasks();
    };

    $scope.StringIsNullOrEmpty = function (value) {

        //var returnVal = (angular.isUndefined(value) || value === null || value)
        var returnVal = !value;
        return returnVal;
    };

    sequenceScopeClosedTasks = $scope;

    $scope.correctDataforAngularClosedTaks = function (ary) {

        var arr = null;

        if (ary) {
            if (!(ary instanceof Array)) {
                arr = [ary];
            }
            else {
                arr = ary;
            }
        }


        return arr;

    }
}
