function setDateFilter(IsCalendarView) {
    //Set Date Filters
    $('.chkAllDates').attr("checked", true);
    //Set Date
    $('.dateFrom').val("All");
    var EndDate = new Date();
    EndDate = (EndDate.getMonth() + 1) + '/' + EndDate.getDate() + '/' + EndDate.getFullYear();
    $('.dateTo').val(EndDate);
    
    $('.chkAllDates').change(function () {
        $('.dateFrom').val("All");
        var EndDate = new Date();
        EndDate = (EndDate.getMonth() + 1) + '/' + EndDate.getDate() + '/' + EndDate.getFullYear();
        $('.dateTo').val(EndDate);
        $('.chkOneYear').attr("checked", false); $('.chkThreeMonth').attr("checked", false); $('.chkOneMonth').attr("checked", false); $('.chkTwoWks').attr("checked", false);
        if (!IsCalendarView) {
            
        }
        else {
            setCalendarFilterData();
            refreshCalendarTasks();
        }
    });

    $('.chkOneYear').change(function () {
        addMonthsToDate(12);
        $('.dateFrom').val(StartDate);
        $('.dateTo').val(EndDate);
        $('.chkThreeMonth').attr("checked", false); $('.chkOneMonth').attr("checked", false); $('.chkTwoWks').attr("checked", false); $('.chkAllDates').attr("checked", false);
        if (!IsCalendarView) {
            
        } else {
            setCalendarFilterData();
            refreshCalendarTasks();
        }
    });

    $('.chkThreeMonth').change(function () {
        addMonthsToDate(3);
        $('.dateFrom').val(StartDate);
        $('.dateTo').val(EndDate);
        $('#chkOneYear').attr("checked", false); $('.chkOneMonth').attr("checked", false); $('.chkTwoWks').attr("checked", false); $('.chkAllDates').attr("checked", false);
        if (!IsCalendarView) {
            
        } else {
            setCalendarFilterData();
            refreshCalendarTasks();
        }
    });

    $('.chkOneMonth').change(function () {
        addMonthsToDate(1);
        $('.dateFrom').val(StartDate);
        $('.dateTo').val(EndDate);
        $('#chkOneYear').attr("checked", false); $('.chkThreeMonth').attr("checked", false); $('.chkTwoWks').attr("checked", false); $('.chkAllDates').attr("checked", false);
        if (!IsCalendarView) {
            
        } else {
            setCalendarFilterData();
            refreshCalendarTasks();
        }
    });

    $('.chkTwoWks').change(function () {
        addDaysToDate(13);
        $('.dateFrom').val(StartDate);
        $('.dateTo').val(EndDate);
        $('#chkOneYear').attr("checked", false); $('.chkThreeMonth').attr("checked", false); $('.chkOneMonth').attr("checked", false); $('.chkAllDates').attr("checked", false);
        if (!IsCalendarView) {
            
        } else {
            setCalendarFilterData();
            refreshCalendarTasks();
        }
    });
}
//Date Filter
var StartDate = new Date();
var EndDate = new Date();
var Did, Uid;

function addMonthsToDate(Number) {
    StartDate = new Date();
    EndDate = new Date();

    StartDate.setMonth(StartDate.getMonth() - Number);
    StartDate.setDate(StartDate.getDate() - 1);
    StartDate = (StartDate.getMonth() + 1) + '/' + StartDate.getDate() + '/' + StartDate.getFullYear();

    EndDate = (EndDate.getMonth() + 1) + '/' + EndDate.getDate() + '/' + EndDate.getFullYear();
}
function addDaysToDate(Number) {
    StartDate = new Date();
    EndDate = new Date();

    StartDate.setDate(StartDate.getDate() - 13);
    StartDate = (StartDate.getMonth() + 1) + '/' + StartDate.getDate() + '/' + StartDate.getFullYear();

    EndDate = (EndDate.getMonth() + 1) + '/' + EndDate.getDate() + '/' + EndDate.getFullYear();
}

function fillUsers(selector, fillDDL, loader) {
    // 
    var did = '';
    if (($('#' + selector).val() != undefined)) {
        did = $('#' + selector).val().join();
    }

    var ustatus = $('#ddlUserStatus').val();
    var TaskStatus = '';
    var UserStatus = '';

    //Extract User Status from MultiStatusType DropDown
    $.each(ustatus, function (key, element) {
        if (element.substr(0, 1) == 'T') {
            TaskStatus += element.replace('T', '') + ',';
        }
        else if (element.substr(0, 1) == 'U') {
            UserStatus += element.replace('U', '') + ',';
        }
    });
    TaskStatus = TaskStatus.slice(0, TaskStatus.length - 1);
    UserStatus = UserStatus.slice(0, UserStatus.length - 1);
    ustatus = UserStatus;

    var options = $('#' + fillDDL);
    $('.chzn-drop').css({ "width": "300px" });

    //$("#" + fillDDL).prop('disabled', true);
    $('#' + loader).show();
    $.ajax({
        type: "POST",
        url: "ajaxcalls.aspx/GetUsersByDesignationIdWithUserStatus",
        dataType: "json",
        contentType: "application/json; charset=utf-8",
        data: JSON.stringify({ designationId: did, userStatus: ustatus }),
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
                //$("#" + fillDDL).prop('disabled', false);
            }
            options.trigger("chosen:updated");
            $('#' + loader).hide();

            //Create Links
            //$('#ddlSelectUserInProTask_chosen .chosen-drop ul.chosen-results li').each(function (i) {
            //    console.log($(this).html());
            //    $(this).bind("click", "a", function () {                            
            //        window.open($(this).find("a").attr("href"), "_blank", "", false);
            //    });
            //});
            // remove loading spinner image.
        }
    });
}