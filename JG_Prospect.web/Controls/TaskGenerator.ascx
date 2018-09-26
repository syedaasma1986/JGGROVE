<%@ Control Language="C#" AutoEventWireup="true" CodeBehind="TaskGenerator.ascx.cs" Inherits="JG_Prospect.Sr_App.Controls.TaskGenerator" %>
<%@ Register TagPrefix="asp" Namespace="Saplin.Controls" Assembly="DropDownCheckBoxes" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="asp" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit.HTMLEditor" TagPrefix="ajax" %>

<link rel="stylesheet" href="../css/jquery-ui.css">
<style>
    table tr th {
        border: 1px solid;
        padding: 0px;
    }

    table.table tr.trHeader {
        background: #000000;
        color: #ffffff;
    }

    .FirstRow {
        background: #f57575;
        padding: 2px;
    }

    .AlternateRow {
        background: #f6f1f3;
        padding: 2px;
    }

    .dark-gray-background {
        background-color: darkgray;
        background-image: none;
    }

    .AlternateRow a, .FirstRow a {
        color: #111;
    }

    .textbox {
        padding: 5px;
        border-radius: 5px;
        border: #b5b4b4 1px solid;
        margin-left: 0;
        margin-right: 0;
        margin-bottom: 5px;
    }

    .tablealign {
        margin-top: 5px;
    }

    div.dd_chk_select {
        height: 30px;
    }

        div.dd_chk_select div#caption {
            top: 7px;
            margin-left: 10px;
        }

    div.dd_chk_drop {
        top: 30px;
    }

    .ui-autocomplete {
        max-height: 250px;
        overflow-y: auto;
        /* prevent horizontal scrollbar */
        overflow-x: hidden;
    }

    .ui-autocomplete-category {
        font-weight: bold;
        padding: .2em .4em;
        margin: .8em 0 .2em;
        line-height: 1.5;
        text-align: center;
    }

    .ui-autocomplete-loading {
        background: white url("../img/ui-anim_basic_16x16.png") right center no-repeat;
    }

    .task-history-tab {
        min-height: 200px;
        max-height: 400px;
        overflow: auto;
        overflow-x: hidden;
    }
    .chosen-disabled{
        width: 150px !important;
    }
    /*#divTask{
        height: 265px;
        margin-right: 400px !important;
        width: 100%;
    }*/
</style>

<%--<div id="divTaskMain" class="tasklist" style="max-height: 256px;">
    <table style="background: url(../img/dashboard-bg.png); width: 100%;" class="tableFilter">
        <tbody>
            <tr style="background-color: #000; color: white; font-weight: bold; text-align: center;">
                <td style="width: 10%;">
                    <span id="lblDesignation">Designation</span></td>
                <td>
                    <span id="lblUserStatus">User &amp; Task Status</span><span style="color: red">*</span></td>
                <td>
                    <span id="lblAddedBy">Users</span></td>

                <td style="width: 435px !important;">
                    <span id="Label2">Select Period</span>
                </td>
                <td>Search</td>
            </tr>
            <tr>
                <td>
                    <div class="chosen-container chosen-container-multi" style="width: 129px;" title="" id="ddlDesignationSeq_chosen">
                        <ul class="chosen-choices">
                            <li class="search-choice"><span>All</span><a class="search-choice-close" data-option-array-index="0"></a></li>
                            <li class="search-field"></li>
                        </ul>
                        <div class="chosen-drop">
                            <ul class="chosen-results">
                                <li class="result-selected" data-option-array-index="0" style="">All</li>
                            </ul>
                        </div>
                    </div>
                </td>
                <td>
                    <div class="chosen-container chosen-container-multi" style="width: 122px;" title="" id="ddlUserStatus_chosen">
                        <ul class="chosen-choices">
                            <li class="search-choice"><span>Active</span><a class="search-choice-close" data-option-array-index="2"></a></li>
                            <li class="search-field"></li>
                        </ul>
                        <div class="chosen-drop">
                            <ul class="chosen-results"></ul>
                        </div>
                    </div>
                </td>
                <td>
                    <div class="chosen-container chosen-container-multi" style="width: 200px;" title="" id="chosen-drop-user">
                        <ul class="chosen-choices">
                            <li class="search-choice"><span>justin m. grove&nbsp;-&nbsp;<a style="color: blue;" href="javascript:;" onclick="redir(&quot;/Sr_App/ViewSalesUser.aspx?id=780&quot;)">ADM-A0064</a></span><a class="search-choice-close" data-option-array-index="1"></a></li>
                            <li class="search-choice"><span>Yogesh N. Keraliya&nbsp;-&nbsp;<a style="color: blue;" href="javascript:;" onclick="redir(&quot;/Sr_App/ViewSalesUser.aspx?id=901&quot;)">ITL-A0002</a></span><a class="search-choice-close" data-option-array-index="8"></a></li>
                            <li class="search-field"></li>
                        </ul>
                    </div>
                    <span id="lblLoading" style="display: none;">Loading...</span>
                </td>

                <td style="text-align: left; text-wrap: avoid; padding: 0px">
                    <div style="float: left; width: 57%;">
                        <input class="chkAllDates" name="chkAllDates" type="checkbox" checked="checked"><label for="chkAllDates">All</label>
                        <input class="chkOneYear" name="chkOneYear" type="checkbox"><label for="chkOneYear">1 year</label>
                        <input class="chkThreeMonth" name="chkThreeMonth" type="checkbox"><label for="chkThreeMonth"> Quarter (3 months)</label>
                        <br>
                        <input class="chkOneMonth" name="chkOneMonth" type="checkbox"><label for="chkOneMonth"> 1 month</label>
                        <input class="chkTwoWks" name="chkTwoWks" type="checkbox"><label for="chkTwoWks"> 2 weeks (pay period!)</label>
                    </div>

                    <div>
                        <span id="Label3">From :*
                            <input type="text" maxlength="10" tabindex="2" onkeypress="return false" style="width: 80px;">
                            <br>
                        </span>

                        <span id="Label4">To :*
                            <input type="text" maxlength="10" tabindex="3" onkeypress="return false" style="width: 80px; margin-left: 16px;">
                        </span>
                    </div>
                </td>
                <td>
                    <input class="textbox ui-autocomplete-input" maxlength="15" placeholder="search users" type="text">
                </td>
            </tr>
            <tr style="">
                <td style=""></td>
                <td></td>
                <td></td>
                <td colspan="2" style="padding: 0px;">
                    <div class="ui-tabs ui-widget ui-widget-content ui-corner-all" style="width: 58%; float: right;">
                        <ul class="ui-tabs-nav ui-helper-reset ui-helper-clearfix ui-widget-header ui-corner-all" role="tablist">
                            <li class="ui-state-default ui-corner-top ui-tabs-active ui-state-active" role="tab" tabindex="0" aria-controls="StaffTask" aria-labelledby="ui-id-29" aria-selected="true"><a href="#StaffTask" class="ui-tabs-anchor" role="presentation" tabindex="-1" id="ui-id-29">Staff Tasks</a></li>
                            <li class="ui-state-default ui-corner-top" role="tab" tabindex="-1" aria-controls="TechTask" aria-labelledby="ui-id-30" aria-selected="false"><a href="#TechTask" class="ui-tabs-anchor" role="presentation" tabindex="-1" id="ui-id-30">Tech Tasks</a></li>

                        </ul>
                    </div>
                </td>
            </tr>
        </tbody>
    </table>
    <div class="div-table-row-header">
        <div class="div-table-col seq-number-fixed">Sequence#</div>
        <div class="div-table-col seq-taskid-fixed">
            ID#<div>Designation</div>
        </div>
        <div class="div-table-col seq-tasktitle-fixed" style="width: 179px;">
            Parent Task
                                        <div>SubTask Title</div>
        </div>
        <div class="div-table-col seq-taskstatus-fixed">
            Status<div>Assigned To</div>
        </div>
        <div class="div-table-col seq-taskduedate-fixed" style="width: 11% !important;">
            Total Hours<br>
            Total $
        </div>
        <div class="div-table-col seq-notes-fixed" style="width: 18% !important;">Notes</div>
    </div>
    <div ng-attr-id="divMasterTask{{Task.TaskId}}" class="div-table-row ng-scope orange" data-ng-repeat="Task in Tasks" ng-class="{orange : Task.Status==='4', yellow: Task.Status==='3'}" repeat-end="onStaffEnd()" id="divMasterTask657" style="display: table;">
        <!-- Sequence# starts -->
        <div class="div-table-col seq-number-fixed">
            <a ng-attr-id="autoClick{{Task.TaskId}}" href="javascript:void(0);" class="badge-hyperlink autoclickSeqEdit" ng-attr-data-taskseq="{{Task.Sequence}}" ng-attr-data-taskid="{{Task.TaskId}}" ng-attr-data-seqdesgid="{{Task.SequenceDesignationId}}" id="autoClick657" data-taskseq="2" data-taskid="657" data-seqdesgid="10"><span class="badge badge-success badge-xstext">
                <label ng-attr-id="SeqLabel{{Task.TaskId}}" class="ng-binding" id="SeqLabel657">2-ITSN:SS</label></span></a>



        </div>
        <!-- Sequence# ends -->

        <!-- ID# and Designation starts -->
        <div class="div-table-col seq-taskid-fixed ng-binding">
            <a ng-href="../Sr_App/TaskGenerator.aspx?TaskId=418&amp;hstid=657" oncontextmenu="openCopyBox(this);return false;" data-installid="ITJN029-IX" parentdata-highlighter="418" data-highlighter="657" class="bluetext context-menu ng-binding" target="_blank" href="../Sr_App/TaskGenerator.aspx?TaskId=418&amp;hstid=657">ITJN029-IX</a><br>
            IT - Sr .Net Developer                                        
        </div>
        <!-- ID# and Designation ends -->

        <!-- Parent Task & SubTask Title starts -->
        <div class="div-table-col seq-tasktitle-fixed ng-binding">
            Task Generator: http://web.jmgrovebuildingsupply.com/Sr_App/TaskGenerator.aspx
                                        <br>
            Task generator DESCRIPTION column upgrade
        </div>
        <!-- Parent Task & SubTask Title ends -->

        <!-- Status & Assigned To starts -->
        <div class="div-table-col seq-taskstatus-fixed chosen-div">
            <select id="drpStatusSubsequence657" onchange="changeTaskStatusClosed(this);" data-highlighter="657" style="width: 100%;">
                <option ng-selected="true" value="4" selected="selected">InProgress</option>

                <option ng-selected="false" style="color: lawngreen" value="3">Request-Assigned</option>
                <option ng-selected="false" value="1">Open</option>



                <option ng-selected="false" value="11">Test Commit</option>

            </select>
            <br>

            <select class="ddlAssignedUsers" disabled="" id="ddcbSeqAssignedStaff657" style="width: 100%; display: none;" multiple="" ng-attr-data-assignedusers="{{Task.TaskAssignedUserIDs}}" data-chosen="1" data-placeholder="Select Users" onchange="EditSeqAssignedTaskUsers(this);" data-taskid="657" data-taskstatus="4" data-assignedusers="{&quot;Id&quot; : &quot;3697&quot;}">
                <!-- ngRepeat: item in DesignationAssignUsers -->
                <option ng-repeat="item in DesignationAssignUsers" value="3797" label="Jitendra J. Pancholi - ITSN-A0411" class="activeUser">Jitendra J. Pancholi - ITSN-A0411
                </option>
                <!-- end ngRepeat: item in DesignationAssignUsers -->
                <option ng-repeat="item in DesignationAssignUsers" value="3697" label="Kapil K. Pancholi - ITSN-A0411" class="activeUser">Kapil K. Pancholi - ITSN-A0411
                </option>
                <!-- end ngRepeat: item in DesignationAssignUsers -->
                <option ng-repeat="item in DesignationAssignUsers" value="3516" label="Shreyas H. Patel - ITSN-A0411" class="IOUser">Shreyas H. Patel - ITSN-A0411
                </option>
                <!-- end ngRepeat: item in DesignationAssignUsers -->
                <option ng-repeat="item in DesignationAssignUsers" value="1096" label="Aavadesh  Patel - ITSN-A0411" class="IOUser">Aavadesh  Patel - ITSN-A0411
                </option>
                <!-- end ngRepeat: item in DesignationAssignUsers -->
                <option ng-repeat="item in DesignationAssignUsers" value="894" label="Ali Shahbad - ITSN-A0411" class="IOUser">Ali Shahbad - ITSN-A0411
                </option>
                <!-- end ngRepeat: item in DesignationAssignUsers -->
                <option ng-repeat="item in DesignationAssignUsers" value="1088" label="Amit Agarwal - ITSN-A0411" class="IOUser">Amit Agarwal - ITSN-A0411
                </option>
                <!-- end ngRepeat: item in DesignationAssignUsers -->
                <option ng-repeat="item in DesignationAssignUsers" value="1092" label="Bhaskhar  D - ITSN-A0411" class="IOUser">Bhaskhar  D - ITSN-A0411
                </option>
                <!-- end ngRepeat: item in DesignationAssignUsers -->
                <option ng-repeat="item in DesignationAssignUsers" value="1115" label="Bhavik J. vaishnani - ITSN-A0411" class="IOUser">Bhavik J. vaishnani - ITSN-A0411
                </option>
                <!-- end ngRepeat: item in DesignationAssignUsers -->
                <option ng-repeat="item in DesignationAssignUsers" value="2648" label="Bismi T. Demo - ITSN-A0411" class="IOUser">Bismi T. Demo - ITSN-A0411
                </option>
                <!-- end ngRepeat: item in DesignationAssignUsers -->
                <option ng-repeat="item in DesignationAssignUsers" value="997" label="Brahmeswar  . Gade - ITSN-A0411" class="IOUser">Brahmeswar  . Gade - ITSN-A0411
                </option>
                <!-- end ngRepeat: item in DesignationAssignUsers -->
                <option ng-repeat="item in DesignationAssignUsers" value="3614" label="Charandeep S. Singh - ITSN-A0411" class="IOUser">Charandeep S. Singh - ITSN-A0411
                </option>
                <!-- end ngRepeat: item in DesignationAssignUsers -->
                <option ng-repeat="item in DesignationAssignUsers" value="921" label="Faheem Ullah - ITSN-A0411" class="IOUser">Faheem Ullah - ITSN-A0411
                </option>
                <!-- end ngRepeat: item in DesignationAssignUsers -->
                <option ng-repeat="item in DesignationAssignUsers" value="3714" label="Jigar B. Shah - ITSN-A0411" class="IOUser">Jigar B. Shah - ITSN-A0411
                </option>
                <!-- end ngRepeat: item in DesignationAssignUsers -->
                <option ng-repeat="item in DesignationAssignUsers" value="1089" label="Liyo  Jose - ITSN-A0411" class="IOUser">Liyo  Jose - ITSN-A0411
                </option>
                <!-- end ngRepeat: item in DesignationAssignUsers -->
                <option ng-repeat="item in DesignationAssignUsers" value="2909" label="Manisha Heman. Shinde - ITSN-A0411" class="IOUser">Manisha Heman. Shinde - ITSN-A0411
                </option>
                <!-- end ngRepeat: item in DesignationAssignUsers -->
                <option ng-repeat="item in DesignationAssignUsers" value="2652" label="Mohd Mr. Rafi - ITSN-A0411" class="IOUser">Mohd Mr. Rafi - ITSN-A0411
                </option>
                <!-- end ngRepeat: item in DesignationAssignUsers -->
                <option ng-repeat="item in DesignationAssignUsers" value="1179" label="Mudit Sharma - ITSN-A0411" class="IOUser">Mudit Sharma - ITSN-A0411
                </option>
                <!-- end ngRepeat: item in DesignationAssignUsers -->
                <option ng-repeat="item in DesignationAssignUsers" value="2765" label="Nandkumar C. Chavan - ITSN-A0411" class="IOUser">Nandkumar C. Chavan - ITSN-A0411
                </option>
                <!-- end ngRepeat: item in DesignationAssignUsers -->
                <option ng-repeat="item in DesignationAssignUsers" value="3724" label="Pawan k. tiwari - ITSN-A0411" class="IOUser">Pawan k. tiwari - ITSN-A0411
                </option>
                <!-- end ngRepeat: item in DesignationAssignUsers -->
                <option ng-repeat="item in DesignationAssignUsers" value="1029" label="Ramya  Akunuri  - ITSN-A0411" class="IOUser">Ramya  Akunuri  - ITSN-A0411
                </option>
                <!-- end ngRepeat: item in DesignationAssignUsers -->
                <option ng-repeat="item in DesignationAssignUsers" value="1184" label="satinder  hundal  - ITSN-A0411" class="IOUser">satinder  hundal  - ITSN-A0411
                </option>
                <!-- end ngRepeat: item in DesignationAssignUsers -->
                <option ng-repeat="item in DesignationAssignUsers" value="1143" label="Shekhar Pawar - ITSN-A0411" class="IOUser">Shekhar Pawar - ITSN-A0411
                </option>
                <!-- end ngRepeat: item in DesignationAssignUsers -->
                <option ng-repeat="item in DesignationAssignUsers" value="835" label="Shilpa Ms. Gupta - ITSN-A0411" class="IOUser">Shilpa Ms. Gupta - ITSN-A0411
                </option>
                <!-- end ngRepeat: item in DesignationAssignUsers -->
                <option ng-repeat="item in DesignationAssignUsers" value="1095" label="Sridhar  D - ITSN-A0411" class="IOUser">Sridhar  D - ITSN-A0411
                </option>
                <!-- end ngRepeat: item in DesignationAssignUsers -->
                <option ng-repeat="item in DesignationAssignUsers" value="1086" label="Vinod Pandya - ITSN-A0411" class="IOUser">Vinod Pandya - ITSN-A0411
                </option>
                <!-- end ngRepeat: item in DesignationAssignUsers -->
                <option ng-repeat="item in DesignationAssignUsers" value="1109" label="Vivek Sharma - ITSN-A0411" class="IOUser">Vivek Sharma - ITSN-A0411
                </option>
                <!-- end ngRepeat: item in DesignationAssignUsers -->
                <option ng-repeat="item in DesignationAssignUsers" value="2653" label="Zubair A. Khan - ITSN-A0411" class="IOUser">Zubair A. Khan - ITSN-A0411
                </option>
                <!-- end ngRepeat: item in DesignationAssignUsers -->
            </select><div class="chosen-container chosen-container-multi chosen-disabled" style="width: 0px;" title="" id="ddcbSeqAssignedStaff657_chosen">
                <ul class="chosen-choices">
                    <li class="search-choice"><span>Kapil K. Pancholi - ITSN-A0411
                    </span><a class="search-choice-close" data-option-array-index="1"></a></li>
                    <li class="search-field">
                        <input type="text" value="Select Users" class="" autocomplete="off" style="width: 25px;" disabled=""></li>
                </ul>
                <div class="chosen-drop">
                    <ul class="chosen-results"></ul>
                </div>
            </div>
            <div class="chosen-container chosen-container-multi chosen-disabled" style="width: 0px;" title="" id="ddcbSeqAssignedStaff657_chosen">
                <ul class="chosen-choices">
                    <li class="search-choice"><span>Kapil K. Pancholi - ITSN-A0411
                    </span><a class="search-choice-close" data-option-array-index="1"></a></li>
                    <li class="search-field">
                        <input type="text" value="Select Users" class="" autocomplete="off" style="width: 25px;" disabled=""></li>
                </ul>
                <div class="chosen-drop">
                    <ul class="chosen-results"></ul>
                </div>
            </div>





        </div>
        <!-- Status & Assigned To ends -->

        <!-- DueDate starts -->
        <div class="div-table-col seq-taskduedate-fixed">
            <div class="seqapprovalBoxes" id="SeqApprovalDiv657" data-adminstatusupdateddate="9/16/2017" data-adminstatusupdatedtime="9:18 PM" data-adminstatusupdatedtimezone="(EST)" data-adminstatusupdated="2017-09-16T15:48:27.19+00:00" data-admindisplayname="INS00092 - justin grove" data-adminstatususerid="780" data-leadstatusupdateddate="9/20/2017" data-leadstatusupdatedtime="6:47 PM" data-leadstatusupdatedtimezone="(EST)" data-leadstatusupdated="16" data-leadhours="16" data-leaddisplayname="901 - Yogesh Keraliya" data-leaduserid="901" data-userstatusupdateddate="" data-userstatusupdatedtime="" data-userstatusupdatedtimezone="" data-userstatusupdated="" data-userhours="" data-userdisplayname=" -  " data-useruserid="">
                <div style="width: 55%; float: left;">
                    <input type="checkbox" data-taskid="657" onchange="openSeqApprovalPopup(this)" id="chkngUserMaster657" ng-checked="false" ng-disabled="false" class="fz fz-user" title="User">
                    <input type="checkbox" data-taskid="657" onchange="openSeqApprovalPopup(this)" id="chkQAMaster657" class="fz fz-QA" title="QA">
                    <input type="checkbox" data-taskid="657" onchange="openSeqApprovalPopup(this)" id="chkAlphaUserMaster657" class="fz fz-Alpha" title="AlphaUser">
                    <br>
                    <input type="checkbox" data-taskid="657" onchange="openSeqApprovalPopup(this)" id="chkBetaUserMaster657" class="fz fz-Beta" title="BetaUser">
                    <input type="checkbox" data-taskid="657" onchange="openSeqApprovalPopup(this)" id="chkngITLead657" ng-checked="true" ng-disabled="true" class="fz fz-techlead" title="IT Lead" disabled="disabled" checked="checked">
                    <input type="checkbox" data-taskid="657" onchange="openSeqApprovalPopup(this)" id="chkngAdmin657" ng-checked="true" ng-disabled="true" class="fz fz-admin" title="Admin" disabled="disabled" checked="checked">
                </div>
                <div style="width: 42%; float: right;">
                    <input type="checkbox" data-taskid="657" onchange="openSeqApprovalPopup(this)" id="chkngITLeadMaster657" class="fz fz-techlead largecheckbox" title="IT Lead"><br>
                    <input type="checkbox" data-taskid="657" onchange="openSeqApprovalPopup(this)" id="chkngAdminMaster657" class="fz fz-admin largecheckbox" title="Admin">
                </div>
            </div>


        </div>
        <!-- DueDate ends -->

        <!-- Nested row starts -->

        <div class="div-table-nested" ng-class="{hide : StringIsNullOrEmpty(Task.SubSeqTasks)}">

            <!-- Body section starts -->
            <!-- ngRepeat: TechTask in correctDataforAngular(Task.SubSeqTasks) -->
            <div class="div-table-row ng-scope yellow" ng-repeat="TechTask in correctDataforAngular(Task.SubSeqTasks)" ng-class="{orange : TechTask.Status==='4', yellow: TechTask.Status==='3'}">
                <!-- Sequence# starts -->
                <div class="div-table-col seq-number-fixed">
                    <a style="text-decoration: none;" ng-show="!$first" ng-attr-data-taskid="{{TechTask.TaskId}}" href="javascript:void(0);" class="uplink ng-hide" ng-class="{hide: TechTask.Sequence == null || 0}" ng-attr-data-taskseq="{{TechTask.SubSequence}}" ng-attr-data-taskdesg="{{TechTask.SequenceDesignationId}}" onclick="swapSubSequence(this,true)" data-taskid="765" data-taskseq="4" data-taskdesg="10">?</a><a style="text-decoration: none;" ng-class="{hide: TechTask.Sequence == null || 0}" ng-attr-data-taskid="{{TechTask.TaskId}}" ng-attr-data-taskseq="{{TechTask.SubSequence}}" class="downlink" ng-attr-data-taskdesg="{{TechTask.SequenceDesignationId}}" href="javascript:void(0);" ng-show="!$last" onclick="swapSubSequence(this,false)" data-taskid="765" data-taskseq="4" data-taskdesg="10">?</a>
                    <a ng-attr-id="autoClick{{Task.TaskId}}" href="javascript:void(0);" class="badge-hyperlink autoclickSeqEdit" ng-attr-data-taskid="{{TechTask.TaskId}}" ng-attr-data-seqdesgid="{{TechTask.SequenceDesignationId}}" id="autoClick657" data-taskid="765" data-seqdesgid="10"><span class="badge badge-error badge-xstext">
                        <label ng-attr-id="SeqLabel{{TechTask.TaskId}}" class="ng-binding" id="SeqLabel765">2 (IV)-ITSN:SS</label></span></a>
                    <div class="handle-counter hide" ng-class="{hide: TechTask.TaskId != HighLightTaskId}" ng-attr-id="divSeq{{TechTask.TaskId}}" id="divSeq765">
                        <input type="text" class="textbox hide" ng-attr-data-original-val="{{ TechTask.Sequence == null &amp;&amp; 0 || TechTask.Sequence}}" ng-attr-data-original-desgid="{{TechTask.SequenceDesignationId}}" ng-attr-id="txtSeq{{TechTask.TaskId}}" value="2" data-original-val="2" data-original-desgid="10" id="txtSeq765">
                    </div>
                </div>
                <!-- Sequence# ends -->

                <!-- ID# and Designation starts -->
                <div class="div-table-col seq-taskid-fixed ng-binding">
                    <a ng-href="../Sr_App/TaskGenerator.aspx?TaskId=418&amp;hstid=765" oncontextmenu="openCopyBox(this);return false;" data-installid="ITJN029-IX-IX - c" parentdata-highlighter="418" data-highlighter="765" class="bluetext context-menu ng-binding" target="_blank" href="../Sr_App/TaskGenerator.aspx?TaskId=418&amp;hstid=765">ITJN029-IX-IX - c</a><br>
                    IT - Sr .Net Developer
                                        <div ng-attr-id="divSeqDesg{{TechTask.TaskId}}" ng-class="{hide: TechTask.TaskId != HighLightTaskId}" id="divSeqDesg765" class="hide">
                                            <select class="textbox hide ng-pristine ng-untouched ng-valid ng-empty" ng-attr-data-taskid="{{TechTask.TaskId}}" ng-options="item as item.Name for item in ParentTaskDesignations track by item.Id" ng-model="DesignationSelectModel[$index]" data-taskid="765">
                                                <option value="?" selected="selected"></option>
                                            </select>
                                        </div>
                </div>
                <!-- ID# and Designation ends -->

                <!-- Parent Task & SubTask Title starts -->
                <div class="div-table-col seq-tasktitle-fixed ng-binding">
                    Task Generator: http://web.jmgrovebuildingsupply.com/Sr_App/TaskGenerator.aspx
                                        <br>
                    Recover and start working on this task - confirmation adding new ID#'s are same
                </div>
                <!-- Parent Task & SubTask Title ends -->

                <!-- Status & Assigned To starts -->
                <div class="div-table-col seq-taskstatus-fixed chosen-div">
                    <select id="drpStatusSubsequenceNested765" onchange="changeTaskStatusClosed(this);" data-highlighter="765">

                        <option ng-selected="false" value="4">InProgress</option>

                        <option ng-selected="true" style="color: lawngreen" value="3" selected="selected">Request-Assigned</option>
                        <option ng-selected="false" value="1">Open</option>



                        <option ng-selected="false" value="11">Test Commit</option>

                    </select>
                    <br>
                    <select disabled="" id="ddcbSeqAssignedIA765" style="width: 100%; display: none;" multiple="" ng-attr-data-assignedusers="{{TechTask.TaskAssignedUserIDs}}" data-chosen="1" data-placeholder="Select Users" onchange="EditSeqAssignedTaskUsers(this);" data-taskid="765" data-taskstatus="3" data-assignedusers="{&quot;Id&quot; : &quot;3697&quot;}">
                        <!-- ngRepeat: item in DesignationAssignUsers -->
                        <option ng-repeat="item in DesignationAssignUsers" value="3797" label="Jitendra J. Pancholi - ITSN-A0411" class="activeUser">Jitendra J. Pancholi - ITSN-A0411
                                                
                        </option>
                        <!-- end ngRepeat: item in DesignationAssignUsers -->
                        <option ng-repeat="item in DesignationAssignUsers" value="3697" label="Kapil K. Pancholi - ITSN-A0411" class="activeUser">Kapil K. Pancholi - ITSN-A0411
                                                
                        </option>
                        <!-- end ngRepeat: item in DesignationAssignUsers -->
                        <option ng-repeat="item in DesignationAssignUsers" value="3516" label="Shreyas H. Patel - ITSN-A0411" class="IOUser">Shreyas H. Patel - ITSN-A0411
                                                
                        </option>
                        <!-- end ngRepeat: item in DesignationAssignUsers -->
                        <option ng-repeat="item in DesignationAssignUsers" value="1096" label="Aavadesh  Patel - ITSN-A0411" class="IOUser">Aavadesh  Patel - ITSN-A0411
                                                
                        </option>
                        <!-- end ngRepeat: item in DesignationAssignUsers -->
                        <option ng-repeat="item in DesignationAssignUsers" value="894" label="Ali Shahbad - ITSN-A0411" class="IOUser">Ali Shahbad - ITSN-A0411
                                                
                        </option>
                        <!-- end ngRepeat: item in DesignationAssignUsers -->
                        <option ng-repeat="item in DesignationAssignUsers" value="1088" label="Amit Agarwal - ITSN-A0411" class="IOUser">Amit Agarwal - ITSN-A0411
                                                
                        </option>
                        <!-- end ngRepeat: item in DesignationAssignUsers -->
                        <option ng-repeat="item in DesignationAssignUsers" value="1092" label="Bhaskhar  D - ITSN-A0411" class="IOUser">Bhaskhar  D - ITSN-A0411
                                                
                        </option>
                        <!-- end ngRepeat: item in DesignationAssignUsers -->
                        <option ng-repeat="item in DesignationAssignUsers" value="1115" label="Bhavik J. vaishnani - ITSN-A0411" class="IOUser">Bhavik J. vaishnani - ITSN-A0411
                                                
                        </option>
                        <!-- end ngRepeat: item in DesignationAssignUsers -->
                        <option ng-repeat="item in DesignationAssignUsers" value="2648" label="Bismi T. Demo - ITSN-A0411" class="IOUser">Bismi T. Demo - ITSN-A0411
                                                
                        </option>
                        <!-- end ngRepeat: item in DesignationAssignUsers -->
                        <option ng-repeat="item in DesignationAssignUsers" value="997" label="Brahmeswar  . Gade - ITSN-A0411" class="IOUser">Brahmeswar  . Gade - ITSN-A0411
                                                
                        </option>
                        <!-- end ngRepeat: item in DesignationAssignUsers -->
                        <option ng-repeat="item in DesignationAssignUsers" value="3614" label="Charandeep S. Singh - ITSN-A0411" class="IOUser">Charandeep S. Singh - ITSN-A0411
                                                
                        </option>
                        <!-- end ngRepeat: item in DesignationAssignUsers -->
                        <option ng-repeat="item in DesignationAssignUsers" value="921" label="Faheem Ullah - ITSN-A0411" class="IOUser">Faheem Ullah - ITSN-A0411
                                                
                        </option>
                        <!-- end ngRepeat: item in DesignationAssignUsers -->
                        <option ng-repeat="item in DesignationAssignUsers" value="3714" label="Jigar B. Shah - ITSN-A0411" class="IOUser">Jigar B. Shah - ITSN-A0411
                                                
                        </option>
                        <!-- end ngRepeat: item in DesignationAssignUsers -->
                        <option ng-repeat="item in DesignationAssignUsers" value="1089" label="Liyo  Jose - ITSN-A0411" class="IOUser">Liyo  Jose - ITSN-A0411
                                                
                        </option>
                        <!-- end ngRepeat: item in DesignationAssignUsers -->
                        <option ng-repeat="item in DesignationAssignUsers" value="2909" label="Manisha Heman. Shinde - ITSN-A0411" class="IOUser">Manisha Heman. Shinde - ITSN-A0411
                                                
                        </option>
                        <!-- end ngRepeat: item in DesignationAssignUsers -->
                        <option ng-repeat="item in DesignationAssignUsers" value="2652" label="Mohd Mr. Rafi - ITSN-A0411" class="IOUser">Mohd Mr. Rafi - ITSN-A0411
                                                
                        </option>
                        <!-- end ngRepeat: item in DesignationAssignUsers -->
                        <option ng-repeat="item in DesignationAssignUsers" value="1179" label="Mudit Sharma - ITSN-A0411" class="IOUser">Mudit Sharma - ITSN-A0411
                                                
                        </option>
                        <!-- end ngRepeat: item in DesignationAssignUsers -->
                        <option ng-repeat="item in DesignationAssignUsers" value="2765" label="Nandkumar C. Chavan - ITSN-A0411" class="IOUser">Nandkumar C. Chavan - ITSN-A0411
                                                
                        </option>
                        <!-- end ngRepeat: item in DesignationAssignUsers -->
                        <option ng-repeat="item in DesignationAssignUsers" value="3724" label="Pawan k. tiwari - ITSN-A0411" class="IOUser">Pawan k. tiwari - ITSN-A0411
                                                
                        </option>
                        <!-- end ngRepeat: item in DesignationAssignUsers -->
                        <option ng-repeat="item in DesignationAssignUsers" value="1029" label="Ramya  Akunuri  - ITSN-A0411" class="IOUser">Ramya  Akunuri  - ITSN-A0411
                                                
                        </option>
                        <!-- end ngRepeat: item in DesignationAssignUsers -->
                        <option ng-repeat="item in DesignationAssignUsers" value="1184" label="satinder  hundal  - ITSN-A0411" class="IOUser">satinder  hundal  - ITSN-A0411
                                                
                        </option>
                        <!-- end ngRepeat: item in DesignationAssignUsers -->
                        <option ng-repeat="item in DesignationAssignUsers" value="1143" label="Shekhar Pawar - ITSN-A0411" class="IOUser">Shekhar Pawar - ITSN-A0411
                                                
                        </option>
                        <!-- end ngRepeat: item in DesignationAssignUsers -->
                        <option ng-repeat="item in DesignationAssignUsers" value="835" label="Shilpa Ms. Gupta - ITSN-A0411" class="IOUser">Shilpa Ms. Gupta - ITSN-A0411
                                                
                        </option>
                        <!-- end ngRepeat: item in DesignationAssignUsers -->
                        <option ng-repeat="item in DesignationAssignUsers" value="1095" label="Sridhar  D - ITSN-A0411" class="IOUser">Sridhar  D - ITSN-A0411
                                                
                        </option>
                        <!-- end ngRepeat: item in DesignationAssignUsers -->
                        <option ng-repeat="item in DesignationAssignUsers" value="1086" label="Vinod Pandya - ITSN-A0411" class="IOUser">Vinod Pandya - ITSN-A0411
                                                
                        </option>
                        <!-- end ngRepeat: item in DesignationAssignUsers -->
                        <option ng-repeat="item in DesignationAssignUsers" value="1109" label="Vivek Sharma - ITSN-A0411" class="IOUser">Vivek Sharma - ITSN-A0411
                                                
                        </option>
                        <!-- end ngRepeat: item in DesignationAssignUsers -->
                        <option ng-repeat="item in DesignationAssignUsers" value="2653" label="Zubair A. Khan - ITSN-A0411" class="IOUser">Zubair A. Khan - ITSN-A0411
                                                
                        </option>
                        <!-- end ngRepeat: item in DesignationAssignUsers -->
                    </select><div class="chosen-container chosen-container-multi chosen-disabled" style="width: 0px;" title="" id="ddcbSeqAssignedIA765_chosen">
                        <ul class="chosen-choices">
                            <li class="search-choice"><span>Kapil K. Pancholi - ITSN-A0411
                                                
                            </span><a class="search-choice-close" data-option-array-index="1"></a></li>
                            <li class="search-field">
                                <input type="text" value="Select Users" class="" autocomplete="off" style="width: 25px;" disabled=""></li>
                        </ul>
                        <div class="chosen-drop">
                            <ul class="chosen-results"></ul>
                        </div>
                    </div>
                    <div class="chosen-container chosen-container-multi chosen-disabled" style="width: 0px;" title="" id="ddcbSeqAssignedIA765_chosen">
                        <ul class="chosen-choices">
                            <li class="search-choice"><span>Kapil K. Pancholi - ITSN-A0411
                                                
                            </span><a class="search-choice-close" data-option-array-index="1"></a></li>
                            <li class="search-field">
                                <input type="text" value="Select Users" class="" autocomplete="off" style="width: 25px;" disabled=""></li>
                        </ul>
                        <div class="chosen-drop">
                            <ul class="chosen-results"></ul>
                        </div>
                    </div>

                </div>
                <!-- Status & Assigned To ends -->
                <div class="div-table-col seq-taskduedate-fixed">
                    <div class="seqapprovalBoxes" id="SeqApprovalDiv765" data-adminstatusupdateddate="" data-adminstatusupdatedtime="" data-adminstatusupdatedtimezone="" data-adminstatusupdated="" data-admindisplayname=" -  " data-adminstatususerid="" data-leadstatusupdateddate="" data-leadstatusupdatedtime="" data-leadstatusupdatedtimezone="" data-leadstatusupdated="" data-leadhours="" data-leaddisplayname=" -  " data-leaduserid="" data-userstatusupdateddate="" data-userstatusupdatedtime="" data-userstatusupdatedtimezone="" data-userstatusupdated="" data-userhours="" data-userdisplayname=" -  " data-useruserid="">
                        <div style="width: 55%; float: left;">
                            <input type="checkbox" data-taskid="765" onchange="openSeqApprovalPopup(this)" id="chkngUserNested765" ng-checked="false" ng-disabled="false" class="fz fz-user" title="User">
                            <input type="checkbox" data-taskid="765" onchange="openSeqApprovalPopup(this)" id="chkQANested765" class="fz fz-QA" title="QA">
                            <input type="checkbox" data-taskid="765" onchange="openSeqApprovalPopup(this)" id="chkAlphaUserNested765" class="fz fz-Alpha" title="AlphaUser">
                            <br>
                            <input type="checkbox" data-taskid="765" onchange="openSeqApprovalPopup(this)" id="chkBetaUserNested765" class="fz fz-Beta" title="BetaUser">
                            <input type="checkbox" data-taskid="765" onchange="openSeqApprovalPopup(this)" id="chkngITLeadNested765" ng-checked="false" ng-disabled="false" class="fz fz-techlead" title="IT Lead">
                            <input type="checkbox" data-taskid="765" onchange="openSeqApprovalPopup(this)" id="chkngAdminNested765" ng-checked="false" ng-disabled="false" class="fz fz-admin" title="Admin">
                        </div>
                        <div style="width: 43%; float: right;">
                            <input type="checkbox" data-taskid="765" onchange="openSeqApprovalPopup(this)" id="chkngITLeadMasterNested765" class="fz fz-techlead largecheckbox" title="IT Lead"><br>
                            <input type="checkbox" data-taskid="765" onchange="openSeqApprovalPopup(this)" id="chkngAdminMasterNested765" class="fz fz-admin largecheckbox" title="Admin">
                        </div>
                    </div>
                </div>
                <div class="div-table-col seq-notes-fixed-top sub-task" taskid="0" taskmultilevellistid="0">
                    <table class="notes-table" cellspacing="0" cellpadding="0">
                        <tbody>
                            <tr>
                                <td>&nbsp;</td>
                                <td>&nbsp;</td>
                            </tr>
                            <tr>
                                <td>&nbsp;</td>
                                <td>&nbsp;</td>
                            </tr>
                            <tr>
                                <td>&nbsp;</td>
                                <td>&nbsp;</td>
                            </tr>
                        </tbody>
                    </table>
                </div>
            </div>
            <!-- end ngRepeat: TechTask in correctDataforAngular(Task.SubSeqTasks) -->
            <div class="div-table-row ng-scope yellow" ng-repeat="TechTask in correctDataforAngular(Task.SubSeqTasks)" ng-class="{orange : TechTask.Status==='4', yellow: TechTask.Status==='3'}">
                <!-- Sequence# starts -->
                <div class="div-table-col seq-number-fixed">
                    <a style="text-decoration: none;" ng-show="!$first" ng-attr-data-taskid="{{TechTask.TaskId}}" href="javascript:void(0);" class="uplink" ng-class="{hide: TechTask.Sequence == null || 0}" ng-attr-data-taskseq="{{TechTask.SubSequence}}" ng-attr-data-taskdesg="{{TechTask.SequenceDesignationId}}" onclick="swapSubSequence(this,true)" data-taskid="766" data-taskseq="3" data-taskdesg="10">?</a><a style="text-decoration: none;" ng-class="{hide: TechTask.Sequence == null || 0}" ng-attr-data-taskid="{{TechTask.TaskId}}" ng-attr-data-taskseq="{{TechTask.SubSequence}}" class="downlink" ng-attr-data-taskdesg="{{TechTask.SequenceDesignationId}}" href="javascript:void(0);" ng-show="!$last" onclick="swapSubSequence(this,false)" data-taskid="766" data-taskseq="3" data-taskdesg="10">?</a>
                    <a ng-attr-id="autoClick{{Task.TaskId}}" href="javascript:void(0);" class="badge-hyperlink autoclickSeqEdit" ng-attr-data-taskid="{{TechTask.TaskId}}" ng-attr-data-seqdesgid="{{TechTask.SequenceDesignationId}}" id="autoClick657" data-taskid="766" data-seqdesgid="10"><span class="badge badge-error badge-xstext">
                        <label ng-attr-id="SeqLabel{{TechTask.TaskId}}" class="ng-binding" id="SeqLabel766">2 (III)-ITSN:SS</label></span></a>
                    <div class="handle-counter hide" ng-class="{hide: TechTask.TaskId != HighLightTaskId}" ng-attr-id="divSeq{{TechTask.TaskId}}" id="divSeq766">
                        <input type="text" class="textbox hide" ng-attr-data-original-val="{{ TechTask.Sequence == null &amp;&amp; 0 || TechTask.Sequence}}" ng-attr-data-original-desgid="{{TechTask.SequenceDesignationId}}" ng-attr-id="txtSeq{{TechTask.TaskId}}" value="2" data-original-val="2" data-original-desgid="10" id="txtSeq766">
                    </div>
                </div>
                <!-- Sequence# ends -->

                <!-- ID# and Designation starts -->
                <div class="div-table-col seq-taskid-fixed ng-binding">
                    <a ng-href="../Sr_App/TaskGenerator.aspx?TaskId=418&amp;hstid=766" oncontextmenu="openCopyBox(this);return false;" data-installid="ITJN029-IX-IX - d" parentdata-highlighter="418" data-highlighter="766" class="bluetext context-menu ng-binding" target="_blank" href="../Sr_App/TaskGenerator.aspx?TaskId=418&amp;hstid=766">ITJN029-IX-IX - d</a><br>
                    IT - Sr .Net Developer
                                        <div ng-attr-id="divSeqDesg{{TechTask.TaskId}}" ng-class="{hide: TechTask.TaskId != HighLightTaskId}" id="divSeqDesg766" class="hide">
                                            <select class="textbox hide ng-pristine ng-untouched ng-valid ng-empty" ng-attr-data-taskid="{{TechTask.TaskId}}" ng-options="item as item.Name for item in ParentTaskDesignations track by item.Id" ng-model="DesignationSelectModel[$index]" data-taskid="766">
                                                <option value="?" selected="selected"></option>
                                            </select>
                                        </div>
                </div>
                <!-- ID# and Designation ends -->

                <!-- Parent Task & SubTask Title starts -->
                <div class="div-table-col seq-tasktitle-fixed ng-binding">
                    Task Generator: http://web.jmgrovebuildingsupply.com/Sr_App/TaskGenerator.aspx
                                        <br>
                    Recover and start working on this task - 
                </div>
                <!-- Parent Task & SubTask Title ends -->

                <!-- Status & Assigned To starts -->
                <div class="div-table-col seq-taskstatus-fixed chosen-div">
                    <select id="drpStatusSubsequenceNested766" onchange="changeTaskStatusClosed(this);" data-highlighter="766">

                        <option ng-selected="false" value="4">InProgress</option>

                        <option ng-selected="true" style="color: lawngreen" value="3" selected="selected">Request-Assigned</option>
                        <option ng-selected="false" value="1">Open</option>



                        <option ng-selected="false" value="11">Test Commit</option>

                    </select>
                    <br>
                    <select disabled="" id="ddcbSeqAssignedIA766" style="width: 100%; display: none;" multiple="" ng-attr-data-assignedusers="{{TechTask.TaskAssignedUserIDs}}" data-chosen="1" data-placeholder="Select Users" onchange="EditSeqAssignedTaskUsers(this);" data-taskid="766" data-taskstatus="3" data-assignedusers="{&quot;Id&quot; : &quot;3697&quot;}">
                        <!-- ngRepeat: item in DesignationAssignUsers -->
                        <option ng-repeat="item in DesignationAssignUsers" value="3797" label="Jitendra J. Pancholi - ITSN-A0411" class="activeUser">Jitendra J. Pancholi - ITSN-A0411
                                                
                        </option>
                        <!-- end ngRepeat: item in DesignationAssignUsers -->
                        <option ng-repeat="item in DesignationAssignUsers" value="3697" label="Kapil K. Pancholi - ITSN-A0411" class="activeUser">Kapil K. Pancholi - ITSN-A0411
                                                
                        </option>
                        <!-- end ngRepeat: item in DesignationAssignUsers -->
                        <option ng-repeat="item in DesignationAssignUsers" value="3516" label="Shreyas H. Patel - ITSN-A0411" class="IOUser">Shreyas H. Patel - ITSN-A0411
                                                
                        </option>
                        <!-- end ngRepeat: item in DesignationAssignUsers -->
                        <option ng-repeat="item in DesignationAssignUsers" value="1096" label="Aavadesh  Patel - ITSN-A0411" class="IOUser">Aavadesh  Patel - ITSN-A0411
                                                
                        </option>
                        <!-- end ngRepeat: item in DesignationAssignUsers -->
                        <option ng-repeat="item in DesignationAssignUsers" value="894" label="Ali Shahbad - ITSN-A0411" class="IOUser">Ali Shahbad - ITSN-A0411
                                                
                        </option>
                        <!-- end ngRepeat: item in DesignationAssignUsers -->
                        <option ng-repeat="item in DesignationAssignUsers" value="1088" label="Amit Agarwal - ITSN-A0411" class="IOUser">Amit Agarwal - ITSN-A0411
                                                
                        </option>
                        <!-- end ngRepeat: item in DesignationAssignUsers -->
                        <option ng-repeat="item in DesignationAssignUsers" value="1092" label="Bhaskhar  D - ITSN-A0411" class="IOUser">Bhaskhar  D - ITSN-A0411
                                                
                        </option>
                        <!-- end ngRepeat: item in DesignationAssignUsers -->
                        <option ng-repeat="item in DesignationAssignUsers" value="1115" label="Bhavik J. vaishnani - ITSN-A0411" class="IOUser">Bhavik J. vaishnani - ITSN-A0411
                                                
                        </option>
                        <!-- end ngRepeat: item in DesignationAssignUsers -->
                        <option ng-repeat="item in DesignationAssignUsers" value="2648" label="Bismi T. Demo - ITSN-A0411" class="IOUser">Bismi T. Demo - ITSN-A0411
                                                
                        </option>
                        <!-- end ngRepeat: item in DesignationAssignUsers -->
                        <option ng-repeat="item in DesignationAssignUsers" value="997" label="Brahmeswar  . Gade - ITSN-A0411" class="IOUser">Brahmeswar  . Gade - ITSN-A0411
                                                
                        </option>
                        <!-- end ngRepeat: item in DesignationAssignUsers -->
                        <option ng-repeat="item in DesignationAssignUsers" value="3614" label="Charandeep S. Singh - ITSN-A0411" class="IOUser">Charandeep S. Singh - ITSN-A0411
                                                
                        </option>
                        <!-- end ngRepeat: item in DesignationAssignUsers -->
                        <option ng-repeat="item in DesignationAssignUsers" value="921" label="Faheem Ullah - ITSN-A0411" class="IOUser">Faheem Ullah - ITSN-A0411
                                                
                        </option>
                        <!-- end ngRepeat: item in DesignationAssignUsers -->
                        <option ng-repeat="item in DesignationAssignUsers" value="3714" label="Jigar B. Shah - ITSN-A0411" class="IOUser">Jigar B. Shah - ITSN-A0411
                                                
                        </option>
                        <!-- end ngRepeat: item in DesignationAssignUsers -->
                        <option ng-repeat="item in DesignationAssignUsers" value="1089" label="Liyo  Jose - ITSN-A0411" class="IOUser">Liyo  Jose - ITSN-A0411
                                                
                        </option>
                        <!-- end ngRepeat: item in DesignationAssignUsers -->
                        <option ng-repeat="item in DesignationAssignUsers" value="2909" label="Manisha Heman. Shinde - ITSN-A0411" class="IOUser">Manisha Heman. Shinde - ITSN-A0411
                                                
                        </option>
                        <!-- end ngRepeat: item in DesignationAssignUsers -->
                        <option ng-repeat="item in DesignationAssignUsers" value="2652" label="Mohd Mr. Rafi - ITSN-A0411" class="IOUser">Mohd Mr. Rafi - ITSN-A0411
                                                
                        </option>
                        <!-- end ngRepeat: item in DesignationAssignUsers -->
                        <option ng-repeat="item in DesignationAssignUsers" value="1179" label="Mudit Sharma - ITSN-A0411" class="IOUser">Mudit Sharma - ITSN-A0411
                                                
                        </option>
                        <!-- end ngRepeat: item in DesignationAssignUsers -->
                        <option ng-repeat="item in DesignationAssignUsers" value="2765" label="Nandkumar C. Chavan - ITSN-A0411" class="IOUser">Nandkumar C. Chavan - ITSN-A0411
                                                
                        </option>
                        <!-- end ngRepeat: item in DesignationAssignUsers -->
                        <option ng-repeat="item in DesignationAssignUsers" value="3724" label="Pawan k. tiwari - ITSN-A0411" class="IOUser">Pawan k. tiwari - ITSN-A0411
                                                
                        </option>
                        <!-- end ngRepeat: item in DesignationAssignUsers -->
                        <option ng-repeat="item in DesignationAssignUsers" value="1029" label="Ramya  Akunuri  - ITSN-A0411" class="IOUser">Ramya  Akunuri  - ITSN-A0411
                                                
                        </option>
                        <!-- end ngRepeat: item in DesignationAssignUsers -->
                        <option ng-repeat="item in DesignationAssignUsers" value="1184" label="satinder  hundal  - ITSN-A0411" class="IOUser">satinder  hundal  - ITSN-A0411
                                                
                        </option>
                        <!-- end ngRepeat: item in DesignationAssignUsers -->
                        <option ng-repeat="item in DesignationAssignUsers" value="1143" label="Shekhar Pawar - ITSN-A0411" class="IOUser">Shekhar Pawar - ITSN-A0411
                                                
                        </option>
                        <!-- end ngRepeat: item in DesignationAssignUsers -->
                        <option ng-repeat="item in DesignationAssignUsers" value="835" label="Shilpa Ms. Gupta - ITSN-A0411" class="IOUser">Shilpa Ms. Gupta - ITSN-A0411
                                                
                        </option>
                        <!-- end ngRepeat: item in DesignationAssignUsers -->
                        <option ng-repeat="item in DesignationAssignUsers" value="1095" label="Sridhar  D - ITSN-A0411" class="IOUser">Sridhar  D - ITSN-A0411
                                                
                        </option>
                        <!-- end ngRepeat: item in DesignationAssignUsers -->
                        <option ng-repeat="item in DesignationAssignUsers" value="1086" label="Vinod Pandya - ITSN-A0411" class="IOUser">Vinod Pandya - ITSN-A0411
                                                
                        </option>
                        <!-- end ngRepeat: item in DesignationAssignUsers -->
                        <option ng-repeat="item in DesignationAssignUsers" value="1109" label="Vivek Sharma - ITSN-A0411" class="IOUser">Vivek Sharma - ITSN-A0411
                                                
                        </option>
                        <!-- end ngRepeat: item in DesignationAssignUsers -->
                        <option ng-repeat="item in DesignationAssignUsers" value="2653" label="Zubair A. Khan - ITSN-A0411" class="IOUser">Zubair A. Khan - ITSN-A0411
                                                
                        </option>
                        <!-- end ngRepeat: item in DesignationAssignUsers -->
                    </select><div class="chosen-container chosen-container-multi chosen-disabled" style="width: 0px;" title="" id="ddcbSeqAssignedIA766_chosen">
                        <ul class="chosen-choices">
                            <li class="search-choice"><span>Kapil K. Pancholi - ITSN-A0411
                                                
                            </span><a class="search-choice-close" data-option-array-index="1"></a></li>
                            <li class="search-field">
                                <input type="text" value="Select Users" class="" autocomplete="off" style="width: 25px;" disabled=""></li>
                        </ul>
                        <div class="chosen-drop">
                            <ul class="chosen-results"></ul>
                        </div>
                    </div>
                    <div class="chosen-container chosen-container-multi chosen-disabled" style="width: 0px;" title="" id="ddcbSeqAssignedIA766_chosen">
                        <ul class="chosen-choices">
                            <li class="search-choice"><span>Kapil K. Pancholi - ITSN-A0411
                                                
                            </span><a class="search-choice-close" data-option-array-index="1"></a></li>
                            <li class="search-field">
                                <input type="text" value="Select Users" class="" autocomplete="off" style="width: 25px;" disabled=""></li>
                        </ul>
                        <div class="chosen-drop">
                            <ul class="chosen-results"></ul>
                        </div>
                    </div>

                </div>
                <!-- Status & Assigned To ends -->
                <div class="div-table-col seq-taskduedate-fixed">
                    <div class="seqapprovalBoxes" id="SeqApprovalDiv766" data-adminstatusupdateddate="" data-adminstatusupdatedtime="" data-adminstatusupdatedtimezone="" data-adminstatusupdated="" data-admindisplayname=" -  " data-adminstatususerid="" data-leadstatusupdateddate="" data-leadstatusupdatedtime="" data-leadstatusupdatedtimezone="" data-leadstatusupdated="" data-leadhours="" data-leaddisplayname=" -  " data-leaduserid="" data-userstatusupdateddate="1/1/2018" data-userstatusupdatedtime="11:34 AM" data-userstatusupdatedtimezone="(EST)" data-userstatusupdated="16" data-userhours="16" data-userdisplayname="3697 - Kapil Pancholi" data-useruserid="3697">
                        <div style="width: 55%; float: left;">
                            <input type="checkbox" data-taskid="766" onchange="openSeqApprovalPopup(this)" id="chkngUserNested766" ng-checked="true" ng-disabled="true" class="fz fz-user" title="User" disabled="disabled" checked="checked">
                            <input type="checkbox" data-taskid="766" onchange="openSeqApprovalPopup(this)" id="chkQANested766" class="fz fz-QA" title="QA">
                            <input type="checkbox" data-taskid="766" onchange="openSeqApprovalPopup(this)" id="chkAlphaUserNested766" class="fz fz-Alpha" title="AlphaUser">
                            <br>
                            <input type="checkbox" data-taskid="766" onchange="openSeqApprovalPopup(this)" id="chkBetaUserNested766" class="fz fz-Beta" title="BetaUser">
                            <input type="checkbox" data-taskid="766" onchange="openSeqApprovalPopup(this)" id="chkngITLeadNested766" ng-checked="false" ng-disabled="false" class="fz fz-techlead" title="IT Lead">
                            <input type="checkbox" data-taskid="766" onchange="openSeqApprovalPopup(this)" id="chkngAdminNested766" ng-checked="false" ng-disabled="false" class="fz fz-admin" title="Admin">
                        </div>
                        <div style="width: 43%; float: right;">
                            <input type="checkbox" data-taskid="766" onchange="openSeqApprovalPopup(this)" id="chkngITLeadMasterNested766" class="fz fz-techlead largecheckbox" title="IT Lead"><br>
                            <input type="checkbox" data-taskid="766" onchange="openSeqApprovalPopup(this)" id="chkngAdminMasterNested766" class="fz fz-admin largecheckbox" title="Admin">
                        </div>
                    </div>
                </div>
                <div class="div-table-col seq-notes-fixed-top sub-task" taskid="0" taskmultilevellistid="0">
                    <table class="notes-table" cellspacing="0" cellpadding="0">
                        <tbody>
                            <tr>
                                <td>&nbsp;</td>
                                <td>&nbsp;</td>
                            </tr>
                            <tr>
                                <td>&nbsp;</td>
                                <td>&nbsp;</td>
                            </tr>
                            <tr>
                                <td>&nbsp;</td>
                                <td>&nbsp;</td>
                            </tr>
                        </tbody>
                    </table>
                </div>
            </div>
            <!-- end ngRepeat: TechTask in correctDataforAngular(Task.SubSeqTasks) -->
            <div class="div-table-row ng-scope yellow" ng-repeat="TechTask in correctDataforAngular(Task.SubSeqTasks)" ng-class="{orange : TechTask.Status==='4', yellow: TechTask.Status==='3'}">
                <!-- Sequence# starts -->
                <div class="div-table-col seq-number-fixed">
                    <a style="text-decoration: none;" ng-show="!$first" ng-attr-data-taskid="{{TechTask.TaskId}}" href="javascript:void(0);" class="uplink" ng-class="{hide: TechTask.Sequence == null || 0}" ng-attr-data-taskseq="{{TechTask.SubSequence}}" ng-attr-data-taskdesg="{{TechTask.SequenceDesignationId}}" onclick="swapSubSequence(this,true)" data-taskid="767" data-taskseq="5" data-taskdesg="10">?</a><a style="text-decoration: none;" ng-class="{hide: TechTask.Sequence == null || 0}" ng-attr-data-taskid="{{TechTask.TaskId}}" ng-attr-data-taskseq="{{TechTask.SubSequence}}" class="downlink" ng-attr-data-taskdesg="{{TechTask.SequenceDesignationId}}" href="javascript:void(0);" ng-show="!$last" onclick="swapSubSequence(this,false)" data-taskid="767" data-taskseq="5" data-taskdesg="10">?</a>
                    <a ng-attr-id="autoClick{{Task.TaskId}}" href="javascript:void(0);" class="badge-hyperlink autoclickSeqEdit" ng-attr-data-taskid="{{TechTask.TaskId}}" ng-attr-data-seqdesgid="{{TechTask.SequenceDesignationId}}" id="autoClick657" data-taskid="767" data-seqdesgid="10"><span class="badge badge-error badge-xstext">
                        <label ng-attr-id="SeqLabel{{TechTask.TaskId}}" class="ng-binding" id="SeqLabel767">2 (V)-ITSN:SS</label></span></a>
                    <div class="handle-counter hide" ng-class="{hide: TechTask.TaskId != HighLightTaskId}" ng-attr-id="divSeq{{TechTask.TaskId}}" id="divSeq767">
                        <input type="text" class="textbox hide" ng-attr-data-original-val="{{ TechTask.Sequence == null &amp;&amp; 0 || TechTask.Sequence}}" ng-attr-data-original-desgid="{{TechTask.SequenceDesignationId}}" ng-attr-id="txtSeq{{TechTask.TaskId}}" value="2" data-original-val="2" data-original-desgid="10" id="txtSeq767">
                    </div>
                </div>
                <!-- Sequence# ends -->

                <!-- ID# and Designation starts -->
                <div class="div-table-col seq-taskid-fixed ng-binding">
                    <a ng-href="../Sr_App/TaskGenerator.aspx?TaskId=418&amp;hstid=767" oncontextmenu="openCopyBox(this);return false;" data-installid="ITJN029-IX-IX - e" parentdata-highlighter="418" data-highlighter="767" class="bluetext context-menu ng-binding" target="_blank" href="../Sr_App/TaskGenerator.aspx?TaskId=418&amp;hstid=767">ITJN029-IX-IX - e</a><br>
                    IT - Sr .Net Developer
                                        <div ng-attr-id="divSeqDesg{{TechTask.TaskId}}" ng-class="{hide: TechTask.TaskId != HighLightTaskId}" id="divSeqDesg767" class="hide">
                                            <select class="textbox hide ng-pristine ng-untouched ng-valid ng-empty" ng-attr-data-taskid="{{TechTask.TaskId}}" ng-options="item as item.Name for item in ParentTaskDesignations track by item.Id" ng-model="DesignationSelectModel[$index]" data-taskid="767">
                                                <option value="?" selected="selected"></option>
                                            </select>
                                        </div>
                </div>
                <!-- ID# and Designation ends -->

                <!-- Parent Task & SubTask Title starts -->
                <div class="div-table-col seq-tasktitle-fixed ng-binding">
                    Task Generator: http://web.jmgrovebuildingsupply.com/Sr_App/TaskGenerator.aspx
                                        <br>
                    Recover and start working on this task - Task Generator Status &amp; Filtering
                </div>
                <!-- Parent Task & SubTask Title ends -->

                <!-- Status & Assigned To starts -->
                <div class="div-table-col seq-taskstatus-fixed chosen-div">
                    <select id="drpStatusSubsequenceNested767" onchange="changeTaskStatusClosed(this);" data-highlighter="767">

                        <option ng-selected="false" value="4">InProgress</option>

                        <option ng-selected="true" style="color: lawngreen" value="3" selected="selected">Request-Assigned</option>
                        <option ng-selected="false" value="1">Open</option>



                        <option ng-selected="false" value="11">Test Commit</option>

                    </select>
                    <br>
                    <select disabled="" id="ddcbSeqAssignedIA767" style="width: 100%; display: none;" multiple="" ng-attr-data-assignedusers="{{TechTask.TaskAssignedUserIDs}}" data-chosen="1" data-placeholder="Select Users" onchange="EditSeqAssignedTaskUsers(this);" data-taskid="767" data-taskstatus="3" data-assignedusers="{&quot;Id&quot; : &quot;3697&quot;}">
                        <!-- ngRepeat: item in DesignationAssignUsers -->
                        <option ng-repeat="item in DesignationAssignUsers" value="3797" label="Jitendra J. Pancholi - ITSN-A0411" class="activeUser">Jitendra J. Pancholi - ITSN-A0411
                                                
                        </option>
                        <!-- end ngRepeat: item in DesignationAssignUsers -->
                        <option ng-repeat="item in DesignationAssignUsers" value="3697" label="Kapil K. Pancholi - ITSN-A0411" class="activeUser">Kapil K. Pancholi - ITSN-A0411
                                                
                        </option>
                        <!-- end ngRepeat: item in DesignationAssignUsers -->
                        <option ng-repeat="item in DesignationAssignUsers" value="3516" label="Shreyas H. Patel - ITSN-A0411" class="IOUser">Shreyas H. Patel - ITSN-A0411
                                                
                        </option>
                        <!-- end ngRepeat: item in DesignationAssignUsers -->
                        <option ng-repeat="item in DesignationAssignUsers" value="1096" label="Aavadesh  Patel - ITSN-A0411" class="IOUser">Aavadesh  Patel - ITSN-A0411
                                                
                        </option>
                        <!-- end ngRepeat: item in DesignationAssignUsers -->
                        <option ng-repeat="item in DesignationAssignUsers" value="894" label="Ali Shahbad - ITSN-A0411" class="IOUser">Ali Shahbad - ITSN-A0411
                                                
                        </option>
                        <!-- end ngRepeat: item in DesignationAssignUsers -->
                        <option ng-repeat="item in DesignationAssignUsers" value="1088" label="Amit Agarwal - ITSN-A0411" class="IOUser">Amit Agarwal - ITSN-A0411
                                                
                        </option>
                        <!-- end ngRepeat: item in DesignationAssignUsers -->
                        <option ng-repeat="item in DesignationAssignUsers" value="1092" label="Bhaskhar  D - ITSN-A0411" class="IOUser">Bhaskhar  D - ITSN-A0411
                                                
                        </option>
                        <!-- end ngRepeat: item in DesignationAssignUsers -->
                        <option ng-repeat="item in DesignationAssignUsers" value="1115" label="Bhavik J. vaishnani - ITSN-A0411" class="IOUser">Bhavik J. vaishnani - ITSN-A0411
                                                
                        </option>
                        <!-- end ngRepeat: item in DesignationAssignUsers -->
                        <option ng-repeat="item in DesignationAssignUsers" value="2648" label="Bismi T. Demo - ITSN-A0411" class="IOUser">Bismi T. Demo - ITSN-A0411
                                                
                        </option>
                        <!-- end ngRepeat: item in DesignationAssignUsers -->
                        <option ng-repeat="item in DesignationAssignUsers" value="997" label="Brahmeswar  . Gade - ITSN-A0411" class="IOUser">Brahmeswar  . Gade - ITSN-A0411
                                                
                        </option>
                        <!-- end ngRepeat: item in DesignationAssignUsers -->
                        <option ng-repeat="item in DesignationAssignUsers" value="3614" label="Charandeep S. Singh - ITSN-A0411" class="IOUser">Charandeep S. Singh - ITSN-A0411
                                                
                        </option>
                        <!-- end ngRepeat: item in DesignationAssignUsers -->
                        <option ng-repeat="item in DesignationAssignUsers" value="921" label="Faheem Ullah - ITSN-A0411" class="IOUser">Faheem Ullah - ITSN-A0411
                                                
                        </option>
                        <!-- end ngRepeat: item in DesignationAssignUsers -->
                        <option ng-repeat="item in DesignationAssignUsers" value="3714" label="Jigar B. Shah - ITSN-A0411" class="IOUser">Jigar B. Shah - ITSN-A0411
                                                
                        </option>
                        <!-- end ngRepeat: item in DesignationAssignUsers -->
                        <option ng-repeat="item in DesignationAssignUsers" value="1089" label="Liyo  Jose - ITSN-A0411" class="IOUser">Liyo  Jose - ITSN-A0411
                                                
                        </option>
                        <!-- end ngRepeat: item in DesignationAssignUsers -->
                        <option ng-repeat="item in DesignationAssignUsers" value="2909" label="Manisha Heman. Shinde - ITSN-A0411" class="IOUser">Manisha Heman. Shinde - ITSN-A0411
                                                
                        </option>
                        <!-- end ngRepeat: item in DesignationAssignUsers -->
                        <option ng-repeat="item in DesignationAssignUsers" value="2652" label="Mohd Mr. Rafi - ITSN-A0411" class="IOUser">Mohd Mr. Rafi - ITSN-A0411
                                                
                        </option>
                        <!-- end ngRepeat: item in DesignationAssignUsers -->
                        <option ng-repeat="item in DesignationAssignUsers" value="1179" label="Mudit Sharma - ITSN-A0411" class="IOUser">Mudit Sharma - ITSN-A0411
                                                
                        </option>
                        <!-- end ngRepeat: item in DesignationAssignUsers -->
                        <option ng-repeat="item in DesignationAssignUsers" value="2765" label="Nandkumar C. Chavan - ITSN-A0411" class="IOUser">Nandkumar C. Chavan - ITSN-A0411
                                                
                        </option>
                        <!-- end ngRepeat: item in DesignationAssignUsers -->
                        <option ng-repeat="item in DesignationAssignUsers" value="3724" label="Pawan k. tiwari - ITSN-A0411" class="IOUser">Pawan k. tiwari - ITSN-A0411
                                                
                        </option>
                        <!-- end ngRepeat: item in DesignationAssignUsers -->
                        <option ng-repeat="item in DesignationAssignUsers" value="1029" label="Ramya  Akunuri  - ITSN-A0411" class="IOUser">Ramya  Akunuri  - ITSN-A0411
                                                
                        </option>
                        <!-- end ngRepeat: item in DesignationAssignUsers -->
                        <option ng-repeat="item in DesignationAssignUsers" value="1184" label="satinder  hundal  - ITSN-A0411" class="IOUser">satinder  hundal  - ITSN-A0411
                                                
                        </option>
                        <!-- end ngRepeat: item in DesignationAssignUsers -->
                        <option ng-repeat="item in DesignationAssignUsers" value="1143" label="Shekhar Pawar - ITSN-A0411" class="IOUser">Shekhar Pawar - ITSN-A0411
                                                
                        </option>
                        <!-- end ngRepeat: item in DesignationAssignUsers -->
                        <option ng-repeat="item in DesignationAssignUsers" value="835" label="Shilpa Ms. Gupta - ITSN-A0411" class="IOUser">Shilpa Ms. Gupta - ITSN-A0411
                                                
                        </option>
                        <!-- end ngRepeat: item in DesignationAssignUsers -->
                        <option ng-repeat="item in DesignationAssignUsers" value="1095" label="Sridhar  D - ITSN-A0411" class="IOUser">Sridhar  D - ITSN-A0411
                                                
                        </option>
                        <!-- end ngRepeat: item in DesignationAssignUsers -->
                        <option ng-repeat="item in DesignationAssignUsers" value="1086" label="Vinod Pandya - ITSN-A0411" class="IOUser">Vinod Pandya - ITSN-A0411
                                                
                        </option>
                        <!-- end ngRepeat: item in DesignationAssignUsers -->
                        <option ng-repeat="item in DesignationAssignUsers" value="1109" label="Vivek Sharma - ITSN-A0411" class="IOUser">Vivek Sharma - ITSN-A0411
                                                
                        </option>
                        <!-- end ngRepeat: item in DesignationAssignUsers -->
                        <option ng-repeat="item in DesignationAssignUsers" value="2653" label="Zubair A. Khan - ITSN-A0411" class="IOUser">Zubair A. Khan - ITSN-A0411
                                                
                        </option>
                        <!-- end ngRepeat: item in DesignationAssignUsers -->
                    </select><div class="chosen-container chosen-container-multi chosen-disabled" style="width: 0px;" title="" id="ddcbSeqAssignedIA767_chosen">
                        <ul class="chosen-choices">
                            <li class="search-choice"><span>Kapil K. Pancholi - ITSN-A0411
                                                
                            </span><a class="search-choice-close" data-option-array-index="1"></a></li>
                            <li class="search-field">
                                <input type="text" value="Select Users" class="" autocomplete="off" style="width: 25px;" disabled=""></li>
                        </ul>
                        <div class="chosen-drop">
                            <ul class="chosen-results"></ul>
                        </div>
                    </div>
                    <div class="chosen-container chosen-container-multi chosen-disabled" style="width: 0px;" title="" id="ddcbSeqAssignedIA767_chosen">
                        <ul class="chosen-choices">
                            <li class="search-choice"><span>Kapil K. Pancholi - ITSN-A0411
                                                
                            </span><a class="search-choice-close" data-option-array-index="1"></a></li>
                            <li class="search-field">
                                <input type="text" value="Select Users" class="" autocomplete="off" style="width: 25px;" disabled=""></li>
                        </ul>
                        <div class="chosen-drop">
                            <ul class="chosen-results"></ul>
                        </div>
                    </div>

                </div>
                <!-- Status & Assigned To ends -->
                <div class="div-table-col seq-taskduedate-fixed">
                    <div class="seqapprovalBoxes" id="SeqApprovalDiv767" data-adminstatusupdateddate="" data-adminstatusupdatedtime="" data-adminstatusupdatedtimezone="" data-adminstatusupdated="" data-admindisplayname=" -  " data-adminstatususerid="" data-leadstatusupdateddate="" data-leadstatusupdatedtime="" data-leadstatusupdatedtimezone="" data-leadstatusupdated="" data-leadhours="" data-leaddisplayname=" -  " data-leaduserid="" data-userstatusupdateddate="" data-userstatusupdatedtime="" data-userstatusupdatedtimezone="" data-userstatusupdated="" data-userhours="" data-userdisplayname=" -  " data-useruserid="">
                        <div style="width: 55%; float: left;">
                            <input type="checkbox" data-taskid="767" onchange="openSeqApprovalPopup(this)" id="chkngUserNested767" ng-checked="false" ng-disabled="false" class="fz fz-user" title="User">
                            <input type="checkbox" data-taskid="767" onchange="openSeqApprovalPopup(this)" id="chkQANested767" class="fz fz-QA" title="QA">
                            <input type="checkbox" data-taskid="767" onchange="openSeqApprovalPopup(this)" id="chkAlphaUserNested767" class="fz fz-Alpha" title="AlphaUser">
                            <br>
                            <input type="checkbox" data-taskid="767" onchange="openSeqApprovalPopup(this)" id="chkBetaUserNested767" class="fz fz-Beta" title="BetaUser">
                            <input type="checkbox" data-taskid="767" onchange="openSeqApprovalPopup(this)" id="chkngITLeadNested767" ng-checked="false" ng-disabled="false" class="fz fz-techlead" title="IT Lead">
                            <input type="checkbox" data-taskid="767" onchange="openSeqApprovalPopup(this)" id="chkngAdminNested767" ng-checked="false" ng-disabled="false" class="fz fz-admin" title="Admin">
                        </div>
                        <div style="width: 43%; float: right;">
                            <input type="checkbox" data-taskid="767" onchange="openSeqApprovalPopup(this)" id="chkngITLeadMasterNested767" class="fz fz-techlead largecheckbox" title="IT Lead"><br>
                            <input type="checkbox" data-taskid="767" onchange="openSeqApprovalPopup(this)" id="chkngAdminMasterNested767" class="fz fz-admin largecheckbox" title="Admin">
                        </div>
                    </div>
                </div>
                <div class="div-table-col seq-notes-fixed-top sub-task" taskid="0" taskmultilevellistid="0">
                    <table class="notes-table" cellspacing="0" cellpadding="0">
                        <tbody>
                            <tr>
                                <td>&nbsp;</td>
                                <td>&nbsp;</td>
                            </tr>
                            <tr>
                                <td>&nbsp;</td>
                                <td>&nbsp;</td>
                            </tr>
                            <tr>
                                <td>&nbsp;</td>
                                <td>&nbsp;</td>
                            </tr>
                        </tbody>
                    </table>
                </div>
            </div>
            <!-- end ngRepeat: TechTask in correctDataforAngular(Task.SubSeqTasks) -->
            <div class="div-table-row ng-scope yellow" ng-repeat="TechTask in correctDataforAngular(Task.SubSeqTasks)" ng-class="{orange : TechTask.Status==='4', yellow: TechTask.Status==='3'}">
                <!-- Sequence# starts -->
                <div class="div-table-col seq-number-fixed">
                    <a style="text-decoration: none;" ng-show="!$first" ng-attr-data-taskid="{{TechTask.TaskId}}" href="javascript:void(0);" class="uplink" ng-class="{hide: TechTask.Sequence == null || 0}" ng-attr-data-taskseq="{{TechTask.SubSequence}}" ng-attr-data-taskdesg="{{TechTask.SequenceDesignationId}}" onclick="swapSubSequence(this,true)" data-taskid="10763" data-taskseq="1" data-taskdesg="10">?</a><a style="text-decoration: none;" ng-class="{hide: TechTask.Sequence == null || 0}" ng-attr-data-taskid="{{TechTask.TaskId}}" ng-attr-data-taskseq="{{TechTask.SubSequence}}" class="downlink ng-hide" ng-attr-data-taskdesg="{{TechTask.SequenceDesignationId}}" href="javascript:void(0);" ng-show="!$last" onclick="swapSubSequence(this,false)" data-taskid="10763" data-taskseq="1" data-taskdesg="10">?</a>
                    <a ng-attr-id="autoClick{{Task.TaskId}}" href="javascript:void(0);" class="badge-hyperlink autoclickSeqEdit" ng-attr-data-taskid="{{TechTask.TaskId}}" ng-attr-data-seqdesgid="{{TechTask.SequenceDesignationId}}" id="autoClick657" data-taskid="10763" data-seqdesgid="10"><span class="badge badge-error badge-xstext">
                        <label ng-attr-id="SeqLabel{{TechTask.TaskId}}" class="ng-binding" id="SeqLabel10763">2 (I)-ITSN:SS</label></span></a>
                    <div class="handle-counter hide" ng-class="{hide: TechTask.TaskId != HighLightTaskId}" ng-attr-id="divSeq{{TechTask.TaskId}}" id="divSeq10763">
                        <input type="text" class="textbox hide" ng-attr-data-original-val="{{ TechTask.Sequence == null &amp;&amp; 0 || TechTask.Sequence}}" ng-attr-data-original-desgid="{{TechTask.SequenceDesignationId}}" ng-attr-id="txtSeq{{TechTask.TaskId}}" value="2" data-original-val="2" data-original-desgid="10" id="txtSeq10763">
                    </div>
                </div>
                <!-- Sequence# ends -->

                <!-- ID# and Designation starts -->
                <div class="div-table-col seq-taskid-fixed ng-binding">
                    <a ng-href="../Sr_App/TaskGenerator.aspx?TaskId=418&amp;hstid=10763" oncontextmenu="openCopyBox(this);return false;" data-installid="ITJN029-IX-IX - a" parentdata-highlighter="418" data-highlighter="10763" class="bluetext context-menu ng-binding" target="_blank" href="../Sr_App/TaskGenerator.aspx?TaskId=418&amp;hstid=10763">ITJN029-IX-IX - a</a><br>
                    IT - Sr .Net Developer
                                        <div ng-attr-id="divSeqDesg{{TechTask.TaskId}}" ng-class="{hide: TechTask.TaskId != HighLightTaskId}" id="divSeqDesg10763" class="hide">
                                            <select class="textbox hide ng-pristine ng-untouched ng-valid ng-empty" ng-attr-data-taskid="{{TechTask.TaskId}}" ng-options="item as item.Name for item in ParentTaskDesignations track by item.Id" ng-model="DesignationSelectModel[$index]" data-taskid="10763">
                                                <option value="?" selected="selected"></option>
                                            </select>
                                        </div>
                </div>
                <!-- ID# and Designation ends -->

                <!-- Parent Task & SubTask Title starts -->
                <div class="div-table-col seq-tasktitle-fixed ng-binding">
                    Task Generator: http://web.jmgrovebuildingsupply.com/Sr_App/TaskGenerator.aspx
                                        <br>
                    Recover and start working on this task
                </div>
                <!-- Parent Task & SubTask Title ends -->

                <!-- Status & Assigned To starts -->
                <div class="div-table-col seq-taskstatus-fixed chosen-div">
                    <select id="drpStatusSubsequenceNested10763" onchange="changeTaskStatusClosed(this);" data-highlighter="10763">

                        <option ng-selected="false" value="4">InProgress</option>

                        <option ng-selected="true" style="color: lawngreen" value="3" selected="selected">Request-Assigned</option>
                        <option ng-selected="false" value="1">Open</option>



                        <option ng-selected="false" value="11">Test Commit</option>

                    </select>
                    <br>
                    <select disabled="" id="ddcbSeqAssignedIA10763" style="width: 100%; display: none;" multiple="" ng-attr-data-assignedusers="{{TechTask.TaskAssignedUserIDs}}" data-chosen="1" data-placeholder="Select Users" onchange="EditSeqAssignedTaskUsers(this);" data-taskid="10763" data-taskstatus="3" data-assignedusers="{&quot;Id&quot; : &quot;3697&quot;}">
                        <!-- ngRepeat: item in DesignationAssignUsers -->
                        <option ng-repeat="item in DesignationAssignUsers" value="3797" label="Jitendra J. Pancholi - ITSN-A0411" class="activeUser">Jitendra J. Pancholi - ITSN-A0411
                                                
                        </option>
                        <!-- end ngRepeat: item in DesignationAssignUsers -->
                        <option ng-repeat="item in DesignationAssignUsers" value="3697" label="Kapil K. Pancholi - ITSN-A0411" class="activeUser">Kapil K. Pancholi - ITSN-A0411
                                                
                        </option>
                        <!-- end ngRepeat: item in DesignationAssignUsers -->
                        <option ng-repeat="item in DesignationAssignUsers" value="3516" label="Shreyas H. Patel - ITSN-A0411" class="IOUser">Shreyas H. Patel - ITSN-A0411
                                                
                        </option>
                        <!-- end ngRepeat: item in DesignationAssignUsers -->
                        <option ng-repeat="item in DesignationAssignUsers" value="1096" label="Aavadesh  Patel - ITSN-A0411" class="IOUser">Aavadesh  Patel - ITSN-A0411
                                                
                        </option>
                        <!-- end ngRepeat: item in DesignationAssignUsers -->
                        <option ng-repeat="item in DesignationAssignUsers" value="894" label="Ali Shahbad - ITSN-A0411" class="IOUser">Ali Shahbad - ITSN-A0411
                                                
                        </option>
                        <!-- end ngRepeat: item in DesignationAssignUsers -->
                        <option ng-repeat="item in DesignationAssignUsers" value="1088" label="Amit Agarwal - ITSN-A0411" class="IOUser">Amit Agarwal - ITSN-A0411
                                                
                        </option>
                        <!-- end ngRepeat: item in DesignationAssignUsers -->
                        <option ng-repeat="item in DesignationAssignUsers" value="1092" label="Bhaskhar  D - ITSN-A0411" class="IOUser">Bhaskhar  D - ITSN-A0411
                                                
                        </option>
                        <!-- end ngRepeat: item in DesignationAssignUsers -->
                        <option ng-repeat="item in DesignationAssignUsers" value="1115" label="Bhavik J. vaishnani - ITSN-A0411" class="IOUser">Bhavik J. vaishnani - ITSN-A0411
                                                
                        </option>
                        <!-- end ngRepeat: item in DesignationAssignUsers -->
                        <option ng-repeat="item in DesignationAssignUsers" value="2648" label="Bismi T. Demo - ITSN-A0411" class="IOUser">Bismi T. Demo - ITSN-A0411
                                                
                        </option>
                        <!-- end ngRepeat: item in DesignationAssignUsers -->
                        <option ng-repeat="item in DesignationAssignUsers" value="997" label="Brahmeswar  . Gade - ITSN-A0411" class="IOUser">Brahmeswar  . Gade - ITSN-A0411
                                                
                        </option>
                        <!-- end ngRepeat: item in DesignationAssignUsers -->
                        <option ng-repeat="item in DesignationAssignUsers" value="3614" label="Charandeep S. Singh - ITSN-A0411" class="IOUser">Charandeep S. Singh - ITSN-A0411
                                                
                        </option>
                        <!-- end ngRepeat: item in DesignationAssignUsers -->
                        <option ng-repeat="item in DesignationAssignUsers" value="921" label="Faheem Ullah - ITSN-A0411" class="IOUser">Faheem Ullah - ITSN-A0411
                                                
                        </option>
                        <!-- end ngRepeat: item in DesignationAssignUsers -->
                        <option ng-repeat="item in DesignationAssignUsers" value="3714" label="Jigar B. Shah - ITSN-A0411" class="IOUser">Jigar B. Shah - ITSN-A0411
                                                
                        </option>
                        <!-- end ngRepeat: item in DesignationAssignUsers -->
                        <option ng-repeat="item in DesignationAssignUsers" value="1089" label="Liyo  Jose - ITSN-A0411" class="IOUser">Liyo  Jose - ITSN-A0411
                                                
                        </option>
                        <!-- end ngRepeat: item in DesignationAssignUsers -->
                        <option ng-repeat="item in DesignationAssignUsers" value="2909" label="Manisha Heman. Shinde - ITSN-A0411" class="IOUser">Manisha Heman. Shinde - ITSN-A0411
                                                
                        </option>
                        <!-- end ngRepeat: item in DesignationAssignUsers -->
                        <option ng-repeat="item in DesignationAssignUsers" value="2652" label="Mohd Mr. Rafi - ITSN-A0411" class="IOUser">Mohd Mr. Rafi - ITSN-A0411
                                                
                        </option>
                        <!-- end ngRepeat: item in DesignationAssignUsers -->
                        <option ng-repeat="item in DesignationAssignUsers" value="1179" label="Mudit Sharma - ITSN-A0411" class="IOUser">Mudit Sharma - ITSN-A0411
                                                
                        </option>
                        <!-- end ngRepeat: item in DesignationAssignUsers -->
                        <option ng-repeat="item in DesignationAssignUsers" value="2765" label="Nandkumar C. Chavan - ITSN-A0411" class="IOUser">Nandkumar C. Chavan - ITSN-A0411
                                                
                        </option>
                        <!-- end ngRepeat: item in DesignationAssignUsers -->
                        <option ng-repeat="item in DesignationAssignUsers" value="3724" label="Pawan k. tiwari - ITSN-A0411" class="IOUser">Pawan k. tiwari - ITSN-A0411
                                                
                        </option>
                        <!-- end ngRepeat: item in DesignationAssignUsers -->
                        <option ng-repeat="item in DesignationAssignUsers" value="1029" label="Ramya  Akunuri  - ITSN-A0411" class="IOUser">Ramya  Akunuri  - ITSN-A0411
                                                
                        </option>
                        <!-- end ngRepeat: item in DesignationAssignUsers -->
                        <option ng-repeat="item in DesignationAssignUsers" value="1184" label="satinder  hundal  - ITSN-A0411" class="IOUser">satinder  hundal  - ITSN-A0411
                                                
                        </option>
                        <!-- end ngRepeat: item in DesignationAssignUsers -->
                        <option ng-repeat="item in DesignationAssignUsers" value="1143" label="Shekhar Pawar - ITSN-A0411" class="IOUser">Shekhar Pawar - ITSN-A0411
                                                
                        </option>
                        <!-- end ngRepeat: item in DesignationAssignUsers -->
                        <option ng-repeat="item in DesignationAssignUsers" value="835" label="Shilpa Ms. Gupta - ITSN-A0411" class="IOUser">Shilpa Ms. Gupta - ITSN-A0411
                                                
                        </option>
                        <!-- end ngRepeat: item in DesignationAssignUsers -->
                        <option ng-repeat="item in DesignationAssignUsers" value="1095" label="Sridhar  D - ITSN-A0411" class="IOUser">Sridhar  D - ITSN-A0411
                                                
                        </option>
                        <!-- end ngRepeat: item in DesignationAssignUsers -->
                        <option ng-repeat="item in DesignationAssignUsers" value="1086" label="Vinod Pandya - ITSN-A0411" class="IOUser">Vinod Pandya - ITSN-A0411
                                                
                        </option>
                        <!-- end ngRepeat: item in DesignationAssignUsers -->
                        <option ng-repeat="item in DesignationAssignUsers" value="1109" label="Vivek Sharma - ITSN-A0411" class="IOUser">Vivek Sharma - ITSN-A0411
                                                
                        </option>
                        <!-- end ngRepeat: item in DesignationAssignUsers -->
                        <option ng-repeat="item in DesignationAssignUsers" value="2653" label="Zubair A. Khan - ITSN-A0411" class="IOUser">Zubair A. Khan - ITSN-A0411
                                                
                        </option>
                        <!-- end ngRepeat: item in DesignationAssignUsers -->
                    </select><div class="chosen-container chosen-container-multi chosen-disabled" style="width: 0px;" title="" id="ddcbSeqAssignedIA10763_chosen">
                        <ul class="chosen-choices">
                            <li class="search-choice"><span>Kapil K. Pancholi - ITSN-A0411
                                                
                            </span><a class="search-choice-close" data-option-array-index="1"></a></li>
                            <li class="search-field">
                                <input type="text" value="Select Users" class="" autocomplete="off" style="width: 25px;" disabled=""></li>
                        </ul>
                        <div class="chosen-drop">
                            <ul class="chosen-results"></ul>
                        </div>
                    </div>
                    <div class="chosen-container chosen-container-multi chosen-disabled" style="width: 0px;" title="" id="ddcbSeqAssignedIA10763_chosen">
                        <ul class="chosen-choices">
                            <li class="search-choice"><span>Kapil K. Pancholi - ITSN-A0411
                                                
                            </span><a class="search-choice-close" data-option-array-index="1"></a></li>
                            <li class="search-field">
                                <input type="text" value="Select Users" class="" autocomplete="off" style="width: 25px;" disabled=""></li>
                        </ul>
                        <div class="chosen-drop">
                            <ul class="chosen-results"></ul>
                        </div>
                    </div>

                </div>
                <!-- Status & Assigned To ends -->
                <div class="div-table-col seq-taskduedate-fixed">
                    <div class="seqapprovalBoxes" id="SeqApprovalDiv10763" data-adminstatusupdateddate="11/30/2017" data-adminstatusupdatedtime="5:58 PM" data-adminstatusupdatedtimezone="(EST)" data-adminstatusupdated="2017-11-30T12:28:01.257+00:00" data-admindisplayname="INS00092 - justin grove" data-adminstatususerid="780" data-leadstatusupdateddate="11/30/2017" data-leadstatusupdatedtime="5:55 PM" data-leadstatusupdatedtimezone="(EST)" data-leadstatusupdated="7" data-leadhours="7" data-leaddisplayname="901 - Yogesh Keraliya" data-leaduserid="901" data-userstatusupdateddate="" data-userstatusupdatedtime="" data-userstatusupdatedtimezone="" data-userstatusupdated="" data-userhours="" data-userdisplayname=" -  " data-useruserid="">
                        <div style="width: 55%; float: left;">
                            <input type="checkbox" data-taskid="10763" onchange="openSeqApprovalPopup(this)" id="chkngUserNested10763" ng-checked="false" ng-disabled="false" class="fz fz-user" title="User">
                            <input type="checkbox" data-taskid="10763" onchange="openSeqApprovalPopup(this)" id="chkQANested10763" class="fz fz-QA" title="QA">
                            <input type="checkbox" data-taskid="10763" onchange="openSeqApprovalPopup(this)" id="chkAlphaUserNested10763" class="fz fz-Alpha" title="AlphaUser">
                            <br>
                            <input type="checkbox" data-taskid="10763" onchange="openSeqApprovalPopup(this)" id="chkBetaUserNested10763" class="fz fz-Beta" title="BetaUser">
                            <input type="checkbox" data-taskid="10763" onchange="openSeqApprovalPopup(this)" id="chkngITLeadNested10763" ng-checked="true" ng-disabled="true" class="fz fz-techlead" title="IT Lead" disabled="disabled" checked="checked">
                            <input type="checkbox" data-taskid="10763" onchange="openSeqApprovalPopup(this)" id="chkngAdminNested10763" ng-checked="true" ng-disabled="true" class="fz fz-admin" title="Admin" disabled="disabled" checked="checked">
                        </div>
                        <div style="width: 43%; float: right;">
                            <input type="checkbox" data-taskid="10763" onchange="openSeqApprovalPopup(this)" id="chkngITLeadMasterNested10763" class="fz fz-techlead largecheckbox" title="IT Lead"><br>
                            <input type="checkbox" data-taskid="10763" onchange="openSeqApprovalPopup(this)" id="chkngAdminMasterNested10763" class="fz fz-admin largecheckbox" title="Admin">
                        </div>
                    </div>
                </div>
                <div class="div-table-col seq-notes-fixed-top sub-task" taskid="0" taskmultilevellistid="0">
                    <table class="notes-table" cellspacing="0" cellpadding="0">
                        <tbody>
                            <tr>
                                <td>&nbsp;</td>
                                <td>&nbsp;</td>
                            </tr>
                            <tr>
                                <td>&nbsp;</td>
                                <td>&nbsp;</td>
                            </tr>
                            <tr>
                                <td>&nbsp;</td>
                                <td>&nbsp;</td>
                            </tr>
                        </tbody>
                    </table>
                </div>
            </div>
            <!-- end ngRepeat: TechTask in correctDataforAngular(Task.SubSeqTasks) -->
            <!-- Body section ends -->

        </div>

        <!-- Nested row ends -->

    </div>
</div>--%>

<div id="divModal" title="Task : Title" style="background: #efeeee url(../img/form-bg.png) repeat-x top; display: none;"
    runat="server" visible="false">
    <hr />
    <asp:UpdatePanel ID="upnlTaskPopup" runat="server">
        <ContentTemplate>
            <asp:ImageButton ID="btnRemoveTask" runat="server" ImageUrl="~/img/search_btn.png" Style="display: none;" OnClick="btnRemoveTask_Click" />
            <asp:HiddenField ID="hdnDeleteTaskId" runat="server" />
            <table id="tblAdminTaskView" runat="server" class="tablealign" width="100%">
                <tr>
                    <td width="150">Designation <span style="color: red;">*</span>:</td>
                    <td>
                        <asp:UpdatePanel ID="upnlDesignation" runat="server" RenderMode="Inline">
                            <ContentTemplate>
                                <asp:DropDownCheckBoxes ID="ddlUserDesignation" runat="server" UseSelectAllNode="false" AutoPostBack="true" OnSelectedIndexChanged="ddlUserDesignation_SelectedIndexChanged">
                                    <Style SelectBoxWidth="195" DropDownBoxBoxWidth="120" DropDownBoxBoxHeight="150" />
                                    <Items>
                                        <asp:ListItem Text="Admin" Value="Admin"></asp:ListItem>
                                        <asp:ListItem Text="ITLead" Value="ITLead"></asp:ListItem>
                                        <asp:ListItem Text="Jr. Sales" Value="Jr. Sales"></asp:ListItem>
                                        <asp:ListItem Text="Jr Project Manager" Value="Jr Project Manager"></asp:ListItem>
                                        <asp:ListItem Text="Office Manager" Value="Office Manager"></asp:ListItem>
                                        <asp:ListItem Text="Recruiter" Value="Recruiter"></asp:ListItem>
                                        <asp:ListItem Text="Sales Manager" Value="Sales Manager"></asp:ListItem>
                                        <asp:ListItem Text="Sr. Sales" Value="Sr. Sales"></asp:ListItem>
                                        <asp:ListItem Text="IT - Network Admin" Value="ITNetworkAdmin"></asp:ListItem>
                                        <asp:ListItem Text="IT - Jr .Net Developer" Value="ITJr.NetDeveloper"></asp:ListItem>
                                        <asp:ListItem Text="IT - Sr .Net Developer" Value="ITSr.NetDeveloper"></asp:ListItem>
                                        <asp:ListItem Text="IT - Android Developer" Value="ITAndroidDeveloper"></asp:ListItem>
                                        <asp:ListItem Text="IT - PHP Developer" Value="ITPHPDeveloper"></asp:ListItem>
                                        <asp:ListItem Text="IT - SEO / BackLinking" Value="ITSEOBackLinking"></asp:ListItem>
                                        <asp:ListItem Text="Installer - Helper" Value="InstallerHelper"></asp:ListItem>
                                        <asp:ListItem Text="Installer - Journeyman" Value="InstallerJourneyman"></asp:ListItem>
                                        <asp:ListItem Text="Installer - Mechanic" Value="InstallerMechanic"></asp:ListItem>
                                        <asp:ListItem Text="Installer - Lead mechanic" Value="InstallerLeadMechanic"></asp:ListItem>
                                        <asp:ListItem Text="Installer - Foreman" Value="InstallerForeman"></asp:ListItem>
                                        <asp:ListItem Text="Commercial Only" Value="CommercialOnly"></asp:ListItem>
                                        <asp:ListItem Text="SubContractor" Value="SubContractor"></asp:ListItem>
                                    </Items>
                                </asp:DropDownCheckBoxes>
                                <asp:CustomValidator ID="cvDesignations" runat="server" ValidationGroup="Submit" ErrorMessage="Please Select Designation" Display="None" ClientValidationFunction="checkDesignations"></asp:CustomValidator>
                                <%--<asp:DropDownList ID="ddlUserDesignation" runat="server" CssClass="textbox" AutoPostBack="True" OnSelectedIndexChanged="txtDesignation_SelectedIndexChanged">
                                </asp:DropDownList>--%>
                            </ContentTemplate>
                        </asp:UpdatePanel>
                    </td>
                    <td>Assigned:</td>
                    <td>
                        <asp:UpdatePanel ID="upnlAssigned" runat="server" RenderMode="Inline">
                            <ContentTemplate>
                                <asp:DropDownCheckBoxes ID="ddcbAssigned" runat="server" UseSelectAllNode="false"
                                    AutoPostBack="true" OnSelectedIndexChanged="ddcbAssigned_SelectedIndexChanged">
                                    <Style SelectBoxWidth="195" DropDownBoxBoxWidth="120" DropDownBoxBoxHeight="150" />
                                    <Texts SelectBoxCaption="--Open--" />
                                </asp:DropDownCheckBoxes>
                            </ContentTemplate>
                        </asp:UpdatePanel>

                        <%--                       <asp:DropDownList ID="ddlAssigned" runat="server" CssClass="textbox" onchange="addRow(this)">
                        <asp:ListItem Text="Darmendra"></asp:ListItem>
                        <asp:ListItem Text="Shabir"></asp:ListItem>
                       </asp:DropDownList>--%>
                  
                    </td>
                </tr>
                <tr>
                    <td colspan="4" valign="top">
                        <table width="100%" cellspacing="0" cellpadding="0">
                            <tr>
                                <td width="40%" valign="top">Task Title <span style="color: red;">*</span>:<br />
                                    <asp:TextBox ID="txtTaskTitle" runat="server" Style="width: 90%" CssClass="textbox"></asp:TextBox>
                                    <%--<ajax:Editor ID="txtTaskTitle" Width="100%" Height="20px" runat="server" ActiveMode="Design" AutoFocus="true" />--%>
                                    <asp:RequiredFieldValidator ID="rfvTaskTitle" ValidationGroup="Submit"
                                        runat="server" ControlToValidate="txtTaskTitle" ForeColor="Red" ErrorMessage="Please Enter Task Title" Display="None">                                 
                                    </asp:RequiredFieldValidator>
                                    <asp:HiddenField ID="controlMode" runat="server" />
                                    <asp:HiddenField ID="hdnTaskId" runat="server" Value="0" />
                                </td>
                                <td valign="top">
                                    <asp:UpdatePanel ID="upWorkSpecifications" runat="server" UpdateMode="Conditional">
                                        <ContentTemplate>
                                            <asp:TabContainer ID="tcWork" runat="server" ActiveTabIndex="0" AutoPostBack="false" Width="460">
                                                <asp:TabPanel ID="tpWork_Files" runat="server" TabIndex="0" CssClass="task-history-tab">
                                                    <HeaderTemplate>Work Files</HeaderTemplate>
                                                    <ContentTemplate>
                                                        <table>
                                                            <tr>
                                                                <td>Attachment(s):<br>
                                                                    <table>
                                                                        <tr>
                                                                            <td>
                                                                                <asp:Repeater ID="rptWorkFiles" OnItemCommand="rptAttachment_ItemCommand" OnItemDataBound="rptAttachment_ItemDataBound" runat="server">
                                                                                    <ItemTemplate>
                                                                                        <small>
                                                                                            <asp:LinkButton ID="lbtnDownload" runat="server" ForeColor="Blue"
                                                                                                CommandName="DownloadFile" /><asp:Literal ID="ltrlSeprator" runat="server" Text=" ," /></small>
                                                                                    </ItemTemplate>
                                                                                </asp:Repeater>
                                                                            </td>
                                                                        </tr>
                                                                        <tr>
                                                                            <td>
                                                                                <input id="hdnWorkFiles" runat="server" type="hidden" />
                                                                                <div id="divWorkFile" class="drop-zone">
                                                                                    <div class="fallback">
                                                                                        <input name="WorkFile" type="file" multiple />
                                                                                        <input type="submit" value="UploadWorkFile" />
                                                                                    </div>
                                                                                </div>
                                                                                <div id="divWorkFilePreview" class="drop-zone-previews">
                                                                                </div>
                                                                            </td>
                                                                        </tr>
                                                                        <tr>
                                                                            <td>
                                                                                <div class="btn_sec">
                                                                                    <asp:Button ID="btnAddAttachment" runat="server" OnClick="btnAddAttachment_ClicK" Text="Save"
                                                                                        CssClass="ui-button" />
                                                                                </div>
                                                                            </td>
                                                                        </tr>
                                                                    </table>
                                                                </td>
                                                            </tr>
                                                        </table>
                                                    </ContentTemplate>
                                                </asp:TabPanel>
                                                <asp:TabPanel ID="tpWork_Specifications" runat="server" TabIndex="1" CssClass="task-history-tab">
                                                    <HeaderTemplate>Work Specifications</HeaderTemplate>
                                                    <ContentTemplate>
                                                    </ContentTemplate>
                                                </asp:TabPanel>
                                            </asp:TabContainer>
                                        </ContentTemplate>
                                    </asp:UpdatePanel>
                                </td>
                            </tr>
                        </table>
                    </td>
                </tr>
                <tr>
                    <td colspan="4">Task Description <span style="color: red;">*</span>:<br />
                        <asp:TextBox ID="txtDescription" TextMode="MultiLine" runat="server" CssClass="textbox" Width="100%" Rows="5"></asp:TextBox>
                        <%--<ajax:Editor ID="txtDescription" Width="100%" Height="100px" runat="server" ActiveMode="Design" AutoFocus="true" />--%>
                        <asp:RequiredFieldValidator ID="rfvDesc" ValidationGroup="Submit"
                            runat="server" ControlToValidate="txtDescription" ForeColor="Red" ErrorMessage="Please Enter Task Description" Display="None">                                 
                        </asp:RequiredFieldValidator>
                    </td>
                </tr>
                <tr id="trSubTaskList" runat="server">
                    <td colspan="4">
                        <fieldset class="tasklistfieldset">
                            <legend>Task List</legend>
                            <asp:UpdatePanel ID="upSubTasks" runat="server" UpdateMode="Conditional">
                                <ContentTemplate>
                                    <div id="divSubTaskGrid">
                                        <asp:GridView ID="gvSubTasks" runat="server" ShowHeaderWhenEmpty="true" EmptyDataRowStyle-HorizontalAlign="Center"
                                            HeaderStyle-BackColor="Black" HeaderStyle-ForeColor="White" BackColor="White" EmptyDataRowStyle-ForeColor="Black"
                                            EmptyDataText="No sub task available!" CssClass="table" Width="100%" CellSpacing="0" CellPadding="0"
                                            AutoGenerateColumns="False" OnRowDataBound="gvSubTasks_RowDataBound" GridLines="Vertical">
                                            <EmptyDataRowStyle ForeColor="White" HorizontalAlign="Center" />
                                            <HeaderStyle CssClass="trHeader " />
                                            <RowStyle CssClass="FirstRow" />
                                            <AlternatingRowStyle CssClass="AlternateRow " />
                                            <Columns>
                                                <asp:BoundField DataField="InstallId" HeaderText="List ID" HeaderStyle-Width="10%" HeaderStyle-HorizontalAlign="Center" ItemStyle-HorizontalAlign="Center" />
                                                <asp:TemplateField HeaderText="Task Description" HeaderStyle-HorizontalAlign="Left" ItemStyle-HorizontalAlign="Left">
                                                    <ItemTemplate>
                                                        <%# Eval("Description") %>
                                                    </ItemTemplate>
                                                </asp:TemplateField>
                                                <%--<asp:TemplateField HeaderText="Due Date" HeaderStyle-Width="11%" HeaderStyle-HorizontalAlign="Center" ItemStyle-HorizontalAlign="Center">
                                                    <ItemTemplate>
                                                        <%#  string.IsNullOrEmpty( Eval("DueDate").ToString() )?string.Empty: Convert.ToDateTime(Eval("DueDate")).ToShortDateString()%>
                                                    </ItemTemplate>
                                                </asp:TemplateField>
                                                <asp:TemplateField HeaderText="Hrs. Est" HeaderStyle-Width="13%" HeaderStyle-HorizontalAlign="Center" ItemStyle-HorizontalAlign="Center">
                                                    <ItemTemplate>
                                                        <%# Eval("Hours") %>
                                                    </ItemTemplate>
                                                    <HeaderStyle Width="5%" />
                                                </asp:TemplateField>
                                                <asp:TemplateField HeaderText="Note Ref:" HeaderStyle-Width="10%" HeaderStyle-HorizontalAlign="Center" ItemStyle-HorizontalAlign="Center">
                                                    <ItemTemplate>
                                                        Note Ref#
                                                    </ItemTemplate>
                                                </asp:TemplateField>--%>
                                                <asp:TemplateField HeaderText="Type" HeaderStyle-Width="15%" HeaderStyle-HorizontalAlign="Center" ItemStyle-HorizontalAlign="Center">
                                                    <ItemTemplate>
                                                        <%# String.IsNullOrEmpty(Eval("TaskType").ToString()) == true ? String.Empty : ddlTaskType.Items.FindByValue( Eval("TaskType").ToString()).Text %>
                                                    </ItemTemplate>
                                                </asp:TemplateField>
                                                <asp:TemplateField HeaderText="Status" HeaderStyle-Width="15%" HeaderStyle-HorizontalAlign="Center" ItemStyle-HorizontalAlign="Center">
                                                    <ItemTemplate>
                                                        <%# string.Concat(cmbStatus.Items.FindByValue( Eval("Status").ToString()).Text , ":" , Eval("FristName")).Trim().TrimEnd(':') %>
                                                    </ItemTemplate>
                                                </asp:TemplateField>
                                                <asp:TemplateField HeaderText="Attachments" HeaderStyle-Width="15%" HeaderStyle-HorizontalAlign="Center" ItemStyle-HorizontalAlign="Left">
                                                    <ItemTemplate>
                                                        <asp:Repeater ID="rptAttachment" OnItemCommand="rptAttachment_ItemCommand" OnItemDataBound="rptAttachment_ItemDataBound" runat="server">
                                                            <ItemTemplate>
                                                                <small>
                                                                    <asp:LinkButton ID="lbtnDownload" runat="server" ForeColor="Blue"
                                                                        CommandName="DownloadFile" /><asp:Literal ID="ltrlSeprator" runat="server" Text=" ," /></small>
                                                            </ItemTemplate>
                                                        </asp:Repeater>
                                                    </ItemTemplate>
                                                </asp:TemplateField>
                                            </Columns>
                                        </asp:GridView>
                                    </div>
                                </ContentTemplate>
                            </asp:UpdatePanel>
                            <br />
                            <asp:UpdatePanel ID="upAddSubTask" runat="server" UpdateMode="Conditional">
                                <ContentTemplate>
                                    <asp:LinkButton ID="lbtnAddNewSubTask" runat="server" Text="Add New Task" OnClick="lbtnAddNewSubTask_Click" />
                                    <br />
                                    <asp:ValidationSummary ID="vsSubTask" runat="server" ValidationGroup="vgSubTask" ShowSummary="False" ShowMessageBox="True" />
                                    <div id="divSubTask" runat="server" style="display: none;">
                                        <asp:HiddenField ID="hdnSubTaskId" runat="server" Value="0" />
                                        <table class="tablealign fullwidth">
                                            <tr>
                                                <td>ListID:
                                                   
                                                    <asp:TextBox ID="txtTaskListID" runat="server" />
                                                    &nbsp; <small><a href="javascript:void(0);" style="color: #06c;" onclick="copytoListID(this);">
                                                        <asp:Literal ID="listIDOpt" runat="server" />
                                                    </a></small></td>
                                                <td>Type:
                                                   
                                                    <asp:DropDownList ID="ddlTaskType" AutoPostBack="true" OnSelectedIndexChanged="ddlTaskType_SelectedIndexChanged" runat="server"></asp:DropDownList>
                                                </td>
                                            </tr>
                                            <tr style="display: none;">
                                                <td colspan="2">Title <span style="color: red;">*</span>:
                           
                                                    <br />
                                                    <asp:TextBox ID="txtSubTaskTitle" Text="N.A." runat="server" Width="98%" CssClass="textbox" />
                                                    <asp:RequiredFieldValidator ID="rfvSubTaskTitle" Visible="false" ValidationGroup="vgSubTask"
                                                        runat="server" ControlToValidate="txtSubTaskTitle" ForeColor="Red" ErrorMessage="Please Enter Task Title" Display="None" />
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
                                            <tr id="trDateHours" runat="server" visible="false">
                                                <td>Due Date:
                           
                                                    <asp:TextBox ID="txtSubTaskDueDate" runat="server" CssClass="textbox datepicker" />
                                                    <%--<asp:CalendarExtender ID="ceSubTaskDueDate" runat="server" TargetControlID="txtSubTaskDueDate" PopupPosition="TopRight" />--%>
                                                </td>
                                                <td>Hrs of Task:
                           
                                                    <asp:TextBox ID="txtSubTaskHours" runat="server" CssClass="textbox" />
                                                    <asp:RegularExpressionValidator ID="revSubTaskHours" runat="server" ControlToValidate="txtSubTaskHours" Display="None"
                                                        ErrorMessage="Please enter decimal numbers for hours of task." ValidationGroup="vgSubTask"
                                                        ValidationExpression="(\d+\.\d{1,2})?\d*" />
                                                </td>
                                            </tr>
                                            <tr>
                                                <td>Attachment(s):<br>
                                                    <input id="hdnAttachments" runat="server" type="hidden" />
                                                    <div id="divSubTaskDropzone1" class="drop-zone" style="overflow: auto; width: 415px;">
                                                        <div class="fallback">
                                                            <input name="file" type="file" multiple />
                                                            <input type="submit" value="Upload" />
                                                        </div>
                                                    </div>
                                                </td>
                                                <td>
                                                    <div id="divSubTaskDropzonePreview1" class="drop-zone-previews">
                                                    </div>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td colspan="2">
                                                    <div class="btn_sec">
                                                        <asp:Button ID="btnSaveSubTask" runat="server" Text="Save Sub Task" CssClass="ui-button" ValidationGroup="vgSubTask"
                                                            OnClick="btnSaveSubTask_Click" />
                                                    </div>
                                                </td>
                                            </tr>
                                        </table>
                                    </div>
                                </ContentTemplate>
                            </asp:UpdatePanel>
                        </fieldset>
                    </td>
                </tr>
                <tr>
                    <td>User Acceptance:</td>
                    <td>
                        <asp:DropDownList ID="ddlUserAcceptance" runat="server" CssClass="textbox">
                            <asp:ListItem Text="Accept" Value="1"></asp:ListItem>
                            <asp:ListItem Text="Reject" Value="0"></asp:ListItem>
                        </asp:DropDownList>
                    </td>
                    <td>Due Date:</td>
                    <td>
                        <asp:TextBox ID="txtDueDate" runat="server" CssClass="textbox datepicker" />
                        <%--<asp:CalendarExtender ID="CEDueDate" runat="server" TargetControlID="txtDueDate"></asp:CalendarExtender>--%>
                        <%--<asp:RequiredFieldValidator ID="RequiredFieldValidator3" ValidationGroup="Submit"
                            runat="server" ControlToValidate="txtDueDate" ForeColor="Red" ErrorMessage="Please Enter Due Date" Display="None">                                 
                        </asp:RequiredFieldValidator>--%>
                    </td>
                </tr>
                <tr>
                    <td>Hrs of Task:</td>
                    <td>
                        <asp:TextBox ID="txtHours" runat="server" CssClass="textbox" />
                        <asp:RegularExpressionValidator ID="revHours" runat="server" ControlToValidate="txtHours" Display="None"
                            ErrorMessage="Please enter decimal numbers for hours of task." ValidationGroup="Submit" ValidationExpression="(\d+\.\d{1,2})?\d*" />
                        <%--<asp:RequiredFieldValidator ID="RequiredFieldValidator4" ValidationGroup="Submit"
                            runat="server" ControlToValidate="txtHours" ForeColor="Red" ErrorMessage="Please Enter Hours Of Task" Display="None">                                 
                        </asp:RequiredFieldValidator>--%>
                    </td>
                    <td>Staus:</td>
                    <td>
                        <asp:DropDownList ID="cmbStatus" runat="server" CssClass="textbox">
                            <%--<asp:ListItem Text="Open" Value="1"></asp:ListItem>
                            <asp:ListItem Text="Assigned" Value="2"></asp:ListItem>
                            <asp:ListItem Text="In Progress" Value="3"></asp:ListItem>
                            <asp:ListItem Text="Pending" Value="4"></asp:ListItem>
                            <asp:ListItem Text="Re-Opened" Value="5"></asp:ListItem>
                            <asp:ListItem Text="Closed" Value="6"></asp:ListItem>--%>
                        </asp:DropDownList>
                    </td>
                </tr>
                <tr>
                    <td colspan="4">
                        <div class="btn_sec">
                            <asp:Button ID="btnSaveTask" runat="server" Text="Save Task" CssClass="ui-button" ValidationGroup="Submit" OnClick="btnSaveTask_Click" />
                        </div>
                    </td>
                </tr>
            </table>
            <!-- table for userview -->
            <table id="tblUserTaskView" class="tablealign" style="width: 100%;" runat="server">
                <tr>

                    <td><b>Designation:</b>
                        <asp:Literal ID="ltlTUDesig" runat="server"></asp:Literal>
                    </td>

                    <td><b>Status:</b>
                        <asp:DropDownList ID="ddlTUStatus" AutoPostBack="true" runat="server" CssClass="textbox">
                            <%--<asp:ListItem Text="Open" Value="1"></asp:ListItem>
                            <asp:ListItem Text="Assigned" Value="2"></asp:ListItem>
                            <asp:ListItem Text="In Progress" Value="3"></asp:ListItem>
                            <asp:ListItem Text="Pending" Value="4"></asp:ListItem>
                            <asp:ListItem Text="Re-Opened" Value="5"></asp:ListItem>
                            <asp:ListItem Text="Closed" Value="6"></asp:ListItem>--%>
                        </asp:DropDownList>
                    </td>
                </tr>
                <tr>
                    <td colspan="2"><b>Task Title:</b>
                        <asp:Literal ID="ltlTUTitle" runat="server"></asp:Literal>
                    </td>
                </tr>
                <tr>
                    <td colspan="2"><b>Task Description:</b>
                        <asp:TextBox ID="txtTUDesc" TextMode="MultiLine" ReadOnly="true" Style="width: 100%;" Rows="10" runat="server"></asp:TextBox>
                    </td>
                </tr>
                <tr>
                    <td><b>User Acceptance:</b>
                        <asp:DropDownList ID="ddlTUAcceptance" AutoPostBack="true" runat="server" CssClass="textbox">
                            <asp:ListItem Text="Accept" Value="1"></asp:ListItem>
                            <asp:ListItem Text="Reject" Value="0"></asp:ListItem>
                        </asp:DropDownList>
                    </td>
                    <td><b>Due Date:</b>
                        <asp:Literal ID="ltlTUDueDate" runat="server"></asp:Literal></td>
                </tr>
                <tr>
                    <td><b>Hrs of Task:</b>
                        <asp:Literal ID="ltlTUHrsTask" runat="server"></asp:Literal></td>
                    <td></td>
                </tr>
            </table>
            <hr />
            <br />
            <asp:ValidationSummary ID="ValidationSummary1" runat="server" ValidationGroup="Submit" ShowSummary="False" ShowMessageBox="True" />
            <asp:UpdatePanel ID="upTaskHistory" runat="server" UpdateMode="Conditional">
                <ContentTemplate>
                    <asp:TabContainer ID="tcTaskHistory" runat="server" ActiveTabIndex="0" AutoPostBack="false">
                        <asp:TabPanel ID="tpTaskHistory_Notes" runat="server" TabIndex="0" CssClass="task-history-tab">
                            <HeaderTemplate>Notes</HeaderTemplate>
                            <ContentTemplate>
                                <div class="grid">
                                    <asp:GridView ID="gdTaskUsers" runat="server" EmptyDataText="No task history available!" ShowHeaderWhenEmpty="true" AutoGenerateColumns="false" Width="100%" HeaderStyle-BackColor="Black" HeaderStyle-ForeColor="White" AllowSorting="false" BackColor="White" PageSize="3" GridLines="Horizontal" OnRowDataBound="gdTaskUsers_RowDataBound" OnRowCommand="gdTaskUsers_RowCommand">
                                        <%--<EmptyDataTemplate>
                    </EmptyDataTemplate>--%>
                                        <Columns>
                                            <asp:TemplateField ShowHeader="True" HeaderText="User" ControlStyle-ForeColor="White" HeaderStyle-Font-Size="Small"
                                                ItemStyle-HorizontalAlign="Left">
                                                <ItemTemplate>
                                                    <asp:Label ID="lbluser" runat="server" Text='<%#String.IsNullOrEmpty(Eval("FristName").ToString())== true ? Eval("UserFirstName").ToString() : Eval("FristName").ToString() %>'></asp:Label>
                                                </ItemTemplate>
                                                <ControlStyle ForeColor="Black" />
                                                <ControlStyle ForeColor="Black" />
                                                <HeaderStyle Font-Size="Small"></HeaderStyle>
                                                <ItemStyle HorizontalAlign="Left"></ItemStyle>
                                            </asp:TemplateField>
                                            <asp:TemplateField ShowHeader="True" HeaderText="Date & Time" ControlStyle-ForeColor="White" HeaderStyle-Font-Size="Small"
                                                ItemStyle-HorizontalAlign="Left">
                                                <ItemTemplate>
                                                    <asp:Label ID="lblupdateDate" runat="server" Text='<%#Eval("UpdatedOn")%>'></asp:Label>
                                                </ItemTemplate>
                                                <ControlStyle ForeColor="Black" />
                                                <ControlStyle ForeColor="Black" />
                                                <HeaderStyle Font-Size="Small"></HeaderStyle>
                                                <ItemStyle HorizontalAlign="Left"></ItemStyle>
                                            </asp:TemplateField>
                                            <asp:TemplateField ShowHeader="false" Visible="false" ControlStyle-ForeColor="White" HeaderStyle-Font-Size="Small"
                                                ItemStyle-HorizontalAlign="Left">
                                                <ItemTemplate>
                                                    <asp:Label ID="lbluserId" runat="server" Text='<%#Eval("Id")%>' Visible="false"></asp:Label>
                                                </ItemTemplate>
                                            </asp:TemplateField>
                                            <%--<asp:TemplateField ShowHeader="false" Visible="false" ControlStyle-ForeColor="White" HeaderStyle-Font-Size="Small"
                            ItemStyle-HorizontalAlign="Left">
                            <ItemTemplate>
                                <asp:Label ID="lbluserType" runat="server" Text='<%#Eval("UserType")%>' Visible="false"></asp:Label>
                            </ItemTemplate>
                        </asp:TemplateField>--%>
                                            <asp:TemplateField ShowHeader="True" HeaderText="Notes" ControlStyle-ForeColor="White" HeaderStyle-Font-Size="Small"
                                                ItemStyle-HorizontalAlign="Left">
                                                <ItemTemplate>
                                                    <asp:Label ID="lblNotes" runat="server" Text='<%#Eval("Notes")%>'></asp:Label>
                                                </ItemTemplate>
                                                <ControlStyle ForeColor="Black" />
                                                <ControlStyle ForeColor="Black" />
                                                <HeaderStyle Font-Size="Small"></HeaderStyle>
                                                <ItemStyle HorizontalAlign="Left"></ItemStyle>
                                            </asp:TemplateField>
                                            <asp:TemplateField ShowHeader="True" HeaderText="Status" ControlStyle-ForeColor="White" HeaderStyle-Font-Size="Small"
                                                ItemStyle-HorizontalAlign="Left">
                                                <ItemTemplate>
                                                    <asp:Label ID="lblStatus" runat="server"></asp:Label>
                                                </ItemTemplate>
                                                <ControlStyle ForeColor="Black" />
                                                <ControlStyle ForeColor="Black" />
                                                <HeaderStyle Font-Size="Small"></HeaderStyle>
                                                <ItemStyle HorizontalAlign="Left"></ItemStyle>
                                            </asp:TemplateField>
                                            <asp:TemplateField ShowHeader="True" HeaderText="Files" ControlStyle-ForeColor="White" HeaderStyle-Font-Size="Small"
                                                ItemStyle-HorizontalAlign="Left">
                                                <ItemTemplate>
                                                    <asp:Label ID="lblFiles" runat="server" Text='<%# Eval("AttachmentCount")%>'></asp:Label>
                                                    <br>
                                                    <asp:LinkButton ID="lbtnAttachment" runat="server" Text="Download" CommandName="DownLoadFiles" CommandArgument='<%# Eval("attachments")%>'></asp:LinkButton>
                                                </ItemTemplate>
                                                <ControlStyle ForeColor="Black" />
                                                <ControlStyle ForeColor="Black" />
                                                <HeaderStyle Font-Size="Small"></HeaderStyle>
                                                <ItemStyle HorizontalAlign="Left"></ItemStyle>
                                            </asp:TemplateField>
                                        </Columns>
                                        <HeaderStyle BackColor="Black" ForeColor="White"></HeaderStyle>
                                    </asp:GridView>
                                    <%-- OnRowDataBound="GridView1_RowDataBound"    OnPageIndexChanging="GridView1_PageIndexChanging" OnRowCommand="GridView1_RowCommand"--%>
                                </div>
                                <br />
                                <table cellspacing="0" cellpadding="0" width="950px" border="1" style="width: 100%; border-collapse: collapse;">
                                    <tr>
                                        <td>Notes:
                                        </td>
                                        <td>
                                            <asp:TextBox ID="txtNote" runat="server" TextMode="MultiLine" Width="90%" CssClass="textbox"></asp:TextBox>
                                        </td>
                                    </tr>

                                    <tr>
                                        <td colspan="2">
                                            <div class="btn_sec">
                                                <asp:Button ID="btnAddNote" runat="server" Text="Add Note & Files" CssClass="ui-button" OnClick="btnAddNote_Click" />
                                            </div>
                                        </td>
                                    </tr>
                                </table>
                            </ContentTemplate>
                        </asp:TabPanel>
                        <asp:TabPanel ID="tpTaskHistory_FilesAndDocs" runat="server" TabIndex="0" CssClass="task-history-tab">
                            <HeaderTemplate>Files & docs</HeaderTemplate>
                            <ContentTemplate>
                                HTML Goes here 1
                           
                            </ContentTemplate>
                        </asp:TabPanel>
                        <asp:TabPanel ID="tpTaskHistory_Images" runat="server" TabIndex="0" CssClass="task-history-tab">
                            <HeaderTemplate>Images</HeaderTemplate>
                            <ContentTemplate>
                                HTML Goes here 3
                           
                            </ContentTemplate>
                        </asp:TabPanel>
                        <asp:TabPanel ID="tpTaskHistory_Links" runat="server" TabIndex="0" CssClass="task-history-tab">
                            <HeaderTemplate>Links</HeaderTemplate>
                            <ContentTemplate>
                                HTML Goes here 4
                           
                            </ContentTemplate>
                        </asp:TabPanel>
                        <asp:TabPanel ID="tpTaskHistory_Videos" runat="server" TabIndex="0" CssClass="task-history-tab">
                            <HeaderTemplate>Videos</HeaderTemplate>
                            <ContentTemplate>
                                HTML Goes here 5
                           
                            </ContentTemplate>
                        </asp:TabPanel>
                        <asp:TabPanel ID="tpTaskHistory_Audios" runat="server" TabIndex="0" CssClass="task-history-tab">
                            <HeaderTemplate>Audios</HeaderTemplate>
                            <ContentTemplate>
                                HTML Goes here 6
                           
                            </ContentTemplate>
                        </asp:TabPanel>
                    </asp:TabContainer>
                </ContentTemplate>
            </asp:UpdatePanel>
        </ContentTemplate>
    </asp:UpdatePanel>


</div>
<script>

    $(function () {

        //functions for auto search suggestions.
        createCategorisedAutoSearch();
        setAutoSearch();
        setDatePicker();
        setTaskDivClickTrigger();
        //setClickableTooltip('#taskGrid');
        bindtasklistExpandCollapse();
    });

    var prmTaskGenerator = Sys.WebForms.PageRequestManager.getInstance();

    prmTaskGenerator.add_endRequest(function () {

        //functions for auto search suggestions.
        createCategorisedAutoSearch();
        setAutoSearch();
        setDatePicker();
        setTaskDivClickTrigger();
        <%--setClickableTooltip('#<%=upnlTasks.ClientID%>');--%>
        bindtasklistExpandCollapse();
    });

    function RemoveTask(TaskId) {

        var userChoice = confirm('Are you sure you want to delete this task?');

        if (userChoice) {
            $("#<%=hdnDeleteTaskId.ClientID%>").val(TaskId);
            $('#<%=btnRemoveTask.ClientID %>').click();
        }

    }

    function setAutoSearch() {

<%--        $("#<%=txtSearch.ClientID%>").catcomplete({
            delay: 500,
            source: function (request, response) {
                $.ajax({
                    type: "POST",
                    url: "ajaxcalls.aspx/GetSearchSuggestions",
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
                //console.log(event);
                //console.log(ui);
                $("#<%=txtSearch.ClientID%>").val(ui.item.value);
                TriggerSearch();
            }
        });--%>
        }

        function createCategorisedAutoSearch() {

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

        function setTaskDivClickTrigger() {
            //On click of task list it should open tasklist page.
            $('#taskGrid').click(function (e) {

                if ($(e.target).is("a") || $(e.target).is("select") || e.target.id == "caption" || $(e.target).hasClass('dd_chk_select')) {
                    return true;
                }
                else {
                    window.location.href = $("#hypTaskListMore").attr("href");
                }
            });
        }

        // as soon as user will type 2 character it will go for search.
        function setSearchTextKeyUpSearchTrigger(textbox) {

            var searchText = $(textbox).val();

            if (searchText.length > 1) {
                TriggerSearch();
            }

            $(textbox).focus();
        }

        function EditTask(id, tasktitle) {

            window.open("TaskGenerator.aspx?TaskId=" + ($('#<%=hdnTaskId.ClientID%>').val()));
        }

        function setDatePicker() {
            // on date selection finish, trigger search, both dates must be selected.
            $('.filter-datepicker').datepicker({

                onSelect: function () {
                    checkDatePickerDatesNTriggerSearch();
                }
            });

            $('.datepicker').datepicker({ dateFormat: 'mm-dd-yy' });
        }

        function checkDatePickerDatesNTriggerSearch() {
            <%--var fromdate, todate;
            fromdate = $('#<%= txtFromDate.ClientID %>').val();
                todate = $('#<%= txtToDate.ClientID %>').val();
                if (fromdate.length > 0 && todate.length > 0) {
                    TriggerSearch();
                }
                else if (fromdate.length == 0 && todate.length == 0) {
                    TriggerSearch();
                }--%>
            }

            //function SetHeaderSectionHeight() {
            //    //$('.tasklist').css('max-height', '800px');
            //    $('.tasklist').animate({ 'maxHeight': 600 }, 1000);
            //}

            //function HideHeaderSectionHeight() {
            //    //$('.tasklist').css('max-height', '165px');
            //    $('.tasklist').animate({ 'maxHeight': 165 }, 1000);
            //}

            function TriggerSearch() {
                <%--$('#<%=btnSearch.ClientID %>').click();--%>

            }

            //function setClickableTooltip(target) {
            //    $(target).mouseenter(function () {

            //        var hyperlinkview = $("#hypViewMore");
            //        var expanded = hyperlinkview.attr("data-expanded");
            //        if (expanded == "0") {
            //            toggleShowMoreResults(expanded, hyperlinkview);
            //        }
            //    });

            //    $(target).mouseleave(function () {

            //        HideHeaderSectionHeight();
            //        var linkobject = $("#hypViewMore");
            //        $(linkobject).html("View More");
            //        $(linkobject).attr("data-expanded", "0");
            //    });
            //}

    function bindtasklistExpandCollapse() {
        $('.tasklist').hover(function () {
            $(this).stop(true, true).animate({ 'maxHeight': 600 }, 500);
        }, function () {
            $(this).stop(true, true).animate({ 'maxHeight': 256 }, 500)
        });
    }

            //function bindViewMore() {

            //    $("#hypViewMore").click(function () {
            //        var expanded = $(this).attr("data-expanded");
            //        toggleShowMoreResults(expanded, this);
            //    });
            //}

            //function toggleShowMoreResults(view, linkobject) {

            //    if (view == "0") {// if content is hidden than expand it.
            //        SetHeaderSectionHeight();
            //        $(linkobject).html("Hide");
            //        $(linkobject).attr("data-expanded", "1");
            //    }
            //    else {
            //        HideHeaderSectionHeight();
            //        $(linkobject).html("View More");
            //        $(linkobject).attr("data-expanded", "0");
            //    }
            //}

</script>
