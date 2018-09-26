<%@ Page Title="" Language="C#" MasterPageFile="~/Sr_App/SR_app.Master" AutoEventWireup="true" CodeBehind="html-template-maintainance.aspx.cs"
    Inherits="JG_Prospect.Sr_App.html_template_maintainance" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <link href="../css/bootstrap-datepicker.css" rel="stylesheet" />
    <link href="../css/jquery.timepicker.css" rel="stylesheet" />
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
        <h1>Maintainance</h1>
        <div style="padding: 5px;">
            <table>
                <tr>
                    <td>
                        <label>Company Address</label>
                    </td>
                    <td>
                        <asp:TextBox ID="txtCompanyAddress" runat="server" CssClass="cls_textbox"></asp:TextBox>
                    </td>
                    <td>
                        <label>Zip</label>
                    </td>
                    <td>
                        <asp:TextBox ID="txtZip" runat="server" CssClass="cls_textbox"></asp:TextBox>
                    </td>
                    <td>
                        <label>City</label>
                    </td>
                    <td>
                        <asp:TextBox ID="txtCity" runat="server" CssClass="cls_textbox"></asp:TextBox>
                    </td>

                    <td>
                        <label>State<span></span></label>
                    </td>
                    <td>
                        <asp:TextBox ID="txtState" runat="server" CssClass="cls_textbox"></asp:TextBox>
                    </td>
                    <td>
                        <asp:HiddenField ID="hdnCompanyAddressId" runat="server" />
                        <div class="btn_sec">
                            <input type="button" id="btnupdate" runat="server" style="width: 80px;" onclick="UpdateCompanyAddress();" value="Update" />
                        </div>
                    </td>
                </tr>
            </table>
            <br />
            <h3>HR Auto Email Templates</h3>
            <div id="tabs">
                <ul>
                    <li><a href="#emailtemplates">Email Templates</a></li>
                    <li><a href="#smstemplates">SMS Templates</a></li>
                </ul>
                <div id="emailtemplates">
                    <asp:GridView ID="grdTemplates_HRAutoEmail" runat="server" AutoGenerateColumns="false" DataKeyNames="Id"
                        CssClass="table" Width="100%" CellSpacing="0" CellPadding="0" EmptyDataText="No Email templates found!!" GridLines="Vertical">
                        <EmptyDataRowStyle ForeColor="White" HorizontalAlign="Center" />
                        <HeaderStyle CssClass="trHeader " />
                        <RowStyle CssClass="FirstRow" BorderStyle="Solid" />
                        <AlternatingRowStyle CssClass="AlternateRow " />
                        <Columns>
                            <asp:TemplateField HeaderText="Name">
                                <ItemTemplate>
                                    <asp:HyperLink ID="hypEdit" ForeColor="Blue" runat="server" Text='<%# Eval("Name") %>'
                                        NavigateUrl='<%# Page.ResolveUrl("~/Sr_App/edit-html-template.aspx?MasterId=" + Eval("Id") + 
                                                "&Type="+ Convert.ToByte(JG_Prospect.Common.HTMLTemplateTypes.AutoEmailTemplate).ToString() +
                                                "&Category="+ Eval("Category")) %>' />
                                </ItemTemplate>
                            </asp:TemplateField>
                            <asp:TemplateField HeaderText="From Email">
                                <ItemTemplate>
                                    <span data-id='<%#Eval("Id") %>' class="tempFromID  ui-helper-clearfix"><%# String.IsNullOrEmpty(Eval("FromID").ToString())== true?"N.A.":Eval("FromID") %></span>
                                </ItemTemplate>
                            </asp:TemplateField>
                            <asp:TemplateField HeaderText="Subject">
                                <ItemTemplate>
                                    <span data-id='<%#Eval("Id") %>' class="tempSubject  ui-helper-clearfix"><%# String.IsNullOrEmpty(Eval("Subject").ToString())== true?"N.A.":Eval("Subject") %></span>
                                </ItemTemplate>
                            </asp:TemplateField>
                            <asp:TemplateField HeaderText="Trigger for Email">
                                <ItemTemplate>
                                    <span data-id='<%#Eval("Id") %>' class="tempTriggerText  ui-helper-clearfix"><%# String.IsNullOrEmpty(Eval("TriggerText").ToString())== true?"N.A.":Eval("TriggerText") %></span>
                                </ItemTemplate>
                            </asp:TemplateField>
                            <asp:TemplateField HeaderText="Frequency">
                                <ItemTemplate>
                                    <span data-id='<%#Eval("Id") %>' class='<%# String.IsNullOrEmpty(Eval("FrequencyInDays").ToString()) == true? "hide" : "" %>'>Repeates: Every <%# Eval("FrequencyInDays") %> Days</span>
                                    <br />
                                    <span data-id='<%#Eval("Id") %>' class='<%# String.IsNullOrEmpty(Eval("FrequencyStartDate").ToString()) == true? "hide" : "" %>'>Starts on <%# String.IsNullOrEmpty(Eval("FrequencyStartDate").ToString()) == true? "" : String.Format("{0: MM/dd/yy}", Convert.ToDateTime( Eval("FrequencyStartDate"))) %> at <%# String.IsNullOrEmpty(Eval("FrequencyStartTime").ToString()) == true? "" : String.Format("{0: hh:mm tt}", Eval("FrequencyStartTime")) %></span>
                                    <br />
                                    <a data-id='<%#Eval("Id") %>' onclick="javascript:openFrequencyEditArea(this);" href="javascript:void(0);">Edit</a> &nbsp;|&nbsp;<a data-id='<%#Eval("Id") %>' onclick="javascript:triggerBulkAutoEmail(this);" href="javascript:void(0);">Send</a>
                                    <table id='tblFreq<%#Eval("Id") %>' class="hide table">
                                        <tr>
                                            <td colspan="2"><strong>Frequency</strong></td>
                                        </tr>
                                        <tr>
                                            <td>Repeate in Days:</td>
                                            <td>
                                                <input type="text" class="textbox" style="width: 20px;" data-type="frdays" value='<%#Eval("FrequencyInDays") %>' /></td>
                                        </tr>
                                        <tr>
                                            <td>Starts on Date:</td>
                                            <td>
                                                <input type="text" class="textbox" style="width: 90px;" data-type="frdate" value='<%#String.IsNullOrEmpty(Eval("FrequencyStartDate").ToString()) == true? "" : String.Format("{0: MM/dd/yy}", Convert.ToDateTime( Eval("FrequencyStartDate"))) %>' /></td>
                                        </tr>
                                        <tr>
                                            <td>Email will be sent at:</td>
                                            <td>
                                                <input type="text" class="textbox time ui-timepicker-input" style="width: 90px;" data-type="frtime" value='<%#String.IsNullOrEmpty(Eval("FrequencyStartTime").ToString()) == true? "" : String.Format("{0: hh:mm tt}", Eval("FrequencyStartTime")) %>' /></td>
                                        </tr>
                                        <tr>
                                            <td><a data-id='<%#Eval("Id")%>' onclick="javascript:saveTemplateFrequency(this);" href="javascript:void(0);">Save</a></td>
                                        </tr>
                                    </table>
                                </ItemTemplate>
                            </asp:TemplateField>
                        </Columns>
                    </asp:GridView>
                </div>
                <div id="smstemplates">
                    <asp:GridView ID="gvSMSTemplates" runat="server" AutoGenerateColumns="false" DataKeyNames="Id"
                        CssClass="table" Width="100%" CellSpacing="0" CellPadding="0" GridLines="Vertical" EmptyDataText="No SMS templates found!!">
                        <EmptyDataRowStyle ForeColor="White" HorizontalAlign="Center" />
                        <HeaderStyle CssClass="trHeader " />
                        <RowStyle CssClass="FirstRow" BorderStyle="Solid" />
                        <AlternatingRowStyle CssClass="AlternateRow " />
                        <Columns>
                            <asp:TemplateField HeaderText="Name">
                                <ItemTemplate>
                                    <asp:HyperLink ID="hypEdit" ForeColor="Blue" runat="server" Text='<%# Eval("Name") %>'
                                        NavigateUrl='<%# Page.ResolveUrl("~/Sr_App/edit-sms-template.aspx?MasterId=" + Eval("Id") + 
                                                "&Type="+ Convert.ToByte(JG_Prospect.Common.HTMLTemplateTypes.AutoEmailTemplate).ToString() +
                                                "&Category="+ Eval("Category")) %>' />
                                </ItemTemplate>
                            </asp:TemplateField>
                            <asp:TemplateField HeaderText="From Mobile Number">
                                <ItemTemplate>
                                    <span data-id='<%#Eval("Id") %>' class="tempFromID  ui-helper-clearfix"><%# String.IsNullOrEmpty(Eval("FromID").ToString())== true?"N.A.":Eval("FromID") %></span>
                                </ItemTemplate>
                            </asp:TemplateField>
                            <%--<asp:TemplateField HeaderText="Subject">
                                <ItemTemplate>
                                    <span data-id='<%#Eval("Id") %>' class="tempSubject  ui-helper-clearfix"><%# String.IsNullOrEmpty(Eval("Subject").ToString())== true?"N.A.":Eval("Subject") %></span>
                                </ItemTemplate>
                            </asp:TemplateField>--%>
                            <asp:TemplateField HeaderText="Trigger for SMS">
                                <ItemTemplate>
                                    <span data-id='<%#Eval("Id") %>' class="tempTriggerText  ui-helper-clearfix"><%# String.IsNullOrEmpty(Eval("TriggerText").ToString())== true?"N.A.":Eval("TriggerText") %></span>
                                </ItemTemplate>
                            </asp:TemplateField>
                            <asp:TemplateField HeaderText="Frequency">
                                <ItemTemplate>
                                    <span data-id='<%#Eval("Id") %>' class='<%# String.IsNullOrEmpty(Eval("FrequencyInDays").ToString()) == true? "hide" : "" %>'>Repeates: Every <%# Eval("FrequencyInDays") %> Days</span>
                                    <br />
                                    <span data-id='<%#Eval("Id") %>' class='<%# String.IsNullOrEmpty(Eval("FrequencyStartDate").ToString()) == true? "hide" : "" %>'>Starts on <%# String.IsNullOrEmpty(Eval("FrequencyStartDate").ToString()) == true? "" : String.Format("{0: MM/dd/yy}", Convert.ToDateTime( Eval("FrequencyStartDate"))) %> at <%# String.IsNullOrEmpty(Eval("FrequencyStartTime").ToString()) == true? "" : String.Format("{0: hh:mm tt}", Eval("FrequencyStartTime")) %></span>
                                    <br />
                                    <a data-id='<%#Eval("Id") %>' onclick="javascript:openFrequencyEditArea(this);" href="javascript:void(0);">Edit</a>
                                    <table id='tblFreq<%#Eval("Id") %>' class="hide table">
                                        <tr>
                                            <td colspan="2"><strong>Frequency</strong></td>
                                        </tr>
                                        <tr>
                                            <td>Repeate in Days:</td>
                                            <td>
                                                <input type="text" class="textbox" style="width: 20px;" data-type="frdays" value='<%#Eval("FrequencyInDays") %>' /></td>
                                        </tr>
                                        <tr>
                                            <td>Starts on Date:</td>
                                            <td>
                                                <input type="text" class="textbox" style="width: 90px;" data-type="frdate" value='<%#String.IsNullOrEmpty(Eval("FrequencyStartDate").ToString()) == true? "" : String.Format("{0: MM/dd/yy}", Convert.ToDateTime( Eval("FrequencyStartDate"))) %>' /></td>
                                        </tr>
                                        <tr>
                                            <td>Email will be sent at:</td>
                                            <td>
                                                <input type="text" class="textbox time ui-timepicker-input" style="width: 90px;" data-type="frtime" value='<%#String.IsNullOrEmpty(Eval("FrequencyStartTime").ToString()) == true? "" : String.Format("{0: hh:mm tt}", Eval("FrequencyStartTime")) %>' /></td>
                                        </tr>
                                        <tr>
                                            <td><a data-id='<%#Eval("Id")%>' onclick="javascript:saveTemplateFrequency(this);" href="javascript:void(0);">Save</a></td>
                                        </tr>
                                    </table>
                                </ItemTemplate>
                            </asp:TemplateField>

                        </Columns>
                    </asp:GridView>
                </div>
            </div>



            <h3>Sales Auto Email Templates</h3>
            <asp:GridView ID="grdTemplates_SalesAutoEmail" runat="server" AutoGenerateColumns="false" DataKeyNames="Id"
                CssClass="table" Width="100%" CellSpacing="0" CellPadding="0" GridLines="Vertical">
                <EmptyDataRowStyle ForeColor="White" HorizontalAlign="Center" />
                <HeaderStyle CssClass="trHeader " />
                <RowStyle CssClass="FirstRow" BorderStyle="Solid" />
                <AlternatingRowStyle CssClass="AlternateRow " />
                <Columns>
                    <asp:TemplateField HeaderText="Name">
                        <ItemTemplate>
                            <asp:HyperLink ID="HyperLink1" ForeColor="Blue" runat="server" Text='<%# Eval("Name") %>'
                                NavigateUrl='<%# Page.ResolveUrl("~/Sr_App/edit-html-template.aspx?MasterId=" + Eval("Id") + 
                                                "&Type="+ Convert.ToByte(JG_Prospect.Common.HTMLTemplateTypes.AutoEmailTemplate).ToString() +
                                                "&Category="+ Eval("Category")) %>' />
                        </ItemTemplate>
                    </asp:TemplateField>
                    <asp:TemplateField HeaderText="Subject">
                        <ItemTemplate>
                            <span data-id='<%#Eval("Id") %>' class="tempSubject  ui-helper-clearfix"><%# String.IsNullOrEmpty(Eval("Subject").ToString())== true?"N.A.":Eval("Subject") %></span>
                        </ItemTemplate>
                    </asp:TemplateField>
                </Columns>
            </asp:GridView>
            <br />
            <h3>Vendor Auto Email Templates</h3>
            <asp:GridView ID="grdTemplates_VendorAutoEmail" runat="server" AutoGenerateColumns="false" DataKeyNames="Id"
                CssClass="table" Width="100%" CellSpacing="0" CellPadding="0" GridLines="Vertical">
                <EmptyDataRowStyle ForeColor="White" HorizontalAlign="Center" />
                <HeaderStyle CssClass="trHeader " />
                <RowStyle CssClass="FirstRow" BorderStyle="Solid" />
                <AlternatingRowStyle CssClass="AlternateRow " />
                <Columns>
                    <asp:TemplateField HeaderText="Name">
                        <ItemTemplate>
                            <asp:HyperLink ID="HyperLink2" ForeColor="Blue" runat="server" Text='<%# Eval("Name") %>'
                                NavigateUrl='<%# Page.ResolveUrl("~/Sr_App/edit-html-template.aspx?MasterId=" + Eval("Id") + 
                                                "&Type="+ Convert.ToByte(JG_Prospect.Common.HTMLTemplateTypes.AutoEmailTemplate).ToString() +
                                                "&Category="+ Eval("Category")) %>' />
                        </ItemTemplate>
                    </asp:TemplateField>
                    <asp:TemplateField HeaderText="Subject">
                        <ItemTemplate>
                            <span data-id='<%#Eval("Id") %>' class="tempSubject  ui-helper-clearfix"><%# String.IsNullOrEmpty(Eval("Subject").ToString())== true?"N.A.":Eval("Subject") %></span>
                        </ItemTemplate>
                    </asp:TemplateField>
                </Columns>
            </asp:GridView>
            <br />
            <h3>Templates</h3>
            <asp:Repeater ID="repTemplates_Template" runat="server">
                <HeaderTemplate>
                    <ul style="display: block; width: 100%;">
                </HeaderTemplate>
                <ItemTemplate>
                    <li style="float: left; width: 30%; padding: 10px 10px 10px 0px;">
                        <asp:HyperLink ID="hypEdit" ForeColor="Blue" runat="server" Text='<%# Eval("Name") %>'
                            NavigateUrl='<%# Page.ResolveUrl("~/Sr_App/edit-html-template.aspx?MasterId=" + Eval("Id") + 
                                                "&Type="+ Convert.ToByte(JG_Prospect.Common.HTMLTemplateTypes.Template).ToString() +
                                                "&Category="+ Eval("Category")) %>' />
                    </li>
                </ItemTemplate>
                <FooterTemplate>
                    </ul>
                </FooterTemplate>
            </asp:Repeater>
        </div>
    </div>
    <script type="text/javascript" src="../js/jquery.timepicker.js">
    </script>
    <script type="text/javascript">
        $(document).ready(function () {
            GetComapnyAddress();
            applyInlineEditing();
        });

        function SetTabs() {
            $("#tabs").tabs();
        }

        function applyInlineEditing() {
            var editClass = [".tempFromID", ".tempSubject", ".tempTriggerText"];
            var updateMethods = ["UpdateHTMLTemplateFromId", "UpdateHTMLTemplateSubject", "UpdateHTMLTemplateTriggerText"];
            var updateParameter = ["FromID", "Subject", "TriggerText"];

            $.each(editClass, function (index, value) {
                var MethodToUpdate = updateMethods[index];
                var ParameterToUpdate = updateParameter[index];

                $(value).each(function () {

                    $(this).click(ParameterToUpdate, function () {
                        var parent = $(this).parent();
                        var TemplateIdVal = $(this).attr("data-id");
                        var textBox = $('<input rows="3" style="width:95%;" type="text">');
                        textBox.val($(this).html());
                        textBox.attr("data-id", TemplateIdVal);
                        textBox.bind('blur', ParameterToUpdate, function () { var postData = new Object; postData["TemplateId"] = TemplateIdVal; postData[ParameterToUpdate] = $(this).val(); UpdateDetailsMethod(MethodToUpdate, this, postData); });
                        parent.append(textBox);
                    });

                });

            });


        }

        function openFrequencyEditArea(link) {

            var TemplateId = $(link).attr("data-id");
            var tblFreq = $('#tblFreq' + TemplateId);
            tblFreq.removeClass("hide");
            var freqTime = tblFreq.find('input[data-type="frtime"]');
            var freqDays = tblFreq.find('input[data-type="frdays"]');
            var freqDate = tblFreq.find('input[data-type="frdate"]');

            if (freqTime) {
                freqTime.timepicker({ 'setTime': new Date(), 'timeFormat': 'h:i A' });
            }
            if (freqDays) {

            }
            if (freqDate) {
                freqDate.datepicker();
            }

        }

        function saveTemplateFrequency(link) {
            var TemplateId = $(link).attr("data-id");

            var tblFreq = $('#tblFreq' + TemplateId);

            var freqTime = tblFreq.find('input[data-type="frtime"]');
            var freqDays = tblFreq.find('input[data-type="frdays"]');
            var freqDate = tblFreq.find('input[data-type="frdate"]');

            if (freqTime && freqDays && freqDate) {
                var datetimestring = $(freqDate).val() + ' ' + $(freqTime).val();

                console.log(datetimestring);

                var frequencyDateTime = new Date(datetimestring);

                var postData = { TemplateId: TemplateId, FrequencyInDays: $(freqDays).val(), FrequencyStartDate: frequencyDateTime, FrequencyTime: frequencyDateTime };

                console.log(postData);

                var OnUpdateTemplateFreqSuccess = function (response) {

                    if (response) {
                        tblFreq.addClass('hide');
                        alert('Template frequency successfully changed!');


                    }
                    else {
                        OnUpdateTemplateFreqError();
                    }
                };

                var OnUpdateTemplateFreqError = function (OnCompletionelementToRemove) {

                    tblFreq.addClass('hide');
                    alert('Error in updating Template frequency, Please try again later!');

                };

                CallJGWebService("UpdateHTMLTemplateFreQuency", postData, OnUpdateTemplateFreqSuccess, OnUpdateTemplateFreqError);


            }

        }

        function UpdateDetailsMethod(MethodName, OnCompletionelementToRemove, postData) {

            var OnUpdateTemplateSuccess = function (response) {

                if (response) {

                    $(OnCompletionelementToRemove).parent().children().first().html($(OnCompletionelementToRemove).val());
                    OnCompletionelementToRemove.remove();

                }
                else {
                    OnUpdateTemplateError();
                }
            };

            var OnUpdateTemplateError = function (OnCompletionelementToRemove) {
                OnCompletionelementToRemove.remove();
            };

            CallJGWebService(MethodName, postData, OnUpdateTemplateSuccess, OnUpdateTemplateError);

        }

        function GetComapnyAddress() {
            $.ajax({
                type: "POST",
                url: "html-template-maintainance.aspx/GetCompanyAddress",
                // data: "{'strZip':'" + $(".list_limit li[style*='background-color: lemonchiffon']").text() + "'}",
                contentType: "application/json; charset=utf-8",
                dataType: "JSON",
                success: function (data) {
                    var response = JSON.parse(data.d);
                    $('#<%=hdnCompanyAddressId.ClientID%>').val(response.Table[0].intCompanyId);
                    $('#<%=txtCompanyAddress.ClientID%>').val(response.Table[0].strCompanyAddress);
                    $('#<%=txtCity.ClientID%>').val(response.Table[0].strCity);
                    $('#<%=txtZip.ClientID%>').val(response.Table[0].strZipCode);
                    $('#<%=txtState.ClientID%>').val(response.Table[0].strState);
                }
            });
        }
        function UpdateCompanyAddress() {
            var Id = $('#<%=hdnCompanyAddressId.ClientID%>').val();
            var CompanyAddress = $('#<%=txtCompanyAddress.ClientID%>').val();
            var CompanyCity = $('#<%=txtCity.ClientID%>').val();
            var CompanyState = $('#<%=txtState.ClientID%>').val();
            var CompanyZipCode = $('#<%=txtZip.ClientID%>').val();
            $.ajax({
                type: "POST",
                url: "html-template-maintainance.aspx/UpdateCompanyAddress",
                data: "{'Id':'" + Id + "','Address':'" + CompanyAddress + "','City':'" + CompanyCity + "','State':'" + CompanyState + "','ZipCode':'" + CompanyZipCode + "'}",
                contentType: "application/json; charset=utf-8",
                dataType: "JSON",
                success: function (data) {
                    if (data.d = 'Success') {
                        GetComapnyAddress();
                    }
                    else {
                        alert("Company address can not be updated. Please try later.");
                    }
                }
            });
        }

        function triggerBulkAutoEmail(link) {

            var HtmlTemplateId = $(link).attr("data-id");

            var OnBulkEmailSuccess = function (response) {

                if (response) {
                    alert('Emails to all candidates with status "Applicant, Refferal Applcant, InterviewDate" of all designation are sent.');

                }
                else {
                    OnBulkEmailError();
                }
            };

            var OnBulkEmailError = function (response) {
                alert('We were not able to sent emails to all candidates with status "Applicant, Refferal Applcant, InterviewDate" of all designations.');
            };

            postData = { TemplateId: HtmlTemplateId, EmailType: <%=JG_Prospect.Common.JGConstant.EmailTypes.Welcome.ToString() %> }
            CallJGWebService("TriggerBulkAutoEmail", postData, OnBulkEmailSuccess, OnBulkEmailError);

            
        }
    </script>
</asp:Content>
