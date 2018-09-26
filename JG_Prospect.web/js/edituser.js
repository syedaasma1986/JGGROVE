function ChangeStatusForSelected() {

    var tableRows = $(UserGridId).find('> tbody > tr');
    editSalesUserScope.EditSalesUsers = [];

    // set seleted user's id for serch.
    if (tableRows) {
        $.each(tableRows, function (index, item) {
            var checkboxspan = $(item).find("span.useraction");// find span that contains action checkbox
            var checkbox = $(checkboxspan).find("input"); // find action checkbox

            if (checkbox && $(checkbox).is(':checked')) { // if checbox is checked.
                // set into angular function for users to be searched.
                editSalesUserScope.SetEditUsersForSearch($(checkboxspan).attr("data-userid"));
                editSalesUserScope.SearchDesignationId = parseInt($(checkboxspan).attr("data-designationid"));
            }
        });
    }

    //Call search function
    console.log(editSalesUserScope.EditSalesUsers);

    $('#EditUsersModal').removeClass("hide");

    var dlg = $('#EditUsersModal').dialog({
        width: 1100,
        height: 700,
        show: 'slide',
        hide: 'slide',
        autoOpen: true,
        modal: false,
        beforeClose: function (event, ui) {
            $('#EditUsersModal').addClass("hide");
        }
    });

    editSalesUserScope.getEditUsers();

}

function GetSequences() {

    console.log("End function of EditUser....");

    var postData = { DesignationId: editSalesUserScope.SearchDesignationId, UserCount: editSalesUserScope.EditSalesUsers.length };

    console.log(postData);

    CallJGWebService('GetInterviewDateSequences', postData, OnGetSequenceSuccess, OnGetSequenceError);

    function OnGetSequenceSuccess(data) {

        if (data.d) {
            AllocatedUserWithSequences(JSON.parse(data.d));
        }
    }

    function OnGetSequenceError(err) {
        alert("Error occured while loading sequences automatically.");
    }
}

function AllocatedUserWithSequences(AvailableSequences) {

    var SeqArray = AvailableSequences;

    //Get table rows for edit users.
    var tableRows = $('#tblEditUserPopup > tbody > tr');

    $.each(tableRows, function (Index, Item) {

        var td = $(Item).find("td.SeqAssignment");// find td that contains assignment.
        var taskUrl = "/Sr_App/TaskGenerator.aspx?TaskId=#PTID#&hstid=#HTID#";

        // Untill sequence is available assign it.
        if (SeqArray && SeqArray.length > Index) {

            var seqLabel = $(td).find("label.seqLable");
            $(seqLabel).html(angular.getSequenceDisplayText(SeqArray[Index].SequenceNo, editSalesUserScope.SearchDesignationId, "TT"));

            //console.log(seqLabel);

            var TaskURL = $(td).find("a.seqTaskURL");
            $(TaskURL).html(SeqArray[Index].InstallId);
            $(TaskURL).attr("href", taskUrl.replace("#PTID#", SeqArray[Index].ParentTaskId).replace("#HTID#", SeqArray[Index].TaskId));
            $(TaskURL).attr("data-taskid", SeqArray[Index].TaskId);
            //console.log(TaskURL);
        }

        // Apply Datetime Picker to input.
        var dateTextBox = $(td).find("input.interviewDate");
        console.log(dateTextBox);
        $(dateTextBox).datepicker({
            dateFormat: 'mm-dd-yy',
            minDate: new Date()
        });

        $(dateTextBox).datepicker("setDate", new Date());

        var timeTextBox = $(td).find("input.interviewTime");

        $(timeTextBox).timepicker({ 'timeFormat': 'h:i A' });

        $(timeTextBox).timepicker('setTime', new Date());


    });
}

function SetMultipleInterviewDate(button) {

    //Get table rows for edit users.
    var tableRows = $('#tblEditUserPopup > tbody > tr');

    $.each(tableRows, function (Index, Item) {

        var td = $(Item).find("td.SeqAssignment");
        var InterviewDateTextBox = $($(td).find("input.interviewDate"));

        var InterviewDate = InterviewDateTextBox.val();
        var InterviewTime = $($(td).find("input.interviewTime")).val();
        var DesignationId = editSalesUserScope.SearchDesignationId;

        var UserEmail = InterviewDateTextBox.attr("data-email");
        var UserId = parseInt(InterviewDateTextBox.attr("data-userid"));

        var TaskURL = $(td).find("a.seqTaskURL");

        var TaskId = parseInt($(TaskURL).attr("data-taskid"));

        if (isNaN(TaskId)) {
            TaskId = 0;
        }

        SetInterviewDateStatus(UserId, UserEmail, DesignationId, InterviewDate, InterviewTime, TaskId);

    });

    return false;
}

function SetInterviewDateStatus(UserId, UserEmail, DesignationId, InterviewDateVal, InterviewTimeVal, TaskId) {

    ShowAjaxLoader();
    var postData = { UserEmail: UserEmail, UserID: UserId, DesignationID: DesignationId, InterviewDate: InterviewDateVal, InterviewTime: InterviewTimeVal, TaskId: TaskId };

    console.log(postData);

    CallJGWebService('SendInterviewDatetoCandidate', postData, OnSendInterviewDatetoCandidateSuccess, OnSendInterviewDatetoCandidateError);

    function OnSendInterviewDatetoCandidateSuccess(data) {


        HideAjaxLoader();
        if (data.d) {

            $("#ediPopupStatusSuccess").html($("#ediPopupStatusSuccess").html() + "Interview date email sent to :" + UserEmail + "<br/>");

        }
    }

    function OnSendInterviewDatetoCandidateError(err) {


        HideAjaxLoader();
        alert("Error occured while sending interview date email to: " + UserEmail);
    }

}