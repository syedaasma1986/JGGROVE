<%@ Page Title="" Language="C#" MasterPageFile="~/Sr_App/SR_app.Master" AutoEventWireup="true" CodeBehind="view-aptitude-test.aspx.cs"
    Inherits="JG_Prospect.Sr_App.view_aptitude_test" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <div class="right_panel">
        <!-- appointment tabs section start -->
        <ul class="appointment_tab">
            <li><a href="Price_control.aspx">Product Line Estimate</a></li>
            <li><a href="Inventory.aspx">Inventory</a></li>
            <li><a href="Maintenace.aspx">Maintainance</a></li>
            <li><a href="email-template-maintainance.aspx">Maintainance New</a></li>
            <li><a href="manage-aptitude-tests.aspx">Aptitude Tests</a></li>
        </ul>
        <!-- appointment tabs section end -->
        <h1>Aptitude Test</h1>
        <div class="form_panel_custom">
            <table class="aptitude-test" width="100%" cellpadding="0" cellspacing="3" border="0">
                <tr>
                    <td colspan="6" align="right">
                        <a href='<%=string.Format("{0}?ExamID={1}", Page.ResolveUrl("~/sr_app/add-edit-aptitude-test.aspx"), this.ExamID) %>'>Edit</a>
                    </td>
                </tr>

                <tr>
                    <th width="80" class="noborder">Title:</th>
                    <td>
                        <asp:Literal ID="ltrlTitle" runat="server" />&nbsp;<img id="imgActive" runat="server" />
                    </td>
                    <th width="120" align="right" class="noborder">Duration:</th>
                    <td width="15">
                        <asp:Literal ID="ltrlDuration" runat="server" />
                    </td>
                </tr>
                <tr>
                    <th class="noborder">Description:</th>
                    <td>
                        <asp:Literal ID="ltrlDescription" runat="server" />
                    </td>
                    <th class="noborder" align="right">Pass Percentage:</th>
                    <td>
                        <asp:Literal ID="ltrlPassPercentage" runat="server" />
                    </td>
                </tr>
                <tr>
                    <th class="noborder">Designation:</th>
                    <td>
                        <asp:Literal ID="ltrlDesignation" runat="server" />
                    </td>
                    <td></td>
                    <td></td>
                </tr>
                <tr>
                    <td colspan="4">
                        <h4>Questions:</h4>
                    </td>
                </tr>
                <tr>
                    <td colspan="4">
                        <table width="100%" cellpadding="0" cellspacing="3" border="0">
                            <tr>
                                <td>
                                    <asp:Repeater ID="repQuestions" runat="server">
                                        <HeaderTemplate>
                                            <table class="question-list" width="100%" cellpadding="0" cellspacing="0" border="0">
                                        </HeaderTemplate>
                                        <ItemTemplate>
                                            <tr class="question">
                                                <td width="15" align="center" valign="top">
                                                    <%# (Container.ItemIndex + 1) + "." %>
                                                </td>
                                                <td valign="top">
                                                    <%# Eval("Question") %>
                                                </td>
                                                <td width="250" valign="top" align="right">
                                                    <b>Positive Marks</b> : <%# Eval("PositiveMarks") %>, <b>Negetive Marks</b> : <%# Eval("NegetiveMarks") %>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td colspan="3">
                                                    <asp:Repeater ID="repOptions" runat="server" DataSource='<%# GetOptionsByQuestionID(Convert.ToInt64(Eval("QuestionID"))) %>'>
                                                        <HeaderTemplate>
                                                            <ol class="option-list">
                                                        </HeaderTemplate>
                                                        <ItemTemplate>
                                                            <li class='<%# IsCorrectAnswer(Convert.ToInt64(Eval("QuestionID")), Convert.ToInt64(Eval("OptionID")))? "answer": "" %>'>
                                                                <%# Eval("OptionText") %>
                                                            </li>
                                                        </ItemTemplate>
                                                        <FooterTemplate>
                                                            </ol>
                                                        </FooterTemplate>
                                                    </asp:Repeater>
                                                </td>
                                            </tr>
                                        </ItemTemplate>
                                        <FooterTemplate>
                                            </table>
                                        </FooterTemplate>
                                    </asp:Repeater>
                                </td>
                            </tr>
                        </table>
                    </td>
                </tr>
                <tr>
                    <td colspan="4" align="right">
                        <a href='<%=Page.ResolveUrl("~/sr_app/manage-aptitude-tests.aspx") %>'>Aptitude Tests</a>&nbsp;&nbsp;|&nbsp;&nbsp;  
                            <a href='<%=string.Format("{0}?ExamID={1}", Page.ResolveUrl("~/sr_app/add-edit-aptitude-test.aspx"), this.ExamID) %>'>Edit</a>
                    </td>
                </tr>
            </table>
        </div>
    </div>
</asp:Content>
