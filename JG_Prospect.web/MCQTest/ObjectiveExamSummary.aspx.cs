using JG_Prospect.BLL;
using System;
using System.Data;
using System.Linq;
using System.Web.UI.WebControls;

namespace JG_Prospect.MCQTest
{
    public partial class ObjectiveExamSummary : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
             
                string ExamID = (string)Session["exam_id"];
                
                 String examDuration = AptitudeTestBLL.Instance.GetExamDurationByID(ExamID);

            int timeLeft = 0;
                if (Session["currentExamDuration"] != null)
                    timeLeft = (int.Parse(examDuration) * 60) - int.Parse(SessionsCommon.getTimeDifference(Session));
                else
                {
                    timeLeft = int.Parse(examDuration) * 60;
                    Session["currentExamDuration"] = DateTime.Now;
                }
                this.currentExamTime.Value = (timeLeft).ToString();

                string StudentName = (string)Session["student"];
                
                DataTable questionTable = AptitudeTestBLL.Instance.GetQuestionsForExamByID(ExamID);

            String s = "<table bgcolor=white class='tblExamSummary' border =1>";
            //for (int j = 0; j < questionTable.Rows.Count; j++)
            foreach (DataRow questionRow in questionTable.Rows)
            {
                s += "<tr><td>";

                string i = questionRow["QuestionID"].ToString();
                    object o = Session[i];
                    string question = questionRow["Question"].ToString();
                    s += "<a href=StartExam.aspx?id=" + questionRow["QuestionID"] + ">Edit Your Answer</a>" + question + "</a>";

                    String lblType = "", answerString = "";

                    answerString = "You did not yet mark answer for this question!";
                    if ("SingleSelect" == "SingleSelect")
                    {
                        ListItemCollection coll = (ListItemCollection)o;
                        if (o != null)
                        {
                            foreach (ListItem item in coll)
                            {
                                if (item.Selected)
                                {
                                    answerString = "The option you selected is <b>" + item.Text;
                                    break;
                                }
                            }

                        }
                        lblType = "Single choice question";

                    } 
                    else
                    {
                        if (o != null)
                            answerString = "The answer you wrote is <b>" + (string)o;
                        lblType = "Fill in the blank question";
                    }

                    s += "<br><font color=black>" + answerString + "</b></font></td>";

                    //s += "<td><b>Question Type:</b> " + lblType + "</td>";
                    s += "</tr>";

                    //s += "<tr><td><font color=black>" + answerString + "</font></td></tr>";
                }
                s += "</table>";
                lblObjectiveSummary.Text = s;
            
        }


        protected void btnSubmitExam_Click1(object sender, EventArgs e)
        {
            string ExamID = (string)Session["exam_id"];
            DataTable questionTable = AptitudeTestBLL.Instance.GetQuestionsForExamByID(ExamID);

            long totalMarks = 0, marksEarned = 0;
            //for (int k = 0; k < questionTable.Rows.Count; k++)
            foreach (DataRow questRow in questionTable.Rows)
            {
                string i = questRow["QuestionID"].ToString();
                object o = Session[i + "A"];
                long marks;
                if (o != null)
                    marks = (long)Session[i + "A"];
                else
                    marks = 0;
                totalMarks += int.Parse(questRow["PositiveMarks"].ToString());
                marksEarned += marks;
            }
            Session["TotalMarks"] = totalMarks;
            Session["MarksEarned"] = marksEarned;
            Response.Redirect("ViewResults.aspx");
        }
    }
}