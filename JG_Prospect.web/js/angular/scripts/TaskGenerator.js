app.controller('TaskGeneratorController', function ($scope, $compile, $http, $timeout, $filter) {
    _applyFunctions($scope, $compile, $http, $timeout, $filter);
});
app.filter('trustAsHtml', function ($sce) { return $sce.trustAsHtml; });

function callWebServiceMethod($http, methodName, filters) {
    return $http.post(url + methodName, filters);
};

function _applyFunctions($scope, $compile, $http, $timeout, $filter) {
    $scope.UsersByDesignation = [];
    $scope.UserSelectedDesigIds = [];
    $scope.DesignationAssignUsers = [];
    $scope.Users = [];
    $scope.SelectedUserId = 0;
    $scope.RootTasks = [];
    $scope.ChildTasks = [];
    $scope.SubTasks = [];
    $scope.TaskFiles = [];
    $scope.pageSize = 5;
    $scope.page = 0;
    $scope.pagesCount = 0;
    $scope.TotalRecords = 0;
    $scope.NextInstallId = "";
    $scope.MultiLevelChildren = [];
    $scope.NewTaskMultiLevelChildren = [];
    $scope.CurrentLevel = 1;
    $scope.NewTaskId = 0;
    var ParentIds = [];

    //var isadded = false;

    $scope.loader = {
        loading: false,
    };

    $scope.getFileData = function (fileName, targetEditor) {
        callWebServiceMethod($http, "GetTaskUserFileByFileName", { FileName: fileName }).then(function (data) {
            FileData = JSON.parse(data.data.d);
            var imgHtml = '<div class="attachmentImageDiv"><a class="image-link" href="/TaskAttachments/' + fileName + '"><img width="100px" src="/TaskAttachments/' + fileName + '" ></a>';
            var date = $filter('date')(new Date(FileData.FileData.File.AttachDate), 'MM/dd/yyyy hh:mm a') + '</span>(EST)</p>';
            date = date.replace(' ', '&nbsp;<span style="color:red">');
            var ulHtml = '<b>' +
                '<p><a class="image-link" href="/TaskAttachments/' + fileName + '">' + FileData.FileData.File.FileName.split('.')[0] + '</a></p>' +
                '<p>' + date +
                '<p>' + FileData.FileData.File.UserName + '</p></b></div>';
            targetEditor.insertHtml(imgHtml + ulHtml);
        });
    }

    $scope.getUserByDesignation = function () {
        callWebServiceMethod($http, "GetAssignUsers", { TaskDesignations: sequenceScopeTG.UserSelectedDesigIds != "" ? sequenceScopeTG.UserSelectedDesigIds.join() : sequenceScopeTG.UserSelectedDesigIds }).then(function (data) {
            var AssignedUsers = JSON.parse(data.data.d);
            $scope.UsersByDesignation = AssignedUsers;
            $scope.SelectedUserId = $scope.UsersByDesignation[0].Id;
        });
    }

    $scope.getSubTasksPager = function (page) {

        ShowAjaxLoader();
        var TaskId = getUrlVars()["TaskId"];
        if (TaskId == undefined || TaskId == '')
            TaskId = 0;
        else
            TaskId = TaskId.replace('#/', '');

        if (page == undefined)
            page = $scope.page;
        else
            $scope.page = page;
        var skey = $('#hdnSearchKey').val();
        if (skey == undefined)
            skey = '';

        callWebServiceMethod($http, "GetSubTasks", { TaskId: TaskId, strSortExpression: "CreatedOn DESC", vsearch: skey, intPageIndex: page != undefined ? page : 0, intPageSize: sequenceScopeTG.pageSize, intHighlightTaskId: 0 }).then(function (data) {
            var resultArray = JSON.parse(data.data.d);
            var result = resultArray.TaskData;
            $scope.page = result.Pages.PageIndex;
            $scope.TotalRecords = result.RecordCount.TotalRecords;
            $scope.pagesCount = Math.ceil(result.RecordCount.TotalRecords / sequenceScopeTG.pageSize);
            $scope.TaskFiles = $scope.correctDataforAngular(result.TaskFiles);
            $scope.SubTasks = $scope.correctDataforAngular(result.Tasks);
            $scope.NextInstallId = result.Table4.LastSubTaskInstallId;
            var NextInstallId = result.Table4.LastSubTaskInstallId;
            $('#ContentPlaceHolder1_objucSubTasks_Admin_txtTaskListID').val(NextInstallId);
            HideAjaxLoader();
        });
    }

    $scope.getRootTasks = function (CurrentTaskId) {
        ShowShareMoveLoading('Getting Root Tasks...');
        callWebServiceMethod($http, "GetRootTasks", { ExcludedTaskId: CurrentTaskId}).then(function (data) {
            var resultArray = JSON.parse(data.data.d);
            var result = resultArray.TasksDataSet;
            $scope.RootTasks = $scope.correctDataforAngular(result.Tasks);        
            ShowShareMoveLoading('');
        });
    }

    $scope.onRootTasksEnd = function () {        
        setTimeout(function () {
            $('#ddlRootTasks').trigger('change');
            $('#ddlRootTasks').trigger('chosen:updated');
        }, 1000);


    }

    $scope.getChildTasks = function (ParentTaskId) {
        ShowShareMoveLoading('Getting Child Tasks...');
        callWebServiceMethod($http, "GetChildTasks", { ParentTaskId: ParentTaskId }).then(function (data) {
            var resultArray = JSON.parse(data.data.d);
            var result = resultArray.TasksDataSet;
            if (result != null && result != undefined) {
                $scope.ChildTasks = $scope.correctDataforAngular(result.Tasks);
            }
            else {
                $scope.ChildTasks = [];
            }
            ShowShareMoveLoading('');
        });
    }

    $scope.getSubTasks = function (page) {

        ShowAjaxLoader();
        var TaskId = getUrlVars()["TaskId"];
        if (TaskId == undefined || TaskId == '')
            TaskId = 0;
        else
            TaskId = TaskId.replace('#/', '');

        var HighLightedTaskId = getUrlVars()["hstid"];
        if (HighLightedTaskId == undefined || HighLightedTaskId == '')
            HighLightedTaskId = 0;
        else if (PreventScroll != 1)
            HighLightedTaskId = HighLightedTaskId.replace('#/', '');
        else
            HighLightedTaskId = 0;

        if (TaskId != 0)
            TaskId = TaskId.replace('#', '');
        if (HighLightedTaskId != 0)
            HighLightedTaskId = HighLightedTaskId.replace('#', '');

        if (page == undefined)
            page = $scope.page;
        else
            $scope.page = page;
        var skey = $('#hdnSearchKey').val();
        if (skey == undefined)
            skey = '';

        ParentTaskId = TaskId;
        TaskLvl = 1;
        callWebServiceMethod($http, "GetSubTasks", { TaskId: TaskId, strSortExpression: "CreatedOn DESC", vsearch: skey, intPageIndex: page != undefined ? page : 0, intPageSize: sequenceScopeTG.pageSize, intHighlightTaskId: HighLightedTaskId }).then(function (data) {
            var resultArray = JSON.parse(data.data.d);
            var result = resultArray.TaskData;

            $scope.page = result.Pages.PageIndex;
            $scope.TotalRecords = result.RecordCount.TotalRecords;
            $scope.pagesCount = Math.ceil(result.RecordCount.TotalRecords / sequenceScopeTG.pageSize);
            $scope.TaskFiles = $scope.correctDataforAngular(result.TaskFiles);
            $scope.SubTasks = $scope.correctDataforAngular(result.Tasks);
            $scope.NextInstallId = result.Table4 != undefined ? result.Table4.LastSubTaskInstallId : 'I';
            var NextInstallId = $scope.NextInstallId;
            $('#hdnNextInstallId').val(NextInstallId);
            $('#ContentPlaceHolder1_objucSubTasks_Admin_txtTaskListID').val(NextInstallId);
            HideAjaxLoader();            
        });
    }

    $scope.getMultilevelChildren = function () {
        callWebServiceMethod($http, "GetMultilevelChildren", { ParentTaskId: SavedTaskID }).then(function (data) {
            $scope.NewTaskId = SavedTaskID;
            var result = JSON.parse(data.data.d);
            if (result.ChildrenData == undefined || result.ChildrenData == null)
                $scope.NewTaskMultiLevelChildren = [];
            else
                $scope.NewTaskMultiLevelChildren = $scope.correctDataforAngular(result.ChildrenData.Children);
        });
    }

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

    $scope.getSequenceDisplayText = function (strSequence, strDesigntionID, seqSuffix) {
        //console.log(strSequence + strDesigntionID + seqSuffix);
        var sequenceText = "#SEQ#-#DESGPREFIX#:#TORS#";
        sequenceText = sequenceText.replace("#SEQ#", strSequence).replace("#DESGPREFIX#", $scope.GetInstallIDPrefixFromDesignationIDinJS(parseInt(strDesigntionID))).replace("#TORS#", seqSuffix);
        return sequenceText;
    };

    $scope.getAssignUser = function () {
        getDesignationAssignUsers($http, "GetAssignUsers", { TaskDesignations: $scope.UserSelectedDesigIds != "" ? $scope.UserSelectedDesigIds.join() : "" }).then(function (data) {
            try {
                var AssignedUsers = JSON.parse(data.data.d);
                $scope.DesignationAssignUsers = AssignedUsers;
                $scope.Users = AssignedUsers;
            } catch (Exp) {
            }
        });
    };

    $scope.onAssignEnd = function (object) {
        //$('.chosen-input').trigger('chosen:updated');

        //Set Assigned Users
        SetChosenAssignedUsers();
    }

    $scope.onURLEnd = function () {
        //For Url
        $(".UrlEdit").each(function (index) {
            // This section is available to admin only.

            $(this).bind("click", function () {
                if (!isadded) {
                    var tid = $(this).attr("data-taskid");
                    var titledetail = $(this).html();
                    var fName = $("<input id=\"txtedittitle\" type=\"text\" value=\"" + titledetail + "\" class=\"editedTitle\" />");
                    $(this).html(fName);
                    $('#txtedittitle').focus();

                    isadded = true;
                }
                return false;
            }).bind('focusout', function () {
                var tid = $(this).attr("data-taskid");
                var tdetail = $('#txtedittitle').val();
                if (tdetail != undefined) {
                    var url = "";
                    $("#TaskContainer" + tid + " .UrlEdit").each(function () {
                        if ($(this).children().is('input:text')) {
                            url += $(this).children('input:text').val() + ";";
                        }
                        else {
                            url += $(this).html() + ";";
                        }
                    });
                    url = url.slice(0, -1);

                    $(this).html(tdetail);
                    EditUrl(tid, url);
                    isadded = false;
                }
                return false;
            });
        });
    }

    $scope.onAttachmentEnd = function (object) {
        LoadImageGallery('#lightSlider_' + object);
    }

    $scope.onEnd = function (obj) {
                
        //Initialize Chosens
        $('.chosen-input').chosen();

        //Set Approval Dialog
        $('.approvalBoxes').each(function () {
            var approvaldialog = $($(this).next('.approvepopup'));
            approvaldialog.dialog({
                width: 400,
                show: 'slide',
                hide: 'slide',
                autoOpen: false
            });

            $(this).click(function () {
                approvaldialog.dialog('open');
            });
        });        

        ApplySubtaskLinkContextMenu();

        $timeout(function () {
            $('a[data-id="hypViewInitialComments"]').click();

            //Add Subtask Button
            $(".showsubtaskDIV").each(function (index) {
                // This section is available to admin only.

                $(this).bind("click", function () {
                    var commandName = $(this).attr("data-val-commandName");
                    var CommandArgument = $(this).attr("data-val-CommandArgument");
                    var TaskLevel = $(this).attr("data-val-taskLVL");
                    var strInstallId = $(this).attr('data-installid');
                    var parentTaskId = $(this).attr('data-parent-taskid');

                    //$("#ContentPlaceHolder1_objucSubTasks_Admin_divAddSubTask").hide();
                    //$("#ContentPlaceHolder1_objucSubTasks_Admin_pnlCalendar").hide();

                    var objAddSubTask = null;
                    if (TaskLevel == "1") {
                        //objAddSubTask = $("#ContentPlaceHolder1_objucSubTasks_Admin_divAddSubTask");
                        //shownewsubtask();
                        maintask = false;
                    }
                    else if (TaskLevel == "2") {
                        //objAddSubTask = $("#ContentPlaceHolder1_objucSubTasks_Admin_pnlCalendar");

                        //var $tr = $('<tr><td colspan="4"></td></tr>');
                        //$tr.find('td').append(objAddSubTask);

                        //var $appendAfter = $('tr[data-parent-taskid="' + parentTaskId + '"]:last');
                        //if ($appendAfter.length == 0) {
                        //    $appendAfter = $('tr[data-taskid="' + parentTaskId + '"]:last');
                        //}
                        //$appendAfter.after($tr);
                    }

                    if (objAddSubTask != null) {
                        //objAddSubTask.show();
                        //ScrollTo(objAddSubTask);
                        //SetTaskDetailsForNew(CommandArgument, commandName, TaskLevel, strInstallId);
                    }
                    showAddNewTaskPopup();
                    SetupNewTaskData(CommandArgument, commandName, TaskLevel, strInstallId);
                    return false;
                });
            });

            
            ParentIds = [];
            $('.MainTask').each(function () {
                //Load Multilevel Children
                var id = $(this).attr('data-taskid');
                ParentIds.push(id);
                //ParentIds = ParentIds.substring(0, ParentIds.length - 1);
            });

            

        }, 1);

        $timeout(function () {
            $('.chosen-input').trigger('chosen:updated');
            $scope.LoadFeedbackPoints();
            //----------- start DP -----
            GridDropZone();
                //----------- end DP -----
        }, 2);


        //For Description
        if (IsAdminMode == 'True') {
            //For Title
            $(".TitleEdit").each(function (index) {
                // This section is available to admin only.

                $(this).bind("click", function () {
                    if (!isadded) {
                        var tid = $(this).attr("data-taskid");
                        var titledetail = $(this).html();
                        var fName = $("<input id=\"txtedittitle\" type=\"text\" value=\"" + titledetail + "\" class=\"editedTitle\" />");
                        $(this).html(fName);
                        $('#txtedittitle').focus();

                        isadded = true;
                    }
                }).bind('focusout', function () {
                    var tid = $(this).attr("data-taskid");
                    var tdetail = $('#txtedittitle').val();
                    $(this).html(tdetail);
                    EditTask(tid, tdetail)
                    isadded = false;
                });
            });            
            
            $(".DescEdit").each(function (index) {
                // This section is available to admin only.            
                $(this).bind("dblclick", function (object) {
                    if (!isadded && !isBtnSave) {
                        var tid = $(this).attr("data-taskid");
                        var titledetail = $(this).html();
                        var fName = $("<textarea id=\"txtedittitle\" style=\"width:100%;\" class=\"editedTitle\" rows=\"10\" >" + titledetail + "</textarea><input id=\"btnSave\" type=\"button\" value=\"Save\" />");
                        $(this).html(fName);
                        $('#ContentPlaceHolder1_objucSubTasks_Admin_hdDropZoneTaskId').val(tid);
                        SetCKEditorForSubTask('txtedittitle');
                        $('#txtedittitle').focus();
                        control = $(this);

                        isadded = true;
                        $('#btnSave').bind("click", function () {
                            isBtnSave = true;
                            clearInterval(TimerId);
                            console.log('interval removed: ' + TimerId);                            
                            updateDesc(GetCKEditorContent('txtedittitle'), false);
                            CKEDITOR.instances['txtedittitle'].destroy();
                        });

                        //Start timer for auto save
                        TimerId = setInterval(function () {
                            updateDesc(GetCKEditorContent('txtedittitle'), true);
                            console.log('auto saved desc');
                        }, 30000);
                        console.log('interval started: ' + TimerId);
                    }
                    return false;
                });
            });
        }

        //GridDropZone();
    };

    $scope.onRomansLoad = function (tid) {        
        //$timeout(function () {
        //    debugger;
        //    if (tid != undefined) {
        //        SetCKEditorForChildren('subtaskDesc' + tid);
        //    }
        //}, 4);
    }

    //Helper Functions
    $scope.LoadFeedbackPoints = function () {
        callWebServiceMethod($http, "GetMultilevelChildren", { ParentTaskId: ParentIds.join() }).then(function (data) {
            if (data.data.d != undefined && data.data.d != '' && data.data.d != null) {
                var result = JSON.parse(data.data.d);
                if (result.ChildrenData != null) {
                    $scope.MultiLevelChildren = $scope.correctDataforAngular(result.ChildrenData.Children);
                }
            }
            $timeout(function () {

                $('.ChildDescField').each(function (i, obj) {
                    var id = $(obj).attr('id');
                    SetCKEditorForRomanDesc(id);
                });

                //For Placeholder
                setTimeout(function () {
                    var placetext = '<i>*</i> <span style="color:darkgrey;font-style:italic">Description</span>';
                    $('div.cke_editable').html(placetext);
                    $('div.cke_editable').on('click focusin', function () {
                        var cid = $(this).prev('textarea').attr('id');
                        var c = GetCKEditorContent(cid).replace('<em>*</em> <em style="color:darkgrey; font-style:italic">Description</em>', '');

                        if (c.length == 0) {
                            $('textarea#' + cid).next('div.cke_editable').html('');
                        }                        
                    });
                    $('div.cke_editable').on('blur', function () {
                        var cid = $(this).prev('textarea').attr('id');
                        var c = GetCKEditorContent(cid);
                        if (c.length == 0) {
                            $('textarea#' + cid).next('div.cke_editable').html(placetext);
                        }                       
                    });
                }, 2000);

                //Add Blink Class
                var ChildId = getUrlVars()["mcid"];
                var hstid = getUrlVars()["hstid"];
                if (ChildId != undefined)
                    ChildId = ChildId.replace('#', '');
                if (hstid != undefined)
                    hstid = hstid.replace('#', '');

                if (ChildId != undefined) {
                    $('#ChildEdit' + ChildId).addClass('yellowthickborder');
                } else {
                    $('#datarow' + hstid).addClass('yellowthickborder');
                }

                //Apply Context Menu
                $(".context-menu-child").bind("contextmenu", function () {
                    var url = window.location.href;
                    url = url.split('&')[0];
                    var urltoCopy = url + '&hstid=' + $(this).attr('data-highlighter') + '&mcid=' + $(this).attr('data-childid');
                    //var urltoCopy = updateQueryStringParameterTP(window.location.href, "hstid", $(this).attr('data-highlighter'));
                    copyToClipboard(urltoCopy);
                    return false;
                });

                if (PreventScroll == 0) {
                    if (ChildId == undefined)
                        ScrollTo($('.yellowthickborder'));
                    else
                        ScrollToChild($('.yellowthickborder'), ChildId, hstid);
                }
                else
                    PreventScroll = 0;

                //set focus for next entry
                setTimeout(function () {
                    $('#txtRomanTitle' + CurrentTaskId).focus();
                }, 1000);

                $(".yellowthickborder").bind("click", function () {
                    $(this).removeClass("yellowthickborder");
                });
                if (IsAdminMode == 'True') {
                    $(".ChildEditTitle").each(function (index) {
                        // This section is available to admin only.

                        $(this).bind("dblclick", function () {
                            if (!isadded) {
                                var tid = $(this).attr("data-taskid");
                                var ptid = $(this).attr("data-parentid");
                                var titledetail = $(this).html();
                                var fName = $("<textarea id=\"txteditChild\" style=\"width:80%;\" class=\"editedTitle\" rows=\"1\" >" + titledetail + "</textarea><input id=\"btnSave\" type=\"button\" value=\"Save\" />");
                                $(this).html(fName);
                                $('#ContentPlaceHolder1_objucSubTasks_Admin_hdDropZoneTaskId').val(tid);
                                SetCKEditorForSubTask('txteditChild');
                                $('#txteditChild').focus();
                                control = $(this);

                                isadded = true;
                                $('#btnSave').bind("click", function () {
                                    var htmldata = GetCKEditorContent('txteditChild');
                                    ShowAjaxLoader();
                                    var postData = {
                                        RomanId: tid,
                                        Title: htmldata
                                    };

                                    $.ajax({
                                        url: '../../../WebServices/JGWebService.asmx/UpdateRomanTitle',
                                        contentType: 'application/json; charset=utf-8;',
                                        type: 'POST',
                                        dataType: 'json',
                                        data: JSON.stringify(postData),
                                        asynch: false,
                                        success: function (data) {
                                            CKEDITOR.instances['txteditChild'].destroy();
                                            alert('Title updated successfully.');
                                            HideAjaxLoader();
                                            $('#ChildEditTitle' + tid).html(htmldata);
                                            isadded = false;
                                        },
                                        error: function (a, b, c) {
                                            HideAjaxLoader();
                                        }
                                    });
                                    $(this).css({ 'display': "none" });
                                });
                                CurrentEditingTaskId = tid;
                                pid = ptid;
                            }
                            return false;
                        });
                    });
                    $(".ChildEdit").each(function (index) {
                        // This section is available to admin only.

                        $(this).bind("dblclick", function () {
                            if (!isadded) {
                                var tid = $(this).attr("data-taskid");
                                var ptid = $(this).attr("data-parentid");
                                var titledetail = $(this).html();
                                var fName = $("<textarea id=\"txteditChild\" style=\"width:80%;\" class=\"editedTitle\" rows=\"10\" >" + titledetail + "</textarea><input id=\"btnSave\" type=\"button\" value=\"Save\" />");
                                $(this).html(fName);
                                $('#ContentPlaceHolder1_objucSubTasks_Admin_hdDropZoneTaskId').val(tid);
                                SetCKEditorForSubTask('txteditChild');
                                $('#txteditChild').focus();
                                control = $(this);

                                isadded = true;
                                $('#btnSave').bind("click", function () {
                                    var htmldata = GetCKEditorContent('txteditChild');
                                    ShowAjaxLoader();
                                    var postData = {
                                        tid: tid,
                                        Description: htmldata
                                    };

                                    $.ajax({
                                        url: '../../../WebServices/JGWebService.asmx/UpdateTaskDescriptionChildById',
                                        contentType: 'application/json; charset=utf-8;',
                                        type: 'POST',
                                        dataType: 'json',
                                        data: JSON.stringify(postData),
                                        asynch: false,
                                        success: function (data) {
                                            CKEDITOR.instances['txteditChild'].destroy();
                                            alert('Description updated successfully.');
                                            HideAjaxLoader();
                                            $('#ChildEdit' + tid).html(htmldata);
                                            isadded = false;
                                        },
                                        error: function (a, b, c) {
                                            HideAjaxLoader();
                                        }
                                    });
                                    $(this).css({ 'display': "none" });
                                });
                                CurrentEditingTaskId = tid;
                                pid = ptid;
                            }
                            return false;
                        });
                    });
                }
                $('.image-link').magnificPopup({ type: 'image' });

                $('.image-link img').mouseover(function () {

                    if ($(this).attr('id') != 'imgIcon') {
                        //alert('click');
                        // Returns width of browser viewport
                        var width = $(window).width();

                        //Show Popover
                        var src = $(this).attr('src');
                        var h = $(this).attr('height');
                        var w = $(this).attr('width');

                        var parentOffset = $(this).parent().offset();

                        var relX = parentOffset.left;
                        var relY = parentOffset.top - 200;

                        if (relX >= (width / 2)) {
                            relX = parentOffset.left - 100;
                        }
                        else {
                            relX = parentOffset.left + 98;
                        }

                        $('.popover__content img').attr('height', 150);
                        $('.popover__content img').attr('src', src);
                        $('.popover__content').css({ "height": h });
                        $('.popover__content').css({ "width": w });
                        $('.popover__content').css({ "left": relX });
                        $('.popover__content').css({ "top": relY });
                        $('.popover__content').fadeIn(200);
                    }
                });

                $('.image-link img').mouseleave(function () {
                    //$('.popover__content img').attr('src', "");
                    $('.popover__content').fadeOut(200);
                });

                if (NewTaskSaved) {
                    SetCKEditorForChildren('subtaskDesc' + CurrentTaskId);
                    NewTaskSaved = false;
                }
            }, 1);
        });
    }
    $scope.trustedHtml = function (plainText) {
        return $sce.trustAsHtml(plainText);
    }

    $scope.LevelToRoman = function (levelChar, indent) {
        if (levelChar == '' || levelChar == undefined) {
            return "I";
        }
        else {
            if (indent == 1)
                return romanize(roman_to_Int(levelChar.toUpperCase()) + 1).toUpperCase();
            else if (indent == 2)
                return romanize(roman_to_Int(levelChar.toUpperCase()) + 1).toLowerCase();
            else if (indent == 3) {
                var s = idOf(((levelChar.charCodeAt(0) - 97) + 1));
                return s;
            }
            else
                return romanize(levelChar);
        }
    }
    
    //Create a Scope
    sequenceScopeTG = $scope;
}

function getUrlVars() {
    var vars = [], hash;
    var hashes = window.location.href.slice(window.location.href.indexOf('?') + 1).split('&');
    for (var i = 0; i < hashes.length; i++) {
        hash = hashes[i].split('=');
        vars.push(hash[0]);
        vars[hash[0]] = hash[1];
    }
    return vars;
}

function romanize(num) {
    var lookup = { M: 1000, CM: 900, D: 500, CD: 400, C: 100, XC: 90, L: 50, XL: 40, X: 10, IX: 9, V: 5, IV: 4, I: 1 }, roman = '', i;
    for (i in lookup) {
        while (num >= lookup[i]) {
            roman += i;
            num -= lookup[i];
        }
    }
    return roman;
}

function roman_to_Int(str1) {
    if (str1 == null) return -1;
    var num = char_to_int(str1.charAt(0));
    var pre, curr;

    for (var i = 1; i < str1.length; i++) {
        curr = char_to_int(str1.charAt(i));
        pre = char_to_int(str1.charAt(i - 1));
        if (curr <= pre) {
            num += curr;
        } else {
            num = num - pre * 2 + curr;
        }
    }

    return num;
}

function char_to_int(c) {
    switch (c) {
        case 'I': return 1;
        case 'V': return 5;
        case 'X': return 10;
        case 'L': return 50;
        case 'C': return 100;
        case 'D': return 500;
        case 'M': return 1000;
        default: return -1;
    }
}

function idOf(i) {
    return (i >= 26 ? idOf((i / 26 >> 0) - 1) : '') + 'abcdefghijklmnopqrstuvwxyz'[i % 26 >> 0];
}

function LetterToNumber(str) {
    var out = 0, len = str.length;
    for (pos = 0; pos < len; pos++) {
        out += (str.charCodeAt(pos) - 64) * Math.pow(26, len - pos - 1);
    }
    return out;
}

var CurrentEditingTaskId = 0;
var TimerId = 0;
var pid = 0;
var isBtnSave = false;
var UploadUserName = '', UploadFileName = '', UploadTime = '';
var RefreshData = false;
var FileData;
var NewTaskSaved = false;
var CurrentTaskId;

function showMedSizePopup() {
    alert('hi');
}