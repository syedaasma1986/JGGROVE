
app.controller('FrozenTaskController', function ($scope, $compile, $http, $timeout, $filter) {
    //alert("FrozenTaskController");
    applyFunctionsFrozenTask($scope, $compile, $http, $timeout, $filter);
});

app.controller('NonFrozenTaskController', function ($scope, $compile, $http, $timeout, $filter) {
    //alert("NonFrozenTaskController");
    applyFunctionsNonFrozenTask($scope, $compile, $http, $timeout, $filter);
});

function getAllFrozenTasksWithSearchandPaging($http, methodName, filters) {
    return $http.post(url + methodName, filters);
};

function getAllNonFrozenTasksWithSearchandPaging($http, methodName, filters) {
    return $http.post(url + methodName, filters);
};

function applyFunctionsFrozenTask($scope, $compile, $http, $timeout , $filter) {

    $scope.FrozenTask = [];
    $scope.vSearch = "";
    $scope.IsTechTask = true;
    $scope.UserId = 0;
    $scope.UserSelectedDesigIdsFrozenTaks = [];
    $scope.DesignationAssignUsersFrozenTaks = [];
    $scope.DesignationSelectModelFrozenTaks = [];
    $scope.loaderFrozenTask = {
        loading: false,
    };
    
    $scope.pageFrozenTask = 0;
    $scope.pagesCountFrozenTask = 0;
    $scope.CurrentpageFrozenTask = 0;
    $scope.TotalRecordsFrozenTask = 0;

    $scope.onStaffEnd = function () {
        $timeout(function () {
            setFirstRowAutoData();
            SetSeqApprovalUI();
            SetChosenAssignedUser();
        }, 1);
    };

    $scope.onTechEnd = function () {
        $timeout(function () {
            if ($scope.IsTechTask) {
                setFirstRowAutoData();
                SetSeqApprovalUI();
                SetChosenAssignedUser();
            }
        }, 1);
    };

    $scope.getFrozenTasks = function (page) {
            console.log("Frozen Task called....");
            $scope.loaderFrozenTask.loading = true;
            $scope.pageFrozenTask = page || 0

            // make it blank so StaffTask grid don't bind.
            $scope.NonFrozenTask = [];

            
            //get all Customers
            getAllFrozenTasksWithSearchandPaging($http, "GetAllFrozenTasksWithPaging", { page: $scope.pageFrozenTask, pageSize: sequenceScopeFrozenTasks.pageSize == undefined ? 20 : sequenceScopeFrozenTasks.pageSize, DesignationIDs: sequenceScopeFrozenTasks.UserSelectedDesigIdsFrozenTaks.join(), UserId: sequenceScopeFrozenTasks.UserId, IsTechTask: $scope.IsTechTask }).then(function (data) {
                //debugger;
                $scope.loaderFrozenTask.loading = false;
                $scope.DesignationSelectModelFrozenTaks = [];
                var resultArray = JSON.parse(data.data.d);
                var results = resultArray.TasksData;
                //console.log("type of tasks is");
                //console.log(typeof results.Tasks);
                //console.log(results.Tasks);
                $scope.pageFrozenTask = results.RecordCount.PageIndex;
                $scope.TotalRecordsFrozenTask = results.RecordCount.TotalRecords;
                $scope.pagesCountFrozenTask = results.RecordCount.TotalPages;
                $scope.FrozenTask = $scope.correctDataforAngularFrozenTaks(results.Tasks);
                //$scope.TaskSelected = $scope.TechTasks[0];                
            });
    };

    $scope.getAssignUsers = function () {

        getDesignationAssignUsers($http, "GetAssignUsers", { TaskDesignations: $scope.UserSelectedDesigIdsFrozenTaks.join() }).then(function (data) {

            var AssignedUsers = JSON.parse(data.data.d);

            ///console.log(AssignedUsers);

            $scope.DesignationAssignUsers = AssignedUsers;

        });

    };

    $scope.SetIsTechTask = function () {
        console.log("callled $scope.SetIsTechTask");
        $scope.getTechTasks();

    };

    $scope.SetAssignedUsers = function (AssignedUsers) {
        //var selected = false;

        //if (AssignedUsers) {

        //   $scope.AssignedUsersArray = angular.fromJson("["+AssignedUsers+"]");

        //   angular.forEach($scope.AssignedUsersArray, function (value, key) {           
        //       if (parseInt(value.Id) === parseInt(UserId)) {
        //            selected = true;
        //           return selected;
        //       }
        //   });
        //}

        //return selected;
        if (AssignedUsers) {
            $scope.AssignedUsersArray = angular.fromJson("[" + AssignedUsers + "]");
        }
        else {
            $scope.AssignedUsersArray = [];
        }
        return $scope.AssignedUsersArray;
    };

    $scope.SetDesignForSearch = function (value, isReload) {
        $scope.UserSelectedDesigIdsFrozenTaks = [];
        $scope.UserSelectedDesigIdsFrozenTaks.push(value);
        //if (isRemove) {
        //    $scope.UserSelectedDesigIds.pop(value);
        //}
        //else { // if element is to be added
        //    if ($scope.UserSelectedDesigIds.indexOf(value) === -1) {//check if value is not already added then only add it.
        //        $scope.UserSelectedDesigIds.push(value);
        //    }
        //}
        if (isReload) {
            $scope.getFrozenTasks();
        }

    };

    $scope.refreshFrozenTask = function () {
        $scope.getFrozenTasks();
    };

    $scope.StringIsNullOrEmpty = function (value) {

        //var returnVal = (angular.isUndefined(value) || value === null || value)
        var returnVal = !value;
        return returnVal;
    };

    sequenceScopeFrozenTasks = $scope;

    $scope.toRoman = function (num) {

        if (!+num)
            return false;
        var digits = String(+num).split(""),
            key = ["", "C", "CC", "CCC", "CD", "D", "DC", "DCC", "DCCC", "CM",
                "", "X", "XX", "XXX", "XL", "L", "LX", "LXX", "LXXX", "XC",
                "", "I", "II", "III", "IV", "V", "VI", "VII", "VIII", "IX"],
            roman = "",
            i = 3;
        while (i--)
            roman = (key[+digits.pop() + (i * 10)] || "") + roman;

        return Array(+digits.join("") + 1).join("M") + roman;
    };

    $scope.getDesignationString = function (Designations) {

        if (!angular.isUndefinedOrNull(Designations)) {
            var DesignationArray = JSON.parse("[" + Designations + "]");

            return DesignationArray.map(function (elem) {
                return elem.Name;
            }).join(",");
        }
        else {
            return "";
        }
    };

    $scope.getSequenceDisplayText = function (strSequence, strDesigntionID, seqSuffix) {
        //console.log(strSequence + strDesigntionID + seqSuffix);
        var sequenceText = "#SEQ#-#DESGPREFIX#:#TORS#";
        sequenceText = sequenceText.replace("#SEQ#", strSequence).replace("#DESGPREFIX#", $scope.GetInstallIDPrefixFromDesignationIDinJS(parseInt(strDesigntionID))).replace("#TORS#", seqSuffix);
        return sequenceText;
    };

    $scope.GetInstallIDPrefixFromDesignationIDinJS = function (DesignID) {

        var prefix = "";
        switch (DesignID) {
            case 1:
                prefix = "ADM";
                break;
            case 2:
                prefix = "JSL";
                break;
            case 3:
                prefix = "JPM";
                break;
            case 4:
                prefix = "OFM";
                break;
            case 5:
                prefix = "REC";
                break;
            case 6:
                prefix = "SLM";
                break;
            case 7:
                prefix = "SSL";
                break;
            case 8:
                prefix = "ITNA";
                break;
            case 9:
                prefix = "ITJN";
                break;
            case 10:
                prefix = "ITSN";
                break;
            case 11:
                prefix = "ITAD";
                break;
            case 12:
                prefix = "ITSPH";
                break;
            case 13:
                prefix = "ITSB";
                break;
            case 14:
                prefix = "INH";
                break;
            case 15:
                prefix = "INJ";
                break;
            case 16:
                prefix = "INM";
                break;
            case 17:
                prefix = "INLM";
                break;
            case 18:
                prefix = "INF";
                break;
            case 19:
                prefix = "COM";
                break;
            case 20:
                prefix = "SBC";
                break;
            case 24:
                prefix = "ITSQA";
                break;
            case 25:
                prefix = "ITJQA";
                break;
            case 26:
                prefix = "ITJPH";
                break;
            default:
                prefix = "N.A.";
                break;
        }

        return prefix;
    };

    $scope.correctDataforAngularFrozenTaks = function (ary) {

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

function applyFunctionsNonFrozenTask($scope, $compile, $http, $timeout, $filter) {

    $scope.NonFrozenTask = [];
    $scope.vSearch = "";
    $scope.IsTechTask = true;
    $scope.UserId = 0;
    $scope.UserSelectedDesigIdsFrozenTaks = [];
    $scope.DesignationAssignUsersFrozenTaks = [];
    $scope.DesignationSelectModelFrozenTaks = [];
    $scope.loaderFrozenTask = {
        loading: false,
    };

    $scope.pageFrozenTask = 0;
    $scope.pagesCountFrozenTask = 0;
    $scope.CurrentpageFrozenTask = 0;
    $scope.TotalRecordsFrozenTask = 0;

    $scope.onStaffEnd = function () {
        $timeout(function () {
            setFirstRowAutoData();
            SetSeqApprovalUI();
            SetChosenAssignedUser();
        }, 1);
    };

    $scope.onTechEnd = function () {
        $timeout(function () {
            if ($scope.IsTechTask) {
                setFirstRowAutoData();
                SetSeqApprovalUI();
                SetChosenAssignedUser();
            }
        }, 1);
    };

    $scope.getNonFrozenTasks = function (page) {
        console.log("Frozen Task called....");
        $scope.loaderFrozenTask.loading = true;
        $scope.pageFrozenTask = page || 0

        // make it blank so StaffTask grid don't bind.
        $scope.FrozenTask = [];


        //get all Customers
        getAllNonFrozenTasksWithSearchandPaging($http, "GetAllNonFrozenTasksWithPaging", { page: $scope.pageFrozenTask, pageSize: sequenceScopeNonFrozenTasks.pageSize == undefined ? 20 : sequenceScopeNonFrozenTasks.pageSize, DesignationIDs: sequenceScopeNonFrozenTasks.UserSelectedDesigIdsFrozenTaks.join(), UserId: sequenceScopeNonFrozenTasks.UserId, IsTechTask: $scope.IsTechTask }).then(function (data) {
            //debugger;
            $scope.loaderFrozenTask.loading = false;
            $scope.DesignationSelectModelFrozenTaks = [];
            var resultArray = JSON.parse(data.data.d);
            var results = resultArray.TasksData;
            //console.log("type of tasks is");
            //console.log(typeof results.Tasks);
            //console.log(results.Tasks);
            $scope.pageFrozenTask = results.RecordCount.PageIndex;
            $scope.TotalRecordsFrozenTask = results.RecordCount.TotalRecords;
            $scope.pagesCountFrozenTask = results.RecordCount.TotalPages;
            $scope.NonFrozenTask = $scope.correctDataforAngularFrozenTaks(results.Tasks);
            //$scope.TaskSelected = $scope.TechTasks[0];                
        });
    };

    $scope.getAssignUsers = function () {

        getDesignationAssignUsers($http, "GetAssignUsers", { TaskDesignations: $scope.UserSelectedDesigIdsFrozenTaks.join() }).then(function (data) {

            var AssignedUsers = JSON.parse(data.data.d);

            ///console.log(AssignedUsers);

            $scope.DesignationAssignUsers = AssignedUsers;

        });

    };

    $scope.SetIsTechTask = function () {
        console.log("callled $scope.SetIsTechTask");
        $scope.getTechTasks();

    };

    $scope.SetAssignedUsers = function (AssignedUsers) {
        //var selected = false;

        //if (AssignedUsers) {

        //   $scope.AssignedUsersArray = angular.fromJson("["+AssignedUsers+"]");

        //   angular.forEach($scope.AssignedUsersArray, function (value, key) {           
        //       if (parseInt(value.Id) === parseInt(UserId)) {
        //            selected = true;
        //           return selected;
        //       }
        //   });
        //}

        //return selected;
        if (AssignedUsers) {
            $scope.AssignedUsersArray = angular.fromJson("[" + AssignedUsers + "]");
        }
        else {
            $scope.AssignedUsersArray = [];
        }
        return $scope.AssignedUsersArray;
    };

    $scope.SetDesignForSearch = function (value, isReload) {
        $scope.UserSelectedDesigIdsFrozenTaks = [];
        $scope.UserSelectedDesigIdsFrozenTaks.push(value);
        //if (isRemove) {
        //    $scope.UserSelectedDesigIds.pop(value);
        //}
        //else { // if element is to be added
        //    if ($scope.UserSelectedDesigIds.indexOf(value) === -1) {//check if value is not already added then only add it.
        //        $scope.UserSelectedDesigIds.push(value);
        //    }
        //}
        if (isReload) {
            $scope.getFrozenTasks();
        }

    };

    $scope.refreshFrozenTask = function () {
        $scope.getFrozenTasks();
    };

    $scope.StringIsNullOrEmpty = function (value) {

        //var returnVal = (angular.isUndefined(value) || value === null || value)
        var returnVal = !value;
        return returnVal;
    };

    sequenceScopeNonFrozenTasks = $scope;

    $scope.toRoman = function (num) {

        if (!+num)
            return false;
        var digits = String(+num).split(""),
            key = ["", "C", "CC", "CCC", "CD", "D", "DC", "DCC", "DCCC", "CM",
                "", "X", "XX", "XXX", "XL", "L", "LX", "LXX", "LXXX", "XC",
                "", "I", "II", "III", "IV", "V", "VI", "VII", "VIII", "IX"],
            roman = "",
            i = 3;
        while (i--)
            roman = (key[+digits.pop() + (i * 10)] || "") + roman;

        return Array(+digits.join("") + 1).join("M") + roman;
    };

    $scope.getDesignationString = function (Designations) {

        if (!angular.isUndefinedOrNull(Designations)) {
            var DesignationArray = JSON.parse("[" + Designations + "]");

            return DesignationArray.map(function (elem) {
                return elem.Name;
            }).join(",");
        }
        else {
            return "";
        }
    };

    $scope.getSequenceDisplayText = function (strSequence, strDesigntionID, seqSuffix) {
        //console.log(strSequence + strDesigntionID + seqSuffix);
        var sequenceText = "#SEQ#-#DESGPREFIX#:#TORS#";
        sequenceText = sequenceText.replace("#SEQ#", strSequence).replace("#DESGPREFIX#", $scope.GetInstallIDPrefixFromDesignationIDinJS(parseInt(strDesigntionID))).replace("#TORS#", seqSuffix);
        return sequenceText;
    };

    $scope.GetInstallIDPrefixFromDesignationIDinJS = function (DesignID) {

        var prefix = "";
        switch (DesignID) {
            case 1:
                prefix = "ADM";
                break;
            case 2:
                prefix = "JSL";
                break;
            case 3:
                prefix = "JPM";
                break;
            case 4:
                prefix = "OFM";
                break;
            case 5:
                prefix = "REC";
                break;
            case 6:
                prefix = "SLM";
                break;
            case 7:
                prefix = "SSL";
                break;
            case 8:
                prefix = "ITNA";
                break;
            case 9:
                prefix = "ITJN";
                break;
            case 10:
                prefix = "ITSN";
                break;
            case 11:
                prefix = "ITAD";
                break;
            case 12:
                prefix = "ITSPH";
                break;
            case 13:
                prefix = "ITSB";
                break;
            case 14:
                prefix = "INH";
                break;
            case 15:
                prefix = "INJ";
                break;
            case 16:
                prefix = "INM";
                break;
            case 17:
                prefix = "INLM";
                break;
            case 18:
                prefix = "INF";
                break;
            case 19:
                prefix = "COM";
                break;
            case 20:
                prefix = "SBC";
                break;
            case 24:
                prefix = "ITSQA";
                break;
            case 25:
                prefix = "ITJQA";
                break;
            case 26:
                prefix = "ITJPH";
                break;
            default:
                prefix = "N.A.";
                break;
        }

        return prefix;
    };

    $scope.correctDataforAngularFrozenTaks = function (ary) {

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