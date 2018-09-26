<%@ Page Title="" Language="C#" MasterPageFile="~/Sr_App/SR_app.Master" AutoEventWireup="true" ValidateRequest="false"
    CodeBehind="edit-html-template.aspx.cs" Inherits="JG_Prospect.Sr_App.edit_html_template" %>

<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit.HTMLEditor" TagPrefix="asp" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <style>
        .GrdBtnAdd {
            margin-top: 12px;
            height: 30px;
            background: url(img/main-header-bg.png) repeat-x;
            color: #fff;
            width: 75px;
        }
    </style>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <div class="right_panel">
        <!-- appointment tabs section start -->
        <ul class="appointment_tab">
            <li><a href="Price_control.aspx">Product Line Estimate</a></li>
            <li><a href="Inventory.aspx">Inventory</a></li>
            <li><a href="Maintenace.aspx">Maintainance</a></li>
            <li><a href="html-template-maintainance.aspx">Maintainance New</a></li>
        </ul>
        <!-- appointment tabs section end -->
        <h1>Edit Email Templates</h1>
        <div style="padding: 5px;">
            <asp:ValidationSummary ID="vsTemplate" runat="server" ShowMessageBox="true" ShowSummary="false" ValidationGroup="vgTemplate" />
            <asp:UpdatePanel ID="upUpdateTemplate" runat="server">
                <ContentTemplate>
                    <table width="100%">
                        <tr>
                            <%--<td width="80" valign="top">Name:
                            </td>--%>
                            <td>
                                <b>Email Template Name:</b><br />
                                <asp:TextBox ID="txtName" runat="server" ReadOnly="true" Enabled="false" Width="500px" />
                            </td>
                        </tr>
                        <tr id="trCategory" runat="server">
                            <td>
                                <b>Category:</b><br />
                                <asp:DropDownList ID="ddlCategory" runat="server" />
                                <asp:RequiredFieldValidator ID="rfvCategory" runat="server" ControlToValidate="ddlCategory"
                                    InitialValue="0" ValidationGroup="vgTemplate" Display="None"
                                    ErrorMessage="Please select category." />
                            </td>
                        </tr>
                        <tr>
                            <%--  <td valign="top">Designation:
                            </td>--%>
                            <td>
                                <b>Used For Designation:</b><br />

                                <asp:DropDownList ID="ddlDesignation" runat="server" AutoPostBack="true" OnSelectedIndexChanged="ddlDesignation_SelectedIndexChanged" />
                                <asp:RequiredFieldValidator ID="rfvDesignation" runat="server" ControlToValidate="ddlDesignation"
                                    InitialValue="0" ValidationGroup="vgTemplate" Visible="false" Display="None"
                                    ErrorMessage="Please select designation." />
                                <br />
                                <br />
                                <table id="tblPayRates" runat="server" visible="false" style="width: 100%">
                                    <tr>
                                        <td style="vertical-align: top; width: 10%;">EmploymentType: <i class="redtext">*</i>
                                            <br />
                                            <asp:Button ID="btnSaveRate" runat="server" OnClientClick="javascript:return SaveDesignationRate();" CssClass="GrdBtnAdd" ValidationGroup="VGPayRate" Text="Save" />
                                        </td>
                                        <td style="vertical-align: top; width: 15%;">
                                            <asp:DropDownList ID="ddlEmpType" runat="server" CssClass="textbox" AutoPostBack="false">
                                                <asp:ListItem Text="--Select--" Value="0"></asp:ListItem>
                                                <asp:ListItem Text="Part Time - Remote" Value="1"></asp:ListItem>
                                                <asp:ListItem Text="Full Time - Remote" Value="2"></asp:ListItem>
                                                <asp:ListItem Text="Part Time - Onsite" Value="3"></asp:ListItem>
                                                <asp:ListItem Text="Full Time - Onsite" Value="4"></asp:ListItem>
                                                <asp:ListItem Text="Internship" Value="5"></asp:ListItem>
                                                <asp:ListItem Text="Temp" Value="6"></asp:ListItem>
                                                <asp:ListItem Text="Sub" Value="7"></asp:ListItem>
                                            </asp:DropDownList>
                                            <asp:RequiredFieldValidator ID="rfvEmpType" runat="server" ControlToValidate="ddlEmpType" InitialValue="0" Display="Dynamic" ErrorMessage="Required" CssClass="redtext" ValidationGroup="VGPayRate"></asp:RequiredFieldValidator>
                                        </td>
                                        <td style="vertical-align: top; width: 30%;">
                                            <div>
                                                Base Rate <i class="redtext">*</i>: &nbsp;&nbsp;
                                                <asp:DropDownList ID="ddlBaseCur" CssClass="textbox" runat="server">
                                                    <asp:ListItem Text="USD" Value="USD"></asp:ListItem>
                                                </asp:DropDownList>

                                                <asp:TextBox ID="txtBaseRate" MaxLength="6" Width="50" CssClass="textbox" runat="server"></asp:TextBox>
                                                <asp:RequiredFieldValidator ID="rfvBaseRate" runat="server" ControlToValidate="txtBaseRate" InitialValue="0" Display="Dynamic" ErrorMessage="Required" CssClass="redtext" ValidationGroup="VGPayRate"></asp:RequiredFieldValidator>
                                                <asp:RegularExpressionValidator ID="revBaseRate" runat="server" ValidationExpression="((\d+)((\.\d{1,2})?))$"
                                                    ErrorMessage="Only numbers upto 2 decimals allowed"
                                                    ControlToValidate="txtBaseRate" CssClass="redtext" ValidationGroup="VGPayRate" />
                                            </div>
                                            <div>
                                                Display Rate <i class="redtext">*</i>:
                                                <asp:DropDownList ID="ddlDisplayCur" CssClass="textbox" runat="server">
                                                    <asp:ListItem Text="INR" Value="INR"></asp:ListItem>
                                                </asp:DropDownList>
                                                <asp:TextBox ID="txtDisplayRate" MaxLength="6" Width="50" CssClass="textbox" runat="server"></asp:TextBox>
                                                <asp:RegularExpressionValidator ID="revDisplayRate" runat="server" ValidationExpression="((\d+)((\.\d{1,2})?))$"
                                                    ErrorMessage="Only numbers upto 2 decimals allowed"
                                                    ControlToValidate="txtDisplayRate" CssClass="redtext" ValidationGroup="VGPayRate" />
                                            </div>
                                        </td>
                                        <td>
                                            <a onclick="showpayRatesPopup();" href="javascript:void(0)">View All PayRates</a>
                                        </td>
                                    </tr>
                                </table>
                                <small class="hide">Save a separate copy, if you want, for individual designations. Master copy will be used if designation specific copy is not available.</small>
                            </td>
                        </tr>
                        <tr id="trMasterCopy" runat="server" class="hide" visible="false">
                            <td colspan="2" style="font-weight: bold;">We do not have designation specific copy for selected designation. So, we have loaded master copy in fields given below. You can modify and save designation specific copy.
                            </td>
                        </tr>
                        <tr id="trSubject" runat="server">
                            <%--<td valign="top">Subject:
                            </td>--%>
                            <td>
                                <b>Email Subject:</b><br />
                                <asp:TextBox ID="txtSubject" runat="server" MaxLength="3500" Width="90%" />
                                <asp:RequiredFieldValidator ID="rfvSubject" runat="server" ControlToValidate="txtSubject"
                                    InitialValue="" ValidationGroup="vgTemplate" Display="None"
                                    ErrorMessage="Please enter subject." />
                            </td>
                        </tr>
                        <tr>
                            <%--<td valign="top">Header:
                            </td>--%>
                            <td>
                                <b>Email Header: </b>
                                <br />
                                <asp:Editor ID="txtHeader" runat="server" Width="90%" />
                                <asp:RequiredFieldValidator ID="rfvHeader" runat="server" ControlToValidate="txtHeader"
                                    InitialValue="" ValidationGroup="vgTemplate" Display="None"
                                    ErrorMessage="Please enter header." />
                            </td>
                        </tr>
                        <tr>
                            <%--<td valign="top">Body:
                            </td>--%>
                            <td>
                                <b>Email Body:</b>
                                <br />
                                <asp:Editor ID="txtBody" runat="server" Width="90%" />
                                <asp:RequiredFieldValidator ID="rfvBody" runat="server" ControlToValidate="txtBody"
                                    InitialValue="" ValidationGroup="vgTemplate" Display="None"
                                    ErrorMessage="Please enter body." />
                            </td>
                        </tr>
                        <tr>
                            <%--<td valign="top">Footer:
                            </td>--%>
                            <td>
                                <b>Email Footer:</b><br />
                                <asp:Editor ID="txtFooter" runat="server" Width="90%" />
                                <asp:RequiredFieldValidator ID="rfvFooter" runat="server" ControlToValidate="txtFooter"
                                    InitialValue="" ValidationGroup="vgTemplate" Display="None"
                                    ErrorMessage="Please enter footer." />
                            </td>
                        </tr>
                        <tr>
                            <td colspan="3">
                                <div class="btn_sec">
                                    <asp:Button ID="btnSaveTemplate" runat="server" Text="Save" OnClick="btnSaveTemplate_Click" ValidationGroup="vgTemplate" />
                                    <asp:Button ID="btnRevertToMaster" runat="server" Text="Revert To Master" OnClick="btnRevertToMaster_Click" />
                                    <asp:Button ID="btnCancel" runat="server" Text="Cancel" OnClick="btnCancel_Click" />
                                </div>
                            </td>
                        </tr>
                    </table>
                </ContentTemplate>
            </asp:UpdatePanel>
        </div>
        <div id="payRatesPopup" class="modal hide">
            <div id="divPayRateNG" data-ng-controller="PayRateAdminController">
                <table width="100%" border="0" cellspacing="0" cellpadding="0" class="table">
                    <thead>
                        <tr class="trHeader">
                            <th width="25%">Designation</th>
                            <th width="20%">Employment Type</th>
                            <th width="20%">Base Rate ($US)</th>
                            <th width="15%">Display Rate</th>
                            <th width="20%">Display Currency</th>
                        </tr>
                    </thead>
                    <tbody>
                        <tr ng-show="PayRates.length!=0" data-ng-repeat="PayRate in PayRates" ng-class-odd="'FirstRow'" ng-class-even="'AlternateRow'" style="vertical-align: top">
                            <td width="25%">{{PayRate.DesignationName}}</td>
                            <td width="20%">{{getEmploymentType(PayRate.EmploymentType)}}</td>
                            <td width="20%">{{PayRate.BaseRate}}</td>
                            <td width="15%">{{PayRate.DisplayRate}}</td>
                            <td width="20%">{{PayRate.DisplayRateCurrencyCode}}</td>
                        </tr>
                        <tr ng-show="PayRates.length==0" ng-class="'AlternateRow'">
                            <td colspan="5" style="text-align: center;">No payrates available for selected designation! 
                            </td>
                        </tr>
                    </tbody>
                </table>
            </div>
        </div>
    </div>

    <script src='<%=Page.ResolveUrl("~/ckeditor/ckeditor.js") %>'></script>
    <script src="https://ajax.googleapis.com/ajax/libs/angularjs/1.6.4/angular-sanitize.js"></script>
    <script src="../js/angular/scripts/jgapp.js"></script>
    <script src="../js/angular/scripts/PayRates.js"></script>
    <script type="text/javascript">

        var prmEmailTemplate = Sys.WebForms.PageRequestManager.getInstance();

        prmEmailTemplate.add_beginRequest(function () {
            DestroyCKEditors();
        });

        prmEmailTemplate.add_endRequest(function () {
            EmailTemplate_Initialize();
        });

        $(document).ready(function () {
            EmailTemplate_Initialize();
        });

        var ddlDesig = '#<%=ddlDesignation.ClientID%>';
        var ddlEmpType = '#<%=ddlEmpType.ClientID%>';
        var ddlDisplayCur = '#<%=ddlDisplayCur.ClientID%>';
        var txtBaseRate = '#<%=txtBaseRate.ClientID%>';
        var txtDisplayRate = '#<%=txtDisplayRate.ClientID%>';

        function EmailTemplate_Initialize() {
            $(ddlEmpType).on('change', function () {
                GetDesignationRate();
            });
            $(ddlDesig).on('change', function () {
                GetDesignationRate();
            });

            clearRates();
            LoadDesignationRates();

        }

        function SaveDesignationRate() {

            if (Page_ClientValidate("VGPayRate")) {
                if ($(ddlDesig).val() && $(ddlDesig).val() != '0') {

                    var postData = {
                        DesignationId: $(ddlDesig).val(),
                        EmpType: $(ddlEmpType).val(),
                        BaseRate: $(txtBaseRate).val(),
                        DisplayRate: $(txtDisplayRate).val(),
                        DisplayCurrencyCode: $(ddlDisplayCur).val()
                    };

                    ShowAjaxLoader();

                    CallJGWebServiceCommon('AddDesignationPayRate', postData, function (data) { OnSaveDesignationRateSuccess() }, function (data) { OnSaveDesignationRateError() });

                    function OnSaveDesignationRateSuccess() {
                        HideAjaxLoader();
                        alert('Designation rate saved successfully');

                        // refresh rate grid.

                        return false;
                    }

                    function OnSaveDesignationRateError() {
                        HideAjaxLoader();
                        alert('Could not save designation rate now, Please try again later.');
                        return false;
                    }
                }
            }

        }

        function GetDesignationRate() {

            if ($(ddlDesig).val() && $(ddlDesig).val() != '0') {
                var postData = {
                    DesignationId: $(ddlDesig).val(),
                    EmpType: $(ddlEmpType).val()
                };

                ShowAjaxLoader();

                CallJGWebServiceCommon('GetDesignationPayRate', postData, function (data) { OnGetDesignationRateSuccess(data) }, function (data) { OnGetDesignationRateError() });

                function OnGetDesignationRateSuccess(data) {
                    HideAjaxLoader();

                    if (data) {

                        var Rates = JSON.parse(data.d)[0];

                        if (Rates) {
                            $(txtBaseRate).val(Rates.BaseRate);
                            $(txtDisplayRate).val(Rates.DisplayRate);
                            $(ddlDisplayCur).val(Rates.DisplayRateCurrencyCode);
                        }
                        else {
                            clearRates();
                        }

                    }

                    return false;
                }

                function OnGetDesignationRateError() {
                    HideAjaxLoader();
                    alert('Could not load designation rate now, Please try again later.');
                    return false;
                }
            }

        }


        function clearRates() {
            $(txtBaseRate).val('');
            $(txtDisplayRate).val('');
        }

        function LoadDesignationRates() {
            if ($(ddlDesig).val() && $(ddlDesig).val() != '0') {
                PayRateScope.getPayRates($(ddlDesig).val());
            }
        }

        var screeningDialog;
        function showpayRatesPopup() {

            $('#payRatesPopup').removeClass('hide');

            screeningDialog = $('#payRatesPopup').dialog({
                modal: false,
                height: 500,
                width: 900,
                title: "Pay Rates",
                closeOnEscape: true
            }).parent().appendTo($("#form1"));

            $('#payRatesPopup').show();

            return true;
        }

    </script>
</asp:Content>
