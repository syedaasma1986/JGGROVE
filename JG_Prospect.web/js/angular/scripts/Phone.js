applicantStatuses = [2, 17, 18, 5, 6];
rApplicantStatuses = [10, 19, 20, 21, 22, 12];
allAllowedStatuses = [9, 1, 3];

app.controller('SalesUserController1', function ($scope, $compile, $http, $timeout, $filter) {
    _applyFunctions($scope, $compile, $http, $timeout, $filter);
});
app.filter('unsafe', function ($sce) { return $sce.trustAsHtml; });

function callWebServiceMethod($http, methodName, filters, sender) {
    return $http.post(url + methodName, filters);
};
function _applyFunctions($scope, $compile, $http, $timeout, $filter) {
    //var list = '[{"Id": 10},{"Id": 10},{"Id": 10},{"Id": 10},{"Id": 10},]';
    $scope.trustAsHtml = function (string) {
        return $sce.trustAsHtml(string);
    };

    $scope.UserList = [];
    $scope.UserEmailList = [];
    $scope.UserPhoneList = [];
    $scope.Test = { 'Id': 100 };
    $scope.PhoneCallLogList = [];
    $scope.PhoneCallStatistics = {};
    $scope.ReminderEmailContent = {};

    $scope.GetPhoneCallLogList = function (sender, callType) {
        ShowAjaxLoader();
        callWebServiceMethod($http, 'GetPhoneCallLog', { index: 1, pageSize: 20, callType: callType }, sender)
            .then(function (data) {
                HideAjaxLoader();
                $scope.PhoneCallLogList = JSON.parse(data.data.d);
                RemoveThrobber();
            });
        callWebServiceMethod($http, 'GetPhoneCallStatistics', {}, sender)
            .then(function (data) {
                HideAjaxLoader();
                $scope.PhoneCallStatistics = JSON.parse(data.data.d).Object;
                RemoveThrobber();
            });
    }

    $scope.GetPhoneScriptData = function (sender, did, type, subtype) {
        ShowAjaxLoader();
        callWebServiceMethod($http, 'GetPhoneScripts', { designationId: did, type: type, subType: subtype }, sender)
            .then(function (data) {
                HideAjaxLoader();
                $scope.PhoneScriptData = JSON.parse(data.data.d);
                RemoveThrobber();
                setTimeout(function () {
                    if ($scope.PhoneScriptData.Results.length == 0) {
                        SetCKEditorForTaskPopup('script-0-script');
                        SetCKEditorForTaskPopup('script-0-faq');
                    }
                }, 100);                
            });
    }

    $scope.GetReminderEmailContent = function (sender) {
        var uid = $(sender).parents('tr').attr('userid');
        ShowAjaxLoader();
        callWebServiceMethod($http, 'GetReminderEmailContent', { userId: uid }, sender)
            .then(function (data) {
                HideAjaxLoader();
                $scope.ReminderEmailContent = JSON.parse(data.data.d);
                $('#reminerEmail').show();
                $('.overlay').show();
                $('#reminderEmailBody').val($scope.ReminderEmailContent.Object.Body);
                SetCKEditorForTaskPopup('reminderEmailBody');
                RemoveThrobber();
                setTimeout(function () {
                    var sW = $(window).width();
                    var pW = $('#reminerEmail').width();
                    $('#reminerEmail').css({ 'left': ((sW / 2) - (pW / 2)) + 'px' });
                }, 100);
            });
    }

    $scope.Paging = function (sender, FirstTimeOpen, restartAutoDialer) {
        $('#PageIndex').val(paging.currentPage);
        paging.pageSize = $('.recordsPerPage').find('option:selected').val();
        var keyword = $('.userKeyword').val().trim();
        var status = $('div.user-status select').val() == null ? '' : $('div.user-status select').val().join(',');
        var secondaryStatus = $('div.user-secondary-status select').val() == null ? '' : $('div.user-secondary-status select').val().join(',');
        var designationId = $('div.designationId select').val()==null ? '' : $('div.designationId select').val().join(',');
        var source = $('div.source select').val()==null ? '' : $('div.source select').val().join(',');
        var from = $('input.fromDate').val();
        var to = $('input.toDate').val();
        var addedBy = $('div.addedBy select').val() == null ? '' : $('div.addedBy select').val().join(',');
        var sortBY = 'LastLoginTimeStamp DESC';
        if (from == '' || from == null || from.toLowerCase() == 'all')
            from = '01/01/1999';
        if (to == '' || to == null)
            to = '01/01/2080';
        

        //JG Chat 06/14/2018 - make default .net designation and last added on.
        //if (typeof designationId == 'undefined' || designationId == "" || designationId == "0") {
        //designationId = 9;
        sortBY = $('#ddlSavedReports').val();
        //}
        FirstTimeOpen = (FirstTimeOpen == undefined || FirstTimeOpen == null) ? false : FirstTimeOpen;
        ShowAjaxLoader();
        callWebServiceMethod($http, 'GetSalesUsers', { startIndex: $('#PageIndex').val(), pageSize: paging.pageSize, keyword: keyword, status: status, secondaryStatus: secondaryStatus, designationId: designationId, source: source, from: from, to: to, addedByUserId: addedBy, sortBY: sortBY, FirstTimeOpen: FirstTimeOpen }, sender)
            .then(function (data) {

                HideAjaxLoader();
                $('.play-stop').show();
                // Reset Auto-Dialer
                stopAutoDialer(this);

                RemoveThrobber();
                $scope.UserList = JSON.parse(data.data.d);
                
                $('#PageIndex').val($scope.UserList.StartIndex);
                paging.currentPage = $scope.UserList.StartIndex;

                PageNumbering($scope.UserList.TotalResults);
                // Reset Phone Dialer list
                if (salesUsers != undefined && salesUsers != null) {
                    salesUsers.length = 0;
                }

                //userDesignations
                var str = '', options = '';
                setTimeout(function () {
                    
                    options = $('.userlist-grid .header-table .user-designations').find('select').html();
                    str = '<select class="" onchange="ChangeDesignation(this)">' + options + '</select>';
                    $('#SalesUserGrid').find('.userDesignations').each(function (i) {
                        var did = $(this).attr('did');
                        $(this).html(str);
                        $(this).find('option:nth-child(1)').remove();
                        $(this).find('select').val(did);
                    });
                    options = $('.userlist-grid .header-table .user-status').find('select').html();
                    str = '<select class="" onchange="ChangeUserStatus(this)">' + options + '</select>';
                    $('#SalesUserGrid').find('.status').each(function (i) {
                        var stid = parseInt($(this).attr('stid'));
                        $(this).html(str);
                        //$(this).find('option:nth-child(1)').remove();
                        $(this).find('select').val(stid);
                        if (applicantStatuses.indexOf(stid) >= 0) {
                            //debugger;
                            // Remove non applicant
                            $(this).find('select option').each(function () {
                                var innerStatus = parseInt($(this).val());
                                if (applicantStatuses.indexOf(innerStatus) < 0) {
                                    //debugger;
                                    if (allAllowedStatuses.indexOf(innerStatus) < 0) {
                                        $(this).remove();
                                    }
                                }
                            });
                        } else if (rApplicantStatuses.indexOf(stid) >= 0) {
                            // Remove non r-applicant
                            $(this).find('select option').each(function () {
                                var innerStatus = parseInt($(this).val());
                                if (rApplicantStatuses.indexOf(innerStatus) < 0) {
                                    if (allAllowedStatuses.indexOf(innerStatus) < 0) {
                                        $(this).remove();
                                    }
                                }
                            });
                        } else if (allAllowedStatuses.indexOf(stid) >= 0) {
                            $(this).find('select option').each(function () {
                                var innerStatus = parseInt($(this).val());
                                if (allAllowedStatuses.indexOf(innerStatus) < 0) {
                                    $(this).remove();
                                }
                            });
                        } else {
                            // Remove all
                            $(this).find('select option').each(function () {
                                $(this).remove();
                            });
                        }
                        
                    });

                    $('#SalesUserGrid').find('.secondary-status').each(function (i) {
                        var stid = $(this).attr('secid');
                        $(this).find('select').val(stid);
                    });

                    options = $('.userlist-grid .header-table .employmentTypes').find('select').html();
                    str = '<select class="" onchange="updateEmpType(this)">' + options + '</select>';
                    $('#SalesUserGrid').find('.employmentTypes').each(function (i) {
                        var empType = $(this).attr('empType');
                        $(this).html(str);
                        $(this).find('select').val(empType);
                    });

                    options = $('.userlist-grid .header-table .phoneTypes').find('select').html();
                    str = '<select class="" onchange="setWatermark(this)">' + options + '</select>';
                    $('#SalesUserGrid').find('.phoneTypes').each(function (i) {
                        // var empType = $(this).attr('empType');
                        $(this).html(str);
                        //$(this).find('select').val(empType);
                    });
                    $('#SalesUserGrid').find('select').find('option').removeAttr('data-ng-repeat');
                    //$('#SalesUserGrid').find('select').find('option').removeAttr('class');
                    $('#SalesUserGrid').find('select').chosen({ width: '100%' });
                    //$('#SalesUserGrid').find('select').on("chosen:showing_dropdown", function () {
                    //    $(".chosen-results").find('li').each(function (index) {
                    //        $(this).prepend("<span style='color: red'>*</span> ");
                    //    });
                    //});
                    
                    //debugger;
                    //1 -> 1 - 20 , pagenumber - pagesize
                    //2 -> 21 - 40, (pagesize * (pagenumber - 1)) + 1 - (pageSize * (pagenumber))
                    //3 -> 41 - 60, (pagesize + (pagenumber - 1)) + 1 - (pageSize * (pagenumber))
                    $('.header-table .pageNumber').html(((paging.currentPage * paging.pageSize) + 1));
                    $('.header-table .pazeSize').html(((paging.currentPage + 1) * paging.pageSize));
                    $('.header-table .totalRecords').html($scope.UserList.TotalResults);

                    // Loading Notes
                    ReLoadNotes();
                    var salesPreUsers = [], num = 1;
                    // Setting CallSeek
                    $('#SalesUserGrid > tr').each(function () {
                        salesPreUsers.push({
                            Seq: num++,
                            UserId: $(this).attr('userid'),
                            UserInstallId: $(this).attr('userinstallid'),
                            LastCalledAt: $(this).attr('last-called-at'),
                            Number: $(this).attr('number'),
                            AllNumbers: getAllSelectValues($(this).find('.userPhones .clickable-dropdown')),
                            CalledNow: false
                        });
                        if ($(this).find('.caller-position').find('span').is(':visible')) {
                            currentCallingUserId = $(this).attr('userid');
                            currentCallingUserSeq = num - 1;
                        }
                    });
                    var nextUserId = parseInt($scope.UserList.NextCallingCandidateUserId);

                    $('#SalesUserGrid').find('.caller-position').find('span').hide();
                    $('#SalesUserGrid').find('.caller-position').find('input').show();
                    if (nextUserId > 0) {
                        $('#SalesUserGrid tr[userid="' + nextUserId + '"]').find('.caller-position').find('span').show();
                        $('#SalesUserGrid tr[userid="' + nextUserId + '"]').find('.caller-position').find('input').hide();
                    } else {
                        // set to first user in the list
                        $('#SalesUserGrid tr:first').find('.caller-position').find('span').show();
                        $('#SalesUserGrid tr:first').find('.caller-position').find('input').hide();
                    }

                    if (restartAutoDialer) {
                        setTimeout(function () {
                            console.log('restartAutoDialer moving next page');
                            startAutoDialer(this);
                        }, gapBetweenCall);
                    }

                    $('#SalesUserGrid').find('.status').each(function (i) {
                        var stid = parseInt($(this).attr('stid'));
                        // apply css asterisk on selected status
                        $(this).find('.chosen-container a.chosen-single').addClass('color-' + stid);
                    });
                }, 100);
            });
    }

    sequenceScopePhone = $scope;
}