function LoadDesignationUsers(DesigIds) {
    if (DesigIds == 0 || DesigIds == undefined) {
        DesigIds = "";
    }

    //Set Params
    sequenceScopeTG.UserSelectedDesigIds = DesigIds;

    //Call Data Function
    sequenceScopeTG.getUserByDesignation();
}

function OnDeleteAttachment(sender) {
    if (confirm('Are you sure?') == true) {
        var aid = $(sender).attr('data-aid');
        CallJGWebService('DeleteTaskUserFile', { AttachmentId: aid }, OnDeleteSuccess, OnDeleteFailure);
        function OnDeleteSuccess(data) {
            if (data.d == true)
                LoadSubTasks();
        }
        function OnDeleteFailure(err) {
            alert('Can not delete attachment.');
        }
    }
}

function GetRootTasks() {
    sequenceScopeTG.getRootTasks(ParentTaskId);
    
}

function GetChildTasks(Sender) {
    sequenceScopeTG.getChildTasks($(Sender).val());
}

function ShowShareMoveLoading(text) {
    var obj = $('.modal-content').find('.status');
    if (obj != undefined) {
        if (text != '') {
            $(obj).html(text);
            $(obj).show(200);
        }
        else {
            $(obj).hide(200);
        }
    }

}

function LoadSubTasks() {
    
    //Set Params
    sequenceScopeTG.getAssignUser();
    sequenceScopeTG.UserSelectedDesigIds = "";

    //Get Page Size
    var pageSize = $('#drpPageSize').val();
    if (pageSize == undefined)
        pageSize = 5;
    sequenceScopeTG.pageSize = pageSize;

    $('.ui-dialog').remove();
    sequenceScopeTG.getSubTasks();
    sequenceScopeTG.getAssignUser();
}

function SetChosenAssignedUsers() {

    setTimeout(function () {
        $('*[data-chosen="1"]').each(function (index) {

            var dropdown = $(this);

            if (dropdown.attr("data-assignedusers")) {
                var users = dropdown.attr("data-assignedusers");

                if (users != undefined && users != null) {
                    try {
                        var assignedUsers = JSON.parse("[" + users + "]");
                        $.each(assignedUsers, function (Index, Item) {
                            dropdown.find("option[value='" + Item + "']").prop("selected", true);
                        });
                    }
                    catch (exp) {
                        //console.log(exp);
                    }
                }
            }

            $(this).chosen();
            $(this).trigger('chosen:updated');

            setSelectedUsersLink();
        });
    }, 2000);
}

function EditAssignedSubTaskUsers(sender) {

    var $sender = $(sender);
    var intTaskID = parseInt($sender.attr('data-taskid'));
    var intTaskStatus = parseInt($sender.attr('data-taskstatus'));
    var arrAssignedUsers = [];
    var arrDesignationUsers = [];
    var options = $sender.find('option');
    arrAssignedUsers = $(sender).val();
    //$.each(options, function (index, item) {

    //    var intUserId = parseInt($(item).attr('value'));

    //    /*Obsolete Code*/
    //    //if (intUserId > 0) {
    //    //    arrDesignationUsers.push(intUserId);
    //    //    //if ($.inArray(intUserId.toString(), $(sender).val()) != -1) {                
    //    //    //    arrAssignedUsers.push(intUserId);
    //    //    //}
    //    //    if ($(sender).val() == intUserId.toString()) {
    //    //        arrAssignedUsers.push(intUserId);
    //    //    }
    //    //}
    //    /*Obsolete Code*/


    //});

    SaveAssignedTaskUsers();


    function SaveAssignedTaskUsers() {
        ShowAjaxLoader();

        var postData = {
            intTaskId: intTaskID,
            intTaskStatus: intTaskStatus,
            arrAssignedUsers: arrAssignedUsers,
            arrDesignationUsers: arrDesignationUsers
        };

        CallJGWebService('SaveAssignedTaskUsers', postData, OnSaveAssignedTaskUsersSuccess, OnSaveAssignedTaskUsersError);

        function OnSaveAssignedTaskUsersSuccess(response) {
            HideAjaxLoader();
            if (response) {
                HideAjaxLoader();
                LoadSubTasks();
            }
            else {
                OnSaveAssignedTaskUsersError();
            }
        }

        function OnSaveAssignedTaskUsersError(err) {
            HideAjaxLoader();
            //alert(JSON.stringify(err));
            alert('Task assignment cannot be updated. Please try again.');
        }
    }
}

function updateMultiLevelChild(tid, desc, autosave) {
    if (desc != '' && desc != undefined) {
        if (autosave)
            ShowAutoSaveProgress(pid);
        else
            ShowAjaxLoader();

        var postData = {
            tid: tid,
            Description: desc
        };

        $.ajax({
            url: '../../../WebServices/JGWebService.asmx/UpdateTaskDescriptionChildById',
            contentType: 'application/json; charset=utf-8;',
            type: 'POST',
            dataType: 'json',
            data: JSON.stringify(postData),
            asynch: false,
            success: function (data) {                

                if (!autosave) {
                    $('#ChildEdit' + tid).html(desc);
                    isadded = false;
                    HideAjaxLoader();
                    alert('Updated Successfully.');
                }
                else {
                    HideAutoSaveProgress(pid);
                }
            },
            error: function (a, b, c) {
                HideAjaxLoader();
            }
        });
    }
}
function EditDesc(tid, tdetail, autosave) {

    if (autosave)
        ShowAutoSaveProgress(tid);
    else
        ShowAjaxLoader();


    var postData = {
        tid: tid,
        Description: tdetail
    };

    $.ajax
        (
        {
            url: '../WebServices/JGWebService.asmx/UpdateTaskDescriptionById',
            contentType: 'application/json; charset=utf-8;',
            type: 'POST',
            dataType: 'json',
            data: JSON.stringify(postData),
            asynch: false,
            success: function (data) {
                if (idAttachments != undefined && idAttachments) {
                    if (!autosave)
                        RefreshData = true;
                    else
                        RefreshData = false;

                    SaveAttchmentToDB();
                }
                else {
                    HideAjaxLoader();
                }

                if ($('#lblStatus').length > 0) {
                    $('#lblStatus').html('Changes saved successfully.');
                }

                //alert(autosave);
                if (autosave) {
                    HideAutoSaveProgress(tid);
                }
                else {
                    alert('Description saved successfully.');
                }
                isBtnSave = false;
            },
            error: function (a, b, c) {
                HideAjaxLoader();
            }
        }
        );
}
function OnSaveSubTaskPopup(taskid, desc) {

    var installID = $('#listId' + taskid).attr('data-listid');
    var TaskLvl = $('#nestLevel' + taskid).val();
    var Class = $('#listId' + taskid).attr('data-label');

    if (desc != undefined && desc.trim() != '') {

        ShowAjaxLoader();
        if (TaskLvl == '') TaskLvl = 1;

        var postData = {
            ParentTaskId: taskid,
            InstallId: installID,
            Description: desc,
            IndentLevel: TaskLvl,
            Class: Class,
            Title: 'No Title'
        };

        CallJGWebService('SaveTaskMultiLevelChild', postData, OnAddNewSubTaskSuccess, OnAddNewSubTaskError);

        function OnAddNewSubTaskSuccess(data) {
            if (data.d == true) {
                HideAjaxLoader();
                PreventScroll = 1;

                SetupChildInfo(taskid);
                //alert('Task saved successfully.');
            }            
        }

        function OnAddNewSubTaskError(err) {
            alert('Task cannot be saved. Please try again.');
        }

        
    }
    return false;

}
function changeTaskStatusRoman(Task) {
    var StatusId = Task.value;
    var TaskId = Task.getAttribute('data-highlighter');
    var data = { TaskId: TaskId, TaskStatus: StatusId };
    CallJGWebService('SetRomanTaskStatus', data,
        function (data) {
            alert("Roman Task Status Changed.");
        },
        function (err) {
            alert("Failed!!!");
        }
    );
}

function ShowFeedbackFreezePopup(sender) {
    FeedbackTaskId = $(sender).attr('data-taskid');
    $('#FeedbackPopup').find('.close').click(function () {
        $('#FeedbackPopup').fadeOut(200);
        $('#FeedbackPopup').find(':text').val('');
        $('#FeedbackPopup').find(':password').val('');
        $('#FeedbackPopup').find('#lblStatusFreeze').html('');

        //ITLead Reset
        $('#FeedbackPopup').find('#ITLeadFreezeHours').hide();
        $('#FeedbackPopup').find('#ITLeadFreezeData').hide();
        $('#FeedbackPopup').find('#txtEstHoursITLead').show();
        $('#FeedbackPopup').find('#ITLeadPasswordSection').show();
        //User Reset
        $('#FeedbackPopup').find('#UserFreezeHours').hide();
        $('#FeedbackPopup').find('#UserFreezeData').hide();
        $('#FeedbackPopup').find('#txtEstHoursUser').show();
        $('#FeedbackPopup').find('#UserPasswordSection').show();
    });
    $('#FeedbackPopup').find('#drpRomanTaskStatus').attr('data-highlighter', FeedbackTaskId);
    $('#FeedbackPopup').show();

    $('#FeedbackPopup').find('#lblStatusFreeze').html('Getting data...');

    CallJGWebService('GetFreezedRomanData', {
        RomanId: FeedbackTaskId
    },
        function (data) {
            if (data != undefined && data.d != undefined) {
                var Roman = JSON.parse(data.d).Roman[0];
                //ITLead
                if (Roman.EstimatedHoursITLead != null) {
                    $('#FeedbackPopup').find('#ITLeadFreezeHours').html('<b>' + Roman.EstimatedHoursITLead + '</b> Hour(s)');
                    $('#FeedbackPopup').find('#ITLeadFreezeData').html('<a target="_blank" href="/Sr_App/CreateSalesUser.aspx?id=' + Roman.ITLeadId + '" >' + Roman.ITLeadId + ' - ' + Roman.ITLeadName + '</a><br/>' +
                        new Date(Roman.DateUpdatedITLead).toLocaleDateString() + '<span style="color:Red"> ' + tConvert(Roman.DateUpdatedITLead.toString().split('T')[1].split('.')[0]) + '</span>');

                    $('#FeedbackPopup').find('#txtEstHoursITLead').hide();
                    $('#FeedbackPopup').find('#ITLeadPasswordSection').hide();
                    $('#FeedbackPopup').find('#ITLeadFreezeHours').show();
                    $('#FeedbackPopup').find('#ITLeadFreezeData').show();
                }
                if (Roman.EstimatedHoursUser != null) {
                    $('#FeedbackPopup').find('#UserFreezeHours').html('<b>' + Roman.EstimatedHoursUser + '</b> Hour(s)');
                    $('#FeedbackPopup').find('#UserFreezeData').html('<a target="_blank" href="/Sr_App/CreateSalesUser.aspx?id=' + Roman.UserId + '" > ' + Roman.UserId + ' - ' + Roman.UserName + '</a > <br />' +
                        new Date(Roman.DateUpdatedUser).toLocaleDateString() + '<span style="color:Red"> ' + tConvert(Roman.DateUpdatedUser.toString().split('T')[1].split('.')[0]) + '</span>');

                    $('#FeedbackPopup').find('#txtEstHoursUser').hide();
                    $('#FeedbackPopup').find('#UserPasswordSection').hide();
                    $('#FeedbackPopup').find('#UserFreezeHours').show();
                    $('#FeedbackPopup').find('#UserFreezeData').show();
                }
                if ($('#FeedbackPopup').find('#drpRomanTaskStatus').length > 0) {
                    $('#FeedbackPopup').find('#drpRomanTaskStatus').val(Roman.Status);
                }
            }           
            $('#FeedbackPopup').find('#lblStatusFreeze').html('');
        },
        function (err) {
            $('#FeedbackPopup').find('#lblStatusFreeze').html('Error');
        }
    );
}

function FreezeFeedback(sender) {
    var IsITLead = $(sender).attr('data-IsITLead');
    var EstimatedHours = IsITLead == 'true' ? $('#txtEstHoursITLead').val() : $('#txtEstHoursUser').val();
    var Password = $(sender).val();
    var StartDate = $('#ContentPlaceHolder1_txtDateFromRoman').val();
    var EndDate = $('#ContentPlaceHolder1_txtDateToRoman').val();

    if (EstimatedHours != '' && Password != '' && StartDate != '' && EndDate != '') {
        $('#lblStatusFreeze').html('Freezing Task...');
        CallJGWebService('FreezeFeedbackTask', {
            EstimatedHours: parseInt(EstimatedHours),
            Password: Password,
            StartDate: StartDate,
            EndDate: EndDate,
            TaskId: parseInt(FeedbackTaskId),
            IsITLead: IsITLead == 'true' ? true : false
        },
            function (data) {
                $('#lblStatusFreeze').html(data.d.Message);
            },
            function (err) {
                $('#lblStatusFreeze').html('Error : Can not freeze task');
            }
        );
    }
}
function OnSaveRoman(sender) {
    clearTimeout(timeoutId);
    var taskid = $(sender).attr('data-taskid');
    var installID = $('#listId' + taskid).attr('data-listid');
    var TaskLvl = $('#nestLevel' + taskid).val();
    var Class = $('#listId' + taskid).attr('data-label');
    var title = $('#txtRomanTitle' + taskid).val();
    var desc = GetCKEditorContent('subtaskDesc' + taskid);

    if (desc != undefined && desc.trim() != '' && title.trim()!='') {

        ShowAjaxLoader();
        if (TaskLvl == '') TaskLvl = 1;

        var postData = {
            ParentTaskId: taskid,
            InstallId: installID,
            Title: title,
            Description: desc,
            IndentLevel: TaskLvl,
            Class: Class
        };

        CallJGWebService('SaveTaskMultiLevelChild', postData, OnAddNewSubTaskSuccess, OnAddNewSubTaskError);

        function OnAddNewSubTaskSuccess(data) {
            if (data.d == true) {
                PreventScroll = 1;
                //alert('Task saved successfully.');
                //sequenceScopeTG.LoadFeedbackPoints();
                LoadSubTasks();
                //$('#subtaskDesc' + taskid).focus();
                NewTaskSaved = true;
                CurrentTaskId = taskid;
            }
            else {
                NewTaskSaved = false;
                alert('Task cannot be saved. Please try again.');
            }
        }

        function OnAddNewSubTaskError(err) {
            alert('Task cannot be saved. Please try again.');
        }
    }
    return false;

}
function OnRomanSave(taskid, desc) {
    clearTimeout(timeoutId);
    var installID = $('#listId' + taskid).attr('data-listid');
    var TaskLvl = $('#nestLevel' + taskid).val();
    var Class = $('#listId' + taskid).attr('data-label');
    var title = $('#txtRomanTitle' + taskid).val();

    if (desc != undefined && desc.trim() != '' && title.trim()!='') {

        ShowAjaxLoader();
        if (TaskLvl == '') TaskLvl = 1;

        var postData = {
            ParentTaskId: taskid,
            InstallId: installID,
            Title: title,
            Description: desc,
            IndentLevel: TaskLvl,
            Class: Class
        };

        CallJGWebService('SaveTaskMultiLevelChild', postData, OnAddNewSubTaskSuccess, OnAddNewSubTaskError);

        function OnAddNewSubTaskSuccess(data) {
            if (data.d == true) {
                PreventScroll = 1;
                //alert('Task saved successfully.');
                //sequenceScopeTG.LoadFeedbackPoints();
                LoadSubTasks();
                //$('#subtaskDesc' + taskid).focus();
                NewTaskSaved = true;
                CurrentTaskId = taskid;
            }
            else {
                NewTaskSaved = false;
                alert('Task cannot be saved. Please try again.');
            }
        }

        function OnAddNewSubTaskError(err) {
            alert('Task cannot be saved. Please try again.');
        }
    }
    return false;

}
function OnSaveSubTask(taskid, desc) {

    var installID = $('#listId' + taskid).attr('data-listid');
    var TaskLvl = $('#nestLevel' + taskid).val();
    var Class = $('#listId' + taskid).attr('data-label');

    if (desc != undefined && desc.trim() != '') {

        ShowAjaxLoader();
        if (TaskLvl == '') TaskLvl = 1;

        var postData = {
            ParentTaskId: taskid,
            InstallId: installID,
            Description: desc,
            IndentLevel: TaskLvl,
            Class: Class
        };

        CallJGWebService('SaveTaskMultiLevelChild', postData, OnAddNewSubTaskSuccess, OnAddNewSubTaskError);

        function OnAddNewSubTaskSuccess(data) {
            if (data.d == true) {
                PreventScroll = 1;
                //alert('Task saved successfully.');
                //sequenceScopeTG.LoadFeedbackPoints();
                LoadSubTasks();
                //$('#subtaskDesc' + taskid).focus();
                NewTaskSaved = true;
                CurrentTaskId = taskid;
            }
            else {
                NewTaskSaved = false;
                alert('Task cannot be saved. Please try again.');
            }
        }

        function OnAddNewSubTaskError(err) {
            alert('Task cannot be saved. Please try again.');
        }
    }
    return false;

}

function ShowAutoSaveProgress(divid) {
    //$('#TaskloaderDiv' + divid).html('<img src="../../img/ajax-loader.gif" style="height:16px; vertical-align:bottom" /> Auto Saving...');
    $('#TaskloaderDiv' + divid).fadeIn(500);
}
function HideAutoSaveProgress(divid) {
    $('#TaskloaderDiv' + divid).fadeOut(500);
    //$('#TaskloaderDiv' + divid).html('');
}

var FeedbackTaskId;
var idAttachments = false;