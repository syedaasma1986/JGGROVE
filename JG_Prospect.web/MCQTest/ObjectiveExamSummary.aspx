<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="ObjectiveExamSummary.aspx.cs" Inherits="JG_Prospect.MCQTest.ObjectiveExamSummary" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title></title>
    <link href="../css/screen.css" rel="stylesheet" media="screen" type="text/css" />
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
        .tblExamSummary tr td {
            padding: 10px 15px 15px 15px;
            background: url(../img/line.png) repeat-x 50% bottom;
            font-size: initial;                
        }

        .SubmitLnk {
            background-color: White;
            font-size: large;
            height: 30px;
            background: url(/Sr_App/img/main-header-bg.png) repeat-x;
            color: #fff;
            border-radius: 5px;
            padding-left: 16px;
            padding-right: 16px;
            border-top-width: 2px;
            padding-bottom: 10px;
            padding-top: 10px;
            text-decoration: blink;
        }
            .SubmitLnk:hover {
                color: #fefefe;
            }
        
        
    </style>
</head>
<body style="background:none;border: Solid 3px #b04547; width: 99%; ">
    <form id="form1" runat="server">
    
    <hr />
    <table class="style1" border="1">
        <tr>
            <td class="style4">
        Here you can see your questions and answer  
        . Just click on the question to go to the corresponding row):</td>
            <td class="style5">
								<span class="style2" style="display:none;" lang="en-us">Time remaining:</span><asp:Label ID="lblExamTime" runat="server" BackColor="#663300" 
                                    Font-Size="Large" ForeColor="White" Text=""></asp:Label>
                            </td>
        </tr>
    </table>
        <p class="style5">
        <asp:Label ID="lblObjectiveSummary" runat="server" BackColor="White" 
            Text="No Questions for this exam"></asp:Label>
    </p>
        <p class="style4">
        <span lang="en-us">(Careful... once submitted, exam Will end)</span></p>


    <p class="style4">
        <asp:LinkButton ID="btnSubmitExam" runat="server" BackColor="White" CssClass="SubmitLnk" 
            onclick="btnSubmitExam_Click1">Click here to submit exam</asp:LinkButton>
        <span lang="en-us">&nbsp;</span></p>
    
    
    <hr />    
    <asp:HiddenField ID="currentExamTime" runat="server" />
    </form>
    </body>
</html>
