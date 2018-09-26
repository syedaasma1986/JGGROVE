<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="chat.aspx.cs" Inherits="JG_Prospect.Sr_App.chat" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title></title>
</head>
<body>
    <form id="form1" runat="server">
    <div class="chats">
        <div class="chat-row"></div>
    </div>
    <div>
        <input type="text" id="chattext" />
        <input type="button" value="Send" id="sendChat" />
    </div>
    </form>
    <script src="../Scripts/jquery-1.6.4.min.js"></script>
    <script src="/Scripts/jquery.signalR-2.2.2.min.js"></script>
    <script src="/signalr/hubs"></script>
    
    <script type="text/javascript">
        $(document).ready(function () {
            // Reference the auto-generated proxy for the hub.
            var chat = $.connection.chatHub;
            // Create a function that the hub can call back to display messages.            
            debugger;
            // Start the connection.
            $.connection.hub.start().done(function () {
                console.log('started...')
                $('#sendChat').click(function () {
                    debugger;
                    chat.server.sendChatMessage('Jitendra', $('#chattext').val());
                });
            }).fail(function (reason) {
                debugger;
                console.log(reason);
            });

            //Callback function which the hub will call when it has finished processing,
            // is attached to the proxy 
            chat.client.updateClient = function (obj) {
                // Add the message to the page.
                debugger;
            };
        });
    </script>
</body>
</html>
