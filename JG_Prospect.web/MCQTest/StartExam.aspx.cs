using System;
using JG_Prospect.BLL;
using System.Data;
using System.Collections;
using System.Collections.Generic;
using System.Web.UI.WebControls;

namespace JG_Prospect.MCQTest
{
    public partial class StartExam : System.Web.UI.Page
    {
        private int marks = 0;
        private string questionID;
        private long positiveMarks, negetiveMarks;
        private string ExamID = "1";
        string currentQuestionId = "";

        protected void Page_Load(object sender, EventArgs e)
        {

        }

        override protected void OnInit(EventArgs e)
        {
            base.OnInit(e);


            Session.Timeout = 300;
            // check if every damn thing so far is all right

            string examId = Request.QueryString["exam_id"];
            if (String.IsNullOrEmpty(examId))
            {
                if (Session["exam_id"] == null)
                {
                    //Session["oldExamId"] = Session["exam_id"];
                    Session["exam_id"] = examId;
                    Response.Redirect("ObjectiveExamSummary.aspx");
                }
            }
            else
            {
                Session["exam_id"] = examId;
            }

            if (Session["oldExamId"] != null)
                Response.Redirect("ObjectiveExamSummary.aspx");

            if (true) // Check for session..
            {
                defaultExamOnLoad();
            }
        }

        private void defaultExamOnLoad()
        {
            string StudentName = (string)Session["student"];
            ExamID = (string)Session["exam_id"];


            if (Request.QueryString["id"] != null)
            {
                currentQuestionId = Request.QueryString["id"];
                Session[currentQuestionId + "VQ"] = "Ahoy";
            }

            //Time to set the timer accordingly
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
            questionID = Request.QueryString["id"];

            DataTable questionTable = AptitudeTestBLL.Instance.GetQuestionsForExamByID(ExamID);



            ArrayList al = (ArrayList)Session["questionList"];
            //if (Session["questionList"] == null)
            //{
            al = GenerateArrayList(questionTable);
            ShuffleList(al);
            Session["questionList"] = al;
            //}

            //////////List<string> lstquestion = new List<string>();
            //////////if (Session["questionList"] == null)
            //////////{
            //////////    lstquestion = GenerateArrayList(questionTable);
            //////////    //ShuffleList(al);
            //////////    Session["questionList"] = lstquestion;
            //////////}
            //////////else
            //////////    lstquestion = (List<string>) Session["questionList"];


            GenerateHtml(al);
        }

        private void GenerateHtml(ArrayList al)
        {
            string s = "";
            int c = 1;

            int xCount = 0, xMaxCount = 10, questionsMarked = 0;
            string dispQuestionId = "0";
            s += "<table><tr>";
            for (int k = 0; k < al.Count; k++)
            {
                if (xCount == xMaxCount)
                    s += "<tr>";
                if (al[k].ToString().Equals(currentQuestionId))
                {
                    dispQuestionId = (c).ToString();
                    if (al.Count == k + 1)
                        Session["nextQuestionId"] = al[0].ToString();
                    else
                        Session["nextQuestionId"] = al[k + 1].ToString();
                    if (k == 0)
                        Session["prevQuestionId"] = al[al.Count - 1].ToString();
                    else
                        Session["prevQuestionId"] = al[k - 1].ToString();
                }
                /*
                if (dispQuestionId.ToString().Equals(c.ToString()))
                {
                    s += "<td><font size=large><a href=StartExam.aspx?id=" + al[k] + " style='color: #ffffff;'>Q" + c++ + "</a></font></td>";
                    if (Session[al[k] + "MA"] != null)
                        questionsMarked++;
                    c++;
                }
                else
                {*/
                if (Session[al[k] + "VQ"] != null)
                {
                    if (Session[al[k] + "MA"] != null)
                    {
                        s += "<td><a href=StartExam.aspx?id=" + al[k] + " style='color: #33cc33;'>Q" + c++ + "</a></td>";
                        questionsMarked++;
                    }
                    else
                        s += "<td><a href=StartExam.aspx?id=" + al[k] + " style='color: #3366ff;'>Q" + c++ + "</a></td>";
                }

                else
                    s += "<td><a href=StartExam.aspx?id=" + al[k] + " style='color: #ff3300'>Q" + c++ + "</a></td>";
                //}

                xCount++;
                if (xCount == xMaxCount || k == al.Count - 1)
                {
                    s += "</tr>";
                    xCount = 0;
                }
            }
            s += "</table>";
            Label2.Text = s;

            if (questionsMarked == al.Count)
            {
                if (SessionsCommon.RedirectStudentToSummaryPage(Session))
                    Response.Redirect("./ObjectiveExamSummary.aspx");
            }


            if (questionID != null)
            {
                // Exam summary now makes a lot of human sense to me. Eeeeee haaaaaa

                DataTable DtQuestion = AptitudeTestBLL.Instance.GetQuestionsByID(Int32.Parse(questionID));
                JG_Prospect.Common.modal.Aptitude.QuestionRow selectedQuestion = new Common.modal.Aptitude.QuestionRow();

                foreach (DataRow Ques in DtQuestion.Rows) // It will be only 1 rows.
                {
                    //selectedQuestion = new Common.modal.Aptitude.QuestionRow();

                    selectedQuestion.QuestionID = Convert.ToInt32(Ques["QuestionID"]);
                    selectedQuestion.Question = Ques["Question"].ToString();
                    selectedQuestion.QuestionType = Convert.ToInt32(Ques["QuestionType"]);
                    selectedQuestion.PositiveMarks = Convert.ToInt32(Ques["PositiveMarks"]);
                    selectedQuestion.NegetiveMarks = Convert.ToInt32(Ques["NegetiveMarks"]);
                    selectedQuestion.PictureURL = "";
                    selectedQuestion.ExamID = Convert.ToInt32(Ques["ExamID"]); ;
                    selectedQuestion.AnswerTemplate = "";
                }

                //JG_Prospect.Common.modal.Aptitude.QuestionRow selectedQuestion = AptitudeTestBLL.Instance.GetQuestionsByID(Int32.Parse(questionID));

                //QuestionType questionType = (QuestionType)selectedQuestion.QuestionType;

                lblQuestion.Text = "<font color=black>Q" + dispQuestionId + "." + selectedQuestion.Question + "</font>";
                positiveMarks = selectedQuestion.PositiveMarks;
                negetiveMarks = selectedQuestion.NegetiveMarks;
                lblPositiveMarks.Text = positiveMarks.ToString();
                lblNegetiveMarks.Text = negetiveMarks.ToString();

                //string pictureURL = selectedQuestion.PictureURL;
                //showPicture(pictureURL);

                if ("SingleSelect" == "SingleSelect")
                {
                    //Single Select
                    #region Single Select

                    pnlMultiSelect.Visible = false;
                    pnlSingleSelect.Visible = true;
                    pnlPhrase.Visible = false;

                    ListItemCollection coll = (ListItemCollection)Session[questionID];
                    if (coll != null)
                    {
                        RadioButtonList1.Items.Clear();
                        foreach (ListItem li in coll)
                            RadioButtonList1.Items.Add(li);
                        return;
                    }


                    DataTable optionData = AptitudeTestBLL.Instance.GetQuestionsoptionByQustionID(Int32.Parse(questionID));
                    foreach (DataRow OptionRow in optionData.Rows)
                    {
                        string item = OptionRow["OptionText"].ToString();
                        RadioButtonList1.Items.Add(new ListItem(item, item));
                    }

                    #endregion
                }
                //else if (questionType == QuestionType.MultiSelect)
                //{
                //    #region  Multi Select
                //    //Multiple Select						
                //    pnlMultiSelect.Visible = true;
                //    pnlSingleSelect.Visible = false;
                //    pnlPhrase.Visible = false;

                //    ListItemCollection coll = (ListItemCollection)Session[questionID];
                //    if (coll != null)
                //    {
                //        CheckBoxList1.Items.Clear();
                //        foreach (ListItem li in coll)
                //            CheckBoxList1.Items.Add(li);
                //        return;
                //    }

                //    OptionTableAdapter optionAdapter = new OptionTableAdapter();
                //    ExamOMaticSchema.OptionDataTable optionData = optionAdapter.GetDataByQuestionID(Int32.Parse(questionID));

                //    for (int k = 0; k < optionData.Rows.Count; k++)
                //    {
                //        string item = optionData[k].OptionText;
                //        CheckBoxList1.Items.Add(new ListItem(item, item));
                //    }
                //    #endregion
                //}
                else
                {
                    //Phrase Mode
                    pnlMultiSelect.Visible = false;
                    pnlSingleSelect.Visible = false;
                    pnlPhrase.Visible = true;

                    string str = (string)Session[questionID];
                    if (str != null)
                        txtAnswer.Text = str;
                }
            }
        }

        private ArrayList GenerateArrayList(DataTable questionTable)
        {
            ArrayList tempList = new ArrayList();

            foreach (DataRow datarow in questionTable.Rows)
            {
                tempList.Add(datarow["QuestionID"]);
            }

            //for (int j = 0; j < questionTable.Rows.Count; j++)
            //    tempList.Add(questionTable[j].QuestionID);

            return tempList;
        }

        private void ShuffleList(ArrayList al)
        {
            for (int i = 0; i < al.Count; i++)
            {
                object x = al[i];
                int index = new System.Random().Next(al.Count - i) + i;
                al[i] = al[index];
                al[index] = x;
            }
        }

        private List<string> GenerateArrayList__Lst(DataTable questionTable)
        {
            //ArrayList returnList = new ArrayList();
            List<string> lstReturn = new List<string>();

            foreach (DataRow question in questionTable.Rows)
            {
                lstReturn.Add(question["QuestionID"].ToString());
            }
            return lstReturn;
        }

        #region '--Button Event--'

        protected void btnSingleSelect_Click(object sender, System.EventArgs e)
        {
            if (RadioButtonList1.SelectedItem != null)
            {

                Session[questionID + "MA"] = "Ahoy";
                ArrayList userAnswers = new ArrayList();
                bool isCorrect = true;
                Session[questionID] = RadioButtonList1.Items;


                DataTable correctAnswerData = AptitudeTestBLL.Instance.GetcorrectAnswerByQuestionID(Int32.Parse(questionID));

                if (RadioButtonList1.SelectedItem.Text != correctAnswerData.Rows[0]["AnswerText"].ToString())
                    isCorrect = false;

                if (isCorrect)
                    Page.Session[questionID + "A"] = positiveMarks;
                else
                    Page.Session[questionID + "A"] = -negetiveMarks;
                gotoNextQuestion();
            }
        }

        protected void btnPhrase_Click(object sender, System.EventArgs e)
        {
            Session[questionID + "MA"] = "Ahoy";
            string answerText = txtAnswer.Text;
            Response.Write(answerText);
            bool isCorrect = false;

            DataTable correctAnswerData = AptitudeTestBLL.Instance.GetcorrectAnswerByQuestionID(Int32.Parse(questionID));

            if (answerText.ToUpper().Equals(correctAnswerData.Rows[0]["AnswerText"].ToString().ToUpper()))
                isCorrect = true;

            Session[questionID] = txtAnswer.Text;
            if (isCorrect)
                Page.Session[questionID + "A"] = positiveMarks;
            else
                Page.Session[questionID + "A"] = -negetiveMarks;
            gotoNextQuestion();
        }

        protected void gotoNextQuestion()
        {
            string nextQuestionId = (string)Session["nextQuestionId"];
            Response.Redirect("StartExam.aspx?id=" + nextQuestionId);
        }

        protected void btnSubmitExam_Click(object sender, System.EventArgs e)
        {
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

        private string getTimeDifference()
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
        protected void lnkQuitExam_Click(object sender, EventArgs e)
        {
            string studentName = Session["student"].ToString();
            Session.Abandon();
            Session["student"] = studentName;
            Response.Redirect("./exam_list.aspx");
            //Response.Write("<font color=white>Exam has ended now kiddie</font>");
            Response.End();
        }
        protected void btnPrevSingle_Click(object sender, EventArgs e)
        {
            string prevQuestionId = (string)Session["prevQuestionId"];
            Response.Redirect("StartExam.aspx?id=" + prevQuestionId);
        }
        protected void btnNextSingle_Click(object sender, EventArgs e)
        {
            string nextQuestionId = (string)Session["nextQuestionId"];
            Response.Redirect("StartExam.aspx?id=" + nextQuestionId);
        }
        protected void btnPrevMulti_Click(object sender, EventArgs e)
        {
            string prevQuestionId = (string)Session["prevQuestionId"];
            Response.Redirect("StartExam.aspx?id=" + prevQuestionId);
        }
        protected void btnNextMulti_Click(object sender, EventArgs e)
        {
            string nextQuestionId = (string)Session["nextQuestionId"];
            Response.Redirect("StartExam.aspx?id=" + nextQuestionId);
        }
        protected void btnPrevPhrase_Click(object sender, EventArgs e)
        {
            string prevQuestionId = (string)Session["prevQuestionId"];
            Response.Redirect("StartExam.aspx?id=" + prevQuestionId);
        }
        protected void btnNextPhrase_Click(object sender, EventArgs e)
        {
            string nextQuestionId = (string)Session["nextQuestionId"];
            Response.Redirect("StartExam.aspx?id=" + nextQuestionId);
        }

        #endregion
    }
}