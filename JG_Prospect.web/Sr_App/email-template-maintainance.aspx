<%@ Page Title="" Language="C#" MasterPageFile="~/Sr_App/SR_app.Master" AutoEventWireup="true" CodeBehind="email-template-maintainance.aspx.cs" 
    Inherits="JG_Prospect.Sr_App.email_template_maintainance" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <div class="right_panel">
        <asp:GridView ID="grdHtmlTemplates" runat="server"  AutoGenerateColumns="false" DataKeyNames="Id"
            CssClass="table" Width="100%" CellSpacing="0" CellPadding="0" GridLines="Vertical"
            OnRowCommand="grdHtmlTemplates_RowCommand">
            <EmptyDataRowStyle ForeColor="White" HorizontalAlign="Center" />
            <HeaderStyle CssClass="trHeader " />
            <RowStyle CssClass="FirstRow" BorderStyle="Solid" />
            <AlternatingRowStyle CssClass="AlternateRow " />
            <Columns>
                <asp:TemplateField HeaderText="Id">
                    <ItemTemplate>
                        <asp:HyperLink ID="hypEdit" runat="server" Text='<%#Eval("Id")%>' NavigateUrl='<%# Page.ResolveUrl("~/Sr_App/edit-email-template.aspx?MasterId=" + Eval("Id")) %>' />
                    </ItemTemplate>
                </asp:TemplateField>
                <asp:TemplateField HeaderText="Name">
                    <ItemTemplate>
                        <%# Eval("Name") %>
                    </ItemTemplate>
                </asp:TemplateField>
                <asp:TemplateField HeaderText="Subject">
                    <ItemTemplate>
                        <%# Eval("Subject") %>
                    </ItemTemplate>
                </asp:TemplateField>
            </Columns>
        </asp:GridView>
    </div>
</asp:Content>
