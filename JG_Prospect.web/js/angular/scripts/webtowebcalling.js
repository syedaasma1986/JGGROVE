app.controller('WebToWebController', function ($scope, $compile, $http, $timeout, $filter) {
    _applyWebCallingFunctions($scope, $compile, $http, $timeout, $filter);
});
app.filter('unsafe', function ($sce) { return $sce.trustAsHtml; });

function callWebServiceMethod($http, methodName, filters, sender) {
    return $http.post(url + methodName, filters);
};
function _applyWebCallingFunctions($scope, $compile, $http, $timeout, $filter) {
    //var list = '[{"Id": 10},{"Id": 10},{"Id": 10},{"Id": 10},{"Id": 10},]';
    $scope.trustAsHtml = function (string) {
        return $sce.trustAsHtml(string);
    };

    $scope.WebToWebCallObj = {};
    $scope.CalleeUser = {};

    $scope.mySplit = function (string, delimeter, index) {
        var array = string.split(delimeter);
        return array[index];
    }

    $scope.InitiateWebToWebCall = function (sender, userchatgroupid, userid, isGroupCall) {
        // ShowAjaxLoader();
        callWebServiceMethod($http, 'InitiateWebToWebCall', { IsGroupCall: isGroupCall, userchatgroupid: userchatgroupid, userid: userid }, sender)
            .then(function (data) {
                var jsonData = JSON.parse(data.data.d);
                if (jsonData.Object == null || jsonData.Object == 'null') {
                    // Person is not online Or It's a group call
                    $scope.WebUsers = jsonData.Results;

                } else {
                    $('.video-dashboard .video-area').find('iframe').removeAttr('src');
                    $scope.CalleeUser = jsonData.Object;
                    $('.telecom-dashboard-popup').hide();
                    $('.phone-dashboard').hide();
                    $('div.video-dashboard').hide();
                    $('div.overlay').show();
                    $('div.audio-video-record').show();
                    // Calculate Center
                    var sW = $(window).width();
                    var pW = $('.audio-video-record').width();
                    var sH = $(window).height();
                    var pH = $('.audio-video-record').height();
                    $('.audio-video-record').css({ 'left': ((sW / 2) - (pW / 2)) + 'px', 'top': ((sH / 2) - (pH / 2)) + 'px' });
                    window.scrollTo(0, 0);
                }
            });
    }

    $scope.AddUserIntoCall = function (sender, GroupName, UserId) {
        callWebServiceMethod($http, 'AddUserIntoCall', { GroupName: GroupName, UserId: UserId }, sender)
            .then(function (data) {

            });
    }

    $scope.SendMissedCallAlert = function (sender, CalleeUserId) {
        // ShowAjaxLoader();
        callWebServiceMethod($http, 'SendMissedCallAlert', { CalleeUserId: CalleeUserId }, sender)
            .then(function (data) {                // 
                
            });
    }

    $scope.GetWebCallingUsers = function (sender, CallGroupURL, GroupNameID) {
        // ShowAjaxLoader();
        callWebServiceMethod($http, 'GetWebCallingUsers', {}, sender)
            .then(function (data) {
                var jsonData = JSON.parse(data.data.d);
                $scope.WebUsers = jsonData.Results;
                $('.telecom-dashboard-popup').hide();
                $('.phone-dashboard').hide();
                $('div.video-dashboard').show();
                $('div.overlay').show();
                $('.call-ring-box').hide();

                // Calculate Center
                var sW = $(window).width();
                var pW = $('.video-dashboard').width();
                var sH = $(window).height();
                var pH = $('.video-dashboard').height();
                $('.video-dashboard').css({ 'left': ((sW / 2) - (pW / 2)) + 'px', 'top': ((sH / 2) - (pH / 2)) + 'px' });
                window.scrollTo(0, 0);
                $('.video-dashboard .video-area').find('iframe').attr('src', CallGroupURL);
            });
    }

    $scope.RejectAndNotify = function (sender, GroupNameID, CallerUserId, IsGroupCall) {
        // ShowAjaxLoader();
        callWebServiceMethod($http, 'RejectAndNotify', { GroupNameID: GroupNameID, CallerUserId: CallerUserId, IsGroupCall: IsGroupCall }, sender)
            .then(function (data) {
                //var jsonData = JSON.parse(data.data.d);
                //$scope.WebUsers = jsonData.Results;
                $('.telecom-dashboard-popup').hide();
                $('.phone-dashboard').hide();
                $('div.video-dashboard').hide();
                $('div.overlay').hide();
                $('.call-ring-box').hide();

                $('.video-dashboard .video-area').find('iframe').removeAttr('src');
            });
    }


    sequenceScopeWebToWebCall = $scope;
}