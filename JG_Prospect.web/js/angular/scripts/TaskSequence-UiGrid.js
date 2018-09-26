app.controller('UiGridController', function ($scope, $compile, $http, $timeout) {
    applyUIGridFunctions($scope, $compile, $http, $timeout);

});


function applyUIGridFunctions($scope, $compile, $http, $timeout) {

    ApplyGridOptions($scope);

    $scope.getUITechTasks = function (page) {

        $scope.Techpage = page || 0;

        //get all Customers
        getTasksWithSearchandPagingM($http, "GetAllTasksWithPaging", { page: $scope.Techpage, pageSize: 20, DesignationIDs: '9,10', IsTechTask: true, HighlightedTaskID: 0 }).then(function (data) {

            //$scope.DesignationSelectModel = [];
            var results = JSON.parse(data.data.d);
            console.log(results.Tasks);
            //$scope.Techpage = results.RecordCount[0].PageIndex;
            //$scope.TechTotalRecords = results.RecordCount[0].TotalRecords;
            //$scope.TechpagesCount = results.RecordCount[0].TotalPages;
            $scope.TechTasks = results.Tasks;
            //$scope.TaskSelected = $scope.Tasks[0];
            $scope.gridOptions.data = $scope.TechTasks;
            
            console.log("grid options data is:");
            console.log($scope.gridOptions.data);

        });

    };

    initializeOnAjaxUpdate($scope, $compile, $http, $timeout);

    sequenceUIGridScope = $scope;
    
    $scope.getSequenceDisplayText = function (strSequence, strDesigntionID, seqSuffix) {
       
        var sequenceText = "#SEQ#-#DESGPREFIX#:#TORS#";

        sequenceText = sequenceText.replace("#SEQ#", strSequence).replace("#DESGPREFIX#", $scope.GetInstallIDPrefixFromDesignationIDinJS(strDesigntionID)).replace("#TORS#", seqSuffix);

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
                prefix = "ITPH";
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
}

function initializeOnAjaxUpdate(scope, compile, http, timeout) {

    Sys.WebForms.PageRequestManager.getInstance().add_endRequest(function () {
        var elem = angular.element(document.getElementById("divUIGrid"));
        compile(elem.children())(scope);
        scope.$apply();

        applyUIGridFunctions(scope, compile, http, timeout);
    });

}

function ApplyGridOptions($scope) {

    $scope.gridOptions = {
        data: $scope.TechTasks,
        showTreeRowHeader: false,
        expandableRowTemplate: '../js/angular/templates/expandableRowTemplate.html',
        headerTemplate: '../js/angular/templates/sequence-header-template.html',
        expandableRowHeight: 150,
        onRegisterApi: function (gridApi) {
            gridApi.expandable.on.rowExpandedStateChanged($scope, function (row) {
                if (row.isExpanded) {

                }
            });
        }
    }
    $scope.gridOptions.columnDefs = [
        {
            enableHiding: false, enableSorting: false, name: 'Sequence#', cellTemplate: `<div style="width:5%;"><a href="javascript:void(0);" onclick="showEditTaskSequence(this)" class="badge-hyperlink autoclickSeqEdit" ng-attr-data-taskid="{{row.entity.TaskId}}" ng-attr-data-seqdesgid="{{row.entity.SequenceDesignationId}}"><span class="badge badge-success badge-xstext">
                                        <label ng-attr-id="SeqLabel{{row.entity.TaskId}}">{{grid.appScope.getSequenceDisplayText(!row.entity.Sequence?"N.A.": row.entity.Sequence, row.entity.SequenceDesignationId, !row.entity.IsTechTask ? "SS": "TT") }}</label></span></a><a style="text-decoration: none;" ng-attr-data-taskid="{{row.entity.TaskId}}" href="javascript:void(0);" class="uplink" ng-class="{hide: row.entity.Sequence == null || 0}" ng-attr-data-taskseq="{{row.entity.Sequence}}" ng-attr-data-taskdesg="{{row.entity.SequenceDesignationId}}" onclick="swapSequence(this,true)">&#9650;</a><a style="text-decoration: none;" ng-class ="{hide: row.entity.Sequence == null || 0}" ng-attr-data-taskid="{{row.entity.TaskId}}" ng-attr-data-taskseq="{{row.entity.Sequence}}" class ="downlink" ng-attr-data-taskdesg="{{row.entity.SequenceDesignationId}}" href="javascript:void(0);" onclick="swapSequence(this,false)">&#9660; </a>
                                        <div class="handle-counter" ng-class="{hide: row.entity.TaskId != HighLightTaskId}" ng-attr-id="divSeq{{row.entity.TaskId}}">
                                            <input type="text" class="textbox hide" ng-attr-data-original-val='{{ row.entity.Sequence == null && 0 || row.entity.Sequence}}' ng-attr-data-original-desgid="{{row.entity.SequenceDesignationId}}" ng-attr-id='txtSeq{{row.entity.TaskId}}' value="{{row.entity.Sequence == null && 0 || row.entity.Sequence}}" />

                                            <div style="clear: both;">
                                                <a id="save" href="javascript:void(0);" ng-attr-data-taskid="{{row.entity.TaskId}}" onclick="javascript:UpdateTaskSequence(this);">Save</a>&nbsp;&nbsp; <a id="Delete" href="javascript:void(0);" ng-attr-data-taskid="{{row.entity.TaskId}}" ng-class="{hide: row.entity.Sequence == null || 0}" onclick="javascript:DeleteTaskSequence(this);">Delete</a>
                                            </div>
                                        </div></div>`
        },
        {
            enableHiding: false, enableSorting: false, name: 'ID#', cellTemplate: `<div style="width:7%;"><a ng-href="../Sr_App/TaskGenerator.aspx?TaskId={{row.entity.MainParentId}}&hstid={{row.entity.TaskId}}" class="bluetext" target="_blank">{{ row.entity.InstallId }}</a>
                 <br />
            {{grid.appScope.getDesignationString(row.entity.TaskDesignation) }}
                                        <div ng-attr-id="divSeqDesg{{ row.entity.TaskId}}" ng-class ="{hide:  row.entity.TaskId != HighLightTaskId}">
                                            <select class ="textbox" ng-attr-data-taskid="{{ row.entity.TaskId}}" onchange="showEditTaskSequence(this)" ng-options="item as item.Name for item in ParentTaskDesignations track by item.Id" ng-model="DesignationSelectModel[0]">
                                            </select>
                                        </div></div>
                                        `
        },
        {
            enableHiding: false, enableSorting: false, name: 'Parent Task',cellTemplate: `<div style="width:25%;"> <strong>
                                        <label>{{ row.entity.ParentTaskTitle }}</label></strong><br />
            <label>{{ row.entity.Title }}</label></div>
            `
        },
        {
            enableHiding: false, enableSorting: false, name: 'Task Status', cellTemplate: `<div style="width:5%;">
                 <any ng-switch="{{row.entity.Status}}">
                    <ANY ng-switch-when="1">Open</ANY>
                    <ANY ng-switch-when="2">Requested</ANY>
                    <ANY ng-switch-when="3">Assigned</ANY>
                    <ANY ng-switch-when="4">InProgress</ANY>
                    <ANY ng-switch-when="5">Pending</ANY>
                    <ANY ng-switch-when="6">ReOpened</ANY>
                    <ANY ng-switch-when="7">Closed</ANY>
                    <ANY ng-switch-when="8">SpecsInProgress</ANY>
                    <ANY ng-switch-when="9">Deleted</ANY>
                    <ANY ng-switch-when="10">Finished</ANY>
                    <ANY ng-switch-when="11">Test</ANY>
                    <ANY ng-switch-when="12">Live</ANY>
                    <ANY ng-switch-when="14">Billed</ANY>

                </any>
                </div>  `
        }

    ];

    //$scope.gridOptions.data = $scope.TechTasks;
    
    }
