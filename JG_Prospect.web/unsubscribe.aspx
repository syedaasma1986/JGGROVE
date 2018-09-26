<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="unsubscribe.aspx.cs" Inherits="JG_Prospect.unsubscribe" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">

<head id="Head1" runat="server">
    <link href="../datetime/css/jquery-ui-1.7.1.custom.css" rel="stylesheet" type="text/css" />
    <link href="../datetime/css/stylesheet.css" rel="stylesheet" type="text/css" />
    <link rel="stylesheet" href="https://code.jquery.com/ui/1.10.2/themes/smoothness/jquery-ui.css" />
    <link href="css/screen.css" rel="stylesheet" media="screen" type="text/css" />
    <link href="css/jquery.ui.theme.css" rel="stylesheet" media="screen" type="text/css" />

    <script src="https://code.jquery.com/jquery-1.9.1.js"></script>
    <script src="https://code.jquery.com/ui/1.10.2/jquery-ui.js"></script>

    <title>JG Prospect - Email Unsubscribe</title>

</head>
<body>
    <form id="form1" runat="server" >
        <asp:ScriptManager ID="scriptmanager1" runat="server"></asp:ScriptManager>
        <div class="container">
            <!--header section-->
            <div class="header">
                <img src="img/logo.png" alt="logo" width="88" height="89" class="logo" />
            </div>
            <div class="content_panel">
                <table width="100%">
                    <tr>
                        <td width="100%" align="center">
                            <div class="login_right_panel" style="min-height: 407px !important; margin: 0 0 0 0 !important;">
                                <h1 style="text-align: left;"><b>Unsubscribe Email Address</b></h1>
                                <br />
                                <h3>
                                    <asp:Literal ID="ltlUnSEmail" runat="server"></asp:Literal>
                                    
                                </h3>
                                <br />
                                <h5>if you think you accidentally clicked on unsubscribe link, you can resubscribe by 
                                    <asp:LinkButton ID="lbtnReSub" runat="server" OnClick="lbtnReSub_Click" >clicking here</asp:LinkButton>
                                </h5>
                            </div>
                        </td>
                    </tr>
                </table>
                <!-- Tabs endss -->
            </div>

        </div>
        <!--footer section-->
        <div class="footer_panel">
            <ul>
                <li>&copy; 2017 JG All Rights Reserved.</li>
                <li><a href="#">Terms of Use</a></li>
                <li>|</li>
                <li><a href="#">Privacy Policy</a></li>
            </ul>
        </div>
    </form>
</body>

</html>

