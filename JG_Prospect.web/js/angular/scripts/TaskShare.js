 $(document).ready(function () {
    $('.search-target').click(function () {
        SearchTargetEmail = $(this).attr('data-target') == 'emails' ? true : false;
        $('#txtSearchUserShare').val('');
        $('#txtSearchUserShare').focus();
        $('.search-label').html(SearchTargetEmail ? 'Search: Email' : 'Search: User');
    });
    $('#btnShare').on('click', function () {
        if (SearchTargetEmail) {
            var contents = urltoCopy;
            sendEmail(this, contents, uid);
        }
        else {
            var note = 'Shared: ' + $('#txtTaskLink').val();
            addNote(this, uid, note);
        }
        return false;
    });
    $('.modal-header').find('.close').click(function () {
        $('#myModal').hide(200);
    });
    $('#btnMove').on('click', function () {
        ShowShareMoveLoading('Moving Task...');
        var ToTaskId = $('#ddlChildTask').val();
        if (ToTaskId != undefined) {
            var FromTaskId = ParentTaskId;
            CallJGWebService('MoveTask', { TaskId: TIdToDel, FromTaskId: FromTaskId, ToTaskId: ToTaskId },
                function (data) {
                    ShowShareMoveLoading('Task Moved Successfully.');
                    setTimeout(function () {
                        $('#myModal').hide(200);
                    }, 2000);
                    LoadSubTasks();
                },
                function (err) {
                    alert('Error - can not move task.');
                }
            );
        }
        else {
            ShowShareMoveLoading('Please select a task first!');
        }
        return false;
    });
    $('#btnDelete').on('click', function () {
        if (confirm('It will delete this task and all its child tasks. Are you sure?')) {
            CallJGWebService('HardDeleteTask', { TaskId: parseInt(TIdToDel) },
                function (data) {
                    if (data) {
                        LoadSubTasks();
                        alert('Task deleted successfully.');
                        $('#myModal').css('display', 'none');
                    }
                },
                function (err) {
                    alert('Error deleting task.');
                });
        }
        return false;
    });
    $('#btnCopy').on('click', function () {
        $('#txtTaskLink').select();
        var successful = document.execCommand('copy');
        return false;
    });

    $('#txtSearchUserShare').on('keyup', function () {
        $('.auto-complete-users').remove();
        var keywords = '', keyword = '';
        if (SearchTargetEmail == false) {
            keywords = $(this).val().split('@');
            keyword = keywords[keywords.length - 1];
        }
        else {
            keyword = $(this).val();
        }
        if (SearchTargetEmail == false && keywords.length < 2)
            return;
        if (keyword != '')
            ajaxExt({
                url: SearchTargetEmail == false ? '/Sr_App/ajaxcalls.aspx/GetInstallUsersByPrefix' : '/Sr_App/EditUser.aspx/GetUsers',
                type: 'POST',
                data: '{ keyword: "' + keyword + '" }',
                showThrobber: true,
                throbberPosition: { my: "left center", at: "right center", of: $(this), offset: "5 0" },
                success: function (data, msg) {
                    if (data.Results.length > 0) {
                        $('.auto-complete-users').remove();
                        var tbl = '<ul class="auto-complete-users">';
                        $(data.Results).each(function (i) {
                            if (name != null && name != undefined) {
                                var data = (SearchTargetEmail == true ? this.Email : this.FirstName);
                                tbl += '<li>' +
                                    '<div onclick="setUserData(this, \'' + data + '\',' + this.ID + ')">' + data + '</div>' +
                                    '</li>';
                            }
                        });
                        tbl += '</ul>';
                        $('.users-container').append(tbl);
                    } else {
                        $('.users-container').append('<ul class="auto-complete-users"><li>Not found</li></ul>');
                    }
                }
            });
    });
});

function addNote(sender, uid, note) {
    if (note != '') {
        $('.search-label').html('Please Wait...');
        ajaxExt({
            url: '/Sr_App/edituser.aspx/AddNotes',
            type: 'POST',
            data: '{ id: ' + uid + ', note: "' + note + '", touchPointSource: ' + TouchPointSource + ' }',
            showThrobber: true,
            throbberPosition: { my: "left center", at: "right center", of: $(sender), offset: "5 0" },
            success: function (data, msg) {
                $('#txtSearchUserShare').val('');
                $('.search-label').html('Note Sent.');
            }
        });
    }
}

function setUserData(sender, data, id) {
    uid = id;
    $('#txtSearchUserShare').val(data);
    $('.auto-complete-users').remove();
}
function sharePopup(obj, SrcITDashboard) {
    TIdToDel = $(obj).attr('data-highlighter');
    urltoCopy = updateQueryStringParameterTP(window.location.href, "hstid", TIdToDel);
    var taskfid = $(obj).attr('data-taskfid');
    var tasktitle = $(obj).attr('data-tasktitle');
    var AssignedUserId = $(obj).attr('data-AssignedUserId');
    var uname = $(obj).attr('data-uname');
    urltoCopy = urltoCopy + '&task=' + taskfid + '&title=' + tasktitle + '&assigneduser=' + AssignedUserId + '&name=' + uname;
    //copyToClipboard(urltoCopy);

    var url = '';
    if (SrcITDashboard!= undefined && SrcITDashboard) {
        url = $(obj).parent().parent().next().children('a').attr('href');
        if (url != undefined && url != null) {
            url = url.replace('..', '');
            urltoCopy = window.location.origin + url + '&task=' + taskfid + '&title=' + tasktitle + '&assigneduser=' + AssignedUserId + '&name=' + uname;
        }
    }

    // Get the modal
    var modal = document.getElementById('myModal');

    // Get the <span> element that closes the modal
    var span = document.getElementsByClassName("close")[0];

    // When the user clicks the button, open the modal 
    modal.style.display = "block";

    // When the user clicks on <span> (x), close the modal
    span.onclick = function () {
        modal.style.display = "none";
    }

    // When the user clicks anywhere outside of the modal, close it
    window.onclick = function (event) {
        if (event.target == modal) {
            modal.style.display = "none";
        }
    }

    $('#txtTaskLink').val(urltoCopy);
    $('#txtSearchUserShare').val('');

    return false;
}

var uid = '';
var SearchTargetEmail = true;
var urltoCopy = '';
var TIdToDel = '';
var TouchPointSource;