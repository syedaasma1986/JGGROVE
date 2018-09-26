<%@ Control Language="C#" AutoEventWireup="true" CodeBehind="SRAppHeader.ascx.cs" Inherits="JG_Prospect.Sr_App.SRAppHeader" %>
<%@ Register Src="~/Controls/TaskGenerator.ascx" TagPrefix="uc1" TagName="TaskGenerator" %>

<!--tabs jquery-->
<%--<script type="text/javascript" src="../js/jquery.ui.core.js"></script>
<script type="text/javascript" src="../js/jquery.ui.widget.js"></script>
<!--tabs jquery ends-->
<script type="text/javascript">
    $(function () {
        // Tabs
        $('#tabs').tabs();
    });
		</script>
<style type="text/css">
.ui-widget-header {
	border: 0;
	background:none/*{bgHeaderRepeat}*/;
	color: #222/*{fcHeader}*/;
}
</style>--%>
<style>
    #Header1_divTask {
        height: 265px;
    }

        #Header1_divTask:hover {
        }
    /*#divTask:hover > nav {
            position:fixed;
        }*/
    #test a {
        color: red;
    }



    .img-Profile {
        border-radius: 50%;
        width: 77px;
        height: 76px;
    }

    .ProfilImg .caption {
        opacity: 0.6;
        position: absolute;
        /* height: 28px; */
        width: 75px;
        bottom: 3px;
        padding: 1px 0px;
        color: #ffffff;
        background: #1f211f;
        text-align: center;
        font-weight: normal;
        left: 1px;
    }

    #ViewTab ul {
        position: absolute;
        top: 415px;
        margin-right: 19px;
    }

    .content_panel {
        margin-top: 46px;
    }

    .search_google input[type=text] {
        margin-top: 97px;
    }

    .tasklist {
        /*width: 100% !important;
        margin-left: 0px !important;*/
    }
    /*.ProfilImg:hover .caption {
        opacity: 0.6;
    }*/
    .tlist{
        background: url(../img/dashboard-bg.png);
        width: 100%;
        max-height: 248px;
        overflow: auto;
        position: relative;
        z-index: 100;
    }
    .nav-menu-icon{
        color: white;
        font-size: 16px;
        cursor:pointer;
    }
</style>
<script>

</script>
<div class="header">
    <%--<img src="../img/logo.png" alt="logo" width="88" height="89" class="logo" />--%>
    <table style="width: 100%">
        <tr>
            <td style="height: 265px; width: 221px">
                <div class="logo" style="font-weight: bold; color: red;">
                    <img src="../img/logo.png" alt="logo" width="88" height="89"><br>
                    <%--<hr style="width: 68%;">--%>
                    <span style="font-size: 14px;">JMGC LLC - #001</span>
                    <br>
                    <br>
                    <span style="color: white;" runat="server" id="BranchAddress1">72 E Lancaster Ave </span>
                    <br>
                    <span runat="server" id="BranchAddress2">Malvern, PA 19355</span><br>
                    <br>
                    <span style="color: white;" runat="server" id="Department">Human Resource:</span><br>
                    <span runat="server" id="Phone">(215)483-3098</span><br />
                    <span><a href="javascript:;" runat="server" id="Email">HR@jmgroveconstruction.com</a></span>
                    <br />
                    <br />
                    <span style="color: white">You will be logged out in: 4:25</span>
                    <span style="background-color: yellow;"></span>
                </div>
            </td>
            <td>
                <div id="divTask" runat="server">
                    <div id="divTaskMain" class="tlist">
                        <uc1:TaskGenerator runat="server" ID="TaskGenerator" />         
                        <%--<div id="divTask">
                   <uc1:TaskGenerator runat="server" ID="TaskGenerator" />                    
                </div>--%>
                        <table id="ContentPlaceHolder1_tableFilter" style="background: url(../img/dashboard-bg.png); width: 100%; table-layout: fixed;" class="tableFilter">
                            <tbody style="display: block;">
                                <tr style="background-color: #000; color: white; font-weight: bold; text-align: center;">
                                    <td>
                                        <span>Designation</span></td>
                                    <td>
                                        <span>User &amp; Task Status</span><span style="color: red">*</span></td>
                                    <td>
                                        <span>Users</span></td>

                                    <td style="width: 450px !important;">
                                        <span id="Label2">Select Period</span>
                                    </td>
                                    <td style="width: 100%;">Search</td>
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
                                            <div class="chosen-drop">
                                                <ul class="chosen-results"></ul>
                                            </div>
                                        </div>
                                        <span id="lblLoading" style="display: none;">Loading...</span>
                                    </td>

                                    <td style="text-align: left; padding: 0px; width: 450px;">
                                        <div style="">
                                            <div style="float: left; margin-right: 40px;">
                                                <input class="chkAllDates" name="chkAllDates" type="checkbox" checked="checked"><label for="chkAllDates">All</label>
                                                <input class="chkOneYear" name="chkOneYear" type="checkbox"><label for="chkOneYear">1 year</label>
                                                <input class="chkThreeMonth" name="chkThreeMonth" type="checkbox"><label for="chkThreeMonth"> Quarter (3 months)</label>
                                                <br>
                                                <input class="chkOneMonth" name="chkOneMonth" type="checkbox"><label for="chkOneMonth"> 1 month</label>
                                                <input class="chkTwoWks" name="chkTwoWks" type="checkbox"><label for="chkTwoWks"> 2 weeks (pay period!)</label>
                                            </div>

                                            <div style="width: 437px;">
                                                <span id="Label3">From :*
                                            <input type="text" maxlength="10" tabindex="2" onkeypress="return false" style="width: 80px;">
                                                    <br>
                                                </span>

                                                <span id="Label4">To :*
                                            <input type="text" maxlength="10" tabindex="3" onkeypress="return false" style="width: 80px; margin-left: 16px;">
                                                </span>
                                            </div>
                                        </div>
                                    </td>
                                    <td>
                                        <input id="txtSearchUser" class="textbox ui-autocomplete-input" maxlength="15" placeholder="search users" type="text">
                                    </td>
                                </tr>
                                <tr>
                                    <td colspan="2" style="vertical-align: bottom; line-height: 6px; padding-bottom: 6px !important; font-size: 16px; font-weight: bold;">
                                        <a href="TaskGenerator.aspx">Add New</a>
                                        <span style="font-weight: bold; color: blue; padding: 7px;">|</span>
                                        <a href="TaskList.aspx">See More</a>
                                    </td>
                                    <td></td>
                                    <td colspan="2" style="padding: 0px;">
                                        <div class="ui-tabs ui-widget ui-widget-content ui-corner-all" style="float: right;">
                                            <ul class="ui-tabs-nav ui-helper-reset ui-helper-clearfix ui-widget-header ui-corner-all" role="tablist">
                                                <li class="ui-state-default ui-corner-top ui-tabs-active ui-state-active" role="tab" tabindex="0" aria-controls="StaffTask" aria-labelledby="ui-id-29" aria-selected="true"><a href="#StaffTask" class="ui-tabs-anchor" role="presentation" tabindex="-1" id="ui-id-29">Staff Tasks</a></li>
                                                <li class="ui-state-default ui-corner-top" role="tab" tabindex="-1" aria-controls="TechTask" aria-labelledby="ui-id-30" aria-selected="false"><a href="#TechTask" class="ui-tabs-anchor" role="presentation" tabindex="-1" id="ui-id-30">Tech Tasks</a></li>
                                            </ul>
                                        </div>
                                    </td>
                                </tr>
                            </tbody>
                        </table>
                        <div class="seqlist" style="">
                            <table style="width: 99%; table-layout: fixed; margin: 4px; margin-top:-4px;" cellspacing="0">
                                <tbody style="display: block;">
                                    <tr style="background-color: black; color: white;">
                                        <td style="width: 122px;">Sequence#</td>
                                        <td style="width: 66px;">ID#<br>
                                            Designation</td>
                                        <td style="width: 275px;">Parent Task<br>
                                            SubTask Title</td>
                                        <td style="width: 160px;">Status<br>
                                            Assigned To</td>
                                        <td style="width: 95px;">Total Hours<br>
                                            Total $</td>
                                        <td style="width: 450px">Notes</td>
                                    </tr>
                                    <tr style="background: orange;">
                                        <td>
                                            <div class="col1-seqno">
                                                <a href="#/">
                                                    <img src="../img/btn_maximize.png" data-taskid="785" onclick="expandRomansFromTask(this)" data-appended="false">
                                                </a>
                                                <a ng-attr-id="autoClick{{Task.TaskId}}" href="javascript:void(0);" class="badge-hyperlink autoclickSeqEdit" ng-attr-data-taskseq="{{Task.Sequence}}" ng-attr-data-taskid="{{Task.TaskId}}" ng-attr-data-seqdesgid="{{Task.SequenceDesignationId}}" id="autoClick785" data-taskseq="36" data-taskid="785" data-seqdesgid="10"><span class="badge badge-success badge-xstext">
                                                    <label ng-attr-id="SeqLabel{{Task.TaskId}}" class="ng-binding" id="SeqLabel785">36-ITSN:SS</label></span></a>

                                                <a href="javascript:void(0);" id="ContentPlaceHolder1_seqArrowUp" ng-attr-data-taskid="{{Task.TaskId}}" ng-attr-data-taskseq="{{Task.Sequence}}" onclick="swapSequence(this,true)" ng-attr-data-taskdesg="{{Task.SequenceDesignationId}}" style="text-decoration: none;" ng-show="!$first" ng-hide="false" ng-class="{hide: Task.Sequence == null || 0}" data-taskid="785" data-taskseq="36" data-taskdesg="10">▲</a>
                                                <a href="javascript:void(0);" id="ContentPlaceHolder1_seqArrowDown" style="text-decoration: none;" ng-class="{hide: Task.Sequence == null || 0}" ng-attr-data-taskid="{{Task.TaskId}}" ng-attr-data-taskseq="{{Task.Sequence}}" ng-attr-data-taskdesg="{{Task.SequenceDesignationId}}" onclick="swapSequence(this,false)" ng-show="!$last" data-taskid="785" data-taskseq="36" data-taskdesg="10">▼</a>
                                            </div>
                                        </td>
                                        <td>
                                            <div class="col2-iddes ng-binding">
                                                <a ng-href="../Sr_App/TaskGenerator.aspx?TaskId=418&amp;hstid=785" oncontextmenu="openCopyBox(this);return false;" data-installid="ITJN029-XIV" parentdata-highlighter="418" data-highlighter="785" class="bluetext context-menu ng-binding" target="_blank" href="../Sr_App/TaskGenerator.aspx?TaskId=418&amp;hstid=785">ITJN029-XIV</a><br>
                                                IT - Sr .Net Developer                                        
                                            </div>
                                        </td>
                                        <td>
                                            <div>
                                                Task Generator: http://web.jmgrovebuildingsupply.com/Sr_App/TaskGenerator.aspx
                                        <br>
                                                Task generator DESCRIPTION column upgrade
                                            </div>
                                        </td>
                                        <td>
                                            <div class="div-table-col seq-taskstatus-fixed chosen-div">
                                                <select id="drpStatusSubsequence700" onchange="changeTaskStatusClosed(this);" data-highlighter="657" style="width: 100%;">
                                                    <option ng-selected="true" value="4" selected="selected">InProgress</option>

                                                    <option ng-selected="false" style="color: lawngreen" value="3">Request-Assigned</option>
                                                    <option ng-selected="false" value="1">Open</option>



                                                    <option ng-selected="false" value="11">Test Commit</option>

                                                </select>
                                                <br>


                                                <div class="chosen-container chosen-container-multi chosen-disabled" style="width: 150px;" title="" id="ddcbSeqAssignedStaff657_chosen">
                                                    <ul class="chosen-choices">
                                                        <li class="search-choice"><span>Kapil K. Pancholi - ITSN-A0411
                                                        </span><a class="search-choice-close" data-option-array-index="1"></a></li>

                                                    </ul>
                                                    <div class="chosen-drop">
                                                        <ul class="chosen-results"></ul>
                                                    </div>
                                                </div>





                                            </div>
                                        </td>
                                        <td>
                                            <div class="div-table-col seq-taskduedate-fixed">
                                                <div class="seqapprovalBoxes" id="SeqApprovalDiv657" data-adminstatusupdateddate="9/16/2017" data-adminstatusupdatedtime="9:18 PM" data-adminstatusupdatedtimezone="(EST)" data-adminstatusupdated="2017-09-16T15:48:27.19+00:00" data-admindisplayname="INS00092 - justin grove" data-adminstatususerid="780" data-leadstatusupdateddate="9/20/2017" data-leadstatusupdatedtime="6:47 PM" data-leadstatusupdatedtimezone="(EST)" data-leadstatusupdated="16" data-leadhours="16" data-leaddisplayname="901 - Yogesh Keraliya" data-leaduserid="901" data-userstatusupdateddate="" data-userstatusupdatedtime="" data-userstatusupdatedtimezone="" data-userstatusupdated="" data-userhours="" data-userdisplayname=" -  " data-useruserid="">
                                                    <div style="width: 55%; float: left;">
                                                        <input type="checkbox" data-taskid="657" onchange="openSeqApprovalPopup(this)" id="chkngUserMaster700" ng-checked="false" ng-disabled="false" class="fz fz-user" title="User">
                                                        <input type="checkbox" data-taskid="657" onchange="openSeqApprovalPopup(this)" id="chkQAMaster700" class="fz fz-QA" title="QA">
                                                        <input type="checkbox" data-taskid="657" onchange="openSeqApprovalPopup(this)" id="chkAlphaUserMaster700" class="fz fz-Alpha" title="AlphaUser">
                                                        <br>
                                                        <input type="checkbox" data-taskid="657" onchange="openSeqApprovalPopup(this)" id="chkBetaUserMaster700" class="fz fz-Beta" title="BetaUser">
                                                        <input type="checkbox" data-taskid="657" onchange="openSeqApprovalPopup(this)" id="chkngITLead700" ng-checked="true" ng-disabled="true" class="fz fz-techlead" title="IT Lead" disabled="disabled" checked="checked">
                                                        <input type="checkbox" data-taskid="657" onchange="openSeqApprovalPopup(this)" id="chkngAdmin700" ng-checked="true" ng-disabled="true" class="fz fz-admin" title="Admin" disabled="disabled" checked="checked">
                                                    </div>
                                                    <div style="width: 42%; float: right;">
                                                        <input type="checkbox" data-taskid="657" onchange="openSeqApprovalPopup(this)" id="chkngITLeadMaster700" class="fz fz-techlead largecheckbox" title="IT Lead"><br>
                                                        <input type="checkbox" data-taskid="657" onchange="openSeqApprovalPopup(this)" id="chkngAdminMaster700" class="fz fz-admin largecheckbox" title="Admin">
                                                    </div>
                                                </div>


                                            </div>
                                        </td>
                                        <td>
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
                                        </td>
                                    </tr>
                                    <tr style="background: yellow;">
                                        <td>
                                            <div class="col1-seqno">
                                                <a href="#/">
                                                    <img src="../img/btn_maximize.png" data-taskid="785" onclick="expandRomansFromTask(this)" data-appended="false">
                                                </a>
                                                <a ng-attr-id="autoClick{{Task.TaskId}}" href="javascript:void(0);" class="badge-hyperlink autoclickSeqEdit" ng-attr-data-taskseq="{{Task.Sequence}}" ng-attr-data-taskid="{{Task.TaskId}}" ng-attr-data-seqdesgid="{{Task.SequenceDesignationId}}" id="autoClick785" data-taskseq="36" data-taskid="785" data-seqdesgid="10"><span class="badge badge-success badge-xstext">
                                                    <label ng-attr-id="SeqLabel{{Task.TaskId}}" class="ng-binding" id="SeqLabel785">36-ITSN:SS</label></span></a>

                                                <a href="javascript:void(0);" id="ContentPlaceHolder1_seqArrowUp" ng-attr-data-taskid="{{Task.TaskId}}" ng-attr-data-taskseq="{{Task.Sequence}}" onclick="swapSequence(this,true)" ng-attr-data-taskdesg="{{Task.SequenceDesignationId}}" style="text-decoration: none;" ng-show="!$first" ng-hide="false" ng-class="{hide: Task.Sequence == null || 0}" data-taskid="785" data-taskseq="36" data-taskdesg="10">▲</a>
                                                <a href="javascript:void(0);" id="ContentPlaceHolder1_seqArrowDown" style="text-decoration: none;" ng-class="{hide: Task.Sequence == null || 0}" ng-attr-data-taskid="{{Task.TaskId}}" ng-attr-data-taskseq="{{Task.Sequence}}" ng-attr-data-taskdesg="{{Task.SequenceDesignationId}}" onclick="swapSequence(this,false)" ng-show="!$last" data-taskid="785" data-taskseq="36" data-taskdesg="10">▼</a>
                                            </div>
                                        </td>
                                        <td>
                                            <div class="col2-iddes ng-binding">
                                                <a ng-href="../Sr_App/TaskGenerator.aspx?TaskId=418&amp;hstid=785" oncontextmenu="openCopyBox(this);return false;" data-installid="ITJN029-XIV" parentdata-highlighter="418" data-highlighter="785" class="bluetext context-menu ng-binding" target="_blank" href="../Sr_App/TaskGenerator.aspx?TaskId=418&amp;hstid=785">ITJN029-XIV</a><br>
                                                IT - Sr .Net Developer                                        
                                            </div>
                                        </td>
                                        <td>
                                            <div>
                                                Task Generator: http://web.jmgrovebuildingsupply.com/Sr_App/TaskGenerator.aspx
                                        <br>
                                                Task generator DESCRIPTION column upgrade
                                            </div>
                                        </td>
                                        <td>
                                            <div class="div-table-col seq-taskstatus-fixed chosen-div">
                                                <select id="drpStatusSubsequence701" onchange="changeTaskStatusClosed(this);" data-highlighter="657" style="width: 100%;">
                                                    <option ng-selected="true" value="4" selected="selected">InProgress</option>

                                                    <option ng-selected="false" style="color: lawngreen" value="3">Request-Assigned</option>
                                                    <option ng-selected="false" value="1">Open</option>



                                                    <option ng-selected="false" value="11">Test Commit</option>

                                                </select>
                                                <br>


                                                <div class="chosen-container chosen-container-multi chosen-disabled" style="width: 150px;" title="" id="ddcbSeqAssignedStaff657_chosen">
                                                    <ul class="chosen-choices">
                                                        <li class="search-choice"><span>Kapil K. Pancholi - ITSN-A0411
                                                        </span><a class="search-choice-close" data-option-array-index="1"></a></li>

                                                    </ul>
                                                    <div class="chosen-drop">
                                                        <ul class="chosen-results"></ul>
                                                    </div>
                                                </div>





                                            </div>
                                        </td>
                                        <td>
                                            <div class="div-table-col seq-taskduedate-fixed">
                                                <div class="seqapprovalBoxes" id="SeqApprovalDiv700" data-adminstatusupdateddate="9/16/2017" data-adminstatusupdatedtime="9:18 PM" data-adminstatusupdatedtimezone="(EST)" data-adminstatusupdated="2017-09-16T15:48:27.19+00:00" data-admindisplayname="INS00092 - justin grove" data-adminstatususerid="780" data-leadstatusupdateddate="9/20/2017" data-leadstatusupdatedtime="6:47 PM" data-leadstatusupdatedtimezone="(EST)" data-leadstatusupdated="16" data-leadhours="16" data-leaddisplayname="901 - Yogesh Keraliya" data-leaduserid="901" data-userstatusupdateddate="" data-userstatusupdatedtime="" data-userstatusupdatedtimezone="" data-userstatusupdated="" data-userhours="" data-userdisplayname=" -  " data-useruserid="">
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
                                        </td>
                                        <td>
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
                                        </td>
                                    </tr>
                                </tbody>
                            </table>
                        </div>
                    </div>
                </div>                
            </td>
            <td style="width: 350px"></td>
        </tr>
    </table>

    <div class="user_panel">
        <div class="ProfilImg">
            <asp:Image CssClass="img-Profile" ID="imgProfile" runat="server" />
            <asp:HyperLink class="caption" runat="server" ID="hLnkEditProfil" Text="Edit"></asp:HyperLink>
        </div>
        Welcome! 
        <span>
            <asp:Label ID="lbluser" runat="server" Text="User"></asp:Label>
            <asp:Button ID="btnlogout" runat="server" Text="Logout" CssClass="cancel" ValidationGroup="header" OnClick="btnlogout_Click" />
        </span>
        <span>
            <asp:Label ID="lblDesignation" runat="server" Text="" CssClass="designation-container"></asp:Label></span>
        <ul>
            <li><a href="home.aspx">Home</a></li>
            <li>|</li>
            <li><a href='<%=Page.ResolveUrl("~/changepassword.aspx")%>'>Change Password</a></li>
            <li>|</li>
            <li style="position:relative"><input type="text" onkeyup="globalSearch(this)" placeholder="Search" class="search-box" />
                <div class="search-container"></div>
            </li>
        </ul>
        <ul style="margin-top: 14px;">
            <li><a href="#" onclick="InitiateBlankChat(this,'all')" class="red-text">All</a></li>
            <li>&nbsp;&nbsp;|&nbsp;&nbsp;</li>
            <!--Email with # of unread msgs and new font-->
            <li id="test"><a id="hypEmail" class="clsPhoneLink" onclick="InitiateBlankChat(this, 'email')" runat="server" style="color: white;">Emails<label id="emailUnreadCount" class="badge badge-error">0</label><label id="lblUnRead" class="badge badge-error hide"></label></a></li>
            <li>&nbsp;&nbsp;|&nbsp;&nbsp;</li>
            <li><a id="idPhoneLink" runat="server" class="clsPhoneLink" href="javascript:;" onclick="openPhoneDashboard(this)">Phone / Vmail(0)<label id="lblNewCounter" class="badge badge-error">10</label><label id="lblUnRead" class="badge badge-error hide"></label></a></a></li>
            <li>&nbsp;&nbsp;|&nbsp;&nbsp;</li>
            <li><a id="hypChat" href="#" class="clsPhoneLink" onclick="InitiateBlankChat(this, 'chat');">Chat
                <label style="display: none;" class="badge badge-error chatUnreadCount"></label>
                <label style="display: none;" class="badge badge-error chatAutoEntriesCount"></label>
                <label class="badge badge-error hide"></label>
            </a></a></li>
        </ul>
    </div>
    <div class="header-msg">
        <div class="no-user">Loading Online Users...</div>
    </div>
</div>
<!--nav section-->
<div class="nav" runat="server" id="NavMenuLeft">
    <ul>
        <%--<li>Toggle Menu</li>--%>
        <li><i class="fas fa-bars nav-menu-icon" aria-hidden="true" onclick="toggleMenu(this)"></i></li>
        <li><a href="home.aspx">Home</a></li>
        <li><a href="new_customer.aspx">Add Customer</a></li>
        <%-- <li><a href="view_customer.aspx">Review / Edit Customer Estimate</a></li>--%>
        <li><a href="ProductEstimate.aspx">Product Estimate</a></li>
        <li><a href="SalesReort.aspx">Sales Report</a></li>
        <%--<li><a href="Vendors.aspx">Vendor Master</a></li>--%>
        <li id="Li_Jr_app" runat="server" visible="true"><a href="~/home.aspx" runat="server"
            id="Jr_app">Junior App</a></li>
        <li id="Li_Installer" runat="server" visible="true"><a href="~/Installer/InstallerHome.aspx" runat="server"
            id="A1">Installer</a></li>


        <%-- <li><a href="/EditUser.aspx" runat="server" id="edituser">EditUser</a></li>
  <li><a href="/Accounts/newuser.aspx" runat="server" id ="newuser">CreateUser</a></li>--%>
    </ul>
</div>
<script type="text/javascript">
    function toggleMenu(sender) {
        $('.dark-bg').fadeToggle(500);
        $('#leftmenudiv').toggle(500);
    }

    function SetEmailCounts() {

        $.ajax({
            type: "POST",
            url: "ajaxcalls.aspx/GetEmailCounters",
            dataType: "json",
            contentType: "application/json; charset=utf-8",
            success: function (data) {
                console.log(data);
                if (data.d) {
                    var counters = JSON.parse(data.d);
                    console.log(counters);
                    if (counters) {
                        $('#lblNewCounter').html(counters.newone);
                        $('#lblNewCounter').show();
                        $('#lblUnRead').html("Unread: " + counters.unread);
                    }
                    //response(data.length === 1 && data[0].length === 0 ? [] : JSON.parse(data.d));
                }
            }
        });
    }

    function OpenChatWindow() {

        $('<img />').attr({
            src: '/img/ajax-loader.gif',
            id: 'chatprogress'
        }).appendTo($('#hypChat'));

        $.ajax({
            type: "POST",
            url: "ajaxcalls.aspx/LogintoChat",
            dataType: "json",
            contentType: "application/json; charset=utf-8",
            success: function (data) {
                console.log(data);
                if (data.d) {
                    var counters = JSON.parse(data.d);
                    console.log(counters);
                    if (counters == "1") {
                        window.open('/Sr_App/JabbRChat.aspx', "JMG - Chat", "width=600,height=600,scrollbars=yes");
                    }
                    else {
                        alert('Couldn\'t Login to Chat application right now, Please try again later.');
                    }
                }
                else {
                    alert('Couldn\'t Login to Chat application right now, Please try again later.');
                }
                $('#hypChat').html('Chat');
            },
            error: function () {
                $('#hypChat').html('Chat');
            }
        });

    }
    $(document).ready(function () {
        $('.tlist').hover(function () {
            $(this).stop(true, true).animate({ 'maxHeight': 600 }, 500);
        }, function () {
            $(this).stop(true, true).animate({ 'maxHeight': 256 }, 500)
        });
        
    });
</script>
