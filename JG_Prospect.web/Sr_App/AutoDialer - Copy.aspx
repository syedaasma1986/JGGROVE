<%@ Page Title="" Language="C#" MasterPageFile="~/Sr_App/SR_app.Master" AutoEventWireup="true" CodeBehind="AutoDialer.aspx.cs" Inherits="JG_Prospect.Sr_App.AutoDialer" %>

<%@ Register Src="~/Controls/_UserGridPhonePopup.ascx" TagPrefix="uc1" TagName="_UserGridPhonePopup" %>


<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <link href="../Controls/user-grid.css" rel="stylesheet" />
    <style>
        .dialer-container div#phone {
            width: 23%;
            float: left;
        }

        div#wrapper {
            text-align: left;
        }

        .dialer-right > div {
            z-index: 101;
            border: 1px solid #bbb;
            border-radius: 5px;
            background: #fff;
        }

        .dialer-right {
            float: left;
            width: 76.8%;
        }

            .dialer-right div.scrips {
                min-height: 539px;
                    padding: 5px;
            }

            

        div.userlist-grid {
            float: left;
            width: 100%;
            background: #fff;
        }
    </style>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <link href="../css/chosen.css" rel="stylesheet" />
    <script type="text/javascript" src="<%=Page.ResolveUrl("~/js/chosen.jquery.js")%>"></script>
    <script src="../js/angular/scripts/jgapp.js"></script>
    <script src="../js/angular/scripts/TaskSequence.js"></script>
    <script src="../js/angular/scripts/FrozenTask.js"></script>
    <script src="../js/TaskSequencing.js"></script>
    <script src="../js/jquery.dd.min.js"></script>
    <script src="../js/angular/scripts/ClosedTasls.js"></script>
    <script src="../js/angular/scripts/Phone.js"></script>
    <div class="dialer-container">
        <div id="wrapper">
            <div id="phone">
                <div id="numberDisplay">
                    <input type="text" name="to" value="" id="to" placeholder="Phone number">
                </div>
                <div id="dialpad" class="button-3">
                    <ul>
                        <li class="first">1</li>
                        <li>2</li>
                        <li class="last">3</li>
                        <li class="first">4</li>
                        <li>5</li>
                        <li class="last">6</li>
                        <li class="first">7</li>
                        <li>8</li>
                        <li class="last">9</li>
                        <li class="first">*</li>
                        <li>0</li>
                        <li class="last">#</li>
                    </ul>
                </div>
                <div id="actions" class="button-3 deactive">
                    <ul>
                        <li class="call" id="make_call" onclick="call();">Call</li>
                        <li class="skip">Skip</li>
                        <li class="clear" onclick="hangup();">Clear</li>
                    </ul>
                </div>
                <div class="button-3">
                    <span class="label" id="status_txt"></span>
                    <span id="callDuration">00:00:00</span>
                </div>
                <div class="play-stop">
                    <div class="row">
                        <span><i class="fas fa-play-circle"></i></span><span><i class="fas fa-stop-circle"></i></span>
                    </div>
                </div>
                <div class="logger">
                    <div class="title">Call Log</div>
                    <div class="tabs">
                        <div class="in">In</div>
                        <div class="out">Out</div>
                    </div>
                    <div class="log-content">
                        <div class="row">
                            <div class="name-phone">919871643627</div>
                            <div class="datetime">10/10/2018 03:45:12 PM</div>
                        </div>
                        <div class="row">
                            <div class="name-phone">919871643627</div>
                            <div class="datetime">10/10/2018 03:45:12 PM</div>
                        </div>
                        <div class="row">
                            <div class="name-phone">919871643627</div>
                            <div class="datetime">10/10/2018 03:45:12 PM</div>
                        </div>
                        <div class="row">
                            <div class="name-phone">919871643627</div>
                            <div class="datetime">10/10/2018 03:45:12 PM</div>
                        </div>
                        <div class="row">
                            <div class="name-phone">919871643627</div>
                            <div class="datetime">10/10/2018 03:45:12 PM</div>
                        </div>
                        <div class="row">
                            <div class="name-phone">919871643627</div>
                            <div class="datetime">10/10/2018 03:45:12 PM</div>
                        </div>
                        <div class="row">
                            <div class="name-phone">919871643627</div>
                            <div class="datetime">10/10/2018 03:45:12 PM</div>
                        </div>
                        <div class="row">
                            <div class="name-phone">919871643627</div>
                            <div class="datetime">10/10/2018 03:45:12 PM</div>
                        </div>
                        <div class="row">
                            <div class="name-phone">919871643627</div>
                            <div class="datetime">10/10/2018 03:45:12 PM</div>
                        </div>
                        <div class="row">
                            <div class="name-phone">919871643627</div>
                            <div class="datetime">10/10/2018 03:45:12 PM</div>
                        </div>
                        <div class="row">
                            <div class="name-phone">919871643627</div>
                            <div class="datetime">10/10/2018 03:45:12 PM</div>
                        </div>
                    </div>
                </div>
            </div>
            <div class="dialer-right">
                <div class="scrips">
                    <div class="tabs">
                        <div onclick="showhideType(this, 1);" class="active">Inbound</div>
                        <div onclick="showhideType(this, 2);">Outbound</div>
                    </div>
                    <div class="script-data">
                        Loading Scrips...
                    </div>
                </div>
                <div class="phone-stats">
                    <div style="padding: 10px; font-size: 16px; font-weight: bold;">Phone Statistic - <a href="">Detailed Report</a></div>
                    <table class="stats">
                        <tr>
                            <td>Total Outbound</td>
                            <td>24</td>
                            <td>Total Duration</td>
                            <td>125:25:12 Hours</td>
                            <td></td>
                            <td></td>
                        </tr>
                        <tr>
                            <td>Total Applicant Called</td>
                            <td>100</td>
                            <td>Total Referal Applicant Called</td>
                            <td>200</td>
                            <td>Total Interview Date Called</td>
                            <td>50</td>
                        </tr>
                        <tr>
                            <td>Total Applicant Duration</td>
                            <td>25:25:12 Hours</td>
                            <td>Total Referal Applicant Duration</td>
                            <td>55:25:12 Hours</td>
                            <td>Total Interview Date Duration</td>
                            <td>65:25:12 Hours</td>
                        </tr>
                    </table>
                </div>
                <div class="userlist-calling-grid" style="display:none">
                    <div>
                        <table class="header-table">
                            <thead>
                                <tr>
                                    <th>
                                        <span>Date</span></th>
                                    <th>
                                        <span>Phone</span></th>
                                    <th>
                                        <span>Candidate Status</span></th>
                                    <th>
                                        <span>Duration</span></th>
                                    <th>
                                        <span>Called by Designation</span></th>
                                </tr>
                            </thead>
                            <tbody>
                                <tr>
                                    <td>3/4/2018 1:45 PM (EST)</td>
                                    <td>91987654321</td>
                                    <td>Yogesh Grove - <a>ITSN-A0411</a></td>
                                    <td>00:00:14 Hours</td>
                                    <td>Justin Grove - <a>INS00092</a></td>
                                </tr>
                            </tbody>
                        </table>
                    </div>
                </div>
            </div>
            <uc1:_UserGridPhonePopup runat="server" ID="_UserGridPhonePopup" />
            
        </div>
    </div>
    <script type="text/javascript">
    $(document).ready(function () {
        GetPhoneScripts(this);
        $('.search-user').trigger('click');
    });
    </script>
</asp:Content>
