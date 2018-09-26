<%@ Page Language="C#" MasterPageFile="~/Sr_App/SR_app.Master" AutoEventWireup="true" EnableEventValidation="false" CodeBehind="ITDashboardCalendar.aspx.cs" Inherits="JG_Prospect.Sr_App.ITDashboardCalendar" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <style type="text/css">
        .timezone-container{
            display: block;
    width: 100%;
    background: #fff;
    padding: 10px 0 0px 10px;
        }
        .timezone-container select{
            border: 1px solid #aaa;
    border-radius: 3px;
    padding: 3px;
        }
        #calendar {
            margin-top: 0px;
            background-color: #fff;
            padding: 10px; 
        }
        .refresh{
                height: 20px;
                cursor: pointer;
                box-shadow: 0 2px 5px 0 rgba(0, 0, 0, 0.26);
                padding: 5px;
                background-color: #fff;
            }
        .eventRow{
            padding: 6px !important;
            font-size: 12px !important;
        }
        .fc-content{
            line-height: 26px;
        }
        .fc-content div{
            margin-left:8px;
        }
        .InstallId{
            margin-left: 12px;
            background-color: #fff;
            padding: 5px;
            border-radius: 8px;            
        }
        .UserInstallId{
            margin-left: 0px;
            background-color: #fff;
            padding: 5px;
            border-radius: 8px;            
        }
        #hidden{
            display:none;
        }
        .badge1 {
            padding: 1px 5px 2px;
            font-size: 12px;
            font-weight: bold;
            white-space: nowrap;
            color: #ffffff;
            background-color: #e55456;
            -webkit-border-radius: 9px;
            -moz-border-radius: 9px;
            border-radius: 8px;
            display: inline;
        }
        .tableFilter tbody tr td {
            padding: 10px;
        }
        #ddlDesignationSeq_chosen ul.chosen-choices{
            max-height: 58px;
            overflow-y: auto;
        }
        .cal-user-height{
            height: 75px;
        }

        .calendar-user {
            border-radius: 50%;
            width: 38px;
            height: 38px;
        }
        .fc-agenda-view .fc-day-grid .fc-row{
            min-height: 7em !important;
        }
        .calendar-users-container{
            height:80px;
            overflow-y:auto;
        }
        .calendar-users-container img:hover {
            border: solid;
            border-radius: 50%;
            border-color:#cd0a0a;
            border-width: 1px;
            border-collapse: collapse;
            cursor: pointer;
            padding: 1px;
        }
        .calendar-users-image-border {
            border-style: solid; 
            border-color: black;
            border-width: 1px;
        }
        .calendar-users-image-border-none{
            border-style:none;
        }
        .fc-day-header{
            font-size:29px;
            color: black;
            padding:10px;
        }
        .fc-day-header a{
            text-decoration:none;
        }
        .fc-event .fc-bg {
            z-index: 1;
            background: #fff;
            opacity: .25;
            border: 1px black solid;
        }

        .chosen-container {
            width: 100% !important;
        }

        .chose-image {
            width: 35px !important;
            max-height: 35px !important;
        }

        .chose-image-list {
        }

        .chosen-container-multi .chosen-choices li.search-choice span {
            font-size: 0px !important;
        }
    </style>
    <link href="../css/chosen.css" rel="stylesheet" />
    <link rel="stylesheet" href="../js/fullcalendar/css/fullcalendar.css" />
    <script type="text/javascript" src="../js/fullcalendar/js/moment.min.js"></script>
    <script type="text/javascript" src="../js/fullcalendar/js/fullcalendar.min.js"></script>

    <script type="text/javascript" src="../js/angular/scripts/jgapp.js"></script>
    <script src="../js/angular/scripts/CommonFunctions.js?ver=<%=DateTime.Now%>"></script>
    <script src="../js/TaskSequencing.js?ver=<%=DateTime.Now%>"></script>
    <script src="../js/angular/scripts/TaskSequence.js?ver=<%=DateTime.Now%>"></script>
    <script type="text/javascript" src="<%=Page.ResolveUrl("~/js/chosen.jquery.js")%>"></script>
    <link href="../Content/image-select/ImageSelect.css" rel="stylesheet" />
    <script src="../Content/image-select/ImageSelect.jquery.js"></script>
    <%--    <script src="../Content/chosen-image/chosen/chosen.jquery.min.js"></script>
    <link href="../Content/chosen-image/chosen/chosen.min.css" rel="stylesheet" />--%>
    <script type="text/javascript">
        $(document).ready(function () {
            
            //$.noConflict();
            if ('<%=IsSuperUser.ToString().ToLower().Trim()%>' == 'true') {
                sequenceScope.IsAdmin = true;
                //$.noConflict();
                $('#refreshInProgTasks').on('click', function () {
                    CalendarUserClickSource = 'FILTER';
                    $('#calendar').fullCalendar('refetchEvents');
                });
                $(".chosen-dropDown").chosen();

                //fill users
                if ($('#' + '<%=tableFilter.ClientID%>').length > 0) {
                    $('#ddlUserStatus').find('option:first-child').prop('selected', false);
                    $('#ddlUserStatus option[value="U1"]').attr("selected", "selected");
                    $('#ddlUserStatus option[value="T3"]').attr("selected", "selected");
                    $('#ddlUserStatus option[value="T4"]').attr("selected", "selected");
                    $('#ddlUserStatus').trigger('chosen:updated');
                    //Get Designation for LoggedIn User
                    var des = <%=UserDesignationId%>;
            
                    var DesToSelectITLead = ['8', '9', '10', '11', '12', '13', '24', '25', '26', '27', '28', '29'];
                    var DesToSelectForeman = ['14', '15', '16', '17', '18', '19', '20'];
                    var DesToSelectSalesManager = ['2', '3', '6', '7'];
                    var DesToSelectOfficeManager = ['1', '4', '5', '22', '23'];

                    //Set pre-selected options
                    switch (des) {
                        case 21: {
                            $('#ddlDesignationSeq').find('option:first-child').prop('selected', false).end().trigger('chosen:updated');
                            $.each(DesToSelectITLead, function (index, value) {
                                //Select Designation
                                $("#ddlDesignationSeq option[value=" + value + "]").attr("selected", "selected");
                            });
                            break;
                        }
                        case 18: {
                            $('#ddlDesignationSeq').find('option:first-child').prop('selected', false).end().trigger('chosen:updated');
                            $.each(DesToSelectForeman, function (index, value) {
                                //Select Designation
                                $("#ddlDesignationSeq option[value=" + value + "]").attr("selected", "selected");
                            });
                            break;
                        }
                        case 6: {
                            $('#ddlDesignationSeq').find('option:first-child').prop('selected', false).end().trigger('chosen:updated');
                            $.each(DesToSelectSalesManager, function (index, value) {
                                //Select Designation
                                $("#ddlDesignationSeq option[value=" + value + "]").attr("selected", "selected");
                            });
                            break;
                        }
                        case 4: {
                            $('#ddlDesignationSeq').find('option:first-child').prop('selected', false).end().trigger('chosen:updated');
                            $.each(DesToSelectOfficeManager, function (index, value) {
                                //Select Designation
                                $("#ddlDesignationSeq option[value=" + value + "]").attr("selected", "selected");
                            });
                            break;
                        }
                    }                    

                    //Refresh Choosen
                    $("#ddlDesignationSeq").trigger("chosen:updated");

                    fillUsers('ddlDesignationSeq', 'ddlSelectUser', 'lblLoading');
                }
                setCalendarFilterData();
                ShowCalendarTasks();
                //CHange events for filters
                $("#ddlSelectUser").change(function () {
                    //resetChosen("#chosen-select-users");
                    CalendarUserClickSource = 'FILTER';
                    setCalendarFilterData();
                    refreshCalendarTasks();
                });
                $('#ddlUserStatus').change(function () {
                    //resetChosen(this);
                    CalendarUserClickSource = 'FILTER';
                    fillUsers('ddlDesignationSeq', 'ddlSelectUser', 'lblLoading');
                    setCalendarFilterData();
                    refreshCalendarTasks();
                });
                $('#ddlDesignationSeq').change(function () {
                    //resetChosen(this);
                    CalendarUserClickSource = 'FILTER';
                    fillUsers('ddlDesignationSeq', 'ddlSelectUser', 'lblLoading');
                    setCalendarFilterData();
                    refreshCalendarTasks();
                });

                $('.fc-icon-left-single-arrow').click(function () {
                    CalendarUserClickSource = 'FILTER';
                    clearSelectedDates();
                });

                $('.fc-icon-right-single-arrow').click(function () {
                    CalendarUserClickSource = 'FILTER';
                    clearSelectedDates();
                });
            } else {//User Mode : NonAdmin
                sequenceScope.IsAdmin = false;
                setCalendarFilterData();
                ShowCalendarTasks();
                $('#refreshInProgTasks').on('click', function () {
                    //$.noConflict();
                    CalendarUserClickSource = 'FILTER';
                    $('#calendar').fullCalendar('refetchEvents');
                    //$('#calendar').fullCalendar('refetchEvents', {defaultView: 'agendaDay', minTime:'01:00:00'});
                });
            }
            //set date filters
            setDateFilter(true);
            //for StartDate and EndDate trigger
            $('.dateFrom').change(function () {
                CalendarUserClickSource = 'FILTER';
                setCalendarFilterData();
                refreshCalendarTasks();
            });

            $('.dateTo').change(function () {
                CalendarUserClickSource = 'FILTER';
                setCalendarFilterData();
                refreshCalendarTasks();
            });            
        });
    </script>
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <div class="right_panel" ng-app="JGApp" ng-controller="TaskSequenceSearchController">
        <!-- appointment tabs section start -->
        <ul class="appointment_tab">
            <li><a href="home.aspx">Sales Calendar</a></li>
            <li><a href="GoogleCalendarView.aspx">Master  Calendar</a></li>
            <li><a href="ITDashboard.aspx">Operations Calendar</a></li>
            <li><a href="CallSheet.aspx">Call Sheet</a></li>
            <li id="li_AnnualCalender" visible="false" runat="server"><a href="#" runat="server">Annual Event Calendar</a> </li>
        </ul>
        <!-- appointment tabs section end -->

        <h1><b>IT Dashboard</b></h1>
        <h2 runat="server">All Tasks
        </h2>
        <div id="ViewTab_">
            <ul class="appointment_tab" style="margin-top: -8px; margin-right: -6px; margin-bottom: -5px;">
                <li><a href="ITDashboard.aspx">Tasklist View</a></li>
                <li><a href="ITDashboardCalendar.aspx" class="active">Calendar View</a></li>
            </ul>
        </div>
        <img src="/img/ajax-loader.gif" class="refresh" id="loading" style="display: none; position: absolute;">
        <img src="/img/refresh.png" class="refresh" id="refreshInProgTasks" style="float: right;">
        <%if (IsSuperUser)
            { %>
        <table style="width: 100%" id="tableFilter" runat="server" class="tableFilter">
            <tr style="background-color: #000; color: white; font-weight: bold; text-align: center;">

                <td>
                    <span id="lblDesignation">Designation</span></td>
                <td>
                    <span id="lblUserStatus">User & Task Status</span><span style="color: red">*</span></td>
                <td>
                    <span id="lblAddedBy">Users</span></td>
                <td style="width: 250px">
                    <span id="lblSourceH">Saved Report</span></td>
                <td style="width: 380px">
                    <span id="Label2">Select Period</span>
                </td>
                <td>Search</td>
            </tr>
            <tr>
                <td>

                        <select data-placeholder="Select Designation" class="chosen-dropDown" multiple style="width: 200px;" id="ddlDesignationSeq">
                            <option selected value="">All</option>
                            <option value="1">Admin</option>
                            <option value="2">Jr. Sales</option>
                            <option value="3">Jr Project Manager</option>
                            <option value="4">Office Manager</option>
                            <option value="5">Recruiter</option>
                            <option value="6">Sales Manager</option>
                            <option value="7">Sr. Sales</option>
                            <option value="8">IT - Network Admin</option>
                            <option value="9">IT - Jr .Net Developer</option>
                            <option value="10">IT - Sr .Net Developer</option>
                            <option value="21">IT Lead</option>
                            <option value="11">IT - Android Developer</option>
                            <option value="12">IT - Sr. PHP Developer</option>
                            <option value="13">IT – JR SEO/Backlinking/Content</option>
                            <option value="14">Installer - Helper</option>
                            <option value="15">Installer - Journeyman</option>
                            <option value="16">Installer - Mechanic</option>
                            <option value="17">Installer - Lead mechanic</option>
                            <option value="18">Installer - Foreman</option>
                            <option value="19">Commercial Only</option>
                            <option value="20">SubContractor</option>
                            <option value="22">Admin-Sales</option>
                            <option value="23">Admin Recruiter</option>
                            <option value="24">IT - Senior QA</option>
                            <option value="25">IT - Junior QA</option>
                            <option value="26">IT - Jr. PHP Developer</option>
                            <option value="27">IT – Sr SEO Developer</option>
                        </select>
                    </td>
                    <td>
                        <select data-placeholder="Select Designation" class="chosen-dropDown" multiple style="width: 200px;" id="ddlUserStatus">
                            
                            <option selected value="A0">All</option>
                            
                            <optgroup label="User Status">
                                <option value="U1">Active</option>
                                <option value="U6">Offer Made</option>
                                <option value="U5">Interview Date</option>
                            </optgroup>
                            <optgroup label="Task Status">
                                <option value="T4">In Progress</option>
                                <%--<option value="T2">Request</option>--%>
                                <option value="T3">Request-Assigned</option>
                                <%--<option value="T1">Open</option>--%>
                                <%--<option value="T8">Specs In Progress-NOT OPEN</option>--%>
                                <option value="T11">Test Commit</option>
                                <option value="T12">Live Commit</option>
                                <option value="T7">Closed</option>
                                <option value="T14">Billed</option>
                                <option value="T9">Deleted</option>
                            </optgroup>
                        </select>
                    </td>
                    <td>
                        <select id="ddlSelectUser" data-placeholder="Select Users" multiple style="width: 200px;" class="chosen-dropDown">
                            <option selected value="">All</option>
                        </select><span id="lblLoading" style="display: none">Loading...</span>
                    </td>
                    <td></td>
                    <td style="text-align: left; text-wrap: avoid; padding:0px">
                        <div style="float: left; width: 57%;">
                            <input class="chkAllDates" name="chkAllDates" type="checkbox"><label for="chkAllDates">All</label>
                            <input class="chkOneYear" name="chkOneYear" type="checkbox"><label for="chkOneYear">1 year</label>
                            <input class="chkThreeMonth" name="chkThreeMonth" type="checkbox"><label for="chkThreeMonth"> Quarter (3 months)</label>
                            <br />
                            <input class="chkOneMonth" name="chkOneMonth" type="checkbox"><label for="chkOneMonth"> 1 month</label>
                            <input class="chkTwoWks" name="chkTwoWks" type="checkbox"><label for="chkTwoWks"> 2 weeks (pay period!)</label>
                        </div>

                        <div>
                            <span id="Label3">From :*
                            <asp:TextBox ID="txtCalfrmdate" runat="server" TabIndex="2" CssClass="dateFrom"
                                onkeypress="return false" MaxLength="10"
                                Style="width: 80px;"></asp:TextBox>
                            <cc1:CalendarExtender ID="calExtendFromDate" runat="server" TargetControlID="txtCalfrmdate">
                            </cc1:CalendarExtender><br />
                            </span>

                            <span id="Label4">To :*
                            <asp:TextBox ID="txtCalTodate" CssClass="dateTo" onkeypress="return false"
                                MaxLength="10" runat="server" TabIndex="3"
                                Style="width: 80px;margin-left: 16px;"></asp:TextBox>
                            <cc1:CalendarExtender ID="CalendarExtender2" runat="server" TargetControlID="txtCalTodate">
                            </cc1:CalendarExtender>
                            </span>

                            <span id="requirefrmdate" style="color: Red; visibility: hidden;">Select From date</span><span id="Requiretodate" style="color: Red; visibility: hidden;"> Select To date</span>
                        </div>
                    </td>
                    <td>
                        <%--<input id="txtSearchUser" class="textbox ui-autocomplete-input" maxlength="15" placeholder="search users" type="text" />--%>
                    </td>
                </tr>
            </table>
        <%}
    else
    { %>
        <table style="width: 100%" id="tableFilterUser" runat="server" class="tableFilter">
                <tr style="background-color: #000; color: white; font-weight: bold; text-align: center;">
                    <td style="width:34%">
                        <span>Saved Report</span></td>
                    <td style="width:33%">
                        <span>Select Period</span>
                    </td>
                    <td style="width:33%">
                        Search</td>
                </tr>
                <tr>
                    <td></td>
                    <td style="text-align: left; text-wrap: avoid; padding:0px">
                        <div style="float: left; width: 57%;">
                            <input class="chkAllDates" name="chkAllDates" type="checkbox"><label for="chkAllDates">All</label>
                            <input class="chkOneYear" name="chkOneYear" type="checkbox"><label for="chkOneYear">1 year</label>
                            <input class="chkThreeMonth" name="chkThreeMonth" type="checkbox"><label for="chkThreeMonth"> Quarter (3 months)</label>
                            <br />
                            <input class="chkOneMonth" name="chkOneMonth" type="checkbox"><label for="chkOneMonth"> 1 month</label>
                            <input class="chkTwoWks" name="chkTwoWks" type="checkbox"><label for="chkTwoWks"> 2 weeks (pay period!)</label>
                        </div>

                        <div>
                            <span>From :*
                            <asp:TextBox ID="txtFromUser" runat="server" TabIndex="2" CssClass="dateFrom"
                                onkeypress="return false" MaxLength="10"
                                Style="width: 80px;"></asp:TextBox>
                            <cc1:CalendarExtender ID="CalendarExtender1" runat="server" TargetControlID="txtFromUser">
                            </cc1:CalendarExtender><br />
                            </span>

                            <span>To :*
                            <asp:TextBox ID="txtToUser" CssClass="dateTo" onkeypress="return false"
                                MaxLength="10" runat="server" TabIndex="3"
                                Style="width: 80px;margin-left: 16px;"></asp:TextBox>
                            <cc1:CalendarExtender ID="CalendarExtender3" runat="server" TargetControlID="txtToUser">
                            </cc1:CalendarExtender>
                            </span>
                        </div>
                    </td>
                    <td>
                        <%--<input id="txtSearchUser" class="textbox ui-autocomplete-input" maxlength="15" placeholder="search users" type="text" />--%>
                    </td>
                </tr>
            </table>
        <%} %>
        <div class="timezone-container">
            Timezone:
          <select id="timezone-selector">
              <option value="" selected>none</option>
              <option value="local">local</option>
              <option value="UTC">UTC</option>
          </select>
        </div>
        <div id="calendar">
        </div>
    </div>
</asp:Content>
