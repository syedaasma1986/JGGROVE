<%@ Page Title="" Language="C#" MasterPageFile="~/Sr_App/SR_app.Master" AutoEventWireup="true" CodeBehind="manage-aptitude-tests.aspx.cs"
    Inherits="JG_Prospect.Sr_App.manage_aptitude_tests" %>

<%@ Register TagPrefix="asp" Namespace="Saplin.Controls" Assembly="DropDownCheckBoxes" %>

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
        <h1>Aptitude Tests</h1>
        <div class="form_panel_custom">
            <asp:UpdatePanel ID="upExams" runat="server" UpdateMode="Conditional">
                <ContentTemplate>
                    <table width="100%">
                        <tr>
                            <td>Filter Tests by Designation:
                        <%--<asp:DropDownList ID="ddlDesignation" runat="server" AutoPostBack="true" OnSelectedIndexChanged="ddlDesignation_SelectedIndexChanged" />--%>
                                <asp:UpdatePanel ID="upnlDesignationFrozen" runat="server" RenderMode="Inline">
                                    <ContentTemplate>
                                        <asp:DropDownCheckBoxes ID="ddlDesigAptitude" runat="server" UseSelectAllNode="false" AutoPostBack="true" OnSelectedIndexChanged="ddlDesigAptitude_SelectedIndexChanged">
                                            <Style SelectBoxWidth="195" DropDownBoxBoxWidth="120" DropDownBoxBoxHeight="150" />
                                        </asp:DropDownCheckBoxes>
                                        <asp:CustomValidator ID="cvalidatorddlDesigAptitude" runat="server" ValidationGroup="Submit" ErrorMessage="Please Select Designation" Display="None" ClientValidationFunction="checkddlDesigAptitude"></asp:CustomValidator>
                                    </ContentTemplate>
                                </asp:UpdatePanel>
                            </td>
                        </tr>
                        <tr>
                            <td align="right">
                                <a href='<%=Page.ResolveUrl("~/sr_app/add-edit-aptitude-test.aspx") %>'>Add New Aptitude Test</a>
                            </td>
                        </tr>
                        <tr>
                            <td>
                                <asp:GridView ID="grdExams" runat="server" AutoGenerateColumns="false" DataKeyNames="ExamId"
                                    CssClass="table" Width="100%" CellSpacing="0" CellPadding="0" GridLines="Vertical" OnRowDataBound="grdExams_RowDataBound">
                                    <EmptyDataRowStyle ForeColor="White" HorizontalAlign="Center" BackColor="Black" Height="30" VerticalAlign="Middle" />
                                    <HeaderStyle CssClass="trHeader " />
                                    <RowStyle CssClass="FirstRow" BorderStyle="Solid" />
                                    <AlternatingRowStyle CssClass="AlternateRow " />
                                    <EmptyDataTemplate>
                                        No records to display.
                                    </EmptyDataTemplate>
                                    <Columns>
                                        <asp:TemplateField HeaderText="Name">
                                            <ItemTemplate>
                                                <a href='<%# string.Format("{0}?ExamID={1}", Page.ResolveUrl("~/sr_app/view-aptitude-test.aspx"), Eval("ExamID")) %>'><%# Eval("ExamTitle") %></a>
                                            </ItemTemplate>
                                        </asp:TemplateField>
                                        <asp:TemplateField HeaderText="Description">
                                            <ItemTemplate>
                                                <%# Eval("ExamDescription") %>
                                            </ItemTemplate>
                                        </asp:TemplateField>
                                        <asp:TemplateField HeaderText="Duration">
                                            <ItemTemplate>
                                                <%# Eval("ExamDuration") %>
                                            </ItemTemplate>
                                        </asp:TemplateField>
                                        <asp:TemplateField HeaderText="Pass Percentage">
                                            <ItemTemplate>
                                                <%# Eval("PassPercentage") %>
                                            </ItemTemplate>
                                        </asp:TemplateField>
                                        <asp:TemplateField HeaderText="Active">
                                            <ItemTemplate>
                                                <img src='<%# Convert.ToBoolean(Eval("IsActive")) ? Page.ResolveUrl("~/img/success.png") : Page.ResolveUrl("~/img/error.png") %>' />
                                            </ItemTemplate>
                                        </asp:TemplateField>
                                        <asp:TemplateField HeaderText="Designation">
                                            <ItemTemplate>
                                                <asp:ListBox ID="ddcbDesig" runat="server" Width="150" ClientIDMode="AutoID" SelectionMode="Multiple"
                                                    CssClass="chosen-select" data-placeholder="Select"
                                                    AutoPostBack="false" />
                                            </ItemTemplate>
                                        </asp:TemplateField>
                                        <asp:TemplateField HeaderText="">
                                            <ItemTemplate>
                                                <a href='<%# string.Format("{0}?ExamID={1}", Page.ResolveUrl("~/sr_app/add-edit-aptitude-test.aspx"), Eval("ExamID")) %>'>Edit</a>
                                            </ItemTemplate>
                                        </asp:TemplateField>
                                    </Columns>
                                </asp:GridView>
                            </td>
                        </tr>
                        <tr>
                            <td align="right">
                                <a href='<%=Page.ResolveUrl("~/sr_app/add-edit-aptitude-test.aspx") %>'>Add New Aptitude Test</a>
                            </td>
                        </tr>
                    </table>
                </ContentTemplate>
            </asp:UpdatePanel>
        </div>
    </div>
    
    <script type="text/javascript" src="<%=Page.ResolveUrl("~/js/chosen.jquery.js")%>"></script>
    <script type="text/javascript">
        // check if user has selected any designations or not.
        function checkddlDesigAptitude(oSrc, args) {
            args.IsValid = ($("#<%= ddlDesigAptitude.ClientID%> input:checked").length > 0);
        }

        $(document).ready(function () {
            Intialize();
        });

        function Intialize() {
            ChosenDropDown();
        }
        function ChosenDropDown(options) {
            var _options = options || {};
            $('.chosen-select').chosen(_options);
        }
        function EditTestsDesignations(sender) {

            ShowAjaxLoader();

            var $sender = $(sender);
            var intExamID = parseInt($sender.attr('data-examid'));            
            //var arrAllDesignations = [];
            var arrAssignedDesign = [];

            $sender.find('option').each(function (index, item) {
                var intDesignId = parseInt($(item).attr('value'));

                if (intDesignId > 0) {
                    if ($.inArray(intDesignId.toString(), $sender.val()) != -1) {
                        arrAssignedDesign.push(intDesignId);
                    }                    
                }
            });

            var postData = {
                "intExamId": intExamID,
                "Designations": arrAssignedDesign.join()              
            };

             CallJGWebServiceCommon('SaveExamDesignation', postData, function (data) { OnExamSaveDesignationsSuccess(data, sender) });

            function OnExamSaveDesignationsSuccess(data, sender) {
                HideAjaxLoader();
                alert("Designation saved successfully.");

            }

        }

    </script>
</asp:Content>
