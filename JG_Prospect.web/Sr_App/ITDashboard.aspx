<%@ Page Title="" Language="C#" MasterPageFile="~/Sr_App/SR_app.Master" AutoEventWireup="true" EnableEventValidation="false" CodeBehind="ITDashboard.aspx.cs" Inherits="JG_Prospect.Sr_App.ITDashboard" %>

<%@ Register Src="~/Sr_App/LeftPanel.ascx" TagName="LeftPanel" TagPrefix="uc2" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<%@ Register TagPrefix="asp" Namespace="Saplin.Controls" Assembly="DropDownCheckBoxes" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <style>
        .notes-container.div-table-col.seq-notes-fixed-top.main-task {
            height: 60px;
        }

        .div-table-col.seq-notes-fixed-top.sub-task {
            width: 308px;
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

        .clsTestMail {
            padding: 20px;
            font-size: 14px;
        }

            .clsTestMail input[type='text'] {
                padding: 5px;
            }

            .clsTestMail input[type='submit'] {
                background: #000;
                color: #fff;
                padding: 5px 7px;
                border: 1px solid #808080;
            }

                .clsTestMail input[type='submit']:hover {
                    background: #fff;
                    color: #000;
                    cursor: pointer;
                }

        .table tr {
            border: solid 1px #fff;
        }

        .modalBackground {
            background-color: #333333;
            filter: alpha(opacity=70);
            opacity: 0.7;
            z-index: 100 !important;
        }

        .modalPopup {
            background-color: #FFFFFF;
            border-width: 1px;
            border-style: solid;
            border-color: #CCCCCC;
            padding: 1px;
            width: 900px;
            Height: 550px;
            overflow-y: auto;
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

        .ui-autocomplete {
            z-index: 999999999 !important;
            max-height: 250px;
            overflow-y: auto;
            overflow-x: hidden;
        }

        .pagination-ys {
            padding-left: 0;
            margin: 5px 0;
            border-radius: 4px;
            align-content: flex-end;
            line-height: none !important;
        }

            .pagination-ys td {
                border: none !important;
            }

            .pagination-ys table > tbody {
                height: unset !important;
            }

                .pagination-ys table > tbody > tr > td {
                    display: inline !important;
                    background: none;
                    border: none !important;
                }

                    .pagination-ys table > tbody > tr > td > a,
                    .pagination-ys table > tbody > tr > td > span {
                        position: relative;
                        float: left;
                        padding: 8px 12px;
                        line-height: 1.42857143;
                        text-decoration: none;
                        color: #dd4814;
                        background-color: #ffffff;
                        border: 1px solid #dddddd;
                        margin-left: -1px;
                    }

                    .pagination-ys table > tbody > tr > td > span {
                        position: relative;
                        float: left;
                        padding: 8px 12px;
                        line-height: 1.42857143;
                        text-decoration: none;
                        margin-left: -1px;
                        z-index: 2;
                        color: #aea79f;
                        background-color: #f5f5f5;
                        border-color: #dddddd;
                        cursor: default;
                    }

                    .pagination-ys table > tbody > tr > td:first-child > a,
                    .pagination-ys table > tbody > tr > td:first-child > span {
                        margin-left: 0;
                        border-bottom-left-radius: 4px;
                        border-top-left-radius: 4px;
                    }

                    .pagination-ys table > tbody > tr > td:last-child > a,
                    .pagination-ys table > tbody > tr > td:last-child > span {
                        border-bottom-right-radius: 4px;
                        border-top-right-radius: 4px;
                    }

                    .pagination-ys table > tbody > tr > td > a:hover,
                    .pagination-ys table > tbody > tr > td > span:hover,
                    .pagination-ys table > tbody > tr > td > a:focus,
                    .pagination-ys table > tbody > tr > td > span:focus {
                        color: #97310e;
                        background-color: #eeeeee;
                        border-color: #dddddd;
                    }

        /*.dashboard tr {
        display: flex;
    }

   .pagination-ys td {
        border-spacing: 0px !important;
        flex: 1 auto;
        word-wrap: break-word;
        background: none !important;
        line-height: none !important;
    }

    .dashboard thead tr:after {
        content:'';
        overflow-y: scroll;
        visibility: hidden;
        height: 0;
    }
 
    .dashboard thead th {
        flex: 1 auto;
        display: block;
        background-color: #000 !important;
    }

    .dashboard tbody {
        display: block;
        width: 100%;
        overflow-y: auto;
        height: 370px;
    }*/

        table.table tr.trHeader {
            background: none !important;
        }

        table.table th {
            border: none;
        }

        .dashboard tr {
            display: flex;
        }

        .dashboard td {
            border-spacing: 0px !important;
            padding: 3px !important;
            flex: 1 auto;
            word-wrap: break-word;
            background: none !important;
            padding: 3px 0 0 0 !important;
            line-height: none !important;
        }

        .dashboard thead tr:after {
            content: '';
            overflow-y: scroll;
            visibility: hidden;
            height: 0;
        }

        .dashboard thead th {
            flex: 1 auto;
            display: block;
            padding: 0px;
            background-color: #000;
        }


            .dashboard thead th:first-child {
                border-top-left-radius: 4px;
            }

            .dashboard thead th:last-child {
                border-top-right-radius: 4px;
            }


        .dashboard tbody {
            display: block;
            width: 100%;
            overflow-y: auto;
            height: 370px;
        }

        .tableFilter tbody tr td {
            padding: 10px;
        }

        .itdashtitle {
            margin-left: 7px;
        }

        .orange {
            background-color: orange;
            color: black;
        }

        .yellow {
            background-color: yellow;
            color: black;
        }

            .yellow span.parent-task-title {
                color: red;
            }

        .gray {
            background-color: Gray;
        }

        .red {
            background-color: red;
            color: white;
        }

            .red span.parent-task-title {
                color: white;
            }

        .black {
            background-color: black;
            color: white;
        }

            .black span.parent-task-title {
                color: red;
            }

        .lightgray {
            background-color: lightgray;
        }

        .green {
            background-color: green;
            color: white;
        }

            .green span.parent-task-title {
                color: white;
            }

        .defaultColor {
            background-color: #F6F1F3;
        }

        span.parent-task-title {
            color: red;
        }

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

        .GrdBtnAdd {
            margin-top: 12px;
            height: 30px;
            background: url(img/main-header-bg.png) repeat-x;
            color: #fff;
            cursor: pointer;
            border-radius: 5px;
        }

        .refresh {
            height: 20px;
            cursor: pointer;
            box-shadow: 0 2px 5px 0 rgba(0, 0, 0, 0.26);
            padding: 5px;
            background-color: #fff;
            vertical-align: middle;
            margin: 10px;
        }

        #ViewTab {
            width: 100%;
            float: right;
        }

        #ContentPlaceHolder1_lblalertpopup {
            float: left;
        }

        #ViewTab ul {
            position: absolute;
            top: 305px;
            margin-right: 19px;
        }

        .noData {
            width: 100%;
            clear: both;
            text-align: center;
            line-height: 50px;
            font-size: 15px;
        }

        .hours-col {
            line-height: 30px;
        }

        #ddlDesignationSeq_chosen ul.chosen-choices {
            max-height: 58px;
            overflow-y: auto;
        }

        .seq-number-fixed {
            width: 120px;
        }

        .seq-taskid-fixed {
            /*width: 130px;*/
            width: 70px;
        }

        .seq-tasktitle-fixed {
            width: 200px;
        }

        .seq-taskstatus-fixed {
            width: 150px;
        }

        .seq-taskduedate-fixed {
            width: 100px;
        }

        .seq-notes-fixed {
            width: 40%;
        }

        .seq-notes-fixed {
            width: 33%;
        }

        #taskSequence {
            margin-top: 42px;
        }

        .query-header {
            padding: 15px;
            font-size: 18px;
            color: #8e0001;
        }

        .query-section {
            background-color: #fff;
            margin-bottom: 20px;
            margin-top: 20px;
            border-radius: 5px;
            border-spacing: 5px;
            padding: 10px;
            font-family: calibri;
            font-size: 13px;
        }

        .query-row {
            margin-left: 10px;
            display: inline-flex;
            width: 100%;
            min-height: 47px;
        }

        .query-row-header {
            margin-left: 10px;
            display: inline-flex;
            width: 100%;
            font-weight: bold;
            border-bottom: #d0d0d0;
            border-bottom-style: solid;
            border-bottom-width: 1px;
        }

        .query-col {
            padding: 5px;
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
            display: none;
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
        /*input:not([type=radio]), select {
            width: 90%;
            padding: 5px;
            border-radius: 5px;
        }*/

        .w3-light-greypop {
            color: #000 !important;
            border: 2px solid #9e9e9e !important;
            border-bottom: 5px solid #9e9e9e !important;
        }

        .w3-greypop {
            color: #fff !important;
            font-weight:bold;
            background-color: #b94c4f!important;
            height: 18px;
            width: 0%;
            
        }

        .header-tablepop {
            padding: 15px 0 0 15px;
        }

            .header-tablepop tr {
                line-height: 1.75;
            }

            .header-tablepop input[type=checkbox] {
                width: auto;
            }

            .header-tablepop td:nth-child(1) {
                width: 40%
            }

            .header-tablepop td:nth-child(2) {
                width: 40%
            }

            .header-tablepop td:nth-child(3) {
                width: 20%
            }

    </style>
    <link href="../css/chosen.css" rel="stylesheet" />
    <link href="../Styles/dd.css?v=<%#JG_Prospect.Common.modal.SingletonGlobal.Instance.RandomGUID %>" rel="stylesheet" />
    <link href="../Content/touchPointlogs.css?v=<%#JG_Prospect.Common.modal.SingletonGlobal.Instance.RandomGUID %>" rel="stylesheet" />
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <input type="hidden" id="ContentPlaceHolder1_objucSubTasks_Admin_hdnGridAttachment" />
    <div class="right_panel">
        <!-- Share Popup Starts -->
        <div id="myModal" class="modal">
            <!-- Modal content -->
            <div class="modal-content">
                <div class="modal-header">
                    <span class="close">&times;</span>
                    <div>
                        <a id="lnkShare" class="header-tab">Share</a>
                        <%--|<a id="lnkMove" class="header-tab">Move</a>--%>
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
                        <button id="btnDelete" onclick="return false;" class="mui-btn mui-btn--small mui-btn--primary mui-btn--flat left">Delete</button>
                        <span class="search-label" style="color: red;">Search: Email</span>
                        <button id="btnShare" onclick="return false;" class="mui-btn mui-btn--small mui-btn--primary mui-btn--flat">Share</button>
                        <button id="btnCopy" class="mui-btn mui-btn--small mui-btn--primary mui-btn--flat">Copy</button>
                    </div>
                </div>
                <%--<div id="divMove">
                        <div class="modal-body">
                            <span><strong>TO</strong></span>
                            <select class="task-dropdown" onchange="GetChildTasks(this)" id="ddlRootTasks">
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
                    </div>--%>
                <div class="users-container"></div>
            </div>
        </div>
        <!-- Share Popup Ends-->

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
                                <cc1:CalendarExtender ID="Calendarextender4" runat="server" TargetControlID="txtDateFromRoman"></cc1:CalendarExtender>
                                <br />

                            </div>
                            <div class="div-table-col div-col-middle">End Date:</div>
                            <div class="div-table-col smalll-col">
                                <asp:TextBox ID="txtDateToRoman" runat="server" TabIndex="2" CssClass="dateToRoman smart-text"
                                    onkeypress="return false" MaxLength="10"></asp:TextBox>
                                <cc1:CalendarExtender ID="calExtendToDate" runat="server" TargetControlID="txtDateToRoman"></cc1:CalendarExtender>
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
                        <%--<div class="row">
                            <div class="div-table-col div-col-middle">Task Status</div>
                            <div class="div-table-col div-col-middle smalll-col">
                                <select id="drpRomanTaskStatus" onchange="changeTaskStatusRoman(this);" data-highlighter="{{Roman.Id}}">
                                    <option ng-selected="{{Roman.Status == '1'}}" value="1">Open</option>
                                    <option ng-selected="{{Roman.Status == '2'}}" style="color: red" value="2">Requested</option>
                                    <option ng-selected="{{Roman.Status == '3'}}" style="color: lawngreen" value="3">Assigned</option>
                                    <option ng-selected="{{Roman.Status == '4'}}" value="4">InProgress</option>
                                    <option ng-selected="{{Roman.Status == '5'}}" value="5">Pending</option>
                                    <option ng-selected="{{Roman.Status == '6'}}" value="6">ReOpened</option>
                                    <option ng-selected="{{Roman.Status == '7'}}" value="7">Closed</option>
                                    <option ng-selected="{{Roman.Status == '8'}}" value="8">SpecsInProgress</option>
                                    <option ng-selected="{{Roman.Status == '10'}}" value="10">Finished</option>
                                    <option ng-selected="{{Roman.Status == '11'}}" value="11">Test</option>
                                    <option ng-selected="{{Roman.Status == '12'}}" value="12">Live</option>
                                    <option ng-selected="{{Roman.Status == '14'}}" value="14">Billed</option>
                                    <option ng-selected="{{Roman.Status == '9'}}" value="9">Deleted</option>
                                </select>
                            </div>
                            <br />
                        </div>--%>
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

        <!-- Add New Task Popup Starts -->
        <div id="myModalAddTask" class="modal">
            <!-- Modal content -->
            <div class="modal-content addTaskPopup" ng-controller="TaskGeneratorController">
                <div class="ui-dialog-titlebar ui-widget-header ui-corner-all ui-helper-clearfix ui-draggable-handle">
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
                            <select data-placeholder="Select Designation" class="chosen-dropdown" multiple id="ddlTasksDesignations">
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
                            </select>
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
                        <div class="div-table-col">
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
                                    <img src="../img/delete.jpg" alt="Delete" data-childid="{{Child.Id}}" onclick="DeleteChild(this, true)" /></div>
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
        <!-- Add New Task Popup Ends -->
        <!-- appointment tabs section start -->
        <ul class="appointment_tab">
            <li><a href="home.aspx">Sales Calendar</a></li>
            <li><a href="GoogleCalendarView.aspx">Master  Calendar</a></li>
            <li><a class="active" href="ITDashboard.aspx">Operations Calendar</a></li>
            <li><a href="CallSheet.aspx">Call Sheet</a></li>
            <li id="li_AnnualCalender" visible="false" runat="server"><a href="#" runat="server">Annual Event Calendar</a> </li>
        </ul>
        <!-- appointment tabs section end -->
        <h1><b>IT Dashboard</b></h1>
        <%--     <asp:Panel ID="pnlTestEmail" Visible="false" GroupingText="Test E-Mail" runat="server" CssClass="clsTestMail">
            <asp:TextBox ID="txtTestEmail" runat="server"></asp:TextBox>
            <asp:Button ID="btnTestMail" runat="server" Text="Send Mail" OnClick="btnTestMail_Click" />
            <br />
            <asp:Label runat="server" ID="lblMessage"></asp:Label>
        </asp:Panel>--%>

        <%--<asp:UpdatePanel runat="server" ID="upAlerts"><ContentTemplate>--%>

        <div id="ViewTab">
            <h2 runat="server" id="lblalertpopup">Alerts:
            <a id="lblNonFrozenTaskCounter" runat="server" style="cursor: pointer">NA</a>
                <a id="lblFrozenTaskCounter" runat="server" style="cursor: pointer">NA</a>
            </h2>
            <ul class="appointment_tab">
                <li><a href="ITDashboard.aspx" class="active">Tasklist View</a></li>
                <li><a href="ITDashboardCalendar.aspx">Calendar View</a></li>
            </ul>
        </div>

        <!--  ------- Start DP new/frozen tasks popup ------  -->
        <div id="pnlNewFrozenTask" class="modal hide">
            <button id="btnFake" style="display: none" runat="server"></button>
            <div id="taskFrozen" ng-controller="FrozenTaskController">

                <table class="table" runat="server" id="table1" style="width: 100%">
                    <tr>
                        <td width="30%">
                            <h2 class="itdashtitle">Partial Frozen Tasks</h2>
                        </td>
                        <td>Designation</td>
                        <td>Users</td>
                        <td></td>
                    </tr>
                    <tr>
                        <td></td>
                        <td>
                            <select data-placeholder="Select Designation" class="chosen-dropdown-FrozenTasks" multiple style="width: 100%;" id="ddlFrozenTasksDesignations">
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
                                <%--<option value="15">Installer - Journeyman</option>--%>
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
                            <select id="ddlSelectFrozenTask" data-placeholder="Select Users" multiple style="width: 350px; padding: 0 10px;" class="chosen-select-frozen">
                                <option selected value="">All</option>
                            </select><span id="lblLoadingFrozen" style="display: none">Loading...</span>
                        </td>
                        <td>
                            <input id="txtSearchUserFrozen" class="textbox ui-autocomplete-input" maxlength="15" placeholder="search users" type="text" style="margin-top: 14px" />
                        </td>
                    </tr>
                </table>

                <div id="taskSequenceTabsFrozen">
                    <ul>
                        <li><a href="#StaffTaskFrozen">Staff Tasks</a></li>
                        <li><a href="#TechTaskFrozen">Tech Tasks</a></li>
                    </ul>
                    <div id="StaffTaskFrozen">
                        <div id="tblStaffSeqFrozen" class="div-table tableSeqTask">
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
                            <!-- NG Repeat Div starts -->
                            <div ng-attr-id="divMasterTaskFrozen{{Task.TaskId}}" class="div-table-row" data-ng-repeat="Task in FrozenTask" ng-class="{orange : Task.Status==='4', yellow: Task.Status==='2', yellow: Task.Status==='3', lightgray: Task.Status==='8'}" repeat-end="onStaffEnd()">
                                <!-- Sequence# starts -->
                                <div class="div-table-col seq-number">
                                    <a ng-attr-id="autoClickFrozen{{Task.TaskId}}" href="javascript:void(0);" class="badge-hyperlink autoclickSeqEdit" ng-attr-data-taskseq="{{Task.Sequence}}" ng-attr-data-taskid="{{Task.TaskId}}" ng-attr-data-seqdesgid="{{Task.SequenceDesignationId}}"><span class="badge badge-success badge-xstext">
                                        <label ng-attr-id="SeqLabelFrozen{{Task.TaskId}}">{{getSequenceDisplayText(!Task.Sequence?"N.A.":Task.Sequence,Task.SequenceDesignationId,Task.IsTechTask === "false" ? "SS" : "TT")}}</label></span></a>

                                    <a id="A1" runat="server" style="text-decoration: none;" ng-show="!$first" ng-attr-data-taskid="{{Task.TaskId}}" href="javascript:void(0);" ng-class="{hide: Task.Sequence == null || 0}" ng-attr-data-taskseq="{{Task.Sequence}}" ng-hide="{{Task.TaskId == BlinkTaskId}}" ng-attr-data-taskdesg="{{Task.SequenceDesignationId}}" onclick="swapSequence(this,true)">&#9650;</a>
                                    <a id="A2" runat="server" style="text-decoration: none;" ng-class="{hide: Task.Sequence == null || 0}" ng-attr-data-taskid="{{Task.TaskId}}" ng-attr-data-taskseq="{{Task.Sequence}}" ng-attr-data-taskdesg="{{Task.SequenceDesignationId}}" href="javascript:void(0);" onclick="swapSequence(this,false)" ng-show="!$last">&#9660;</a>
                                </div>
                                <!-- Sequence# ends -->

                                <!-- ID# and Designation starts -->
                                <div class="div-table-col seq-taskid">
                                    <a ng-href="../Sr_App/TaskGenerator.aspx?TaskId={{Task.MainParentId}}&hstid={{Task.TaskId}}" oncontextmenu="openCopyBox(this);return false;" data-installid="{{Task.InstallId}}" parentdata-highlighter="{{Task.MainParentId}}" data-highlighter="{{Task.TaskId}}" class="bluetext" target="_blank">{{ Task.InstallId }}</a><br />
                                    {{getDesignationString(Task.TaskDesignation)}}                                        
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
                                    <select id="drpStatusSubsequenceFrozen" onchange="changeTaskStatusClosed(this);" data-highlighter="{{Task.TaskId}}">
                                        <option ng-selected="{{Task.Status == '1'}}" value="1">Open</option>
                                        <option ng-selected="{{Task.Status == '2'}}" style="color: red" value="2">Requested</option>
                                        <option ng-selected="{{Task.Status == '3'}}" style="color: lawngreen" value="3">Assigned</option>
                                        <option ng-selected="{{Task.Status == '4'}}" value="4">InProgress</option>
                                        <% if (IsSuperUser)
                                            { %>
                                        <option ng-selected="{{Task.Status == '5'}}" value="5">Pending</option>
                                        <option ng-selected="{{Task.Status == '6'}}" value="6">ReOpened</option>
                                        <option ng-selected="{{Task.Status == '7'}}" value="7">Closed</option>
                                        <option ng-selected="{{Task.Status == '8'}}" value="8">SpecsInProgress</option>
                                        <%} %>
                                        <option ng-selected="{{Task.Status == '10'}}" value="10">Finished</option>
                                        <option ng-selected="{{Task.Status == '11'}}" value="11">Test</option>
                                        <% if (IsSuperUser)
                                            { %>
                                        <option ng-selected="{{Task.Status == '12'}}" value="12">Live</option>
                                        <option ng-selected="{{Task.Status == '14'}}" value="14">Billed</option>
                                        <option ng-selected="{{Task.Status == '9'}}" value="9">Deleted</option>
                                        <%} %>
                                    </select>
                                    <br />
                                    <%-- <select id="lstbAssign" data-chosen="1" data-placeholder="Select Users" ng-options="item as item.FristName for item in DesignationAssignUsers track by item.Id" ng-model="DesignationAssignUsersModel" multiple>
                                        </select>--%>
                                    <%--<asp:ListBox ID="ddcbSeqAssigned" runat="server" Width="100" ClientIDMode="AutoID" SelectionMode="Multiple"
                                            data-chosen="1" data-placeholder="Select Users" ng-options="item as item.FristName for item in DesignationAssignUsers track by item.Id" ng-model="DesignationAssignUsersModel"
                                            AutoPostBack="false">--%>

                                    <select <%=!IsSuperUser ? "disabled" : ""%> id="ddcbSeqAssignedFrozen" style="width: 100%;" multiple ng-attr-data-assignedusers="{{Task.TaskAssignedUserIDs}}" data-chosen="1" data-placeholder="Select Users" onchange="EditSeqAssignedTaskUsers(this);" data-taskid="{{Task.TaskId}}" data-taskstatus="{{Task.Status}}">
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
                                            <input type="checkbox" id="chkngUserFrozen" ng-checked="{{Task.OtherUserStatus}}" ng-disabled="{{Task.OtherUserStatus}}" class="fz fz-user" title="User" />
                                            <input type="checkbox" id="chkQAFrozen" class="fz fz-QA" title="QA" />
                                            <input type="checkbox" id="chkAlphaUserFrozen" class="fz fz-Alpha" title="AlphaUser" />
                                            <br />
                                            <input type="checkbox" id="chkBetaUserFrozen" class="fz fz-Beta" title="BetaUser" />
                                            <input type="checkbox" id="chkngITLeadFrozen" ng-checked="{{Task.TechLeadStatus}}" ng-disabled="{{Task.TechLeadStatus}}" class="fz fz-techlead" title="IT Lead" />
                                            <input type="checkbox" id="chkngAdminFrozen" ng-checked="{{Task.AdminStatus}}" ng-disabled="{{Task.AdminStatus}}" class="fz fz-admin" title="Admin" />
                                        </div>
                                        <div style="width: 30%; float: right;">
                                            <input type="checkbox" id="chkngITLeadMasterFrozen" class="fz fz-techlead largecheckbox" title="IT Lead" /><br />
                                            <input type="checkbox" id="chkngAdminMasterFrozen" class="fz fz-admin largecheckbox" title="Admin" />
                                        </div>
                                    </div>

                                    <div ng-attr-data-taskid="{{Task.TaskId}}" class="seqapprovepopup" style="display: none">

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
                                <div class="notes-section" taskid="{{TechTask.TaskId}}" taskmultilevellistid="0" style="position: relative; overflow-x: hidden; overflow-y: auto; min-height: 90px; width: 320px !important;">
                                    <div class="div-table-col seq-notes-fixed-top sub-task" taskid="{{TechTask.TaskId}}" taskmultilevellistid="0">
                                        Loading Notes...
                                    </div>
                                    <div class="notes-inputs">
                                        <div class="first-col">
                                            <input type="button" class="GrdBtnAdd" value="Add Notes" onclick="addNotes(this)" />
                                        </div>
                                        <div class="second-col">
                                            <textarea class="note-text textbox"></textarea>
                                        </div>
                                    </div>
                                </div>
                                <!-- Notes ends -->

                                <!-- Nested row starts -->

                                <div class="div-table-nested" ng-class="{hide : StringIsNullOrEmpty(Task.SubSeqTasks)}">

                                    <!-- Body section starts -->
                                    <div class="div-table-row" ng-repeat="TechTask in correctDataforAngularFrozenTaks(Task.SubSeqTasks)" ng-class="{orange : TechTask.Status==='4', yellow: TechTask.Status==='2', yellow: TechTask.Status==='3', lightgray: TechTask.Status==='8'}">
                                        <!-- Sequence# starts -->
                                        <div class="div-table-col seq-number">
                                            <a style="text-decoration: none;" ng-show="!$first" ng-attr-data-taskid="{{TechTask.TaskId}}" href="javascript:void(0);" class="uplink" ng-class="{hide: TechTask.Sequence == null || 0}" ng-attr-data-taskseq="{{TechTask.SubSequence}}" ng-attr-data-taskdesg="{{TechTask.SequenceDesignationId}}" onclick="swapSubSequence(this,true)">&#9650;</a><a style="text-decoration: none;" ng-class="{hide: TechTask.Sequence == null || 0}" ng-attr-data-taskid="{{TechTask.TaskId}}" ng-attr-data-taskseq="{{TechTask.SubSequence}}" class="downlink" ng-attr-data-taskdesg="{{TechTask.SequenceDesignationId}}" href="javascript:void(0);" ng-show="!$last" onclick="swapSubSequence(this,false)">&#9660;</a>
                                            <a ng-attr-id="autoClick{{Task.TaskId}}" href="javascript:void(0);" class="badge-hyperlink autoclickSeqEdit" ng-attr-data-taskid="{{TechTask.TaskId}}" ng-attr-data-seqdesgid="{{TechTask.SequenceDesignationId}}"><span class="badge badge-error badge-xstext">
                                                <label ng-attr-id="SeqLabel{{TechTask.TaskId}}">{{getSequenceDisplayText(!TechTask.Sequence?"N.A.":TechTask.Sequence + " (" + toRoman(TechTask.SubSequence)+ ")",TechTask.SequenceDesignationId,TechTask.IsTechTask == "false" ? "SS" : "TT")}}</label></span></a>
                                            <div class="handle-counter" ng-class="{hide: TechTask.TaskId != HighLightTaskId}" ng-attr-id="divSeq{{TechTask.TaskId}}">
                                                <input type="text" class="textbox hide" ng-attr-data-original-val='{{ TechTask.Sequence == null && 0 || TechTask.Sequence}}' ng-attr-data-original-desgid="{{TechTask.SequenceDesignationId}}" ng-attr-id='txtSeq{{TechTask.TaskId}}' value="{{  TechTask.Sequence == null && 0 || TechTask.Sequence}}" />


                                            </div>
                                        </div>
                                        <!-- Sequence# ends -->

                                        <!-- ID# and Designation starts -->
                                        <div class="div-table-col seq-taskid">
                                            <a ng-href="../Sr_App/TaskGenerator.aspx?TaskId={{TechTask.MainParentId}}&hstid={{TechTask.TaskId}}" oncontextmenu="openCopyBox(this);return false;" data-installid="{{TechTask.InstallId}}" parentdata-highlighter="{{TechTask.MainParentId}}" data-highlighter="{{TechTask.TaskId}}" class="bluetext" target="_blank">{{ TechTask.InstallId }}</a><br />
                                            {{getDesignationString(TechTask.TaskDesignation)}}
                                        <div ng-attr-id="divSeqDesg{{TechTask.TaskId}}" ng-class="{hide: TechTask.TaskId != HighLightTaskId}">
                                            <select class="textbox hide" ng-attr-data-taskid="{{TechTask.TaskId}}" ng-options="item as item.Name for item in ParentTaskDesignations track by item.Id" ng-model="DesignationSelectModel[$index]">
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
                                        <div class="div-table-col seq-taskstatus">
                                            <select id="drpStatusSubsequenceFrozenNested" onchange="changeTaskStatusClosed(this);" data-highlighter="{{TechTask.TaskId}}">
                                                <option ng-selected="{{TechTask.Status == '1'}}" value="1">Open</option>
                                                <option ng-selected="{{TechTask.Status == '2'}}" style="color: red" value="2">Requested</option>
                                                <option ng-selected="{{TechTask.Status == '3'}}" style="color: lawngreen" value="3">Assigned</option>
                                                <option ng-selected="{{TechTask.Status == '4'}}" value="4">InProgress</option>
                                                <% if (IsSuperUser)
                                                    { %>
                                                <option ng-selected="{{TechTask.Status == '5'}}" value="5">Pending</option>
                                                <option ng-selected="{{TechTask.Status == '6'}}" value="6">ReOpened</option>
                                                <option ng-selected="{{TechTask.Status == '7'}}" value="7">Closed</option>
                                                <option ng-selected="{{TechTask.Status == '8'}}" value="8">SpecsInProgress</option>
                                                <%} %>
                                                <option ng-selected="{{TechTask.Status == '10'}}" value="10">Finished</option>
                                                <option ng-selected="{{TechTask.Status == '11'}}" value="11">Test</option>
                                                <% if (IsSuperUser)
                                                    { %>
                                                <option ng-selected="{{TechTask.Status == '12'}}" value="12">Live</option>
                                                <option ng-selected="{{TechTask.Status == '14'}}" value="14">Billed</option>
                                                <option ng-selected="{{TechTask.Status == '9'}}" value="9">Deleted</option>
                                                <%} %>
                                            </select>
                                            <br />
                                            <select id="ddcbSeqAssignedFrozenNested" style="width: 100%;" multiple ng-attr-data-assignedusers="{{TechTask.TaskAssignedUserIDs}}" data-chosen="1" data-placeholder="Select Users" onchange="EditSeqAssignedTaskUsers(this);" data-taskid="{{TechTask.TaskId}}" data-taskstatus="{{TechTask.Status}}">
                                                <option
                                                    ng-repeat="item in DesignationAssignUsers"
                                                    value="{{item.Id}}"
                                                    label="{{item.FristName}}"
                                                    class="{{item.CssClass}}">{{item.FristName}}
                                                
                                                </option>
                                            </select>
                                        </div>
                                        <div class="div-table-col seq-taskduedate">
                                            <div class="seqapprovalBoxes">
                                                <div style="width: 65%; float: left;">
                                                    <input type="checkbox" id="chkngUserFrozenNested" ng-checked="{{TechTask.OtherUserStatus}}" ng-disabled="{{TechTask.OtherUserStatus}}" class="fz fz-user" title="User" />
                                                    <input type="checkbox" id="chkQAFrozenNested" class="fz fz-QA" title="QA" />
                                                    <input type="checkbox" id="chkAlphaUserFrozenNested" class="fz fz-Alpha" title="AlphaUser" />
                                                    <br />
                                                    <input type="checkbox" id="chkBetaUserFrozenNested" class="fz fz-Beta" title="BetaUser" />
                                                    <input type="checkbox" id="chkngITLeadFrozenNested" ng-checked="{{TechTask.TechLeadStatus}}" ng-disabled="{{TechTask.TechLeadStatus}}" class="fz fz-techlead" title="IT Lead" />
                                                    <input type="checkbox" id="chkngAdminFrozenNested" ng-checked="{{TechTask.AdminStatus}}" ng-disabled="{{TechTask.AdminStatus}}" class="fz fz-admin" title="Admin" />
                                                </div>
                                                <div style="width: 30%; float: right;">
                                                    <input type="checkbox" id="chkngITLeadMasterFrozenNested" class="fz fz-techlead largecheckbox" title="IT Lead" /><br />
                                                    <input type="checkbox" id="chkngAdminMasterFreezeSeqTask" class="fz fz-admin largecheckbox" title="Admin" />
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
                                        <div class="div-table-col seq-notes">
                                            Notes
                                        </div>
                                        <!-- Status & Assigned To ends -->


                                    </div>
                                    <!-- Body section ends -->

                                </div>

                                <!-- Nested row ends -->

                            </div>
                        </div>

                        <div class="text-center">
                            <jgpager page="{{page}}" pages-count="{{pagesCount}}" total-count="{{TotalRecords}}" search-func="getTasks(page)"></jgpager>
                        </div>
                        <div ng-show="loader.loading" style="position: absolute; left: 50%; bottom: -20%">
                            Loading...
                <img src="../img/ajax-loader.gif" />
                        </div>

                    </div>

                    <div id="TechTaskFrozen">

                        <div id="tblTechSeqFrozen" class="div-table tableSeqTask">
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

                            <div ng-attr-id="divMasterTask{{Task.TaskId}}" class="div-table-row" data-ng-repeat="Task in FrozenTask" ng-class="{orange : Task.Status==='4', yellow: Task.Status==='2', yellow: Task.Status==='3', lightgray: Task.Status==='8'}" repeat-end="onTechEnd()">

                                <!-- Sequence# starts -->
                                <div class="div-table-col seq-number">
                                    <a ng-attr-id="autoClick{{Task.TaskId}}" href="javascript:void(0);" class="badge-hyperlink autoclickSeqEdit" ng-attr-data-taskid="{{Task.TaskId}}" ng-attr-data-seqdesgid="{{Task.SequenceDesignationId}}"><span class="badge badge-success badge-xstext">
                                        <label ng-attr-id="SeqLabel{{Task.TaskId}}">{{getSequenceDisplayText(!Task.Sequence?"N.A.":Task.Sequence,Task.SequenceDesignationId,Task.IsTechTask === "false" ? "SS" : "TT")}}</label></span></a><a style="text-decoration: none;" ng-attr-data-taskid="{{Task.TaskId}}" href="javascript:void(0);" class="uplink" ng-class="{hide: Task.Sequence == null || 0}" ng-attr-data-taskseq="{{Task.Sequence}}" ng-show="!$first" ng-attr-data-taskdesg="{{Task.SequenceDesignationId}}" onclick="swapSequence(this,true)">&#9650;</a><a style="text-decoration: none;" ng-class="{hide: Task.Sequence == null || 0}" ng-attr-data-taskid="{{Task.TaskId}}" ng-attr-data-taskseq="{{Task.Sequence}}" class="downlink" ng-attr-data-taskdesg="{{Task.SequenceDesignationId}}" href="javascript:void(0);" onclick="swapSequence(this,false)" ng-show="!$last">&#9660;</a>
                                    <div class="handle-counter" ng-class="{hide: Task.TaskId != HighLightTaskId}" ng-attr-id="divSeq{{Task.TaskId}}">
                                        <input type="text" class="textbox hide" ng-attr-data-original-val='{{ Task.Sequence == null && 0 || Task.Sequence}}' ng-attr-data-original-desgid="{{Task.SequenceDesignationId}}" ng-attr-id='txtSeq{{Task.TaskId}}' value="{{  Task.Sequence == null && 0 || Task.Sequence}}" />


                                    </div>
                                </div>
                                <!-- Sequence# ends -->

                                <!-- ID# and Designation starts -->
                                <div class="div-table-col seq-taskid">
                                    <a ng-href="../Sr_App/TaskGenerator.aspx?TaskId={{Task.MainParentId}}&hstid={{Task.TaskId}}" oncontextmenu="openCopyBox(this);return false;" data-installid="{{Task.InstallId}}" parentdata-highlighter="{{Task.MainParentId}}" data-highlighter="{{Task.TaskId}}" class="bluetext" target="_blank">{{ Task.InstallId }}</a><br />
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
                                    <select id="drpStatusSubsequenceTechFrozen" onchange="changeTaskStatusClosed(this);" data-highlighter="{{Task.TaskId}}">
                                        <option ng-selected="{{Task.Status == '1'}}" value="1">Open</option>
                                        <option ng-selected="{{Task.Status == '2'}}" style="color: red" value="2">Requested</option>
                                        <option ng-selected="{{Task.Status == '3'}}" style="color: lawngreen" value="3">Assigned</option>
                                        <option ng-selected="{{Task.Status == '4'}}" value="4">InProgress</option>
                                        <% if (IsSuperUser)
                                            { %>
                                        <option ng-selected="{{Task.Status == '5'}}" value="5">Pending</option>
                                        <option ng-selected="{{Task.Status == '6'}}" value="6">ReOpened</option>
                                        <option ng-selected="{{Task.Status == '7'}}" value="7">Closed</option>
                                        <option ng-selected="{{Task.Status == '8'}}" value="8">SpecsInProgress</option>
                                        <%} %>
                                        <option ng-selected="{{Task.Status == '10'}}" value="10">Finished</option>
                                        <option ng-selected="{{Task.Status == '11'}}" value="11">Test</option>
                                        <% if (IsSuperUser)
                                            { %>
                                        <option ng-selected="{{Task.Status == '12'}}" value="12">Live</option>
                                        <option ng-selected="{{Task.Status == '14'}}" value="14">Billed</option>
                                        <option ng-selected="{{Task.Status == '9'}}" value="9">Deleted</option>
                                        <%} %>
                                    </select>
                                    <br />
                                    <select <%=!IsSuperUser ? "disabled" : ""%> id="ddcbSeqAssigned" style="width: 100%;" multiple ng-attr-data-assignedusers="{{Task.TaskAssignedUserIDs}}" data-chosen="1" data-placeholder="Select Users" onchange="EditSeqAssignedTaskUsers(this);" data-taskid="{{Task.TaskId}}" data-taskstatus="{{Task.Status}}">
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
                                            <input type="checkbox" id="chkngUserTechFrozen" ng-checked="{{Task.OtherUserStatus}}" ng-disabled="{{Task.OtherUserStatus}}" class="fz fz-user" title="User" />
                                            <input type="checkbox" id="chkQATechFrozen" class="fz fz-QA" title="QA" />
                                            <input type="checkbox" id="chkAlphaUserTechFrozen" class="fz fz-Alpha" title="AlphaUser" />
                                            <br />
                                            <input type="checkbox" id="chkBetaUserTechFrozen" class="fz fz-Beta" title="BetaUser" />
                                            <input type="checkbox" id="chkngITLeadTechFrozen" ng-checked="{{Task.TechLeadStatus}}" ng-disabled="{{Task.TechLeadStatus}}" class="fz fz-techlead" title="IT Lead" />
                                            <input type="checkbox" id="chkngAdminTechFrozen" ng-checked="{{Task.AdminStatus}}" ng-disabled="{{Task.AdminStatus}}" class="fz fz-admin" title="Admin" />
                                        </div>
                                        <div style="width: 30%; float: right;">
                                            <input type="checkbox" id="chkngITLeadMasterTechFrozen" class="fz fz-techlead largecheckbox" title="IT Lead" /><br />
                                            <input type="checkbox" id="chkngAdminMasterTechFrozen" class="fz fz-admin largecheckbox" title="Admin" />
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

                </div>


            </div>

            <div id="taskNonFrozen" ng-controller="NonFrozenTaskController">
                <h2 class="itdashtitle">Non Frozen Tasks</h2>


                <div id="taskSequenceTabsNonFrozen">
                    <ul>
                        <li><a href="#StaffTaskNonFrozen">Staff Tasks</a></li>
                        <li><a href="#TechTaskNonFrozen">Tech Tasks</a></li>

                    </ul>
                    <div id="StaffTaskNonFrozen">
                        <div id="tblStaffSeqNonFrozen" class="div-table tableSeqTask">
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
                            <!-- NG Repeat Div starts -->
                            <div ng-attr-id="divMasterTaskNonFrozen{{Task.TaskId}}" class="div-table-row" data-ng-repeat="Task in NonFrozenTask" ng-class="{orange : Task.Status==='4', yellow: Task.Status==='2', yellow: Task.Status==='3', lightgray: Task.Status==='8'}" repeat-end="onStaffEnd()">
                                <!-- Sequence# starts -->
                                <div class="div-table-col seq-number">
                                    <a ng-attr-id="autoClickNonFrozen{{Task.TaskId}}" href="javascript:void(0);" class="badge-hyperlink autoclickSeqEdit" ng-attr-data-taskseq="{{Task.Sequence}}" ng-attr-data-taskid="{{Task.TaskId}}" ng-attr-data-seqdesgid="{{Task.SequenceDesignationId}}"><span class="badge badge-success badge-xstext">
                                        <label ng-attr-id="SeqLabelNonFrozen{{Task.TaskId}}">{{getSequenceDisplayText(!Task.Sequence?"N.A.":Task.Sequence,Task.SequenceDesignationId,Task.IsTechTask === "false" ? "SS" : "TT")}}</label></span></a>

                                    <a id="A3" runat="server" style="text-decoration: none;" ng-show="!$first" ng-attr-data-taskid="{{Task.TaskId}}" href="javascript:void(0);" ng-class="{hide: Task.Sequence == null || 0}" ng-attr-data-taskseq="{{Task.Sequence}}" ng-hide="{{Task.TaskId == BlinkTaskId}}" ng-attr-data-taskdesg="{{Task.SequenceDesignationId}}" onclick="swapSequence(this,true)">&#9650;</a>
                                    <a id="A4" runat="server" style="text-decoration: none;" ng-class="{hide: Task.Sequence == null || 0}" ng-attr-data-taskid="{{Task.TaskId}}" ng-attr-data-taskseq="{{Task.Sequence}}" ng-attr-data-taskdesg="{{Task.SequenceDesignationId}}" href="javascript:void(0);" onclick="swapSequence(this,false)" ng-show="!$last">&#9660;</a>
                                </div>
                                <!-- Sequence# ends -->

                                <!-- ID# and Designation starts -->
                                <div class="div-table-col seq-taskid">
                                    <a ng-href="../Sr_App/TaskGenerator.aspx?TaskId={{Task.MainParentId}}&hstid={{Task.TaskId}}" oncontextmenu="openCopyBox(this);return false;" data-installid="{{Task.InstallId}}" parentdata-highlighter="{{Task.MainParentId}}" data-highlighter="{{Task.TaskId}}" class="bluetext" target="_blank">{{ Task.InstallId }}</a><br />
                                    {{getDesignationString(Task.TaskDesignation)}}                                        
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
                                    <select id="drpStatusSubsequenceNonFrozen" onchange="changeTaskStatusClosed(this);" data-highlighter="{{Task.TaskId}}">
                                        <option ng-selected="{{Task.Status == '1'}}" value="1">Open</option>
                                        <option ng-selected="{{Task.Status == '2'}}" style="color: red" value="2">Requested</option>
                                        <option ng-selected="{{Task.Status == '3'}}" style="color: lawngreen" value="3">Assigned</option>
                                        <option ng-selected="{{Task.Status == '4'}}" value="4">InProgress</option>
                                        <% if (IsSuperUser)
                                            { %>
                                        <option ng-selected="{{Task.Status == '5'}}" value="5">Pending</option>
                                        <option ng-selected="{{Task.Status == '6'}}" value="6">ReOpened</option>
                                        <option ng-selected="{{Task.Status == '7'}}" value="7">Closed</option>
                                        <option ng-selected="{{Task.Status == '8'}}" value="8">SpecsInProgress</option>
                                        <%} %>
                                        <option ng-selected="{{Task.Status == '10'}}" value="10">Finished</option>
                                        <option ng-selected="{{Task.Status == '11'}}" value="11">Test</option>
                                        <% if (IsSuperUser)
                                            { %>
                                        <option ng-selected="{{Task.Status == '12'}}" value="12">Live</option>
                                        <option ng-selected="{{Task.Status == '14'}}" value="14">Billed</option>
                                        <option ng-selected="{{Task.Status == '9'}}" value="9">Deleted</option>
                                        <%} %>
                                    </select>
                                    <br />
                                    <%-- <select id="lstbAssign" data-chosen="1" data-placeholder="Select Users" ng-options="item as item.FristName for item in DesignationAssignUsers track by item.Id" ng-model="DesignationAssignUsersModel" multiple>
                                        </select>--%>
                                    <%--<asp:ListBox ID="ddcbSeqAssigned" runat="server" Width="100" ClientIDMode="AutoID" SelectionMode="Multiple"
                                            data-chosen="1" data-placeholder="Select Users" ng-options="item as item.FristName for item in DesignationAssignUsers track by item.Id" ng-model="DesignationAssignUsersModel"
                                            AutoPostBack="false">--%>

                                    <select <%=!IsSuperUser ? "disabled" : ""%> id="ddcbSeqAssignedNonFrozen" style="width: 100%;" multiple ng-attr-data-assignedusers="{{Task.TaskAssignedUserIDs}}" data-chosen="1" data-placeholder="Select Users" onchange="EditSeqAssignedTaskUsers(this);" data-taskid="{{Task.TaskId}}" data-taskstatus="{{Task.Status}}">
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
                                            <input type="checkbox" id="chkngUserNonFrozen" ng-checked="{{Task.OtherUserStatus}}" ng-disabled="{{Task.OtherUserStatus}}" class="fz fz-user" title="User" />
                                            <input type="checkbox" id="chkQANonFrozen" class="fz fz-QA" title="QA" />
                                            <input type="checkbox" id="chkAlphaUserNonFrozen" class="fz fz-Alpha" title="AlphaUser" />
                                            <br />
                                            <input type="checkbox" id="chkBetaUserNonFrozen" class="fz fz-Beta" title="BetaUser" />
                                            <input type="checkbox" id="chkngITLeadNonFrozen" ng-checked="{{Task.TechLeadStatus}}" ng-disabled="{{Task.TechLeadStatus}}" class="fz fz-techlead" title="IT Lead" />
                                            <input type="checkbox" id="chkngAdminNonFrozen" ng-checked="{{Task.AdminStatus}}" ng-disabled="{{Task.AdminStatus}}" class="fz fz-admin" title="Admin" />
                                        </div>
                                        <div style="width: 30%; float: right;">
                                            <input type="checkbox" id="chkngITLeadMasterNonFrozen" class="fz fz-techlead largecheckbox" title="IT Lead" /><br />
                                            <input type="checkbox" id="chkngAdminMasterNonFrozen" class="fz fz-admin largecheckbox" title="Admin" />
                                        </div>
                                    </div>

                                    <div ng-attr-data-taskid="{{Task.TaskId}}" class="seqapprovepopup" style="display: none">

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
                                    <div class="div-table-row" ng-repeat="TechTask in correctDataforAngularFrozenTaks(Task.SubSeqTasks)" ng-class="{orange : TechTask.Status==='4', yellow: TechTask.Status==='2', yellow: TechTask.Status==='3', lightgray: TechTask.Status==='8'}">
                                        <!-- Sequence# starts -->
                                        <div class="div-table-col seq-number">
                                            <a style="text-decoration: none;" ng-show="!$first" ng-attr-data-taskid="{{TechTask.TaskId}}" href="javascript:void(0);" class="uplink" ng-class="{hide: TechTask.Sequence == null || 0}" ng-attr-data-taskseq="{{TechTask.SubSequence}}" ng-attr-data-taskdesg="{{TechTask.SequenceDesignationId}}" onclick="swapSubSequence(this,true)">&#9650;</a><a style="text-decoration: none;" ng-class="{hide: TechTask.Sequence == null || 0}" ng-attr-data-taskid="{{TechTask.TaskId}}" ng-attr-data-taskseq="{{TechTask.SubSequence}}" class="downlink" ng-attr-data-taskdesg="{{TechTask.SequenceDesignationId}}" href="javascript:void(0);" ng-show="!$last" onclick="swapSubSequence(this,false)">&#9660;</a>
                                            <a ng-attr-id="autoClick{{Task.TaskId}}" href="javascript:void(0);" class="badge-hyperlink autoclickSeqEdit" ng-attr-data-taskid="{{TechTask.TaskId}}" ng-attr-data-seqdesgid="{{TechTask.SequenceDesignationId}}"><span class="badge badge-error badge-xstext">
                                                <label ng-attr-id="SeqLabel{{TechTask.TaskId}}">{{getSequenceDisplayText(!TechTask.Sequence?"N.A.":TechTask.Sequence + " (" + toRoman(TechTask.SubSequence)+ ")",TechTask.SequenceDesignationId,TechTask.IsTechTask == "false" ? "SS" : "TT")}}</label></span></a>
                                            <div class="handle-counter" ng-class="{hide: TechTask.TaskId != HighLightTaskId}" ng-attr-id="divSeq{{TechTask.TaskId}}">
                                                <input type="text" class="textbox hide" ng-attr-data-original-val='{{ TechTask.Sequence == null && 0 || TechTask.Sequence}}' ng-attr-data-original-desgid="{{TechTask.SequenceDesignationId}}" ng-attr-id='txtSeq{{TechTask.TaskId}}' value="{{  TechTask.Sequence == null && 0 || TechTask.Sequence}}" />


                                            </div>
                                        </div>
                                        <!-- Sequence# ends -->

                                        <!-- ID# and Designation starts -->
                                        <div class="div-table-col seq-taskid">
                                            <a ng-href="../Sr_App/TaskGenerator.aspx?TaskId={{TechTask.MainParentId}}&hstid={{TechTask.TaskId}}" oncontextmenu="openCopyBox(this);return false;" data-installid="{{TechTask.InstallId}}" parentdata-highlighter="{{TechTask.MainParentId}}" data-highlighter="{{TechTask.TaskId}}" class="bluetext" target="_blank">{{ TechTask.InstallId }}</a><br />
                                            {{getDesignationString(TechTask.TaskDesignation)}}
                                        <div ng-attr-id="divSeqDesg{{TechTask.TaskId}}" ng-class="{hide: TechTask.TaskId != HighLightTaskId}">
                                            <select class="textbox hide" ng-attr-data-taskid="{{TechTask.TaskId}}" ng-options="item as item.Name for item in ParentTaskDesignations track by item.Id" ng-model="DesignationSelectModel[$index]">
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
                                        <div class="div-table-col seq-taskstatus">
                                            <select id="drpStatusSubsequenceNonFrozenNested" onchange="changeTaskStatusClosed(this);" data-highlighter="{{TechTask.TaskId}}">
                                                <option ng-selected="{{TechTask.Status == '1'}}" value="1">Open</option>
                                                <option ng-selected="{{TechTask.Status == '2'}}" style="color: red" value="2">Requested</option>
                                                <option ng-selected="{{TechTask.Status == '3'}}" style="color: lawngreen" value="3">Assigned</option>
                                                <option ng-selected="{{TechTask.Status == '4'}}" value="4">InProgress</option>
                                                <% if (IsSuperUser)
                                                    { %>
                                                <option ng-selected="{{TechTask.Status == '5'}}" value="5">Pending</option>
                                                <option ng-selected="{{TechTask.Status == '6'}}" value="6">ReOpened</option>
                                                <option ng-selected="{{TechTask.Status == '7'}}" value="7">Closed</option>
                                                <option ng-selected="{{TechTask.Status == '8'}}" value="8">SpecsInProgress</option>
                                                <%} %>
                                                <option ng-selected="{{TechTask.Status == '10'}}" value="10">Finished</option>
                                                <option ng-selected="{{TechTask.Status == '11'}}" value="11">Test</option>
                                                <% if (IsSuperUser)
                                                    { %>
                                                <option ng-selected="{{TechTask.Status == '12'}}" value="12">Live</option>
                                                <option ng-selected="{{TechTask.Status == '14'}}" value="14">Billed</option>
                                                <option ng-selected="{{TechTask.Status == '9'}}" value="9">Deleted</option>
                                                <%} %>
                                            </select>
                                            <br />
                                            <select id="ddcbSeqAssignedNonFrozenNested" style="width: 100%;" multiple ng-attr-data-assignedusers="{{TechTask.TaskAssignedUserIDs}}" data-chosen="1" data-placeholder="Select Users" onchange="EditSeqAssignedTaskUsers(this);" data-taskid="{{TechTask.TaskId}}" data-taskstatus="{{TechTask.Status}}">
                                                <option
                                                    ng-repeat="item in DesignationAssignUsers"
                                                    value="{{item.Id}}"
                                                    label="{{item.FristName}}"
                                                    class="{{item.CssClass}}">{{item.FristName}}
                                                
                                                </option>
                                            </select>
                                        </div>
                                        <!-- Status & Assigned To ends -->

                                        <div class="div-table-col seq-taskduedate">
                                            <div class="seqapprovalBoxes">
                                                <div style="width: 65%; float: left;">
                                                    <input type="checkbox" id="chkngUserNonFrozenNested" ng-checked="{{TechTask.OtherUserStatus}}" ng-disabled="{{TechTask.OtherUserStatus}}" class="fz fz-user" title="User" />
                                                    <input type="checkbox" id="chkQANonFrozenNested" class="fz fz-QA" title="QA" />
                                                    <input type="checkbox" id="chkAlphaUserNonFrozenNested" class="fz fz-Alpha" title="AlphaUser" />
                                                    <br />
                                                    <input type="checkbox" id="chkBetaUserNonFrozenNested" class="fz fz-Beta" title="BetaUser" />
                                                    <input type="checkbox" id="chkngITLeadNonFrozenNested" ng-checked="{{TechTask.TechLeadStatus}}" ng-disabled="{{TechTask.TechLeadStatus}}" class="fz fz-techlead" title="IT Lead" />
                                                    <input type="checkbox" id="chkngAdminNonFrozenNested" ng-checked="{{TechTask.AdminStatus}}" ng-disabled="{{TechTask.AdminStatus}}" class="fz fz-admin" title="Admin" />
                                                </div>
                                                <div style="width: 30%; float: right;">
                                                    <input type="checkbox" id="chkngITLeadMasterNonFrozenNested" class="fz fz-techlead largecheckbox" title="IT Lead" /><br />
                                                    <input type="checkbox" id="chkngAdminMasterNonFrozenNested" class="fz fz-admin largecheckbox" title="Admin" />
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
                                        <div class="div-table-col seq-notes">
                                            Notes
                                        </div>
                                    </div>
                                    <!-- Body section ends -->

                                </div>

                                <!-- Nested row ends -->

                            </div>
                        </div>


                        <div class="text-center">
                            <jgpager page="{{page}}" pages-count="{{pagesCount}}" total-count="{{TotalRecords}}" search-func="getTasks(page)"></jgpager>

                        </div>
                        <div ng-show="loader.loading" style="position: absolute; left: 50%; bottom: 10%">
                            Loading...
                <img src="../img/ajax-loader.gif" />
                        </div>

                    </div>

                    <div id="TechTaskNonFrozen">

                        <div id="tblTechSeqNonFrozen" class="div-table tableSeqTask">
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

                            <div ng-attr-id="divMasterTask{{Task.TaskId}}" class="div-table-row" data-ng-repeat="Task in NonFrozenTask" ng-class="{orange : Task.Status==='4', yellow: Task.Status==='2', yellow: Task.Status==='3', lightgray: Task.Status==='8'}" repeat-end="onTechEnd()">

                                <!-- Sequence# starts -->
                                <div class="div-table-col seq-number">
                                    <a ng-attr-id="autoClick{{Task.TaskId}}" href="javascript:void(0);" class="badge-hyperlink autoclickSeqEdit" ng-attr-data-taskid="{{Task.TaskId}}" ng-attr-data-seqdesgid="{{Task.SequenceDesignationId}}"><span class="badge badge-success badge-xstext">
                                        <label ng-attr-id="SeqLabel{{Task.TaskId}}">{{getSequenceDisplayText(!Task.Sequence?"N.A.":Task.Sequence,Task.SequenceDesignationId,Task.IsTechTask === "false" ? "SS" : "TT")}}</label></span></a><a style="text-decoration: none;" ng-attr-data-taskid="{{Task.TaskId}}" href="javascript:void(0);" class="uplink" ng-class="{hide: Task.Sequence == null || 0}" ng-attr-data-taskseq="{{Task.Sequence}}" ng-show="!$first" ng-attr-data-taskdesg="{{Task.SequenceDesignationId}}" onclick="swapSequence(this,true)">&#9650;</a><a style="text-decoration: none;" ng-class="{hide: Task.Sequence == null || 0}" ng-attr-data-taskid="{{Task.TaskId}}" ng-attr-data-taskseq="{{Task.Sequence}}" class="downlink" ng-attr-data-taskdesg="{{Task.SequenceDesignationId}}" href="javascript:void(0);" onclick="swapSequence(this,false)" ng-show="!$last">&#9660;</a>
                                    <div class="handle-counter" ng-class="{hide: Task.TaskId != HighLightTaskId}" ng-attr-id="divSeq{{Task.TaskId}}">
                                        <input type="text" class="textbox hide" ng-attr-data-original-val='{{ Task.Sequence == null && 0 || Task.Sequence}}' ng-attr-data-original-desgid="{{Task.SequenceDesignationId}}" ng-attr-id='txtSeq{{Task.TaskId}}' value="{{  Task.Sequence == null && 0 || Task.Sequence}}" />


                                    </div>
                                </div>
                                <!-- Sequence# ends -->

                                <!-- ID# and Designation starts -->
                                <div class="div-table-col seq-taskid">
                                    <a ng-href="../Sr_App/TaskGenerator.aspx?TaskId={{Task.MainParentId}}&hstid={{Task.TaskId}}" oncontextmenu="openCopyBox(this);return false;" data-installid="{{Task.InstallId}}" parentdata-highlighter="{{Task.MainParentId}}" data-highlighter="{{Task.TaskId}}" class="bluetext" target="_blank">{{ Task.InstallId }}</a><br />
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
                                    <select id="drpStatusSubsequenceTechTaskFrozen" onchange="changeTaskStatusClosed(this);" data-highlighter="{{Task.TaskId}}">
                                        <option ng-selected="{{Task.Status == '1'}}" value="1">Open</option>
                                        <option ng-selected="{{Task.Status == '2'}}" style="color: red" value="2">Requested</option>
                                        <option ng-selected="{{Task.Status == '3'}}" style="color: lawngreen" value="3">Assigned</option>
                                        <option ng-selected="{{Task.Status == '4'}}" value="4">InProgress</option>
                                        <% if (IsSuperUser)
                                            { %>
                                        <option ng-selected="{{Task.Status == '5'}}" value="5">Pending</option>
                                        <option ng-selected="{{Task.Status == '6'}}" value="6">ReOpened</option>
                                        <option ng-selected="{{Task.Status == '7'}}" value="7">Closed</option>
                                        <option ng-selected="{{Task.Status == '8'}}" value="8">SpecsInProgress</option>
                                        <%} %>
                                        <option ng-selected="{{Task.Status == '10'}}" value="10">Finished</option>
                                        <option ng-selected="{{Task.Status == '11'}}" value="11">Test</option>
                                        <% if (IsSuperUser)
                                            { %>
                                        <option ng-selected="{{Task.Status == '12'}}" value="12">Live</option>
                                        <option ng-selected="{{Task.Status == '14'}}" value="14">Billed</option>
                                        <option ng-selected="{{Task.Status == '9'}}" value="9">Deleted</option>
                                        <%} %>
                                    </select>
                                    <br />
                                    <select <%=!IsSuperUser ? "disabled" : ""%> id="ddcbSeqAssigned" style="width: 100%;" multiple ng-attr-data-assignedusers="{{Task.TaskAssignedUserIDs}}" data-chosen="1" data-placeholder="Select Users" onchange="EditSeqAssignedTaskUsers(this);" data-taskid="{{Task.TaskId}}" data-taskstatus="{{Task.Status}}">
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
                                            <input type="checkbox" id="chkngUserTechTaskFrozen" ng-checked="{{Task.OtherUserStatus}}" ng-disabled="{{Task.OtherUserStatus}}" class="fz fz-user" title="User" />
                                            <input type="checkbox" id="chkQATechTaskFrozen" class="fz fz-QA" title="QA" />
                                            <input type="checkbox" id="chkAlphaUserTechTaskFrozen" class="fz fz-Alpha" title="AlphaUser" />
                                            <br />
                                            <input type="checkbox" id="chkBetaUserTechTaskFrozen" class="fz fz-Beta" title="BetaUser" />
                                            <input type="checkbox" id="chkngITLeadTechTaskFrozen" ng-checked="{{Task.TechLeadStatus}}" ng-disabled="{{Task.TechLeadStatus}}" class="fz fz-techlead" title="IT Lead" />
                                            <input type="checkbox" id="chkngAdminTechTaskFrozen" ng-checked="{{Task.AdminStatus}}" ng-disabled="{{Task.AdminStatus}}" class="fz fz-admin" title="Admin" />
                                        </div>
                                        <div style="width: 30%; float: right;">
                                            <input type="checkbox" id="chkngITLeadMasterTechTaskFrozen" class="fz fz-techlead largecheckbox" title="IT Lead" /><br />
                                            <input type="checkbox" id="chkngAdminMasterTechTaskFrozen" class="fz fz-admin largecheckbox" title="Admin" />
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


                </div>


            </div>
        </div>

        <!-- -------------------- End DP -------------------  -->

        <%--</ContentTemplate>
        </asp:UpdatePanel>--%>
        <div id="taskSequence" ng-controller="TaskSequenceSearchController">
            <div class="loading" ng-show="loading === true"></div>


            <%if (IsSuperUser)
                { %>
            <table style="width: 100%" id="tableFilter" runat="server" class="tableFilter">
                <tr>
                    <td colspan="6" style="padding: 0px !important;">
                        <h2 class="itdashtitle">In Progress, Assigned-Requested</h2>
                    </td>
                </tr>
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
                        <select data-placeholder="Select Designation" class="chosen-dropDownStatus" multiple style="width: 200px;" id="ddlUserStatus">

                            <option selected value="A0">All</option>

                            <optgroup label="User Status">
                                <option class="color-1" value="U1" index="2">Active</option>
                                <option class="color-6" value="U6" index="3">Offer Made: Applicant</option>
                                <option class="color-5" value="U5" index="4">Interview Date : Applicant</option>
                            </optgroup>
                            <optgroup label="Task Status">
                                <option value="T4" index="6">In Progress</option>
                                <%--<option value="T2">Request</option>--%>
                                <option value="T3" index="7">Request-Assigned</option>
                                <%--<option value="T1">Open</option>--%>
                                <%--<option value="T8">Specs In Progress-NOT OPEN</option>--%>
                                <option value="T11" index="8">Test Commit</option>
                                <option value="T12" index="9">Live Commit</option>
                                <option value="T7" index="10">Closed</option>
                                <option value="T14" index="11">Billed</option>
                                <option value="T9" index="12">Deleted</option>
                            </optgroup>
                        </select>
                    </td>
                    <td>
                        <select id="ddlSelectUserInProTask" data-placeholder="Select Users" multiple style="width: 200px;" class="chosen-select-users">
                            <option selected value="">All</option>
                        </select><span id="lblLoading" style="display: none">Loading...</span>
                    </td>
                    <td></td>
                    <td style="text-align: left; text-wrap: avoid; padding: 0px">
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
                            <asp:TextBox ID="txtfrmdate" runat="server" TabIndex="2" CssClass="dateFrom"
                                onkeypress="return false" MaxLength="10"
                                Style="width: 80px;"></asp:TextBox>
                                <cc1:CalendarExtender ID="calExtendFromDate" runat="server" TargetControlID="txtfrmdate">
                                </cc1:CalendarExtender>
                                <br />
                            </span>

                            <span id="Label4">To :*
                            <asp:TextBox ID="txtTodate" CssClass="dateTo" onkeypress="return false"
                                MaxLength="10" runat="server" TabIndex="3"
                                Style="width: 80px; margin-left: 16px;"></asp:TextBox>
                                <cc1:CalendarExtender ID="CalendarExtender2" runat="server" TargetControlID="txtTodate">
                                </cc1:CalendarExtender>
                            </span>

                            <span id="requirefrmdate" style="color: Red; visibility: hidden;">Select From date</span><span id="Requiretodate" style="color: Red; visibility: hidden;"> Select To date</span>
                        </div>
                    </td>
                    <td>
                        <input id="txtSearchUser" class="textbox ui-autocomplete-input" maxlength="15" placeholder="search users" type="text" />
                    </td>
                </tr>
            </table>
            <%}
                else
                { %>

            <table style="width: 100%" id="tableFilterUser" runat="server" class="tableFilter">
                <tr>
                    <td colspan="6" style="padding: 0px !important;">
                        <h2 class="itdashtitle">In Progress, Assigned-Requested</h2>
                    </td>
                </tr>
                <tr style="background-color: #000; color: white; font-weight: bold; text-align: center;">
                    <td style="width: 34%">
                        <span>Saved Report</span></td>
                    <td style="width: 33%">
                        <span>Select Period</span>
                    </td>
                    <td style="width: 33%">Search</td>
                </tr>
                <tr>
                    <td></td>
                    <td style="text-align: left; text-wrap: avoid; padding: 0px">
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
                            <asp:TextBox ID="TextBox1" runat="server" TabIndex="2" CssClass="dateFrom"
                                onkeypress="return false" MaxLength="10"
                                Style="width: 80px;"></asp:TextBox>
                                <cc1:CalendarExtender ID="CalendarExtender1" runat="server" TargetControlID="TextBox1">
                                </cc1:CalendarExtender>
                                <br />
                            </span>

                            <span>To :*
                            <asp:TextBox ID="TextBox2" CssClass="dateTo" onkeypress="return false"
                                MaxLength="10" runat="server" TabIndex="3"
                                Style="width: 80px; margin-left: 16px;"></asp:TextBox>
                                <cc1:CalendarExtender ID="CalendarExtender3" runat="server" TargetControlID="TextBox2">
                                </cc1:CalendarExtender>
                            </span>

                            <span id="requirefrmdate" style="color: Red; visibility: hidden;">Select From date</span><span id="Requiretodate" style="color: Red; visibility: hidden;"> Select To date</span>
                        </div>
                    </td>
                    <td>
                        <input id="txtSearchUser" class="textbox ui-autocomplete-input" maxlength="15" placeholder="search users" type="text" />
                    </td>
                </tr>
            </table>

            <%} %>
            <h2 class="itdashtitle">In Progress, Assigned-Requested</h2>
            <%
                if (TaskListView)
                {%>

            <!--Top Grid Records Starts-->
            <div id="taskSequenceTabs" class="ui-tabs ui-widget ui-widget-content ui-corner-all">
                <div id="StaffTask">
                    <div id="tblStaffSeq" class="div-table tableSeqTask">

                        <div ng-show="loader.loading" style="align-content: center; width: 90%; text-align: center;" class="">
                            <img src="../img/ajax-loader.gif" style="vertical-align: middle">Please Wait...
                        </div>
                        <div>
                            <div>
                                <div>

                                    <div class="freeze-head-content">
                                        <span class="freeze-head-instruction">INSTRUCTIONS:</span> To "accept-request" a task select the 
                                            <%--<img src="../img/freeze-checkboxes.JPG" />--%>
                                        <div class="freeze-chkbox-div-red"></div>
                                        <div class="freeze-chkbox-div-black"></div>
                                        <div class="freeze-chkbox-div-blue"></div>
                                        <div class="freeze-chkbox-div-orange"></div>
                                        <div class="freeze-chkbox-div-yellow"></div>
                                        icon & follow FREEZE PROCESS prompts in the pop up. NOTE: Reuse existing source code (copy & paste) unless notified of NEW FEATURE
                                    </div>

                                    <div class="freeze-step">
                                        <span id="freeze-step1-head">Step 1 -</span>
                                        <span class="freeze-step-content">Enter any technical or UI queries, If a final draft UI is not attached than attach an HTML screen shot and wait for approval;</span>
                                    </div>
                                    <div class="freeze-step">
                                        <span id="freeze-step2-head">Step 2 -</span>
                                        <span class="freeze-step-content">Enter a min of 3 unit testing bug test cases; </span>
                                    </div>
                                    <div class="freeze-step">
                                        <span id="freeze-step3-head">Step 3 -</span>
                                        <span class="freeze-step-content">Enter Individually estimated hours for UI, test case writing, development & employment, wait for manager approval; </span>
                                    </div>
                                    <div class="freeze-step">
                                        <span id="freeze-step4-head">Step 4 -</span>
                                        <span class="freeze-step-content">Begin development and when ready commit to github for QA feedback.</span>
                                    </div>
                                    <div class="freeze-step"></div>
                                    <hr />
                                    <div class="freeze-step">
                                        <span class="freeze-red">Red check box = client/End user; </span>
                                        <span class="freeze-black">Black check box = IT Lead; </span>
                                        <span class="freeze-blue">Blue check box = Developer; </span>
                                        <span class="freeze-orange">Orange check box = QA; </span>
                                        <span class="freeze-yellow">yellow check box= Alpha tester;</span>
                                    </div>
                                    <div class="div-table-row">
                                        <div class="div-table-col freeze-ins-box orange">Orange background = Frozen/In Progress</div>
                                        <div class="div-table-col freeze-ins-box yellow">Yellow background = Freeze Process Started</div>
                                        <div class="div-table-col freeze-ins-box freeze-white-col">No background = Assigned Requested-No Progress</div>
                                    </div>
                                </div>
                                <div id="accordion">
                                    <h2>&nbsp;<strong>How to commit your work</strong></h2>
                                    <div>
                                        <p class="MsoNormal" style="margin-bottom: 0in; margin-bottom: .0001pt; line-height: normal">
                                            <br />
                                            <span style="font-size: 10pt;">Dear User,
                                        In order to commit your work, You will need to complete your task assigned after completing and performing proper QA, Commit your Task on Test site.</span>
                                        </p>
                                        <p class="MsoNormal" style="margin-bottom: 0in; margin-bottom: .0001pt; line-height: normal"><span style="font-size: 10pt;">To complete your task, you will need Environment in your local machine as described below.</span></p>
                                        <p class="MsoNormal" style="margin-bottom: 0in; margin-bottom: .0001pt; line-height: normal"><span style="font-size: 10pt;">Please follow below steps:</span></p>
                                        <p class="MsoNormal" style="margin-bottom: 0in; margin-bottom: .0001pt; line-height: normal"><span style="font-size: 10pt; font-family: verdana, sans-serif;">1) Please make sure that you have following software installed:<o:p /></span></p>
                                        <p class="MsoNormal" style="margin-bottom: 0.0001pt; line-height: normal; margin-left: 40px;"><span style="font-size: 10pt; font-family: verdana, sans-serif;">a) Microsoft Visual Studio 2015 or later<o:p /></span></p>
                                        <p class="MsoNormal" style="margin-bottom: 0.0001pt; line-height: normal; margin-left: 40px;"><span style="font-size: 10pt; font-family: verdana, sans-serif;">b) Microsoft SQL Server 2014 or later<o:p /></span></p>
                                        <p class="MsoNormal" style="margin-bottom: 0.0001pt; line-height: normal; margin-left: 40px;"><span style="font-size: 10pt; font-family: verdana, sans-serif;">c) Download and Install Git for windows from this <a href="https://git-scm.com/download/win" target="_blank">link</a>.&nbsp;</span></p>
                                        <p class="MsoNormal" style="margin-bottom: 0.0001pt; line-height: normal; margin-left: 40px;"><span style="font-size: 10pt; font-family: verdana, sans-serif;">d) Download and Install&nbsp;</span><span style="font-size: 13.3333px;">Source Tree for windows from this <a href="https://www.sourcetreeapp.com/" target="_blank">link</a></span></p>
                                        <p class="MsoNormal" style="margin-bottom: 0in; margin-bottom: .0001pt; line-height: normal">
                                            <span style="font-size: 10pt; font-family: verdana, sans-serif;">
                                                <br />
                                            </span>
                                        </p>
                                        <p class="MsoNormal" style="margin-bottom: 0in; margin-bottom: .0001pt; line-height: normal"><span style="font-size: 10pt; font-family: verdana, sans-serif;">2) Download &amp; Setup source code from Our GitHub repository.<o:p /></span></p>
                                        <p class="MsoNormal" style="margin-bottom: 0.0001pt; line-height: normal; margin-left: 40px;"><span style="font-size: 10pt; font-family: verdana, sans-serif;">To do that below are the steps:<o:p /></span></p>
                                        <p class="MsoNormal" style="margin-bottom: 0.0001pt; line-height: normal; margin-left: 40px;"><span style="font-size: 10pt; font-family: verdana, sans-serif;">a)&nbsp;<o:p /></span><span style="font-size: 13.3333px;">Clone the&nbsp;</span><a href="https://github.com/jmgrove2016/JGInterview" target="_blank" style="font-size: 13.3333px;"><span style="color: blue;">Interview Repository</span></a><span style="font-size: 13.3333px;">.&nbsp;If you are new to using Source Tree with Github, Watch our help video from&nbsp;</span><a href="http://web.jmgrovebuildingsupply.com/Tutorials/SourceTree/GithubRepositorySetup.mp4" target="_blank" style="font-size: 13.3333px;">here</a><span style="font-size: 13.3333px;">.&nbsp;</span></p>
                                        <p class="MsoNormal" style="margin-bottom: 0.0001pt; line-height: normal; margin-left: 40px;"><span style="font-size: 13.3333px;">&nbsp; &nbsp; &nbsp; &nbsp;<span style="color: #ff0000;">Note:</span>&nbsp;</span><span style="font-size: 8pt; color: #ff0000;">In help Video, We have taken </span><span style="font-size: 8pt; font-weight: bold; color: #ff0000;">JGProspectLive</span><span style="font-size: 8pt; color: #ff0000;"> Repository example.</span></p>
                                        <p class="MsoNormal" style="margin-bottom: 0.0001pt; line-height: normal; margin-left: 40px;"><span style="font-size: 10pt;">b) Provide your Valid Github account while setting up code into your local system, which you have given at time of Accepting Technical Task from </span>Aptitude<span style="font-size: 10pt;">&nbsp;Success popup(Access to your github username you entered into success popup&nbsp;</span><span style="font-size: 13.3333px;">has already given&nbsp;</span><span style="font-size: 10pt;">&nbsp;automatically to work on our repository on github). Refer this </span><a href="http://web.jmgrovebuildingsupply.com/Resources/Help-Images/Success-Popup.png" target="_blank" style="font-size: 10pt;">image</a>&nbsp;<span style="font-size: 10pt;">for more clear understanding.</span></p>
                                        <p class="MsoNormal" style="margin-bottom: 0.0001pt; line-height: normal; margin-left: 40px;">
                                            <span style="font-size: 10pt; font-family: verdana, sans-serif;">
                                                <o:p />
                                            </span>
                                        </p>
                                        <p class="MsoNormal" style="margin-bottom: 0in; margin-bottom: .0001pt; line-height: normal"><span style="font-size: 10pt; font-family: verdana, sans-serif;">&nbsp;<o:p /></span></p>
                                        <p class="MsoNormal" style="margin-bottom: 0in; margin-bottom: .0001pt; line-height: normal"><span style="font-size: 10pt; font-family: verdana, sans-serif;">3) Setup the development environment.</span></p>
                                        <p class="MsoNormal" style="margin-bottom: 0in; margin-bottom: .0001pt; line-height: normal"></p>
                                        <p class="MsoNormal" style="margin-bottom: 0.0001pt; line-height: normal; margin-left: 40px;"><span style="font-size: 10pt;">a) Create your own branch on our repository to work on your tech task before you start coding on your assigned&nbsp;</span>Tech Task<span style="font-size: 10pt;">.&nbsp;</span><span style="font-size: 13.3333px;">If you are new to work with Github and don't know how to create your own branch, Watch our help video from&nbsp;</span><a href="http://web.jmgrovebuildingsupply.com/Tutorials/SourceTree/HowtoCreateOwnBranch.mp4" target="_blank" style="font-size: 13.3333px;">here</a><span style="font-size: 13.3333px;">.</span></p>
                                        <p class="MsoNormal" style="margin-bottom: 0.0001pt; line-height: normal; margin-left: 40px;">
                                            <span style="font-size: 10pt; font-family: verdana, sans-serif;">b) Please use connection string from web.config file of web project to connect to database.<br />
                                                <br />
                                            </span>
                                        </p>
                                        <p class="MsoNormal" style="margin-bottom: 0.0001pt; line-height: normal; margin-left: 40px;"><span style="font-size: 10pt; font-family: verdana, sans-serif;">c) Use any user from database to login into system in your local development environment. Don't try to use your own username you are using in live website because both environment are different and your username created in live is not in local environment.<o:p /></span></p>
                                        <p class="MsoNormal" style="margin-bottom: 0in; margin-bottom: .0001pt; line-height: normal"><span style="font-size: 10pt; font-family: verdana, sans-serif;">&nbsp;<o:p /></span></p>
                                        <p class="MsoNormal" style="mso-margin-top-alt: auto; mso-margin-bottom-alt: auto; line-height: normal"><span style="font-size: 10pt; font-family: verdana, sans-serif;">4) Log back into to&nbsp;<a href="http://web.jmgrovebuildingsupply.com/" target="_blank"><span style="color: blue">web.jmgrovebuildingsupply.com</span></a>, it will take you to&nbsp; IT dashboard page where you can see task assigned to you.&nbsp;</span></p>
                                        <p class="MsoNormal" style="line-height: normal; margin-left: 40px;">a) From ITDashborad, Click on TaskLink and New Task Detail page will be open, and Task Assigned to you will be Highlighted and Blinking in Yellow. Click <a href="http://web.jmgrovebuildingsupply.com/Resources/Help-Images/ITDashboard-InterviewUser.png" target="_blank">Here</a>&nbsp;for more detail image.</p>
                                        <p class="MsoNormal" style="line-height: normal; margin-left: 40px;">b) Read Task Requirements and Instructions Carefully before you jump over to code.</p>
                                        <p class="MsoNormal" style="line-height: normal; margin-left: 40px;">c) Keep track of your database related changes into separate SQL file into Your Name Folder created under Database Script folder into Solution.&nbsp;<span style="font-size: 13.3333px;">Click&nbsp;</span><a href="http://web.jmgrovebuildingsupply.com/Resources/Help-Images/Database-Files-Interview.png" target="_blank" style="font-size: 13.3333px;">Here</a><span style="font-size: 13.3333px;">&nbsp;for more detail image.</span></p>
                                        <p class="MsoNormal" style="line-height: normal; margin-left: 40px;">d) After completing Task, <span style="color: #ff0000;">Make sure you have tested it thoroughly on your local environment by comparing word to word of Task Description with your completed task. Incomplete/Poorly Tested Task submission increase chances of your rejection for position you have applied.</span></p>
                                        <p class="MsoNormal" style="line-height: normal; margin-left: 40px;"></p>
                                        <p class="MsoNormal" style="mso-margin-top-alt: auto; mso-margin-bottom-alt: auto; line-height: normal">
                                            <br />
                                        </p>
                                        <p class="MsoNormal" style="mso-margin-top-alt: auto; mso-margin-bottom-alt: auto; line-height: normal">5) Once You are satisfied with your code, Commit and Push it to remote repository. If you don't know how to commit on GitHub remote repository using Source Tree click on our help video <a href="http://web.jmgrovebuildingsupply.com/Tutorials/SourceTree/HowtoCommitChangesToGithub.mp4" target="_blank">Here</a>.</p>
                                        <p class="MsoNormal" style="line-height: normal; margin-left: 40px;">
                                            <br />
                                        </p>
                                        <p class="MsoNormal" style="mso-margin-top-alt: auto; mso-margin-bottom-alt: auto; line-height: normal">6)&nbsp;<span style="font-size: 13.3333px;">Please have all above prerequisites and your task completed, committed and ready for your interview #date# &amp; #time# (EST Time zone) with #manager#.</span></p>
                                        <p class="MsoNormal" style="font-size: 13.3333px; line-height: normal; margin-left: 40px;">
                                            <br />
                                            a)&nbsp;<b style="font-size: 13.3333px;"><span style="font-size: 10pt;">&nbsp;</span></b><span style="font-size: 10pt; color: #ff0000;">your commit message must contain, TaskID# , Your Full Name and Date &amp; Time stamp when you are&nbsp;committing&nbsp;code and notify the staffing coordinator that its been completed.</span>
                                        </p>
                                        <p class="MsoNormal" style="margin-bottom: 0in; margin-bottom: .0001pt; line-height: normal">
                                            <span style="font-size: 10pt; font-family: verdana, sans-serif; background-image: initial; background-position: initial; background-size: initial; background-repeat: initial; background-attachment: initial; background-origin: initial; background-clip: initial;">
                                                <br />
                                            </span>
                                        </p>
                                        <p class="MsoNormal" style="margin-bottom: 0in; margin-bottom: .0001pt; line-height: normal">
                                            <span style="font-size: 10pt; font-family: verdana, sans-serif; background-image: initial; background-position: initial; background-size: initial; background-repeat: initial; background-attachment: initial; background-origin: initial; background-clip: initial;">NOTE: Please have a look at advanced concepts listed here,&nbsp;</span><span style="font-size: 12.0pt; font-family: times new roman,serif; mso-fareast-font-family: times new roman"><a href="https://docs.microsoft.com/en-gb/aspnet/web-forms/" target="_self"><span style="font-size: 10.0pt; font-family: verdana,sans-serif; color: blue">https://docs.microsoft.com/en-gb/aspnet/web-forms/</span></a></span><span style="font-size: 10pt; font-family: verdana, sans-serif; background-image: initial; background-position: initial; background-size: initial; background-repeat: initial; background-attachment: initial; background-origin: initial; background-clip: initial;">&nbsp;in order to work faster and efficient with software currently we have.</span><span style="font-size: 10pt; font-family: verdana, sans-serif;"><br />
                                                <br />
                                                <!--[if !supportLineBreakNewLine]-->
                                                <br />
                                                <!--[endif]-->
                                            </span><span style="font-size: 12.0pt; font-family: times new roman,serif; mso-fareast-font-family: times new roman">
                                                <o:p />
                                            </span>
                                        </p>

                                    </div>
                                </div>
                            </div>
                        </div>
                        <div style="clear: both"></div>


                        <div style="float: right;">
                            <span id="lblFrom">{{pageFrom}}</span>&nbsp;<span id="ContentPlaceHolder1_Label5">to</span>&nbsp;
                                <span id="lblTo" style="color: #19ea19">{{pageTo}}</span>
                            <span id="lblof">of</span>
                            <span id="lblCount" style="color: red;">{{pageOf}}</span>
                            <span id="lblselectedchk" style="font-weight: bold;"></span>
                            <img src="/img/refresh.png" class="refresh" id="refreshInProgTasks">
                        </div>

                        <div style="clear: both"></div>
                        <div class="col-header">
                            <div class="col1-seqno">
                                Sequence#
                            </div>
                            <div class="col2-iddes">
                                ID#<br />
                                Designation
                            </div>
                            <div class="col3-title">
                                Parent Task<br />
                                SubTask Title
                            </div>
                            <div class="col4-assigned">
                                Status<br />
                                Assigned To
                            </div>
                            <div class="col5-hours">
                                Total Hours<br />
                                Total $
                            </div>
                            <div class="col6-notes">
                                Notes
                            </div>
                        </div>
                        <div class="noData" id="noDataIA">No Records Found!</div>
                        <!-- NG Repeat Div starts -->
                        <div ng-attr-id="divMasterTask{{Task.TaskId}}" class="div-table-row" data-ng-repeat="Task in Tasks" ng-class="{orange : Task.Status==='4', yellow: Task.Status==='3'}" repeat-end="onTopEnd()">
                            <!-- Sequence# starts -->
                            <div class="col1-seqno">
                                <a href="#/">
                                    <img src="../img/btn_maximize.png" data-taskid="{{Task.TaskId}}" onclick="expandRomansFromTask(this)" data-appended="false" />
                                </a>
                                <a ng-attr-id="autoClick{{Task.TaskId}}" href="javascript:void(0);" class="badge-hyperlink autoclickSeqEdit" ng-attr-data-taskseq="{{Task.Sequence}}" ng-attr-data-taskid="{{Task.TaskId}}" ng-attr-data-seqdesgid="{{Task.SequenceDesignationId}}"><span class="badge badge-success badge-xstext">
                                    <label ng-attr-id="SeqLabel{{Task.TaskId}}">{{getSequenceDisplayText(!Task.Sequence?"N.A.":Task.Sequence,Task.SequenceDesignationId,Task.IsTechTask === "false" ? "SS" : "TT")}}</label></span></a>

                                <a id="seqArrowUp" runat="server" style="text-decoration: none;" ng-show="!$first" ng-attr-data-taskid="{{Task.TaskId}}" href="javascript:void(0);" ng-class="{hide: Task.Sequence == null || 0}" ng-attr-data-taskseq="{{Task.Sequence}}" ng-hide="{{Task.TaskId == BlinkTaskId}}" ng-attr-data-taskdesg="{{Task.SequenceDesignationId}}" onclick="swapSequence(this,true)">&#9650;</a>
                                <a id="seqArrowDown" runat="server" style="text-decoration: none;" ng-class="{hide: Task.Sequence == null || 0}" ng-attr-data-taskid="{{Task.TaskId}}" ng-attr-data-taskseq="{{Task.Sequence}}" ng-attr-data-taskdesg="{{Task.SequenceDesignationId}}" href="javascript:void(0);" onclick="swapSequence(this,false)" ng-show="!$last">&#9660;</a>
                            </div>
                            <!-- Sequence# ends -->

                            <!-- ID# and Designation starts -->
                            <div class="col2-iddes">
                                <a ng-href="../Sr_App/TaskGenerator.aspx?TaskId={{Task.MainParentId}}&hstid={{Task.TaskId}}" oncontextmenu="openCopyBox(this);return false;" data-installid="{{Task.InstallId}}" parentdata-highlighter="{{Task.MainParentId}}" data-highlighter="{{Task.TaskId}}" class="bluetext context-menu" target="_blank">{{ Task.InstallId }}</a><br />
                                {{getDesignationString(Task.TaskDesignation)}}                                        
                            </div>
                            <!-- ID# and Designation ends -->

                            <!-- Parent Task & SubTask Title starts -->
                            <div class="col3-title">
                                {{ Task.ParentTaskTitle }}
                                        <br />
                                {{ Task.Title }}
                            </div>
                            <!-- Parent Task & SubTask Title ends -->

                            <!-- Status & Assigned To starts -->
                            <div class="col4-assigned">
                                <select id="drpStatusSubsequence{{Task.TaskId}}" onchange="changeTaskStatusClosed(this);" data-highlighter="{{Task.TaskId}}">
                                    <option ng-selected="{{Task.Status == '4'}}" value="4">InProgress</option>
                                    <%--<option ng-selected="{{Task.Status == '2'}}" style="color: red" value="2">Requested</option>--%>
                                    <option ng-selected="{{Task.Status == '3'}}" style="color: lawngreen" value="3">Request-Assigned</option>
                                    <option ng-selected="{{Task.Status == '1'}}" value="1">Open</option>
                                    <% if (IsSuperUser)
                                        { %>
                                    <%--<option ng-selected="{{Task.Status == '5'}}" value="5">Pending</option>--%>
                                    <%--<option ng-selected="{{Task.Status == '6'}}" value="6">ReOpened</option>  --%>
                                    <option ng-selected="{{Task.Status == '8'}}" value="8">SpecsInProgress-NOT OPEN</option>
                                    <%} %>

                                    <%--<option ng-selected="{{TechTask.Status == '10'}}" value="10">Finished</option>--%>
                                    <option ng-selected="{{Task.Status == '11'}}" value="11">Test Commit</option>
                                    <% if (IsSuperUser)
                                        { %>
                                    <option ng-selected="{{Task.Status == '12'}}" value="12">Live Commit</option>
                                    <option ng-selected="{{Task.Status == '7'}}" value="7">Closed</option>
                                    <option ng-selected="{{Task.Status == '14'}}" value="14">Billed</option>
                                    <option ng-selected="{{Task.Status == '9'}}" value="9">Deleted</option>
                                    <%} %>
                                </select>
                                <br />

                                <select class="ddlAssignedUsers" <%=!IsSuperUser ? "disabled" : ""%> id="ddcbSeqAssignedStaff{{Task.TaskId}}" style="width: 100%;" multiple ng-attr-data-assignedusers="{{Task.TaskAssignedUserIDs}}" data-chosen="1" data-placeholder="Select Users" onchange="EditSeqAssignedTaskUsers(this);" data-taskid="{{Task.TaskId}}" data-taskstatus="{{Task.Status}}">
                                    <option
                                        ng-repeat="item in DesignationAssignUsers"
                                        value="{{item.Id}}"
                                        label="{{item.FristName}}"
                                        class="{{item.CssClass}}">{{item.FristName}}
                                    </option>
                                </select>




                            </div>
                            <!-- Status & Assigned To ends -->

                            <!-- DueDate starts -->
                            <div class="col5-hours">
                                <div class="seqapprovalBoxes" id="SeqApprovalDiv{{Task.TaskId}}"
                                    data-adminstatusupdateddate="{{ Task.AdminStatusUpdated | date:'M/d/yyyy' }}"
                                    data-adminstatusupdatedtime="{{ Task.AdminStatusUpdated | date:'shortTime' }}"
                                    data-adminstatusupdatedtimezone="{{StringIsNullOrEmpty(Task.AdminStatusUpdated) ? '' : '(EST)' }}"
                                    data-adminstatusupdated="{{Task.AdminStatusUpdated}}"
                                    data-admindisplayname="{{StringIsNullOrEmpty(Task.AdminUserInstallId)? Task.AdminUserId : Task.AdminUserInstallId}} - {{Task.AdminUserFirstName}} {{Task.AdminUserLastName}}"
                                    data-adminstatususerid="{{Task.AdminUserId}}"
                                    data-leadstatusupdateddate="{{ Task.TechLeadStatusUpdated | date:'M/d/yyyy' }}"
                                    data-leadstatusupdatedtime="{{ Task.TechLeadStatusUpdated | date:'shortTime' }}"
                                    data-leadstatusupdatedtimezone="{{StringIsNullOrEmpty(Task.TechLeadStatusUpdated) ? '' : '(EST)' }}"
                                    data-leadstatusupdated="{{Task.ITLeadHours}}"
                                    data-leadhours="{{Task.ITLeadHours}}"
                                    data-leaddisplayname="{{StringIsNullOrEmpty(Task.TechLeadUserInstallId)? Task.TechLeadUserId : Task.TechLeadUserInstallId}} - {{Task.TechLeadUserFirstName}} {{Task.TechLeadUserLastName}}"
                                    data-leaduserid="{{Task.TechLeadUserId}}"
                                    data-userstatusupdateddate="{{ Task.OtherUserStatusUpdated | date:'M/d/yyyy' }}"
                                    data-userstatusupdatedtime="{{ Task.OtherUserStatusUpdated | date:'shortTime' }}"
                                    data-userstatusupdatedtimezone="{{StringIsNullOrEmpty(Task.OtherUserStatusUpdated) ? '' : '(EST)' }}"
                                    data-userstatusupdated="{{Task.UserHours}}"
                                    data-userhours="{{Task.UserHours}}"
                                    data-userdisplayname="{{StringIsNullOrEmpty(Task.OtherUserInstallId)? Task.OtherUserId : Task.OtherUserInstallId}} - {{Task.OtherUserFirstName}} {{Task.OtherUserLastName}}"
                                    data-useruserid="{{Task.OtherUserId}}">
                                    <div style="width: 55%; float: left;">
                                        <input type="checkbox" data-taskid="{{Task.TaskId}}" onchange="openSeqApprovalPopup(this)" id="chkngUserMaster{{Task.TaskId}}" ng-checked="{{Task.OtherUserStatus}}" ng-disabled="{{Task.OtherUserStatus}}" class="fz fz-user" title="User" />
                                        <input type="checkbox" data-taskid="{{Task.TaskId}}" onchange="openSeqApprovalPopup(this)" id="chkQAMaster{{Task.TaskId}}" class="fz fz-QA" title="QA" />
                                        <input type="checkbox" data-taskid="{{Task.TaskId}}" onchange="openSeqApprovalPopup(this)" id="chkAlphaUserMaster{{Task.TaskId}}" class="fz fz-Alpha" title="AlphaUser" />
                                        <br />
                                        <input type="checkbox" data-taskid="{{Task.TaskId}}" onchange="openSeqApprovalPopup(this)" id="chkBetaUserMaster{{Task.TaskId}}" class="fz fz-Beta" title="BetaUser" />
                                        <input type="checkbox" data-taskid="{{Task.TaskId}}" onchange="openSeqApprovalPopup(this)" id="chkngITLead{{Task.TaskId}}" ng-checked="{{Task.TechLeadStatus}}" ng-disabled="{{Task.TechLeadStatus}}" class="fz fz-techlead" title="IT Lead" />
                                        <input type="checkbox" data-taskid="{{Task.TaskId}}" onchange="openSeqApprovalPopup(this)" id="chkngAdmin{{Task.TaskId}}" ng-checked="{{Task.AdminStatus}}" ng-disabled="{{Task.AdminStatus}}" class="fz fz-admin" title="Admin" />
                                    </div>
                                    <div style="width: 42%; float: right;">
                                        <input type="checkbox" data-taskid="{{Task.TaskId}}" onchange="openSeqApprovalPopup(this)" id="chkngITLeadMaster{{Task.TaskId}}" class="fz fz-techlead largecheckbox" title="IT Lead" /><br />
                                        <input type="checkbox" data-taskid="{{Task.TaskId}}" onchange="openSeqApprovalPopup(this)" id="chkngAdminMaster{{Task.TaskId}}" class="fz fz-admin largecheckbox" title="Admin" />
                                    </div>
                                </div>


                            </div>
                            <!-- DueDate ends -->
                            <div id="col6-notes">
                                <div class="notes-section" taskid="{{Task.TaskId}}" taskmultilevellistid="0" style="position: relative; overflow-x: hidden; overflow-y: auto; min-height: 90px;">
                                    <!-- Notes starts -->
                                    <div class="notes-container div-table-col seq-notes-fixed-top main-task" taskid="{{Task.TaskId}}" taskmultilevellistid="0">
                                        Loading Notes...
                                    </div>
                                    <div class="notes-inputs">
                                        <div class="first-col">
                                            <input type="button" class="GrdBtnAdd" value="Add Notes" onclick="addNotes(this)" />
                                        </div>
                                        <div class="second-col">
                                            <textarea class="note-text textbox"></textarea>
                                        </div>
                                    </div>
                                    <!-- Notes ends -->
                                </div>

                            </div>
                            <!-- Roman Grid Starts -->
                            <div class="div-table-row roman-grid hide-div" id="roman_{{Task.TaskId}}">
                                <!--Freeze Status Grid Starts-->
                                <div class="query-section container-margin">
                                    <div class="section-container hide">
                                        <!-- HIDE -->
                                        <div class="freeze-status-row">
                                            <div class="freeze-status-col">
                                                <div class="freeze-detail-row">
                                                    <div class="freeze-detail-col">
                                                        <div class="freeze-data">
                                                            <div id="task-id" class="task-detail">Task Id: </div>
                                                            123
                                                        </div>
                                                        <div class="freeze-data">
                                                            <div id="subtask-id" class="task-detail">SubTask ID: </div>
                                                            SubTask Id
                                                        </div>
                                                    </div>
                                                    <div class="freeze-detail-col">
                                                        <div class="freeze-data">
                                                            <div id="task-title" class="task-detail">Task Title: </div>
                                                            Title
                                                        </div>
                                                        <div class="freeze-data">
                                                            <div id="subtask-title" class="task-detail">Subtask Title: </div>
                                                            SubTaskTitle
                                                        </div>
                                                    </div>
                                                </div>
                                            </div>
                                            <div class="freeze-status-col">
                                            </div>
                                            <div class="freeze-status-col">
                                                <b>Created by</b>
                                            </div>
                                        </div>
                                        <div class="freeze-status-row row-space">
                                            <div class="freeze-status-col">
                                                <div class="freeze-detail-row">
                                                    <div class="freeze-detail-col">

                                                        <div class="freeze-data">
                                                            <div class="task-status-detail">
                                                                <input type="checkbox" class="approve-checkbox fz fz-admin user-checkbox">
                                                            </div>
                                                            <div class="freeze-by-user"></div>
                                                        </div>
                                                        <div class="freeze-data">
                                                            <div class="task-status-detail">
                                                                <input type="checkbox" class="approve-checkbox fz fz-techlead user-checkbox">
                                                            </div>
                                                            <div class="freeze-by-user"></div>
                                                        </div>
                                                    </div>
                                                </div>
                                            </div>
                                            <div class="freeze-status-col">
                                                <div class="freeze-detail-col">
                                                    <div class="freeze-data">
                                                        <div class="task-status-detail">
                                                            <input type="checkbox" class="approve-checkbox fz fz-user user-checkbox">
                                                        </div>
                                                        <div class="freeze-by-user">
                                                            <div class="chosen-container chosen-container-multi" style="width: 186px;" title="" id="ddcbSeqAssignedStaffClosedTask523_chosen2">
                                                                <ul class="chosen-choices">
                                                                    <li class="search-choice"><span><span class="activeUser">Kapil K. Pancholi - </span><a style="color: blue;" href="/Sr_App/ViewSalesUser.aspx?id=3697">ITSN-A0411
                                                                    </a></span><a class="search-choice-close" data-option-array-index="1"></a></li>
                                                                </ul>
                                                            </div>
                                                            <br>
                                                            <span class="date">1/17/2018</span><span class="time">2:28 PM </span><span>(EST)</span>
                                                        </div>
                                                    </div>
                                                    <div class="freeze-data">
                                                        <div class="task-status-detail">
                                                            <input type="checkbox" class="approve-checkbox fz fz-Alpha user-checkbox">
                                                        </div>
                                                        <div class="freeze-by-user"></div>
                                                    </div>
                                                </div>
                                            </div>
                                            <div class="freeze-status-col">
                                                <div class="freeze-detail-col">
                                                </div>
                                            </div>
                                        </div>
                                    </div>
                                    <div class="section-container hide">
                                        <!-- HIDE -->
                                        <div class="freeze-status-row inline">
                                            <div class="freeze-status-header">SubTask Freeze Status: Queries/Questions/UI</div>
                                            <div class="myProgress">
                                                <div id="myBar_{{Task.TaskId}}" class="bar">
                                                    <span style="font-size: 19px; color: #fff; line-height: 32px;">33%</span>
                                                </div>
                                            </div>
                                        </div>
                                        <div class="freeze-status-row">
                                            <div class="freeze-status-col">
                                                <div class="freeze-detail-row">
                                                    <div class="freeze-detail-col">
                                                        <div class="freeze-data">
                                                            <div class="task-status-detail">Stage 1: </div>
                                                            Queries/Questions/UI
                                                        </div>
                                                        <div class="freeze-data">
                                                            <div class="task-status-detail">
                                                                <input type="checkbox" class="approve-checkbox">
                                                            </div>
                                                            <div class="big-chkbox-label">Queries/Questions Submitted</div>
                                                        </div>
                                                        <div class="freeze-data">
                                                            <div class="task-status-detail">
                                                                <input type="checkbox" class="approve-checkbox" />
                                                            </div>
                                                            <div class="big-chkbox-label">UI Submitted</div>
                                                        </div>
                                                    </div>
                                                </div>
                                            </div>
                                            <div class="freeze-status-col">
                                                <div class="freeze-detail-col">
                                                    <div class="freeze-data">
                                                        <div class="task-status-detail">Stage 2:</div>
                                                        Test Management
                                                    </div>
                                                    <div class="freeze-data">
                                                        <div class="task-status-detail">
                                                            <input type="checkbox" class="approve-checkbox" />
                                                        </div>
                                                        <div class="big-chkbox-label">Test Cases Submitted</div>
                                                    </div>
                                                </div>
                                            </div>
                                            <div class="freeze-status-col">
                                                <div class="freeze-detail-col">
                                                    <div class="freeze-data">
                                                        <div class="task-status-detail">Stage 3:</div>
                                                        Estimation
                                                    </div>
                                                    <div class="freeze-data">
                                                        <div class="task-status-detail">
                                                            <input type="checkbox" class="approve-checkbox" />
                                                        </div>
                                                        <div class="big-chkbox-label">Estimated Hours Submitted</div>
                                                    </div>
                                                </div>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                                <!--Freeze Status Grid Ends-->

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
                                                Loading, Please wait...
                                            </div>
                                        </div>
                                        <div class="div-table-col roman-col-assign">
                                        </div>
                                        <div class="div-table-col roman-col-user-status">
                                        </div>
                                        <div class="div-table-col roman-col-notes">
                                        </div>
                                    </div>
                                    <div class="div-table-row" ng-class-even="'roman-row-alternate'" ng-class-odd="'roman-row'" data-romanid="{{Roman.Id}}" ng-repeat="Roman in Romans | filter: {ParentTaskId: (Task.TaskId | num)} : true" ng-class="{'parent': Roman.IndentLevel ==1, 'child hide': Roman.IndentLevel ==2 || Roman.IndentLevel ==3}" repeat-end="onTaskExpand({{Task.TaskId}})">
                                        <div class="div-table-col roman-col-margin" ng-class="{'col-margin-nested-child': Roman.IndentLevel ==2 , 'col-margin-nested-child-level3': Roman.IndentLevel ==3}"></div>
                                        <div class="div-table-col roman-col-expand" ng-hide="Roman.IndentLevel == 2 || Roman.IndentLevel == 3">
                                            <a href="#/">
                                                <img class="expand-image" src="../img/btn_maximize.png" data-taskid="{{Task.TaskId}}" onclick="expandRomansFromRoman(this)" data-appended="false" />
                                            </a>
                                            <%--<input type="checkbox" class="roman-query-checkbox" data-romanid="{{Roman.Id}}" onclick="ShowQuerySection(this)" />--%>
                                            <input type="checkbox" class="roman-query-checkbox" data-romanid="{{Roman.Id}}" />
                                            <div class="roman-col-share">
                                                <img src="../../img/icon_share.JPG" data-taskfid="{{Task.InstallId1}}" data-tasktitle="{{Task.Title}}"
                                                    data-assigneduserid="{{Roman.TaskAssignedUserIDs}}" data-uname="{{Task.TaskAssignedUsers}}" class="share-icon installidleft"
                                                    onclick="sharePopup(this, true)" data-highlighter="{{Task.TaskId}}" style="color: Blue; cursor: pointer; display: inline;" />

                                                <a href="javascript:void(0);" id="seqArrowDown{{Roman.Id}}" style="text-decoration: none;" data-parenttaskid="{{Task.TaskId}}" data-taskid="{{Roman.Id}}" onclick="swapRomans(this, true)" ng-show="!$last">▼</a>
                                                <a href="javascript:void(0);" id="seqArrowUp{{Roman.Id}}" style="text-decoration: none;" data-parenttaskid="{{Task.TaskId}}" data-taskid="{{Roman.Id}}" onclick="swapRomans(this ,false)" ng-show="!$first">▲</a>
                                            </div>
                                        </div>
                                        <div class="div-table-col roman-col-id"><a href="../Sr_App/TaskGenerator.aspx?TaskId={{Task.MainParentId}}&hstid={{Task.TaskId}}&mcid={{Roman.Id}}" target="_blank">{{Roman.Label}}</a></div>
                                        <div class="div-table-col roman-col-title-content">
                                            <div ng-bind-html="Roman.Title | trustAsHtml" class="roman-title"></div>
                                            <div ng-bind-html="Roman.Description | trustAsHtml"></div>
                                            <div style="float: right; text-decoration: underline; color: blue; cursor: pointer;">View/Ask Query</div>
                                        </div>
                                        <div class="div-table-col roman-col-assign" ng-hide="Roman.IndentLevel == 2 || Roman.IndentLevel == 3">
                                            <select id="drpStatusRoman{{Roman.Id}}" onchange="changeTaskStatusRoman(this);" data-highlighter="{{Roman.Id}}">

                                                <option ng-selected="{{Roman.Status == 20}}" value="20">Request-Assigned-Step 1</option>
                                                <option ng-selected="{{Roman.Status == 21}}" value="21">Request-Assigned-Step 2</option>
                                                <option ng-selected="{{Roman.Status == 22}}" value="22">Request-Assigned-Step 3</option>

                                                <option ng-selected="{{Roman.Status == 4}}" value="4">InProgress</option>
                                                <%--<option ng-selected="{{Roman.Status == 2}}" style="color: red" value="2">Requested</option>--%>
                                                <option ng-selected="{{Roman.Status == 3}}" style="color: lawngreen" value="3">Request-Assigned</option>
                                                <option ng-selected="{{Roman.Status == 1}}" value="1">Open</option>
                                                <% if (IsSuperUser)
                                                    { %>
                                                <%--<option ng-selected="{{Roman.Status == 5}}" value="5">Pending</option>--%>
                                                <%--<option ng-selected="{{Roman.Status == 6}}" value="6">ReOpened</option>  --%>
                                                <option ng-selected="{{Roman.Status == 8}}" value="8">SpecsInProgress-NOT OPEN</option>
                                                <%} %>

                                                <%--<option ng-selected="{{Roman.Status == 10}}" value="10">Finished</option>--%>
                                                <option ng-selected="{{Roman.Status == 11}}" value="11">Test Commit</option>
                                                <% if (IsSuperUser)
                                                    { %>
                                                <option ng-selected="{{Roman.Status == 12}}" value="12">Live Commit</option>
                                                <option ng-selected="{{Roman.Status == 7}}" value="7">Closed</option>
                                                <option ng-selected="{{Roman.Status == 14}}" value="14">Billed</option>
                                                <option ng-selected="{{Roman.Status == 9}}" value="9">Deleted</option>
                                                <%} %>
                                            </select>
                                            <select class="ddlAssignedUsersRomans" <%=!IsSuperUser ? "disabled" : ""%>
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
                                    <div class="div-table-col roman-col-title-content">
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

                            <!-- Nested row starts -->

                            <div class="div-table-nested" ng-class="{hide : StringIsNullOrEmpty(Task.SubSeqTasks)}">

                                <!-- Body section starts -->
                                <div class="div-table-row" ng-repeat="TechTask in correctDataforAngular(Task.SubSeqTasks)" ng-class="{orange : TechTask.Status==='4', yellow: TechTask.Status==='3'}">
                                    <!-- Sequence# starts -->
                                    <div class="col1-seqno">
                                        <a href="#/">
                                            <img src="../img/btn_maximize.png" data-taskid="{{TechTask.TaskId}}" onclick="expandRomansFromTask(this)" data-appended="false" />
                                        </a>
                                        <a style="text-decoration: none;" ng-show="!$first" ng-attr-data-taskid="{{TechTask.TaskId}}" href="javascript:void(0);" class="uplink" ng-class="{hide: TechTask.Sequence == null || 0}" ng-attr-data-taskseq="{{TechTask.SubSequence}}" ng-attr-data-taskdesg="{{TechTask.SequenceDesignationId}}" onclick="swapSubSequence(this,true)">&#9650;</a><a style="text-decoration: none;" ng-class="{hide: TechTask.Sequence == null || 0}" ng-attr-data-taskid="{{TechTask.TaskId}}" ng-attr-data-taskseq="{{TechTask.SubSequence}}" class="downlink" ng-attr-data-taskdesg="{{TechTask.SequenceDesignationId}}" href="javascript:void(0);" ng-show="!$last" onclick="swapSubSequence(this,false)">&#9660;</a>
                                        <a ng-attr-id="autoClick{{Task.TaskId}}" href="javascript:void(0);" class="badge-hyperlink autoclickSeqEdit" ng-attr-data-taskid="{{TechTask.TaskId}}" ng-attr-data-seqdesgid="{{TechTask.SequenceDesignationId}}"><span class="badge badge-error badge-xstext">
                                            <label ng-attr-id="SeqLabel{{TechTask.TaskId}}">{{getSequenceDisplayText(!TechTask.Sequence?"N.A.":TechTask.Sequence + " (" + toRoman(TechTask.SubSequence)+ ")",TechTask.SequenceDesignationId,TechTask.IsTechTask == "false" ? "SS" : "TT")}}</label></span></a>
                                        <div class="handle-counter" ng-class="{hide: TechTask.TaskId != HighLightTaskId}" ng-attr-id="divSeq{{TechTask.TaskId}}">
                                            <input type="text" class="textbox hide" ng-attr-data-original-val='{{ TechTask.Sequence == null && 0 || TechTask.Sequence}}' ng-attr-data-original-desgid="{{TechTask.SequenceDesignationId}}" ng-attr-id='txtSeq{{TechTask.TaskId}}' value="{{  TechTask.Sequence == null && 0 || TechTask.Sequence}}" />


                                        </div>
                                    </div>
                                    <!-- Sequence# ends -->

                                    <!-- ID# and Designation starts -->
                                    <div class="col2-iddes">
                                        <a ng-href="../Sr_App/TaskGenerator.aspx?TaskId={{TechTask.MainParentId}}&hstid={{TechTask.TaskId}}" oncontextmenu="openCopyBox(this);return false;" data-installid="{{TechTask.InstallId}}" parentdata-highlighter="{{TechTask.MainParentId}}" data-highlighter="{{TechTask.TaskId}}" class="bluetext context-menu" target="_blank">{{ TechTask.InstallId }}</a><br />
                                        {{getDesignationString(TechTask.TaskDesignation)}}
                                        <div ng-attr-id="divSeqDesg{{TechTask.TaskId}}" ng-class="{hide: TechTask.TaskId != HighLightTaskId}">
                                            <select class="textbox hide" ng-attr-data-taskid="{{TechTask.TaskId}}" ng-options="item as item.Name for item in ParentTaskDesignations track by item.Id" ng-model="DesignationSelectModel[$index]">
                                            </select>
                                        </div>
                                    </div>
                                    <!-- ID# and Designation ends -->

                                    <!-- Parent Task & SubTask Title starts -->
                                    <div class="col3-title">
                                        {{ TechTask.ParentTaskTitle }}
                                        <br />
                                        {{ TechTask.Title }}
                                    </div>
                                    <!-- Parent Task & SubTask Title ends -->

                                    <!-- Status & Assigned To starts -->
                                    <div class="col4-assigned">
                                        <select id="drpStatusSubsequenceNested{{TechTask.TaskId}}" onchange="changeTaskStatusClosed(this);" data-highlighter="{{TechTask.TaskId}}">

                                            <option ng-selected="{{TechTask.Status == '4'}}" value="4">InProgress</option>
                                            <%--<option ng-selected="{{TechTask.Status == '2'}}" style="color: red" value="2">Requested</option>--%>
                                            <option ng-selected="{{TechTask.Status == '3'}}" style="color: lawngreen" value="3">Request-Assigned</option>
                                            <option ng-selected="{{TechTask.Status == '1'}}" value="1">Open</option>
                                            <% if (IsSuperUser)
                                                { %>
                                            <%--<option ng-selected="{{TechTask.Status == '5'}}" value="5">Pending</option>--%>
                                            <%--<option ng-selected="{{TechTask.Status == '6'}}" value="6">ReOpened</option>  --%>
                                            <option ng-selected="{{TechTask.Status == '8'}}" value="8">SpecsInProgress-NOT OPEN</option>
                                            <%} %>

                                            <%--<option ng-selected="{{TechTask.Status == '10'}}" value="10">Finished</option>--%>
                                            <option ng-selected="{{TechTask.Status == '11'}}" value="11">Test Commit</option>
                                            <% if (IsSuperUser)
                                                { %>
                                            <option ng-selected="{{TechTask.Status == '12'}}" value="12">Live Commit</option>
                                            <option ng-selected="{{TechTask.Status == '7'}}" value="7">Closed</option>
                                            <option ng-selected="{{TechTask.Status == '14'}}" value="14">Billed</option>
                                            <option ng-selected="{{TechTask.Status == '9'}}" value="9">Deleted</option>
                                            <%} %>
                                        </select>
                                        <br />
                                        <select <%=!IsSuperUser ? "disabled" : ""%> id="ddcbSeqAssignedIA{{TechTask.TaskId}}" style="width: 100%;" multiple ng-attr-data-assignedusers="{{TechTask.TaskAssignedUserIDs}}" data-chosen="1" data-placeholder="Select Users" onchange="EditSeqAssignedTaskUsers(this);" data-taskid="{{TechTask.TaskId}}" data-taskstatus="{{TechTask.Status}}">
                                            <option
                                                ng-repeat="item in DesignationAssignUsers"
                                                value="{{item.Id}}"
                                                label="{{item.FristName}}"
                                                class="{{item.CssClass}}">{{item.FristName}}
                                                
                                            </option>
                                        </select>
                                    </div>
                                    <!-- Status & Assigned To ends -->
                                    <div class="col5-hours">
                                        <div class="seqapprovalBoxes" id="SeqApprovalDiv{{TechTask.TaskId}}"
                                            data-adminstatusupdateddate="{{ TechTask.AdminStatusUpdated | date:'M/d/yyyy' }}"
                                            data-adminstatusupdatedtime="{{ TechTask.AdminStatusUpdated | date:'shortTime' }}"
                                            data-adminstatusupdatedtimezone="{{StringIsNullOrEmpty(TechTask.AdminStatusUpdated) ? '' : '(EST)' }}"
                                            data-adminstatusupdated="{{TechTask.AdminStatusUpdated}}"
                                            data-admindisplayname="{{StringIsNullOrEmpty(TechTask.AdminUserInstallId)? TechTask.AdminUserId : TechTask.AdminUserInstallId}} - {{TechTask.AdminUserFirstName}} {{TechTask.AdminUserLastName}}"
                                            data-adminstatususerid="{{TechTask.AdminUserId}}"
                                            data-leadstatusupdateddate="{{ TechTask.TechLeadStatusUpdated | date:'M/d/yyyy' }}"
                                            data-leadstatusupdatedtime="{{ TechTask.TechLeadStatusUpdated | date:'shortTime' }}"
                                            data-leadstatusupdatedtimezone="{{StringIsNullOrEmpty(TechTask.TechLeadStatusUpdated) ? '' : '(EST)' }}"
                                            data-leadstatusupdated="{{TechTask.ITLeadHours}}"
                                            data-leadhours="{{TechTask.ITLeadHours}}"
                                            data-leaddisplayname="{{StringIsNullOrEmpty(TechTask.TechLeadUserInstallId)? TechTask.TechLeadUserId : TechTask.TechLeadUserInstallId}} - {{TechTask.TechLeadUserFirstName}} {{TechTask.TechLeadUserLastName}}"
                                            data-leaduserid="{{TechTask.TechLeadUserId}}"
                                            data-userstatusupdateddate="{{ TechTask.OtherUserStatusUpdated | date:'M/d/yyyy' }}"
                                            data-userstatusupdatedtime="{{ TechTask.OtherUserStatusUpdated | date:'shortTime' }}"
                                            data-userstatusupdatedtimezone="{{StringIsNullOrEmpty(TechTask.OtherUserStatusUpdated) ? '' : '(EST)' }}"
                                            data-userstatusupdated="{{TechTask.UserHours}}"
                                            data-userhours="{{TechTask.UserHours}}"
                                            data-userdisplayname="{{StringIsNullOrEmpty(TechTask.OtherUserInstallId)? TechTask.OtherUserId : TechTask.OtherUserInstallId}} - {{TechTask.OtherUserFirstName}} {{TechTask.OtherUserLastName}}"
                                            data-useruserid="{{TechTask.OtherUserId}}">
                                            <div style="width: 55%; float: left;">
                                                <input type="checkbox" data-taskid="{{TechTask.TaskId}}" onchange="openSeqApprovalPopup(this)" id="chkngUserNested{{TechTask.TaskId}}" ng-checked="{{TechTask.OtherUserStatus}}" ng-disabled="{{TechTask.OtherUserStatus}}" class="fz fz-user" title="User" />
                                                <input type="checkbox" data-taskid="{{TechTask.TaskId}}" onchange="openSeqApprovalPopup(this)" id="chkQANested{{TechTask.TaskId}}" class="fz fz-QA" title="QA" />
                                                <input type="checkbox" data-taskid="{{TechTask.TaskId}}" onchange="openSeqApprovalPopup(this)" id="chkAlphaUserNested{{TechTask.TaskId}}" class="fz fz-Alpha" title="AlphaUser" />
                                                <br />
                                                <input type="checkbox" data-taskid="{{TechTask.TaskId}}" onchange="openSeqApprovalPopup(this)" id="chkBetaUserNested{{TechTask.TaskId}}" class="fz fz-Beta" title="BetaUser" />
                                                <input type="checkbox" data-taskid="{{TechTask.TaskId}}" onchange="openSeqApprovalPopup(this)" id="chkngITLeadNested{{TechTask.TaskId}}" ng-checked="{{TechTask.TechLeadStatus}}" ng-disabled="{{TechTask.TechLeadStatus}}" class="fz fz-techlead" title="IT Lead" />
                                                <input type="checkbox" data-taskid="{{TechTask.TaskId}}" onchange="openSeqApprovalPopup(this)" id="chkngAdminNested{{TechTask.TaskId}}" ng-checked="{{TechTask.AdminStatus}}" ng-disabled="{{TechTask.AdminStatus}}" class="fz fz-admin" title="Admin" />
                                            </div>
                                            <div style="width: 43%; float: right;">
                                                <input type="checkbox" data-taskid="{{TechTask.TaskId}}" onchange="openSeqApprovalPopup(this)" id="chkngITLeadMasterNested{{TechTask.TaskId}}" class="fz fz-techlead largecheckbox" title="IT Lead" /><br />
                                                <input type="checkbox" data-taskid="{{TechTask.TaskId}}" onchange="openSeqApprovalPopup(this)" id="chkngAdminMasterNested{{TechTask.TaskId}}" class="fz fz-admin largecheckbox" title="Admin" />
                                            </div>
                                        </div>
                                    </div>
                                    <div class="col6-notes">
                                        <div class="notes-section" taskid="{{TechTask.TaskId}}" taskmultilevellistid="0" style="position: relative; overflow-x: hidden; overflow-y: auto; min-height: 90px; width: 320px !important;">
                                            <div class="div-table-col seq-notes-fixed-top sub-task" taskid="{{TechTask.TaskId}}" taskmultilevellistid="0">
                                                Loading Notes...
                                            </div>
                                            <div class="notes-inputs">
                                                <div class="first-col">
                                                    <input type="button" class="GrdBtnAdd" value="Add Notes" onclick="addNotes(this)" />
                                                </div>
                                                <div class="second-col">
                                                    <textarea class="note-text textbox"></textarea>
                                                </div>
                                            </div>
                                        </div>
                                    </div>
                                    <!-- Roman Grid Starts -->
                                    <div class="div-table-row roman-grid hide-div" id="roman_{{TechTask.TaskId}}">
                                        <!--Freeze Status Grid Starts-->
                                        <div class="query-section container-margin">
                                            <div class="section-container hide">
                                                <div class="freeze-status-row">
                                                    <div class="freeze-status-col">
                                                        <div class="freeze-detail-row">
                                                            <div class="freeze-detail-col">
                                                                <div class="freeze-data">
                                                                    <div id="task-id-sub" class="task-detail">Task Id: </div>
                                                                    123
                                                                </div>
                                                                <div class="freeze-data">
                                                                    <div id="sub-subtask-id" class="task-detail">SubTask ID: </div>
                                                                    SubTask Id
                                                                </div>
                                                            </div>
                                                            <div class="freeze-detail-col">
                                                                <div class="freeze-data">
                                                                    <div id="sub-task-title" class="task-detail">Task Title: </div>
                                                                    Title
                                                                </div>
                                                                <div class="freeze-data">
                                                                    <div id="sub-subtask-title" class="task-detail">Subtask Title: </div>
                                                                    SubTaskTitle
                                                                </div>
                                                            </div>
                                                        </div>
                                                    </div>
                                                    <div class="freeze-status-col">
                                                    </div>
                                                    <div class="freeze-status-col">
                                                        <b>Created by</b>
                                                    </div>
                                                </div>
                                                <div class="freeze-status-row row-space">
                                                    <div class="freeze-status-col">
                                                        <div class="freeze-detail-row">
                                                            <div class="freeze-detail-col">

                                                                <div class="freeze-data">
                                                                    <div class="task-status-detail">
                                                                        <input type="checkbox" class="approve-checkbox fz fz-admin user-checkbox">
                                                                    </div>
                                                                    <div class="freeze-by-user"></div>
                                                                </div>
                                                                <div class="freeze-data">
                                                                    <div class="task-status-detail">
                                                                        <input type="checkbox" class="approve-checkbox fz fz-techlead user-checkbox">
                                                                    </div>
                                                                    <div class="freeze-by-user"></div>
                                                                </div>
                                                            </div>
                                                        </div>
                                                    </div>
                                                    <div class="freeze-status-col">
                                                        <div class="freeze-detail-col">
                                                            <div class="freeze-data">
                                                                <div class="task-status-detail">
                                                                    <input type="checkbox" class="approve-checkbox fz fz-user user-checkbox">
                                                                </div>
                                                                <div class="freeze-by-user">
                                                                    <div class="chosen-container chosen-container-multi" style="width: 186px;" title="">
                                                                        <ul class="chosen-choices">
                                                                            <li class="search-choice"><span><span class="activeUser">Kapil K. Pancholi - </span><a style="color: blue;" href="/Sr_App/ViewSalesUser.aspx?id=3697">ITSN-A0411
                                                                            </a></span><a class="search-choice-close" data-option-array-index="1"></a></li>
                                                                        </ul>
                                                                    </div>
                                                                    <br>
                                                                    <span class="date">1/17/2018</span><span class="time">2:28 PM </span><span>(EST)</span>
                                                                </div>
                                                            </div>
                                                            <div class="freeze-data">
                                                                <div class="task-status-detail">
                                                                    <input type="checkbox" class="approve-checkbox fz fz-Alpha user-checkbox">
                                                                </div>
                                                                <div class="freeze-by-user"></div>
                                                            </div>
                                                        </div>
                                                    </div>
                                                    <div class="freeze-status-col">
                                                        <div class="freeze-detail-col">
                                                        </div>
                                                    </div>
                                                </div>
                                            </div>
                                            <div class="section-container hide">
                                                <div class="freeze-status-row inline">
                                                    <div class="freeze-status-header">SubTask Freeze Status: Queries/Questions/UI</div>
                                                    <div class="myProgress">
                                                        <div id="myBar_{{TechTask.TaskId}}" class="bar">
                                                            <span style="font-size: 19px; color: #fff; line-height: 32px;">33%</span>
                                                        </div>
                                                    </div>
                                                </div>
                                                <div class="freeze-status-row">
                                                    <div class="freeze-status-col">
                                                        <div class="freeze-detail-row">
                                                            <div class="freeze-detail-col">
                                                                <div class="freeze-data">
                                                                    <div class="task-status-detail">Stage 1: </div>
                                                                    Queries/Questions/UI
                                                                </div>
                                                                <div class="freeze-data">
                                                                    <div class="task-status-detail">
                                                                        <input type="checkbox" class="approve-checkbox">
                                                                    </div>
                                                                    <div class="big-chkbox-label">Queries/Questions Submitted</div>
                                                                </div>
                                                                <div class="freeze-data">
                                                                    <div class="task-status-detail">
                                                                        <input type="checkbox" class="approve-checkbox" />
                                                                    </div>
                                                                    <div class="big-chkbox-label">UI Submitted</div>
                                                                </div>
                                                            </div>
                                                        </div>
                                                    </div>
                                                    <div class="freeze-status-col">
                                                        <div class="freeze-detail-col">
                                                            <div class="freeze-data">
                                                                <div class="task-status-detail">Stage 2:</div>
                                                                Test Management
                                                            </div>
                                                            <div class="freeze-data">
                                                                <div class="task-status-detail">
                                                                    <input type="checkbox" class="approve-checkbox" />
                                                                </div>
                                                                <div class="big-chkbox-label">Test Cases Submitted</div>
                                                            </div>
                                                        </div>
                                                    </div>
                                                    <div class="freeze-status-col">
                                                        <div class="freeze-detail-col">
                                                            <div class="freeze-data">
                                                                <div class="task-status-detail">Stage 3:</div>
                                                                Estimation
                                                            </div>
                                                            <div class="freeze-data">
                                                                <div class="task-status-detail">
                                                                    <input type="checkbox" class="approve-checkbox" />
                                                                </div>
                                                                <div class="big-chkbox-label">Estimated Hours Submitted</div>
                                                            </div>
                                                        </div>
                                                    </div>
                                                </div>
                                            </div>
                                        </div>
                                        <!--Freeze Status Grid Ends-->

                                        <div id="romanList_{{TechTask.TaskId}}" class="section-container">
                                            <div class="div-table-row">
                                                <div class="div-table-col roman-col-margin"></div>
                                                <div class="div-table-col roman-col-expand"></div>
                                                <div class="div-table-col roman-col-id">ID#</div>
                                                <div class="div-table-col roman-col-title">Title: Content</div>
                                                <div class="div-table-col roman-col-assign"></div>
                                            </div>
                                            <div class="div-table-row">
                                                <div class="div-table-col roman-col-margin"></div>
                                                <div class="div-table-col roman-col-expand">
                                                </div>
                                                <div class="div-table-col roman-col-id ng-binding"></div>
                                                <div class="div-table-col roman-col-share">
                                                </div>
                                                <div class="div-table-col roman-col-title-content">
                                                    <div style="float: right;" id="LoadingRomans{{TechTask.TaskId}}">
                                                        Loading, Please wait...
                                                    </div>
                                                </div>
                                                <div class="div-table-col roman-col-assign">
                                                </div>
                                                <div class="div-table-col roman-col-user-status">
                                                </div>
                                                <div class="div-table-col roman-col-notes">
                                                </div>
                                            </div>
                                            <div class="div-table-row data-row" data-romanid="{{Roman.Id}}" ng-repeat="Roman in Romans | filter: {ParentTaskId: (TechTask.TaskId | num)} : true" ng-class="{'parent': Roman.IndentLevel ==1, 'child hide': Roman.IndentLevel ==2 || Roman.IndentLevel ==3}" repeat-end="onTaskExpand({{TechTask.TaskId}})">
                                                <div class="div-table-col roman-col-margin" ng-class="{'col-margin-nested-child': Roman.IndentLevel ==2 , 'col-margin-nested-child-level3': Roman.IndentLevel ==3}"></div>
                                                <div class="div-table-col roman-col-expand" ng-hide="Roman.IndentLevel == 2 || Roman.IndentLevel == 3">
                                                    <a href="#/">
                                                        <img class="expand-image" src="../img/btn_maximize.png" data-taskid="{{TechTask.TaskId}}" onclick="expandRomansFromRoman(this)" data-appended="false" />
                                                    </a>
                                                    <input type="checkbox" />
                                                    <div class="roman-col-share">
                                                        <img src="../../img/icon_share.JPG" data-taskfid="{{TechTask.InstallId1}}" data-tasktitle="{{TechTask.Title}}"
                                                            data-assigneduserid="{{Roman.TaskAssignedUserIDs}}" data-uname="{{TechTask.TaskAssignedUsers}}" class="share-icon installidleft"
                                                            onclick="sharePopup(this)" data-highlighter="{{TechTask.TaskId}}" style="color: Blue; cursor: pointer; display: inline;" />

                                                        <a href="javascript:void(0);" style="text-decoration: none;" data-parenttaskid="{{TechTask.TaskId}}" data-taskid="{{Roman.Id}}" onclick="swapRomans(this, true)" ng-show="!$last">▼</a>
                                                        <a href="javascript:void(0);" style="text-decoration: none;" data-parenttaskid="{{TechTask.TaskId}}" data-taskid="{{Roman.Id}}" onclick="swapRomans(this ,false)" ng-show="!$first">▲</a>
                                                    </div>
                                                </div>
                                                <div class="div-table-col roman-col-id"><a href="../Sr_App/TaskGenerator.aspx?TaskId={{TechTask.MainParentId}}&hstid={{TechTask.TaskId}}&mcid={{Roman.Id}}" target="_blank">{{Roman.Label}}</a></div>
                                                <div class="div-table-col roman-col-title-content">
                                                    <div ng-bind-html="Roman.Description | trustAsHtml"></div>
                                                    <div style="float: right; text-decoration: underline; color: blue; cursor: pointer;">View/Ask Query</div>
                                                </div>
                                                <div class="div-table-col roman-col-assign">
                                                    <select onchange="changeTaskStatusRoman(this);" data-highlighter="{{Roman.Id}}">
                                                        <option ng-selected="{{Roman.Status == 4}}" value="4">InProgress</option>
                                                        <%--<option ng-selected="{{Roman.Status == 2}}" style="color: red" value="2">Requested</option>--%>
                                                        <option ng-selected="{{Roman.Status == 3}}" style="color: lawngreen" value="3">Request-Assigned</option>
                                                        <option ng-selected="{{Roman.Status == 1}}" value="1">Open</option>
                                                        <% if (IsSuperUser)
                                                            { %>
                                                        <%--<option ng-selected="{{Roman.Status == 5}}" value="5">Pending</option>--%>
                                                        <%--<option ng-selected="{{Roman.Status == 6}}" value="6">ReOpened</option>  --%>
                                                        <option ng-selected="{{Roman.Status == 8}}" value="8">SpecsInProgress-NOT OPEN</option>
                                                        <%} %>

                                                        <%--<option ng-selected="{{Roman.Status == 10}}" value="10">Finished</option>--%>
                                                        <option ng-selected="{{Roman.Status == 11}}" value="11">Test Commit</option>
                                                        <% if (IsSuperUser)
                                                            { %>
                                                        <option ng-selected="{{Roman.Status == 12}}" value="12">Live Commit</option>
                                                        <option ng-selected="{{Roman.Status == 7}}" value="7">Closed</option>
                                                        <option ng-selected="{{Roman.Status == 14}}" value="14">Billed</option>
                                                        <option ng-selected="{{Roman.Status == 9}}" value="9">Deleted</option>
                                                        <%} %>
                                                    </select>
                                                    <select class="ddlAssignedUsersRomans" <%=!IsSuperUser ? "disabled" : ""%>
                                                        style="width: 200px !important;" multiple
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
                                                <div class="div-table-col roman-col-user-status">
                                                    <input type="checkbox" data-taskid="{{Roman.Id}}" onchange="ShowFeedbackFreezePopup(this)" ng-checked="" ng-disabled="" class="fz fz-admin" title="Admin">
                                                    <input type="checkbox" data-taskid="{{Roman.Id}}" onchange="ShowFeedbackFreezePopup(this)" ng-checked="{{Roman.EstimatedHoursITLead}}" ng-disabled="{{Roman.EstimatedHoursITLead}}" class="fz fz-techlead" title="IT Lead">
                                                    <input type="checkbox" data-taskid="{{Roman.Id}}" onchange="ShowFeedbackFreezePopup(this)" ng-checked="{{Roman.EstimatedHoursUser}}" ng-disabled="{{Roman.EstimatedHoursUser}}" class="fz fz-user" title="User">
                                                    <input type="checkbox" data-taskid="{{Roman.Id}}" onchange="ShowFeedbackFreezePopup(this)" class="fz fz-Alpha" title="AlphaUser">
                                                </div>
                                                <div class="div-table-col roman-col-notes">
                                                    <div class="notes-section" userchatgroupid="{{Roman.UserChatGroupId}}" taskid="{{Roman.ParentTaskId}}" taskmultilevellistid="{{Roman.Id}}" style="position: relative; overflow-x: hidden; overflow-y: auto; min-height: 90px;">
                                                        <!-- Notes starts -->
                                                        <div class="note-list" style="height: 60px;">
                                                            <table onclick="" class="notes-table" cellspacing="0" cellpadding="0">
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
                                            <div class="div-table-col roman-col-title-content">
                                                <div style="float: right;">
                                                    <button data-parent-taskid="{{TechTask.TaskId}}" data-val-commandname="{{TechTask.TaskLevel}}#{{TechTask.InstallId1}}#{{TechTask.TaskId}}#1"
                                                        data-val-tasklvl="{{TechTask.TaskLevel}}" data-val-commandargument="{{TechTask.TaskId}}"
                                                        data-installid="{{TechTask.InstallId}}"
                                                        type="button" id="lbtnAddNewSubTask_Sub{{TechTask.TaskId}}" onclick="javascript:OpenAddTaskPopup(this);"
                                                        style="color: Blue; text-decoration: underline; cursor: pointer; background: none;">
                                                        Add New Task</button>
                                                    <a href="../Sr_App/TaskGenerator.aspx?TaskId={{TechTask.MainParentId}}&hstid={{TechTask.TaskId}}" class="bluetext context-menu"
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
                                <!-- Body section ends -->

                            </div>

                            <!-- Nested row ends -->

                        </div>
                    </div>



                </div>

            </div>
            <!--Top Grid Records Ends-->


            <!--Top Grid Pager Starts-->
            <div class="text-center" style="float: right">
                <jgpager page="{{page}}" pages-count="{{pagesCount}}" total-count="{{TotalRecords}}" search-func="getTasks(page)"></jgpager>
            </div>
            <!--Top Grid Pager Ends-->

            <!--Test-Cases Grid Starts-->
            <div class="query-section hide">
                <div class="query-header">Test cases for:  <a href="#">ITSN092-XIV-I</a></div>
                <div class="query-row-header">
                    <div class="query-col id">ID</div>

                    <div class="query-col query">Title</div>
                    <div class="query-col status">Steps</div>
                    <div class="query-col created-for">Last Updated By</div>
                </div>
                <div class="query-row row-even">

                    <div class="query-col id">TC-1-ITSN-0058</div>

                    <div class="query-col query">What will be the title of this grid?</div>
                    <div class="query-col steps"><a href="#">Steps & More</a></div>
                    <div class="query-col created-for">
                        <div class="chosen-container chosen-container-multi" style="width: 186px;" title="" id="ddcbSeqAssignedStaffClosedTask523_chosen2">
                            <ul class="chosen-choices">
                                <li class="search-choice"><span><span class="activeUser">Kapil K. Pancholi - </span><a style="color: blue;" href="/Sr_App/ViewSalesUser.aspx?id=3697">ITSN-A0411
                                </a></span><a class="search-choice-close" data-option-array-index="1"></a></li>
                            </ul>
                        </div>
                        <br />
                        <span class="date">1/17/2018</span><span class="time">2:28 PM </span><span>(EST)</span>
                    </div>
                </div>
                <div class="query-row row-odd">

                    <div class="query-col id">TC-2-ADM34-0058</div>

                    <div class="query-col query">I don't understand 4 checkboxes flow, can you please update me for that?</div>
                    <div class="query-col steps"><a href="#">Steps & More</a></div>
                    <div class="query-col created-for">
                        <div class="chosen-container chosen-container-multi" style="width: 186px;" title="" id="ddcbSeqAssignedStaffClosedTask523_chosen2">
                            <ul class="chosen-choices">
                                <li class="search-choice"><span><span class="activeUser">Kapil K. Pancholi - </span><a style="color: blue;" href="/Sr_App/ViewSalesUser.aspx?id=3697">ITSN-A0411
                                </a></span><a class="search-choice-close" data-option-array-index="1"></a></li>
                            </ul>
                        </div>
                        <br />
                        <span class="date">1/17/2018</span><span class="time">2:28 PM </span><span>(EST)</span>
                    </div>
                </div>
                <div class="query-row row-even">

                    <div class="query-col id">TC-3-ITSN-0058</div>

                    <div class="query-col query">What will be the title of this grid?</div>
                    <div class="query-col steps"><a href="#">Steps & More</a></div>
                    <div class="query-col created-for">
                        <div class="chosen-container chosen-container-multi" style="width: 186px;" title="" id="ddcbSeqAssignedStaffClosedTask523_chosen2">
                            <ul class="chosen-choices">
                                <li class="search-choice"><span><span class="activeUser">Kapil K. Pancholi - </span><a style="color: blue;" href="/Sr_App/ViewSalesUser.aspx?id=3697">ITSN-A0411
                                </a></span><a class="search-choice-close" data-option-array-index="1"></a></li>
                            </ul>
                        </div>
                        <br />
                        <span class="date">1/17/2018</span><span class="time">2:28 PM </span><span>(EST)</span>
                    </div>
                </div>
                <div class="query-row row-odd">

                    <div class="query-col id">TC-4-ADM34-0058</div>

                    <div class="query-col query">I don't understand 4 checkboxes flow, can you please update me for that?</div>
                    <div class="query-col steps"><a href="#">Steps & More</a></div>
                    <div class="query-col created-for">
                        <div class="chosen-container chosen-container-multi" style="width: 186px;" title="" id="ddcbSeqAssignedStaffClosedTask523_chosen2">
                            <ul class="chosen-choices">
                                <li class="search-choice"><span><span class="activeUser">Kapil K. Pancholi - </span><a style="color: blue;" href="/Sr_App/ViewSalesUser.aspx?id=3697">ITSN-A0411
                                </a></span><a class="search-choice-close" data-option-array-index="1"></a></li>
                            </ul>
                        </div>
                        <br />
                        <span class="date">1/17/2018</span><span class="time">2:28 PM </span><span>(EST)</span>
                    </div>
                </div>

                <div class="query-row row-even">

                    <div class="query-col id">TC-5-ITSN-0058</div>

                    <div class="query-col query">What will be the title of this grid?</div>
                    <div class="query-col steps"><a href="#">Steps & More</a></div>
                    <div class="query-col created-for">
                        <div class="chosen-container chosen-container-multi" style="width: 186px;" title="" id="ddcbSeqAssignedStaffClosedTask523_chosen2">
                            <ul class="chosen-choices">
                                <li class="search-choice"><span><span class="activeUser">Kapil K. Pancholi - </span><a style="color: blue;" href="/Sr_App/ViewSalesUser.aspx?id=3697">ITSN-A0411
                                </a></span><a class="search-choice-close" data-option-array-index="1"></a></li>
                            </ul>
                        </div>
                        <br />
                        <span class="date">1/17/2018</span><span class="time">2:28 PM </span><span>(EST)</span>
                    </div>
                </div>
                <div class="query-row row-odd">

                    <div class="query-col id">TC-6-ADM34-0058</div>

                    <div class="query-col query">I don't understand 4 checkboxes flow, can you please update me for that?</div>
                    <div class="query-col steps"><a href="#">Steps & More</a></div>
                    <div class="query-col created-for">
                        <div class="chosen-container chosen-container-multi" style="width: 186px;" title="" id="ddcbSeqAssignedStaffClosedTask523_chosen2">
                            <ul class="chosen-choices">
                                <li class="search-choice"><span><span class="activeUser">Kapil K. Pancholi - </span><a style="color: blue;" href="/Sr_App/ViewSalesUser.aspx?id=3697">ITSN-A0411
                                </a></span><a class="search-choice-close" data-option-array-index="1"></a></li>
                            </ul>
                        </div>
                        <br />
                        <span class="date">1/17/2018</span><span class="time">2:28 PM </span><span>(EST)</span>
                    </div>
                </div>
                <div class="query-row row-even">
                    <a href="#">Add Test Case</a>
                </div>
            </div>
            <!--Test-Cases Grid Ends-->

            <!-- Steps & More Grid Starts -->
            <div class="query-section hide">
                <div class="query-header">Add Test Case</div>
                <div class="query-row form-input">
                    <div class="query-col test-case-id">
                        ID
                    </div>
                    <div class="step-col-input">
                        <a href="#">TC-5-ITSN-0058</a>

                    </div>
                </div>
                <div class="query-row form-input">
                    <div class="query-col input-title">Title</div>
                    <div class="step-col-input">
                        <input type="text" class="text-query">
                    </div>
                </div>

                <div class="query-header">
                    <br />
                    Steps</div>
                <div class="query-row-header">
                    <div class="query-col id">Steps</div>

                    <div class="query-col query">Action</div>
                    <div class="query-col status">Expected Result</div>
                    <div class="query-col created-for">Attachments</div>
                </div>
                <div class="query-row row-even">

                    <div class="query-col id">1</div>

                    <div class="query-col query">What will be the title of this grid?</div>
                    <div class="query-col steps">R Step 1</div>
                    <div class="query-col created-for">
                    </div>
                </div>
                <div class="query-row row-odd">

                    <div class="query-col id">2</div>

                    <div class="query-col query">I don't understand 4 checkboxes flow, can you please update me for that?</div>
                    <div class="query-col steps">R Step 2</div>
                    <div class="query-col created-for">
                    </div>
                </div>
                <div class="query-row row-even">

                    <div class="query-col id">3</div>

                    <div class="query-col query">What will be the title of this grid?</div>
                    <div class="query-col steps">R Step 3</div>
                    <div class="query-col created-for">
                    </div>
                </div>
                <div class="query-row row-odd">

                    <div class="query-col id">4</div>

                    <div class="query-col query">I don't understand 4 checkboxes flow, can you please update me for that?</div>
                    <div class="query-col steps">R Step 4</div>
                    <div class="query-col created-for">
                    </div>
                </div>

                <div class="query-row row-even">

                    <div class="query-col id">5</div>

                    <div class="query-col query">What will be the title of this grid?</div>
                    <div class="query-col steps">R Step 5</div>
                    <div class="query-col created-for">
                    </div>
                </div>
                <div class="query-row row-odd">
                    <div class="query-col id"></div>
                    <div class="step-col-ghost">
                        <input type="text" class="text-step-ghost" placeholder="Click or type here to add a step">
                    </div>
                    <div class="query-col steps"></div>
                    <div class="query-col created-for">
                    </div>
                </div>
                <div class="query-row row-even">
                    <input type="button" class="send-button" value="Save">
                </div>
            </div>
            <!-- Steps & More Grid Ends -->

            <!--Query Grid Starts-->
            <div class="query-section" id="query-grid" style="display: none">
                <div class="query-header">Submit Query for:  <a href="#">ITSN092-XIV-I</a></div>
                <div class="query-row">
                    <div class="row-expand"></div>
                    <div class="query-col id"></div>
                    <div class="col-chat">
                        <input type="text" placeholder="type your query..." class="text-query" id="txtQueryText">
                    </div>
                </div>
                <div class="query-row">
                    <div class="row-expand"></div>
                    <div class="query-col id"></div>
                    <div class="col-chat">
                        <select class="dropdown-query-type">
                            <option value="0">select query type...</option>
                            <option value="1">Business</option>
                            <option value="2">Technical</option>
                        </select>
                    </div>
                    <div class="col-button-send">
                        <input type="button" class="send-button query-button" value="Send" onclick="SaveTaskQuery(this);">
                    </div>
                </div>

                <div class="query-header">Queries for: <a href="#">ITSN092-XIV-I</a></div>
                <div class="query-row-header">
                    <div class="row-expand"></div>
                    <div class="query-col id">ID#</div>
                    <div class="query-col created-for">
                        Created By<br />
                        Timestamp
                    </div>
                    <div class="query-col query">Query</div>
                    <div class="query-col status">Status</div>
                </div>
                <div class="query-row row-even">
                    <div class="row-expand">
                        <img src="../img/expanded.jpg" class="expand-button" /></div>
                    <div class="query-col id">ITSN-0058</div>
                    <div class="query-col created-for">
                        <div class="chosen-container chosen-container-multi" style="width: 186px;" title="" id="ddcbSeqAssignedStaffClosedTask523_chosen1">
                            <ul class="chosen-choices">
                                <li class="search-choice"><span><span class="activeUser">Kapil K. Pancholi - </span><a style="color: blue;" href="/Sr_App/ViewSalesUser.aspx?id=3697">ITSN-A0411
                                </a></span><a class="search-choice-close" data-option-array-index="1"></a></li>
                            </ul>
                        </div>
                        <br />
                        <span class="date">1/17/2018</span><span class="time">2:28 PM </span><span>(EST)</span>
                    </div>
                    <div class="query-col query">What will be the title of this grid?</div>
                    <div class="query-col status">Raised</div>
                </div>
                <div class="query-row row-odd">
                    <div class="row-expand"></div>
                    <div class="query-col id"></div>
                    <div class="query-col created-for">
                        <div class="chosen-container chosen-container-multi" style="width: 186px;" title="" id="ddcbSeqAssignedStaffClosedTask523_chosen2">
                            <ul class="chosen-choices">
                                <li class="search-choice"><span><span class="activeUser">Kapil K. Pancholi - </span><a style="color: blue;" href="/Sr_App/ViewSalesUser.aspx?id=3697">ITSN-A0411
                                </a></span><a class="search-choice-close" data-option-array-index="1"></a></li>
                            </ul>
                        </div>
                        <br />
                        <span class="date">1/17/2018</span><span class="time">2:28 PM </span><span>(EST)</span>
                    </div>
                    <div class="query-col query">I don't understand 4 checkboxes flow, can you please update me for that?</div>
                    <div class="query-col status"></div>
                </div>
                <div class="query-row row-even">
                    <div class="row-expand"></div>
                    <div class="query-col id"></div>
                    <div class="query-col created-for">
                        <div class="chosen-container chosen-container-multi" style="width: 186px;" title="" id="ddcbSeqAssignedStaffClosedTask523_chosen1">
                            <ul class="chosen-choices">
                                <li class="search-choice"><span><span class="activeUser">Kapil K. Pancholi - </span><a style="color: blue;" href="/Sr_App/ViewSalesUser.aspx?id=3697">ITSN-A0411
                                </a></span><a class="search-choice-close" data-option-array-index="1"></a></li>
                            </ul>
                        </div>
                        <br />
                        <span class="date"></span><span class="time">2:28 PM </span><span>(EST)</span>
                    </div>
                    <div class="query-col query">What will be the title of this grid?</div>
                    <div class="query-col status"></div>
                </div>
                <div class="query-row row-odd">
                    <div class="row-expand"></div>
                    <div class="query-col id"></div>
                    <div class="query-col created-for">
                        <div class="chosen-container chosen-container-multi" style="width: 186px;" title="" id="ddcbSeqAssignedStaffClosedTask523_chosen2">
                            <ul class="chosen-choices">
                                <li class="search-choice"><span><span class="activeUser">Kapil K. Pancholi - </span><a style="color: blue;" href="/Sr_App/ViewSalesUser.aspx?id=3697">ITSN-A0411
                                </a></span><a class="search-choice-close" data-option-array-index="1"></a></li>
                            </ul>
                        </div>
                        <br />
                        <span class="date">1/17/2018</span><span class="time">2:28 PM </span><span>(EST)</span>
                    </div>
                    <div class="query-col query">I don't understand 4 checkboxes flow, can you please update me for that?</div>
                    <div class="query-col status"></div>
                </div>
                <div class="query-row row-odd">
                    <div class="row-expand"></div>
                    <div class="query-col id"></div>
                    <div class="col-chat">
                        <input type="text" placeholder="type your query..." class="text-query" />
                    </div>
                    <div class="col-button-send">
                        <input type="button" class="send-button" value="Send" />
                    </div>
                </div>
                <div class="query-row row-even">
                    <div class="row-expand">
                        <img src="../img/collapsed.png" class="expand-button" /></div>
                    <div class="query-col id">ITSN-0058</div>
                    <div class="query-col created-for">
                        <div class="chosen-container chosen-container-multi" style="width: 186px;" title="" id="ddcbSeqAssignedStaffClosedTask523_chosen1">
                            <ul class="chosen-choices">
                                <li class="search-choice"><span><span class="activeUser">Kapil K. Pancholi - </span><a style="color: blue;" href="/Sr_App/ViewSalesUser.aspx?id=3697">ITSN-A0411
                                </a></span><a class="search-choice-close" data-option-array-index="1"></a></li>
                            </ul>
                        </div>
                        <br />
                        <span class="date">1/17/2018</span><span class="time">2:28 PM </span><span>(EST)</span>
                    </div>
                    <div class="query-col query">What will be the title of this grid?</div>
                    <div class="query-col status">Raised</div>
                </div>
                <div class="query-row row-odd">
                    <div class="row-expand">
                        <img src="../img/collapsed.png" class="expand-button" /></div>
                    <div class="query-col id">ADM34-0058</div>
                    <div class="query-col created-for">
                        <div class="chosen-container chosen-container-multi" style="width: 186px;" title="" id="ddcbSeqAssignedStaffClosedTask523_chosen2">
                            <ul class="chosen-choices">
                                <li class="search-choice"><span><span class="activeUser">Kapil K. Pancholi - </span><a style="color: blue;" href="/Sr_App/ViewSalesUser.aspx?id=3697">ITSN-A0411
                                </a></span><a class="search-choice-close" data-option-array-index="1"></a></li>
                            </ul>
                        </div>
                        <br />
                        <span class="date">1/17/2018</span><span class="time">2:28 PM </span><span>(EST)</span>
                    </div>
                    <div class="query-col query">I don't understand 4 checkboxes flow, can you please update me for that?</div>
                    <div class="query-col status">Discussing</div>
                </div>
            </div>
            <!--Query Grid Ends-->


            <!--Bottom Grid Caption Starts-->
            <div>
                <table width="100%">
                    <tbody>
                        <tr>
                            <td width="200px" align="left">
                                <h2 class="itdashtitle">Commits, Closed-Billed</h2>
                            </td>
                            <td></td>
                            <td></td>
                            <td></td>
                            <td style="text-align: right"></td>
                        </tr>
                    </tbody>
                </table>
            </div>
            <!--Bottom Grid Caption Ends-->

            <!--Bottom Grid Record Starts-->
            <div id="taskHolder" class="ui-tabs ui-widget ui-widget-content ui-corner-all">
                <div id="taskSubHolder">
                    <div id="divClosedTask" class="div-table tableSeqTask">
                        <div style="float: left; padding-top: 10px; margin-right: 1.7%; /*margin-bottom: -40px; */">
                            <span id="lblFromClosedTask">{{pageFromCT}}</span>&nbsp;<span>to</span>&nbsp;
                                <span id="lblToClosedTask" style="color: #19ea19">{{pageToCT}}</span>
                            <span id="lblofClosedTask">of</span>
                            <span id="lblCountClosedTask" style="color: red;">{{pageOfCT}}</span>
                            <span id="lblselectedchkClosedTask" style="font-weight: bold;"></span>
                            <img src="/img/refresh.png" class="refresh" id="refreshClosedTask">
                        </div>
                        <div ng-show="loaderClosedTask.loading" style="align-content: center; width: 90%; text-align: center;" class="">
                            <img src="../img/ajax-loader.gif" style="vertical-align: middle">Please Wait...
                        </div>
                        <div style="clear: both"></div>

                        <div class="col-header">
                            <div class="col2-iddes">
                                ID#<div>Designation</div>
                            </div>
                            <div class="col3-title">
                                Parent Task
                                        <div>SubTask Title</div>
                            </div>
                            <div class="col4-assigned">
                                Status<div>Assigned To</div>
                            </div>
                            <div class="col5-hours">
                                Total Hours<br />
                                Total $
                            </div>
                            <div class="col6-notes">Notes</div>
                        </div>
                        <div class="noData" id="noDataCT">No Records Found!</div>
                        <!-- NG Repeat Div starts -->
                        <div ng-attr-id="divMasterTask{{Task.TaskId}}" class="div-table-row" data-ng-repeat="Task in ClosedTask" ng-class="{red: Task.Status==='12', black : Task.Status==='7', green: Task.Status==='14', white: Task.Status==='11'}" repeat-end="onStaffEnd()">

                            <!-- ID# and Designation starts -->
                            <div class="col2-iddes">
                                <a ng-href="../Sr_App/TaskGenerator.aspx?TaskId={{Task.MainParentId}}&hstid={{Task.TaskId}}" oncontextmenu="openCopyBox(this);return false;" data-installid="{{Task.InstallId}}" parentdata-highlighter="{{Task.MainParentId}}" data-highlighter="{{Task.TaskId}}" class="bluetext context-menu" target="_blank">{{ Task.InstallId }}</a><br />
                                {{getDesignationString(Task.TaskDesignation)}}                                        
                            </div>
                            <!-- ID# and Designation ends -->

                            <!-- Parent Task & SubTask Title starts -->
                            <div class="col3-title">
                                <span class="parent-task-title">{{ Task.ParentTaskTitle }}</span>
                                <br />
                                {{ Task.Title }}
                            </div>
                            <!-- Parent Task & SubTask Title ends -->

                            <!-- Status & Assigned To starts -->
                            <div class="col4-assigned chosen-div">
                                <select id="drpStatusSubsequenceCT{{Task.TaskId}}" onchange="changeTaskStatusClosed(this);" data-highlighter="{{Task.TaskId}}">
                                    <option ng-selected="{{Task.Status == '4'}}" value="4">InProgress-Frozen</option>
                                    <%--<option ng-selected="{{Task.Status == '2'}}" style="color: red" value="2">Requested</option>--%>
                                    <option ng-selected="{{Task.Status == '3'}}" value="3">Request-Assigned</option>
                                    <option ng-selected="{{Task.Status == '1'}}" value="1">Open</option>
                                    <% if (IsSuperUser)
                                        { %>
                                    <%--<option ng-selected="{{Task.Status == '5'}}" value="5">Pending</option>--%>
                                    <%--<option ng-selected="{{Task.Status == '6'}}" value="6">ReOpened</option>  --%>
                                    <option ng-selected="{{Task.Status == '8'}}" value="8">SpecsInProgress-NOT OPEN</option>
                                    <%} %>

                                    <%--<option ng-selected="{{TechTask.Status == '10'}}" value="10">Finished</option>--%>
                                    <option ng-selected="{{Task.Status == '11'}}" value="11">Test Commit</option>

                                    <option ng-selected="{{Task.Status == '12'}}" value="12">Live Commit</option>
                                    <option ng-selected="{{Task.Status == '14'}}" value="14">Billed</option>
                                    <% if (IsSuperUser)
                                        { %>
                                    <option ng-selected="{{Task.Status == '7'}}" value="7">Closed</option>
                                    <option ng-selected="{{Task.Status == '9'}}" value="9">Deleted</option>
                                    <%} %>
                                </select>
                                <br />

                                <select class="ddlAssignedUsers" <%=!IsSuperUser ? "disabled" : ""%> id="ddcbSeqAssignedStaffClosedTask{{Task.TaskId}}" style="width: 100%;" multiple ng-attr-data-assignedusers="{{Task.TaskAssignedUserIDs}}" data-chosen="1" data-placeholder="Select Users" onchange="EditSeqAssignedTaskUsers(this);" data-taskid="{{Task.TaskId}}" data-taskstatus="{{Task.Status}}">
                                    <option
                                        ng-repeat="item in DesignationAssignUsers"
                                        value="{{item.Id}}"
                                        label="{{item.FristName}}"
                                        class="{{item.CssClass}}">{{item.FristName}}
                                    </option>
                                </select>




                            </div>
                            <!-- Status & Assigned To ends -->

                            <!-- DueDate starts -->
                            <div class="col5-hours" style="margin-top: -10px;">
                                <span class="hours-col">IT Lead: {{Task.ITLeadHours}}, User: {{Task.UserHours}}</span>
                                <div class="seqapprovalBoxes" id="SeqApprovalDiv{{Task.TaskId}}"
                                    data-adminstatusupdateddate="{{ Task.AdminStatusUpdated | date:'M/d/yyyy' }}"
                                    data-adminstatusupdatedtime="{{ Task.AdminStatusUpdated | date:'shortTime' }}"
                                    data-adminstatusupdatedtimezone="{{StringIsNullOrEmpty(Task.AdminStatusUpdated) ? '' : '(EST)' }}"
                                    data-adminstatusupdated="{{Task.AdminStatusUpdated}}"
                                    data-admindisplayname="{{StringIsNullOrEmpty(Task.AdminUserInstallId)? Task.AdminUserId : Task.AdminUserInstallId}} - {{Task.AdminUserFirstName}} {{Task.AdminUserLastName}}"
                                    data-adminstatususerid="{{Task.AdminUserId}}"
                                    data-leadstatusupdateddate="{{ Task.TechLeadStatusUpdated | date:'M/d/yyyy' }}"
                                    data-leadstatusupdatedtime="{{ Task.TechLeadStatusUpdated | date:'shortTime' }}"
                                    data-leadstatusupdatedtimezone="{{StringIsNullOrEmpty(Task.TechLeadStatusUpdated) ? '' : '(EST)' }}"
                                    data-leadstatusupdated="{{Task.ITLeadHours}}"
                                    data-leadhours="{{Task.ITLeadHours}}"
                                    data-leaddisplayname="{{StringIsNullOrEmpty(Task.TechLeadUserInstallId)? Task.TechLeadUserId : Task.TechLeadUserInstallId}} - {{Task.TechLeadUserFirstName}} {{Task.TechLeadUserLastName}}"
                                    data-leaduserid="{{Task.TechLeadUserId}}"
                                    data-userstatusupdateddate="{{ Task.OtherUserStatusUpdated | date:'M/d/yyyy' }}"
                                    data-userstatusupdatedtime="{{ Task.OtherUserStatusUpdated | date:'shortTime' }}"
                                    data-userstatusupdatedtimezone="{{StringIsNullOrEmpty(Task.OtherUserStatusUpdated) ? '' : '(EST)' }}"
                                    data-userstatusupdated="{{Task.UserHours}}"
                                    data-userhours="{{Task.UserHours}}"
                                    data-userdisplayname="{{StringIsNullOrEmpty(Task.OtherUserInstallId)? Task.OtherUserId : Task.OtherUserInstallId}} - {{Task.OtherUserFirstName}} {{Task.OtherUserLastName}}"
                                    data-useruserid="{{Task.OtherUserId}}">
                                    <div style="width: 55%; float: left;">
                                        <input type="checkbox" data-taskid="{{Task.TaskId}}" onchange="openSeqApprovalPopup(this)" id="chkngUserMasterClosedTask{{Task.TaskId}}" ng-checked="{{Task.OtherUserStatus}}" ng-disabled="{{Task.OtherUserStatus}}" class="fz fz-user" title="User" />
                                        <input type="checkbox" data-taskid="{{Task.TaskId}}" onchange="openSeqApprovalPopup(this)" id="chkQAMasterClosedTask{{Task.TaskId}}" class="fz fz-QA" title="QA" />
                                        <input type="checkbox" data-taskid="{{Task.TaskId}}" onchange="openSeqApprovalPopup(this)" id="chkAlphaUserMasterClosedTask{{Task.TaskId}}" class="fz fz-Alpha" title="AlphaUser" />
                                        <br />
                                        <input type="checkbox" data-taskid="{{Task.TaskId}}" onchange="openSeqApprovalPopup(this)" id="chkBetaUserMasterClosedTask{{Task.TaskId}}" class="fz fz-Beta" title="BetaUser" />
                                        <input type="checkbox" data-taskid="{{Task.TaskId}}" onchange="openSeqApprovalPopup(this)" id="chkngITLeadClosedTask{{Task.TaskId}}" ng-checked="{{Task.TechLeadStatus}}" ng-disabled="{{Task.TechLeadStatus}}" class="fz fz-techlead" title="IT Lead" />
                                        <input type="checkbox" data-taskid="{{Task.TaskId}}" onchange="openSeqApprovalPopup(this)" id="chkngAdminClosedTask{{Task.TaskId}}" ng-checked="{{Task.AdminStatus}}" ng-disabled="{{Task.AdminStatus}}" class="fz fz-admin" title="Admin" />
                                    </div>
                                    <div style="width: 42%; float: right;">
                                        <input type="checkbox" data-taskid="{{Task.TaskId}}" onchange="openSeqApprovalPopup(this)" id="chkngITLeadMasterClosedTask{{Task.TaskId}}" class="fz fz-techlead largecheckbox" title="IT Lead" /><br />
                                        <input type="checkbox" data-taskid="{{Task.TaskId}}" onchange="openSeqApprovalPopup(this)" id="chkngAdminMasterClosedTask{{Task.TaskId}}" class="fz fz-admin largecheckbox" title="Admin" />
                                    </div>
                                </div>


                            </div>
                            <!-- DueDate ends -->
                            <div class="col6-notes">
                                <!-- Notes starts -->
                                <div class="notes-section" taskid="{{Task.TaskId}}" taskmultilevellistid="0" style="position: relative; overflow-x: hidden; overflow-y: auto; min-height: 90px; width: 460px !important;">
                                    <div style="width: 98%; height: 53px; overflow-x: hidden; overflow-y: auto;" class="div-table-col seq-notes-fixed-top main-task" taskid="{{Task.TaskId}}" taskmultilevellistid="0">
                                        Loading Notes...
                                    </div>
                                    <div class="notes-inputs">
                                        <div class="first-col">
                                            <input type="button" class="GrdBtnAdd" value="Add Notes" onclick="addNotes(this)" />
                                        </div>
                                        <div class="second-col">
                                            <textarea class="note-text textbox"></textarea>
                                        </div>
                                    </div>
                                </div>
                            </div>
                            <!-- Notes ends -->

                            <!-- Nested row starts -->

                            <div class="div-table-nested" ng-class="{hide : StringIsNullOrEmpty(Task.SubSeqTasks)}">

                                <!-- Body section starts -->
                                <div class="div-table-row" ng-repeat="TechTask in correctDataforAngular(Task.SubSeqTasks)" ng-class="{red: TechTask.Status==='12', black : TechTask.Status==='7', green: TechTask.Status==='14', white: TechTask.Status==='11'}">

                                    <!-- ID# and Designation starts -->
                                    <div class="col2-iddes">
                                        <a ng-href="../Sr_App/TaskGenerator.aspx?TaskId={{TechTask.MainParentId}}&hstid={{TechTask.TaskId}}" oncontextmenu="openCopyBox(this);return false;" data-installid="{{TechTask.InstallId}}" parentdata-highlighter="{{TechTask.MainParentId}}" data-highlighter="{{TechTask.TaskId}}" class="bluetext context-menu" target="_blank">{{ TechTask.InstallId }}</a><br />
                                        {{getDesignationString(TechTask.TaskDesignation)}}
                                        <div ng-attr-id="divSeqDesg{{TechTask.TaskId}}" ng-class="{hide: TechTask.TaskId != HighLightTaskId}">
                                            <select class="textbox hide" ng-attr-data-taskid="{{TechTask.TaskId}}" ng-options="item as item.Name for item in ParentTaskDesignations track by item.Id" ng-model="DesignationSelectModel[$index]">
                                            </select>
                                        </div>
                                    </div>
                                    <!-- ID# and Designation ends -->

                                    <!-- Parent Task & SubTask Title starts -->
                                    <div class="col3-title">
                                        {{ TechTask.ParentTaskTitle }}
                                        <br />
                                        {{ TechTask.Title }}
                                    </div>
                                    <!-- Parent Task & SubTask Title ends -->

                                    <!-- Status & Assigned To starts -->
                                    <div class="col4-assigned chosen-div">
                                        <select id="drpStatusSubsequenceNestedClosedTask{{TechTask.TaskId}}" onchange="changeTaskStatusClosed(this);" data-highlighter="{{TechTask.TaskId}}">
                                            <option ng-selected="{{TechTask.Status == '4'}}" value="4">InProgress-Frozen</option>
                                            <%--<option ng-selected="{{TechTask.Status == '2'}}" style="color: red" value="2">Requested</option>--%>
                                            <option ng-selected="{{TechTask.Status == '3'}}" value="3">Request-Assigned</option>
                                            <option ng-selected="{{TechTask.Status == '1'}}" value="1">Open</option>
                                            <% if (IsSuperUser)
                                                { %>
                                            <%--<option ng-selected="{{TechTask.Status == '5'}}" value="5">Pending</option>--%>
                                            <%--<option ng-selected="{{TechTask.Status == '6'}}" value="6">ReOpened</option>  --%>
                                            <option ng-selected="{{TechTask.Status == '8'}}" value="8">SpecsInProgress-NOT OPEN</option>
                                            <%} %>

                                            <%--<option ng-selected="{{TechTask.Status == '10'}}" value="10">Finished</option>--%>
                                            <option ng-selected="{{TechTask.Status == '11'}}" value="11">Test Commit</option>

                                            <option ng-selected="{{TechTask.Status == '12'}}" value="12">Live Commit</option>
                                            <% if (IsSuperUser)
                                                { %>
                                            <option ng-selected="{{TechTask.Status == '7'}}" value="7">Closed</option>
                                            <option ng-selected="{{TechTask.Status == '14'}}" value="14">Billed</option>
                                            <option ng-selected="{{TechTask.Status == '9'}}" value="9">Deleted</option>
                                            <%} %>
                                        </select>
                                        <br />
                                        <select <%=!IsSuperUser ? "disabled" : ""%> id="ddcbSeqAssigned{{TechTask.TaskId}}" style="width: 100%;" multiple ng-attr-data-assignedusers="{{TechTask.TaskAssignedUserIDs}}" data-chosen="1" data-placeholder="Select Users" onchange="EditSeqAssignedTaskUsers(this);" data-taskid="{{TechTask.TaskId}}" data-taskstatus="{{TechTask.Status}}">
                                            <option
                                                ng-repeat="item in DesignationAssignUsers"
                                                value="{{item.Id}}"
                                                label="{{item.FristName}}"
                                                class="{{item.CssClass}}">{{item.FristName}}
                                                
                                            </option>
                                        </select>
                                    </div>
                                    <!-- Status & Assigned To ends -->
                                    <div class="col5-hours">
                                        <span class="hours-col">IT Lead: {{TechTask.ITLeadHours}}, User: {{TechTask.UserHours}}</span>
                                        <div class="seqapprovalBoxes" id="SeqApprovalDiv{{TechTask.TaskId}}"
                                            data-adminstatusupdateddate="{{ TechTask.AdminStatusUpdated | date:'M/d/yyyy' }}"
                                            data-adminstatusupdatedtime="{{ TechTask.AdminStatusUpdated | date:'shortTime' }}"
                                            data-adminstatusupdatedtimezone="{{StringIsNullOrEmpty(TechTask.AdminStatusUpdated) ? '' : '(EST)' }}"
                                            data-adminstatusupdated="{{TechTask.AdminStatusUpdated}}"
                                            data-admindisplayname="{{StringIsNullOrEmpty(TechTask.AdminUserInstallId)? TechTask.AdminUserId : TechTask.AdminUserInstallId}} - {{TechTask.AdminUserFirstName}} {{TechTask.AdminUserLastName}}"
                                            data-adminstatususerid="{{TechTask.AdminUserId}}"
                                            data-leadstatusupdateddate="{{ TechTask.TechLeadStatusUpdated | date:'M/d/yyyy' }}"
                                            data-leadstatusupdatedtime="{{ TechTask.TechLeadStatusUpdated | date:'shortTime' }}"
                                            data-leadstatusupdatedtimezone="{{StringIsNullOrEmpty(TechTask.TechLeadStatusUpdated) ? '' : '(EST)' }}"
                                            data-leadstatusupdated="{{TechTask.ITLeadHours}}"
                                            data-leadhours="{{TechTask.ITLeadHours}}"
                                            data-leaddisplayname="{{StringIsNullOrEmpty(TechTask.TechLeadUserInstallId)? TechTask.TechLeadUserId : TechTask.TechLeadUserInstallId}} - {{TechTask.TechLeadUserFirstName}} {{TechTask.TechLeadUserLastName}}"
                                            data-leaduserid="{{TechTask.TechLeadUserId}}"
                                            data-userstatusupdateddate="{{ TechTask.OtherUserStatusUpdated | date:'M/d/yyyy' }}"
                                            data-userstatusupdatedtime="{{ TechTask.OtherUserStatusUpdated | date:'shortTime' }}"
                                            data-userstatusupdatedtimezone="{{StringIsNullOrEmpty(TechTask.OtherUserStatusUpdated) ? '' : '(EST)' }}"
                                            data-userstatusupdated="{{TechTask.UserHours}}"
                                            data-userhours="{{TechTask.UserHours}}"
                                            data-userdisplayname="{{StringIsNullOrEmpty(TechTask.OtherUserInstallId)? TechTask.OtherUserId : TechTask.OtherUserInstallId}} - {{TechTask.OtherUserFirstName}} {{TechTask.OtherUserLastName}}"
                                            data-useruserid="{{TechTask.OtherUserId}}">
                                            <div style="width: 55%; float: left;">
                                                <input type="checkbox" data-taskid="{{TechTask.TaskId}}" onchange="openSeqApprovalPopup(this)" id="chkngUserNestedSubTask{{TechTask.TaskId}}" ng-checked="{{TechTask.OtherUserStatus}}" ng-disabled="{{TechTask.OtherUserStatus}}" class="fz fz-user" title="User" />
                                                <input type="checkbox" data-taskid="{{TechTask.TaskId}}" onchange="openSeqApprovalPopup(this)" id="chkQANestedSubTask{{TechTask.TaskId}}" class="fz fz-QA" title="QA" />
                                                <input type="checkbox" data-taskid="{{TechTask.TaskId}}" onchange="openSeqApprovalPopup(this)" id="chkAlphaUserNestedSubTask{{TechTask.TaskId}}" class="fz fz-Alpha" title="AlphaUser" />
                                                <br />
                                                <input type="checkbox" data-taskid="{{TechTask.TaskId}}" onchange="openSeqApprovalPopup(this)" id="chkBetaUserNestedSubTask{{TechTask.TaskId}}" class="fz fz-Beta" title="BetaUser" />
                                                <input type="checkbox" data-taskid="{{TechTask.TaskId}}" onchange="openSeqApprovalPopup(this)" id="chkngITLeadNestedSubTask{{TechTask.TaskId}}" ng-checked="{{TechTask.TechLeadStatus}}" ng-disabled="{{TechTask.TechLeadStatus}}" class="fz fz-techlead" title="IT Lead" />
                                                <input type="checkbox" data-taskid="{{TechTask.TaskId}}" onchange="openSeqApprovalPopup(this)" id="chkngAdminNestedSubTask{{TechTask.TaskId}}" ng-checked="{{TechTask.AdminStatus}}" ng-disabled="{{TechTask.AdminStatus}}" class="fz fz-admin" title="Admin" />
                                            </div>
                                            <div style="width: 43%; float: right;">
                                                <input type="checkbox" data-taskid="{{TechTask.TaskId}}" onchange="openSeqApprovalPopup(this)" id="chkngITLeadMasterNestedSubTask{{TechTask.TaskId}}" class="fz fz-techlead largecheckbox" title="IT Lead" /><br />
                                                <input type="checkbox" data-taskid="{{TechTask.TaskId}}" onchange="openSeqApprovalPopup(this)" id="chkngAdminMasterNestedSubTask{{TechTask.TaskId}}" class="fz fz-admin largecheckbox" title="Admin" />
                                            </div>
                                        </div>

                                    </div>
                                    <div class="div-table-col col6-notes">
                                        Notes
                                    </div>
                                </div>
                                <!-- Body section ends -->

                            </div>

                            <!-- Nested row ends -->

                        </div>

                        <!-- Hours Total Row Starts -->
                        <div id="divMasterTaskTotal" class="div-table-row">

                            <div class="div-table-col seq-taskid-fixed ng-binding">
                            </div>
                            <div class="div-table-col seq-tasktitle-fixed ng-binding">
                            </div>
                            <div class="div-table-col seq-taskstatus-fixed chosen-div">
                            </div>
                            <div class="div-table-col seq-taskduedate-fixed" style="margin-top: -10px; width: 200px;">
                                <span class="hours-col ng-binding"><b>(Total) IT Lead: {{TotalHoursITLead}}, User: {{TotalHoursUsers}}</b></span>
                            </div>
                        </div>
                        <!-- Hours Total Row Ends -->
                    </div>



                </div>

            </div>
            <!--Bottom Grid Record Ends-->

            <!--Bottom Grid Pager Starts-->
            <div class="text-center" style="float: right">
                <jgpager page="{{pageCT}}" pages-count="{{pagesCountCT}}" total-count="{{TotalRecordsCT}}" search-func="getClosedTasks(page)"></jgpager>
            </div>
            <!--Bottom Grid Pager Ends-->

            <!-- Interview Date popup starts -->
                <div id="HighLightedTask" class="modal hide">
                    <div class="w3-light-greypop">
                    <div class="w3-greypop" style="width:60%;">60%</div>
                 </div>

                <table width="100%" class="header-tablepop">
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
                            <asp:CheckBox ID="chkNotifiedAboutOpportunity" Checked="true"  runat="server" />
                            Notified About Opportunity</td>
                        <td>
                            <asp:CheckBox ID="chkApplicationApproval" Checked="true" runat="server" />
                            Application Approval</td>
                    </tr>
                    <tr>
                        <td>
                            <asp:CheckBox ID="chkApplicationInProgress" runat="server" Checked="true" />
                            Application In Progress</td>
                        <td>
                            <asp:CheckBox ID="chkAccountSetup" runat="server"  />
                            Account Setup</td>
                        <td>
                            <asp:CheckBox ID="chkServiceProviderFullyOnBoard" runat="server" />
                            Service Provider Fully On-Board</td>
                    </tr>
            
                </table>
                <%--<iframe id="ifrmTask" style="height: 100%; width: 100%; overflow: auto;"></iframe>--%>

                <div id="examPassed">
                <span id="InterviewDateHeader">
                    Dear Applicant, <label id="ltlApplicantName"></label>
                        &nbsp;-&nbsp;<label id="ltlApplicantId"></label>, Thank you for applying to JMGrove! To schedule an Interview Date&time with     VAL Kerilya - REC-xxxx  select a commit date&time with a 24 hours; 3 days; 7day Deadline. Follow Commit/Interview Instructions below ( a copy has been autoemailed to you) to commit your required sample tech task.  Reference *Training&Resources - Interview date...  for additional video tutorials, docs, etc. This is meant to be a TEST and ONLY your recruiter (NON tech person) is allowed to address technical questions. Commit your task by a deadline or task will be re-assigned and could cause further delay. Good Luck!                                                                                                          
JMGrove Management & Organization
                    </span>                    
                <label id="ltlDesignation" class="hide"></label>
                    
                    <br />
                    <br />
                    <div id="tblIntTechSeq" class="div-table tableSeqTask">
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
                        <div ng-attr-id="divIntPopupTask" class="div-table-row" data-ng-repeat="Task in Tasks" ng-class="{orange : Task.Status==='4', yellow: Task.Status==='2', yellow: Task.Status==='3', lightgray: Task.Status==='8'}" repeat-end="onStaffEnd()">
                            <!-- Sequence# starts -->
                            <div class="div-table-col seq-number">
                                <span class="badge badge-success badge-xstext">
                                    <label ng-attr-id="IntSeqLabel{{Task.TaskId}}">{{getSequenceDisplayText(!Task.Sequence?"N.A.":Task.Sequence,Task.SequenceDesignationId,Task.IsTechTask === "false" ? "SS" : "TT")}}</label></span>
                            </div>
                            <!-- Sequence# ends -->

                            <!-- ID# and Designation starts -->
                            <div class="div-table-col seq-taskid">
                                <a ng-href="../Sr_App/TaskGenerator.aspx?TaskId={{Task.MainParentId}}&hstid={{Task.TaskId}}" oncontextmenu="openCopyBox(this);return false;" data-installid="{{Task.InstallId}}" parentdata-highlighter="{{Task.MainParentId}}" data-highlighter="{{Task.TaskId}}" class="bluetext context-menu" target="_blank">{{ Task.InstallId }}</a><br />
                                {{getDesignationString(Task.TaskDesignation)}}                                        
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
                                <select id="drpIntStatusSubsequence2{{Task.TaskId}}" data-highlighter="{{Task.TaskId}}">
                                    <option ng-selected="{{Task.Status == '1'}}" value="1">Open</option>
                                    <option ng-selected="{{Task.Status == '2'}}" style="color: red" value="2">Requested</option>
                                    <option ng-selected="{{Task.Status == '3'}}" style="color: lawngreen" value="3">Assigned</option>
                                    <option ng-selected="{{Task.Status == '4'}}" value="4">InProgress</option>
                                    <option ng-selected="{{Task.Status == '10'}}" value="10">Finished</option>
                                    <option ng-selected="{{Task.Status == '11'}}" value="11">Test</option>
                                </select>
                                <br />

                                <select <%=!IsSuperUser ? "disabled" : ""%> id="ddcbIntSeqAssignedStaff{{Task.TaskId}}" style="width: 100%;" multiple ng-attr-data-assignedusers="{{Task.TaskAssignedUserIDs}}" data-chosen="1" data-placeholder="Select Users" data-taskid="{{Task.TaskId}}" data-taskstatus="{{Task.Status}}">
                                    <option
                                        ng-repeat="item in DesignationAssignUsers"
                                        value="{{item.Id}}"
                                        label="{{item.FristName}}"
                                        class="{{item.CssClass}}">{{item.FristName}}
                                        
                                    </option>
                                </select>

                            </div>
                            <!-- Status & Assigned To ends -->

                            <!-- DueDate starts -->
                            <div class="div-table-col seq-taskduedate">
                                <div class="seqapprovalBoxes">
                                    <div style="width: 65%; float: left;">
                                        <input type="checkbox" id="IntchkngUser{{Task.TaskId}}" ng-checked="{{Task.OtherUserStatus}}" ng-disabled="{{Task.OtherUserStatus}}" class="fz fz-user" title="User" />
                                        <input type="checkbox" id="IntchkQA{{Task.TaskId}}" class="fz fz-QA" title="QA" />
                                        <input type="checkbox" id="IntchkAlphaUser{{Task.TaskId}}" class="fz fz-Alpha" title="AlphaUser" />
                                        <br />
                                        <input type="checkbox" id="IntchkBetaUser{{Task.TaskId}}" class="fz fz-Beta" title="BetaUser" />
                                        <input type="checkbox" id="IntchkngITLead{{Task.TaskId}}" ng-checked="{{Task.TechLeadStatus}}" ng-disabled="{{Task.TechLeadStatus}}" class="fz fz-techlead" title="IT Lead" />
                                        <input type="checkbox" id="IntchkngAdmin{{Task.TaskId}}" ng-checked="{{Task.AdminStatus}}" ng-disabled="{{Task.AdminStatus}}" class="fz fz-admin" title="Admin" />
                                    </div>
                                    <div style="width: 30%; float: right;">
                                        <input type="checkbox" id="IntchkngITLeadMaster{{Task.TaskId}}" class="fz fz-techlead largecheckbox" title="IT Lead" /><br />
                                        <input type="checkbox" id="IntchkngAdminMaster{{Task.TaskId}}" class="fz fz-admin largecheckbox" title="Admin" />
                                    </div>
                                </div>

                                <div ng-attr-data-taskid="{{Task.TaskId}}" class="seqapprovepopup">

                                    <div id="divTaskAdminSubTask{{Task.TaskId}}" style="margin-bottom: 15px; font-size: x-small;">
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
                                    <div id="divTaskITLeadSubTask{{Task.TaskId}}" style="margin-bottom: 15px; font-size: x-small;">
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
                                    <div id="divUserSubTask{{Task.TaskId}}" style="margin-bottom: 15px; font-size: x-small;">
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
                                            <a class="bluetext" href="CreateSalesUser.aspx?id={{Task.OtherUserId}}" target="_blank">{{StringIsNullOrEmpty(Task.OtherUserInstallId)? Task.OtherUserId : Task.OtherUserInstallId}} - {{Task.OtherUserFirstName}} {{Task.OtherUserLastName}}
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

                    <!-- Interview popup Roman GridSSSss Starts -->
                    <div class="div-table-row roman-grid" id="roman_{{Task.TaskId}}">

                        <div id="romanList_{{Task.TaskId}}" class="section-container">
                            <div class="div-table-row" id="roman-head{{Task.TaskId}}">
                                <div class="div-table-col roman-col-margin"></div>
                                <div class="div-table-col roman-col-expand"></div>
                                <div class="div-table-col roman-col-id">ID#</div>
                                <div class="div-table-col roman-col-title">Title: Content</div>
                                <div class="div-table-col roman-col-assign"></div>
                            </div>
                            <div class="div-table-row" id="LoadingRomansDiv">
                                <div class="div-table-col roman-col-margin"></div>
                                <div class="div-table-col roman-col-expand">
                                </div>
                                <div class="div-table-col roman-col-id ng-binding"></div>
                                <div class="div-table-col roman-col-share">
                                </div>
                                <div class="div-table-col roman-col-title-content">
                                    <div style="float: right;" id="LoadingRomans">
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
                            <div class="div-table-row" ng-class-even="'roman-row-alternate'" ng-class-odd="'roman-row'" data-romanid="{{Roman.Id}}" ng-repeat="Roman in IntPopRomans" ng-class="{'parent': Roman.IndentLevel ==1, 'child': Roman.IndentLevel ==2 || Roman.IndentLevel ==3}" repeat-end="onTaskExpand({{Task.TaskId}})">
                                <div class="div-table-col roman-col-margin" ng-class="{'col-margin-nested-child': Roman.IndentLevel ==2 , 'col-margin-nested-child-level3': Roman.IndentLevel ==3}"></div>
                                <div class="div-table-col roman-col-expand" ng-hide="Roman.IndentLevel == 2 || Roman.IndentLevel == 3">
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
                    <!-- Interview popup Roman Grid End -->

                    <br />
                    <div>
                        <strong style="margin: 5px;">Commit/Interview Instructions</strong>
                        <div id="InterviewInstructions" class="employeeinstruction">
                        </div>

                    </div>
                    <%
                        if (Request.QueryString["PWT"] == "1")
                        {
                    %>

                    <%
                        }
                    %>
                    <br />
                    Your default Interview Date & Time Deadline has been scheduled for & with below:
            <br />
                    <br />
                    <table>
                        <tr>
                            <td width="50%" align="left" style="vertical-align: top;"><span><strong><span class="bluetext">*</span>Interview Date & Time: </strong>
                                <label id="InterviewDateTime"></label>
                            </span></td>
                            <td align="right" style="vertical-align: top;">
                                <table>
                                    <tr>
                                        <td align="left" valign="top"><a href="#" style="color: blue;">REC-001</a><br />
                                            <asp:Literal ID="ltlManagerName" runat="server" Text="Default Recruiter"></asp:Literal></td>
                                        <td align="right" valign="top">
                                            <img width="100px" height="100px" src="../img/JG-Logo.gif" /></td>
                                    </tr>
                                </table>


                            </td>
                        </tr>
                    </table>
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
                                                 <input id="filePath-{{subModule1.ID}}" type="hidden" value="Upload/Resources/{{subModule1.DesignationId}}/{{subModule.Title}}/{{subModule1.UniqueName}}"/>
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
                    <div id="tnrDisplay" style="width:450px;height:450px;">
                        <video id="def-intro" src="{{FileSourceURL}}" style="max-width:100%;display:none;" class="video-js video-js-opp" controls data-setup="{}">
                            <p class="vjs-no-js">
                                To view this video please enable JavaScript, and consider upgrading to a web browser that
                                <a href="http://videojs.com/html5-video-support/" target="_blank">supports HTML5 video</a>
                            </p>
                        </video>
                        <a href="{{FileSourceURL}}" id="lnkTR" style="display:none;" target="_blank">
                            <image src="{{FileSourceURL}}" style="max-width:100%;" id="imgTR"></image>
                        </a>
                        <a href="{{FileSourceURL}}" id="lnkTR1" style="display:none;" target="_blank"><h1>Download</h1></a>
                    </div>
                </div>

            </div>
            <!-- Interview Date popup ends -->

          <!-- Offer made popup starts -->
            <div id="divOfferMade" class="modal hide">
                <div class="w3-light-greypop">
                    <div class="w3-greypop" style="width: 90%;">90%</div>
                </div>

                <table width="100%" class="header-tablepop">
                    <tr>
                        <td><b>Stage 1 - Application</b></td>
                        <td><b>Stage 2 - On Boarding</b></td>
                        <td><b>Stage 3 - Approval</b></td>
                    </tr>
                    <tr>
                        <td>
                            <input type="checkbox" name="regComplete" disabled checked>
                            Registration Complete</td>
                        <td>
                            <input type="checkbox" name="optNotified" disabled checked>
                            Notified About Opportunity</td>
                        <td>
                            <input type="checkbox" name="AppApproval" disabled checked>
                            Application Approval</td>
                    </tr>
                    <tr>
                        <td>
                            <input type="checkbox" name="AppInProgress" disabled checked>
                            Application In Progress</td>
                        <td>
                            <input type="checkbox" name="AcctSetup" disabled checked>
                            Account Setup</td>
                        <td>
                            <input type="checkbox" name="OnBoard" disabled>
                            Service Provider Fully On-Board</td>
                    </tr>

                </table>

                <hr />
                <div class="offermademiddle">

                </div>
                <br />
                <h3>Contract Details</h3>
                <div id="divOfferContract" class="offermadecontract">
                </div>

            </div>
        <!-- Offer Made popup ends -->



            <%} %>
        </div>

        <asp:HiddenField ID="hdnUserId" runat="server" />
    </div>
    <div class="push popover__content">
        <div style="float: right; top: 0px; position: absolute; left: 160px;">
            <a href="#/" id="popoverCloseButton">x</a>
        </div>
        <div class="content"></div>
    </div>


    <div class="SeqApprovalPopup" style="display: none">
        <input type="hidden" id="hdnTaskId" />
        <div id="IntdivTaskAdmin" style="margin-bottom: 15px; font-size: x-small;">
            <div style="width: 10%;" class="display_inline">Admin: </div>
            <div style="width: 30%;" class="display_inline"></div>
            <div class="" id="AdminClass">
                <a id="linkUser" class="bluetext" href="#" target="_blank"><span id="AdminDisplayName"></span>
                </a>
                <br />
                <span id="AdminDate"></span>&nbsp;<span style="color: red" id="AdminTime"></span>&nbsp;<span id="AdminTimezone"></span>
            </div>
            <div id="AdminClass2">
                <input type="password" style="width: 100px;" placeholder="Admin password" onchange="javascript:FreezeSeqTask(this, 'A');" data-id="txtngstaffAdminPassword" data-hours-id="txtngstaffAdminEstimatedHours" />
            </div>
        </div>
        <div id="IntdivTaskITLead" style="margin-bottom: 15px; font-size: x-small;">
            <div style="width: 10%;" class="display_inline">ITLead: </div>
            <!-- ITLead Hours section -->
            <div style="width: 30%;" id="LeadClass">
                <span>
                    <label id="LeadHours"></label>
                    Hour(s)
                </span>
            </div>
            <div style="width: 30%;" id="LeadClass2">
                <input type="text" style="width: 55px;" placeholder="Est. Hours" id="txtITLeadHours" />
            </div>
            <div style="width: 50%; float: right; font-size: x-small;" id="LeadClass3">
                <input type="password" style="width: 100px;" placeholder="ITLead Password" onchange="javascript:FreezeSeqTask(this, 'L');" />
            </div>
            <!-- ITLead password section -->
            <div style="width: 50%; float: right; font-size: x-small;" id="LeadClass4">
                <a class="bluetext" href="#" id="linkLead" target="_blank"></a>
                <br />
                <span id="LeadDate"></span>&nbsp;<span style="color: red" id="LeadTime"></span>&nbsp;<span id="LeadTimezone"></span>
            </div>

        </div>
        <div id="IntdivUser" style="margin-bottom: 15px; font-size: x-small;">
            <div style="width: 10%;" class="display_inline">User: </div>
            <!-- UserHours section -->
            <div style="width: 30%;" id="UserClass">
                <span>
                    <label id="UserHours"></label>
                    Hour(s)
                                                        Hour(s)</span>
            </div>
            <div style="width: 30%;" id="UserClass2">
                <input type="text" style="width: 55px;" placeholder="Est. Hours" id="txtUserHours" />
            </div>
            <div style="width: 50%; float: right; font-size: x-small;" id="UserClass3">
                <input type="password" style="width: 100px;" placeholder="User Password" onchange="javascript:FreezeSeqTask(this, 'U');" />
            </div>
            <!-- User password section -->
            <div style="width: 50%; float: right; font-size: x-small;" id="UserClass4">
                <a class="bluetext" href="CreateSalesUser.aspx?id=" target="_blank" id="linkOtherUser"></a>
                <br />
                <span id="OtherUserStatusUpdatedDate"></span>&nbsp;<span style="color: red" id="OtherUserStatusUpdatedTime"></span>&nbsp;<span id="OtherUserStatusUpdatedTimezone"></span>
            </div>
        </div>
    </div>
     <input type="hidden" id="hdnUDID" runat="server" />
    <script type="text/javascript" src="<%=Page.ResolveUrl("~/js/chosen.jquery.js")%>"></script>

    <%--<script src="../js/angular/scripts/jgapp.js"></script>--%>
    <script src="../js/angular/scripts/TaskSequence.js"></script>
    <script src="../js/angular/scripts/FrozenTask.js"></script>
    <script src="../js/TaskSequencing.js"></script>
    <script src="../js/jquery.dd.min.js"></script>
    <script src="../js/angular/scripts/ClosedTasls.js"></script>
    <script src="../ckeditor/ckeditor.js"></script>
    <script src="../js/angular/scripts/TaskGenerator.js"></script>
    <script src="../js/angular/scripts/TaskGeneratorHelper.js"></script>
    <script src="../js/angular/scripts/TaskPopupHelper.js"></script>
    <script src="../js/angular/scripts/TaskShare.js"></script>
    <%--<script src="../js/angular/scripts/FreezeProcess.js"></script>--%>
    <script type="text/javascript">
        var UserDesignationId = '#<%=hdnUDID.ClientID%>';
        $(document).ready(function () {
            // Send location id 2 - Interview popup
            var UserDesignationId = '#<%=hdnUDID.ClientID%>';
            if (UserDesignationId === undefined || UserDesignationId === null) {
                console.log(UserDesignationId);
            }
            else
            {
                var designationid = $(UserDesignationId).val();
                ScopeIT.getFilesByDesignation(2, designationid);
                bindTreeEvents();
            }
        });
        function attachImagesByCKEditor(filename, name) {
            AddAttachmenttoViewState(name + '@' + name, '#ContentPlaceHolder1_objucSubTasks_Admin_hdnGridAttachment');
            idAttachments = true;
        }
        function SelectAllRoman(sender) {
            var taskid = $(sender).attr('data-taskid');
            $('#romanList_' + taskid).find('.roman-query-checkbox').prop('checked', true);
        }
        function ShowQuerySection(sender) {
            var RomanId = $(sender).attr('data-romanid');
            $('.query-button').attr('data-romanid', RomanId);

            $('#query-grid').show();
            ScrollTo($('#query-grid'));
        }
        function OpenAddTaskPopup(sender) {
            var commandName = $(sender).attr("data-val-commandName");
            var CommandArgument = $(sender).attr("data-val-CommandArgument");
            var TaskLevel = $(sender).attr("data-val-taskLVL");
            var strInstallId = $(sender).attr('data-installid');
            var parentTaskId = $(sender).attr('data-parent-taskid');

            showAddNewTaskPopup();
            SetupNewTaskData(CommandArgument, commandName, TaskLevel, strInstallId);
        }
        function viewLessChild(sender, TaskId) {
            var firstRow, lastRow;
            var parent = $(sender).parent().parent();
            $(sender).remove();
            $(parent).prevUntil('div.parent').each(function (i, item) {
                firstRow = item;
            });
            $(firstRow).nextUntil('div.parent').each(function (i, item) {
                if (i > 4)
                    $(item).addClass('hide');
                if (i == 4)
                    lastRow = item;
            });
            $(lastRow).find('.roman-col-title-content').append('<div class="ecBtn" onClick="viewAllChild(this)" style="margin-top:25px;float: right;text-decoration: underline;background-color: brown;color: #fff;padding: 5px 8px 5px 8px;border-radius: 11px;cursor: pointer;">View All Child</div>');
        }
        function viewAllChild(sender) {
            var lastRow;
            var parent = $(sender).parent().parent();
            $(sender).remove();
            $(parent).nextUntil('div.parent').each(function (i, item) {
                $(item).removeClass('hide');
                $(item).show();
                lastRow = item;
            })

            $(lastRow).find('.roman-col-title-content').append('<div class="ecBtn" onClick="viewLessChild(this)" style="margin-top:25px;float: right;text-decoration: underline;background-color: brown;color: #fff;padding: 5px 8px 5px 8px;border-radius: 11px;cursor: pointer;">View Less</div>');
            $('*[data-chosen="11"]').each(function (index) {
                var dropdown = $(this);
                $(dropdown).parent().find('.chosen-container').css('width', '200px');
            });

        }
        function viewLessParent(sender, TaskId) {
            $(sender).remove();
            sequenceScope.onTaskExpand(TaskId);
        }
        function viewAllParent(sender, TaskId) {
            var lastRow;
            $(sender).remove();
            $('#romanList_' + TaskId + ' div.parent').show();

            //Add ViewLess
            $('#romanList_' + TaskId + ' div.parent').each(function (i, item) {
                lastRow = item;
            });
            $(lastRow).find('.roman-col-title-content').append('<div onClick="viewLessParent(this,' + TaskId + ')" style="margin-top: 23px;position: absolute;left: 358px;text-decoration: underline;background-color: brown;color: #fff;padding: 5px 8px 5px 8px;border-radius: 11px;cursor: pointer;">View Less Parent</div>');
            $('*[data-chosen="11"]').each(function (index) {
                var dropdown = $(this);
                $(dropdown).parent().find('.chosen-container').css('width', '200px');
            });
        }
        function expandRomansFromTask(sender) {
            var tid = $(sender).attr('data-taskid');
            var appended = $(sender).attr('data-appended');
            //Clear prev ECs
            $('#romanList_' + tid).find('.ecBtn').remove();

            if (appended == 'false') {
                $(sender).attr('src', "../img/btn-minus.png");
                $('#roman_' + tid).show();
                $(sender).attr('data-appended', 'true');
                expandTask(tid);
                makeProgress('myBar_' + tid, 33);
            }
            else {//collapse
                //$('#romanList_' + tid).find('.ecBtn').remove();
                $(sender).attr('src', "../img/btn_maximize.png");
                $('#roman_' + tid).hide();
                $(sender).attr('data-appended', 'false');
                clearRomans(tid);
                makeProgress('myBar_' + tid, 1);
            }
        }
        function expandRomansFromRoman(sender) {
            var appended = $(sender).attr('data-appended');
            var showMoreButton = false;
            var lastRow;
            if (appended == 'false') {
                $(sender).attr('src', "../img/btn-minus.png");
                //$(sender).parent().parent().parent().nextUntil('div.parent').removeClass('hide');
                $(sender).parent().parent().parent().nextUntil('div.parent').each(function (i, item) {
                    if (i < 5)
                        $(item).removeClass('hide');
                    else if (i == 5) {
                        showMoreButton = true;
                        lastRow = item;
                    }
                    else {
                        console.log(i);
                    }
                });
                if (showMoreButton) {
                    //Add View All button
                    $(lastRow).prev().find('.roman-col-title-content').find('.ecBtn').remove();
                    $(lastRow).prev().find('.roman-col-title-content').append('<div class="ecBtn" onClick="viewAllChild(this)" style="float: right;text-decoration: underline;background-color: brown;color: #fff;padding: 5px 8px 5px 8px;border-radius: 11px;cursor: pointer;">View All</div>');
                }
                $(sender).attr('data-appended', 'true');
                $('*[data-chosen="11"]').each(function (index) {
                    var dropdown = $(this);
                    $(dropdown).parent().find('.chosen-container').css('width', '200px');
                });
            }
            else {//collapse
                $(sender).attr('src', "../img/btn_maximize.png");
                $(sender).parent().parent().parent().nextUntil('div.parent').addClass('hide');
                $(sender).attr('data-appended', 'false');
            }

        }

        function Paging(sender) {
            $('#PageIndex').val(paging.currentPage);
            ajaxExt({
                url: '/Sr_App/edituser.aspx/GetUserTouchPointLogs',
                type: 'POST',
                data: '{ pageNumber: ' + $('#PageIndex').val() + ', pageSize: ' + paging.pageSize + ', userId: ' + <%=loggedInUserId%> + ' }',
                    showThrobber: true,
                    throbberPosition: { my: "left center", at: "right center", of: $(sender), offset: "5 0" },
                    success: function (data, msg) {
                        if (data.Data.length > 0) {
                            PageNumbering(data.TotalResults);
                            var tbl = '<table cellspacing="0" cellpadding="0"><tr><th>Updated By<br/>Created On</th><th>Note</th></tr>';
                            $(data.Data).each(function (i) {
                                tbl += '<tr id="' + data.Data[i].UserTouchPointLogID + '">' +
                                    '<td><a target="_blank" href="/Sr_App/ViewSalesUser.aspx?id=' + data.Data[i].UserID + '">' + data.Data[i].SourceUser + '<br/>' + data.Data[i].ChangeDateTimeFormatted + '</a></td>' +
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
            <%--function addNotes(sender) {
                var note = $(sender).parent().find('.note-text').val();
                var tid = $(sender).parents('')
                var mtid = 0
                if (note != '')
                    ajaxExt({
                        url: '/Sr_App/itdashboard.aspx/AddNotes',
                        type: 'POST',
                        data: '{ taskId: ' + tid + ', taskMultilevelListId: ' + mtid + ',note:"' + note +'",touchPointSource:<%=(int)JG_Prospect.Common.ChatSource.ITDashboard%> }',
                        showThrobber: true,
                        throbberPosition: { my: "left center", at: "right center", of: $(sender), offset: "5 0" },
                        success: function (data, msg) {
                            $(sender).parent().find('.note-text').val('');
                            Paging(sender);
                        }
                    });
            }--%>
            var ddlDesigSeqClientIDFrozenTasks = "";
            var ddlDesigSeqClientID;
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

                        var dids = ""; var uids = '';
                        if ($('.' + ddlDesigSeqClientID).val() != undefined)
                            dids = $('.' + ddlDesigSeqClientID).val().join();
                        if ($('.chosen-select-users').val() != undefined)
                            uids = $('.chosen-select-users').val().join();

                        var attrs = $('#pnlNewFrozenTask').attr('class').split(' ');
                        var cls = attrs[attrs.length - 1];

                        if (cls != 'hide') {
                            ShowFrozenTaskSequenceDashBoard($('#' + ddlDesigSeqClientIDFrozenTasks).val(), $("#ddlSelectFrozenTask").val().join());
                            ShowNonFrozenTaskSequenceDashBoard($('#' + ddlDesigSeqClientIDFrozenTasks).find('option:selected').val(), $("#ddlSelectFrozenTask").val().join());
                        }
                        else {
                            ShowTaskSequenceDashBoard(dids, uids, true);
                            ShowTaskSequenceDashBoard(dids, uids, false);
                            //ShowAllClosedTasksDashBoard(dids, uids, pageSize);
                        }
                    },
                    error: function (errorThrown) {
                        alert("Failed!!!");
                    }
                });
            }


            function pageLoad(sender, args) {
                ddlDesigSeqClientID = 'chosen-dropDown';
                ddlDesigSeqClientIDFrozenTasks = 'chosen-dropdown-FrozenTasks';
                ChosenDropDown();
            }
            var desIds = "";
            var pageSize = 20;

            function resetChosen(selector) {
                var val = $(selector).val();

                //
                if (val != undefined && val != '') {
                    $(selector)
                        .find('option:first-child').prop('selected', false)
                        .end().trigger('chosen:updated');
                } else {
                    $(selector)
                        .find('option:first-child').prop('selected', true)
                        .end().trigger('chosen:updated');
                }
            }

            function openSeqApprovalPopup(caller) {
                var taskid = $(caller).attr('data-taskid');
                $('#hdnTaskId').val(taskid);
                var taskinfo = $('#SeqApprovalDiv' + taskid);
                var AdminUpdatedDate = $(taskinfo).attr('data-AdminStatusUpdatedDate');
                var AdminUpdatedTime = $(taskinfo).attr('data-AdminStatusUpdatedTime');
                var AdminUpdatedTimezone = $(taskinfo).attr('data-AdminStatusUpdatedTimezone');
                var AdminStatusUpdated = $(taskinfo).attr('data-AdminStatusUpdated');
                var AdminDisplayName = $(taskinfo).attr('data-AdminDisplayName');
                var AdminUserId = $(taskinfo).attr('data-AdminStatusUserId');

                var LeadUpdatedDate = $(taskinfo).attr('data-LeadStatusUpdatedDate');
                var LeadUpdatedTime = $(taskinfo).attr('data-LeadStatusUpdatedTime');
                var LeadUpdatedTimezone = $(taskinfo).attr('data-LeadStatusUpdatedTimezone');
                var LeadStatusUpdated = $(taskinfo).attr('data-LeadStatusUpdated');
                var LeadDisplayName = $(taskinfo).attr('data-LeadDisplayName');
                var LeadHours = $(taskinfo).attr('data-LeadHours');
                var LeadUserId = $(taskinfo).attr('data-LeadUserId');

                var UserUpdatedDate = $(taskinfo).attr('data-UserStatusUpdatedDate');
                var UserUpdatedTime = $(taskinfo).attr('data-UserStatusUpdatedTime');
                var UserUpdatedTimezone = $(taskinfo).attr('data-UserStatusUpdatedTimezone');
                var UserStatusUpdated = $(taskinfo).attr('data-UserStatusUpdated');
                var UserDisplayName = $(taskinfo).attr('data-UserDisplayName');
                var UserHours = $(taskinfo).attr('data-UserHours');
                var UserId = $(taskinfo).attr('data-UserUserId');

                var approvaldialog = $('.SeqApprovalPopup');
                $(approvaldialog).find('#AdminClass').attr('class', AdminStatusUpdated == '' ? 'hide' : 'display_inline');
                $(approvaldialog).find('#linkUser').attr('href', 'CreateSalesUser.aspx?id=' + AdminUserId);
                $(approvaldialog).find('#AdminDate').html(AdminUpdatedDate);
                $(approvaldialog).find('#AdminTime').html(AdminUpdatedTime);
                $(approvaldialog).find('#AdminTimezone').html(AdminUpdatedTimezone);
                $(approvaldialog).find('#AdminDisplayName').html(AdminDisplayName);
                $(approvaldialog).find('#AdminClass2').attr('class', AdminStatusUpdated != '' ? 'hide' : 'display_inline');

                //Lead
                $(approvaldialog).find('#LeadClass').attr('class', LeadStatusUpdated == '' ? 'hide' : 'display_inline');
                $(approvaldialog).find('#linkLead').attr('href', 'CreateSalesUser.aspx?id=' + LeadUserId);
                $(approvaldialog).find('#linkLead').html(LeadDisplayName);
                $(approvaldialog).find('#LeadDate').html(LeadUpdatedDate);
                $(approvaldialog).find('#LeadTime').html(LeadUpdatedTime);
                $(approvaldialog).find('#LeadTimezone').html(LeadUpdatedTimezone);
                $(approvaldialog).find('#LeadDisplayName').html(LeadDisplayName);
                $(approvaldialog).find('#LeadHours').html(LeadHours);
                $(approvaldialog).find('#LeadClass2').attr('class', LeadStatusUpdated != '' ? 'hide' : 'display_inline');
                $(approvaldialog).find('#LeadClass3').attr('class', LeadStatusUpdated != '' ? 'hide' : 'display_inline');
                $(approvaldialog).find('#LeadClass4').attr('class', LeadStatusUpdated == '' ? 'hide' : 'display_inline');

                //User
                $(approvaldialog).find('#UserClass').attr('class', UserUpdatedDate == '' ? 'hide' : 'display_inline');
                $(approvaldialog).find('#linkOtherUser').attr('href', 'CreateSalesUser.aspx?id=' + UserId);
                $(approvaldialog).find('#OtherUserStatusUpdatedDate').html(UserUpdatedDate);
                $(approvaldialog).find('#OtherUserStatusUpdatedTime').html(UserUpdatedTime);
                $(approvaldialog).find('#OtherUserStatusUpdatedTimezone').html(UserUpdatedTimezone);
                $(approvaldialog).find('#linkOtherUser').html(UserDisplayName);
                $(approvaldialog).find('#UserHours').html(UserHours);
                $(approvaldialog).find('#UserClass2').attr('class', UserStatusUpdated != '' ? 'hide' : 'display_inline');
                $(approvaldialog).find('#UserClass3').attr('class', UserStatusUpdated != '' ? 'hide' : 'display_inline');
                $(approvaldialog).find('#UserClass4').attr('class', UserStatusUpdated == '' ? 'hide' : 'display_inline');

                approvaldialog.dialog({
                    width: 400,
                    show: 'slide',
                    hide: 'slide',
                    autoOpen: false
                });

                approvaldialog.removeClass("hide");
                approvaldialog.dialog('open');
            }
            function makeProgress(sender, value) {
                var elem = document.getElementById(sender);
                var width = 1;
                var id = setInterval(frame, 10);
                function frame() {
                    if (width >= value) {
                        clearInterval(id);
                    } else {
                        width++;
                        elem.style.width = width + '%';
                    }
                }
            }
            $(document).ready(function () {
                Page = 'IT';
                TouchPointSource =<%=(int)JG_Prospect.Common.TouchPointSource.TaskGenerator %>;
                SetAccordingContent();
                //Paging($(this));
                $(".chosen-select-multi").chosen();
                $('.chosen-dropDown').chosen();
                $('.chosen-dropDownStatus').chosen();
                $('.chosen-dropdown-FrozenTasks').chosen();
                $(".chosen-select-users").chosen({ no_results_text: "No users found!" });
                $("#ddlSelectUserClosedTask").chosen({ no_results_text: "No users found!" });
                $("#ddlSelectFrozenTask").chosen();

                //InProAssigned
                $(".chosen-select-users").change(function () {
                    resetChosen(".chosen-select-users");
                    ShowTaskSequenceDashBoard($('.' + ddlDesigSeqClientID).val().join(), $(".chosen-select-users").val().join(), true);
                    ShowTaskSequenceDashBoard($('.' + ddlDesigSeqClientID).val().join(), $(".chosen-select-users").val().join(), false);
                    //ShowAllClosedTasksDashBoard($('.' + ddlDesigSeqClientID).val().join(), $(".chosen-select-users").val().join(), pageSize);
                });

                //Frozen/NonFrozen
                $("#ddlSelectFrozenTask").change(function () {
                    resetChosen("#ddlSelectFrozenTask");
                    ShowFrozenTaskSequenceDashBoard($('#' + ddlDesigSeqClientIDFrozenTasks).val(), $("#ddlSelectFrozenTask").val().join());
                    ShowNonFrozenTaskSequenceDashBoard($('#' + ddlDesigSeqClientIDFrozenTasks).find('option:selected').val(), $("#ddlSelectFrozenTask").val().join());
                });

                //set page size
                $('#drpPageSizeClosedTasks').change(function () {
                    desIds = $(".chosen-select-multi").val();
                    if (desIds == undefined) { desIds = ''; }
                    pageSize = $('#drpPageSizeClosedTasks').val();
                    //ShowAllClosedTasksDashBoard($('.' + ddlDesigSeqClientID).val().join(), $(".chosen-select-users").val().join(), pageSize)
                });

                //fill users
                if ($('#' + '<%=tableFilter.ClientID%>').length > 0) {
                    $('#ddlUserStatus').find('option:first-child').prop('selected', false);
                    $('#ddlUserStatus option[value="U1"]').attr("selected", "selected");
                    $('#ddlUserStatus option[value="T3"]').attr("selected", "selected");
                    $('#ddlUserStatus option[value="T4"]').attr("selected", "selected");
                    $('#ddlUserStatus').trigger('chosen:updated');
                    $('#ddlUserStatus').trigger('change');
                    

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

                    fillUsers(ddlDesigSeqClientID, 'ddlSelectUserInProTask', 'lblLoading');
                    fillUsers(ddlDesigSeqClientIDFrozenTasks, 'ddlSelectFrozenTask', 'lblLoadingFrozen');                    
                }
            });

            var IntTaskId;
            var IntTaskHstId;
            var IntPopupWithoutTask;
            var OfferMadePopupVisible;
            var IntDesgid;
            var IntUserid;

            function setQueryStringPara() {

                IntTaskId = getUrlVars()["TaskId"];
                IntTaskHstId = getUrlVars()["hstid"];
                IntPopupWithoutTask = getUrlVars()["PWT"];
                OfferMadePopupVisible = getUrlVars()["OF"];
                IntDesgid = getUrlVars()["did"];
                IntUserid = getUrlVars()["uid"];

            }

            $(window).load(function () {
                setQueryStringPara();
                sequenceScope.ForDashboard = true;
                var desId = "";
                var userids = "";
                desId = $('.' + ddlDesigSeqClientID).val();

                if (desId != undefined) {
                    desId = desId.join();
                }
                else {
                    desId = "";
                }

                userids = $(".chosen-select-users").val();

                if (userids != undefined) {
                    userids = userids.join();
                }
                else {
                    userids = "";
                }

                $('#refreshClosedTask').on('click', function () {
                    desId = $('.' + ddlDesigSeqClientID).val();
                    userids = $(".chosen-select-users").val();
                    if (desId != undefined) {
                        desId = desId.join();
                    }
                    else {
                        desId = "";
                    }

                    if (userids != undefined) {
                        userids = userids.join();
                    }
                    else {
                        userids = "";
                    }

                    ShowTaskSequenceDashBoard(desId, userids, false);
                    //ShowAllClosedTasksDashBoard($('.' + ddlDesigSeqClientID).val().join(), $(".chosen-select-users").val().join(), pageSize);
                });

                $('#refreshInProgTasks').on('click', function () {
                    desId = $('.' + ddlDesigSeqClientID).val();
                    userids = $(".chosen-select-users").val();
                    if (desId != undefined) {
                        desId = desId.join();
                    }
                    else {
                        desId = "";
                    }

                    if (userids != undefined) {
                        userids = userids.join();
                    }
                    else {
                        userids = "";
                    }

                    ShowTaskSequenceDashBoard(desId, userids, true);
                });


                //Set Date Filters
                $('.chkAllDates').attr("checked", true);
                //Set Date
                $('.dateFrom').val("All");
                var EndDate = new Date();
                EndDate = (EndDate.getMonth() + 1) + '/' + EndDate.getDate() + '/' + EndDate.getFullYear();
                $('.dateTo').val(EndDate);


                //for StartDate and EndDate trigger
                $('.dateFrom').change(function () {
                    ShowTaskSequenceDashBoard(desId, userids, true);
                    ShowTaskSequenceDashBoard(desId, userids, false);
                });

                $('.dateTo').change(function () {
                    ShowTaskSequenceDashBoard(desId, userids, true);
                    ShowTaskSequenceDashBoard(desId, userids, false);
                });

                $('.chkAllDates').change(function () {
                    $('.dateFrom').val("All");
                    var EndDate = new Date();
                    EndDate = (EndDate.getMonth() + 1) + '/' + EndDate.getDate() + '/' + EndDate.getFullYear();
                    $('.dateTo').val(EndDate);
                    $('.chkOneYear').attr("checked", false); $('.chkThreeMonth').attr("checked", false); $('.chkOneMonth').attr("checked", false); $('.chkTwoWks').attr("checked", false);
                    ShowTaskSequenceDashBoard(desId, userids, true);
                    ShowTaskSequenceDashBoard(desId, userids, false);
                });

                $('.chkOneYear').change(function () {
                    addMonthsToDate(12);
                    $('.dateFrom').val(StartDate);
                    $('.dateTo').val(EndDate);
                    $('.chkThreeMonth').attr("checked", false); $('.chkOneMonth').attr("checked", false); $('.chkTwoWks').attr("checked", false); $('.chkAllDates').attr("checked", false);
                    ShowTaskSequenceDashBoard(desId, userids, true);
                    ShowTaskSequenceDashBoard(desId, userids, false);
                });

                $('.chkThreeMonth').change(function () {
                    addMonthsToDate(3);
                    $('.dateFrom').val(StartDate);
                    $('.dateTo').val(EndDate);
                    $('#chkOneYear').attr("checked", false); $('.chkOneMonth').attr("checked", false); $('.chkTwoWks').attr("checked", false); $('.chkAllDates').attr("checked", false);
                    ShowTaskSequenceDashBoard(desId, userids, true);
                    ShowTaskSequenceDashBoard(desId, userids, false);
                });

                $('.chkOneMonth').change(function () {
                    addMonthsToDate(1);
                    $('.dateFrom').val(StartDate);
                    $('.dateTo').val(EndDate);
                    $('#chkOneYear').attr("checked", false); $('.chkThreeMonth').attr("checked", false); $('.chkTwoWks').attr("checked", false); $('.chkAllDates').attr("checked", false);
                    ShowTaskSequenceDashBoard(desId, userids, true);
                    ShowTaskSequenceDashBoard(desId, userids, false);
                });

                $('.chkTwoWks').change(function () {
                    addDaysToDate(13);
                    $('.dateFrom').val(StartDate);
                    $('.dateTo').val(EndDate);
                    $('#chkOneYear').attr("checked", false); $('.chkThreeMonth').attr("checked", false); $('.chkOneMonth').attr("checked", false); $('.chkAllDates').attr("checked", false);
                    ShowTaskSequenceDashBoard(desId, userids, true);
                    ShowTaskSequenceDashBoard(desId, userids, false);
                });

                if ($('#' + '<%=tableFilter.ClientID%>').length > 0) {


                    $('.' + ddlDesigSeqClientID).change(function (e) {
                        resetChosen('#ddlDesignationSeq');
                        ShowTaskSequenceDashBoard($('.' + ddlDesigSeqClientID).val().join(), '', true);
                        ShowTaskSequenceDashBoard($('.' + ddlDesigSeqClientID).val().join(), '', false);
                        //ShowAllClosedTasksDashBoard($('.' + ddlDesigSeqClientID).val().join(), $(".chosen-select-users").val().join(), pageSize)
                        fillUsers(ddlDesigSeqClientID, 'ddlSelectUserInProTask', 'lblLoading');
                    });

                    //$('#ddlUserStatus').change(function () {
                    //    //resetChosen("#ddlUserStatus");
                    //    $('.' + ddlDesigSeqClientID).trigger('change');
                    //});

                    // And now fire change event when the DOM is ready
                    $('#' + ddlDesigSeqClientID).trigger('change');
                    sequenceScope.IsTechTask = false;
                    //Get Selected Designations
                    desIds = $(".chosen-select-multi").val();
                    if (desIds == undefined) { desIds = ''; }

                // Load initial tasks for user.
                    <%if (IsSuperUser)
        { %>
                    desId = $('.' + ddlDesigSeqClientID).val().join();
                    <%}
        else
        {%>
                    desId = '';
            <%}%>

                ShowTaskSequenceDashBoard(desId, '', true);
                ShowTaskSequenceDashBoard(desId, '', false);
                //Load Closed Tasks            
                //ShowAllClosedTasksDashBoard("", 0, pageSize);

                //load Frozen/Non Tasks
                //ShowFrozenTaskSequenceDashBoard($('#' + ddlDesigSeqClientIDFrozenTasks).find('option:selected').val(), 0);
                //ShowNonFrozenTaskSequenceDashBoard($('#' + ddlDesigSeqClientIDFrozenTasks).find('option:selected').val(), 0);

                $('.' + ddlDesigSeqClientIDFrozenTasks).change(function (e) {
                    resetChosen('#ddlFrozenTasksDesignations');
                    fillUsers(ddlDesigSeqClientIDFrozenTasks, 'ddlSelectFrozenTask', 'lblLoadingFrozen');
                    ShowFrozenTaskSequenceDashBoard($('.' + ddlDesigSeqClientIDFrozenTasks).val(), 0);
                    ShowNonFrozenTaskSequenceDashBoard($('.' + ddlDesigSeqClientIDFrozenTasks).val(), 0);
                });
                }
                else {
                    
                    //For User
                    if (typeof IntUserid == "undefined" || IntUserid == "") // if interview user is there on popup then load his task.
                    { 
                        IntUserid = '';
                    }

                    ShowTaskSequenceDashBoard('', IntUserid, true);

                    if (!IntTaskId) {
                        ShowTaskSequenceDashBoard('', '', false);
                    }
                }
                showInterviewPopup();
                showOfferMadePopup();
            });

            //Date Filter
            var StartDate = new Date();
            var EndDate = new Date();

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

                if (selector == '')
                    return;
                // 
                var did = '';
                if (($('.' + selector).val() != undefined)) {
                    did = $('.' + selector).val().join();
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
                $('#ddlSelectFrozenTask_chosen').css({ "width": "300px" });
                $('#ddlFrozenTasksDesignations_chosen').css({ "width": "300px" });

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
                        $('#ddlSelectFrozenTask_chosen').css({ "width": "300px" });

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

            function redir(url) {
                window.open(url, '_blank');
            }

            function updateTaskStatus(id, value) {
                ShowAjaxLoader();
                var postData = {
                    intTaskId: id,
                    TaskStatus: value
                };

                $.ajax
                    (
                    {
                        url: '../WebServices/JGWebService.asmx/SetTaskStatus',
                        contentType: 'application/json; charset=utf-8;',
                        type: 'POST',
                        dataType: 'json',
                        data: JSON.stringify(postData),
                        asynch: false,
                        success: function (data) {
                            HideAjaxLoader();
                            alert('Task Status Updated successfully.');
                        },
                        error: function (a, b, c) {
                            HideAjaxLoader();
                        }
                    }
                    );
            }

       <%-- function checkFrozenDesignations(oSrc, args) {
                args.IsValid = ($("#<%= ddlFrozenUserDesignation.ClientID%> input:checked").length > 0);
        }--%>

            var prmTaskGenerator = Sys.WebForms.PageRequestManager.getInstance();

            prmTaskGenerator.add_endRequest(function () {
                Initialize();
            });

            function _updateQStringParam(uri, key, value, Mainkey, MainValue) {
                var re = new RegExp("([?&])" + key + "=.*?(&|$)", "i");
                var separator = uri.indexOf('?') !== -1 ? "&" : "?";

                if (uri.match(re)) {
                    return uri.replace(re, '$1' + key + "=" + value + '$2');
                }
                else {
                    uri = uri.replace("ITDashboard", "TaskGenerator");
                    return uri + separator + Mainkey + "=" + MainValue + '&' + key + "=" + value;
                }
            }

            function _updateQStringParam(uri, key, value, Mainkey, MainValue, InstallKey, InstallValue) {
                var re = new RegExp("([?&])" + key + "=.*?(&|$)", "i");
                var separator = uri.indexOf('?') !== -1 ? "&" : "?";

                if (uri.match(re)) {
                    return uri.replace(re, '$1' + key + "=" + value + '$2');
                }
                else {
                    uri = uri.replace("ITDashboard", "TaskGenerator");
                    return uri + separator + Mainkey + "=" + MainValue + '&' + key + "=" + value + '&' + InstallKey + '=' + InstallValue;
                }
            }

            $(document).ready(function () {
                Initialize();
            });

            //$(document).on('click', '#ddlSelectUserInProTask_chosen', function () {
            //    
            //    var href = $(this).find('li.search-choice a').attr('href');
            //    window.open(href, "_blank");
            //});


            function Initialize() {
                SetAccordingContent();
                SetInProTaskAutoSuggestion();
                SetInProTaskAutoSuggestionUI();

                SetFrozenTaskAutoSuggestionUI();

                SetFrozenTaskAutoSuggestion();

                SetApprovalUI();
                SetTaskCounterPopup();
                checkDropdown();

                ChosenDropDown();
                setSelectedUsersLink();

                $(".context-menu").bind("contextmenu", function () {
                    var urltoCopy = _updateQStringParam(window.location.href, "hstid", $(this).attr('data-highlighter'), "TaskId", $(this).attr('parentdata-highlighter'));
                    copyToClipboard(urltoCopy);
                    return false;
                });
            }
            function openCopyBox(obj) {
                // 
                var urltoCopy = _updateQStringParam(window.location.href, "hstid", $(obj).attr('data-highlighter'), "TaskId", $(obj).attr('parentdata-highlighter'), "InstallId", $(obj).attr('data-installid'));
                copyToClipboard(urltoCopy);
                return false;
            }

            function SetAccordingContent() {
                $("#accordion").accordion({
                    collapsible: true,
                    active: false
                });
            }


            function showInterviewPopup() {

                var showPopup = false;

                if (IntTaskId) {
                    sequenceScope.expandIntPopupTask(IntTaskHstId);
                    showPopup = true;
                }
                else if (IntPopupWithoutTask) {// If no task available hide task div.
                    showPopup = true;
                    $('#tblIntTechSeq').hide();
                }

                if (showPopup) {
                    GetEmployeeInterviewDetails();
                    $('#HighLightedTask').removeClass('hide');
                    var $dialog = $('#HighLightedTask').dialog({
                        autoOpen: true,
                        modal: false,
                        height: 500,
                        width: 1100,
                        title: 'Important Interview Information'
                    });
                }

            }

            function showOfferMadePopup() {

                if (OfferMadePopupVisible) {
                    SetOfferMadePopupContract();
                    $('#divOfferMade').removeClass('hide');
                    var $dialog = $('#divOfferMade').dialog({
                        autoOpen: true,
                        modal: false,
                        height: 700,
                        width: 1250,
                        title: 'Congratulations! You are getting an offer from us!'
                    });

                }
            }

            function SetOfferMadePopupContract() {

                var postData;
                var MethodToCall = "GetOfferMadeContract";
                postData = {};

                CallJGWebService(MethodToCall, postData, OnSetOfferMadePopupContractSuccess);

                function OnSetOfferMadePopupContractSuccess(data) {
                    if (data.d) {
                        console.log(data.d);
                        $('#divOfferContract').html(data.d);
                    }
                }
            }


            // Read a page's GET URL variables and return them as an associative array.
            function getUrlVars() {
                var vars = [], hash;
                var hashes = window.location.href.slice(window.location.href.indexOf('?') + 1).split('&');
                for (var i = 0; i < hashes.length; i++) {
                    hash = hashes[i].split('=');
                    vars.push(hash[0]);
                    vars[hash[0]] = hash[1];
                }
                return vars;
            }

            function setSelectedUsersLink() {
                //debugger; 
                $('.chosen-dropDown').each(function () {
                    var itemIndex = $(this).children('.search-choice-close').attr('data-option-array-index');
                    //console.log(itemIndex);
                    if (itemIndex) {
                        //console.log($(this).parent('.chosen-choices').parent('.chosen-container'));
                        var id = $(this).parent('.chosen-choices').parent('.chosen-container').attr('id');
                        if (id != undefined) {
                            var selectoptionid = '#' + id.replace("_chosen", "") + ' option';
                            var chspan = $(this).children('span');
                            if (chspan) {
                                chspan.html('<a style="color:blue;" href="/Sr_App/ViewSalesUser.aspx?id=' + $(selectoptionid)[itemIndex].value + '">' + chspan.text() + '</a>');
                                chspan.bind("click", "a", function () {
                                    window.open($(this).children("a").attr("href"), "_blank", "", false);
                                });
                            }
                        }
                    }
                });

                $('.chosen-select').bind('change', function (evt, params) {
                    console.log(evt);
                    console.log(params);


                });
            }

            function SetSeqApprovalUI() {
                //alert("called");
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
                    });
                });
            }

            function SetApprovalUI() {
                //// 
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
                    });
                });
            }

            function SetFrozenTaskAutoSuggestionUI() {
                //// 
                //console.log("SetFrozenTaskAutoSuggestionUI called");
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






            function SetFrozenTaskAutoSuggestion() {

                $("#txtSearchUserFrozen").catcomplete({
                    delay: 500,
                    source: function (request, response) {

                        if (request.term == "") {
                            ShowFrozenTaskSequenceDashBoard($('#' + ddlDesigSeqClientIDFrozenTasks).find('option:selected').val(), 0);
                            ShowNonFrozenTaskSequenceDashBoard($('#' + ddlDesigSeqClientIDFrozenTasks).find('option:selected').val(), 0);
                            $("#txtSearchUserFrozen").removeClass("ui-autocomplete-loading");
                            return false;
                        }

                        $.ajax({
                            type: "POST",
                            url: "ajaxcalls.aspx/GetTaskUsersForDashBoard",
                            dataType: "json",
                            contentType: "application/json; charset=utf-8",
                            data: JSON.stringify({ searchterm: request.term }),
                            success: function (data) {
                                // Handle 'no match' indicated by [ "" ] response
                                if (data.d) {
                                    ////
                                    response(data.length === 1 && data[0].length === 0 ? [] : JSON.parse(data.d));
                                }
                                // remove loading spinner image.                                
                                $("#txtSearchUserFrozen").removeClass("ui-autocomplete-loading");
                            }
                        });
                    },
                    minLength: 0,
                    select: function (event, ui) {
                        //
                        //alert(ui.item.value);
                        //alert(ui.item.id);
                        $("#txtSearchUserFrozen").val(ui.item.value);
                        //TriggerSearch();
                        ShowFrozenTaskSequenceDashBoard(0, ui.item.id);
                        ShowNonFrozenTaskSequenceDashBoard(0, ui.item.id);
                    }
                });
            }

            function SetInProTaskAutoSuggestion() {

                $("#txtSearchUser").catcomplete({
                    delay: 500,
                    source: function (request, response) {

                        if (request.term == "") {
                            var did = $('.' + ddlDesigSeqClientID).val();
                            if (did != undefined)
                                did = $('.' + ddlDesigSeqClientID).val().join();
                            else did = '';

                            ShowTaskSequenceDashBoard(did, '', true);
                            ShowTaskSequenceDashBoard(did, '', false);
                            //ShowAllClosedTasksDashBoard($('.' + ddlDesigSeqClientID).val().join(), $(".chosen-select-users").val().join(), pageSize);
                            $("#txtSearchUser").removeClass("ui-autocomplete-loading");
                            return false;
                        }

                        $.ajax({
                            type: "POST",
                            url: "ajaxcalls.aspx/GetTaskUsersForDashBoard",
                            dataType: "json",
                            contentType: "application/json; charset=utf-8",
                            data: JSON.stringify({ searchterm: request.term }),
                            success: function (data) {
                                // Handle 'no match' indicated by [ "" ] response
                                if (data.d) {
                                    ////;
                                    response(data.length === 1 && data[0].length === 0 ? [] : JSON.parse(data.d));
                                }
                                // remove loading spinner image.                                
                                $("#txtSearchUser").removeClass("ui-autocomplete-loading");
                            }
                        });
                    },
                    minLength: 0,
                    select: function (event, ui) {
                        //;
                        //alert(ui.item.value);
                        //alert(ui.item.id);
                        $("#txtSearchUser").val(ui.item.value);
                        //TriggerSearch();
                        ShowTaskSequenceDashBoard(0, ui.item.id, true);
                        ShowTaskSequenceDashBoard(0, ui.item.id, false);
                        //ShowAllClosedTasksDashBoard(0, ui.item.id, pageSize);
                    }
                });
            }

            function SetInProTaskAutoSuggestionUI() {
                //
                //console.log("SetInProTaskAutoSuggestionUI called");
                $.widget("custom.catcomplete", $.ui.autocomplete, {
                    _create: function () {
                        this._super();
                        this.widget().menu("option", "items", "> :not(.ui-autocomplete-category)");
                    },
                    _renderMenu: function (ul, items) {
                        var that = this,
                            currentCategory = "";
                        $.each(items, function (index, item) {
                            //
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

            function SetTaskCounterPopup() {

                $('#' +'<%=lblNonFrozenTaskCounter.ClientID%>').click(function () {
                    // 
                    ShowFrozenTaskSequenceDashBoard($('#' + ddlDesigSeqClientIDFrozenTasks).find('option:selected').val(), 0);
                    ShowNonFrozenTaskSequenceDashBoard($('#' + ddlDesigSeqClientIDFrozenTasks).find('option:selected').val(), 0);
                });
                $('#' + '<%=lblFrozenTaskCounter.ClientID%>').click(function () {

                    ShowFrozenTaskSequenceDashBoard($('#' + ddlDesigSeqClientIDFrozenTasks).find('option:selected').val(), 0);
                    ShowNonFrozenTaskSequenceDashBoard($('#' + ddlDesigSeqClientIDFrozenTasks).find('option:selected').val(), 0);
                });
            }

            function checkDropdown() {
         <%--   $('#<%=ddlDesigFrozen.ClientID %> [type="checkbox"]').each(function () {
                $(this).click(function () { console.log($(this).prop('checked')); })
            });--%>
            }

            function FreezeTask(sender) {

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
                    }
                    else {
                        alert(data.d.Message);
                    }
                }
            }

            function FreezeSeqTask(sender) {

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

            function FreezeSeqTask(sender, role) {

                var strTaskId = $('#hdnTaskId').val();
                var strHours = '';
                var strPassword = $(sender).val();
                var postData;
                var MethodToCall;

                if (role == 'L') {
                    strHours = $('#txtITLeadHours').val();
                    postData = {
                        strEstimatedHours: strHours,
                        strTaskApprovalId: '',
                        strTaskId: strTaskId,
                        strPassword: strPassword
                    };
                    MethodToCall = "FreezeTask";
                }
                else if (role == 'U') {
                    strHours = $('#txtUserHours').val();
                    postData = {
                        strEstimatedHours: strHours,
                        strTaskApprovalId: '',
                        strTaskId: strTaskId,
                        strPassword: strPassword
                    };
                    MethodToCall = "FreezeTask";
                }
                else {
                    postData = {
                        strTaskApprovalId: '',
                        strTaskId: strTaskId,
                        strPassword: strPassword
                    };
                    MethodToCall = "AdminFreezeTask";
                }


                CallJGWebService(MethodToCall, postData, OnFreezeTaskSuccess);

                function OnFreezeTaskSuccess(data) {
                    if (data.d.Success) {
                        alert(data.d.Message);
                        HidePopup('.SeqApprovalPopup');
                        sequenceScope.refreshTasks();
                    }
                    else {
                        alert(data.d.Message);
                    }
                }
            }

            function SetInterviewDatePopupEmployeeInstructions(DesigId) {

                var postData;
                var MethodToCall = "GetEmployeeInstructionByDesignationId";
                postData = {
                    DesignationId: DesigId,
                    UsedFor: 1 //constant used for InterviewDate popup from EmployeeInstructionUsedFor in JGConstant.cs file.                   
                };


                CallJGWebService(MethodToCall, postData, OnInterviewDatePopupEmployeeInstructionsSuccess);

                function OnInterviewDatePopupEmployeeInstructionsSuccess(data) {
                    if (data.d) {
                        //console.log(data.d);
                        //var responseObj = JSON.parse(data.d);
                        // if (responseObj) {
                        $('#InterviewInstructions').html(data.d);
                        //}
                    }
                }
            }

            function GetEmployeeInterviewDetails() {

                var EmployeeId = $('#<%=hdnUserId.ClientID%>').val();
                // alert(EmployeeId);
                var postData;
                var MethodToCall = "GetEmployeeInterviewDetails";
                postData = {
                    UserId: EmployeeId
                };


                CallJGWebService(MethodToCall, postData, OnEmployeeInterviewDetailsSuccess);

                function OnEmployeeInterviewDetailsSuccess(data) {
                    if (data.d) {
                        var responseObj = JSON.parse(data.d);

                        if (responseObj) {
                            $('#ltlApplicantName').html(responseObj[0].FristName + " " + responseObj[0].LastName);
                            $('#ltlApplicantId').html(responseObj[0].UserInstallId);
                            $('#ltlDesignation').html(responseObj[0].Designation);
                            $('#InterviewDateTime').html(responseObj[0].RejectionDate + " " + responseObj[0].RejectionTime);

                            SetInterviewDatePopupEmployeeInstructions(responseObj[0].DesignationId);
                        }
                    }
                }
            }
            function LoadNotes(sender, taskid, taskMultilevelListId) {
                ajaxExt({
                    url: '/Sr_App/itdashboard.aspx/GetTaskChatMessages',
                    type: 'POST',
                    data: '{ taskId: ' + taskid + ',taskMultilevelListId:' + taskMultilevelListId +',chatSourceId:<%=(int)JG_Prospect.Common.ChatSource.ITDashboard%> }',
                    showThrobber: false,
                    throbberPosition: { my: "left center", at: "right center", of: $('.task-' + taskid), offset: "5 0" },
                    success: function (data, msg) {
                        var unreadCount = 0;
                        if (data.Data.length > 0) {
                            var tbl = '<table class="notes-table" cellspacing="0" cellpadding="0" data-parenttaskid="' + taskid + '" data-romanid="' + taskMultilevelListId + '" data-recids="' + data.Message + '" data-userchatgroupid="' + data.Data[0].UserChatGroupId + '" onclick="openChatPopup(this)">';
                            $(data.Data).each(function (i) {
                                if (data.Data[i].IsRead == '0') {
                                    unreadCount += 1;
                                }
                                tbl += '<tr>' +
                                    '<td>' + data.Data[i].SourceUsername + '- <a target="_blank" href="/Sr_App/ViewSalesUser.aspx?id=' + data.Data[i].UpdatedByUserID + '">' + data.Data[i].SourceUserInstallId + '</a><br/>' + data.Data[i].ChangeDateTimeFormatted + '</td>' +
                                    '<td><div class="note-desc">' + data.Data[i].LogDescription + '</div></td>' +
                                    '</tr>';
                            });
                            tbl += '</table>';
                            var tdHeight = $('.task-' + taskid).parents('tr').height();
                            $(sender).html(tbl);
                            //$(sender).css('height',(tdHeight-36)+'px');
                            var tuid = getUrlVars()["TUID"];
                            var nid = getUrlVars()["NID"];
                            if (tuid != undefined && nid != undefined) {
                                $('.notes-table tr#' + nid).addClass('blink-notes');
                            }
                        } else {
                            var tbl = '<table class="notes-table" cellspacing="0" cellpadding="0">' +
                                '<tr><td>&nbsp;</td><td>&nbsp;</td></tr>' +
                                '<tr><td>&nbsp;</td><td>&nbsp;</td></tr>' +
                                '<tr><td>&nbsp;</td><td>&nbsp;</td></tr>' +
                                '</table>';
                            $(sender).html(tbl);
                        }
                        //$(sender).parents('.notes-section').find('.notes-table').attr('onclick','openChat(this, ' + taskid + ',' + 0 + ',\'' + data.Message + '\',0)');
                        if (unreadCount > 0) {
                            $(sender).parents('.notes-section').prepend('<span class="unread-chat-count">' + unreadCount + '</span>');
                        } else {
                            $(sender).parents('.notes-section').find('span.unread-chat-count').remove();
                        }
                        //LoadTaskMultilevelList(sender,taskid);
                    }
                });
            }

            function ReLoadNotes() {
                $('.main-task').each(function (i) {
                    var taskid = $(this).attr('taskid');
                    var taskMultilevelListId = $(this).attr('taskMultilevelListId');
                    LoadNotes($(this), taskid, taskMultilevelListId);
                });
                $('.sub-task').each(function (i) {
                    var taskid = $(this).attr('taskid');
                    var taskMultilevelListId = $(this).attr('taskMultilevelListId');
                    LoadNotes($(this), taskid, taskMultilevelListId);
                });
            }

            <%--function LoadTaskMultilevelList(sender, taskId) {
                ajaxExt({
                    url: '/WebServices/JGWebService.asmx/GetMultiLevelList',
                    type: 'POST',
                    data: '{ ParentTaskId: ' + taskId + ',chatSourceId:<%=(int)JG_Prospect.Common.ChatSource.ITDashboard%> }',
                    showThrobber: false,
                    throbberPosition: { my: "left center", at: "right center", of: $(sender), offset: "5 0" },
                    success: function (data, msg) {
                        var str = '';
                        if (data.Results.length > 0)
                            //str = '<div id="accordionParentTask' + taskId + '"><h2>&nbsp;<strong>Load more</strong></h2><div><div class="row">';
                        $.each(data.Results, function (i) {
                            str += '<div class="row-item">' +
                                '<div class="col1">' + '<a class="label" href"#">' + data.Results[i].Label + '.</a> ' + data.Results[i].Description + '</div>' +
                                '<div class="col2">' +
                                '<div class="notes-section" userChatGroupId="'+data.Results[i].UserChatGroupId+'" taskid="' + data.Results[i].ParentTaskId + '" taskMultilevelListId="' + data.Results[i].Id + '">' +
                                '<div class="note-list">' +
                                '<table onclick="openChat(this, ' + data.Results[i].ParentTaskId + ',' + data.Results[i].Id + ',\'' + data.Results[i].ReceiverIds + '\','+data.Results[i].UserChatGroupId+')" class="notes-table" cellspacing="0" cellpadding="0">';
                            if (data.Results[i].Notes.length > 0) {
                                var tbl = '';
                                $(data.Results[i].Notes).each(function (j) {
                                    tbl += '<tr>' +
                                        '<td>' + data.Results[i].Notes[j].SourceUsername + '- <a target="_blank" href="/Sr_App/ViewSalesUser.aspx?id=' + data.Results[i].Notes[j].UpdatedByUserID + '">' + data.Results[i].Notes[j].SourceUserInstallId + '</a><br/>' + data.Results[i].Notes[j].ChangeDateTimeFormatted + '</td>' +
                                        '<td title="' + data.Results[i].Notes[j].LogDescription + '"><div class="note-desc">' + data.Results[i].Notes[j].LogDescription + '</div></td>' +
                                        '</tr>';
                                });
                            } else {
                                var tbl = '<tr><td>&nbsp;</td><td>&nbsp;</td></tr>' +
                                    '<tr><td>&nbsp;</td><td>&nbsp;</td></tr>' +
                                    '<tr><td>&nbsp;</td><td>&nbsp;</td></tr>';
                            }
                            str += tbl + '</table></div>';// End of note list
                            str += '<div class="notes-inputs">' +
                                '<div class="first-col"><input type="button" class="GrdBtnAdd" value="Add Notes" onclick="addNotes(this,' + taskId + ',' + data.Results[i].Id + ','+data.Results[i].UserChatGroupId+')"></div>' +
                                '<div class="second-col"><textarea class="note-text textbox"></textarea></div>' +
                                '</div>' +
                                '</div>'; // End of notes section
                            str += '</div></div>'; // End of row-item
                        });
                        if (data.Results.length > 0)
                            str += '</div></div>';
                        var container = $(sender).parents('div.div-table-row');
                        $(container).find('div.row').remove();
                        $(container).append(str);

                        $('.row-item').each(function () {
                            var h = $(this).find('.col1').height();
                            $(this).find('.col2').css('height', h + 'px');
                            $(this).find('.note-list').css('height', (h - 30) + 'px');
                        });

                        //$("#accordionParentTask" + taskId).accordion({
                        //    collapsible: true,
                        //    active: false
                        //});
                    }
                });
            }--%>
            function addNotes(sender) {
                var note = $(sender).parents('.notes-inputs').find('.note-text').val();
                var taskId = $(sender).parents('.notes-section').attr('taskid');
                var taskmultilevellistid = $(sender).parents('.notes-section').attr('taskmultilevellistid');
                var userChatGroupId = $(sender).parents('.notes-section').attr('userchatgroupid');
                if (note != '')
                    ajaxExt({
                        url: '/Sr_App/itdashboard.aspx/AddNotes',
                        type: 'POST',
                        data: '{ taskId: ' + taskId + ',taskMultilevelListId:' + taskmultilevellistid + ', note: "' + note + '", touchPointSource: ' + <%=(int)JG_Prospect.Common.TouchPointSource.ITDashboard %> + ' }',
                        showThrobber: true,
                        throbberPosition: { my: "left center", at: "right center", of: $(sender), offset: "5 0" },
                        success: function (data, msg) {
                            $(sender).parents('.notes-inputs').find('.note-text').val('');
                            //Paging(sender);
                            LoadNotes($(sender).parents('.notes-section').find('.notes-table').parent(), taskId, taskmultilevellistid);
                            // Refresh Online users
                            GetOnlineUsers();
                        }
                    });
            }

            function openChat(sender, taskId, taskMultilevelListId, receiverIds, userChatGroupId) {
                InitiateChat(sender, receiverIds, null, '<%=(int)JG_Prospect.Common.ChatSource.ITDashboard%>', taskId, taskMultilevelListId, userChatGroupId);
            }
            function openChatPopup(sender) {
                //data-ParentTaskId="{{Roman.ParentTaskId}}" data-RomanId="{{Roman.Id}}"
                //data-RecIds="{{Roman.ReceiverIds}}" data-UserChatGroupId="{{Roman.UserChatGroupId}}"

                openChat(sender, $(sender).attr('data-ParentTaskId'), $(sender).attr('data-RomanId'), $(sender).attr('data-RecIds'), $(sender).attr('data-UserChatGroupId'));
            }
            $(document).on('change', '#ddlUserStatus', function () {
                var allStatus = [];
                var attr = $(this).attr('multiple');
                var $select = $(this);
                if (typeof attr !== typeof undefined && attr !== false) {
                    var seletedValues = $($select).val();
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
                        var curIndex = $(this).attr('index');
                        if(curValue != null && curValue != undefined){
                            if(seletedValues.indexOf(curValue) >= 0 && $(this).attr('class') != undefined){
                                allStatus.push({index: curIndex, cls: $(this).attr('class'), stValue: $(this).val()});
                            }
                        }
                    });
                    $(allStatus).each(function(i){
                        $($select).parent().find('.chosen-choices .search-choice a[data-option-array-index="' + allStatus[i].index + '"]').parents('li.search-choice').addClass(allStatus[i].cls);
                    });
                }
                $('.' + ddlDesigSeqClientID).trigger('change');
            });
    </script>
</asp:Content>
