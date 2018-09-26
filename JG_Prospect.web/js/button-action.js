var gapBetweenCall = 10000;// miliseconds
var gapBetweenRecallingSameUser = 3600000;// miliseconds
var currentCallingUserId = 0;
var currentCallingUserInstallId = '';
var currentCallingUserNumber = 0;
var currentCallingCode = 0;
var currentCallingUserSeq = 0;
var currentCallingPhoneSeq = 0;
var currentCallingUserLastCalledAt = '';
var autoDialerOn = false;
var pauseDialer = false;
var salesUsers = [];


/**************** new plivo settings *//////
var callStorage = {}, phoneTimer = "00:00:00";
// UI tweaks
$('#makecall').attr('class', 'btn btn-success btn-block flatbtn disabled');

function date() {
    return (new Date()).toISOString().substring(0, 10) + " " + Date().split(" ")[4];
}
function kickStartNow() {
    //$('.callScreen').hide();
    //$('.loader').show();
    //$('.fadein-effect').fadeIn(5000);	
}
function login(username, password) {
    if (username && password) {
        //start UI load spinner
        kickStartNow();
        plivoWebSdk.client.login(username, password);
        //$('#sipUserName').html(username);
        //document.querySelector('title').innerHTML=username;
    } else {
        console.error('username/password missing!')
    }
}
function audioDeviceChange(e) {
    console.log('audioDeviceChange', e);
    if (e.change) {
        if (e.change == "added") {
            customAlert(e.change, e.device.kind + " - " + e.device.label, 'info');
        } else {
            customAlert(e.change, e.device.kind + " - " + e.device.label, 'warn');
        }
    } else {
        customAlert('info', 'There is an audioDeviceChange but mediaPermission is not allowed yet');
    }
}
function onWebrtcNotSupported() {
    console.warn('no webRTC support');
    alert('Webrtc is not supported in this broswer, Please use latest version of chrome/firefox/opera/IE Edge');
}
function mediaMetrics(obj) {
    /**
	* Set a trigger for Quality FB popup when there is an warning druing call using sessionStorage
	* During `onCallTerminated` event check for `triggerFB` flag
	*/
    sessionStorage.setItem('triggerFB', true);
    console.table([obj]);
    var classExist = document.querySelector('.-' + obj.type);
    var message = obj.type;
    /**
	* If there is a same audio level for 3 samples then we will get a trigger
	* If audio level is greater than 30 then it could be some continuous echo or user is not speaking
	* Set message "same level" for audio greater than 30. Less than 30 could be a possible mute  	
	*/
    if (obj.type.match('audio') && obj.value > 30) {
        message = "same level";
    }
    if (obj.active) {
        classExist ? classExist.remove() : null;
        $(".alertmsg").prepend(
          '<div class="metrics -' + obj.type + '">' +
          '<span style="margin-left:20px;">' + obj.level + ' | </span>' +
          '<span style="margin-left:20px;">' + obj.group + ' | </span>' +
          '<span style="margin-left:20px;">' + message + ' - ' + obj.value + ' : </span><span >' + obj.desc + '</span>' +
          '<span aria-hidden="true" onclick="closeMetrics(this)" style="margin-left:25px;cursor:pointer;">X</span>' +
          '</div>'
        );
    }
    if (!obj.active && classExist) {
        document.querySelector('.-' + obj.type).remove();
    }
    // Handle no mic input even after mic access
    if (obj.desc == "no access to your microphone") {
        $('#micAccessBlock').modal({ show: true })
    }
}

function onReady() {
    $('#phonestatus').html('trying to login...');
    console.info('Ready');
}
function onLogin() {
    //$('#phonestatus').html('online');
    console.info('Logged in');
    $('#makecall').attr('class', 'btn btn-success btn-block flatbtn');
    $('#uiLogin').hide();
    $('#uiLogout').show();
    $('.feedback').show();
    $('.loader').remove();
}
function onLoginFailed(reason) {
    $('#phonestatus').html('login failed');
    console.info('onLoginFailed ', reason);
    customAlert('Login failure :', reason);
    $('.loader').remove()
}
function onLogout() {
    $('#phonestatus').html('Offline');
    console.info('onLogout');
}
function onCalling() {
    $('#callstatus').html('Progress...');
    console.info('onCalling');
}
function onCallRemoteRinging() {
    $('#callstatus').html('Ringing...');
    console.info('onCallRemoteRinging');
}
function onCallAnswered() {
    console.info('onCallAnswered');
    $('#callstatus').html('Answered');
    $('.hangup').show();
    // plivoWebSdk.client.logout();
    phoneTimer = 0;
    window.calltimer = setInterval(function () {
        phoneTimer = phoneTimer + 1;
        $('#callDuration').html(phoneTimer.toString().calltimer());
    }, 1000);

}
function onCallTerminated(evt) {
    // Calls when user picks and then disconnect
    $('#callstatus').html('Call Ended');
    //alert('onCallTerminated');
    if (sessionStorage.getItem('triggerFB')) {
        clearStars();
        $('#clickFeedback').trigger('click');
        // clear at end of every call
        sessionStorage.removeItem('triggerFB');
    }
    callOff(evt);
    currentCallingPhoneSeq = 0;
    if (autoDialerOn && !pauseDialer) {
        setTimeout(function () {
            callNextUser();
        }, gapBetweenCall);
    }
}
function onCallFailed(reason) {
    $('#callstatus').html('call failed');
    //alert('onCallFailed');
    if (reason && /Denied Media/i.test(reason)) {
        $('#mediaAccessBlock').modal('show');
    };
    callOff(reason);
    if (autoDialerOn && !pauseDialer) {
        // Start Calling Secondary numbers
        setTimeout(function () {
            callSecondaryNumber();
        }, 2000);
    }
}
function onMediaPermission(evt) {
    console.info('onMediaPermission', evt);
    if (evt.error) {
        customAlert('Media permission error', evt.error);
        $('#mediaAccessBlock').modal('show');
    }
}
function onIncomingCall(callerName, extraHeaders) {

    console.info('onIncomingCall : ', callerName, extraHeaders);
    callStorage.startTime = date();
    callStorage.mode = 'in';
    callStorage.num = callerName;
    $('#boundType').html('Incomming :');
    $('#callNum').html(callerName);
    $('#callDuration').html('00:00:00');
    $('.callinfo').show();
    $('.callScreen').show();
    $('.inboundBeforeAnswer').show();
    $('#makecall').hide();
}
function onIncomingCallCanceled() {
    //alert('onIncomingCallCanceled');
    callOff();
}

function callOff(reason) {
    if (typeof reason == "object") {
        customAlert('Hangup', JSON.stringify(reason));
    } else if (typeof reason == "string") {
        customAlert('Hangup', reason);
    }
    $('.callScreen').hide();
    $('.inboundBeforeAnswer').hide();
    $('.AfterAnswer').hide();
    $('.outboundBeforeAnswer').hide();
    $('.hangup').hide();
    $('#makecall').show();
    window.calltimer ? clearInterval(window.calltimer) : false;
    callStorage.dur = phoneTimer.toString().calltimer();

    if (phoneTimer == "00:00:00" && callStorage.mode == "in") {
        callStorage.mode = "missed";
    }
    saveCallLog(callStorage);
    $('#callstatus').html('Idle');
    $('.callinfo').hide();
    callStorage = {}; // reset callStorage
    phoneTimer = "00:00:00"; //reset the phoneTimer

    // remove calling blinking css
    $('#SalesUserGrid > tr').removeClass('current-calling-blink');
}

String.prototype.calltimer = function () {
    var sec_num = parseInt(this, 10);
    var hours = Math.floor(sec_num / 3600);
    var minutes = Math.floor((sec_num - (hours * 3600)) / 60);
    var seconds = sec_num - (hours * 3600) - (minutes * 60);
    if (hours < 10) { hours = "0" + hours; }
    if (minutes < 10) { minutes = "0" + minutes; }
    if (seconds < 10) { seconds = "0" + seconds; }
    return hours + ':' + minutes + ':' + seconds;
}
function closeMetrics(e) {
    e.parentElement.remove();
}

function resetSettings(source) {
    // You can use all your default settings to go in as options during sdk init
    var defaultSettings = { "debug": "OFF", "permOnClick": true, "codecs": ["OPUS", "PCMU"], "enableIPV6": false, "audioConstraints": { "optional": [{ "googAutoGainControl": false }] }, "dscp": true, "enableTracking": true }
    var uiSettings = document.querySelector('#appSettings');
    uiSettings.value = JSON.stringify(defaultSettings);
    if (source == 'clickTrigger')
        localStorage.removeItem('plivosettings');
}

function refreshSettings() {
    var getSettings = localStorage.getItem('plivosettings');
    var uiSettings = document.querySelector('#appSettings');
    if (getSettings) {
        uiSettings.value = getSettings;
        return JSON.parse(getSettings);
    } else {
        return JSON.parse(uiSettings.value);
    }
}
function updateSettings(val) {
    localStorage.setItem('plivosettings', val);
    console.log('plivosettings updated!')
}
function customAlert(header, alertMessage, type) {
    var typeClass = "";
    if (type == "info") {
        typeClass = "alertinfo";
    } else if (type == "warn") {
        typeClass = "alertwarn";
    }
    $(".alertmsg").prepend(
	  '<div class="customAlert' + ' ' + typeClass + '">' +
	  '<span style="margin-left:20px;">' + header + ' | </span>' +
	  '<span style="margin-left:20px;">' + alertMessage + ' </span>' +
	  '<span aria-hidden="true" onclick="closeMetrics(this)" style="margin-left:25px;cursor:pointer;">X</span>' +
	  '</div>'
	);
}

function updateAudioDevices() {
    // Remove existing options if any
    document.querySelectorAll('#micDev option').forEach(e=>e.remove())
    document.querySelectorAll('#ringtoneDev option').forEach(e=>e.remove())

    plivoWebSdk.client.audio.availableDevices()
	.then(function (e) {
	    e.forEach(function (dev) {
	        if (dev.label && dev.kind == "audioinput")
	            $('#micDev').append('<option value=' + dev.deviceId + '>' + dev.label + '</option>')
	        if (dev.label && dev.kind == "audiooutput") {
	            $('#ringtoneDev').append('<option value=' + dev.deviceId + '>' + dev.label + '</option>');
	            $('#speakerDev').append('<option value=' + dev.deviceId + '>' + dev.label + '</option>')
	        }
	    });
	})
	.catch(function (error) {
	    console.error(error);
	})
}

function clearStars() {
    var stars = document.querySelectorAll('.star');
    for (i = 0; i < stars.length; i++) {
        $(stars[i]).removeClass('selected');
    }
    document.querySelectorAll('[name="callqualitycheck"]').forEach(e=> {
        e.checked ? (e.checked = false) : null;
    });
    sendFeedbackComment.value = "";
}

function checkBrowserComplaince(client) {
    if (client.browserDetails.browser != "chrome") {
        document.querySelector('[data-target="#popAudioDevices"]').remove();
    }
}

function trimSpace(e) {
    e.value = e.value.replace(/[- ()]/g, '');
}

function callLogDiv(e) {
    var mapper = {
        "in": "arrow-down log-in",
        "out": "share-alt log-out",
        "missed": "arrow-down log-missed"
    }
    $('#callHistoryTable').prepend(
		'<tr>' +
			'<td><span class="glyphicon glyphicon-' + mapper[e.mode] + '"></span></td>' +
			'<td>' + e.num + '</td>' +
			'<td>' + e.dur + '</td>' +
			'<td>' + e.startTime + '</td>' +
			'<td><span class="glyphicon glyphicon-earphone log-call" data-dismiss="modal" onclick="makecallCallLog(this)"></span></button></td>' +
		'</tr>'
	);
    return;
}

function saveCallLog(e) {
    var callLog = localStorage.getItem('pli_callHis');
    var formatCallLog = JSON.parse(callLog);
    var callLogStr;
    callLogDiv(e);
    if (formatCallLog.length > 50) {
        formatCallLog.shift();// Pops first element
        console.info('Call log exceeded 50 rows, removing oldest log')
    }
    formatCallLog.push({ "mode": e.mode, "num": e.num, "dur": e.dur, "startTime": e.startTime });
    callLogStr = JSON.stringify(formatCallLog);
    localStorage.setItem('pli_callHis', callLogStr);
    var strObj = { "mode": e.mode, "num": e.num, "dur": e.dur, "startTime": e.startTime };
    // Save call log into database
    var userId = autoDialerOn == true ? currentCallingUserId : null;
    var installUserId = autoDialerOn == true ? currentCallingUserInstallId : null;

    if (userId == null)
        userId = $('#SalesUserGrid > tr[number="' + e.num + '"]').attr('userid');

    var seq = parseInt($('#SalesUserGrid > tr[userid="' + userId + '"]').attr('seq'));
    var nextUserId = userId == null ? null : $('#SalesUserGrid > tr[seq="' + (seq + 1) + '"]').attr('userid');
    if (nextUserId == undefined)
        nextUserId = null;

    var userchatgroupid = $('#SalesUserGrid > tr[userid="' + userId + '"]').find('.notes-table').attr('userchatgroupid');
    var chatGroupId = $('#SalesUserGrid > tr[userid="' + userId + '"]').find('.notes-table').attr('chatgroupid');
    if (userchatgroupid == undefined || userchatgroupid == null || userchatgroupid == '') {
        userchatgroupid = 0;
    }
    if (userId == undefined || userId == '')
        userId = null;
    ajaxExt({
        url: '/WebServices/JGWebService.asmx/savePhoneCallLog',
        type: 'POST',
        data: '{mode:"' + e.mode + '",num:"' + e.num + '",dur:"' + e.dur + '",userId:' + userId + ', nextUserId:' + nextUserId + ',chatGroupId:"' + chatGroupId + '",UserChatGroupId:' + userchatgroupid + '}',
        showThrobber: false,
        success: function (data, msg) {
            sequenceScopePhone.GetPhoneCallLogList(this, 'recent');
            if (userId != null) {
                LoadNotes($('#user-' + userId), userId);
                var ctrl = $('#SalesUserGrid tr[userid="' + userId + '"]').find('.secondary-status > select');
                $(ctrl).val(10);
                //$(ctrl).trigger('change');
                $(ctrl).trigger("chosen:updated");
            }
            if (e.dur != '00:00:00' && userId != null) {

                // load notes
                //var msg = '<div class="global-msg">Please do not forget to change the secondary status for this user!!!</div>';
                //$('.global-msg').remove();
                //$('body').append(msg);
                //setTimeout(function () {
                //    $('.global-msg').remove();
                //}, 6000);
            } else {

            }

            // to next position
            if (userId != null && userId != undefined) {
                var seq = parseInt($('#SalesUserGrid > tr[userid="' + userId + '"]').attr('seq'));
                // set call seek position
                $('#SalesUserGrid').find('.caller-position').find('span').hide();
                $('#SalesUserGrid').find('.caller-position').find('input').show();

                $('#SalesUserGrid tr[userid="' + nextUserId + '"]').find('.caller-position').find('span').show();
                $('#SalesUserGrid tr[userid="' + nextUserId + '"]').find('.caller-position').find('input').hide();
            }
        }
    });
}

function displayCallHistory() {
    var callLog = localStorage.getItem('pli_callHis');
    if (callLog) {
        var formatCallLog = JSON.parse(callLog);
        var mapper = {
            "in": "right log-in",
            "out": "left log-out",
            "missed": "down log-missed"
        }
        for (var i = 0; i < formatCallLog.length; i++) {
            callLogDiv(formatCallLog[i]);
        }
    } else {
        localStorage.setItem('pli_callHis', '[]');
    }
}
function makecallCallLog(e) {
    var to = e.parentNode.parentNode.childNodes[1].innerHTML;
    toNumber.value = to; // update the dial input 
    makecall.click(); // trigger call	
}
/** 
* Hangup calls on page reload / close
* This is will prevent the other end still listening for dead call
*/
window.onbeforeunload = function () {
    plivoWebSdk.client && plivoWebSdk.client.logout();
};

/*
	Capture UI onclick triggers 
*/
$('#inboundAccept').click(function () {
    console.info('Call accept clicked');
    plivoWebSdk.client.answer();
    $('.inboundBeforeAnswer').hide();
    $('.AfterAnswer').show();
});
$('#inboundReject').click(function () {
    console.info('callReject');
    plivoWebSdk.client.reject();
});
$('#outboundHangup').click(function () {
    console.info('outboundHangup');
    plivoWebSdk.client.hangup();
});
$('.hangup').click(function () {
    //alert('Hangup');
    //if (plivoWebSdk.client.callSession) {
    plivoWebSdk.client.hangup();
    //} else {
    //callOff();
});

$('#tmute').click(function (e) {
    var event = e.currentTarget.getAttribute('data-toggle');
    if (event == "mute") {
        plivoWebSdk.client.mute();
        e.currentTarget.setAttribute('data-toggle', 'unmute');
        $('.tmute').attr('class', 'fa tmute fa-microphone-slash')
    } else {
        plivoWebSdk.client.unmute();
        e.currentTarget.setAttribute('data-toggle', 'mute');
        $('.tmute').attr('class', 'fa tmute fa-microphone')
    }
});
$('#makecall').click(function (e) {
    var cCode = $('#phone').find('.intl-tel-input.allow-dropdown').find('ul.country-list').find('li.country.active').find('span.dial-code').html();
    var to = cCode + $('#toNumber').val().replace(" ", ""),
		extraHeaders,
		customCallerId = localStorage.getItem('setCallerId'),
		customCallerIdEnabled = localStorage.getItem('setCallerIdCheck');
    if (customCallerIdEnabled && customCallerId) {
        customCallerId = customCallerId.replace("+", "");
        extraHeaders = { 'X-PH-callerId': customCallerId };
    }
    var callEnabled = $('#makecall').attr('class').match('disabled');
    if (!to || !plivoWebSdk || !!callEnabled) { return };
    if (!plivoWebSdk.client.isLoggedIn) { alert('You\'re not Logged in!') }
    plivoWebSdk.client.call(to, extraHeaders);
    console.info('Click make call : ', to);
    callStorage.mode = "out";
    callStorage.startTime = date();
    callStorage.num = to;
    $('.callScreen').show();
    $('.AfterAnswer').show();
    $('#boundType').html('Outgoing :');
    $('#callNum').html(to);
    $('#callDuration').html('00:00:00');
    $('.callinfo').show();
    $('.hangup').show();
    $('#makecall').hide();

    //phoneTimer = 0;
    //window.calltimer = setInterval(function () {
    //    phoneTimer = phoneTimer + 1;
    //    $('#callDuration').html(phoneTimer.toString().calltimer());
    //}, 1000);

    e.stopPropagation();
});

$('#updateSettings').click(function (e) {
    var appSettings = document.querySelector('#appSettings');
    appSettings = appSettings.value;
    updateSettings(appSettings);
});

$('#resetSettings').click(function (e) {
    resetSettings('clickTrigger');
});

$('#sendFeedback').click(function () {
    var score = $('#stars li.selected').last().data('value');
    score = Number(score);
    var lastCallid = plivoWebSdk.client.getLastCallUUID();
    // var comment = $("input[type=radio][name=callqualitycheck]:checked").val() || "good";
    var comment = "";
    if (score == 5) {
        comment = "good";
    }
    document.querySelectorAll('[name="callqualitycheck"]').forEach(e=> {
        if (e.checked) {
            comment = comment + "," + e.value;
        }
    });
    if (sendFeedbackComment.value) {
        comment = comment + "," + sendFeedbackComment.value;
    }
    comment = comment.slice(1);
    if (!comment) {
        customAlert('feedback', 'Please select any comment');
        return;
    }
    if (!score) {
        customAlert('feedback', 'Please select star');
        return;
    }
    plivoWebSdk.client.sendQualityFeedback(lastCallid, score, comment);
    customAlert('Quality feedback ', lastCallid);
});

$('#clickLogin').click(function (e) {
    var userName = $('#loginUser').val();
    var password = $('#loginPwd').val();
    login(userName, password);
});

// Audio device selection
$('#micDev').change(function () {
    var selectDev = $('#micDev').val();
    plivoWebSdk.client.audio.microphoneDevices.set(selectDev);
    console.debug('Microphone device set to : ', selectDev);
});
$('#speakerDev').change(function () {
    var selectDev = $('#speakerDev').val();
    plivoWebSdk.client.audio.speakerDevices.set(selectDev);
    console.debug('Speaker device set to : ', selectDev);
});
$('#ringtoneDev').change(function () {
    var selectDev = $('#ringtoneDev').val();
    plivoWebSdk.client.audio.ringtoneDevices.set(selectDev);
    console.debug('Ringtone dev set to : ', selectDev);
});

// Ringtone device test
$('#ringtoneDevTest').click(function () {
    var ringAudio = plivoWebSdk.client.audio.ringtoneDevices.media();
    // Toggle play
    if (ringAudio.paused) {
        ringAudio.play();
        $('#ringtoneDevTest').html('Pause');
    } else {
        ringAudio.pause();
        $('#ringtoneDevTest').html('Play');
    }
});
// Speaker device test
$('#speakerDevTest').click(function () {
    var speakerAudio = plivoWebSdk.client.audio.speakerDevices.media();
    // Toggle play
    if (speakerAudio.paused) {
        speakerAudio.play();
        $('#speakerDevTest').html('Pause');
    } else {
        speakerAudio.pause();
        $('#speakerDevTest').html('Play');
    }
});
//revealAudioDevices	
$('#allowAudioDevices').click(function () {
    document.querySelectorAll('#popAudioDevices option').forEach(e=>e.remove());
    plivoWebSdk.client.audio.revealAudioDevices()
	.then(function (e) {
	    updateAudioDevices();
	    console.log('Media permission ', e)
	})
	.catch(function (error) {
	    console.error('media permission error :', error);
	    $('#mediaAccessBlock').modal('show');
	})
});

$('.num').click(function () {
    var num = $(this);
    var text = $.trim(num.find('.txt').clone().children().remove().end().text());
    var telNumber = $('#toNumber');
    $(telNumber).val(telNumber.val() + text);
    if (plivoWebSdk && plivoWebSdk.client.callSession) {
        plivoWebSdk.client.sendDtmf(text);
    }
});

//clearLogs.onclick = function(){
//    localStorage.setItem('pli_callHis','[]');
//    callHistoryTable.innerHTML=""
//}

//showPass.onclick = function(){
//    if($('#showPass input').prop("checked")){
//        loginPwd.type="text";
//    }else{
//        loginPwd.type="password";
//    }
//}

function starFeedback() {
    $('#stars li').on('mouseover', function () {
        var onStar = parseInt($(this).data('value'), 10);
        $(this).parent().children('li.star').each(function (e) {
            if (e < onStar) {
                $(this).addClass('hover');
            }
            else {
                $(this).removeClass('hover');
            }
        });
    }).on('mouseout', function () {
        $(this).parent().children('li.star').each(function (e) {
            $(this).removeClass('hover');
        });
    });

    $('#stars li').on('click', function () {
        var onStar = parseInt($(this).data('value'), 10);
        var stars = $(this).parent().children('li.star');

        for (i = 0; i < stars.length; i++) {
            $(stars[i]).removeClass('selected');
        }

        for (i = 0; i < onStar; i++) {
            $(stars[i]).addClass('selected');
        }

        var value = parseInt($('#stars li.selected').last().data('value'), 10);
        if (value < 5) {
            $('.lowQualityRadios').show();
        } else {
            $('.lowQualityRadios').hide();
        }

    });
}
// variables to declare 

var plivoWebSdk; // this will be retrived from settings in UI

function initPhone(username, password) {
    var options = refreshSettings();
    plivoWebSdk = new window.Plivo(options);
    plivoWebSdk.client.on('onWebrtcNotSupported', onWebrtcNotSupported);
    plivoWebSdk.client.on('onLogin', onLogin);
    plivoWebSdk.client.on('onLogout', onLogout);
    plivoWebSdk.client.on('onLoginFailed', onLoginFailed);
    plivoWebSdk.client.on('onCallRemoteRinging', onCallRemoteRinging);
    plivoWebSdk.client.on('onIncomingCallCanceled', onIncomingCallCanceled);
    plivoWebSdk.client.on('onCallFailed', onCallFailed);
    plivoWebSdk.client.on('onCallAnswered', onCallAnswered);
    plivoWebSdk.client.on('onCallTerminated', onCallTerminated);
    plivoWebSdk.client.on('onCalling', onCalling);
    plivoWebSdk.client.on('onIncomingCall', onIncomingCall);
    plivoWebSdk.client.on('onMediaPermission', onMediaPermission);
    plivoWebSdk.client.on('mediaMetrics', mediaMetrics);
    plivoWebSdk.client.on('audioDeviceChange', audioDeviceChange);
    plivoWebSdk.client.setRingTone(true);
    plivoWebSdk.client.setRingToneBack(true);
    // plivoWebSdk.client.setConnectTone(false);
    /** Handle browser issues
	* Sound devices won't work in firefox
	*/
    checkBrowserComplaince(plivoWebSdk.client);
    updateAudioDevices();
    displayCallHistory();
    starFeedback();
    console.log('initPhone ready!')

    // Do login
    login('jgdeveloper180225074457', 'Admin@123');
}

function getAllSelectValues(sender) {
    var values = [];
    $(sender).find('ul.options li').each(function (i) {
        var num = $(this).attr('value');
        if (isValidPhoneNumber(num)) {
            values.push(num);
        }
    });
    return values;
}

// Auto Dialer Logic
function startAutoDialer(sender) {
    debugger;
    var num = 1;
    currentCallingPhoneSeq = 0;
    if (pauseDialer) {
        pauseDialer = false;
    } else {
        currentCallingUserSeq = 0;
    }

    if (!autoDialerOn && !pauseDialer) {
        $('#SalesUserGrid > tr').each(function () {
            salesUsers.push({
                Seq: num++,
                UserId: $(this).attr('userid'),
                UserInstallId: $(this).attr('userinstallid'),
                LastCalledAt: $(this).attr('last-called-at'),
                Number: $(this).attr('number'),
                Code: $(this).attr('code'),
                AllNumbers: getAllSelectValues($(this).find('.userPhones .clickable-dropdown')),
                CalledNow: false
            });
            if ($(this).find('.caller-position').find('span').is(':visible')) {
                currentCallingUserId = $(this).attr('userid');
                currentCallingUserSeq = num == 1 ? num - 1 : num - 2;
            }
        });
    }
    $('#SalesUserGrid > tr').each(function () {
        if ($(this).find('.caller-position').find('span').is(':visible')) {
            currentCallingUserId = $(this).attr('userid');
            currentCallingUserSeq = parseInt($(this).attr('seq'));
        }
    });

    $('.play-stop').find('span.pause').show();
    $('.play-stop').find('span.play').hide();

    if (currentCallingUserSeq < salesUsers.length) {
        currentCallingUserId = salesUsers[currentCallingUserSeq].UserId;
        currentCallingUserInstallId = salesUsers[currentCallingUserSeq].UserInstallId;
        currentCallingUserLastCalledAt = salesUsers[currentCallingUserSeq].LastCalledAt;
        currentCallingUserNumber = salesUsers[currentCallingUserSeq].AllNumbers[currentCallingPhoneSeq];
        currentCallingCode = salesUsers[currentCallingUserSeq].Code;
        autoDialerOn = true;
        pauseDialer = false;
        if (isValidPhoneNumber(currentCallingUserNumber)) {
            $('#phone').find('#toNumber').val(currentCallingUserNumber);
            SetCountryCode(currentCallingCode);
            $('#phone').find('#makecall').trigger('click');
            $('#SalesUserGrid > tr').removeClass('current-calling-blink');
            $('tr[userid="' + currentCallingUserId + '"]').addClass('current-calling-blink');
            // Get row position by index
            var ypos = $('tr.current-calling-blink').offset().top;
            // Go to row
            $('.auto-dialer-bottom-section').animate({
                scrollTop: $('.auto-dialer-bottom-section').scrollTop() + ypos - 370
            }, 500);

        } else {
            callNextUser();
        }
    }
}

function SetCountryCode(code) {
    $('#phone').find('.intl-tel-input.allow-dropdown').find('ul.country-list').find('li.country').removeClass('active');
    $('#phone').find('.intl-tel-input.allow-dropdown').find('ul.country-list').find('li.country').removeClass('highlight');
    $('#phone').find('.intl-tel-input.allow-dropdown').find('ul.country-list').find('li.country[data-dial-code="' + code + '"]').addClass('highlight');
    $('#phone').find('.intl-tel-input.allow-dropdown').find('ul.country-list').find('li.country[data-dial-code="' + code + '"]').addClass('active');

    var flag = $('#phone').find('.intl-tel-input.allow-dropdown').find('ul.country-list').find('li.country.active').attr('data-country-code');
    var cName = $('#phone').find('.intl-tel-input.allow-dropdown').find('ul.country-list').find('li.country.active').find('span.country-name').html();
    var cCode = $('#phone').find('.intl-tel-input.allow-dropdown').find('ul.country-list').find('li.country.active').find('span.dial-code').html();
    $('#phone').find('.intl-tel-input.allow-dropdown').find('div.selected-flag').find('div.iti-flag').attr('class', 'iti-flag ' + flag);
    $('#phone').find('.intl-tel-input.allow-dropdown').find('div.selected-flag').find('div.iti-flag').attr('title', cName + ': ' + cCode);
}

function callNextUser() {
    currentCallingUserSeq += 1;
    currentCallingPhoneSeq = 0;
    if (currentCallingUserSeq < salesUsers.length) {
        currentCallingUserId = salesUsers[currentCallingUserSeq].UserId;
        currentCallingUserInstallId = salesUsers[currentCallingUserSeq].UserInstallId;
        currentCallingUserLastCalledAt = salesUsers[currentCallingUserSeq].LastCalledAt;
        currentCallingUserNumber = salesUsers[currentCallingUserSeq].AllNumbers[currentCallingPhoneSeq];
        currentCallingCode = salesUsers[currentCallingUserSeq].Code;

        if (isValidPhoneNumber(currentCallingUserNumber)) {
            $('#phone').find('#toNumber').val(currentCallingUserNumber);
            SetCountryCode(currentCallingCode);
            $('#phone').find('#makecall').trigger('click');
            $('#SalesUserGrid > tr').removeClass('current-calling-blink');
            $('tr[userid="' + currentCallingUserId + '"]').addClass('current-calling-blink');

            // Get row position by index
            var ypos = $('tr.current-calling-blink').offset().top;
            // Go to row
            $('.auto-dialer-bottom-section').animate({
                scrollTop: $('.auto-dialer-bottom-section').scrollTop() + ypos - 370
            }, 500);
        } else {
            callNextUser();
        }
    } else if (currentCallingUserSeq == salesUsers.length) {
        //alert('list ended');
        console.clear();
        console.log('callNextUser : move to next page')
        var currentPage = parseInt($('#PageIndex').val());
        $('#PageIndex').val((currentPage + 1));
        paging.currentPage = currentPage + 1;
        Paging(this, false, true);
        stopAutoDialer(this);
    } else {
        stopAutoDialer(this);
        // list ended, now stop auto-dialer
        alert('List not yet started.');
    }
}

function callSecondaryNumber() {
    currentCallingPhoneSeq += 1;
    if (currentCallingPhoneSeq < salesUsers[currentCallingUserSeq].AllNumbers.length) {
        currentCallingUserNumber = salesUsers[currentCallingUserSeq].AllNumbers[currentCallingPhoneSeq];
        currentCallingCode = salesUsers[currentCallingUserSeq].Code;
    } else {
        callNextUser();
    }
    if (isValidPhoneNumber(currentCallingUserNumber)) {
        $('#phone').find('#toNumber').val(currentCallingUserNumber);
        SetCountryCode(currentCallingCode);
        $('#phone').find('#makecall').trigger('click');
        $('#SalesUserGrid > tr').removeClass('current-calling-blink');
        $('tr[userid="' + currentCallingUserId + '"]').addClass('current-calling-blink');
        // Get row position by index
        var ypos = $('tr.current-calling-blink').offset().top;
        // Go to row
        $('.auto-dialer-bottom-section').animate({
            scrollTop: $('.auto-dialer-bottom-section').scrollTop() + ypos - 370
        }, 500);
    } else {
        setTimeout(function () {
            callSecondaryNumber();
        }, 2000);
    }
}

function stopAutoDialer(sender) {
    autoDialerOn = false;
    pauseDialer = false;
    $('.play-stop').find('span.pause').hide();
    $('.play-stop').find('span.play').show();
    salesUsers.length = 0;// reset dialing list
}

function pauseAutoDialer(sender) {
    autoDialerOn = true;
    pauseDialer = true;
    currentCallingUserSeq += 1; // move to next user 
    $('.play-stop').find('span.pause').hide();
    $('.play-stop').find('span.play').show();
}
function dialPreviousNumber(sender) {
    if (autoDialerOn) {
        // disconnect current call
        $('input.hangup').trigger('click');
    }
    $('.play-stop').find('span.pause').show();
    $('.play-stop').find('span.play').hide();
    if (currentCallingUserSeq > 0 && autoDialerOn) {
        currentCallingUserSeq -= 2; // move to previous 2 users, callNextUser function will move 1 farward.
        callNextUser();
    } else {
        autoDialerOn = true;
        pauseDialer = false;
        var num = 1;
        $('#SalesUserGrid > tr').each(function () {
            salesUsers.push({
                Seq: num++,
                UserId: $(this).attr('userid'),
                UserInstallId: $(this).attr('userinstallid'),
                LastCalledAt: $(this).attr('last-called-at'),
                Number: $(this).attr('number'),
                Code: $(this).attr('code'),
                AllNumbers: getAllSelectValues($(this).find('.userPhones .clickable-dropdown')),
                CalledNow: false
            });
        });
        currentCallingPhoneSeq = 0;
        currentCallingUserSeq = 0; // starts from first user
        $('.play-stop').find('span.pause').show();
        $('.play-stop').find('span.play').hide();

        if (currentCallingUserSeq < salesUsers.length) {
            currentCallingUserId = salesUsers[currentCallingUserSeq].UserId;
            currentCallingUserInstallId = salesUsers[currentCallingUserSeq].UserInstallId;
            currentCallingUserLastCalledAt = salesUsers[currentCallingUserSeq].LastCalledAt;
            currentCallingUserNumber = salesUsers[currentCallingUserSeq].AllNumbers[currentCallingPhoneSeq];
            currentCallingCode = salesUsers[currentCallingUserSeq].Code;
            autoDialerOn = true;
            pauseDialer = false;
            if (isValidPhoneNumber(currentCallingUserNumber)) {
                $('#phone').find('#toNumber').val(currentCallingUserNumber);
                SetCountryCode(currentCallingCode);
                $('#phone').find('#makecall').trigger('click');

                $('#SalesUserGrid > tr').removeClass('current-calling-blink');
                $('tr[userid="' + currentCallingUserId + '"]').addClass('current-calling-blink');
                // Get row position by index
                var ypos = $('tr.current-calling-blink').offset().top;
                // Go to row
                $('.auto-dialer-bottom-section').animate({
                    scrollTop: $('.auto-dialer-bottom-section').scrollTop() + ypos - 370
                }, 500);

            } else {
                callNextUser();
            }
        }
    }

}
function diaNextNumber(sender) {
    if (autoDialerOn) {
        // disconnect current call
        $('input.hangup').trigger('click');
    }
    //currentCallingUserSeq += 1; // move to next user // callNextUser function will move 1 farward.
    $('.play-stop').find('span.pause').show();
    $('.play-stop').find('span.play').hide();
    if (currentCallingUserSeq > 0 && autoDialerOn) {
        callNextUser();
    }
    else {
        autoDialerOn = true;
        pauseDialer = false;
        var num = 1;
        $('#SalesUserGrid > tr').each(function () {
            salesUsers.push({
                Seq: num++,
                UserId: $(this).attr('userid'),
                UserInstallId: $(this).attr('userinstallid'),
                LastCalledAt: $(this).attr('last-called-at'),
                Number: $(this).attr('number'),
                Code: $(this).attr('code'),
                AllNumbers: getAllSelectValues($(this).find('.userPhones .clickable-dropdown')),
                CalledNow: false
            });
        });
        currentCallingPhoneSeq = 0;
        currentCallingUserSeq = 1; // starts from second user
        $('.play-stop').find('span.pause').show();
        $('.play-stop').find('span.play').hide();

        if (currentCallingUserSeq < salesUsers.length) {
            currentCallingUserId = salesUsers[currentCallingUserSeq].UserId;
            currentCallingUserInstallId = salesUsers[currentCallingUserSeq].UserInstallId;
            currentCallingUserLastCalledAt = salesUsers[currentCallingUserSeq].LastCalledAt;
            currentCallingUserNumber = salesUsers[currentCallingUserSeq].AllNumbers[currentCallingPhoneSeq];
            currentCallingCode = salesUsers[currentCallingUserSeq].Code;
            autoDialerOn = true;
            pauseDialer = false;
            if (isValidPhoneNumber(currentCallingUserNumber)) {
                $('#phone').find('#toNumber').val(currentCallingUserNumber);
                SetCountryCode(currentCallingCode);
                $('#phone').find('#makecall').trigger('click');

                $('#SalesUserGrid > tr').removeClass('current-calling-blink');
                $('tr[userid="' + currentCallingUserId + '"]').addClass('current-calling-blink');
                // Get row position by index
                var ypos = $('tr.current-calling-blink').offset().top;
                // Go to row
                $('.auto-dialer-bottom-section').animate({
                    scrollTop: $('.auto-dialer-bottom-section').scrollTop() + ypos - 370
                }, 500);

            } else {
                callNextUser();
            }
        }
    }
}
function isValidPhoneNumber(num) {
    var reg = /^[1-9]{1}[0-9]{3,14}$/;
    var result = reg.test(num)
    return result;
}