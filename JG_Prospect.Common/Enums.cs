using System.ComponentModel;

namespace JG_Prospect.Common
{
    public class Enums
    {
        public enum Aptitude_ExamType
        {
            DotNet = 2
        }

        public enum ResourceType
        {
            Video = 1,
            Image = 2,
            Audio = 3,
            CompreesedFolder = 4,
            PDF = 5,
            Excel = 6,
            Word = 7,
            Presentation = 8,
            Other = 99
        }

        public enum Location
        {
            [Description("Sucess Popup")]
            SucessPopup = 1,
            [Description("Interview Date popup")]
            InterviewDatePopup = 2,
            [Description("Active/OffMade Staff")]
            ActiveOffMadeStaff = 3
        }

    }

    public enum TouchPointSource
    {
        EditUserPage = 1,
        ITDashboard = 2,
        InterviewPopup = 3,
        TouchPointLogPage = 4,
        ViewSalesUser = 5,
        ViewApplicantUser = 6,
        CreateSalesUser = 7,
        TaskGenerator = 8
    }

    public enum ChatSource
    {
        EditUserPage = 1,
        ITDashboard = 2,
        InterviewPopup = 3,
        TouchPointLogPage = 4,
        ViewSalesUser = 5,
        ViewApplicantUser = 6,
        CreateSalesUser = 7,
        TaskGenerator = 8,
        TaskChat = 9,
        UserChat = 10,
        PhoneCallLog = 11,
        WebToWebCall = 12
    }

    public enum ChatUserStatus
    {
        Active = 1,
        Idle = 2,
        Offline = 3
    }
}
