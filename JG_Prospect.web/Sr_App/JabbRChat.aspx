<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="JabbRChat.aspx.cs" Inherits="JG_Prospect.Sr_App.JabbRChat" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title></title>
</head>
<body>
    <form id="form1" runat="server">
        <div>
        </div>
    </form>
    <div style="display: none;">
        <form name="frmJabbRChatLogin" action="http://chat.jmgrovebuildingsupply.com/account/login?ReturnUrl=%2F" method="post">
            <input type="text" id="username" name="username" value="<%=UserName%>" placeholder="Username" />
            <input type="password" id="password" name="password" value="<%=Password%>" class="span10" placeholder="Password" />
        </form>
    </div>
    <div style="padding: 10px;">
        Please wait...
    </div>
    <script type="text/javascript">
        document.frmJabbRChatLogin.submit();
    </script>
</body>
</html>
