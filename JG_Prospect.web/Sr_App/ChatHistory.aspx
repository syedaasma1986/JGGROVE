<%@ Page Language="C#" AutoEventWireup="true" MasterPageFile="~/Sr_App/SR_app.Master" ValidateRequest="false"
    CodeBehind="ChatHistory.aspx.cs" Inherits="JG_Prospect.Sr_App.ChatHistory" MaintainScrollPositionOnPostback="true" Async="true" %>

<%@ Register Assembly="System.Web.DataVisualization, Version=4.0.0.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35" Namespace="System.Web.UI.DataVisualization.Charting" TagPrefix="asp" %>

<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<%@ Register Assembly="CKEditor.NET" Namespace="CKEditor.NET" TagPrefix="CKEditor" %>
<%@ Register Src="~/UserControl/ucStatusChangePopup.ascx" TagPrefix="ucStatusChange" TagName="PoPup" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <script type="text/javascript" src="<%=Page.ResolveUrl("~/js/chosen.jquery.js")%>"></script>
    <script src="../js/angular/scripts/jgapp.js"></script>
    <script src="../js/angular/scripts/TaskSequence.js"></script>
    <script src="../js/angular/scripts/FrozenTask.js"></script>
    <script src="../js/TaskSequencing.js"></script>
    <script src="../js/jquery.dd.min.js"></script>
    <script src="../js/angular/scripts/ClosedTasls.js"></script>
    <link href="../Chat/chathistory.css" rel="stylesheet" />
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <div class="history-section">
        <div class="title">
            Chat History
        </div>
        <div class="list">
            <%
                string baseUrl = HttpContext.Current.Request.Url.Scheme +
                        "://" + HttpContext.Current.Request.Url.Authority +
                        HttpContext.Current.Request.ApplicationPath.TrimEnd('/') + "/";
                foreach (var item in users)
                {
            %>
            <div title="<%=item.GroupOrUsername%>" class="user-row" uid="<%=item.UserId%>" onclick="showChatHistory(this, '<%=item.ReceiverIds%>', '<%=item.UserId.HasValue?null:item.ChatGroupId%>','<%=item.UserChatGroupId.HasValue?item.UserChatGroupId.Value:0 %>')">
                <div class="profile">
                    <img src="<%=baseUrl+item.ProfilePic%>" title=""><%--<div class="status-icon active"></div>--%>
                    <div class="installid"><a href="#"></a></div>
                </div>
                <div class="contents">
                    <div class="top">
                        <div class="name"><%=item.GroupOrUsername%></div>
                        <div class="time"><%=item.LastMessageAtFormatted%></div>
                    </div>
                    <div class="msg-container">
                        <div class="tick">
                            <img src="../img/grey-tick.png">
                        </div>
                        <div class="msg"><%=item.LastMessage%></div>
                    </div>
                </div>
            </div>
            <%}%>
        </div>
        <div class="chats">
        </div>
    </div>
    <script type="text/javascript">
        function showChatHistory(sender, receiverIds, chatGroupId, userChatGroupId) {
            ajaxExt({
                url: '/WebServices/JGWebService.asmx/ChatHistory',
                type: 'POST',
                data: '{ receiverIds: "' + receiverIds + '", chatGroupId:"' + chatGroupId + '", chatSourceId:0,userChatGroupId:' + userChatGroupId + ',pageNumber:1, pageSize:500 }',
                showThrobber: true,
                throbberPosition: { my: "left center", at: "right center", of: $(sender), offset: "5 0" },
                success: function (data, msg) {
                    // Identify sender/receiver
                    var loggedInUserId = getCookie('<%=JG_Prospect.Common.Cookies.UserId%>');
                    var str = '';
                    $(data.Results).each(function (i) {
                        var senderReceiver = loggedInUserId == data.Results[i].UserId ? 'sender' : 'receiver';
                        var fileid = data.Results[i].FileId;
                        var msg = data.Results[i].Message;
                        if (fileid != undefined && fileid != null && fileid != '') {
                            msg = '<a href="/chat/attachments/' + msg.split(':')[1] + '" target="_black">' + msg.split(':')[0] + '</a>';
                        }
                        var tickColor = data.Results[i].IsRead.toString().toLowerCase() == 'true' ? 'blue' : 'grey';
                        str += '<div class="chat-row ' + senderReceiver + '" userid="' + data.Results[i].UserId + '"><div class="profile">' +
                                        '<img src="<%=baseUrl %>' + data.Results[i].UserProfilePic + '" title="' + data.Results[i].UserFullname + '" />' +
                                        '<div class="name">' + data.Results[i].UserFullname + '</div><div class="installid">' +
                                            '<a target="_blank" href="/Sr_App/ViewSalesUser.aspx?id=' + data.Results[i].UserId + '">' + data.Results[i].UserInstallId + '</a></div>' +
                                    '</div>' +
                                    '<div class="message"><div class="msg">' + msg + '</div>' +
                                    '<div class="time-container"><div class="tick">' +
                                        '<img src="../img/' + tickColor + '-tick.png" /> </div>' +
                                        '<div class="time">' + data.Results[i].MessageAtFormatted + '</div>' +
                                        '<div class="est">(EST)</div> </div>' +
                                    '</div></div>';
                    });
                    $('.chats').html(str);
                }
            });
        }
    </script>
</asp:Content>
