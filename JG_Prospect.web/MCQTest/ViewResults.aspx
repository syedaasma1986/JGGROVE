<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="ViewResults.aspx.cs" Inherits="JG_Prospect.MCQTest.ViewResults" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title></title>
    <link href="../css/screen.css" rel="stylesheet" media="screen" type="text/css" />
</head>
<body style="background:none;">
    <form id="form1" runat="server">
        <br />
        <br />
        <h1> Test Ended </h1>
        <div style="text-align: center" class="form_panel_custom">
            
            <br /><br /><br />

            <p class="style2">
                If you are seeing this page, it implies that the session has ended and you have 
            been evaluated. You can close this.
            </p>

            <table id="Table1" style="width: 480px; height: 168px" cellspacing="1" cellpadding="1"
                width="480" border="1">

                <tr>
                    <td style="width: 156px">Marks Earned</td>
                    <td>
                        <asp:Label ID="lblMarksEarned" runat="server">Label</asp:Label></td>
                </tr>
                <tr>
                    <td style="width: 156px">Total Marks</td>
                    <td>
                        <asp:Label ID="lblTotalMarks" runat="server">Label</asp:Label></td>
                </tr>
                <tr>
                    <td style="width: 156px">Aggregate</td>
                    <td>
                        <asp:Label ID="lblPercentage" runat="server">Label</asp:Label></td>
                </tr>
            </table>
            <br />
            <p id="pFail" runat="server">
                <b>
                    Unfortunately you did NOT pass the apptitude test for the designation you applied for.
                    <br />
                    If you feel you reached this message in error you will need to contact a JG MNGR represenative to unlock your account and allow you to take another test.
                    <br /><br />
                    Thank you for applying with JMG.
                </b>
            </p>
            <p id="pPass" runat="server" >
                <b>
                    Congratulations! 
                    <br />
                    You have passed the apptitude test for the designation you applied for.
                    <br />To continue the Hiring process fill out the remaining following fields and confirm the default given date and time to speak with a hiring manager for instructions for the final step of the hiring process.
                    <br />You will be contacted to confirm that date and time is acceptable with the hiring manager.
                    <br />You will login to the application to have your Video/Voice/chat "Interview Date Meeting.
                </b>
            </p>
            <br />
        </div>
    </form>
        <hr width="100%" size="1">
</body>
</html>
