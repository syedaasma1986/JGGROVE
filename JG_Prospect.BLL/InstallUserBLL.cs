using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using JG_Prospect.DAL;
using JG_Prospect.Common;
using JG_Prospect.Common.modal;
using System.Data;
using System.Xml;
using System.Web.UI.HtmlControls;
using static JG_Prospect.Common.JGCommon;

namespace JG_Prospect.BLL
{
    public class InstallUserBLL
    {
        private static InstallUserBLL m_InstallUserBLL = new InstallUserBLL();

        private InstallUserBLL()
        {
        }
        public static InstallUserBLL Instance
        {
            get { return m_InstallUserBLL; }
            private set {; }
        }

        public ActionOutput<LoginUser> GetUsers(string keyword, string exceptUserIds = null, int? LoggedInUserId = null)
        {
            return InstallUserDAL.Instance.GetUsers(keyword, exceptUserIds, LoggedInUserId);
        }



        public void AddUserNotes(string Notes, int UserID, int AddedByID)
        {
            InstallUserDAL.Instance.AddUserNotes(Notes, UserID, AddedByID);
        }
        public DataSet GetUserEmailAndPhone(int UserID)
        { return InstallUserDAL.Instance.GetUserEmailAndPhone(UserID); }

        public bool IsManager(int UserID)
        {
            return InstallUserDAL.Instance.IsManager(UserID);
        }

        public void SetPrimaryContactOfUser(int DataID, int UserID, int DataType, bool IsPrimary)
        {
            InstallUserDAL.Instance.SetPrimaryContactOfUser(DataID, UserID, DataType, IsPrimary);
        }
        public string AddUserEmailOrPhone(int UserID, string DataForValidation, int DataType, string PhoneTypeID, string PhoneExt, bool IsPrimary)
        {
            return InstallUserDAL.Instance.AddUserEmailOrPhone(UserID, DataForValidation, DataType, PhoneTypeID, PhoneExt, IsPrimary);
        }
        public void UpdateGithubUserName(int UserId, String GithubUsername)
        {
            InstallUserDAL.Instance.UpdateGithubUserName(UserId, GithubUsername);
        }

        public string GetUserGithubUserName(int id)
        {
            return InstallUserDAL.Instance.GetUserGitUserName(id);
        }

        public string GetUserDesignationCode(int UserId)
        {
            return InstallUserDAL.Instance.GetUserDesignationCode(UserId);
        }

        public string GetDesignationCode(int designationId)
        {
            return InstallUserDAL.Instance.GetDesignationCode(designationId);
        }

        public string AddHoursToAvailability(DateTime dt)
        {
            int month = dt.Month;
            int day = dt.Day;
            int year = dt.Year;
            int hours = dt.Hour;
            string ampm = hours >= 12 ? "pm" : "am";
            int addedHours = hours + 2;
            string ampmAddedHours = hours >= 12 ? "pm" : "am";
            hours = hours % 12;
            hours = hours != 0 ? hours : 12; // the hour '0' should be '12'

            addedHours = addedHours % 12;
            addedHours = addedHours != 0 ? addedHours : 12; // the hour '0' should be '12'

            string result = month + "/" + day + "/" + year + " " + hours + ":00 " + ampm + " to " + addedHours + ":00 " + ampmAddedHours;

            return result;
            //  var d1 = new Date($(obj).val());
            //            var month = d1.getMonth();
            //            var day = d1.getDate();
            //            var year = d1.getFullYear();
            //            var hours = d1.getHours();
            //            var ampm = hours >= 12 ? 'pm' : 'am';
            //            var addedHours = hours + 2;
            //            var ampmAddedHours = addedHours >= 12 ? 'pm' : 'am';

            //            hours = hours % 12;
            //            hours = hours ? hours : 12; // the hour '0' should be '12'
            //            addedHours = addedHours % 12;
            //            addedHours = addedHours ? addedHours : 12; // the hour '0' should be '12'

            //            var f = month + '/' + day + '/' + year + ' ' + hours + ':00 ' + ampm + ' to ' + addedHours + ':00 ' + ampmAddedHours;
            //            $(obj).val(f);
        }
        public Tuple<bool, Int32> AddUser(user objuser)
        {
            return InstallUserDAL.Instance.AddIntsallUser(objuser);
        }
        public int AddSalesFollowUp(int customerid, int userId, DateTime meetingdate, string Status)
        {
            return InstallUserDAL.Instance.AddSalesFollowUp(customerid, meetingdate, Status, userId);
        }

        public DataSet GetSalesTouchPointLogData(int CustomerId, int userid)
        {
            return InstallUserDAL.Instance.GetSalesTouchPointLogData(CustomerId, userid);
        }

        public DataSet GetInstallUsersForBulkEmail(Int32 DesignationId)
        {
            return InstallUserDAL.Instance.GetInstallUsersForBulkEmail(DesignationId);
        }

        public void UpdateProspect(user objuser)
        {
            InstallUserDAL.Instance.UpdateProspect(objuser);
        }

        public DataSet AddSkillUser(string Name, string Type, string PerOwner, string Phone, string Email, string Address, string UserId)
        {
            return InstallUserDAL.Instance.addSkillUser(Name, Type, PerOwner, Phone, Email, Address, UserId);
        }

        public DataSet GetSkillUser(string UserId, string Id)
        {
            return InstallUserDAL.Instance.GetSkillUser(UserId, Id);
        }

        public void AddEditInstallerAvailability(Availability a)
        {
            InstallUserDAL.Instance.AddEditInstallerAvailability(a);
        }

        public void DeletePLLic(string LicPath)
        {
            InstallUserDAL.Instance.DeletePLLicense(LicPath);
        }

        public void DeleteAssessment(string Source)
        {
            InstallUserDAL.Instance.DeleteAssessment(Source);
        }

        public void DeleteResume(string Path)
        {
            InstallUserDAL.Instance.DeleteResume(Path);
        }

        public void UpdateDocPath(string NewPath, string OldPath)
        {
            InstallUserDAL.Instance.UpdatePath(NewPath, OldPath);
        }

        public void DeleteCirtification(string Path)
        {
            InstallUserDAL.Instance.DeleteCirtification(Path);
        }

        public void DeleteGeneral(string Path)
        {
            InstallUserDAL.Instance.DeleteLibilities(Path);
        }

        public void DeleteComp(string Path)
        {
            InstallUserDAL.Instance.DeleteWorkerComp(Path);
        }

        public void DeleteImage(string imagePath)
        {
            InstallUserDAL.Instance.DeleteImage(imagePath);
        }
        public DataSet AddSource(string Source)
        {
            return InstallUserDAL.Instance.AddSource(Source);
        }


        public DataSet GetProspectCount(int UserId, string dt1, string dt2)
        {
            return InstallUserDAL.Instance.GetProspectCount(UserId, dt1, dt2);
        }

        public DataSet CheckSource(string Source)
        {
            return InstallUserDAL.Instance.CheckDuplicateSource(Source);
        }

        public DataSet GetSource()
        {
            return InstallUserDAL.Instance.getSource();
        }

        public List<UserSource> GetSourceList()
        {
            return InstallUserDAL.Instance.GetSourceList();
        }

        public bool DeleteSource(string Source)
        {
            return InstallUserDAL.Instance.DeleteSource(Source);
        }
        public DataSet GetAttachment(int id)
        {
            return InstallUserDAL.Instance.GetAttachment(id);
        }

        public DataSet CheckInstallUser(string UserName, string PhoneNo)
        {
            return InstallUserDAL.Instance.CheckDuplicateInstaller(UserName, PhoneNo);
        }

        public DataSet CheckInstallUserOnEdit(string UserName, string PhoneNo, int Id)
        {
            return InstallUserDAL.Instance.CheckDuplicateInstallerOnEdit(UserName, PhoneNo, Id);
        }

        public DataSet getzip(string zip)
        {
            return InstallUserDAL.Instance.getZip(zip);
        }
        public DataSet GetInstallerAvailability(string referenceId, int installerId)
        {
            return InstallUserDAL.Instance.GetInstallerAvailability(referenceId, installerId);
        }

        public bool UpdateConfirmInstallUser(user objuser)
        {
            return InstallUserDAL.Instance.UpdateConfirmInstallUser(objuser);
        }

        public bool UpdateInstallUser(user objuser, int id, int loggedInUserId)
        {
            return InstallUserDAL.Instance.UpdateInstallUser(objuser, id, loggedInUserId);
        }
        public DataSet GetJobsForInstaller()
        {
            DataSet ds = InstallUserDAL.Instance.GetJobsForInstaller();
            if (ds.Tables[0].Rows.Count > 0)
            {
                for (int i = 0; i < ds.Tables[0].Rows.Count; i++)
                {
                    DataRow dr = ds.Tables[0].Rows[i];
                    dr["Category"] = InstallUserDAL.Instance.GetAllCategoriesForReferenceId(dr["ReferenceId"].ToString());
                }
            }
            return ds;
        }

        public bool CheckUnsubscribedEmail(string strToAddress)
        {
            return InstallUserDAL.Instance.CheckUnsubscribedEmail(strToAddress);
        }

        public DataSet getUser(string loginid)
        {
            return UserDAL.Instance.getUser(loginid);
        }
        public DataSet getallInstallusers()
        {
            DataSet dsNew = new DataSet();
            try
            {
                dsNew = InstallUserDAL.Instance.getallInstallusers();
            }
            catch
            {
                throw;
            }
            return dsNew;
        }
        public DataSet GetAllEditSalesUser()
        {
            return InstallUserDAL.Instance.GetAllEditSalesUser();
        }

        public DataSet GetAllSalesUserToExport()
        {
            return InstallUserDAL.Instance.ExportAllSalesUsersData();
        }

        public DataSet ExportAllInstallUsersData()
        {
            return InstallUserDAL.Instance.ExportAllInstallUsersData();
        }
        public DataSet getTrades()
        {
            return InstallUserDAL.Instance.getTrade();
        }

        public DataSet getUserList()
        {
            return InstallUserDAL.Instance.getUserList();
        }

        public DataSet getSrusers()
        {
            return UserDAL.Instance.getSrusers();
        }
        public DataSet getuserdetails(int id)
        {
            return InstallUserDAL.Instance.getuserdetails(id);
        }
        public DataSet getuserdetailsbyId(int id)
        {
            return InstallUserDAL.Instance.getuserdetailsbyId(id);
        }
        public DataSet getalluserdetails()
        {
            return InstallUserDAL.Instance.getalluserdetails();
        }
        public DataTable getMaxId(string userType, string userStatus)
        {
            return InstallUserDAL.Instance.getMaxId(userType, userStatus);
        }

        public DataTable GetMaxSalesId(string Designition)
        {
            return InstallUserDAL.Instance.GetMaxSalesId(Designition);
        }

        public DataTable getTemplate(string status, string Part)
        {
            return InstallUserDAL.Instance.getEmailTemplate(status, Part);
        }

        public bool DeactivateInstallUsers(List<Int32> lstIDs)
        {
            return InstallUserDAL.Instance.DeactivateInstallUsers(lstIDs);
        }

        public bool DeleteInstallUsers(List<Int32> lstIDs)
        {
            return InstallUserDAL.Instance.DeleteInstallUsers(lstIDs);
        }

        public bool updateProspectstatus(int Estimateid, string status, DateTime? followupdate)
        {
            return UserDAL.Instance.updateProspectstatus(Estimateid, status, followupdate);
        }

        public bool SavePeriod(period objperiod)
        {
            return UserDAL.Instance.SavePeriod(objperiod);
        }

        public bool deleteperiod(int periodname)
        {
            return UserDAL.Instance.deleteperiod(periodname);
        }

        public DataSet getallperiod()
        {
            return UserDAL.Instance.getallperiod();
        }

        public DataSet getperioddetails(int periodId)
        {
            return UserDAL.Instance.getperioddetails(periodId);
        }

        public DataSet getInstallerUserDetailsByLoginId(string loginid, bool blIncludeRejected = false)
        {
            return InstallUserDAL.Instance.getInstallerUserDetailsByLoginId(loginid, blIncludeRejected);
        }

        public ActionOutput<string> ExpireLoginCode(string loginCode)
        {
            return InstallUserDAL.Instance.ExpireLoginCode(loginCode);
        }

        public DataSet getCustomerUserDetails(string Email, string Password)
        {
            return InstallUserDAL.Instance.getInstallerUserDetailsByLoginId(Email, Password);
        }


        public DataSet getCustomerUserLogin(string Email, string Password)
        {
            return InstallUserDAL.Instance.getCustomerLogin(Email, Password);
        }

        public void ActivateUser(string loginid)
        {
            InstallUserDAL.Instance.Activateuser(loginid);
        }

        public DataSet CheckRegistration(string loginid, string PhoneNo)
        {
            return InstallUserDAL.Instance.CheckRegistration(loginid, PhoneNo);
        }

        public DataSet CheckCustomerRegistration(string loginid, string PhoneNo)
        {
            return InstallUserDAL.Instance.CheckCustomerRegistration(loginid, PhoneNo);
        }

        public bool BulkUpdateIntsallUser(string xmlDoc, string UpdatedBy)
        {
            return InstallUserDAL.Instance.BulkUpdateIntsallUser(xmlDoc, UpdatedBy);
        }

        public DataSet BulkIntsallUser(string xmlDoc)
        {
            return InstallUserDAL.Instance.BulkIntsallUser(xmlDoc);
        }

        public void AddUser(string loginid, string password, string phoneNo, string DOB)
        {
            InstallUserDAL.Instance.AddUser(loginid, password, phoneNo, DOB);
        }

        public void AddCustomer(string loginid, string password, string phoneNo, string DateOfBirth)
        {
            InstallUserDAL.Instance.AddCustomer(loginid, password, phoneNo, DateOfBirth);
        }

        public void AddUserFB(string loginid)
        {
            InstallUserDAL.Instance.AddUserFB(loginid);
        }

        public string GetPassword(string loginid)
        {
            return InstallUserDAL.Instance.GetPassword(loginid);
        }

        public string GetCustomerPassword(string loginid)
        {
            return InstallUserDAL.Instance.GetCustomerPassword(loginid);
        }

        public string GetUserName(string PhoneNumber)
        {
            return InstallUserDAL.Instance.GetUserName(PhoneNumber);
        }

        public string GetCustomerName(string PhoneNumber)
        {
            return InstallUserDAL.Instance.GetCustomerName(PhoneNumber);
        }

        public int IsValidInstallerUser(string loginid, string password)
        {
            return InstallUserDAL.Instance.IsValidInstallerUser(loginid, password);
        }
        public int addprospect(prospect objprospect)
        {
            return UserDAL.Instance.addprospect(objprospect);
        }

        public int updateprospect(prospect objprospect)
        {
            return UserDAL.Instance.updateprospect(objprospect);
        }

        public DataSet Fetchleadssummary(DateTime? frmdate, DateTime? todate, string username)
        {
            return UserDAL.Instance.Fetchleadssummary(frmdate, todate, username);
        }

        public DataSet FetchProspectstoassign(DateTime? frmdate, DateTime? todate, string username)
        {
            return UserDAL.Instance.FetchProspectstoassign(frmdate, todate, username);
        }

        public DataSet Fetchprogressreport(DateTime frmdate, DateTime todate, string username)
        {
            return UserDAL.Instance.Fetchprogressreport(frmdate, todate, username);
        }

        public DataSet Fetchstaticreport(prospect objprospect)
        {
            return UserDAL.Instance.Fetchstaticreport(objprospect);
        }

        public DataSet getprospectdetails(int id)
        {
            return UserDAL.Instance.getprospectdetails(id);
        }

        public DataSet fetchzipcode(string zipcode)
        {
            return UserDAL.Instance.fetchzipcode(zipcode);
        }

        public DataSet fetchcitystate(string zipcode)
        {
            return UserDAL.Instance.fetchcitystate(zipcode);
        }

        public DataSet GetAllVideo()
        {
            return UserDAL.Instance.GetAllVideo();
        }

        public DataSet GetResources(string type)
        {
            return UserDAL.Instance.GetResources(type);
        }

        public bool SaveResources(string link, string description, string type)
        {
            return UserDAL.Instance.SaveResources(link, description, type);
        }

        public DataSet Getcurrentperioddates()
        {
            return UserDAL.Instance.Getcurrentperioddates();
        }

        public bool ChangeInstallerPassword(int loginid, string password)
        {
            return InstallUserDAL.Instance.ChangeInstallerPassword(loginid, password);
        }

        public bool UpdateInstallUserStatus(string Status, int StatusId, int loggedInUserId)
        {
            return InstallUserDAL.Instance.UpdateInstallUserStatus(Status, StatusId, loggedInUserId);
        }

        public DataSet ChangeDesignition(int EditId, int DesignitionID)
        {

            return InstallUserDAL.Instance.ChangeDesignition(EditId, DesignitionID);
        }

        public DataSet ChangeStatus(string Status, int StatusId, DateTime RejectionDate, string RejectionTime, int RejectedUserId, bool IsInstallUser, string StatusReason = "", string UserIds = "")
        {

            return InstallUserDAL.Instance.ChangeSatatus(Status, StatusId, RejectionDate, RejectionTime, RejectedUserId, IsInstallUser, StatusReason, UserIds);
        }

        public DataSet ChangeUserStatusToReject(int StatusId, DateTime RejectionDate, string RejectionTime, int RejectedUserId, Int64 UserId, string StatusReason = "")
        {
            return InstallUserDAL.Instance.ChangeUserStatusToReject(StatusId, RejectionDate, RejectionTime, RejectedUserId, UserId, StatusReason);
        }


        public DataSet GetAllInterivewUserByPastDate()
        {
            return InstallUserDAL.Instance.GetAllInterivewUserByPastDate();
        }

        public DataSet ReSchedule_Interivew(int ApplicantId, string ReSheduleDate, string ReSheduleTime, int ReSheduleByUserId)
        {

            return InstallUserDAL.Instance.ReSchedule_Interivew(ApplicantId, ReSheduleDate, ReSheduleTime, ReSheduleByUserId);
        }

        public void ChangeStatusToInterviewDate(string Status, int StatusId, string RejectionDate, string RejectionTime, int RejectedUserId, string time, string StatusReason = "")
        {
            InstallUserDAL.Instance.ChangeStatusToInterviewDate(Status, StatusId, RejectionDate, RejectionTime, RejectedUserId, time, StatusReason);
        }

        public bool UpdateOfferMade(int Id, string Email, string password, string branchLocationId = null)
        {
            return InstallUserDAL.Instance.UpdateOfferMade(Id, Email, password, branchLocationId);
        }


        public string AddNewEmailForUser(string EmailID, bool IsPrimary, int UserID)
        {
            return InstallUserDAL.Instance.AddNewEmailForUser(EmailID, IsPrimary, UserID);
        }

        /// <summary>
        /// Load auto search suggestion as user types in search box for sales users.
        /// </summary>
        /// <param name="searchTerm"></param>
        /// <returns> categorised search suggestions for sales users</returns>
        public DataSet GetSalesUserAutoSuggestion(String searchTerm)
        {
            return InstallUserDAL.Instance.GetSalesUserAutoSuggestion(searchTerm);
        }

        //---------- start DP --------
        public DataSet GetTaskUsers(String searchTerm)
        {
            return InstallUserDAL.Instance.GetTaskUsers(searchTerm);
        }

        public DataSet GetTaskUsersForDashBoard(String searchTerm)
        {
            return InstallUserDAL.Instance.GetTaskUsersForDashBoard(searchTerm);
        }

        public string GetStarBookMarkUsers(int bookmarkingUser, int bookmarkedUser, int isdelete)
        {
            return InstallUserDAL.Instance.GetStarBookMarkUsers(bookmarkingUser, bookmarkedUser, isdelete);
        }

        public DataSet GetBookMarkingUserDetails(int bookmarkedUser)
        {
            return InstallUserDAL.Instance.GetBookMarkingUserDetails(bookmarkedUser);
        }

        //--------- end DP ----------

        public DataSet GetSalesUsersStaticticsAndData(string strSearchTerm, string strStatus, String strDesignationId, string strSourceId, DateTime? fromdate, DateTime? todate, string struserid, int intPageIndex, int intPageSize, string strSortExpression)
        {
            return InstallUserDAL.Instance.GetSalesUsersStaticticsAndData(strSearchTerm, strStatus, strDesignationId, strSourceId, fromdate, todate, struserid, intPageIndex, intPageSize, strSortExpression);
        }

        public DataSet GetHrData(DateTime? fromdate, DateTime? todate, int userid)
        {
            return InstallUserDAL.Instance.GetHrData(fromdate, todate, userid);
        }

        public DataSet GetHrDataForHrReports(DateTime fromDate, DateTime toDate, int userid)
        {
            return InstallUserDAL.Instance.GetHrDataForHrReports(fromDate, toDate, userid);
        }

        public DataSet FilteHrData(DateTime fromDate, DateTime toDate, string designation, string status)
        {
            return InstallUserDAL.Instance.FilteHrData(fromDate, toDate, designation, status);
        }

        public DataSet GetActiveUsers()
        {
            return InstallUserDAL.Instance.GetActiveUsers();
        }
        public DataSet GetActiveContractors()
        {
            return InstallUserDAL.Instance.GetActiveContractors();

        }

        public DataSet GetTechTaskByUser(int UserId)
        {
            return InstallUserDAL.Instance.GetTechTaskByUser(UserId);
        }

        public string AddNewPhoneType(string NewPhoneType, int AddedByID)
        {
            return InstallUserDAL.Instance.AddNewPhoneType(NewPhoneType, AddedByID);
        }

        public DataSet GetAllUserPhoneType()
        {
            return InstallUserDAL.Instance.GetAllUserPhoneType();
        }

        public void SetUserDisplayID(int UserId, string strUserDesignationId, string UpdateCurrentSequence)
        {
            InstallUserDAL.Instance.SetUserDisplayID(UserId, strUserDesignationId, UpdateCurrentSequence);
        }

        public DataSet GetUsersNDesignationForSalesFilter()
        {
            return InstallUserDAL.Instance.GetUsersNDesignationForSalesFilter();
        }

        public DataSet GeAddedBytUsers()
        {
            return InstallUserDAL.Instance.GeAddedBytUsers();
        }

        public List<UserAddedBy> GeAddedBytUsersFormatted()
        {
            return InstallUserDAL.Instance.GeAddedBytUsersFormatted();
        }

        public string AddUserEmails(string hidExtEmail, int UserId)
        {
            return InstallUserDAL.Instance.AddUserEmails(hidExtEmail, UserId);
        }
        public DataSet GetUserEmailByUseId(int UserId)
        {
            return InstallUserDAL.Instance.GetUserEmailByUseId(UserId);
        }
        public DataSet GetUserPhoneByUseId(int UserId)
        {
            return InstallUserDAL.Instance.GetUserPhoneByUseId(UserId);
        }
        public string AddUserPhone(bool isPrimaryPhone, string phoneText, int phoneType, int UserID, string PhoneExtNo, string PhoneISDCode, bool ClearDataBeforInsert)
        {
            return InstallUserDAL.Instance.AddUserPhone(isPrimaryPhone, phoneText, phoneType, UserID, PhoneExtNo, PhoneISDCode, ClearDataBeforInsert);
        }

        public ChatParameter GetChatParametersByUser(int userId, int loggedInUserId, int? taskId = null, int? taskMultilevelListId = null)
        {
            return InstallUserDAL.Instance.GetChatParametersByUser(userId, loggedInUserId, taskId, taskMultilevelListId);
        }

        public int AddTouchPointLogRecord(int LoginUserID, int UserID, string LoginUserInstallID, DateTime now,
                    string ChangeLog, string strGUID, int touchPointSource, int? taskId, int? multiLevelTaskId)
        {

            ChatParameter para = InstallUserDAL.Instance.GetChatParametersByUser(UserID, LoginUserID, taskId, multiLevelTaskId);

            var LastUserTouchPoint = InstallUserDAL.Instance.GetUserTouchPointLogs(0, 1, UserID).Data;

            ChatDAL.Instance.SaveChatMessage(new ChatMessage
            {
                ChatGroupId = para.ChatGroupId,
                ChatSourceId = touchPointSource,
                FileId = null,
                IsRead = false,
                Message = ChangeLog,
                MessageAt = DateTime.Now.ToEST(),
                ReceiverIds = para.ReceiverIds,
                TaskId = taskId,
                TaskMultilevelListId = multiLevelTaskId,
                UserChatGroupId = para.UserChatGroupId,
                UserId = UserID
            }, para.ChatGroupId, para.ReceiverIds, LoginUserID);

            int UserTouchPointLogID=0;
            //int UserTouchPointLogID = InstallUserDAL.Instance.AddTouchPointLogRecord(LoginUserID, UserID, LoginUserInstallID, now, ChangeLog, strGUID, touchPointSource);
            // Send email to User / Recruiter
            // Get Html Template
            string messageUrl = string.Empty, toEmail = string.Empty, body = string.Empty;
            string baseUrl = System.Web.HttpContext.Current.Request.Url.Scheme + "://" + System.Web.HttpContext.Current.Request.Url.Authority + System.Web.HttpContext.Current.Request.ApplicationPath.TrimEnd('/') + "/";
            DesignationHTMLTemplate html = HTMLTemplateBLL.Instance.GetDesignationHTMLTemplate(HTMLTemplates.HR_EditSales_TouchpointLog_Email, "");
            // sender details
            var sender = getuserdetails(LoginUserID).Tables[0].Rows[0];
            string pic = string.IsNullOrEmpty(sender["Picture"].ToString()) ? "default.jpg"
                                : sender["Picture"].ToString().Replace("~/UploadeProfile/", "");
            pic = baseUrl + "Employee/ProfilePictures/" + pic;
            html.Body = html.Body.Replace("{ImageUrl}", pic);
            html.Body = html.Body.Replace("{Name}", sender["FristName"].ToString() + " " + sender["LastName"].ToString());
            html.Body = html.Body.Replace("{Designation}", sender["Designation"].ToString());
            html.Body = html.Body.Replace("{UserInstallID}", sender["UserInstallID"].ToString());
            html.Body = html.Body.Replace("{ProfileUrl}", baseUrl + "Sr_App/ViewSalesUser.aspx?id=" + sender["Id"].ToString());
            html.Body = html.Body.Replace("{MessageContent}", ChangeLog.Replace("Note :", "").Trim());
            //

            // Generate auto login code
            string loginCode = InstallUserDAL.Instance.GenerateLoginCode(UserID).Object;


            if (LastUserTouchPoint == null && LoginUserID == UserID) // first entry
            {
                // send email to recruiter
                toEmail = "hr@jmgroveconstruction.com";
                messageUrl = baseUrl + "Sr_App/edituser.aspx?TUID=" + UserID + "&NID=" + UserTouchPointLogID + "&auth=" + loginCode;
            }
            else if (LastUserTouchPoint != null && LastUserTouchPoint.Count() > 0 && LoginUserID == UserID) // send email to receiver
            {
                // send email to user
                var lastSender = getuserdetails(LastUserTouchPoint.First().UpdatedByUserID).Tables[0].Rows[0];
                if (Convert.ToInt32(lastSender["Id"]) == UserID)
                {
                    toEmail = lastSender["Email"].ToString();
                    messageUrl = baseUrl + "Sr_App/TouchPointLog.aspx?TUID=" + UserID + "&NID=" + UserTouchPointLogID + "&auth=" + loginCode +
                                        "&ugid=" + para.UserChatGroupId;
                }
                else
                {
                    toEmail = lastSender["Email"].ToString();
                    messageUrl = baseUrl + "Sr_App/edituser.aspx?TUID=" + UserID + "&NID=" + UserTouchPointLogID + 
                        "&auth=" + loginCode+ "&ugid=" + para.UserChatGroupId;
                }
            }
            else
            {
                var receiver = getuserdetails(UserID).Tables[0].Rows[0];
                // send email to user
                toEmail = receiver["Email"].ToString();
                messageUrl = baseUrl + "Sr_App/TouchPointLog.aspx?TUID=" + UserID + "&NID=" + UserTouchPointLogID + 
                    "&auth=" + loginCode+ "&ugid=" + para.UserChatGroupId;
            }
            body = (html.Header + html.Body + html.Footer).Replace("{MessageUrl}", messageUrl);

            EmailManager.SendEmail(JGConstant.EmailTypes.ChatMessage.ToString(), "Touch Point Log", toEmail, html.Subject, body, null);

            // find all emails
            List<string> emails = new List<string>();
            // emails.Add(toEmail);
            string[] allWords = ChangeLog.Split(new char[] { '@' }, StringSplitOptions.RemoveEmptyEntries);
            foreach (var item in allWords)
            {
                switch (item.Trim().ToLower().Substring(0, item.IndexOf(' ')))
                {
                    case "justin":
                        if (toEmail != "jgrove.georgegrovee@gmail.com")
                            emails.Add("jgrove.georgegrovee@gmail.com");//321
                        // add touch point note entry 
                        break;
                    case "yogesh":
                        if (toEmail != "kerconsultancy@hotmail.com")
                            emails.Add("kerconsultancy@hotmail.com");//901
                        break;
                    default:
                        break;
                }
            }
            if (emails.Count > 1)
                foreach (var item in emails.Distinct())
                {
                    switch (item)
                    {
                        case "jgrove.georgegrovee@gmail.com":
                            UserTouchPointLogID = InstallUserDAL.Instance.AddTouchPointLogRecord(LoginUserID, 321, LoginUserInstallID, now, ChangeLog, strGUID, touchPointSource);
                            messageUrl = baseUrl + "Sr_App/TouchPointLog.aspx?TUID=" + UserID + "&NID=" + UserTouchPointLogID + "&auth=" + loginCode+ "&ugid=" + para.UserChatGroupId;
                            body = (html.Header + html.Body + html.Footer).Replace("{MessageUrl}", messageUrl);
                            EmailManager.SendEmail(JGConstant.EmailTypes.None.ToString(), "Touch Point Log", item, html.Subject, body, null);
                            break;
                        case "kerconsultancy@hotmail.com":
                            UserTouchPointLogID = InstallUserDAL.Instance.AddTouchPointLogRecord(LoginUserID, 901, LoginUserInstallID, now, ChangeLog, strGUID, touchPointSource);
                            messageUrl = baseUrl + "Sr_App/TouchPointLog.aspx?TUID=" + UserID + "&NID=" + UserTouchPointLogID + "&auth=" + loginCode+ "&ugid=" + para.UserChatGroupId;
                            body = (html.Header + html.Body + html.Footer).Replace("{MessageUrl}", messageUrl);
                            EmailManager.SendEmail(JGConstant.EmailTypes.None.ToString(), "Touch Point Log", item, html.Subject, body, null);
                            break;
                        default:
                            break;
                    }
                }
            return UserTouchPointLogID;
        }

        public PagingResult<Notes> GetUserTouchPointLogs(int pageNumber, int pageSize, int userId)
        {
            return InstallUserDAL.Instance.GetUserTouchPointLogs(pageNumber, pageSize, userId);
        }

        public DataSet GetTouchPointLogDataByUserID(int UserID)
        {
            return InstallUserDAL.Instance.GetTouchPointLogDataByUserID(UserID);
        }

        public DataSet GetTouchPointLogDataByGUID(string StrGUID)
        {
            return InstallUserDAL.Instance.GetTouchPointLogDataByGUID(StrGUID);
        }

        public void UpdateTouchPointLog(string strGUID, int InstallUserID)
        {
            InstallUserDAL.Instance.UpdateTouchPointLog(strGUID, InstallUserID);
        }

        public string Update_ForgotPassword(string loginId, string newPassword, bool isCustomer)
        {
            return InstallUserDAL.Instance.Update_ForgotPassword(loginId, newPassword, isCustomer);
        }

        public string CheckForNewUserByEmaiID(string userEmail, int userID, string DefaultPW)
        {
            return InstallUserDAL.Instance.CheckForNewUserByEmaiID(userEmail, userID, DefaultPW);
        }

        public int InsertUserOTP(int userID, int userType, string OTP)
        {
            return InstallUserDAL.Instance.InsertUserOTP(userID, userType, OTP);
        }

        public bool ChangeUserStatusToRejectByEmail(int StatusId, DateTime RejectionDate, string RejectionTime, int RejectedUserId, String UserEmail, string StatusReason = "")
        {
            return InstallUserDAL.Instance.ChangeUserStatusToRejectByEmail(StatusId, RejectionDate, RejectionTime, RejectedUserId, UserEmail, StatusReason);
        }

        public bool ChangeUserStatusToRejectByMobile(int StatusId, DateTime RejectionDate, string RejectionTime, int RejectedUserId, String UserMobile, string StatusReason = "")
        {
            return InstallUserDAL.Instance.ChangeUserStatusToRejectByMobile(StatusId, RejectionDate, RejectionTime, RejectedUserId, UserMobile, StatusReason);

        }

        public DataSet ChangeUserSatatus(Int32 UserId, int StatusId, DateTime RejectionDate, string RejectionTime, int RejectedUserId, bool IsInstallUser, string StatusReason = "", string UserIds = "")
        {

            return InstallUserDAL.Instance.ChangeUserSatatus(UserId, StatusId, RejectionDate, RejectionTime, RejectedUserId, IsInstallUser, StatusReason, UserIds);
        }

        public void UpdateEmpType(int ID, string EmpType)
        {
            InstallUserDAL.Instance.UpdateEmpType(ID, EmpType);
        }

        public DataSet GetPopupEditUsers(String UserIds, String Status, int DesignationId, int PageIndex, int PageSize, String SortExpression)
        {
            return InstallUserDAL.Instance.GetPopupEditUsers(UserIds, Status, DesignationId, PageIndex, PageSize, SortExpression);

        }

        public DataSet GetEmployeeInterviewDetails(int UserID)
        {
            return InstallUserDAL.Instance.GetEmployeeInterviewDetails(UserID);

        }

        public int UpdateUsersLastLoginTime(int loginUserID, DateTime LogInTime)
        {
            return InstallUserDAL.Instance.UpdateUsersLastLoginTime(loginUserID, LogInTime);
        }

        public int QuickSaveInstallUser(user objInstallUser)
        {
            return InstallUserDAL.Instance.QuickSaveInstallUser(objInstallUser);
        }

        public DataSet QuickSaveUserWithEmailorPhone(user objInstallUser)
        {
            return InstallUserDAL.Instance.QuickSaveUserWithEmailorPhone(objInstallUser);
        }

        public DataSet BulkIntsallUserDuplicateCheck(string xmlDoc)
        {
            return InstallUserDAL.Instance.BulkIntsallUserDuplicateCheck(xmlDoc);
        }

        public Boolean UpdateUserProfile(user objuser)
        {
            return InstallUserDAL.Instance.UpdateUserProfile(objuser);

        }
        public int UserExists(int userId, string email, string phone)
        {
            return InstallUserDAL.Instance.UserExists(userId, email, phone);

        }

        public DataSet getInstallUserDetailsById(Int32 UserId)
        {
            return InstallUserDAL.Instance.getInstallUserDetailsById(UserId);
        }

        public void SavePhoneCallLog(PhoneCallLog phLog)
        {
            InstallUserDAL.Instance.SavePhoneCallLog(phLog);
        }

        public long SendCallConnectedAutoEmail(int LoginUserID, int UserID, string LoginUserInstallID,
                                        string Message, int ChatSource, string BaseUrl,
                                        string chatGroupId, int userChatGroupId, string receiverIds)
        {
            var receiver = InstallUserBLL.Instance.getuserdetails(UserID).Tables[0].Rows[0];

            // Get Html Template
            string messageUrl = string.Empty, toEmail = string.Empty, body = string.Empty;
            //string BaseUrl = System.Web.HttpContext.Current.Request.Url.Scheme + "://" + System.Web.HttpContext.Current.Request.Url.Authority + System.Web.HttpContext.Current.Request.ApplicationPath.TrimEnd('/') + "/";
            DesignationHTMLTemplate html = HTMLTemplateBLL.Instance.GetDesignationHTMLTemplate(HTMLTemplates.Call_Connected_Auto_Email, "");
            // sender details
            var sender = InstallUserBLL.Instance.getuserdetails(LoginUserID).Tables[0].Rows[0];
            string pic = string.IsNullOrEmpty(sender["Picture"].ToString()) ? "default.jpg"
                                : sender["Picture"].ToString().Replace("~/UploadeProfile/", "");
            pic = BaseUrl + "Employee/ProfilePictures/" + pic;
            html.Body = html.Body.Replace("{ImageUrl}", pic);
            html.Body = html.Body.Replace("{SenderName}", sender["FristName"].ToString() + " " + sender["LastName"].ToString());
            html.Body = html.Body.Replace("{SenderDesignation}", sender["Designation"].ToString());
            html.Body = html.Body.Replace("{SenderUserInstallID}", sender["UserInstallID"].ToString());
            html.Body = html.Body.Replace("{ProfileUrl}", BaseUrl + "Sr_App/ViewSalesUser.aspx?id=" + sender["Id"].ToString());
            html.Body = html.Body.Replace("{ReceiverEmail}", receiver["Email"].ToString());
            html.Body = html.Body.Replace("{ReceiverPhone}", receiver["Phone"].ToString());
            html.Body = html.Body.Replace("{ReceiverName}", receiver["FristName"].ToString() + " " + receiver["LastName"].ToString());


            // Generate auto login code
            string loginCode = InstallUserDAL.Instance.GenerateLoginCode(UserID).Object;

            toEmail = receiver["Email"].ToString();
            messageUrl = BaseUrl + "Sr_App/TouchPointLog.aspx?TUID=" + UserID + "&CGID=" + chatGroupId +
                                    "&auth=" + loginCode + "&RcvrID=" + receiverIds + "&Src=" + ChatSource + 
                                    "&ugid=" + userChatGroupId;


            body = (html.Header + html.Body + html.Footer).Replace("{MessageUrl}", messageUrl);
            return EmailManager.SendEmail(JGConstant.EmailTypes.CallConectedAutoEmail.ToString(), html.Subject, toEmail, html.Subject, body, null);
        }

        public List<PhoneCallLog> GetPhoneCallLog(int loggedInUserId, string callType, int index = 1, int pageSize = 5)
        {
            return InstallUserDAL.Instance.GetPhoneCallLog(loggedInUserId, callType, index, pageSize);
        }

        public PhoneCallStatistics GetPhoneCallStatistics()
        {
            return InstallUserDAL.Instance.GetPhoneCallStatistics();
        }

        public GlobalSearchModel GlobalSearch(string keyword, int LoggedInUserId)
        {
            return InstallUserDAL.Instance.GlobalSearch(keyword, LoggedInUserId);
        }

        public string UpdateSecondaryStatus(int userId, int newStatus, string newStatusText, int oldStatus,
                                                string oldStatusText, int loggedInUserId, bool AddHrChatLog = true)
        {
            return InstallUserDAL.Instance.UpdateSecondaryStatus(userId, newStatus, newStatusText, oldStatus,
                                                                    oldStatusText, loggedInUserId, AddHrChatLog);
        }

        public BranchLocation GetUserBranchLocation(int userId)
        {
            return InstallUserDAL.Instance.GetUserBranchLocation(userId);
        }

        public List<BranchLocation> GetBranchLocations()
        {
            return InstallUserDAL.Instance.GetBranchLocations();
        }

        public DataSet GetBranchLocationsDataSet()
        {
            return InstallUserDAL.Instance.GetBranchLocationsDataSet();
        }

        public List<LoginUser> GetUserManagers(int userId)
        {
            return InstallUserDAL.Instance.GetUserManagers(userId);
        }
    }
}