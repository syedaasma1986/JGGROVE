var secs;
var timerID = null;
var timerRunning = false;
var delay = 1000;
window.onload = InitializeTimer;


function InitializeTimer()
{
    // Set the length of the timer, in seconds
    //secs = 7200;
    secs=document.getElementById('currentExamTime').value;
 //   StopTheClock();
    StartTheTimer();
}

function StopTheClock()
{
    if(timerRunning);
        clearTimeout(timerID);
    timerRunning = false;
}

function StartTheTimer()
{
    if (secs==0)
    {
        StopTheClock();        
        javascript:__doPostBack('btnSubmitExam', '');
    }
    else
    {
        //self.status = secs;
        secs = secs - 1;
        //self.status=secs;
        var mins=Math.floor(secs/60);
        var hours=Math.floor(mins/60);
        var sec=secs-(mins*60);
        var min=mins-(hours*60);
        if(min < 10)
            min="0" + min;
        if(sec < 10)
            sec="0" + sec;
        if(hours < 10)
            hours="0" + hours;
        
        var formattedTime=hours + ":" + min + ":" + sec;
        document.getElementById('lblExamTime').innerHTML=formattedTime; 
        //window.Form1.lblExamTime.innerHTML=formattedTime;
        
        timerRunning = true;
        timerID = self.setTimeout("StartTheTimer()", delay);
    }
}