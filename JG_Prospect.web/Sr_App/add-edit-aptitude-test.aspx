<%@ Page Title="" Language="C#" MasterPageFile="~/Sr_App/SR_app.Master" AutoEventWireup="true" CodeBehind="add-edit-aptitude-test.aspx.cs"
    Inherits="JG_Prospect.Sr_App.add_edit_aptitude_test" ValidateRequest="false" EnableEventValidation="false" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <link href="../css/chosen.css" rel="stylesheet" />
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
        <h1>
            <asp:Literal ID="ltrlPageHeader" runat="server" /></h1>
        <div class="form_panel_custom">
            <asp:UpdatePanel ID="upnlEditTest" runat="server">
                <ContentTemplate>
                    <asp:ValidationSummary ID="vsExam" runat="server" ValidationGroup="vgExam" ShowMessageBox="true" ShowSummary="false" />
                    <table class="aptitude-test" width="100%" cellpadding="0" cellspacing="3" border="0">
                        <tr>
                            <th width="80" class="noborder">Title:</th>
                            <td>
                                <asp:TextBox ID="txtTitle" runat="server" MaxLength="200" Width="250" />
                                <asp:RequiredFieldValidator ID="rfvTitle" runat="server" ControlToValidate="txtTitle" InitialValue="" ValidationGroup="vgExam"
                                    ErrorMessage="Please enter Title." Display="None" />
                                &nbsp;
                        <asp:CheckBox ID="chkActive" runat="server" Text="Active?" TextAlign="Left" /></td>
                            <th width="120" align="right" class="noborder">Duration:</th>
                            <td width="15">
                                <asp:TextBox ID="txtDuration" runat="server" Width="15" MaxLength="3" onkeypress="return IsNumeric(event, true);" onpatse="return false;" />
                                <asp:RequiredFieldValidator ID="rfvDuration" runat="server" ControlToValidate="txtDuration" InitialValuepositive="" ValidationGroup="vgExam"
                                    ErrorMessage="Please enter Duration." Display="None" />
                            </td>
                        </tr>
                        <tr>
                            <th class="noborder">Description:</th>
                            <td>
                                <asp:TextBox ID="txtDescription" runat="server" TextMode="MultiLine" Rows="3" Width="100%" />
                                <asp:RequiredFieldValidator ID="rfvDescription" runat="server" ControlToValidate="txtDescription" InitialValue="" ValidationGroup="vgExam"
                                    ErrorMessage="Please enter Description." Display="None" /></td>
                            <th class="noborder" align="right">Pass Percentage:</th>
                            <td>
                                <asp:TextBox ID="txtPassPercentage" runat="server" Width="15" MaxLength="3" onkeypress="return IsNumeric(event, true);" onpatse="return false;" Text="80" />
                                <asp:RequiredFieldValidator ID="rfvPassPercentage" runat="server" ControlToValidate="txtPassPercentage" InitialValue="" ValidationGroup="vgExam"
                                    ErrorMessage="Please enter Pass Percentage." Display="None" />
                            </td>
                        </tr>
                        <tr>
                            <th class="noborder">Designation:</th>
                            <td>
                                <%--<asp:DropDownList ID="ddlDesignation" runat="server" />
                        <asp:RequiredFieldValidator ID="rfvDesignation" runat="server" ControlToValidate="ddlDesignation" InitialValue="0" ValidationGroup="vgExam"
                            ErrorMessage="Please select Designation." Display="None" />--%>
                                <%--<asp:UpdatePanel ID="upnlDesignationFrozen" runat="server" RenderMode="Inline">
                                        <ContentTemplate>--%>
                                <%--<asp:DropDownCheckBoxes ID="ddlDesigAptitude" runat="server" UseSelectAllNode="false" AutoPostBack="false">
                            <style selectboxwidth="195" dropdownboxboxwidth="120" dropdownboxboxheight="150" />
                        </asp:DropDownCheckBoxes>--%>
                                <asp:ListBox ID="ddlDesigAptitude" runat="server" Width="150" ClientIDMode="AutoID" SelectionMode="Multiple"
                                    CssClass="chosen-select" data-placeholder="Select"
                                    AutoPostBack="false" />

                                <asp:CustomValidator ID="cvalidatorDesignationAptitude" runat="server" ValidationGroup="Submit" ErrorMessage="Please Select Designation" Display="None" ClientValidationFunction="checkddlDesigAptitude"></asp:CustomValidator>
                                <%--</ContentTemplate>
                                    </asp:UpdatePanel>--%>
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
                                            <asp:UpdatePanel ID="upQuestions" runat="server" UpdateMode="Conditional">
                                                <ContentTemplate>
                                                    <asp:Repeater ID="repQuestions" runat="server" OnItemCommand="repQuestions_ItemCommand" OnItemCreated="repQuestions_ItemCreated">
                                                        <HeaderTemplate>
                                                            <table class="question-list" width="100%" cellpadding="0" cellspacing="0" border="0">
                                                        </HeaderTemplate>
                                                        <ItemTemplate>
                                                            <tr class="question">
                                                                <td width="15" align="center" valign="top">
                                                                    <%# (Container.ItemIndex + 1) + "." %>
                                                                </td>
                                                                <td valign="top">
                                                                    <asp:HiddenField ID="hdnQuestionID" runat="server" Value='<%# Eval("QuestionID") %>' />
                                                                    <asp:HiddenField ID="hdnQuestionUniqueID" runat="server" Value='<%# Eval("QuestionUniqueID") %>' />
                                                                    <asp:TextBox ID="txtQuestion" runat="server" TextMode="MultiLine" Rows="2" Width="100%"
                                                                        Text='<%# Eval("Question") %>' />
                                                                    <asp:RequiredFieldValidator ID="rfvQuestion" runat="server" ControlToValidate="txtQuestion" InitialValue="" ValidationGroup="vgExam"
                                                                        ErrorMessage='<%# "Please enter Question " + (Container.ItemIndex + 1) + "." %>' Display="None" />
                                                                </td>
                                                                <td width="250" valign="top" align="right">
                                                                    <b>Positive Marks</b> :
                                                    <asp:TextBox ID="txtPositiveMarks" runat="server" Width="15" Text='<%# String.IsNullOrEmpty(Eval("PositiveMarks").ToString()) == true ? "1":  Eval("PositiveMarks").ToString() %>' onkeypress="return IsNumeric(event, true);" onpatse="return false;" />
                                                                    <b>Negetive Marks</b> :
                                                    <asp:TextBox ID="txtNegetiveMarks" runat="server" Width="15" Text='<%# String.IsNullOrEmpty(Eval("NegetiveMarks").ToString()) == true ? "1":  Eval("NegetiveMarks").ToString() %>' onkeypress="return IsNumeric(event, true);" onpatse="return false;" />
                                                                    <asp:RequiredFieldValidator ID="rfvPositiveMarks" runat="server" ControlToValidate="txtPositiveMarks" InitialValue="" ValidationGroup="vgExam"
                                                                        ErrorMessage="Please enter Positive Marks." Display="None" />
                                                                    <asp:RequiredFieldValidator ID="rfvNegetiveMarks" runat="server" ControlToValidate="txtNegetiveMarks" InitialValue="" ValidationGroup="vgExam"
                                                                        ErrorMessage="Please enter Negetive Marks." Display="None" />
                                                                </td>
                                                            </tr>
                                                            <tr>
                                                                <td colspan="3">
                                                                    <asp:Repeater ID="repOptions" runat="server" DataSource='<%# GetOptionsByQuestionID(Convert.ToString(Eval("QuestionUniqueID"))) %>'>
                                                                        <HeaderTemplate>
                                                                            <ol class="option-list" style="margin-bottom: 0;">
                                                                        </HeaderTemplate>
                                                                        <ItemTemplate>
                                                                            <li class='<%# IsCorrectAnswer(Convert.ToString(Eval("QuestionUniqueID")), Convert.ToString(Eval("OptionUniqueID")))? "answer": "" %>'>
                                                                                <asp:HiddenField ID="hdnOptionID" runat="server" Value='<%# Eval("OptionID") %>' />
                                                                                <asp:HiddenField ID="hdnOptionUniqueID" runat="server" Value='<%# Eval("OptionUniqueID") %>' />
                                                                                <input id="hdnIsAnswer" type="hidden" runat="server" class="validanswer" />
                                                                                <asp:TextBox ID="txtOptionText" runat="server" Width="200" Text='<%# Eval("OptionText") %>' />&nbsp;
                                                                <asp:RadioButton ID="rdoIsAnswer" runat="server" ClientIDMode="AutoID" data-radioname='<%# "Q" + Eval("QuestionUniqueID") %>'
                                                                    Checked='<%# IsCorrectAnswer(Convert.ToString(Eval("QuestionUniqueID")), Convert.ToString(Eval("OptionUniqueID")))%>' />
                                                                                <asp:RequiredFieldValidator ID="rfvOptionText" runat="server" ControlToValidate="txtOptionText" InitialValue="" ValidationGroup="vgExam"
                                                                                    ErrorMessage='<%# "Please enter Option " + (Container.ItemIndex + 1) + "." %>' Display="None" />
                                                                            </li>
                                                                        </ItemTemplate>
                                                                        <FooterTemplate>
                                                                            </ol>
                                                                        </FooterTemplate>
                                                                    </asp:Repeater>
                                                                </td>
                                                            </tr>
                                                            <tr>
                                                                <td colspan="3" style="padding-bottom: 10px; padding-left: 25px;">
                                                                    <asp:LinkButton ID="lbtnSaveMCQ" ClientIDMode="AutoID" runat="server" Text="Save Question" CommandName="SaveMcQ" />
                                                                </td>
                                                            </tr>
                                                        </ItemTemplate>
                                                        <FooterTemplate>
                                                            </table>
                                                        </FooterTemplate>
                                                    </asp:Repeater>
                                                </ContentTemplate>

                                            </asp:UpdatePanel>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td style="padding-top: 20px;">
                                            <asp:LinkButton ID="lbtnAddQuestion" runat="server" Text="Add New Question" OnClick="lbtnAddQuestion_Click" />
                                        </td>
                                    </tr>
                                </table>
                            </td>
                        </tr>
                        <tr>
                            <td colspan="3">
                                <div class="btn_sec">
                                    <asp:Button ID="btnSaveExam" runat="server" Text="Save Exam" CssClass="ui-button" ValidationGroup="vgExam" OnClick="btnSaveExam_Click" />
                                </div>
                            </td>
                            <td align="rigt">
                                <a href='<%=Page.ResolveUrl("~/sr_app/manage-aptitude-tests.aspx") %>'>Aptitude Tests</a>
                            </td>
                    </table>
                    </tr>

                </ContentTemplate>
            </asp:UpdatePanel>

        </div>
    </div>
    <script type="text/javascript" src="<%=Page.ResolveUrl("~/js/chosen.jquery.js")%>"></script>
    <script type="text/javascript">
        function rdoIsAnswer_Click(sender) {
            var $sender = $(sender);
            $('input[data-id="' + $sender.attr('data-id') + '"]').prop('checked', false);
            $sender.prop('checked', true);
        }

        //Mark Valid answer
        function ApplyMarkValidAnswer() {

            $("span[data-radioname]").each(function () {
                $(this).children('input:radio').change(function () {
                    $($(this).closest('ol')).children('li').each(function () {
                        $(this).children('.validanswer').val('');
                    });
                    //   console.log($($(this).parent()).parent());
                    $($($(this).parent()).parent()).children('.validanswer').val('1');
                    //console.log(  $(this).parent().children('.validanswer').val('1'));
                });
            });
        }

        // check if user has selected any designations or not.
        function checkddlDesigAptitude(oSrc, args) {
            args.IsValid = ($("#<%= ddlDesigAptitude.ClientID%> input:checked").length > 0);
        }

        $(document).ready(function () {
            Intialize();
        });

        function Intialize() {
            ChosenDropDown();
            ApplyQuestionRadioName();
            ApplyMarkValidAnswer();
        }

        function ChosenDropDown(options) {
            var _options = options || {};
            $('.chosen-select').chosen(_options);
        }

        var prmTaskGenerator = Sys.WebForms.PageRequestManager.getInstance();

        prmTaskGenerator.add_endRequest(function () {
            Intialize();
        });

        function ApplyQuestionRadioName() {

            $("span[data-radioname]").each(function () {
                $(this).children('input:radio').attr("name", $(this).attr('data-radioname'));
            });
        }

    </script>
</asp:Content>
