<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="ForgotPassword.aspx.cs" Inherits="JG_Prospect.ForgotPassword" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>JG Prospect</title>
    <link href="/css/screen.css" rel="stylesheet" media="screen" type="text/css" />
    <link href="/css/jquery.ui.theme.css" rel="stylesheet" media="screen" type="text/css" />

    <style type="text/css">
        .ui-widget-header {
            border: 0;
            background: none /*{bgHeaderRepeat}*/;
            color: #222 /*{fcHeader}*/;
        }

        .auto-style1 {
            width: 100%;
        }
    </style>
    <script>
        function goBacktoLogin() {
            window.parent.location.href = "stafflogin.aspx";
            return false;
        } 
    </script>
</head>
<body>
    <form id="form1" runat="server">
        <asp:ScriptManager ID="scriptmanager1" runat="server"></asp:ScriptManager>
        <div class="">
            <h1><b>Forgot Password</b></h1>

            <asp:UpdatePanel ID="upnlForgotPWD" runat="server">
                <ContentTemplate>

                    <div class="login_form_panel">
                        <ul>
                            <li class="last">
                                <table border="0" cellspacing="0" cellpadding="0">
                                    <tr>
                                        <td>&nbsp;</td>
                                    </tr>
                                    <tr>
                                        <td>
                                            <label>User Type.<span>*</span></label>
                                            <asp:RadioButton ID="rdCustomer" runat="server" Style="width: 10% !important;" Text="Customer" GroupName="Login" />
                                            <asp:RadioButton ID="rdSalesIns" runat="server" Style="width: 10% !important;" Text="Staff" GroupName="Login" />
                                        </td>
                                    </tr>
                                    <tr>
                                        <td>
                                            <label style="line-height: 14px !important;">Login Id (Email)<span>*</span></label>
                                            <asp:TextBox ID="txtloginid" runat="server" TabIndex="1" Width="312px"></asp:TextBox>
                                            <br />
                                            <label></label>
                                            <asp:RequiredFieldValidator ID="RequiredFieldValidator1" runat="server" ValidationGroup="Login"
                                                ControlToValidate="txtloginid" Display="Dynamic" ForeColor="Red">Please enter Username.</asp:RequiredFieldValidator>
                                            <asp:RegularExpressionValidator ID="validateEmail" runat="server" ValidationGroup="Login" ErrorMessage="Please enter valid email address."
                                                ControlToValidate="txtloginid" Display="Dynamic" ForeColor="Red" ValidationExpression="^([\w\.\-]+)@([\w\-]+)((\.(\w){2,3})+)$" />
                                        </td>
                                    </tr>
                                </table>
                            </li>
                        </ul>
                        <div class="btn_sec">
                            <asp:Button ID="btnsubmit" runat="server" Text="Submit" ValidationGroup="Login" TabIndex="3" OnClick="btnsubmit_Click" />
                            <asp:Button ID="btnBack" runat="server" Text="Back" OnClientClick="javascript:return goBacktoLogin();" CausesValidation="false" TabIndex="4"  />
                        </div>
                    </div>

                </ContentTemplate>
                <Triggers>
                    <asp:AsyncPostBackTrigger ControlID="btnsubmit" EventName="Click" />
                </Triggers>
            </asp:UpdatePanel>
        </div>

    </form>
</body>
</html>
