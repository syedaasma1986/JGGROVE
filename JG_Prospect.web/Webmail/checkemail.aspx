<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="checkemail.aspx.cs" Inherits="JG_Prospect.WebMImpl.checkemail" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title></title>
</head>
<body onload="onLoadSubmit();">
    <form id="form1" action="http://webmail.jmgrovebuildingsupply.com/show-emails.aspx" target="_self" method="post">
        <input type="hidden" name="un" value="jgrove@jmgroveconstruction.com"/>
        <input type="hidden" name="pw" value="Hockey10!"/>
   
        
    </form>
    
    <script>
        function onLoadSubmit() {
            var formtoSubmit = document.getElementById('form1');
            if (form1) {
                form1.submit();
            }
        }
    </script>
</body>
</html>
