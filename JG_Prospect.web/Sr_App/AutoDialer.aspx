<%@ Page Title="" Language="C#" MasterPageFile="~/Sr_App/SR_app.Master" AutoEventWireup="true" CodeBehind="AutoDialer.aspx.cs" Inherits="JG_Prospect.Sr_App.AutoDialer" %>

<%@ Register Src="~/Controls/_UserGridPhonePopup.ascx" TagPrefix="uc1" TagName="_UserGridPhonePopup" %>
<%@ Import Namespace="JG_Prospect.Common" %>
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

        .script-data .content .content-items > div.edit-link, .script-data .content .content-items-right > div.edit-link {
            /*width: 170px !important;*/
        }

        .chosen-container.chosen-container-single {
            text-align: left;
            width: 100% !important;
        }

        .edit-link .chosen-container.chosen-container-single {
            position: absolute;
            z-index: -1;
        }

        .script-content .chosen-container.chosen-container-single {
            position: absolute;
            z-index: -1;
        }

        select.ddlDesignationScriptFAQ {
            display: none;
        }
        .content_panel{padding:5px !important;}
    </style>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <%
        string baseUrl = HttpContext.Current.Request.Url.Scheme +
                                "://" + HttpContext.Current.Request.Url.Authority +
                                HttpContext.Current.Request.ApplicationPath.TrimEnd('/') + "/";

    %>
    <link href="../css/chosen.css" rel="stylesheet" />
    <script type="text/javascript" src="<%=Page.ResolveUrl("~/js/chosen.jquery.js")%>"></script>
    <%--<script src="../js/angular/scripts/jgapp.js"></script>--%>
    <%--<script src="../js/angular/scripts/TaskSequence.js"></script>
    <script src="../js/angular/scripts/FrozenTask.js"></script>--%>
    <%--<script src="../js/TaskSequencing.js"></script>--%>
    <script src="../js/jquery.dd.min.js"></script>
    <%--<script src="../js/angular/scripts/ClosedTasls.js"></script>--%>
    <script src="../js/angular/scripts/Phone.js"></script>
    <link href="../css/intTel/intlTelInput.css" rel="stylesheet" />
    <script src="../js/intTel/intlTelInput.js"></script>
    <div class="dialer-container" ng-controller="SalesUserController1">
        <div id="wrapper">
            <div class="auto-dialer-top-section">
                <div id="phone">
                    <div class="col-md-4 phone">
                        <div class="row1">
                            <input type="hidden" id="appSettings" />
                            <textarea style="display: none;" rows="4" cols="40" id="sendFeedbackComment" placeholder="Optional comments"></textarea>
                            <div class="col-md-12 white-shadow">
                                <div class="phone-number-box">
                                    <%--<input type="text" id="phone-code" />--%>
                                    <input type="text" name="name" onkeyup="trimSpace(this)" onblur="trimSpace(this)" id="toNumber" class="form-control tel" placeholder="801XXXXXXX" value="" />
                                </div>
                                <div class="num-pad">
                                    <div class="span4">
                                        <div class="num">
                                            <div class="txt">
                                                1
                                            </div>
                                        </div>
                                    </div>
                                    <div class="span4">
                                        <div class="num">
                                            <div class="txt">
                                                2 <span class="small">
                                                    <p>
                                                        ABC
                                                    </p>
                                                </span>
                                            </div>
                                        </div>
                                    </div>
                                    <div class="span4">
                                        <div class="num">
                                            <div class="txt">
                                                3 <span class="small">
                                                    <p>
                                                        DEF
                                                    </p>
                                                </span>
                                            </div>
                                        </div>
                                    </div>
                                    <div class="span4">
                                        <div class="num">
                                            <div class="txt">
                                                4 <span class="small">
                                                    <p>
                                                        GHI
                                                    </p>
                                                </span>
                                            </div>
                                        </div>
                                    </div>
                                    <div class="span4">
                                        <div class="num">
                                            <div class="txt">
                                                5 <span class="small">
                                                    <p>
                                                        JKL
                                                    </p>
                                                </span>
                                            </div>
                                        </div>
                                    </div>
                                    <div class="span4">
                                        <div class="num">
                                            <div class="txt">
                                                6 <span class="small">
                                                    <p>
                                                        MNO
                                                    </p>
                                                </span>
                                            </div>
                                        </div>
                                    </div>
                                    <div class="span4">
                                        <div class="num">
                                            <div class="txt">
                                                7 <span class="small">
                                                    <p>
                                                        PQRS
                                                    </p>
                                                </span>
                                            </div>
                                        </div>
                                    </div>
                                    <div class="span4">
                                        <div class="num">
                                            <div class="txt">
                                                8 <span class="small">
                                                    <p>
                                                        TUV
                                                    </p>
                                                </span>
                                            </div>
                                        </div>
                                    </div>
                                    <div class="span4">
                                        <div class="num">
                                            <div class="txt">
                                                9 <span class="small">
                                                    <p>
                                                        WXYZ
                                                    </p>
                                                </span>
                                            </div>
                                        </div>
                                    </div>
                                    <div class="span4">
                                        <div class="num">
                                            <div class="txt">
                                                *
                                            </div>
                                        </div>
                                    </div>
                                    <div class="span4">
                                        <div class="num">
                                            <div class="txt">
                                                0 <span class="small">
                                                    <p>
                                                        +
                                                    </p>
                                                </span>
                                            </div>
                                        </div>
                                    </div>
                                    <div class="span4">
                                        <div class="num">
                                            <div class="txt">
                                                #
                                            </div>
                                        </div>
                                    </div>
                                </div>
                                <div class="clearfix">
                                </div>
                                <span onclick="SaveCallPosition(this, 0)" class="reset btn btn-block" title="Reset Dialer Position to First"><i class="fas fa-redo-alt"></i></span>
                                <input type="button" id="makecall" class="btn btn-success btn-block flatbtn" value="CALL" />
                                <input type="button" class="hangup btn btn-danger btn-block flatbtn" value="HANGUP" />
                                <%
                                    List<int> AllowedDesignations = new List<int>();
                                    AllowedDesignations.Add(1);
                                    AllowedDesignations.Add(5);
                                    AllowedDesignations.Add(21);
                                    AllowedDesignations.Add(23);
                                    if (AllowedDesignations.Contains(DesignationId))
                                    {
                                %>
                                <div class="play-stop" style="display: none;">
                                    <div class="row">
                                        <span class="back" title="Back" onclick="dialPreviousNumber(this)"><i class="fas fa-step-backward"></i></span>
                                        <span class="play" title="Start" onclick="startAutoDialer(this)"><i class="fas fa-play-circle"></i></span>
                                        <span class="pause" style="display: none;" title="Pause" onclick="pauseAutoDialer(this)"><i class="fas fa-pause-circle"></i></span>
                                        <span class="stop" title="Stop" onclick="stopAutoDialer(this)"><i class="fas fa-stop-circle"></i></span>
                                        <span class="next" title="Forward" onclick="diaNextNumber(this)"><i class="fas fa-step-forward"></i></span>
                                    </div>
                                </div>
                                <%
                                    }
                                %>
                            </div>
                        </div>
                        <div class="clearfix">
                        </div>
                    </div>
                    <div class="button-3">
                        <div class="callinfo">
                            <h4 id="boundType">Fetching...</h4>
                            <h4 id="callNum">Fetching...</h4>
                            <h2 id="callDuration">00:00</h2>
                        </div>
                    </div>
                    <div class="logger">
                        <div class="tabs">
                            <div class="recent active">Recent</div>
                            <div class="missed">Missed</div>
                            <div class="vmail">VMail</div>
                            <% if (DesignationId == 1 || DesignationId == 3 || DesignationId == 4 || DesignationId == 5
                                      || DesignationId == 6|| DesignationId == 21 || DesignationId == 22 || DesignationId == 23
                                      || DesignationId == 1034 || DesignationId == 1035)
                                { %>
                            <div class="mngr">Manager</div>
                            <%} %>
                        </div>
                        <%--<div class="title">Recent Calls</div>--%>
                        <div class="log-content">
                            <div ng-repeat="Log in PhoneCallLogList.Results" class="user-row row bg1" title="User: {{Log.ReceiverFullName}}({{Log.ReceiverNumber}}), Call Duration : {{Log.CallDurationFormatted}}" uid="780">
                                <div class="user-image">
                                    <div class="img">
                                        <img alt="No image" src="<%=baseUrl %>Employee/ProfilePictures/{{Log.ReceiverProfilePic}}" />
                                    </div>
                                </div>
                                <div class="contents">
                                    <div class="top">
                                        <div class="name">{{Log.ReceiverFullName}}</div>
                                    </div>
                                    <div class="msg-container">
                                        <div class="tick">
                                            <span class="img {{Log.Mode}} {{Log.CallDurationInSeconds == 0 ? 'not-connected':''}}"></span>
                                        </div>
                                        <div class="msg">{{Log.CallStartTimeFormatted}}</div>
                                    </div>
                                </div>
                                <div class="caller">
                                    <div class="video" style="display:{{Log.ReceiverUserId == null ? 'none': 'block'}}"><i class="fas fa-video" aria-hidden="true"></i></div>
                                    <div class="phone"><i class="fa fa-phone" aria-hidden="true"></i></div>
                                    <div class="mic" style="display:{{Log.ReceiverUserId == null ? 'none': 'block'}}"><i class="fas fa-microphone" aria-hidden="true"></i></div>
                                </div>
                                <div class="caller-detail">
                                    <a onclick="event.stopPropagation();" title="{{Log.CallerFullName}}" target="_blank" href="/Sr_App/ViewSalesUser.aspx?id={{Log.CreatedBy}}">{{Log.CallerUserInstallId}}</a>
                                </div>
                            </div>
                        </div>
                    </div>

                </div>
                <div class="dialer-right">
                    <div class="script-container">
                        <div class="tab-container">
                            <div class="type" type="1">Inbound<span class="arrow"><i class="fas fa-angle-right"></i></span></div>
                            <div class="type active" type="2">Outbound<span class="arrow"><i class="fas fa-angle-right"></i></span></div>
                            <div class="subtype active" subtype="<%= (int)JG_Prospect.Common.modal.ScriptSubType.Hr %>">
                                <%= JG_Prospect.Common.modal.ScriptSubType.Hr.ToEnumDescription() %>
                                <span class="arrow"><i class="fas fa-angle-right"></i></span>
                                <select class="script-designations">
                                    <option value="1">Admin</option>
                                    <option value="23">Admin Recruiter</option>
                                    <option value="5">Recruiter</option>
                                    <option value="4">Office Manager</option>
                                </select>
                            </div>
                            <div class="subtype " subtype="<%= (int)JG_Prospect.Common.modal.ScriptSubType.Sales %>">
                                <%= JG_Prospect.Common.modal.ScriptSubType.Sales.ToEnumDescription() %>
                                <span class="arrow"><i class="fas fa-angle-right"></i></span>
                                <select class="script-designations">
                                    <option value="22">Admin-Sales</option>
                                    <option value="6">Sales Manager</option>
                                    <option value="3">Jr Project Manager</option>
                                    <option value="1034">Middle Management Project Manager</option>
                                    <option value="1035">Sr. Project Manager</option>
                                </select>
                            </div>
                            <div class="subtype " subtype="<%= (int)JG_Prospect.Common.modal.ScriptSubType.Customer %>">
                                <%= JG_Prospect.Common.modal.ScriptSubType.Customer.ToEnumDescription() %>
                                <span class="arrow"><i class="fas fa-angle-right"></i></span>
                                <select class="script-designations">
                                    <option value="1">Admin</option>
                                    <option value="22">Admin-Sales</option>
                                    <option value="6">Sales Manager</option>
                                    <option value="3">Jr Project Manager</option>
                                    <option value="1034">Middle Management Project Manager</option>
                                    <option value="1035">Sr. Project Manager</option>
                                </select>
                            </div>
                            <div class="subtype " subtype="<%= (int)JG_Prospect.Common.modal.ScriptSubType.Vendor %>">
                                <%= JG_Prospect.Common.modal.ScriptSubType.Vendor.ToEnumDescription() %>
                                <span class="arrow"><i class="fas fa-angle-right"></i></span>
                                <select class="script-designations">
                                    <option value="1">Admin</option>
                                    
                                </select>
                            </div>
                        </div>
                        <div class="script-content" ng-repeat="script in PhoneScriptData.Results" ng-if="PhoneScriptData.Results.length > 0">
                            <input type="hidden" class="script-id" value="{{script.Id}}" />
                            <div class="left-script">
                                <div class="single-script">
                                    <div class="title"><span>{{script.Title}}</span><a href="javascript:;" onclick="editScript(this);" sid="{{script.Id}}">Edit</a></div>
                                    <div class="content" ng-bind-html="script.DescriptionPlain | unsafe"></div>
                                </div>
                            </div>
                            <div class="right-faq">
                                <div class="single-script">
                                    <div class="title"><span>{{script.FAQTitle}}</span><a href="javascript:;" onclick="editScript(this);" sid="{{script.Id}}">Edit</a></div>
                                    <div class="content" ng-bind-html="script.FAQDescription | unsafe"></div>
                                </div>
                            </div>
                        </div>
                        <div class="script-content" ng-if="PhoneScriptData.Results.length == 0">
                            <input type="hidden" class="script-id" value="{{script.Id}}" />
                            <div class="left-script">
                                <div class="single-script">
                                    <div class="title">
                                        <input type="text" />
                                    </div>
                                    <div class="content">
                                        <textarea id="script-0-script"></textarea>
                                    </div>
                                    <div class="action">
                                        <input type="hidden" class="old-title" value="" />
                                        <input type="hidden" class="old-content" value="" />
                                        <input type="button" value="Save" onclick="updateScript(this, 0, 'script')">
                                        <input type="button" class="cancel" value="Cancel" onclick="cancelUpdateScript(this)">
                                    </div>
                                </div>
                            </div>
                            <div class="right-faq">
                                <div class="single-script">
                                    <div class="title">
                                        <input type="text" />
                                    </div>
                                    <div class="content">
                                        <textarea id="script-0-faq"></textarea>
                                    </div>
                                    <div class="action">
                                        <input type="hidden" class="old-title" value="" />
                                        <input type="hidden" class="old-content" value="" />
                                        <input type="button" value="Save" onclick="updateScript(this, 0, 'faq')">
                                        <input type="button" class="cancel" value="Cancel" onclick="cancelUpdateScript(this)">
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                    <%--<input type="hidden" class="script-data" value="" />
                    <div class="scrips">
                        <div class="tabs">
                            <div onclick="showhideType(this, 1);">Inbound</div>
                            <div onclick="showhideType(this, 2);" class="active">Outbound</div>
                        </div>
                        <div class="script-data">
                            <div class="inner-tabs">
                            </div>
                            <div class="content">
                            </div>
                            <div class="content-right"></div>
                        </div>
                    </div>--%>
                </div>
                <div class="bottom-row">
                    

                    <div class="phone-stats">
                        <div style="padding: 10px; font-size: 16px; font-weight: bold;">Phone Statistic - <a href="">Detailed Report</a></div>
                        <table class="stats">
                            <tr>
                                <td>Total Outbound</td>
                                <td>{{PhoneCallStatistics.TotalOutbound}}</td>
                                <td>Total Duration</td>
                                <td>{{PhoneCallStatistics.TotalCallDurationFormatted}}</td>
                                <td></td>
                                <td></td>
                            </tr>
                            <tr>
                                <td>Total Applicant Called</td>
                                <td>{{PhoneCallStatistics.TotalApplicantCalled}}</td>
                                <td>Total Referal Applicant Called</td>
                                <td>{{PhoneCallStatistics.TotalReferralApplicantCalled}}</td>
                                <td>Total Interview Date Called</td>
                                <td>{{PhoneCallStatistics.TotalInterviewDateCalled}}</td>
                            </tr>
                            <tr>
                                <td>Total Applicant Duration</td>
                                <td>{{PhoneCallStatistics.TotalApplicantDurationFormatted}}</td>
                                <td>Total Referal Applicant Duration</td>
                                <td>{{PhoneCallStatistics.TotalReferralApplicantFormatted}}</td>
                                <td>Total Interview Date Duration</td>
                                <td>{{PhoneCallStatistics.TotalInterviewDateFormatted}}</td>
                            </tr>
                        </table>
                    </div>
                </div>
            </div>
            <%--<div class="auto-dialer-middle-section">
                
            </div>--%>
            <div class="auto-dialer-bottom-section">
                <uc1:_UserGridPhonePopup runat="server" ID="_UserGridPhonePopup" />
            </div>
        </div>
    </div>
    <script type="text/javascript">
        var firstLoad = true;
        $("#toNumber").intlTelInput();
        $(document).ready(function () {
            $('.footer_panel').remove();
            var userDID = <%= DesignationId %>;
            if(userDID==1 || userDID==4 || userDID==5 || userDID==23){
                $('.tab-container .subtype.active').find('select.script-designations').val(userDID);
                $('.tab-container .subtype.active').find('select.script-designations').trigger("chosen:updated");                
            }
            $('.tab-container .subtype.active').trigger('click');
            //sequenceScopePhone.GetPhoneScriptData(this, userDID , 2, 1);
            //$('.search-user').trigger('click');
            

            resetSettings();
            initPhone();
            sequenceScopePhone.GetPhoneCallLogList($(this), 'recent');
            var pH = $(window).height();
            if(pH < 600){
                $('.auto-dialer-top-section').css('height', '265px');
                $('.auto-dialer-bottom-section').css('height', (parent.phonePopupHeight - 300) + 'px');
            }else{
                $('.auto-dialer-bottom-section').css('height', (parent.phonePopupHeight - 414) + 'px');
            }
            $('.tab-container').find('select').chosen({ width: '150px !important' });
        });

        $(document).on('click','.logger .tabs > div', function(){
            var type = $(this).attr('class');
            $('.logger .tabs > div').removeClass('active');
            $(this).addClass('active');
            sequenceScopePhone.GetPhoneCallLogList($(this), type);
        });

        $(document).on('change', '.edit-link select', function () {
            var did = $(this).val();
            ajaxExt({
                url: '/WebServices/JGWebService.asmx/GetPhoneScriptByDesignationId',
                type: 'POST',
                data: '{did:' + did + '}',
                showThrobber: true,
                throbberPosition: { my: "left center", at: "right center", of: $(this), offset: "5 0" },
                success: function (data, msg) {

                }
            });
        });

        function SaveCallPosition(sender, candidateUserId) {
            if (candidateUserId == null || candidateUserId == undefined) {
                candidateUserId = $(sender).parents('tr').attr('userid');
            }
            ajaxExt({
                url: '/WebServices/JGWebService.asmx/SaveCallPosition',
                type: 'POST',
                data: '{candidateUserId:' + candidateUserId + '}',
                showThrobber: false,
                throbberPosition: { my: "left center", at: "right center", of: $(sender), offset: "5 0" },
                success: function (data, msg) {
                    if (candidateUserId == '0') {
                        // set to first user in the list
                        $('#SalesUserGrid').find('.caller-position').find('span').hide();
                        $('#SalesUserGrid').find('.caller-position').find('input').show();

                        $('#SalesUserGrid tr:first').find('.caller-position').find('span').show();
                        $('#SalesUserGrid tr:first').find('.caller-position').find('input').hide();
                    } else {
                        $('#SalesUserGrid').find('.caller-position').find('span').hide();
                        $('#SalesUserGrid').find('.caller-position').find('input').show();
                        $(sender).hide();
                        $(sender).parents('.caller-position').find('span').show();
                    }
                }
            });
        }

        function updateScript(sender, id, scriptType){
            var txtAreaId = $(sender).parents('.single-script').find('.content').find('textarea').attr('id');
            var script = GetCKEditorContent(txtAreaId).replace(/"/g, '\\"');
            var title = $(sender).parents('.single-script').find('.title').find('input[type="text"]').val().trim();
            var did = $('.subtype.active').find('select.script-designations').val();
            var type=$('.tab-container').find('.type.active').attr('type');
            var subType=$('.tab-container').find('.subtype.active').attr('subtype');
            ajaxExt({
                url: '/WebServices/JGWebService.asmx/UpdatePhoneScript',
                type: 'POST',
                data: '{id:' + id + ',type:' + type + ',subType:' + subType + ', title:"'+title+'",desc:"'+script+'",did:'+did+',scriptType:"'+scriptType+'"}',
                showThrobber: false,
                throbberPosition: { my: "left center", at: "right center", of: $(sender), offset: "5 0" },
                success: function (data, msg) {
                    var sid = data.Object;
                    $(sender).parents('.single-script').find('.title').find('input[type="text"]').remove();
                    $(sender).parents('.single-script').find('.title').html('<span>' + title + '</span><a href="javascript:;" onclick="editScript(this);" sid="'+sid+'">Edit</a>');
                    script = script.replace(/\\"/g,'');
                    $(sender).parents('.single-script').find('.content').html(script);
                    $(sender).parents('.action').remove();
                }
            });
        }

        function editScript(sender){
            var scriptType = $(sender).parents('.single-script').parent().hasClass('left-script') ? 'script' : 'faq';
            var title = $(sender).parents('.single-script').find('.title span').html();
            var content = $(sender).parents('.single-script').find('.content').html();
            var id = $(sender).parents('.script-content').find('.script-id').val();            
            $(sender).parents('.single-script').find('.content').html('<textarea id="script-' + id + '-' + scriptType + '">' + content + '</textarea>');
            
            var action='<div class="action">'+
                            '<span style="display:none;" class="old-title">' + title + '"</span>'+
                            '<span style="display:none;" class="old-content">' + content + '"</span>'+
                            '<input type="button" value="Save" onclick="updateScript(this, ' + id + ', \'' + scriptType + '\')">'+
                            '<input type="button" class="cancel" value="Cancel" onclick="cancelUpdateScript(this)">'+
                        '</div>';
            $(sender).parents('.single-script').append(action);
            $(sender).parents('.single-script').find('.title').html('<input type="text" value="' + title + '" />');
            SetCKEditorForTaskPopup('script-' + id + '-' + scriptType);
        }

        function cancelUpdateScript(sender){
            var title = $(sender).parents('.action').find('.old-title').html();
            var content = $(sender).parents('.action').find('.old-content').html();
            var sid = $(sender).parents('.script-content').find('.script-id').val();

            $(sender).parents('.single-script').find('.title').find('input[type="text"]').remove();
            $(sender).parents('.single-script').find('.title').html('<span>' + title + '</span><a href="javascript:;" onclick="editScript(this);" sid="'+sid+'">Edit</a>');
            content = content.replace(/\"/g,'');
            $(sender).parents('.single-script').find('.content').html(content);
            
            $(sender).parents('.action').remove();
        }
        
        $(document).on('click','.script-container .chosen-container', function(e){
            e.stopPropagation();
        });

        $(document).on('click','.tab-container .type', function(){
            $('.tab-container .type').removeClass('active');
            $(this).addClass('active');
            $('.tab-container .subtype.active').trigger('click');
        });

        $(document).on('click','.tab-container .subtype', function(){            
            $('.tab-container .subtype').removeClass('active');
            $(this).addClass('active');
            $(this).find('select').trigger('change');
           
        });

        $(document).on('change','.script-container .script-designations', function(e){
            var type = $('.tab-container .type.active').attr('type');
            var subtype = $('.tab-container .subtype.active').attr('subtype');
            var did = $(this).val();
            sequenceScopePhone.GetPhoneScriptData(this, did, type, subtype);
            if(did=='1'){
                $('#ddlSavedReports').val('CreatedDateTime DESC');
            }else{
                $('#ddlSavedReports').val('LastLoginTimeStamp DESC');
            }
            $('#ddlSavedReports').trigger("chosen:updated");
            //$('#ddlSavedReports').trigger('change');
            //$('.search-user').trigger('click');
            if(firstLoad){
                searchUsers($(this), true);
                firstLoad = false;
            }else{
                searchUsers($(this), false);
            }
        });
    </script>
</asp:Content>
