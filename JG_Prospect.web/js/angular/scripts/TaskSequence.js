app.controller('TaskSequenceSearchController', function ($scope, $compile, $http, $timeout, $filter) {    
    applyFunctions($scope, $compile, $http, $timeout, $filter);
});
app.filter('trustAsHtml', function ($sce) { return $sce.trustAsHtml; });
function getTasksWithSearchandPaging(methodName, $http) {
    return $http.get(url + methodName);
}

function getTasksWithSearchandPagingM($http, methodName, filters) {
    return $http.post(url + methodName, filters);
};

function getDesignationAssignUsers($http, methodName, filters) {
    return $http.post(url + methodName, filters);
};

function getTasksForSubSequencing($http, methodName, filters) {
    return $http.post(url + methodName, filters);
};
function callWebServiceMethod($http, methodName, filters) {
    return $http.post(url + methodName, filters);
};


function applyFunctions($scope, $compile, $http, $timeout, $filter) {
    $scope.IsAdmin = false;
    $scope.Tasks = [];
    $scope.ClosedTask = [];
    $scope.ParentTaskDesignations = [];
    $scope.DesignationAssignUsers = [];
    $scope.DesignationAssignUsersModel = [{ FristName: "Select", Id: 0, Status: "", CssClass: "" }];
    $scope.SelectedParentTaskDesignation;
    $scope.UserSelectedDesigIds = [];
    $scope.DesignationSelectModel = [];
    $scope.UserStatus = 1;
    $scope.StartDate = '';
    $scope.EndDate = '';
    $scope.IsTechTask = true;
    $scope.ForDashboard = false;
    $scope.UserId = '';
    $scope.vSearch = "";
    $scope.pageFrom = "0";
    $scope.pageTo = "0";
    $scope.pageOf = "0";
    $scope.pageFromCT = "0";
    $scope.pageToCT = "0";
    $scope.pageOfCT = "0";
    $scope.TotalHoursITLead = 0;
    $scope.TotalHoursUsers = 0;
    $scope.SeqSubsets = [];
    $scope.ForInProgress = true;


    $scope.loader = {
        loading: false,
    };

    $scope.loaderClosedTask = {
        loading: false,
    };

    $scope.page = 0;
    $scope.pageSize = 5;
    $scope.pagesCount = 0;
    $scope.Currentpage = 0;
    $scope.TotalRecords = 0;
    $scope.pageCT = 0;
    $scope.pagesCountCT = 0;
    $scope.CurrentpageCT = 0;
    $scope.TotalRecordsCT = 0;
    $scope.HighLightTaskId = 0;
    $scope.BlinkTaskId = 0;
    $scope.CalendarUsers = [];
    $scope.Romans = [];
    $scope.IntPopRomans = [];
    $scope.TechTasks = [];
    $scope.Techpage = 0;
    $scope.TechpagesCount = 0;
    $scope.TechCurrentpage = 0;
    $scope.TechTotalRecords = 0;
    var uid;
    
    $scope.getFilesByDesignation = function (locationId, designationId) {
        getFilesByDesignation($scope, $http, locationId, designationId);
       
    }
    ScopeIT = $scope;
    $scope.LoadCalendarData = function () {
        //debugger;
        $('#calendar').fullCalendar({
            header: {
                left: 'prev,next today',
                center: 'title',
                right: 'month,agendaWeek,agendaDay'
            },
            //defaultDate: '2017-12-1',
            defaultView: 'agendaWeek',
            minTime: '06:00:00',
            maxTime:'30:00:00',
            navLinks: true, // can click day/week names to navigate views
            editable: true,
            eventLimit: true, // allow "more" link when too many events
            events: function (start, end, timezone, callback) {
                $('#loading').fadeIn(300);
                callWebServiceMethod($http, "GetCalendarTasksByDate", { StartDate: $scope.StartDate == '' ? start : $scope.StartDate, EndDate: $scope.EndDate == '' ? end : $scope.EndDate, UserId: sequenceScope.UserId, DesignationIDs: sequenceScope.UserSelectedDesigIds, TaskUserStatus: sequenceScope.UserStatus }).then(function (data) {
                    CalendarData = JSON.parse(data.data.d);
                    CalendarData = CalendarData.AllEvents;

                    //Clear Start & End Dates
                    //$scope.StartDate = $scope.EndDate = '';
                    //debugger;
                    var events = [];
                    if (!!CalendarData) {
                        $.map(CalendarData, function (r) {
                            events.push({
                                id: r.TaskId,
                                title: r.Title.substring(0, 20) + '<span id="shown">...</span><span id="hidden">' + r.Title.substring(20, r.Title.length) + '</span><span id="shown" class="InstallId"> <a target="_blank" href="TaskGenerator.aspx?TaskId=' + (r.IsRoman == true ? r.MainTaskId : r.ParentTaskId) + '&hstid=' + (r.IsRoman == true ? r.ParentTaskId : r.TaskId) + (r.IsRoman == true ? '&mcid=' + r.TaskId : '') + '">' + r.InstallId + '</a></span>'
                                    + '&nbsp; <span class="UserInstallId" id="shown"><a target="_blank" href="ViewSalesUser.aspx?id=' + r.UserId + '">' + r.AssignedUsers + '</a></span>',
                                start: r.StartDate,
                                end: r.EndDate,
                                color: r.Status,
                                textColor: r.TextColor,
                                className: 'eventRow' + r.UserId
                            });
                        });
                    }
                    callback(events);
                    //Change View        
                    if ($scope.StartDate != '' && $scope.StartDate != undefined && $scope.StartDate != 'All') {
                        //$('#calendar').fullCalendar('changeView', 'month', $scope.StartDate == '' ? start : $scope.StartDate);
                        //$scope.StartDate = $scope.EndDate = '';
                    }
                    //Clear Dates after use to prevent apply filters forcefully                    
                    $('#loading').fadeOut(300);
                });

            },
            eventMouseover: function (data, event, view) {

                tooltip = '<div class="tooltiptopicevent" style="width:auto;height:auto;background:#fff;position:absolute;z-index:10001;padding:10px 10px 10px 10px ;  line-height: 200%; box-shadow: 0 2px 5px 0 rgba(0, 0, 0, 0.26);">' +
                    data.title.replace("hidden", "").replace("shown", "hidden") + '</div>';
                tooltip = tooltip.replace("shown", "hidden");
                tooltip = tooltip.replace("shown", "hidden");

                $("body").append(tooltip);
                $(this).mouseover(function (e) {
                    $(this).css('z-index', 10000);
                    $('.tooltiptopicevent').fadeIn('500');
                    $('.tooltiptopicevent').fadeTo('10', 1.9);
                }).mousemove(function (e) {
                    $('.tooltiptopicevent').css('top', e.pageY + 10);
                    $('.tooltiptopicevent').css('left', e.pageX + 20);
                });


            },
            eventMouseout: function (data, event, view) {
                $(this).css('z-index', 8);

                $('.tooltiptopicevent').remove();

            },
            
            eventResizeStart: function () {
                tooltip.hide()
            },
            eventDragStart: function () {
                tooltip.hide()
            },
            viewRender: function (view, element) {
                $('.dateFrom').val($('#calendar').fullCalendar('getView').start.format());
                $('.dateTo').val($('#calendar').fullCalendar('getView').end.format());

                if ($('.fc-view-container div.fc-agendaWeek-view').length > 0) {
                    $('.fc-day-header').each(function (i, elem) {
                        var html = $(this).children('a').html();
                        var day = html.split(' ')[0];
                        var date = html.split(' ')[1].split('/')[1];
                        var newData = '<span><span style="font-size: 12px;line-height: 22px;vertical-align: top;float: left;">' + day + '</span><br><span style="float: left;font-weight: normal;font-size: 50px;">' + date + '</span></span>';
                        $(this).html(newData);
                    });
                }
                $('.fc-agendaWeek-view').find('table:first').find('table:nth(1)').find('td.fc-day').each(function (i, obj) {
                    $(this).attr('data-index', i);
                });
                $('.fc-scroller').find('.fc-content-skeleton').find('td:not(.fc-axis)').each(function (i, obj) {
                    $(this).attr('data-index', i);
                });
                if (view.name != 'month')
                    loadDayUsers();
            },
            eventRender: function (event, element) {
                // render the timezone offset below the event title
                if (event.start.hasZone()) {
                    element.find('.fc-title').after(
                      $('<div class="tzo"/>').text(event.start.format('Z'))
                    );
                }
                element.find('.fc-title').html(event.title);
            },
            loading: function (bool) {
                if (!bool) {
                    //debugger;
                    loadDayUsers();                    
                }
                //Possibly call you feed loader to add the next feed in line
            }            
        });
        // load the list of available timezones, build the <select> options
        $.getJSON('https://fullcalendar.io/demo-timezones.json', function (timezones) {
            $.each(timezones, function (i, timezone) {
                if (timezone != 'UTC') { // UTC is already in the list
                    $('#timezone-selector').append(
                      $("<option/>").text(timezone).attr('value', timezone)
                    );
                }
            });
        });
        // when the timezone selector changes, dynamically change the calendar option
        $('#timezone-selector').on('change', function () {
            $('#calendar').fullCalendar('option', 'timezone', this.value || false);
        });
    }

    
    function loadDayUsers() {
        if (CalendarUserClickSource == 'PIC' || $('.fc-view-container div.fc-month-view').length>0)
            return false;
        $('.fc-week div.fc-bg table').find('td.fc-day').each(function (i, el) {
            var sender = $(this);
            $(sender).html('Loading...');
            //$(sender).html('');
            var colDate = $(sender).attr('data-date');
            callWebServiceMethod($http, "GetCalendarUsersByDate", { Date: colDate, UserId: sequenceScope.UserId, DesignationIDs: sequenceScope.UserSelectedDesigIds, TaskUserStatus: sequenceScope.UserStatus }).then(function (data) {
                $scope.CalendarUsers = JSON.parse(data.data.d);
                CalendarUsers = $scope.CalendarUsers.Users;
                //debugger;
                if (CalendarUsers.length > 0) {
                    //var html = '<div class="calendar-users-container" id="user-container-' + colDate + '">';
                    var html = '<select multiple="multiple" class="calendar-users-container" id="user-container-' + colDate + '">';
                    $.each(CalendarUsers, function (i, item) {
                        //html += '<img title="' + item.FullName + '" id="Header1_imgProfile" data-uid="' + item.UserId + '" style="border-radius: 50%;width: 34px;height: 34px;padding:5px" class="img-Profile calendar-user" src="../Employee/ProfilePictures/' + item.Picture + '">';
                        html += '<option selected="selected" title="' + item.FullName + '" value="' + item.UserId + '" data-img-src="../Employee/ProfilePictures/' + item.Picture + '">' + item.FullName + '</option>';
                    });
                    html += '</select>';
                   // html += '<a href="#/" class="clear-user-filter">Clear All</a></div>';
                    $(sender).html(html);                    
                    $("#user-container-" + colDate).chosen();
                    //Attach Event Handlers
                    //Clear Button
                    $('#user-container-' + colDate + ' .clear-user-filter').click(function () {
                        uid = '';
                        $('#user-container-' + colDate + ' .calendar-user').removeClass('calendar-users-image-border');
                        //setCalendarFilterData();
                        //refreshCalendarTasks();
                        //Show only all user's events
                        var index = $(this).parent().parent('td').attr('data-index');
                        if (index != undefined && uid != undefined) {
                            $('.fc-scroller').find('.fc-content-skeleton').find('td:not(.fc-axis)').each(function (i, obj) {
                                var td = $(this);
                                if ($(td).attr('data-index') == index) {
                                    $(td).find('a.fc-event').fadeIn(200);                                    
                                }
                            });
                        }
                    });

                    $(document).on('change', '#user-container-' + colDate, function () {
                        var uids = [];
                        $(this).find('option:selected').each(function (i) {
                            uids.push($(this).val());
                        });
                        CalendarUserClickSource = 'PIC';
                        //Show only clicked user's events
                        var index = $(this).parents('td').attr('data-index');
                        if (index != undefined /*&& uid != undefined*/) {
                            $('.fc-scroller').find('.fc-content-skeleton').find('td:not(.fc-axis)').each(function (i, obj) {
                                var td = $(this);
                                if ($(td).attr('data-index') == index) {
                                    //var uids = uid.split(",");
                                    $(td).find('a.fc-event').hide();
                                    $.each(uids, function (j, u) {
                                        $(td).find('a.eventRow' + u).show();
                                    });
                                    if (index != '')
                                        lastIndex = index;
                                }
                            });
                        }
                    }); 

                    //User Button
                    $('#user-container-' + colDate + ' .calendar-user').click(function () {
                        CalendarUserClickSource = 'PIC';
                        //Show only clicked user's events
                        var index = $(this).parent().parent('td').attr('data-index');
                        if (index != lastIndex && lastIndex != '') {
                            //Clear selected users from other day
                            uid = '';
                        }

                        if (uid != undefined) {
                            uid = uid + ',' + $(this).attr('data-uid');
                        }
                        else {
                            uid = $(this).attr('data-uid');
                        }
                                                
                        if (index != undefined && uid != undefined) {
                            $('.fc-scroller').find('.fc-content-skeleton').find('td:not(.fc-axis)').each(function (i, obj) { 
                                var td = $(this);
                                if ($(td).attr('data-index') == index) {                                    
                                    var uids = uid.split(",");
                                    $(td).find('a.fc-event').fadeOut(200);
                                    $.each(uids, function (j, u) {
                                        $(td).find('a.eventRow' + u).fadeIn(200);
                                    });
                                    if (index != '')
                                        lastIndex = index;
                                }
                            });
                        }

                        //alert(uid);
                        //--setCalendarFilterData(uid);
                        //ShowCalendarTasks();
                        //--$('#calendar').fullCalendar('refetchEvents');
                        //$('#user-container-' + colDate + ' .calendar-user').removeClass('calendar-users-image-border');
                        $(this).addClass('calendar-users-image-border');
                    });
                }
                else {
                    $(sender).html('');
                }
            });
        });
    }

    $scope.onTopEnd = function () {
        $timeout(function () {
            setFirstRowAutoData();
            SetSeqApprovalUI();
            SetChosenAssignedUser();

            var flag = false;
            //Show only first assigned user, rest on mouseover
            $('#tblStaffSeq .chosen-container').each(function (i, obj) {
                //Hide User Selection
                $(obj).find('li:not(:first):not(:last)').css({ "display": "none" });

                //Add class to li                
                $(obj).addClass('popover__wrapper');
                //$(obj).find('li:not(:first)').addClass('popover__wrapper');
            });

            //Build Hyperlinks ddcbSeqAssignedStaff
            $('#taskSequence .chosen-container .search-choice').each(function (i, obj) {
                var itemIndex = $(this).children('.search-choice-close').attr('data-option-array-index');
                if (itemIndex) {
                    //console.log($(this).parent('.chosen-choices').parent('.chosen-container'));
                    var id = $(this).parent('.chosen-choices').parent('.chosen-container').attr('id');
                    if (id != undefined) {
                        var selectoptionid = '#' + id.replace("_chosen", "") + ' option';
                        var chspan = $(this).children('span');
                        var text = chspan.text();
                        var name = text.split(' - ')[0] + ' - ';
                        var code = text.split(' - ')[1];
                        var className = $(selectoptionid)[itemIndex] != undefined ? $(selectoptionid)[itemIndex].classList[0] : '';
                        name = '<span class="' + className + '">' + name + '</span>';
                        if (chspan && code != undefined) {
                            if ($(selectoptionid)[itemIndex] != null || $(selectoptionid)[itemIndex] != undefined)
                                chspan.html(name + '<a style="color:blue;" href="/Sr_App/ViewSalesUser.aspx?id=' + $(selectoptionid)[itemIndex].value + '">' + code + '</a>');
                            else
                                chspan.html(name + '<a style="color:blue;">' + code + '</a>');
                            chspan.bind("click", "a", function () {
                                window.open($(this).children("a").attr("href"), "_blank", "", false);
                            });
                        }
                    }
                }
            });

            //Set MouseHover Popup
            $('.chosen-choices').mouseenter(function () {
                var parent = $(this).parent().parent().attr('class');
                if (parent != undefined && parent.indexOf('chosen-div') >= 0) {
                    if ($(this).find('li').length > 1) {

                        $('#popoverCloseButton').click(function () {
                            $('.popover__content').fadeOut(200);
                        });
                        $('.popover__content').mouseleave(function () {
                            $('.popover__content').hide();
                        });

                        //Show Popover
                        var parentOffset = $(this).parent().offset();
                        var relX = parentOffset.left;
                        var relY = parentOffset.top + 40;

                        $('.popover__content').css({ "left": relX });
                        $('.popover__content').css({ "top": relY });
                        $('.popover__content').fadeIn(200);


                        var data = $(this).html();
                        data = data.replace('type="text"', 'type="hidden"');
                        //console.log(data);
                        $('.popover__content div:not(:first)').html(data.replace(/none/gi, 'block'));
                    }
                    //$(this).find('li:not(:first)').css({ "display": "block" });
                }
            });

            //Reload Notes
            $timeout(function () {                
                ReLoadNotes();
            }, 1);
        }, 1);
    };

    $scope.onStaffEnd = function () {
        $timeout(function () {
            setFirstRowAutoData();
            SetSeqApprovalUI();
            SetChosenAssignedUser();

            var flag = false;
            //Show only first assigned user, rest on mouseover
            $('#tblStaffSeq .chosen-container').each(function (i, obj) {
                //Hide User Selection
                $(obj).find('li:not(:first):not(:last)').css({ "display": "none" });

                //Add class to li                
                $(obj).addClass('popover__wrapper');
                //$(obj).find('li:not(:first)').addClass('popover__wrapper');
            });         

             //Build Hyperlinks ddcbSeqAssignedStaff
            $('#taskSequence .chosen-container .search-choice').each(function (i, obj) {
                var itemIndex = $(this).children('.search-choice-close').attr('data-option-array-index');
                if (itemIndex) {
                    //console.log($(this).parent('.chosen-choices').parent('.chosen-container'));
                    var id = $(this).parent('.chosen-choices').parent('.chosen-container').attr('id');
                    if (id != undefined) {
                        var selectoptionid = '#' + id.replace("_chosen", "") + ' option';
                        var chspan = $(this).children('span');
                        var text = chspan.text();
                        var name = text.split(' - ')[0] + ' - ';
                        var code = text.split(' - ')[1];
                        var className = $(selectoptionid)[itemIndex] != undefined ? $(selectoptionid)[itemIndex].classList[0] : '';
                        name = '<span class="' + className + '">' + name + '</span>';
                        if (chspan && code != undefined) {
                            if ($(selectoptionid)[itemIndex] != null || $(selectoptionid)[itemIndex] != undefined)
                                chspan.html(name + '<a style="color:blue;" href="/Sr_App/ViewSalesUser.aspx?id=' + $(selectoptionid)[itemIndex].value + '">' + code + '</a>');
                            else
                                chspan.html(name + '<a style="color:blue;">' + code + '</a>');
                            chspan.bind("click", "a", function () {
                                window.open($(this).children("a").attr("href"), "_blank", "", false);
                            });
                        }
                    }
                    
                }
            });

            //Set MouseHover Popup
            $('.chosen-choices').mouseenter(function () {
                var parent = $(this).parent().parent().attr('class');
                if (parent != undefined && parent.indexOf('chosen-div') >= 0) {
                    if ($(this).find('li').length > 1) {

                        $('#popoverCloseButton').click(function () {
                            $('.popover__content').fadeOut(200);
                        });
                        $('.popover__content').mouseleave(function () {
                            $('.popover__content').hide();
                        });

                        //Show Popover
                        var parentOffset = $(this).parent().offset();
                        var relX = parentOffset.left;
                        var relY = parentOffset.top + 40;

                        $('.popover__content').css({ "left": relX });
                        $('.popover__content').css({ "top": relY });
                        $('.popover__content').fadeIn(200);


                        var data = $(this).html();
                        data = data.replace('type="text"', 'type="hidden"');
                        //console.log(data);
                        $('.popover__content div:not(:first)').html(data.replace(/none/gi, 'block'));
                    }
                    //$(this).find('li:not(:first)').css({ "display": "block" });
                }
            });
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

    $scope.onTaskExpand = function (TaskId) {        
        var totalItems = 0;
        var lastRow;
        $timeout(function () {
            $('#romanList_' + TaskId + ' div.parent').each(function (i, item) {
                if (i == 4) {
                    lastRow = item;
                }
                if (i > 4) {
                    $(item).hide();
                }
                totalItems = i + 1;
                //Add/Remove Plus icon
                var ChildrenExists = false;
                $(item).next('.child').each(function (i, item) {
                    ChildrenExists = true;
                });
                if (ChildrenExists) {
                    $(item).find('.expand-image').attr('src', "../../img/btn_maximize.png");
                }
                else {
                    $(item).find('.expand-image').hide();
                } 
            });
            if (totalItems > 5) {                
                //Insert ViewAll button
                $('#romanList_' + TaskId).append('<div class="ecBtn" onClick="viewAllParent(this,' + TaskId + ')" style="position: absolute;left: 358px;margin-top: -33px;text-decoration: underline;background-color: brown;color: #fff;padding: 5px 8px 5px 8px;border-radius: 11px;cursor: pointer;">View All Parent</div>');
                //$(lastRow).find('.roman-col-title-content').append('<br/><br/><br/><div onClick="viewAllParent(this,' + TaskId + ')" style="margin-top:25px;float: right;text-decoration: underline;background-color: brown;color: #fff;padding: 5px 8px 5px 8px;border-radius: 11px;cursor: pointer;">View All</div>');
            }            
            $timeout(function () {
                //$('.ddlAssignedUsersRomans').chosen();
                SetChosenAssignedUserRoman();               
            }, 2);
            
        }, 1);
    }

    $scope.expandTask = function (TaskId) {
        $('#LoadingRomansDiv' + TaskId).show();
        callWebServiceMethod($http, "GetMultiLevelList", { ParentTaskId: TaskId, chatSourceId: 2 }).then(function (data) {
            $('#LoadingRomansDiv' + TaskId).hide();
            var resultArray = JSON.parse(data.data.d);
            var results = resultArray.Results;
            $scope.Romans = $scope.Romans.concat($scope.correctDataforAngular(results));
            if ($scope.Romans.length < 1) {                
                $('#LoadingRomans' + TaskId).html('No data found.');
                $('#LoadingRomansDiv' + TaskId).show(500);
            }            
        });
    }

    $scope.expandIntPopupTask = function (TaskId) {
        $('#LoadingRomansDiv').show();
        callWebServiceMethod($http, "GetMultiLevelList", { ParentTaskId: TaskId, chatSourceId: 2 }).then(function (data) {
            $('#LoadingRomansDiv').hide();
            var resultArray = JSON.parse(data.data.d);
            var results = resultArray.Results;
            $scope.IntPopRomans = $scope.IntPopRomans.concat($scope.correctDataforAngular(results));
            if ($scope.IntPopRomans.length < 1) {
                $('#LoadingRomans').html('No data found.');
                $('#LoadingRomansDiv').show(500);
            }
        });
    }

    $scope.getTasks = function (page) {
        $scope.ForInProgress = true;
        if (sequenceScope.UserStatus == undefined)
            sequenceScope.UserStatus = 0;
        if (sequenceScope.StartDate == undefined)
            sequenceScope.StartDate = "";
        if (sequenceScope.EndDate == undefined)
            sequenceScope.EndDate = "";

        //if (!$scope.IsTechTask) {
        //console.log("Url: " + url);
        console.log("Fetching Top Grid Tasks....");
        $scope.loader.loading = true;
        $scope.page = page || 0;

        // make it blank so TechTask grid don't bind.
        $scope.TechTasks = [];

        //debugger;
        //get all Customers
        getTasksWithSearchandPagingM($http, "GetAllTasksWithPaging", { page: $scope.page, pageSize: $scope.pageSize, DesignationIDs: $scope.UserSelectedDesigIds!=''?$scope.UserSelectedDesigIds.join():'', IsTechTask: false, HighlightedTaskID: $scope.HighLightTaskId, UserId: $scope.UserId, ForDashboard: $scope.ForDashboard, TaskUserStatus: $scope.UserStatus, StartDate: $scope.StartDate, EndDate: $scope.EndDate, ForInProgress: $scope.ForInProgress }).then(function (data) {
            //console.log(data);
            //debugger;
            $scope.loader.loading = false;
            $scope.IsTechTask = false;
            $scope.DesignationSelectModel = [];
            var resultArray = JSON.parse(data.data.d);
            var results = resultArray.TasksData;
            //console.log(results);
            $scope.page = results.RecordCount.PageIndex;
            $scope.TotalRecords = results.RecordCount.TotalRecords;
            $scope.pagesCount = results.RecordCount.TotalPages;
            $scope.Tasks = $scope.correctDataforAngular(results.Tasks);

            if ($scope.Tasks != null)
                $scope.TaskSelected = $scope.Tasks[0];

            if ($scope.TotalRecords > 0) {
                $('#noDataIA').hide();
                $scope.pageFrom = ($scope.page * $scope.pageSize) + 1;
                if ($scope.TotalRecords <= $scope.pageSize) {
                    $scope.pageTo = $scope.TotalRecords;
                }
                else {
                    $scope.pageTo = ($scope.page + 1) * $scope.pageSize;
                }
                $scope.pageOf = $scope.TotalRecords;
            }
            else {
                $scope.pageFrom = $scope.pageOf = $scope.pageTo = 0;
                $('#noDataIA').fadeIn(1000);
            }
        });
    };

    $scope.getTechTasks = function (page) {

        if (sequenceScope.UserStatus == undefined)
            sequenceScope.UserStatus = 0;
        if (sequenceScope.StartDate == undefined)
            sequenceScope.StartDate = "";
        if (sequenceScope.EndDate == undefined)
            sequenceScope.EndDate = "";

        if ($scope.IsTechTask) {
            //console.log("Tech Task called....");
            $scope.loader.loading = true;
            $scope.Techpage = page || 0

            // make it blank so StaffTask grid don't bind.
            $scope.Tasks = [];


            //get all Customers
            getTasksWithSearchandPagingM($http, "GetAllTasksWithPaging", { page: $scope.Techpage, pageSize: 20, DesignationIDs: $scope.UserSelectedDesigIds != '' ? $scope.UserSelectedDesigIds.join() : '', IsTechTask: true, HighlightedTaskID: $scope.HighLightTaskId, UserId: $scope.UserId, ForDashboard: $scope.ForDashboard, TaskUserStatus: $scope.UserStatus, StartDate: $scope.StartDate, EndDate: $scope.EndDate, ForInProgress: $scope.ForInProgress }).then(function (data) {
                $scope.loader.loading = false;
                $scope.IsTechTask = true;
                $scope.DesignationSelectModel = [];
                var resultArray = JSON.parse(data.data.d);
                var results = resultArray.TasksData;
                //console.log("type of tasks is");
                //console.log(typeof results.Tasks);
                //console.log(results.Tasks);
                $scope.Techpage = results.RecordCount.PageIndex;
                $scope.TechTotalRecords = results.RecordCount.TotalRecords;
                $scope.TechpagesCount = results.RecordCount.TotalPages;
                $scope.TechTasks = $scope.correctDataforAngular(results.Tasks);
                //console.log($scope.TechTasks);
                //$scope.TaskSelected = $scope.TechTasks[0];

            });

        }
    };

    $scope.getClosedTasks = function (page) {
        $scope.ForInProgress = false;
        if (sequenceScope.UserStatus == undefined)
            sequenceScope.UserStatus = 0;
        if (sequenceScope.StartDate == undefined)
            sequenceScope.StartDate = "";
        if (sequenceScope.EndDate == undefined)
            sequenceScope.EndDate = "";

        console.log("Fetching Bottom Grid Tasks....");
        $scope.loaderClosedTask.loading = true;
        $scope.pageCT = page || 0;

        // make it blank so TechTask grid don't bind.
        $scope.TechTasks = [];

        //debugger;
        //get all Customers
        getTasksWithSearchandPagingM($http, "GetAllTasksWithPaging", { page: $scope.pageCT, pageSize: $scope.pageSize, DesignationIDs: $scope.UserSelectedDesigIds != '' ? $scope.UserSelectedDesigIds.join() : '', IsTechTask: false, HighlightedTaskID: $scope.HighLightTaskId, UserId: $scope.UserId, ForDashboard: $scope.ForDashboard, TaskUserStatus: $scope.UserStatus, StartDate: $scope.StartDate, EndDate: $scope.EndDate, ForInProgress: $scope.ForInProgress }).then(function (data) {
            //console.log(data);
            //debugger;
            $scope.loaderClosedTask.loading = false;
            $scope.IsTechTask = false;
            $scope.DesignationSelectModel = [];
            var resultArray = JSON.parse(data.data.d);
            var results = resultArray.TasksData;
            //console.log(results);
            $scope.pageCT = results.RecordCount.PageIndex;
            $scope.TotalRecordsCT = results.RecordCount.TotalRecords;
            $scope.pagesCountCT = results.RecordCount.TotalPages;

            if (results.Hours != undefined && results.Hours != null) {
                $scope.TotalHoursITLead = results.Hours.TotalITLeadHours;
                $scope.TotalHoursUsers = results.Hours.TotalUserHours;
            }
            $scope.ClosedTask = $scope.correctDataforAngular(results.Tasks);

            if ($scope.ClosedTask != null)
                $scope.TaskSelected = $scope.ClosedTask[0];

            if ($scope.TotalRecordsCT > 0) {
                $('#noDataCT').hide();
                $scope.pageFromCT = ($scope.pageCT * $scope.pageSize) + 1;
                if ($scope.TotalRecordsCT <= $scope.pageSize) {
                    $scope.pageToCT = $scope.TotalRecordsCT;
                }
                else {
                    $scope.pageToCT = ($scope.pageCT + 1) * $scope.pageSize;
                }
                $scope.pageOfCT = $scope.TotalRecordsCT;
            }
            else {
                $scope.pageFromCT = $scope.pageOfCT = $scope.pageToCT = 0;
                $('#noDataCT').fadeIn(1000);
            }
        });
    };

    $scope.getTechTasks = function (page) {

        if (sequenceScope.UserStatus == undefined)
            sequenceScope.UserStatus = 0;
        if (sequenceScope.StartDate == undefined)
            sequenceScope.StartDate = "";
        if (sequenceScope.EndDate == undefined)
            sequenceScope.EndDate = "";

        if ($scope.IsTechTask) {
            //console.log("Tech Task called....");
            $scope.loader.loading = true;
            $scope.Techpage = page || 0

            // make it blank so StaffTask grid don't bind.
            $scope.Tasks = [];


            //get all Customers
            getTasksWithSearchandPagingM($http, "GetAllTasksWithPaging", { page: $scope.Techpage, pageSize: 20, DesignationIDs: $scope.UserSelectedDesigIds != '' ? $scope.UserSelectedDesigIds.join() : '', IsTechTask: true, HighlightedTaskID: $scope.HighLightTaskId, UserId: $scope.UserId, ForDashboard: $scope.ForDashboard, TaskUserStatus: $scope.UserStatus, StartDate: $scope.StartDate, EndDate: $scope.EndDate, ForInProgress: $scope.ForInProgress }).then(function (data) {
                $scope.loader.loading = false;
                $scope.IsTechTask = true;
                $scope.DesignationSelectModel = [];
                var resultArray = JSON.parse(data.data.d);
                var results = resultArray.TasksData;
                //console.log("type of tasks is");
                //console.log(typeof results.Tasks);
                //console.log(results.Tasks);
                $scope.Techpage = results.RecordCount.PageIndex;
                $scope.TechTotalRecords = results.RecordCount.TotalRecords;
                $scope.TechpagesCount = results.RecordCount.TotalPages;
                $scope.TechTasks = $scope.correctDataforAngular(results.Tasks);
                //console.log($scope.TechTasks);
                //$scope.TaskSelected = $scope.TechTasks[0];

            });

        }
    };

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

    $scope.getTasksForSubset = function (DesignationCode, TaskID) {
        $scope.loader.loading = true;


        //get all Customers		
        getTasksForSubSequencing($http, "GetAllTasksforSubSequencing", { DesignationId: $scope.UserSelectedDesigIds.join(), DesiSeqCode: DesignationCode, IsTechTask: false, TaskId: TaskID }).then(function (data) {
            console.log(data);
            $scope.loader.loading = false;
            var resultArray = JSON.parse(data.data.d);

            var results = resultArray.Tasks;
            console.log(results);
            $scope.SeqSubsets = results;

            //console.log('Counting Data...');		
            //console.log(results.RecordCount.PageIndex);		
            //console.log(results.RecordCount.TotalRecords);		
            //console.log(results.RecordCount.TotalPages);		
        });
    };


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

    $scope.getAssignUsers = function () {
        //debugger;

        getDesignationAssignUsers($http, "GetAssignUsers", { TaskDesignations: $scope.UserSelectedDesigIds != '' ? $scope.UserSelectedDesigIds.join() : '' }).then(function (data) {

            var AssignedUsers = JSON.parse(data.data.d);

            ///console.log(AssignedUsers);
            //
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
        $scope.UserSelectedDesigIds = [];
        $scope.UserSelectedDesigIds.push(value);
        //if (isRemove) {
        //    $scope.UserSelectedDesigIds.pop(value);
        //}
        //else { // if element is to be added
        //    if ($scope.UserSelectedDesigIds.indexOf(value) === -1) {//check if value is not already added then only add it.
        //        $scope.UserSelectedDesigIds.push(value);
        //    }
        //}
        if (isReload) {
            if ($scope.IsTechTask) {
                console.log("called $scope.SetDesignForSearch");
                $scope.getTechTasks();
            }
            else {
                $scope.getTasks();
            }
        }

    };

    $scope.refreshTasks = function () {
        console.log("called $scope.refreshTasks");
        if ($scope.IsTechTask) {
            $scope.getTechTasks();
        }
        else {
            $scope.getTasks();
            $scope.getClosedTasks();
        }
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

    $scope.getDesignationsModel = function (SeqDesign) {

        var DesignModel;

        //console.log(SeqDesign);

        if (!angular.isUndefinedOrNull(SeqDesign)) {
            DesignModel = $scope.ParentTaskDesignations.filter(function (obj) {
                return obj.Id === SeqDesign.toString();
            })[0];
        }
        else {

            DesignModel = $scope.ParentTaskDesignations.filter(function (obj) {
                return obj.Id === $(ddlDesigSeqClientID).val();
            })[0];
        }

        //if (!DesignModel) {
        //    DesignModel = { 'Name': $(ddlDesigSeqClientID).text(), 'Id': $(ddlDesigSeqClientID).val() };
        //}

        // console.log("Assigning designation model value is.....");

        // console.log(DesignModel);

        return DesignModel;

    };

    $scope.designationChanged = function () {
    };

    $scope.getSequenceDisplayText = function (strSequence, strDesigntionID, seqSuffix) {
        //console.log(strSequence + strDesigntionID + seqSuffix);
        var sequenceText = "#SEQ#-#DESGPREFIX#:#TORS#";
        sequenceText = sequenceText.replace("#SEQ#", strSequence).replace("#DESGPREFIX#", $scope.GetInstallIDPrefixFromDesignationIDinJS(parseInt(strDesigntionID))).replace("#TORS#", seqSuffix);
        return sequenceText;
    };

    $scope.getSequenceDisplayText_ = function (strSequence, strDesigntionID, seqSuffix) {
        var sequenceText = "#SEQ#-#DESGPREFIX#:#TORS#";

        if (strSequence == "N.A.") {
            sequenceText = strSequence;
        }
        else {
            //console.log(strSequence + strDesigntionID + seqSuffix);            
            sequenceText = sequenceText.replace("#SEQ#", strSequence).replace("#DESGPREFIX#", $scope.GetInstallIDPrefixFromDesignationIDinJS(parseInt(strDesigntionID))).replace("#TORS#", seqSuffix);
        }
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
            case 22:
                prefix = "ADS";
                break;
            case 23:
                prefix = "ADR";
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
            case 27:
                prefix = "ITSSE";
                break;
            case 28:
                prefix = "ITSTE";
                break;
            case 29:
                prefix = "ITFRXD";
                break;
            case 1028:
                prefix = "ITMN";
                break;
            case 1029:
                prefix = "ITMPH";
                break;
            case 1030:
                prefix = "ITMSE";
                break;
            case 1031:
                prefix = "ITJBA";
                break;
            case 1032:
                prefix = "ITSBA";
                break;
            case 1033:
                prefix = "ITMXD     ";
                break;
            default:
                prefix = "N.A.";
                break;
        }

        return prefix;
    };

    $scope.trustedHtml = function (plainText) {
        return $sce.trustAsHtml(plainText);
    }

    $scope.StringIsNullOrEmpty = function (value) {

        //var returnVal = (angular.isUndefined(value) || value === null || value)
        var returnVal = !value;
        return returnVal;
    };

 //   initializeOnAjaxUpdate($scope, $compile, $http, $timeout, $filter);

    sequenceScope = $scope;

}

function getFilesByDesignation($scope, $http, locationId, designationId) {
    callWebServiceMethod($http, "GetFilesByDesignationId", { locationId: locationId, DesignationId: designationId })
        .then(function (data) {
            var resourceTypes = getResponse(data);
            if (resourceTypes.length > 0) {
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
                    $('#def-intro').attr("src", filepath);
                    $('#def-intro').attr("autoplay", "autoplay");
                    $('#def-intro')[0].play();
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
            }
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

function initializeOnAjaxUpdate(scope, compile, http, timeout, filter) {


    Sys.WebForms.PageRequestManager.getInstance().add_endRequest(function () {
        var elem = angular.element(document.getElementById("divTaskNG"));
        compile(elem.children())(scope);
        scope.$apply();

        applyFunctions(scope, compile, http, timeout, filter);
    });

    //Sys.WebForms.PageRequestManager.getInstance().add_endRequest(function (sender, args) {
    //    var elem = angular.element(document.getElementById("divTaskNG"));

    //    elem.replaceWith(compile(elem)(scope));
    //    scope.$apply();

    //    console.log(scope);

    //    applyFunctions(scope, compile, http);

    //});
}


app.controller('AddNewTaskSequenceController', function PostsController($scope, taskSequenceFactory) {
    $scope.Tasks = [];
    $scope.getTasks = function () {
        $scope.loading = true;

        //get all Customers
        taskSequenceFactory.getTasksWithSequence("GetAllTaskWithSequence").then(function (data) {
            $scope.Tasks = data.data;
            $scope.TaskSelected = $scope.Tasks[0];
            $scope.loading = false;
        });

    };

});
var CalendarData;
var CalendarUserClickSource;
var lastIndex = '';