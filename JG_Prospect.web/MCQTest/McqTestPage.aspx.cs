using System;
using System.Data;
using System.Drawing;
using JG_Prospect.BLL;
using JG_Prospect.Common;
using System.Web.UI.WebControls;
using System.Web.UI;
using System.Collections;
using System.Collections.Generic;
using JG_Prospect.Common.modal;
using System.Net.Mail;
using System.IO;
using JG_Prospect.App_Code;
using System.Globalization;
using System.Web;
using System.Web.Services;

namespace JG_Prospect.MCQTest
{
    public partial class McqTestPage : System.Web.UI.Page
    {
        #region "-- Properties --"

        public int UserID
        {
            get
            {
                int intUserID = 0;
                if (ViewState["UserID"] != null)
                {
                    Int32.TryParse(ViewState["UserID"].ToString(), out intUserID);
                }
                return intUserID;
            }
            set
            {
                ViewState["UserID"] = value;
            }
        }
        public int CurrentExamID
        {
            get
            {
                int ExamID = 0;
                if (ViewState["CEXAMID"] != null)
                {
                    Int32.TryParse(ViewState["CEXAMID"].ToString(), out ExamID);
                }
                return ExamID;
            }
            set
            {
                ViewState["CEXAMID"] = value;
            }
        }

        public int NextExamSeq
        {
            get
            {
                int ExamID = 0;
                if (ViewState["NEXAMID"] != null)
                {
                    Int32.TryParse(ViewState["NEXAMID"].ToString(), out ExamID);
                }
                return ExamID;
            }
            set
            {
                ViewState["NEXAMID"] = value;
            }
        }

        public int CurrentQuestion
        {
            get
            {
                int QueID = 0;
                if (ViewState["CQID"] != null)
                {
                    Int32.TryParse(ViewState["CQID"].ToString(), out QueID);
                }
                return QueID;
            }
            set
            {
                ViewState["CQID"] = value;
            }
        }

        public int NextQuestion
        {
            get
            {
                int QueID = 0;
                if (ViewState["NQID"] != null)
                {
                    Int32.TryParse(ViewState["NQID"].ToString(), out QueID);
                }
                return QueID;
            }
            set
            {
                ViewState["NQID"] = value;
            }
        }
        public int TotalQuestions
        {
            get
            {
                int QueID = 0;
                if (ViewState["TQ"] != null)
                {
                    Int32.TryParse(ViewState["TQ"].ToString(), out QueID);
                }
                return QueID;
            }
            set
            {
                ViewState["TQ"] = value;
            }
        }

        public int TotalExams
        {
            get
            {
                int QueID = 0;
                if (ViewState["TEX"] != null)
                {
                    Int32.TryParse(ViewState["TEX"].ToString(), out QueID);
                }
                return QueID;
            }
            set
            {
                ViewState["TEX"] = value;
            }
        }

        public String ExamsGiven
        {
            get
            {
                String strExamsGiven = String.Empty;
                if (ViewState["EXAMGiven"] != null)
                {
                    strExamsGiven = ViewState["EXAMGiven"].ToString();
                }
                return strExamsGiven;
            }
            set
            {
                ViewState["EXAMGiven"] = value;
            }

        }

        /// <summary>
        /// Stores user question with QuestionID as a Key
        /// Value (seperated by '-'):- 1. User Answer 2. Correct Answer 3. Positive Marks  4. Negative Marks
        /// </summary>
        public Dictionary<int, string> ExamAttempted
        {
            get
            {
                Dictionary<int, string> ExamAttempt = new Dictionary<int, string>();
                if (ViewState["EXATEMP"] != null)
                {
                    ExamAttempt = (Dictionary<int, string>)ViewState["EXATEMP"];
                }
                return ExamAttempt;
            }
            set
            {
                ViewState["EXATEMP"] = value;
            }

        }

        public int DesignationID
        {
            get
            {
                int intDesignID = 0;
                if (ViewState["DesignID"] != null)
                {
                    Int32.TryParse(ViewState["DesignID"].ToString(), out intDesignID);
                }
                return intDesignID;
            }
            set
            {
                ViewState["DesignID"] = value;
            }

        }

        public String DesignationName
        {
            get
            {
                String strDesign = String.Empty;
                if (ViewState["DGName"] != null)
                {
                    strDesign = ViewState["DGName"].ToString();
                }
                return strDesign;
            }
            set
            {
                ViewState["DGName"] = value;
            }

        }

        #endregion

        #region "-- Page Methods --"
        protected void Page_Load(object sender, EventArgs e)
        {
            //Display Page Timer.
            SetTimerOnPage();
            if (!Page.IsPostBack)
            {
                if (Session["ID"] != null)
                    if (Session["ID"].ToString() != "")
                    {
                        UserID = Convert.ToInt32(Session["ID"]);
                        populateExams();
                        //populateLabel();
                        //populatePerformanceArea();
                        bool isAllExamGiven = AptitudeTestBLL.Instance.IsAllExamGivenByUserId(UserID);
                        if (isAllExamGiven)
                        {
                            btnTakeTest.Visible = false;
                            btnCancelTest.Visible = false;
                        }

                    }
            }
        }

        #endregion

        #region "-- Control Events --"

        protected void btnCancelTest_Click(object sender, EventArgs e)
        {
            LogoutUser(false);

        }

        protected void btnTakeTest_Click(object sender, EventArgs e)
        {
            StartExam();
        }

        protected void rptQuestions_ItemCommand(object source, RepeaterCommandEventArgs e)
        {

            if (e.CommandName == "LoadQuestion")
            {
                SetQuestionUI(e.Item);

            }
        }

        protected void rblQuestionOptions_SelectedIndexChanged(object sender, EventArgs e)
        {
            // Get user attempted answer
            String Answer = rblQuestionOptions.SelectedItem.Value;
            String correctAnswer = hdnCorrectAnswer.Value;
            String PMarks = hdnPMarks.Value;
            String NMarks = hdnNMarks.Value;


            // Check user's attempts
            Dictionary<int, string> dicExamAttempted = this.ExamAttempted;

            // if user has already attempted question than update its answer.
            if (dicExamAttempted.ContainsKey(this.CurrentQuestion))
            {
                // Store QuestionID,User Answer, Correct Answer, Positive Marks, Negative Marks
                dicExamAttempted[this.CurrentQuestion] = String.Concat(Answer, "-", correctAnswer, "-", PMarks, "-", NMarks);
            }
            else // else add new attempted question
            {
                // Store QuestionID,User Answer, Correct Answer, Positive Marks, Negative Marks
                dicExamAttempted.Add(this.CurrentQuestion, String.Concat(Answer, "-", correctAnswer, "-", PMarks, "-", NMarks));

            }

            this.ExamAttempted = dicExamAttempted;

            MarkQuestionAsAttempted();

            LoadNextQuestion();

            CheckExamCompletion();

        }

        protected void btnEndExam_Click(object sender, EventArgs e)
        {
            // Don't allow user to end exam if all exam attempted by user.
            bool isAllExamGiven = true;

            AptitudeTestBLL.Instance.GetExamsResultByUserID(UserID, ref isAllExamGiven);

            if (!isAllExamGiven)
            {
                CountExamResultandReset();
            }
        }

        protected void rptExams_ItemDataBound(object sender, RepeaterItemEventArgs e)
        {
            //Result data available
            if (DataBinder.Eval(e.Item.DataItem, "MarksEarned") != null && !String.IsNullOrEmpty(DataBinder.Eval(e.Item.DataItem, "MarksEarned").ToString()))
            {
                Label lblMarks = (Label)e.Item.FindControl("lblMarks");
                Label lblPercentage = (Label)e.Item.FindControl("lblPercentage");
                Label lblResult = (Label)e.Item.FindControl("lblResult");

                lblMarks.Text = String.Concat("Marks Obtained: ", DataBinder.Eval(e.Item.DataItem, "MarksEarned").ToString(), "/", DataBinder.Eval(e.Item.DataItem, "TotalMarks").ToString());
                lblPercentage.Text = String.Concat("Percentage Obtained: ", DataBinder.Eval(e.Item.DataItem, "Aggregate").ToString());

                if (DataBinder.Eval(e.Item.DataItem, "ExamPerformanceStatus") == null || DataBinder.Eval(e.Item.DataItem, "ExamPerformanceStatus").ToString() == "")
                {
                    lblResult.CssClass = "greentext";
                    lblResult.Text = "Pass";
                    lblResult.CssClass = "redtext";
                    lblResult.Text = "pending";
                    this.NextExamSeq = e.Item.ItemIndex;
                }
                else
                {
                    lblResult.CssClass = "redtext";
                    lblResult.Text = "Fail";
                    if (Convert.ToInt32(DataBinder.Eval(e.Item.DataItem, "ExamPerformanceStatus").ToString()) > 0)
                    {
                        lblResult.CssClass = "greentext";
                        lblResult.Text = "Pass";
                    }
                    else
                    {
                        lblResult.CssClass = "redtext";
                        lblResult.Text = "Fail";
                    }
                }

            }
        }


        #endregion

        #region "-- Private Methods --"

        private void AssignedTaskToUser(int UserId, UInt64 TaskId, UInt64 ParentTaskId, String TaskTitle, String InstallId)
        {
            string ApplicantId = UserID.ToString();

            // save (insert / delete) assigned users.

            // save assigned user a TASK.
            bool isSuccessful = TaskGeneratorBLL.Instance.SaveTaskAssignedToMultipleUsers(TaskId, ApplicantId);

            // Change task status to assigned = 3.
            if (isSuccessful)
                UpdateTaskStatus(TaskId, Convert.ToUInt16(JGConstant.TaskStatus.Assigned));

            SendEmailToAssignedUsers(ApplicantId, ParentTaskId.ToString(), TaskId.ToString(), TaskTitle, InstallId);

        }

        private void UpdateTaskStatus(UInt64 taskId, UInt16 Status)
        {
            Task task = new Task();
            task.TaskId = Convert.ToInt32(taskId);
            task.Status = Status;

            int result = TaskGeneratorBLL.Instance.UpdateTaskStatus(task);    // save task master details

        }

        private void SendEmailToAssignedUsers(string strInstallUserIDs, string strTaskId, string strSubTaskId, string strTaskTitle, String InstallId)
        {
            try
            {
                //string strHTMLTemplateName = "Task Generator Auto Email";
                //DataSet dsEmailTemplate = AdminBLL.Instance.GetEmailTemplate(strHTMLTemplateName, 108);

                DesignationHTMLTemplate objHTMLTemplate = HTMLTemplateBLL.Instance.GetDesignationHTMLTemplate(HTMLTemplates.Task_Generator_Auto_Email, JGSession.DesignationId.ToString());

                foreach (string userID in strInstallUserIDs.Split(new char[] { ',' }, StringSplitOptions.RemoveEmptyEntries))
                {
                    DataSet dsUser = TaskGeneratorBLL.Instance.GetInstallUserDetails(Convert.ToInt32(userID));

                    string emailId = dsUser.Tables[0].Rows[0]["Email"].ToString();
                    string FName = dsUser.Tables[0].Rows[0]["FristName"].ToString();
                    string LName = dsUser.Tables[0].Rows[0]["LastName"].ToString();
                    string fullname = FName + " " + LName;

                    //string strHeader = dsEmailTemplate.Tables[0].Rows[0]["HTMLHeader"].ToString();
                    //string strBody = dsEmailTemplate.Tables[0].Rows[0]["HTMLBody"].ToString();
                    //string strFooter = dsEmailTemplate.Tables[0].Rows[0]["HTMLFooter"].ToString();
                    //string strsubject = dsEmailTemplate.Tables[0].Rows[0]["HTMLSubject"].ToString();
                    string strHeader = objHTMLTemplate.Header;
                    string strBody = objHTMLTemplate.Body;
                    string strFooter = objHTMLTemplate.Footer;
                    string strsubject = objHTMLTemplate.Subject;

                    strsubject = strsubject.Replace("#ID#", strTaskId);
                    strsubject = strsubject.Replace("#TaskTitleID#", strTaskTitle);
                    strsubject = strsubject.Replace("#TaskTitle#", strTaskTitle);

                    strBody = strBody.Replace("#ID#", strTaskId);
                    strBody = strBody.Replace("#TaskTitleID#", strTaskTitle);
                    strBody = strBody.Replace("#TaskTitle#", strTaskTitle);
                    strBody = strBody.Replace("#Fname#", fullname);
                    strBody = strBody.Replace("#email#", emailId);

                    strBody = strBody.Replace("#Designation(s)#", this.DesignationName);
                    strBody = strBody.Replace("#TaskLink#", string.Format(
                                                                            "{0}?TaskId={1}&hstid={2}",
                                                                            string.Concat(
                                                                                            JGApplicationInfo.GetSiteURL(),
                                                                                            "/Sr_App/TaskGenerator.aspx"
                                                                                         ),
                                                                            strTaskId,
                                                                            strSubTaskId
                                                                        )
                                            );

                    string strTaskLinkTitle = CommonFunction.GetTaskLinkTitleForAutoEmail(int.Parse(strTaskId));
                    strBody = strBody.Replace("#TaskTitle#", strTaskLinkTitle);

                    strBody = strHeader + strBody + strFooter;

                    string strHTMLTemplateName = "Task Generator Auto Email";
                    DataSet dsEmailTemplate = AdminBLL.Instance.GetEmailTemplate(strHTMLTemplateName, 108);
                    List<Attachment> lstAttachments = new List<Attachment>();
                    // your remote SMTP server IP.
                    for (int i = 0; i < dsEmailTemplate.Tables[1].Rows.Count; i++)
                    {
                        string sourceDir = Server.MapPath(dsEmailTemplate.Tables[1].Rows[i]["DocumentPath"].ToString());
                        if (File.Exists(sourceDir))
                        {
                            Attachment attachment = new Attachment(sourceDir);
                            attachment.Name = Path.GetFileName(sourceDir);
                            lstAttachments.Add(attachment);
                        }
                    }

                    CommonFunction.SendEmail(JGConstant.EmailTypes.TaskAutoEmail.ToString(), HTMLTemplates.Task_Generator_Auto_Email.ToString(), emailId, strsubject, strBody, lstAttachments);
                }
            }
            catch (Exception ex)
            {
                Console.WriteLine("{0} Exception caught.", ex);
            }
        }

        private void LoadNextQuestion()
        {
            int repeaterItemIndex = 0;

            // If next question is set then load its detail, else load by default first question.
            if (this.NextQuestion > 0)
            {
                repeaterItemIndex = this.NextQuestion;
            }

            RepeaterItem rptQuestionItem = rptQuestions.Items[repeaterItemIndex];

            SetQuestionUI(rptQuestionItem);
        }

        private void populateExams()
        {
            DataTable dsExams = AptitudeTestBLL.Instance.GetExamsByUserID(UserID);
            if (dsExams != null && dsExams.Rows.Count > 0)
            {

                this.TotalExams = dsExams.Rows.Count;
                this.DesignationID = Convert.ToInt32(dsExams.Rows[0]["DesignationID"].ToString());
                this.DesignationName = Convert.ToString(dsExams.Rows[0]["Designation"].ToString());

                rptExams.DataSource = dsExams;
                rptExams.DataBind();
                upnlMainExams.Update();
            }
        }

        private void populateLabel()
        {
            DataTable examsNotWrittenYet = AptitudeTestBLL.Instance.GetExamByExamID(Enums.Aptitude_ExamType.DotNet, UserID);

            if (examsNotWrittenYet.Rows.Count == 0)
            {
                Label1.ForeColor = Color.DarkBlue;
                Label1.Text = "";
            }
            else
            {
                string buff = "<table class='tblExamStartup' bgcolor=white>";

                foreach (DataRow ExamRow in examsNotWrittenYet.Rows)
                {
                    //if (Enums.Aptitude_ExamType.DotNet.GetHashCode() == (int)ExamRow["ExamType"])
                    {
                        String url = "StartExam";
                        buff += "<tr><td>Click on following link to Start Exam ";
                        buff += "</Br></Br></Br>";
                        buff += "<b><a href=" + url + ".aspx?exam_id=" + ExamRow["ExamID"].ToString() + ">" + ExamRow["ExamTitle"] + "</a></b></td>";
                        buff += "</tr>";
                        buff += "<tr><td> </Br></Br>" + ExamRow["ExamDescription"] + "</td>";
                        buff += "</Br></Br></Br></tr>";
                    }

                    buff += "</table>";
                    Label1.Text = buff;
                }
            }

        }

        private void SetExamSectionViews()
        {
            divTakeExam.Visible = false;
            divExamSection.Visible = true;
        }

        private void LoadQuestionsForExam()
        {
            DataTable questionTable = AptitudeTestBLL.Instance.GetQuestionsForExamByID(this.CurrentExamID.ToString());
            rptQuestions.DataSource = questionTable;

            rptQuestions.DataBind();

            //Set Exam Timeout Values in 
            SetExamTimerSessionValues(questionTable);

            SetTimerOnPage();

        }

        private void SetTimerOnPage()
        {
            // if exam start registration time available.
            if (JGSession.ExamTimerSetTime != null && divExamSection.Visible == true)
            {
                // Subtract Registered time from time now will yeild total time taken so far.
                TimeSpan TimeTaken = DateTime.Now.Subtract(Convert.ToDateTime(JGSession.ExamTimerSetTime));

                // Subtract total exam alloted time from time taken will yeild Time left to give exam.
                Double MilliSecondLeft = (JGSession.CurrentExamTime * 60000) - TimeTaken.TotalMilliseconds;

                //TODO: If timeup then call time up methods.

                // If time left to give exam then show that time.
                if (MilliSecondLeft > 0)
                {
                    int secondLeft = Convert.ToInt32(MilliSecondLeft * 0.001);
                    hdnTimeLeft.Value = secondLeft.ToString();
                    //ScriptManager.RegisterStartupScript(this,this.Page.GetType(), "timerDisplay", "startExamTimer(" + secondLeft.ToString() + ");", true); 
                }

            }
        }

        private void SetExamTimerSessionValues(DataTable questionTable)
        {
            // Set when exam time started.
            JGSession.ExamTimerSetTime = DateTime.Now;
            JGSession.CurrentExamTime = Convert.ToInt32(questionTable.Rows[0]["ExamDuration"]);
            hdnCurrentExamTime.Value = JGSession.CurrentExamTime.ToString();
        }

        private void SetQuestionUI(RepeaterItem e)
        {
            LinkButton hypQuestion = (LinkButton)e.FindControl("hypQuestion");

            //hypQuestion.CssClass = "greentext";

            int QuestionID = Convert.ToInt32(hypQuestion.CommandArgument);

            String Question = ((Literal)(e.FindControl("ltlQuestionText"))).Text;

            this.CurrentQuestion = QuestionID;

            // Set next question to load, if it reaches last question, set it to first question.
            this.NextQuestion = e.ItemIndex == rptQuestions.Items.Count - 1 == true ? 0 : e.ItemIndex + 1;

            ltlQuesNo.Text = String.Concat("Q", (e.ItemIndex + 1).ToString());
            ltlQuestionTitle.Text = Question;

            hdnPMarks.Value = ((HiddenField)(e.FindControl("hdnPMarks"))).Value;
            hdnNMarks.Value = ((HiddenField)(e.FindControl("hdnNMarks"))).Value;

            SetAnswerOptions(QuestionID);

            SetCorrectAnswer(QuestionID);
        }

        private void SetAnswerOptions(int QuestionID)
        {
            DataTable optionData = AptitudeTestBLL.Instance.GetQuestionsoptionByQustionID(QuestionID);

            rblQuestionOptions.DataSource = optionData;
            rblQuestionOptions.DataTextField = "OptionText";
            rblQuestionOptions.DataValueField = "OptionID";

            rblQuestionOptions.DataBind();

            //if question is already attempted, set answer earlier given as preselected.
            if (this.ExamAttempted.ContainsKey(QuestionID))
            {
                String attemptedanswer = getUserAttemptedAnswerFromString(this.ExamAttempted[QuestionID]);

                ListItem answer = rblQuestionOptions.Items.FindByValue(attemptedanswer);

                if (answer != null)
                {
                    rblQuestionOptions.SelectedIndex = rblQuestionOptions.Items.IndexOf(answer);
                }

            }
        }

        /// <summary>
        /// Return Attempted answer from Value
        /// (seperated by '-'): 1. User Answer 2. Correct Answer 3. Positive Marks  4. Negative Marks
        /// </summary>
        /// <param name="examAttemptString"></param>
        /// <returns>1. User Answer</returns>
        private string getUserAttemptedAnswerFromString(string examAttemptString)
        {
            return (examAttemptString.Split(new char[] { '-' }, StringSplitOptions.RemoveEmptyEntries))[0];
        }

        /// <summary>
        /// Return Correct answer from Value
        /// (seperated by '-'): 1. User Answer 2. Correct Answer 3. Positive Marks  4. Negative Marks
        /// </summary>
        /// <param name="examAttemptString"></param>
        /// <returns>2. Correct Answer</returns>
        private string getCorrectAnswerFromString(string examAttemptString)
        {
            return (examAttemptString.Split(new char[] { '-' }, StringSplitOptions.RemoveEmptyEntries))[1];
        }

        /// <summary>
        /// Return Positive mark from Value
        /// (seperated by '-'): 1. User Answer 2. Correct Answer 3. Positive Marks  4. Negative Marks
        /// </summary>
        /// <param name="examAttemptString"></param>
        /// <returns>3. Positive Marks</returns>
        private string getPMarkForAnswerFromString(string examAttemptString)
        {
            return (examAttemptString.Split(new char[] { '-' }, StringSplitOptions.RemoveEmptyEntries))[2];
        }

        /// <summary>
        /// Return Negative mark from Value
        /// (seperated by '-'): 1. User Answer 2. Correct Answer 3. Positive Marks  4. Negative Marks
        /// </summary>
        /// <param name="examAttemptString"></param>
        /// <returns> 4. Negative Marks</returns>
        private string getNMarkForAnswerFromString(string examAttemptString)
        {
            return (examAttemptString.Split(new char[] { '-' }, StringSplitOptions.RemoveEmptyEntries))[3];
        }

        private void SetCorrectAnswer(int questionID)
        {
            DataTable correctAnswerData = AptitudeTestBLL.Instance.GetcorrectAnswerByQuestionID(questionID);
            if (correctAnswerData.Rows.Count > 0)
            {
                hdnCorrectAnswer.Value = correctAnswerData.Rows[0]["OptionID"].ToString();
            }
        }

        private void CheckExamCompletion()
        {
            // if user has attempted all questions.   
            if (this.ExamAttempted.Count == rptQuestions.Items.Count)
            {
                divEndExam.Visible = true;
            }
        }

        private void MarkQuestionAsAttempted()
        {

            int ItemIndex = this.NextQuestion - 1;

            if (ItemIndex < 0)// if last question in repeater then bydefault next question will be 0.
            {
                ItemIndex = rptQuestions.Items.Count - 1;
            }
            RepeaterItem item = rptQuestions.Items[ItemIndex];

            LinkButton hypQuestion = (LinkButton)item.FindControl("hypQuestion");

            if (hypQuestion != null)
            {
                hypQuestion.CssClass = "redtext";
            }
        }

        private void CountExamResultandReset()
        {
            Dictionary<int, string> examAttempted = this.ExamAttempted;

            double markScored = 0;
            double TotalMarks = 0;
            foreach (KeyValuePair<int, string> question in examAttempted)
            {
                int attemptedAnswer = Convert.ToInt32(getUserAttemptedAnswerFromString(question.Value));
                int correctAnswer = Convert.ToInt32(getCorrectAnswerFromString(question.Value));
                int PMark = Convert.ToInt32(getPMarkForAnswerFromString(question.Value));
                int NMark = Convert.ToInt32(getNMarkForAnswerFromString(question.Value));

                TotalMarks = TotalMarks + PMark;

                //if user has attempted correct answer then increase mark obtained.
                if (attemptedAnswer == correctAnswer)
                {
                    markScored = markScored + PMark;
                }
                else // if question has negative marking, minus, negative marks from users marks obtained.
                {
                    if (NMark > 0)
                    {
                        markScored = markScored - NMark;
                    }
                }

            }

            // Now obtained percentages are calculated inside store procedure.
            //double percentageObtained = 0.0;

            //percentageObtained = getUserPassingPercentage(TotalMarks, markScored);

            markScored = markScored < 0 ? 0 : markScored;

            UpdateUserExamSummary((int)markScored,this.UserID);

            ResetExamParameter();
        }

        private void ResetExamParameter()
        {

            this.ExamsGiven = String.Concat(this.ExamsGiven, this.CurrentExamID.ToString(), ",");

            this.CurrentQuestion = 0;
            this.ExamAttempted = null;
            this.NextQuestion = 0;
            this.CurrentExamID = 0;
            JGSession.ExamTimerSetTime = null;
            JGSession.CurrentExamTime = 0;
            divEndExam.Visible = false;
            hdnTimeLeft.Value = "0";

           // String userExamsGiven = this.ExamsGiven;

           // string[] exams = userExamsGiven.Split(new char[] { ',' }, StringSplitOptions.RemoveEmptyEntries);

            bool isAllExamGiven = false;

            double overAllPercentageScored = 0;

            overAllPercentageScored = AptitudeTestBLL.Instance.GetExamsResultByUserID(UserID, ref isAllExamGiven);


            if (isAllExamGiven)// if user has finished attempting all available designation exams then check pass or fail result.
            {
                // set flag to exam over so auto exam time up doesn't happens.
                hdnExamsOver.Value = "1";

                //All exams finished.

                #region "-- Aptitude test result based status change - OLD --"
                // Changed By - Yogesh Keraliya
                //  Reference:  Skype Chat JG-KY 03/23/2018
                //// If obtained aggregated percentage is less than acceptable level, user is unfit to join JG.
                //if (overAllPercentageScored < JGApplicationInfo.GetAcceptiblePrecentage())
                //{
                //    //Set User status as rejected.
                //    UpdateUserStatusAsRejectedWithReason(UserID, "Didn't Passed apptitude test.");
                //    LogoutUser(true);

                //}
                //else // User is pass into our application.
                //{
                //    //After successfully completed test , Status will be applicant again.
                //    UpdateUserStatusAsApplicantWithReason(UserID, "Completed apptitude test successfully.");

                //    //Response.Redirect("~/ViewApplicantUser.aspx?Id="+UserID+"&IE=1");

                //    #region "-- old cold commented --"
                //    /// Modified By: Yogesh Keraliya
                //    /// Modified Date: 11/16/2017
                //    /// Description: Flow changed after discussion with JG, http://web.jmgrovebuildingsupply.com/Sr_App/TaskGenerator.aspx?TaskId=686&hstid=722
                //    /// Point X. 2,3
                //    /// If user successfully completed test, but haven't accepted task their status is still in "Applicant"
                //    //UpdateUserStatusAsInterviewDateWithReason(DateTime.Now.AddDays(2), "Exam successfully cleared!s"); 
                //    #endregion

                //    ScriptManager.RegisterStartupScript(this, this.Page.GetType(), "ExamPassed", "SuccessRedirect(" + UserID + ");", true);

                //    //Get latest task to be assigned for user's designation.
                //    //DataSet dsTaskToBeAssigned = TaskGeneratorBLL.Instance.GetDesignationTaskToAssignWithSequence(this.DesignationID, true);

                //    //if (dsTaskToBeAssigned != null && dsTaskToBeAssigned.Tables.Count > 0 && dsTaskToBeAssigned.Tables[0].Rows.Count > 0)
                //    //{
                //    //    // Assign automatic task to user.
                //    //    AssignedTaskToUser(UserID, Convert.ToUInt64(dsTaskToBeAssigned.Tables[0].Rows[0]["TaskId"]), Convert.ToUInt64(dsTaskToBeAssigned.Tables[0].Rows[0]["ParentTaskId"]), Convert.ToString(dsTaskToBeAssigned.Tables[0].Rows[0]["Title"]), Convert.ToString(dsTaskToBeAssigned.Tables[0].Rows[0]["InstallId"]));

                //    //    //Update automatic task sequence  assignment
                //    //    InsertAssignedTaskSequenceInfo(Convert.ToInt64(dsTaskToBeAssigned.Tables[0].Rows[0]["TaskId"]), this.DesignationID, Convert.ToInt64(dsTaskToBeAssigned.Tables[0].Rows[0]["AvailableSequence"]), true);

                //    //    //SetInterviewDateNTime();

                //    //    SetExamPassedMessage(dsTaskToBeAssigned.Tables[0].Rows[0]["InstallId"].ToString(), dsTaskToBeAssigned.Tables[0].Rows[0]["Title"].ToString(), Convert.ToInt64(dsTaskToBeAssigned.Tables[0].Rows[0]["TaskId"]), Convert.ToInt64(dsTaskToBeAssigned.Tables[0].Rows[0]["ParentTaskId"]));

                //    //    ScriptManager.RegisterStartupScript(this, this.Page.GetType(), "ExamPassed", "showExamPassPopup();", true);
                //    //}
                //}
                #endregion

                #region "-- Aptitude test result based status change - NEW --"
                // If obtained aggregated percentage is less than acceptable level, user is unfit to join JG.
                if (overAllPercentageScored < JGApplicationInfo.GetAcceptiblePrecentage())
                {
                    // Changed By - Yogesh Keraliya
                    // Reference:  Skype Chat JG-KY 03/23/2018
                    //Set User status as rejected.
                    //UpdateUserStatusAsRejectedWithReason(UserID, "Didn't Passed apptitude test.");
                    //LogoutUser(true);

                    //keep user status as applicant but set message of fail.
                    UpdateUserStatusAsApplicantWithReason(UserID, "Didn't Passed apptitude test.");
                    ScriptManager.RegisterStartupScript(this, this.Page.GetType(), "ExamPassed", "SuccessRedirect(" + UserID + "," + DesignationID + ");", true);
                }
                else // User is pass into our application.
                {
                    //After successfully completed test , Status will be applicant again.
                    UpdateUserStatusAsApplicantWithReason(UserID, "Completed apptitude test successfully.");

                    //Response.Redirect("~/ViewApplicantUser.aspx?Id="+UserID+"&IE=1");

                    #region "-- old cold commented --"
                    /// Modified By: Yogesh Keraliya
                    /// Modified Date: 11/16/2017
                    /// Description: Flow changed after discussion with JG, http://web.jmgrovebuildingsupply.com/Sr_App/TaskGenerator.aspx?TaskId=686&hstid=722
                    /// Point X. 2,3
                    /// If user successfully completed test, but haven't accepted task their status is still in "Applicant"
                    //UpdateUserStatusAsInterviewDateWithReason(DateTime.Now.AddDays(2), "Exam successfully cleared!s"); 
                    #endregion

                  

                    //Get latest task to be assigned for user's designation.
                    //DataSet dsTaskToBeAssigned = TaskGeneratorBLL.Instance.GetDesignationTaskToAssignWithSequence(this.DesignationID, true);

                    //if (dsTaskToBeAssigned != null && dsTaskToBeAssigned.Tables.Count > 0 && dsTaskToBeAssigned.Tables[0].Rows.Count > 0)
                    //{
                    //    // Assign automatic task to user.
                    //    AssignedTaskToUser(UserID, Convert.ToUInt64(dsTaskToBeAssigned.Tables[0].Rows[0]["TaskId"]), Convert.ToUInt64(dsTaskToBeAssigned.Tables[0].Rows[0]["ParentTaskId"]), Convert.ToString(dsTaskToBeAssigned.Tables[0].Rows[0]["Title"]), Convert.ToString(dsTaskToBeAssigned.Tables[0].Rows[0]["InstallId"]));

                    //    //Update automatic task sequence  assignment
                    //    InsertAssignedTaskSequenceInfo(Convert.ToInt64(dsTaskToBeAssigned.Tables[0].Rows[0]["TaskId"]), this.DesignationID, Convert.ToInt64(dsTaskToBeAssigned.Tables[0].Rows[0]["AvailableSequence"]), true);

                    //    //SetInterviewDateNTime();

                    //    SetExamPassedMessage(dsTaskToBeAssigned.Tables[0].Rows[0]["InstallId"].ToString(), dsTaskToBeAssigned.Tables[0].Rows[0]["Title"].ToString(), Convert.ToInt64(dsTaskToBeAssigned.Tables[0].Rows[0]["TaskId"]), Convert.ToInt64(dsTaskToBeAssigned.Tables[0].Rows[0]["ParentTaskId"]));

                    //    ScriptManager.RegisterStartupScript(this, this.Page.GetType(), "ExamPassed", "showExamPassPopup();", true);
                    //}
                }
                //btnClosePopup.Visible = true;
                ScriptManager.RegisterStartupScript(this, this.Page.GetType(), "ExamPassed", "SuccessRedirect(" + UserID + ","+ DesignationID +");", true);

                #endregion

            }
            else
            {
                //Load exam with result again.
                populateExams();

                //Start next pending exam.
                StartExam();
            }


        }



        // update user status to interview date.
        private DataSet UpdateUserStatusAsInterviewDateWithReason(DateTime InterviewDateNTime, String StatusReason = "Default automated interview date assigned")
        {
            return InstallUserBLL.Instance.ChangeUserSatatus(UserID, Convert.ToInt32(JGConstant.InstallUserStatus.InterviewDate), InterviewDateNTime.Date, InterviewDateNTime.ToShortTimeString(), JGApplicationInfo.GetJMGCAutoUserID(), JGSession.IsInstallUser.Value, StatusReason, UserID.ToString());
        }


        private void LogoutUser(bool isFailed)
        {
            //Logout user and clear its session value.
            Session["ID"] = null;
            Session.Clear();
            Session.Abandon();
            String ScriptString = "redirectParentToLoginPage('" + Page.ResolveUrl("~/stafflogin.aspx") + (isFailed == true ? "?UF=1" : String.Empty) + "');";
            ScriptManager.RegisterStartupScript(this, this.Page.GetType(), "ExamPassed", ScriptString, true);
        }

        private void InsertAssignedTaskSequenceInfo(long TaskId, int DesignationID, long AssignedSequence, bool IsTechTask)
        {
            TaskGeneratorBLL.Instance.InsertAssignedDesignationTaskWithSequence(DesignationID, IsTechTask, AssignedSequence, TaskId, this.UserID);
        }

        private void FillUserDetailsForConfirmation()
        {
            DataSet dsUserDetails = InstallUserBLL.Instance.getuserdetails(UserID);
        }

        private void UpdateUserStatusAsRejectedWithReason(int userID, String ReasonMessage)
        {
            // Changed By Yogesh Keraliya
            // Reference : JG-YK skype chat 03/23/2018
            //InstallUserBLL.Instance.ChangeUserStatusToReject(Convert.ToInt32(JGConstant.InstallUserStatus.Rejected), DateTime.Now.Date, DateTime.Now.ToShortTimeString(), JGApplicationInfo.GetJMGCAutoUserID(), Convert.ToInt32(Session["ID"]), ReasonMessage);
            InstallUserBLL.Instance.ChangeUserStatusToReject(Convert.ToInt32(JGConstant.InstallUserStatus.Applicant), DateTime.Now.Date, DateTime.Now.ToShortTimeString(), JGApplicationInfo.GetJMGCAutoUserID(), Convert.ToInt32(Session["ID"]), ReasonMessage);
        }

        private void UpdateUserStatusAsApplicantWithReason(int userID, String ReasonMessage)
        {
            InstallUserBLL.Instance.ChangeUserStatusToReject(Convert.ToInt32(JGConstant.InstallUserStatus.Applicant), DateTime.Now.Date, DateTime.Now.ToShortTimeString(), JGApplicationInfo.GetJMGCAutoUserID(), Convert.ToInt32(Session["ID"]), ReasonMessage);
        }

        //Update User Exam Summary.
        private void UpdateUserExamSummary(int markScored, int userID)
        {
            AptitudeTestBLL.Instance.InsertPerformance(UserID, CurrentExamID, markScored);
        }

        private double getUserPassingPercentage(double totalMakrs, double markScored)
        {
            double passingPercentage = 0;

            //set total Marks to 1 to avoid divide by zero error.
            totalMakrs = totalMakrs <= 0 ? 1 : totalMakrs;

            //if marks scored are negative, than make it 0.
            markScored = markScored < 0 ? 0 : markScored;

            Math.Round((markScored / totalMakrs) * 100.00, 2);

            return passingPercentage;

        }

        private void StartExam()
        {
            foreach(RepeaterItem item in rptExams.Items)
            {
                Label lblResult = (Label)item.FindControl("lblResult");
                if(lblResult.Text.ToLower() == "pass" || lblResult.Text.ToLower() == "fail")
                {
                    continue;
                }
                else
                {
                    this.NextExamSeq = item.ItemIndex;
                    break;
                }
            }
            if (rptExams.Items.Count > this.NextExamSeq)
            {
                // Start very first exam.
                if (this.NextExamSeq == 0)
                {
                    //Before user starts exam set his/her status to Rejected/With Reason, and set it to interview date only when that user has completed all exams. 
                    UpdateUserStatusAsRejectedWithReason(UserID, "Left apptitude test without completing it.");

                    this.CurrentExamID = Convert.ToInt32(((Literal)rptExams.Items[0].FindControl("ltlExamId")).Text);
                    this.NextExamSeq = 1;// fetch next exam from repeater item index.
                }
                else
                {
                    this.CurrentExamID = Convert.ToInt32(((Literal)rptExams.Items[this.NextExamSeq].FindControl("ltlExamId")).Text);

                    this.NextExamSeq = this.NextExamSeq + 1;
                }

                if (!AptitudeTestBLL.Instance.IsExamGivenByUserByExamId(UserID, CurrentExamID))
                {
                    SetExamSectionViews();
                    LoadQuestionsForExam();
                    LoadNextQuestion();
                }

            }
        }

        private void SendEmail(string EmailType, string emailId, string FName, string LName, string status, string Reason, string Designition, int DesignitionId, string HireDate, string EmpType, string PayRates, HTMLTemplates objHTMLTemplateType, DateTime InterviewDateTime, List<Attachment> Attachments = null, string strManager = "")
        {
            DesignationHTMLTemplate objHTMLTemplate = HTMLTemplateBLL.Instance.GetDesignationHTMLTemplate(objHTMLTemplateType, DesignitionId.ToString());

            string fullname = FName + " " + LName;

            string strHeader = objHTMLTemplate.Header;
            string strBody = objHTMLTemplate.Body;
            string strFooter = objHTMLTemplate.Footer;
            string strsubject = objHTMLTemplate.Subject;

            strBody = strBody.Replace("#Email#", emailId).Replace("#email#", emailId);
            strBody = strBody.Replace("#FirstName#", FName);
            strBody = strBody.Replace("#LastName#", LName);
            strBody = strBody.Replace("#Name#", FName).Replace("#name#", FName);
            strBody = strBody.Replace("#Date#", CommonFunction.GetStandardDateString(InterviewDateTime)).Replace("#date#", CommonFunction.GetStandardDateString(InterviewDateTime));
            strBody = strBody.Replace("#Time#", CommonFunction.GetStandardTimeString(InterviewDateTime)).Replace("#time#", CommonFunction.GetStandardDateString(InterviewDateTime));
            strBody = strBody.Replace("#Designation#", Designition).Replace("#designation#", Designition);

            strFooter = strFooter.Replace("#Name#", FName).Replace("#name#", FName);
            strFooter = strFooter.Replace("#Date#", CommonFunction.GetStandardDateString(InterviewDateTime)).Replace("#date#", CommonFunction.GetStandardDateString(InterviewDateTime));
            strFooter = strFooter.Replace("#Time#", CommonFunction.GetStandardTimeString(InterviewDateTime)).Replace("#time#", CommonFunction.GetStandardTimeString(InterviewDateTime));
            strFooter = strFooter.Replace("#Designation#", Designition).Replace("#designation#", Designition);

            strBody = strBody.Replace("Lbl Full name", fullname);
            strBody = strBody.Replace("LBL position", Designition);
            //strBody = strBody.Replace("lbl: start date", txtHireDate.Text);
            //strBody = strBody.Replace("($ rate","$"+ txtHireDate.Text);
            strBody = strBody.Replace("Reason", Reason);

            strBody = strBody.Replace("#manager#", strManager);

            strBody = strHeader + strBody + strFooter;



            List<Attachment> lstAttachments = objHTMLTemplate.Attachments;


            if (Attachments != null)
            {
                lstAttachments.AddRange(Attachments);
            }

            try
            {
                JG_Prospect.App_Code.CommonFunction.SendEmail(EmailType, Designition, emailId, strsubject, strBody, lstAttachments);

                ScriptManager.RegisterStartupScript(this, this.GetType(), "UserMsg", "alert('An email notification has sent on " + emailId + ".');", true);
            }
            catch
            {
                ScriptManager.RegisterStartupScript(this, this.GetType(), "UserMsg", "alert('Error while sending email notification on " + emailId + ".');", true);
            }
        }

        #endregion

        #region "-- Web Methods --"



        #endregion

        //protected void btnClosePopup_Click(object sender, EventArgs e)
        //{
        //    Response.Redirect("../postapptitude.aspx?DId=" + DesignationID + "&UId=" + ID);
        //}
    }
}