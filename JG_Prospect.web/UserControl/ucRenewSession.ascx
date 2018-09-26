<%@ Control Language="C#" AutoEventWireup="true" CodeBehind="ucRenewSession.ascx.cs" Inherits="JG_Prospect.UserControl.ucRenewSession" %>

<label id="intSecondsRemaining" style="color: white;"></label>
<div class="hide">
    <div id="divRenewSession" runat="server" title="Relogin">
        <p>
            You session is expired. Do you want to re-login?
        </p>
        <p style="text-align: center;">
            <input type="hidden" name="_hdnRenewSession" id="_hdnRenewSession" runat="server" value="0" />
            <asp:Button ID="btnYes" runat="server" Text="Yes" OnClientClick="return btnYes_Click(this);" OnClick="btnYes_Click" />
            <asp:Button ID="btnNo" runat="server" Text="No" OnClick="btnNo_Click" />
        </p>
    </div>
</div>

<script type="text/javascript">
    var intSecondsRemaining = <%=GetSessionTimeoutSeconds()%>;
    var sessionExpiryInterval;

    function CheckSessionExpiry() {
        intSecondsRemaining--;
        $('#intSecondsRemaining').html('You will logged out in next : ' + GetHour() + ':' + GetMinutes() + ':' + GetSeconds());
        if(intSecondsRemaining <= 60) {
            clearTimeout(sessionExpiryInterval);
            //ShowPopupWithTitle('<%=divRenewSession.ClientID%>','Relogin');
            var objDialog = $('#<%=divRenewSession.ClientID%>').dialog();
            // this will enable postback from dialog buttons.
            objDialog.parent().appendTo(jQuery("form:first"));
        }
        else {
            sessionExpiryInterval = setTimeout(CheckSessionExpiry, 1000);
        }
    }
    
    function GetHour() {
        var h = parseInt(intSecondsRemaining/3600);
        return h > 0? h : 0;
    }

    function GetMinutes() {
        var m = parseInt((intSecondsRemaining % 3600)/60);
        return m > 0 ? m: 0;
    }

    function GetSeconds() {
        return (intSecondsRemaining % 60);
    }

    sessionExpiryInterval = setTimeout(CheckSessionExpiry, 1000);

    function btnYes_Click(sender) {
        $('#<%=_hdnRenewSession.ClientID%>').val('1');

        return true;
    }

</script>
