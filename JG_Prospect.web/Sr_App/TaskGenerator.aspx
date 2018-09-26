<%@ Page Title="" Language="C#" MasterPageFile="~/Sr_App/SR_app.Master" AutoEventWireup="true" CodeBehind="TaskGenerator.aspx.cs"
    Inherits="JG_Prospect.Sr_App.TaskGenerator" ValidateRequest="false" EnableEventValidation="false"
    MaintainScrollPositionOnPostback="true" %>

<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="asp" %>
<%@ Register TagPrefix="asp" Namespace="Saplin.Controls" Assembly="DropDownCheckBoxes" %>
<%@ Register Assembly="CKEditor.NET" Namespace="CKEditor.NET" TagPrefix="CKEditor" %>
<%@ Register Src="~/Controls/CustomPager.ascx" TagPrefix="uc1" TagName="CustomPager" %>
<%@ Register Src="~/Sr_App/Controls/ucTaskWorkSpecifications.ascx" TagPrefix="uc1" TagName="ucTaskWorkSpecifications" %>
<%@ Register Src="~/Sr_App/Controls/ucTaskHistory.ascx" TagPrefix="uc1" TagName="ucTaskHistory" %>
<%@ Register Src="~/Sr_App/Controls/ucSubTasks.ascx" TagPrefix="uc1" TagName="ucSubTasks" %>


<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <link href="../css/chosen.css" rel="stylesheet" />
    <style>
        .div-col-middle {
            vertical-align: middle;
            line-height: 44px;
        }

        .div-table-col input {
            margin-top: 0px;
        }

        .div-table-col a {
            text-decoration: none;
        }

        .div-col-middle input {
            margin-top: 0px;
        }

            .div-col-middle input[type=checkbox] {
                width: 20px;
            }

        .row {
            clear: both;
        }

        .addTaskPopup {
            position: unset !important;
            top: unset !important;
            left: unset !important;
            width: 1100px;
        }

        .chosen-dropdown {
            width: 225px;
        }

        .search-field {
            line-height: normal;
        }

        .url {
            margin-left: 5px;
        }

        .designation {
            margin-left: 47px;
        }

        .ui-button {
            background: url(../img/main-header-bg.png) repeat-x;
            color: #fff;
        }

        #cke_txtTaskDescription {
            border: 1px solid #b5b4b4;
            box-shadow: none;
            width: 1030px;
        }

        #myModalAddTask .multileveledittext div.cke_textarea_inline {
            margin-left: 40px;
            width: 987px;
            overflow: unset;
            height: unset !important;
        }

        .listIdPopup {
            float: left;
            width: 30px;
            margin-top: 7px;
            margin-left: 10px;
        }

        .center {
            text-align: center !important;
        }

        #txtTaskDescription {
            height: 200px;
        }

        .cke_bottom {
            padding: 6px 8px 2px;
            position: relative;
            background: #555555 !important;
        }

        .cke_textarea_inline {
            border-radius: 0px;
        }

        #myModalAddTask .modal-body input.smart-text {
            font-size: 12px;
            margin-top: 15px;
        }

        #FeedbackPopup .modal-body input.smart-text {
            font-size: 12px;
            margin-top: 15px;
        }

        .delete-icon {
            float: right;
        }

            .delete-icon img {
                margin-top: 10px;
                height: 17px;
                cursor: pointer;
            }

        .left {
            float: left;
            color: red !important;
            text-decoration: underline;
        }

        .task-dropdown {
            width: 100%;
            margin-top: 10px;
            margin-bottom: 20px;
            border-top: none;
            border-left: none;
            border-right: none;
            height: 27px;
            color: rgba(0, 0, 0, 0.75);
        }

        .subtask-dropdown {
            width: 100%;
            margin-top: 10px;
            color: rgba(0, 0, 0, 0.75);
        }

        .header-tab {
            color: black;
            text-decoration: none;
            font-size: 16px;
            font-weight: bold;
            margin: 0px 0px 11px 0px;
            line-height: 3;
        }

        #divMove {
            display: none;
        }

        #lnkShare {
            color: #06c;
            cursor: pointer;
        }

        #lnkMove {
            cursor: pointer;
        }

        .smalll-col {
            width: 160px;
        }

        .leftLabel {
            width: 58px;
        }

        .modal-content .status {
            float: left;
            margin-top: -33px;
            margin-left: 15px;
            color: white;
            background-color: red;
            padding: 3px;
            border-radius: 4px;
            padding-left: 6px;
            display: none;
        }

        .attachmentImageDiv img {
            width: 100px;
        }
    </style>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <link rel="stylesheet" href="../css/jquery-ui.css" />
    <link href="../css/dropzone/css/basic.css" rel="stylesheet" />
    <link href="../css/dropzone/css/dropzone.css" rel="stylesheet" />

    <script src="../ckeditor/ckeditor.js"></script>
    <script src="../js/clipboard.min.js"></script>
    <script type="text/javascript" src="../js/dropzone.js"></script>


    <script src="../js/jquery.dd.min.js"></script>
    <script src="../js/angular/scripts/jgapp.js"></script>
    <script src="../js/angular/scripts/TaskGenerator.js"></script>
    <script src="../js/angular/scripts/TaskGeneratorHelper.js"></script>

    <div id="controllerDiv" data-ng-controller="TaskGeneratorController">
        <!-- Feedback Freeze Popup Starts-->
        <div id="FeedbackPopup" class="modal">
            <!-- Modal content -->
            <div class="modal-content">
                <div class="modal-header">
                    <span class="close">&times;</span>
                </div>
                <div>
                    <div class="modal-body">
                        <div class="row">
                            <div class="div-table-col div-col-middle">Start Date:</div>
                            <div class="div-table-col smalll-col">
                                <asp:TextBox ID="txtDateFromRoman" runat="server" TabIndex="2" CssClass="dateFromRoman smart-text"
                                    onkeypress="return false" MaxLength="10"></asp:TextBox>
                                <asp:CalendarExtender ID="Calendarextender4" runat="server" TargetControlID="txtDateFromRoman"></asp:CalendarExtender>
                                <br />

                            </div>
                            <div class="div-table-col div-col-middle">End Date:</div>
                            <div class="div-table-col smalll-col">
                                <asp:TextBox ID="txtDateToRoman" runat="server" TabIndex="2" CssClass="dateToRoman smart-text"
                                    onkeypress="return false" MaxLength="10"></asp:TextBox>
                                <asp:CalendarExtender ID="calExtendToDate" runat="server" TargetControlID="txtDateToRoman"></asp:CalendarExtender>
                            </div>
                            <br />
                        </div>
                        <div class="row">
                            <div class="div-table-col div-col-middle leftLabel">
                                IT Lead
                            </div>
                            <div class="div-table-col smalll-col">
                                <div id="ITLeadFreezeHours" class="roman-data"></div>
                                <input type="text" id="txtEstHoursITLead" class="smart-text" placeholder="Est. Hours">
                            </div>
                            <div class="div-table-col smalll-col" id="ITLeadFreezeData">
                                <span class="roman-data"></span>
                            </div>
                            <div id="ITLeadPasswordSection">
                                <div class="div-table-col div-col-middle">Password</div>
                                <div class="div-table-col smalll-col">
                                    <input type="password" id="txtPasswordITLead" class="smart-text" placeholder="Password" data-isitlead="true" onblur="FreezeFeedback(this)">
                                </div>
                                <br>
                            </div>
                        </div>
                        <div class="row">
                            <div class="div-table-col div-col-middle leftLabel">
                                User
                            </div>
                            <div class="div-table-col smalll-col">
                                <div id="UserFreezeHours" class="roman-data"></div>
                                <input type="text" id="txtEstHoursUser" class="smart-text" placeholder="Est. Hours">
                            </div>
                            <div class="div-table-col smalll-col" id="UserFreezeData">
                                <span class="roman-data"></span>
                            </div>
                            <div id="UserPasswordSection">
                                <div class="div-table-col div-col-middle">Password</div>
                                <div class="div-table-col smalll-col">
                                    <input type="password" id="txtPasswordUser" class="smart-text" placeholder="Password" data-isitlead="false" onblur="FreezeFeedback(this)">
                                </div>
                                <br>
                            </div>
                        </div>
                        <div class="row">
                            <div class="div-table-col div-col-middle">Task Status</div>
                            <div class="div-table-col div-col-middle smalll-col">
                                <select id="drpRomanTaskStatus" onchange="changeTaskStatusRoman(this);" data-highlighter="">
                                    <option value="1">Open</option>
                                    <option style="color: red" value="2">Requested</option>
                                    <option style="color: lawngreen" value="3">Assigned</option>
                                    <option value="4">InProgress</option>
                                    <option value="5">Pending</option>
                                    <option value="6">ReOpened</option>
                                    <option value="7">Closed</option>
                                    <option value="8">SpecsInProgress</option>
                                    <option value="10">Finished</option>
                                    <option value="11">Test</option>
                                    <option value="12">Live</option>
                                    <option value="14">Billed</option>
                                    <option value="9">Deleted</option>
                                </select>
                            </div>
                            <br />
                        </div>
                        <div class="row">
                            <br />
                        </div>
                    </div>
                    <div class="modal-footer">
                        <span class="search-label" id="lblStatusFreeze" style="color: red;"></span>
                    </div>
                </div>
            </div>
        </div>
        <!-- Feedback Freeze Popup Ends-->

        <!-- Share Popup Starts -->
        <div id="myModal" class="modal">
            <!-- Modal content -->
            <div class="modal-content">
                <div class="modal-header">
                    <span class="close">&times;</span>
                    <div>
                        <a id="lnkShare" class="header-tab">Share</a>|
                    <a id="lnkMove" class="header-tab">Move</a>
                    </div>
                    <div class="modal-icons">
                        <img src="../img/icon_email.PNG" class="search-target" data-target="emails" /><img src="../img/icon_jg.PNG" class="search-target" data-target="users" />
                    </div>
                </div>
                <div id="divShare">
                    <div class="modal-body">
                        <hr />
                        <input type="text" id="txtTaskLink" class="smart-text" /><br />
                        <input type="text" id="txtSearchUserShare" class="smart-text" />
                    </div>
                    <div class="modal-footer">
                        <%if (IsAdminMode)
                            { %>
                        <button id="btnDelete" onclick="return false;" class="mui-btn mui-btn--small mui-btn--primary mui-btn--flat left">Delete</button>
                        <%} %>
                        <span class="search-label" style="color: red;">Search: Email</span>
                        <button id="btnShare" onclick="return false;" class="mui-btn mui-btn--small mui-btn--primary mui-btn--flat">Share</button>
                        <button id="btnCopy" class="mui-btn mui-btn--small mui-btn--primary mui-btn--flat">Copy</button>
                    </div>
                </div>
                <div id="divMove">
                    <div class="modal-body">
                        <span><strong>TO</strong></span>
                        <select class="task-dropdown" chosen class="chosen-dropdown" onchange="GetChildTasks(this)" id="ddlRootTasks">
                            <option ng-repeat="RootTask in RootTasks" value="{{RootTask.TaskId}}" repeat-end="onRootTasksEnd()">{{RootTask.Title}}</option>
                        </select>
                        <span><strong>ABOVE</strong></span>
                        <select class="subtask-dropdown" size="5" id="ddlChildTask">
                            <option ng-repeat="ChildTask in ChildTasks" value="{{ChildTask.TaskId}}">{{ChildTask.Title}}</option>
                        </select>
                    </div>
                    <div class="modal-footer">
                        <span class="search-label" style="color: red;"></span>
                        <button id="btnMove" onclick="return false;" class="mui-btn mui-btn--small mui-btn--primary mui-btn--flat">Ok</button>
                        <button id="btnCancel" class="mui-btn mui-btn--small mui-btn--primary mui-btn--flat">Cancel</button>
                    </div>
                </div>
                <div class="status"></div>
                <div class="users-container"></div>
            </div>
        </div>
        <!-- Share Popup Ends-->

        <!-- Add New Task Popup Starts -->
        <div id="myModalAddTask" class="modal">
            <!-- Modal content -->
            <div id="modalAddTaskDrag">
                <div class="modal-content addTaskPopup ui-draggable">
                    <div class="ui-dialog-titlebar ui-widget-header ui-corner-all ui-helper-clearfix">
                        <span id="ui-id-3" class="ui-dialog-title">Add New Task</span>
                        <button onclick="closePopup()" type="button" class="ui-button ui-widget ui-state-default ui-corner-all ui-button-icon-only ui-dialog-titlebar-close" role="button" title="Close">
                            <span class="ui-button-icon-primary ui-icon ui-icon-closethick"></span><span class="ui-button-text">Close</span>
                        </button>
                    </div>

                    <!-- 
            <div class="modal-header">
                <span class="close">×</span>
                <h2>Add New Task</h2>

            </div>
            -->
                    <div class="modal-body">
                        <div class="row">
                            <div class="div-table-col div-col-middle">List ID:</div>
                            <div class="div-table-col">
                                <input type="text" id="txtListId" class="smart-text" readonly style="width: 100px;" value="Loading...">
                            </div>
                            <div class="div-table-col div-col-middle">
                                <input type="checkbox" id="chkIsTechTask" class="smart-text">Tech Task?
                            </div>
                            <div class="div-table-col div-col-middle">
                                Type<span style="color: red;">*</span>
                                <select id="ddlTaskType">
                                    <option value="1">Bug</option>
                                    <option value="2">BetaError</option>
                                    <option value="3">Enhancement</option>
                                </select>
                            </div>
                            <div class="div-table-col div-col-middle designation">
                                Designations:<span style="color: red;">*</span>
                                <%--<select data-placeholder="Select Designation" class="chosen-dropdown" multiple id="ddlTasksDesignations">
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
                            </select>--%>

                                <asp:ListBox data-placeholder="Select Designation" CssClass="chosen-dropdown" SelectionMode="Multiple" ID="ddlTasksDesignations" runat="server"></asp:ListBox>
                            </div>
                            <div class="div-table-col div-col-middle">
                                Users:<span style="color: red;">*</span>
                                <select data-placeholder="Select Designation" class="chosen-dropdown" multiple id="ddlTaskUsers">
                                    <option selected value="">All</option>
                                </select>
                            </div>
                        </div>
                        <div class="row">
                            <div class="div-table-col div-col-middle">Title<span style="color: red;">*</span></div>
                            <div class="div-table-col">
                                <input type="text" id="txtTitle" class="smart-text" style="width: 448px;">
                            </div>
                            <div class="div-table-col div-col-middle url">URL <span style="color: red;">*</span></div>
                            <div class="div-table-col" id="divURL">
                                <input type="text" id="txtURL" class="smart-text taskURL" style="width: 484px;">
                                <a href="#" onclick="OnURLAdd(this)">+</a>
                            </div>
                        </div>
                        <div class="row">
                            <div class="div-table-col div-col-middle">Description<span style="color: red;">*</span></div>
                        </div>
                        <div class="row">
                            <div class="div-table-col divtdetails">
                                <textarea id="txtTaskDescription" class="smart-text" style="width: 1030px;" rows="5"></textarea>
                            </div>
                        </div>
                        <div class="row">
                            <div class="nestedChildren">
                                <div ng-repeat="Child in NewTaskMultiLevelChildren"
                                    class="ChildRow{{NewTaskId}}" data-level="{{Child.IndentLevel}}" data-label="{{Child.Label}}"
                                    style="clear: both; padding: 5px;">
                                    <div ng-class="{level2: Child.IndentLevel==2, level3: Child.IndentLevel==3, parentdiv: Child.IndentLevel==1}">
                                        <div style="float: left" id="selectboxes{{NewTaskId}}">
                                            <input ng-class="{hide: Child.IndentLevel!= 1}" type="checkbox" style="margin-top: 0px !important; width: auto" />
                                            <a href="#" style="color: blue" class="context-menu-child" data-childid="{{Child.Id}}" data-highlighter="{{NewTaskId}}">{{Child.Label}}.</a>
                                        </div>
                                        <div ng-bind-html="Child.Description | trustAsHtml" class="ChildEdit" style="float: left" id="ChildEdit{{Child.Id}}" data-parentid="{{NewTaskId}}" data-taskid="{{Child.Id}}"></div>
                                    </div>
                                    <div class="delete-icon">
                                        <img src="../img/delete.jpg" alt="Delete" data-childid="{{Child.Id}}" onclick="DeleteChild(this, true)" />
                                    </div>
                                </div>
                            </div>
                        </div>
                        <div class="row">
                            <div class="taskSubPoints" style="background-color: white; padding-top: 5px;">
                                <div class="listId">
                                    <a href="#" data-listid="{{TaskInstallId}}" data-level="{{TaskIndent}}" data-label="{{LevelToRoman(TaskLastChild,TaskIndent)}}"
                                        id="listIdNewTask" style="color: blue">{{LevelToRoman(TaskLastChild,TaskIndent)}}</a>
                                    <input id="nestLevelNewTask" value="{{TaskIndent}}" data-label="{{LevelToRoman(TaskLastChild,TaskIndent)}}" type="hidden" />
                                    <input id="lastDataNewTask" value="{{TaskIndent}}" data-label="{{LevelToRoman(TaskLastChild,TaskIndent)}}" type="hidden" />
                                </div>
                                <div class="multileveledittext">
                                    <textarea style="width: 80%" rows="1" id="multilevelChildDesc" data-taskid="{{NewTaskId}}"></textarea>
                                </div>
                            </div>
                        </div>
                        <div class="row">
                            <div id="NewChildDiv">
                                &nbsp;
                        <div class="btn_sec" id="indentDiv">
                            <button class="indentButtonLeft" type="button" id="btnLeftNewTask" data-taskid="{{NewTaskId}}" data-action="left" onclick="OnIndent(this)"></button>
                            <button class="indentButtonRight" type="button" id="btnRightNewTask" data-taskid="{{NewTaskId}}" data-action="right" onclick="OnIndent(this)"></button>
                        </div>
                                <div id="TaskloaderDiv" class="TaskloaderDiv">
                                    <img src="../../img/ajax-loader.gif" style="height: 16px; vertical-align: bottom">
                                    Auto Saving...
                                </div>
                            </div>
                        </div>
                    </div>
                    <div class="modal-footer clear center">
                        <span class="search-label" style="color: red;" id="lblStatus"></span>
                        <input type="button" value="Save Task" id="btnSaveSubTask" class="ui-button">
                    </div>
                    <div class="users-container"></div>
                </div>
            </div>
        </div>
        <!-- Add New Task Popup Ends -->

        <div class="right_panel">
            <hr />
            <asp:UpdatePanel ID="upTask" runat="server">
                <ContentTemplate>
                    <h1>Task</h1>
                    <table id="tblTaskHeader" runat="server" visible="false" class="appointment_tab"
                        style="position: absolute; top: 338px; right: 39px; background-color: #fff;">
                        <tr>
                            <td width="25%" align="left">
                                <asp:LinkButton ID="lbtnDeleteTask" runat="server" OnClick="lbtnDeleteTask_Click" Text="Delete" />
                                &nbsp;&nbsp;Task ID#:
                           
                            <asp:Literal ID="ltrlInstallId" runat="server" /></td>
                            <td align="center">Date Created:
                           
                            <asp:Literal ID="ltrlDateCreated" runat="server" /></td>
                            <td width="25%" align="right">
                                <asp:Literal ID="ltrlAssigningManager" runat="server" /></td>
                        </tr>
                    </table>
                    <div class="form_panel_custom">
                        <table id="tblAdminTaskView" runat="server" class="tablealign"
                            width="100%" cellspacing="5">
                            <tr>
                                <td style="width: 30%;">Designation <span style="color: red;">*</span>: 
                               <%--<select data-placeholder="Select Designation" class="chosen-input" multiple style="width: 95%;" id="ddlDesignationSeq" runat="server">
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
                               </select>--%>
                                    <asp:ListBox data-placeholder="Select Designation" CssClass="chosen-input" SelectionMode="Multiple" ID="ddlDesignationSeq" runat="server" ClientIDMode="Static"></asp:ListBox>
                                    <asp:HiddenField ID="hdnSelectedDesig" runat="server" />
                                </td>
                                <td>Assigned:    
                                <select id="ddlUsers" data-placeholder="Select Users" multiple style="width: 85%;" class="chosen-input" runat="server">
                                </select><span id="lblLoading" style="display: none">Loading...</span>
                                    <asp:HiddenField ID="hdnSelectedUsers" runat="server" />
                                    <span style="padding-left: 20px;">
                                        <asp:CheckBox ID="chkTechTask" runat="server" Checked="false" Text=" Tech Task" />
                                    </span>
                                </td>
                            </tr>
                            <tr>
                                <td class="valigntop">Task Title <span style="color: red;">*</span>:<br />

                                    <asp:TextBox ID="txtTaskTitle" runat="server" Style="width: 90%" CssClass="textbox"></asp:TextBox>

                                    <asp:RequiredFieldValidator ID="rfvTaskTitle" ValidationGroup="Submit"
                                        runat="server" ControlToValidate="txtTaskTitle" ForeColor="Red" ErrorMessage="Please Enter Task Title" Display="None">                                 
                                    </asp:RequiredFieldValidator>
                                    <asp:HiddenField ID="controlMode" runat="server" />
                                    <asp:HiddenField ID="hdnTaskId" runat="server" Value="0" />
                                    <%--<a id="hypSaveParentTaskTitle" href="javascript:void(0);" onclick="javascript:saveTaskTitle();">Save Title</a>--%>
                                </td>
                                <td style="vertical-align: middle;">

                                    <asp:LinkButton ID="lbtnShowWorkSpecificationSection" runat="server" Text="Work Specification Files"
                                        ValidationGroup="Submit" OnClick="lbtnShowWorkSpecificationSection_Click" />
                                    <asp:LinkButton ID="lbtnShowFinishedWorkFiles" runat="server" Text="Finished Work Files"
                                        ValidationGroup="Submit" OnClick="lbtnShowFinishedWorkFiles_Click" />

                                </td>
                            </tr>
                            <tr>
                                <td align="left">Staus:
                               
                                <asp:DropDownList ID="cmbStatus" runat="server" CssClass="textbox" />
                                    &nbsp;&nbsp;Priority:&nbsp;<asp:DropDownList ID="ddlTaskPriority" runat="server" CssClass="textbox" />
                                </td>
                                <td>
                                    <div class="block-link-container">
                                        <asp:Literal ID="ltrlFreezedSpecificationByUserLinkMain" runat="server" />
                                    </div>

                                    <asp:TextBox ID="txtAdminPasswordToFreezeSpecificationMain" runat="server" TextMode="Password" CssClass="textbox fz fz-admin" Width="110"
                                        placeholder="Admin Password" AutoPostBack="true" Visible="false" OnTextChanged="txtPasswordToFreezeSpecification_TextChanged" />

                                    <asp:TextBox ID="txtITLeadPasswordToFreezeSpecificationMain" runat="server" TextMode="Password" CssClass="textbox fz fz-techlead" Width="110"
                                        placeholder="IT Lead Password" AutoPostBack="true" Visible="false" OnTextChanged="txtPasswordToFreezeSpecification_TextChanged" />
                                    <asp:TextBox ID="txtUserPasswordToFreezeSpecificationMain" runat="server" TextMode="Password" CssClass="textbox fz fz-user" Width="110"
                                        placeholder="User Password" AutoPostBack="true" Visible="false" OnTextChanged="txtPasswordToFreezeSpecification_TextChanged" />
                                </td>
                            </tr>
                            <tr style="display: none;">
                                <td colspan="2">Task Description <span style="color: red;">*</span>:                                
                               
                                <br />
                                    <asp:TextBox ID="txtDescription" TextMode="MultiLine" runat="server" CssClass="textbox" Width="98%" Rows="10"></asp:TextBox>
                                    <%--<ajax:Editor ID="txtDescription" Width="100%" Height="100px" runat="server" ActiveMode="Design" AutoFocus="true" />--%>
                                
                                </td>
                            </tr>
                            <tr>
                                <td colspan="2">
                                    <uc1:ucTaskHistory ID="objucTaskHistory_Admin" runat="server" />
                                </td>
                            </tr>
                            <tr id="trSubTaskList" runat="server">
                                <td colspan="2">
                                    <uc1:ucSubTasks ID="objucSubTasks_Admin" runat="server" />
                                </td>
                            </tr>
                            <tr>
                                <td colspan="2">
                                    <div class="btn_sec">
                                        <asp:Button ID="btnSaveTask" runat="server" Text="Save Task" CssClass="ui-button" ValidationGroup="Submit" OnClick="btnSaveTask_Click" />
                                    </div>
                                </td>
                            </tr>
                        </table>
                        <!-- table for userview -->
                        <table id="tblUserTaskView" class="tablealign" style="width: 100%;" cellspacing="5" runat="server">
                            <tr>
                                <td><b>Designation:</b>
                                    <asp:Literal ID="ltlTUDesig" runat="server"></asp:Literal>
                                    <div id="divAcceptRejectButtons" runat="server" visible="false">
                                        <asp:LinkButton ID="lbtnAcceptTask" runat="server" Text="Accept" OnClick="lbtnAcceptTask_Click" />&nbsp;
                                    <asp:LinkButton ID="lbtnRejectTask" runat="server" Text="Reject" OnClick="lbtnRejectTask_Click" />
                                    </div>
                                </td>
                                <td><b>Status:</b>
                                    <asp:DropDownList ID="ddlTUStatus" AutoPostBack="true" runat="server" CssClass="textbox">
                                    </asp:DropDownList>
                                    &nbsp;&nbsp;
                               
                                <b>Priority:</b>
                                    <asp:Literal ID="ltrlTaskPriority" runat="server" />
                                </td>
                            </tr>
                            <tr>
                                <td class="valigntop"><b>Task Title:</b>
                                    <asp:Literal ID="ltlTUTitle" runat="server"></asp:Literal>
                                </td>
                                <td class="valigntop">
                                    <asp:LinkButton ID="lbtnShowWorkSpecificationSection1" runat="server" Text="Work Specification Files"
                                        OnClick="lbtnShowWorkSpecificationSection_Click" />&nbsp;

                                <asp:LinkButton ID="lbtnShowFinishedWorkFiles1" runat="server" Text="Finished Work Files"
                                    OnClick="lbtnShowFinishedWorkFiles_Click" />
                                    <br />
                                    <div>
                                        <div id="divWorkFileUser" class="dropzone work-file" data-hidden="<%=hdnWorkFiles.ClientID%>">
                                            <div class="fallback">
                                                <input name="WorkFile" type="file" multiple />
                                                <input type="submit" value="UploadWorkFile" />
                                            </div>
                                        </div>
                                        <div id="divWorkFileUserPreview" class="dropzone-previews work-file-previews">
                                        </div>
                                    </div>
                                </td>
                            </tr>
                            <tr style="display: none;">
                                <td colspan="2"><b>Task Description:</b>
                                    <asp:TextBox ID="txtTUDesc" TextMode="MultiLine" ReadOnly="true" Style="width: 100%;" Rows="10" runat="server"></asp:TextBox>
                                </td>
                            </tr>
                            <tr>
                                <td colspan="2">
                                    <uc1:ucTaskHistory ID="objucTaskHistory_User" runat="server" />
                                </td>
                            </tr>
                            <tr>
                                <td colspan="2">
                                    <uc1:ucSubTasks ID="objucSubTasks_User" runat="server" />
                                </td>
                            </tr>
                        </table>
                    </div>
                    <%--This is a client side hidden section and It is used to trigger server event from java script code.--%>
                    <div class="hide">
                        <input id="hdnWorkFiles" runat="server" type="hidden" />
                        <asp:Button ID="btnAddAttachment" runat="server" OnClick="btnAddAttachment_ClicK" Text="Save"
                            CssClass="ui-button" />
                    </div>
                </ContentTemplate>
            </asp:UpdatePanel>
        </div>
    </div>
    <div id="divFixedSection" runat="server" style="position: fixed; right: 0px; bottom: 0px; margin: 0px 10px 10px 0px; padding: 3px; background-color: black; color: white;">
    </div>

    <%--Popup Starts--%>
    <div class="hide">

        <div id="divAcceptanceLog" runat="server" title="Acceptance Log">
            <asp:UpdatePanel ID="upAcceptanceLog" runat="server" UpdateMode="Conditional">
                <ContentTemplate>
                    <asp:GridView ID="gvAcceptanceLog" runat="server" ShowHeaderWhenEmpty="true" EmptyDataRowStyle-HorizontalAlign="Center"
                        HeaderStyle-BackColor="Black" HeaderStyle-ForeColor="White" BackColor="White" EmptyDataRowStyle-ForeColor="Black"
                        EmptyDataText="No acceptance log available!" CssClass="table" Width="100%" CellSpacing="0" CellPadding="0"
                        AutoGenerateColumns="False" GridLines="Vertical" DataKeyNames="Id,UserId">
                        <EmptyDataRowStyle ForeColor="White" HorizontalAlign="Center" />
                        <HeaderStyle CssClass="trHeader " />
                        <RowStyle CssClass="FirstRow" />
                        <AlternatingRowStyle CssClass="AlternateRow " />
                        <Columns>
                            <asp:TemplateField HeaderText="User" HeaderStyle-HorizontalAlign="Left" ItemStyle-HorizontalAlign="Left">
                                <ItemTemplate>
                                    <%# string.Concat(Eval("UserFirstName").ToString()," - ") %>
                                    <asp:HyperLink runat="server" ForeColor="Blue"
                                        NavigateUrl='<%# Eval("UserId", "CreateSalesUser.aspx?id={0}") %>'
                                        Text='<%# Eval("UserId")%>' />
                                </ItemTemplate>
                            </asp:TemplateField>
                            <asp:TemplateField HeaderText="Status" HeaderStyle-HorizontalAlign="Left" ItemStyle-HorizontalAlign="Left">
                                <ItemTemplate>
                                    <%# Convert.ToBoolean(Eval("IsAccepted"))? "Accepted" : "Rejected" %>
                                </ItemTemplate>
                            </asp:TemplateField>
                            <asp:TemplateField HeaderText="Date" HeaderStyle-HorizontalAlign="Left" ItemStyle-HorizontalAlign="Left">
                                <ItemTemplate>
                                    <%#Eval("DateCreated")%>
                                </ItemTemplate>
                            </asp:TemplateField>
                        </Columns>
                    </asp:GridView>
                </ContentTemplate>
            </asp:UpdatePanel>
        </div>

        <%--Work Specification Popup--%>
        <div id="divWorkSpecificationSection" runat="server" title="Work Specification Files" data-min-button="Work Specification Files">
            <asp:UpdatePanel ID="upWorkSpecificationSection" runat="server" UpdateMode="Conditional">
                <ContentTemplate>
                    <asp:UpdatePanel ID="upWorkSpecifications" runat="server" UpdateMode="Conditional">
                        <ContentTemplate>
                            <div>
                                <asp:UpdatePanel ID="upWorkSpecificationAttachments" runat="server" UpdateMode="Conditional">
                                    <ContentTemplate>
                                        <table>
                                            <thead>
                                            </thead>
                                            <tbody>
                                                <tr>
                                                    <td style="vertical-align: top;">
                                                        <div id="divWorkFileAdmin" class="dropzone work-file" data-hidden="<%=hdnWorkFiles.ClientID%>">
                                                            <div class="fallback">
                                                                <input name="WorkFile" type="file" multiple />
                                                                <input type="submit" value="UploadWorkFile" />
                                                            </div>
                                                        </div>
                                                        <div id="divWorkFileAdminPreview" class="dropzone-previews work-file-previews">
                                                        </div>
                                                    </td>
                                                    <td>
                                                        <div style="text-align: right; vertical-align: top;">
                                                            <asp:Literal ID="ltrlFreezedSpecificationByUserLinkPopup" runat="server" />
                                                            <asp:TextBox ID="txtAdminPasswordToFreezeSpecificationPopup" runat="server" TextMode="Password" CssClass="textbox fz fz-admin" Width="110"
                                                                placeholder="Admin Password" AutoPostBack="true" Visible="false" OnTextChanged="txtPasswordToFreezeSpecification_TextChanged" />


                                                            <asp:TextBox ID="txtITLeadPasswordToFreezeSpecificationPopup" runat="server" TextMode="Password" CssClass="textbox fz fz-techlead" Width="110"
                                                                placeholder="IT Lead Password" AutoPostBack="true" Visible="false" OnTextChanged="txtPasswordToFreezeSpecification_TextChanged" />

                                                            <asp:TextBox ID="txtUserPasswordToFreezeSpecificationPopup" runat="server" TextMode="Password" CssClass="textbox fz fz-user" Width="110"
                                                                placeholder="User Password" AutoPostBack="true" Visible="false" OnTextChanged="txtPasswordToFreezeSpecification_TextChanged" />
                                                        </div>
                                                    </td>
                                                </tr>
                                                <tr>
                                                    <td colspan="2">
                                                        <div style="max-height: 300px; min-height: 200px; overflow-y: auto; overflow-x: hidden;">
                                                            <asp:UpdatePanel ID="upnlAttachments" runat="server" UpdateMode="Conditional">
                                                                <ContentTemplate>
                                                                    <asp:Repeater ID="grdWorkSpecificationAttachments" runat="server"
                                                                        OnItemDataBound="grdWorkSpecificationAttachments_ItemDataBound"
                                                                        OnItemCommand="grdWorkSpecificationAttachments_ItemCommand">
                                                                        <HeaderTemplate>
                                                                            <ul style="width: 100%; list-style-type: none; margin: 0px; padding: 0px;">
                                                                        </HeaderTemplate>
                                                                        <ItemTemplate>
                                                                            <li style="margin: 10px; text-align: center; float: left; width: 100px;">
                                                                                <asp:LinkButton ID="lbtnDelete" runat="server" ClientIDMode="AutoID" ForeColor="Blue" Text="Delete" CommandArgument='<%#Eval("Id").ToString()+ "|" + Eval("attachment").ToString() %>' CommandName="delete-attachment" />
                                                                                <br />
                                                                                <img id="imgIcon" runat="server" height="100" width="100" src="javascript:void(0);" />
                                                                                <br />
                                                                                <small>
                                                                                    <asp:LinkButton ID="lbtnDownload" runat="server" ForeColor="Blue" CommandName="download-attachment" />
                                                                                    <br />
                                                                                    <small><%# Convert.ToDateTime(Eval("UpdatedOn")).ToString("MM/dd/yyyy hh:mm tt") %></small>
                                                                                </small>
                                                                            </li>
                                                                        </ItemTemplate>
                                                                        <FooterTemplate>
                                                                            </ul>
                                                                       
                                                                        </FooterTemplate>
                                                                    </asp:Repeater>
                                                                </ContentTemplate>
                                                            </asp:UpdatePanel>
                                                        </div>
                                                    </td>
                                                </tr>
                                            </tbody>
                                        </table>
                                    </ContentTemplate>
                                </asp:UpdatePanel>
                            </div>
                            <uc1:ucTaskWorkSpecifications ID="objucTaskWorkSpecifications" runat="server" />
                            <br />
                        </ContentTemplate>
                    </asp:UpdatePanel>
                </ContentTemplate>
            </asp:UpdatePanel>
            <%--Below div is required to make entire section visible.--%>
            <div style="float: none; clear: both;"></div>
        </div>

        <%--Finished Work Files Popup--%>
        <div id="divFinishedWorkFiles" runat="server" title="Finished Work Files" data-min-button="Finished Work Files">
            <%--Only Allow "*.doc" files to be uploaded
                            Add Log with file name "username_datetimeofsubmitionofwork.doc."
                            When user submit their CODE files, it should be auto compiled and if there is any compilation error it should show popup to user 
                            with build error and that errors should be logged with attempt count as well. when user resubmit work it should follow same process 
                            as above and there should be max. attempt count.
            --%>
            <fieldset>
                <legend>Log Finished Work</legend>
                <hr />
                <table width="100%" border="0" cellspacing="3" cellpadding="3">
                    <tr>
                        <td width="120" align="right">Est. Hrs. of Task:
                        </td>
                        <td width="250">
                            <asp:TextBox ID="txtEstHrsOfTaskFWF" runat="server" CssClass="textbox" Width="60" />
                        </td>
                        <td width="180" align="right">Actual Hrs. of Task:
                        </td>
                        <td style="min-width: 200px;">
                            <asp:TextBox ID="txtActualHrsOfTaskFWF" runat="server" CssClass="textbox" Width="60" />
                        </td>
                    </tr>
                    <tr>
                        <td colspan="4">
                            <table width="100%">
                                <tr>
                                    <td align="left">User Acceptance:
                                           
                                        <asp:DropDownList ID="ddlUserAcceptance" runat="server" CssClass="textbox">
                                            <asp:ListItem Text="Accept" Value="1"></asp:ListItem>
                                            <asp:ListItem Text="Reject" Value="0"></asp:ListItem>
                                        </asp:DropDownList>
                                    </td>
                                    <td align="left">Due Date:
                                               
                                        <asp:TextBox ID="txtDueDate" runat="server" CssClass="textbox datepicker" Width="120" />
                                        <asp:Literal ID="ltlTUDueDate" runat="server" />
                                    </td>
                                    <td align="right">Hrs of Task:
                                               
                                        <asp:Literal ID="ltlTUHrsTask" runat="server" />
                                        <asp:TextBox ID="txtHours" runat="server" CssClass="textbox" Width="100" />
                                        <asp:RegularExpressionValidator ID="revHours" runat="server" ControlToValidate="txtHours" Display="None"
                                            ErrorMessage="Please enter decimal numbers for hours of task." ValidationGroup="SaveWorkSpecification" ValidationExpression="(\d+\.\d{1,2})?\d*" />
                                    </td>
                                </tr>
                            </table>
                        </td>
                    </tr>
                    <tr>
                        <td align="right">Freeze By:
                        </td>
                        <td>Yogesh Keraliya
                        </td>
                        <td align="right">Profile:
                        </td>
                        <td>
                            <a href="InstallCreateUser.aspx?Id=901">901</a>
                        </td>
                    </tr>
                    <tr>
                        <td align="right">Sub task:
                        </td>
                        <td>
                            <asp:DropDownList ID="ddlSubTasksFWF" runat="server" CssClass="textbox" Width="100">
                                <asp:ListItem>Select</asp:ListItem>
                                <asp:ListItem>I-a</asp:ListItem>
                                <asp:ListItem>I-b</asp:ListItem>
                                <asp:ListItem>II-b</asp:ListItem>
                            </asp:DropDownList>
                        </td>
                        <td align="right">Sub task status:
                        </td>
                        <td>
                            <asp:DropDownList ID="ddlSubTaskStatusFWF" runat="server" CssClass="textbox" Width="100">
                                <asp:ListItem>Select</asp:ListItem>
                                <asp:ListItem>Open</asp:ListItem>
                                <asp:ListItem>In Progress</asp:ListItem>
                                <asp:ListItem>Closed</asp:ListItem>
                            </asp:DropDownList>
                        </td>
                    </tr>
                    <tr>
                        <td colspan="2" valign="top">File:<br />
                            <div class="dropzone">
                                <div class="dz-default dz-message"></div>
                            </div>
                        </td>
                        <td align="right" valign="top">Date of File Submission:
                        </td>
                        <td valign="top">
                            <asp:TextBox ID="DateOfFileSubmissionFWF" runat="server" CssClass="textbox" Width="80" />
                        </td>
                    </tr>
                    <tr>
                        <td colspan="2">Code files change log: (only doc files)<br />
                            <div class="dropzone">
                                <div class="dz-default dz-message"></div>
                            </div>
                        </td>
                        <td colspan="2">Database change script file: (only sql files)<br />
                            <div class="dropzone">
                                <div class="dz-default dz-message"></div>
                            </div>
                        </td>
                    </tr>
                    <tr>
                        <td colspan="2" valign="top">Code files: (only aspx, ascx or cs files)<br />
                            <div class="dropzone">
                                <div class="dz-default dz-message"></div>
                            </div>
                        </td>
                        <td colspan="2" valign="top">Comment on sub task:
                                       
                                       

                            <br />
                            <asp:TextBox ID="txtSubTaskCommentFWF" runat="server" CssClass="textbox" TextMode="MultiLine" Style="width: 90%;" Rows="4" />
                        </td>
                    </tr>
                    <tr>
                        <td colspan="4">Test page url :<br />
                            <asp:TextBox ID="txtTestPageUrl" runat="server" CssClass="textbox" Style="width: 90%" />
                        </td>
                    </tr>
                    <tr>
                        <td colspan="4">
                            <div class="btn_sec">
                                <asp:Button ID="btnSaveFWF" runat="server" CssClass="ui-button" Text="Save" OnClientClick="javascript:return false;" />
                            </div>
                        </td>
                    </tr>
                </table>
            </fieldset>
        </div>
    </div>
    <%--Popup Ends--%>
    <script type="text/javascript" src="../js/chosen.jquery.js"></script>
    <script type="text/javascript" src="../js/angular/scripts/angular-chosen.min.js"></script>
    <script src="../js/angular/scripts/TaskPopupHelper.js"></script>

    <script type="text/javascript">
        var ddlTasksDesignations = '#<%= ddlTasksDesignations.ClientID%>';
        /**
         * Added By Kapil Pancholi
         * For Angular
         */

        $(document).ready(function () {

            //Share Popup
            $('#lnkMove').on('click', function () {
                $('#divMove').css('display', 'block');
                $(this).css('color', '#06c');
                $('#lnkShare').css('color', '#4d4a33');
                $('#divShare').css('display', 'none');
                $('.modal-icons').css('display', 'none');

                //Load All Tasks
                GetRootTasks();
            });
            $('#lnkShare').on('click', function () {
                $('#divShare').css('display', 'block');
                $(this).css('color', '#06c');
                $('#lnkMove').css('color', '#4d4a33');
                $('#divMove').css('display', 'none');
                $('.modal-icons').css('display', 'block');
            });

            //Load Chosen
            $('.chosen-input').chosen();

            //Update Chosen
            $(".chosen-input").bind("DOMSubtreeModified", function () {
                $('.chosen-input').trigger("chosen:updated");
            });

            $('#ddlRootTasks').chosen();
        });

        $(window).load(function () {
            //For Users
            var ddlDesig = '#<%=ddlDesignationSeq.ClientID%>';
            var ddlUsers = '#<%=ddlUsers.ClientID%>';

            //Load All Designations
            <%if (IsAdminMode)
        { %>
            fillUsers(ddlDesig, ddlUsers, '#lblLoading');

            $(ddlDesig).change(function (e) {
                //resetChosen('#ddlDesignationSeq');
                $('#<%=hdnSelectedDesig.ClientID%>').val($(this).val());
                fillUsers(ddlDesig, ddlUsers, '#lblLoading');
            });

            $(ddlUsers).change(function () {
                $('#<%=hdnSelectedUsers.ClientID%>').val($(this).val());
            });

            <%}%>
            //Load SubTasks
            LoadSubTasks();


        });
       <%if (IsAdminMode)
        { %>
        function fillUsers(selector, fillDDL, loader) {
            var did = $(selector).val();
            if (did != undefined && did != null) {
                did = did.join();
            }
            else {
                did = '';
            }
            var options = $(fillDDL);
            var selectedUsersString = '<%=hdnSelectedUsers.Value%>';

            var arrUsers = [];
            if (selectedUsersString.length > 0) {
                arrUsers = selectedUsersString.split(',');
                for (var i = 0; i < arrUsers.length; i++)
                    arrUsers[i] = +arrUsers[i];
            }

            $(loader).show();
            $.ajax({
                type: "POST",
                url: "ajaxcalls.aspx/GetUsersByDesignationId",
                dataType: "json",
                contentType: "application/json; charset=utf-8",
                data: JSON.stringify({ designationId: did }),
                success: function (data) {
                    options.empty();
                    //options.append($("<option selected='selected' />").val('0').text('All'));
                    // Handle 'no match' indicated by [ "" ] response
                    if (data.d) {

                        var result = [];
                        result = JSON.parse(data.d);
                        $.each(result, function () {
                            var names = this.FristName.split(' - ');
                            var name = names[0] + '&nbsp;-&nbsp;';
                            var link = names[1] != null && names[1] != '' ? '<a style="color:blue;" href="javascript:;" onclick=redir("/Sr_App/ViewSalesUser.aspx?id=' + this.Id + '")>' + names[1] + '</a>' : '';
                            if ($.inArray(this.Id, arrUsers) >= 0)
                                options.append($("<option selected='selected' />").val(this.Id).html(name + link));
                            else
                                options.append($("<option />").val(this.Id).html(name + link));
                        });
                        //$("#" + fillDDL).prop('disabled', false);
                    }
                    options.trigger("chosen:updated");
                    $(loader).hide();
                }
            });
        }
        <%}%>
        /*************END***************/

        var workspecEditor;

        Dropzone.autoDiscover = false;

        $(function () {
            Initialize();
            ApplyToolTip();
        });

        var prmTaskGenerator = Sys.WebForms.PageRequestManager.getInstance();

        prmTaskGenerator.add_endRequest(function () {
            Initialize();
        });

        function Initialize() {
            ApplyDropZone();
            EnableAutoTitleSave();
        }

        function EnableAutoTitleSave() {
            $('#<%=txtTaskTitle.ClientID%>').bind('blur', function () {
                saveTaskTitle();
            });
        }
        function ShowPopup(varControlID) {

            var windowWidth = (parseInt($(window).width()) / 2) - 10;

            var dialogwidth = windowWidth + "px";

            var objDialog = $(varControlID).dialog({ width: dialogwidth, height: "auto" });

            AppendMinimizeButton(objDialog);

            // this will enable postback from dialog buttons.
            objDialog.parent().appendTo(jQuery("form:first"));
            if (varControlID == '#<%=divFinishedWorkFiles.ClientID%>') {

                $(varControlID).dialog("option", "position", {
                    my: 'left top',
                    at: 'right+5 top',
                    of: $('#<%=divWorkSpecificationSection.ClientID%>')
                });

                $(varControlID).bind("dialogclose", function (event, ui) { location.reload(); });
            }
            else if (varControlID == '#<%=divWorkSpecificationSection.ClientID%>') {
                $(varControlID).dialog("option", "position", {
                    my: 'left top',
                    at: 'left top',
                    of: window
                });
            }
        }

        function AppendMinimizeButton(objDialog) {

            var varTarget = $('#' + objDialog.attr('id'));

            if (typeof (varTarget.attr('data-min-button')) != 'undefined') {

                if (objDialog.parent().find('.ui-dialog-titlebar-minimize').length == 0) {
                    var varMinimizeButton = $('<button type="button" class="ui-button ui-widget ui-state-default ui-corner-all ui-button-icon-only ui-dialog-titlebar-minimize" role="button" title="Minimize"><span class="ui-button-icon-primary ui-icon ui-icon-minusthick"></span><span class="ui-button-text">Minimize</span></button>');

                    varMinimizeButton.click(function () {
                        var divFixedSection = $('#<%=divFixedSection.ClientID%>');

                        if (divFixedSection.find('a[data-id="' + varTarget.attr('id') + '"]').length == 0) {
                            var varLink = $('<a data-id="' + varTarget.attr('id') + '" href="javascript:void(0);" style="margin:0px 6px 0px 0px;color:white;font-weight:bold" onclick="javascript:ShowPopup(\'#' + varTarget.attr('id') + '\');$(this).remove();">' + varTarget.attr('data-min-button') + '</a>');
                            varLink.appendTo(divFixedSection);
                        }
                        HidePopup('#' + varTarget.attr('id'));
                    });

                    varMinimizeButton.insertBefore(objDialog.parent().find('.ui-dialog-titlebar-close'));
                }
            }
        }

        function ApplyToolTip() {
            $(document).tooltip({
                items: "[data-tooltip]",
                content: function () {
                    var element = $(this);

                    if (element.is("[data-tooltipcontent]")) {
                        return element.attr("data-tooltipcontent");
                    }
                    //if ( element.is( "[title]" ) ) {
                    //    return element.attr( "title" );
                    //}
                    //if ( element.is( "img" ) ) {
                    //    return element.attr( "alt" );
                    //}
                }
            });
        }

        // check if user has selected any designations or not.
        function checkDesignations(oSrc, args) {

        }

        var objWorkFileDropzone;

        function ApplyDropZone() {
            //debugger;
            ////User's drag and drop file attachment related code

            //remove already attached dropzone.
            if (objWorkFileDropzone) {
                objWorkFileDropzone.destroy();
                objWorkFileDropzone = null;
            }
            objWorkFileDropzone = GetWorkFileDropzone("div.work-file", 'div.work-file-previews', '#<%= hdnWorkFiles.ClientID %>', '#<%=btnAddAttachment.ClientID%>');
        }

        function saveTaskTitle() {
            var Title = $('#<%=txtTaskTitle.ClientID%>').val();
            var Id = $('#<%=hdnTaskId.ClientID%>').val();
            EditTask(Id, Title);
        }
    </script>
</asp:Content>
