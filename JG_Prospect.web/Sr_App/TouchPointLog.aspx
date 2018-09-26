<%@ Page Title="" Language="C#" MasterPageFile="~/Sr_App/SR_app.Master" AutoEventWireup="true" CodeBehind="TouchPointLog.aspx.cs" Inherits="JG_Prospect.Sr_App.TouchPointLog" %>

<%--<%@ Register Src="~/Sr_App/LeftPanel.ascx" TagName="LeftPanel" TagPrefix="uc2" %>--%>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <link href="../Content/touchPointlogs.css" rel="stylesheet" />
    <style type="text/css">
        
    </style>
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <script type="text/javascript" src="<%=Page.ResolveUrl("~/js/chosen.jquery.js")%>"></script>
    <script src="../js/angular/scripts/jgapp.js"></script>
    <script src="../js/angular/scripts/TaskSequence.js"></script>
    <script src="../js/angular/scripts/FrozenTask.js"></script>
    <script src="../js/TaskSequencing.js"></script>
    <script src="../js/jquery.dd.min.js"></script>
    <script src="../js/angular/scripts/ClosedTasls.js"></script>
</asp:Content>
