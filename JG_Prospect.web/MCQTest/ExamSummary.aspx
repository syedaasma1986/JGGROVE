<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="ExamSummary.aspx.cs" Inherits="JG_Prospect.MCQTest.ExamSummary" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title></title>
    <style type="text/css">
        .style1
        {
            width: 100%;
        }
        .style2
        {
            color: #000000;
        }
        .style4
        {
            color: #000000;
            text-align: center;
        }
        .style5
        {
            text-align: center;
        }
        .style6
        {
            float: right;
        }
    </style>
    <script type="text/javascript" src="../js/TimerFunctions.js"></script>
</head>
<body>
    <form id="form1" runat="server">
    <hr />
    <table class="style1" border="1">
        <tr>
            <td class="style4">
        Here you can see your questions and answer  
        . Just click on the question to go to the corresponding row):</td>
            <td class="style5">
								<span class="style2" lang="en-us">Time remaining:</span><asp:Label ID="lblExamTime" runat="server" BackColor="#663300" 
                                    Font-Size="Large" ForeColor="White" Text="Label"></asp:Label>
                            </td>
        </tr>
    </table>
    <p class="style4">
        <asp:LinkButton ID="btnSubmitExam" runat="server" BackColor="White" 
            onclick="btnSubmitExam_Click1">Click here to submit exam</asp:LinkButton>
        <span lang="en-us">&nbsp;</span></p>
    <p class="style4">
        <span lang="en-us">(Careful... once submitted, exam Will end)</span></p>
    <p class="style5">
        <asp:Label ID="lblObjectiveSummary" runat="server" BackColor="White" 
            Text="No Questions for this exam"></asp:Label>
    </p>
    <hr />    
    <asp:HiddenField ID="currentExamTime" runat="server" />
    </form>
</body>
</html>
