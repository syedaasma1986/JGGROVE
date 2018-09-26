//var app = angular.module('JGApp', ['ui.grid', 'ui.grid.expandable']);
var app = angular.module('JGApp', ['ngSanitize'], function ($compileProvider) {
    $compileProvider.aHrefSanitizationWhitelist(/^\s*(https?|ftp|mailto|file):/);
});
var url = '/WebServices/JGWebService.asmx/';
var sequenceScope, sequenceScopeClosedTasks, sequenceScopeFrozenTasks, sequenceUIGridScope,
    sequenceScopeTG, sequenceScopePhone, PayRateScope, ManageResourceScope, sequenceScopePA;

/*************************************************************************/
// DIRECTIVES
app.filter('num', function () {
    return function (input) {
        return parseInt(input, 10);
    };
});

app.directive('jgpager', function () {
    return {
        scope: {
            page: '@',
            pagesCount: '@',
            TotalRecords: '@',
            searchFunc: '&'
        },
        replace: true,
        restrict: 'E',
        templateUrl: '../js/angular/templates/pager-template.html',
        controller: ['$scope', function ($scope) {
            $scope.search = function (i) {
                if ($scope.searchFunc) {
                    $scope.searchFunc({ page: i });
                }
            };

            $scope.range = function () {
                if (!$scope.pagesCount) { return []; }
                var step = 2;
                var doubleStep = step * 2;
                var start = Math.max(0, $scope.page - step);
                var end = start + 1 + doubleStep;
                if (end > $scope.pagesCount) { end = $scope.pagesCount; }

                var ret = [];
                for (var i = start; i != end; ++i) {
                    ret.push(i);
                }

                return ret;
            };
        }]
    }
}).directive("repeatEnd", function () {
    return {
        restrict: "A",
        link: function (scope, element, attrs) {
            if (scope.$last) {
                scope.$eval(attrs.repeatEnd);
            }
        }
    };
});

angular.isUndefinedOrNull = function (val) {
    return angular.isUndefined(val) || val === null;
};

angular.getSequenceDisplayText = function (strSequence, strDesigntionID, seqSuffix) {
    var sequenceText = "#SEQ#-#DESGPREFIX#:#TORS#";
    sequenceText = sequenceText.replace("#SEQ#", strSequence).replace("#DESGPREFIX#", angular.GetInstallIDPrefixFromDesignationIDinJS(parseInt(strDesigntionID))).replace("#TORS#", seqSuffix);
    return sequenceText;
};

angular.GetInstallIDPrefixFromDesignationIDinJS = function (DesignID) {

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

(function () {
    'use strict';

    angular
        .module('JGApp')
        .filter('utcToLocal', Filter)
        .filter('semiColSplit', function () {
            return function (input) {
                console.log(input);
                if (input != null && input != undefined) {
                    var ar = input.split(';'); // this will make string an array 
                    return ar;
                }
                else {
                    return null
                }
            };
        });

    function Filter($filter) {
        return function (utcDateString, format) {
            // return if input date is null or undefined
            if (!utcDateString) {
                return;
            }

            // append 'Z' to the date string to indicate UTC time if the timezone isn't already specified
            if (utcDateString.indexOf('Z') === -1 && utcDateString.indexOf('+') === -1) {
                utcDateString += 'Z';
            }

            // convert and format date using the built in angularjs date filter
            return $filter('date')(utcDateString, format);
        };
    }
})();
