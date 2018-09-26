<%@ Page Title="" Language="C#" MasterPageFile="~/JGApplicant.Master" AutoEventWireup="true" CodeBehind="postapptitude.aspx.cs" Inherits="JG_Prospect.postapptitude" %>

<%@ Register Src="~/UserControl/ucAuditTrailByUser.ascx" TagPrefix="ucAudit" TagName="UserListing" %>


<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <link href="https://vjs.zencdn.net/7.0.3/video-js.css" rel="stylesheet" />
    <style type="text/css">
        .notes-section {
            width: 330px !important;
            float: none !important;
            margin: 1px 0 0 0 !important;
            display: inline-block;
            min-height: 90px;
        }

        .notes-container {
            display: block;
            /*height: 66px;*/
            overflow-x: hidden;
            overflow-y: auto;
            position: absolute;
            top: 0;
            left: 0;
            width: 100%;
            float: none;
            margin: 0;
            padding: 0;
            min-height: auto;
        }

        .note-list {
            display: block;
            height: 66px !important;
            overflow-x: hidden;
            overflow-y: auto;
            position: absolute;
            top: 0;
            left: 0;
            width: 100%;
            float: none;
            margin: 0;
            padding: 0;
            min-height: auto;
        }

        .pos-rel {
            position: relative;
        }

        .notes-inputs {
            text-align: left;
            height: 30px;
            padding: 0px;
            position: absolute;
            left: 0px;
            bottom: 0;
            width: 100%;
        }

        .notes-table {
            height: auto;
            width: 100%;
            margin: 0 0px;
            font-size: 11px;
        }

            .notes-table tbody {
                height: auto !important;
            }

            .notes-table th {
                color: #fff;
                padding: 5px !important;
                background: #000 !important;
                border: none;
            }

            .notes-table td {
                padding: 2px !important;
            }

            .notes-table tr:nth-child(even) {
                background: #A33E3F;
                color: #fff;
            }

            .notes-table tr:nth-child(odd) {
                background: #FFF;
                color: #000;
            }
            /*.notes-table tr a{font-size:10px;}*/
            .notes-table tr:nth-child(even) a, .notes-popup tr:nth-child(even) a {
                color: #fff;
            }

            .notes-table tr th:nth-child(1), .notes-table tr td:nth-child(1) {
                width: 12% !important;
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

        .row-item p {
            margin: 0;
        }

        .div-table-row .row {
            display: inline-block;
            width: 99%;
            padding: 10px 0 10px 10px;
            background: #eee;
            border: 1px solid #aaa;
            border-radius: 5px;
            font-size: 11px;
            color: #000;
        }

            .div-table-row .row a {
                color: blue;
            }

            .div-table-row .row ol {
                list-style-type: decimal;
            }

        .row .row-item {
            float: left;
            width: 100%;
            position: relative;
            min-height: 90px;
            margin-bottom: 5px;
        }

            .row .row-item .col1 {
                width: 54%;
                float: left;
                min-height: 90px;
            }

            .row .row-item .col2 {
                width: 45%;
                float: left;
                position: relative;
                min-height: 90px;
            }

        .row .notes-table {
            float: left;
        }

        .row .notes-section {
            float: left !important;
            width: 100% !important;
        }

            .row .notes-section .second-col {
                width: 83%;
            }

            .row .notes-section .first-col {
                width: 16%;
            }

        .first-col {
            width: 20%;
            float: left;
        }

            .first-col input {
                padding: 5px !important;
                margin: 0 !important;
                border-radius: 5px !important;
                border: #b5b4b4 1px solid !important;
            }

        textarea.note-text {
            height: 22px;
            vertical-align: middle;
            padding: 2px !important;
            width: 255px;
            margin: 0px;
            border-radius: 5px;
            border: #b5b4b4 1px solid;
        }

        .second-col {
            float: right;
            width: 79%;
            text-align: right;
        }

            .second-col textarea.note-text {
                width: 95%;
            }

        .steps {
            width: 10%;
        }

        .id {
            width: 112px;
        }

        .created-for {
            width: 18%;
        }

        .query {
            width: 50%;
        }

        .status {
            width: 10%;
        }

        .freeze-by-user .time {
            color: #ff0000;
        }

        .row-even {
        }

        .row-odd {
            background-color: #f9f9f9;
        }

        .expand-button {
            height: 22px;
            margin-left: 5px;
            margin-top: 2px;
            cursor: pointer;
        }

        .row-expand {
            width: 28px;
        }

        .col-chat {
            width: 40%;
            padding-top: 10px;
            padding-bottom: 10px;
            margin-right: 10px;
        }

        .step-col-ghost {
            line-height: 45px;
            width: 46%;
        }

        .text-step-ghost {
            border: none;
            padding: 9px;
            width: 100%;
        }

        .send-button {
            height: 30px;
            margin-top: 16px;
            padding-left: 30px;
            padding-right: 30px;
            background-color: crimson;
            color: #ffffff;
        }

        .form-input {
            min-height: 24px !important;
        }

        .test-case-id {
            width: 25px;
            font-weight: bold;
        }

        .text-query {
            border-left-width: 0px !important;
            border-right-width: 0px !important;
            border-top-width: 0px !important;
            border-bottom-color: #a9a6a6 !important;
            border-bottom-width: 1px !important;
            border-bottom-style: solid !important;
            margin-top: 5px;
            padding: 4px;
            width: 98%;
        }

        .input-title {
            vertical-align: middle;
            line-height: 20px;
            width: 25px;
            font-weight: bold;
        }

        .step-col-input {
            width: 100%;
            line-height: 24px;
            margin-left: 20px;
        }

        .dropdown-query-type {
            border-left-width: 0px !important;
            border-right-width: 0px !important;
            border-top-width: 0px !important;
            border-bottom-color: #a9a6a6 !important;
            border-bottom-width: 1px !important;
            border-bottom-style: solid !important;
            margin-top: 5px;
            padding: 4px;
            width: 99%;
        }

        .roman-grid {
            background-color: #ffffff;
            font-family: Arial;
            font-size: 12px;
        }

        .roman-col-margin {
            /*width: 25px*/
        }

        .roman-col-expand {
            width: 34px;
        }

        .roman-col-id {
            width: 30px;
        }

        .roman-col-share {
            width: 77px;
        }

            .roman-col-share img {
                width: 73px;
            }

        .roman-col-title {
            width: 330px;
        }

        .roman-col-title-content {
            font-weight: normal;
            text-decoration: none;
            width: 330px;
        }

            .roman-col-title-content .roman-title {
                font-weight: bold;
            }

        .roman-col-assign {
            width: 150px;
        }

        .roman-row {
            background-color: antiquewhite;
        }

        .roman-row-alternate {
            background-color: white;
        }

        .roman-col-assign select {
            width: 155px !important;
        }

        .roman-col-title, .roman-col-id {
            font-weight: bold;
            text-decoration: underline;
            font-size: 14px;
        }

        .roman-col-id {
        }

        .level2 {
            margin-left: 36px;
        }

        .level3 {
            margin-left: 54px;
        }

        .col-margin-nested-child {
            width: 86px;
        }

        .col-margin-nested-child-level3 {
            width: 130px;
        }

        .roman-col-notes {
            width: 332px;
            float: right;
        }

        .roman-col-user-status {
            width: 66px;
        }

        .freeze-head-instruction {
            font-size: 12px;
            font-weight: bold;
            text-decoration: underline;
        }

        .freeze-head-content {
            vertical-align: middle;
            font-size: 12px;
        }

        .freeze-step {
            padding: 5px;
        }

        .freeze-checkbox-info {
            border: 1px solid darkgray;
            margin-bottom: -3px;
        }

        #freeze-step1-head {
            color: red;
            font-size: 12px;
        }

        .freeze-step-content {
            font-size: 12px;
        }

        #freeze-step2-head {
            color: orange;
            font-size: 12px;
        }

        #freeze-step3-head {
            color: green;
            font-size: 12px;
        }

        #freeze-step4-head {
            color: deepskyblue;
            font-size: 12px;
        }

        .freeze-red {
            color: red;
            font-size: 12px;
            font-weight: bold;
        }

        .freeze-black {
            color: black;
            font-size: 12px;
            font-weight: bold;
        }

        .freeze-blue {
            color: blue;
            font-size: 12px;
            font-weight: bold;
        }

        .freeze-orange {
            color: orange;
            font-size: 12px;
            font-weight: bold;
        }

        .freeze-yellow {
            color: #e6e600;
            font-size: 12px;
            font-weight: bold;
        }

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

        .freeze-status-row {
            margin-left: 10px;
            display: inline-flex;
            width: 100%;
        }

        .freeze-status-col {
            width: 33%;
            display: inline-flex;
            margin-right: 50px;
        }

        .freeze-detail-row {
            display: flex;
        }

        .task-detail {
            width: 82px;
            font-weight: bold;
        }

        .freeze-data {
            display: flex;
        }

        .approved-checkboxes {
            display: grid;
            margin-top: 15px;
        }

        .approve-checkbox {
            height: 20px;
            width: 20px;
            margin: 5px;
        }

        .freeze-detail-col {
            width: 255px;
        }

        .freeze-status-header {
            text-align: center;
            width: 100%;
            font-size: 18px;
            font-weight: bold;
        }

        .hide-div {
            display: none;
        }

        .myProgress {
            width: 100%;
            background-color: #f1f1f1;
        }

        .bar {
            width: 1%;
            height: 30px;
            background-color: #990000;
            text-align: center;
        }

        .inline {
            display: inline;
        }

        .task-status-detail {
            font-weight: bold;
            width: 50px;
            text-align: right;
        }

        .big-chkbox-label {
            line-height: 30px;
            vertical-align: middle;
        }

        .freeze-by-user {
            padding: 5px;
            width: 61%;
            height: 37px;
        }

        .row-space {
            margin-top: 20px;
        }

        .user-checkbox {
        }

        .section-container {
            border-style: solid;
            border-color: #e0e0e0;
            border-width: 1px;
            padding: 11px;
            border-radius: 4px;
            margin: 15px;
        }

        .section-container {
            position: relative;
            -webkit-box-shadow: 0 1px 4px rgba(0, 0, 0, 0.3), 0 0 40px rgba(0, 0, 0, 0.1) inset;
            -moz-box-shadow: 0 1px 4px rgba(0, 0, 0, 0.3), 0 0 40px rgba(0, 0, 0, 0.1) inset;
            box-shadow: 0 1px 4px rgba(0, 0, 0, 0.3), 0 0 40px rgba(0, 0, 0, 0.1) inset;
        }

            .section-container:before, .section-container:after {
                content: "";
                position: absolute;
                z-index: -1;
                -webkit-box-shadow: 0 0 20px rgba(0,0,0,0.8);
                -moz-box-shadow: 0 0 20px rgba(0,0,0,0.8);
                box-shadow: 0 0 20px rgba(0,0,0,0.8);
                top: 50%;
                bottom: 0;
                left: 10px;
                right: 10px;
                -moz-border-radius: 100px / 10px;
                border-radius: 100px / 10px;
            }

            .section-container:after {
                right: 10px;
                left: auto;
                -webkit-transform: skew(8deg) rotate(3deg);
                -moz-transform: skew(8deg) rotate(3deg);
                -ms-transform: skew(8deg) rotate(3deg);
                -o-transform: skew(8deg) rotate(3deg);
                transform: skew(8deg) rotate(3deg);
            }

        .container-margin {
            margin: 20px;
        }
        /*Add New Task Popup*/
        #indentDiv {
            background-color: #fff;
            height: 34px;
            float: left;
        }

        .TaskloaderDiv {
            float: right;
            margin-top: 12px;
        }

        #NewChildDiv {
            background-color: white;
            height: 34px;
        }

        .ChildEdit {
            float: left;
            width: 92%;
        }

        .indentButtonRight {
            float: left;
            margin-top: 10px;
            background-image: url(/img/indent_right.jpg);
            height: 21px;
            width: 26px;
            background-repeat: no-repeat;
        }

        .indentButtonLeft {
            float: left;
            margin-left: 4px;
            margin-top: 10px;
            background-image: url(/img/indent_left.jpg);
            height: 21px;
            width: 26px;
            background-repeat: no-repeat;
        }
        /*Add New Task Popup*/

        /*For Roman Freeze(hours) popup*/
        .roman-data {
            margin-top: 15px;
        }

        #ITLeadFreezeHours, #ITLeadFreezeData, #UserFreezeHours, #UserFreezeData {
            display: none;
        }

        #ITLeadFreezeData, #UserFreezeData {
            margin-top: 10px;
        }
        /*For Roman Freeze(hours) popup*/

        /*Freeze-Instructions*/
        .freeze-ins-box {
            width: 28%;
            font-weight: bold;
            font-size: 18px;
            font-family: monospace;
            text-align: center;
            margin: 4px;
        }

        .freeze-white-col {
            border: 1px black solid;
            padding: 2px;
        }

        .freeze-chkbox-div-red {
            border: 1px red solid;
            height: 12px;
            width: 12px;
            display: inline-grid;
        }

        .freeze-chkbox-div-black {
            border: 1px black solid;
            height: 12px;
            width: 12px;
            display: inline-grid;
        }

        .freeze-chkbox-div-blue {
            border: 1px blue solid;
            height: 12px;
            width: 12px;
            display: inline-grid;
        }

        .freeze-chkbox-div-orange {
            border: 1px orange solid;
            height: 12px;
            width: 12px;
            display: inline-grid;
        }

        .freeze-chkbox-div-yellow {
            border: 1px yellow solid;
            height: 12px;
            width: 12px;
            display: inline-grid;
        }

        .ui-accordion-header strong {
            color: blue;
            text-decoration: underline;
            font-weight: normal;
        }

        .col1-seqno {
            float: left;
            width: 122px;
            padding: 3px 5px;
            min-height: 25px;
        }

        .col2-iddes {
            float: left;
            width: 66px;
            padding: 3px 5px;
            min-height: 25px;
            overflow-wrap: break-word;
        }

        .col3-title {
            overflow-wrap: break-word;
            float: left;
            width: 225px;
            padding: 3px 5px;
            min-height: 25px;
        }

        .col4-assigned {
            float: left;
            width: 160px;
            padding: 3px 5px;
            min-height: 25px;
        }

        .col5-hours {
            float: left;
            width: 95px;
            padding: 3px 5px;
            min-height: 25px;
        }

        .col6-notes {
            width: 100%;
            padding: 3px 5px;
            min-height: 25px;
        }

        .col-header {
            background-color: black;
            color: white;
        }
        /*Freeze-Instructions*/



        input:not([type=radio]), select {
            width: 90%;
            padding: 5px;
            border-radius: 5px;
        }

        .w3-light-grey {
            color: #000 !important;
            border: 2px solid #9e9e9e !important;
            border-bottom: 5px solid #9e9e9e !important;
        }

        .w3-grey {
            color: #fff !important;
            font-weight: bold;
            background-color: #b94c4f !important;
            height: 18px;
            width: 0%;
        }

        .header-table {
            padding: 15px 0 0 15px;
        }

            .header-table tr {
                line-height: 1.75;
            }

            .header-table input[type=checkbox] {
                width: auto;
            }

            .header-table td:nth-child(1) {
                width: 40%
            }

            .header-table td:nth-child(2) {
                width: 40%
            }

            .header-table td:nth-child(3) {
                width: 20%
            }

        .errortext {
            color: red;
        }

        .right_panel {
            background-color: #fff;
        }
    </style>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <div class="right_panel">
        <div id="OppUnlocked" data-ng-controller="PostApptitude">
            <h1>Congratulations! - Opportunity Notice</h1>
            <!-- Application stage progress -->
            <div id="appstage" class="sectiondiv">
                <div class="w3-light-grey">
                    <div class="w3-grey" style="width: 30%;">33%</div>
                </div>

                <table width="100%" class="header-table">
                    <tr>
                        <td><b>Stage 1 - Application</b></td>
                        <td><b>Stage 2 - On Boarding</b></td>
                        <td><b>Stage 3 - Approval</b></td>
                    </tr>
                    <tr>
                        <td>
                            <asp:CheckBox ID="chkRegComplete" runat="server" Checked="true" />
                            Registration Complete</td>
                        <td>
                            <asp:CheckBox ID="chkNotifiedAboutOpportunity" Checked="true" runat="server" />
                            Notified About Opportunity</td>
                        <td>
                            <asp:CheckBox ID="chkApplicationApproval" runat="server" />
                            Application Approval</td>
                    </tr>
                    <tr>
                        <td>
                            <asp:CheckBox ID="chkApplicationInProgress" runat="server" Checked="true" />
                            Application In Progress</td>
                        <td>
                            <asp:CheckBox ID="chkAccountSetup" runat="server" />
                            Account Setup</td>
                        <td>
                            <asp:CheckBox ID="chkServiceProviderFullyOnBoard" runat="server" />
                            Service Provider Fully On-Board</td>
                    </tr>

                </table>
            </div>
            <!-- Application stage div  Ends-->

            <%--<!-- Welcome text -->
        <div id="weltext" class="sectiondiv">
            <div class="text-block">
             Confirm your contact info is correct! To edit your profile select your IMG or <a href="void(0)">ID#</a> at anytime. Review the below "Sample Tech Task" auto-assigned by job/designation you applied for. Once you review the required <span class="redtext">*</span>Training & Resources files attached below and change your <span class="redtext">*</span>Password, you are confirming that you <span style="text-decoration:underline;" class="redtext">  *accept</span> this task. You will be redirected to your "dashborard/homepage" & Commit/Interview date & time pop up with additional instructions. If you will <span style="text-decoration:underline;" class="redtext">  *accept</span> this task will have a <b>deadline of 24 hours; 3 days; 7days max to complete</b>! Task commit is required to schedule Interview date & time. You will have access to chat with JMGrove human resource rep with any query in next prompt. 
            </div>
        </div>
        <!-- Welcome text ends -->--%>

            <!-- Contact Info -->
            <div id="contactinfo" class="sectiondiv">
                <h3 class="bold-header">Contact Information</h3>
                <span>- Confirm your contact info is correct! To edit your profile select your IMG or <a href="void(0)">ID#</a> at anytime.</span>

                <div class="userlist-grid">
                    <table id="tblProfile" class="header-table">
                        <thead>
                            <tr>
                                <th>Picture</th>
                                <th>ID#<br />
                                    Designation
                        <br />
                                    F&L Name
                                </th>

                                <th>Email
                        <br />
                                    Phone</th>
                                <th>Country - City - Zip
                        <br />
                                    EmploymentType
                                </th>
                            </tr>
                        </thead>
                        <tbody>

                            <tr>
                                <td style="width: 5%;">
                                    <div id="imgProfile" style="width: 100px; height: 100px;">
                                        <asp:Image ID="imgprofile" runat="server"></asp:Image>
                                    </div>

                                </td>
                                <td style="width: 18%;">
                                    <a id="hypExam" runat="server" class="bluetext" href="ViewApplicantUser.aspx?Id=">
                                        <asp:Literal ID="ltlAssignToInstallID" runat="server"></asp:Literal></a><br />
                                    <asp:Label runat="server" ID="lblDisignation"></asp:Label>
                                    <br />
                                    <asp:Label ID="lblFirstName" runat="server"></asp:Label>
                                    <asp:Label ID="lblLastName" runat="server"></asp:Label>
                                </td>
                                <td style="width: 40%;">
                                    <div class="GrdPrimaryEmail">
                                        <asp:LinkButton ID="lbtnEmail" runat="server" />
                                    </div>
                                    <asp:Label ID="lblPrimaryPhone" CssClass="grd-lblPrimaryPhone hide" data-click-to-call="true" runat="server"></asp:Label>
                                    <br />
                                    <div id="useremail">
                                        <asp:CheckBox ID="chkEmailPrimary" CssClass="liCheck" Checked="true" runat="server"></asp:CheckBox>&nbsp;
                                                <asp:DropDownList runat="server" CssClass="mail" ID="ddlEmail"></asp:DropDownList>
                                    </div>
                                    <div id="userphone">
                                        <asp:CheckBox ID="chkPhonePrimary" runat="server" Checked="true"></asp:CheckBox>
                                        <asp:DropDownList runat="server" CssClass="phone" ID="ddlPhone"></asp:DropDownList>
                                        <!-- over here -->
                                        <asp:DropDownList runat="server" Enabled="false" CssClass="typeDrop hide"
                                            ID="ddlPhoneTypeDisplay">
                                        </asp:DropDownList>
                                    </div>

                                    <ul>
                                        <li class="hide">
                                            <asp:DropDownList runat="server" CssClass="typeDrop"
                                                ID="ddlPhoneType" Width="114px">
                                            </asp:DropDownList>
                                            <asp:CheckBox ID="chkPrimary" runat="server"></asp:CheckBox>
                                            <asp:TextBox ID="txtContact" placeholder="Phone" CssClass="phone" runat="server" onkeydown="return validateContact(event, this);"></asp:TextBox>
                                            <!-- over here -->
                                            <asp:Button ID="btnAddContact" CssClass="GrdBtnAdd" runat="server" Text="Add"></asp:Button>
                                        </li>
                                    </ul>
                                    <asp:Label ID="lblExt" CssClass="ext" runat="server" Visible="false"></asp:Label>
                                    <asp:TextBox ID="txtExt" Visible="false" placeholder="Ext" MaxLength="8" CssClass="ext" runat="server"></asp:TextBox>
                                </td>
                                <td style="width: 30%;">
                                    <div id="divCountryCode" runat="server">
                                    </div>
                                    <%--<span><%# Eval("Zip") %></span>--%>
                                    <asp:Label ID="lblCity" runat="server"></asp:Label>
                                    <asp:Label ID="lblZip" runat="server"></asp:Label>
                                    <asp:DropDownList ID="ddlEmployeeType" Style="width: 95%;" runat="server" onchange="setEmployeeType(this)">
                                        <asp:ListItem Text="Select" Value="0"></asp:ListItem>
                                        <asp:ListItem Text="Part Time - Remote" Value="1"></asp:ListItem>
                                        <asp:ListItem Text="Full Time - Remote" Value="2"></asp:ListItem>
                                        <asp:ListItem Text="Part Time - Onsite" Value="3"></asp:ListItem>
                                        <asp:ListItem Text="Full Time - Onsite" Value="4"></asp:ListItem>
                                        <asp:ListItem Text="Internship" Value="5"></asp:ListItem>
                                        <asp:ListItem Text="Temp" Value="6"></asp:ListItem>
                                        <asp:ListItem Text="Sub" Value="7"></asp:ListItem>
                                    </asp:DropDownList></td>
                            </tr>
                        </tbody>
                    </table>
                </div>

            </div>
            <!-- Contact Info ends -->

            <!-- Interview Task text -->
            <div id="IntTasktext" class="sectiondiv">
                <h3 class="bold-header">Interview Sample Tech Task</h3>
                <%--<div class="text-block">
                Review the below Interview Sample Tech Task link
                <a id="hypTaskLink" target="_blank" style="color: blue;" runat="server" href="#">
                    <asp:Literal ID="ltlTaskInstallID" runat="server">Tasklinkhere</asp:Literal>
                </a>of tech task auto-assigned by job/designation you selected. After you review below mandatory <span class="redtext">*</span>Training & Resources, <span class="redtext">*</span>Change Password & <span class="redtext">*</span>Accept the task you will be redirected to your Home Page with further instructions to schedule an "Interview Date".                
                Once you accept the task, you will have 7 business days to commit Interview Sample Tech Task and schedule Interview Date with your assignement.
            </div>--%>
                <div class="text-block">
                    Review the below Interview Sample Tech Task link <a id="hypTaskLink" target="_blank" style="color: blue;" runat="server" href="#">
                        <asp:Literal ID="ltlTaskInstallID" runat="server">Tasklinkhere</asp:Literal>
                    </a>of tech task auto-assigned by job/designation you selected. After you review below mandatory <span class="redtext">*</span>Training & Resources, <span class="redtext">*</span>Change Password & <span class="redtext" style="text-decoration: underline;">*Accept</span> the task 
you will be redirected to your Home Page with further instructions to schedule an "Interview Date". If you <span style="text-decoration: underline;" class="redtext">*Accept</span> this task, you will have a <b>deadline of 24 hours; 3 days; 7days max to complete</b>! A sample Task commit is required to schedule Interview date & time.
                </div>
            </div>
            <!-- Interview Task text ends -->


            <!-- Interview Task -->
            <div id="interviewtask" class="sectiondiv">

                <div id="divTaskAssigned" visible="true" runat="server" class="ExpandedTask">

                    <!-- Parent Task Grid Starts -->
                    <div>
                        <div id="divTechAssignment" class="hide">
                        </div>
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

                                <div class="div-table-col seq-notes">Notes</div>
                            </div>
                            <div id="divMasterTask" class="div-table-row">

                                <!-- Sequence# starts -->
                                <div class="div-table-col seq-number">
                                    <a href="javascript:void(0);" class="badge-hyperlink autoclickSeqEdit"><span class="badge badge-success badge-xstext">
                                        <label id="lblSeqtask" runat="server"></label>
                                    </span></a>
                                </div>
                                <!-- Sequence# ends -->

                                <!-- ID# and Designation starts -->
                                <div class="div-table-col seq-taskid">
                                    <a id="hypTaskLink1" runat="server" class="bluetext" target="_blank"></a>
                                    <br />
                                    <asp:Literal ID="ltlUDesg" runat="server"></asp:Literal>

                                </div>
                                <!-- ID# and Designation ends -->

                                <!-- Parent Task & SubTask Title starts -->
                                <div class="div-table-col seq-tasktitle">
                                    <asp:Literal ID="ltlParentTask" runat="server"></asp:Literal>
                                    <br />
                                    <asp:Literal ID="ltlTaskTitle" runat="server"></asp:Literal>
                                </div>
                                <!-- Parent Task & SubTask Title ends -->

                                <!-- Notes starts -->
                                <div class="div-table-col seq-notes">
                                    Notes
                                </div>
                                <!-- Notes ends -->

                            </div>
                        </div>
                    </div>
                    <!-- Parent Task Grid ends -->

                    <!-- Roman Grid Starts -->
                    <div class="div-table-row roman-grid" id="roman_{{Task.TaskId}}">

                        <div id="romanList_{{Task.TaskId}}" class="section-container">
                            <div class="div-table-row" id="roman-head{{Task.TaskId}}">
                                <div class="div-table-col roman-col-margin"></div>
                                <div class="div-table-col roman-col-expand"></div>
                                <div class="div-table-col roman-col-id">ID#</div>
                                <div class="div-table-col roman-col-title">Title: Content</div>
                                <div class="div-table-col roman-col-assign"></div>
                            </div>
                            <div class="div-table-row" id="LoadingRomansDiv{{Task.TaskId}}">
                                <div class="div-table-col roman-col-margin"></div>
                                <div class="div-table-col roman-col-expand">
                                </div>
                                <div class="div-table-col roman-col-id ng-binding"></div>
                                <div class="div-table-col roman-col-share">
                                </div>
                                <div class="div-table-col roman-col-title-content">
                                    <div style="float: right;" id="LoadingRomans{{Task.TaskId}}">
                                        Loading full task, Please wait...
                                    </div>
                                </div>
                                <div class="div-table-col roman-col-assign">
                                </div>
                                <div class="div-table-col roman-col-user-status">
                                </div>
                                <div class="div-table-col roman-col-notes">
                                </div>
                            </div>
                            <div class="div-table-row" ng-class-even="'roman-row-alternate'" ng-class-odd="'roman-row'" data-romanid="{{Roman.Id}}" ng-repeat="Roman in Romans" ng-class="{'parent': Roman.IndentLevel ==1, 'child': Roman.IndentLevel ==2 || Roman.IndentLevel ==3}" repeat-end="onTaskExpand({{Task.TaskId}})">
                                <div class="div-table-col roman-col-margin" ng-class="{'col-margin-nested-child': Roman.IndentLevel ==2 , 'col-margin-nested-child-level3': Roman.IndentLevel ==3}"></div>
                                <div class="div-table-col roman-col-expand" ng-hide="Roman.IndentLevel == 2 || Roman.IndentLevel == 3">
                                    <%--<a href="#/">
                                <img class="expand-image" src="../img/btn_maximize.png" data-taskid="{{Task.TaskId}}" onclick="expandRomansFromRoman(this)" data-appended="false" />
                            </a>
                            
                            <input type="checkbox" class="roman-query-checkbox" data-romanid="{{Roman.Id}}" />--%>
                                    <div class="roman-col-share hide-div">
                                        <img src="../../img/icon_share.JPG" data-taskfid="{{Task.InstallId1}}" data-tasktitle="{{Task.Title}}"
                                            data-assigneduserid="{{Roman.TaskAssignedUserIDs}}" data-uname="{{Task.TaskAssignedUsers}}" class="share-icon installidleft"
                                            onclick="sharePopup(this, true)" data-highlighter="{{Task.TaskId}}" style="color: Blue; cursor: pointer; display: inline;" />

                                    </div>
                                </div>
                                <div class="div-table-col roman-col-id"><a href="../Sr_App/TaskGenerator.aspx?TaskId={{Task.MainParentId}}&hstid={{Task.TaskId}}&mcid={{Roman.Id}}" target="_blank">{{Roman.Label}}</a></div>
                                <div class="div-table-col roman-col-title-content">
                                    <div ng-bind-html="Roman.Title | trustAsHtml" class="roman-title"></div>
                                    <div ng-bind-html="Roman.Description | trustAsHtml"></div>
                                    <%--  <div style="float: right; text-decoration: underline; color: blue; cursor: pointer;">View/Ask Query</div>--%>
                                </div>
                                <div class="div-table-col roman-col-assign" ng-hide="Roman.IndentLevel == 2 || Roman.IndentLevel == 3">
                                    <select id="drpStatusRoman{{Roman.Id}}" onchange="changeTaskStatusRoman(thiils);" data-highlighter="{{Roman.Id}}">

                                        <option ng-selected="{{Roman.Status == 20}}" value="20">Request-Assigned-Step 1</option>
                                        <option ng-selected="{{Roman.Status == 21}}" value="21">Request-Assigned-Step 2</option>
                                        <option ng-selected="{{Roman.Status == 22}}" value="22">Request-Assigned-Step 3</option>

                                        <option ng-selected="{{Roman.Status == 4}}" value="4">InProgress</option>

                                        <option ng-selected="{{Roman.Status == 3}}" style="color: lawngreen" value="3">Request-Assigned</option>
                                        <option ng-selected="{{Roman.Status == 1}}" value="1">Open</option>
                                        <option ng-selected="{{Roman.Status == 11}}" value="11">Test Commit</option>

                                    </select>
                                    <select class="ddlAssignedUsersRomans" disabled
                                        id="ddcbSeqAssignedStaffRomans{{Roman.Id}}" multiple
                                        ng-attr-data-assignedusers="{{Roman.TaskAssignedUserIds}}" data-chosen="11"
                                        data-placeholder="Select Users" onchange="EditSeqAssignedTaskUsersRoman(this);"
                                        data-taskid="{{Roman.Id}}" data-taskstatus="{{Roman.Status}}"
                                        ng-class="{'parent': Roman.IndentLevel ==1, 'child hide': Roman.IndentLevel ==2 || Roman.IndentLevel ==3}">
                                        <option
                                            ng-repeat="item in DesignationAssignUsers"
                                            value="{{item.Id}}"
                                            label="{{item.FristName}}"
                                            class="{{item.CssClass}}">{{item.FristName}}
                                        </option>
                                    </select>
                                </div>
                                <div class="div-table-col roman-col-user-status" data-ng-hide="Roman.IndentLevel == 2 || Roman.IndentLevel == 3">
                                    <input type="checkbox" data-taskid="{{Roman.Id}}" onchange="ShowFeedbackFreezePopup(this)" id="chkngAdmin{{Roman.Id}}" ng-checked="" ng-disabled="" class="fz fz-admin" title="Admin">
                                    <input type="checkbox" data-taskid="{{Roman.Id}}" onchange="ShowFeedbackFreezePopup(this)" id="chkngITLead{{Roman.Id}}" ng-checked="{{Roman.EstimatedHoursITLead}}" ng-disabled="{{Roman.EstimatedHoursITLead}}" class="fz fz-techlead" title="IT Lead">
                                    <input type="checkbox" data-taskid="{{Roman.Id}}" onchange="ShowFeedbackFreezePopup(this)" id="chkngUserMaster{{Roman.Id}}" ng-checked="{{Roman.EstimatedHoursUser}}" ng-disabled="{{Roman.EstimatedHoursUser}}" class="fz fz-user" title="User">
                                    <input type="checkbox" data-taskid="{{Roman.Id}}" onchange="ShowFeedbackFreezePopup(this)" id="chkAlphaUserMaster{{Roman.Id}}" class="fz fz-Alpha" title="AlphaUser">
                                </div>
                                <div class="div-table-col roman-col-notes" ng-hide="Roman.IndentLevel == 2 || Roman.IndentLevel == 3">
                                    <div class="notes-section" userchatgroupid="{{Roman.UserChatGroupId}}" taskid="{{Roman.ParentTaskId}}" taskmultilevellistid="{{Roman.Id}}" style="position: relative; overflow-x: hidden; overflow-y: auto; min-height: 90px;">
                                        <!-- Notes starts -->
                                        <div class="note-list" style="height: 60px;">
                                            <table
                                                data-parenttaskid="{{Roman.ParentTaskId}}" data-romanid="{{Roman.Id}}"
                                                data-recids="{{Roman.ReceiverIds}}" data-userchatgroupid="{{Roman.UserChatGroupId}}"
                                                onclick="openChatPopup(this)" class="notes-table" cellspacing="0" cellpadding="0">
                                                <tr ng-repeat="Note in Roman.Notes" ng-if="Roman.Notes">
                                                    <td>{{Note.SourceUsername}}- <a target="_blank" href="/Sr_App/ViewSalesUser.aspx?id={{Note.UpdatedByUserID}}">{{Note.SourceUserInstallId}}</a><br>
                                                        {{Note.ChangeDateTimeFormatted}}</td>
                                                    <td title="{{Note.LogDescription}}">
                                                        <div class="note-desc">{{Note.LogDescription}}</div>
                                                    </td>
                                                </tr>
                                            </table>
                                        </div>
                                        <div class="notes-inputs">
                                            <div class="first-col">
                                                <input type="button" class="GrdBtnAdd" value="Add Notes" onclick="addNotes(this)">
                                            </div>
                                            <div class="second-col">
                                                <textarea class="note-text textbox"></textarea>
                                            </div>
                                        </div>
                                        <!-- Notes ends -->
                                    </div>
                                </div>
                            </div>
                        </div>
                        <div class="div-table-row">
                            <div class="div-table-col roman-col-margin"></div>
                            <div class="div-table-col roman-col-expand">
                            </div>
                            <div class="div-table-col roman-col-id ng-binding"></div>
                            <div class="div-table-col roman-col-share">
                            </div>
                            <div class="div-table-col roman-col-title-content hide">
                                <div style="float: right;">
                                    <button data-parent-taskid="{{Task.TaskId}}" data-val-commandname="{{Task.TaskLevel}}#{{Task.InstallId1}}#{{Task.TaskId}}#1"
                                        data-val-tasklvl="{{Task.TaskLevel}}" data-val-commandargument="{{Task.TaskId}}"
                                        data-installid="{{Task.InstallId}}"
                                        type="button" id="lbtnAddNewSubTask{{Task.TaskId}}" onclick="javascript:OpenAddTaskPopup(this);"
                                        style="color: Blue; text-decoration: underline; cursor: pointer; background: none;">
                                        Add New Task</button>
                                    <span style="margin-right: 8px;">|</span>
                                    <button type="button" onclick="javascript:SelectAllRoman(this);" data-taskid="{{Task.TaskId}}"
                                        style="color: Blue; text-decoration: underline; cursor: pointer; background: none;">
                                        Select All</button>
                                    <span style="margin-right: 8px; margin-left: 8px">|</span>
                                    <a href="../Sr_App/TaskGenerator.aspx?TaskId={{Task.MainParentId}}&hstid={{Task.TaskId}}" class="bluetext context-menu"
                                        target="_blank">View Task Expanded</a>
                                </div>
                            </div>
                            <div class="div-table-col roman-col-assign">
                            </div>
                            <div class="div-table-col roman-col-user-status">
                            </div>
                            <div class="div-table-col roman-col-notes">
                            </div>
                        </div>
                    </div>
                    <!-- Roman Grid End -->

                </div>

            </div>
            <!-- Interview Task ends -->

            <!-- Carrer Path -->
            <div id="cpath" class="sectiondiv">
                <h3 class="bold-header">Carrer Path at JMGrove</h3>
                <div id="dcpath" class="crpath">
                    <asp:Literal ID="ltlCPath" runat="server"></asp:Literal>
                </div>
            </div>
            <!-- Carrer Path ends -->

            <!-- Training and Resource -->
            <div id="tandr" class="sectiondiv clearfix">
                <div id="divPwd">
                    <span class="redtext">*</span>Change Password:
                                            
                                            <input id="txtpassword" class="hide" style="width: 100%" type="password" maxlength="30" placeholder="New password of your choice" />
                    <asp:TextBox ID="txtPassword" runat="server" placeholder="New password of your choice" MaxLength="30" CssClass="textbox"></asp:TextBox>
                    <br />
                    <br />
                    <span class="redtext">*</span><%--<input type="submit" id="btnAccept" onclick="return AcceptTask();" value="Accept" class="btn-jg" />--%>
                    <asp:Button ID="btnAcceptTask" Text="Accept" ValidationGroup="vgCPWD" CssClass="btn-jg" runat="server" OnClientClick="return AcceptTask();" OnClick="btnAcceptTask_Click" />
                    <input type="submit" id="btnReject" value="Reject" class="btn-jg" />
                    <br />
                    <div class="text-block" style="border: 1px solid #0f0e0e; margin-top: 10px;">
                        You will have access to chat with JMGrove human resource representative with any query in next prompt. 
                    </div>

                    <div class="text-block center" ><a href="void(0);">Recruiter-REC00x</a></div>
                    
                </div>
                <div id="tnrResources">
                    <h3 class="bold-header"><span class="redtext">*</span> Training and Resources</h3>
                    <div id="tnrListing">
                        <div class="tab__content">
                            <ul class="tree-parent">
                                <li data-ng-repeat="module in DesignationResources" class="tree-parent">
                                    <span class="tree-desg">{{module.Title}}</span>
                                    <ul class="tree-child">
                                        <li data-ng-repeat="subModule in module.Categories">
                                            <img src="../img/minus.png" class="icons tree-minus" />
                                            <img src="../img/plus.png" class="icons tree-plus" style="display: none;" />
                                            <img src="../img/folder.png" width="16" height="16" class="icons" />
                                            {{subModule.Title}}
                                 <ul class="tree-child-files">
                                     <li data-ng-repeat="subModule1 in subModule.Categories">
                                         <%--<a target="_blank" href="Upload/Resources/{{subModule1.DesignationId}}/{{subModule.Title}}/{{subModule1.UniqueName}}">{{subModule1.Title}}</a>--%>
                                         <input id="filePath-{{subModule1.ID}}" type="hidden" value="Upload/Resources/{{subModule1.DesignationId}}/{{subModule.Title}}/{{subModule1.UniqueName}}" />
                                         <a id="lnkFile-{{subModule1.ID}}" onclick="SetPreview(event)">{{subModule1.Title}}</a>
                                         <img src="../img/video-icon1.png" class="icons icon-right icon-video" ng-if="subModule1.Type == 1" />
                                         <img src="../img/image-icon1.png" class="icons icon-right icon-image" ng-if="subModule1.Type == 2" />
                                         <img src="../img/file.png" class="icons icon-right" ng-if="subModule1.Type == 3" />
                                     </li>
                                 </ul>
                                        </li>
                                    </ul>
                                </li>
                            </ul>
                        </div>
                    </div>

                </div>
                <div id="tnrDisplay" style="height: 450px;">
                    <video id="def-intro" width="320" height="240" controls>
                  <source src="movie.mp4" type="video/mp4">
                  <source src="movie.ogg" type="video/ogg">
                  Your browser does not support the video tag.
                </video>
                    <%--<video id="def-intro" autoplay style="max-width:100%;display:none;" controls data-setup="{}">
                    <source src="movie.mp4" type="video/mp4">
                </video>--%>
                    <a href="{{FileSourceURL}}" id="lnkTR" style="display: none;" target="_blank">
                        <image src="{{FileSourceURL}}" style="max-width: 100%;" id="imgTR"></image>
                    </a>
                    <a href="{{FileSourceURL}}" id="lnkTR1" style="display: none;" target="_blank">
                        <h1>Download</h1>
                    </a>
                    <%--<iframe id="lnkTR2" src="{{FileSourceURL}}" style="display:none;" style="max-width:100%;"></iframe>--%>
                </div>
                <div class="clearfix"></div>
            </div>
            <!-- Training and Resource ends -->

            <!-- Legal Disclaimer -->
            <div id="ldesc" class="sectiondiv">
                <h3 class="bold-header">Legal Disclaimer</h3>
                <div id="dcpath" class="crpath">
                    <asp:Literal ID="ltlLegal" runat="server"></asp:Literal>
                </div>
            </div>
            <!-- Legal Disclaimer -->

            <input type="hidden" id="hdnDefIntroV" runat="server" />
            <input type="hidden" id="hdnUDID" runat="server" />
            <input type="hidden" id="hdnAssignTaskId" runat="server" />
            <input type="hidden" id="hdnParentTaskId" runat="server" />
        </div>
    </div>
    <script type="text/javascript" src="js/jquery-ui.js"></script>
    <script type="text/javascript" src="js/jquery.dd.min.js"></script>
    <script type="text/javascript" src="js/intTel/intlTelInput.js"></script>
    <script type="text/javascript" src="https://vjs.zencdn.net/7.0.3/video.js" type="text/javascript"></script>
    <script type="text/javascript" src="js/angular/scripts/jgapp.js"></script>
    <script type="text/javascript" src="js/angular/scripts/ngpostapptitude.js"></script>
    <script type="text/javascript" src="js/postapptitude.js"></script>

    <script type="text/javascript">

        var UserDesignationId = '#<%=hdnUDID.ClientID%>';
        var UserAssignTaskId = '#<%=hdnAssignTaskId.ClientID%>';
        var UserAssignTaskParentId = '#<%=hdnParentTaskId.ClientID%>';
        var DefIntrov = '#<%= hdnDefIntroV.ClientID%>';
        var txtPwd = '#<%=txtPassword.ClientID%>';
    </script>
</asp:Content>
