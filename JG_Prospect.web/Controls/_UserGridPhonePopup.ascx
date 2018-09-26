<%@ Control Language="C#" AutoEventWireup="true" CodeBehind="_UserGridPhonePopup.ascx.cs" Inherits="JG_Prospect.Controls._UserGridPhonePopup" %>
<%
    string baseUrl = HttpContext.Current.Request.Url.Scheme +
                        "://" + HttpContext.Current.Request.Url.Authority +
                        HttpContext.Current.Request.ApplicationPath.TrimEnd('/') + "/";
%>
<input type="hidden" id="loggedInUsername" value="<%=loggedInUsername %>" />
<input type="hidden" id="loggedInUserInstallId" value="<%=loggedInUserInstallId %>" />
<link href="../css/flags24.css" type="text/css" rel="stylesheet" />
<div class="userlist-grid">
    <input type="hidden" id="PageIndex" value="0" />
    <table class="header-table">
        <thead>
            <tr>
                <th><span>User Status</span><span style="color: red">*</span></th>
                <th><span>Secondary Status</span></th>
                <th><span>Added By</span></th>
                <th rowspan="2" style="width:20%;"><span>Select Period</span></th>
            </tr>
            <tr>
                <th><span>Designation</span></th>
                <th><span>Saved Reports</span></th>
                <th><span>Source</span></th>
            </tr>
        </thead>
        <tbody>
            <tr>
                <td>
                    <div class="phoneTypes" style="display: none;">
                        <select>
                            <option value="0">--Select--</option>
                            <%
                                foreach (var item in dsPhoneType)
                                {
                            %><option value="<%=item.Key %>"><%=item.Value %></option>
                            <%
                                }
                            %>
                        </select>
                    </div>
                    <div class="employmentTypes" style="display: none;">
                        <select>
                            <option value="0">--Select--</option>
                            <%
                                foreach (var item in employmentTypes)
                                {
                            %><option value="<%=item.Key %>"><%=item.Value %></option>
                            <%
                                }
                            %>
                        </select>
                    </div>
                    <div class="user-status">
                        <select multiple="multiple" data-placeholder="All Status">
                            <%
                                foreach (var item in userStatuses)
                                {
                            %><option class="color-<%=item.EnumValue %>" value="<%=item.EnumValue %>"> <%=item.EnumText %></option>
                            <%
                                }
                            %>
                        </select>
                    </div>
                    <br />
                    <div class="user-designations" style="display: none;">
                        <select >
                            <option value="0">--All--</option>
                            <%
                                foreach (var item in userDesignations)
                                {
                            %><option value="<%=item.Id %>"><%=item.DesignationName %></option>
                            <%
                                }
                            %>
                        </select>
                    </div>
                    <div class="designationId">
                        <select multiple="multiple" data-placeholder="All Designations">
                            <%
                                foreach (var item in filterDesignations)
                                {
                            %><option value="<%=item.Id %>"><%=item.DesignationName %></option>
                            <%
                                }
                            %>
                        </select>
                    </div>
                </td>
                <td>
                    <div class="user-secondary-status">
                        <select multiple="multiple" data-placeholder="All Secondary Status">
                            <%
                                foreach (var item in userSecondaryStatuses)
                                {
                            %><option value="<%=item.EnumValue %>"><%=item.EnumText %></option>
                            <%
                                }
                            %>
                        </select>
                    </div>
                    <br />
                    <div class="saved-reports">
                        <select id="ddlSavedReports" onchange="searchUsers(this, false);">
                            <option value="LastLoginTimeStamp DESC">Last Login &darr;</option>
                            <option selected value="CreatedDateTime DESC">Created On &darr;</option>
                        </select>
                    </div>
                </td>
                <td>
                    <div class="addedBy">
                        <select multiple="multiple" data-placeholder="All Users">
                            <%
                                foreach (var item in userAddedBy)
                                {
                            %><option value="<%=item.UserId %>"><%=item.FormattedName %></option>
                            <%
                                }
                            %>
                        </select>
                    </div>
                    <br />
                    <div class="source">
                        <select multiple="multiple" data-placeholder="All Sources">
                            <%
                                foreach (var item in sources)
                                {
                            %><option value="<%=item.Id %>"><%=item.Source %></option>
                            <%
                                }
                            %>
                        </select>
                    </div>
                </td>
                <td class="search-duration">
                    <input type="radio" value="all" name="period" checked="checked" /><span>All</span>
                    <input type="radio" value="1y" name="period" /><span>1 Year</span>
                    <input type="radio" value="1q" name="period" /><span>Quarter (3 months)</span>
                    <input type="radio" value="1m" name="period" /><span>1 Month</span>
                    <input type="radio" value="2w" name="period" /><span>Two Weeks (Pay Period)</span>
                    <span>From :<span>*</span><input type="text" class="fromDate" value="All" />
                    </span>
                    <span>To :<span>*</span><input type="text" class="toDate" value="<%=DateTime.Now.ToShortDateString() %>" />
                    </span>
                    <div>
                        <div class="grid-overview-totalrecords"><span class="pageNumber"></span><span> to </span><span class="pazeSize"></span><span>of </span><span class="totalRecords"></span></div>
                        <div class="grid-overview-records-perpage">
                            Number of Records:
                            <select class="recordsPerPage">
                                <option value="10">10</option>
                                <option value="20">20</option>
                                <option value="25" selected="selected">25</option>
                                <option value="30">30</option>
                                <option value="40">40</option>
                                <option value="50">50</option>
                            </select>
                        </div>
                        <input type="text" class="userKeyword" />
                        <input type="button" value="Search" class="search-user" onclick="searchUsers(this, false)" />
                        <%--<input type="button" value="Deactivate Selected" class="deactivate-user" onclick="bulkDeactivateUsers(this)" />--%>
                    </div>
                </td>
            </tr>
            <%--<tr>
                <td colspan="3">
                    <div class="grid-overview-totalrecords"><span class="pageNumber"></span><span> to </span><span class="pazeSize"></span><span>of </span><span class="totalRecords"></span></div>
                    <div class="grid-overview-records-perpage">
                        Number of Records:
                        <select class="recordsPerPage">
                            <option value="10">10</option>
                            <option value="20">20</option>
                            <option value="25" selected="selected">25</option>
                            <option value="30">30</option>
                            <option value="40">40</option>
                            <option value="50">50</option>
                        </select>
                    </div>
                </td>
                <td>
                    <input type="text" class="userKeyword" />
                    <input type="button" value="Search" class="search-user" onclick="searchUsers(this)" />
                    <%--<input type="button" value="Deactivate Selected" class="deactivate-user" onclick="bulkDeactivateUsers(this)" />
                </td>
            </tr>--%>
        </tbody>
    </table>
    <table class="user-table">
        <thead>
            <tr>
                <td><span>Action<br />
                    Picture</span></td>
                <td><span>ID#<br />
                    Designation<br />
                    Fullname<br />
                    Salary Req
                    </span></td>
                <td><span>Primary Status</span><br />
                    <span>Secondary Status</span></td>
                <td><span>Source<br />
                    Added By<br />
                    Added On</span></td>
                <td><span>Email<br />
                    Phone Type - Phone</span></td>
                <td><span>Country-City-Zip<br />
                    Type-Apptitude Test %<br />
                    Resume</span></td>
                <td>
                    <div class="row">
                        <div>
                            UserID<br />
                            Date & Time
                        </div>
                        <div>
                            Note<br />
                            Status
                        </div>
                    </div>
                </td>
            </tr>
        </thead>
        <tbody id="SalesUserGrid">
            <tr seq="{{$index}}" ng-repeat="User in UserList.Data" class="{{User.StatusName}}" last-called-at="{{User.LastCalledAtFormatted}}" userid="{{User.Id}}" userinstallid="{{User.UserInstallId}}" code="{{User.PhoneCode}}" number="+{{User.PhoneCode}}{{User.Phone}}">
                <td>
                    <div class="profile-pic-container">
                        <input type="checkbox" value="{{User.Id}}" />
                        <img alt="No Picture" src="<%=baseUrl %>Employee/ProfilePictures/{{User.ProfilePic}}" />
                    </div>
                    <div><a href="/Sr_App/ViewSalesUser.aspx?id={{User.Id}}" target="_blank">Edit</a></div>
                    <div class="caller-position">
                        <input style="display:none;" onclick="SaveCallPosition(this)" title="Set Dialer Position Here" type="button" value="Set Here" />
                        <span style="display:none;" title="Current Seek Position">Current Seek Position</span>
                    </div>
                </td>
                <td>
                    <div><a target="_blank" href="<%=baseUrl %>Sr_App/ViewSalesUser.aspx?id={{User.Id}}">{{User.Id}}</a></div>
                    <div class="userDesignations" did="{{User.DesignationId}}" uid="{{User.Id}}"></div>
                    <div>{{User.FirstName}} {{User.LastName}}</div>
                    <div>
                        {{User.SalaryReq}} / Year {{User.CurrencyName}}
                    </div>
                </td>
                <td>
                    <div class="status" stid="{{User.Status}}" uid="{{User.Id}}"></div>
                    <div class="secondary-status" secid="{{User.SecondaryStatus}}" uid="{{User.Id}}">
                        <select onchange="setSecondaryStatus(this)">
                            <option value="0">--Select--</option>
                            <%
                                foreach (var item in userSecondaryStatuses)
                                {
                            %><option value="<%=item.EnumValue %>"><%=item.EnumText %></option>
                            <%
                                }
                            %>
                        </select>
                    </div>
                    <div class="reason">
                        <span>{{User.StatusReason}}</span>
                        <span>{{User.RejectDetail}}</span>
                        <span>{{User.RejectedByUserName}}</span>
                        <a ng-if="User.RejectedByUserInstallId != ''" href="/Sr_App/ViewSalesUser.aspx?id={{User.RejectedUserId}}">-{{User.RejectedByUserInstallId}}</a>
                        <span ng-if="User.InterviewDetail != ''" style="color: red">{{User.InterviewDetail}} (EST)</span>
                        <span></span>
                    </div>
                </td>
                <td>{{User.Source}}
                    <br />
                    {{User.AddedBy}}-<a target="_blank" href="<%=baseUrl %>Sr_App/ViewSalesUser.aspx?id={{User.Id}}">{{User.AddedByInstallId}}</a>
                    <br />
                    <span style="color: #ff0000;">{{User.AddedOnFormatted}}</span> (EST)
                </td>
                <td>
                    <div class="userEmails">
                        <%--<select>
                             <option email="{{User.Email}}" uid="{{User.Id}}" value="{{User.Email}}">
                                {{User.Email}}
                            </option>
                            <option email="{{UserEmail.Email}}" uid="{{User.Id}}" data-ng-repeat="UserEmail in UserList.QData | filter: {UserId:User.Id}" value="{{UserEmail.Email}}">
                                {{UserEmail.Email}}
                            </option>
                        </select>--%>
                        <div class="clickable-dropdown" uid="{{User.Id}}">
                            <div class="selected-item" value="{{User.Email}}">{{User.Email}}</div>
                            <div class="arrow-to-open"></div>
                            <ul class="options">
                                <li data-ng-repeat="UserEmail in UserList.QData | filter: {UserId:User.Id}" value="{{UserEmail.Email}}">{{UserEmail.Email}}</li>
                            </ul>
                        </div>
                    </div>
                    <div class="small userPhones">
                        <div class="clickable-dropdown" uid="{{User.Id}}">
                            <div class="selected-item" value="{{User.Phone}}">{{User.Phone}}</div>
                            <div class="arrow-to-open"></div>
                            <ul class="options">
                                <li data-ng-repeat="UserPhone in UserList.RData | filter: {UserId:User.Id}" value="{{UserPhone.Phone}}">{{UserPhone.Phone}}</li>
                            </ul>
                        </div>
                    </div>
                    <div class="social" uid="{{User.Id}}">
                        <div class="small phoneTypes"></div>
                        <input type="text" class="phone" placeholder="Select Type" />
                        <input type="checkbox" />
                        <input type="button" value="Add" onclick="AddSocial(this)" />
                    </div>
                </td>
                <td>
                    <div>
                        <span ng-if="User.Country != ''" class="flagbg {{User.Country | lowercase}}"></span>
                        <span>{{User.City}}-{{User.Zip}}</span>
                    </div>
                    <div emptype="{{User.JobType}}" class="employmentTypes" uid="{{User.Id}}"></div>
                    <div ng-if="User.Aggregate != null" class="percentage">
                        <span class="greentext" ng-if="User.Aggregate >= <%=JG_Prospect.Common.JGApplicationInfo.GetAcceptiblePrecentage() %>">{{User.Aggregate}}%</span>
                        <span class="redtext" ng-if="User.Aggregate < <%=JG_Prospect.Common.JGApplicationInfo.GetAcceptiblePrecentage() %>">{{User.Aggregate}}%</span>
                    </div>
                    <div class="resume">
                        <a title="{{User.ResumeFileDisplayName}}" target="_blank" href="<%=baseUrl %>Employee/Resume/{{User.ResumeFileSavedName}}">{{User.ResumeFileDisplayName}}</a>
                    </div>
                </td>
                <td>
                    <div class="notes-section">
                        <div class="notes-container" uid="{{User.Id}}" id="user-{{User.Id}}" installid="user-{{User.UserInstallId}}">
                            Loading Notes...
                        </div>
                        <div class="notes-inputs">
                            <div class="first-col">
                                <input type="button" class="GrdBtnAdd" value="Add Notes" onclick="addNotes(this)">
                            </div>
                            <div class="second-col">
                                <textarea class="note-text textbox" id="txt-{{User.Id}}" data-tribute="true"></textarea>
                            </div>
                        </div>
                    </div>
                </td>
            </tr>
        </tbody>
    </table>
    <div class="pagingWrapper">
        <div class="total-results">Total <span class="total-results-count"></span>Results</div>
        <div class="pager">
            <span class="first">« First</span> <span class="previous">Previous</span> <span class="numeric"></span><span class="next">Next</span> <span class="last">Last »</span>
        </div>
        <div class="pageInfo">
        </div>
    </div>
    <div class="action-row">
        <input type="button" value="Deactivate Selected" class="deactivate-user" onclick="deactivateSelected(this)" />
        <% if (IsManager)
            {
                %>
        <input type="button" value="Delete Selected" class="deactivate-user" onclick="deleteSelected(this)" />
                <%
            } %>
    </div>
</div>
<div id="DivOfferMade" class="white_content" style="height: auto;">
    <div class="title">Offer Made Details</div>
    <input type="hidden" class="userId" />
    <input type="hidden" class="status" />
    <div class="content">
        <div class="row">
            <div>Name:</div>
            <div class="fullname"></div>
            <div class="error"></div>
        </div>
        <div class="row">
            <div>Designation:</div>
            <div class="designation"></div>
            <div class="error"></div>
        </div>
        <div class="row">
            <div>Branch Location:</div>
            <div class="branchLocations"></div>
            <div class="error"></div>
        </div>
        <div class="row">
            <div>Email<span class="mandatory">*</span>:</div>
            <div class="email">
                <input type="text" />
            </div>
            <div class="error"></div>
        </div>
        <div class="row">
            <div>Password<span class="mandatory">*</span>:</div>
            <div class="password">
                <input type="password" />
            </div>
            <div class="error"></div>
        </div>
        <div class="row">
            <div>Confirm Password<span class="mandatory">*</span>:</div>
            <div class="cnf-password">
                <input type="password" />
            </div>
            <div class="error"></div>
        </div>
        <div class="row">
            <div class="full">
                <input type="button" value="Save" onclick="saveOfferMade(this)" />&nbsp;<input type="button" value="Cancel" class="grey" onclick="    closePopup()" />
            </div>
        </div>
    </div>
</div>
<div id="interviewDatelite" class="white_content" style="height: auto;">
    <div class="title">Interview Details</div>
    <input type="hidden" class="userId" />
    <input type="hidden" class="status" />
    <div class="content">
        <div class="row">
            <div>Name:</div>
            <div class="fullname"></div>
        </div>
        <div class="row">
            <div>Date:</div>
            <div class="date">
                <input type="text" />
            </div>
            <div class="error"></div>
        </div>
        <div class="row">
            <div>Time:</div>
            <div class="time">
                <select>
                    <option value="12:00 AM">12:00 AM</option>
                    <option value="12:30 AM">12:30 AM</option>
                    <option value="1:00 AM">1:00 AM</option>
                    <option value="1:30 AM">1:30 AM</option>
                    <option value="2:00 AM">2:00 AM</option>
                    <option value="2:30 AM">2:30 AM</option>
                    <option value="3:00 AM">3:00 AM</option>
                    <option value="3:30 AM">3:30 AM</option>
                    <option value="4:00 AM">4:00 AM</option>
                    <option value="4:30 AM">4:30 AM</option>
                    <option value="5:00 AM">5:00 AM</option>
                    <option value="5:30 AM">5:30 AM</option>
                    <option value="6:00 AM">6:00 AM</option>
                    <option value="6:30 AM">6:30 AM</option>
                    <option value="7:00 AM">7:00 AM</option>
                    <option value="7:30 AM">7:30 AM</option>
                    <option value="8:00 AM">8:00 AM</option>
                    <option value="8:30 AM">8:30 AM</option>
                    <option value="9:00 AM">9:00 AM</option>
                    <option value="9:30 AM">9:30 AM</option>
                    <option selected="selected" value="10:00 AM">10:00 AM</option>
                    <option value="10:30 AM">10:30 AM</option>
                    <option value="11:00 AM">11:00 AM</option>
                    <option value="11:30 AM">11:30 AM</option>
                    <option value="12:00 PM">12:00 PM</option>
                    <option value="12:30 PM">12:30 PM</option>
                    <option value="1:00 PM">1:00 PM</option>
                    <option value="1:30 PM">1:30 PM</option>
                    <option value="2:00 PM">2:00 PM</option>
                    <option value="2:30 PM">2:30 PM</option>
                    <option value="3:00 PM">3:00 PM</option>
                    <option value="3:30 PM">3:30 PM</option>
                    <option value="4:00 PM">4:00 PM</option>
                    <option value="4:30 PM">4:30 PM</option>
                    <option value="5:00 PM">5:00 PM</option>
                    <option value="5:30 PM">5:30 PM</option>
                    <option value="6:00 PM">6:00 PM</option>
                    <option value="6:30 PM">6:30 PM</option>
                    <option value="7:00 PM">7:00 PM</option>
                    <option value="7:30 PM">7:30 PM</option>
                    <option value="8:00 PM">8:00 PM</option>
                    <option value="8:30 PM">8:30 PM</option>
                    <option value="9:00 PM">9:00 PM</option>
                    <option value="9:30 PM">9:30 PM</option>
                    <option value="10:00 PM">10:00 PM</option>
                    <option value="10:30 PM">10:30 PM</option>
                    <option value="11:00 PM">11:00 PM</option>
                    <option value="11:30 PM">11:30 PM</option>
                </select>
            </div>
            <div class="error"></div>
        </div>
        <div class="row">
            <div>Recruiter:</div>
            <div class="recruiter"></div>
            <div class="error"></div>
        </div>
        <div class="row">
            <div>Designation:</div>
            <div class="designation"></div>
            <div class="error"></div>
        </div>
        <div class="row">
            <div>Task:</div>
            <div class="task"></div>
            <div class="error"></div>
        </div>
        <div class="row">
            <div>Sub Task:</div>
            <div class="sub-task">
                <select>
                    <option value="0">--Select--</option>
                </select>
            </div>
            <div class="error"></div>
        </div>
        <div class="row">
            <div class="full">
                <input type="button" value="Save" onclick="ChangeUserStatusToInterviewDate(this)" />&nbsp;<input type="button" value="Cancel" class="grey" onclick="    closePopup()" />
            </div>
        </div>
    </div>
</div>
<div id="light" class="white_content">
    <div class="title">Reason</div>
    <input type="hidden" class="userId" />
    <input type="hidden" class="status" />
    <div class="content">
        <div class="row">
            <div>Reason:</div>  
            <div class="reason">
                <textarea></textarea>
            </div>
            <div class="error"></div>
        </div>
        <div class="row">
            <div class="full">
                <input type="button" value="Save" onclick="saveWithReason(this)" />&nbsp;<input type="button" value="Cancel" class="grey" onclick="    closePopup()" />
            </div>
        </div>
    </div>
</div>
<div id="reminerEmail" class="white_content">
    <div class="title">Send Email</div>
    <input type="hidden" class="userId" value="{{ReminderEmailContent.Object.UserId}}" />
    <div class="content">
        <div class="row">
            <div class="email">
                Email: {{ReminderEmailContent.Object.Email}}
            </div>
            <div class="error"></div>
        </div>
        <div class="row">
            <div class="subject">
                Subject: {{ReminderEmailContent.Object.Subject}}
            </div>
            <div class="error"></div>
        </div>
        <div class="row">
            <div class="body">
                <textarea id="reminderEmailBody" style="height: 600px;">
                    {{ReminderEmailContent.Object.Body}}
                </textarea>
            </div>
            <div class="error"></div>
        </div>
        <div class="row">
            <div class="custom">
                <input type="text" placeholder="Custom Message" value="{{ReminderEmailContent.Object.CustomMessage}}" />
            </div>
            <div class="error"></div>
        </div>
        <div class="row">
            <div class="full">
                <input type="button" value="Send" onclick="sendReminerEmail(this)" />&nbsp;<input type="button" value="Cancel" class="grey" onclick="    closePopup()" />
            </div>
        </div>
    </div>
</div>
<script type="text/javascript">
    
    $('.userlist-grid .header-table select').chosen({ width: '100%' });
    paging.currentPage = 0;
    var Users;
    function searchUsers(sender, FirstTimeOpen) {
        paging.currentPage = 0;
        Paging(sender, FirstTimeOpen, false);
    }

    function deleteSelected(sender){
        var userIds = [];
        $('#SalesUserGrid .profile-pic-container > input[type="checkbox"]:checked').each(function () {
            userIds.push($(this).val());
        });
        if (userIds.length <= 0) {
            alert('Please select at least one user to delete.');
            return false;
        }
        ajaxExt({
            url: '/WebServices/JGWebService.asmx/DeleteSelected',
            type: 'POST',
            data: '{userIds:"' + userIds + '"}',
            showThrobber: true,
            throbberPosition: { my: "left center", at: "right center", of: $(sender), offset: "5 0" },
            success: function (data, msg) {
                $('.search-user').trigger('click');
            },
            error: function (data, msg) {
                alert(msg);
            }
        });
    }

    function deactivateSelected(sender) {
        var userIds = [];
        $('#SalesUserGrid .profile-pic-container > input[type="checkbox"]:checked').each(function () {
            userIds.push($(this).val());
        });
        if (userIds.length <= 0) {
            alert('Please select at least one user to deactivate.');
            return false;
        }
        ajaxExt({
            url: '/WebServices/JGWebService.asmx/bulkDeactivateUsers',
            type: 'POST',
            data: '{userIds:"' + userIds + '"}',
            showThrobber: true,
            throbberPosition: { my: "left center", at: "right center", of: $(sender), offset: "5 0" },
            success: function (data, msg) {
                console.log('bulkDeactivateUsers');
                $('.search-user').trigger('click');
            },
            error: function (data, msg) {
                alert(msg);
            }
        });
    }

    function Paging(sender, FirstTimeOpen, restartAutoDialer) {
        sequenceScopePhone.Paging(sender, FirstTimeOpen, restartAutoDialer);
    }
    function AddSocial(sender) {
        var type = $(sender).parents('.social').find('select').val();
        var phone = $(sender).parents('.social').find('input.phone').val().trim();
        var primary = $(sender).parents('.social').find('input[type="checkbox"]').is(':checked');
        var uid = $(sender).parents('.social').attr('uid');
        if (type == '' || type == '0')
            return false;
        if (phone == '')
            return false;
        ajaxExt({
            url: '/WebServices/JGWebService.asmx/AddSocial',
            type: 'POST',
            data: '{userId:' + uid + ',type:' + type + ',phone:"' + phone + '",primary:' + primary + '}',
            showThrobber: true,
            throbberPosition: { my: "left center", at: "right center", of: $(sender), offset: "5 0" },
            success: function (data, msg) {
                LoadNotes($('#user-'+uid), uid);
            },
            error: function (data, msg) {
                alert(msg);
            }
        })
    }
    function setWatermark(sender) {
        var text = $(sender).find('option:selected').text();
        var value = $(sender).find('option:selected').val();
        if (value == '0')
            $(sender).parents('.social').find('input.phone').attr('placeholder', 'Select Type');
        else
            $(sender).parents('.social').find('input.phone').attr('placeholder', text);
    }
    function ChangeDesignation(sender) {
        var uid = $(sender).parents('.userDesignations').attr('uid');
        var did = $(sender).find('option:selected').val();
        ajaxExt({
            url: '/WebServices/JGWebService.asmx/ChangeUserDesignation',
            type: 'POST',
            data: '{userId:' + uid + ',designationId:' + did + '}',
            showThrobber: true,
            throbberPosition: { my: "left center", at: "right center", of: $(sender).parents('.userDesignations').find('.chosen-container'), offset: "5 0" },
            success: function (data, msg) {
                LoadNotes($('#user-'+uid), uid);
            },
            error: function (data, msg) {
                alert(msg);
            }
        })
    }
    function setSecondaryStatus(sender) {
        var newStatus = $(sender).find('option:selected').val();
        var uid = $(sender).parents('.secondary-status').attr('uid');
        ajaxExt({
            url: '/WebServices/JGWebService.asmx/UpdateSecondaryStatus',
            type: 'POST',
            data: '{userId:' + uid + ',newStatus:' + newStatus + '}',
            showThrobber: true,
            throbberPosition: { my: "left center", at: "right center", of: $(sender).parents('.secondary-status').find('.chosen-container'), offset: "5 0" },
            success: function (data, msg) {
                LoadNotes($('#user-'+uid), uid);
            },
            error: function (data, msg) {
                alert(msg);
            }
        });
    }
    var branches = [];
    function ChangeUserStatus(sender) {
        var oldStatus = $(sender).parents('.status').attr('stid');
        var uid = $(sender).parents('.status').attr('uid');
        var newStatus = $(sender).find('option:selected').val();
        ajaxExt({
            url: '/WebServices/JGWebService.asmx/ChangeUserStatus',
            type: 'POST',
            data: '{userId:' + uid + ',newStatus:' + newStatus + ',oldStatus:' + oldStatus + '}',
            showThrobber: true,
            throbberPosition: { my: "left center", at: "right center", of: $(sender).parents('.status').find('.chosen-container'), offset: "5 0" },
            success: function (data, msg) {
                if (data.Object != '' && data.Object != undefined) {
                    branches = data.Results;
                    window[data.Object](data.Message);
                } else {
                    LoadNotes($('#user-'+uid), uid);
                }
            },
            error: function (data, msg) {
                alert(msg);
            }
        });
    }
    function RecenterPopup() {
        // Calculate Center
        var sW = $(window).width();
        var pW = $('.white_content').width();
        var sH = $(window).height();
        var pH = $('.white_content').height();
        $('.white_content').css({ 'left': ((sW / 2) - (pW / 2)) + 'px', 'top': ((sH / 2) - (pH / 2)) + 'px' });
    }
    function OverlayPopupOfferMade(str) {
        var items = str.split(',');
        $('#DivOfferMade').show();
        $('.overlay').show();
        RecenterPopup();
        $('#DivOfferMade').find('.userId').val(items[0]);
        $('#DivOfferMade').find('.status').val(items[1]);
        $('#DivOfferMade').find('.fullname').html(items[3]);
        $('#DivOfferMade').find('.designation').html(items[4]);
        $('#DivOfferMade').find('.email input').val(items[5]);
        $('#DivOfferMade').find('.password input').val(items[6]);
        $('#DivOfferMade').find('.cnf-password input').val(items[6]);
        var json = JSON.parse(branches[0]);
        var str = '<select class="branches">';
        $.each(json, function (i) {
            str += '<option value="' + json[i].Id + '">' + json[i].BranchLocationTitle + '</option>';
        });
        str += '</select>';
        $('#DivOfferMade').find('.branchLocations').html(str);
    }
    function overlayInterviewDate(str) {
        var items = str.split(',');
        $('#interviewDatelite').find('.userId').val(items[0]);
        $('#interviewDatelite').find('.status').val(items[1]);
        $('#interviewDatelite').find('.fullname').html(items[3]);
        $('#interviewDatelite').find('.designation').html(items[4]);
        var did = items[7];
        $('#interviewDatelite').show();
        $('.overlay').show();
        RecenterPopup();
        $('#interviewDatelite').find('.date input').datepicker({ minDate: 0, maxDate: "+1M +10D" });
        // Fill Tech Task
        ajaxExt({
            url: '/WebServices/JGWebService.asmx/GetTechTasks',
            type: 'POST',
            data: '{designationId:' + did + '}',
            showThrobber: true,
            throbberPosition: { my: "left center", at: "right center", of: $('.task'), offset: "5 0" },
            success: function (data, msg) {
                var str = '<select onchange="getSubTechTasks(this)"><option value="0">--Select--</option>'
                if (data.Results != null && data.Results != undefined && data.Results != '') {
                    $.each(data.Results, function (i) {
                        str += '<option value="' + data.Results[i].Id + '">' + data.Results[i].Title + '</option>';
                    });
                    str += '</select>';
                }
                $('#interviewDatelite').find('.task').html(str);
                $('#interviewDatelite').find('.task select').chosen({ width: '100%' });
            }
        });
        // Fill Recruiters
        ajaxExt({
            url: '/WebServices/JGWebService.asmx/GetRecruiters',
            type: 'POST',
            data: '{designationId:' + did + '}',
            showThrobber: true,
            throbberPosition: { my: "left center", at: "right center", of: $('.recruiter'), offset: "5 0" },
            success: function (data, msg) {
                var str = '<select><option value="0">--Select--</option>'
                if (data.Results != null && data.Results != undefined && data.Results != '') {
                    $.each(data.Results, function (i) {
                        str += '<option class="' + data.Results[i].optionCss + '" value="' + data.Results[i].Id + '">' + data.Results[i].Name + '</option>';
                    });
                    str += '</select>';
                }
                $('#interviewDatelite').find('.recruiter').html(str);
                $('#interviewDatelite').find('.recruiter select').chosen({ width: '100%' });
            }
        });
        // Fill Designations
        var dstr = '', options = '';
        options = $('.userlist-grid .header-table .user-designations').find('select').html();
        dstr = '<select class="" onchange="getTasks(this)">' + options + '</select>';
        $('#interviewDatelite').find('.designation').html(dstr);
        $('#interviewDatelite').find('.designation').find('select').val(did);
        $('#interviewDatelite').find('.designation select').chosen({ width: '100%' });
        $('#interviewDatelite').find('.time select').chosen({ width: '100%' });
        $('#interviewDatelite').find('.sub-task select').chosen({ width: '100%' });
    }
    function getTasks(sender) {
        // Fill Tech Task
        ajaxExt({
            url: '/WebServices/JGWebService.asmx/GetSubTechTasks',
            type: 'POST',
            data: '{taskId:' + $(sender).find('option:selected').val() + '}',
            showThrobber: true,
            throbberPosition: { my: "left center", at: "right center", of: $('.task'), offset: "5 0" },
            success: function (data, msg) {
                var str = '<select><option value="0">--Select--</option>'
                if (data.Results != null && data.Results != undefined && data.Results != '') {
                    $.each(data.Results, function (i) {
                        str += '<option value="' + data.Results[i].Id + '">' + data.Results[i].Title + '</option>';
                    });
                    str += '</select>';
                }
                $('#interviewDatelite').find('.sub-task').html(str);
                $('#interviewDatelite').find('.sub-task select').chosen({ width: '100%' });
            }
        });
    }
    function getSubTechTasks(sender) {
        // Fill Sub Tech Task
        ajaxExt({
            url: '/WebServices/JGWebService.asmx/GetSubTechTasks',
            type: 'POST',
            data: '{taskId:' + $(sender).find('option:selected').val() + '}',
            showThrobber: true,
            throbberPosition: { my: "left center", at: "right center", of: $('.task'), offset: "5 0" },
            success: function (data, msg) {
                var str = '<select><option value="0">--Select--</option>'
                if (data.Results != null && data.Results != undefined && data.Results != '') {
                    $.each(data.Results, function (i) {
                        str += '<option value="' + data.Results[i].Id + '">' + data.Results[i].Title + '</option>';
                    });
                    str += '</select>';
                }
                $('#interviewDatelite').find('.sub-task').html(str);
                $('#interviewDatelite').find('.sub-task select').chosen({ width: '100%' });
            }
        });
    }
    function overlay(str) {
        var items = str.split(',');
        $('#light').find('.userId').val(items[0]);
        $('#light').find('.status').val(items[1]);
        $('#light').show();
        $('.overlay').show();
        RecenterPopup();
    }
    function closePopup() {
        $('.white_content').hide();
        $('.overlay').hide();
    }
    function saveOfferMade(sender) {
        var uid = $(sender).parents('.white_content').find('.userId').val();
        var status = $(sender).parents('.white_content').find('.status').val();
        var email = $(sender).parents('.white_content').find('.email input').val();
        var password = $(sender).parents('.white_content').find('.password input').val();
        var bid = $(sender).parents('.white_content').find('.branchLocations select').find('option:selected').val();
        var cnfPassword = $(sender).parents('.white_content').find('.cnf-password input').val();
        if (validateControls(sender) == false)
            return false;
        if (password != cnfPassword) {
            $(sender).parents('.white_content').find('.cnf-password').parents('.row').find('div.error').html('Required');
            return false;
        } else {
            $(sender).parents('.white_content').find('.cnf-password').parents('.row').find('div.error').html('');
        }
        ajaxExt({
            url: '/WebServices/JGWebService.asmx/ChangeUserStatusOfferMade',
            type: 'POST',
            data: '{userId:' + uid + ',newStatus:' + status + ',newEmail:"' + email + '",password:"' + password + '",branchLocationId:' + bid + '}',
            showThrobber: true,
            throbberPosition: { my: "left center", at: "right center", of: $(sender), offset: "5 0" },
            success: function (data, msg) {
                LoadNotes($('#user-'+uid), uid);
                closePopup();
            },
            error: function (data, msg) {
                alert(msg);
            }
        })
    }

    function updateEmpType(sender) {
        var uid = $(sender).parents('.employmentTypes').attr('uid');
        var empType = $(sender).find('option:selected').val();
        ajaxExt({
            url: '/WebServices/JGWebService.asmx/UpdateEmpType',
            type: 'POST',
            data: '{userId:' + uid + ',empType:' + empType + '}',
            showThrobber: true,
            throbberPosition: { my: "left center", at: "right center", of: $(sender).parents('.employmentTypes').find('.chosen-container'), offset: "5 0" },
            success: function (data, msg) {
                LoadNotes($('#user-'+uid), uid);
            },
            error: function (data, msg) {
                alert(msg);
            }
        });
    }

    function saveWithReason(sender) {
        var uid = $(sender).parents('.white_content').find('.userId').val();
        var status = $(sender).parents('.white_content').find('.status').val();
        var reason = $(sender).parents('.white_content').find('.reason textarea').val();
        if (validateControls(sender) == false)
            return false;
        ajaxExt({
            url: '/WebServices/JGWebService.asmx/ChangeUserStatusWithReason',
            type: 'POST',
            data: '{userId:' + uid + ',newStatus:' + status + ',reason:"' + reason + '"}',
            showThrobber: true,
            throbberPosition: { my: "left center", at: "right center", of: $(sender), offset: "5 0" },
            success: function (data, msg) {
                LoadNotes($('#user-'+uid), uid);
                closePopup();
            },
            error: function (data, msg) {
                alert(msg);
            }
        });
    }

    function validateControls(sender) {
        var flag = 0;
        $(sender).parents('.content').find('.row').each(function () {
            var value = '';
            if ($(this).find('select').length > 0) {
                value = $(this).find('select').find('option:selected').val();
                if (value == '0' || value == '') {
                    flag = 1;
                    $(this).find('div.error').html('Required');
                } else {
                    $(this).find('div.error').html('');
                }
            } else if ($(this).find('input[type="text"]').length > 0) {
                value = $(this).find('input[type="text"]').val().trim();
                if (value == '') {
                    flag = 1;
                    $(this).find('div.error').html('Required');
                } else {
                    $(this).find('div.error').html('');
                }
            } else if ($(this).find('input[type="password"]').length > 0) {
                value = $(this).find('input[type="password"]').val().trim();
                if (value == '') {
                    flag = 1;
                    $(this).find('div.error').html('Required');
                } else {
                    $(this).find('div.error').html('');
                }
            } else if ($(this).find('textarea').length > 0) {
                value = $(this).find('textarea').val().trim();
                if (value == '') {
                    flag = 1;
                    $(this).find('div.error').html('Required');
                } else {
                    $(this).find('div.error').html('');
                }
            }
        });
        if (flag == 1) {
            return false;
        }
        else {
            return true;
        }
    }

    function ChangeUserStatusToInterviewDate(sender) {
        var uid = $(sender).parents('.white_content').find('.userId').val();
        var status = $(sender).parents('.white_content').find('.status').val();
        var date = $(sender).parents('.white_content').find('.date input[type="text"]').val();
        var time = $(sender).parents('.white_content').find('.time select').find('option:selected').val();
        var recruiterId = $(sender).parents('.white_content').find('.recruiter select').find('option:selected').val();
        var taskId = $(sender).parents('.white_content').find('.task select').find('option:selected').val();
        var subTaskId = $(sender).parents('.white_content').find('.sub-task select').find('option:selected').val();
        var recruiterName = $(sender).parents('.white_content').find('.recruiter select').find('option:selected').text();
        var taskName = $(sender).parents('.white_content').find('.task select').find('option:selected').val();
        var designationId = $(sender).parents('.white_content').find('.designation select').find('option:selected').val();
        var designationName = $(sender).parents('.white_content').find('.designation select').find('option:selected').text();

        if (validateControls(sender) == false)
            return false;
        ajaxExt({
            url: '/WebServices/JGWebService.asmx/ChangeUserStatusToInterviewDate',
            type: 'POST',
            data: '{date:"' + date + '",status:' + status + ',userId:' + uid + ',time:"' + time + '",recruiterId:' + recruiterId + ',taskId:' + taskId + ',subTaskId:' + subTaskId + ',recruiterName:"' + recruiterName + '",taskName:"' + taskName + '",designationId:' + designationId + ',designationName:"' + designationName + '"}',
            showThrobber: true,
            throbberPosition: { my: "left center", at: "right center", of: $(sender), offset: "5 0" },
            success: function (data, msg) {
                LoadNotes($('#user-'+uid), uid);
                closePopup();
                //window.location.href = '/Sr_App/GoogleCalendarView.aspx';
            },
            error: function (data, msg) {
                alert(msg);
            }
        })
    }

    function ReLoadNotes() {
        $('.notes-container').each(function (i) {
            if ($(this).attr('id') != undefined && $(this).attr('id') != '' && $(this).attr('id') != null) {
                var uid = $(this).attr('uid');
                LoadNotes($('#user-' + uid), uid);
            }
        });
    }

    function LoadNotes(sender, userid) {
        ajaxExt({
            url: '/Sr_App/edituser.aspx/GetUserTouchPointLogs',
            type: 'POST',
            data: '{ pageNumber: 1, pageSize: 5, userId: ' + userid + ',chatSourceId:<%=(int)JG_Prospect.Common.ChatSource.EditUserPage%> }',
            showThrobber: true,
            throbberPosition: { my: "left center", at: "right center", of: $('#user-' + userid), offset: "5 0" },
            success: function (data, msg) {
                var unreadCount = 0;
                var ReceiverIds = data.Message.split(':')[0];
                var UserChatGroupId = data.Message.split(':')[1];
                var ChatGroupId = data.Message.split(':')[2];
                var chatSourceId = data.Message.split(':')[3];
                if (data.Data.length > 0) {
                    var tbl = '<table chatsource="' + chatSourceId + '" class="notes-table" cellspacing="0" cellpadding="0" receiverIds="' + ReceiverIds + '" userChatGroupId="' + UserChatGroupId + '" chatGroupId="' + ChatGroupId + '">';
                    $(data.Data).each(function (i) {
                        if (data.Data[i].IsRead == '0') {
                            unreadCount += 1;
                        }
                        tbl += '<tr uid="' + data.Data[i].UserID + '" id="' + data.Data[i].UserTouchPointLogID + '">' +
                                    '<td>' + data.Data[i].SourceUsername + '- <a target="_blank" href="/Sr_App/ViewSalesUser.aspx?id=' + data.Data[i].UpdatedByUserID + '">' + data.Data[i].SourceUserInstallId + '</a><br/>' + data.Data[i].ChangeDateTimeFormatted + '</td>' +
                                    '<td><div class="note-desc">' + data.Data[i].LogDescription + '</div></td>' +
                                '</tr>';
                    });
                    tbl += '</table>';
                    var tdHeight = $('#user-' + userid).parents('tr').height();
                    $('#user-' + userid).html(tbl);

                    $('#user-' + userid).css('height', (tdHeight - 36) + 'px');
                    var tuid = getUrlVars()["TUID"];
                    var nid = getUrlVars()["NID"];
                    if (tuid != undefined && nid != undefined) {
                        $('.notes-table tr#' + nid).addClass('blink-notes');
                    } else {

                    }
                    //tribute.attach(document.querySelectorAll('.note-text'));
                    tribute.attach(document.getElementById('txt-' + userid));
                } else {
                    var tbl = '<table class="notes-table" cellspacing="0" cellpadding="0" receiverIds="' + ReceiverIds + '" userChatGroupId="' + ChatGroupId + '" chatGroupId="' + ChatGroupId + '">' +
                                '<tr uid="' + userid + '"><td>&nbsp;</td><td>&nbsp;</td></tr>' +
                                '<tr uid="' + userid + '"><td>&nbsp;</td><td>&nbsp;</td></tr>' +
                                '<tr uid="' + userid + '"><td>&nbsp;</td><td>&nbsp;</td></tr>' +
                               '</table>';
                    $('#user-' + userid).html(tbl);
                    tribute.attach(document.getElementById('txt-' + userid));
                }
                if (unreadCount > 0) {
                    $('#user-' + userid).parents('.notes-section').prepend('<span class="unread-chat-count">' + unreadCount + '</span>');
                } else {
                    $('#user-' + userid).parents('.notes-section').find('span.unread-chat-count').remove();
                }
            }
        });
    }

    function addNotes(sender) {
        var uid = $(sender).parents('td').find('.notes-container').attr('uid');
        var installId = $(sender).parents('td').find('.notes-container').attr('id').substring(5);
        var note = $(sender).parents('.notes-inputs').find('.note-text').val();

        var chatSource = $(sender).parents('td').find('.notes-table').attr('chatsource');
        var chatGroupId = $(sender).parents('td').find('.notes-table').attr('chatgroupid');
        var userchatgroupid = $(sender).parents('td').find('.notes-table').attr('userchatgroupid');
        if(chatSource==undefined || chatSource==null){
                chatSource=<%=(int)JG_Prospect.Common.ChatSource.EditUserPage%>;
            }
            if(userchatgroupid==undefined || userchatgroupid==null || userchatgroupid==''){
                userchatgroupid=0;
            }
        if (note != '')
            ajaxExt({
                url: '/Sr_App/edituser.aspx/AddNotes',
                type: 'POST',
                data: '{ id: ' + uid + ', note: "' + note + '", touchPointSource: ' + chatSource + ', chatGroupId:"'+chatGroupId+'",UserChatGroupId:'+userchatgroupid+' }',
                showThrobber: true,
                throbberPosition: { my: "left center", at: "right center", of: $(sender), offset: "5 0" },
                success: function (data, msg) {
                    $(sender).parents('.notes-inputs').find('.note-text').val('');
                    //Paging(sender);

                    LoadNotes(sender, uid);
                }
            });
    }
    $(document).on('click', '.notes-table tr', function (e) {
        if (!$(e.target).is('a')) {
            var chatgroupid = $(this).parents('.notes-table').attr('chatgroupid');
            var receiverids = $(this).parents('.notes-table').attr('receiverids');
            var userchatgroupid = $(this).parents('.notes-table').attr('userchatgroupid');
            InitiateChat(this, receiverids, chatgroupid, '<%=(int)JG_Prospect.Common.ChatSource.EditUserPage%>', 0, 0, userchatgroupid);
                }
        });

            $(document).on('click', '.search-duration input[type="radio"]', function (e) {
                var period = $(this).val();
                switch (period) {
                    case 'all':
                        $('input.fromDate').val('all');
                        break;
                    case '1y':
                        $('input.fromDate').val('<%= DateTime.Now.AddYears(-1).AddDays(-1).ToShortDateString() %>');
                        break;
                    case '1q':
                        $('input.fromDate').val('<%= DateTime.Now.AddMonths(-3).AddDays(-1).ToShortDateString() %>');
                        break;
                    case '1m':
                        $('input.fromDate').val('<%= DateTime.Now.AddMonths(-1).ToShortDateString() %>');
                        break;
                    case '2w':
                        $('input.fromDate').val('<%= DateTime.Now.AddDays(-15).ToShortDateString() %>');
                        break;
                }
                $('input.toDate').val('<%= DateTime.Now.ToShortDateString() %>');
            });
    $(function () {
        var dateFormat = "mm/dd/yy",
          from = $("input.fromDate")
            .datepicker({
                defaultDate: "+1w",
                changeMonth: true,
                numberOfMonths: 1
            })
            .on("change", function () {
                to.datepicker("option", "minDate", getDate(this));
            }),
          to = $("input.toDate").datepicker({
              defaultDate: "+1w",
              changeMonth: true,
              numberOfMonths: 1
          })
          .on("change", function () {
              from.datepicker("option", "maxDate", getDate(this));
          });

        function getDate(element) {
            var date;
            try {
                date = $.datepicker.parseDate(dateFormat, element.value);
            } catch (error) {
                date = null;
            }

            return date;
        }
    });
    function sendReminerEmail(sender) {
        var body = GetCKEditorContent('reminderEmailBody').replace(/"/g, '\\"');
        var uid = $('#reminerEmail').find('.userId').val();
        var subject = $('#reminerEmail').find('.subject').html();
        var customMsg = $('#reminerEmail').find('.custom input').val().replace(/"/g, '\\"');
        ajaxExt({
            url: '/WebServices/JGWebService.asmx/SendReminderEmailContent',
            type: 'POST',
            data: '{ userId: ' + uid + ', subject: "' + subject + '", body:"' + body + '",customMessage:"' + customMsg + '" }',
            showThrobber: true,
            throbberPosition: { my: "left center", at: "right center", of: $(sender), offset: "5 0" },
            success: function (data, msg) {
                $('#reminerEmail .content').find('.full').append('<span class="green">Email has been sent.</span>');
                setTimeout(function () {
                    $('.white_content').hide();
                    $('.overlay').hide();
                    $('#reminerEmail .content').find('.full > .green').remove();
                }, 3000);
            },
            error: function (data, msg) {
                alert(msg);
            }
        });
    }
    $(document).on('keyup', '.userKeyword', function () {
        console.log('keyup userKeyword');
        $('.search-user').trigger('click');
    });
    $(document).on('change', '.recordsPerPage', function () {
        console.log('change recordsPerPage');
        $('.search-user').trigger('click');
    });
    //var selectedStatus = [];
    
    $(document).on('change', '.header-table select', function () {
        var allStatus = [];
        var attr = $(this).attr('multiple');
        var $select = $(this);
        if (typeof attr !== typeof undefined && attr !== false) {
            var seletedValues = $($select).val();
            var lastValue = '-1';
            var lastIndex = -1;
            var lastClass = '';
            $(seletedValues).each(function(i){
                if(seletedValues[i] == '' && seletedValues.length > 0){
                    var index = seletedValues.indexOf(seletedValues[i]);
                    if (index > -1) {
                        seletedValues.splice(index, 1);
                    }
                }else if(seletedValues.length <= 0) {                
                    seletedValues.push('');
                }
            });
            $($select).val(seletedValues);
            $($select).trigger("chosen:updated");
            $($select).find('option').each(function(i){
                var curValue = $(this).val();
                if(curValue != null && curValue != undefined){
                    if(seletedValues != '' && seletedValues != null){
                        if(seletedValues.indexOf(curValue) >= 0){
                            allStatus.push({index: i, cls: $(this).attr('class'), stValue: $(this).val()});
                        }
                    }
                }
            });
            $(allStatus).each(function(i){
                $($select).parent().find('.chosen-choices .search-choice a[data-option-array-index="' + allStatus[i].index + '"]').parents('li.search-choice').addClass(allStatus[i].cls);
            });
        }
        $('.search-user').trigger('click');
    });
    
    $(document).on('change', '#SalesUserGrid select', function () {
        var $select = $(this);
        var selectedClass = $($select).find('option:selected').attr('class');
        var selectedIndex = $($select).prop('selectedIndex');
        var attr = $(this).attr('multiple');
        if(typeof attr == typeof undefined || attr == false){
            if(selectedClass!=null && selectedClass != '' && selectedClass != undefined) {
                var $anchor = $($select).parent().find('a.chosen-single');
                $($anchor).removeAttr('class');
                $($anchor).addClass('chosen-single');
                $($anchor).addClass(selectedClass);
            }}
    });

    $(document).on('mousedown', '.userPhones .clickable-dropdown .selected-item', function (e) {
        if (e.button == 2) {
            e.preventDefault();
            var text = $(this).html().trim();
            var $temp = $("<input>");
            $("body").append($temp);
            $temp.val(text).select();
            document.execCommand("copy");
            $temp.remove();
            // 
            var msg = '<div class="global-msg">Number copied.</div>';
            $('.global-msg').remove();
            $('body').append(msg);
            setTimeout(function () {
               $('.global-msg').remove();
            }, 3000);            
            return false;
        } else if (e.button == 0) {
            if (window.location.href.toLowerCase().indexOf('autodialer.aspx') > 1) {
                SetCountryCode($(this).parents('tr').attr('code'));
                $('#phone #toNumber').val(/*$(this).parents('tr').attr('code') + */$(this).html().trim());
                console.log('userPhones .clickable-dropdown .selected-item');
                $('#phone #makecall').trigger('click');
                $('html, body').animate({
                    scrollTop: $("#phone").offset().top
                }, 2000);
            }
        }
        return true;
    });
    $(document).on('mousedown', '.userEmails .clickable-dropdown .selected-item', function (e) {
        if (e.button == 2) {
            e.preventDefault();
            var text = $(this).html().trim();
            var $temp = $("<input>");
            $("body").append($temp);
            $temp.val(text).select();
            document.execCommand("copy");
            $temp.remove();
            // 
            var msg = '<div class="global-msg">Email copied.</div>';
            $('.global-msg').remove();
            $('body').append(msg);
            setTimeout(function () {
                $('.global-msg').remove();
            }, 3000);
            return false;
        } else if (e.button == 0) {
            sequenceScopePhone.GetReminderEmailContent(this);
        }
        return true;
    });

    var removeByAttr = function(arr, attr, value){
        var i = arr.length;
        while(i--){
            if( arr[i] 
                && arr[i].hasOwnProperty(attr) 
                && (arguments.length > 2 && arr[i][attr] === value ) ){ 

                arr.splice(i,1);

            }
        }
        return arr;
    }
</script>
