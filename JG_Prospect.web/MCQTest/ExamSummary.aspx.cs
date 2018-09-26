using System;
using System.Linq;
using System.Web.UI.WebControls;
using System.Data;
using JG_Prospect.BLL;

namespace JG_Prospect.MCQTest
{
    public partial class ExamSummary : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
              
            if (Session["exam_id"] != null)
            {
                string ExamID = (string)Session["exam_id"];
                //ExamTableAdapter examAdapter = new ExamTableAdapter();
                //String examDuration = examAdapter.GetData().FindByExamID(Int32.Parse(ExamID)).ExamDuration.ToString();
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
                
                DataTable questionTable = AptitudeTestBLL.Instance.GetQuestionsForExamByID(ExamID);

                String s = "<table bgcolor=white border=1>";

                
                foreach (DataRow QuestionRow in questionTable.Rows)
                {
                    s += "<tr><td>";
                
                    string i = QuestionRow["QuestionID"].ToString();
                    object o = Session[i];
                    string question = QuestionRow["Question"].ToString();
                    s += "<a href=StartExam.aspx?id=" + QuestionRow["QuestionID"] + ">Edit Your Answer</a>" + question + "</a>";

                    String lblType = "", answerString = "";

                    answerString = "You did not yet mark answer for this question!";
                    if ("SingleSelect" == "SingleSelect") //== TODO
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

                    s += "<td><b>Question Type:</b> " + lblType + "</td>";
                    s += "</tr>";

                    //s += "<tr><td><font color=black>" + answerString + "</font></td></tr>";
                }
                s += "</table>";
                lblObjectiveSummary.Text = s;
            }
            else
            {
                Response.Redirect("../MCQTest/McqTestPage.aspx");
            }
        }

        protected void btnSubmitExam_Click1(object sender, EventArgs e)
        {
            string ExamID = (string)Session["exam_id"];
            //QuestionTableAdapter questionAdapter = new QuestionTableAdapter();
            //ExamOMaticSchema.QuestionDataTable questionTable = questionAdapter.GetQuestionsForExam(Int32.Parse(ExamID));
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