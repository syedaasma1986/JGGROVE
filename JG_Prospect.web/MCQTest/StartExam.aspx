<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="StartExam.aspx.cs" Inherits="JG_Prospect.MCQTest.StartExam" %>

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
                color: #0026ff;
            }
            .style4
            {
                width: 472px;
            }
            .style5
            {
                width: 115px;
            }
            .style6
            {
                width: 441px;
            }
            .style7
            {
                width: 153px;
            }
            .style8
            {
                width: 1060px;
            }
            .style10
            {
                height: 22px;
            }
            .style12
            {
                color: #FF3300;
            }
            .style11
            {
                color: #009900;
            }
            .style13
            {
                width: 71px;
            }
            .tblStartExamMai
            {
                border: Solid 3px #b04547; width: 99%;
            }
        .lblQuestion table tr td
        {
            font-size:large;
        }
        .rbtnLstOption {
            margin: 15px;
        }
        .rbtnLstOption tr td 
        {
            padding: 10px 15px 0px 15px;
        }
        .btn-default {
            border-radius: 5px;
            border: #b5b4b4 1px solid;
            padding: 5px;
            background: url(/Sr_App/img/main-header-bg.png) repeat-x; 
            color: #fff;
        }
        </style>
    <script type="text/javascript" src="../js/TimerFunctions.js"></script>
</head>
<body style="background:none;" class="tblStartExamMai">

    <form id="form1" runat="server">
      
		<table id="Table2" cellSpacing="1" cellPadding="1" border="1">
								<tr>
									<td style="HEIGHT: 39px">
										<table class="style1">
                                            <tr>
                                                <td>
                                                    <br />
                                                    <p style="float: left">
                                                        <asp:Label ID="Label4" runat="server" BackColor="White">Exam has started. Start Attempting by selecting Question Number , </asp:Label>
                                                        <asp:Label ID="Label1" runat="server" BackColor="#E0E0E0">List Of Questions</asp:Label>
                                                    </p>
                                                    <p style="float: right">
                                                        <asp:Label ID="lblExamTime" runat="server" BackColor="#f57575" Visible="false"
                                                            Font-Size="Large" Text="Label"></asp:Label>
                                                    </p>
                                                    <br />
                                                    <br />
                                                    <asp:Label ID="Label2" CssClass="lblQuestion" runat="server" BackColor="White"></asp:Label>
                                                    <hr style="width:100%"  />                                                    

                                                </td>
                                                <td>
								            </td>
                                            </tr>
                                        </table>
                                    </td>
								</tr>
								<tr>
									<td style="HEIGHT: 39px" bgcolor="White">
										<asp:label id="lblQuestion" runat="server" BackColor="White" Font-Bold="False"
											ForeColor="Black">Exam Question Will Appear Here</asp:label></td>
								</tr>
								<tr>
									<td bgcolor="White" class="style10">
										<table border="1" class="style1">
                                            <tr>
                                                <td>
                                                    <span lang="en-us"><span class="style11">Weightage of Questation:
                                                    <asp:Label ID="lblPositiveMarks" runat="server" ForeColor="#009900"></asp:Label>
                                                        &nbsp;Point</span>
                                                    </span>
                                                </td>
                                                <td>
                                                    <span class="style12" lang="en-us" style="display:none;">Negative Marks:                                                     <asp:Label ID="lblNegetiveMarks" runat="server" ForeColor="#FF3300"></asp:Label>
                                                    </span>
                                                </td>
                                            </tr>
                                        </table>
                                    </td>
								</tr>
								<TR>
									<TD>
										<P>&nbsp;</P>
											<asp:panel id="pnlSingleSelect" runat="server" 
                                            Visible="False">												
												<asp:RadioButtonList id="RadioButtonList1" class="rbtnLstOption" runat="server" ></asp:RadioButtonList>
												<table class="style1">
                                                    
                                                    <tr>
                                                        <td>
                                                            <br /><br /><br /><br /><br />
                                                        </td>
                                                        <td class="style13">
                                                            
                                                            <asp:Button ID="btnPrevSingle" runat="server" onclick="btnPrevSingle_Click" CssClass="btn-default" 
                                                                Text="<" Width="50px"  />
                                                        </td>
                                                        <td class="style13">
                                                            <asp:Button ID="btnSingleSelect0" runat="server" CssClass="btn-default" 
                                                                onclick="btnSingleSelect_Click" Text="Mark Answer" Width="157px" />
                                                        </td>
                                                        <td class="style4">
                                                            <asp:Button ID="btnNextSingle" Style="margin-left: 15px;" runat="server" onclick="btnNextSingle_Click" CssClass="btn-default" 
                                                                Text=">" Width="50px" />
                                                        </td>
                                                    </tr>
                                                    <tr>
                                                        <td colspan="4" style="text-align: right">
                                                            <asp:Button ID="btnSubmitExam" runat="server" Text="End / Sumbit Exam" CssClass="btn-default"
                                                                OnClick="btnSubmitExam_Click"></asp:Button>
                                                        </td>
                                                    </tr>
                                                </table>
												</asp:panel>
											<asp:panel id="pnlMultiSelect" runat="server" 
                                            Visible="False">
												<P><FONT color="#ffffff">More than one answer given below is correct.</FONT></P>
												<asp:CheckBoxList id="CheckBoxList1" runat="server" ></asp:CheckBoxList>
												<table class="style1">
                                                    <tr>
                                                        <td class="style5">
                                                            <%--<asp:Button ID="btnMultiSelect" runat="server" onclick="btnMultiSelect_Click" 
                                                                Text="Mark Answer" Width="157px" />--%>
                                                        </td>   
                                                        <td class="style6">
                                                            <%--<asp:Button ID="btnMultiSelectClear" runat="server" 
                                                                onclick="btnMultiSelectClear_Click" Text="Clear Answer" Width="157px" />--%>
                                                        </td>
                                                    </tr>
                                                    <tr>
                                                        <td class="style5">
                                                            <asp:Button ID="btnPrevMulti" runat="server" onclick="btnPrevMulti_Click" 
                                                                Text="Previous Question" Width="157px" />
                                                        </td>
                                                        <td class="style6">
                                                            <asp:Button ID="btnNextMulti" runat="server" onclick="btnNextMulti_Click" 
                                                                style="margin-left: 0px" Text="Next Question" Width="157px" />
                                                        </td>
                                                    </tr>
                                                </table>
                                                <br />
												</asp:panel>
											<asp:panel id="pnlPhrase" runat="server" Visible="False">
												<P><FONT color="#ffffff">Fill in the blank with Appropriate answer</FONT></P>
												<P>
													<asp:TextBox id="txtAnswer" runat="server"></asp:TextBox></P>

                                                <br />
												<table class="style1">
                                                    <tr>
                                                        <td class="style7">
                                                            <asp:Button ID="btnPhrase0" runat="server" onclick="btnPhrase_Click" 
                                                                Text="Mark Answer" Width="157px" />
                                                        </td>
                                                        <td class="style8">
                                                            <%--<asp:Button ID="btnPhraseClear" runat="server" onclick="btnPhraseClear_Click" 
                                                                Text="Clear Answer" Width="157px" />--%>
                                                        </td>
                                                    </tr>
                                                    <tr>
                                                        <td class="style7">
                                                            <asp:Button ID="btnPrevPhrase" runat="server" onclick="btnPrevPhrase_Click" 
                                                                Text="Previous Question" Width="157px" />
                                                        </td>
                                                        <td class="style8">
                                                            <asp:Button ID="btnNextPhrase" runat="server" onclick="btnNextPhrase_Click" 
                                                                Text="Next Question" Width="158px" />
                                                        </td>
                                                    </tr>
                                                </table>
												</asp:panel>
									</TD>
								</TR>
								<TR>
									<TD></TD>
								</TR>
							</table>
        
            <asp:Image ID="ImageForQuestion" runat="server" 
                                    AlternateText=""  />
        

        <HR width="100%" SIZE="1">
		    <asp:HiddenField ID="currentExamTime" runat="server" Value="" />
    </form>
</body>
</html>
