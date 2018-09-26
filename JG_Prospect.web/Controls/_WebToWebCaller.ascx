<%@ Control Language="C#" AutoEventWireup="true" CodeBehind="_WebToWebCaller.ascx.cs" Inherits="JG_Prospect.Controls._WebToWebCaller" %>
<link href="/Controls/webtowebcaller.css" rel="stylesheet" />
<div ng-controller="WebToWebController">
    <div class="video-dashboard">
        <div class="header">
            <span class="popup-title">Video / Conference Dashboard</span>
            <%--<div class="title-popup-stats">
            <ul style="">
                <li><a href="#" onclick="InitiateBlankChat(this,'all')" class="red-text">All</a></li>
                <li>&nbsp;&nbsp;|&nbsp;&nbsp;</li>
                <li id="test"><a id="Header1_hypEmail" class="clsPhoneLink" onclick="InitiateBlankChat(this, 'email')" style="color: white;">Emails<label id="emailUnreadCount" class="badge badge-error">0</label><label id="lblUnRead" class="badge badge-error hide"></label></a></li>
                <li>&nbsp;&nbsp;|&nbsp;&nbsp;</li>
                <li><a href="javascript:;" id="Header1_idPhoneLink" class="clsPhoneLink" onclick="openPhoneDashboard(this)">Phone / Vmail(0)<label id="lblNewCounter" class="badge badge-error">10</label><label id="lblUnRead" class="badge badge-error hide"></label></a></li>
                <li>&nbsp;&nbsp;|&nbsp;&nbsp;</li>
                <li><a id="hypChat" href="#" class="clsPhoneLink" onclick="InitiateBlankChat(this, 'chat');">Chat
		            <label style="display: none;" class="badge badge-error chatUnreadCount"></label>
                    <label style="display: none;" class="badge badge-error chatAutoEntriesCount"></label>
                    <label class="badge badge-error hide"></label>
                </a></li>
            </ul>
        </div>--%>
            <span class="close" onclick="closeWebPopup(this)"><i class="fa fa-window-close" aria-hidden="true"></i></span>
            <span class="min-max" onclick="minMaxPhone(this)"><i class="fa fa-window-minimize" aria-hidden="true"></i></span>
            <span class="fullscreen-btn" onclick="fullscreenPhone(this)"><i class="fas fa-window-restore" aria-hidden="true"></i></span>
        </div>
        <div class="content-area">
            <div class="video-area">
                <iframe src="" allow="geolocation; microphone; camera"></iframe>
            </div>
            <div class="chat-area">
                <div class="chat-section">
                    <div class="chat-container" id="chat-container">
                        <div class="all-chats">
                        </div>
                    </div>
                </div>
            </div>
            <div class="user-area">
                <div class="chat-users-section">
                    <div class="list">
                        Loading Chats...                   
                    </div>
                </div>
                <%--<div ng-repeat="User in WebUsers" class="user-row row bg{{User.InstallUserStatusId}}" title="{{User.GroupOrUsername}}" userchatgroupid="{{User.UserChatGroupId}}" uid="{{User.UserId}}">
                    <div receiverids="{{User.ReceiverIds}}" chatgroupid="{{User.ChatGroupId}}" taskid="{{User.TaskId}}" taskmultilevellistid="{{User.TaskMultilevelListId}}" userchatgroupid="{{User.UserChatGroupId}}">
                        <div class="user-image">
                            <img alt="No image" src="/Employee/ProfilePictures/{{User.ProfilePic}}"><div class="status-icon {{User.chatStatus}}"></div>
                            <div class="installid"><a onclick="event.stopPropagation();" target="_blank" href="/Sr_App/ViewSalesUser.aspx?id={{User.UserId}}">{{User.UserInstallId}}</a></div>
                        </div>
                        <div class="contents">
                            <div class="top">
                                <div class="name">{{User.GroupOrUsername}} - <a target="_blank" onclick="event.stopPropagation();" href="/Sr_App/ViewSalesUser.aspx?id={{User.UserId}}" title="/Sr_App/ViewSalesUser.aspx?id={{User.UserId}}">{{User.UserInstallId}}</a></></div>
                            </div>
                            <div class="msg-container">
                                <div class="tick">
                                    <small>
                                        <img src="../img/{{User.IsRead.toString().toLowerCase() == 'true' ? 'double-blue' : 'double-grey'}}-tick.png"></small>
                                </div>
                                <div class="msg" ng-bind-html="User.LastMessage | unsafe"></div>
                            </div>
                        </div>
                    </div>
                    <div class="caller">
                        <div class="phone-existing" title="Add into Call"><small><i class="fa fa-phone" aria-hidden="true"></i></small></div>
                        <div class="email"><small><i class="fa fa-envelope" aria-hidden="true"></i></small></div>
                        <div class="video-existing" title="Add into Call"><small><i class="fas fa-video" aria-hidden="true"></i></small></div>
                        <div class="mic" title="Record Voice"><small><i class="fas fa-microphone" aria-hidden="true"></i></small></div>
                        <div class="time"><small>{{User.LastMessageAtFormatted == null ? '' : mySplit(User.LastMessageAtFormatted," ",0)}}</small></div>
                        <div class="last-login-time"><small>{{(User.LastLoginAtFormatted != '' && User.LastLoginAtFormatted != null) ? mySplit(User.LastLoginAtFormatted," ",0) : ''}}</small></div>
                    </div>
                </div>--%>
            </div>
        </div>
    </div>
    <div class="call-ring-box" style="display: none;">
        <input type="hidden" id="CallGroupURL" value="{{WebToWebCallObj.CallGroupURL}}" />
        <input type="hidden" id="GroupNameID" value="{{WebToWebCallObj.GroupNameID}}" />
        <input type="hidden" id="CallerUserId" value="{{WebToWebCallObj.CallerUserId}}" />
        <input type="hidden" id="IsGroupCall" value="{{WebToWebCallObj.IsGroupCall}}" />
        <div class="profile-pic">
            <img src="/Employee/ProfilePictures/{{WebToWebCallObj.CallerProfilePic}}" />
        </div>
        <div class="caller">
            <span>{{WebToWebCallObj.CallerUsername}}</span> - <a href="/Sr_App/ViewSalesUser.aspx?id={{WebToWebCallObj.CallerUserId}}" target="_blank">{{WebToWebCallObj.CallerUserInstallId}}</a>
        </div>
        <div class="text">Incoming Call...</div>
        <div class="action-button">
            <span class="reject" title="Reject Call">
                <img src="../img/reject-call.PNG" /></span>
            <span class="accept" title="Accept Call">
                <img src="../img/accept-call.PNG" /></span>
        </div>
    </div>

    <div class="call-ring-box-reject" style="position: fixed; top: 10000px; left: 10000px;">
        <span class="close" onclick="closeRejectBox(this)"><i class="fa fa-window-close" aria-hidden="true"></i></span>
        <span>User has rejected your call.</span>
    </div>
    <div class="audio-video-record">
        <input type="hidden" id="CalleeUserId" value="{{CalleeUser.UserId}}" />
        <div class="message">
            <span class="callee-name">{{CalleeUser.FirstName}} {{CalleeUser.LastName}}</span>-
        <a target="_blank" href="/Sr_App/ViewSalesUser.aspx?id={{CalleeUser.UserId}}">{{CalleeUser.UserInstallId}}</a> does not seems to be online.
        Would you like to leave a message for them?
        </div>
        <div class="action-button">
            <input type="button" class="audio-message" value="Record Audio Message" />
            <input type="button" class="video-message" value="Record Video Message" />
            <input type="button" class="cancel" value="Cancel" />            
        </div>
    </div>
    <div class="audio-video-recorder">
        <video id="preview" controls></video>
        <audio id="audiopreview" controls></audio>
        <div class="action-button">
            <input type="hidden" id="ChatGroupId"  />
            <input type="hidden" id="TaskId" />
            <input type="hidden" id="TaskMultilevelListId" />
            <input type="hidden" id="ReceiverIds" />
            <input type="hidden" id="UserChatGroupId" />
            <input type="hidden" id="ChatSourceId" />

            <input type="button" id="record" class="record" value="Record" />
            <input type="button" id="stop" disabled="disabled" class="stopAndSend" value="Stop and Send" />
            <input type="button" class="cancel" value="Cancel" />
            <input type="button" class="close-popup" value="Cancel" />
        </div>
        <div id="container" style="padding: 1em 2em;"></div>
    </div>
</div>

<%--<script src="../js/angular/scripts/jgapp.js"></script>--%>
<script src="../js/angular/scripts/webtowebcalling.js"></script>
<script src="https://cdn.webrtc-experiment.com/RecordRTC.js"> </script>

<script type="text/javascript">
    $(document).on('click', '.caller .video,.caller .phone', function (e) {
        // close any chat if opened
        $('.video-dashboard').find('.all-chats').html('');
        var userchatgroupid = $(this).parents('.user-row').attr('userchatgroupid');
        var userid = $(this).parents('.user-row').attr('uid');
        if (userchatgroupid == 'null')
            userchatgroupid = 0;
        if (userid == 'null')
            userid = 0;
        var roomname = userchatgroupid == 0 ? 'Single' + userid : 'Group' + userchatgroupid;

        var isGroupCall = userchatgroupid == 0 ? false : true;
        $('.video-dashboard .video-area').find('iframe').attr('src', '<%=JGPA%>/' + roomname);
        $('.telecom-dashboard-popup').hide();
        $('.phone-dashboard').hide();
        $('div.video-dashboard').show();
        $('div.overlay').show();
        // Calculate Center
        var sW = $(window).width();
        var pW = $('.video-dashboard').width();
        var sH = $(window).height();
        var pH = $('.video-dashboard').height();
        $('.video-dashboard').css({ 'left': ((sW / 2) - (pW / 2)) + 'px', 'top': ((sH / 2) - (pH / 2)) + 'px' });
        window.scrollTo(0, 0);
        sequenceScopeWebToWebCall.InitiateWebToWebCall(this, userchatgroupid, userid, isGroupCall);
    });

    $(document).on('click', '.caller .video-existing', function (e) {
        var userid = $(this).parents('.user-row').attr('uid');
        if (userid == 'null') {
            alert('Cannot add a group into call, add users one by one');
            return false;
        } else {
            var callUrl = $('.video-dashboard .video-area iframe').attr('src');
            var roomname = callUrl.substring(callUrl.lastIndexOf('/') + 1);
            sequenceScopeWebToWebCall.AddUserIntoCall(this, roomname, userid);
        }
    });

    function closeWebPopup(sender) {
        $('.overlay').hide();
        $('.video-dashboard').hide();
        $('.video-dashboard .video-area').find('iframe').removeAttr('src');
        $('.phone-dashboard').hide();
        $('.telecom-dashboard-popup').hide();
    }

    function closeRejectBox(sender) {
        $('.overlay').hide();
        $('.call-ring-box-reject').hide();
    }

    if (chat === undefined)
        chat = $.connection.chatHub;
    chat.client.ringClient = function (data) {
        // Check if user is already on call 
        if ($('div.video-dashboard').is(':visible')) {
            // do someting
            chat.server.notifyCaller(data.Object.CallerUserId, data.Object.UserId);
        } else {
            //var GroupNameID = data.Object.GroupNameID;
            //var UserIds = data.Object.UserIds;
            //var CallerUserId = data.Object.CallerUserId;
            //var CallerUsername = data.Object.CallerUsername;
            //var CallerProfilePic = data.Object.CallerProfilePic;
            //var CallerUserInstallId = data.Object.CallerUserInstallId;
            //var CallGroupURL = data.Object.CallGroupURL;
            //var UserChatGroupId = data.Object.UserChatGroupId;
            //var UserId = data.Object.UserId;
            //sequenceScopeWebToWebCall.WebToWebCallObj = data.Object;
            $('.call-ring-box .profile-pic').find('img').attr('src', '/Employee/ProfilePictures/' + data.Object.CallerProfilePic);
            $('.call-ring-box .caller').find('span').html(data.Object.CallerUsername);
            $('.call-ring-box .caller').find('a').attr('href', '/Sr_App/ViewSalesUser.aspx?id=' + data.Object.CallerUserId);
            $('.call-ring-box .caller').find('a').html(data.Object.CallerUserInstallId);
            $('.call-ring-box').find('#CallGroupURL').val(data.Object.CallGroupURL);
            $('.call-ring-box').find('#GroupNameID').val(data.Object.GroupNameID);
            $('.call-ring-box').find('#CallerUserId').val(data.Object.CallerUserId);
            $('.call-ring-box').find('#IsGroupCall').val(data.Object.IsGroupCall);
            $('.call-ring-box').show();
            $('.telecom-dashboard-popup').hide();
            $('.phone-dashboard').hide();
            $('div.video-dashboard').hide();
            $('div.overlay').show();

            // Calculate Center
            var sW = $(window).width();
            var pW = $('.call-ring-box').width();
            var sH = $(window).height();
            var pH = $('.call-ring-box').height();
            $('.call-ring-box').css({ 'left': ((sW / 2) - (pW / 2)) + 'px', 'top': ((sH / 2) - (pH / 2)) + 'px' });
            window.scrollTo(0, 0);
            $('body').append('<audio autoplay loop class="call-notification-sound"><source src="../Controls/web-call.mp3" /><source src=".../Controls/web-call.ogg" /></audio>');
        }
    }

    chat.client.notifyCallerCallback = function () {
        alert('User is busy in some other call.');
    }

    chat.client.rejectOneToOneCall = function (data) {
        $('.video-dashboard .video-area').find('iframe').removeAttr('src');
        $('.telecom-dashboard-popup').hide();
        $('.phone-dashboard').hide();
        $('div.video-dashboard').hide();
        $('.call-ring-box').hide();

        $('.call-ring-box-reject').show();
        $('div.overlay').show();
        // Calculate Center
        var sW = $(window).width();
        var pW = $('.call-ring-box-reject').width();
        var sH = $(window).height();
        var pH = $('.call-ring-box-reject').height();
        $('.call-ring-box-reject').css({ 'left': ((sW / 2) - (pW / 2)) + 'px', 'top': ((sH / 2) - (pH / 2)) + 'px' });
        window.scrollTo(0, 0);
    }

    chat.client.rejectGroupCall = function (data) {

    }

    $(document).on('click', '.call-ring-box .action-button span.accept', function () {
        var CallGroupURL = $('.call-ring-box').find('#CallGroupURL').val();
        var GroupNameID = $('.call-ring-box').find('#GroupNameID').val();
        $('audio.call-notification-sound').remove();
        sequenceScopeWebToWebCall.GetWebCallingUsers(this, CallGroupURL, GroupNameID);
    });

    $(document).on('click', '.call-ring-box .action-button span.reject', function () {
        var CallGroupURL = $('.call-ring-box').find('#CallGroupURL').val();
        var GroupNameID = $('.call-ring-box').find('#GroupNameID').val();
        var CallerUserId = $('.call-ring-box').find('#CallerUserId').val();
        var IsGroupCall = $('.call-ring-box').find('#IsGroupCall').val();
        $('audio.call-notification-sound').remove();
        sequenceScopeWebToWebCall.RejectAndNotify(this, GroupNameID, CallerUserId, IsGroupCall);
    });

    $(document).on('click', '.audio-video-record .action-button .cancel', function () {
        var CalleeUserId = $('.audio-video-record').find('#CalleeUserId').val();
        sequenceScopeWebToWebCall.SendMissedCallAlert(this, CalleeUserId);
        $('.telecom-dashboard-popup').hide();
        $('.phone-dashboard').hide();
        $('div.video-dashboard').hide();
        $('div.overlay').hide();
        $('div.audio-video-record').hide();
    });
    var recordVideo = false, normalVoice = false;;
    $(document).on('click', '.audio-video-record .action-button .video-message', function () {
        recordVideo = true;
        normalVoice = false;
        var CalleeUserId = $('.audio-video-record').find('#CalleeUserId').val();
        $('.audio-video-record').hide();
        $('.audio-video-recorder').show();
        $('.audio-video-recorder').find('#CalleeUserId').val(CalleeUserId);
        $('.audio-video-recorder').find('#audiopreview').hide();
        $('.audio-video-recorder').find('.cancel').show();
        $('.audio-video-recorder').find('.close-popup').hide();
        // Calculate Center
        var sW = $(window).width();
        var pW = $('.audio-video-recorder').width();
        var sH = $(window).height();
        var pH = $('.audio-video-recorder').height();
        $('.audio-video-recorder').css({ 'left': ((sW / 2) - (pW / 2)) + 'px', 'top': ((sH / 2) - (pH / 2)) + 'px' });
        window.scrollTo(0, 0);
    });

    $(document).on('click', '.audio-video-record .action-button .audio-message', function () {
        recordVideo = false;
        normalVoice = false;
        var CalleeUserId = $('.audio-video-record').find('#CalleeUserId').val();
        $('.audio-video-record').hide();
        $('.audio-video-recorder').show();
        $('.audio-video-recorder').find('#CalleeUserId').val(CalleeUserId);
        $('.audio-video-recorder').find('#preview').hide();
        $('.audio-video-recorder').find('.cancel').show();
        $('.audio-video-recorder').find('.close-popup').hide();
        // Calculate Center
        var sW = $(window).width();
        var pW = $('.audio-video-recorder').width();
        var sH = $(window).height();
        var pH = $('.audio-video-recorder').height();
        $('.audio-video-recorder').css({ 'left': ((sW / 2) - (pW / 2)) + 'px', 'top': ((sH / 2) - (pH / 2)) + 'px' });
        window.scrollTo(0, 0);
    });

    $(document).on('click', '.caller .mic, .chat-text .record-send', function () {
        recordVideo = false;
        normalVoice = true;
        var uid = 0, userchatgroupid = 0;
        if ($(this).parents('.user-row').length > 0 && $(this).parents('.user-row').length > 0) {
            $('.audio-video-recorder').find('#ReceiverIds').val($(this).parents('.user-row').attr('receiverids'));
            $('.audio-video-recorder').find('#UserChatGroupId').val($(this).parents('.user-row').attr('userchatgroupid'));
            $('.audio-video-recorder').find('#ChatGroupId').val($(this).parents('.user-row').attr('chatgroupid'));
            $('.audio-video-recorder').find('#TaskId').val($(this).parents('.user-row').attr('taskid'));
            $('.audio-video-recorder').find('#TaskMultilevelListId').val($(this).parents('.user-row').attr('taskmultilevellistid'));
        } else {
            $('.audio-video-recorder').find('#ReceiverIds').val($(this).parents('.user-row').find('#ReceiverIds').val());
            $('.audio-video-recorder').find('#UserChatGroupId').val($(this).parents('.user-row').find('#UserChatGroupId').val());
            $('.audio-video-recorder').find('#ChatGroupId').val($(this).parents('.user-row').find('#ChatGroupId').val());
            $('.audio-video-recorder').find('#TaskId').val($(this).parents('.user-row').find('#TaskId').val());
            $('.audio-video-recorder').find('#TaskMultilevelListId').val($(this).parents('.user-row').find('#TaskMultilevelListId').val());
        }
        $('.audio-video-record').hide();
        $('.audio-video-recorder').show();
        $('.audio-video-recorder').find('#preview').hide();
        $('.audio-video-recorder').find('.cancel').hide();
        $('.audio-video-recorder').find('.close-popup').show();
        $('.telecom-dashboard-popup').hide();
        $('.phone-dashboard').hide();
        $('div.overlay').show();
        // Calculate Center
        var sW = $(window).width();
        var pW = $('.audio-video-recorder').width();
        var sH = $(window).height();
        var pH = $('.audio-video-recorder').height();
        $('.audio-video-recorder').css({ 'left': ((sW / 2) - (pW / 2)) + 'px', 'top': ((sH / 2) - (pH / 2)) + 'px' });
        window.scrollTo(0, 0);
    });

    $(document).on('click', '.audio-video-recorder .close-popup', function () {
        $('.audio-video-recorder').hide();
        $('div.overlay').hide();
    });
    // Audio/Video Recording Section
    // PostBlob method uses XHR2 and FormData to submit 
    // recorded blob to the PHP server
    function PostBlob(blob) {
        // FormData
        var formData = new FormData();
        formData.append('docbinaryarray', fileName);
        formData.append('docbinaryarray', blob);

        // progress-bar
        var hr = document.createElement('hr');
        container.appendChild(hr);
        var strong = document.createElement('strong');
        strong.id = 'percentage';
        strong.innerHTML = 'Video upload progress: ';
        container.appendChild(strong);
        var progress = document.createElement('progress');
        container.appendChild(progress);
        
        var CalleeUserId = $('.audio-video-recorder').find('#CalleeUserId').val();

        // POST the Blob using XHR2
        xhr('/Chat/ChatAttachmentUpload.aspx', formData, progress, percentage, function (fName, response) {
            var filename = fName.split("^");
            var originalName = filename[2];
            var displayName = filename[0];
            var fileId = filename[1];
            var contentType = filename[3];
            progress.parentNode.removeChild(progress);
            strong.parentNode.removeChild(strong);
            hr.parentNode.removeChild(hr);
            recordVideo.destroy();
            // Save this in HR chat
            sendRecordedNote(CalleeUserId, originalName, fileId, contentType, normalVoice);
            $('.audio-video-recorder').hide();
            $('.overlay').hide();
        });
    }

    var record = document.getElementById('record');
    var stop = document.getElementById('stop');
    // var deleteFiles = document.getElementById('delete');

    var preview = recordVideo ? document.getElementById('preview') : document.getElementById('audiopreview');
    var container = document.getElementById('container');

    var recordVideo;
    record.onclick = function () {
        record.disabled = true;
        $(this).attr('disabled');

        navigator.getUserMedia = navigator.getUserMedia || navigator.mozGetUserMedia || navigator.webkitGetUserMedia;
        navigator.getUserMedia({
            audio: true,
            video: recordVideo
        }, function (stream) {
            preview.src = window.URL.createObjectURL(stream);
            preview.play();

            recordVideo = RecordRTC(stream, {
                type: recordVideo ? 'video' : 'audio'
            });
            recordVideo.startRecording();
            stop.disabled = false;
        }, function (error) {
            alert(error.toString());
        });
    };

    var fileName;
    stop.onclick = function () {
        record.disabled = false;
        stop.disabled = true;

        preview.src = '';

        fileName = (Math.round(Math.random() * 99999999) + 99999999) + '.webm';

        recordVideo.stopRecording(function () {
            PostBlob(recordVideo.getBlob());
        });

        // deleteFiles.disabled = false;
        var MediaStream = window.MediaStream;

        if (typeof MediaStream === 'undefined' && typeof webkitMediaStream !== 'undefined') {
            MediaStream = webkitMediaStream;
        }

        /*global MediaStream:true */
        if (typeof MediaStream !== 'undefined' && !('stop' in MediaStream.prototype)) {
            MediaStream.prototype.stop = function () {
                this.getAudioTracks().forEach(function (track) {
                    track.stop();
                });

                this.getVideoTracks().forEach(function (track) {
                    track.stop();
                });
            };
        }
    };

    function xhr(url, data, progress, percentage, callback) {
        var request = new XMLHttpRequest();
        request.onreadystatechange = function () {
            if (request.readyState == 4 && request.status == 200) {
                callback(request.responseText);
            }
        };

        if (url.indexOf('/RecordRTC/DeleteFile') == -1) {
            request.upload.onloadstart = function () {
                percentage.innerHTML = 'Upload started...';
            };

            request.upload.onprogress = function (event) {
                progress.max = event.total;
                progress.value = event.loaded;
                percentage.innerHTML = 'Upload Progress ' + Math.round(event.loaded / event.total * 100) + "%";
            };

            request.upload.onload = function () {
                percentage.innerHTML = 'Saved!';
            };
        }

        request.open('POST', url);
        request.send(data);
    }

    function sendRecordedNote(CalleeUserId, originalName, fileId, contentType, normalVoice) {
        var ReceiverIds = $('.audio-video-recorder').find('#ReceiverIds').val();
        var UserChatGroupId = $('.audio-video-recorder').find('#UserChatGroupId').val();
        var ChatGroupId = $('.audio-video-recorder').find('#ChatGroupId').val();
        var TaskId = $('.audio-video-recorder').find('#TaskId').val();
        var TaskMultilevelListId = $('.audio-video-recorder').find('#TaskMultilevelListId').val();
        UserChatGroupId = UserChatGroupId == '' || UserChatGroupId == undefined ? null : UserChatGroupId;
        TaskId = TaskId == '' || TaskId == undefined ? null : TaskId;
        TaskMultilevelListId = TaskMultilevelListId == '' || TaskMultilevelListId == undefined ? null : TaskMultilevelListId;
        ajaxExt({
            url: '/WebServices/JGWebService.asmx/SendRecordedNote',
            type: 'POST',
            data: '{ReceiverIds:"' + ReceiverIds + '", UserChatGroupId:' + UserChatGroupId + ', ChatGroupId:"' + ChatGroupId + '", TaskId:' + TaskId + ', TaskMultilevelListId:' + TaskMultilevelListId + ',originalName:"' + originalName + '",fileId:' + fileId + ', contentType:"' + contentType + '", normalVoice:' + normalVoice + '}',
            showThrobber: false,
            throbberPosition: { my: "left center", at: "right center", of: $(this), offset: "5 0" },
            success: function (data, msg) {
                var obj = {
                    Object: { ActiveUsers: data.Results }
                };                
            }
        });
    }
    //Audio/Video Recording Section
</script>
