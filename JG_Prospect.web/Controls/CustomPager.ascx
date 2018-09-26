<%@ Control Language="C#" AutoEventWireup="true" CodeBehind="CustomPager.ascx.cs" Inherits="JG_Prospect.Controls.CustomPager" %>

<asp:Repeater ID="rptPager" runat="server">
    <HeaderTemplate>
        <table>
            <tbody>
                <tr>
    </HeaderTemplate>
    <ItemTemplate>
        <td runat="server" visible='<%#Convert.ToBoolean(Eval("Enabled"))%>'>
            <asp:LinkButton ID="lnkPage" runat="server" CssClass='<%# Convert.ToBoolean(Eval("Enabled")) ? "page_enabled" : "page_disabled" %>'
                Text='<%#Eval("Text") %>' CommandArgument='<%# Eval("Value") %>'
                OnClientClick='<%# !Convert.ToBoolean(Eval("Enabled")) ? "return false;" : "" %>'
                OnClick="Page_Changed" ClientIDMode="AutoID" />
        </td>
        <td runat="server" visible='<%#!Convert.ToBoolean(Eval("Enabled"))%>'>
            <span><%#Eval("Text") %></span>
        </td>
    </ItemTemplate>
    <FooterTemplate>
                </tr>
            </tbody>
        </table>
    </FooterTemplate>
</asp:Repeater>
