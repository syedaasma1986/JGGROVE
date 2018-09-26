using System;
using System.Collections.Generic;
using System.Configuration;
using System.Text;
using System.Web;

namespace JG_Prospect.Common
{
    public class JGCommon
    {
        public class UserSource
        {
            public int Id { get; set; }
            public string Source { get; set; }
        }
        public class UserAddedBy
        {
            public int UserId { get; set; }
            public string FormattedName { get; set; }
        }
        public class UserDesignation
        {
            public int Id { get; set; }
            public string DesignationName { get; set; }
            public int DepartmentId { get; set; }
            public string DesignationCode { get; set; }
        }

        public class FilterDesignation
        {
            public int Id { get; set; }
            public string DesignationName { get; set; }
        }
        public class UserStatus
        {
            public string Status { get; set; }
            public string StatusValue { get; set; }
        }

        public class TechTask
        {
            public int Id { get; set; }
            public string Title { get; set; }
        }
        public class SubTechTask
        {
            public int Id { get; set; }
            public string Title { get; set; }
        }

        public class Recruiter
        {
            public int Id { get; set; }
            public string Name { get; set; }
            public string optionCss { get; set; }
        }

        public class ReminderEmail
        {
            public int UserId { get; set; }
            public string Email { get; set; }
            public string Subject { get; set; }
            public string Body { get; set; }
            public string CustomMessage { get; set; }
        }

        public class callLog
        {
            public string mode { get; set; }
            public DateTime startTime { get; set; }
            public string num { get; set; }
            public string dur { get; set; }
        }

        public class PhoneCallStatistics
        {
            public int TotalOutbound { get; set; }
            public double TotalCallDurationInSeconds { get; set; }
            public string TotalCallDurationFormatted { get; set; }
            public string Mode { get; set; }
            public int TotalApplicantCalled { get; set; }
            public double TotalApplicantDuration { get; set; }
            public string TotalApplicantDurationFormatted { get; set; }
            public int TotalReferralApplicantCalled { get; set; }
            public double TotalReferralApplicantDuration { get; set; }
            public string TotalReferralApplicantFormatted { get; set; }
            public int TotalInterviewDateCalled { get; set; }
            public double TotalInterviewDateDuration { get; set; }
            public string TotalInterviewDateFormatted { get; set; }
        }

        public class PhoneCallLog
        {
            public int Id { get; set; }
            public string Mode { get; set; }
            public string CallerNumber { get; set; }
            public string ReceiverNumber { get; set; }
            public string ReceiverFullName { get; set; }
            public int? ReceiverUserId { get; set; }
            public int? NextReceiverUserId { get; set; }
            public double CallDurationInSeconds { get; set; }
            public string CallDurationFormatted { get; set; }
            public DateTime CallStartTime { get; set; }
            public string CallStartTimeFormatted { get; set; }
            public DateTime CreatedOn { get; set; }
            public int CreatedBy { get; set; }
            public string ReceiverProfilePic { get; set; }
            public string ReceiverUserInstallId { get; set; }
            public string CallerFullName { get; set; }
            public string CallerProfilePic { get; set; }
            public string CallerUserInstallId { get; set; }
        }
        public static string GenerateOTP(int length)
        {
            const string valid = "ABCDEFGHIJKLMNOPQRSTUVWXYZ123456789011223344556677889900";
            StringBuilder res = new StringBuilder();
            Random rnd = new Random(5);
            while (0 < length--)
            {
                res.Append(valid[rnd.Next(valid.Length)]);
            }
            return res.ToString();
        }

        public static string GetEmailUnSubscribeSection()
        {
            String html = "<div style=\"clear:both;\"></div><div style=\"text-align:center;\">if you do not want to continue receiving emails from us, Please <a href =\"#URL#/unsubscribe.aspx?e=#UNSEMAIL#\" > Unsubscribe here.</a> </div>";
            html = html.Replace("#URL#", JGApplicationInfo.GetSiteURL());

            return html;
        }

        public static string GetSequenceDisplayText(string strSequence, int DesigntionID, string seqSuffix)
        {
            var sequenceText = "#SEQ#-#DESGPREFIX#:#TORS#";

            if (strSequence == "N.A.")
            {
                sequenceText = strSequence;
            }
            else
            {
                //console.log(strSequence + strDesigntionID + seqSuffix);            
                sequenceText = sequenceText.Replace("#SEQ#", strSequence).Replace("#DESGPREFIX#", GetInstallIDPrefixFromDesignationIDinJS(DesigntionID)).Replace("#TORS#", seqSuffix);
            }
            return sequenceText;
        }

        public static string GetInstallIDPrefixFromDesignationIDinJS(int DesignID)
        {
            var prefix = "";
            switch (DesignID)
            {
                case 1:
                    prefix = "ADM";
                    break;
                case 2:
                    prefix = "JSL";
                    break;
                case 3:
                    prefix = "JPM";
                    break;
                case 4:
                    prefix = "OFM";
                    break;
                case 5:
                    prefix = "REC";
                    break;
                case 6:
                    prefix = "SLM";
                    break;
                case 7:
                    prefix = "SSL";
                    break;
                case 8:
                    prefix = "ITNA";
                    break;
                case 9:
                    prefix = "ITJN";
                    break;
                case 10:
                    prefix = "ITSN";
                    break;
                case 11:
                    prefix = "ITAD";
                    break;
                case 12:
                    prefix = "ITSPH";
                    break;
                case 13:
                    prefix = "ITSB";
                    break;
                case 14:
                    prefix = "INH";
                    break;
                case 15:
                    prefix = "INJ";
                    break;
                case 16:
                    prefix = "INM";
                    break;
                case 17:
                    prefix = "INLM";
                    break;
                case 18:
                    prefix = "INF";
                    break;
                case 19:
                    prefix = "COM";
                    break;
                case 20:
                    prefix = "SBC";
                    break;
                case 22:
                    prefix = "ADS";
                    break;
                case 23:
                    prefix = "ADR";
                    break;
                case 24:
                    prefix = "ITSQA";
                    break;
                case 25:
                    prefix = "ITJQA";
                    break;
                case 26:
                    prefix = "ITJPH";
                    break;
                case 27:
                    prefix = "ITSSE";
                    break;
                case 28:
                    prefix = "ITSTE";
                    break;
                case 29:
                    prefix = "ITFRXD";
                    break;
                default:
                    prefix = "N.A.";
                    break;
            }

            return prefix;
        }

        public static void CreateIfNotExists(string path)
        {
            bool isExists = System.IO.Directory.Exists(path);
            if (!isExists)
                System.IO.Directory.CreateDirectory(path);
        }
    }

    public class JGApplicationInfo
    {
        public static double GetAcceptiblePrecentage()
        {
            return Convert.ToDouble(ConfigurationManager.AppSettings["AcceptableUserPercentage"]);
        }
        public static Int32 GetJMGCAutoUserID()
        {
            return Convert.ToInt32(ConfigurationManager.AppSettings["JMGCAUTOUSERID"]);
        }
        public static string GetApplicationEnvironment()
        {
            return ConfigurationManager.AppSettings["ApplicationEnvironment"];

        }
        public static string GetSiteURL()
        {
            return ConfigurationManager.AppSettings["URL"];

        }
        public static string GetDefaultBCCEmail()
        {
            return ConfigurationManager.AppSettings["DefaultBCCEmail"];

        }

        public static bool IsSendEmailExceptionOn()
        {
            bool returnVal = false;

            if (ConfigurationManager.AppSettings["AllowEmailSendingExceptionEmail"].Equals("1"))
            {
                returnVal = true;
            }

            return returnVal;
        }


    }

    public class GlobalSearchModel
    {
        public GlobalSearchModel()
        {
            SearchUsersByFirstName = new List<Common.SearchUser>();
            SearchUsersByLastName = new List<Common.SearchUser>();
            SearchUsersByEmail = new List<Common.SearchUser>();
        }
        public List<SearchUser> SearchUsersByFirstName { get; set; }
        public List<SearchUser> SearchUsersByLastName { get; set; }
        public List<SearchUser> SearchUsersByEmail { get; set; }
    }

    public class SearchUser
    {
        public int Id { get; set; }
        public string Fullname { get; set; }
        public string Email { get; set; }
    }
}
