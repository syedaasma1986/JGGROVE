using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Configuration;
using System.Globalization;
using System.ComponentModel;

namespace JG_Prospect.Common
{
    public class JGConstant
    {
        #region '--Constants--'

        public static CultureInfo CULTURE = System.Globalization.CultureInfo.GetCultureInfo("en-US");

        public const string JUSTIN_LOGIN_ID = "jgrove@jmgroveconstruction.com";//"jgtest2@gmail.com"; //" jgrove@jmgroveconstruction.com"
        //public const string JUSTIN_LOGIN_ID ="jgtest2@gmail.com";
        public const string PAGE_STATIC_REPORT = "StaticReport";
        public const string COLOR_RED = "red";
        public const int RETURN_ZERO = 0;
        public const int ZERO = 0;
        public const int ONE = 1;
        public const int STATUS_ID_RECEIVED_STORAGE_LOCATION = 18;
        public const int STATUS_ID_ON_STANDBY_VENDOR_LINK_TO_VENDOR_PROFILE = 19;
        public const int STATUS_ID_BEING_DELEIVERED_TO_JOBSITE = 20;
        public const bool RETURN_TRUE = true;
        public const bool RETURN_FALSE = false;
        public const string TRUE = "Yes";
        public const string UPDATE = "Update";
        public const string SAVE = "Save";
        public const string SELECT = "Select";
        public static string CustomerCalendar = ConfigurationManager.AppSettings["CustomerCalendar"].ToString();
        public const string EMAIL_STATUS_VENDORCATEGORIES = "C";
        public const string EMAIL_STATUS_VENDOR = "V";
        public const string EMAIL_STATUS_NONE = "N";
        // public const string EMAILID_VENDORCATEGORIES = "accountspayable@jmgroveconstruction.com";
        // public const string EMAILID_VENDOR = "purchasing@jmgroveconstruction.com";
        // public const string PASSWORD_VENDORCATEGORIES = "Sunrise1";
        // public const string PASSWORD_VENDOR = "Bquality1";
        public const string PROCURRING_QUOTES = "Procurring Quotes";
        public const string PRODUCT_CUSTOM = "Custom";
        public const string PRODUCT_SHUTTER = "Shutter";

        public const string Sorting_UserName = "UserName";
        //public const string Sorting_SortDirection_DESC = "DESC";
        //public const string Sorting_SortDirection_ASC = "ASC";

        public const char PERMISSION_STATUS_GRANTED = 'G';
        public const char PERMISSION_STATUS_NOTGRANTED = 'N';

        public const string USER_TYPE_ADMIN = "Admin";
        public const string USER_TYPE_JSE = "JSE";
        public const string USER_TYPE_SSE = "SSE";
        public const string USER_TYPE_MM = "MM";
        public const string USER_TYPE_SM = "SM";
        public const string USER_TYPE_ADMINSEC = "AdminSec";

        public const string CUSTOMER_STATUS_SET = "Set";
        public const string CUSTOMER_STATUS_FOLLOWUP = "Follow up";
        public const string CUSTOMER_STATUS_ASSIGNED = "Assigned";
        public const string CUSTOMER_STATUS_ORDERED = "Ordered(3)";

        public const string PageIndex = "PageIndex";
        public const string SortExpression = "SortExpression";
        public const string SortDirection = "SortDirection";
        public const string Sorting_ReferenceId = "ReferenceId";
        public const string Sorting_SortDirection_DESC = "DESC";
        public const string Sorting_SortDirection_ASC = "ASC";
        public const string GridViewData = "GridViewData";

        public const string DROPDOWNLIST = "DROPDOWNLIST";
        public const string TEXTBOX = "TEXTBOX";

        public const string RESHEDULE_INTERVIEW_DATE = "RESHEDULEINTERVIEWDATE";
        public const string ProfilPic_Upload_Folder = "~/UploadeProfile";

        public const string Default_PassWord = "jmgrove";


        //-------- start DP ---------
        public const string EventCalendar_Upload_Folder = "~/EventCalendar";
        //-------- End DP ------------

        //public static string RandomGUID = Guid.NewGuid().ToString();

        public const string ChatFilePath = "~/Chat/Attachments";

        public const string ResourceFilePath = "~/Upload/Resources";

        #endregion

        #region '--Enums--'


        /// <summary>
        /// These values are also used in ApplicationEnvironment appSettings to identify current environment for application.
        /// </summary>
        public enum ApplicationEnvironment
        {
            Local = 1,
            Staging = 2,
            Live = 3
        }

        public enum GitRepo
        {
            Interview,
            Live
        }

        public enum GitActions
        {
            AddUser,
            DeleteUser
        }

        public enum ProductType
        {
            shutter = 1,
            custom = 4
        }

        public enum CustomMaterialListStatus
        {
            Unchanged = 0,
            Added = 1,
            Deleted = 2,
            Modified = 3,
        }


        public enum TaskStatus
        {
            Open = 1,
            Requested = 2,
            Assigned = 3,
            InProgress = 4,
            Pending = 5,
            ReOpened = 6,
            Closed = 7,
            SpecsInProgress = 8,
            Deleted = 9,
            Finished = 10,
            Test = 11,
            Live = 12,
            Billed = 14
        }

        public enum TaskPriority
        {
            Critical = 1,
            High = 2,
            Medium = 3,
            Low = 4
        }

        public enum TaskType
        {
            Bug = 1,
            BetaError = 2,
            Enhancement = 3
        }

        public enum TaskFileDestination
        {
            Task = 1,
            SubTask = 2,
            WorkSpecification = 3,
            FinishedWork = 4,
            TaskNote = 5
        }

        public enum TaskUserFileType
        {
            Notes = 1,
            Audio = 2,
            Video = 3,
            Images = 4,
            Docu = 5,
            Other = 6
        }

        public enum DesignationType
        {
            Admin = 1,
            Jr_Sales = 2,
            Jr_Project_Manager = 3,
            Office_Manager = 4,
            Recruiter = 5,
            Sales_Manager = 6,
            Sr_Sales = 7,
            IT_Network_Admin = 8,
            IT_Jr_Net_Developer = 9,
            IT_Sr_Net_Developer = 10,
            IT_Android_Developer = 11,
            IT_PHP_Developer = 12,
            IT_SEO_OR_BackLinking = 13,
            Installer_Helper = 14,
            Installer_Journeyman = 15,
            Installer_Mechanic = 16,
            Installer_Lead_Mechanic = 17,
            Installer_Foreman = 18,
            Commercial_Only = 19,
            SubContractor = 20,
            IT_Lead = 21,
            Admin_Sales = 22,
            Admin_Recruiter = 23,
            IT_Jr_PHP_Developer = 24,
        }

        public enum DesignationCode
        {
            [TypeText("Admin")]
            ADM = 1,
            [TypeText("Jr. Sales")]
            JSL = 2,
            [TypeText("Jr Project Manager")]
            JPM = 3,
            [TypeText("Office Manager")]
            OFM = 4,
            [TypeText("Recruiter")]
            REC = 5,
            [TypeText("Sales Manager")]
            SLM = 6,
            [TypeText("Sr. Sales")]
            SSL = 7,
            [TypeText("IT - Network Admin")]
            ITNA = 8,
            [TypeText("IT - Jr .Net Developer")]
            ITJN = 9,
            [TypeText("IT - Sr .Net Developer")]
            ITSN = 10,
            [TypeText("IT - SR xamarin mobile developer")]
            ITSXD = 11,
            [TypeText("IT - Sr. PHP Developer")]
            ITPH = 12,
            [TypeText("IT – JR SEO/Backlinking/Content")]
            ITJSE = 13,
            [TypeText("Installer - Helper")]
            INH = 14,
            [TypeText("Installer - Journeyman")]
            INJ = 15,
            [TypeText("Installer - Mechanic")]
            INM = 16,
            [TypeText("Installer - Lead mechanic")]
            INLM = 17,
            [TypeText("Installer - Foreman")]
            INF = 18,
            [TypeText("Commercial Only")]
            COM = 19,
            [TypeText("SubContractor")]
            SBC = 20,
            [TypeText("ITLead")]
            ITL = 21,
            [TypeText("Admin-Sales")]
            ASL = 22,
            [TypeText("Admin Recruiter")]
            AREC = 23,
            [TypeText("IT - Senior QA")]
            ITQS = 24,
            [TypeText("IT - Junior QA")]
            ITQJ = 25,
            [TypeText("IT - Jr. PHP Developer")]
            ITJP = 26,
            [TypeText("IT – Sr SEO Developer")]
            ITSSE = 27,
            [TypeText("IT - Sr. Telecom Engineer")]
            ITSTE = 28,
            [TypeText("IT -  JR  xamarin mobile developer")]
            ITJXD = 29,
            [TypeText("IT - MM .Net Developer")]
            ITMN = 1028,
            [TypeText("IT - MM PHP Developer")]
            ITMPH = 1029,
            [TypeText("IT - MM SEO Developer")]
            ITMSE = 1030,
            [TypeText("IT - Jr Business Analyst(BA)")]
            ITJBA = 1031,
            [TypeText("IT - Sr Business Analyst(BA)")]
            ITSBA = 1032,
            [TypeText("IT - MM Xamarin Mobile Developer")]
            ITMXD = 1033,
            [TypeText("Middle Management Project Manager")]
            MMPM = 1034,
            [TypeText("Sr. Project Manager")]
            SPM = 1035
        }

        public enum EmployeeLegalDesclaimerUsedFor
        {
            InterviewDate = 1,
            SuccessPopup = 2,
            OfferMade = 3
        }

        public enum EmployeeInstructionUsedFor
        {
            InterviewDate = 1,
            SuccessPopup = 2,
            OfferMade = 3
        }

        public class EnumWitAttributes
        {
            public int EnumValue { get; set; }
            public int Order { get; set; }
            public string EnumText { get; set; }
            public string EnumCssClass { get; set; }
        }

        public enum InstallUserStatus
        {
            [TypeText("Rejected")]
            [StatusIcon("9")]
            [Order(1)]
            Rejected = 9,

            [TypeText("Applicant")]
            [StatusIcon("2")]
            [Order(2)]
            Applicant = 2,

            [TypeText("R-Applicant")]
            [StatusIcon("10")]
            [Order(3)]
            ReferralApplicant = 10,

            [TypeText("Applicant: Aptitude Test")]
            [StatusIcon("17")]
            [Order(4)]
            ApplicantAptitudeTest = 17,

            [TypeText("R-Applicant: Aptitude Test")]
            [StatusIcon("19")]
            [Order(5)]
            ReferralApplicantAptitudeTest = 19,

            [TypeText("Opportunity Notice: Applicant")]
            [StatusIcon("18")]
            [Order(6)]
            OpportunityNoticeApplicant = 18,

            [TypeText("R-Opportunity Notice: Applicant")]
            [StatusIcon("20")]
            [Order(7)]
            ReferralOpportunityNoticeApplicant = 20,

            [TypeText("Interview Date : Applicant")]
            [StatusIcon("5")]
            [Order(8)]
            InterviewDate = 5,

            [TypeText("R-Interview Date : Applicant")]
            [StatusIcon("21")]
            [Order(9)]
            ReferralInterviewDate = 21,

            [TypeText("Offer Made: Applicant")]
            [StatusIcon("6")]
            [Order(10)]
            OfferMade = 6,

            [TypeText("R-Offer Made: Applicant")]
            [StatusIcon("22")]
            [Order(11)]
            ReferralOfferMade = 22,

            [TypeText("Active")]
            [StatusIcon("1")]
            [Order(12)]
            Active = 1,

            [TypeText("Deactive")]
            [StatusIcon("3")]
            [Order(13)]
            Deactive = 3,

            [TypeText("Install Prospect")]
            [StatusIcon("4")]
            [Order(14)]
            InstallProspect = 4
            /* old
            [Description("Active")]
            Active = 1,
            [Description("Applicant")]
            Applicant = 2,
            [Description("Deactive")]
            Deactive = 3,
            [Description("Install Prospect")]
            InstallProspect = 4,
            [Description("Interview Date : Applicant")]
            InterviewDate = 5,
            [Description("Offer Made: Applicant")]
            OfferMade = 6,
            [Description("Phone Screened")]
            PhoneScreened = 7,
            [Description("Phone Video Screened")]
            Phone_VideoScreened = 8,
            [Description("Rejected")]
            Rejected = 9,
            [Description("Referral Applicant")]
            ReferralApplicant = 10,
            [Description("Deleted")]
            Deleted = 11,
            [Description("Hidden")]
            Hidden = 15,
            [Description("Interview Date Expired")]
            InterviewDateExpired = 16,
            [Description("Applicant: Aptitude Test")]
            ApplicantAptitudeTest = 17,
            [Description("Opportunity Notice: Applicant")]
            OpportunityNoticeApplicant = 18
            */
        }

        public enum UserSecondaryStatus
        {
            [TypeText("A - Call NOT connected- AutoVoiceMail Left")]
            [StatusIcon("1")]
            [Order(1)]
            A_CallNOTconnectedAutoVoiceMailLeft = 1,
            [TypeText("A - Bad Contact Info")]
            [StatusIcon("2")]
            [Order(2)]
            A_BadContactInfo = 2,
            [TypeText("A - Call Disconnected")]
            [StatusIcon("3")]
            [Order(3)]
            A_CallDisconnected = 3,
            [TypeText("M - Applicant Self Reject")]
            [StatusIcon("4")]
            [Order(4)]
            M_ApplicantSelfReject = 4,
            [TypeText("M - Admin Rejected Applicant: Uncooperative/Unqualified")]
            [StatusIcon("5")]
            [Order(5)]
            M_AdminRejectedApplicantUncooperativeUnqualified = 5,
            [TypeText("M - Applicant hungup - rejected ")]
            [StatusIcon("6")]
            [Order(6)]
            M_Applicanthunguprejected = 6,
            [TypeText("M - Bad/Wrong contact info")]
            [StatusIcon("7")]
            [Order(7)]
            M_BadWrongcontactinfo = 7,
            [TypeText("M - Admin Rejected Applicant: Other")]
            [StatusIcon("8")]
            [Order(8)]
            M_AdminRejectedApplicantOther = 8,
            [TypeText("M - Applicant Demands Onsite/Higher Pay")]
            [StatusIcon("9")]
            [Order(9)]
            M_ApplicantDemandsOnsiteHigherPay = 9,
            [TypeText("A - Auto Email Sent")]
            [StatusIcon("10")]
            [Order(10)]
            A_AutoEmailSent = 10,
            [TypeText("A - Applicant Opt out- Rejected")]
            [StatusIcon("11")]
            [Order(11)]
            A_ApplicantOptoutRejected = 11,
            [TypeText("A - Auto Email Opened")]
            [StatusIcon("12")]
            [Order(12)]
            A_AutoemailOpened = 12,
            [TypeText("A - Auto Emailed Loggedin")]
            [StatusIcon("13")]
            [Order(13)]
            A_AutoemailedLoggedin = 13,
            [TypeText("A - Auto Emailed Open")]
            [StatusIcon("14")]
            [Order(14)]
            A_AutoemailedOpen = 14,
            [TypeText("M - Applicant interested/ promised action; 1st call")]
            [StatusIcon("15")]
            [Order(15)]
            M_Applicantinterestedpromisedaction1stcall = 15,
            [TypeText("A - Applicant 1st Call : No login 48 hours")]
            [StatusIcon("16")]
            [Order(16)]
            A_Applicant1stCallNologin48hours = 16,
            [TypeText("A - Applicant 1st Call :Login but Not complete HR forms")]
            [StatusIcon("17")]
            [Order(17)]
            A_Applicant1stCallLoginbutNotcompleteHRforms = 17,
            [TypeText("M - Applicant interested/ promised action; 2nd call")]
            [StatusIcon("18")]
            [Order(18)]
            M_Applicantinterestedpromisedaction2ndcall = 18,
            [TypeText("A - Applicant 2nd Call: No login 48 hours")]
            [StatusIcon("19")]
            [Order(19)]
            A_Applicant2ndCallNologin48hours = 19,
            [TypeText("A - Applicant 2nd Call :Login but Not complete HR forms")]
            [StatusIcon("20")]
            [Order(20)]
            A_Applicant2ndCallLoginbutNotcompleteHRforms = 20,
            [TypeText("M - Call disconnected")]
            [StatusIcon("21")]
            [Order(21)]
            M_Calldisconnected = 21,
            [TypeText("A/M - Low test scores")]
            [StatusIcon("22")]
            [Order(22)]
            AM_Lowtestscores = 22,
            [TypeText("A - Left aptitude test without finishing")]
            [StatusIcon("23")]
            [Order(23)]
            A_Leftaptitudetestwithoutfinishing = 23,
            [TypeText("A - Task/interview committed")]
            [StatusIcon("24")]
            [Order(24)]
            A_Taskinterviewcommitted = 24,
            [TypeText("A/M - Task/interview committed-ACCEPTED")]
            [StatusIcon("25")]
            [Order(25)]
            AM_TaskinterviewcommittedACCEPTED = 25,
            [TypeText("A/M - Task/interview committed-REJECTED 1st")]
            [StatusIcon("26")]
            [Order(26)]
            AM_TaskinterviewcommittedREJECTED1st = 26,
            [TypeText("A/M - Task/interview committed-REJECTED 2nd")]
            [StatusIcon("27")]
            [Order(27)]
            AM_TaskinterviewcommittedREJECTED2nd = 27,
            [TypeText("A - Commit/Interview date expired")]
            [StatusIcon("28")]
            [Order(28)]
            A_CommitInterviewdateexpired = 28,
            [TypeText("A/M - Offer Accepted by applicant")]
            [StatusIcon("29")]
            [Order(29)]
            AM_OfferAcceptedbyapplicant = 29,
            [TypeText("A - Offer rejected by applicant")]
            [StatusIcon("30")]
            [Order(30)]
            A_Offerrejectedbyapplicant = 30,
            [TypeText("A - Offer Expired")]
            [StatusIcon("31")]
            [Order(31)]
            A_OfferExpired = 31,
            [TypeText("M - Open Offer (date& time)")]
            [StatusIcon("32")]
            [Order(32)]
            M_OpenOfferdatetime = 32,
            [TypeText("M - Offer Expired")]
            [StatusIcon("33")]
            [Order(33)]
            M_OfferExpired = 33


            #region old
            /*
        [TypeText("Applicant Self Reject")]
        [StatusIcon("1")]
        [Order(1)]
        ApplicantSelfReject = 1,

        [TypeText("Admin Rejected Applicant: Uncooperative/Unqualified")]
        [StatusIcon("2")]
        [Order(2)]
        AdminRejectedApplicantUncooperativeUnqualified = 2,

        [TypeText("Admin Rejected Applicant: Other")]
        [StatusIcon("3")]
        [Order(3)]
        AdminRejectedApplicantOther = 3,

        [TypeText("Bad/Wrong Contact Info")]
        [StatusIcon("4")]
        [Order(4)]
        BadWrongContactInfo = 4,

        [TypeText("Call Disconnected")]
        [StatusIcon("5")]
        [Order(5)]
        CallDisconnected = 5,

        [TypeText("Offer informal Accepte")]
        [StatusIcon("6")]
        [Order(6)]
        OfferinformalAccepte = 6,

        [TypeText("Offer Terms Renegotiated")]
        [StatusIcon("7")]
        [Order(7)]
        OfferTermsRenegotiated = 7,

        [TypeText("Applicant Hungup")]
        [StatusIcon("8")]
        [Order(8)]
        ApplicantHungup = 8,

        [TypeText("Applicant Answered Interested")]
        [StatusIcon("9")]
        [Order(9)]
        ApplicantAnsweredInterested = 9,

        [TypeText("AutoEmail Sent")]
        [StatusIcon("10")]
        [Order(10)]
        AutoEmailSent = 10,

        [TypeText("Rejected Opt Out")]
        [StatusIcon("11")]
        [Order(11)]
        RejectedOptOut = 11,

        [TypeText("Autoemail Opened")]
        [StatusIcon("12")]
        [Order(12)]
        AutoemailOpened = 12,

        [TypeText("Autoemailed Loggedin")]
        [StatusIcon("13")]
        [Order(13)]
        AutoemailedLoggedin = 13,

        [TypeText("Autoemailed Open")]
        [StatusIcon("14")]
        [Order(14)]
        AutoemailedOpen = 14,

        [TypeText("Offer Rejected By Applicant")]
        [StatusIcon("15")]
        [Order(15)]
        OfferRejectedByApplicant = 15,

        [TypeText("Offer Is Open")]
        [StatusIcon("16")]
        [Order(16)]
        OfferIsOpen = 16,

        [TypeText("Offer Expired")]
        [StatusIcon("17")]
        [Order(17)]
        OfferExpired = 17,

        [TypeText("Call Not Answered")]
        [StatusIcon("18")]
        [Order(18)]
        CallNotAnswered = 18,

        [TypeText("Interview Date Expired")]
        [StatusIcon("19")]
        [Order(19)]
        InterviewDateExpired = 19
            */
            #endregion
        }

        public enum EmailTypes
        {
            None = 0,
            Error = 1,
            Welcome = 2,
            TaskAutoEmail = 3,
            InterviewEmail = 4,
            OfferMadeEmail = 5,
            UserStatusChange = 6,
            ReminderEmail = 7,
            CallConectedAutoEmail = 8,
            ChatMessage = 9,
            VendorCategories = 10,
            Vendors = 11,
            Orders = 12,
            MissedCallAlert = 13
        }

        public enum UserRoles
        {
            Admin = 1
        }

        public enum ExamPerformanceStatus
        {
            Pass = 1,
            Fail = 0
        }

        /// <summary>
        /// Gets key names to access ApplicationFeatures from database.
        /// Keep updating this class to have all KEY values as per database.
        /// </summary>
        public enum ApplicationFeatures
        {

        }


        /// <summary>
        /// Get employment statuses for system.
        /// </summary>
        public enum EmploymentType
        {

            [Description("Part Time - Remote")]
            PartTimeRemote = 1,
            [Description("Full Time - Remote")]
            FullTimeRemote = 2,
            [Description("Part Time - Onsite")]
            PartTimeOnsite = 3,
            [Description("Full Time - Onsite")]
            FullTimeOnsite = 4,
            [Description("Internship")]
            Internship = 5,
            [Description("Temp")]
            Temp = 6,
            [Description("Sub")]
            Sub = 7

        }
        #endregion

        #region '-- Page Name --'

        /// <summary>
        /// Master Calendar Direct URL 
        /// </summary>
        public const string PG_PATH_MASTER_CALENDAR = "~/Sr_App/GoogleCalendarView.aspx";

        #endregion

        /// <summary>
        /// Gets key names to access ContentSetting from database.
        /// Keep updating this class to have all KEY values as per database.
        /// </summary>
        public static class ContentSettings
        {
            public const string TASK_HELP_TEXT = "TASK_HELP_TEXT";
        }
    }
}
