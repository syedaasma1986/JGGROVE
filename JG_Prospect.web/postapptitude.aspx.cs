using JG_Prospect.App_Code;
using JG_Prospect.BLL;
using JG_Prospect.Common;
using JG_Prospect.Common.modal;
using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data;
using System.IO;
using System.Linq;
using System.Net;
using System.Net.Mail;
using System.Text;
using System.Web;
using System.Web.Services;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace JG_Prospect
{
    public partial class postapptitude : System.Web.UI.Page
    {
        #region '--Members--'
        public static string InstallerUserIntro = "https://web.jmgrovebuildingsupply.com/Tutorials/installer-sub-video-intro.mp4";
        public static string SalesUserIntro = "https://web.jmgrovebuildingsupply.com/Tutorials/introduction-and-JG-app-tutorial.mp4";
        
        #endregion

        #region '--Properties--'

        public bool ShowGithubField
        {
            get
            {
                bool GithubField = false;
                if (ViewState["ShowGithubField"] != null)
                {
                    Boolean.TryParse(ViewState["ShowGithubField"].ToString(), out GithubField);
                }
                return GithubField;
            }
            set
            {
                ViewState["ShowGithubField"] = value;
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

        public Int64 AssignedSequenceID
        {
            get
            {
                Int64 intSeqID = 0;
                if (ViewState["ASID"] != null)
                {
                    Int64.TryParse(ViewState["ASID"].ToString(), out intSeqID);
                }
                return intSeqID;
            }
            set
            {
                ViewState["ASID"] = value;
            }
        }

        #endregion

        #region '--Page Events--'

        protected void Page_Load(object sender, EventArgs e)
        {
            CommonFunction.AuthenticateUser();

            #region -- Page Load --

            if (!IsPostBack)
            {
                if (Request.QueryString != null && Request.QueryString.Count > 0)
                {
                    this.DesignationID = Convert.ToInt32(Request.QueryString["DId"]);
                    hdnUDID.Value = this.DesignationID.ToString();
                    this.UserID = Convert.ToInt32(Request.QueryString["UId"]);
                    
                    SetCarrerPathDetails();
                    SetLegalDisclaimer();
                    SetUserContactDetails();

                    SetAutoTaskSequence();
                }
            }

            #endregion

        }

        private void SetLegalDisclaimer()
        {

            DesignationHTMLTemplate objHTMLTemplate = HTMLTemplateBLL.Instance.GetDesignationHTMLTemplate(HTMLTemplates.Legal_Desclaimer, this.DesignationID.ToString());
            ltlLegal.Text = objHTMLTemplate.Header + objHTMLTemplate.Body + objHTMLTemplate.Footer;
        }

        private void SetCarrerPathDetails()
        {
            DesignationHTMLTemplate objHTMLTemplate = HTMLTemplateBLL.Instance.GetDesignationHTMLTemplate(HTMLTemplates.Carrer_Path, this.DesignationID.ToString());
            ltlCPath.Text = objHTMLTemplate.Header + objHTMLTemplate.Body + objHTMLTemplate.Footer; 
        }

        private void SetUserContactDetails()
        {
            DataSet ds = InstallUserBLL.Instance.getInstallUserDetailsById(Convert.ToInt32(JGSession.LoginUserID));

            if (ds != null && ds.Tables.Count > 0 && ds.Tables[0].Rows.Count > 0)
            {
                if (!String.IsNullOrEmpty(ds.Tables[0].Rows[0]["Picture"].ToString()))
                {
                    imgprofile.ImageUrl = String.Concat("~/Employee/ProfilePictures/", ds.Tables[0].Rows[0]["Picture"].ToString());
                }
                else
                {
                    imgprofile.ImageUrl = "~/Employee/ProfilePictures/default.jpg";
                }
            }

            hypExam.HRef = String.Concat(hypExam.HRef, this.UserID.ToString());

            lblFirstName.Text = ds.Tables[0].Rows[0]["FristName"].ToString();
            lblLastName.Text = ds.Tables[0].Rows[0]["LastName"].ToString();
            lblDisignation.Text = ds.Tables[0].Rows[0]["Designation"].ToString();
            ddlEmployeeType.SelectedIndex = ddlEmployeeType.SelectedIndex;

            divCountryCode.Attributes["class"] = String.Concat("flagsprite ", ds.Tables[0].Rows[0]["CountryCode"].ToString().ToLower());

            lblCity.Text = ds.Tables[0].Rows[0]["City"].ToString();
            lblZip.Text = ds.Tables[0].Rows[0]["Zip"].ToString();

            lblPrimaryPhone.Text = ds.Tables[0].Rows[0]["Phone"].ToString();

            if (!String.IsNullOrEmpty(ds.Tables[0].Rows[0]["EmpType"].ToString()))
            {
                ddlEmployeeType.SelectedValue = ds.Tables[0].Rows[0]["EmpType"].ToString();
            }

            ddlEmail.DataSource = ds.Tables[1];
            ddlEmail.DataTextField = "emailID";
            ddlEmail.DataBind();

            ddlPhone.DataSource = ds.Tables[2];
            ddlPhone.DataTextField = "Phone";
            ddlPhone.DataBind();

            if (ds.Tables[0].Rows[0]["UserType"].ToString() == "SalesUser")
            {
                hdnDefIntroV.Value = SalesUserIntro;
            }
            else
            {
                hdnDefIntroV.Value = InstallerUserIntro;
            }

        }

        #endregion

        #region '--Control Events--'

        #region ' -- Button --'
        protected void btnAcceptTask_Click(object sender, EventArgs e)
        {
            int taskId = TaskGeneratorBLL.Instance.GetTaskIdByTaskSequence(this.AssignedSequenceID);
            TaskGeneratorBLL.Instance.AcceptUserAssignedWithSequence(this.AssignedSequenceID);

            ChangePassword();

            //Set user's status to InterviewDate.
            ChangetoInterviewdateStatusandSendEmailtoUser();
                      
            //  User successfully accepted tech task
            string strUserInstallId = JGSession.Username + " - " + JGSession.LoginUserID;
            int userID = Convert.ToInt32(JGSession.LoginUserID);
            //InstallUserBLL.Instance.AddTouchPointLogRecord(userID, userID, strUserInstallId, DateTime.Now.ToEST(), "User successfully accepted tech task", "", 
            //                        (int)TouchPointSource.ViewApplicantUser, taskId, null);
            ChatBLL.Instance.AddHRChatMessage(userID, "User successfully accepted tech task",null);

            ScriptManager.RegisterStartupScript(this, this.Page.GetType(), "SuccessfulRedirect", "TaskAcceptSuccessRedirect('" + hypTaskLink.HRef + "');", true);

            if (divTaskAssigned.Visible)
            {
                TaskGeneratorBLL.Instance.AcceptUserAssignedWithSequence(this.AssignedSequenceID);
                ScriptManager.RegisterStartupScript(this, this.Page.GetType(), "SuccessfulRedirect", "TaskAcceptSuccessRedirect('" + hypTaskLink.HRef + "');", true);
            }
            else
            {
                Response.Redirect("~/Sr_App/ITDashboard.aspx?PWT=1");
            }


        }
        #endregion



        protected void btnRejectTask_Click(object sender, EventArgs e)
        {
            TaskGeneratorBLL.Instance.RejectUserAssignedWithSequence(this.AssignedSequenceID, this.UserID, JGApplicationInfo.GetJMGCAutoUserID());
        }

        protected void btnConfirmCancel_Click(object sender, EventArgs e)
        {

        }

        #endregion

        #region '--Methods--'

        #region 'Private Methods - Assigned Task ToUser '

        private void InsertAssignedTaskSequenceInfo(long TaskId, int DesignationID, long AssignedSequence, bool IsTechTask)
        {
            TaskGeneratorBLL.Instance.InsertAssignedDesignationTaskWithSequence(DesignationID, IsTechTask, AssignedSequence, TaskId, this.UserID);
        }

        private void AssignedTaskToUser()
        {
            ////If dropdown has any value then Assigned it to user else. return 
            //string ApplicantId = Session["ID"].ToString();

            //if (ddlTechTask.Items.Count > 0)
            //{
            //    // save (insert / delete) assigned users.
            //    //bool isSuccessful = TaskGeneratorBLL.Instance.SaveTaskAssignedUsers(Convert.ToUInt64(ddlTechTask.SelectedValue), Session["EditId"].ToString());

            //    // save assigned user a TASK.
            //    bool isSuccessful = TaskGeneratorBLL.Instance.SaveTaskAssignedToMultipleUsers(Convert.ToUInt64(ddlTechTask.SelectedValue), ApplicantId);

            //    // Change task status to assigned = 3.
            //    if (isSuccessful)
            //        UpdateTaskStatus(Convert.ToInt32(ddlTechTask.SelectedValue), Convert.ToUInt16(JGConstant.TaskStatus.Assigned));

            //    if (ddlTechTask.SelectedValue != "" || ddlTechTask.SelectedValue != "0")
            //        SendEmailToAssignedUsers(ApplicantId, ddlTechTask.SelectedValue);

            //}
        }

        private void UpdateTaskStatus(Int32 taskId, UInt16 Status)
        {
            Task task = new Task();
            task.TaskId = taskId;
            task.Status = Status;

            int result = TaskGeneratorBLL.Instance.UpdateTaskStatus(task);    // save task master details


        }

        private void SendEmailToAssignedUsers(string strInstallUserIDs, string strTaskId)
        {
            try
            {
                string strHTMLTemplateName = "Task Generator Auto Email";
                DataSet dsEmailTemplate = AdminBLL.Instance.GetEmailTemplate(strHTMLTemplateName, 108);
                foreach (string userID in strInstallUserIDs.Split(new char[] { ',' }, StringSplitOptions.RemoveEmptyEntries))
                {
                    DataSet dsUser = TaskGeneratorBLL.Instance.GetInstallUserDetails(Convert.ToInt32(userID));

                    string emailId = dsUser.Tables[0].Rows[0]["Email"].ToString();
                    string FName = dsUser.Tables[0].Rows[0]["FristName"].ToString();
                    string LName = dsUser.Tables[0].Rows[0]["LastName"].ToString();
                    string fullname = FName + " " + LName;

                    string strHeader = dsEmailTemplate.Tables[0].Rows[0]["HTMLHeader"].ToString();
                    string strBody = dsEmailTemplate.Tables[0].Rows[0]["HTMLBody"].ToString();
                    string strFooter = dsEmailTemplate.Tables[0].Rows[0]["HTMLFooter"].ToString();
                    string strsubject = dsEmailTemplate.Tables[0].Rows[0]["HTMLSubject"].ToString();
                    string strTaskLinkTitle = CommonFunction.GetTaskLinkTitleForAutoEmail(int.Parse(strTaskId));

                    strBody = strBody.Replace("#Fname#", fullname);
                    strBody = strBody.Replace("#TaskLink#", string.Format("{0}?TaskId={1}&{2}", String.Concat(Request.Url.Scheme, Uri.SchemeDelimiter, Request.Url.Host.Split('?')[0], "/Sr_App/TaskGenerator.aspx"), strTaskId, strTaskLinkTitle));


                    strBody = strBody.Replace("#TaskTitle#", string.Format("{0}?TaskId={1}", Request.Url.ToString().Split('?')[0], strTaskId));

                    strBody = strHeader + strBody + strFooter;

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

                    CommonFunction.SendEmail(JGConstant.EmailTypes.TaskAutoEmail.ToString(), strHTMLTemplateName, emailId, strsubject, strBody, lstAttachments);
                }
            }
            catch (Exception ex)
            {
                Console.WriteLine("{0} Exception caught.", ex);
            }
        }

        private bool UserGivenAllTests(int userID)
        {
            bool isAllExamGiven = false;
            double overAllPercentageScored = 0;

            //Check if user has given exam and is above acceptable percentage.
            overAllPercentageScored = AptitudeTestBLL.Instance.GetExamsResultByUserID(this.UserID, ref isAllExamGiven);

            if (isAllExamGiven && overAllPercentageScored > JGApplicationInfo.GetAcceptiblePrecentage()) // if user has finished attempting all available designation exams then check pass or fail result.
            {
                isAllExamGiven = true;
            }
            else
            {
                isAllExamGiven = false;
            }

            return isAllExamGiven;
        }

        private void SetAutoTaskSequence()
        {

            //Get latest task to be assigned for user's designation.
            DataSet dsTaskToBeAssigned = TaskGeneratorBLL.Instance.GetUserAssignedWithSequence(this.DesignationID, true, this.UserID);

            // If task is assigned to user than show success popup with assigned task information.
            if (dsTaskToBeAssigned != null && dsTaskToBeAssigned.Tables.Count > 0 && dsTaskToBeAssigned.Tables[0].Rows.Count > 0)
            {
                this.AssignedSequenceID = Convert.ToInt64(dsTaskToBeAssigned.Tables[0].Rows[0]["Id"]);

                hdnAssignTaskId.Value = dsTaskToBeAssigned.Tables[0].Rows[0]["TaskId"].ToString();
                hdnParentTaskId.Value = dsTaskToBeAssigned.Tables[0].Rows[0]["ParentTaskId"].ToString();
                // Assign automatic task to user.
                AssignedTaskToUser(this.UserID, Convert.ToUInt64(dsTaskToBeAssigned.Tables[0].Rows[0]["TaskId"]), Convert.ToUInt64(dsTaskToBeAssigned.Tables[0].Rows[0]["ParentTaskId"]), Convert.ToString(dsTaskToBeAssigned.Tables[0].Rows[0]["Title"]), Convert.ToString(dsTaskToBeAssigned.Tables[0].Rows[0]["InstallId"]));

                //Update automatic task sequence  assignment
                //TODO:Uncomment after full spec implementation.
                // InsertAssignedTaskSequenceInfo(Convert.ToInt64(dsTaskToBeAssigned.Tables[0].Rows[0]["TaskId"]), this.DesignationID, Convert.ToInt64(dsTaskToBeAssigned.Tables[0].Rows[0]["AvailableSequence"]), true);

                SetExamPassedMessage(dsTaskToBeAssigned.Tables[0].Rows[0]["InstallId"].ToString(), dsTaskToBeAssigned.Tables[0].Rows[0]["Title"].ToString(), Convert.ToInt64(dsTaskToBeAssigned.Tables[0].Rows[0]["TaskId"]), Convert.ToInt64(dsTaskToBeAssigned.Tables[0].Rows[0]["ParentTaskId"]), dsTaskToBeAssigned.Tables[0].Rows[0]["ParentTitle"].ToString(), false, dsTaskToBeAssigned.Tables[0].Rows[0]["AvailableSequence"].ToString(), DesignationID);
                
            }
            else //If task is not available and not assigned to user than show success popup without assigned task information.
            {
                SetExamPassedMessage(String.Empty, String.Empty, 0, 0, String.Empty, true);


            }
            /*
            // display text in notes" User successfully passed aptitude test"
            string strUserInstallId = JGSession.Username + " - " + JGSession.LoginUserID;
            int userID = Convert.ToInt32(JGSession.LoginUserID);
            InstallUserBLL.Instance.AddTouchPointLogRecord(userID, userID, strUserInstallId, DateTime.Now.ToEST(), "User successfully passed aptitude test", 
                                                    "", (int)TouchPointSource.ViewApplicantUser, null, null);
            */
        }

        private void SetExamPassedMessage(String InstallId, String TaskTitle, Int64 TaskId, Int64 ParentTaskId, String ParentTaskTitle, Boolean IsWithOutTask, string Sequence = null, int SequenceDesignationId = 0)
        {

            ltlUDesg.Text = this.DesignationName;

            // IF task is assigned to user.
            if (!IsWithOutTask)
            {
                ltlTaskInstallID.Text = InstallId;
                ltlTaskTitle.Text = TaskTitle;
                ltlParentTask.Text = ParentTaskTitle;

                //ltlAssignTo.Text = String.Concat(txtfirstname.Text, " ", txtlastname.Text, " - ");

                //ltlAssignToInstallID.Text = hlnkUserID.Text;

                hypTaskLink.HRef = String.Concat(JGApplicationInfo.GetSiteURL(), "/Sr_App/ITDashboard.aspx?TaskId=", ParentTaskId.ToString(), "&hstid=", TaskId.ToString());
                hypTaskLink1.HRef = String.Concat(JGApplicationInfo.GetSiteURL(), "/Sr_App/ITDashboard.aspx?TaskId=", ParentTaskId.ToString(), "&hstid=", TaskId.ToString());

                divTaskAssigned.Visible = true;
            }

            #region "-- User Details in Popup --"


            //ddlEmployeeType.SelectedIndex = ddlEmployeeType.SelectedIndex;

            //  divCountryCode.Attributes.Add("class", ddlCountry.SelectedValue);

            //lblCity.Text = txtCity.Text;
            //lblZip.Text = txtZip.Text;

            ////lbtnEmail.Text = hidExtEmail.Value;

            //lblPrimaryPhone.Text = txtPhone.Text;
            lblExt.Text = txtExt.Text;
            lblSeqtask.InnerText = JGCommon.GetSequenceDisplayText(string.IsNullOrEmpty(Sequence) ? "N.A." : Sequence, SequenceDesignationId, "TT");

            #endregion

            hypExam.HRef = String.Concat(hypExam.HRef, this.UserID);

            hypTaskLink.HRef = String.Concat(JGApplicationInfo.GetSiteURL(), "/Sr_App/ITDashboard.aspx?TaskId=", ParentTaskId.ToString(), "&hstid=", TaskId.ToString(), "&did=", this.DesignationID, "&uid=", this.UserID);
            hypTaskLink1.HRef = String.Concat(JGApplicationInfo.GetSiteURL(), "/Sr_App/ITDashboard.aspx?TaskId=", ParentTaskId.ToString(), "&hstid=", TaskId.ToString(), "&did=", this.DesignationID, "&uid=", this.UserID);

            ////Only for programming designations
            //if (ShowGithubField)
            //{
            //    txtGithubUsername.Text = InstallUserBLL.Instance.GetUserGithubUserName(this.UserID);
            //}

            //trConfirmInterview.Visible = true;


        }

        private void SetUserControlValue(string LoginID)
        {
            //ucAuditTrail.UserLoginID = LoginID;
        }

        private void AssignedTaskToUser(int UserId, UInt64 TaskId, UInt64 ParentTaskId, String TaskTitle, String InstallId)
        {
            string ApplicantId = UserID.ToString();

            // save (insert / delete) assigned users.

            // save assigned user a TASK.
            bool isSuccessful = TaskGeneratorBLL.Instance.SaveTaskAssignedToMultipleUsers(TaskId, ApplicantId);

            // Change task status to assigned = 3.
            if (isSuccessful)
                UpdateTaskStatusExam(TaskId, Convert.ToUInt16(JGConstant.TaskStatus.Assigned));

            SendEmailToAssignedUsers(ApplicantId, ParentTaskId.ToString(), TaskId.ToString(), TaskTitle, InstallId);

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

                    // Added by Zubair Ahmed Khan for displaying proper text for task link
                    string strTaskLinkTitle = CommonFunction.GetTaskLinkTitleForAutoEmail(int.Parse(strTaskId));
                    strBody = strBody.Replace("#TaskLinkTitle#", strTaskLinkTitle);

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

        private void UpdateInstallUserConfirmDetails()
        {
            //user objConfirmUser = new user();
            //objConfirmUser.attachements = GetContractAttachments();
            //objConfirmUser.dob = txtCDateOfBirth.Text;
            //objConfirmUser.citizenship = ddlPenaltyOfPerjury.SelectedValue;
            //objConfirmUser.maritalstatus = ddlcmaritalstatus.SelectedValue;
            //objConfirmUser.MailingAddress = txtApplicantAddress.Text;
            //if (ShowGithubField)
            //    objConfirmUser.GitUserName = txtGithubUsername.Text.Trim();
            //objConfirmUser.PqLicense = UploadDrivingLicense();

            //if (rdoLicenseYes.Checked)
            //{
            //    objConfirmUser.LicenseStatus = true;
            //}

            //objConfirmUser.id = this.UserID;

            //bool result = InstallUserBLL.Instance.UpdateConfirmInstallUser(objConfirmUser);
            //if (result)
            //{
            //    //Allow access to the GitHub Repository
            //    CommonFunction.AddUserAsGitcollaborator(objConfirmUser.GitUserName, JGConstant.GitRepo.Interview);
            //}
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

        private void UpdateTaskStatusExam(UInt64 taskId, UInt16 Status)
        {
            Task task = new Task();
            task.TaskId = Convert.ToInt32(taskId);
            task.Status = Status;

            int result = TaskGeneratorBLL.Instance.UpdateTaskStatus(task);    // save task master details

        }

        private void ChangetoInterviewdateStatusandSendEmailtoUser()
        {
            DataSet dsStatusUpdate;

            DateTime CandidateInterviewDateTime = GetInterviewDateNTime();

           dsStatusUpdate = UpdateUserStatusAsInterviewDateWithReason(CandidateInterviewDateTime , "Default Interview Datetime Option Set - From Opportunity Notice!");
           
            if (dsStatusUpdate.Tables.Count > 0 && dsStatusUpdate.Tables[0].Rows.Count > 0)
            {

                string email = "";
                string HireDate = "";
                string EmpType = "";
                string PayRates = "";
                string gitusername = string.Empty;

                if (Convert.ToString(dsStatusUpdate.Tables[0].Rows[0][0]) != "")
                {
                    email = Convert.ToString(dsStatusUpdate.Tables[0].Rows[0][0]);
                }
                if (Convert.ToString(dsStatusUpdate.Tables[0].Rows[0][1]) != "")
                {
                    HireDate = Convert.ToString(dsStatusUpdate.Tables[0].Rows[0][1]);
                }
                if (Convert.ToString(dsStatusUpdate.Tables[0].Rows[0][2]) != "")
                {
                    EmpType = Convert.ToString(dsStatusUpdate.Tables[0].Rows[0][2]);
                }
                if (Convert.ToString(dsStatusUpdate.Tables[0].Rows[0][3]) != "")
                {
                    PayRates = Convert.ToString(dsStatusUpdate.Tables[0].Rows[0][3]);
                }
                if (!String.IsNullOrEmpty(dsStatusUpdate.Tables[0].Rows[0]["GitUserName"].ToString()))
                {
                    gitusername = dsStatusUpdate.Tables[0].Rows[0]["GitUserName"].ToString();
                }

                SendEmail(email, Convert.ToString(JGSession.Username), Convert.ToString(JGSession.LastName),
           "Interview Date Auto Email", "", JGSession.Designation, JGSession.DesignationId, HireDate, EmpType, PayRates, HTMLTemplates.InterviewDateAutoEmail
           , GetInterviewDateNTime(), null, "");

            }
        }

        private void ChangePassword()
        {
            //int loginid = (int)Session["loginid"];
            int id = Convert.ToInt16(Session[JG_Prospect.Common.SessionKey.Key.UserId.ToString()]);
            // string UserType = (string)Session["usertype"];
            bool result = false;
            result = InstallUserBLL.Instance.ChangeInstallerPassword(id, txtPassword.Text);
            if (result)
            {
                JGSession.IsFirstTime = false;
            }
        }

        private DateTime GetInterviewDateNTime()
        {

            int dayDifference = 5;

            DateTime InterviewDate = DateTime.Now.AddDays(dayDifference);
            DateTime FirstInterviewDate, SecondInterviewDate;
            TimeSpan InterviewTime, FirstInterviewTime, SecondInterviewTime;

            // Check Interview day of week, it should be only Monday, Wednesday, Friday
            // Monday - Friday Interview Time - 10 AM IST and Wednesday Interview Time - 8 PM IST
            switch (InterviewDate.DayOfWeek)
            {
                case DayOfWeek.Monday:
                    FirstInterviewDate = InterviewDate.AddDays(2);// First Interview Date Option - Wednesday                    
                    SecondInterviewDate = InterviewDate.AddDays(4);// Second Interview Date Option - Friday 
                    InterviewTime = SecondInterviewTime = new TimeSpan(10, 00, 00);

                    FirstInterviewTime = new TimeSpan(20, 00, 00);

                    break;

                case DayOfWeek.Friday:
                    FirstInterviewDate = InterviewDate.AddDays(3);// First Interview Date Option - Monday                    
                    SecondInterviewDate = InterviewDate.AddDays(5);// Second Interview Date Option - Wednesday                    

                    InterviewTime = FirstInterviewTime = new TimeSpan(10, 00, 00);
                    SecondInterviewTime = new TimeSpan(20, 00, 00);
                    break;

                case DayOfWeek.Wednesday:
                    FirstInterviewDate = InterviewDate.AddDays(2);// First Interview Date Option - Friday                    
                    SecondInterviewDate = InterviewDate.AddDays(5);// second Interview Date Option - Monday                    

                    InterviewTime = new TimeSpan(20, 00, 00);

                    SecondInterviewTime = FirstInterviewTime = new TimeSpan(10, 00, 00);
                    break;

                case DayOfWeek.Sunday:
                    InterviewDate = InterviewDate.AddDays(1);// Default Interview Date Option - Monday                    
                    FirstInterviewDate = InterviewDate.AddDays(2);// First Interview Date Option - Wednesday                    
                    SecondInterviewDate = InterviewDate.AddDays(4);// Second Interview Date Option - Friday                    

                    InterviewTime = SecondInterviewTime = new TimeSpan(10, 00, 00);

                    FirstInterviewTime = new TimeSpan(20, 00, 00);

                    break;
                case DayOfWeek.Tuesday:
                    InterviewDate = InterviewDate.AddDays(1); // Default Interview Date Option - Wednesday
                    FirstInterviewDate = InterviewDate.AddDays(2);// First Interview Date Option - Friday                    
                    SecondInterviewDate = InterviewDate.AddDays(5);// Second Interview Date Option - Monday

                    InterviewTime = new TimeSpan(20, 00, 00);
                    SecondInterviewTime = FirstInterviewTime = new TimeSpan(10, 00, 00);

                    break;
                case DayOfWeek.Thursday:
                    InterviewDate = InterviewDate.AddDays(1);// Default Interview Date Option - Friday                    
                    FirstInterviewDate = InterviewDate.AddDays(3);// First Interview Date Option - Monday                    
                    SecondInterviewDate = InterviewDate.AddDays(5);// Second Interview Date Option - Wednesday                    

                    InterviewTime = FirstInterviewTime = new TimeSpan(10, 00, 00);

                    SecondInterviewTime = new TimeSpan(20, 00, 00);

                    break;
                case DayOfWeek.Saturday:
                    InterviewDate = InterviewDate.AddDays(2);// Default Interview Date Option - Monday                    
                    FirstInterviewDate = InterviewDate.AddDays(2);// First Interview Date Option - Wednesday                    
                    SecondInterviewDate = InterviewDate.AddDays(4);// Second Interview Date Option - Friday                    

                    InterviewTime = SecondInterviewTime = new TimeSpan(10, 00, 00);

                    FirstInterviewTime = new TimeSpan(20, 00, 00);
                    break;
                default:
                    InterviewTime = FirstInterviewTime = SecondInterviewTime = new TimeSpan(10, 00, 00);
                    FirstInterviewDate = SecondInterviewDate = InterviewDate;
                    break;

            }

            InterviewDate = InterviewDate.Date + InterviewTime;
            FirstInterviewDate = FirstInterviewDate.Date + FirstInterviewTime;
            SecondInterviewDate = SecondInterviewDate.Date + SecondInterviewTime;

            return InterviewDate;
        }
        
        // update user status to interview date.
        private DataSet UpdateUserStatusAsInterviewDateWithReason(DateTime InterviewDateNTime, String StatusReason = "Default automated interview date assigned")
        {
            return InstallUserBLL.Instance.ChangeUserSatatus(UserID, Convert.ToInt32(JGConstant.InstallUserStatus.InterviewDate), InterviewDateNTime.Date, InterviewDateNTime.ToShortTimeString(), JGApplicationInfo.GetJMGCAutoUserID(), JGSession.IsInstallUser.Value, StatusReason, UserID.ToString());
        }

        private void SendEmail(string emailId, string FName, string LName, string status, string Reason, string Designition, int DesignitionId, string HireDate, string EmpType, string PayRates, HTMLTemplates objHTMLTemplateType, DateTime InterviewDateTime, List<Attachment> Attachments = null, string strManager = "")
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
                JG_Prospect.App_Code.CommonFunction.SendEmail(JGConstant.EmailTypes.InterviewEmail.ToString(), Designition, emailId, strsubject, strBody, lstAttachments);                            
        }

       
        #endregion



        #endregion


    }
}