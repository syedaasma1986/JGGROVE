<%@ Control Language="C#" AutoEventWireup="true" CodeBehind="ucSubTasks.ascx.cs" Inherits="JG_Prospect.Sr_App.Controls.ucSubTasks" %>

<%@ Register TagPrefix="asp" Namespace="Saplin.Controls" Assembly="DropDownCheckBoxes" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<%@ Register Src="~/Controls/CustomPager.ascx" TagPrefix="uc" TagName="CustomPager" %>

<link rel="stylesheet" type="text/css" href="../css/lightslider.css">
<link rel="stylesheet" type="text/css" href="../Content/ui-grid.css">
<script type="text/javascript" src="../js/jquery.magnific-popup.min.js"></script>

<script type="text/javascript" src="../js/lightslider.js"></script>
<script type="text/javascript" src="../js/jg-common.js"></script>

<style type="text/css">
    .notes-section {
            width: 100%;
        }
         .notes-popup {
            width: 100%;
            background: #fff;
            border-radius: 5px;
            border: 1px solid #aaa;
        }

        .notes-popup-background {
            display: none;
            height: 100%;
            width: 100%;
            position: fixed;
            top: 0;
            left: 0;
            z-index: 10;
            background: #000;
            opacity: 0.5;
        }

        .notes-popup .heading {
            width: 100%;
            display: inline-block;
            background: #A33E3F;
            color: #fff;
            padding: 5px 0;
            border-radius: 5px 5px 0 0;
        }

            .notes-popup .heading .title {
                padding: 0 5px;
                float: left;
            }

        .notes-popup .content {
            padding: 0px;
        }

        .notes-popup .heading .close {
            float: right;
            top: -11px;
            font-size: 14px;
            right: -8px;
            background: #ccc;
            border-radius: 19px;
            cursor: pointer;
        }

        .notes-popup .content table {
            width: 100%;
        }

            .notes-popup .content table th {
                border: 1px solid #ccc;
                text-align: left;
                padding: 3px;
                font-size: 13px;
                color: #ddd;
                background: #000;
            }

            .notes-popup .content table td {
                padding: 3px;
                font-size: 12px;
                border: 1px solid #ccc;
            }

            .notes-popup .content table tr:nth-child(even) {
                background: #ba4f50;
                color: #fff;
            }

            .notes-popup .content table tr:nth-child(odd) {
                background: #FFF;
                color: #000;
            }

            .notes-popup .content table tr th:nth-child(1), .notes-popup .content table tr td:nth-child(1) {
                width: 210px;
            }

        .notes-popup .add-notes-container {
            display: inline-block;
            width: 98%;
            padding: 5px;    POSITION: relative;
        }

            .notes-popup .add-notes-container textarea {
                width: 80% !important;
                height: 50px !important;
                padding: 5px !important;
                    float: left;
    margin-right: 10px;
            }
            .notes-popup .notes-container .note-desc {
                width: 194px;
                height: 29px;
                overflow: hidden;
                text-overflow: ellipsis;
                white-space: nowrap;
            }
    .notes-table tr:nth-child(odd) a{}
            .notes-table tr:nth-child(even) a, .notes-popup tr:nth-child(even) a{color:#fff;}
            .notes-table tr th:nth-child(1), .notes-table tr td:nth-child(1) {
                width: 5%;
            }
            
            .notes-table tr th:nth-child(2), .notes-table tr td:nth-child(2) {
                width: 27%;
            }

            .notes-table tr th:nth-child(3), .notes-table tr td:nth-child(3) {
                width: 90px;
                text-overflow: ellipsis;
                overflow: hidden;
                white-space: nowrap;
            }
            .GrdBtnAdd {
    margin-top: 12px;
    height: 30px;
    background: url(img/main-header-bg.png) repeat-x;
    color: #fff;
    cursor: pointer;
    border-radius: 5px;
}
    .installidright {
        text-align: right;
        width: 80px;
        display: block;
        padding-right: 5px;
    }

    .installidcenter {
        text-align: center;
        width: 80px;
        display: block;
        padding-right: 5px;
    }

    .installidleft {
        text-align: left;
        width: 80px;
        display: block;
    }


    .taskdesc a {
        text-decoration: underline;
        color: blue;
    }

    .taskdesc * {
        max-width: 100%;
    }

    .taskdesc .TitleEdit, .taskdesc .UrlEdit, .taskdesc .DescEdit {
        min-width: 200px;
        display: inline-block;
        height: 15px;
    }

    .modalBackground {
        background-color: #333333;
        filter: alpha(opacity=70);
        opacity: 0.7;
        z-index: 100 !important;
    }


    /*poup css starts*/
    .Descoverlay {
        position: fixed;
        top: 0;
        bottom: 0;
        left: 0;
        right: 0;
        background: rgba(0, 0, 0, 0.7);
        transition: opacity 500ms;
        visibility: hidden;
        opacity: 0;
    }

        .Descoverlay:target {
            visibility: visible;
            opacity: 1;
        }

    .Descpopup {
        margin: 70px auto;
        padding: 20px;
        background: #fff;
        border-radius: 5px;
        width: 70%;
        position: relative;
        transition: all 5s ease-in-out;
    }

        .Descpopup h2 {
            margin-top: 0;
            color: #333;
            font-family: Tahoma, Arial, sans-serif;
        }

        .Descpopup .close {
            position: absolute;
            top: 20px;
            right: 30px;
            transition: all 200ms;
            font-size: 30px;
            font-weight: bold;
            text-decoration: none;
            color: #333;
        }

            .Descpopup .close:hover {
                color: #06D85F;
            }

        .Descpopup .content {
            /*max-height: 30%;
            overflow: auto;
            overflow-x: hidden;*/
            max-height: 450px;
            overflow: scroll;
            width: 96%;
            height: 450px;
        }

            .Descpopup .content img {
                width: 100%;
            }

    @media screen and (max-width: 700px) {
        .Descpopup {
            width: 70%;
        }
    }
    /*poup css ends*/

    /*.modalPopup { 
            background-color:#FFFFFF; 
            border-width:1px; 
            border-style:solid; 
            border-color:#CCCCCC; 
            padding:1px; 
            width:100%; 
            Height:450px; 
            
        }*/

    /*.lSGallery img
   {
       width:70px !important;
       height:70px !important;
   }
    .lSGallery li
   {
       width:70px!important;
   }*/

    .form_panel_custom ul {
        margin: 0px !important;
    }

    .dropzonetbl td {
        border: none !important;
        border-right: none !important;
    }

    .sub-task-attachments-list {
        height: 270px !important;
    }

    .sub-task-link{
        color:blue !important;
    }
    .sub-task-date{
        color:black;
    }
    .sub-task-time{
        color:red;
    }
    .listId {
        float:left;
        width: 32px;
        margin-top: 7px;
    }
    .taskSubPoints {
        clear: both;
        vertical-align: middle;
        margin-top: 5px;
    }
    .nestedChildren{
        clear: both;        
        padding: 10px;
        background-color: white;
    }
    .level2{
        margin-left:36px;
    }
    .level3{
        margin-left:54px;
    }
    .parentdiv{
        border-top-color: black;
        border-width: thin;
        border-top-style: dotted;
        padding-top: 5px;
        padding-bottom:15px;
    }
    .selectchildren{
        float:right;
    }
    .indentButtonRight{
        float: left;        
        margin-top: 5px;
        background-image: url(/img/indent_right.jpg);
        height: 21px;
        width: 26px;
        background-repeat: no-repeat;
    }
    .indentButtonLeft{
        float: left;
        margin-left: 4px;
        margin-top: 5px;
        background-image: url(/img/indent_left.jpg);
        height: 21px;
        width: 26px;
        background-repeat: no-repeat;
    }
    .roman-save{
        padding-left: 15px;
        padding-right: 15px;
        padding-top: 5px;
        padding-bottom: 5px;
        margin-top: 2px;
        float: right;
        background-color: #c05154;
        color: #fff;
        margin-right:20px;
    }
    .roman-title{
        font-weight: bold;
    }
    .cke_textarea_inline i{
        color:red;
    }
    .multileveledittext .cke_textarea_inline{
        overflow-y:auto;
        height:45px !important;
    }
    /*For Placeholder*/
    label.roman-placeholder{
	    position : relative
    }
    label.roman-placeholder>span{
	    position: absolute;
        left: 7px;
        top: 0px;
        font-weight: normal;
        color: #9d9d9d;
        font-style:italic;
    }
    input.roman-placeholder{
	    position : relative;
	    background : none;
    }
    /*For Placeholder*/
    .multileveledittext{
        width: 90%;
    text-align: left;
    }
    .pagination > li {float: none !important;}
    .pagingInfo{
        margin-top: -20px !important;
    }
    .clear{
        clear:both;
        margin-bottom:5px;
        padding-bottom:5px;
    }
    #indentDiv{
        background-color: #fff;
        height: 34px;
        float:left;
        width:98%;
    }
    .TaskloaderDiv{
        float:right;
        margin-top: 12px;
        display: none;
    }
    #NewChildDiv{
        background-color: white;
        height: 34px;
    }
    .ChildEdit{
        float: left;
        width: 92%;
    }
    /*For Roman Freeze(hours) popup*/
        .roman-data{
            margin-top: 15px;
        }
        #ITLeadFreezeHours,#ITLeadFreezeData,#UserFreezeHours,#UserFreezeData{
            display:none;
        }
        #ITLeadFreezeData,#UserFreezeData{
            margin-top:10px;
        }
        /*For Roman Freeze(hours) popup*/

        /*Sequence Popup*/
        .divDesigDropDown{
            float:left;
        }
        .divPageSize{
            float:right;
            display:none;
        }
        /*Sequence Popup*/
</style>

<fieldset class="tasklistfieldset">
    <legend>Task List</legend>

    <%-- <asp:UpdatePanel ID="upAddSubTask" runat="server" UpdateMode="Conditional">
        <ContentTemplate>--%>
    <div class="push popover__content">
        <div class="content">
            <img src="#" >
        </div>
    </div>

    <div id="divAddSubTask" runat="server">
        <asp:ValidationSummary ID="ValidationSummary2" runat="server" ValidationGroup="SubmitSubTask" ShowSummary="False" ShowMessageBox="True" />
        <%--<asp:LinkButton ID="lbtnAddNewSubTask" runat="server" Text="Add New Task" ValidationGroup="Submit" OnClick="lbtnAddNewSubTask_Click" />--%>
        <asp:HiddenField ID="hdndesignations" runat="server" Value="" />
        <asp:HiddenField ID="hdnLastSubTaskSequence" runat="server" Value="" />
        <asp:HiddenField ID="hdnTaskListId" runat="server" Value="{{NextInstallId}}" />
        <input type="hidden" id="hdnNextInstallId"/>
        <button type="button" id="lbtnAddNewSubTask1" onclick="javascript:AddNewTaskPopup();" style="color: Blue; text-decoration: underline; cursor: pointer; background: none;">Add New Task</button>
        <br />
        <asp:ValidationSummary ID="vsSubTask" runat="server" ValidationGroup="vgSubTask" ShowSummary="False" ShowMessageBox="True" />
        <div id="divNEWSubTask" runat="server" class="tasklistfieldset" style="display: none;">
            <asp:HiddenField ID="hdnTaskApprovalId" runat="server" Value="0" />
            <asp:HiddenField ID="hdnSubTaskId" runat="server" Value="0" />
            <asp:HiddenField ID="hdnSubTaskIndex" runat="server" Value="-1" />
            <input type="hidden" id="hdnSearchKey" />
            <table class="tablealign fullwidth">
                <tr>
                    <td>ListID:<asp:TextBox ID="txtTaskListID" runat="server" Enabled="false" Text="{{NextInstallId}}" />
                        &nbsp;<small>
                            <a href="javascript:void(0);" style="color: #06c;" id="lnkidopt" onclick="copytoListID(this);">
                                <asp:Literal ID="listIDOpt" runat="server" />
                            </a>
                        </small>
                        <asp:CheckBox ID="chkTechTask" runat="server" Text=" Tech Task?" Checked="false" />
                    </td>
                    <td>
                        <div style="display: inline;">
                            Type <span style="color: red;">*</span>
                            <asp:DropDownList ID="ddlTaskType" AutoPostBack="false" runat="server" />
                            <asp:RequiredFieldValidator ID="RequiredFieldValidator2" runat="server" Display="None" ValidationGroup="vgSubTask"
                                ControlToValidate="ddlTaskType" ErrorMessage="Please enter Task Type." />
                            Designation<span style="color: red;">*</span>:<asp:DropDownList ID="ddlUserDesignation" runat="server" AutoPostBack="false">
                            </asp:DropDownList>
                        </div>
                        <div id="divSeqForAddNewTask" style="display: none;">
                            Priority/Sequence <span style="color: red;">*</span>
                            <div class="handle-counter hide" id="divNewAddSeq">

                                <a href="javascript:void(0);" class="counter-minus btn btn-primary">-</a>
                                <input type="text" id="txtSeqAdd" class="textbox" />
                                <a href="javascript:void(0);" class="counter-plus btn btn-primary">+</a>

                            </div>
                            <div style="clear: both; display: none;">
                                Other Task Sequencing:
                            <%--<select ng-options="Task as Task.TaskSequence + ' - ' + Task.Title for Task in Tasks track by Task.TaskSequence" ng-model="TaskSelected"></select>--%>
                            </div>
                        </div>
                        <div class="hide">
                            <asp:DropDownList ID="ddlSubTaskPriority" runat="server" />
                            <asp:RequiredFieldValidator ID="RequiredFieldValidator3" runat="server" Visible="false" Display="None" ValidationGroup="vgSubTask"
                                ControlToValidate="ddlSubTaskPriority" ErrorMessage="Please enter Task Priority." />
                        </div>
                    </td>
                </tr>
                <tr>
                    <td>Title <span style="color: red;">*</span>:
                        <br />
                        <asp:TextBox ID="txtSubTaskTitle" Text="" runat="server" Width="98%" CssClass="textbox" TextMode="SingleLine" />
                        <asp:RequiredFieldValidator ID="rfvTitle" runat="server" Display="None" ValidationGroup="vgSubTask"
                            ControlToValidate="txtSubTaskTitle" ErrorMessage="Please enter Task Title." />
                    </td>
                    <td>Url <span style="color: red;">*</span>:
                        <br />
                        <asp:TextBox ID="txtUrl" Text="" runat="server" Width="98%" CssClass="textbox" />
                        <asp:RequiredFieldValidator ID="rfvUrl" runat="server" Display="None" ValidationGroup="vgSubTask"
                            ControlToValidate="txtUrl" ErrorMessage="Please enter Task Url." />
                    </td>
                </tr>

                <%--as per discussion attachemnt field should be removed.--%>
                <tr runat="server" visible="false">
                    <td colspan="2">Attachment(s):                        
                    </td>
                </tr>

                <tr>
                    <td colspan="2">Description <span style="color: red;">*</span>:
                        <br />
                        <asp:TextBox ID="txtSubTaskDescription" runat="server" CssClass="textbox" TextMode="MultiLine" Rows="5" Width="98%" />
                        <asp:RequiredFieldValidator ID="rfvSubTaskDescription" ValidationGroup="vgSubTask"
                            runat="server" ControlToValidate="txtSubTaskDescription" ForeColor="Red" ErrorMessage="Please Enter Task Description" Display="None" />
                    </td>
                </tr>
                <%--as per discussion attachemnt field should be removed.--%>
                <tr runat="server" visible="false">
                    <td>Attachment(s):<br>
                        <%--<asp:UpdatePanel ID="upAttachmentsData" runat="server" UpdateMode="Conditional">
                                    <ContentTemplate>--%>
                        <asp:HiddenField ID="hdnAttachments" runat="server" />

                        <%--                                    </ContentTemplate>
                                </asp:UpdatePanel>--%>
                        <div id="divSubTaskDropzone" runat="server" class="dropzone">
                            <div class="fallback">
                                <input name="file" type="file" multiple />
                                <input type="submit" value="Upload" />
                            </div>
                        </div>
                    </td>
                    <td>
                        <div id="divSubTaskDropzonePreview" runat="server" class="dropzone-previews">
                        </div>
                        <asp:Button ID="btnSaveSubTaskAttachment" runat="server" OnClick="btnSaveSubTaskAttachment_Click" Style="display: none;" Text="Save Attachement" />
                    </td>
                </tr>
                <%--as per discussion, estimated hours and task hour fields should be removed.--%>
                <tr runat="server" visible="false">
                    <td colspan="2">Estimated Hours:
                       
                        <asp:TextBox ID="txtEstimatedHours" runat="server" CssClass="textbox" Width="110" placeholder="Estimate" />
                        <asp:RegularExpressionValidator ID="revEstimatedHours" runat="server" ControlToValidate="txtEstimatedHours" Display="None"
                            ErrorMessage="Please enter decimal numbers for estimated hours of task." ValidationGroup="vgSubTask"
                            ValidationExpression="(\d+\.\d{1,2})?\d*" />
                    </td>
                </tr>
                <%--as per discussion, estimated hours and task hour fields should be removed.--%>
                <tr id="trDateHours" runat="server" visible="false" style="display: none;">
                    <td>Due Date:<asp:TextBox ID="txtSubTaskDueDate" runat="server" CssClass="textbox datepicker" />
                    </td>
                    <td>Hrs of Task:
                       
                        <asp:TextBox ID="txtSubTaskHours" runat="server" CssClass="textbox" />
                        <asp:RegularExpressionValidator ID="revSubTaskHours" runat="server" ControlToValidate="txtSubTaskHours" Display="None"
                            ErrorMessage="Please enter decimal numbers for hours of task." ValidationGroup="vgSubTask"
                            ValidationExpression="(\d+\.\d{1,2})?\d*" />
                    </td>
                </tr>
                <tr id="trSubTaskStatus" runat="server" visible="false">
                    <td>Status:
                       
                        <asp:DropDownList ID="ddlSubTaskStatus" runat="server" />
                    </td>
                    <td>&nbsp;
                    </td>
                </tr>
                <tr>
                    <td colspan="2">
                        <div class="btn_sec">
                            <%--<asp:Button ID="btnSaveSubTask" runat="server" Text="Save Sub Task" CssClass="ui-button" ValidationGroup="vgSubTask"
                                        OnClientClick="javascript:return OnSaveSubTaskClick();" OnClick="btnSaveSubTask_Click" />--%>
                            <asp:Button ID="btnSaveSubTask" runat="server" Text="Save Sub Task" CssClass="ui-button" ValidationGroup="vgSubTask"
                                OnClientClick="javascript:return OnSaveSubTaskClick();" />

                        </div>
                    </td>
                </tr>
            </table>
        </div>
    </div>
    <%--</ContentTemplate>
    </asp:UpdatePanel>--%>
    <div id="divTaskNG" data-ng-controller="TaskSequenceSearchController">
        <asp:UpdatePanel ID="upSubTasks" runat="server" UpdateMode="Conditional">
            <ContentTemplate>
                <div id="divSubTaskGrid">
                    <asp:HiddenField ID="hdnGridAttachment" runat="server" />
                    <div style="float: left; margin-top: 15px;">
                        <asp:TextBox ID="txtSearch" runat="server" CssClass="textbox" placeholder="search users" MaxLength="15" />
                        <asp:Button ID="btnSearch" runat="server" Text="Search" Style="display: none;" class="btnSearc" OnClick="btnSearch_Click" />

                        Number of Records:                                
                    <select onchange="LoadSubTasks()" id="drpPageSize">
                        <option selected="selected" value="5">5</option>
                        <option value="10">10</option>
                        <option value="15">15</option>
                        <option value="20">20</option>
                        <option value="25">25</option>

                    </select>
                    </div>
                        <div>
                            <table width="100%" border="0" cellspacing="0" cellpadding="0" class="table edit-subtask">
                            <thead>
                                <tr class="trHeader">
                                    <th width="8%" class="subtask-actionid">Action-ID#</th>
                                    <th width="47%" class="subtask-taskdetails">Task Details</th>
                                    <th width="15%" class="subtask-assign">Assigned</th>
                                    <th width="30%" class="subtask-attchments">Attachments, IMGs, Docs, Videos & Recordings</th>
                                </tr>
                            </thead>
                            <tbody>
                                <tr class="{{SubTask.className}} MainTask" data-ng-repeat="SubTask in SubTasks" data-task-level="1" data-taskid="{{SubTask.TaskId}}" 
                                    data-parent-taskid="{{SubTask.TaskId}}" style="vertical-align:top" repeat-end="onEnd(this)" id="datarow{{SubTask.TaskId}}">
                                    <td width="8%" ng-class="{sbtlevel2 : SubTask.NestLevel==='2'}">
                                        <h5 ng-class="{hide: SubTask.NestLevel == '3'}">
                                            <input type="checkbox" name="bulkaction">
                                            <a id="lbtnInstallId" data-taskfid="{{SubTask.InstallId1}}" data-tasktitle="{{SubTask.Title}}" 
                                                data-AssignedUserId="{{SubTask.TaskAssignedUserIds}}" data-uname="{{SubTask.TaskAssignedUsers}}" class="context-menu installidleft" 
                                                onclick="javascript:return false;" data-highlighter="{{SubTask.TaskId}}" style="color: Blue; cursor:pointer; display: inline;">
                                                {{SubTask.InstallId}}
                                            </a>
                                            <%if (IsAdminMode)
                                                { %>
                                            <input type="submit" name="btnshowdivsub" value="+" id="btnshowdivsub" ng-class="{showsubtaskDIV: SubTask.NestLevel==1, hide: SubTask.NestLevel==2}" 
                                                data-parent-taskid="{{SubTask.TaskId}}" data-val-commandname="{{SubTask.NestLevel}}#{{SubTask.InstallId}}#{{SubTask.TaskId}}#1" data-val-tasklvl="{{SubTask.NestLevel}}"
                                                data-val-commandargument="{{SubTask.TaskId}}" 
                                                data-val-tasklvl="{{SubTask.NestLevel==1}}" data-installid="{{SubTask.InstallId}}" style="color: Blue; text-decoration: underline; cursor: pointer; background: none;">
                                            <%} %>
                                            <img src="../../img/icon_share.JPG" data-taskfid="{{SubTask.InstallId1}}" data-tasktitle="{{SubTask.Title}}" 
                                                data-AssignedUserId="{{SubTask.TaskAssignedUserIds}}" data-uname="{{SubTask.TaskAssignedUsers}}" class="share-icon installidleft" 
                                                onclick="sharePopup(this)" data-highlighter="{{SubTask.TaskId}}" style="color: Blue; cursor:pointer; display: inline;" />
                                            <div class="selectchildren">
                                                <a href="#/" onclick="selectChildren(this)" data-taskid="{{SubTask.TaskId}}">Select All</a>
                                            </div>
                                            <div class="clear"></div>
                                        </h5>

                                        <!-- Freezingn Task Part Starts -->
                                        <div class="approvalBoxes">
                                            <span class="aspNetDisabled fz fz-admin" title="Admin">
                                                <input id="chkAdmin" type="checkbox" name="chkAdmin" ng-checked="{{SubTask.AdminStatus}}" ng-disabled="{{SubTask.AdminStatus}}"/></span>
                                            <span class="aspNetDisabled fz fz-techlead" title="IT Lead">
                                                <input id="chkITLead" type="checkbox" name="chkITLead" ng-checked="{{SubTask.TechLeadStatus}}" ng-disabled="{{SubTask.TechLeadStatus}}"></span>
                                            <span class="aspNetDisabled fz fz-user" title="User">
                                                <input id="chkUser" type="checkbox" name="chkUser" ng-checked="{{SubTask.OtherUserStatus}}" ng-disabled="{{SubTask.OtherUserStatus}}"></span>

                                        </div>
                                        
                                        <div ng-attr-data-taskid="{{SubTask.TaskId}}" class="approvepopup">
                                            <div id="divTaskAdmin{{SubTask.TaskId}}" style="margin-bottom: 15px; font-size: x-small;">
                                                <div style="width: 10%;" class="display_inline">Admin: </div>
                                                <div style="width: 30%;" class="display_inline"></div>
                                                <div ng-class="{hide : StringIsNullOrEmpty(SubTask.AdminStatusUpdated), display_inline : !StringIsNullOrEmpty(SubTask.AdminStatusUpdated) }">
                                                    <a class="bluetext" href="CreateSalesUser.aspx?id={{SubTask.AdminUserId}}" target="_blank">{{StringIsNullOrEmpty(SubTask.AdminUserInstallId)? SubTask.AdminUserId : SubTask.AdminUserInstallId}} - {{SubTask.AdminUserFirstName}} {{SubTask.AdminUserLastName}}
                                                    </a>
                                                    <br />
                                                    <span>{{ SubTask.AdminStatusUpdated | date:'M/d/yyyy' }}</span>&nbsp;<span style="color: red">{{ SubTask.AdminStatusUpdated | date:'shortTime' }}</span>&nbsp;<span> {{StringIsNullOrEmpty(SubTask.AdminStatusUpdated) ? '' : '(EST)' }} </span>
                                                </div>
                                                <div ng-class="{hide : !StringIsNullOrEmpty(SubTask.AdminStatusUpdated), display_inline : StringIsNullOrEmpty(SubTask.AdminStatusUpdated) }">
                                                    <input type="password" style="width: 100px;" placeholder="Admin password" onchange="javascript:FreezeTask(this);"
                                                        data-id="txtAdminPassword" data-hours-id="txtAdminEstimatedHours" ng-attr-data-taskid="{{SubTask.TaskId}}" />
                                                </div>
                                            </div>
                                            <div id="divTaskITLead{{SubTask.TaskId}}" style="margin-bottom: 15px; font-size: x-small;">
                                                <div style="width: 10%;" class="display_inline">ITLead: </div>
                                                <!-- ITLead Hours section -->
                                                <div style="width: 30%;" ng-class="{hide : StringIsNullOrEmpty(SubTask.AdminOrITLeadEstimatedHours), display_inline : !StringIsNullOrEmpty(SubTask.AdminOrITLeadEstimatedHours) }">
                                                    <span>
                                                        <label>{{SubTask.AdminOrITLeadEstimatedHours}}</label>Hour(s)
                                                    </span>
                                                </div>
                                                <div style="width: 30%;" ng-class="{hide : !StringIsNullOrEmpty(SubTask.AdminOrITLeadEstimatedHours), display_inline : StringIsNullOrEmpty(SubTask.AdminOrITLeadEstimatedHours) }">
                                                    <input type="text" style="width: 55px;" placeholder="Est. Hours" data-id="txtITLeadEstimatedHours" />
                                                </div>
                                                <div style="width: 50%; float: right; font-size: x-small;" ng-class="{hide : !StringIsNullOrEmpty(SubTask.AdminOrITLeadEstimatedHours), display_inline : StringIsNullOrEmpty(SubTask.AdminOrITLeadEstimatedHours) }">
                                                    <input type="password" style="width: 100px;" placeholder="ITLead Password" onchange="javascript:FreezeTask(this);"
                                                        data-id="txtITLeadPassword" data-hours-id="txtITLeadEstimatedHours" ng-attr-data-taskid="{{SubTask.TaskId}}" />
                                                </div>
                                                <!-- ITLead password section -->
                                                <div style="width: 50%; float: right; font-size: x-small;" ng-class="{hide : StringIsNullOrEmpty(SubTask.AdminOrITLeadEstimatedHours), display_inline : !StringIsNullOrEmpty(SubTask.AdminOrITLeadEstimatedHours) }">
                                                    <a class="bluetext" href="CreateSalesUser.aspx?id={{SubTask.TechLeadUserId}}" target="_blank">{{StringIsNullOrEmpty(SubTask.TechLeadUserInstallId)? SubTask.TechLeadUserId : SubTask.TechLeadUserInstallId}} - {{SubTask.TechLeadUserFirstName}} {{SubTask.TechLeadUserLastName}}
                                                    </a>
                                                    <br />
                                                    <span>{{ SubTask.TechLeadStatusUpdated | date:'M/d/yyyy' }}</span>&nbsp;<span style="color: red">{{ SubTask.TechLeadStatusUpdated | date:'shortTime' }}</span>&nbsp;<span> {{StringIsNullOrEmpty(SubTask.TechLeadStatusUpdated)? '' : '(EST)' }} </span>
                                                </div>
                                            </div>
                                            <div id="divUser{{SubTask.TaskId}}" style="margin-bottom: 15px; font-size: x-small;">
                                                <div style="width: 10%;" class="display_inline">User: </div>
                                                <!-- UserHours section -->
                                                <div style="width: 30%;" ng-class="{hide : StringIsNullOrEmpty(SubTask.UserEstimatedHours), display_inline : !StringIsNullOrEmpty(SubTask.UserEstimatedHours) }">
                                                    <span>
                                                        <label>{{SubTask.UserEstimatedHours}}</label>Hour(s)
                                                        Hour(s)</span>
                                                </div>
                                                <div style="width: 30%;" ng-class="{hide : !StringIsNullOrEmpty(SubTask.UserEstimatedHours), display_inline : StringIsNullOrEmpty(SubTask.UserEstimatedHours) }">
                                                    <input type="text" style="width: 55px;" placeholder="Est. Hours" data-id="txtUserEstimatedHours" />
                                                </div>
                                                <div style="width: 50%; float: right; font-size: x-small;" ng-class="{hide : !StringIsNullOrEmpty(SubTask.UserEstimatedHours), display_inline : StringIsNullOrEmpty(SubTask.UserEstimatedHours) }">
                                                    <input type="password" style="width: 100px;" placeholder="User Password" onchange="javascript:FreezeTask(this);"
                                                        data-id="txtUserPassword" data-hours-id="txtUserEstimatedHours" ng-attr-data-taskid="{{SubTask.TaskId}}" />
                                                </div>
                                                <!-- User password section -->
                                                <div style="width: 50%; float: right; font-size: x-small;" ng-class="{hide : StringIsNullOrEmpty(SubTask.UserEstimatedHours), display_inline : !StringIsNullOrEmpty(SubTask.UserEstimatedHours) }">
                                                    <a class="bluetext" href="CreateSalesUser.aspx?id={{SubTask.TechLeadUserId}}" target="_blank">{{StringIsNullOrEmpty(SubTask.OtherUserInstallId)? SubTask.OtherUserId : SubTask.OtherUserInstallId}} - {{SubTask.OtherUserFirstName}} {{SubTask.OtherUserLastName}}
                                                    </a>
                                                    <br />
                                                    <span>{{ SubTask.OtherUserStatusUpdated | date:'M/d/yyyy' }}</span>&nbsp;<span style="color: red">{{ SubTask.OtherUserStatusUpdated | date:'shortTime' }}</span>&nbsp;<span> {{StringIsNullOrEmpty(SubTask.OtherUserStatusUpdated)? '' : '(EST)' }} </span>
                                                </div>
                                            </div>

                                            <div>
                                                <div style="width: 50%">
                                                    Bussiness Logic Queries:<br />
                                                    <table class="table">
                                                        <tbody>
                                                            <tr class="FirstRow">
                                                                <td><img style="width: 50px; height: 50px;" /></td>
                                                                <td>Please write you business related queries here.</td>
                                                            </tr>
                                                            <tr class="AlternateRow">
                                                                <td><img style="width: 50px; height: 50px;" /></td>
                                                                <td>Please write you business related queries here.</td>
                                                            </tr>
                                                    </table>
                                                    <br />
                                                    Technical Queries:<br />
                                                    <table class="table">
                                                        <tbody>
                                                            <tr class="FirstRow">
                                                                <td><img style="width: 50px; height: 50px;" /></td>
                                                                <td>Please write you technical queries here.</td>
                                                            </tr>
                                                            <tr class="AlternateRow">
                                                                <td><img style="width: 50px; height: 50px;" /></td>
                                                                <td>Please write you technical queries here.</td>
                                                            </tr>
                                                    </table>
                                                </div>
                                                <div style="width: 50%; clear: none;">
                                                    Attach UI:
                                                    <div id="divUserUIDropzone" style="width: 200px;" data-taskid="{{SubTask.TaskId}}" class="dropzone dropzonetask dropzonJgStyle"
                                                        >
                                                        <div class="fallback">
                                                            <input name="file" type="file" multiple />
                                                        </div>
                                                    </div>
                                                </div>
                                            </div>
                                            <input id="hdnTaskApprovalId" type="hidden" value="{{SubTask.TaskApprovalId}}" />
                                        </div>
                                        <!-- Freezingn Task Part Ends -->
                                    </td>
                                    <td width="47%">
                                        <div ng-class="{hide: SubTask.NestLevel != '3', left: SubTask.NestLevel == '3'}" style="border-right: 0px solid #FFF; padding-right: 5px; width: 40px;">
                                            <input type="checkbox" name="bulkaction">
                                            <a href="javascript:void(0);" data-highlighter="{{SubTask.TaskId}}" class="context-menu" style="color: blue;">{{SubTask.InstallId}}</a>
                                        </div>
                                        <div id="TaskContainer{{SubTask.TaskId}}" style="background-color: white; border-bottom: 2px solid black; padding: 3px; max-width: 99%; max-height:260px; width: 99%; overflow: auto;">
                                            <div class="divtdetails left" style="background-color: white; border-bottom: 2px solid black; padding: 3px; max-width: 99%; width: 99%;">
                                                <div class="taskdesc" style="padding-bottom: 5px; width: 98%; color: black!important;">
                                                
                                                    <div class="right">
                                                        <a href="/sr_app/CreateSalesUser.aspx?id={{SubTask.TaskId}}" style="color: Blue;">{{SubTask.CreatedBy}}# {{SubTask.TaskCreatorFirstName}} {{SubTask.TaskCreatorLastName}}</a><br>
                                                        <span>{{ SubTask.CreatedOn | date:'M/d/yyyy' }}</span>&nbsp;<span style="color: red">{{ SubTask.CreatedOn | date:'shortTime' }}</span>&nbsp;<span>(EST)</span><br />
                                                        <span>Updated On: {{ SubTask.UpdatedOn | date:'M/d/yyyy' }}</span>&nbsp;<span style="color: red">{{ SubTask.UpdatedOn | date:'shortTime' }}</span>&nbsp;<span>(EST)</span>
                                                    </div>
                                                    <strong>Title: <span data-taskid="{{SubTask.TaskId}}" class="TitleEdit">{{SubTask.Title}}</span></strong><br>
                                                    <strong ng-repeat="url in (SubTask.Url | semiColSplit)" repeat-end="onURLEnd()">URL: <span data-taskid="{{SubTask.TaskId}}" style="color: blue; cursor: pointer;" class="UrlEdit">{{ url }}</span><br /></strong>
                                                    <strong>Description: </strong>
                                                    <br>
                                                    <span data-taskid="{{SubTask.TaskId}}" class="DescEdit">
                                                        <div ng-bind-html="SubTask.Description | trustAsHtml"></div>
                                                    </span>                                                
                                                </div>                                                                                        
                                                <%--<button type="button" id="btnsubtasksave" class="btnsubtask" style="display: none;">Save</button>--%>                                            
                                            </div>
                                            <div class="nestedChildren">
                                                <div ng-repeat="Child in MultiLevelChildren | filter: {ParentTaskId: SubTask.TaskId} : true"
                                                    class="ChildRow{{SubTask.TaskId}}" data-level="{{Child.IndentLevel}}" data-label="{{Child.Label}}"
                                                    style="clear: both; padding: 5px;" repeat-end="onRomansLoad({{SubTask.TaskId}})" data-tid="{{SubTask.TaskId}}">
                                                    <div ng-class="{level2: Child.IndentLevel==2, level3: Child.IndentLevel==3, parentdiv: Child.IndentLevel==1}"
                                                        style="float:left;width: 95%;">
                                                        <div style="float: left" id="selectboxes{{SubTask.TaskId}}">
                                                            <input ng-class="{hide: Child.IndentLevel!= 1}" type="checkbox" data-taskid="{{Child.Id}}" onclick="ShowFeedbackFreezePopup(this)" />
                                                            <a href="#" style="color: blue" class="context-menu-child" data-childid="{{Child.Id}}" data-highlighter="{{SubTask.TaskId}}">{{Child.Label}}.</a>
                                                        </div>
                                                        <div>
                                                            <div style="display:table-column; float:left; width:68%">
                                                                <div ng-bind-html="Child.Title | trustAsHtml" class="roman-title ChildEditTitle" id="ChildEditTitle{{Child.Id}}" data-parentid="{{SubTask.TaskId}}" data-taskid="{{Child.Id}}"></div>
                                                                <div ng-bind-html="Child.Description | trustAsHtml" class="ChildEdit" id="ChildEdit{{Child.Id}}" data-parentid="{{SubTask.TaskId}}" data-taskid="{{Child.Id}}"></div>
                                                            </div>
                                                            <div class="right" style="display:table-column; font-size:11px !important">
                                                                <a href="/sr_app/CreateSalesUser.aspx?id={{Child.UpdatedByUserId}}" style="color: Blue;">{{Child.UpdatedByUserId}}# {{Child.UpdatedBy}}</a><br>
                                                                <span>{{ Child.DateUpdated | date:'M/d/yyyy' }}</span>&nbsp;<span style="color: red">{{ Child.DateUpdated | date:'shortTime' }}</span>&nbsp;<span>(EST)</span><br />
                                                                <span>Updated On:<br /> {{ Child.DateUpdated | date:'M/d/yyyy' }}</span>&nbsp;<span style="color: red">{{ Child.DateUpdated | date:'shortTime' }}</span>&nbsp;<span>(EST)</span>
                                                            </div>
                                                        </div>
                                                    </div>
                                                    <div class="delete-icon"><img src="../img/delete.jpg" alt="Delete" data-childid="{{Child.Id}}" onclick="DeleteChild(this, false)"/></div>
                                                </div>
                                            </div>
                                            <%--SubTask Part Starts--%>
                                            <div id="Div1" runat="server" align="center" class="taskSubPoints" style="background-color:white;padding-top: 5px;">
                                                <div class="listId">
                                                    <input type="checkbox" />
                                                    <a href="#" data-listid="{{SubTask.InstallId}}" data-level="{{SubTask.Indent}}" data-label="{{LevelToRoman(SubTask.LastChild,SubTask.Indent)}}" 
                                                        id="listId{{SubTask.TaskId}}" style="color:blue">{{LevelToRoman(SubTask.LastChild,SubTask.Indent)}}</a>
                                                    <input id="nestLevel{{SubTask.TaskId}}" value="{{SubTask.Indent}}" data-label="{{LevelToRoman(SubTask.LastChild,SubTask.Indent)}}" type="hidden" />
                                                    <input id="lastData{{SubTask.TaskId}}" value="{{SubTask.Indent}}" data-label="{{LevelToRoman(SubTask.LastChild,SubTask.Indent)}}" type="hidden" />
                                                </div>
                                                <div>
                                                    <div class="multileveledittext">
                                                        <label class="roman-placeholder">
                                                            <span id="sp" class="roman-placeholder"><span style="color:red">*</span> Sub Task Title</span>
                                                            <input onfocus="hidePlaceholder(this);" onblur="showPlaceHolder(this);" type="text" id="txtRomanTitle{{SubTask.TaskId}}" class="roman-placeholder"
                                                                style="width: 99%; margin-bottom: 2px; height: 22px; padding-left: 5px">
                                                        </label>
                                                        <textarea placeholder="<i>*</i> Description" style="width: 80%" rows="3" class="ChildDescField" id="subtaskDesc{{SubTask.TaskId}}" data-taskid="{{SubTask.TaskId}}" onkeypress="OnMultiLevelChildSave()"></textarea>
                                                    </div>
                                                </div>
                                            </div>
                                            <div id="NewChildDiv">&nbsp;
                                                <div class="" id="indentDiv">
                                                    <button class="indentButtonLeft" type="button" id="btnLeft{{SubTask.TaskId}}" data-taskid="{{SubTask.TaskId}}" data-action="left" onclick="OnIndent(this)" ></button>
                                                    <button class="indentButtonRight" type="button" id="btnRight{{SubTask.TaskId}}" data-taskid="{{SubTask.TaskId}}" data-action="right" onclick="OnIndent(this)" ></button>
                                                    <input type="button" class="roman-save" value="Save" onclick="OnSaveRoman(this)" data-taskid="{{SubTask.TaskId}}"/>
                                                </div>
                                                <div id="TaskloaderDiv{{SubTask.TaskId}}" class="TaskloaderDiv">
                                                    <img src="../../img/ajax-loader.gif" style="height:16px; vertical-align:bottom" /> Auto Saving...
                                                </div>
                                            </div>
                                            <%--SubTask Part Ends--%>
                                        </div>
                                        
                                        <div class="clr" style="height: 1px;"></div>
                                                                    
                                        <a href="javascript:void(0);" data-id="hypViewInitialComments" data-taskid="{{SubTask.TaskId}}" class="hide" 
                                            data-parent-commentid="0" data-startindex="0" data-pagesize="2"
                                            onclick="javascript:SubTaskCommentScript.GetTaskComments(this);">View Replies</a>
                                        <h5 class="taskCommentTitle">Comments/Feedback</h5>
                                        <div data-id="divSubTaskCommentPlaceHolder" data-taskid="{{SubTask.TaskId}}" data-parent-commentid="0" class="taskComments">
                                            <table width="100%">
                                                <tbody data-parent-commentid="0">
                                                </tbody>
                                                <tfoot data-parent-commentid="0">
                                                    <tr>
                                                        <td class="noborder">
                                                            
                                                            <a href="javascript:void(0);" data-id="hypViewComments" data-taskid="{{SubTask.TaskId}}" data-parent-commentid="0" data-startindex="0" data-pagesize="0" onclick="javascript:SubTaskCommentScript.GetTaskComments(this);" style="display: none;">View -2 more comments</a>
                                                            <a href="javascript:void(0);" data-taskid="{{SubTask.TaskId}}" data-parent-commentid="0" class="hide" onclick="javascript:SubTaskCommentScript.AddTaskComment(this);">Comment +</a>
                                                        </td>
                                                    </tr>
                                                    <tr data-id="trAddComment" style="display: none;">
                                                        <td class="noborder">
                                                            <div>
                                                                <textarea data-id="txtComment" class="textbox" style="width: 90%; height: 50px;"></textarea>
                                                            </div>
                                                            <a href="javascript:void(0);" data-id="hypSaveComment" data-comment-id="0" data-taskid="{{SubTask.TaskId}}" data-parent-commentid="0" onclick="javascript:SubTaskCommentScript.SaveTaskComment(this);">Save</a>
                                                            <a href="javascript:void(0);" data-id="hypCancelComment" data-taskid="{{SubTask.TaskId}}" data-parent-commentid="0" onclick="javascript:SubTaskCommentScript.CancelTaskComment(this);">Cancel</a>
                                                        </td>
                                                    </tr>
                                                </tfoot>
                                            </table>
                                        </div>
                                        <a href="javascript:void(0);" data-taskid="{{SubTask.TaskId}}" data-parent-commentid="0" onclick="javascript:SubTaskCommentScript.AddTaskComment(this);">Comment +</a>
                                    </td>
                                    <td width="15%">
                                        <ul ng-class="{hide: SubTask.NestLevel == '3', stulli: SubTask.NestLevel != '3'}">
                                            <li>
                                                <input <%=IsAdminMode?"":"disabled" %> id="chkTechSubTask" type="checkbox" name="chkTechTask" ng-checked="{{SubTask.IsTechTask}}" onclick="setTaskType(this)" data-taskid="{{SubTask.TaskId}}"><label for="chkTechTask"> Tech Task?</label>
                                            </li>
                                            <li>
                                                <input <%=IsAdminMode?"":"disabled" %> id="chkRASSubTask" type="checkbox" name="chkTechTask" ng-checked="{{SubTask.IsReassignable}}" onclick="setReassignableTaskType(this)" data-taskid="{{SubTask.TaskId}}"><label for="chkTechTask">Reoccuring Task</label>
                                            </li>
                                            <li></li>
                                            <li>Priority/Sequence
                                            </li>
                                            <li>
                                                <a id="hypEditTaskSequence" class="badge-hyperlink" href="javascript:void(0);" onclick="javascript:ShowTaskSequence(this,'#ddlDesigSeq');" 
                                                    data-task-designationids="{{SubTask.TaskDesignationIds}}" 
                                                    data-task-techtask="{{SubTask.IsTechTask}}" data-taskid="{{SubTask.TaskId}}">
                                                    <label id="TaskSeque{{SubTask.TaskId}}" class="badge badge-success badge-largetext">
                                                        {{getSequenceDisplayText_(!SubTask.Sequence?"N.A.":SubTask.Sequence,SubTask.SequenceDesignationId,SubTask.IsTechTask === "false" ? "SS" : "TT")}}
                                                    </label></a>
                                            </li>
                                            <li class="hide">Priority
                                            </li>
                                            <li class="hide">
                                                <select name="ddlTaskPriority" id="ddlTaskPriority" class="clsTaskPriority textbox" data-val-taskid="{{SubTask.TaskId}}" taskid="{{SubTask.TaskId}}">
                                                    <option value="0">--None--</option>
                                                    <option selected="selected" value="1">Critical</option>
                                                    <option value="2">High</option>
                                                    <option value="3">Medium</option>
                                                    <option value="4">Low</option>

                                                </select>
                                            </li>

                                            <li>Status</li>
                                            <li>
                                                <select id="drpStatusSubsequenceFrozen" onchange="changeTaskStatusClosed(this);" data-highlighter="{{SubTask.TaskId}}">
                                                    <option ng-selected="{{SubTask.Status == '1'}}" value="1">Open</option>
                                                    <option ng-selected="{{SubTask.Status == '2'}}" style="color: red" value="2">Requested</option>
                                                    <option ng-selected="{{SubTask.Status == '3'}}" style="color: lawngreen" value="3">Assigned</option>
                                                    <option ng-selected="{{SubTask.Status == '4'}}" value="4">InProgress</option>
                                                    <option ng-selected="{{SubTask.Status == '5'}}" value="5">Pending</option>
                                                    <option ng-selected="{{SubTask.Status == '6'}}" value="6">ReOpened</option>
                                                    <option ng-selected="{{SubTask.Status == '7'}}" value="7">Closed</option>
                                                    <option ng-selected="{{SubTask.Status == '8'}}" value="8">SpecsInProgress</option>
                                                    <option ng-selected="{{SubTask.Status == '10'}}" value="10">Finished</option>
                                                    <option ng-selected="{{SubTask.Status == '11'}}" value="11">Test</option>
                                                    <option ng-selected="{{SubTask.Status == '12'}}" value="12">Live</option>
                                                    <option ng-selected="{{SubTask.Status == '14'}}" value="14">Billed</option>
                                                    <option ng-selected="{{SubTask.Status == '9'}}" value="9">Deleted</option>
                                                </select>
                                            </li>
                                            <li style="display: none;">Type
                                            </li>
                                            <li style="display: none;">Enhancement
                                            </li>

                                        </ul>
                                        <div ng-class="{hide: SubTask.NestLevel == '3'}" >
                                            <span>Assigned
                                            </span>
                                            <div style="clear:both"></div>
                                            <select id="ddcbSeqAssignedStaff" style="width: 180px;" multiple data-assignedusers="{{SubTask.TaskAssignedUserIds}}" 
                                                data-chosen="1" data-placeholder="Select Users" onchange="EditAssignedSubTaskUsers(this);" data-taskid="{{SubTask.TaskId}}" 
                                                data-taskstatus="{{SubTask.Status}}" class="chosen-input task-users">
                                                <option
                                                    ng-repeat="item in Users"
                                                    value="{{item.Id}}"
                                                    label="{{item.FristName}}"
                                                    class="{{item.CssClass}}"
                                                    repeat-end="onAssignEnd()"
                                                    >
                                                    <span>{{item.FristName}}</span>                                                    
                                                </option>
                                            </select>                                            
                                        </div>
                                        <table style="display: none;">
                                            <tbody>
                                                <tr>
                                                    <td class="noborder" colspan="2">
                                                        <h5>Estimated Hours</h5>
                                                    </td>
                                                </tr>
                                                <tr>
                                                    <td class="noborder" width="30%"><b>ITLead</b>
                                                    </td>
                                                    <td class="noborder">2 Hour(s)
                                                    </td>
                                                </tr>
                                                <tr>
                                                    <td class="noborder"><b>User</b></td>
                                                    <td class="noborder">N.A.</td>
                                                </tr>
                                            </tbody>
                                        </table>
                                    </td>
                                    <td width="30%">
                                        <table border="0" ng-class="{hide: SubTask.NestLevel == '3', dropzonetbl: SubTask.NestLevel != '3'}"  style="width: 100%;">
                                            <tr>
                                                <td>
                                                    <asp:UpdatePanel ID="upAttachmentsData1" runat="server" UpdateMode="Conditional" ClientIDMode="AutoID">
                                                        <ContentTemplate>
                                                            <input id="hdnAttachments1" runat="server" type="hidden" clientidmode="AutoID" />
                                                        </ContentTemplate>
                                                    </asp:UpdatePanel>
                                                    <div id="divSubTaskDropzone1" style="width: 200px;" data-taskid="{{SubTask.TaskId}}" 
                                                        class="dropzone dropzonetask dropzonJgStyle" onclick="SetHiddenTaskId(this);">
                                                        <div class="fallback">
                                                            <input name="file" type="file" multiple />
                                                        </div>
                                                    </div>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td>
                                                    <div id="divSubTaskDropzonePreview1" runat="server" class="dropzone-previews">
                                                    </div>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td>
                                                    <input id="chkUiRequested" type="checkbox" ng-checked="{{SubTask.IsUiRequested}}" title="Ui Requested?" />
                                                    <label for="chkUiRequested">Ui Requested?</label>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td>
                                                    <div class="lSSlideOuter sub-task-attachments" style="max-width: 420px;">

                                                        <div class="lSSlideWrapper usingCss">
                                                            <ul id="lightSlider_{{SubTask.TaskId}}" class="gallery list-unstyled sub-task-attachments-list">
                                                                <li repeat-end="onAttachmentEnd({{SubTask.TaskId}})" ng-repeat="File in TaskFiles | filter: {TaskId: SubTask.TaskId} : true" 
                                                                    id="liImage" runat="server" class="noborder" style="overflow: inherit !important; width: 247px; margin-right: 0px;"
                                                                    data-thumb="/TaskAttachments/{{File.attachment.split('@')[0]}}">
                                                                    <h5>
                                                                        <a class="sub-task-link" target="_blank" id="lbtnDownload" href="/TaskAttachments/{{File.attachment.split('@')[0]}}">{{File.attachment.split("@")[1]}}</a></h5>
                                                                    <h5>
                                                                        <span class="sub-task-date" id="ltlUpdateDate">{{File.UpdatedOn | date:'M/d/yyyy'}}</span>
                                                                        <span class="sub-task-time" id="ltlUpdateTime">{{File.UpdatedOn | date:'shortTime'}} (EST)</span>
                                                                    </h5>
                                                                    <h5>
                                                                        <span class="sub-task-user" id="ltlCreatedUser">{{File.FirstName}}</span></h5>
                                                                    <div>
                                                                        <%if (IsAdminMode)
                                                                            {%>
                                                                        <a class="sub-task-link" id="lbtnDelete" data-aid="{{File.Id}}" onclick="OnDeleteAttachment(this);" href="#">Delete</a>
                                                                        <%} %>
                                                                    </div>
                                                                    <br />
                                                                    <a class="image-link" href="/TaskAttachments/{{File.attachment.split('@')[0]}}">
                                                                        <img  id="imgIcon" class="gallery-ele" style="width: 100% !important;" src="/TaskAttachments/{{File.attachment.split('@')[0]}}" />
                                                                    </a>
                                                                </li>

                                                            </ul>
                                                        </div>
                                                    </div>

                                                    <%--<img id="defaultimgIcon" ng-hide="{File in TaskFiles | filter: {TaskId: SubTask.TaskId} : true} == null"
                                                        class="gallery-ele" width="247" height="185" src="~/img/JG-Logo-white.gif" />--%>

                                                </td>
                                            </tr>
                                        </table>
                                    </td>
                                </tr>
                            </tbody>
                        </table>
                        </div>
                     <div class="text-center">
                        <jgpager page="{{page}}" pages-count="{{pagesCount}}" total-count="{{TotalRecords}}" search-func="getSubTasksPager(page)"></jgpager>
                    </div>
                    <div ng-show="loader.loading" style="position: absolute; left: 50%;">
                        Loading...
                        <img src="../img/ajax-loader.gif" />
                    </div>
   
                    
                                        
                    <div id="divSubTasks_Empty" runat="server" class="hide">
                        <table width="100%" border="0" cellspacing="0" cellpadding="0" class="table edit-subtask">
                            <tr>
                                <td align="center" valign="middle" style="color: black;">No sub task available!
                                </td>
                            </tr>
                        </table>
                    </div>

                    <asp:Button ID="btnSaveGridAttachment" runat="server"
                        OnClick="btnSaveGridAttachment_Click" Style="display: none;" Text="Save Attachement" />
                    <asp:HiddenField ID="hdDropZoneTaskId" runat="server" />
                </div>
                <asp:HiddenField ID="hdnCurrentEditingRow" runat="server" />
                <asp:LinkButton ID="lnkFake" runat="server"></asp:LinkButton>
                <asp:Button ID="btnUpdateRepeater" runat="server" OnClick="btnUpdateRepeater_Click" Style="display: none;" ClientIDMode="AutoID" Text="Button" />
                <div id="taskSequence" class="modal hide">
                    <div class="loading" ng-show="loading === true"></div>
                    <h5>Sequenced Tasks: </h5>
                    <table class="table">
                        <tr>
                            
                            <td style="width:100%">
                                <div class="divDesigDropDown">
                                    Designation
                                    <asp:DropDownList ID="ddlDesigSeq" CssClass="textbox" runat="server" AutoPostBack="false"></asp:DropDownList>
                                </div>
                                <div class="divPageSize">
                                    Page Size
                                    <select id="seqPageSizeDropDown" class="textbox">
                                        <option value="0">All</option>
                                        <option value="5">5</option>
                                        <option value="10" selected>10</option>
                                        <option value="15">15</option>
                                        <option value="20">20</option>
                                        <option value="25">25</option>
                                    </select>
                                </div>
                            </td>
                            <td>
                                <label>
                                    <%--  <select id="lstbMasterAssign" ng-options="item as item.FristName for item in DesignationAssignUsers track by item.Id" ng-model="DesignationAssignUsersModel" multiple>
                                    </select>--%>
                                    <input type="checkbox" style="display: none;" />
                                </label>
                            </td>

                        </tr>
                    </table>

                    <div id="taskSequenceTabs">
                        <ul>
                            <li><a href="#StaffTask">Staff Tasks</a></li>
                            <li><a href="#TechTask">Tech Tasks</a></li>
                            <li><a href="#Notes">Notes</a></li>
                        </ul>
                        <div id="StaffTask">
                            

                            <div id="tblStaffSeq" class="div-table tableSeqTask">
                                <!-- Header Div starts -->
                                <div class="div-table-row-header">
                                    <div class="div-table-col seq-number">Sequence#</div>
                                    <div class="div-table-col seq-taskid">
                                        ID#<div>Designation</div>
                                    </div>
                                    <div class="div-table-col seq-tasktitle">
                                        Parent Task
                                        <div>SubTask Title</div>
                                    </div>
                                    <div class="div-table-col seq-taskstatus">
                                        Status<div>Assigned To</div>
                                    </div>
                                    <div class="div-table-col seq-taskduedate">Due Date</div>
                                    <div class="div-table-col seq-notes">Notes</div>
                                </div>
                                <!-- Header Div Ends -->

                                <!-- NG Repeat Div starts -->
                                <div ng-attr-id="divMasterTask{{Task.TaskId}}" class="div-table-row" data-ng-repeat="Task in Tasks" ng-class-odd="'FirstRow'" ng-class="{yellowthickborder: Task.TaskId == BlinkTaskId, 'faded-row': !Task.AdminStatus || !Task.TechLeadStatus}" ng-class-even="'AlternateRow'" repeat-end="onStaffEnd()">
                                    <!-- Sequence# starts -->
                                    <div class="div-table-col seq-number">
                                        <a ng-attr-id="autoClick{{Task.TaskId}}" href="javascript:void(0);" onclick="showEditTaskSequence(this)" class="badge-hyperlink autoclickSeqEdit" ng-attr-data-taskseq="{{Task.Sequence}}" ng-attr-data-taskid="{{Task.TaskId}}" ng-attr-data-seqdesgid="{{Task.SequenceDesignationId}}"><span class="badge badge-success badge-xstext">
                                            <label ng-attr-id="SeqLabel{{Task.TaskId}}">{{getSequenceDisplayText(!Task.Sequence?"N.A.":Task.Sequence,Task.SequenceDesignationId,Task.IsTechTask === "false" ? "SS" : "TT")}}</label></span></a>
                                        <a style="text-decoration: none;" ng-show="!$first" ng-attr-data-taskid="{{Task.TaskId}}" href="javascript:void(0);" ng-class="{hide: Task.Sequence == null || 0}" ng-attr-data-taskseq="{{Task.Sequence}}" ng-hide="{{Task.TaskId == BlinkTaskId}}" ng-attr-data-taskdesg="{{Task.SequenceDesignationId}}" onclick="swapSequence(this,true)">&#9650;</a><a style="text-decoration: none;" ng-class="{hide: Task.Sequence == null || 0}" ng-attr-data-taskid="{{Task.TaskId}}" ng-attr-data-taskseq="{{Task.Sequence}}" ng-attr-data-taskdesg="{{Task.SequenceDesignationId}}" href="javascript:void(0);" onclick="swapSequence(this,false)" ng-show="!$last">&#9660;</a>
                                        <div class="handle-counter" ng-class="{hide: Task.TaskId != HighLightTaskId}" ng-attr-id="divSeq{{Task.TaskId}}">
                                            <input type="text hide" class="textbox " ng-attr-data-original-val='{{ Task.Sequence == null && 0 || Task.Sequence}}' ng-data-original-desgid='{{Task.SequenceDesignationId}}' ng-attr-id='txtSeq{{Task.TaskId}}' value="{{  Task.Sequence == null && 0 || Task.Sequence}}" />

                                            <div style="clear: both;">
                                                <a id="save" href="javascript:void(0);" ng-attr-data-taskid="{{Task.TaskId}}" onclick="javascript:UpdateTaskSequence(this);">Save</a>&nbsp;&nbsp; <a id="Delete" href="javascript:void(0);" ng-attr-data-taskid="{{Task.TaskId}}" ng-class="{hide: Task.Sequence == null || 0}" onclick="javascript:DeleteTaskSequence(this);">Delete</a>
                                            </div>

                                            <div ng-hide="{{Task.Sequence == null}}">
                                                <select class="textbox" ng-attr-data-taskid="{{Task.TaskId}}" ng-options="item as item.SeqLable for item in SeqSubsets track by item.TaskId" ng-model="SeqSubsets[0]">
                                                </select>
                                                <a href="javascript:void(0);" ng-attr-data-taskid="{{Task.TaskId}}" ng-attr-data-taskseq="{{Task.Sequence}}" onclick="SaveTaskSubSequence(this)">Add Subset</a>
                                            </div>
                                        </div>
                                    </div>
                                    <!-- Sequence# ends -->

                                    <!-- ID# and Designation starts -->
                                    <div class="div-table-col seq-taskid">
                                        <a ng-href="../Sr_App/TaskGenerator.aspx?TaskId={{Task.MainParentId}}&hstid={{Task.TaskId}}" class="bluetext" target="_blank">{{ Task.InstallId }}</a><br />
                                        {{getDesignationString(Task.TaskDesignation)}}
                                        <div ng-attr-id="divSeqDesg{{Task.TaskId}}" ng-class="{hide: Task.TaskId != HighLightTaskId}">
                                            <select class="textbox" ng-attr-data-taskid="{{Task.TaskId}}" onchange="setDropDownChangedData(this)" ng-options="item as item.Name for item in ParentTaskDesignations track by item.Id" ng-model="DesignationSelectModel[$index]">
                                            </select>
                                        </div>
                                    </div>
                                    <!-- ID# and Designation ends -->

                                    <!-- Parent Task & SubTask Title starts -->
                                    <div class="div-table-col seq-tasktitle">
                                        {{ Task.ParentTaskTitle }}
                                        <br />
                                        {{ Task.Title }}
                                    </div>
                                    <!-- Parent Task & SubTask Title ends -->

                                    <!-- Status & Assigned To starts -->
                                    <div class="div-table-col seq-taskstatus">
                                        <any ng-switch="Task.Status">
                    <any ng-switch-when="1">Open</any>
                    <any ng-switch-when="2">Requested</any>
                    <any ng-switch-when="3">Assigned</any>
                    <any ng-switch-when="4">InProgress</any>
                    <any ng-switch-when="5">Pending</any>
                    <any ng-switch-when="6">ReOpened</any>
                    <any ng-switch-when="7">Closed</any>
                    <any ng-switch-when="8">SpecsInProgress</any>
                    <any ng-switch-when="9">Deleted</any>
                    <any ng-switch-when="10">Finished</any>
                    <any ng-switch-when="11">Test</any>
                    <any ng-switch-when="12">Live</any>
                    <any ng-switch-when="14">Billed</any>
                    
                </any>
                                        <br />
                                        <%-- <select id="lstbAssign" data-chosen="1" data-placeholder="Select Users" ng-options="item as item.FristName for item in DesignationAssignUsers track by item.Id" ng-model="DesignationAssignUsersModel" multiple>
                                        </select>--%>
                                        <%--<asp:ListBox ID="ddcbSeqAssigned" runat="server" Width="100" ClientIDMode="AutoID" SelectionMode="Multiple"
                                            data-chosen="1" data-placeholder="Select Users" ng-options="item as item.FristName for item in DesignationAssignUsers track by item.Id" ng-model="DesignationAssignUsersModel"
                                            AutoPostBack="false">--%>
                                        <select id="ddcbSeqAssigned" style="width: 100px;" multiple ng-attr-data-assignedusers="{{Task.TaskAssignedUserIDs}}" data-chosen="1" data-placeholder="Select Users" onchange="EditSeqAssignedTaskUsers(this);" data-taskid="{{Task.TaskId}}" data-taskstatus="{{Task.Status}}">
                                            <option
                                                ng-repeat="item in DesignationAssignUsers"
                                                value="{{item.Id}}"
                                                label="{{item.FristName}}"
                                                class="{{item.CssClass}}">{{item.FristName}}
                                                
                                            </option>
                                        </select>

                                        <%--                                        <select id="ddcbSeqAssigned" style="width: 100px;" multiple  ng-options="item as item.FristName for item in DesignationAssignUsers track by item.Id"  ng-model="DesignationAssignUsersModel" ng-attr-data-AssignedUsers="{{Task.TaskAssignedUserIDs}}" data-chosen="1" data-placeholder="Select Users" onchange="EditSeqAssignedTaskUsers(this);" data-taskid="{{Task.TaskId}}" data-taskstatus="{{Task.Status}}">
                                        </select>--%>
                                    </div>
                                    <!-- Status & Assigned To ends -->

                                    <!-- DueDate starts -->
                                    <div class="div-table-col seq-taskduedate">
                                        <div class="seqapprovalBoxes">
                                            <div style="width: 65%; float: left;">
                                                <input type="checkbox" id="chkngUser" ng-checked="{{Task.OtherUserStatus}}" ng-disabled="{{Task.OtherUserStatus}}" class="fz fz-user" title="User" />
                                                <input type="checkbox" id="chkQA" class="fz fz-QA" title="QA" />
                                                <input type="checkbox" id="chkAlphaUser" class="fz fz-Alpha" title="AlphaUser" />
                                                <br />
                                                <input type="checkbox" id="chkBetaUser" class="fz fz-Beta" title="BetaUser" />
                                                <input type="checkbox" id="chkngITLead" ng-checked="{{Task.TechLeadStatus}}" ng-disabled="{{Task.TechLeadStatus}}" class="fz fz-techlead" title="IT Lead" />
                                                <input type="checkbox" id="chkngAdmin" ng-checked="{{Task.AdminStatus}}" ng-disabled="{{Task.AdminStatus}}" class="fz fz-admin" title="Admin" />
                                            </div>
                                            <div style="width: 30%; float: right;">
                                                <input type="checkbox" id="chkngITLeadMaster" class="fz fz-techlead largecheckbox" title="IT Lead" />
                                                <input type="checkbox" id="chkngAdminMaster" class="fz fz-admin largecheckbox" style="margin-top: -15px;" title="Admin" />
                                            </div>
                                        </div>

                                        <div ng-attr-data-taskid="{{Task.TaskId}}" class="seqapprovepopup">

                                            <div id="divTaskAdmin{{Task.TaskId}}" style="margin-bottom: 15px; font-size: x-small;">
                                                <div style="width: 10%;" class="display_inline">Admin: </div>
                                                <div style="width: 30%;" class="display_inline"></div>
                                                <div ng-class="{hide : StringIsNullOrEmpty(Task.AdminStatusUpdated), display_inline : !StringIsNullOrEmpty(Task.AdminStatusUpdated) }">
                                                    <a class="bluetext" href="CreateSalesUser.aspx?id={{Task.AdminUserId}}" target="_blank">{{StringIsNullOrEmpty(Task.AdminUserInstallId)? Task.AdminUserId : Task.AdminUserInstallId}} - {{Task.AdminUserFirstName}} {{Task.AdminUserLastName}}
                                                    </a>
                                                    <br />
                                                    <span>{{ Task.AdminStatusUpdated | date:'M/d/yyyy' }}</span>&nbsp;<span style="color: red">{{ Task.AdminStatusUpdated | date:'shortTime' }}</span>&nbsp;<span> {{StringIsNullOrEmpty(Task.AdminStatusUpdated) ? '' : '(EST)' }} </span>
                                                </div>
                                                <div ng-class="{hide : !StringIsNullOrEmpty(Task.AdminStatusUpdated), display_inline : StringIsNullOrEmpty(Task.AdminStatusUpdated) }">
                                                    <input type="password" style="width: 100px;" placeholder="Admin password" onchange="javascript:FreezeSeqTask(this);"
                                                        data-id="txtngstaffAdminPassword" data-hours-id="txtngstaffAdminEstimatedHours" ng-attr-data-taskid="{{Task.TaskId}}" />
                                                </div>
                                            </div>
                                            <div id="divTaskITLead{{Task.TaskId}}" style="margin-bottom: 15px; font-size: x-small;">
                                                <div style="width: 10%;" class="display_inline">ITLead: </div>
                                                <!-- ITLead Hours section -->
                                                <div style="width: 30%;" ng-class="{hide : StringIsNullOrEmpty(Task.ITLeadHours), display_inline : !StringIsNullOrEmpty(Task.ITLeadHours) }">
                                                    <span>
                                                        <label>{{Task.ITLeadHours}}</label>Hour(s)
                                                    </span>
                                                </div>
                                                <div style="width: 30%;" ng-class="{hide : !StringIsNullOrEmpty(Task.ITLeadHours), display_inline : StringIsNullOrEmpty(Task.ITLeadHours) }">
                                                    <input type="text" style="width: 55px;" placeholder="Est. Hours" data-id="txtngstaffITLeadEstimatedHours" />
                                                </div>
                                                <div style="width: 50%; float: right; font-size: x-small;" ng-class="{hide : !StringIsNullOrEmpty(Task.ITLeadHours), display_inline : StringIsNullOrEmpty(Task.ITLeadHours) }">
                                                    <input type="password" style="width: 100px;" placeholder="ITLead Password" onchange="javascript:FreezeSeqTask(this);"
                                                        data-id="txtngstaffITLeadPassword" data-hours-id="txtngstaffITLeadEstimatedHours" ng-attr-data-taskid="{{Task.TaskId}}" />
                                                </div>
                                                <!-- ITLead password section -->
                                                <div style="width: 50%; float: right; font-size: x-small;" ng-class="{hide : StringIsNullOrEmpty(Task.ITLeadHours), display_inline : !StringIsNullOrEmpty(Task.ITLeadHours) }">
                                                    <a class="bluetext" href="CreateSalesUser.aspx?id={{Task.TechLeadUserId}}" target="_blank">{{StringIsNullOrEmpty(Task.TechLeadUserInstallId)? Task.TechLeadUserId : Task.TechLeadUserInstallId}} - {{Task.TechLeadUserFirstName}} {{Task.TechLeadUserLastName}}
                                                    </a>
                                                    <br />
                                                    <span>{{ Task.TechLeadStatusUpdated | date:'M/d/yyyy' }}</span>&nbsp;<span style="color: red">{{ Task.TechLeadStatusUpdated | date:'shortTime' }}</span>&nbsp;<span> {{StringIsNullOrEmpty(Task.TechLeadStatusUpdated)? '' : '(EST)' }} </span>
                                                </div>

                                            </div>
                                            <div id="divUser{{Task.TaskId}}" style="margin-bottom: 15px; font-size: x-small;">
                                                <div style="width: 10%;" class="display_inline">User: </div>
                                                <!-- UserHours section -->
                                                <div style="width: 30%;" ng-class="{hide : StringIsNullOrEmpty(Task.UserHours), display_inline : !StringIsNullOrEmpty(Task.UserHours) }">
                                                    <span>
                                                        <label>{{Task.UserHours}}</label>Hour(s)
                                                        Hour(s)</span>
                                                </div>
                                                <div style="width: 30%;" ng-class="{hide : !StringIsNullOrEmpty(Task.UserHours), display_inline : StringIsNullOrEmpty(Task.UserHours) }">
                                                    <input type="text" style="width: 55px;" placeholder="Est. Hours" data-id="txtngstaffUserEstimatedHours" />
                                                </div>
                                                <div style="width: 50%; float: right; font-size: x-small;" ng-class="{hide : !StringIsNullOrEmpty(Task.UserHours), display_inline : StringIsNullOrEmpty(Task.UserHours) }">
                                                    <input type="password" style="width: 100px;" placeholder="User Password" onchange="javascript:FreezeSeqTask(this);"
                                                        data-id="txtngstaffUserPassword" data-hours-id="txtngstaffUserEstimatedHours" ng-attr-data-taskid="{{Task.TaskId}}" />
                                                </div>
                                                <!-- User password section -->
                                                <div style="width: 50%; float: right; font-size: x-small;" ng-class="{hide : StringIsNullOrEmpty(Task.UserHours), display_inline : !StringIsNullOrEmpty(Task.UserHours) }">
                                                    <a class="bluetext" href="CreateSalesUser.aspx?id={{Task.TechLeadUserId}}" target="_blank">{{StringIsNullOrEmpty(Task.OtherUserInstallId)? Task.OtherUserId : Task.OtherUserInstallId}} - {{Task.OtherUserFirstName}} {{Task.OtherUserLastName}}
                                                    </a>
                                                    <br />
                                                    <span>{{ Task.OtherUserStatusUpdated | date:'M/d/yyyy' }}</span>&nbsp;<span style="color: red">{{ Task.OtherUserStatusUpdated | date:'shortTime' }}</span>&nbsp;<span> {{StringIsNullOrEmpty(Task.OtherUserStatusUpdated)? '' : '(EST)' }} </span>
                                                </div>
                                            </div>
                                        </div>
                                    </div>
                                    <!-- DueDate ends -->

                                    <!-- Notes starts -->
                                    <div class="div-table-col seq-notes">
                                        Notes
                                    </div>
                                    <!-- Notes ends -->

                                    <!-- Nested row starts -->

                                    <div class="div-table-nested" ng-class="{hide : StringIsNullOrEmpty(Task.SubSeqTasks)}">

                                        <!-- Body section starts -->
                                        <div class="div-table-row" ng-repeat="TechTask in correctDataforAngular(Task.SubSeqTasks)" ng-class-odd="'FirstRow'" ng-class="{yellowthickborder: TechTask.TaskId == BlinkTaskId, 'faded-row': !TechTask.AdminStatus || !TechTask.TechLeadStatus}" ng-class-even="'AlternateRow'">
                                            <!-- Sequence# starts -->
                                            <div class="div-table-col seq-number">
                                                <a style="text-decoration: none;" ng-show="!$first" ng-attr-data-taskid="{{TechTask.TaskId}}" href="javascript:void(0);" class="uplink" ng-class="{hide: TechTask.Sequence == null || 0}" ng-attr-data-taskseq="{{TechTask.SubSequence}}" ng-attr-data-taskdesg="{{TechTask.SequenceDesignationId}}" onclick="swapSubSequence(this,true)">&#9650;</a><a style="text-decoration: none;" ng-class="{hide: TechTask.Sequence == null || 0}" ng-attr-data-taskid="{{TechTask.TaskId}}" ng-attr-data-taskseq="{{TechTask.SubSequence}}" class="downlink" ng-attr-data-taskdesg="{{TechTask.SequenceDesignationId}}" href="javascript:void(0);" ng-show="!$last" onclick="swapSubSequence(this,false)">&#9660;</a>
                                                <a ng-attr-id="autoClick{{Task.TaskId}}" href="javascript:void(0);" class="badge-hyperlink autoclickSeqEdit" onclick="showEditTaskSubSequence(this)" ng-attr-data-taskid="{{TechTask.TaskId}}" ng-attr-data-seqdesgid="{{TechTask.SequenceDesignationId}}"><span class="badge badge-error badge-xstext">
                                                    <label ng-attr-id="SeqLabel{{TechTask.TaskId}}">{{getSequenceDisplayText(!TechTask.Sequence?"N.A.":TechTask.Sequence + " (" + toRoman(TechTask.SubSequence)+ ")",TechTask.SequenceDesignationId,TechTask.IsTechTask == "false" ? "SS" : "TT")}}</label></span></a>
                                                <div class="handle-counter" ng-class="{hide: TechTask.TaskId != HighLightTaskId}" ng-attr-id="divSeq{{TechTask.TaskId}}">
                                                    <input type="text" class="textbox hide" ng-attr-data-original-val='{{ TechTask.Sequence == null && 0 || TechTask.Sequence}}' ng-attr-data-original-desgid="{{TechTask.SequenceDesignationId}}" ng-attr-id='txtSeq{{TechTask.TaskId}}' value="{{  TechTask.Sequence == null && 0 || TechTask.Sequence}}" />

                                                    <div style="clear: both;">
                                                        <a id="save" ng-hide="{{Task.Sequence != null}}" href="javascript:void(0);" ng-attr-data-taskid="{{TechTask.TaskId}}" onclick="">Save</a>&nbsp;&nbsp; <a id="Delete" href="javascript:void(0);" ng-attr-data-taskid="{{TechTask.TaskId}}" ng-class="{hide: TechTask.Sequence == null || 0}" onclick="javascript:DeleteTaskSubSequence(this);">Delete</a>
                                                    </div>
                                                </div>
                                            </div>
                                            <!-- Sequence# ends -->

                                            <!-- ID# and Designation starts -->
                                            <div class="div-table-col seq-taskid">
                                                <a ng-href="../Sr_App/TaskGenerator.aspx?TaskId={{TechTask.MainParentId}}&hstid={{TechTask.TaskId}}" class="bluetext" target="_blank">{{ TechTask.InstallId }}</a><br />
                                                {{getDesignationString(TechTask.TaskDesignation)}}
                                        <div ng-attr-id="divSeqDesg{{TechTask.TaskId}}" ng-class="{hide: TechTask.TaskId != HighLightTaskId}">
                                            <select class="textbox hide" ng-attr-data-taskid="{{TechTask.TaskId}}" onchange="showEditTaskSequence(this)" ng-options="item as item.Name for item in ParentTaskDesignations track by item.Id" ng-model="DesignationSelectModel[$index]">
                                            </select>
                                        </div>
                                            </div>
                                            <!-- ID# and Designation ends -->

                                            <!-- Parent Task & SubTask Title starts -->
                                            <div class="div-table-col seq-tasktitle">
                                                {{ TechTask.ParentTaskTitle }}
                                        <br />
                                                {{ TechTask.Title }}
                                            </div>
                                            <!-- Parent Task & SubTask Title ends -->

                                            <!-- Status & Assigned To starts -->
                                            <div class="div-table-col">
                                                <!-- Status & Assigned To starts -->
                                                <div class="div-table-col">
                                                    <any ng-switch="TechTask.Status">
                    <any ng-switch-when="1">Open</any>
                    <any ng-switch-when="2">Requested</any>
                    <any ng-switch-when="3">Assigned</any>
                    <any ng-switch-when="4">InProgress</any>
                    <any ng-switch-when="5">Pending</any>
                    <any ng-switch-when="6">ReOpened</any>
                    <any ng-switch-when="7">Closed</any>
                    <any ng-switch-when="8">SpecsInProgress</any>
                    <any ng-switch-when="9">Deleted</any>
                    <any ng-switch-when="10">Finished</any>
                    <any ng-switch-when="11">Test</any>
                    <any ng-switch-when="12">Live</any>
                    <any ng-switch-when="14">Billed</any>
                    
                </any>
                                                    <br />
                                                    <select id="ddcbSeqAssigned" style="width: 100px;" multiple ng-attr-data-assignedusers="{{TechTask.TaskAssignedUserIDs}}" data-chosen="1" data-placeholder="Select Users" onchange="EditSeqAssignedTaskUsers(this);" data-taskid="{{TechTask.TaskId}}" data-taskstatus="{{TechTask.Status}}">
                                                        <option
                                                            ng-repeat="item in DesignationAssignUsers"
                                                            value="{{item.Id}}"
                                                            label="{{item.FristName}}"
                                                            class="{{item.CssClass}}">{{item.FristName}}
                                                
                                                        </option>
                                                    </select>

                                                </div>
                                                <!-- Status & Assigned To ends -->


                                            </div>
                                            <!-- Body section ends -->
                                            <!-- DueDate starts -->
                                            <div class="div-table-col seq-taskduedate">
                                                <div class="seqapprovalBoxes">
                                                    <div style="width: 65%; float: left;">
                                                        <input type="checkbox" id="chkngUser" ng-checked="{{TechTask.OtherUserStatus}}" ng-disabled="{{TechTask.OtherUserStatus}}" class="fz fz-user" title="User" />
                                                        <input type="checkbox" id="chkQA" class="fz fz-QA" title="QA" />
                                                        <input type="checkbox" id="chkAlphaUser" class="fz fz-Alpha" title="AlphaUser" />
                                                        <br />
                                                        <input type="checkbox" id="chkBetaUser" class="fz fz-Beta" title="BetaUser" />
                                                        <input type="checkbox" id="chkngITLead" ng-checked="{{TechTask.TechLeadStatus}}" ng-disabled="{{TechTask.TechLeadStatus}}" class="fz fz-techlead" title="IT Lead" />
                                                        <input type="checkbox" id="chkngAdmin" ng-checked="{{TechTask.AdminStatus}}" ng-disabled="{{TechTask.AdminStatus}}" class="fz fz-admin" title="Admin" />
                                                    </div>
                                                    <div style="width: 30%; float: right;">
                                                        <input type="checkbox" id="chkngITLeadMaster" class="fz fz-techlead largecheckbox" title="IT Lead" />
                                                        <input type="checkbox" id="chkngAdminMaster" class="fz fz-admin largecheckbox" style="margin-top: -15px;" title="Admin" />
                                                    </div>
                                                </div>

                                                <div ng-attr-data-taskid="{{TechTask.TaskId}}" class="seqapprovepopup">

                                                    <div id="divTaskAdmin{{TechTask.TaskId}}" style="margin-bottom: 15px; font-size: x-small;">
                                                        <div style="width: 10%;" class="display_inline">Admin: </div>
                                                        <div style="width: 30%;" class="display_inline"></div>
                                                        <div ng-class="{hide : StringIsNullOrEmpty(TechTask.AdminStatusUpdated), display_inline : !StringIsNullOrEmpty(TechTask.AdminStatusUpdated) }">
                                                            <a class="bluetext" href="CreateSalesUser.aspx?id={{TechTask.AdminUserId}}" target="_blank">{{StringIsNullOrEmpty(TechTask.AdminUserInstallId)? TechTask.AdminUserId : TechTask.AdminUserInstallId}} - {{TechTask.AdminUserFirstName}} {{TechTask.AdminUserLastName}}
                                                            </a>
                                                            <br />
                                                            <span>{{ TechTask.AdminStatusUpdated | date:'M/d/yyyy' }}</span>&nbsp;<span style="color: red">{{ TechTask.AdminStatusUpdated | date:'shortTime' }}</span>&nbsp;<span> {{StringIsNullOrEmpty(TechTask.AdminStatusUpdated) ? '' : '(EST)' }} </span>
                                                        </div>
                                                        <div ng-class="{hide : !StringIsNullOrEmpty(TechTask.AdminStatusUpdated), display_inline : StringIsNullOrEmpty(TechTask.AdminStatusUpdated) }">
                                                            <input type="password" style="width: 100px;" placeholder="Admin password" onchange="javascript:FreezeSeqTask(this);"
                                                                data-id="txtngstaffAdminPassword" data-hours-id="txtngstaffAdminEstimatedHours" ng-attr-data-taskid="{{TechTask.TaskId}}" />
                                                        </div>
                                                    </div>
                                                    <div id="divTaskITLead{{TechTask.TaskId}}" style="margin-bottom: 15px; font-size: x-small;">
                                                        <div style="width: 10%;" class="display_inline">ITLead: </div>
                                                        <!-- ITLead Hours section -->
                                                        <div style="width: 30%;" ng-class="{hide : StringIsNullOrEmpty(TechTask.ITLeadHours), display_inline : !StringIsNullOrEmpty(TechTask.ITLeadHours) }">
                                                            <span>
                                                                <label>{{TechTask.ITLeadHours}}</label>Hour(s)
                                                            </span>
                                                        </div>
                                                        <div style="width: 30%;" ng-class="{hide : !StringIsNullOrEmpty(TechTask.ITLeadHours), display_inline : StringIsNullOrEmpty(TechTask.ITLeadHours) }">
                                                            <input type="text" style="width: 55px;" placeholder="Est. Hours" data-id="txtngstaffITLeadEstimatedHours" />
                                                        </div>
                                                        <div style="width: 50%; float: right; font-size: x-small;" ng-class="{hide : !StringIsNullOrEmpty(TechTask.ITLeadHours), display_inline : StringIsNullOrEmpty(TechTask.ITLeadHours) }">
                                                            <input type="password" style="width: 100px;" placeholder="ITLead Password" onchange="javascript:FreezeSeqTask(this);"
                                                                data-id="txtngstaffITLeadPassword" data-hours-id="txtngstaffITLeadEstimatedHours" ng-attr-data-taskid="{{TechTask.TaskId}}" />
                                                        </div>
                                                        <!-- ITLead password section -->
                                                        <div style="width: 50%; float: right; font-size: x-small;" ng-class="{hide : StringIsNullOrEmpty(TechTask.ITLeadHours), display_inline : !StringIsNullOrEmpty(TechTask.ITLeadHours) }">
                                                            <a class="bluetext" href="CreateSalesUser.aspx?id={{TechTask.TechLeadUserId}}" target="_blank">{{StringIsNullOrEmpty(TechTask.TechLeadUserInstallId)? TechTask.TechLeadUserId : TechTask.TechLeadUserInstallId}} - {{TechTask.TechLeadUserFirstName}} {{TechTask.TechLeadUserLastName}}
                                                            </a>
                                                            <br />
                                                            <span>{{ TechTask.TechLeadStatusUpdated | date:'M/d/yyyy' }}</span>&nbsp;<span style="color: red">{{ TechTask.TechLeadStatusUpdated | date:'shortTime' }}</span>&nbsp;<span> {{StringIsNullOrEmpty(TechTask.TechLeadStatusUpdated)? '' : '(EST)' }} </span>
                                                        </div>

                                                    </div>
                                                    <div id="divUser{{TechTask.TaskId}}" style="margin-bottom: 15px; font-size: x-small;">
                                                        <div style="width: 10%;" class="display_inline">User: </div>
                                                        <!-- UserHours section -->
                                                        <div style="width: 30%;" ng-class="{hide : StringIsNullOrEmpty(TechTask.UserHours), display_inline : !StringIsNullOrEmpty(TechTask.UserHours) }">
                                                            <span>
                                                                <label>{{TechTask.UserHours}}</label>Hour(s)
                                                        Hour(s)</span>
                                                        </div>
                                                        <div style="width: 30%;" ng-class="{hide : !StringIsNullOrEmpty(TechTask.UserHours), display_inline : StringIsNullOrEmpty(TechTask.UserHours) }">
                                                            <input type="text" style="width: 55px;" placeholder="Est. Hours" data-id="txtngstaffUserEstimatedHours" />
                                                        </div>
                                                        <div style="width: 50%; float: right; font-size: x-small;" ng-class="{hide : !StringIsNullOrEmpty(TechTask.UserHours), display_inline : StringIsNullOrEmpty(TechTask.UserHours) }">
                                                            <input type="password" style="width: 100px;" placeholder="User Password" onchange="javascript:FreezeSeqTask(this);"
                                                                data-id="txtngstaffUserPassword" data-hours-id="txtngstaffUserEstimatedHours" ng-attr-data-taskid="{{TechTask.TaskId}}" />
                                                        </div>
                                                        <!-- User password section -->
                                                        <div style="width: 50%; float: right; font-size: x-small;" ng-class="{hide : StringIsNullOrEmpty(TechTask.UserHours), display_inline : !StringIsNullOrEmpty(TechTask.UserHours) }">
                                                            <a class="bluetext" href="CreateSalesUser.aspx?id={{TechTask.TechLeadUserId}}" target="_blank">{{StringIsNullOrEmpty(TechTask.OtherUserInstallId)? TechTask.OtherUserId : TechTask.OtherUserInstallId}} - {{TechTask.OtherUserFirstName}} {{TechTask.OtherUserLastName}}
                                                            </a>
                                                            <br />
                                                            <span>{{ TechTask.OtherUserStatusUpdated | date:'M/d/yyyy' }}</span>&nbsp;<span style="color: red">{{ TechTask.OtherUserStatusUpdated | date:'shortTime' }}</span>&nbsp;<span> {{StringIsNullOrEmpty(TechTask.OtherUserStatusUpdated)? '' : '(EST)' }} </span>
                                                        </div>
                                                    </div>
                                                </div>
                                            </div>
                                            <!-- DueDate ends -->
                                        </div>

                                        <!-- Nested row ends -->

                                    </div>
                                </div>

                                <div class="text-center">
                                    <jgpager page="{{page}}" pages-count="{{pagesCount}}" total-count="{{TotalRecords}}" search-func="getTasks(page)"></jgpager>
                                </div>
                                <div ng-show="loader.loading" style="position: absolute; left: 50%;">
                                    Loading...
                <img src="../img/ajax-loader.gif" />
                                </div>

                            </div>
                        </div>
                        <div id="TechTask">

                            <div id="tblTechSeq" class="div-table tableSeqTask">
                                <div class="div-table-row-header">
                                    <div class="div-table-col seq-number">Sequence#</div>
                                    <div class="div-table-col seq-taskid">
                                        ID#<div>Designation</div>
                                    </div>
                                    <div class="div-table-col seq-tasktitle">
                                        Parent Task
                                            <div>SubTask Title</div>
                                    </div>
                                    <div class="div-table-col seq-taskstatus">
                                        Status<div>Assigned To</div>
                                    </div>
                                    <div class="div-table-col seq-taskduedate">Due Date</div>
                                    <div class="div-table-col seq-notes">Notes</div>
                                </div>

                                <div ng-attr-id="divMasterTask{{Task.TaskId}}" class="div-table-row" data-ng-repeat="Task in TechTasks" ng-class-odd="'FirstRow'" ng-class="{'yellowthickborder': Task.TaskId == BlinkTaskId, 'faded-row': !Task.AdminStatus || !Task.TechLeadStatus}" ng-class-even="'AlternateRow'" repeat-end="onTechEnd()">

                                    <!-- Sequence# starts -->
                                    <div class="div-table-col seq-number">
                                        <a ng-attr-id="autoClick{{Task.TaskId}}" href="javascript:void(0);" onclick="showEditTaskSequence(this)" class="badge-hyperlink autoclickSeqEdit" ng-attr-data-taskid="{{Task.TaskId}}" ng-attr-data-seqdesgid="{{Task.SequenceDesignationId}}"><span class="badge badge-success badge-xstext">
                                            <label ng-attr-id="SeqLabel{{Task.TaskId}}">{{getSequenceDisplayText(!Task.Sequence?"N.A.":Task.Sequence,Task.SequenceDesignationId,Task.IsTechTask === "false" ? "SS" : "TT")}}</label></span></a><a style="text-decoration: none;" ng-attr-data-taskid="{{Task.TaskId}}" href="javascript:void(0);" class="uplink" ng-class="{hide: Task.Sequence == null || 0}" ng-attr-data-taskseq="{{Task.Sequence}}" ng-show="!$first" ng-attr-data-taskdesg="{{Task.SequenceDesignationId}}" onclick="swapSequence(this,true)">&#9650;</a><a style="text-decoration: none;" ng-class="{hide: Task.Sequence == null || 0}" ng-attr-data-taskid="{{Task.TaskId}}" ng-attr-data-taskseq="{{Task.Sequence}}" class="downlink" ng-attr-data-taskdesg="{{Task.SequenceDesignationId}}" href="javascript:void(0);" onclick="swapSequence(this,false)" ng-show="!$last">&#9660;</a>
                                        <div class="handle-counter" ng-class="{hide: Task.TaskId != HighLightTaskId}" ng-attr-id="divSeq{{Task.TaskId}}">
                                            <input type="text" class="textbox hide" ng-attr-data-original-val='{{ Task.Sequence == null && 0 || Task.Sequence}}' ng-attr-data-original-desgid="{{Task.SequenceDesignationId}}" ng-attr-id='txtSeq{{Task.TaskId}}' value="{{  Task.Sequence == null && 0 || Task.Sequence}}" />

                                            <div style="clear: both;">
                                                <a id="save" href="javascript:void(0);" ng-attr-data-taskid="{{Task.TaskId}}" onclick="javascript:UpdateTaskSequence(this);">Save</a>&nbsp;&nbsp; <a id="Delete" href="javascript:void(0);" ng-attr-data-taskid="{{Task.TaskId}}" ng-class="{hide: Task.Sequence == null || 0}" onclick="javascript:DeleteTaskSequence(this);">Delete</a>
                                            </div>
                                        </div>
                                    </div>
                                    <!-- Sequence# ends -->

                                    <!-- ID# and Designation starts -->
                                    <div class="div-table-col seq-taskid">
                                        <a ng-href="../Sr_App/TaskGenerator.aspx?TaskId={{Task.MainParentId}}&hstid={{Task.TaskId}}" class="bluetext" target="_blank">{{ Task.InstallId }}</a><br />
                                        {{getDesignationString(Task.TaskDesignation)}}
                                            <div ng-attr-id="divSeqDesg{{Task.TaskId}}" ng-class="{hide: Task.TaskId != HighLightTaskId}">
                                                <select class="textbox" ng-attr-data-taskid="{{Task.TaskId}}" onchange="setDropDownChangedData(this)" ng-options="item as item.Name for item in ParentTaskDesignations track by item.Id" ng-model="DesignationSelectModel[$index]">
                                                </select>
                                            </div>
                                    </div>
                                    <!-- ID# and Designation ends -->

                                    <!-- Parent Task & SubTask Title starts -->
                                    <div class="div-table-col seq-tasktitle">
                                        {{ Task.ParentTaskTitle }}
                                            <br />
                                        {{ Task.Title }}
                                    </div>
                                    <!-- Parent Task & SubTask Title ends -->

                                    <!-- Status & Assigned To starts -->
                                    <div class="div-table-col seq-taskstatus">
                                        <any ng-switch="Task.Status">
                        <any ng-switch-when="1">Open</any>
                        <any ng-switch-when="2">Requested</any>
                        <any ng-switch-when="3">Assigned</any>
                        <any ng-switch-when="4">InProgress</any>
                        <any ng-switch-when="5">Pending</any>
                        <any ng-switch-when="6">ReOpened</any>
                        <any ng-switch-when="7">Closed</any>
                        <any ng-switch-when="8">SpecsInProgress</any>
                        <any ng-switch-when="9">Deleted</any>
                        <any ng-switch-when="10">Finished</any>
                        <any ng-switch-when="11">Test</any>
                        <any ng-switch-when="12">Live</any>
                        <any ng-switch-when="14">Billed</any>
                    
                    </any>
                                        <br />
                                        <%-- <select id="lstbAssign" data-chosen="1" data-placeholder="Select Users" ng-options="item as item.FristName for item in DesignationAssignUsers track by item.Id" ng-model="DesignationAssignUsersModel" multiple>
                                            </select>--%>
                                        <%--<asp:ListBox ID="ddcbSeqAssigned" runat="server" Width="100" ClientIDMode="AutoID" SelectionMode="Multiple"
                                                data-chosen="1" data-placeholder="Select Users" ng-options="item as item.FristName for item in DesignationAssignUsers track by item.Id" ng-model="DesignationAssignUsersModel"
                                                AutoPostBack="false">--%>
                                        <select id="ddcbSeqAssigned" style="width: 100px;" multiple ng-attr-data-assignedusers="{{Task.TaskAssignedUserIDs}}" data-chosen="1" data-placeholder="Select Users" onchange="EditSeqAssignedTaskUsers(this);" data-taskid="{{Task.TaskId}}" data-taskstatus="{{Task.Status}}">
                                            <option
                                                ng-repeat="item in DesignationAssignUsers"
                                                value="{{item.Id}}"
                                                label="{{item.FristName}}"
                                                class="{{item.CssClass}}">{{item.FristName}}
                                                
                                            </option>
                                        </select>

                                        <%--                                        <select id="ddcbSeqAssigned" style="width: 100px;" multiple  ng-options="item as item.FristName for item in DesignationAssignUsers track by item.Id"  ng-model="DesignationAssignUsersModel" ng-attr-data-AssignedUsers="{{Task.TaskAssignedUserIDs}}" data-chosen="1" data-placeholder="Select Users" onchange="EditSeqAssignedTaskUsers(this);" data-taskid="{{Task.TaskId}}" data-taskstatus="{{Task.Status}}">
                                            </select>--%>
                                    </div>
                                    <!-- Status & Assigned To ends -->

                                    <!-- DueDate starts -->
                                    <div class="div-table-col seq-taskduedate">
                                        <div class="seqapprovalBoxes">
                                            <div style="width: 65%; float: left;">
                                                <input type="checkbox" id="chkngUser" ng-checked="{{Task.OtherUserStatus}}" ng-disabled="{{Task.OtherUserStatus}}" class="fz fz-user" title="User" />
                                                <input type="checkbox" id="chkQA" class="fz fz-QA" title="QA" />
                                                <input type="checkbox" id="chkAlphaUser" class="fz fz-Alpha" title="AlphaUser" />
                                                <br />
                                                <input type="checkbox" id="chkBetaUser" class="fz fz-Beta" title="BetaUser" />
                                                <input type="checkbox" id="chkngITLead" ng-checked="{{Task.TechLeadStatus}}" ng-disabled="{{Task.TechLeadStatus}}" class="fz fz-techlead" title="IT Lead" />
                                                <input type="checkbox" id="chkngAdmin" ng-checked="{{Task.AdminStatus}}" ng-disabled="{{Task.AdminStatus}}" class="fz fz-admin" title="Admin" />
                                            </div>
                                            <div style="width: 30%; float: right;">
                                                <input type="checkbox" id="chkngITLeadMaster" class="fz fz-techlead largecheckbox" title="IT Lead" />
                                                <input type="checkbox" id="chkngAdminMaster" class="fz fz-admin largecheckbox" style="margin-top: -15px;" title="Admin" />
                                            </div>
                                        </div>

                                        <div ng-attr-data-taskid="{{Task.TaskId}}" class="seqapprovepopup">

                                            <div id="divTaskAdmin{{Task.TaskId}}" style="margin-bottom: 15px; font-size: x-small;">
                                                <div style="width: 10%;" class="display_inline">Admin: </div>
                                                <div style="width: 30%;" class="display_inline"></div>
                                                <div ng-class="{hide : StringIsNullOrEmpty(Task.AdminStatusUpdated), display_inline : !StringIsNullOrEmpty(Task.AdminStatusUpdated) }">
                                                    <a class="bluetext" href="CreateSalesUser.aspx?id={{Task.AdminUserId}}" target="_blank">{{StringIsNullOrEmpty(Task.AdminUserInstallId)? Task.AdminUserId : Task.AdminUserInstallId}} - {{Task.AdminUserFirstName}} {{Task.AdminUserLastName}}
                                                    </a>
                                                    <br />
                                                    <span>{{ Task.AdminStatusUpdated | date:'M/d/yyyy' }}</span>&nbsp;<span style="color: red">{{ Task.AdminStatusUpdated | date:'shortTime' }}</span>&nbsp;<span> {{StringIsNullOrEmpty(Task.AdminStatusUpdated) ? '' : '(EST)' }} </span>
                                                </div>
                                                <div ng-class="{hide : !StringIsNullOrEmpty(Task.AdminStatusUpdated), display_inline : StringIsNullOrEmpty(Task.AdminStatusUpdated) }">
                                                    <input type="password" style="width: 100px;" placeholder="Admin password" onchange="javascript:FreezeSeqTask(this);"
                                                        data-id="txtngstaffAdminPassword" data-hours-id="txtngstaffAdminEstimatedHours" ng-attr-data-taskid="{{Task.TaskId}}" />
                                                </div>
                                            </div>
                                            <div id="divTaskITLead{{Task.TaskId}}" style="margin-bottom: 15px; font-size: x-small;">
                                                <div style="width: 10%;" class="display_inline">ITLead: </div>
                                                <!-- ITLead Hours section -->
                                                <div style="width: 30%;" ng-class="{hide : StringIsNullOrEmpty(Task.ITLeadHours), display_inline : !StringIsNullOrEmpty(Task.ITLeadHours) }">
                                                    <span>
                                                        <label>{{Task.ITLeadHours}}</label>Hour(s)
                                                    </span>
                                                </div>
                                                <div style="width: 30%;" ng-class="{hide : !StringIsNullOrEmpty(Task.ITLeadHours), display_inline : StringIsNullOrEmpty(Task.ITLeadHours) }">
                                                    <input type="text" style="width: 55px;" placeholder="Est. Hours" data-id="txtngstaffITLeadEstimatedHours" />
                                                </div>
                                                <div style="width: 50%; float: right; font-size: x-small;" ng-class="{hide : !StringIsNullOrEmpty(Task.ITLeadHours), display_inline : StringIsNullOrEmpty(Task.ITLeadHours) }">
                                                    <input type="password" style="width: 100px;" placeholder="ITLead Password" onchange="javascript:FreezeSeqTask(this);"
                                                        data-id="txtngstaffITLeadPassword" data-hours-id="txtngstaffITLeadEstimatedHours" ng-attr-data-taskid="{{Task.TaskId}}" />
                                                </div>
                                                <!-- ITLead password section -->
                                                <div style="width: 50%; float: right; font-size: x-small;" ng-class="{hide : StringIsNullOrEmpty(Task.ITLeadHours), display_inline : !StringIsNullOrEmpty(Task.ITLeadHours) }">
                                                    <a class="bluetext" href="CreateSalesUser.aspx?id={{Task.TechLeadUserId}}" target="_blank">{{StringIsNullOrEmpty(Task.TechLeadUserInstallId)? Task.TechLeadUserId : Task.TechLeadUserInstallId}} - {{Task.TechLeadUserFirstName}} {{Task.TechLeadUserLastName}}
                                                    </a>
                                                    <br />
                                                    <span>{{ Task.TechLeadStatusUpdated | date:'M/d/yyyy' }}</span>&nbsp;<span style="color: red">{{ Task.TechLeadStatusUpdated | date:'shortTime' }}</span>&nbsp;<span> {{StringIsNullOrEmpty(Task.TechLeadStatusUpdated)? '' : '(EST)' }} </span>
                                                </div>

                                            </div>
                                            <div id="divUser{{Task.TaskId}}" style="margin-bottom: 15px; font-size: x-small;">
                                                <div style="width: 10%;" class="display_inline">User: </div>
                                                <!-- UserHours section -->
                                                <div style="width: 30%;" ng-class="{hide : StringIsNullOrEmpty(Task.UserHours), display_inline : !StringIsNullOrEmpty(Task.UserHours) }">
                                                    <span>
                                                        <label>{{Task.UserHours}}</label>Hour(s)
                                                            Hour(s)</span>
                                                </div>
                                                <div style="width: 30%;" ng-class="{hide : !StringIsNullOrEmpty(Task.UserHours), display_inline : StringIsNullOrEmpty(Task.UserHours) }">
                                                    <input type="text" style="width: 55px;" placeholder="Est. Hours" data-id="txtngstaffUserEstimatedHours" />
                                                </div>
                                                <div style="width: 50%; float: right; font-size: x-small;" ng-class="{hide : !StringIsNullOrEmpty(Task.UserHours), display_inline : StringIsNullOrEmpty(Task.UserHours) }">
                                                    <input type="password" style="width: 100px;" placeholder="User Password" onchange="javascript:FreezeSeqTask(this);"
                                                        data-id="txtngstaffUserPassword" data-hours-id="txtngstaffUserEstimatedHours" ng-attr-data-taskid="{{Task.TaskId}}" />
                                                </div>
                                                <!-- User password section -->
                                                <div style="width: 50%; float: right; font-size: x-small;" ng-class="{hide : StringIsNullOrEmpty(Task.UserHours), display_inline : !StringIsNullOrEmpty(Task.UserHours) }">
                                                    <a class="bluetext" href="CreateSalesUser.aspx?id={{Task.TechLeadUserId}}" target="_blank">{{StringIsNullOrEmpty(Task.OtherUserInstallId)? Task.OtherUserId : Task.OtherUserInstallId}} - {{Task.OtherUserFirstName}} {{Task.OtherUserLastName}}
                                                    </a>
                                                    <br />
                                                    <span>{{ Task.OtherUserStatusUpdated | date:'M/d/yyyy' }}</span>&nbsp;<span style="color: red">{{ Task.OtherUserStatusUpdated | date:'shortTime' }}</span>&nbsp;<span> {{StringIsNullOrEmpty(Task.OtherUserStatusUpdated)? '' : '(EST)' }} </span>
                                                </div>
                                            </div>
                                        </div>
                                    </div>
                                    <!-- DueDate ends -->

                                    <!-- Notes starts -->
                                    <div class="div-table-col seq-notes">
                                        Notes
                                    </div>
                                    <!-- Notes ends -->

                                </div>

                            </div>


                            <div class="text-center">
                                <jgpager page="{{Techpage}}" pages-count="{{TechpagesCount}}" total-count="{{TechTotalRecords}}" search-func="getTechTasks(page)"></jgpager>
                            </div>


                            <%--  <!-- UI-Grid Starts Here -->

                            <div id="divUIGrid" ng-controller="UiGridController">
                                <div ui-grid="gridOptions" ui-grid-expandable class="grid"></div>
                            </div>

                            <!-- UI-Grid Ends here -->--%>
                        </div>
                        <div id="Notes">
                            <div class="notes-section">
                                <div class="notes-popup">
                                    <div class="heading">
                                        <div class="title">User Touch Point Logs</div>

                                        <input type="hidden" id="PageIndex" value="0" />
                                    </div>
                                    <div class="content">
                                        Loading Notes...
                                    </div>
                                    <div class="pagingWrapper">
                                        <div class="total-results">Total <span class="total-results-count"></span>Results</div>
                                        <div class="pager">
                                            <span class="first">« First</span> <span class="previous">Previous</span> <span class="numeric"></span><span class="next">Next</span> <span class="last">Last »</span>
                                        </div>
                                        <div class="pageInfo">
                                        </div>
                                    </div>
                                    <div class="add-notes-container">
                                        <textarea id="note-text" class="note-text textbox"></textarea>
                                        <input type="button" class="GrdBtnAdd" value="Add Notes" onclick="addPopupNotes(this)" />
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>

                </div>

            </ContentTemplate>
            <Triggers>
                <asp:AsyncPostBackTrigger ControlID="btnUpdateRepeater" EventName="Click" />
            </Triggers>
        </asp:UpdatePanel>
    </div>
    <%--<asp:UpdatePanel ID="upEditSubTask" runat="server" UpdateMode="Conditional">
                <ContentTemplate>--%>
    <div id="pnlCalendar" runat="server" align="center" class="tasklistfieldset" style="display: none; background-color: white;">
        <table border="1" cellspacing="5" cellpadding="5" width="100%">
            <tr>
                <td>ListID:                
                                   

                    <asp:TextBox ID="txtInstallId" runat="server"></asp:TextBox>
                </td>

                <td>Sub Title <span style="color: red;">*</span>:
                  
                    <asp:TextBox ID="txtSubSubTitle" runat="server"></asp:TextBox>
                    <asp:RequiredFieldValidator ID="RequiredFieldValidator4" ValidationGroup="SubmitSubTask"
                        runat="server" ControlToValidate="txtSubSubTitle" ForeColor="Red"
                        ErrorMessage="Please Enter Task Title" Display="None"> </asp:RequiredFieldValidator>
                </td>

                <td>Priority <span style="color: red;">*</span>:

                    <asp:DropDownList ID="drpSubTaskPriority" runat="server" />
                    <asp:RequiredFieldValidator ID="RequiredFieldValidator6" runat="server" Display="None" ValidationGroup="SubmitSubTask"
                        ControlToValidate="drpSubTaskPriority" ErrorMessage="Please enter Task Priority." />
                </td>

                <td>Type <span style="color: red;">*</span>: 
                                   
                                   

                    <asp:DropDownList ID="drpSubTaskType" runat="server" />
                    <asp:RequiredFieldValidator ID="RequiredFieldValidator5" runat="server" Display="None" ValidationGroup="SubmitSubTask"
                        ControlToValidate="drpSubTaskType" ErrorMessage="Please enter Task Type." />
                </td>
            </tr>
            <tr>
                <td>Task Description <span style="color: red;">*</span>:
                                   
                    <br />
                    <asp:TextBox ID="txtTaskDesc" runat="server" CssClass="textbox" TextMode="MultiLine" Rows="5" Width="98%" />
                    <asp:RequiredFieldValidator ID="RequiredFieldValidator1" ValidationGroup="SubmitSubTask"
                        runat="server" ControlToValidate="txtTaskDesc" ForeColor="Red"
                        ErrorMessage="Please Enter Task Description" Display="None"> </asp:RequiredFieldValidator>
                </td>
            </tr>
            <tr>
                <td>
                    <asp:HiddenField ID="txtMode" runat="server" />
                    <asp:HiddenField ID="hdParentTaskId" runat="server" />
                    <asp:HiddenField ID="hdMainParentId" runat="server" />
                    <asp:HiddenField ID="hdTaskLvl" runat="server" />
                    <asp:HiddenField ID="hdTaskId" runat="server" />
                    <div class="btn_sec">
                        <%--<asp:Button ID="btnAddMoreSubtask" runat="server" OnClientClick="javascript:return OnAddMoreSubtaskClick();"
                            TabIndex="5" Text="Submit" CssClass="ui-button"
                            OnClick="btnAddMoreSubtask_Click" ValidationGroup="SubmitSubTask" />--%>
                        <asp:Button ID="btnAddMoreSubtask" runat="server" OnClientClick="javascript:return OnAddMoreSubtaskClick();"
                            TabIndex="5" Text="Submit" CssClass="ui-button" ValidationGroup="SubmitSubTask" />
                    </div>
                    <%-- <asp:Button ID="btnCalClose" runat="server" Height="30px" Width="70px" TabIndex="6"
                                                     OnClick="btnCalClose_Click" Text="Close" Style="background: url(img/main-header-bg.png) repeat-x; color: #fff;" />--%>
                </td>
            </tr>
        </table>
    </div>
    <%--    </ContentTemplate>
    </asp:UpdatePanel>--%>

    <asp:HiddenField ID="hdnAdminMode" runat="server" />

</fieldset>

<%--Popup Stars--%>
<div class="hide">

    <%--Sub Task Feedback Popup--%>
    <div id="divSubTaskFeedbackPopup" runat="server" title="Sub Task Feedback">
        <asp:UpdatePanel ID="upSubTaskFeedbackPopup" runat="server" UpdateMode="Conditional">
            <ContentTemplate>
                <fieldset>
                    <legend>
                        <asp:Literal ID="ltrlSubTaskFeedbackTitle" runat="server" /></legend>

                    <table id="tblAddEditSubTaskFeedback" runat="server" cellspacing="3" cellpadding="3" width="100%">
                        <tr>
                            <td colspan="2">&nbsp;
                            </td>
                        </tr>
                        <tr>
                            <td width="90" align="right" valign="top">Description:
                            </td>
                            <td>
                                <asp:TextBox ID="txtSubtaskComment" runat="server" CssClass="textbox" TextMode="MultiLine" Rows="4" Width="90%" />
                                <asp:RequiredFieldValidator ID="rfvComment" ValidationGroup="comment"
                                    runat="server" ControlToValidate="txtSubtaskComment" ForeColor="Red" ErrorMessage="Please comment" Display="None" />
                                <asp:ValidationSummary ID="vsComment" runat="server" ValidationGroup="comment" ShowSummary="False" ShowMessageBox="True" />
                            </td>
                        </tr>
                        <tr>
                            <td align="right" valign="top">Files:
                            </td>
                            <td>
                                <input id="hdnSubTaskNoteAttachments" runat="server" type="hidden" />
                                <input id="hdnSubTaskNoteFileType" runat="server" type="hidden" />
                                <div id="divSubTaskNoteDropzone" runat="server" class="dropzone work-file-Note">
                                    <div class="fallback">
                                        <input name="file" type="file" multiple />
                                        <input type="submit" value="Upload" />
                                    </div>
                                </div>
                                <div id="divSubTaskNoteDropzonePreview" runat="server" class="dropzone-previews work-file-previews-note">
                                </div>
                            </td>
                        </tr>
                        <tr>
                            <td colspan="2">
                                <div class="btn_sec">
                                    <asp:Button ID="btnSaveSubTaskFeedback" runat="server" ValidationGroup="comment" OnClick="btnSaveSubTaskFeedback_Click" CssClass="ui-button" Text="Save" />
                                    <asp:Button ID="btnSaveCommentAttachment" runat="server" OnClick="btnSaveCommentAttachment_Click" Style="display: none;" Text="Save Attachement" />
                                </div>
                            </td>
                        </tr>
                    </table>
                </fieldset>
            </ContentTemplate>
        </asp:UpdatePanel>
    </div>



</div>
<%--<script src="../Scripts/angular.min.js"></script>--%>
<%--<script src="http://ajax.googleapis.com/ajax/libs/angularjs/1.5.0/angular.js"></script>
<script src="http://ajax.googleapis.com/ajax/libs/angularjs/1.5.0/angular-touch.js"></script>
<script src="http://ajax.googleapis.com/ajax/libs/angularjs/1.5.0/angular-animate.js"></script>--%>
<%--<script src="../Scripts/ui-grid.min.js"></script>--%>
<%--<script src="../js/angular/scripts/jgapp.js"></script>--%>
<script src="http://ajax.googleapis.com/ajax/libs/angularjs/1.6.4/angular-sanitize.js"></script>
<script src="../js/angular/scripts/TaskSequence.js"></script>
<script src="../js/angular/scripts/TaskShare.js"></script>
<script src="../js/TaskSequencing.js"></script>
<%--<script src="../js/angular/scripts/TaskSequence-UiGrid.js"></script>--%>


<div id="descimgpopup1" class="Descoverlay">
    <div class="Descpopup">
        <a class="close" href="#" id="closebtn">&times;</a>
        <div class="content">
            <img src="" id="imgDesc" />
        </div>
    </div>
</div>
<%--Popup Ends--%>
<script type="text/javascript" src="<%=Page.ResolveUrl("~/js/handleCounter.js")%>"></script>


<script type="text/template" class="hide" data-id="divSubTaskCommentTemplate">
    <table width="100%">
        <tbody data-parent-commentid="{ParentCommentId}">
        </tbody>
        <tfoot data-parent-commentid="{ParentCommentId}">
            <tr>
                <td class="noborder">
                    <a href="javascript:void(0);" data-id="hypViewComments" data-taskid="{TaskId}"
                        data-parent-commentid="{ParentCommentId}" data-startindex="0" data-pagesize="0"
                        onclick="javascript:SubTaskCommentScript.GetTaskComments(this);">View {RemainingRecords} more comments</a>
                    <a href="javascript:void(0);" data-taskid="{TaskId}" data-parent-commentid="{ParentCommentId}" class="hide"
                        onclick="javascript:SubTaskCommentScript.AddTaskComment(this);">Comment +</a>
                </td>
            </tr>
            <tr data-id="trAddComment" style="display: none;">
                <td class="noborder">
                    <div>
                        <textarea data-id="txtComment" class="textbox" style="width: 90%; height: 50px;"></textarea>
                    </div>
                    <a href="javascript:void(0);" data-id="hypSaveComment" data-comment-id="0" data-taskid="{TaskId}" data-parent-commentid="{ParentCommentId}"
                        onclick="javascript:SubTaskCommentScript.SaveTaskComment(this);">Save</a>
                    <a href="javascript:void(0);" data-id="hypCancelComment" data-taskid="{TaskId}" data-parent-commentid="{ParentCommentId}"
                        onclick="javascript:SubTaskCommentScript.CancelTaskComment(this);">Cancel</a>
                </td>
            </tr>
        </tfoot>
    </table>
</script>

<script type="text/template" class="hide" data-id="divSubTaskCommentRowTemplate">
    <tr data-commentid="{Id}">
        <td class="noborder">
            <div class="taskComment">
                {Comment}               
              
                    <div class="ctimestmap">
                        <a href='<%=Page.ResolveUrl("CreateSalesUser.aspx?id={UserId}")%>' target="_blank">{UserInstallId} - {UserFirstName} {UserLastName}
                        </a>
                        <br />
                        <span>{DateCreated_MDYYYY}</span>&nbsp<span style="color: red">{TimeCreated_HHMMSSTT}</span>&nbsp;<span>(EST)</span>
                    </div>


            </div>
            <a href="javascript:void(0);" data-id="hypViewReplies" data-taskid="{TaskId}" data-parent-commentid="{Id}" class="hide"
                data-startindex="0" data-pagesize="0" style="margin-left: 10px;"
                onclick="javascript:SubTaskCommentScript.GetTaskComments(this);">View {TotalChildRecords} Replies&nbsp;</a>
            <a href="javascript:void(0);" data-id="hypAddReply" data-taskid="{TaskId}" data-parent-commentid="{Id}"
                data-startindex="0" data-pagesize="0" onclick="javascript:SubTaskCommentScript.AddTaskComment(this);">Reply</a>
            <div data-id="divSubTaskCommentPlaceHolder" data-taskid="{TaskId}" data-parent-commentid="{Id}" class="taskdesc"
                style="margin-left: 10px;">
            </div>
            <div id="replyComment" class="hide replycomment" data-parent-commentid="{ParentCommentId}">
                <div>
                    <textarea data-id="txtComment" class="textbox" style="width: 90%; height: 50px;"></textarea>
                </div>
                <a href="javascript:void(0);" data-id="hypSaveComment" data-comment-id="0" data-taskid="{TaskId}" data-parent-commentid="{Id}"
                    onclick="javascript:SubTaskCommentScript.SaveTaskComment(this);">Save</a>
                <a href="javascript:void(0);" data-id="hypCancelComment" data-taskid="{TaskId}" data-parent-commentid="{ParentCommentId}"
                    onclick="javascript:SubTaskCommentScript.CancelTaskComment(this);">Cancel</a>
            </div>
        </td>
    </tr>
</script>

<script type="text/javascript" data-id="divSubTaskCommentScript">

    function OnMultiLevelChildSave() {
        var key = window.event.keyCode;

        // If the user has pressed enter
        if (key === 13) {
            alert('save');
            return false;
        }
        else {
            return true;
        }
    }

    function selectChildren(obj) {
        var taskid = $(obj).attr('data-taskid');
        $('#selectboxes' + taskid + ' input').each(function () {
            $(this).prop('checked', !($(this).attr('checked')));
        });
    }

    function OnIndent(obj) {
        var taskid = $(obj).attr('data-taskid');
        var currentIndent = $('#listId' + taskid).attr('data-level');
        var action = $(obj).attr('data-action');
        var lastLevel = $('#lastData' + taskid).val();
        var lastLabel = $('#lastData' + taskid).attr('data-label');

        switch (currentIndent) {
            case '1': {
                if (action == 'right') {
                    $('#nestLevel' + taskid).val(2);                    
                    $('#listId' + taskid).attr('data-level', 2);
                    currentIndent = 2;
                    if (lastLevel != 1) {
                        var label = 'i';
                        var endLabel = '';

                        $('.ChildRow' + taskid).each(function () {
                            var l = $(this).attr('data-level');
                            var b = $(this).attr('data-label');
                            if (l == '2') {
                                endLabel = b;
                            }
                        });
                        var num = roman_to_Int(endLabel.toUpperCase());
                        label = romanize(num + 1).toLowerCase();
                        $('#listId' + taskid).attr('data-label', label);
                        $('#listId' + taskid).html(label);
                    }
                    else {
                        var label = 'i';
                        $('#listId' + taskid).attr('data-label', label);
                        $('#listId' + taskid).html(label);
                        
                    }
                }
                else {
                    alert('Not Supported');
                }
                break;
            }
            case '2': {
                if (action == 'right') {
                    $('#nestLevel' + taskid).val(3);
                    $('#listId' + taskid).attr('data-level', 3);
                    currentIndent = 3;
                    if (lastLevel == 3) {
                        var label = 'a';
                        var endLabel = '';

                        $('.ChildRow' + taskid).each(function () {
                            var l = $(this).attr('data-level');
                            var b = $(this).attr('data-label');
                            if (l == '3') {
                                endLabel = b;
                            }
                        });
                        var num = (endLabel.charCodeAt(0) - 97) + 1;
                        label = idOf(num);
                        $('#listId' + taskid).attr('data-label', label);
                        $('#listId' + taskid).html(label);

                    }
                    else {
                        if (lastLevel != 1) {
                            $('#listId' + taskid).attr('data-label', 'a');
                            $('#listId' + taskid).html('a');
                        }
                        else {
                            $('#nestLevel' + taskid).val(2);
                            $('#listId' + taskid).attr('data-level', 2);
                        }
                    }
                    
                }
                else {
                    $('#nestLevel' + taskid).val(1);
                    $('#listId' + taskid).attr('data-level', 1);
                    var label = 'I';
                    var endLabel = '';

                    $('.ChildRow' + taskid).each(function () {
                        var l = $(this).attr('data-level');
                        var b = $(this).attr('data-label');
                        if (l == '1') {
                            endLabel = b;
                        }
                    });
                    var num = roman_to_Int(endLabel.toUpperCase());
                    label = romanize(num + 1).toUpperCase();
                    $('#listId' + taskid).attr('data-label', label);
                    $('#listId' + taskid).html(label);
                    
                }
                break;
            }
            case '3': {
                if (action == 'left') {
                    $('#nestLevel' + taskid).val(2);
                    $('#listId' + taskid).attr('data-level', 2);

                    if (lastLevel != 1) {
                        var label = 'i';
                        var endLabel = '';

                        $('.ChildRow' + taskid).each(function () {
                            var l = $(this).attr('data-level');
                            var b = $(this).attr('data-label');
                            if (l == '2') {
                                endLabel = b;
                            }
                        });
                        var num = roman_to_Int(endLabel.toUpperCase());
                        label = romanize(num + 1).toLowerCase();
                        $('#listId' + taskid).attr('data-label', label);
                        $('#listId' + taskid).html(label);
                    }
                    else {
                        var label = 'i';
                        $('#listId' + taskid).attr('data-label', label);
                        $('#listId' + taskid).html(label);

                    }
                }
                else {
                    alert('Not Supported');
                }
                break;
            }
        }
    }
    
    var SubTaskCommentScript = {};

    SubTaskCommentScript.Initialize = function () {
        $('a[data-id="hypViewInitialComments"]').click();
    };

    SubTaskCommentScript.GetTaskComments = function (sender) {

        var viewlink = $(sender);
        var strTaskId = viewlink.attr('data-taskid');

        var strParentCommentId = viewlink.attr('data-parent-commentid');
        var strStartIndex = viewlink.attr('data-startindex');
        var strPageSize = viewlink.attr('data-pagesize');

        if (strPageSize == "0") {
            strPageSize = null;
        }

        var postData = {
            "intTaskId": strTaskId,
            "intParentCommentId": strParentCommentId,
            "intStartIndex": strStartIndex,
            "intPageSize": strPageSize
        };

        CallJGWebService('GetTaskComments', postData, function (data) { OnGetTaskCommentsSuccess(data, sender) });

        function OnGetTaskCommentsSuccess(data, sender) {
            if (data.d.Success) {
                var viewlink = $(sender);
                var strTaskId = viewlink.attr('data-taskid');
                var strParentCommentId = viewlink.attr('data-parent-commentid');
                var strStartIndex = viewlink.attr('data-startindex');
                var strPageSize = viewlink.attr('data-pagesize');

                var strSubTaskCommentTemplate = $('script[data-id="divSubTaskCommentTemplate"]').html();
                strSubTaskCommentTemplate = strSubTaskCommentTemplate.replace(/{ParentCommentId}/gi, strParentCommentId);
                strSubTaskCommentTemplate = strSubTaskCommentTemplate.replace(/{TaskId}/gi, strTaskId);
                strSubTaskCommentTemplate = strSubTaskCommentTemplate.replace(/{RemainingRecords}/gi, data.d.RemainingRecords.toString());
                strSubTaskCommentTemplate = strSubTaskCommentTemplate.replace(/{TotalRecords}/gi, data.d.TotalRecords.toString());

                var $SubTaskCommentTemplate = $(strSubTaskCommentTemplate);

                if (data.d.RemainingRecords <= 0) {
                    //$SubTaskCommentTemplate.find('a[data-id="hypViewComments"]').html('View More Replies');
                    $SubTaskCommentTemplate.find('a[data-id="hypViewComments"]').hide();
                }

                for (var i = 0; i < data.d.TaskComments.length; i++) {

                    var objTaskComment = data.d.TaskComments[i];

                    var strSubTaskCommentRowTemplate = $('script[data-id="divSubTaskCommentRowTemplate"]').html();
                    strSubTaskCommentRowTemplate = strSubTaskCommentRowTemplate.replace(/{Id}/gi, objTaskComment.Id.toString());
                    strSubTaskCommentRowTemplate = strSubTaskCommentRowTemplate.replace(/{Comment}/gi, objTaskComment.Comment);
                    strSubTaskCommentRowTemplate = strSubTaskCommentRowTemplate.replace(/{ParentCommentId}/gi, objTaskComment.ParentCommentId.toString());
                    strSubTaskCommentRowTemplate = strSubTaskCommentRowTemplate.replace(/{TaskId}/gi, objTaskComment.TaskId.toString());
                    strSubTaskCommentRowTemplate = strSubTaskCommentRowTemplate.replace(/{UserId}/gi, objTaskComment.UserId.toString());

                    var intDateCreated = parseInt(objTaskComment.DateCreated.replace(/\//gi, '').replace('Date', '').replace(/[(]/gi, '').replace(/[)]/gi, ''));

                    strSubTaskCommentRowTemplate = strSubTaskCommentRowTemplate.replace(/{DateCreated_MDYYYY}/gi, SubTaskCommentScript.GetDate_MDYYYY(intDateCreated));
                    strSubTaskCommentRowTemplate = strSubTaskCommentRowTemplate.replace(/{TimeCreated_HHMMSSTT}/gi, SubTaskCommentScript.GetTime_HHMMSSTT(intDateCreated));
                    strSubTaskCommentRowTemplate = strSubTaskCommentRowTemplate.replace(/{TotalChildRecords}/gi, objTaskComment.TotalChildRecords.toString());
                    strSubTaskCommentRowTemplate = strSubTaskCommentRowTemplate.replace(/{UserName}/gi, objTaskComment.UserName);
                    strSubTaskCommentRowTemplate = strSubTaskCommentRowTemplate.replace(/{UserFirstName}/gi, objTaskComment.UserFirstName);
                    strSubTaskCommentRowTemplate = strSubTaskCommentRowTemplate.replace(/{UserLastName}/gi, objTaskComment.UserLastName);
                    strSubTaskCommentRowTemplate = strSubTaskCommentRowTemplate.replace(/{UserInstallId}/gi, objTaskComment.UserInstallId);
                    strSubTaskCommentRowTemplate = strSubTaskCommentRowTemplate.replace(/{UserEmail}/gi, objTaskComment.UserEmail);

                    $SubTaskCommentRowTemplate = $(strSubTaskCommentRowTemplate);

                    if (objTaskComment.ParentCommentId != 0) {
                        //$SubTaskCommentRowTemplate.find('a[data-id="hypAddReply"]').hide();
                        $SubTaskCommentRowTemplate.find('a[data-id="hypViewReplies"]').hide();
                    }
                    else {
                        //$SubTaskCommentRowTemplate.find('a[data-id="hypAddReply"]').show();
                    }

                    //console.log(objTaskComment.TotalChildRecords);

                    if (objTaskComment.TotalChildRecords != 0) {

                        $SubTaskCommentRowTemplate.find('a[data-id="hypViewReplies"]').removeClass('hide');
                    }

                    $SubTaskCommentTemplate.append($SubTaskCommentRowTemplate);
                }
                $('div[data-id="divSubTaskCommentPlaceHolder"][data-taskid="' + strTaskId + '"][data-parent-commentid="' + strParentCommentId + '"]').html('');
                $('div[data-id="divSubTaskCommentPlaceHolder"][data-taskid="' + strTaskId + '"][data-parent-commentid="' + strParentCommentId + '"]').append($SubTaskCommentTemplate);

                //$SubTaskCommentTemplate.find('a[data-id="hypViewReplies"]').click();
            }
        }
    };

    SubTaskCommentScript.SaveTaskComment = function (sender) {
        var $sender = $(sender);
        var strId = $sender.attr('data-comment-id');
        var strTaskId = $sender.attr('data-taskid');
        var strParentCommentId = $sender.attr('data-parent-commentid');
        var $divSubTaskCommentPlaceHolder = $('div[data-id="divSubTaskCommentPlaceHolder"][data-taskid="' + strTaskId + '"][data-parent-commentid="' + strParentCommentId + '"]');
        var $tfoot;

        if ($sender.parent().attr('id') == "replyComment") {
            $tfoot = $sender.parent();
        }
        else {
            $tfoot = $divSubTaskCommentPlaceHolder.find('tfoot[data-parent-commentid="' + strParentCommentId + '"]');
        }

        var strComment = $tfoot.find('textarea[data-id="txtComment"]').val();

        if (strComment != '') {
            var postData = {
                strId: strId,
                strComment: strComment,
                strParentCommentId: strParentCommentId,
                strTaskId: strTaskId
            };

            CallJGWebService('SaveTaskComment', postData, function (data) { OnSaveTaskCommentSuccess(data, sender) });

            function OnSaveTaskCommentSuccess(data, sender) {
                if (data.d.Success) {
                    console.log(data.d);

                    var $sender = $(sender);
                    var strTaskId = $sender.attr('data-taskid');
                    var strParentCommentId = $sender.attr('data-parent-commentid');
                    var $divSubTaskCommentPlaceHolder = $('div[data-id="divSubTaskCommentPlaceHolder"][data-taskid="' + strTaskId + '"][data-parent-commentid="' + strParentCommentId + '"]');
                    var $tfoot;

                    if ($sender.parent().attr('id') == "replyComment") {
                        $tfoot = $sender.parent();
                        $tfoot.addClass('hide');
                    }
                    else {
                        $tfoot = $divSubTaskCommentPlaceHolder.find('tfoot[data-parent-commentid="' + strParentCommentId + '"]');
                        $tfoot.find('tr[data-id="trAddComment"]').hide();
                    }

                    //$tfoot.find('a[data-id="hypViewComments"]').click();
                    $('a[data-id="hypViewInitialComments"]').click();
                }
            }
        }
    };

    SubTaskCommentScript.CancelTaskComment = function (sender) {
        var $sender = $(sender);
        var strTaskId = $sender.attr('data-taskid');
        var strParentCommentId = $sender.attr('data-parent-commentid');
        var $divSubTaskCommentPlaceHolder = $('div[data-id="divSubTaskCommentPlaceHolder"][data-taskid="' + strTaskId + '"][data-parent-commentid="' + strParentCommentId + '"]');
        var $tfoot;

        if ($sender.parent().attr('id') == "replyComment") {
            $tfoot = $sender.parent();
            $tfoot.find('textarea[data-id="txtComment"]').val('');
            $tfoot.addClass('hide');
        }
        else {
            $tfoot = $divSubTaskCommentPlaceHolder.find('tfoot[data-parent-commentid="' + strParentCommentId + '"]');
            $tfoot.find('textarea[data-id="txtComment"]').val('');
            $tfoot.find('tr[data-id="trAddComment"]').hide();
        }


    };

    SubTaskCommentScript.AddTaskComment = function (sender) {

        var $sender = $(sender);
        var strTaskId = $sender.attr('data-taskid');
        var strParentCommentId = $sender.attr('data-parent-commentid');

        var $divSubTaskCommentPlaceHolder = $('div[data-id="divSubTaskCommentPlaceHolder"][data-taskid="' + strTaskId + '"][data-parent-commentid="' + strParentCommentId + '"]');
        var $tfoot;

        if ($sender.html() == "Reply") {
            $tfoot = $sender.siblings('div[id="replyComment"]');
            //console.log($tfoot.html());
            $tfoot.removeClass('hide');
        }
        else {
            $tfoot = $divSubTaskCommentPlaceHolder.find('tfoot[data-parent-commentid="' + strParentCommentId + '"]');
        }

        $tfoot.find('textarea[data-id="txtComment"]').val('');
        $tfoot.find('tr[data-id="trAddComment"]').show();
    };

    SubTaskCommentScript.GetDate_MDYYYY = function (date) {
        //console.log(date);
        var objDate = new Date(date);

        var dd = objDate.getDate();
        var mm = objDate.getMonth() + 1; //January is 0! 
        var yyyy = objDate.getFullYear();

        //if (dd < 10) { dd = '0' + dd; } if (mm < 10) { mm = '0' + mm; }

        return (dd + '/' + mm + '/' + yyyy);
    }

    SubTaskCommentScript.GetTime_HHMMSSTT = function (date) {
        var objDate = new Date(date);

        var hh = objDate.getHours();
        var mm = objDate.getMinutes();
        var ss = objDate.getSeconds();

        //if (dd < 10) { dd = '0' + dd; } if (mm < 10) { mm = '0' + mm; }

        return (hh + ':' + mm + ':' + ss);
    }
</script>

<script type="text/javascript">
    var updateRepeaterButton = $('#<%=btnUpdateRepeater.ClientID%>');
    Dropzone.autoDiscover = false;
    var ddlDesigSeqClientID = '#<%=ddlDesigSeq.ClientID%>';

    $(function () {
        ucSubTasks_Initialize();
    });

    var prmTaskGenerator = Sys.WebForms.PageRequestManager.getInstance();

    prmTaskGenerator.add_endRequest(function () {
        console.log('end req.');

        ucSubTasks_Initialize();

        SetUserAutoSuggestion();
        SetUserAutoSuggestionUI();
        initializeAngular();
    });

    prmTaskGenerator.add_beginRequest(function () {
        console.log('begin req.');
        DestroyGallery();
        DestroyDropzones();
        DestroyCKEditors();
    });
    var IsAdminMode = 'False';
    $(document).ready(function () {
        TouchPointSource =<%=(int)JG_Prospect.Common.TouchPointSource.TaskGenerator %>;
        IsAdminMode = '<%=IsAdminMode%>';
        //SubTask Enter Event
        $("#subtaskDesc").keyup(function (event) {
            if (event.keyCode === 13) {
                alert("enter");
                return;
            }
        });

        SetUserAutoSuggestion();
        SetUserAutoSuggestionUI();
        Paging($(this));
        $('#<%=ddlTaskType.ClientID%>').change(function () {
            if ($("#<%=ddlTaskType.ClientID%>").val() == 3) {
                // as per discussion, estimated hours and task hour fields should be removed.
                //$("#<%=trDateHours.ClientID%>").css({ 'display': "block" });
            }
            else {
                // as per discussion, estimated hours and task hour fields should be removed.
                //$("#<%=trDateHours.ClientID%>").css({ 'display': "none" });
            }
            return false;
        })
    });


    var maintask = true;

    function shownewsubtask() {

        maintask = true;
        // SetLatestSequenceForAddNewSubTask();
        $('#<%=hdTaskLvl.ClientID%>').val("1");
        //$('#<%=txtTaskListID.ClientID%>').val($('#<%=hdnTaskListId.ClientID%>').val());
        $('#<%=chkTechTask.ClientID%>').prop('checked', false)
        $("#<%=divNEWSubTask.ClientID%>").css({ 'display': "block" });

        return false;
    }

    function changeTaskStatusClosed(Task) {
        var StatusId = Task.value;
        var TaskId = Task.getAttribute('data-highlighter');
        var data = { intTaskId: TaskId, TaskStatus: StatusId };
        $.ajax({
            type: "POST",
            url: url + "SetTaskStatus",
            data: data,
            success: function (result) {
                alert("Task Status Changed.");

                LoadSubTasks();
            },
            error: function (errorThrown) {
                alert("Failed!!!");
            }
        });
    }


    function setReassignableTaskType(Task) {
        if (IsAdminMode == 'True') {
            var Checked = $(Task).is(':checked');
            var TaskId = Task.getAttribute('data-taskid');
            var data = { intTaskId: TaskId, TaskType: Checked };
            $.ajax({
                type: "POST",
                url: url + "SetReassignableTaskType",
                data: data,
                success: function (result) {
                    alert("Task set to reoccuring successfully.");
                    LoadSubTasks();
                },
                error: function (errorThrown) {
                    alert("Failed!!!");
                }
            });
        }
    }

    function setTaskType(Task) {
        if (IsAdminMode=='True') {
            var Checked = $(Task).is(':checked');
            var TaskId = Task.getAttribute('data-taskid');
            var data = { intTaskId: TaskId, TaskType: Checked };
            $.ajax({
                type: "POST",
                url: url + "SetTaskType",
                data: data,
                success: function (result) {
                    alert("Task Type Changed.");
                    LoadSubTasks();
                },
                error: function (errorThrown) {
                    alert("Failed!!!");
                }
            });
        }
    }

    var control;
    var isadded = false;    

    function pageLoad(sender, args) {
        $('#closebtn').bind("click", function () {
            $('#descimgpopup1').css({ 'visibility': "hidden" });
            $('#descimgpopup1').css({ 'opacity': "0" });
            return false;
        });
        $(".DescEdit img").each(function (index) {
            $(this).unbind('click').click(function () {
            });
            $(this).bind("click", function () {
                var imgPath = $(this).attr("src");
                $('#imgDesc').attr("src", imgPath);
                $('#descimgpopup1').css({ 'visibility': "visible" });
                $('#descimgpopup1').css({ 'opacity': "1" });
                return false;
            });
        });              

        // For Drodown Task Priority
        $(".clsTaskPriority").each(function (index) {
            $(this).bind("change", function (e) {
                var datavaltaskid = $(this).attr("data-val-taskid");
                var ddlValue = $(this).val();
                updatePriority(datavaltaskid, ddlValue);
            });
        });

    }

    function placeHighlightedRowonTop(isTechTask) {

        $("#taskSequenceTabs").find("tr.yellowthickborder").each(function () {
            var editLink = $(this).find("a.autoclickSeqEdit");

            if (editLink) {
                setTimeout(function () { editLink.click(); }, 1000);
            }
        });

        //$("#tblTechSeq tbody  > tr").each(function () {
        //    console.log($(this));
        //    if ($(this).hasClass("yellowthickborder")) {
        //        console.log('class has yellowthick border');
        //        $(this).click(function () { alert('i am clicked');});
        //    }
        //});

        //var row = $("#tblTechSeq").find("tr.yellowthickborder");
        //$(row).remove();
        ////$("#tblTechSeq").find("tr.yellowthickborder").remove();
        //console.log(row);
        //        row.appendTo($('#tblTechSeq'));

    }

    function updatePriority(id, value) {
        ShowAjaxLoader();
        var postData = {
            taskid: id,
            priority: value
        };

        $.ajax
        (
            {
                url: '../WebServices/JGWebService.asmx/SetTaskPriority',
                contentType: 'application/json; charset=utf-8;',
                type: 'POST',
                dataType: 'json',
                data: JSON.stringify(postData),
                asynch: false,
                success: function (data) {
                    HideAjaxLoader();
                    alert('Priority Updated successfully.');
                },
                error: function (a, b, c) {
                    HideAjaxLoader();
                }
            }
        );
    }

    function updateDesc(htmldata, autosave) {
        //console.log(htmldata);
        if (isadded) {
            if (!autosave) {
                control.html(htmldata);
                isadded = false;
            }
            EditDesc(control.attr("data-taskid"), htmldata, autosave);
        }
    }
    function updateChild(htmldata) {
        if (isadded) {
            control.html(htmldata);
            EditDesc(control.attr("data-taskid"), htmldata);
            isadded = false;
        }
    }


    function FreezeTask(sender) {
        //debugger;
        var $sender = $(sender);

        var adminCheckBox = $sender.attr('data-id');

        var strTaskId = $sender.attr('data-taskid');
        var strHoursId = $sender.attr('data-hours-id');
        var strPasswordId = $sender.attr('data-id');

        var $tr = $('div.approvepopup[data-taskid="' + strTaskId + '"]');
        var postData;
        var MethodToCall;

        if (adminCheckBox && adminCheckBox.includes("txtAdminPassword")) {
            postData = {
                strTaskApprovalId: $tr.find('input[id*="hdnTaskApprovalId"]').val(),
                strTaskId: strTaskId,
                strPassword: $tr.find('input[data-id="' + strPasswordId + '"]').val()
            };
            MethodToCall = "AdminFreezeTask";
        }
        else {
            postData = {
                strEstimatedHours: $tr.find('input[data-id="' + strHoursId + '"]').val(),
                strTaskApprovalId: $tr.find('input[id*="hdnTaskApprovalId"]').val(),
                strTaskId: strTaskId,
                strPassword: $tr.find('input[data-id="' + strPasswordId + '"]').val()
            };
            MethodToCall = "FreezeTask";
        }


        CallJGWebService(MethodToCall, postData, OnFreezeTaskSuccess);

        function OnFreezeTaskSuccess(data) {
            if (data.d.Success) {
                alert(data.d.Message);
                HidePopup('.approvepopup')
                $('#<%=hdTaskId.ClientID%>').val(data.d.TaskId.toString());

                LoadSubTasks();
            }
            else {
                alert(data.d.Message);
            }
        }
    }

    function FreezeSeqTask(sender) {
        //debugger;
        var $sender = $(sender);
        console.log(sender);
        var adminCheckBox = $sender.attr('data-id');
        console.log(adminCheckBox);
        var strTaskId = $sender.attr('data-taskid');
        var strHoursId = $sender.attr('data-hours-id');
        var strPasswordId = $sender.attr('data-id');

        var $tr = $('div.seqapprovepopup[data-taskid="' + strTaskId + '"]');
        var postData;
        var MethodToCall;

        if (adminCheckBox && adminCheckBox.includes("txtngstaffAdminPassword")) {
            alert('AdminFreezeTask');
            postData = {
                strTaskApprovalId: '',
                strTaskId: strTaskId,
                strPassword: $tr.find('input[data-id="' + strPasswordId + '"]').val()
            };
            MethodToCall = "AdminFreezeTask";
        }
        else {
            postData = {
                strEstimatedHours: $tr.find('input[data-id="' + strHoursId + '"]').val(),
                strTaskApprovalId: '',
                strTaskId: strTaskId,
                strPassword: $tr.find('input[data-id="' + strPasswordId + '"]').val()
            };
            MethodToCall = "FreezeTask";
        }


        CallJGWebService(MethodToCall, postData, OnFreezeTaskSuccess);

        function OnFreezeTaskSuccess(data) {
            if (data.d.Success) {
                alert(data.d.Message);
                HidePopup('.seqapprovepopup');
                sequenceScope.refreshTasks();
            }
            else {
                alert(data.d.Message);
            }
        }
    }

    function EditTask(tid, tdetail) {
        ShowAjaxLoader();
        var postData = {
            tid: tid,
            title: tdetail
        };

        $.ajax
        (
            {
                url: '../WebServices/JGWebService.asmx/UpdateTaskTitleById',
                contentType: 'application/json; charset=utf-8;',
                type: 'POST',
                dataType: 'json',
                data: JSON.stringify(postData),
                asynch: false,
                success: function (data) {
                    HideAjaxLoader();
                    alert('Title saved successfully.');
                },
                error: function (a, b, c) {
                    HideAjaxLoader();
                }
            }
        );
    }
    function EditUrl(tid, tdetail) {
        ShowAjaxLoader();
        var postData = {
            tid: tid,
            URL: tdetail
        };

        $.ajax
        (
            {
                url: '../WebServices/JGWebService.asmx/UpdateTaskURLById',
                contentType: 'application/json; charset=utf-8;',
                type: 'POST',
                dataType: 'json',
                data: JSON.stringify(postData),
                asynch: false,
                success: function (data) {
                    HideAjaxLoader();
                    alert('Url saved successfully.');
                },
                error: function (a, b, c) {
                    HideAjaxLoader();
                }
            }
        );
    }
    
        function EditAssignedTaskUsers(sender) {
            ShowAjaxLoader();

            var $sender = $(sender);
            var intTaskID = parseInt($sender.attr('data-taskid'));
            var intTaskStatus = parseInt($sender.attr('data-taskstatus'));
            var arrAssignedUsers = [];
            var arrDesignationUsers = [];
            var options = $sender.find('option');

            $.each(options, function (index, item) {

                var intUserId = parseInt($(item).attr('value'));

                if (intUserId > 0) {
                    arrDesignationUsers.push(intUserId);
                    //if ($.inArray(intUserId.toString(), $(sender).val()) != -1) {                
                    //    arrAssignedUsers.push(intUserId);
                    //}
                    if ($(sender).val() == intUserId.toString()) {
                        arrAssignedUsers.push(intUserId);
                    }
                }
            });

            SaveAssignedTaskUsers();

            //var postData = {
            //    intTaskId: intTaskID,
            //    intTaskStatus: intTaskStatus,
            //    arrAssignedUsers: arrAssignedUsers
            //};

            //CallJGWebService('ValidateTaskStatus', postData, OnValidateTaskStatusSuccess);

            //function OnValidateTaskStatusSuccess(response) {
            //    if (!response.d.IsValid) {
            //        alert(response.d.Message);
            //    }
            //    else {
            //        SaveAssignedTaskUsers();
            //    }
            //}

            //function OnValidateTaskStatusError() {
            //    alert('Task status cannot be validated. Please try again.');
            //}

            // private function (so, it is defined in a function) to save task assigned users only after validating task status.
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
                    console.log(response);
                    if (response) {
                        alert('Task assignment saved successfully.');
                        $('#<%=hdTaskId.ClientID%>').val(intTaskID.toString());
                        $('#<%=btnUpdateRepeater.ClientID%>').click();
                    }
                    else {
                        OnSaveAssignedTaskUsersError();
                    }
                }

                function OnSaveAssignedTaskUsersError(err) {
                    //alert(JSON.stringify(err));
                    alert('Task assignment cannot be updated. Please try again.');
                }
            }
        }

        function SetTaskDetailsForNew(cmdArg, cName, TaskLevel, strInstallId) {
            ShowAjaxLoader();
            var postData = {
                CommandArgument: cmdArg,
                CommandName: cName
            };

            $.ajax
            (
                {
                    url: '../WebServices/JGWebService.asmx/GetSubTaskId',
                    contentType: 'application/json; charset=utf-8;',
                    type: 'POST',
                    dataType: 'json',
                    data: JSON.stringify(postData),
                    asynch: false,
                    success: function (data) {
                        HideAjaxLoader();

                        if (TaskLevel == "2") {
                            var taskid = GetParameterValues('TaskId');
                            $('#<%=txtInstallId.ClientID%>').val(data.d.txtInstallId);
                            $('#<%=hdParentTaskId.ClientID%>').val(data.d.hdParentTaskId);
                            $('#<%=hdMainParentId.ClientID%>').val(taskid);
                            $('#<%=hdTaskLvl.ClientID%>').val(data.d.hdTaskLvl);
                            $('#<%=hdTaskId.ClientID%>').val(cmdArg);
                        }
                        else {
                            $('#<%=txtTaskListID.ClientID%>').val(data.d.txtInstallId);                            
                            $('#<%=hdParentTaskId.ClientID%>').val(data.d.hdParentTaskId);
                            $('#<%=hdTaskLvl.ClientID%>').val(data.d.hdTaskLvl);
                            $('#<%=hdTaskId.ClientID%>').val(cmdArg);
                        }
                    },
                    error: function (a, b, c) {
                        HideAjaxLoader();
                    }
                }
        );
            }

            function OnAddMoreSubtaskClick() {
                $('#<%=txtTaskDesc.ClientID%>').val(GetCKEditorContent('<%=txtTaskDesc.ClientID%>'));
                if (Page_ClientValidate('SubmitSubTask')) {
                    ShowAjaxLoader();
                    var hdParentTaskId = $('#<%=hdParentTaskId.ClientID%>').val();
                    var listID = $('#<%=txtInstallId.ClientID%>').val();
                    var txtSubSubTitle = $('#<%=txtSubSubTitle.ClientID%>').val();
                    var Priority = $('#<%= drpSubTaskPriority.ClientID %>').val();
                    var type = $('#<%= drpSubTaskType.ClientID %>').val();
                    var desc = GetCKEditorContent('<%= txtTaskDesc.ClientID %>');
                    var designations = $("#<%= ddlUserDesignation.ClientID %> option:selected").val();
                    var TaskLvl = $('#<%= hdTaskLvl.ClientID %>').val();

                    var postData = {
                        ParentTaskId: hdParentTaskId,
                        Title: txtSubSubTitle,
                        URL: "",
                        Desc: desc,
                        Status: "1",
                        Priority: Priority,
                        DueDate: "",
                        TaskHours: "",
                        InstallID: listID,
                        Attachments: "",
                        TaskType: type,
                        TaskDesignations: designations,
                        TaskLvl: TaskLvl,
                        blTechTask: false,
                        Sequence: ''
                    };

                    console.log(postData);

                    CallJGWebService('AddNewSubTask', postData, OnAddNewSubTaskSuccess, OnAddNewSubTaskError);

                    function OnAddNewSubTaskSuccess(data) {
                        if (data.d.Success) {
                            alert('Task saved successfully.');
                            $('#<%=hdTaskId.ClientID%>').val(data.d.TaskId.toString());
                            LoadSubTasks();
                        }
                        else {
                            alert('Task cannot be saved. Please try again.');
                        }
                    }

                    function OnAddNewSubTaskError(err) {
                        alert('Task cannot be saved. Please try again.');
                    }

                    return false;
                }
            }

            function SetUserAutoSuggestion() {
                $("#<%=txtSearch.ClientID%>").catcomplete({
                    delay: 500,
                    source: function (request, response) {
                        $.ajax({
                            type: "POST",
                            url: "ajaxcalls.aspx/GetTaskUsers",
                            dataType: "json",
                            contentType: "application/json; charset=utf-8",
                            data: JSON.stringify({ searchterm: request.term }),
                            success: function (data) {
                                // Handle 'no match' indicated by [ "" ] response
                                if (data.d) {

                                    response(data.length === 1 && data[0].length === 0 ? [] : JSON.parse(data.d));
                                }
                                // remove loading spinner image.                                
                                $("#<%=txtSearch.ClientID%>").removeClass("ui-autocomplete-loading");
                            }
                        });
                    },
                    minLength: 2,
                    select: function (event, ui) {
                        var searchkey = ui.item.value;
                        $('#hdnSearchKey').val(searchkey);
                        LoadSubTasks();
                        //TriggerSearch();
                    }
                });
            }

            function SetUserAutoSuggestionUI() {

                $.widget("custom.catcomplete", $.ui.autocomplete, {
                    _create: function () {
                        this._super();
                        this.widget().menu("option", "items", "> :not(.ui-autocomplete-category)");
                    },
                    _renderMenu: function (ul, items) {
                        var that = this,
                          currentCategory = "";
                        $.each(items, function (index, item) {
                            var li;
                            if (item.Category != currentCategory) {
                                ul.append("<li class='ui-autocomplete-category'> Search " + item.Category + "</li>");
                                currentCategory = item.Category;
                            }
                            li = that._renderItemData(ul, item);
                            if (item.Category) {
                                li.attr("aria-label", item.Category + " : " + item.label);
                            }
                        });

                    }
                });
            }

            function SetApprovalUI() {

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
                        alert("SetApprovalUI");
                    });
                });
            }

            function SetSeqApprovalUI() {

                $('.seqapprovalBoxes').each(function () {
                    var approvaldialog = $($(this).next('div.seqapprovepopup'));

                    //console.log(approvaldialog);

                    approvaldialog.addClass("hide");

                    approvaldialog.dialog({
                        width: 400,
                        show: 'slide',
                        hide: 'slide',
                        autoOpen: false
                    });

                    $(this).click(function () {
                        approvaldialog.removeClass("hide");
                        approvaldialog.dialog('open');
                        alert("SetSeqApprovalUI");
                    });
                });
            }

            function ucSubTasks_Initialize() {

                SubTaskCommentScript.Initialize();

                ChosenDropDown();
                // Choosen selected option with hyperlink to profile.
                setSelectedUsersLink();

                ApplySubtaskLinkContextMenu();

                //ApplyImageGallery();

                LoadImageGallery('.sub-task-attachments-list');

                SetApprovalUI();

                var controlmode = $('#<%=hdnAdminMode.ClientID%>').val().toLowerCase();

                if (controlmode == "true") {
                    ucSubTasks_ApplyDropZone();
                    SetCKEditor('<%=txtSubTaskDescription.ClientID%>', txtSubTaskDescription_Blur);
                    UpdateTaskDescBeforeSubmit('<%=txtSubTaskDescription.ClientID%>', '#<%=btnSaveSubTask.ClientID%>');


                    SetCKEditor('<%=txtTaskDesc.ClientID%>', txtTaskDesc_Blur);
                    UpdateTaskDescBeforeSubmit('<%=txtTaskDesc.ClientID%>', '#<%=btnAddMoreSubtask.ClientID%>');


                    $('#<%=txtInstallId.ClientID%>').bind('keypress', function (e) {
                        return false;
                    });

                    $('#<%=txtInstallId.ClientID%>').bind('keydown', function (e) {
                        if (e.keyCode === 8 || e.which === 8) {
                            return false;
                        }
                    });

                }
                BindSeqDesignationChange('#<%=ddlDesigSeq.ClientID %>');
                pageLoad(null, null);
            }




            function txtSubTaskDescription_Blur(editor) {
                if ($('#<%=hdnSubTaskId.ClientID%>').val() != '0') {
                    if (Page_ClientValidate('vgSubTask') && confirm('Do you wish to save description?')) {
                        $('#<%=btnSaveSubTask.ClientID%>').click();
                    }
                }
            }
            var PreventScroll = 0;
            function OnSaveSubTaskClick() {
                if (Page_ClientValidate('vgSubTask')) {
                    ShowAjaxLoader();
                    var taskid = '';
                    if (maintask) {
                        taskid = GetParameterValues('TaskId');
                    }
                    else {
                        taskid = $('#<%=hdParentTaskId.ClientID%>').val();
                    }

                    var title = $('#<%= txtSubTaskTitle.ClientID %>').val();
                    var url = $('#<%= txtUrl.ClientID %>').val();
                    var desc = GetCKEditorContent('<%= txtSubTaskDescription.ClientID %>');
                    var status = "<%=Convert.ToByte(JG_Prospect.Common.JGConstant.TaskStatus.Open)%>";
                    var Priority = $('#<%= ddlSubTaskPriority.ClientID %>').val();
                    var DueDate = ''; //$('#<%= txtSubTaskDueDate.ClientID %>').val();
                    var tHours = ''; //$('#<%= txtSubTaskHours.ClientID %>').val();
                    var installID = $('#<%= txtTaskListID.ClientID %>').val();
                    var Attachments = ''; //$('#<%= hdnAttachments.ClientID %>').val();
                    var type = $('#<%= ddlTaskType.ClientID %>').val();
                    //var designaions = $('#<%= hdndesignations.ClientID %>').val();
                    var designations = $("#<%= ddlUserDesignation.ClientID %> option:selected").val();
                    var TaskLvl = $('#<%= hdTaskLvl.ClientID %>').val();
                    var blTechTask = $('#<%=chkTechTask.ClientID%>').prop('checked');
                    var sequence = $('#txtSeqAdd').val();

                    var postData = {
                        ParentTaskId: taskid,
                        Title: title,
                        URL: url,
                        Desc: desc,
                        Status: status,
                        Priority: Priority,
                        DueDate: DueDate,
                        TaskHours: tHours,
                        InstallID: installID,
                        Attachments: Attachments,
                        TaskType: type,
                        TaskDesignations: designations,
                        TaskLvl: TaskLvl,
                        blTechTask: blTechTask,
                        Sequence: sequence
                    };

                    CallJGWebService('AddNewSubTask', postData, OnAddNewSubTaskSuccess, OnAddNewSubTaskError);

                    function OnAddNewSubTaskSuccess(data) {
                        if (data.d.Success) {
                            //Allow scroll to newly created task
                            //PreventScroll = 1;
                            var tid = data.d.TaskId.toString();

                            alert('Task saved successfully.');
                            $('#<%=hdTaskId.ClientID%>').val(tid);

                            $("#<%=divNEWSubTask.ClientID%>").hide();
                            $("#<%=pnlCalendar.ClientID%>").hide();

                            $("#<%=txtSubTaskTitle.ClientID%>").val('');
                            $("#<%=txtUrl.ClientID%>").val('');
                            $("#<%=txtSubTaskDescription.ClientID%>").val('');

                            //URL Processing
                            var url = getUrlVars();

                            switch (url.length) {
                                case 1: {
                                    window.history.pushState("", "", "TaskGenerator.aspx?TaskId=" + tid);
                                    break;
                                }
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

                            LoadSubTasks();
                        }
                        else {
                            alert('Task cannot be saved. Please try again.');
                        }
                    }

                    function OnAddNewSubTaskError(err) {
                        alert('Task cannot be saved. Please try again.');
                    }
                    return false;
                }
            }
            function GetParameterValues(param) {
                var url = window.location.href.slice(window.location.href.indexOf('?') + 1).split('&');
                for (var i = 0; i < url.length; i++) {
                    var urlparam = url[i].split('=');
                    if (urlparam[0] == param) {
                        return urlparam[1];
                    }
                }
            }

            function copytoListID(sender) {
                var strListID = $.trim($(sender).text());
                if (strListID.length > 0) {
                    $('#<%= txtTaskListID.ClientID %>').val(strListID);
                    ValidatorEnable(document.getElementById('<%=rfvTitle.ClientID%>'), true)
                    ValidatorEnable(document.getElementById('<%=rfvUrl.ClientID%>'), true)
                }
            }

            var objSubTaskDropzone, objSubtaskNoteDropzone;

            function ucSubTasks_ApplyDropZone() {
                //remove already attached dropzone.
                if (objSubTaskDropzone) {
                    objSubTaskDropzone.destroy();
                    objSubTaskDropzone = null;
                }
                if ($("#<%=divSubTaskDropzone.ClientID%>").length > 0) {
                    objSubTaskDropzone = new Dropzone("#<%=divSubTaskDropzone.ClientID%>", {
                        maxFiles: 5,
                        url: "taskattachmentupload.aspx",
                        thumbnailWidth: 90,
                        thumbnailHeight: 90,
                        previewsContainer: 'div#<%=divSubTaskDropzonePreview.ClientID%>',
                        init: function () {
                            this.on("maxfilesexceeded", function (data) {
                                alert('you are reached maximum attachment upload limit.');
                            });

                            // when file is uploaded successfully store its corresponding server side file name to preview element to remove later from server.
                            this.on("success", function (file, response) {
                                var filename = response.split("^");
                                $(file.previewTemplate).append('<span class="server_file">' + filename[0] + '</span>');

                                AddAttachmenttoViewState(filename[0] + '@' + file.name, '#<%= hdnAttachments.ClientID %>');

                                if ($('#<%=btnSaveSubTaskAttachment.ClientID%>').length > 0) {
                                    // saves attachment.
                                    //$('#<%=btnSaveSubTaskAttachment.ClientID%>').click();

                                    
                                    //Session[JG_Prospect.Common.SessionKey.Key.UserId.ToString()]
                                    //this.removeFile(file);
                                }
                            });
                        }
                    });
                }

                //Apply dropzone for comment section.
                if (objSubtaskNoteDropzone) {
                    objSubtaskNoteDropzone.destroy();
                    objSubTaskNoteDropzone = null;
                }

                objSubTaskNoteDropzone = GetWorkFileDropzone("#<%=divSubTaskNoteDropzone.ClientID%>", '#<%=divSubTaskNoteDropzonePreview.ClientID%>', '#<%= hdnSubTaskNoteAttachments.ClientID %>', '#<%=btnSaveCommentAttachment.ClientID%>');
            }

            function ucSubTasks_OnApprovalCheckBoxChanged(sender) {
                var sender = $(sender);
                if (sender.prop('checked')) {
                    sender.closest('tr').next('tr').show();
                }
                else {
                    sender.closest('tr').next('tr').hide();
                }
            }

            

            function ApplySubtaskLinkContextMenu() {

                $(".context-menu").bind("contextmenu", function () {
                    sharePopup(this);
                    return false;
                });
            }

            

            

            // check if user has selected any designations or not.
            function SubTasks_checkDesignations(oSrc, args) {
                //args.IsValid = ($("# input:checked").length > 0);
            }


            //  Created By : Yogesh K
            // To updat element underlying CKEditor before work submited to server.
            function UpdateTaskDescBeforeSubmit(CKEditorId, ButtonId) {
                $(ButtonId).bind('click', function () {
                    var editor = CKEDITOR.instances[CKEditorId];

                    if (editor) {
                        editor.updateElement();
                    }
                });
            }


            //----------- Start DP ---------

            function SetHiddenTaskId(vId) {

                $('#<%=hdDropZoneTaskId.ClientID%>').val($(vId).attr('data-taskid'));
            }


            $('#<%=pnlCalendar.ClientID%>').hide();
  <%--  $('#<%=divSubTask.ClientID%>').hide();--%>

    function txtTaskDesc_Blur(editor) {
        //if ($('#<%=hdnSubTaskId.ClientID%>').val() != '0') {
        <%--if (confirm('Do you wish to save description?')) {
            $('#<%=btnAddMoreSubtask.ClientID%>').click();
        }--%>
        // }
    }

    function showSubTaskEditView(divid, rowindex) {

        var html = $('<tr>').append($('<td colspan="5">').append($(divid)));

        $('.edit-subtask > tbody > tr').eq(rowindex + 1).after(html);

        $(divid).slideDown('slow');

        ScrollTo($(divid));
    }
    function hideSubTaskEditView(divid, rowindex) {

        //$('#<%=hdnCurrentEditingRow.ClientID%>').val('');
        // $('.edit-subtask > tbody > tr').eq(rowindex + 2).remove();
        // $(divid).slideUp('slow');
        $('#<%=pnlCalendar.ClientID %>').hide();
        var row = $('.edit-subtask').find('tr').eq(rowindex + 2);

        //alert(row);

        ScrollTo(row);
    }


    function attachImagesByCKEditor(filename, name) {
        AddAttachmenttoViewState(name + '@' + name, '#<%= hdnGridAttachment.ClientID %>');
        idAttachments = true;
    }

    function GridDropZone() {
        Dropzone.autoDiscover = false;

        $(".dropzonetask").each(function () {
            var objSubTaskDropzone1;
            var taskId = $(this).attr('data-taskid');
            //alert(taskId);
            if (!(this.dropzone)) {
                $(this).dropzone({
                    maxFiles: 5,
                    url: "taskattachmentupload.aspx",
                    thumbnailWidth: 90,
                    thumbnailHeight: 90,
                    init: function () {
                        dzClosure = this;

                        this.on("maxfilesexceeded", function (data) {
                            alert('you are reached maximum attachment upload limit.');
                        });

                        this.on("drop", function (data) {
                            //alert(taskId);
                            $('#<%=hdDropZoneTaskId.ClientID%>').val(taskId);
                        });

                        // when file is uploaded successfully store its corresponding server side file name to preview element to remove later from server.
                        this.on("success", function (file, response) {
                            // Success coding goes here

                            var filename = response.split("^");
                            $(file.previewTemplate).append('<span class="server_file">' + filename[0] + '</span>');

                            AddAttachmenttoViewState(filename[0] + '@' + file.name, '#<%= hdnGridAttachment.ClientID %>');

                        if ($('#<%=btnSaveGridAttachment.ClientID%>').length > 0) {
                            // saves attachment.
                            RefreshData = true;
                            SaveAttchmentToDB();
                            //$('#<%=btnSaveGridAttachment.ClientID%>').click();
                            //this.removeFile(file);
                        }
                    });
                    }
                });
        }
        });
    }
    function SaveChildAttchmentToDB(taskid) {
        if (IsAdminMode == 'True') {
            var data = {
                TaskId: taskid, attachments: $('#<%=hdnGridAttachment.ClientID%>').val()
            };
            $.ajax({
                type: "POST",
                url: url + "SaveUserAttachements",
                data: data,
                success: function (result) {
                    //alert("Success");
                    <%--$('#<%=hdnGridAttachment.ClientID%>').val('');
                    $('#<%=hdDropZoneTaskId.ClientID%>').val('');--%>
                    if (RefreshData)
                        LoadSubTasks();
                    else {
                        sequenceScopeTG.getFileData(CurrentFileName, CurrentEditor);
                    }
                },
                error: function (errorThrown) {
                    console.log(errorThrown);
                    alert("Failed!!!");
                }
            });
        }
    }
    function SaveAttchmentToDB() {
        debugger;
        if (IsAdminMode == 'True') {
            var data = {
                TaskId: $('#<%=hdDropZoneTaskId.ClientID%>').val(), attachments: $('#<%=hdnGridAttachment.ClientID%>').val()
            };
            $.ajax({
                type: "POST",
                url: url + "SaveUserAttachements",
                data: data,
                success: function (result) {
                    //alert("Success");
                    <%--$('#<%=hdnGridAttachment.ClientID%>').val('');
                    $('#<%=hdDropZoneTaskId.ClientID%>').val('');--%>
                    if (RefreshData)
                        LoadSubTasks();
                    else {
                        sequenceScopeTG.getFileData(CurrentFileName, CurrentEditor);
                    }
                },
                error: function (errorThrown) {
                    console.log(errorThrown);
                    alert("Failed!!!");
                }
            });            
            $('#ContentPlaceHolder1_objucSubTasks_Admin_hdnGridAttachment').val('');
        }
    }

    function setSelectedUsersLink() {       
        $('.search-choice').each(function () {
            var itemIndex = $(this).children('.search-choice-close').attr('data-option-array-index');
            //console.log(itemIndex);
            if (itemIndex) {
                //console.log($(this).parent('.chosen-choices').parent('.chosen-container'));
                var id = $(this).parent('.chosen-choices').parent('.chosen-container').attr('id');
                if (id != undefined) {
                    var selectoptionid = '#' + id.replace("_chosen", "") + ' option';
                    var chspan = $(this).children('span');
                    if (chspan) {
                        if (selectoptionid != undefined && $(selectoptionid)[itemIndex] != undefined) {
                            chspan.html('<a style="color:blue;" href="/Sr_App/ViewSalesUser.aspx?id=' + $(selectoptionid)[itemIndex].value + '">' + chspan.text() + '</a>');
                            chspan.bind("click", "a", function () {
                                window.open($(this).children("a").attr("href"), "_blank", "", false);
                            });
                        }
                    }
                }
            }
        });
    }

    function Paging(sender) {
            $('#PageIndex').val(paging.currentPage);
            ajaxExt({
                url: '/Sr_App/edituser.aspx/GetUserTouchPointLogs',
                type: 'POST',
                data: '{ pageNumber: ' + $('#PageIndex').val() + ', pageSize: ' + paging.pageSize + ', userId: ' + <%=loggedInUserId%> + ',chatSourceId:<%=(int)JG_Prospect.Common.ChatSource.TaskGenerator%> }',
                showThrobber: true,
                throbberPosition: { my: "left center", at: "right center", of: $(sender), offset: "5 0" },
                success: function (data, msg) {
                    if (data.Data.length > 0) {
                        PageNumbering(data.TotalResults);
                        var tbl = '<table cellspacing="0" cellpadding="0"><tr><th>Updated By<br/>Created On</th><th>Note</th></tr>';
                        $(data.Data).each(function (i) {
                            tbl += '<tr id="' + data.Data[i].UserTouchPointLogID + '">' +
                                        '<td>' + data.Data[i].SourceUsername + '- <a target="_blank" href="/Sr_App/ViewSalesUser.aspx?id=' + data.Data[i].UpdatedByUserID + '">' + data.Data[i].SourceUserInstallId + '</a><br/>' + data.Data[i].ChangeDateTimeFormatted + '</td>' +
                                        '<td title="' + data.Data[i].LogDescription + '"><div class="note-desc">' + data.Data[i].LogDescription + '</div></td>' +
                                    '</tr>';
                        });
                        tbl += '</table>';
                        $('.notes-popup .content').html(tbl);
                        var tuid = getUrlVars()["TUID"];
                        var nid = getUrlVars()["NID"];
                        if (tuid != undefined && nid != undefined) {
                            $('.notes-popup tr#' + nid).addClass('blink-notes');
                            $('html, body').animate({
                                scrollTop: $(".notes-popup").offset().top
                            }, 2000);
                        }
                        $('.pagingWrapper').show();
                        tribute.attach(document.querySelectorAll('.note-text'));
                    } else {
                        $('.notes-popup .content').html('Notes not found');
                        $('.pagingWrapper').hide();
                    }
                }
            });
            return false;
        }
        function addPopupNotes(sender) {
            var userId = '<%=loggedInUserId%>';
            addNotes(sender, userId);
        }
        function addNotes(sender, uid) {
            var note = $(sender).parent().find('.note-text').val();
            if (note != '')
                ajaxExt({
                    url: '/Sr_App/edituser.aspx/AddNotes',
                    type: 'POST',
                    data: '{ id: ' + uid + ', note: "' + note + '", touchPointSource: ' + <%=(int)JG_Prospect.Common.TouchPointSource.TaskGenerator %> + ' }',
                    showThrobber: true,
                    throbberPosition: { my: "left center", at: "right center", of: $(sender), offset: "5 0" },
                    success: function (data, msg) {
                        $(sender).parent().find('.note-text').val('');
                        Paging(sender);
                    }
                });
        }
        



//--------------- End DP ---------------

</script>
