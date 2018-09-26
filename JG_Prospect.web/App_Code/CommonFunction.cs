using JG_Prospect.BLL;
using JG_Prospect.Common;
using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data;
using System.IO;
using System.Net;
using System.Net.Mail;
using System.Text;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Linq;
using System.Reflection;
using System.ComponentModel;
using JG_Prospect.Common.modal;
using System.Collections.Specialized;
using System.Globalization;
using System.Threading;
using System.Web.Hosting;
using JG_Prospect.DAL;

namespace JG_Prospect.App_Code
{
    public static class CommonFunction
    {
        static ReaderWriterLock locker = new ReaderWriterLock();
        static ReaderWriterLock lockerEmailLogs = new ReaderWriterLock();
        static ReaderWriterLock lockerErrors = new ReaderWriterLock();

        public static String PreConfiguredAdminUserId
        {
            get { return ConfigurationManager.AppSettings["AdminUserId"].ToString(); }

        }

        public static string JGPA
        {
            get { return ConfigurationManager.AppSettings["JGPA"].ToString(); }
        }

        /// <summary>
        /// Add a GitHub user as Collaborator in repo        
        /// </summary>
        /// <param name="gitUserName"></param>
        /// <param name="repo"></param>
        public static void AddUserAsGitcollaborator(string gitUserName, JGConstant.GitRepo repo)
        {
            try
            {
                PerformGitAction(repo, JGConstant.GitActions.AddUser, gitUserName);

            }
            catch (Exception ex)
            {
                //Log exception 
                Console.WriteLine("{0} Exception caught.", ex);
            }
        }

        public static int GetUserIdCookie()
        {
            HttpCookie auth_cookie = HttpContext.Current.Request.Cookies[Cookies.UserId];
            if (auth_cookie != null)
                return Convert.ToInt32(auth_cookie.Value);
            return 0;
        }

        /// <summary>
        /// Add a GitHub user as Collaborator in repo        
        /// </summary>
        /// <param name="gitUserName"></param>
        /// <param name="repo"></param>
        public static void DeleteUserFromGit(string gitUserName, JGConstant.GitRepo repo)
        {
            try
            {
                PerformGitAction(repo, JGConstant.GitActions.DeleteUser, gitUserName);
            }
            catch (Exception ex)
            {
                //Log exception 
                Console.WriteLine("{0} Exception caught.", ex);
            }
        }

        /// <summary>
        /// Performs GitHub Actions
        /// </summary>
        /// <param name="repo"></param>
        /// <param name="action"></param>
        /// <param name="UserName"></param>
        private static void PerformGitAction(JGConstant.GitRepo repo, JGConstant.GitActions action, String UserName)
        {
            Octokit.GitHubClient client = null;
            String reponame = string.Empty;
            String adminname = string.Empty;
            switch (repo)
            {
                case JGConstant.GitRepo.Interview:
                    {
                        reponame = ConfigurationManager.AppSettings["GitRepoName"].ToString();
                        adminname = ConfigurationManager.AppSettings["GitRepoAdminName"].ToString();
                        String adminloginId = ConfigurationManager.AppSettings["GitRepoAdminLoginId"].ToString();
                        String adminpassword = ConfigurationManager.AppSettings["GitRepoAdminPassword"].ToString();
                        client = new Octokit.GitHubClient(new Octokit.ProductHeaderValue(ConfigurationManager.AppSettings["GitAppName"].ToString()));
                        Octokit.Credentials basicAuth = new Octokit.Credentials(adminloginId, adminpassword);
                        client.Credentials = basicAuth;
                        break;
                    }
                case JGConstant.GitRepo.Live:
                    {
                        reponame = ConfigurationManager.AppSettings["GitRepoNameLive"].ToString();
                        adminname = ConfigurationManager.AppSettings["GitRepoAdminNameLive"].ToString();
                        String adminloginId = ConfigurationManager.AppSettings["GitRepoAdminLoginIdLive"].ToString();
                        String adminpassword = ConfigurationManager.AppSettings["GitRepoAdminPasswordLive"].ToString();
                        client = new Octokit.GitHubClient(new Octokit.ProductHeaderValue(ConfigurationManager.AppSettings["GitAppNameLive"].ToString()));
                        Octokit.Credentials basicAuth = new Octokit.Credentials(adminloginId, adminpassword);
                        client.Credentials = basicAuth;
                        break;
                    }
            }


            //Perform Actions       
            switch (action)
            {
                case JGConstant.GitActions.AddUser:
                    {
                        client.Repository.Collaborator.Add(adminname, reponame, UserName);
                        break;
                    }
                case JGConstant.GitActions.DeleteUser:
                    {
                        client.Repository.Collaborator.Delete(adminname, reponame, UserName);
                        break;
                    }
            }
        }

        /// <summary>
        /// Call to show javascript alert message from page.
        /// </summary>
        /// <param name="page">Pass page obect of current page. i.e. this.Page</param>
        /// <param name="MessageString">Message which needs to display inside alert</param>
        public static void ShowAlertFromPage(Page page, String MessageString)
        {
            page.ClientScript.RegisterStartupScript(page.GetType(), "alert", String.Concat("alert('", MessageString, "');"), true);
        }

        /// <summary>
        /// Call to show javascript alert message from update panel inside page.
        /// </summary>
        /// <param name="page">Pass page obect of current page. i.e. this.Page</param>
        /// <param name="MessageString">Message which needs to display inside alert</param>
        public static void ShowAlertFromUpdatePanel(Page page, String MessageString)
        {
            ScriptManager.RegisterStartupScript(page, page.GetType(), "alert", String.Concat("alert('", MessageString, "');"), true);
        }

        public static string FormatToShortDateString(object dateobject)
        {
            string formateddatetime = string.Empty;
            DateTime date;

            if (dateobject != null && DateTime.TryParse(dateobject.ToString(), out date))
            {
                formateddatetime = date.ToString("MM/dd/yyyy");
            }

            return formateddatetime;
        }

        public static string FormatDateTimeString(object dateobject)
        {
            string formateddatetime = string.Empty;
            DateTime date;

            if (dateobject != null && DateTime.TryParse(dateobject.ToString(), out date))
            {
                formateddatetime = date.ToString("hh:mm tt MM/dd/yyyy");
            }

            return formateddatetime;
        }

        public static void SetUserIdCookie(string UserId)
        {
            HttpCookie auth = new HttpCookie(Cookies.UserId, UserId);
            auth.Expires = DateTime.Now.AddMonths(20);
            HttpContext.Current.Response.Cookies.Add(auth);
        }

        public static void AuthenticateUser()
        {
            if (!JGSession.IsActive)
            {
                bool autoLogin = false;
                #region Login if auth is present in URL
                string auth = HttpContext.Current.Request.QueryString["auth"];
                if (!string.IsNullOrEmpty(auth))
                {
                    string loginId = InstallUserBLL.Instance.ExpireLoginCode(auth).Object;
                    if (!string.IsNullOrEmpty(loginId))
                    {
                        DataSet ds = InstallUserBLL.Instance.getInstallerUserDetailsByLoginId(loginId.Trim());
                        if (ds.Tables[0].Rows.Count > 0)
                        {
                            HttpContext.Current.Session[JG_Prospect.Common.SessionKey.Key.UserId.ToString()] = ds.Tables[0].Rows[0]["Id"].ToString().Trim();

                            JGSession.Username = ds.Tables[0].Rows[0]["FristName"].ToString().Trim();
                            JGSession.LastName = ds.Tables[0].Rows[0]["LastName"].ToString().Trim();
                            JGSession.UserProfileImg = String.Concat("~/Employee/ProfilePictures/", ds.Tables[0].Rows[0]["Picture"].ToString());
                            JGSession.LoginUserID = ds.Tables[0].Rows[0]["Id"].ToString();
                            JGSession.Designation = ds.Tables[0].Rows[0]["Designation"].ToString().Trim();
                            JGSession.UserInstallId = ds.Tables[0].Rows[0]["UserInstallId"].ToString().Trim();
                            JGSession.UserStatus = (JGConstant.InstallUserStatus)Convert.ToInt32(ds.Tables[0].Rows[0]["Status"]);
                            SetUserIdCookie(ds.Tables[0].Rows[0]["Id"].ToString());
                            if (!string.IsNullOrEmpty(ds.Tables[0].Rows[0]["DesignationId"].ToString()))
                            {
                                JGSession.DesignationId = Convert.ToInt32(ds.Tables[0].Rows[0]["DesignationId"].ToString().Trim());
                            }
                            if (ds.Tables[0].Rows[0]["IsFirstTime"] != null && ds.Tables[0].Rows[0]["IsFirstTime"].ToString().ToLower() == "true")
                            {
                                JGSession.IsFirstTime = true;
                            }

                            JGSession.GuIdAtLogin = Guid.NewGuid().ToString(); // Adding GUID for Audit Track
                            JGSession.UserLoginId = loginId;
                            JGSession.UserPassword = "";
                            string AdminInstallerId = ConfigurationManager.AppSettings["AdminUserId"].ToString();
                            if (loginId.Trim() == AdminInstallerId)
                            {
                                JGSession.AdminUserId = AdminInstallerId;
                            }

                            JGSession.UserType = "Installer";

                            autoLogin = true;
                            int userId = Convert.ToInt32(ds.Tables[0].Rows[0]["Id"].ToString());
                            bool isProfileUpdateRequired = CommonFunction.IsProfileUpdateRequired(ds.Tables[0].Rows[0]["LastProfileUpdated"].ToString());
                            string redirectionURL = GetCandidateRedirectionURL(userId, isProfileUpdateRequired);

                            // Append Parameters into URL
                            var uriBuilder = new UriBuilder(redirectionURL);
                            var query = HttpUtility.ParseQueryString(uriBuilder.Query);

                            foreach (string key in HttpContext.Current.Request.QueryString)
                            {
                                query[key] = HttpContext.Current.Request.QueryString[key];
                                //JGSession.ChatReplyQueryParameters.Add(key, HttpContext.Current.Request.QueryString[key]);
                            }
                            uriBuilder.Query = query.ToString();
                            redirectionURL = uriBuilder.ToString();

                            HttpContext.Current.Response.Redirect(redirectionURL);
                        }
                    }
                }
                #endregion
                if (!autoLogin)
                {
                    // redirect user to login page, only when session renewal is not requested.
                    string strRenewSessionKey = string.Empty;

                    if (HttpContext.Current.Request != null && HttpContext.Current.Request.Params.Count > 0)
                    {
                        strRenewSessionKey = HttpContext.Current.Request.Params.Cast<string>().FirstOrDefault(s => s.Contains("_hdnRenewSession"));
                    }

                    if (string.IsNullOrEmpty(strRenewSessionKey) || HttpContext.Current.Request.Params[strRenewSessionKey] == "0")
                    {
                        HttpContext.Current.Response.Redirect("~/stafflogin.aspx?returnurl=" + HttpContext.Current.Request.Url.PathAndQuery);
                    }
                }
            }
        }

        /// <summary>
        /// Used in task related controls to enable / disable features based on user type.
        /// Admin, Office manager, Sales Managers, Tech Leads, IT Enginners, Foremans are given Admin rights for task controls.
        /// </summary>
        /// <returns></returns>
        public static bool CheckAdminMode()
        {
            // Please refer InstallCreateProspect.ascx.cs control to find list of available designations for install user in BindDesignation method.

            bool returnVal = false;
            if (JGSession.Designation != null)
            {
                switch (JGSession.Designation.ToUpper())
                {
                    //To add/edit Tasks
                    case "IT - SR .NET DEVELOPER":
                    case "IT - SR. PHP DEVELOPER":

                    case "ADMIN": // admin
                    case "ADMIN-SALES":
                    case "ADMIN RECRUITER":
                    case "OFFICE MANAGER": // office manager
                    case "SALES MANAGER": // sales manager
                    case "ITLEAD": // it engineer | tech lead
                    case "FOREMAN": // foreman
                        returnVal = true;
                        break;
                    default: // other designations
                        returnVal = false;
                        break;
                }
            }
            //if (HttpContext.Current.Session["DesigNew"] != null && HttpContext.Current.Session["DesigNew"].ToString().Contains("Admin"))
            //{
            //    returnVal = true;
            //}

            return returnVal;
        }

        /// <summary>
        /// Used in task related controls to enable / disable features based on user type.
        /// Admin, Tech Leads are given different default values for task controls.
        /// </summary>
        /// <returns></returns>
        public static bool CheckAdminAndItLeadMode()
        {
            // Please refer InstallCreateProspect.ascx.cs control to find list of available designations for install user in BindDesignation method.

            bool returnVal = false;
            if (JGSession.Designation != null)
            {
                switch (JGSession.Designation.ToUpper())
                {
                    case "ADMIN": // admin
                    case "ADMIN-SALES":
                    case "ADMIN RECRUITER":
                    case "ITLEAD": // it engineer | tech lead
                        returnVal = true;
                        break;
                    default: // other designations
                        returnVal = false;
                        break;
                }
            }

            return returnVal;
        }

        /// <summary>
        /// Sends an email.
        /// </summary>
        /// <param name="strEmailTemplate"></param>
        /// <param name="strToAddress">it will receive email.</param>
        /// <param name="strSubject">subject line of email.</param>
        /// <param name="strBody">contect / body of email.</param>
        /// <param name="lstAttachments">any files to be attached to email.</param>
        public static long SendEmail(string EmailType, string strEmailTemplate, string strToAddress, string strSubject, string strBody,
            List<Attachment> lstAttachments, List<AlternateView> lstAlternateView = null,
            string[] CC = null, string[] BCC = null)
        {
            //Thread email = new Thread(delegate ()
            //{
            return SendEmailAsync(EmailType, strEmailTemplate, strToAddress, strSubject, strBody, lstAttachments, lstAlternateView, CC, BCC);
            //});
            //email.IsBackground = true;
            //email.Start();
            //return true;
        }

        private static long SendEmailAsync(string EmailType, string strEmailTemplate, string strToAddress, string strSubject, string strBody,
            List<Attachment> lstAttachments, List<AlternateView> lstAlternateView = null,
            string[] CC = null, string[] BCC = null)
        {
            bool retValue = false;
            if (!InstallUserBLL.Instance.CheckUnsubscribedEmail(strToAddress))
            {
                try
                {
                    #region Check for autologin url
                    if (strBody.Contains("{AutoLoginCode}"))
                    {
                        // Generate auto login code
                        string loginCode = InstallUserDAL.Instance.GenerateLoginCode(strToAddress).Object;
                        strBody = strBody.Replace("{AutoLoginCode}", loginCode);
                    }
                    #endregion
                    /* Sample HTML Template
                     * *****************************************************************************
                     * Hi #lblFName#,
                     * <br/>
                     * <br/>
                     * You are requested to appear for an interview on #lblDate# - #lblTime#.
                     * <br/>
                     * <br/>
                     * Regards,
                     * <br/>
                    */

                    string defaultEmailFrom = ConfigurationManager.AppSettings["defaultEmailFrom"].ToString();
                    string userName = ConfigurationManager.AppSettings["smtpUName"].ToString();
                    string password = ConfigurationManager.AppSettings["smtpPwd"].ToString();

                    if (JGApplicationInfo.GetApplicationEnvironment() == "1" || JGApplicationInfo.GetApplicationEnvironment() == "2")
                    {
                        strBody = String.Concat(strBody, "<br/><br/><h1>Email is intended for Email Address: " + strToAddress + "</h1><br/><br/>");
                        strToAddress = "error@kerconsultancy.com";

                    }

                    MailMessage Msg = new MailMessage();
                    Msg.From = new MailAddress(defaultEmailFrom, "JGrove Construction");
                    Msg.To.Add(strToAddress);
                    //Msg.Bcc.Add(JGApplicationInfo.GetDefaultBCCEmail());
                    Msg.Subject = strSubject;// "JG Prospect Notification";
                    Msg.Body = strBody.Replace("#UNSEMAIL#", strToAddress);
                    Msg.IsBodyHtml = true;

                    if (CC != null)
                        foreach (string email in CC)
                        {
                            Msg.CC.Add(email);
                        }
                    if (BCC != null)
                        foreach (string email in BCC)
                        {
                            Msg.Bcc.Add(email);
                        }

                    //ds = AdminBLL.Instance.GetEmailTemplate('');
                    //// your remote SMTP server IP.
                    if (lstAttachments != null)
                    {
                        foreach (Attachment objAttachment in lstAttachments)
                        {
                            Msg.Attachments.Add(objAttachment);
                        }
                    }

                    if (lstAlternateView != null)
                    {
                        foreach (AlternateView objAlternateView in lstAlternateView)
                        {
                            Msg.AlternateViews.Add(objAlternateView);
                        }
                    }

                    SmtpClient sc = new SmtpClient(
                                                    ConfigurationManager.AppSettings["smtpHost"].ToString(),
                                                    Convert.ToInt32(ConfigurationManager.AppSettings["smtpPort"].ToString())
                                                  );
                    NetworkCredential ntw = new NetworkCredential(userName, password);
                    sc.UseDefaultCredentials = false;
                    sc.Credentials = ntw;
                    sc.DeliveryMethod = SmtpDeliveryMethod.Network;
                    sc.EnableSsl = Convert.ToBoolean(ConfigurationManager.AppSettings["enableSSL"].ToString()); // runtime encrypt the SMTP communications using SSL

                    //sc.Send(Msg);
                    //sc.Send(Msg);
                    Common.ElasticEmailClient.ApiTypes.EmailSend data = Common.ElasticEmailClient.Api.Email.Send(subject: strSubject,
                                    from: ConfigurationManager.AppSettings["defaultEmailFrom"].ToString(),
                                    to: new List<string> { strToAddress }, bodyHtml: strBody, isTransactional: true, trackOpens: true, trackClicks: true);

                    /*
                     JG_Prospect.Common.ElasticEmailClient.ApiTypes.EmailStatus data =
                        JG_Prospect.Common.ElasticEmailClient.Api.Email.Status("0zkOx0X3qGqbp74sVO-nYg2");

                    JG_Prospect.Common.ElasticEmailClient.ApiTypes.EmailJobStatus ss =
                        JG_Prospect.Common.ElasticEmailClient.Api.Email.GetStatus("310e4832-13a6-81c5-c032-307a2ff9dc58", showFailed: true, showSent: true,
                                    showDelivered: true, showPending: true, showOpened: true, showClicked: true, showAbuse: true, showUnsubscribed: true,
                                    showErrors: true, showMessageIDs: true);  
                     */
                    // Get Status using MessageId And TransactionId & save into database
                    //Common.ElasticEmailClient.ApiTypes.EmailStatus EmailStatus =
                    //    Common.ElasticEmailClient.Api.Email.Status(data.MessageID);
                    //if (EmailStatus != null)
                    //{
                    //   EmailManager.SaveEmailStatus(EmailStatus, data.MessageID, EmailType);
                    //}
                    Common.ElasticEmailClient.ApiTypes.EmailStatus EmailStatus = new Common.ElasticEmailClient.ApiTypes.EmailStatus();
                    EmailStatus.Status = Common.ElasticEmailClient.ApiTypes.LogJobStatus.Sent;
                    EmailStatus.From = ConfigurationManager.AppSettings["defaultEmailFrom"].ToString();
                    EmailStatus.To = strToAddress;
                    EmailStatus.TransactionID = new Guid(data.TransactionID);
                    EmailStatus.ErrorMessage = data.MessageID;
                    EmailStatus.DateOpened = null;
                    EmailStatus.DateClicked = null;
                    EmailStatus.StatusName = Common.ElasticEmailClient.ApiTypes.LogJobStatus.Sent.ToString();
                    EmailStatus.StatusChangeDate = DateTime.UtcNow;
                    EmailStatus.ErrorMessage = null;

                    long emailStatusId = EmailManager.SaveEmailStatus(EmailStatus, data.MessageID, EmailType, strBody);

                    retValue = true;

                    Msg = null;
                    sc.Dispose();
                    sc = null;

                    return emailStatusId;
                }
                catch (Exception ex)
                {
                    CommonFunction.LogError(ex.ToString(), ex.Message);
                    return 0;
                    //if (JGApplicationInfo.IsSendEmailExceptionOn())
                    //{
                    //    CommonFunction.SendExceptionEmail(ex);
                    //}
                }
            }
            return 0;
        }

        /// <summary>
        /// Sends an internal email.
        /// </summary>
        /// <param name="strEmailTemplate"></param>
        /// <param name="strToAddress">it will receive email.</param>
        /// <param name="strSubject">subject line of email.</param>
        /// <param name="strBody">contect / body of email.</param>
        public static void SendEmailInternal(string EmailType, string strToAddress, string strSubject, string strBody, string[] CC = null, string[] BCC = null)
        {
            //Thread email = new Thread(delegate ()
            //{
            SendEmailInternalAsync(EmailType, strToAddress, strSubject, strBody, CC, BCC);
            //});
            //email.IsBackground = true;
            //email.Start();
        }

        private static void SendEmailInternalAsync(string EmailType, string strToAddress, string strSubject, string strBody,
             string[] CC = null, string[] BCC = null)
        {
            try
            {
                #region Check for autologin url
                if (strBody.Contains("{AutoLoginCode}"))
                {
                    // Generate auto login code
                    string loginCode = InstallUserDAL.Instance.GenerateLoginCode(strToAddress).Object;
                    strBody = strBody.Replace("{AutoLoginCode}", loginCode);
                }
                #endregion
                string userName = ConfigurationManager.AppSettings["VendorCategoryUserName"].ToString();
                string password = ConfigurationManager.AppSettings["VendorCategoryPassword"].ToString();

                MailMessage Msg = new MailMessage();
                Msg.From = new MailAddress(userName, "JGrove Construction");
                foreach (string strEmailAddress in strToAddress.Split(new char[] { ';' }, StringSplitOptions.RemoveEmptyEntries))
                {
                    Msg.To.Add(strEmailAddress);
                }

                Msg.Subject = strSubject;// "JG Prospect Notification";
                Msg.Body = strBody;
                Msg.IsBodyHtml = true;
                if (CC != null)
                    foreach (string email in CC)
                    {
                        Msg.CC.Add(email);
                    }
                if (BCC != null)
                    foreach (string email in BCC)
                    {
                        Msg.Bcc.Add(email);
                    }
                SmtpClient sc = new SmtpClient(
                                                ConfigurationManager.AppSettings["smtpHost"].ToString(),
                                                Convert.ToInt32(ConfigurationManager.AppSettings["smtpPort"].ToString())
                                              );
                NetworkCredential ntw = new NetworkCredential(userName, password);
                sc.UseDefaultCredentials = false;
                sc.Credentials = ntw;
                sc.DeliveryMethod = SmtpDeliveryMethod.Network;
                sc.EnableSsl = Convert.ToBoolean(ConfigurationManager.AppSettings["enableSSL"].ToString()); // runtime encrypt the SMTP communications using SSL
                try
                {
                    //sc.Send(Msg);
                    Common.ElasticEmailClient.ApiTypes.EmailSend data = Common.ElasticEmailClient.Api.Email.Send(subject: strSubject,
                                   from: ConfigurationManager.AppSettings["defaultEmailFrom"].ToString(),
                                   to: new List<string> { strToAddress }, bodyHtml: strBody, isTransactional: true, trackOpens: true, trackClicks: true);

                    /*
                     JG_Prospect.Common.ElasticEmailClient.ApiTypes.EmailStatus data =
                        JG_Prospect.Common.ElasticEmailClient.Api.Email.Status("0zkOx0X3qGqbp74sVO-nYg2");

                    JG_Prospect.Common.ElasticEmailClient.ApiTypes.EmailJobStatus ss =
                        JG_Prospect.Common.ElasticEmailClient.Api.Email.GetStatus("310e4832-13a6-81c5-c032-307a2ff9dc58", showFailed: true, showSent: true,
                                    showDelivered: true, showPending: true, showOpened: true, showClicked: true, showAbuse: true, showUnsubscribed: true,
                                    showErrors: true, showMessageIDs: true);  
                     */
                    // Get Status using MessageId And TransactionId & save into database
                    //Common.ElasticEmailClient.ApiTypes.EmailStatus EmailStatus =
                    //    Common.ElasticEmailClient.Api.Email.Status(data.MessageID);
                    //if (EmailStatus != null)
                    //{
                    //    EmailManager.SaveEmailStatus(EmailStatus, data.MessageID, EmailType);
                    //}
                    Common.ElasticEmailClient.ApiTypes.EmailStatus EmailStatus = new Common.ElasticEmailClient.ApiTypes.EmailStatus();
                    EmailStatus.Status = Common.ElasticEmailClient.ApiTypes.LogJobStatus.Sent;
                    EmailStatus.From = ConfigurationManager.AppSettings["defaultEmailFrom"].ToString();
                    EmailStatus.To = strToAddress;
                    EmailStatus.TransactionID = new Guid(data.TransactionID);
                    EmailStatus.ErrorMessage = data.MessageID;
                    EmailStatus.DateOpened = null;
                    EmailStatus.DateClicked = null;
                    EmailStatus.StatusName = Common.ElasticEmailClient.ApiTypes.LogJobStatus.Sent.ToString();
                    EmailStatus.StatusChangeDate = DateTime.UtcNow;
                    EmailStatus.ErrorMessage = null;

                    EmailManager.SaveEmailStatus(EmailStatus, data.MessageID, EmailType, strBody);
                }
                catch
                {
                    // do not add throw clause here.
                    // it will lead to infinite loop.
                    // because application error event calls this method to send error details.
                    // here, we need to supress the exception.
                }

                Msg = null;
                sc.Dispose();
                sc = null;
            }
            catch
            {
                // do not add throw clause here.
                // it will lead to infinite loop.
                // because application error event calls this method to send error details.
                // here, we need to supress the exception.
            }
        }

        /// <summary>
        /// Gets contract tamplate content string by combining header, body and footer.
        /// </summary>
        /// <returns></returns>
        public static string GetContractTemplateContent(int intContractTemplateId, int intDesignationId = 0, String designation = "IT - Sr .Net Developer")
        {
            DataSet ds1 = AdminBLL.Instance.FetchContractTemplate(intContractTemplateId, intDesignationId);
            string strHtml = string.Empty;
            if (ds1 != null)
            {
                var datatable = from myRow in ds1.Tables[1].AsEnumerable()
                                where myRow.Field<string>("Designation").Trim().Equals(designation.Trim()) == true
                                select myRow;

                DataTable htmlData = (from myRow in ds1.Tables[1].AsEnumerable()
                                      where myRow.Field<string>("Designation").Trim().Equals(designation.Trim()) == true
                                      select myRow).CopyToDataTable();

                if (htmlData.Rows.Count > 0)
                {
                    strHtml = string.Concat(
                                                   htmlData.Rows[0]["HTMLHeader"].ToString(),
                                                   htmlData.Rows[0]["HTMLBody"].ToString(),
                                                   htmlData.Rows[0]["HTMLBody2"].ToString(),
                                                   htmlData.Rows[0]["HTMLFooter"].ToString()
                                                  );
                }
                else
                {
                    strHtml = string.Concat(
                                                   ds1.Tables[1].Rows[0]["HTMLHeader"].ToString(),
                                                   ds1.Tables[1].Rows[0]["HTMLBody"].ToString(),
                                                   ds1.Tables[1].Rows[0]["HTMLBody2"].ToString(),
                                                   ds1.Tables[1].Rows[0]["HTMLFooter"].ToString()
                                                  );
                }
                // this creates a warpper to limit width of all the sections.
                strHtml = "<table width='100%' cellpadding='0' cellspacing='0' border='0'><tr><td>" + strHtml + "</td></tr></table>";
            }
            return strHtml;
        }

        /// <summary>
        /// Converts html to pdf file and retunrs pdf file path.
        /// </summary>
        /// <param name="strHtml">Html content to include in pdf.</param>
        /// <param name="strRootPath">Folder path to store generated pdf.</param>
        /// <returns>Path to the generated pdf file.</returns>
        public static string ConvertHtmlToPdf(string strHtml, string strRootPath, string strFileName)
        {
            iTextSharp.text.Document objDocument = new iTextSharp.text.Document();
            string strFilePath = Path.Combine(strRootPath, string.Format("{0} {1}.pdf", strFileName, DateTime.Now.ToString("dd-MM-yyyy hh-mm-ss-tt")));

            try
            {
                iTextSharp.text.pdf.PdfWriter objPdfWriter = iTextSharp.text.pdf.PdfWriter.GetInstance
                        (
                            objDocument,
                            new FileStream(strFilePath, FileMode.Create)
                        );

                objDocument.Open();

                iTextSharp.tool.xml.XMLWorkerHelper.GetInstance().ParseXHtml
                        (
                            objPdfWriter,
                            objDocument,
                            new StringReader(strHtml)
                        );

                objDocument.Close();
            }
            catch
            { }
            finally
            {
                if (objDocument != null)
                {
                    objDocument.Close();
                }
                objDocument = null;
            }

            return strFilePath;
        }

        /// <summary>
        /// Converts html to pdf file stream and retunrs bytes.
        /// </summary>
        /// <param name="strHtml">Html content to include in pdf.</param>
        /// <returns>Bytes to generate pdf file.</returns>
        public static byte[] ConvertHtmlToPdf(string strHtml)
        {
            iTextSharp.text.Document objDocument = new iTextSharp.text.Document();

            try
            {
                MemoryStream objMemoryStream = new MemoryStream();
                iTextSharp.text.pdf.PdfWriter objPdfWriter = iTextSharp.text.pdf.PdfWriter.GetInstance
                        (
                            objDocument,
                            objMemoryStream
                        );

                objDocument.Open();

                iTextSharp.tool.xml.XMLWorkerHelper.GetInstance().ParseXHtml
                        (
                            objPdfWriter,
                            objDocument,
                            new StringReader(strHtml)
                        );

                objDocument.Close();

                return objMemoryStream.ToArray();
            }
            catch
            { }
            finally
            {
                if (objDocument != null)
                {
                    objDocument.Close();
                }
                objDocument = null;
            }
            return null;
        }

        /// <summary>
        /// Generate subtask auto suggest sequence.
        /// </summary>
        /// <param name="sequence"></param>
        /// <returns></returns>
        public static string[] getSubtaskSequencing(string sequence)
        {
            String[] ReturnSequence = new String[2];

            String[] numbercomponents = sequence.Split(new char[] { '-' }, StringSplitOptions.RemoveEmptyEntries);

            //if no subtask sequence than start with roman number I.
            if (String.IsNullOrEmpty(sequence))
            {
                int startSequence = 1;
                ReturnSequence[0] = ExtensionMethods.ToRoman(startSequence);
                ReturnSequence[1] = string.Empty;
            }
            else if (numbercomponents.Length == 1) // like number of subtask without alphabet I,II
            {
                int numbersequence;
                numbercomponents[0] = numbercomponents[0].Trim();
                bool parsed = ExtensionMethods.TryRomanParse(numbercomponents[0], out numbersequence);
                if (parsed)
                {
                    numbersequence++;

                    ReturnSequence[0] = ExtensionMethods.ToRoman(numbersequence); // increment integer and convert to roman number again.
                    ReturnSequence[1] = String.Concat(numbercomponents[0], " - a"); // concat existing roman number with alphabet.
                }
            }
            else  // if task sequence contains alphabet.
            {
                int numbersequence;
                numbercomponents[0] = numbercomponents[0].Trim();
                numbercomponents[1] = numbercomponents[1].Trim();


                char[] alphabetsequence = numbercomponents[1].ToCharArray();// get aplphabet from sequence

                bool parsed = ExtensionMethods.TryRomanParse(numbercomponents[0], out numbersequence); // parse roman to integer

                if (parsed)
                {
                    numbersequence++; // increase integer sequence

                    ReturnSequence[0] = ExtensionMethods.ToRoman(numbersequence); // convert integer sequnce to roman
                    ReturnSequence[1] = string.Concat(numbercomponents[0], " - ", ++alphabetsequence[0]); // advance alphabet to next alphabet.
                }
            }

            return ReturnSequence;
        }

        /// <summary>
        /// Enumeration description assiciated with it.
        /// </summary>
        /// <param name="value"></param>
        /// <returns></returns>
        public static string GetEnumDescription(Enum value)
        {
            FieldInfo fi = value.GetType().GetField(value.ToString());

            DescriptionAttribute[] attributes =
                (DescriptionAttribute[])fi.GetCustomAttributes(
                typeof(DescriptionAttribute),
                false);

            if (attributes != null &&
                attributes.Length > 0)
                return attributes[0].Description;
            else
                return value.ToString();
        }

        /// <summary>
        /// Gets next sequence value based on current value.
        /// </summary>
        /// <param name="strStartAt">First value of sequence. i.e. A, 1, I.</param>
        /// <param name="strCurrentSequence">current sequence number. i.e. C, 5, III.</param>
        /// <param name="blIsRoman">I can be an alphabet as well as a romal number. This flag is used to differenciate both.</param>
        /// <returns>
        /// input  : ouput
        ///    ''  :     A
        ///     1  :     2 
        ///     A  :     B 
        ///     Z  :    AA 
        ///    A1  :    A2
        ///    Z1  :    Z2
        ///    A9  :   AA0
        ///    Z9  :   AZ0
        ///    A-  :   A-0
        ///    Z-  :   Z-0
        /// </returns>
        public static string GetNextSequenceValue(string strStartAt, string strCurrentSequence = "", bool blIsRoman = false)
        {
            string strReturnValue = strStartAt.ToString();

            if (!string.IsNullOrEmpty(strCurrentSequence))
            {
                string strPrefix = string.Empty;

                char chInputPostfix = strCurrentSequence[strCurrentSequence.Length - 1];
                string strPostfix = chInputPostfix.ToString();
                if (strCurrentSequence.Length > 1)
                {
                    strPrefix = strCurrentSequence.Substring(0, strCurrentSequence.Length - 1);
                }

                int intaCode = (int)'a';
                int intzCode = (int)'z';
                int intACode = (int)'A';
                int intZCode = (int)'Z';
                int intInputCode = (int)chInputPostfix;

                int intNumber;

                if (blIsRoman && ExtensionMethods.TryRomanParse(strCurrentSequence, out intNumber))
                {
                    return ExtensionMethods.ToRoman((++intNumber));
                }
                else if (Char.IsDigit(chInputPostfix))
                {
                    intNumber = (int)Char.GetNumericValue(chInputPostfix);

                    if (intNumber == 9)
                    {
                        strPrefix = "A" + strPrefix;
                        //chInputPostfix = chStartAt;
                        strPostfix = strStartAt;
                    }
                    else
                    {
                        //chInputPostfix = (++intNumber).ToString()[0];
                        strPostfix = (++intNumber).ToString();
                    }
                }
                else if (
                            (intInputCode >= intaCode && intInputCode <= intzCode) ||
                            (intInputCode >= intACode && intInputCode <= intZCode)
                        )
                {
                    if (intInputCode == intzCode || intInputCode == intZCode)
                    {
                        strPrefix = "A" + strPrefix;
                        //chInputPostfix = chStartAt;
                        strPostfix = strStartAt;
                    }
                    else
                    {
                        //chInputPostfix = (char)(++intInputCode);
                        strPostfix = ((char)(++intInputCode)).ToString();
                    }
                }
                else
                {
                    strPrefix = strPrefix + chInputPostfix;
                    //chInputPostfix = chStartAt;
                    strPostfix = strStartAt;
                }

                //strReturnValue = strPrefix + chInputPostfix;
                strReturnValue = strPrefix + strPostfix;
            }

            return strReturnValue;
        }

        public static string GetDesignationCode(JGConstant.DesignationType objDesignationType)
        {
            string strCode = string.Empty;

            switch (objDesignationType)
            {
                case JGConstant.DesignationType.Admin:
                    strCode = "ADM";
                    break;
                case JGConstant.DesignationType.Jr_Sales:
                    strCode = "JSL";
                    break;
                case JGConstant.DesignationType.Jr_Project_Manager:
                    strCode = "JPM";
                    break;
                case JGConstant.DesignationType.Office_Manager:
                    strCode = "OFM";
                    break;
                case JGConstant.DesignationType.Recruiter:
                    strCode = "REC";
                    break;
                case JGConstant.DesignationType.Sales_Manager:
                    strCode = "SLM";
                    break;
                case JGConstant.DesignationType.Sr_Sales:
                    strCode = "SSL";
                    break;
                case JGConstant.DesignationType.IT_Network_Admin:
                    strCode = "ITNA";
                    break;
                case JGConstant.DesignationType.IT_Jr_Net_Developer:
                    strCode = "ITJN";
                    break;
                case JGConstant.DesignationType.IT_Sr_Net_Developer:
                    strCode = "ITSN";
                    break;
                case JGConstant.DesignationType.IT_Android_Developer:
                    strCode = "ITAD";
                    break;
                case JGConstant.DesignationType.IT_PHP_Developer:
                    strCode = "ITPH";
                    break;
                case JGConstant.DesignationType.IT_Jr_PHP_Developer:
                    strCode = "ITJP";
                    break;
                case JGConstant.DesignationType.IT_SEO_OR_BackLinking:
                    strCode = "ITSB";
                    break;
                case JGConstant.DesignationType.Installer_Helper:
                    strCode = "INH";
                    break;
                case JGConstant.DesignationType.Installer_Journeyman:
                    strCode = "INJ";
                    break;
                case JGConstant.DesignationType.Installer_Mechanic:
                    strCode = "INM";
                    break;
                case JGConstant.DesignationType.Installer_Lead_Mechanic:
                    strCode = "INLM";
                    break;
                case JGConstant.DesignationType.Installer_Foreman:
                    strCode = "INF";
                    break;
                case JGConstant.DesignationType.Commercial_Only:
                    strCode = "COM";
                    break;
                case JGConstant.DesignationType.SubContractor:
                    strCode = "SBC";
                    break;
                case JGConstant.DesignationType.IT_Lead:
                    strCode = "ITL";
                    break;
                case JGConstant.DesignationType.Admin_Sales:
                    strCode = "ASL";
                    break;
                case JGConstant.DesignationType.Admin_Recruiter:
                    strCode = "AREC";
                    break;
                default:
                    strCode = "OUID";
                    break;
            }

            return strCode;
        }

        public static System.Web.UI.WebControls.ListItemCollection GetTaskStatusList()
        {
            ListItemCollection objListItemCollection = new ListItemCollection();

            //----------- Start DP -----------------
            //objListItemCollection.Add(new ListItem("Open", Convert.ToByte(JGConstant.TaskStatus.Open).ToString()));
            //objListItemCollection.Add(new ListItem("Requested", Convert.ToByte(JGConstant.TaskStatus.Requested).ToString()));
            //objListItemCollection.Add(new ListItem("Assigned", Convert.ToByte(JGConstant.TaskStatus.Assigned).ToString()));
            //objListItemCollection.Add(new ListItem("In Progress", Convert.ToByte(JGConstant.TaskStatus.InProgress).ToString()));
            //objListItemCollection.Add(new ListItem("Pending", Convert.ToByte(JGConstant.TaskStatus.Pending).ToString()));
            //objListItemCollection.Add(new ListItem("Re-Opened", Convert.ToByte(JGConstant.TaskStatus.ReOpened).ToString()));
            //objListItemCollection.Add(new ListItem("Finished", Convert.ToByte(JGConstant.TaskStatus.Finished).ToString()));
            //objListItemCollection.Add(new ListItem("Closed", Convert.ToByte(JGConstant.TaskStatus.Closed).ToString()));
            //objListItemCollection.Add(new ListItem("Specs In Progress", Convert.ToByte(JGConstant.TaskStatus.SpecsInProgress).ToString()));
            //objListItemCollection.Add(new ListItem("Test", Convert.ToByte(JGConstant.TaskStatus.Test).ToString()));
            //objListItemCollection.Add(new ListItem("Live", Convert.ToByte(JGConstant.TaskStatus.Live).ToString()));

            int enumlen = Enum.GetNames(typeof(JGConstant.TaskStatus)).Length;

            foreach (var item in Enum.GetNames(typeof(JGConstant.TaskStatus)))
            {
                int enumval = (int)Enum.Parse(typeof(JGConstant.TaskStatus), item);
                if (item != "Deleted")
                {
                    objListItemCollection.Add(new ListItem(item, enumval.ToString()));
                }
            }
            //----------- End DP -----------------

            if (CheckAdminAndItLeadMode())
            {
                objListItemCollection.Add(new ListItem("Deleted", Convert.ToByte(JGConstant.TaskStatus.Deleted).ToString()));
            }

            return objListItemCollection;
        }

        public static System.Web.UI.WebControls.ListItemCollection GetTaskTypeList()
        {
            ListItemCollection objListItemCollection = new ListItemCollection();

            objListItemCollection.Add(new ListItem("--None--", "0"));
            objListItemCollection.Add(new ListItem("Bug", Convert.ToInt16(JGConstant.TaskType.Bug).ToString()));
            objListItemCollection.Add(new ListItem("BetaError", Convert.ToInt16(JGConstant.TaskType.BetaError).ToString()));
            objListItemCollection.Add(new ListItem("Enhancement", Convert.ToInt16(JGConstant.TaskType.Enhancement).ToString()));

            //objListItemCollection[1].Enabled = false;
            return objListItemCollection;
        }

        public static string ReplaceEncodeWhiteSpace(string urlstring)
        {
            return urlstring.Replace("+", "%20");
        }

        public static System.Web.UI.WebControls.ListItemCollection GetTaskPriorityList()
        {
            ListItemCollection objListItemCollection = new ListItemCollection();

            objListItemCollection.Add(new ListItem("--None--", "0"));
            objListItemCollection.Add(new ListItem("Critical", Convert.ToInt16(JGConstant.TaskPriority.Critical).ToString()));
            objListItemCollection.Add(new ListItem("High", Convert.ToInt16(JGConstant.TaskPriority.High).ToString()));
            objListItemCollection.Add(new ListItem("Medium", Convert.ToInt16(JGConstant.TaskPriority.Medium).ToString()));
            objListItemCollection.Add(new ListItem("Low", Convert.ToInt16(JGConstant.TaskPriority.Low).ToString()));

            return objListItemCollection;
        }

        public static System.Web.UI.WebControls.ListItemCollection GetHTMLTemplateCategoryList()
        {
            ListItemCollection objListItemCollection = new ListItemCollection();

            objListItemCollection.Add(new ListItem("HR Auto Email", Convert.ToInt16(HTMLTemplateCategories.HRAutoEmail).ToString()));
            objListItemCollection.Add(new ListItem("Vendor Auto Email", Convert.ToInt16(HTMLTemplateCategories.VendorAutoEmail).ToString()));
            objListItemCollection.Add(new ListItem("Sales Auto Email", Convert.ToInt16(HTMLTemplateCategories.SalesAutoEmail).ToString()));

            return objListItemCollection;
        }

        public static string GetTaskRowCssClass(JGConstant.TaskStatus objTaskStatus, JGConstant.TaskPriority? objTaskPriority)
        {
            string strRowCssClass = string.Empty;

            switch (objTaskStatus)
            {
                case JGConstant.TaskStatus.Open:
                    strRowCssClass += " task-open";
                    if (objTaskPriority.HasValue)
                    {
                        strRowCssClass += " task-with-priority";
                    }
                    break;
                case JGConstant.TaskStatus.Requested:
                    strRowCssClass += " task-requested";
                    break;
                case JGConstant.TaskStatus.Assigned:
                    strRowCssClass += " task-assigned";
                    break;
                case JGConstant.TaskStatus.InProgress:
                    strRowCssClass += " task-inprogress";
                    break;
                case JGConstant.TaskStatus.Pending:
                    strRowCssClass += " task-pending";
                    break;
                case JGConstant.TaskStatus.ReOpened:
                    strRowCssClass += " task-reopened";
                    break;
                case JGConstant.TaskStatus.Closed:
                    strRowCssClass += " task-closed closed-task-bg";
                    break;
                case JGConstant.TaskStatus.Finished:
                    strRowCssClass += " task-finished finished-task-bg";
                    break;
                case JGConstant.TaskStatus.SpecsInProgress:
                    strRowCssClass += " task-specsinprogress";
                    break;
                case JGConstant.TaskStatus.Deleted:
                    strRowCssClass += " task-deleted deleted-task-bg";
                    break;
                default:
                    break;
            }

            return strRowCssClass;
        }

        public static bool IsImageFile(string fileName)
        {
            bool isImageFile = false;
            string fileExtension = Path.GetExtension(fileName).ToLower();

            if (fileExtension.Contains(".jpg") || fileExtension.Contains(".jpeg") || fileExtension.Contains(".bmp") || fileExtension.Contains(".gif") || fileExtension.Contains(".png"))
            {
                isImageFile = true;
            }
            return isImageFile;
        }

        public static string GetFileTypeIcon(string FileName, Page objPage)
        {
            string fileExtension = Path.GetExtension(FileName).ToLower();

            string iconFile = string.Empty;

            switch (fileExtension)
            {
                case ".zip":
                case ".rar":
                    iconFile = "~/img/zip-icon.png";
                    break;
                case ".mp3":
                case ".wav":
                case ".m4a":
                    iconFile = "~/img/audio-icon.png";
                    break;
                case ".wmv":
                case ".avi":
                case ".mov":
                case ".mpg":
                case ".mp4":
                    iconFile = "~/img/video-icon.png";
                    break;
                case ".pdf":
                    iconFile = "~/img/pdf-icon.png";
                    break;
                case ".xlsx":
                case ".xls":
                    iconFile = "~/img/excel-icon.png";
                    break;
                case ".txt":
                case ".rtf":
                case ".docx":
                case ".doc":
                    iconFile = "~/img/word-icon.png";
                    break;
                case ".png":
                case ".jpg":
                case ".jpeg":
                case ".bmp":
                case ".gif":
                default:
                    break;
            }
            return objPage.ResolveUrl(iconFile);
        }

        public static Enums.ResourceType GetFileType(string FileName)
        {
            string fileExtension = Path.GetExtension(FileName).ToLower();

            Enums.ResourceType resourceType;

            switch (fileExtension)
            {
                case ".zip":
                case ".rar":
                    resourceType = Enums.ResourceType.CompreesedFolder;
                    break;
                case ".mp3":
                case ".wav":
                case ".m4a":
                    resourceType = Enums.ResourceType.Audio;
                    break;
                case ".wmv":
                case ".avi":
                case ".mov":
                case ".mpg":
                case ".mp4":
                    resourceType = Enums.ResourceType.Video;
                    break;
                case ".pdf":
                    resourceType = Enums.ResourceType.PDF;
                    break;
                case ".xlsx":
                case ".xls":
                    resourceType = Enums.ResourceType.Excel;
                    break;
                case ".pptx":
                case ".ppt":
                    resourceType = Enums.ResourceType.Presentation;
                    break;
                case ".txt":
                case ".rtf":
                case ".docx":
                case ".doc":
                    resourceType = Enums.ResourceType.Word;
                    break;
                case ".png":
                case ".jpg":
                case ".jpeg":
                case ".bmp":
                case ".gif":
                    resourceType = Enums.ResourceType.Image;
                    break;
                default:
                    resourceType = Enums.ResourceType.Other;
                    break;
            }
            return resourceType;
        }

        public static string CreatePassword(int length)
        {
            const string valid = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ1234567890";
            StringBuilder res = new StringBuilder();
            Random rnd = new Random();
            while (0 < length--)
            {
                res.Append(valid[rnd.Next(valid.Length)]);
            }
            return res.ToString();
        }

        internal static void BindAssignUserDropdown(string strTaskDesignations, ListBox lstbUsersMaster)
        {
            DataSet dsUsers = TaskGeneratorBLL.Instance.GetInstallUsers(2, strTaskDesignations.Trim());

            if (dsUsers != null && dsUsers.Tables.Count > 0 && dsUsers.Tables[0].Rows.Count > 0)
            {
                DataTable dtUsers = dsUsers.Tables[0];

                lstbUsersMaster.Items.Clear();
                lstbUsersMaster.DataSource = dsUsers;
                lstbUsersMaster.DataTextField = "FristName";
                lstbUsersMaster.DataValueField = "Id";
                lstbUsersMaster.DataBind();

            }
        }

        internal static string GetStandardDateTimeString(DateTime interviewDate)
        {
            return interviewDate.ToString("MM/dd/yyyy h:mm tt", CultureInfo.InvariantCulture);
        }

        internal static string GetStandardDateString(DateTime interviewDate)
        {
            return interviewDate.ToString("MM/dd/yyyy", CultureInfo.InvariantCulture);
        }

        internal static string GetStandardTimeString(DateTime interviewDate)
        {
            return interviewDate.ToString("h:mm tt", CultureInfo.InvariantCulture);
        }

        internal static void ApplyColorCodeToAssignUserDropdown(DataTable dataSource, ListBox lstAssignUser)
        {
            // For all active user set font in red and for all InterviewDate and OfferMade set blue.
            foreach (ListItem item in lstAssignUser.Items)
            {
                DataRow row = (from DataRow dr in dataSource.Rows
                               where dr["Id"].ToString().Equals(item.Value) == true
                               select dr).FirstOrDefault();

                if (row != null)
                {
                    JGConstant.InstallUserStatus Userstatus;
                    Enum.TryParse(Convert.ToString(row["Status"]), out Userstatus);

                    switch (Userstatus)
                    {
                        case JGConstant.InstallUserStatus.Active:
                        case JGConstant.InstallUserStatus.OfferMade:
                            item.Attributes.Add("class", "activeUser");
                            break;
                        case JGConstant.InstallUserStatus.InterviewDate:
                            item.Attributes.Add("class", "IOUser");
                            break;
                        default:
                            break;
                    }

                }
            }
        }

        internal static DataTable ApplyColorCodeToAssignUserDataTable(DataTable dataSource)
        {

            DataColumn dcColorClass = new DataColumn("CssClass", System.Type.GetType("System.String"));

            dataSource.Columns.Add(dcColorClass);
            dataSource.AcceptChanges();

            // For all active user set font in red and for all InterviewDate and OfferMade set blue.
            foreach (DataRow row in dataSource.Rows)
            {

                JGConstant.InstallUserStatus Userstatus;
                Enum.TryParse(Convert.ToString(row["Status"]), out Userstatus);

                switch (Userstatus)
                {
                    case JGConstant.InstallUserStatus.Active:
                        row["CssClass"] = "activeUser";
                        break;
                    case JGConstant.InstallUserStatus.OfferMade:
                    case JGConstant.InstallUserStatus.InterviewDate:
                        row["CssClass"] = "IOUser";
                        break;
                    default:
                        break;
                }

            }

            return dataSource;
        }

        internal static int GetNextWeekdayDifference(DateTime start, DayOfWeek day)
        {
            // The (... + 7) % 7 ensures we end up with a value in the range [0, 6]
            int daysToAdd = ((int)day - (int)start.DayOfWeek + 7) % 7;
            return daysToAdd;
        }

        internal static void BulkEmail(string EmailType, HTMLTemplates objHTMLTemplateType, Int32 DesignationId)
        {
            DesignationHTMLTemplate objHTMLTemplate = HTMLTemplateBLL.Instance.GetDesignationHTMLTemplate(objHTMLTemplateType, DesignationId.ToString());

            // Get all install users with statuses, Applicant, Refferal Applcant, InterviewDate
            DataSet dsUser = InstallUserBLL.Instance.GetInstallUsersForBulkEmail(DesignationId);

            if (dsUser != null && dsUser.Tables.Count > 0)
            {
                foreach (DataRow installUser in dsUser.Tables[0].Rows)
                {
                    // Send email to each user.
                    string emailId = String.Empty;
                    string strBody = String.Empty;

                    if (JGApplicationInfo.GetApplicationEnvironment() == "1")
                    {
                        emailId = "error@kerconsultancy.com";
                        strBody = "<h1>Email is intended for Email Address: " + installUser["Email"].ToString() + "</h1><br/><br/>";
                    }
                    else
                    {
                        emailId = installUser["Email"].ToString();
                    }

                    string FName = installUser["FristName"].ToString();
                    string LName = installUser["LastName"].ToString();
                    string Designation = installUser["Designation"].ToString();
                    string fullname = FName + " " + LName;

                    string userName = ConfigurationManager.AppSettings["VendorCategoryUserName"].ToString();
                    string password = ConfigurationManager.AppSettings["VendorCategoryPassword"].ToString();


                    string strHeader = objHTMLTemplate.Header;
                    strBody = String.Concat(strBody, objHTMLTemplate.Body);
                    string strFooter = objHTMLTemplate.Footer;
                    string strsubject = objHTMLTemplate.Subject;

                    strBody = strBody.Replace("#name#", fullname).Replace("#Email#", installUser["Email"].ToString()).Replace("#Phone number#", installUser["Phone"].ToString());

                    strFooter = strFooter.Replace("#Designation#", Designation);

                    strBody = strHeader + strBody + strFooter;

                    List<Attachment> lstAttachments = objHTMLTemplate.Attachments;


                    //if (Attachments != null)
                    //{
                    //    lstAttachments.AddRange(Attachments);
                    //}

                    try
                    {
                        SendEmail(EmailType, Designation, emailId, strsubject, strBody, lstAttachments);

                        CommonFunction.UpdateEmailStatistics(emailId);
                    }
                    catch (Exception ex)
                    {
                        CommonFunction.LogError(ex.ToString(), ex.Message);
                    }
                }
            }

        }

        private static void LogError(string error, string msg)
        {
            ErrorLogBLL.Instance.SaveApplicationError("Error", msg, error, "");
            //try
            //{
            //    locker.AcquireWriterLock(int.MaxValue);

            //    string logDirectoryPath = HostingEnvironment.MapPath(@"~\EmailStatistics");
            //    if (!Directory.Exists(logDirectoryPath))
            //    {
            //        Directory.CreateDirectory(logDirectoryPath);
            //    }
            //    string path = String.Concat(logDirectoryPath, "\\errors.txt");
            //    if (!File.Exists(path))
            //    {
            //        using (TextWriter tw = File.CreateText(path))
            //        {
            //            tw.WriteLine(error + "  - " + DateTime.Now);
            //            tw.Close();
            //        }
            //    }
            //    else if (File.Exists(path))
            //    {
            //        using (var tw = new StreamWriter(path, true))
            //        {
            //            tw.WriteLine(error + "  - " + DateTime.Now);
            //            tw.Close();
            //        }
            //    }
            //}
            //catch (Exception exp) { }
            //finally
            //{
            //    lockerErrors.ReleaseWriterLock();
            //}
        }

        internal static bool IsProfileUpdateRequired(string LastProfileUpdateDateTime)
        {
            bool ProfileUpdateRequired = true;

            if (!String.IsNullOrEmpty(LastProfileUpdateDateTime))
            {
                ProfileUpdateRequired = false;
            }
            return ProfileUpdateRequired;
        }

        private static void UpdateEmailStatistics(string emailId)
        {
            try
            {
                locker.AcquireWriterLock(int.MaxValue);

                string logDirectoryPath = HostingEnvironment.MapPath(@"~\EmailStatistics");
                if (!Directory.Exists(logDirectoryPath))
                {
                    Directory.CreateDirectory(logDirectoryPath);
                }
                string path = String.Concat(logDirectoryPath, "\\statistics.txt");
                if (!File.Exists(path))
                {
                    using (TextWriter tw = File.CreateText(path))
                    {
                        tw.WriteLine(emailId + "  - " + DateTime.Now);
                        tw.Close();
                    }
                }
                else if (File.Exists(path))
                {
                    using (var tw = new StreamWriter(path, true))
                    {
                        tw.WriteLine(emailId + "  - " + DateTime.Now);
                        tw.Close();
                    }
                }
            }
            finally
            {
                locker.ReleaseWriterLock();
            }
        }

        public static void UpdateLog(string LogText)
        {
            try
            {
                lockerEmailLogs.AcquireWriterLock(int.MaxValue);

                string logDirectoryPath = HostingEnvironment.MapPath(@"~\Log");
                if (!Directory.Exists(logDirectoryPath))
                {
                    Directory.CreateDirectory(logDirectoryPath);
                }
                string path = String.Concat(logDirectoryPath, "\\Log.txt");
                if (!File.Exists(path))
                {
                    using (TextWriter tw = File.CreateText(path))
                    {
                        tw.WriteLine(LogText + "  - " + DateTime.Now);
                        tw.Close();
                    }
                }
                else if (File.Exists(path))
                {
                    using (var tw = new StreamWriter(path, true))
                    {
                        tw.WriteLine(LogText + "  - " + DateTime.Now);
                        tw.Close();
                    }
                }
            }
            finally
            {
                lockerEmailLogs.ReleaseWriterLock();
            }
        }

        internal static DataSet GetDesignations()
        {
            DataSet dsDesignation = new DataSet();
            dsDesignation = DesignationBLL.Instance.GetAllDesignationsForHumanResource();
            return dsDesignation;
        }

        internal static void SendExceptionEmail(Exception Error)
        {
            // Code that runs when an unhandled error occurs
            if (!string.IsNullOrEmpty(System.Configuration.ConfigurationManager.AppSettings["ErrorNotificationEmailId"]))
            {
                Exception objException = Error;

                if (objException != null)
                {
                    string strSubject, strBody;

                    // inner exception is the actual exception. 
                    // so, if inner exception is available, send it in email.
                    if (objException.InnerException != null)
                    {
                        strSubject = "Exception - " + objException.InnerException.Message;

                        strBody = GetExceptionHtml(objException.InnerException);
                    }
                    // send base exception details, when inner exception is not available.
                    else
                    {
                        strSubject = "Exception - " + objException.Message;

                        strBody = GetExceptionHtml(objException);
                    }

                    if (!string.IsNullOrEmpty(System.Configuration.ConfigurationManager.AppSettings["ApplicationEnvironment"]))
                    {
                        switch ((JG_Prospect.Common.JGConstant.ApplicationEnvironment)Convert.ToByte(System.Configuration.ConfigurationManager.AppSettings["ApplicationEnvironment"]))
                        {
                            case JG_Prospect.Common.JGConstant.ApplicationEnvironment.Local:
                                strSubject = "Local " + strSubject;
                                break;
                            case JG_Prospect.Common.JGConstant.ApplicationEnvironment.Staging:
                                strSubject = "Staging " + strSubject;
                                break;
                            case JG_Prospect.Common.JGConstant.ApplicationEnvironment.Live:
                                strSubject = "Live " + strSubject;
                                break;
                        }
                    }


                    if (HttpContext.Current.Request != null && HttpContext.Current.Request.Url != null && !string.IsNullOrEmpty(HttpContext.Current.Request.Url.ToString()))
                    {
                        strBody = "<p style='padding:5px;margin:5px;'>" + HttpContext.Current.Request.Url.ToString() + "</p>" + strBody;
                    }

                    // append all contents to a main table 
                    // to center align the contents and 
                    // to keep all the contents in one parent table.
                    strBody = "<table width='100%'><tr><td align='center' valign='top'>" + strBody + "</td></tr></table>";

                    SendEmailInternal(JGConstant.EmailTypes.Error.ToString(),
                                    System.Configuration.ConfigurationManager.AppSettings["ErrorNotificationEmailId"],
                                    strSubject,
                                    strBody
                                    );
                }
            }
        }

        internal static string GetInstallIDPrefixFromDesignationID(string DesignID)
        {
            string prefix = "";
            switch (DesignID)
            {
                case "1":
                    prefix = "ADM";
                    break;
                case "2":
                    prefix = "JSL";
                    break;
                case "3":
                    prefix = "JPM";
                    break;
                case "4":
                    prefix = "OFM";
                    break;
                case "5":
                    prefix = "REC";
                    break;
                case "6":
                    prefix = "SLM";
                    break;
                case "7":
                    prefix = "SSL";
                    break;
                case "8":
                    prefix = "ITNA";
                    break;
                case "9":
                    prefix = "ITJN";
                    break;
                case "10":
                    prefix = "ITSN";
                    break;
                case "11":
                    prefix = "ITAD";
                    break;
                case "12":
                    prefix = "ITPH";
                    break;
                case "13":
                    prefix = "ITSB";
                    break;
                case "14":
                    prefix = "INH";
                    break;
                case "15":
                    prefix = "INJ";
                    break;
                case "16":
                    prefix = "INM";
                    break;
                case "17":
                    prefix = "INLM";
                    break;
                case "18":
                    prefix = "INF";
                    break;
                case "19":
                    prefix = "COM";
                    break;
                case "20":
                    prefix = "SBC";
                    break;
                case "24":
                    prefix = "ITSQA";
                    break;
                case "25":
                    prefix = "ITJQA";
                    break;
                case "26":
                    prefix = "ITJPH";
                    break;
                case "27":
                    prefix = "ITSSE";
                    break;
                case "28":
                    prefix = "ITSTE";
                    break;
                case "29":
                    prefix = "ITFRXD";
                    break;
                case "1028":
                    prefix = "ITMN";
                    break;
                case "1029":
                    prefix = "ITMPH";
                    break;
                case "1030":
                    prefix = "ITMSE";
                    break;
                case "1031":
                    prefix = "ITJBA";
                    break;
                case "1032":
                    prefix = "ITSBA";
                    break;
                case "1033":
                    prefix = "ITMXD";
                    break;
                default:
                    prefix = "TSK";
                    break;
            }

            return prefix;
        }

        internal static string GetExceptionHtml(Exception objException)
        {
            string strHtml = "";

            strHtml += "<table width='700' cellpadding='5' border='0'>";
            strHtml += "<tr>";
            strHtml += "<td valign='top'>Type:</td>";
            strHtml += "<td valign='top'>" + objException.GetType().FullName + "</td>";
            strHtml += "</tr>";
            strHtml += "<tr>";
            strHtml += "<td valign='top'>Message:</td>";
            strHtml += "<td valign='top'>" + objException.Message + "</td>";
            strHtml += "</tr>";
            strHtml += "<tr>";
            strHtml += "<td valign='top'>StackTrace:</td>";
            strHtml += "<td valign='top'>" + objException.StackTrace + "</td>";
            strHtml += "</tr>";
            strHtml += "</table>";

            return strHtml;
        }

        internal static void SendHRFormFillupRequestEmail(string EmailType, string email, Int32 DesignationId, String FirstName)
        {
            DesignationHTMLTemplate objHTMLTemplate = HTMLTemplateBLL.Instance.GetDesignationHTMLTemplate(HTMLTemplates.HR_Request_FormFill_EmailTemplate, DesignationId.ToString());

            // Send email to each user.
            string emailId = String.Empty;
            string strBody = String.Empty;

            if (JGApplicationInfo.GetApplicationEnvironment() == "1")
            {
                emailId = "error@kerconsultancy.com";
                strBody = "<h1>Email is intended for Email Address: " + email + "</h1><br/><br/>";
            }
            else
            {
                emailId = email;
            }

            string strHeader = objHTMLTemplate.Header;
            strBody = String.Concat(strBody, objHTMLTemplate.Body);
            string strFooter = objHTMLTemplate.Footer;
            string strsubject = objHTMLTemplate.Subject;

            strBody = strBody.Replace("#name#", FirstName);

            strBody = strHeader + strBody + strFooter;

            List<Attachment> lstAttachments = objHTMLTemplate.Attachments;

            try
            {
                SendEmail(EmailType, String.Empty, emailId, strsubject, strBody, lstAttachments);
            }
            catch (Exception ex)
            {

            }

        }

        public static string GetTaskLinkTitleForAutoEmail(int taskId)
        {

            DataSet dsTaskDetails = TaskGeneratorBLL.Instance.GetTasksInformation(taskId);

            DataTable dtOriginalTaskDetails = dsTaskDetails.Tables[0];

            string newTaskLinkTitle = "";
            string installId = dtOriginalTaskDetails.Rows[0]["InstallId"].ToString();
            string taskTitle = dtOriginalTaskDetails.Rows[0]["Title"].ToString();
            string parentTaskId = dtOriginalTaskDetails.Rows[0]["ParentTaskId"].ToString();
            while (!string.IsNullOrEmpty(parentTaskId))
            {
                int intParentTaskId = int.Parse(parentTaskId);
                DataSet parentTask = TaskGeneratorBLL.Instance.GetTasksInformation(intParentTaskId);
                if (parentTask != null && parentTask.Tables.Count > 0)
                {
                    installId = parentTask.Tables[0].Rows[0]["InstallId"].ToString() + "-" + installId;
                    taskTitle += "; " + parentTask.Tables[0].Rows[0]["Title"].ToString();
                    parentTaskId = parentTask.Tables[0].Rows[0]["ParentTaskId"].ToString();
                }
                else
                {
                    parentTaskId = "";
                }
            }

            newTaskLinkTitle = string.Format("TaskID#:{0}:Title:{1}", installId, taskTitle);

            return newTaskLinkTitle;
        }


        /// <summary>
        /// Upload file on server to given relative path from given file upload control.
        /// </summary>
        /// <param name="fupControl"></param>
        /// <param name="RelativePath">Relative path on server, ex. ~/Employee/</param>
        /// <returns>Saved file name -> guid-originalfilename</returns>
        public static string UploadFile(FileUpload fupControl, String RelativePath)
        {
            String fileName = string.Empty;

            if (fupControl.HasFile)
            {
                DirectoryInfo originalDirectory = new DirectoryInfo(HttpContext.Current.Server.MapPath(RelativePath));

                string originalName = Path.GetFileName(fupControl.FileName);
                string NewFileName = Guid.NewGuid() + "-" + originalName;

                string pathString = System.IO.Path.Combine(originalDirectory.ToString(), NewFileName);

                bool isExists = System.IO.Directory.Exists(originalDirectory.ToString());

                if (!isExists)
                    System.IO.Directory.CreateDirectory(originalDirectory.ToString());

                fupControl.SaveAs(pathString);

                fileName = NewFileName;
            }

            return fileName;
        }

        /// <summary>
        /// 
        /// </summary>
        /// <param name="strFilePath">Send physically mapped path of file on server.</param>
        internal static void RemoveFile(string strFilePath)
        {
            try
            {
                if (File.Exists(strFilePath))
                {
                    File.Delete(strFilePath);
                }
            }
            catch (Exception)
            {


            }
        }


        public static string GetCandidateRedirectionURL(int UserId, bool isProfileUpdateRequired)
        {
            string strRedirectUrl = string.Empty;
            DataRow user = InstallUserBLL.Instance.getuserdetails(UserId).Tables[0].Rows[0];
            DataRow ds = InstallUserBLL.Instance.getInstallerUserDetailsByLoginId(user["Email"].ToString().Trim()).Tables[0].Rows[0];
            string AssignedSequence = ds["AssignedSequence"].ToString();
            string DesignationCode = user["DesignationCode"].ToString();
            int DesignationId = Convert.ToInt32(user["DesignationId"]);
            JGConstant.InstallUserStatus status = (JGConstant.InstallUserStatus)Convert.ToInt32(user["Status"]);
            bool FirstTime = false;
            if (ds["IsFirstTime"] != null && ds["IsFirstTime"].ToString().ToLower() == "true")
            {
                FirstTime = true;
            }

            if (JGSession.UserStatus.HasValue && JGSession.UserStatus.Value == JGConstant.InstallUserStatus.Applicant)
            {
                if (isProfileUpdateRequired)
                    strRedirectUrl = String.Concat("screening-intermediate.aspx", "?returnurl=/ViewApplicantUser.aspx?Id=", JGSession.LoginUserID);
                else
                    strRedirectUrl = "~/ViewApplicantUser.aspx?Id=" + JGSession.LoginUserID;

            }
            /*
            else if (JGSession.UserStatus.HasValue && JGSession.UserStatus.Value == JGConstant.InstallUserStatus.InterviewDateExpired)
            {
                if (isProfileUpdateRequired)
                    strRedirectUrl = String.Concat("screening-intermediate.aspx", "?returnurl=/postapptitude.aspx?Id=", JGSession.LoginUserID, "&DId=" + JGSession.DesignationId);
                else
                    strRedirectUrl = "~/postapptitude.aspx?Id=" + JGSession.LoginUserID + "&DId=" + JGSession.DesignationId;
            }*/
            // if user has passed exam and didn't assigned sequence he should be redirect to view applicant page for auto sequence assignment.
            else if (JGSession.UserStatus.HasValue && JGSession.UserStatus.Value == JGConstant.InstallUserStatus.InterviewDate && ds["AssignedSequence"].ToString() == "0")
            {
                // commented by - yogesh kerliya to implement screening popup.
                //Response.Redirect("~/ViewApplicantUser.aspx?Id=" + JGSession.LoginUserID + "&IE=1");

                if (isProfileUpdateRequired)
                {
                    strRedirectUrl = String.Concat("screening-intermediate.aspx", "?returnurl=/ViewApplicantUser.aspx?Id=", JGSession.LoginUserID, "&IE=1");
                }
                else
                {
                    strRedirectUrl = String.Concat("~/ViewApplicantUser.aspx?Id=", JGSession.LoginUserID, "&IE=1");
                }
            }

            //If user has interview date status it should always see interview instruction with them.
            else if (JGSession.UserStatus.HasValue && JGSession.UserStatus.Value == JGConstant.InstallUserStatus.InterviewDate)
            {
                // commented by - yogesh kerliya to implement screening popup.
                //Response.Redirect("~/Sr_App/ITDashboard.aspx?PWT=1");

                if (isProfileUpdateRequired)
                {
                    strRedirectUrl = String.Concat("screening-intermediate.aspx", "?returnurl=/Sr_App/ITDashboard.aspx?PWT=1");
                }
                else
                {
                    strRedirectUrl = "~/Sr_App/ITDashboard.aspx?PWT=1";
                }
            }
            else
            {
                if (JGSession.IsFirstTime == true)
                {
                    strRedirectUrl = "~/changepassword.aspx";
                }

                else if (Convert.ToString(JGSession.Designation) != "" && JGSession.IsFirstTime == false && (Convert.ToString(JGSession.Designation) == "Sr. Sales" || Convert.ToString(JGSession.Designation) == "Admin" || Convert.ToString(JGSession.Designation) == "Office Manager" || Convert.ToString(JGSession.Designation) == "Recruiter" || Convert.ToString(JGSession.Designation) == "Sales Manager") || Convert.ToString(JGSession.Designation) == "Admin Recruiter")
                {
                    #region Redirect to home Or Sr_App/home Or Installer/InstallerHome

                    if (Convert.ToString(JGSession.Designation) == "Jr. Sales" || Convert.ToString(JGSession.Designation) == "Jr Project Manager")
                    {
                        strRedirectUrl = "~/home.aspx";
                    }
                    else if (Convert.ToString(JGSession.Designation) == "sales" || Convert.ToString(JGSession.Designation).Trim() == "Admin Recruiter" || Convert.ToString(JGSession.Designation) == "SalesUser" || Convert.ToString(JGSession.Designation) == "SSE")
                    {
                        strRedirectUrl = "~/Sr_App/home.aspx";
                    }
                    else if (Convert.ToString(JGSession.Designation) == "Sr. Sales" || Convert.ToString(JGSession.Designation) == "A" || Convert.ToString(JGSession.Designation) == "Admin" || Convert.ToString(JGSession.Designation) == "Office Manager" || Convert.ToString(JGSession.Designation) == "Recruiter" || Convert.ToString(JGSession.Designation) == "Sales Manager" || Convert.ToString(JGSession.Designation).Contains("IT"))
                    {
                        if (Convert.ToString(JGSession.Designation) == "Admin" || Convert.ToString(JGSession.Designation) == "Recruiter" || Convert.ToString(JGSession.Designation) == "Office Manager")
                        {
                            strRedirectUrl = "~/Sr_App/GoogleCalendarView.aspx?lastpage=login";
                        }
                        else
                        {
                            strRedirectUrl = "~/Sr_App/home.aspx";
                        }

                    }
                    else if (Convert.ToString(JGSession.Designation).StartsWith("Installer"))
                    {
                        strRedirectUrl = "/Installer/InstallerHome.aspx";
                    }
                    else if (Convert.ToString(JGSession.Designation) == "SSE")
                    {
                        strRedirectUrl = "~/Sr_App/home.aspx";
                    }
                    else if (Convert.ToString(JGSession.Designation) == "Forman" || Convert.ToString(JGSession.Designation) == "ForeMan")
                    {
                        strRedirectUrl = "~/Installer/InstallerHome.aspx";
                    }
                    else if (Convert.ToString(JGSession.Designation) == "SubContractor")
                    {
                        strRedirectUrl = "~/Installer/InstallerHome.aspx";
                    }
                    else
                    {
                        strRedirectUrl = "~/Installer/InstallerHome.aspx";
                    }

                    #endregion
                }

                else if (Convert.ToString(JGSession.Designation).Contains("IT") || Convert.ToString(JGSession.Designation).ToLower().Contains("developer"))
                {

                    // commented by - yogesh kerliya to implement screening popup.
                    //strRedirectUrl = "~/Sr_App/ITDashboard.aspx";

                    if (isProfileUpdateRequired)
                    {
                        strRedirectUrl = String.Concat("screening-intermediate.aspx", "?returnurl=/Sr_App/ITDashboard.aspx");
                    }
                    else
                    {
                        strRedirectUrl = "~/Sr_App/ITDashboard.aspx";
                    }
                }

                else if (Convert.ToString(JGSession.Designation).StartsWith("Installer") && JGSession.IsFirstTime == false)
                {
                    strRedirectUrl = "~/Installer/InstallerHome.aspx";
                }
                else if (Convert.ToString(JGSession.Designation) == "Jr. Sales" && JGSession.IsFirstTime == false)
                {
                    strRedirectUrl = "~/home.aspx";
                }
                else if (Convert.ToString(JGSession.Designation) == "SSE" && JGSession.IsFirstTime == false)
                {
                    strRedirectUrl = "~/Sr_App/home.aspx";
                }
                else if ((Convert.ToString(JGSession.Designation) == "Forman" || Convert.ToString(JGSession.Designation) == "ForeMan") && JGSession.IsFirstTime == false)
                {
                    strRedirectUrl = "~/Installer/InstallerHome.aspx";
                }
            }
            // redirects user to the last accessed page.
            if (!string.IsNullOrEmpty(strRedirectUrl))
            {
                if (!string.IsNullOrEmpty(HttpContext.Current.Request.QueryString["returnurl"]))
                {
                    if (strRedirectUrl.ToLower().Contains("sr_app") && HttpContext.Current.Request.QueryString["returnurl"].ToLower().Contains("sr_app"))
                    {
                        strRedirectUrl = HttpUtility.UrlDecode(HttpContext.Current.Request.Url.Query.Replace("?returnurl=", ""));
                    }
                    else if (!strRedirectUrl.ToLower().Contains("sr_app") && !HttpContext.Current.Request.QueryString["returnurl"].ToLower().Contains("sr_app"))
                    {
                        strRedirectUrl = HttpUtility.UrlDecode(HttpContext.Current.Request.Url.Query.Replace("?returnurl=", ""));
                    }
                }
            }
            string baseUrl = HttpContext.Current.Request.Url.Scheme +
                            "://" + HttpContext.Current.Request.Url.Authority +
                            HttpContext.Current.Request.ApplicationPath.TrimEnd('/') + "/";
            return baseUrl + strRedirectUrl;
        }
    }
}

namespace JG_Prospect
{
    public static class JGSession
    {
        public static bool IsActive
        {
            get
            {
                if (HttpContext.Current.Session == null || JGSession.UserId == 0)
                {
                    return false;
                }
                return true;
            }
        }

        public static DateTime StartDateTime
        {
            get
            {
                if (HttpContext.Current.Session["StartDateTime"] == null)
                {
                    return DateTime.MinValue;
                }
                return Convert.ToDateTime(HttpContext.Current.Session["StartDateTime"]);
            }
            set
            {
                HttpContext.Current.Session["StartDateTime"] = value;
            }
        }

        public static Int32 UserId
        {
            get
            {
                if (HttpContext.Current.Session[JG_Prospect.Common.SessionKey.Key.UserId.ToString()] == null)
                {
                    return 0;
                }
                return Convert.ToInt32(HttpContext.Current.Session[JG_Prospect.Common.SessionKey.Key.UserId.ToString()]);
            }
            set
            {
                HttpContext.Current.Session[JG_Prospect.Common.SessionKey.Key.UserId.ToString()] = value;
            }
        }

        public static string AdminUserId
        {
            get
            {
                if (HttpContext.Current.Session["AdminUserId"] == null)
                {
                    return string.Empty;
                }
                return Convert.ToString(HttpContext.Current.Session["AdminUserId"]);
            }
            set
            {
                HttpContext.Current.Session["AdminUserId"] = value;
            }
        }

        public static string UserType
        {
            get
            {
                if (HttpContext.Current.Session["usertype"] == null)
                {
                    return string.Empty;
                }
                return Convert.ToString(HttpContext.Current.Session["usertype"]);
            }
            set
            {
                HttpContext.Current.Session["usertype"] = value;
            }
        }

        public static string Username
        {
            get
            {
                if (HttpContext.Current.Session["Username"] == null)
                {
                    return null;
                }
                return Convert.ToString(HttpContext.Current.Session["Username"]);
            }
            set
            {
                HttpContext.Current.Session["Username"] = value;
            }
        }

        public static string LastName
        {
            get
            {
                if (HttpContext.Current.Session["Lastname"] == null)
                {
                    return null;
                }
                return Convert.ToString(HttpContext.Current.Session["Lastname"]);
            }
            set
            {
                HttpContext.Current.Session["Lastname"] = value;
            }
        }

        public static string GuIdAtLogin
        {
            get
            {
                if (HttpContext.Current.Session["GuIdAtLogin"] == null)
                {
                    return null;
                }
                return Convert.ToString(HttpContext.Current.Session["GuIdAtLogin"]);
            }
            set
            {
                HttpContext.Current.Session["GuIdAtLogin"] = value;
            }
        }

        public static string UserLoginId
        {
            get
            {
                if (HttpContext.Current.Session["loginid"] == null)
                {
                    return null;
                }
                return Convert.ToString(HttpContext.Current.Session["loginid"]);
            }
            set
            {
                HttpContext.Current.Session["loginid"] = value;
            }
        }

        public static string UserPassword
        {
            get
            {
                if (HttpContext.Current.Session["loginpassword"] == null)
                {
                    return null;
                }
                return Convert.ToString(HttpContext.Current.Session["loginpassword"]);
            }
            set
            {
                HttpContext.Current.Session["loginpassword"] = value;
            }
        }

        public static string UserProfileImg
        {
            get
            {
                if (HttpContext.Current.Session["UserProfileImg"] == null || HttpContext.Current.Session["UserProfileImg"].ToString() == "")
                    return "../img/JG-Logo-white.gif";
                else
                    return Convert.ToString(HttpContext.Current.Session["UserProfileImg"]);
            }
            set
            {
                HttpContext.Current.Session["UserProfileImg"] = value;
            }
        }

        public static string LoginUserID
        {
            get
            {
                if (HttpContext.Current.Session["LoginUserID"] == null)
                    return null;
                return Convert.ToString(HttpContext.Current.Session["LoginUserID"]);
            }
            set
            {
                HttpContext.Current.Session["LoginUserID"] = value;
            }
        }

        public static Int32 DesignationId
        {
            get
            {
                if (HttpContext.Current.Session["DesignationId"] == null)
                {
                    return 0;
                }
                return Convert.ToInt32(HttpContext.Current.Session["DesignationId"]);
            }
            set
            {
                HttpContext.Current.Session["DesignationId"] = value;
            }
        }

        public static JGConstant.InstallUserStatus? UserStatus
        {
            get
            {
                if (HttpContext.Current.Session["UserStatus"] == null)
                {
                    return null;
                }
                return (JGConstant.InstallUserStatus)Convert.ToInt32(HttpContext.Current.Session["UserStatus"]);
            }
            set
            {
                HttpContext.Current.Session["UserStatus"] = value;
            }
        }

        public static string Designation
        {
            get
            {
                if (HttpContext.Current.Session["DesigNew"] == null)
                    return null;
                return Convert.ToString(HttpContext.Current.Session["DesigNew"]);
            }
            set
            {
                HttpContext.Current.Session["DesigNew"] = value;
            }
        }

        public static bool? IsInstallUser
        {
            get
            {
                if (HttpContext.Current.Session["IsInstallUser"] == null)
                {
                    return null;
                }
                return Convert.ToBoolean(HttpContext.Current.Session["IsInstallUser"]);
            }
            set
            {
                HttpContext.Current.Session["IsInstallUser"] = value;
            }
        }

        public static bool IsFirstTime
        {
            get
            {
                if (HttpContext.Current.Session["IsFirstTime"] == null)
                    return false;
                return Convert.ToBoolean(HttpContext.Current.Session["IsFirstTime"]);
            }
            set
            {
                HttpContext.Current.Session["IsFirstTime"] = value;
            }
        }

        public static bool IsCustomer
        {
            get
            {
                if (HttpContext.Current.Session["IsCustomer"] == null)
                    return false;
                return Convert.ToBoolean(HttpContext.Current.Session["IsCustomer"]);
            }
            set
            {
                HttpContext.Current.Session["IsCustomer"] = value;
            }
        }

        public static bool IsGooglePlus
        {
            get
            {
                if (HttpContext.Current.Session["GooglePlus"] == null)
                    return false;
                return Convert.ToBoolean(HttpContext.Current.Session["GooglePlus"]);
            }
            set
            {
                HttpContext.Current.Session["GooglePlus"] = value;
            }
        }

        public static bool IsFacebook
        {
            get
            {
                if (HttpContext.Current.Session["facebook"] == null)
                    return false;
                return Convert.ToBoolean(HttpContext.Current.Session["facebook"]);
            }
            set
            {
                HttpContext.Current.Session["facebook"] = value;
            }
        }

        public static bool IsYahoo
        {
            get
            {
                if (HttpContext.Current.Session["yahoo"] == null)
                    return false;
                return Convert.ToBoolean(HttpContext.Current.Session["yahoo"]);
            }
            set
            {
                HttpContext.Current.Session["yahoo"] = value;
            }
        }

        public static bool IsMicrosoft
        {
            get
            {
                if (HttpContext.Current.Session["microsoft"] == null)
                    return false;
                return Convert.ToBoolean(HttpContext.Current.Session["microsoft"]);
            }
            set
            {
                HttpContext.Current.Session["microsoft"] = value;
            }
        }
        public static DateTime? ExamTimerSetTime
        {
            get
            {
                if (HttpContext.Current.Session["estime"] == null)
                    return null;
                return Convert.ToDateTime(HttpContext.Current.Session["estime"]);
            }
            set
            {
                HttpContext.Current.Session["estime"] = value;
            }
        }
        public static Int32 CurrentExamTime
        {
            get
            {
                if (HttpContext.Current.Session["cextime"] == null)
                    return 0;
                return Convert.ToInt32(HttpContext.Current.Session["cextime"]);
            }
            set
            {
                HttpContext.Current.Session["cextime"] = value;
            }
        }

        public static string UserInstallId
        {
            get
            {
                if (HttpContext.Current.Session["UserInstallId"] == null)
                    return null;
                return Convert.ToString(HttpContext.Current.Session["UserInstallId"]);
            }
            set
            {
                HttpContext.Current.Session["UserInstallId"] = value;
            }
        }

        public static string PortalEmail
        {
            get
            {
                if (HttpContext.Current.Session["PortalEmail"] == null)
                {
                    return string.Empty;
                }
                return Convert.ToString(HttpContext.Current.Session["PortalEmail"]);
            }
            set
            {
                HttpContext.Current.Session["PortalEmail"] = value;
            }
        }

        public static string PortalEmailPassword
        {
            get
            {
                if (HttpContext.Current.Session["PortalEmailPassword"] == null)
                {
                    return string.Empty;
                }
                return Convert.ToString(HttpContext.Current.Session["PortalEmailPassword"]);
            }
            set
            {
                HttpContext.Current.Session["PortalEmailPassword"] = value;
            }
        }

        public static Dictionary<string, string> ChatReplyQueryParameters
        {
            get
            {
                if (HttpContext.Current.Session["ChatReplyQueryParameters"] == null)
                    return null;
                return (Dictionary<string, string>)HttpContext.Current.Session["ChatReplyQueryParameters"];
            }
            set
            {
                HttpContext.Current.Session["ChatReplyQueryParameters"] = value;
            }
        }
    }
}

namespace JG_Prospect
{
    public static class JGSMSHelper
    {

        /// <summary>
        /// Send text SMS to given mobile number
        /// </summary>
        /// <param name="MobileNumber">Mobile message number with international dialing code. for ex. +91</param>
        /// <param name="MSGText"></param>
        /// <returns></returns>
        internal static bool SendSMS(String MobileNumber, String MSGText)
        {

            //using (WebClient client = new WebClient())
            //{
            //    byte[] response = client.UploadValues("http://textbelt.com/text", new NameValueCollection() { { "phone", MobileNumber }, { "message", MSGText }, { "key", "b6c82eaecce10df0c4fa006c8a3093438bd5850fZ6ZspSTasK3XtwO9OyoBUwS9r" } });
            //    string result = System.Text.Encoding.UTF8.GetString(response);
            //}

            return true;

        }

        internal static string[] GetFromatedMobileNumber(String MobileNumber)
        {
            return new string[] { "", "" };

        }

    }
}