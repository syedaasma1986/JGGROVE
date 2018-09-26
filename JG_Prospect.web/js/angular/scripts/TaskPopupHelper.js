$(document).ready(function () {
    //Initialize CKEditor
    SetCKEditorForTaskPopup('txtTaskDescription');
    SetCKEditorForChildrenPopup('multilevelChildDesc');    

    //Attach Change event to Designation DropDown
    $(ddlTasksDesignations).on('change', function () {
        resetChosen(ddlTasksDesignations);
        loadUsers(ddlTasksDesignations.replace("#", ""), 'ddlTaskUsers', 'lblStatus');
    });
    $('#ddlTaskUsers').on('change', function () {
        resetChosen('#ddlTaskUsers');        
    });

    //Attach OnClick event to Save button
    $('#btnSaveSubTask').on('click', function () {
        SaveSubTask(false);
    });

    //sequenceScopeTG.TaskLastChild = '';
    //sequenceScopeTG.TaskIndent = 1;
    $('#modalAddTaskDrag').draggable({ handle: '.ui-dialog-titlebar' });
});

//Event Handlers
function AddNewTaskPopup() {    
    $('#txtTitle').val(''); $('#txtURL').val(''); $('#txtTaskDescription').val('');
    $('#txtListId').val($('#hdnNextInstallId').val());
    showAddNewTaskPopup();
}

function SaveSubTask(Silent) {       
    //get URLs
    var url = "";
    $("#divURL :text").each(function () {
        url += $(this).val() + ";";
    });
    url = url.slice(0, -1);

    var title = $('#txtTitle').val();
    //var url = $('#txtURL').val();
    var desc = GetCKEditorContent('txtTaskDescription');
    var status = '1';
    var Priority = '1';
    var DueDate = '';
    var tHours = '';
    var installID = $('#txtListId').val();
    var Attachments = '';
    var type = $('#ddlTaskType').val();
    var users = $("#ddlTaskUsers").val();
    var designations = $(ddlTasksDesignations).val().join();
    var blTechTask = $('#chkIsTechTask').prop('checked');
    var sequence = $('#txtSeqAdd').val();

    if (sequence == undefined)
        sequence = '';

    //Validate Form
    if (!Silent) {

        if (installID == undefined || installID == '') {
            alert('List ID Missing.');
            $('#txtListId').focus();
            return;
        }
        if (title == undefined || title == '') {
            alert('Title Missing.');
            $('#txtTitle').focus();
            return;
        }
        if (url == undefined || url == '') {
            alert('URL Missing.');
            $('#txtURL').focus();
            return;
        }
        if (desc == undefined || desc == '') {
            alert('Description Missing.');
            $('#txtTaskDescription').focus();
            return;
        }
    } else {
        if (installID == undefined || installID == '' || title == undefined || title == '' || url == undefined || url == '' || desc == undefined || desc == '')
            return;
    }

    if (!TaskSaved) {
        ShowAjaxLoader();
        $('#lblStatus').html('Saving Task...');

        var postData = {
            ParentTaskId: ParentTaskId, Title: title, URL: url, Desc: desc, Status: status, Priority: Priority, DueDate: DueDate, TaskHours: tHours, InstallID: installID,
            Attachments: Attachments, TaskType: type, TaskDesignations: designations, TaskAssignedUsers: users, TaskLvl: TaskLvl, blTechTask: blTechTask, Sequence: sequence
        };
        CallJGWebService('AddNewSubTask', postData, OnAddNewSubTaskSuccess, OnAddNewSubTaskError);

        function OnAddNewSubTaskSuccess(data) {
            if (data.d.Success) {
                TaskSaved = true;
                var tid = data.d.TaskId.toString();
                SavedTaskID = tid;

                //Get New Task information for feedback points
                var params = {
                    ParentTaskId: SavedTaskID
                };

                CallJGWebService('GetMultilevelChildren', params, OnMultilevelChildrenSuccess, OnMultilevelChildrenError);
                LastIndent = 1;
                LastChild = '';
                resetData('');

                //Allow scroll to newly created task
                //PreventScroll = 1;
                
                $('#lblStatus').html('Task saved successfully.');

                if (Page == 'TG') {
                    //URL Processing
                    var url = getUrlVars();
                    switch (url.length) {
                        case 1: { }
                        case 2: {
                            var param1;
                            param1 = url['TaskId'];
                            window.history.pushState("", "", "TaskGenerator.aspx?TaskId=" + param1 + "&hstid=" + tid);
                            break;
                        }
                        //case 3: {
                        //    var param1;
                        //    param1 = url['TaskId'];
                        //    param2 = url['hstid'];
                        //    window.history.pushState("", "", "TaskGenerator.aspx?TaskId=" + param1 + "&hstid=" + param2 + "&mcid=" + tid);
                        //    break;
                        //}
                    }
                }
                if (!Silent) {
                    //closePopup();
                    //LoadSubTasks();
                }
            }
            else {
                $('#lblStatus').html('Saving Task failed...');
                //alert('Task cannot be saved. Please try again.');
            }
        }

        function OnAddNewSubTaskError(err) {
            alert('Task cannot be saved. Please try again.');
        }

        function OnMultilevelChildrenSuccess(data) {
            //$scope.NewTaskChildren = data
        }

        function OnMultilevelChildrenError(err) {

        }

        
    }
    else {
        $('#lblStatus').html('Saving Changes...');
        idAttachments = false;
        EditDesc(SavedTaskID, desc, true);
    }
}

function DeleteChild(sender, forPopup) {
    var r = confirm("Are you sure?");

    if (r == true) {
        var ChildId = $(sender).attr('data-childid');
        var postData = {
            ChildId: parseInt(ChildId)
        };
        CallJGWebService('DeleteSubTaskChild', postData, DeleteSuccess, DeleteError);

        function DeleteSuccess(data) {
            if (data.d.Success) {
                if (forPopup) {
                    sequenceScopeTG.getMultilevelChildren();
                    SetupChildInfo(SavedTaskID);
                }
                else {
                    LoadSubTasks();
                }
            }
        }

        function DeleteError(err) {

        }
    }
}

function OnURLAdd(sender) {
    var container = $(sender).parent();
    $(container).append('<div><br/><input type="text" class="smart-text taskURL" style="width: 484px;margin-right: 5px;"><a href="#" onClick="OnURLRemove(this)">-</a></div>');
}

function OnURLRemove(sender) {
    $(sender).parent().remove();
}

//Helper Functions
function SetupNewTaskData(cmdArg, cName, TaskLevel, strInstallId) {

    var postData = {
        CommandArgument: cmdArg,
        CommandName: cName
    };

    $.ajax({
        url: url + 'GetSubTaskListId',
        contentType: 'application/json; charset=utf-8;',
        type: 'POST',
        dataType: 'json',
        data: JSON.stringify(postData),
        asynch: false,
        success: function (data) {
            ParentTaskId = data.d.hdParentTaskId;
            TaskLvl = data.d.hdTaskLvl;
            InstallId = data.d.txtInstallId;
            $('#txtListId').val(InstallId);
        },
        error: function (a, b, c) {
            
        }
    });
}

function SetupChildInfo(taskid) {
    CallJGWebService('GetTaskMultilevelChildInfo', { ParentTaskId: taskid }, OnChildInfoSuccess, OnChildInfoError);
    function OnChildInfoSuccess(data) {
        sequenceScopeTG.getMultilevelChildren();
        data = JSON.parse(data.d);
        data = data.ChildInfoDS.Info;
        if (data != null || data != undefined) {
            InstallId = data.InstallId;
            LastChild = data.LastChild;
            LastIndent = data.Indent;
            resetData(LastIndent);
        }
    }
    function OnChildInfoError(err) {

    }
}

function SaveAttchmentToDBPopup() {
    //if (IsAdminMode == 'True') {
        var data = {
            TaskId: SavedTaskID, attachments: $('#ContentPlaceHolder1_objucSubTasks_Admin_hdnGridAttachment').val()
        };
        $.ajax({
            type: "POST",
            url: url + "SaveUserAttachements",
            data: data,
            success: function (result) {
                //alert("Success");
                $('#ContentPlaceHolder1_objucSubTasks_Admin_hdnGridAttachment').val('');
                sequenceScopeTG.getFileData(CurrentFileName, CurrentEditor);
            },
            error: function (errorThrown) {
                console.log(errorThrown);
                alert("Failed!!!");
            }
        });
        $('#ContentPlaceHolder1_objucSubTasks_Admin_hdnGridAttachment').val('');
    //}
}

function resetData(level) {    
    $('#listIdNewTask').attr('id', 'listId' + SavedTaskID);
    $('#listId' + SavedTaskID).attr('data-listid', InstallId);
    $('#listId' + SavedTaskID).attr('data-level', level);
    $('#listId' + SavedTaskID).attr('data-label', sequenceScopeTG.LevelToRoman(LastChild, LastIndent));
    $('#listId' + SavedTaskID).html(sequenceScopeTG.LevelToRoman(LastChild, LastIndent));    

    $('#nestLevelNewTask').attr('id', 'nestLevel' + SavedTaskID);
    $('#nestLevel' + SavedTaskID).val(level);
    $('#nestLevel' + SavedTaskID).attr('data-label', sequenceScopeTG.LevelToRoman(LastChild, LastIndent));    

    $('#lastDataNewTask').attr('id', 'lastData' + SavedTaskID);
    $('#lastData' + SavedTaskID).val(level);
    $('#lastData' + SavedTaskID).attr('data-label', sequenceScopeTG.LevelToRoman(LastChild, LastIndent));   

    $('#multilevelChildDesc').attr('data-taskid', SavedTaskID);

    $('#btnLeftNewTask').attr('id', 'btnLeft' + SavedTaskID);
    $('#btnLeft' + SavedTaskID).attr('data-taskid', SavedTaskID);    

    $('#btnRightNewTask').attr('id', 'btnRight' + SavedTaskID);
    $('#btnRight' + SavedTaskID).attr('data-taskid', SavedTaskID);    
}

function resetChildData(level) {
    $('#listId' + SavedTaskID).attr('id', 'listIdNewTask');
    $('#listIdNewTask').attr('data-listid', InstallId);
    $('#listIdNewTask').attr('data-level', level);
    $('#listIdNewTask').attr('data-label', 'I');
    $('#listIdNewTask').html('I');

    $('#nestLevel' + SavedTaskID).attr('id', 'nestLevelNewTask');
    $('#nestLevelNewTask').val(level);
    $('#nestLevelNewTask').attr('data-label', 'I');

    $('#lastData' + SavedTaskID).attr('id', 'lastDataNewTask');
    $('#lastDataNewTask').val(level);
    $('#lastDataNewTask').attr('data-label', 'I');

    $('#multilevelChildDesc').attr('data-taskid', SavedTaskID);

    $('#btnLeft' + SavedTaskID).attr('id', 'btnLeftNewTask');
    $('#btnLeftNewTask').attr('data-taskid', SavedTaskID);

    $('#btnRight' + SavedTaskID).attr('id', 'btnRightNewTask');
    $('#btnRightNewTask' + SavedTaskID).attr('data-taskid', SavedTaskID);
}

function closePopup() {
    $('#myModalAddTask div.modal-content').removeClass('ui-dialog');
    $('#txtListId').val('Loading...');
    $('#myModalAddTask').css('display', 'none');
    $('.chosen-dropdown').chosen("destroy");

    //Remove any running timer
    if (timeoutId != undefined) {
        console.log('removing timer: ' + timeoutId);
        clearTimeout(timeoutId);
    }
    //Reload Tasks
    if (TaskSaved) {
        if (Page == 'TG') {
            LoadSubTasks();
        }
        else {
        }
    }
    //Clear Memory
    LastIndent = 1;
    LastChild = '';
    resetChildData('');

    TaskSaved = false; SavedTaskID = 0;    
    sequenceScopeTG.NewTaskMultiLevelChildren = [];
}

function showAddNewTaskPopup() {
    $('#txtTitle').val(''); $('#txtURL').val(''); $('#txtTaskDescription').val('');
    $('.chosen-dropdown').chosen({ width: "225px" });
    $('#myModalAddTask div.modal-content').addClass('ui-dialog');
    $('#myModalAddTask').css('display', 'block');
    clearCKEditor('txtTaskDescription');
    clearCKEditor('multilevelChildDesc');

    //Load Users
    loadUsers(ddlTasksDesignations.replace("#", ""), 'ddlTaskUsers', 'lblStatus');
}

function loadUsers(selector, destination, loader) {
    var did = '';
    var options = $('#' + destination);
    if (($('#' + selector).val() != undefined)) {
        did = $('#' + selector).val().join();
    }

    $('#' + loader).html('Loading Users...');
    $.ajax({
        type: "POST",
        url: "ajaxcalls.aspx/GetUsersByDesignationId",
        dataType: "json",
        contentType: "application/json; charset=utf-8",
        data: JSON.stringify({ designationId: did}),
        success: function (data) {
            options.empty();
            options.append($("<option selected='selected' />").val('0').text('All'));
            // Handle 'no match' indicated by [ "" ] response
            if (data.d) {
                var result = [];
                result = JSON.parse(data.d);
                $.each(result, function () {
                    var names = this.FristName.split(' - ');
                    var Class = 'activeUser';
                    if (this.Status == '5')
                        Class = 'IOUser';

                    var name = names[0] + '&nbsp;-&nbsp;';
                    var link = names[1] != null && names[1] != '' ? '<a style="color:blue;" href="javascript:;" onclick=redir("/Sr_App/ViewSalesUser.aspx?id=' + this.Id + '")>' + names[1] + '</a>' : '';
                    options.append($('<option class="' + Class + '" />').val(this.Id).html(name + link));
                });
            }
            options.trigger("chosen:updated");
            $('#' + loader).html('');
        }
    });
}

function resetChosen(selector) {
    var val = $(selector).val();

    //
    if (val != undefined && val != '') {
        $(selector)
            .find('option:first-child').prop('selected', false)
            .end().trigger('chosen:updated');
    } else {
        $(selector)
            .find('option:first-child').prop('selected', true)
            .end().trigger('chosen:updated');
    }
}



//For new task
var TaskLvl;
var ParentTaskId;
var TaskSaved = false;
var SavedTaskID;
var InstallId;
var LastIndent;
var LastChild;
var CurrentEditor;
var CurrentFileName;
var Page = 'TG';