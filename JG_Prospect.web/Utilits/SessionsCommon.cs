using System;
using System.Web.SessionState;

/// <summary>
/// Summary description for SessionsCommon
/// </summary>
public static class SessionsCommon
{
    public static bool RedirectStudentToSummaryPage(HttpSessionState session)
    {
        if (session["visitedSummaryPageOnce"] == null)
            session["visitedSummaryPageOnce"] = "Yeah";
        else
            return false;
        return true;
    }

    public static string getTimeDifference(HttpSessionState Session)
    {
        TimeSpan difference;
        if (Session["currentExamDuration"] != null)
        {
            DateTime now = DateTime.Now;
            DateTime prevRequest = (DateTime)Session["currentExamDuration"];
            difference = now.Subtract(prevRequest);
            return ((difference.Hours * 60) + (difference.Minutes * 60) + (difference.Seconds)).ToString();
        }
        return null;
    }
}
