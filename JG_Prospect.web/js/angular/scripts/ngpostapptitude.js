app.controller('PostApptitude', function ($scope, $compile, $http, $timeout, $filter) {
    _applyFunctions($scope, $compile, $http, $timeout, $filter);
});
app.filter('trustAsHtml', function ($sce) { return $sce.trustAsHtml; });

function callWebServiceMethod($http, methodName, filters) {
    return $http.post(url + methodName, filters);
};

function _applyFunctions($scope, $compile, $http, $timeout, $filter) {

    //Create a Scope
    sequenceScopePA = $scope;
    $scope.Romans = [];
    $scope.Task = [];
    /* Task related methods starts */
    $scope.expandTask = function (TaskId) {

        $('#LoadingRomansDiv' + TaskId).show();
        callWebServiceMethod($http, "GetMultiLevelList", { ParentTaskId: TaskId, chatSourceId: 2 }).then(function (data) {
            $('#LoadingRomansDiv' + TaskId).hide();
            var resultArray = JSON.parse(data.data.d);
            var results = resultArray.Results;
            $scope.Romans = $scope.Romans.concat($scope.correctDataforAngular(results));
            console.log($scope.Romans);
            if ($scope.Romans.length < 1) {
                $('#LoadingRomans' + TaskId).html('No data found.');
                $('#LoadingRomansDiv' + TaskId).show(500);
            }
        });
    }
    /* Task related methods ends */

    /* Resources methods starts */

    $scope.getFilesByDesignation = function (locationId, designationId) {
        getFilesByDesignation($scope, $http, locationId, designationId);
    }

    /* Resources methods ends */

    //Helper Functionss
    $scope.correctDataforAngular = function (ary) {
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

function getFilesByDesignation($scope, $http, locationId, designationId) {
    callWebServiceMethod($http, "GetFilesByDesignationId", { locationId: locationId, DesignationId: designationId })
        .then(function (data) {
            var resourceTypes = getResponse(data);
            $scope.DesignationResources = resourceTypes;
            $scope.UniqueName = $scope.DesignationResources[0].Categories[0].Categories[0].UniqueName;
            $scope.FileSourceURL = "Upload/Resources/" + $scope.DesignationResources[0].Categories[0].Categories[0].DesignationId
                + "/" + $scope.DesignationResources[0].Categories[0].Title
                + "/" + $scope.DesignationResources[0].Categories[0].Categories[0].UniqueName;
            var extension = $scope.UniqueName.substr(($scope.UniqueName.lastIndexOf('.') + 1));
            if (extension.toLowerCase() == "wav" || extension.toLowerCase() == "m4a" || extension.toLowerCase() == "avi" || extension.toLowerCase() == "mov" || extension.toLowerCase() == "mpg" || extension.toLowerCase() == "mp4") {
                $scope.FileToPlaySource = 1;
                $('#def-intro').show();
                $('#lnkTR1').hide();
                $('#lnkTR').hide();
                $('#def-intro').attr("src", $scope.FileSourceURL);
                $('#def-intro')[0].load();
            }
            else if (extension.toLowerCase() == "png" || extension.toLowerCase() == "jpg" || extension.toLowerCase() == "jpeg" || extension.toLowerCase() == "bmp" || extension.toLowerCase() == "gif") {
                $scope.FileToPlaySource = 2;
                $('#lnkTR').show();
                $('#def-intro').hide();
                $('#lnkTR1').hide();
            }
            else {
                $scope.FileToPlaySource = 3;
                $('#lnkTR1').show();
                $('#def-intro').hide();
                $('#lnkTR').hide();
            }

            $('#lnkTR').attr("href", $scope.FileSourceURL);
            $('#lnkTR1').attr("href", $scope.FileSourceURL);
            $('#imgTR').attr("src", $scope.FileSourceURL);
        });

}

function getResponse(data) {
    try {
        if (data && data.data && data.data.d && data.data.d != '')
            return jsonResult = JSON.parse(data.data.d);
        else
            return [];
    }
    catch (e) {
        return [];
    };
};