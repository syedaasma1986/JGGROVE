using JG_Prospect.BLL;
using JG_Prospect.Common;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace JG_Prospect.MCQTest
{
    public partial class ViewResults : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            // Put user code to initialize the page here
           
            String ExamID = (String)Session["exam_id"];
            long totalMarks = (long)Session["TotalMarks"];
            long marksEarned = (long)Session["MarksEarned"];
            lblMarksEarned.Text = marksEarned.ToString();
            lblTotalMarks.Text = totalMarks.ToString();
            float percentage = ((float)marksEarned / totalMarks) * 100;
            if (percentage < 0)
                percentage = 0.00F;
            lblPercentage.Text = percentage.ToString("0.00");

            // Here code to insert into Performance Index database
            //StudentPerformanceTableAdapter studentPerformance = new StudentPerformanceTableAdapter();
            //ExamTableAdapter examAdapter = new ExamTableAdapter();

            //String status = "FINISHED";
            //ExamOMaticSchema.ExamRow examDetails = examAdapter.GetData().FindByExamID(int.Parse(ExamID));
            //ExamPerformanceStatus examPerformanceStatus = ExamPerformanceStatus.Pass;
            //if (examDetails.PassPercentage == 0)
            //    examPerformanceStatus = ExamPerformanceStatus.NoStatus;
            //else
            //{
            //    if (percentage < examDetails.PassPercentage)
            //    {
            //        examPerformanceStatus = ExamPerformanceStatus.Fail;
            //        status = "<font color=red>FAILED</font>";
            //    }
            //    else
            //        status = "<font color=green>PASSED</font>";
            //}
            //lblStatus.Text = status;

            int InstallUserID = 0;
            int.TryParse(Session["ID"].ToString(), out InstallUserID);
           // AptitudeTestBLL.Instance.InsertPerformance(InstallUserID, int.Parse(ExamID), (int)marksEarned, (int)totalMarks, percentage, 1);
            //Session.RemoveAll();
            //Session.Abandon();

            if (percentage < 30)
            {
                int intUserID = Convert.ToInt32(Session[JG_Prospect.Common.SessionKey.Key.UserId.ToString()]);

                JGSession.UserStatus = JGConstant.InstallUserStatus.Rejected;

                InstallUserBLL.Instance.ChangeStatus(Convert.ToByte(JGConstant.InstallUserStatus.Rejected).ToString(), intUserID, DateTime.Today, DateTime.Now.ToShortTimeString(), intUserID, JGSession.IsInstallUser.Value, "Rejected: Failed apptitude test.");

                pFail.Visible = true;
                pPass.Visible = false;
            }
            else
            {
                pFail.Visible = false;
                pPass.Visible = true;
            }
        }
    }
}