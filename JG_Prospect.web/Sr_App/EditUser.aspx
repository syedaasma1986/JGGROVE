<%@ Page Title="" Language="C#" MasterPageFile="~/Sr_App/SR_app.Master" EnableEventValidation="false" AutoEventWireup="true" ValidateRequest="false"
    CodeBehind="EditUser.aspx.cs" Inherits="JG_Prospect.EditUser" MaintainScrollPositionOnPostback="true" Async="true" %>

<%@ Register Assembly="System.Web.DataVisualization, Version=4.0.0.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35" Namespace="System.Web.UI.DataVisualization.Charting" TagPrefix="asp" %>

<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<%@ Register Assembly="CKEditor.NET" Namespace="CKEditor.NET" TagPrefix="CKEditor" %>
<%@ Register Src="~/UserControl/ucStatusChangePopup.ascx" TagPrefix="ucStatusChange" TagName="PoPup" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">

    <script src="../js/Custom/JgPopUp.js?v=<%#JG_Prospect.Common.modal.SingletonGlobal.Instance.RandomGUID %>" type="text/javascript"></script>
    <link type="text/css" href="../css/flags24.css" rel="Stylesheet" />
    <link href="../css/jquery.timepicker.css" rel="stylesheet" />
    <style type="text/css">
        .filter {
            width: 100%;
        }

        table.filter td {
            padding: 0px !important;
            vertical-align: central !important;
        }

        .filterdiv {
            vertical-align: middle;
            height: 50%;
            line-height: 15px;
            margin: 5px 0 5px 2px;
            width: 98%;
        }

        .filterdivbottom {
            border-top: 1px solid white;
        }

        .ddlstatus-per-text {
            float: right;
            width: 100%;
            font-size: 8px;
        }

        img.fnone {
            height: 8px;
            width: 8px;
        }

        /*.form_panel ul li {
       width: 90% !important;
            }*/
        .dd .ddChild li {
            width: 95% !important;
        }


        /*Grid add Container START*/
        .GrdContainer {
            width: 100%;
            border: 1px solid #d3d3d3;
        }

            .GrdContainer div {
                width: inherit;
            }

            .GrdContainer .GrdHeader {
                background-color: #a09585 !important;
                padding: 2px;
                cursor: pointer;
                font-weight: bold;
                width: initial;
                text-align: left;
                font-size: 20px;
            }

            .GrdContainer .GrdContent {
                display: none;
                /* padding: 5px;
                height: 160px;*/
            }

                .GrdContainer .GrdContent span {
                    margin: 0px !important;
                    display: block;
                    width: inherit;
                }

        .GrdContent ul li span {
            width: 100% !important;
        }

        .GrdContent ul li {
            width: 80%;
            padding-top: 10px;
        }

            .GrdContent ul li span label {
                width: 75%;
                float: left;
                padding-top: 0px;
            }

            .GrdContent ul li span input {
                width: 20% !important;
                float: left;
            }

            .GrdContent ul li select, .GrdContent ul li input {
                width: 85% !important;
            }

        .GrdBtnAdd {
            margin-top: 12px;
            height: 30px;
            background: url(img/main-header-bg.png) repeat-x;
            color: #fff;
            cursor: pointer;
            border-radius: 5px;
        }

        /*Grid add Container END */
        .PrimaryPhone {
            cursor: pointer;
        }

        .GrdPrimaryEmail {
            text-decoration: underline;
            cursor: pointer;
            color: blue;
            line-height: 20px;
            width: 150px;
            overflow: hidden;
            white-space: nowrap;
            text-overflow: ellipsis;
            display: none;
        }

        .form_panel ul li {
            margin: 0 !important;
        }
        /*.GrdPrimaryEmail:hover {
        overflow: visible;
        white-space: normal;
        width: auto;
        position: absolute;
        background-color: #FFF;
        }*/
        .ddChild li {
            text-align: left;
            margin: 0 !important;
            /*width: auto ;!important;*/
            width: auto;
            border-bottom: none;
        }

        .grd-lblPrimaryPhone img {
            float: left;
            display: none;
        }

        .grd-lblPrimaryPhone {
            width: 135px !important;
            padding-top: 8px;
            display: none;
        }

        .user-zip {
            padding-left: 50px;
            margin-left: 70px;
        }

        .SearchLoad {
            position: absolute;
            display: block;
            margin-top: 116px;
            margin-left: 153px;
        }

        .wordBreak {
            word-wrap: break-word;
        }

        .black_overlay {
            display: none;
            position: fixed;
            top: 0%;
            left: 0%;
            width: 100%;
            height: 100%;
            background-color: black;
            z-index: 1001;
            -moz-opacity: 0.8;
            opacity: .80;
            filter: alpha(opacity=80);
            overflow-y: hidden;
        }

        /*#327FB5*/
        .white_content {
            display: none;
            position: absolute;
            top: 10%;
            left: 20%;
            width: 60%;
            min-height: 10%;
            padding: 0 16px 16px 16px;
            border: 10px solid #000000;
            background-color: white;
            z-index: 1002;
            overflow: auto;
        }

        .ddcommon.disabledAll {
            width: 35% !important;
        }

        .close {
            position: absolute;
            top: 35px;
            right: 30px;
            transition: all 200ms;
            font-size: 30px;
            font-weight: bold;
            text-decoration: none;
            color: #333;
        }

        .HeaderFreez {
            position: absolute;
            /*top: expression(this.offsetParent.scrollTop);*/
            z-index: 10;
            margin-top: -53px;
        }

        .grdUserMain {
            /*margin-top: 50px;*/
        }

            .grdUserMain tr td {
                padding: 10px 8px 12px 4px !important;
            }

        .txtSearch {
            width: 135px;
            padding: 5px;
            border-radius: 5px 0 0 5px;
            color: #666;
            font-size: 14px;
        }

        .btnSearc {
            width: 100px;
            border-radius: 0 5px 5px 0;
            line-height: 28px;
            background: #A33E3F;
            color: #fff;
            cursor: pointer;
        }
        /*Code change by Deep*/
        .scroll tbody {
            height: 1275px !important;
        }

        .scroll {
            font-size: 12px;
        }

        .right_panel {
            margin: 0 0 0 0 !important;
        }

        .first-col {
            width: 20%;
            float: left;
        }

        .second-col {
            float: left;
            width: 78%;
        }

            .second-col textarea.note-text {
                width: 99%;
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
        }

        .pos-rel {
            position: relative;
        }

        .notes-inputs {
            text-align: left;
            height: 30px;
            padding: 2px;
            position: absolute;
            left: 0;
            bottom: 0;
            width: 100%;
        }

        .notes-table {
            height: auto;
            width: 100%;
            margin: 0 5px;
            font-size: 12px;
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

        .rejected {
            background-color: #AEAEAE;
        }

        .deleted {
            background-color: #565656;
        }

        .interview-date-expired {
            background-color: #d3d3d3;
        }

        .applicant {
            background-color: #FFFF00;
        }

        .install-prospect {
            background-color: #FFA500;
        }

        table.notes-table tr.trHeader {
            background: none !important;
        }

        .notes-popup {
            display: none;
            position: fixed;
            top: 100px;
            left: 300px;
            width: 800px;
            background: #fff;
            z-index: 11;
            border-radius: 5px;
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
            padding: 5px;
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
                width: 185px;
            }

        .notes-popup .add-notes-container {
            display: inline-block;
            width: 98%;
            padding: 5px;
        }

            .notes-popup .add-notes-container textarea {
                width: 80% !important;
                height: 50px !important;
                padding: 5px !important;
            }

        .notes-container .note-desc {
            width: 230px;
            height: 29px;
            overflow: hidden;
            text-overflow: ellipsis;
            white-space: nowrap;
        }

        .notes-popup .notes-container .note-desc {
            width: 194px;
            height: 29px;
            overflow: hidden;
            text-overflow: ellipsis;
            white-space: nowrap;
        }
    </style>
    <style type="text/css">
        #hint {
            cursor: pointer;
        }

        .startooltip {
            margin: 8px;
            padding: 8px;
            border: 1px solid blue;
            background-color: #ddd;
            position: absolute;
            z-index: 2;
        }

        .contactGrid {
            padding: 0px !important;
            margin: 0px !important;
            overflow: visible !important;
            width: 100% !important;
        }

            .contactGrid > li {
                width: 100% !important;
                text-align: left;
                margin: 2px 0px;
            }

            .contactGrid li select.mail {
                width: 90% !important;
                height: 25px;
            }

            .contactGrid li select.phone {
                width: 40% !important;
                height: 25px;
            }


            .contactGrid li input.phone {
                width: 65px !important;
            }

            .contactGrid li .ext {
                width: 10%;
                background: white;
                display: inline-block;
                /*padding: 5px;*/
            }

            .contactGrid .dd .ddTitle .ddTitleText img {
                padding: 0px !important;
            }

            .contactGrid select.phone option[data-p='1'] {
                color: red;
            }

        .noMargin span {
            margin: 0px !important;
        }

        textarea.note-text {
            height: 22px;
            vertical-align: middle;
            padding: 2px !important;
            width: 255px;
            margin: 0px;
        }

        .content .row {
            display: inline-block;
            width: 100%;
        }

            .content .row.sender .user-image {
                float: right;
                margin-left: 5px;
            }

            .content .row.receiver .user-image {
                float: left;
                margin-right: 5px;
            }

            .content .row .user-image {
                position: relative;
                width: 80px;
            }

                .content .row .user-image .img img {
                    width: 80px;
                }

                .content .row .user-image .installid {
                    position: absolute;
                    bottom: 0px;
                    width: 100%;
                    text-align: center;
                    background: #ddd;
                }

                .content .row .user-image .status-icon {
                    position: absolute;
                    right: 2px;
                    top: 2px;
                    width: 16px;
                    height: 16px;
                    border-radius: 8px;
                    background: green;
                }

                .content .row .user-image .installid a {
                }

        .time-container {
            float: right;
        }

        .row .contents {
            width: 600px;
            border-radius: 10px;
            padding: 30px;
        }

        .row.sender .contents {
            float: right;
            background: #333;
            color: #ccc;
            border-radius: 30px 30px 0;
        }

        .row.receiver .contents .est {
            color: #000;
        }

        .row.receiver .contents {
            float: left;
            background: #A33E3F;
            border-radius: 30px 30px 30px 0;
            color: #ccc;
        }

        .row .contents .tick, .row .contents .time, .row .contents .est {
            display: inline-block;
        }

        .row .contents .est {
            color: #A33E3F;
        }

        .tick img {
            width: 16px;
        }
    </style>
    <script type="text/javascript">

        function addNotes(sender, uid, txtUid) {
            var note = $(sender).parents('.notes-inputs').find('.note-text').val();
            var chatSource = $(sender).parents('.notes-section').find('.notes-table').attr('chatsource');
            var chatGroupId=$(sender).parents('.notes-section').find('.notes-table').attr('chatgroupid');
            var userchatgroupid=$(sender).parents('.notes-section').find('.notes-table').attr('userchatgroupid');
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
                        LoadNotes(sender, txtUid, uid);
                        // Refresh Online users
                        GetOnlineUsers();
                    }
                });
        }
        //tribute.attach(document.querySelectorAll('.note-text'));
        function LoadNotes(sender, installUserId, userid) {
            ajaxExt({
                url: '/Sr_App/edituser.aspx/GetUserTouchPointLogs',
                type: 'POST',
                data: '{ pageNumber: 0, pageSize: 5, userId: ' + userid + ',chatSourceId:<%=(int)JG_Prospect.Common.ChatSource.EditUserPage%> }',
                showThrobber: true,
                throbberPosition: { my: "left center", at: "right center", of: $('#user-' + userid), offset: "5 0" },
                success: function (data, msg) {
                    var unreadCount=0;
                    var ReceiverIds = data.Message.split(':')[0];
                    var UserChatGroupId = data.Message.split(':')[1];
                    var ChatGroupId = data.Message.split(':')[2];
                    var chatSourceId = data.Message.split(':')[3];
                    if (data.Data.length > 0) {
                        var tbl = '<table chatsource="' + chatSourceId + '" class="notes-table" cellspacing="0" cellpadding="0" receiverIds="'+ReceiverIds+'" userChatGroupId="'+UserChatGroupId+'" chatGroupId="'+ChatGroupId+'">';
                        $(data.Data).each(function (i) {
                            if(data.Data[i].IsRead=='0'){
                                unreadCount += 1;
                            }
                            tbl += '<tr iuid="' + installUserId + '" uid="' + data.Data[i].UserID + '" id="' + data.Data[i].UserTouchPointLogID + '">' +
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
                        var tbl = '<table class="notes-table" cellspacing="0" cellpadding="0" receiverIds="'+ReceiverIds+'" userChatGroupId="'+ChatGroupId+'" chatGroupId="'+ChatGroupId+'">' +
                            '<tr uid="' + userid + '"><td>&nbsp;</td><td>&nbsp;</td></tr>' +
                            '<tr uid="' + userid + '"><td>&nbsp;</td><td>&nbsp;</td></tr>' +
                            '<tr uid="' + userid + '"><td>&nbsp;</td><td>&nbsp;</td></tr>' +
                            '</table>';
                        $('#user-' + userid).html(tbl);
                        tribute.attach(document.getElementById('txt-' + userid));
                    }
                    if(unreadCount>0){
                        $('#user-' + userid).parents('.notes-section').prepend('<span class="unread-chat-count">'+unreadCount+'</span>');
                    }else{
                        $('#user-' + userid).parents('.notes-section').find('span.unread-chat-count').remove();
                    }
                }
            });
        }

        function Paging(sender) {
            $('#PageIndex').val(paging.currentPage);
            ajaxExt({
                url: '/Sr_App/edituser.aspx/GetUserTouchPointLogs',
                type: 'POST',
                data: '{ pageNumber: ' + $('#PageIndex').val() + ', pageSize: ' + paging.pageSize + ', userId: ' + $('#popupNoteUserId').val() + ',chatSourceId:<%=(int)JG_Prospect.Common.ChatSource.EditUserPage%> }',
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
                        tribute.attach(document.getElementById('txt-popup'));
                    } else {
                        $('.notes-popup .content').html('Notes not found');
                    }
                }
            });
            return false;
        }

        $(document).on('click', '.notes-table tr', function (e) {
            if (!$(e.target).is('a')) {
                //$('.notes-popup').css({ left: ($(window).width() / 2) - 400 });
                //$('#popupNoteUserId').val($(this).attr('uid'));
                //$('#popupNoteTxtUserId').val($(this).attr('iuid'));
                //$('.notes-popup').show();
                //$('.notes-popup-background').show();
                //Paging($(this));

                // Open Chat Window
                var chatgroupid=$(this).parents('.notes-table').attr('chatgroupid');
                var receiverids=$(this).parents('.notes-table').attr('receiverids');
                var userchatgroupid=$(this).parents('.notes-table').attr('userchatgroupid');
                InitiateChat(this, receiverids, chatgroupid,'<%=(int)JG_Prospect.Common.ChatSource.EditUserPage%>', 0, 0, userchatgroupid);
                //ajaxExt({
                //    url: '/WebServices/JGWebService.asmx/InitiateChat',
                //    type: 'POST',
                //    data: '{ userID: ' + $(this).attr('uid') + ' }',
                //    showThrobber: true,
                //    throbberPosition: { my: "left center", at: "right center", of: $(this), offset: "5 0" },
                //    success: function (data, msg) {
                //        var id = data.Object.split('`')[0];
                //        var name = data.Object.split('`')[1];
                //        //$('.chat-container').show();
                //        if($('#'+id).length <= 0){
                //            $('.telecom-dashboard-popup').show();
                //            $('.overlay').show();
                //            window.scrollTo(0, 0);                            
                //            var strChat = '<div class="chat-box" id="' + id + '" style="display:block;">' +
                //                                '<div class="header"><span class="group-name">' + name +
                //                                    '</span><span class="close" onclick="closechat(this)"><i class="fa fa-times" aria-hidden="true"></i></span>' +
                //                                    '<span class="minimize" onclick="minimize(this)"><i class="fa fa-minus" aria-hidden="true"></i></span></div>' +
                //                                '<input type="hidden" id="ChatGroupId" value="' + id + '" />' +
                //                                '<div class="chats"></div>' +
                //                                '<div class="chat-text">' +
                //                                    '<input type="text" class="mention" id="chattext" onkeyup="sendChat(event, this);"  />' +
                //                                    //'<input type="button" value="Send" id="sendChat" />' +
                //                                '</div>' +
                //                           '</div>';
                //            $('.all-chats').append(strChat);
                //            // reset existing @mention and add new @mention support 
                //            $('input.mention').parent().find('.mentions').remove();
                //            $('input.mention').parent().find('.mentions-autocomplete-list').remove();
                //            $('input.mention').mentionsInput({
                //                onDataRequest: function (mode, query, callback) {
                //                    ajaxExt({
                //                        url: '/WebServices/JGWebService.asmx/GetUsers',
                //                        type: 'POST',
                //                        data: '{ keyword: "' + query + '", chatGroupId:"' + userTobeAddedIntoChatGroupId + '" }',
                //                        showThrobber: true,
                //                        throbberPosition: { my: "left center", at: "right center", of: $(this), offset: "5 0" },
                //                        success: function (data, msg) {
                //                            responseData = data.Results;
                //                            responseData = _.filter(responseData, function (item) {
                //                                return item.name.toLowerCase().indexOf(query.toLowerCase()) > -1
                //                            });
                //                            callback.call(this, responseData);
                //                        }
                //                    });
                //                }
                //            });
                //            // Load User's list on right panel
                //            loadChatUsers(this);
                //        }
                //    }
                //});
            }
        });

        function addPopupNotes(sender) {
            var userId = $('#popupNoteUserId').val();
            var txtUserId = $('#popupNoteTxtUserId').val();
            addNotes(sender, userId, txtUserId);
        }

        function closeNotesPopup() {
            paging.currentPage = 0;
            $('.notes-popup .content').html('Loading Notes...');
            $('.notes-popup').hide();
            $('.notes-popup-background').hide();

        }

        function validateContact(event, obj) {
            var selValue = $(obj).parent().find('select.typeDrop option:selected').text().toLowerCase();

            if (selValue.indexOf("phone") >= 0) {
                return IsNumeric(event, true);
            }
            else { return true; }
        }

        function ConfirmDelete() {
            var Ok = confirm('Are you sure you want to Delete this User?');
            if (Ok)
                return true;
            else
                return false;
        }

        function ClosePopup() {
            document.getElementById('light').style.display = 'none';
            document.getElementById('fade').style.display = 'none';
        }

        function overlay() {
            document.getElementById('light').style.display = 'block';
            document.getElementById('fade').style.display = 'block';
        }


        function ClosePopupInterviewDate() {
            document.getElementById('interviewDatelite').style.display = 'none';
            document.getElementById('interviewDatefade').style.display = 'none';
        }

        function overlayInterviewDate() {

            document.getElementById('interviewDatelite').style.display = 'block';
            document.getElementById('interviewDatefade').style.display = 'block';
            //$('#interviewDatelite').focus();
            $("html, body").animate({ scrollTop: 0 }, "slow");
        }

        function ClosePopupOfferMade() {
            document.getElementById('DivOfferMade').style.display = 'none';
            document.getElementById('DivOfferMadefade').style.display = 'none';
        }

        function OverlayPopupOfferMade() {
            document.getElementById('DivOfferMade').style.display = 'block';
            document.getElementById('DivOfferMadefade').style.display = 'block';
            $("html, body").animate({ scrollTop: 0 }, "slow");
        }

        function ClosePopupUploadBulk() {
            document.getElementById('lightUploadBulk').style.display = 'none';
            document.getElementById('fadeUploadBulk').style.display = 'none';
        }

        function OverlayPopupUploadBulk() {
            alert('Successfully imported users and auto-email/sms sent for request for applicant to fill out Hr form https://www.jmgroveconstruction.com/employment.php');
            document.getElementById('lightUploadBulk').style.display = 'block';
            document.getElementById('fadeUploadBulk').style.display = 'block';
            $("html, body").animate({ scrollTop: 0 }, "slow");
        }

        function CloseAddUserPopUp() {
            document.getElementById('lightUploadBulk').style.display = 'none';
            document.getElementById('fadeUploadBulk').style.display = 'none';
        }

        //var validFilesTypes = ["xls", "xlsx", "csv"];
        var validFilesTypes = ["xlsx", "csv"];
        function ValidateFile() {
            var file = document.getElementById("<%=BulkProspectUploader.ClientID%>");
            var label = document.getElementById("<%=Label1.ClientID%>");
            var path = file.value;
            var ext = path.substring(path.lastIndexOf(".") + 1, path.length).toLowerCase();
            var isValidFile = false;
            for (var i = 0; i < validFilesTypes.length; i++) {
                if (ext == validFilesTypes[i]) {
                    isValidFile = true;
                    break;
                }
            }
            if (!isValidFile) {
                alert('Select file of type csv or xlsx ');
                //label.style.color = "red";
                //label.innerHTML = "Invalid File. Please upload a File with" +

                // " extension:\n\n" + validFilesTypes.join(", ");

            }
            return isValidFile;
        }

    </script>
    <script>
        $(document).on('keyup', '.txtSearch', function (e) {
            if (e.keyCode == 13) {
                $('.btnSearchGridData').trigger('click');
            }
            e.stopPropagation();
        });

        $(document).on('click', '.ClearSearch', function (e) {
            $('.txtSearch').val('');
            $('.btnSearchGridData').trigger('click');
        });

        function pageLoad() {


            $(document).ready(function () {

                $(".GrdHeader").click(function () {

                    $header = $(this);
                    //getting the next element
                    $content = $header.next();
                    //open up the content needed - toggle the slide- if visible, slide up, if not slidedown.
                    $content.slideToggle(500, function () {
                        //execute this after slideToggle is done
                        //change text of header based on visibility of content div
                        $header.text(function () {
                            //change text based on condition
                            return $content.is(":visible") ? "-" : "+";
                        });
                    });
                });


                $('.PrimaryPhone').click(function () {
                    showCustomPopUp("\\CommingSoon.aspx", "Primary Phone");
                });
                //$('.GrdPrimaryEmail').click(function () {
                //showCustomPopUp("\\CommingSoon.aspx", "Primary Email");
                //});

                try {
                    $('.typeDrop').msDropDown();// OnPreRender="PhoneTypeDropdown_PreRender" CssClass="typeDrop"
                } catch (e) {
                    alert(e.message);
                }

                $(".typeDrop").change(function () {
                    var selValue = $(this).parent().find('option:selected').text().toLowerCase();
                    $(this).parent().parent().find("input.phone").val('');

                    if (selValue.indexOf("phone") >= 0) {
                        $(this).parent().parent().find("input.ext").show();
                        $(this).parent().parent().find("input.phone").attr('placeholder', 'Phone');
                    }
                    else {
                        $(this).parent().parent().find("input.ext").hide();
                        $(this).parent().parent().find("input.phone").attr('placeholder', 'Email');
                    }
                });

                $(".phone").change(function () {
                    setCheckBox(this);

                    var ext = $(this).find('option:selected').attr('data-ext');

                    if (ext != undefined & ext != null)
                        $(this).parent().find('span.ext').text(ext);
                });

                $(".mail").change(function () {
                    setCheckBox(this);
                });
            });
        }

        function setCheckBox(obj) {
            var isPrimary = $(obj).find('option:selected').attr('data-p');

            if (isPrimary == '1') {
                $(obj).parent().find('input[type="checkbox"]').prop('checked', true);
            }
            else {
                $(obj).parent().find('input[type="checkbox"]').prop('checked', false);
                $(obj).parent().find('input[type="checkbox"]').removeProp('checked');
            }
        }
    </script>
    <style type="text/css">
        .modalBackground {
            background-color: Black;
            filter: alpha(opacity=90);
            opacity: 0.8;
        }

        .modalPopup {
            background-color: #FFFFFF;
            border-width: 3px;
            border-style: solid;
            border-color: black;
            padding-top: 10px;
            padding-left: 2px;
            width: 129px;
            height: 173px;
        }

        table.select_period_table {
        }

            table.select_period_table tr td {
                width: 50% !important;
            }

                table.select_period_table tr td label {
                    display: block !important;
                    width: 100% !important;
                }

                table.select_period_table tr td input {
                    width: 100% !important;
                    box-sizing: border-box !important;
                }

        table.tblshowhrdata {
            width: 100%;
            border: 1px solid #ddd;
            background: #fff;
            border-collapse: collapse;
        }

        .tblPieChart td.head {
            color: white;
            font-weight: bold;
            text-align: center;
            height: 15px;
            background: #A33E3F url(../img/line.png) bottom repeat-x;
            padding: 10px 0px;
            width: 32%;
            line-height: 15px;
            min-height: 5px;
            vertical-align: top;
        }

        .scrollCls {
            height: 300px !important;
            overflow-y: scroll;
        }
        /*.scrollCls table tbody {
            display: block;
            height: 300px;
            overflow-y: scroll;
        }*/

        .form_panel table tr td .starimg {
            width: 15px;
            height: 15px;
            border: none !important;
            /*background-image:url(../img/star.png);*/
        }

        .form_panel table tr td .starimgred {
            width: 15px;
            height: 15px;
            border: none !important;
            /*background-image:url(../img/starred.png);*/
        }
    </style>
    <link href="../Styles/dd.css?v=<%#JG_Prospect.Common.modal.SingletonGlobal.Instance.RandomGUID %>" rel="stylesheet" />
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <%
        string baseUrl = HttpContext.Current.Request.Url.Scheme +
                            "://" + HttpContext.Current.Request.Url.Authority +
                            HttpContext.Current.Request.ApplicationPath.TrimEnd('/') + "/";


    %>
    <link href="../css/dropzone/css/basic.css" rel="stylesheet" />
    <link href="../css/dropzone/css/dropzone.css" rel="stylesheet" />
    <script type="text/javascript" src="../js/dropzone.js"></script>
    <script src="../ckeditor/ckeditor.js"></script>
    <div class="right_panel">
        <!-- appointment tabs section start -->
        <ul class="appointment_tab">
            <li><a href="HRReports.aspx">HR Reports</a></li>
            <li><a href="InstallCreateUser.aspx">Create Install User</a></li>
            <li><a href="EditInstallUser.aspx">Edit Install User</a></li>
            <li><a href="CreateSalesUser.aspx">Create Sales-Admin_IT User</a></li>
            <li><a href="EditUser.aspx">Edit Sales-Admin_IT User</a></li>
        </ul>
        <h1>Edit User</h1>
        <div class="form_panel">
            <asp:UpdatePanel ID="upSalesUserStatictics" runat="server">
                <ContentTemplate>
                    <span>
                        <asp:Label ID="lblmsg" runat="server" Visible="false"></asp:Label>
                    </span>
                    <table style="width: 100%; background-color: #fff;" class="tblPieChart">
                        <tr>
                            <td style="width: 50%; padding: 0px;">
                                <asp:Chart ID="Chart1" runat="server" Height="320px" Width="415px">
                                    <Titles>
                                        <asp:Title ShadowOffset="3" Name="Items" />
                                    </Titles>
                                    <Legends>
                                        <asp:Legend Alignment="Center" Docking="Bottom" IsTextAutoFit="False" Name="Default" LegendStyle="Table" />
                                    </Legends>
                                    <Series>
                                        <asp:Series Name="Default" />
                                    </Series>
                                    <ChartAreas>
                                        <asp:ChartArea Name="ChartArea1" BorderWidth="0" />
                                    </ChartAreas>
                                </asp:Chart>
                            </td>
                            <td style="width: 50%; padding: 0px;">
                                <div class="scrollCls">
                                    <table style="height: inherit;">
                                        <tr>
                                            <td class="head">Added By</td>
                                            <td class="head">Designation</td>
                                            <td class="head">Source</td>
                                        </tr>
                                        <tr>
                                            <td style="padding: 0px;">
                                                <table>
                                                    <asp:ListView ID="listAddedBy" runat="server">
                                                        <ItemTemplate>
                                                            <tr>
                                                                <td><span><%#(Eval("AddedBy") == null || Eval("AddedBy") == "") ? "No Name" : Eval("AddedBy")%></span></td>
                                                                <td><span><%#Eval("Count")%></span></td>
                                                            </tr>
                                                        </ItemTemplate>
                                                    </asp:ListView>
                                                </table>
                                            </td>
                                            <td style="padding: 0px;">
                                                <table>
                                                    <asp:ListView ID="listDesignation" runat="server">
                                                        <ItemTemplate>
                                                            <tr>
                                                                <td><span><%#(Eval("Designation") == null || Eval("Designation") == "") ? "No Designation" : Eval("Designation")%></span></td>
                                                                <td><span><%#Eval("Count")%></span></td>
                                                            </tr>
                                                        </ItemTemplate>
                                                    </asp:ListView>
                                                </table>
                                            </td>
                                            <td style="padding: 0px;">
                                                <table>
                                                    <asp:ListView ID="listSource" runat="server">
                                                        <ItemTemplate>
                                                            <tr>
                                                                <td><span><%#(Eval("Source") == null || Eval("Source") == "") ? "No Name" : Eval("Source")%></span></td>
                                                                <td><span><%#Eval("Count")%></span></td>
                                                            </tr>
                                                        </ItemTemplate>
                                                    </asp:ListView>
                                                </table>
                                            </td>
                                        </tr>
                                    </table>
                                </div>
                            </td>
                        </tr>
                    </table>
                    <br />
                    <br />
                    <div class="showhrdata">
                        <table class="tblshowhrdata">
                            <tr>
                                <td>
                                    <asp:Label ID="lbljoboffer" runat="server">New "Job Offers" Submissions</asp:Label>
                                </td>
                                <td>
                                    <asp:Label ID="lbljoboffercount" runat="server" Text="0"></asp:Label>
                                </td>
                                <td>
                                    <asp:Label ID="lblInterviewDate" runat="server">New "Interview Date"</asp:Label>
                                </td>
                                <td>
                                    <asp:Label ID="lblInterviewDateCount" runat="server" Text="0"></asp:Label>
                                </td>
                                <td>
                                    <asp:Label ID="lblActive" runat="server">New active</asp:Label>
                                </td>
                                <td>
                                    <asp:Label ID="lblActiveCount" runat="server" Text="0"></asp:Label>
                                </td>
                            </tr>
                            <tr>
                                <td>
                                    <asp:Label ID="lblPhoneVideoScreened" runat="server">New "Phone/Video Screened"</asp:Label>
                                </td>
                                <td>
                                    <asp:Label ID="lblPhoneVideoScreenedCount" runat="server" Text="0"></asp:Label>
                                </td>
                                <td>
                                    <asp:Label ID="lblRejected" runat="server">New "Rejected"</asp:Label>
                                </td>
                                <td>
                                    <asp:Label ID="lblRejectedCount" runat="server" Text="0"></asp:Label>
                                </td>
                                <td>
                                    <asp:Label ID="lblDeactivated" runat="server">New "Deactivated"</asp:Label>
                                </td>
                                <td>
                                    <asp:Label ID="lblDeactivatedCount" runat="server" Text="0"></asp:Label>
                                </td>
                            </tr>
                            <tr>
                                <td>
                                    <asp:Label ID="lblNewApplicants" runat="server">New "Applicants"</asp:Label>
                                </td>
                                <td>
                                    <asp:Label ID="lblNewApplicantsCount" runat="server" Text="0"></asp:Label>
                                </td>
                                <td>
                                    <asp:Label ID="lblInstallProspect" runat="server">New "Prospect Referrals"</asp:Label>
                                </td>
                                <td>
                                    <asp:Label ID="lblInstallProspectCount" runat="server" Text="0"></asp:Label>
                                </td>

                                <td>
                                    <asp:Label ID="lblAppInterview" runat="server">Applicant/interview ratio</asp:Label>
                                </td>
                                <td>
                                    <asp:Label ID="lblAppInterviewRatio" runat="server" Text="0"></asp:Label>
                                </td>
                            </tr>
                            <tr>
                                <td>
                                    <asp:Label ID="lblInterviewActive" runat="server">Interview/Active ratio</asp:Label>
                                </td>
                                <td>
                                    <asp:Label ID="lblInterviewActiveRatio" runat="server" Text="0"></asp:Label>
                                </td>
                                <td>
                                    <asp:Label ID="lblJobOfferActive" runat="server">Offer Made/Active ratio</asp:Label>
                                </td>
                                <td>
                                    <asp:Label ID="lblJobOfferActiveRatio" runat="server" Text="0"></asp:Label>
                                </td>
                                <td>
                                    <asp:Label ID="lblActiveDeactive" runat="server">Active/Deactive Ratio</asp:Label>
                                </td>
                                <td>
                                    <asp:Label ID="lblActiveDeactiveRatio" runat="server" Text="0"></asp:Label>
                                </td>
                                <%--<td>
                                    <asp:Label ID="lblInactive" runat="server">New Inactive</asp:Label>
                                </td>
                                <td>
                                    <asp:Label ID="lblInactiveCount" runat="server" Text="0"></asp:Label>
                                </td><td>
                                    <asp:Label ID="lblAppHire" runat="server">Applicant/new hire ratio</asp:Label>
                                </td>
                                <td>
                                    <asp:Label ID="lblAppHireRatio" runat="server" Text="0"></asp:Label>
                                </td><td>
                                    <asp:Label ID="lblJobOfferHire" runat="server">Job Offer/new hire ratio	</asp:Label>
                                </td>
                                <td>
                                    <asp:Label ID="lblJobOfferHireRatio" runat="server" Text="0"></asp:Label>
                                </td>--%>
                            </tr>
                        </table>
                    </div>
                </ContentTemplate>
            </asp:UpdatePanel>
            <br />
            <br />
            <asp:UpdatePanel ID="upFilter" runat="server">
                <ContentTemplate>
                    <table class="filter">
                        <tr style="background-color: #A33E3F; color: white; font-weight: bold; text-align: center; width: 100%;">
                            <td width="15%">
                                <div class="filterdiv filterdivtop">
                                    <asp:Label ID="lblUserStatus" Text="User Status" runat="server" /><span style="color: red">*</span>
                                </div>
                                <div class="filterdiv filterdivbottom">
                                    <asp:Label ID="lblDesignation" Text="Designation" runat="server" />
                                </div>
                            </td>

                            <td width="20%">
                                <div class="filterdiv filterdivtop">
                                    <span>Secondary Status</span>
                                </div>
                                <div class="filterdiv filterdivbottom">
                                    <span>Saved Reports</span>
                                </div>
                            </td>
                            <td width="15%">
                                <div class="filterdiv filterdivtop">
                                    <asp:Label ID="lblAddedBy" Text="Added By" runat="server" />
                                </div>
                                <div class="filterdiv filterdivbottom">
                                    <asp:Label ID="lblSourceH" Text="Source" runat="server" />
                                </div>

                            </td>

                            <td style="text-align: center;">
                                <div class="filterdiv ">
                                    <asp:Label ID="Label2" Text="Select Period" runat="server" />
                                </div>
                            </td>

                        </tr>
                        <tr style="text-align: center; width: 100%">
                            <td style="text-align: center;" width="15%">
                                <div class="filterdiv filterdivtop">
                                    <asp:ListBox ID="ddlUserStatus" CssClass="chosen-select status-dd" SelectionMode="Multiple" runat="server" />
                                    <input type="hidden" runat="server" id="hdnStatuses">
                                </div>
                                <div class="filterdiv filterdivbottom">
                                    <asp:ListBox ID="ddlDesignation" CssClass="chosen-select" runat="server" SelectionMode="Multiple" />
                                    <input type="hidden" runat="server" id="hdnDesignations">
                                </div>
                            </td>
                            <td width="20%">
                                <asp:DropDownList ID="ddlSavedReport" AutoPostBack="true" runat="server" CssClass="textbox" OnSelectedIndexChanged="ddlSavedReport_SelectedIndexChanged">
                                    <asp:ListItem Text="Last Login &darr;" Selected="True" Value="LastLoginTimeStamp^DESC"></asp:ListItem>                                    
                                    <asp:ListItem Text="Created On &darr;" Value="CreatedDateTime^DESC"></asp:ListItem>
                                </asp:DropDownList>
                            </td>
                            <td width="15%">
                                <div class="filterdiv filterdivtop">
                                    <asp:ListBox ID="drpUser" SelectionMode="Multiple" CssClass="chosen-select" runat="server"></asp:ListBox>
                                    <input type="hidden" runat="server" id="hdnFilterUsers">
                                </div>
                                <div class="filterdiv filterdivbottom">
                                    <asp:ListBox ID="ddlSource" runat="server" CssClass="chosen-select" SelectionMode="Multiple"></asp:ListBox>
                                    <input type="hidden" runat="server" id="hdnSources">
                                </div>
                                <asp:Button ID="btnSearchFilterwise" runat="server" OnClick="btnSearchFilterwise_Click" CssClass="hide" />
                            </td>

                            <td style="text-align: left; text-wrap: avoid;">
                                <div style="float: left; width: 50%;">
                                    <ul class="userDatafilter">
                                        <li>
                                            <asp:CheckBox ID="chkAllDates" runat="server" Checked="true" Text="All" OnCheckedChanged="chkAllDates_CheckedChanged" AutoPostBack="true" />
                                        </li>
                                        <li>
                                            <asp:CheckBox ID="chkOneYear" runat="server" Checked="false" Text="1 year" OnCheckedChanged="chkOneYear_CheckedChanged" AutoPostBack="true" />
                                        </li>
                                        <li>
                                            <asp:CheckBox ID="chkThreeMonth" runat="server" Checked="false" Text=" Quarter (3 months)" OnCheckedChanged="chkThreeMonth_CheckedChanged" AutoPostBack="true" /></li>

                                    </ul>
                                    <ul class="userDatafilter">
                                        <li>
                                            <asp:CheckBox ID="chkOneMonth" runat="server" Checked="false" Text=" 1 month" OnCheckedChanged="chkOneMonth_CheckedChanged" AutoPostBack="true" />
                                        </li>
                                        <li>
                                            <asp:CheckBox ID="chkTwoWks" runat="server" Checked="false" Text=" 2 weeks (pay period!)" OnCheckedChanged="chkTwoWk_CheckedChanged" AutoPostBack="true" /></li>
                                    </ul>
                                </div>

                                <div>
                                    <asp:Label ID="Label3" Text="From :*" runat="server" />
                                    <asp:TextBox ID="txtHRFromDate" runat="server" TabIndex="2" CssClass="date" MaxLength="10" Style="width: 60px;"></asp:TextBox>

                                    <asp:Label ID="Label4" Text="To :*" runat="server" />
                                    <asp:TextBox ID="txtHRToDate" CssClass="date"
                                        MaxLength="10" runat="server" TabIndex="3"
                                        Style="width: 65px;"></asp:TextBox>

                                    <asp:RequiredFieldValidator ID="requirefrmdate" ControlToValidate="txtHRFromDate"
                                        runat="server" ErrorMessage=" Select From date" ForeColor="Red" ValidationGroup="show">
                                    </asp:RequiredFieldValidator><asp:RequiredFieldValidator ID="Requiretodate" ControlToValidate="txtHRToDate"
                                        runat="server" ErrorMessage=" Select To date" ForeColor="Red" ValidationGroup="show">
                                    </asp:RequiredFieldValidator>
                                </div>
                            </td>
                        </tr>

                    </table>
                </ContentTemplate>
            </asp:UpdatePanel>
            <div style="width: auto; border: 1px solid #ccc; padding: 3px;">
                <asp:UpdatePanel ID="upUsers" runat="server" UpdateMode="Conditional">
                    <ContentTemplate>



                        <div style="float: left; padding-top: 10px; margin-right: 1.7%; /*margin-bottom: -40px; */">
                            <asp:Label ID="lblFrom" runat="server" />&nbsp;<asp:Label ID="Label5" runat="server" Text="to" />&nbsp;
                            <asp:Label ID="lblTo" runat="server" Style="color: #19ea19" />
                            <asp:Label ID="lblof" runat="server" Text="of" />
                            <asp:Label ID="lblCount" runat="server" Style="color: red;" />
                            <asp:Label ID="lblselectedchk" runat="server" Style="font-weight: bold;" />
                        </div>
                        <div style="float: right;">
                            <input type="button" class="btnSearc ClearSearch" value="Clear" />
                            <asp:TextBox ID="txtSearch" runat="server" CssClass="textbox txtSearch" placeholder="search users" MaxLength="15" />
                            <asp:Button ID="btnSearchGridData" runat="server" Text="Search" class="btnSearc btnSearchGridData" OnClick="btnSearchGridData_Click" />

                            Number of Records: 
                            <asp:DropDownList ID="ddlPageSize_grdUsers" runat="server" AutoPostBack="true"
                                OnSelectedIndexChanged="ddlPageSize_grdUsers_SelectedIndexChanged">
                                <asp:ListItem Text="10" Value="10" />
                                <asp:ListItem Text="20" Value="20" />
                                <asp:ListItem Selected="True" Text="25" Value="25" />
                                <asp:ListItem Text="30" Value="30" />
                                <asp:ListItem Text="40" Value="40" />
                                <asp:ListItem Text="50" Value="50" />
                            </asp:DropDownList>

                            <%-- Showing :  
                                <asp:Label ID="PageRowCountLabel" runat="server" Text="Label" />
                             of
                                <asp:Label ID="PageTotalLabel" runat="server" Text="Label" />--%>
                        </div>

                        <asp:GridView ID="grdUsers" OnPreRender="grdUsers_PreRender" runat="server" CssClass="scroll" Width="100%" EmptyDataText="No Data"
                            AutoGenerateColumns="False" DataKeyNames="Id,DesignationID" AllowSorting="true" AllowPaging="true" AllowCustomPaging="true" PageSize="25"
                            OnRowDataBound="grdUsers_RowDataBound" OnRowCommand="grdUsers_RowCommand" OnSorting="grdUsers_Sorting"
                            OnPageIndexChanging="grdUsers_PageIndexChanging">
                            <PagerSettings Mode="NumericFirstLast" NextPageText="Next" PreviousPageText="Previous" Position="Bottom" />
                            <PagerStyle HorizontalAlign="Right" CssClass="pagination-ys" />
                            <Columns>
                                <asp:TemplateField HeaderText="Action <br/> Picture" HeaderStyle-HorizontalAlign="Center" ItemStyle-HorizontalAlign="Center" HeaderStyle-Width="1%"
                                    ItemStyle-Width="1%">
                                    <ItemTemplate>
                                        <asp:HiddenField runat="server" ID="bmId" Value='<%#Eval("bookmarkedUser")%>' />
                                        <asp:HiddenField runat="server" Value='<%#Eval("Id")%>' ID="hdId" />
                                        <asp:HiddenField runat="server" Value='<%#Eval("picture")%>' ID="hdimgsource" />
                                        <%--<asp:CheckBox ID="chkSelected" AutoPostBack="true" data-userid='<%#Eval("Id")%>' OnCheckedChanged="chkSelected_CheckedChanged" runat="server" CssClass="useraction" Style="position: relative; top: 2px; right: 30px;" />--%>
                                        <asp:CheckBox ID="chkSelected" AutoPostBack="false" data-userid='<%#Eval("Id")%>' data-designationid='<%#Eval("DesignationID")%>' runat="server" CssClass="useraction" Style="position: relative; top: 2px; right: 30px;" />
                                        <%-- <asp:Image CssClass="starimg"  ID="starblankimg"  runat="server" ImageUrl= "../img/star.png"    ></asp:Image> --%>
                                        <%-- <asp:ImageButton ID="starredimg" CssClass="starimg" runat="server" ImageUrl="~/img/starred.png" OnClientClick=<%# "GotoStarUser('" + Eval("Id") + "','1')" %>></asp:ImageButton>--%>
                                        <a href='<%# String.Concat("ViewSalesUser.aspx?ID=", Eval("Id")) %>'>
                                            <asp:Image Style="width: 100%; margin-top: -20px" ID="imgprofile" runat="server"></asp:Image></a>
                                        <asp:LinkButton ID="lbltest" Text="Edit" CommandName="EditSalesUser" runat="server" CommandArgument='<%#Eval("Id")%>'></asp:LinkButton>
                                        <%--<asp:LinkButton ID="lbltest" Text="Edit" CommandName="EditSalesUser" runat="server" Visible='<%# Eval("picture").ToString()!="" && Eval("picture")!= null ? true :  false %>' CommandArgument='<%#Eval("Id")%>'></asp:LinkButton>--%>
                                        <%-- <asp:LinkButton ID="lnkDeactivate" Text="Deactivate" CommandName="DeactivateSalesUser" runat="server" OnClientClick="return confirm('Are you sure you want to deactivate this user?')"
                                            CommandArgument='<%#Eval("Id")%>'></asp:LinkButton>--%>
                                        <asp:LinkButton ID="lnkDelete" Text="Delete" CommandName="DeleteSalesUser" runat="server" OnClientClick="return confirm('Are you sure you want to delete this user?')"
                                            CommandArgument='<%#Eval("Id")%>'></asp:LinkButton>
                                    </ItemTemplate>
                                </asp:TemplateField>
                                <asp:TemplateField ShowHeader="True" HeaderText="ID# <br/>  Designation<br/> F&LName" HeaderStyle-HorizontalAlign="Center" ItemStyle-HorizontalAlign="Center" HeaderStyle-Width="1%" ItemStyle-Width="1%" ControlStyle-ForeColor="Black"
                                    Visible="true" SortExpression="Designation">
                                    <EditItemTemplate>
                                        <asp:TextBox ID="txtid" runat="server" MaxLength="30" Text='<%#Eval("Id")%>'></asp:TextBox>
                                    </EditItemTemplate>
                                    <ItemTemplate>
                                        <asp:Label ID="lblid" Visible="false" runat="server" Text='<%#Eval("Id")%>'></asp:Label>
                                        <asp:LinkButton ID="lnkID" Text='<%#Eval("UserInstallId")%>' CommandName="EditSalesUser" runat="server"
                                            CommandArgument='<%#Eval("Id")%>'></asp:LinkButton>
                                        <br />
                                        <asp:HiddenField ID="lblDesignationID" runat="server" Value='<%#Eval("DesignationID")%>'></asp:HiddenField>
                                        <asp:HiddenField ID="lblDesignation" runat="server" Value='<%#Eval("Designation")%>'></asp:HiddenField>
                                        <asp:DropDownList ID="drpDesig" Width="140px" Style="text-align: left; width: 95%;" AutoPostBack="true" OnSelectedIndexChanged="drpDesig_SelectedIndexChanged" runat="server">
                                        </asp:DropDownList>
                                        <br />
                                        <asp:Label ID="lblFirstName" runat="server" Text='<%#Eval("FristName").ToString().Trim()%>'></asp:Label>
                                        <asp:Label ID="lblLastName" runat="server" Text='<%# Eval("Lastname").ToString().Trim() %>'></asp:Label><br />
                                        <asp:Label ID="lblSalaryReq" runat="server" Text='<%# Eval("SalaryReq").ToString().Trim() %>'></asp:Label> / Year
                                        <asp:Label ID="lblCurrency" runat="server" Text='<%# Eval("CurrencyName").ToString().Trim() %>'></asp:Label>
                                    </ItemTemplate>
                                    <ControlStyle ForeColor="Black" />
                                    <ControlStyle ForeColor="Black" />
                                    <ItemStyle HorizontalAlign="Center"></ItemStyle>
                                </asp:TemplateField>

                                <asp:TemplateField HeaderText="Last name" Visible="false" SortExpression="Lastname" ItemStyle-HorizontalAlign="Center">
                                    <EditItemTemplate>
                                        <asp:TextBox ID="txtlastname" runat="server" Text='<%# Bind("Lastname") %>'></asp:TextBox>
                                    </EditItemTemplate>
                                    <ItemTemplate>
                                    </ItemTemplate>
                                </asp:TemplateField>
                                <asp:TemplateField HeaderText="Designation" Visible="false" SortExpression="Designation" ItemStyle-HorizontalAlign="Center">
                                    <EditItemTemplate>
                                        <asp:TextBox ID="txtDesignation" runat="server" Text='<%#Eval("Designation")%>'></asp:TextBox>
                                    </EditItemTemplate>
                                    <ItemTemplate>
                                        <asp:Label ID="lblGrdDesignation" runat="server" Text='<%#Eval("Designation")%>'></asp:Label>
                                    </ItemTemplate>
                                    <ItemStyle HorizontalAlign="Center"></ItemStyle>
                                </asp:TemplateField>
                                <asp:TemplateField HeaderText="Status" ItemStyle-HorizontalAlign="Center" HeaderStyle-HorizontalAlign="Center" HeaderStyle-Width="7%" ItemStyle-Width="7%" SortExpression="Status">
                                    <ItemTemplate>
                                        <asp:HiddenField ID="lblStatus" runat="server" Value='<%#Eval("Status")%>'></asp:HiddenField>
                                        <asp:HiddenField ID="lblSecondaryStatus" runat="server" Value='<%#Eval("SecondaryStatus")%>'></asp:HiddenField>
                                        <asp:HiddenField ID="lblOrderStatus" runat="server" Value='<%#(Eval("OrderStatus") == null || Eval("OrderStatus") == "") ? -99 : Eval("OrderStatus")%>'></asp:HiddenField>

                                        <asp:DropDownList ID="ddlStatus" Width="400px" CssClass="grd-status" Style="text-align: left; width: 95%;" OnSelectedIndexChanged="grdUsers_ddlStatus_SelectedIndexChanged" runat="server" onchange="javascript:GridstatusChanged(event,this);" OnPreRender="ddlUserStatus_PreRender">
                                        </asp:DropDownList>
                                        <asp:DropDownList ID="ddlSecondaryStatus" Width="400px" CssClass="grd-status" Style="text-align: left; width: 95%;" runat="server" onchange="javascript:GridSecondaryStatusChanged(event,this);" ></asp:DropDownList>
                                        <asp:Label ID="hdnlblEmail" runat="server" CssClass="OffferMadeEmail hide" Text='<%#Eval("Email")%>'></asp:Label>
                                        <asp:Label ID="hdnlblFname" runat="server" CssClass="OffferMadeFirstName hide" Text='<%#Eval("FristName")%>'></asp:Label>
                                        <asp:Label ID="hdnlblLName" runat="server" CssClass="OffferMadeLastName hide" Text='<%#Eval("LastName")%>'></asp:Label>
                                        <asp:Label ID="hdnlblDesignation" runat="server" CssClass="OffferMadeDesignation hide" Text='<%#Eval("Designation")%>'></asp:Label>
                                        <asp:Label ID="hdnlblOldStatus" runat="server" CssClass="OffferMadeOldStatus hide" Text='<%#Eval("Status")%>'></asp:Label>
                                        <asp:Label ID="hdnlblUserID" runat="server" CssClass="OffferMadeUserID hide" Text='<%#Eval("Id")%>'></asp:Label>
                                        <asp:Label ID="hdnlblUserDesiID" runat="server" CssClass="OffferMadeUserDesignID hide" Text='<%#Eval("DesignationID")%>'></asp:Label>

                                        <br />
                                        <asp:Literal ID="ltlStatusReason" runat="server" Text='<%#  string.Format(Eval("StatusReason").ToString() == "" ? "" : Eval("StatusReason").ToString() + "{0}", "<br />") %>'></asp:Literal>
                                        <asp:Literal ID="ltlRejectedDetails" runat="server" Text='<%#  string.Format(Eval("RejectDetail").ToString() == "" ? "" : Eval("RejectDetail").ToString() + "{0}", "<br />") %>'></asp:Literal>
                                        <span><%#Eval("RejectedByUserName")%></span>
                                        <asp:HyperLink runat="server" Visible='<%#(string.IsNullOrEmpty(Eval("RejectedByUserInstallId").ToString())) ? false : true%>' NavigateUrl='<%#(string.IsNullOrEmpty(Eval("RejectedUserId").ToString())) ? "#" : "ViewSalesUser.aspx?id=" + Eval("RejectedUserId")%>'
                                            Text='<%#(string.IsNullOrEmpty(Eval("RejectedByUserInstallId").ToString())) ? "" : "- " + Eval("RejectedByUserInstallId")%>'></asp:HyperLink>
                                        <br />
                                        <span><%#string.IsNullOrEmpty(Eval("InterviewDetail").ToString()) ? "" : Eval("InterviewDetail").ToString().Split(' ')[0]%></span>&nbsp<span style="color: red"><%#string.IsNullOrEmpty(Eval("InterviewDetail").ToString()) ? "" : Eval("InterviewDetail").ToString().Remove(0, Eval("InterviewDetail").ToString().IndexOf(' ') + 1)%></span>&nbsp<span><%#string.IsNullOrEmpty(Eval("InterviewDetail").ToString()) ? "" : "(EST)"%></span><asp:Label ID="lblInterviewDetail" runat="server" Visible="false" Text='<%#Eval("InterviewDetail") %>'></asp:Label>
                                        <asp:HyperLink ID="hypTechTask" runat="server" Visible="false" />
                                    </ItemTemplate>
                                    <ItemStyle HorizontalAlign="Center"></ItemStyle>
                                </asp:TemplateField>
                                <asp:TemplateField HeaderText="Source<br/>Added By<br/>Added On" HeaderStyle-Width="4%" ItemStyle-Width="4%" SortExpression="Source" ItemStyle-HorizontalAlign="Center" HeaderStyle-HorizontalAlign="Center">
                                    <ItemTemplate>
                                        <asp:Label ID="lblSource" runat="server" Text='<%#Eval("Source")%>'></asp:Label>
                                        <br />
                                        <span><%#Eval("AddedBy")%></span>
                                        <a href='<%#(string.IsNullOrEmpty(Eval("AddedById").ToString())) ? "#" : "ViewSalesUser.aspx?id=" + Eval("AddedById")%>'><%#(string.IsNullOrEmpty(Eval("AddedByUserInstallId").ToString())) ? "" : "- " + Eval("AddedByUserInstallId")%></a>

                                        <br />
                                        <span><%#String.Format("{0:M/d/yyyy}", Eval("CreatedDateTime"))%></span>&nbsp<span style="color: red"><%#String.Format("{0:hh:mm:ss tt}", Eval("CreatedDateTime"))%></span>&nbsp<span>(EST)</span>
                                    </ItemTemplate>
                                </asp:TemplateField>
                                <asp:TemplateField HeaderText="Added On" Visible="false" SortExpression="CreatedDateTime" HeaderStyle-HorizontalAlign="Center" ItemStyle-HorizontalAlign="Center">
                                    <ItemTemplate>
                                    </ItemTemplate>
                                </asp:TemplateField>

                                <asp:TemplateField HeaderText="Email<br/>Phone Type - Phone" HeaderStyle-Width="15%" ItemStyle-Width="15%" ItemStyle-HorizontalAlign="left" SortExpression="Phone">
                                    <ItemTemplate>

                                        <div class="GrdPrimaryEmail">
                                            <asp:LinkButton ID="lbtnEmail" runat="server" Text='<%# Eval("Email") %>' ToolTip='<%# Eval("Email") %>'
                                                CommandName="send-email" CommandArgument='<%# Container.DataItemIndex %>' />
                                        </div>
                                        <asp:Label ID="lblPrimaryPhone" CssClass="grd-lblPrimaryPhone" data-click-to-call="true" runat="server" Text='<%# Eval("PrimaryPhone") %>'></asp:Label>
                                        <br />

                                        <ul class="contactGrid">
                                            <li>
                                                <asp:CheckBox ID="chkEmailPrimary" CssClass="liCheck" AutoPostBack="true" OnCheckedChanged="chkPrimary_CheckedChanged" runat="server"></asp:CheckBox>&nbsp;
                                                <asp:DropDownList runat="server" CssClass="mail" ID="ddlEmail"></asp:DropDownList>
                                            </li>
                                            <li>
                                                <asp:CheckBox ID="chkPhonePrimary" AutoPostBack="true" OnCheckedChanged="chkPrimary_CheckedChanged" runat="server"></asp:CheckBox>
                                                <asp:DropDownList runat="server" CssClass="phone" ID="ddlPhone"></asp:DropDownList>
                                                <!-- over here -->
                                                <asp:DropDownList runat="server" OnPreRender="PhoneTypeDropdown_PreRender" Enabled="false" CssClass="typeDrop"
                                                    ID="ddlPhoneTypeDisplay">
                                                </asp:DropDownList>
                                            </li>
                                            <li>
                                                <asp:DropDownList runat="server" OnPreRender="PhoneTypeDropdown_PreRender" CssClass="typeDrop"
                                                    ID="ddlPhoneType" Width="114px">
                                                </asp:DropDownList>
                                                <asp:CheckBox ID="chkPrimary" runat="server"></asp:CheckBox>
                                                <asp:TextBox ID="txtContact" placeholder="Phone" CssClass="phone" runat="server" onkeydown="return validateContact(event, this);"></asp:TextBox>
                                                <!-- over here -->
                                                <asp:Button ID="btnAddContact" CssClass="GrdBtnAdd" runat="server" Text="Add" CommandName="AddNewContact"
                                                    CommandArgument='<%# Eval("Id") %>'></asp:Button>
                                            </li>
                                        </ul>
                                        <asp:Label ID="lblExt" CssClass="ext" runat="server" Visible="false"></asp:Label>
                                        <asp:TextBox ID="txtExt" Visible="false" placeholder="Ext" MaxLength="8" CssClass="ext" runat="server"></asp:TextBox>

                                    </ItemTemplate>
                                </asp:TemplateField>
                                <asp:TemplateField HeaderText="Country-Zip-City<br/>Type-Apptitude Test %<br/>Resume Attachment" HeaderStyle-Width="2%" ItemStyle-Width="2%" ItemStyle-HorizontalAlign="Center" SortExpression="Zip" ControlStyle-CssClass="wordBreak">
                                    <ItemTemplate>
                                        <div title='<%#Eval("Country") %>' style='<%# string.IsNullOrEmpty(Eval("CountryCode").ToString()) == true ? "": "background-image:url(img/flags24.png);background-repeat:no-repeat;float:left;height:22px;width:24px;margin-top:-5px;" %>' class='<%#Eval("CountryCode").ToString().ToLower()%>'>
                                        </div>

                                        <asp:Label ID="lblCity" runat="server" Text='<%#Eval("City") %>'></asp:Label>
                                        <asp:Label ID="lblZip" runat="server" Text='<%# " - " + Eval("Zip") %>'></asp:Label>

                                        <asp:HiddenField ID="hdnUserInstallId" Value='<%#Eval("Id")%>' runat="server"></asp:HiddenField>
                                        <asp:Label ID="lblExamResults" runat="server" Text=""></asp:Label>

                                        <asp:HiddenField ID="lblEmployeeType" runat="server" Value='<%#Eval("EmpType")%>'></asp:HiddenField>
                                        <asp:DropDownList ID="ddlEmployeeType" Style="width: 95%;" AutoPostBack="true" runat="server" OnSelectedIndexChanged="ddlEmployeeType_SelectedIndexChanged">
                                            <asp:ListItem Text="Select" Value="0"></asp:ListItem>
                                            <asp:ListItem Text="Temp" Value="1"></asp:ListItem>
                                            <asp:ListItem Text="Internship" Value="2"></asp:ListItem>
                                            <asp:ListItem Text="Part Time - Remote" Value="3"></asp:ListItem>
                                            <asp:ListItem Text="Part Time - Onsite" Value="4"></asp:ListItem>
                                            <asp:ListItem Text="Full Time - Remote" Value="5"></asp:ListItem>
                                            <asp:ListItem Text="Full Time - Onsite" Value="6"></asp:ListItem>
                                            <asp:ListItem Text="Full Time Hourly" Value="7"></asp:ListItem>
                                            <asp:ListItem Text="Full Time Salary" Value="8"></asp:ListItem>
                                            <asp:ListItem Text="Part Time" Value="9"></asp:ListItem>
                                            <asp:ListItem Text="Sub" Value="10"></asp:ListItem>
                                        </asp:DropDownList><br />

                                        <span class='<%# (string.IsNullOrEmpty(Eval("Aggregate").ToString())) ? "hide" : (Convert.ToDouble(Eval("Aggregate")) > JG_Prospect.Common.JGApplicationInfo.GetAcceptiblePrecentage()) ? "greentext" : "redtext" %>'><%#(string.IsNullOrEmpty(Eval("Aggregate").ToString())) ? "N/A" : string.Format("{0:#,##}", Eval("Aggregate")) + "%" %></span>

                                        <a href='<%# "~/Employee/Resume/"+Eval("Resumepath") %>' id="aReasumePath" runat="server" target="_blank"><%# System.IO.Path.GetFileName(Eval("Resumepath").ToString()) %></a>

                                    </ItemTemplate>
                                </asp:TemplateField>
                                <asp:TemplateField HeaderStyle-HorizontalAlign="Center" ItemStyle-HorizontalAlign="Center" HeaderStyle-Width="27%"
                                    ItemStyle-Width="27%" ItemStyle-CssClass="noMargin pos-rel">
                                    <HeaderTemplate>
                                        Notes
                                        <table class="table gridtbl notes-table" cellspacing="0" cellpadding="0" rules="cols" border="1" style="width: 100%; border-collapse: collapse;">
                                            <tr class="trHeader " style="color: White;">
                                                <th>User ID<br />
                                                    Date&nbsp;&&nbsp;Time</th>
                                                <th>Note/Status</th>
                                            </tr>
                                        </table>
                                    </HeaderTemplate>
                                    <ItemTemplate>
                                        <div class="notes-section">
                                            <div class="notes-container" uid="<%#Eval("UserInstallId")%>" id="user-<%#Eval("Id")%>">
                                                Loading Notes...
                                            </div>
                                            <div class="notes-inputs">
                                                <div class="first-col">
                                                    <input type="button" class="GrdBtnAdd" value="Add Notes" onclick="addNotes(this, '<%# Eval("Id") %>','<%#Eval("UserInstallId")%>')" />
                                                </div>
                                                <div class="second-col">
                                                    <textarea class="note-text textbox" id="txt-<%# Eval("Id") %>"></textarea>
                                                </div>
                                            </div>
                                        </div>
                                    </ItemTemplate>
                                </asp:TemplateField>
                            </Columns>
                        </asp:GridView>
                    </ContentTemplate>
                    <Triggers>
                        <asp:AsyncPostBackTrigger ControlID="lbtnDeactivateSelected" EventName="Click" />
                        <asp:AsyncPostBackTrigger ControlID="lbtnDeleteSelected" EventName="Click" />
                        <asp:AsyncPostBackTrigger ControlID="lbtnChangeStatusForSelected" EventName="Click" />
                    </Triggers>
                </asp:UpdatePanel>
            </div>
            <asp:UpdatePanel ID="upnlBulkUpload" runat="server">
                <ContentTemplate>
                    <table style="width: 100%">
                        <tr style="width: 100%">
                            <td>
                                <asp:LinkButton ID="lnkDownload" Text="Download Sample Excel Format For Bulk Upload" CommandArgument='~/UserFile/SalesSample.xlsx' runat="server" OnClick="DownloadFile"></asp:LinkButton>
                                <%--<br />
                        <br />
                        <asp:LinkButton ID="lnkDownloadCSV" Text="Download Sample CSV Format For Bulk Upload" CommandArgument='../UserFile/SalesSample.csv' runat="server" OnClick="DownloadFile"></asp:LinkButton>--%>
                            </td>
                            <td>
                                <div style="float: left;">
                                    <div id="divBulkUploadFile" class="dropzone work-file" data-hidden="<%=hdnBulkUploadFile.ClientID%>"
                                        data-accepted-files=".csv,.xlsx" data-upload-path-code="1">
                                        <div class="fallback">
                                            <input name="WorkFile" type="file" />
                                            <input type="submit" value="UploadWorkFile" />
                                        </div>
                                    </div>
                                    <div id="divBulkUploadFilePreview" class="dropzone-previews work-file-previews">
                                    </div>
                                </div>
                                <div class="btn_sec" style="float: left;">
                                    <asp:Button ID="btnUploadNew" runat="server" Text="Upload" OnClick="btnUploadNew_Click" OnClientClick="showBulkUploadProgressPopup();" CssClass="ui-button" Style="padding: 0px 10px 0px 10px!important;" />
                                </div>
                                <div class="hide">
                                    <input id="hdnBulkUploadFile" runat="server" type="hidden" />
                                    <asp:Button ID="btnUpload" runat="server" Text="Upload" OnClientClick="return ValidateFile()" OnClick="btnUpload_Click" />

                                    <label>
                                        Upload Prospects using xlsx file:
                                <asp:FileUpload ID="BulkProspectUploader" runat="server" /></label>
                                    <asp:RequiredFieldValidator ID="RequiredFieldValidator3" ControlToValidate="BulkProspectUploader" runat="server" ErrorMessage="Select file to import data." ValidationGroup="BulkImport"></asp:RequiredFieldValidator>
                                </div>
                            </td>
                            <td align="right">
                                <asp:LinkButton ID="lbtnDeactivateSelected" runat="server" Text="Deactivate Selected"
                                    OnClientClick="return confirm('Are you sure you want to deactivate selected users?')"
                                    OnClick="lbtnDeactivateSelected_Click" />
                                <br />
                                <br />
                                <asp:LinkButton ID="lbtnDeleteSelected" runat="server" Text="Delete Selected"
                                    OnClientClick="return confirm('Are you sure you want to delete selected users?')"
                                    OnClick="lbtnDeleteSelected_Click" />
                                <br />
                                <br />
                                <%--<asp:LinkButton ID="lbtnChangeStatusForSelected" runat="server" Text="Change Status For Selected" OnClick="lbtnChangeStatusForSelected_Click" />--%>
                                <asp:LinkButton ID="lbtnChangeStatusForSelected" runat="server" Text="Change Status For Selected" OnClientClick="javascript:ChangeStatusForSelected();" />
                            </td>
                        </tr>
                    </table>
                </ContentTemplate>
                <Triggers>
                    <asp:AsyncPostBackTrigger ControlID="btnUploadNew" EventName="Click" />
                    <asp:PostBackTrigger ControlID="lnkDownload" />
                </Triggers>
            </asp:UpdatePanel>
            <br />
            <br />
            <div class="btn_sec">
                <asp:Button ID="btnExport" runat="server" Text="Export" OnClick="btnExport_Click" /><br />
                <br />
                <asp:Label ID="Label1" runat="server" />
            </div>
        </div>
    </div>
    <%--Modal Popup Stars--%>
    <div id="divModalPopups">
        <%--<asp:UpdatePanel ID="updatepanel1" runat="server">
                        <ContentTemplate>--%>
        <asp:Button ID="Button1" Style="display: none;" runat="server" Text="Button" />
        <cc1:ModalPopupExtender ID="mp1" runat="server" PopupControlID="Panel1" TargetControlID="Button1"
            CancelControlID="btnClose" BackgroundCssClass="modalBackground">
        </cc1:ModalPopupExtender>
        <asp:Panel ID="Panel1" runat="server" CssClass="modalPopup" align="center" Style="display: none">
            <asp:Image ID="img_InstallerImage" runat="server" Height="150px" Width="118px" />
            <br />
            <asp:Button ID="btnClose" runat="server" Text="Close" />
        </asp:Panel>

        <asp:Panel ID="panelPopup" runat="server">
            <div id="light" class="white_content">
                <h3>Reason
                </h3>
                <a href="javascript:void(0)" onclick="document.getElementById('light').style.display='none';document.getElementById('fade').style.display='none'">Close</a>
                <table width="100%" style="border: Solid 3px #b04547; width: 100%; height: 70%"
                    cellpadding="0" cellspacing="0">
                    <tr>
                        <td align="center" colspan="2" style="height: 15px;">
                            <asp:TextBox ID="txtReason" runat="server" placeholder="Enter Reason" TextMode="MultiLine"></asp:TextBox>
                            <asp:RequiredFieldValidator ID="reqReason" runat="server" ErrorMessage="Enter reason" ControlToValidate="txtReason" ValidationGroup="Reason"></asp:RequiredFieldValidator>
                        </td>
                    </tr>
                    <tr>
                        <td align="center">
                            <asp:Button ID="btnSaveReason" runat="server" BackColor="#327FB5" ForeColor="White" Height="32px"
                                Style="height: 26px; font-weight: 700; line-height: 1em;" Text="Save" Width="100px" ValidationGroup="Reason"
                                TabIndex="119" OnClick="btnSaveReason_Click" />
                            <%--<asp:Button ID="Button2" runat="server" OnClick="" />--%>
                        </td>
                    </tr>
                </table>
            </div>
        </asp:Panel>
        <div id="fade" class="black_overlay">
        </div>
        <ucStatusChange:PoPup ID="UcStatusPopUp" runat="server"></ucStatusChange:PoPup>
        <asp:Panel ID="panel2" runat="server">
            <div id="interviewDatelite" class="white_content" style="height: auto;">
                <h3>Interview Details
                </h3>
                <%--<a href="javascript:void(0)" onclick="">Close</a>--%>
                <asp:UpdatePanel runat="server" UpdateMode="Always">
                    <ContentTemplate>
                        <table width="100%" style="border: Solid 3px #b04547; width: 100%; height: 300px;"
                            cellpadding="0" cellspacing="0">
                            <tr>
                                <td colspan="3" align="center">Name:
                                    <asp:Label ID="lblName_InterviewDetails" runat="server" /></td>
                            </tr>
                            <tr>
                                <td align="center" style="height: 15px;">Date :
                        <asp:TextBox ID="dtInterviewDate" placeholder="Select Date" runat="server" ClientIDMode="Static" onkeypress="return false" TabIndex="104" Width="127px"></asp:TextBox>
                                    <cc1:CalendarExtender ID="CalendarExtender1" TargetControlID="dtInterviewDate" Format="MM/dd/yyyy" runat="server"></cc1:CalendarExtender>
                                    <asp:RequiredFieldValidator ID="RequiredFieldValidator1" runat="server" ErrorMessage="Select Date" ControlToValidate="dtInterviewDate" ValidationGroup="InterviewDate"></asp:RequiredFieldValidator>
                                </td>
                                <td align="center"></td>
                                <td>Time :
                            <asp:DropDownList ID="ddlInsteviewtime" runat="server" TabIndex="105" Width="112px"></asp:DropDownList>
                                </td>
                            </tr>
                            <tr>
                                <td align="right">Recruiter</td>
                                <td>: </td>
                                <td align="left">
                                    <asp:DropDownList ID="ddlUsers" runat="server" />
                                    <asp:RequiredFieldValidator ID="rfvddlUsers" runat="server" ErrorMessage="Select Recruiter" ControlToValidate="ddlUsers"
                                        ValidationGroup="InterviewDate" InitialValue="0" />
                                </td>
                            </tr>
                            <tr>
                                <td align="right">Designation</td>
                                <td>: </td>
                                <td align="left">
                                    <asp:DropDownList ID="ddlDesignationForTask" runat="server" Width="140px" EnableViewState="true" AutoPostBack="true" OnSelectedIndexChanged="ddlDesignationForTask_SelectedIndexChanged"></asp:DropDownList>
                                </td>
                            </tr>
                            <tr>
                                <td align="right">Task</td>
                                <td>: </td>
                                <td align="left">
                                    <asp:DropDownList ID="ddlTechTask" runat="server" AutoPostBack="true" OnSelectedIndexChanged="ddlTechTask_SelectedIndexChanged" />
                                    <asp:RequiredFieldValidator ID="rfvTechTask" runat="server" ControlToValidate="ddlTechTask" ErrorMessage="Select Tech Task"
                                        InitialValue="0" ValidationGroup="InterviewDate" />
                                </td>
                            </tr>
                            <tr>
                                <td align="right">Sub Task</td>
                                <td>: </td>
                                <td align="left">
                                    <asp:DropDownList ID="ddlTechSubTask" runat="server" />
                                    <asp:RequiredFieldValidator ID="rfvTechSubTask" runat="server" ControlToValidate="ddlTechSubTask" ErrorMessage="Select Sub Task"
                                        InitialValue="0" ValidationGroup="InterviewDate" />
                                </td>
                            </tr>
                            <tr>
                                <td align="center" colspan="3">
                                    <asp:Button ID="btnSaveInterview" runat="server" BackColor="#327FB5" ForeColor="White" Height="32px"
                                        Style="height: 26px; font-weight: 700; line-height: 1em;" Text="OK" Width="100px" ValidationGroup="InterviewDate"
                                        TabIndex="119" OnClick="btnSaveInterview_Click" />
                                    <asp:Button ID="btnCancelInterview" runat="server" Text="Cancel" OnClick="btnCancelInterview_Click" Width="100px"
                                        Style="height: 26px; font-weight: 700; line-height: 1em;"
                                        OnClientClick="javascript:document.getElementById('interviewDatelite').style.display='none';document.getElementById('interviewDatefade').style.display='none'" />
                                </td>
                            </tr>
                        </table>
                    </ContentTemplate>
                </asp:UpdatePanel>
            </div>
        </asp:Panel>

        <asp:Panel ID="panel3" runat="server">
            <div id="litePassword" class="white_content">
                <h3>Password
                </h3>
                <a href="javascript:void(0)" onclick="document.getElementById('litePassword').style.display='none';document.getElementById('fadePassword').style.display='none'">Close</a>
                <table width="100%" style="border: Solid 3px #b04547; width: 100%; height: 70%"
                    cellpadding="0" cellspacing="0">
                    <tr>
                        <td align="center" style="height: 54px; width: 200px;">Enter Password To Change Status
                        </td>
                        <td align="center" style="height: 54px;">
                            <asp:TextBox ID="txtPassword" runat="server" placeholder="Enter Password" TextMode="Password"></asp:TextBox>
                            <asp:RequiredFieldValidator ID="RequiredFieldValidator2" runat="server" ErrorMessage="Enter Password" ControlToValidate="txtPassword" ValidationGroup="Password"></asp:RequiredFieldValidator>
                        </td>
                    </tr>
                    <tr>
                        <td align="center" colspan="2" style="height: 54px;">
                            <asp:Button ID="btnChangeStatus" runat="server" BackColor="#327FB5" ForeColor="White" Height="32px"
                                Style="height: 26px; font-weight: 700; line-height: 1em;" Text="Save" Width="100px" ValidationGroup="Password"
                                TabIndex="119" OnClick="btnChangeStatus_Click" />
                            <%--<asp:Button ID="Button2" runat="server" OnClick="" />--%>
                        </td>
                    </tr>
                </table>
            </div>
        </asp:Panel>
        <div id="fadePassword" class="black_overlay">
        </div>

        <asp:Panel ID="panel4" runat="server">
            <div id="DivOfferMade" class="white_content" style="height: auto;">
                <h3>Offer Made Details</h3>
                <asp:UpdatePanel runat="server" UpdateMode="Always">
                    <ContentTemplate>
                        <asp:HiddenField ID="hdnFirstName" runat="server" />
                        <asp:HiddenField ID="hdnLastName" runat="server" />
                        <table width="100%" style="border: Solid 3px #b04547; width: 100%; height: 300px;"
                            cellpadding="0" cellspacing="0">
                            <tr>
                                <td align="right"><strong>Name: </strong></td>
                                <td align="left">
                                    <asp:Label ID="lblName_OfferMade" runat="server" />
                                </td>
                            </tr>

                            <tr align="right">
                                <td><strong>Designation:
                                    
                                </strong></td>
                                <td align="left">
                                    <asp:Label ID="lblDesignation_OfferMade" runat="server" />
                                </td>
                            </tr>
                            <tr>
                                <td align="right" style="height: 15px;">
                                    <br />
                                    <label>
                                        Branch Location<span><asp:Label ID="Label6" Text="*" runat="server" ForeColor="Red"></asp:Label></span></label>
                                </td>
                                <td>
                                    <asp:DropDownList CssClass="branchLocationId" ID="ddlBranchLocation" runat="server"></asp:DropDownList>
                                    <br />
                                </td>
                            </tr>
                            <tr>
                                <td align="right" style="height: 15px;">
                                    <br />
                                    <label>
                                        Email<span><asp:Label ID="lblReqEmail" Text="*" runat="server" ForeColor="Red"></asp:Label></span></label>
                                </td>
                                <td>
                                    <asp:TextBox ID="txtEmail" runat="server" MaxLength="40" Width="242px"
                                        Enabled="false" ReadOnly="true"></asp:TextBox>
                                    <br />
                                    <asp:RequiredFieldValidator ID="rqEmail" Display="Dynamic" runat="server" ControlToValidate="txtEmail"
                                        ValidationGroup="OfferMade" ForeColor="Red" ErrorMessage="Please Enter Email"></asp:RequiredFieldValidator>
                                    <asp:RegularExpressionValidator ID="reEmail" ControlToValidate="txtEmail" ValidationExpression="\w+([-+.']\w+)*@\w+([-.]\w+)*\.\w+([-.]\w+)*"
                                        Display="Dynamic" runat="server" ForeColor="Red" ErrorMessage="Please Enter a valid Email"
                                        ValidationGroup="OfferMade">
                                    </asp:RegularExpressionValidator>
                                </td>
                            </tr>
                            <tr>
                                <td align="right" style="height: 15px;">
                                    <label>
                                        Password<asp:Label ID="lblPassReq" runat="server" Text="*" ForeColor="Red"></asp:Label></label>
                                </td>
                                <td>
                                    <asp:TextBox ID="txtPassword1" runat="server" TextMode="Password" MaxLength="30"
                                        autocomplete="off" Width="242px"></asp:TextBox>
                                    <br />
                                    <label>
                                    </label>
                                    <asp:RequiredFieldValidator ID="rqPass" runat="server" ControlToValidate="txtPassword1"
                                        ValidationGroup="OfferMade" ForeColor="Red" Display="Dynamic" ErrorMessage="Please Enter Password"></asp:RequiredFieldValidator><br />
                                </td>
                            </tr>
                            <tr>
                                <td align="right" style="height: 15px;">
                                    <label>
                                        Confirm Password<asp:Label ID="lblConfirmPass" runat="server" Text="*" ForeColor="Red"></asp:Label></label>
                                </td>
                                <td>
                                    <asp:TextBox ID="txtpassword2" runat="server" TextMode="Password" autocomplete="off"
                                        MaxLength="30" EnableViewState="false" AutoCompleteType="None" Width="242px"></asp:TextBox>
                                    <br />
                                    <label>
                                    </label>
                                    <asp:CompareValidator ID="password" runat="server" ControlToValidate="txtpassword2"
                                        Display="Dynamic" ControlToCompare="txtPassword1" ForeColor="Red" ErrorMessage="Password didn't matched"
                                        ValidationGroup="OfferMade">
                                    </asp:CompareValidator>
                                    <asp:RequiredFieldValidator ID="rqConPass" runat="server" ControlToValidate="txtpassword2"
                                        ForeColor="Red" ValidationGroup="OfferMade" ErrorMessage="Enter Confirm Password"></asp:RequiredFieldValidator>

                                </td>
                            </tr>
                            <tr>
                                <td align="center" colspan="2">
                                    <asp:Button ID="btnSaveOfferMade" runat="server" BackColor="#327FB5" ForeColor="White" Height="32px"
                                        Style="height: 26px; font-weight: 700; line-height: 1em;" Text="Save" Width="100px" ValidationGroup="OfferMade"
                                        TabIndex="119" />
                                    <asp:Button ID="btnCancelOfferMade" runat="server" Text="Cancel" Width="100px" Style="height: 26px; font-weight: 700; line-height: 1em;" />
                                </td>
                            </tr>
                        </table>
                    </ContentTemplate>
                </asp:UpdatePanel>
            </div>
        </asp:Panel>
        <div id="DivOfferMadefade" class="black_overlay">
        </div>

        <asp:Panel ID="pnlUploadBulk" runat="server">

            <div id="lightUploadBulk" class="white_content" style="text-align: center">
                <a class="close" href="#" onclick="CloseAddUserPopUp()">&times;</a>

                <asp:Panel ID="pnlDuplicate" runat="server">
                    <asp:Label ID="lblDuplicateCount" runat="server"></asp:Label>

                    <div style="padding: 20px; margin: auto;">
                        <center>
                                <table width="60%" class="uploadBulkTab" cellpadding="0">
                                <tr style="background-color: #A33E3F; color: white; font-weight: bold; text-align: center; width: 100%;">
                                    <td><span>Full Name</span></td>
                                    <td><span>Email</span></td>
                                    <td><span>Phone</span></td>
                                    <td><span>status</span></td>
                                </tr>
                                <asp:ListView ID="listDuplicateUsers" runat="server">
                                    <ItemTemplate>
                                        <tr>
                                            <td><span><%#Eval("FirstName")%>&nbsp;<%#Eval("LastName")%></span></td>
                                            <td><span><%#Eval("Email")%></span></td>
                                            <td><span><%#Eval("phone")%></span></td>
                                            <td><span><%#Eval("status")%></span></td>
                                        </tr>
                                    </ItemTemplate>
                                </asp:ListView>
                            </table>
                            </center>
                    </div>
                    <div style="padding: 20px; margin: auto;">
                        Email or Phone number of above users already exists, do you want to update the existing record?
                    </div>
                    <div style="padding: 10px; margin: auto;">
                        <asp:Button ID="btnYesEdit" runat="server" BackColor="#bb0000" ForeColor="White" Height="32px"
                            Style="height: 26px; font-weight: 700; line-height: 1em;" Text="Yes" Width="100px"
                            ValidationGroup="IndiCred" TabIndex="119" OnClick="btnYesEdit_Click" />
                        &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
                        <asp:Button ID="btnNoEdit" runat="server" BackColor="#bb0000" ForeColor="White" Height="32px"
                            Style="height: 26px; font-weight: 700; line-height: 1em;" Text="No" Width="100px"
                            ValidationGroup="IndiCred" TabIndex="119" OnClick="btnNoEdit_Click" />
                    </div>

                    <hr />
                    <br />
                </asp:Panel>

                <asp:Panel ID="pnlAddNewUser" runat="server">
                    <asp:Label ID="lblNewRecordAddedCount" runat="server"></asp:Label>
                    <center>
                    <table width="60%" class="uploadBulkTab" cellpadding="0" style="margin-top:20px;">
                        <tr style="background-color: #A33E3F; color: white; font-weight: bold; text-align: center; width: 100%;">
                            <td><span>Full Name</span></td>
                            <td><span>Email</span></td>
                            <td><span>Phone</span></td>
                            <td><span>status</span></td>
                        </tr>
                        <asp:ListView ID="lstNewUserAdd" runat="server">
                            <ItemTemplate>
                                <tr>
                                    <td><span><%#Eval("FirstName")%>&nbsp;<%#Eval("LastName")%></span></td>
                                    <td><span><%#Eval("Email")%></span></td>
                                    <td><span><%#Eval("phone")%></span></td>
                                    <td><span><%#Eval("status")%></span></td>
                                </tr>
                            </ItemTemplate>
                        </asp:ListView>
                    </table>
                    </center>
                </asp:Panel>

            </div>
        </asp:Panel>
        <div id="fadeUploadBulk" class="black_overlay">
        </div>
        <div id="interviewDatefade" class="black_overlay">
        </div>
    </div>
    <%--Modal Popup Ends--%>
    <%--Popup Stars--%>
    <div id="bulkUpload" class="modal hide">
        <asp:UpdatePanel ID="upnlBulkUploadStatus" runat="server" UpdateMode="Conditional">
            <ContentTemplate>
                <div id="divBulkUploadStatistics" runat="server" title="Information" data-width="900px">

                    <div>
                        <h2>Incomplete users: <small>Total:
                            <asp:Literal ID="ltlTotalInvalidUser" runat="server"></asp:Literal></small></h2>
                        <table class="table" cellspacing="0" cellpadding="0" rules="cols" border="1" style="width: 100%; border-collapse: collapse;">

                            <asp:Repeater ID="rptIncorrectRecords" runat="server">
                                <HeaderTemplate>
                                    <thead>
                                        <tr class="trHeader ">
                                            <th scope="col" style="width: 75px;">FirstName*</th>
                                            <th scope="col" style="width: 75px;">LastName*</th>
                                            <th scope="col" style="width: 90px;">Email*</th>
                                            <th scope="col" style="width: 75px;">Designation*</th>
                                            <th scope="col" style="width: 50px;">Status*</th>
                                            <th scope="col" style="width: 60px;">Source*</th>
                                            <th scope="col" style="width: 90px;">Primary Contact Phone*</th>
                                            <th scope="col" style="width: 60px;">Phone Type*</th>
                                            <th scope="col" style="width: 50px;">Zip*</th>
                                        </tr>
                                    </thead>
                                    <tbody>
                                </HeaderTemplate>
                                <ItemTemplate>
                                    <tr class="<%# Container.ItemIndex % 2 == 0 ? "FirstRow" : "AlternateRow" %>" style="border-style: Solid;">
                                        <td style="width: 10%;"><%#Eval("FirstName") %>
                                        </td>
                                        <td style="width: 10%;"><%#Eval("LastName") %>
                                        </td>
                                        <td style="width: 15%;"><%#Eval("Email") %>
                                        </td>
                                        <td style="width: 10%;"><%#Eval("Designation") %>
                                        </td>
                                        <td style="width: 10%;"><%#Eval("Status") %>
                                        </td>
                                        <td style="width: 10%;"><%#Eval("Source") %></td>
                                        <td style="width: 15%;"><%#Eval("Phone1") %>
                                        </td>
                                        <td style="width: 10%;"><%#Eval("Phone1Type") %></td>
                                        <td style="width: 5%;"><%#Eval("Zip") %></td>
                                    </tr>
                                </ItemTemplate>
                                <FooterTemplate>
                                    </tbody>
                                </FooterTemplate>
                            </asp:Repeater>

                        </table>

                    </div>

                    <div style="margin-top: 10px;">
                        <h2>Duplicate users: <small>Total:
                            <asp:Literal ID="ltlTotalDuplicateUsers" runat="server"></asp:Literal></small></h2>
                        <div>
                            <table class="table" cellspacing="0" cellpadding="0" rules="cols" border="1" style="width: 100%; border-collapse: collapse;">
                                <asp:Repeater ID="rptDuplicateRecords" runat="server">
                                    <HeaderTemplate>
                                        <thead>
                                            <tr class="trHeader ">
                                                <th scope="col" style="width: 75px;">FirstName*</th>
                                                <th scope="col" style="width: 75px;">LastName*</th>
                                                <th scope="col" style="width: 90px;">Email*</th>
                                                <th scope="col" style="width: 75px;">Designation*</th>
                                                <th scope="col" style="width: 50px;">Status*</th>
                                                <th scope="col" style="width: 60px;">Source*</th>
                                                <th scope="col" style="width: 90px;">Primary Contact Phone*</th>
                                                <th scope="col" style="width: 60px;">Phone Type*</th>
                                                <th scope="col" style="width: 50px;">Zip*</th>
                                            </tr>
                                        </thead>
                                        <tbody>
                                    </HeaderTemplate>
                                    <ItemTemplate>
                                        <tr class="<%# Container.ItemIndex % 2 == 0 ? "FirstRow" : "AlternateRow" %>" style="border-style: Solid;">
                                            <td style="width: 10%;"><%#Eval("FirstName") %>
                                            </td>
                                            <td style="width: 10%;"><%#Eval("LastName") %>
                                            </td>
                                            <td style="width: 15%;"><%#Eval("Email") %>
                                            </td>
                                            <td style="width: 10%;"><%#Eval("Designation") %>
                                            </td>
                                            <td style="width: 10%;"><%#Eval("Status") %>
                                            </td>
                                            <td style="width: 10%;"><%#Eval("Source") %></td>
                                            <td style="width: 15%;"><%#Eval("phone") %>
                                            </td>
                                            <td style="width: 10%;"><%#Eval("phonetype") %></td>
                                            <td style="width: 5%;"><%#Eval("Zip") %></td>
                                        </tr>
                                    </ItemTemplate>
                                    <FooterTemplate>
                                        </tbody>
                                    </FooterTemplate>
                                </asp:Repeater>
                            </table>
                        </div>
                    </div>

                    <div style="margin-top: 10px;">
                        <h2>Users to be Added: <small>Total:
                            <asp:Literal ID="ltlTotalUserstobeAdded" runat="server"></asp:Literal></small></h2>
                        <div>
                            <table class="table" cellspacing="0" cellpadding="0" rules="cols" border="1" style="width: 100%; border-collapse: collapse;">
                                <asp:Repeater ID="rptUserstoBeAdded" runat="server">
                                    <HeaderTemplate>
                                        <thead>
                                            <tr class="trHeader ">
                                                <th scope="col" style="width: 75px;">FirstName*</th>
                                                <th scope="col" style="width: 75px;">LastName*</th>
                                                <th scope="col" style="width: 90px;">Email*</th>
                                                <th scope="col" style="width: 75px;">Designation*</th>
                                                <th scope="col" style="width: 50px;">Status*</th>
                                                <th scope="col" style="width: 60px;">Source*</th>
                                                <th scope="col" style="width: 90px;">Primary Contact Phone*</th>
                                                <th scope="col" style="width: 60px;">Phone Type*</th>
                                                <th scope="col" style="width: 50px;">Zip*</th>
                                            </tr>
                                        </thead>
                                        <tbody>
                                    </HeaderTemplate>
                                    <ItemTemplate>
                                        <tr class="<%# Container.ItemIndex % 2 == 0 ? "FirstRow" : "AlternateRow" %>" style="border-style: Solid;">
                                            <td style="width: 10%;"><%#Eval("FirstName") %>
                                            </td>
                                            <td style="width: 10%;"><%#Eval("LastName") %>
                                            </td>
                                            <td style="width: 15%;"><%#Eval("Email") %>
                                            </td>
                                            <td style="width: 10%;"><%#Eval("Designation") %>
                                            </td>
                                            <td style="width: 10%;"><%#Eval("Status") %>
                                            </td>
                                            <td style="width: 10%;"><%#Eval("Source") %></td>
                                            <td style="width: 15%;"><%#Eval("Phone1") %>
                                            </td>
                                            <td style="width: 10%;"><%#Eval("Phone1Type") %></td>
                                            <td style="width: 5%;"><%#Eval("Zip") %></td>
                                        </tr>
                                    </ItemTemplate>
                                    <FooterTemplate>
                                        </tbody>
                                    </FooterTemplate>
                                </asp:Repeater>
                            </table>
                        </div>
                    </div>

                    <div style="margin-top: 10px;">
                        <h2>Successfully entered users: <small>Total:
                            <asp:Literal ID="ltlTotalSuccessfulUsersInserted" runat="server"></asp:Literal></small></h2>
                        <div>
                            <table class="table" cellspacing="0" cellpadding="0" rules="cols" border="1" style="width: 100%; border-collapse: collapse;">
                                <asp:Repeater ID="rptSuccessFullyEntered" runat="server">
                                    <HeaderTemplate>
                                        <thead>
                                            <tr class="trHeader ">
                                                <th scope="col" style="width: 75px;">FirstName*</th>
                                                <th scope="col" style="width: 75px;">LastName*</th>
                                                <th scope="col" style="width: 90px;">Email*</th>
                                                <th scope="col" style="width: 75px;">Designation*</th>
                                                <th scope="col" style="width: 50px;">Status*</th>
                                                <th scope="col" style="width: 60px;">Source*</th>
                                                <th scope="col" style="width: 90px;">Primary Contact Phone*</th>
                                                <th scope="col" style="width: 60px;">Phone Type*</th>
                                                <th scope="col" style="width: 50px;">Zip*</th>
                                            </tr>
                                        </thead>
                                        <tbody>
                                    </HeaderTemplate>
                                    <ItemTemplate>
                                        <tr class="<%# Container.ItemIndex % 2 == 0 ? "FirstRow" : "AlternateRow" %>" style="border-style: Solid;">
                                            <td style="width: 10%;"><%#Eval("FirstName") %>
                                            </td>
                                            <td style="width: 10%;"><%#Eval("LastName") %>
                                            </td>
                                            <td style="width: 15%;"><%#Eval("Email") %>
                                            </td>
                                            <td style="width: 10%;"><%#Eval("Designation") %>
                                            </td>
                                            <td style="width: 10%;"><%#Eval("Status") %>
                                            </td>
                                            <td style="width: 10%;"><%#Eval("Source") %></td>
                                            <td style="width: 15%;"><%#Eval("Phone1") %>
                                            </td>
                                            <td style="width: 10%;"><%#Eval("Phone1Type") %></td>
                                            <td style="width: 5%;"><%#Eval("Zip") %></td>
                                        </tr>
                                    </ItemTemplate>
                                    <FooterTemplate>
                                        </tbody>
                                    </FooterTemplate>
                                </asp:Repeater>
                            </table>
                        </div>
                    </div>

                </div>


            </ContentTemplate>
            <Triggers>
                <asp:AsyncPostBackTrigger ControlID="btnUploadNew" EventName="Click" />
            </Triggers>
        </asp:UpdatePanel>
    </div>
    <div class="hide">
        <div id="divBulkUploadUserErrors" runat="server" title="Information" data-width="900px">
            <div style="padding: 5px 10px;">
                Below records contain empty values for mandatory fields. Please update cells marked by <span style="color: blue; font-weight: bold; text-align: center; font-size: 20px;">x</span> below in your file and upload again. If you see several empty rows at the end of the records, please delete those empty lines from your file.
            </div>
            <div style="max-height: 500px; height: 500px; overflow: auto;">
                <asp:UpdatePanel ID="upnlBUPError" runat="server" UpdateMode="Conditional">
                    <ContentTemplate>
                        <asp:GridView ID="grdBulkUploadUserErrors" runat="server" AutoGenerateColumns="false"
                            CssClass="table" Width="100%" CellSpacing="0" CellPadding="0" GridLines="Vertical">
                            <EmptyDataRowStyle ForeColor="White" HorizontalAlign="Center" />
                            <HeaderStyle CssClass="trHeader " />
                            <RowStyle CssClass="FirstRow" BorderStyle="Solid" />
                            <AlternatingRowStyle CssClass="AlternateRow " />
                            <Columns>
                                <asp:TemplateField HeaderText="FirstName*" HeaderStyle-Width="75" ItemStyle-Width="75">
                                    <ItemTemplate>
                                        <%#Eval("FirstName")%>
                                    </ItemTemplate>
                                </asp:TemplateField>
                                <asp:TemplateField HeaderText="FirstName*" HeaderStyle-Width="75" ItemStyle-Width="75">
                                    <ItemTemplate>
                                        <%#Eval("LastName")%>
                                    </ItemTemplate>
                                </asp:TemplateField>
                                <asp:TemplateField HeaderText="Email*" HeaderStyle-Width="90" ItemStyle-Width="90">
                                    <ItemTemplate>
                                        <%#Eval("Email")%>
                                    </ItemTemplate>
                                </asp:TemplateField>
                                <asp:TemplateField HeaderText="Designation*" HeaderStyle-Width="75" ItemStyle-Width="75">
                                    <ItemTemplate>
                                        <%#Eval("Designation")%>
                                    </ItemTemplate>
                                </asp:TemplateField>
                                <asp:TemplateField HeaderText="Status*" HeaderStyle-Width="50" ItemStyle-Width="50">
                                    <ItemTemplate>
                                        <%#Eval("Status")%>
                                    </ItemTemplate>
                                </asp:TemplateField>
                                <asp:TemplateField HeaderText="Source*" HeaderStyle-Width="60" ItemStyle-Width="60">
                                    <ItemTemplate>
                                        <%#Eval("Source")%>
                                    </ItemTemplate>
                                </asp:TemplateField>
                                <asp:TemplateField HeaderText="Primary Contact Phone*" HeaderStyle-Width="90" ItemStyle-Width="90">
                                    <ItemTemplate>
                                        <%#Eval("Phone1")%>
                                    </ItemTemplate>
                                </asp:TemplateField>
                                <asp:TemplateField HeaderText="Phone Type*" HeaderStyle-Width="60" ItemStyle-Width="60">
                                    <ItemTemplate>
                                        <%#Eval("Phone1Type")%>
                                    </ItemTemplate>
                                </asp:TemplateField>
                                <asp:TemplateField HeaderText="Zip*" HeaderStyle-Width="50" ItemStyle-Width="50">
                                    <ItemTemplate>
                                        <%#Eval("Zip")%>
                                    </ItemTemplate>
                                </asp:TemplateField>
                            </Columns>
                        </asp:GridView>
                    </ContentTemplate>
                </asp:UpdatePanel>
            </div>
            <br />
        </div>
        <%--Send Email To User Popup--%>
        <div id="divSendEmailToUser" runat="server" title="Send Email">
            <asp:UpdatePanel ID="upSendEmailToUser" runat="server" UpdateMode="Conditional">
                <ContentTemplate>
                    <asp:ValidationSummary ID="vsEmailToUser" runat="server" ValidationGroup="vgEmailToUser" ShowSummary="False" ShowMessageBox="True" />
                    <fieldset>
                        <legend>
                            <asp:Label ID="lblEmailTo" runat="server" /><asp:HiddenField ID="hdnEmailTo" runat="server" />
                        </legend>
                        <table cellspacing="3" cellpadding="3" width="100%">
                            <tr>
                                <td>Subject:<br />
                                    <asp:TextBox ID="txtEmailSubject" runat="server" CssClass="textbox" Width="90%" ReadOnly="true" />
                                    <asp:RequiredFieldValidator ID="rfvEmailSubject" ValidationGroup="vgEmailToUser"
                                        runat="server" ControlToValidate="txtEmailSubject" ForeColor="Red" ErrorMessage="Please enter email subject." Display="None" />
                                </td>
                            </tr>
                            <tr>
                                <td>Custom Message:<br />
                                    <asp:TextBox ID="txtEmailCustomMessage" runat="server" CssClass="textbox" TextMode="MultiLine" Width="90%" />
                                    <asp:RequiredFieldValidator ID="rfvEmailCustomMessage" ValidationGroup="vgEmailToUser" Display="None"
                                        runat="server" ControlToValidate="txtEmailCustomMessage" ForeColor="Red" ErrorMessage="Please enter custom message for email." />
                                </td>
                            </tr>
                            <tr>
                                <td>Email Body:<br />
                                    <asp:TextBox ID="txtEmailBody" runat="server" CssClass="textbox" TextMode="MultiLine" Rows="4" Width="90%" />
                                    <asp:RequiredFieldValidator ID="rfvEmailBody" ValidationGroup="vgEmailToUser"
                                        runat="server" ControlToValidate="txtEmailBody" ForeColor="Red" ErrorMessage="Please enter email body." Display="None" />
                                </td>
                            </tr>
                            <tr>
                                <td>
                                    <div class="btn_sec">
                                        <asp:Button ID="btnSendEmailToUser" runat="server" ValidationGroup="vgEmailToUser" OnClick="btnSendEmailToUser_Click"
                                            CssClass="ui-button" Text="Send" />
                                        <asp:Button ID="btnCancelSendEmailToUser" runat="server" OnClick="btnCancelSendEmailToUser_Click"
                                            Text="Cancel" />
                                    </div>
                                </td>
                            </tr>
                        </table>
                    </fieldset>
                </ContentTemplate>
            </asp:UpdatePanel>
        </div>

        <div id="divChangeStatusForSelected" runat="server" title="Change Status">
            <asp:UpdatePanel ID="upChangeStatusForSelected" runat="server" UpdateMode="Conditional">
                <ContentTemplate>
                    <asp:ValidationSummary ID="vsChangeStatus" runat="server" ValidationGroup="vgChangeStatus" ShowMessageBox="true" ShowSummary="false" />
                    <div>
                        Status:
                        <asp:DropDownList ID="ddlStatus_Popup" Width="400px" runat="server" AutoPostBack="true" OnPreRender="ddlStatus_Popup_PreRender" OnSelectedIndexChanged="ddlStatus_Popup_SelectedIndexChanged" />
                        <asp:RequiredFieldValidator ID="rfvStatus_Popup" runat="server" ErrorMessage="Please select recruiter." InitialValue="0"
                            ControlToValidate="ddlStatus_Popup" ValidationGroup="vgChangeStatus" Display="None" />
                    </div>
                    <br />
                    <div id="divInterviewDate" runat="server" visible="false">
                        Recruiter:
                        <asp:DropDownList ID="ddlRecruiter_Popup" runat="server" />
                        <asp:RequiredFieldValidator ID="rfvRecruiter_Popup" runat="server" ErrorMessage="Please select recruiter." InitialValue="0"
                            ControlToValidate="ddlRecruiter_Popup" ValidationGroup="vgChangeStatus" Display="None" />
                    </div>
                    <br />
                    <asp:GridView ID="grdUsers_Popup" runat="server" AutoGenerateColumns="false" DataKeyNames="Id,DesignationID"
                        CssClass="table" Width="100%" CellSpacing="0" CellPadding="0" GridLines="Vertical"
                        OnRowDataBound="grdUsers_Popup_RowDataBound">
                        <EmptyDataRowStyle ForeColor="White" HorizontalAlign="Center" />
                        <HeaderStyle CssClass="trHeader " />
                        <RowStyle CssClass="FirstRow" BorderStyle="Solid" />
                        <AlternatingRowStyle CssClass="AlternateRow " />
                        <Columns>
                            <asp:TemplateField HeaderText="Name" ItemStyle-Width="150">
                                <ItemTemplate>
                                    <asp:Literal ID="ltrlFirstName" runat="server" Text='<%#Eval("FirstName") %>' />&nbsp;<asp:Literal ID="ltrlLastName" runat="server" Text='<%#Eval("LastName") %>' />
                                </ItemTemplate>
                            </asp:TemplateField>
                            <asp:TemplateField HeaderText="Designation" ItemStyle-Width="150">
                                <ItemTemplate>
                                    <asp:Literal ID="ltrlDesignation" runat="server" Text='<%#Eval("Designation") %>' />
                                </ItemTemplate>
                            </asp:TemplateField>
                            <asp:TemplateField HeaderText="Interview" Visible="false">
                                <ItemTemplate>
                                    <asp:TextBox ID="txtInterviewDate" placeholder="Select Date" runat="server"
                                        onkeypress="return false" Width="127px" Text='<%#Eval("InterviewDate")%>' />
                                    <cc1:CalendarExtender ID="ceInterviewDate" TargetControlID="txtInterviewDate" Format="MM/dd/yyyy" runat="server" />
                                    <asp:RequiredFieldValidator ID="rfvInterviewDate" runat="server" ErrorMessage="Please select interview date."
                                        ControlToValidate="txtInterviewDate" ValidationGroup="vgChangeStatus" Display="None" />
                                    <br />
                                    <asp:DropDownList ID="ddlInterviewTime" runat="server" Width="112px" />
                                </ItemTemplate>
                            </asp:TemplateField>
                            <asp:TemplateField HeaderText="Tech Task" Visible="false" ItemStyle-Width="100">
                                <ItemTemplate>
                                    Tech Task:
                                    <asp:DropDownList ID="ddlTechTask" runat="server" Width="95" AutoPostBack="true" OnSelectedIndexChanged="grdUsers_Popup_ddlTechTask_SelectedIndexChanged" />
                                    <asp:RequiredFieldValidator ID="rfvTechTask" runat="server" ErrorMessage="Please select tech task." InitialValue="0"
                                        ControlToValidate="ddlTechTask" ValidationGroup="vgChangeStatus" Display="None" />
                                    <br />
                                    Sub Task:
                                    <asp:DropDownList ID="ddlTechSubTask" runat="server" Width="95" />
                                    <asp:RequiredFieldValidator ID="rfvTechSubTask" runat="server" ErrorMessage="Please select tech sub task." InitialValue="0"
                                        ControlToValidate="ddlTechSubTask" ValidationGroup="vgChangeStatus" Display="None" />
                                </ItemTemplate>
                            </asp:TemplateField>
                            <asp:TemplateField HeaderText="Reason" Visible="false">
                                <ItemTemplate>
                                    <asp:TextBox ID="txtReason" runat="server" TextMode="MultiLine" Rows="3" Width="95%" />
                                    <asp:RequiredFieldValidator ID="rfvReason" runat="server" ErrorMessage="Please enter reason for status change."
                                        ControlToValidate="txtReason" ValidationGroup="vgChangeStatus" Display="None" />
                                </ItemTemplate>
                            </asp:TemplateField>
                        </Columns>
                    </asp:GridView>
                    <br />
                    <br />
                    <div class="btn_sec">
                        <asp:Button ID="btnSaveStatusForSelected" runat="server" Text="Change Status" ValidationGroup="vgChangeStatus"
                            OnClick="btnSaveStatusForSelected_Click" />&nbsp;
                    <asp:Button ID="btnCancelChangeStatusForSelected" runat="server" Text="Cancel" OnClick="btnCancelChangeStatusForSelected_Click" />
                        <br />
                        <br />
                    </div>
                </ContentTemplate>
            </asp:UpdatePanel>
        </div>
    </div>
    <div id="divEditUserNG" data-ng-controller="EditUserController">

        <div id="EditUsersModal" class="modal hide">

            <table class="scroll" cellspacing="0" rules="all" border="1" id="tblEditUserPopup" style="width: 100%; border-collapse: collapse;">
                <thead>
                    <tr>
                        <th style="width: 10%; text-align: center;">Action
                            <br>
                            Picture</th>
                        <th style="width: 16%; text-align: center;"><a href="javascript:void(0);">Staff ID#
                            <br>
                            Designation<br>
                            F&amp;LName
                          
                        </a></th>
                        <th style="width: 16%; text-align: center;">
                            <a href="javascript:void(0);">Interview Status
                            <br>
                                Interview Date&Time
                                <br>
                                TaskID# - Sub ID#
                            </a>
                        </th>
                        <th style="width: 10%; text-align: center;"><a href="javascript:void(0);">Source<br>
                            Added By<br>
                            Added On</a></th>
                        <th style="width: 10%; text-align: center;"><a href="javascript:void(0);">Country-Zip-City<br>
                            Type-Apptitude Test %<br>
                            Resume Attachment</a></th>
                        <th style="width: 17%; text-align: left;"><a href="javascript:void(0);">Email<br>
                            Phone Type - Phone</a></th>
                        <th style="width: 17%; text-align: center;">Notes<br>
                            <table class="table gridtbl" cellspacing="0" cellpadding="0" rules="cols" border="1" style="width: 100%; border-collapse: collapse;">
                                <thead>
                                    <tr>
                                        <th>User ID</th>
                                        <th>Date&Time</th>
                                        <th>Note/Status</th>

                                    </tr>
                                </thead>
                            </table>
                        </th>
                    </tr>
                </thead>
                <tbody style="height: 400px !important;">
                    <tr data-ng-repeat="EditSalesUser in EditSalesUsers" ng-class="{rejectedUser: EditSalesUser.Status == '9'}" repeat-end="onEditUserBindEnd()">
                        <td style="width: 10%; text-align: center;">

                            <a ng-href="ViewSalesUser.aspx?id={{EditSalesUser.Id}}">
                                <img id="ContentPlaceHolder1_grdUsers_imgprofile_0" ng-src="{{EditSalesUser.picture}}" style="width: 100%; height: 85%;"></a>

                        </td>
                        <td style="width: 16%; text-align: center;">

                            <a class="bluetext" ng-href="ViewSalesUser.aspx?id={{EditSalesUser.Id}}">{{EditSalesUser.UserInstallId}}</a>
                            <br>
                            <label>{{EditSalesUser.Designation}}</label>
                            <br />
                            <label class="blacktext">{{EditSalesUser.FristName}} {{EditSalesUser.LastName}}</label>
                        </td>
                        <td style="width: 16%; text-align: center;" class="SeqAssignment">

                            <any ng-switch="EditSalesUser.Status">
                    <ANY ng-switch-when="1">Active</ANY>
                    <ANY ng-switch-when="2">Applicant</ANY>
                    <ANY ng-switch-when="3">Deactive</ANY>
                    <ANY ng-switch-when="4">InstallProspect</ANY>
                    <ANY ng-switch-when="5">InterviewDate</ANY>
                    <ANY ng-switch-when="6">OfferMade</ANY>
                    <ANY ng-switch-when="7">PhoneScreened</ANY>
                    <ANY ng-switch-when="8">Phone_VideoScreened</ANY>
                    <ANY ng-switch-when="9">Rejected</ANY>
                    <ANY ng-switch-when="10">ReferralApplicant</ANY>                  
                    
                </any>
                            <br />
                            <input ng-attr-id="intdt{{EditSalesUser.Id}}" style="width: 80px" class="interviewDate" ng-attr-data-email="{{EditSalesUser.Email}}" ng-attr-data-userid="{{EditSalesUser.Id}}" type="text">
                            <input ng-attr-id="inttime{{EditSalesUser.Id}}" style="width: 70px" class="interviewTime" type="text">
                            <br />
                            <a href="javascript:void(0);" class="badge-hyperlink"><span class="badge badge-success badge-xstext">
                                <label class="seqLable"></label>
                            </span></a><a class="seqTaskURL" data-taskid="" href=""></a>

                        </td>
                        <td style="width: 10%; text-align: center;">

                            <span>{{EditSalesUser.Source}}</span>
                            <br>
                            <span>{{EditSalesUser.AddedBy}}</span>
                            <a ng-href="ViewSalesUser.aspx?id={{EditSalesUser.AddedById}}">- {{EditSalesUser.AddedByUserInstallId}}</a>
                            <br>
                            <span>{{EditSalesUser.CreatedDateTime | date:'M/d/yyyy'}}</span>&nbsp;<span ng-class="redtext">{{EditSalesUser.CreatedDateTime | date:'h:mma'}}</span>&nbsp;<span>(EST)</span>
                        </td>
                        <td style="width: 10%; text-align: center;">

                            <div ng-attr-title='{{EditSalesUser.Country}}' style="background-image: url(img/flags24.png); background-repeat: no-repeat; float: left; height: 22px; width: 24px; margin-top: -5px;" class="us">
                            </div>
                            <span>- {{EditSalesUser.Zip}}</span>
                            <span>{{EditSalesUser.City}}</span>
                            <br />

                            <any ng-switch="EditSalesUser.EmpType">
                    <ANY ng-switch-when="1">Temp</ANY>
                    <ANY ng-switch-when="2">Internship</ANY>
                    <ANY ng-switch-when="3">Part Time - Remote</ANY>
                    <ANY ng-switch-when="4">Part Time - Onsite</ANY>
                    <ANY ng-switch-when="5">Full Time - Remote</ANY>
                    <ANY ng-switch-when="6">Full Time - Onsite</ANY>
                    <ANY ng-switch-when="7">Full Time Hourly</ANY>
                    <ANY ng-switch-when="8">Full Time Salary</ANY>
                    <ANY ng-switch-when="9">Part Time</ANY>
                    <ANY ng-switch-when="10">Sub</ANY>                  
                    
                </any>

                            <span ng-class="{'redtext': EditSalesUser.Aggregate < 33, 'greentext': EditSalesUser.Aggregate > 33, 'hide': EditSalesUser.Aggregate == null}">{{EditSalesUser.Aggregate | number:2}}%</span>
                            <br>
                            <a ng-class="hide" ng-href="//jmgroveconstruction.com/Resumes/{{EditSalesUser.Resumepath}}" target="_blank">{{EditSalesUser.Resumepath}}</a>

                        </td>
                        <td style="width: 17%; text-align: left;">

                            <ul class="contactGrid">
                                <li>{{EditSalesUser.Email}}
                                </li>
                                <li>{{EditSalesUser.Phone}}
                                </li>
                            </ul>
                        </td>
                        <td class="noMargin" style="width: 21%; text-align: center;"></td>
                    </tr>


                </tbody>
            </table>
            <div ng-show="loader.loading" style="position: absolute; top: 50%; left: 50%;">
                Loading...
                <img src="../img/ajax-loader.gif" />
            </div>
            <div class="btn_sec">
                <h3>
                    <label id="ediPopupStatusSuccess"></label>
                </h3>
                <input type="button" value="Save" style="background: url(img/main-header-bg.png) repeat-x; color: #fff; height: 30px; width: 80px;" id="btnSaveMultipleStatuses" onclick="SetMultipleInterviewDate(this);" class="GrdBtnAdd" title="Save" />

            </div>
            <%--   <div class="text-center">
                <jgpager page="{{page}}" pages-count="{{pagesCount}}" total-count="{{TotalRecords}}" search-func="getEditUsers(page)"></jgpager>
            </div>--%>
        </div>

    </div>
    <%--Popup Ends--%>
    <input type="hidden" id="popupNoteUserId" />
    <input type="hidden" id="popupNoteTxtUserId" />
    <!-- Notes Popup -->
    <div class="notes-popup-background"></div>
    <div class="notes-popup">
        <div class="heading">
            <div class="title">User Touch Point Logs</div>
            <div class="close" onclick="closeNotesPopup()">
                <img src="../img/close.png" />
            </div>
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
            <textarea class="note-text textbox" id="txt-popup"></textarea>
            <input type="button" class="GrdBtnAdd" value="Add Notes" onclick="addPopupNotes(this)" />
        </div>
    </div>
    <script src="../Scripts/angular.min.js"></script>
    <script src="../js/angular/scripts/jgapp.js?v=<%=JG_Prospect.Common.modal.SingletonGlobal.Instance.RandomGUID %>"></script>
    <script src="../js/angular/scripts/edituser-angular.js?v=<%=JG_Prospect.Common.modal.SingletonGlobal.Instance.RandomGUID %>"></script>
    <script src="../js/jquery.dd.min.js"></script>
    <script type="text/javascript" src="../js/jquery.timepicker.js"></script>
    <script src="../js/edituser.js?v=<%=JG_Prospect.Common.modal.SingletonGlobal.Instance.RandomGUID %>"></script>
    <script type="text/javascript" src="<%=Page.ResolveUrl("~/js/chosen.jquery.js")%>"></script>
    <script type="text/javascript">

        var UserGridId = "#<%=grdUsers.ClientID%>";

        Dropzone.autoDiscover = false;

        var prmTaskGenerator = Sys.WebForms.PageRequestManager.getInstance();

        prmTaskGenerator.add_beginRequest(function () {
            DestroyCKEditors();
        });

        prmTaskGenerator.add_endRequest(function () {
            EditUser_Initialize();
        });

        $(document).ready(function () {
            EditUser_Initialize();
        });

        function ApplyDateTextBoxes() {

            var txtHRFromDate = '#<%= txtHRFromDate.ClientID %>';
            var txtHRToDate = '#<%= txtHRToDate.ClientID %>';
            $(txtHRFromDate).datepicker().attr('readonly', 'readonly');;
            $(txtHRToDate).datepicker().attr('readonly', 'readonly');;
        }

        var statusDropdown = '#<%= ddlUserStatus.ClientID %>';
        var drpUser = '#<%= drpUser.ClientID %>';
        var drpDesignation = '#<%= ddlDesignation.ClientID %>';
        var drpSource = '#<%= ddlSource.ClientID %>';
        var hdnStatuses = '#<%= hdnStatuses.ClientID %>';
        var hdnSources = '#<%= hdnSources.ClientID %>';
        var hdnDesignations = '#<%= hdnDesignations.ClientID %>';
        var hdnFilterUsers = '#<%= hdnFilterUsers.ClientID %>';
        var btnSearchFilterwise = '#<%= btnSearchFilterwise.ClientID %>';

        function ApplyChoosenDropDown() {

            $(statusDropdown + '> option').each(function (i, item) {
                $(item).html($("<div/>").html($(item).html()).text());
            });

            $(drpUser + '> option').each(function (i, item) {
                $(item).html($("<div/>").html($(item).html()).text());
            });

            $(statusDropdown).chosen();
            $(drpDesignation).chosen();
            $(drpUser).chosen();
            $(drpSource).chosen();

            setonChangeResetforChosen(statusDropdown, hdnStatuses);
            setonChangeResetforChosen(drpDesignation, hdnDesignations);
            setonChangeResetforChosen(drpUser, hdnFilterUsers);
            setonChangeResetforChosen(drpSource, hdnSources);

        }

        function setonChangeResetforChosen(dropdown, hiddenfieldId) {
            $(dropdown).change(function () {
                resetChosen(dropdown, hiddenfieldId);
            });
        }

        function resetChosen(selector, hiddenfieldId) {
            var val = $(selector).val();

            if (val != undefined && val != '') {
                $(selector)
                    .find('option:first-child').prop('selected', false)
                    .end().trigger('chosen:updated');
            } else {
                $(selector)
                    .find('option:first-child').prop('selected', true)
                    .end().trigger('chosen:updated');
            }

            $(hiddenfieldId).val($(selector).val());
            console.log($(hiddenfieldId).val());

            $(btnSearchFilterwise).click();


        }

        function EditUser_Initialize() {
            ApplyChoosenDropDown();
            ApplyDateTextBoxes();
            SetSalesUserAutoSuggestion();
            SetSalesUserAutoSuggestionUI();
            ApplyDropZone();

            try {
                $("#<%=drpUser.ClientID%>").msDropDown();
                $("#<%=ddlStatus_Popup.ClientID%>").msDropDown();
                $("#<%=ddlUserStatus.ClientID%>").msDropDown();
                $(".grd-status").msDropDown();
            } catch (e) {
                alert(e.message);
            }
        }

        var objBulkUploadFileDropzone;

        function ApplyDropZone() {
            //debugger;
            ////User's drag and drop file attachment related code

            //remove already attached dropzone.
            if (objBulkUploadFileDropzone) {
                objBulkUploadFileDropzone.destroy();
                objBulkUploadFileDropzone = null;
            }
            objBulkUploadFileDropzone = GetWorkFileDropzone("div#divBulkUploadFile", 'div#divBulkUploadFilePreview', '#<%= hdnBulkUploadFile.ClientID %>');
        }

        function SetSalesUserAutoSuggestion() {

            $("#<%=txtSearch.ClientID%>").catcomplete({
                delay: 500,
                source: function (request, response) {
                    $.ajax({
                        type: "POST",
                        url: "ajaxcalls.aspx/GetSalesUserAutoSuggestion",
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
                    $("#<%=txtSearch.ClientID%>").val(ui.item.value);
                    //TriggerSearch();
                    $('#<%=btnSearchGridData.ClientID%>').click();
                }
            });
        }

        function SetSalesUserAutoSuggestionUI() {

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

        function grdUsers_Email_OnClick(sender, email) {
            $('#<%=lblEmailTo.ClientID%>').html(email);
            $('#<%=hdnEmailTo.ClientID%>').val(email);
            <%--SetCKEditor('<%=txtEmailHeader.ClientID%>');
            SetCKEditor('<%=txtEmailBody.ClientID%>');
            SetCKEditor('<%=txtEmailFooter.ClientID%>');--%>
            ShowPopupWithTitle('#<%=divSendEmailToUser.ClientID%>', 'Send Email');
        }


        //============= Start DP =============
        function GotoStarUser(bookmarkedUser, isdel, obj) {
            //alert(isdel);
            //alert(obj);
            //alert(bookmarkedUser);
            $(".loading").show();
            $.ajax({
                type: "POST",
                url: "ajaxcalls.aspx/StarBookMarkUsers",
                data: '{bookmarkedUser: ' + bookmarkedUser + ',isdelete:' + isdel + ' }',
                contentType: "application/json; charset=utf-8",
                dataType: "json",
                success: function (response) {
                    //alert("Hello: " + response + " ");

                    var d = new Date();
                    if (isdel == "0") {
                        // alert("if");
                        //alert($("#" + obj));
                        $("#" + obj).removeAttr("src").prop('src', '<%=baseUrl %>/img/starred.png?dummy=' + d.getTime());
                        $("#" + obj).removeAttr("class").attr('class', 'starimgred');
                        $("#" + obj).removeAttr("alt").attr('alt', bookmarkedUser);
                        $("#" + obj).removeAttr("onclick").attr('onclick', 'GotoStarUser("' + bookmarkedUser + '","1","' + obj + '")')
                    }
                    else {
                        $("#" + obj).removeAttr("src").prop('src', '<%=baseUrl %>/img/star.png?dummy=' + d.getTime());
                        $("#" + obj).removeAttr("class").attr('class', 'starimg');
                        $("#" + obj).removeAttr("alt").attr('alt', bookmarkedUser);
                        $("#" + obj).removeAttr("onclick").attr('onclick', 'GotoStarUser("' + bookmarkedUser + '","0","' + obj + '")')
                    }
                    $(".loading").show();
                },
                complete: function () {
                    // Schedule the next request when the current one has been completed
                    // setTimeout(ajaxInterval, 4000);
                    $(".loading").hide();
                },
                failure: function (response) {
                    // alert(response.responseText);
                    $(".loading").hide();
                },
                error: function (response) {
                    // alert(response.responseText);
                    $(".loading").hide();
                }
            });

        }

        function GridSecondaryStatusChanged(event, dropdown){
            var statustr = $(dropdown).closest("tr");
            var selectedValue = $(dropdown).val();
            var UserID = $(statustr).find(".OffferMadeUserID").html();
            ajaxExt({
                url: '/WebServices/JGWebService.asmx/UpdateSecondaryStatus',
                type: 'POST',
                data: '{userId:' + UserID + ',newStatus:' + selectedValue + '}',
                showThrobber: true,
                throbberPosition: { my: "left center", at: "right center", of: $(dropdown), offset: "5 0" },
                success: function (data, msg) {
                    LoadNotes($('#user-'+UserID), UserID, UserID);
                },
                error: function (data, msg) {
                    alert(msg);
                }
            });
        }

        function GridstatusChanged(event, dropdown) {
            var selectedValue = $(dropdown).val();

            // If user status is offermade than dont postback.
            if (selectedValue == "6") {
                OverlayPopupOfferMade();
                var statustr = $(dropdown).closest("tr");

                var Email = $(statustr).find(".OffferMadeEmail").html();
                var FirstName = $(statustr).find(".OffferMadeFirstName").html();
                var LastName = $(statustr).find(".OffferMadeLastName").html();
                var Designation = $(statustr).find(".OffferMadeDesignation").html();
                var OldStatus = $(statustr).find(".OffferMadeOldStatus").html();
                var DesignationID = $(statustr).find(".OffferMadeUserDesignID").html();
                var UserID = $(statustr).find(".OffferMadeUserID").html();
                

                $('#<%=lblName_OfferMade.ClientID%>').html(FirstName + ' ' + LastName);
                $('#<%=lblDesignation_OfferMade.ClientID%>').html(Designation);


                // on cancel button click close popup and reset dropdown to its original status.
                $('#<%=btnCancelOfferMade.ClientID%>').unbind("click");
                $('#<%=btnSaveOfferMade.ClientID%>').unbind("click");

                $('#<%=btnCancelOfferMade.ClientID%>').click(function () {
                    $(dropdown).val(OldStatus);
                    ClosePopupOfferMade();
                    return false;
                });


                $('#<%=btnSaveOfferMade.ClientID%>').click(function () {
                    var branchLocationId = $('#DivOfferMade').find('.branchLocationId').find('option:selected').val();
                    SendOfferMadeEmail(UserID, Email, DesignationID, branchLocationId);
                    return false;
                });

                $('#<%=txtEmail.ClientID%>').val(Email);
                $('#<%=txtPassword1.ClientID%>').val("jmgrove");
                $('#<%=txtpassword2.ClientID%>').val("jmgrove");



            }
            else { // For rest of the statuses postback.
                __doPostBack($(dropdown).attr("id"));
            }

            return false;
        }

        function SendOfferMadeEmail(UserID, Email, DesignationID, branchLocationId) {

            var postData = {
                UserEmail: Email,
                UserID: parseInt(UserID),
                DesignationID: DesignationID,
                branchLocationId:branchLocationId
            };

            CallJGWebService('SendOfferMadeToCandidate', postData, OnSendOfferMadeToCandidateSuccess, OnSendOfferMadeToCandidateError);

            function OnSendOfferMadeToCandidateSuccess(data) {
                if (data.d) {
                    alert("OfferMade Email Sent Successfully!");
                    ClosePopupOfferMade();
                }
            }

            function OnSendOfferMadeToCandidateError(err) {
                alert("Error occured while sending OfferMade Email");
                ClosePopupOfferMade();
            }

        }

        $(document).ready(function () {
            var notesEmail = '<%=notesUserEmail %>';
            if (notesEmail != '') {
                $('.txtSearch').val(notesEmail);
                $('.btnSearchGridData').trigger('click');
            }
            var changeTooltipPosition = function (event) {
                var tooltipX = event.pageX - 8;
                var tooltipY = event.pageY + 8;
                $('div.startooltip').css({ top: tooltipY, left: tooltipX });
            };

            var showTooltip = function (event) {
                //$(".loading").show();
                var bookmarkedUser = $(this).attr('alt');

                $.ajax({
                    type: "POST",
                    url: "ajaxcalls.aspx/GetBookMarkingUserDetails",
                    data: '{bookmarkedUser: ' + bookmarkedUser + ' }',
                    contentType: "application/json; charset=utf-8",
                    dataType: "json",
                    success: function (data) {
                        if (data.d) {
                            var str = "";
                            var parsed = $.parseJSON(data.d);

                            $.each(parsed, function (i, item) {
                                var vBookmarkDate = new Date(parseInt(item.createdDateTime.substr(6)));
                                str = str + item.UserInstallId + " - " + item.FristName + " " + item.LastName + " & " + vBookmarkDate + "<br/> ";
                            });

                            $('div.startooltip').remove();
                            $('<div class="startooltip">' + str + '</div>')
                                .appendTo('body');
                            changeTooltipPosition(event);
                        }
                        // $(".loading").show();
                    },
                    complete: function () {
                        // Schedule the next request when the current one has been completed
                        // setTimeout(ajaxInterval, 4000);
                        //$(".loading").hide();
                    },
                    failure: function (response) {
                        // alert(response.responseText);
                        // $(".loading").hide();
                    },
                    error: function (response) {
                        // alert(response.responseText);
                        // $(".loading").hide();
                    }
                });

            };

            var hideTooltip = function () {
                $('div.startooltip').remove();
                //$(".loading").hide();
            };

            $(".starimgred").bind({
                mousemove: changeTooltipPosition,
                mouseenter: showTooltip,
                mouseleave: hideTooltip

            });
            ReLoadNotes();
        });

            function ReLoadNotes() {
                $('.notes-container').each(function (i) {
                    var id = $(this).attr('id').split('-')[1];
                    var installUserId = $(this).attr('uid');
                    LoadNotes($('#user' + id), installUserId, id);
                });
            }
            //============== End DP ==============

            function showBulkUploadProgressPopup() {

                $('#bulkUpload').removeClass('hide');

                $('#bulkUpload').dialog({
                    modal: false,
                    height: 700,
                    width: 1000,
                    title: "Bulk upload progress...",

                }).parent().appendTo($("form:first"));

                $('#bulkUpload').show();



                return true;
            }

    </script>
</asp:Content>
