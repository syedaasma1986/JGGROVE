using JG_Prospect.BLL;
using JG_Prospect.Common.modal;
using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Web;
using System.Web.Services;
using JG_Prospect.Common;
using JG_Prospect.App_Code;
using System.Net.Mail;
using System.IO;
using Newtonsoft.Json;
using System.Web.Script.Services;
using System.Configuration;
using System.Web.Script.Serialization;
using JG_Prospect.Chat.Hubs;
using static JG_Prospect.Common.JGCommon;
using static JG_Prospect.Common.JGConstant;
using Microsoft.AspNet.SignalR;
using JG_Prospect.DAL;

namespace JG_Prospect.WebServices
{
    /// <summary>
    /// Summary description for JGWebService
    /// </summary>
    [WebService(Namespace = "http://tempuri.org/")]
    [WebServiceBinding(ConformsTo = WsiProfiles.BasicProfile1_1)]
    [System.ComponentModel.ToolboxItem(false)]
    // To allow this Web Service to be called from script, using ASP.NET AJAX, uncomment the following line. 
    [System.Web.Script.Services.ScriptService]
    public class JGWebService : System.Web.Services.WebService
    {
        public static string TaskUserStatuses { get; set; }

        #region '--TaskComments--'

        [WebMethod]
        public object GetTaskComments(long intTaskId, long? intParentCommentId, int? intStartIndex, int? intPageSize)
        {
            DataSet dsTaskComments = TaskCommentBLL.Instance.GetTaskCommentsDataSet(intTaskId, intParentCommentId, intStartIndex, intPageSize);

            bool blSuccess = false;
            int intTotalRecords = 0, intRemainingRecords = 0;
            List<TaskComment> lstTaskComments = new List<TaskComment>();

            if (dsTaskComments != null && dsTaskComments.Tables.Count == 2)
            {
                blSuccess = true;

                intTotalRecords = Convert.ToInt32(dsTaskComments.Tables[1].Rows[0]["TotalRecords"]);

                foreach (DataRow drTaskComment in dsTaskComments.Tables[0].Rows)
                {
                    TaskComment objTaskComment = new TaskComment();
                    objTaskComment.Id = Convert.ToInt64(drTaskComment["Id"]);
                    objTaskComment.Comment = Convert.ToString(drTaskComment["Comment"]);
                    if (!string.IsNullOrEmpty(Convert.ToString(drTaskComment["ParentCommentId"])))
                    {
                        objTaskComment.ParentCommentId = Convert.ToInt64(drTaskComment["ParentCommentId"]);
                    }
                    else
                    {
                        objTaskComment.ParentCommentId = 0;
                    }
                    objTaskComment.TaskId = Convert.ToInt64(drTaskComment["TaskId"]);
                    objTaskComment.UserId = Convert.ToInt32(drTaskComment["UserId"]);
                    objTaskComment.DateCreated = Convert.ToDateTime(drTaskComment["DateCreated"]);

                    objTaskComment.TotalChildRecords = Convert.ToInt32(drTaskComment["TotalChildRecords"]);

                    objTaskComment.UserInstallId = Convert.ToString(drTaskComment["UserInstallId"]);
                    objTaskComment.UserName = Convert.ToString(drTaskComment["Username"]);
                    objTaskComment.UserFirstName = Convert.ToString(drTaskComment["FirstName"]);
                    objTaskComment.UserLastName = Convert.ToString(drTaskComment["LastName"]);
                    objTaskComment.UserEmail = Convert.ToString(drTaskComment["Email"]);

                    lstTaskComments.Add(objTaskComment);
                }

                if (intPageSize.HasValue)
                {
                    intRemainingRecords = intTotalRecords - intPageSize.Value;
                }
            }

            return new
            {
                Success = blSuccess,
                TotalRecords = intTotalRecords,
                RemainingRecords = intRemainingRecords,
                TaskComments = lstTaskComments
            };
        }

        [WebMethod(EnableSession = true)]
        public object SaveTaskComment(string strId, string strComment, string strParentCommentId, string strTaskId)
        {
            TaskComment objTaskComment = new TaskComment();
            objTaskComment.Id = 0;
            objTaskComment.Comment = strComment;
            if (string.IsNullOrEmpty(strParentCommentId) || strParentCommentId == "0")
            {
                objTaskComment.ParentCommentId = null;
            }
            else
            {
                objTaskComment.ParentCommentId = Convert.ToInt64(strParentCommentId);
            }
            objTaskComment.TaskId = Convert.ToInt64(strTaskId);
            objTaskComment.UserId = Convert.ToInt32(Session[JG_Prospect.Common.SessionKey.Key.UserId.ToString()]);

            bool blSuccess = false;

            if (!string.IsNullOrEmpty(strId))
            {
                objTaskComment.Id = Convert.ToInt64(strId);
            }

            if (objTaskComment.Id > 0)
            {
                blSuccess = TaskCommentBLL.Instance.UpdateTaskComment(objTaskComment);
            }
            else
            {
                blSuccess = TaskCommentBLL.Instance.InsertTaskComment(objTaskComment);
            }

            var result = new
            {
                Success = blSuccess
            };

            return result;
        }

        #endregion

        #region '--TaskApproval--'
        [WebMethod(EnableSession = true)]
        public object FreezeFeedbackTask(int EstimatedHours, string Password, string StartDate, string EndDate, int TaskId, bool IsITLead)
        {
            string strMessage = "Task Freezed Successfully";
            bool blSuccess = false;

            if (!Password.Equals(Convert.ToString(Session["loginpassword"])))
            {
                strMessage = "Task cannot be freezed as password is not valid.";
            }
            else
            {
                blSuccess = TaskGeneratorBLL.Instance.UpdateFeedbackTask(EstimatedHours, Password, StartDate, EndDate, TaskId, (JGSession.DesignationId == (byte)JG_Prospect.Common.JGConstant.DesignationType.IT_Lead), Convert.ToInt32(Session[JG_Prospect.Common.SessionKey.Key.UserId.ToString()]));
            }

            var result = new
            {
                Message = strMessage,
                Success = blSuccess
            };
            return result;
        }

        [WebMethod(EnableSession = true)]
        public object FreezeTask(string strEstimatedHours, string strTaskApprovalId, string strTaskId, string strPassword)
        {
            string strMessage;
            bool blSuccess = false;

            decimal decEstimatedHours = 0;

            if (string.IsNullOrEmpty(strPassword))
            {
                strMessage = "Sub Task cannot be freezed as password is not provided.";
            }
            else if (!strPassword.Equals(Convert.ToString(Session["loginpassword"])))
            {
                strMessage = "Sub Task cannot be freezed as password is not valid.";
            }
            else if (string.IsNullOrEmpty(strEstimatedHours))
            {
                strMessage = "Sub Task cannot be freezed as estimated hours is not provided.";
            }
            else if (!decimal.TryParse(strEstimatedHours.Trim(), out decEstimatedHours) || decEstimatedHours <= 0)
            {
                strMessage = "Sub Task cannot be freezed as estimated hours is not valid.";
            }
            else
            {
                #region Update Estimated Hours

                TaskApproval objTaskApproval = new TaskApproval();
                if (string.IsNullOrEmpty(strTaskApprovalId))
                {
                    objTaskApproval.Id = 0;
                }
                else
                {
                    objTaskApproval.Id = Convert.ToInt64(strTaskApprovalId);
                }
                objTaskApproval.EstimatedHours = strEstimatedHours.Trim();
                objTaskApproval.Description = string.Empty;
                objTaskApproval.TaskId = Convert.ToInt32(strTaskId);
                objTaskApproval.UserId = Convert.ToInt32(Session[JG_Prospect.Common.SessionKey.Key.UserId.ToString()]);
                objTaskApproval.IsInstallUser = JGSession.IsInstallUser.Value;

                if (objTaskApproval.Id > 0)
                {
                    TaskGeneratorBLL.Instance.UpdateTaskApproval(objTaskApproval);
                }
                else
                {
                    TaskGeneratorBLL.Instance.InsertTaskApproval(objTaskApproval);
                }

                #endregion

                #region Update Task (Freeze, Status)

                Task objTask = new Task();

                objTask.TaskId = Convert.ToInt32(strTaskId);

                bool blIsAdmin, blIsTechLead, blIsUser;

                blIsAdmin = blIsTechLead = blIsUser = false;
                if (JGSession.DesignationId == (byte)JG_Prospect.Common.JGConstant.DesignationType.Admin)
                {
                    objTask.AdminUserId = Convert.ToInt32(Session[JG_Prospect.Common.SessionKey.Key.UserId.ToString()]);
                    objTask.IsAdminInstallUser = JGSession.IsInstallUser.Value;
                    objTask.AdminStatus = true;
                    blIsAdmin = true;
                }
                else if (JGSession.DesignationId == (byte)JG_Prospect.Common.JGConstant.DesignationType.IT_Lead)
                {
                    objTask.TechLeadUserId = Convert.ToInt32(Session[JG_Prospect.Common.SessionKey.Key.UserId.ToString()]);
                    objTask.IsTechLeadInstallUser = JGSession.IsInstallUser.Value;
                    objTask.TechLeadStatus = true;
                    blIsTechLead = true;
                }
                else
                {
                    objTask.OtherUserId = Convert.ToInt32(Session[JG_Prospect.Common.SessionKey.Key.UserId.ToString()]);
                    objTask.IsOtherUserInstallUser = JGSession.IsInstallUser.Value;
                    objTask.OtherUserStatus = true;
                    blIsUser = true;
                }

                TaskGeneratorBLL.Instance.UpdateSubTaskStatusById
                                            (
                                                objTask,
                                                blIsAdmin,
                                                blIsTechLead,
                                                blIsUser
                                            );

                blSuccess = true;
                strMessage = "Sub Task freezed successfully.";

                #endregion
            }

            var result = new
            {
                Success = blSuccess,
                Message = strMessage,
                TaskId = strTaskId
            };

            return result;
        }

        [WebMethod(EnableSession = true)]
        public object AdminFreezeTask(string strTaskApprovalId, string strTaskId, string strPassword)
        {
            string strMessage;
            bool blSuccess = false;

            if (string.IsNullOrEmpty(strPassword))
            {
                strMessage = "Sub Task cannot be freezed as password is not provided.";
            }
            else if (!strPassword.Equals(Convert.ToString(Session["loginpassword"])))
            {
                strMessage = "Sub Task cannot be freezed as password is not valid.";
            }
            else
            {

                #region Update Task (Freeze, Status)

                Task objTask = new Task();

                objTask.TaskId = Convert.ToInt32(strTaskId);

                bool blIsAdmin, blIsTechLead, blIsUser;

                blIsAdmin = blIsTechLead = blIsUser = false;
                if (JGSession.DesignationId == (byte)JG_Prospect.Common.JGConstant.DesignationType.Admin)
                {
                    objTask.AdminUserId = Convert.ToInt32(Session[JG_Prospect.Common.SessionKey.Key.UserId.ToString()]);
                    objTask.IsAdminInstallUser = JGSession.IsInstallUser.Value;
                    objTask.AdminStatus = true;
                    blIsAdmin = true;
                }

                TaskGeneratorBLL.Instance.UpdateSubTaskStatusById
                                            (
                                                objTask,
                                                blIsAdmin,
                                                blIsTechLead,
                                                blIsUser
                                            );

                blSuccess = true;
                strMessage = "Sub Task freezed successfully.";

                #endregion
            }

            var result = new
            {
                Success = blSuccess,
                Message = strMessage,
                TaskId = strTaskId
            };

            return result;
        }

        #endregion

        #region '--TaskWorkSpecification--'

        [WebMethod(EnableSession = true)]
        public object GetTaskWorkSpecifications(Int32 TaskId, Int64 intParentTaskWorkSpecificationId)
        {
            List<string> strTableData = new List<string>();

            DataSet ds = new DataSet();

            if (intParentTaskWorkSpecificationId == 0)
            {
                ds = TaskGeneratorBLL.Instance.GetTaskWorkSpecifications(TaskId, App_Code.CommonFunction.CheckAdminAndItLeadMode(), null, 0, null);
            }
            else
            {
                ds = TaskGeneratorBLL.Instance.GetTaskWorkSpecifications(TaskId, App_Code.CommonFunction.CheckAdminAndItLeadMode(), intParentTaskWorkSpecificationId, 0, null);
            }

            TaskWorkSpecification[] arrTaskWorkSpecification = null;

            string strFirstParentCustomId = "";
            string strLastCustomId = "";
            int intTotalRecordCount = 0;

            if (ds.Tables.Count == 4)
            {
                arrTaskWorkSpecification = new TaskWorkSpecification[ds.Tables[0].Rows.Count];
                for (int i = 0; i < ds.Tables[0].Rows.Count; i++)
                {
                    DataRow dr = ds.Tables[0].Rows[i];
                    arrTaskWorkSpecification[i] = new TaskWorkSpecification();
                    arrTaskWorkSpecification[i].Id = Convert.ToInt64(dr["Id"]);
                    arrTaskWorkSpecification[i].CustomId = Convert.ToString(dr["CustomId"]);
                    arrTaskWorkSpecification[i].AdminStatus = Convert.ToBoolean(dr["AdminStatus"]);
                    arrTaskWorkSpecification[i].TechLeadStatus = Convert.ToBoolean(dr["TechLeadStatus"]);
                    arrTaskWorkSpecification[i].OtherUserStatus = Convert.ToBoolean(dr["OtherUserStatus"]);
                    arrTaskWorkSpecification[i].Description = Convert.ToString(dr["Description"]);
                    arrTaskWorkSpecification[i].Title = Convert.ToString(dr["Title"]);
                    arrTaskWorkSpecification[i].URL = Convert.ToString(dr["URL"]);
                    if (!string.IsNullOrEmpty(dr["ParentTaskWorkSpecificationId"].ToString()))
                    {
                        arrTaskWorkSpecification[i].ParentTaskWorkSpecificationId = Convert.ToInt64(dr["ParentTaskWorkSpecificationId"]);
                    }
                    arrTaskWorkSpecification[i].TaskWorkSpecificationsCount = Convert.ToInt32(dr["SubTaskWorkSpecificationCount"]);
                }

                intTotalRecordCount = Convert.ToInt32(ds.Tables[1].Rows[0]["TotalRecordCount"]);

                if (ds.Tables[2].Rows.Count > 0)
                {
                    strFirstParentCustomId = Convert.ToString(ds.Tables[2].Rows[0]["FirstParentCustomId"]);
                }
                if (ds.Tables[3].Rows.Count > 0)
                {
                    strLastCustomId = Convert.ToString(ds.Tables[3].Rows[0]["LastChildCustomId"]);
                }
            }

            string strNextCustomId = string.Empty;

            if (string.IsNullOrEmpty(strFirstParentCustomId) || intParentTaskWorkSpecificationId == 0)
            {
                strNextCustomId = App_Code.CommonFunction.GetNextSequenceValue("A", strLastCustomId);
            }
            // parent list has alphabetical numbering.
            else if (strFirstParentCustomId.Equals("A"))
            {
                strNextCustomId = App_Code.CommonFunction.GetNextSequenceValue("1", strLastCustomId);
            }
            // parent list has decimal numbering.
            else if (strFirstParentCustomId.Equals("1"))
            {
                strNextCustomId = App_Code.CommonFunction.GetNextSequenceValue("1a", strLastCustomId);
            }
            // parent list has custom numbering.
            else if (strFirstParentCustomId.Equals("1a"))
            {
                strNextCustomId = App_Code.CommonFunction.GetNextSequenceValue("1", strLastCustomId);
            }
            // parent list has roman numbering.
            else if (strFirstParentCustomId.Equals("i") || strFirstParentCustomId.Equals("I"))
            {
                strNextCustomId = App_Code.CommonFunction.GetNextSequenceValue("a", strLastCustomId);
            }
            else
            {
                strNextCustomId = App_Code.CommonFunction.GetNextSequenceValue("I", strLastCustomId, true);
            }

            int intPendingCount = 0;

            DataSet dsTaskSpecificationStatus = TaskGeneratorBLL.Instance.GetPendingTaskWorkSpecificationCount(TaskId);
            if (dsTaskSpecificationStatus.Tables.Count > 1 && dsTaskSpecificationStatus.Tables[1].Rows.Count > 0)
            {
                intPendingCount = Convert.ToInt32(dsTaskSpecificationStatus.Tables[1].Rows[0]["PendingRecordCount"]);
            }

            var result = new
            {
                NextCustomId = strNextCustomId,
                TotalRecordCount = intTotalRecordCount,
                PendingCount = intPendingCount,
                Records = arrTaskWorkSpecification
            };

            return result;
        }

        [WebMethod(EnableSession = true)]
        public bool SaveTaskWorkSpecification(Int64 intId, string strCustomId, string strDescription, string strTitle, string strURL, Int64 intTaskId, Int64 intParentTaskWorkSpecificationId, string strPassword = "")
        {
            bool blSuccess = true;

            if (intTaskId > 0)
            {
                TaskWorkSpecification objTaskWorkSpecification = new TaskWorkSpecification();
                objTaskWorkSpecification.Id = intId;
                objTaskWorkSpecification.CustomId = strCustomId;
                objTaskWorkSpecification.TaskId = intTaskId;
                objTaskWorkSpecification.Description = Server.HtmlDecode(strDescription);
                objTaskWorkSpecification.Title = strTitle;
                objTaskWorkSpecification.URL = strURL;

                // save will revoke freezed status.
                objTaskWorkSpecification.AdminStatus = false;
                objTaskWorkSpecification.TechLeadStatus = false;

                if (strPassword.Equals(Convert.ToString(Session["loginpassword"])))
                {
                    if (HttpContext.Current.Session["DesigNew"].ToString().ToUpper().Equals("ADMIN"))
                    {
                        objTaskWorkSpecification.AdminUserId = Convert.ToInt32(Session[JG_Prospect.Common.SessionKey.Key.UserId.ToString()]);
                        objTaskWorkSpecification.IsAdminInstallUser = JGSession.IsInstallUser.Value;
                        objTaskWorkSpecification.AdminStatus = true;
                    }
                    else if (HttpContext.Current.Session["DesigNew"].ToString().ToUpper().Equals("ITLEAD"))
                    {
                        objTaskWorkSpecification.TechLeadUserId = Convert.ToInt32(Session[JG_Prospect.Common.SessionKey.Key.UserId.ToString()]);
                        objTaskWorkSpecification.IsTechLeadInstallUser = JGSession.IsInstallUser.Value;
                        objTaskWorkSpecification.TechLeadStatus = true;
                    }
                    else
                    {
                        objTaskWorkSpecification.OtherUserId = Convert.ToInt32(Session[JG_Prospect.Common.SessionKey.Key.UserId.ToString()]);
                        objTaskWorkSpecification.IsOtherUserInstallUser = JGSession.IsInstallUser.Value;
                        objTaskWorkSpecification.OtherUserStatus = true;
                    }
                }

                if (intParentTaskWorkSpecificationId > 0)
                {
                    objTaskWorkSpecification.ParentTaskWorkSpecificationId = intParentTaskWorkSpecificationId;
                }

                if (objTaskWorkSpecification.Id == 0)
                {
                    TaskGeneratorBLL.Instance.InsertTaskWorkSpecification(objTaskWorkSpecification);
                }
                else
                {
                    TaskGeneratorBLL.Instance.UpdateTaskWorkSpecification(objTaskWorkSpecification);
                }
            }
            else
            {
                blSuccess = false;
            }
            return blSuccess;
        }

        [WebMethod(EnableSession = true)]
        public bool DeleteTaskWorkSpecification(Int64 intId)
        {
            bool blSuccess = false;

            if (TaskGeneratorBLL.Instance.DeleteTaskWorkSpecification(intId) > 0)
            {
                blSuccess = true;
            }

            return blSuccess;
        }

        [WebMethod(EnableSession = true)]
        public bool DeleteTaskUserFile(int AttachmentId)
        {
            bool blSuccess = false;

            if (TaskGeneratorBLL.Instance.DeleteTaskUserFile(AttachmentId))
            {
                blSuccess = true;
            }

            return blSuccess;
        }

        [WebMethod(EnableSession = true)]
        public int UpdateTaskWorkSpecificationStatusById(Int64 intId, string strPassword)
        {
            if (strPassword.Equals(Convert.ToString(Session["loginpassword"])))
            {
                TaskWorkSpecification objTaskWorkSpecification = new TaskWorkSpecification();
                objTaskWorkSpecification.Id = intId;

                bool blIsAdmin, blIsTechLead, blIsUser;

                blIsAdmin = blIsTechLead = blIsUser = false;
                if (HttpContext.Current.Session["DesigNew"].ToString().ToUpper().Equals("ADMIN"))
                {
                    objTaskWorkSpecification.AdminUserId = Convert.ToInt32(Session[JG_Prospect.Common.SessionKey.Key.UserId.ToString()]);
                    objTaskWorkSpecification.IsAdminInstallUser = JGSession.IsInstallUser.Value;
                    objTaskWorkSpecification.AdminStatus = true;
                    blIsAdmin = true;
                }
                else if (HttpContext.Current.Session["DesigNew"].ToString().ToUpper().Equals("ITLEAD"))
                {
                    objTaskWorkSpecification.TechLeadUserId = Convert.ToInt32(Session[JG_Prospect.Common.SessionKey.Key.UserId.ToString()]);
                    objTaskWorkSpecification.IsTechLeadInstallUser = JGSession.IsInstallUser.Value;
                    objTaskWorkSpecification.TechLeadStatus = true;
                    blIsTechLead = true;
                }
                else
                {
                    objTaskWorkSpecification.OtherUserId = Convert.ToInt32(Session[JG_Prospect.Common.SessionKey.Key.UserId.ToString()]);
                    objTaskWorkSpecification.IsOtherUserInstallUser = JGSession.IsInstallUser.Value;
                    objTaskWorkSpecification.OtherUserStatus = true;
                    blIsUser = true;
                }

                return TaskGeneratorBLL.Instance.UpdateTaskWorkSpecificationStatusById
                                            (
                                                objTaskWorkSpecification,
                                                blIsAdmin,
                                                blIsTechLead,
                                                blIsUser
                                            );
            }
            else
            {
                return -2;
            }
        }

        #endregion

        #region '--Task--'
        [WebMethod(EnableSession = true)]
        public String GetTaskUserFileByFileName(string FileName)
        {
            string strMessage = string.Empty;
            DataSet dtResult = null;

            dtResult = TaskGeneratorBLL.Instance.GetTaskUserFileByFileName(FileName);
            dtResult.Tables[0].Rows[0]["AttachDate"] = string.Format("{0:MM/dd/yyyy hh:mm tt}", Convert.ToDateTime(dtResult.Tables[0].Rows[0]["AttachDate"]).ToEST());

            if (dtResult != null && dtResult.Tables.Count > 0)
            {
                dtResult.DataSetName = "FileData";
                dtResult.Tables[0].TableName = "File";
                System.Xml.XmlDocument doc = new System.Xml.XmlDocument();
                doc.LoadXml(dtResult.GetXml());
                strMessage = JsonConvert.SerializeXmlNode(doc);//.Replace("null", "\"\"").Replace("'", "\'");
            }
            else
            {
                strMessage = String.Empty;
            }
            return strMessage;
        }

        [WebMethod(EnableSession = true)]
        public String GetTaskMultilevelChildInfo(int ParentTaskId)
        {
            string strMessage = string.Empty;
            DataSet dtResult = null;

            dtResult = TaskGeneratorBLL.Instance.GetTaskMultilevelChildInfo(ParentTaskId);

            if (dtResult != null && dtResult.Tables.Count > 0)
            {
                dtResult.DataSetName = "ChildInfoDS";
                dtResult.Tables[0].TableName = "Info";
                System.Xml.XmlDocument doc = new System.Xml.XmlDocument();
                doc.LoadXml(dtResult.GetXml());
                strMessage = JsonConvert.SerializeXmlNode(doc);//.Replace("null", "\"\"").Replace("'", "\'");
            }
            else
            {
                strMessage = String.Empty;
            }
            return strMessage;
        }

        [WebMethod(EnableSession = true)]
        public bool SaveUserAttachements(string TaskId, string attachments)
        {
            //User has attached file than save it to database.
            if (!String.IsNullOrEmpty(attachments))
            {
                TaskUser taskUserFiles = new TaskUser();

                if (!string.IsNullOrEmpty(attachments))
                {
                    String[] files = attachments.Split(new char[] { '^' }, StringSplitOptions.RemoveEmptyEntries);

                    foreach (String attachment in files)
                    {
                        String[] attachements = attachment.Split('@');

                        taskUserFiles.Attachment = attachements[0];
                        taskUserFiles.OriginalFileName = attachements[1];
                        taskUserFiles.Mode = 0; // insert data.
                        taskUserFiles.TaskId = long.Parse(TaskId);
                        taskUserFiles.UserId = Convert.ToInt32(Session[SessionKey.Key.UserId.ToString()]);
                        taskUserFiles.TaskUpdateId = null;
                        taskUserFiles.UserType = JGSession.IsInstallUser ?? false;
                        taskUserFiles.TaskFileDestination = JGConstant.TaskFileDestination.SubTask;
                        TaskGeneratorBLL.Instance.SaveOrDeleteTaskUserFiles(taskUserFiles);  // save task files
                    }
                }
            }
            return true;
        }

        [WebMethod(EnableSession = true)]
        public bool UpdateTaskTitleById(string tid, string title)
        {
            TaskGeneratorBLL.Instance.UpdateTaskTitleById(tid, title);
            return true;
        }

        [WebMethod(EnableSession = true)]
        public bool UpdateTaskSequence(Int64 Sequence, Int64 TaskID, Int32 DesignationID, bool IsTechTask)
        {
            TaskGeneratorBLL.Instance.UpdateTaskSequence(Sequence, TaskID, DesignationID, IsTechTask);
            return true;
        }

        [WebMethod(EnableSession = true)]
        public bool UpdateTaskURLById(string tid, string URL)
        {
            TaskGeneratorBLL.Instance.UpdateTaskURLById(tid, URL);
            return true;
        }

        [WebMethod(EnableSession = true)]
        public bool UpdateTaskDescriptionChildById(string tid, string Description)
        {
            TaskGeneratorBLL.Instance.UpdateTaskDescriptionChildById(tid, Description);
            return true;
        }

        [WebMethod(EnableSession = true)]
        public bool UpdateRomanTitle(string RomanId, string Title)
        {
            return TaskGeneratorBLL.Instance.UpdateRomanTitle(RomanId, Title) > 0;
        }

        [WebMethod(EnableSession = true)]
        public bool UpdateTaskDescriptionById(string tid, string Description)
        {
            TaskGeneratorBLL.Instance.UpdateTaskDescriptionById(tid, Description);
            return true;
        }

        [WebMethod(EnableSession = true)]
        public object AddNewSubTask(int ParentTaskId, String Title, String URL, String Desc, String Status, String Priority, String DueDate, String TaskHours, String InstallID, String Attachments, String TaskType, String TaskDesignations, int[] TaskAssignedUsers, string TaskLvl, bool blTechTask, Int64? Sequence)
        {
            return SaveSubTask(ParentTaskId, Title, URL, Desc, Status, Priority, DueDate, TaskHours, InstallID, Attachments, TaskType, TaskDesignations, TaskAssignedUsers, TaskLvl, blTechTask, Sequence);
        }

        [WebMethod]
        public string GetRootTasks(int ExcludedTaskId)
        {
            string strMessage = string.Empty;
            DataSet dtResult = null;

            dtResult = TaskGeneratorBLL.Instance.GetRootTasks(ExcludedTaskId);

            if (dtResult != null && dtResult.Tables.Count > 0)
            {
                dtResult.DataSetName = "TasksDataSet";
                dtResult.Tables[0].TableName = "Tasks";
                System.Xml.XmlDocument doc = new System.Xml.XmlDocument();
                doc.LoadXml(dtResult.GetXml());
                strMessage = JsonConvert.SerializeXmlNode(doc);
            }
            else
            {
                strMessage = String.Empty;
            }
            return strMessage;
        }

        [WebMethod]
        public string GetChildTasks(int ParentTaskId)
        {
            string strMessage = string.Empty;
            DataSet dtResult = null;

            dtResult = TaskGeneratorBLL.Instance.GetChildTasks(ParentTaskId);

            if (dtResult != null && dtResult.Tables.Count > 0)
            {
                dtResult.DataSetName = "TasksDataSet";
                dtResult.Tables[0].TableName = "Tasks";
                System.Xml.XmlDocument doc = new System.Xml.XmlDocument();
                doc.LoadXml(dtResult.GetXml());
                strMessage = JsonConvert.SerializeXmlNode(doc);
            }
            else
            {
                strMessage = String.Empty;
            }
            return strMessage;
        }

        [WebMethod(EnableSession = true)]
        public object GetSubTaskListId(string CommandArgument, string CommandName)
        {
            char[] delimiterChars = { '#' };
            string[] TaskLvlandInstallId = CommandName.Split(delimiterChars);

            string listIDOpt = string.Empty;
            string txtInstallId = string.Empty;
            string hdTaskLvl = TaskLvlandInstallId[0];
            string hdParentTaskId = TaskLvlandInstallId[2];
            string hdnCurrentEditingRow = TaskLvlandInstallId[3];


            Task objTask = new Task();
            DataSet result = new DataSet();
            string vInstallId = TaskLvlandInstallId[1];
            result = TaskGeneratorBLL.Instance.GetTaskByMaxId(TaskLvlandInstallId[2], 1);
            if (result.Tables[0].Rows.Count > 0)
            {
                vInstallId = result.Tables[0].Rows[0]["InstallId"].ToString();
            }
            string[] subtaskListIDSuggestion = getSUBSubtaskSequencing(vInstallId);
            if (subtaskListIDSuggestion.Length > 0)
            {
                if (subtaskListIDSuggestion.Length > 1)
                {
                    if (String.IsNullOrEmpty(subtaskListIDSuggestion[1]))
                    {
                        txtInstallId = subtaskListIDSuggestion[0];
                    }
                    else
                    {
                        txtInstallId = subtaskListIDSuggestion[1];
                    }
                }
                else
                {
                    txtInstallId = subtaskListIDSuggestion[0];
                }
            }


            var obj = new
            {
                hdTaskLvl = hdTaskLvl,
                hdParentTaskId = hdParentTaskId,
                txtInstallId = txtInstallId
            };

            return obj;
        }

        [WebMethod(EnableSession = true)]
        public object GetSubTaskId(string CommandArgument, string CommandName)
        {
            char[] delimiterChars = { '#' };
            string[] TaskLvlandInstallId = CommandName.Split(delimiterChars);

            string listIDOpt = string.Empty;
            string txtInstallId = string.Empty;
            string hdTaskLvl = TaskLvlandInstallId[0];
            string hdParentTaskId = TaskLvlandInstallId[2];
            string hdnCurrentEditingRow = TaskLvlandInstallId[3];

            if (TaskLvlandInstallId[0] == "2")
            {
                Task objTask = new Task();
                DataSet result = new DataSet();
                string vInstallId = TaskLvlandInstallId[1];
                result = TaskGeneratorBLL.Instance.GetTaskByMaxId(TaskLvlandInstallId[2], 2);
                if (result.Tables[0].Rows.Count > 0)
                {
                    vInstallId = result.Tables[0].Rows[0]["InstallId"].ToString();
                }
                string[] subtaskListIDSuggestion = getSUBSubtaskSequencing(vInstallId);
                if (subtaskListIDSuggestion.Length > 0)
                {
                    if (subtaskListIDSuggestion.Length > 1)
                    {
                        if (String.IsNullOrEmpty(subtaskListIDSuggestion[1]))
                        {
                            txtInstallId = subtaskListIDSuggestion[0];
                        }
                        else
                        {
                            txtInstallId = subtaskListIDSuggestion[1];
                        }
                    }
                    else
                    {
                        txtInstallId = subtaskListIDSuggestion[0];
                    }
                }
            }
            else
            {

                string[] roman4 = { "i", "ii", "iii", "iv", "v", "vi", "vii", "viii", "ix", "x", "xi", "xii", "xiii", "xiv", "xv", "xvi", "xvii", "xviii", "xix", "xx" };
                DataSet result = new DataSet();
                result = TaskGeneratorBLL.Instance.GetTaskByMaxId(TaskLvlandInstallId[2], short.Parse(hdTaskLvl));
                string vNextInstallId = "";
                if (result.Tables[0].Rows.Count > 0)
                {
                    string vInstallId = result.Tables[0].Rows[0]["InstallId"].ToString();

                    int cnt = -1;
                    for (int i = 0; i < roman4.Length; i++)
                    {
                        if (vInstallId == roman4[i])
                        {
                            cnt = i + 1;
                        }

                        if (cnt == i)
                        {
                            vNextInstallId = roman4[i];
                            break;
                        }
                    }
                }
                else { vNextInstallId = roman4[0]; }
                txtInstallId = vNextInstallId;
                result.Dispose();
            }


            var obj = new
            {
                hdTaskLvl = hdTaskLvl,
                hdParentTaskId = hdParentTaskId,
                txtInstallId = txtInstallId
            };

            return obj;
        }

        [WebMethod(EnableSession = true)]

        public bool SetTaskPriority(string taskid, string priority)
        {
            Task objTask = new Task();
            objTask.TaskId = Convert.ToInt32(taskid);
            if (taskid == "0")
            {
                objTask.TaskPriority = null;
            }
            else
            {
                objTask.TaskPriority = Convert.ToByte(priority);
            }
            TaskGeneratorBLL.Instance.UpdateTaskPriority(objTask);

            return true;
        }

        [WebMethod(EnableSession = true)]
        public object ValidateTaskStatus(Int32 intTaskId, int intTaskStatus, int[] arrAssignedUsers)
        {
            bool blResult = true;

            string strMessage = string.Empty;

            //if (
            //    strStatus != Convert.ToByte(JGConstant.TaskStatus.SpecsInProgress).ToString() &&
            //    !TaskGeneratorBLL.Instance.IsTaskWorkSpecificationApproved(intTaskId)
            //   )
            //{
            //    blResult = false;
            //    strMessage = "Task work specifications must be approved, to change status from Specs In Progress.";
            //}
            //else
            // if task is in assigned status. it should have assigned user selected there in dropdown. 
            if (intTaskStatus == Convert.ToByte(JGConstant.TaskStatus.Assigned))
            {
                blResult = false;
                strMessage = "Task must be assigned to one or more users, to change status to assigned.";

                blResult = arrAssignedUsers.Length > 0;
            }

            var result = new
            {
                IsValid = blResult,
                Message = strMessage
            };

            return result;
        }

        [WebMethod(EnableSession = true)]
        public string GetLatestTaskSequence(Int32 DesignationId, bool IsTechTask)
        {
            string strMessage = string.Empty;
            DataSet dtResult = TaskGeneratorBLL.Instance.GetLatestTaskSequence(DesignationId, IsTechTask);
            if (dtResult != null)
            {
                strMessage = JsonConvert.SerializeObject(dtResult, Formatting.Indented);
            }
            else
            {
                strMessage = String.Empty;
            }
            return strMessage;
        }

        [WebMethod(EnableSession = true)]
        public bool DeleteTaskSequence(Int64 TaskId)
        {
            Boolean blnReturnResult = TaskGeneratorBLL.Instance.DeleteTaskSequence(TaskId);

            return blnReturnResult;
        }

        [WebMethod(EnableSession = true)]
        public bool MoveTask(int TaskId, int FromTaskId, int ToTaskId)
        {
            Boolean blnReturnResult = TaskGeneratorBLL.Instance.MoveTask(TaskId, FromTaskId, ToTaskId);

            return blnReturnResult;
        }

        [WebMethod(EnableSession = true)]
        public bool DeleteTaskSubSequence(Int64 TaskId)
        {
            Boolean blnReturnResult = TaskGeneratorBLL.Instance.DeleteTaskSubSequence(TaskId);

            return blnReturnResult;
        }

        [WebMethod(EnableSession = true)]
        public string GetAssignUsers(string TaskDesignations)
        {
            if (TaskDesignations == "")
            {
                if (!CommonFunction.CheckAdminAndItLeadMode())
                {
                    TaskDesignations = Session["DesignationId"].ToString();
                }
                else
                {
                    TaskDesignations = string.Join(",", TaskGeneratorBLL.Instance.GetAllActiveDesignation().Select(x => x.ID));
                    //TaskDesignations = "1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24";
                }
            }

            // As subtasks are not having any seperate designations other than Parent task, not need to fecth users every time.
            DataSet dsUsers = TaskGeneratorBLL.Instance.GetInstallUsers(2, TaskDesignations);
            string strMessage;

            if (dsUsers != null && dsUsers.Tables.Count > 0)
            {


                DataTable dtUsers = CommonFunction.ApplyColorCodeToAssignUserDataTable(dsUsers.Tables[0]);

                dtUsers.TableName = "AssignedUsers";

                strMessage = JsonConvert.SerializeObject(dtUsers, Formatting.Indented);
            }
            else
            {
                strMessage = String.Empty;
            }
            return strMessage;
        }



        [WebMethod(EnableSession = true)]
        public String GetAllClosedTasks(int page, int pageSize, String DesignationIDs, string userid, string TaskUserStatus, string vSearch)
        {
            string strMessage = string.Empty;
            DataSet dtResult = null;
            if (!CommonFunction.CheckAdminAndItLeadMode())
            {
                int UserId = 0;
                Int32.TryParse(JGSession.LoginUserID, out UserId);
                userid = UserId.ToString();
            }
            else
            {
                //Extract Selected Task & User Status
                TaskUserStatus = GenerateStatusCodes(TaskUserStatus, true, false);
            }



            dtResult = TaskGeneratorBLL.Instance.GetClosedTasks(userid, DesignationIDs, TaskUserStatus, vSearch, page, pageSize);

            if (dtResult != null && dtResult.Tables.Count > 0)
            {
                dtResult.DataSetName = "TasksData";
                dtResult.Tables[0].TableName = "Tasks";
                dtResult.Tables[1].TableName = "RecordCount";
                System.Xml.XmlDocument doc = new System.Xml.XmlDocument();
                doc.LoadXml(dtResult.GetXml());
                strMessage = JsonConvert.SerializeXmlNode(doc);//.Replace("null", "\"\"").Replace("'", "\'");
            }
            else
            {
                strMessage = String.Empty;
            }
            return strMessage;
        }

        [WebMethod(EnableSession = true)]
        public String GetMultilevelChildren(string ParentTaskId)
        {
            string strMessage = string.Empty;
            DataSet dtResult = null;

            dtResult = TaskGeneratorBLL.Instance.GetMultilevelChildren(ParentTaskId);

            if (dtResult != null && dtResult.Tables.Count > 0)
            {
                dtResult.DataSetName = "ChildrenData";
                dtResult.Tables[0].TableName = "Children";
                System.Xml.XmlDocument doc = new System.Xml.XmlDocument();
                doc.LoadXml(dtResult.GetXml());
                strMessage = JsonConvert.SerializeXmlNode(doc);//.Replace("null", "\"\"").Replace("'", "\'");
            }
            else
            {
                strMessage = String.Empty;
            }
            return strMessage;
        }

        [WebMethod(EnableSession = true)]
        public String GetSubTasks(Int32 TaskId, string strSortExpression, string vsearch = "", Int32? intPageIndex = 0, Int32? intPageSize = 0, int intHighlightTaskId = 0)
        {
            DataSet dtResult = null;
            String strMessage = string.Empty;
            dtResult = TaskGeneratorBLL.Instance.GetSubTasks
                                                (
                                                    TaskId,
                                                    CommonFunction.CheckAdminAndItLeadMode(),
                                                    strSortExpression,
                                                    vsearch,
                                                    intPageIndex,
                                                    intPageSize,
                                                    intHighlightTaskId
                                                );
            //Convert UTC to EST
            foreach (DataRow row in dtResult.Tables[3].Rows)
            {
                if (row["UpdatedOn"] != null && row["UpdatedOn"].ToString() != "")
                {
                    row["UpdatedOn"] = string.Format("{0:MM/dd/yyyy hh:mm tt}", Convert.ToDateTime(row["UpdatedOn"].ToString()).ToEST());
                }
            }

            dtResult.Tables[0].Columns.Add("className");

            DataTable copyTable = dtResult.Tables[0].Clone();
            copyTable.TableName = "Tasks";

            bool isFirstRow = true;

            foreach (DataRow row in dtResult.Tables[0].Select("NestLevel=1", "TaskId ASC"))
            {
                string tid = row[0].ToString();
                string className = isFirstRow ? "FirstRow" : "AlternateRow";
                row["className"] = className;

                //Toggle ClassName
                isFirstRow = !isFirstRow;

                //Add Parent
                DataRow dr = copyTable.NewRow();
                copyTable.ImportRow(row);

                DataRow[] rows = dtResult.Tables[0].Select("ParentTaskId=" + tid, "TaskId ASC");
                foreach (DataRow r in rows)
                {
                    string tid2 = r[0].ToString();

                    //Add Level 2 Child
                    DataRow dr1 = copyTable.NewRow();
                    r["className"] = className;
                    copyTable.ImportRow(r);

                    DataRow[] r3 = dtResult.Tables[0].Select("ParentTaskId=" + tid2, "TaskId ASC");
                    foreach (DataRow r2 in r3)
                    {
                        //Add Level 3 Child
                        DataRow dr3 = copyTable.NewRow();
                        r2["className"] = className;
                        copyTable.ImportRow(r2);
                    }
                }
            }



            dtResult.Tables.Add(copyTable);
            if (dtResult != null && dtResult.Tables.Count > 0)
            {
                #region Get Next Install ID
                if (dtResult.Tables[4].Rows.Count > 0)
                {
                    string[] subtaskListIDSuggestion = CommonFunction.getSubtaskSequencing(dtResult.Tables[4].Rows[0][0].ToString());
                    if (subtaskListIDSuggestion.Length > 0)
                    {
                        dtResult.Tables[4].Rows[0][0] = subtaskListIDSuggestion[0];
                    }
                }
                else
                {
                    //dtResult.Tables[4].Rows[0][0] = "I";
                }
                #endregion

                //dtResult.Tables[4].TableName = "Tasks";
                dtResult.Tables[1].TableName = "RecordCount";
                dtResult.Tables[2].TableName = "Pages";
                dtResult.Tables[3].TableName = "TaskFiles";
                dtResult.DataSetName = "TaskData";

                System.Xml.XmlDocument doc = new System.Xml.XmlDocument();
                doc.LoadXml(dtResult.GetXml());
                strMessage = JsonConvert.SerializeXmlNode(doc);//.Replace("null", "\"\"").Replace("'", "\'");
            }

            return strMessage;
        }

        [WebMethod(EnableSession = true)]
        public String GetAllTasksWithPaging(int? page, int? pageSize, String DesignationIDs, bool IsTechTask, Int64 HighlightedTaskID, string UserId, bool ForDashboard, string TaskUserStatus, string StartDate, string EndDate, bool ForInProgress)
        {
            string strMessage = string.Empty;
            DataSet dtResult = null;
            if (UserId.Equals("0"))
                UserId = "";

            //Extract Selected Task & User Status
            TaskUserStatus = GenerateStatusCodes(TaskUserStatus, !ForInProgress, false);

            if (ForDashboard)
            {
                if (!CommonFunction.CheckAdminAndItLeadMode() && UserId == "")
                {
                    UserId = JGSession.LoginUserID;
                    dtResult = TaskGeneratorBLL.Instance.GetAllInProAssReqUserTaskWithSequence(page == null ? 0 : Convert.ToInt32(page), pageSize == null ? 1000 : Convert.ToInt32(pageSize), Session["UserStatus"].Equals(JGConstant.InstallUserStatus.InterviewDate) ? true : false, UserId, false, StartDate, EndDate, ForInProgress);
                }
                else
                {
                    dtResult = TaskGeneratorBLL.Instance.GetAllInProAssReqTaskWithSequence(page == null ? 0 : Convert.ToInt32(page), pageSize == null ? 1000 : Convert.ToInt32(pageSize), DesignationIDs, TaskUserStatus, UserId, StartDate, EndDate, ForInProgress);
                }
            }

            else
            {
                dtResult = TaskGeneratorBLL.Instance.GetAllTaskWithSequence(page == null ? 0 : Convert.ToInt32(page), pageSize == null ? 1000 : Convert.ToInt32(pageSize), DesignationIDs, IsTechTask, HighlightedTaskID);
            }

            if (dtResult != null && dtResult.Tables.Count > 0)
            {
                //Context.Response.Clear();
                //Context.Response.ContentType = "application/json";
                //Context.Response.Write(JsonConvert.SerializeObject(dtResult, Formatting.Indented));
                dtResult.Tables[0].TableName = "Tasks";
                dtResult.Tables[1].TableName = "SubSeqTasks";
                dtResult.Tables[2].TableName = "RecordCount";
                if (dtResult.Tables.Count == 4)
                    dtResult.Tables[3].TableName = "Hours";

                DataColumn[] SeqCols = new DataColumn[] { dtResult.Tables["Tasks"].Columns["Sequence"], dtResult.Tables["Tasks"].Columns["SequenceDesignationId"], dtResult.Tables["Tasks"].Columns["IsTechTask"] };
                DataColumn[] SubSeqCols = new DataColumn[] { dtResult.Tables["SubSeqTasks"].Columns["Sequence"], dtResult.Tables["SubSeqTasks"].Columns["SequenceDesignationId"], dtResult.Tables["SubSeqTasks"].Columns["IsTechTask"] };


                //DataRelation relation = dtResult.Relations.Add("relation", dtResult.Tables["Tasks"].Columns["Sequence"], dtResult.Tables["SubSeqTasks"].Columns["Sequence"]);
                DataRelation relation = dtResult.Relations.Add("relation", SeqCols, SubSeqCols);
                relation.Nested = true;
                dtResult.DataSetName = "TasksData";

                System.Xml.XmlDocument doc = new System.Xml.XmlDocument();
                doc.LoadXml(dtResult.GetXml());
                strMessage = JsonConvert.SerializeXmlNode(doc);//.Replace("null", "\"\"").Replace("'", "\'");


                //strMessage = JsonConvert.SerializeObject(dtResult, Formatting.Indented);

            }
            else
            {
                strMessage = String.Empty;
            }
            return strMessage;
        }

        private static string GenerateStatusCodes(string TaskUserStatus, bool ForClosedGrid, bool ForCalendar)
        {
            string UserStatus = "";
            string TaskStatus = "";
            foreach (string value in TaskUserStatus.Split(",".ToCharArray()))
            {
                if (value.StartsWith("U"))
                {
                    UserStatus += value.TrimStart("U".ToCharArray()) + ",";
                }
                else if (value.StartsWith("T"))
                {
                    if (ForClosedGrid)
                    {
                        if (!"1,2,3,4,8".ToString().Contains(value.TrimStart("T".ToCharArray())))
                        {
                            TaskStatus += value.TrimStart("T".ToCharArray()) + ",";
                        }
                    }
                    else if (ForCalendar)
                    {
                        TaskStatus += value.TrimStart("T".ToCharArray()) + ",";
                    }
                    else
                    {
                        if ("1,2,3,4,8".ToString().Contains(value.TrimStart("T".ToCharArray())))
                        {
                            TaskStatus += value.TrimStart("T".ToCharArray()) + ",";
                        }
                    }

                }
            }
            TaskStatus = TaskStatus.TrimEnd(",".ToCharArray());
            UserStatus = UserStatus.TrimEnd(",".ToCharArray());

            TaskUserStatus = TaskStatus + ":" + UserStatus;
            return TaskUserStatus;
        }

        [WebMethod(EnableSession = true)]
        public String GetAllFrozenTasksWithPaging(int? page, int? pageSize, String DesignationIDs, string UserId, bool IsTechTask)
        {
            string strMessage = string.Empty;
            DataSet dtResult = null;

            if (UserId == "0")
                dtResult = TaskGeneratorBLL.Instance.GetAllPartialFrozenTaskWithSequence(page == null ? 0 : Convert.ToInt32(page), pageSize == null ? 1000 : Convert.ToInt32(pageSize), DesignationIDs, IsTechTask);
            else
                dtResult = TaskGeneratorBLL.Instance.GetAllPartialFrozenUserTaskWithSequence(page == null ? 0 : Convert.ToInt32(page), pageSize == null ? 1000 : Convert.ToInt32(pageSize), IsTechTask, UserId);


            if (dtResult != null && dtResult.Tables.Count > 0)
            {
                //Context.Response.Clear();
                //Context.Response.ContentType = "application/json";
                //Context.Response.Write(JsonConvert.SerializeObject(dtResult, Formatting.Indented));
                dtResult.Tables[0].TableName = "Tasks";
                dtResult.Tables[1].TableName = "SubSeqTasks";
                dtResult.Tables[2].TableName = "RecordCount";

                DataColumn[] SeqCols = new DataColumn[] { dtResult.Tables["Tasks"].Columns["Sequence"], dtResult.Tables["Tasks"].Columns["SequenceDesignationId"] };
                DataColumn[] SubSeqCols = new DataColumn[] { dtResult.Tables["SubSeqTasks"].Columns["Sequence"], dtResult.Tables["SubSeqTasks"].Columns["SequenceDesignationId"] };
                DataRelation relation = dtResult.Relations.Add("relation", SeqCols, SubSeqCols);
                relation.Nested = true;
                dtResult.DataSetName = "TasksData";

                System.Xml.XmlDocument doc = new System.Xml.XmlDocument();
                doc.LoadXml(dtResult.GetXml());
                strMessage = JsonConvert.SerializeXmlNode(doc);//.Replace("null", "\"\"").Replace("'", "\'");


                //strMessage = JsonConvert.SerializeObject(dtResult, Formatting.Indented);

            }
            else
            {
                strMessage = String.Empty;
            }
            return strMessage;
        }

        [WebMethod(EnableSession = true)]
        public String GetAllNonFrozenTasksWithPaging(int? page, int? pageSize, String DesignationIDs, string UserId, bool IsTechTask)
        {
            string strMessage = string.Empty;
            DataSet dtResult = null;

            if (UserId == "0")
                dtResult = TaskGeneratorBLL.Instance.GetAllNonFrozenTaskWithSequence(page == null ? 0 : Convert.ToInt32(page), pageSize == null ? 1000 : Convert.ToInt32(pageSize), DesignationIDs, IsTechTask);
            else
                dtResult = TaskGeneratorBLL.Instance.GetAllNonFrozenUserTaskWithSequence(page == null ? 0 : Convert.ToInt32(page), pageSize == null ? 1000 : Convert.ToInt32(pageSize), IsTechTask, UserId);


            if (dtResult != null && dtResult.Tables.Count > 0)
            {
                //Context.Response.Clear();
                //Context.Response.ContentType = "application/json";
                //Context.Response.Write(JsonConvert.SerializeObject(dtResult, Formatting.Indented));
                dtResult.Tables[0].TableName = "Tasks";
                dtResult.Tables[1].TableName = "SubSeqTasks";
                dtResult.Tables[2].TableName = "RecordCount";

                DataColumn[] SeqCols = new DataColumn[] { dtResult.Tables["Tasks"].Columns["Sequence"], dtResult.Tables["Tasks"].Columns["SequenceDesignationId"] };
                DataColumn[] SubSeqCols = new DataColumn[] { dtResult.Tables["SubSeqTasks"].Columns["Sequence"], dtResult.Tables["SubSeqTasks"].Columns["SequenceDesignationId"] };
                DataRelation relation = dtResult.Relations.Add("relation", SeqCols, SubSeqCols);
                relation.Nested = true;
                dtResult.DataSetName = "TasksData";

                System.Xml.XmlDocument doc = new System.Xml.XmlDocument();
                doc.LoadXml(dtResult.GetXml());
                strMessage = JsonConvert.SerializeXmlNode(doc);//.Replace("null", "\"\"").Replace("'", "\'");


                //strMessage = JsonConvert.SerializeObject(dtResult, Formatting.Indented);

            }
            else
            {
                strMessage = String.Empty;
            }
            return strMessage;
        }


        [WebMethod(EnableSession = true)]
        public String GetAllTasksforSubSequencing(Int32 DesignationId, String DesiSeqCode, bool IsTechTask, Int64 TaskId)
        {
            string strMessage = string.Empty;
            DataSet dtResult = TaskGeneratorBLL.Instance.GetAllTasksforSubSequencing(DesignationId, DesiSeqCode, IsTechTask, TaskId);

            if (dtResult != null && dtResult.Tables.Count > 0)
            {
                //Context.Response.Clear();
                //Context.Response.ContentType = "application/json";
                //Context.Response.Write(JsonConvert.SerializeObject(dtResult, Formatting.Indented));
                dtResult.Tables[0].TableName = "Tasks";


                strMessage = JsonConvert.SerializeObject(dtResult, Formatting.Indented);

            }
            else
            {
                strMessage = String.Empty;
            }
            return strMessage;
        }


        [WebMethod(EnableSession = true)]
        public bool UpdateTaskSubSequence(Int64 TaskID, Int64 TaskIdSeq, Int64 SubSeqTaskId, Int64 DesignationId)
        {
            string strMessage = string.Empty;
            bool Result = TaskGeneratorBLL.Instance.UpdateTaskSubSequence(TaskID, TaskIdSeq, SubSeqTaskId, DesignationId);

            return Result;

        }

        [WebMethod(EnableSession = true)]
        public bool SaveAssignedTaskUsers(Int32 intTaskId, int intTaskStatus, int[] arrAssignedUsers, int[] arrDesignationUsers)
        {
            JGConstant.TaskStatus objTaskStatus = (JGConstant.TaskStatus)intTaskStatus;

            //if task id is available to save its note and attachement.
            if (intTaskId != 0)
            {
                string strUsersIds = string.Join(",", arrAssignedUsers);

                // save (insert / delete) assigned users.
                bool isSuccessful = TaskGeneratorBLL.Instance.SaveTaskAssignedUsers(Convert.ToUInt64(intTaskId), strUsersIds);

                // send email to selected users.
                if (strUsersIds.Length > 0)
                {
                    if (isSuccessful)
                    {
                        // Change task status to assigned = 3.
                        if (objTaskStatus == JGConstant.TaskStatus.Open || objTaskStatus == JGConstant.TaskStatus.Requested)
                        {
                            TaskGeneratorBLL.Instance.UpdateTaskStatus
                                            (
                                                new Task()
                                                {
                                                    TaskId = intTaskId,
                                                    Status = Convert.ToUInt16(JGConstant.TaskStatus.Assigned)
                                                }
                                            );
                        }

                        SendEmailToAssignedUsers(intTaskId, strUsersIds);
                    }
                }
                else // if all users are removed, then set task status to open.
                {
                    TaskGeneratorBLL.Instance.UpdateTaskStatus
                                            (
                                                new Task()
                                                {
                                                    TaskId = intTaskId,
                                                    Status = Convert.ToUInt16(JGConstant.TaskStatus.Open)
                                                }
                                            );
                }
                // send email to all users of the department as task is assigned to designation, but not to any specific user.
                //else
                //{
                //    string strUserIDs = string.Join(",", arrDesignationUsers);

                //    SendEmailToAssignedUsers(intTaskId, strUserIDs.TrimEnd(','));
                //}
            }
            return true;
        }

        [WebMethod(EnableSession = true)]
        public bool SaveAssignedTaskUsersRoman(Int32 RomanId, int[] UserIds)
        {
            string strUsersIds = UserIds != null ? string.Join(",", UserIds) : "";
            bool isSuccessful = TaskGeneratorBLL.Instance.SaveTaskAssignedUsersRoman(Convert.ToUInt64(RomanId), strUsersIds);

            return true;
        }

        [WebMethod(EnableSession = true)]
        public bool SaveTaskQuery(int TaskId, string QueryDesc, int QueryTypeId)
        {
            int QueryStatusId = 1;//Default Raised
            int CreatedById = 0;
            int uid = 0;
            Int32.TryParse(JGSession.LoginUserID, out uid);
            CreatedById = uid;

            bool isSuccessful = TaskGeneratorBLL.Instance.SaveTaskQuery(TaskId, QueryDesc, QueryTypeId, QueryStatusId, CreatedById);
            return isSuccessful;
        }

        [WebMethod(EnableSession = true)]
        public bool SetTaskStatus(int intTaskId, string TaskStatus)
        {
            return TaskGeneratorBLL.Instance.SetTaskStatus(intTaskId, TaskStatus);
        }

        [WebMethod(EnableSession = true)]
        public bool SetRomanTaskStatus(int TaskId, int TaskStatus)
        {
            return TaskGeneratorBLL.Instance.SetRomanTaskStatus(TaskId, TaskStatus);
        }

        [WebMethod(EnableSession = true)]
        public bool SetTaskType(int intTaskId, string TaskType)
        {
            return TaskGeneratorBLL.Instance.UpdateTaskTechTask(intTaskId, bool.Parse(TaskType));
        }

        [WebMethod(EnableSession = true)]
        public bool SetReassignableTaskType(int intTaskId, string TaskType)
        {
            return TaskGeneratorBLL.Instance.UpdateTaskReassignable(intTaskId, bool.Parse(TaskType));
        }


        [WebMethod(EnableSession = true)]
        public bool SaveTaskMultiLevelChild(int ParentTaskId, string InstallId, string Title, string Description, int IndentLevel, string Class)
        {
            return TaskGeneratorBLL.Instance.SaveTaskMultiLevelChild(ParentTaskId, InstallId, Title, Description, IndentLevel, Class, Convert.ToInt16(Session[SessionKey.Key.UserId.ToString()]));
        }

        [WebMethod(EnableSession = true)]
        public bool TaskSwapSequence(Int64 FirstSequenceId, Int64 SecondSequenceId, Int64 FirstTaskId, Int64 SecondTaskId)
        {
            return TaskGeneratorBLL.Instance.TaskSwapSequence(FirstSequenceId, SecondSequenceId, FirstTaskId, SecondTaskId);
        }

        [WebMethod(EnableSession = true)]
        public bool TaskSwapSubSequence(Int64 FirstSequenceId, Int64 SecondSequenceId, Int64 FirstTaskId, Int64 SecondTaskId)
        {
            return TaskGeneratorBLL.Instance.TaskSwapSubSequence(FirstSequenceId, SecondSequenceId, FirstTaskId, SecondTaskId);
        }

        [WebMethod(EnableSession = true)]
        public bool TaskSwapRoman(Int64 FirstRomanId, Int64 SecondRomanId)
        {
            return TaskGeneratorBLL.Instance.TaskSwapRoman(FirstRomanId, SecondRomanId);
        }

        [WebMethod(EnableSession = true)]
        public bool HardDeleteTask(Int64 TaskId)
        {
            String filesToDelete = TaskGeneratorBLL.Instance.HardDeleteTask(TaskId);

            if (!String.IsNullOrEmpty(filesToDelete))
            {
                DeleteTaskFiles(filesToDelete);
            }

            return true;

        }

        //Remove all file related attachments from file system of server.
        private void DeleteTaskFiles(string filesToDelete)
        {
            // Seperate each file name to delete.
            String[] files = filesToDelete.Split(new char[] { ',' }, StringSplitOptions.RemoveEmptyEntries);

            foreach (String fileName in files) // Remove each files.
            {
                String filePath = Server.MapPath(String.Concat("~/TaskAttachments/", fileName));// Map physical path on server.

                if (File.Exists(filePath))
                {
                    try
                    {
                        File.Delete(filePath);// Remove file from server.
                    }
                    catch (Exception ex)
                    {

                    }

                }

            }
        }

        [WebMethod(EnableSession = true)]
        public String GetFreezedRomanData(long RomanId)
        {
            string strMessage = string.Empty;
            DataSet dtResult = null;

            dtResult = TaskGeneratorBLL.Instance.GetFreezedRomanData(RomanId);

            if (dtResult != null && dtResult.Tables.Count > 0)
            {
                dtResult.DataSetName = "RomanData";
                dtResult.Tables[0].TableName = "Roman";
                strMessage = JsonConvert.SerializeObject(dtResult, Formatting.Indented);
            }
            else
            {
                strMessage = String.Empty;
            }
            return strMessage;
        }

        [WebMethod(EnableSession = true)]
        public String GetCalendarUsersByDate(string Date, string TaskUserStatus, string UserId)
        {
            string strMessage = string.Empty;
            DataSet dtResult = null;
            if (!CommonFunction.CheckAdminAndItLeadMode())
            {
                int uid = 0;
                Int32.TryParse(JGSession.LoginUserID, out uid);
                UserId = uid.ToString();
            }

            dtResult = TaskGeneratorBLL.Instance.GetCalendarUsersByDate(Date, TaskUserStatuses, UserId);

            if (dtResult != null && dtResult.Tables.Count > 0)
            {
                dtResult.DataSetName = "Events";
                dtResult.Tables[0].TableName = "Users";
                strMessage = JsonConvert.SerializeObject(dtResult, Formatting.Indented);
            }
            else
            {
                strMessage = String.Empty;
            }
            return strMessage;
        }

        [WebMethod(EnableSession = true)]
        public String GetCalendarTasksByDate(string StartDate, string EndDate, string UserId, String DesignationIDs, string TaskUserStatus)
        {
            string strMessage = string.Empty;
            DataSet dtResult = null;
            if (!CommonFunction.CheckAdminAndItLeadMode())
            {
                int uid = 0;
                Int32.TryParse(JGSession.LoginUserID, out uid);
                UserId = uid.ToString();
            }

            //Extract Selected Task & User Status
            TaskUserStatuses = GenerateStatusCodes(TaskUserStatus, false, true);

            dtResult = TaskGeneratorBLL.Instance.GetCalendarTasksByDate(StartDate, EndDate, UserId, DesignationIDs, TaskUserStatuses);

            if (dtResult != null && dtResult.Tables.Count > 0)
            {
                dtResult.DataSetName = "Events";
                dtResult.Tables[0].TableName = "AllEvents";
                strMessage = JsonConvert.SerializeObject(dtResult, Formatting.Indented);
            }
            else
            {
                strMessage = String.Empty;
            }
            return strMessage;
        }


        #endregion

        #region '--Private Methods--'

        [WebMethod(EnableSession = true)]
        public string QuickSaveInstallUsers(String FirstName, String NameMiddleInitial, String LastName, String Email, String Phone, String Zip, String DesignationText, Int32 DesignationId,
                                          String Status, String SourceText, String EmpType, String StartDate, String SalaryReq,
                                          String SourceUserId, Int32 PositionAppliedForDesignationId, Int32 SourceID, Int32 AddedByUserId,
                                          Boolean IsEmailContactPreference, Boolean IsCallContactPreference, Boolean IsTextContactPreference, Boolean IsMailContactPreference)
        {
            user objInstallUser = new user();

            objInstallUser.fristname = FirstName;
            objInstallUser.NameMiddleInitial = NameMiddleInitial;
            objInstallUser.lastname = LastName;
            objInstallUser.email = Email;
            objInstallUser.phone = Phone;
            objInstallUser.zip = Zip;
            objInstallUser.designation = DesignationText;
            objInstallUser.DesignationID = DesignationId;
            objInstallUser.status = Status;
            objInstallUser.Source = SourceText;
            objInstallUser.EmpType = EmpType;
            objInstallUser.StartDate = StartDate;
            objInstallUser.SalaryReq = SalaryReq;
            objInstallUser.SourceUser = SourceUserId;
            objInstallUser.PositionAppliedFor = PositionAppliedForDesignationId.ToString();
            objInstallUser.SourceId = SourceID;
            objInstallUser.AddedBy = AddedByUserId;
            objInstallUser.IsEmailContactPreference = IsEmailContactPreference;
            objInstallUser.IsCallContactPreference = IsCallContactPreference;
            objInstallUser.IsTextContactPreference = IsTextContactPreference;
            objInstallUser.IsMailContactPreference = IsMailContactPreference;


            Int32 Id = InstallUserBLL.Instance.QuickSaveInstallUser(objInstallUser);

            //update user install id.
            InstallUserBLL.Instance.SetUserDisplayID(Id, DesignationId.ToString(), "YES");


            return Id.ToString();
        }

        [WebMethod(EnableSession = true)]
        public string QuickSaveUserwithEmailOrPhone(String FirstName, String LastName, String Email, String Phone, Int32 AddedByUserId)
        {
            String returnString = string.Empty;

            user objInstallUser = new user();

            objInstallUser.fristname = FirstName;
            objInstallUser.lastname = LastName;
            objInstallUser.email = Email;
            objInstallUser.phone = Phone;
            //objInstallUser.designation = DesignationText;
            //objInstallUser.DesignationID = DesignationId;
            objInstallUser.AddedBy = AddedByUserId;
            objInstallUser.status = Convert.ToInt32(JGConstant.InstallUserStatus.Applicant).ToString();

            DataSet ds = InstallUserBLL.Instance.QuickSaveUserWithEmailorPhone(objInstallUser);

            if (ds != null && ds.Tables.Count > 0 && ds.Tables[0].Rows.Count > 0)
            {
                if (Convert.ToBoolean(ds.Tables[0].Rows[0]["PhoneExists"].ToString()) && Convert.ToBoolean(ds.Tables[0].Rows[0]["EmailExists"].ToString()))
                {
                    returnString = "Email and Phone number are already exists in database";
                }
                else if (Convert.ToBoolean(ds.Tables[0].Rows[0]["PhoneExists"].ToString()))
                {
                    returnString = "Phone number is already exists in database";
                }
                else if (Convert.ToBoolean(ds.Tables[0].Rows[0]["EmailExists"].ToString()))
                {
                    returnString = "Email is already exists in database";
                }
                else if (!Convert.ToBoolean(ds.Tables[0].Rows[0]["PhoneExists"].ToString()) && !Convert.ToBoolean(ds.Tables[0].Rows[0]["EmailExists"].ToString()) && String.IsNullOrEmpty(ds.Tables[0].Rows[0]["UserID"].ToString()))
                {
                    returnString = "User cannot be saved. Please try again.";
                }
                else
                {
                    returnString = "User saved successfully!";

                    SendPHPWelcomeEmail(Email, Phone);
                }
            }

            return returnString;
        }

        private void SendPHPWelcomeEmail(String UserEmailId, String PhoneNumber)
        {
            DataSet dsUser = InstallUserBLL.Instance.getInstallerUserDetailsByLoginId(String.IsNullOrEmpty(UserEmailId) == true ? PhoneNumber : UserEmailId);
            String FirstName = string.Empty, LastName = string.Empty, Designation = string.Empty, EmployeeType = string.Empty, UserEmail = String.Empty, DesignationID = String.Empty, Phone = String.Empty;

            if (dsUser.Tables.Count > 0 && dsUser.Tables[0].Rows.Count > 0)
            {
                FirstName = Convert.ToString(dsUser.Tables[0].Rows[0]["FristName"]);
                LastName = Convert.ToString(dsUser.Tables[0].Rows[0]["LastName"]);
                UserEmail = Convert.ToString(dsUser.Tables[0].Rows[0]["Email"]);
                Phone = Convert.ToString(dsUser.Tables[0].Rows[0]["Phone"]);
                DesignationID = "0";
                Designation = Convert.ToString(dsUser.Tables[0].Rows[0]["Designation"]);
            }

            SendHRWelcomeEmail(UserEmail, FirstName, LastName, Designation, Phone, Convert.ToInt32(DesignationID), HTMLTemplates.PHP_HR_Welcome_Auto_Email, null, "JMGC-PC");

        }

        private string[] getSUBSubtaskSequencing(string sequence)
        {
            String[] ReturnSequence = new String[2];

            String[] numbercomponents = sequence.Split(new char[] { '-' }, StringSplitOptions.RemoveEmptyEntries);


            //if no subtask sequence than start with roman number I.
            if (numbercomponents.Length == 0) // like number of subtask without alphabet I,II
            {
                int startSequence = 1;
                ReturnSequence[0] = ExtensionMethods.ToRoman(startSequence);
                ReturnSequence[1] = String.Concat(ReturnSequence[0], " - a"); // concat existing roman number with alphabet.

            }
            else if (numbercomponents.Length == 1) // like number of subtask without alphabet I,II
            {
                int startSequence = 1;
                ReturnSequence[0] = ExtensionMethods.ToRoman(startSequence);
                ReturnSequence[1] = String.Concat(sequence, " - a"); // concat existing roman number with alphabet.

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

        [WebMethod]
        public object DeleteSubTaskChild(int ChildId)
        {
            var result = new
            {
                Success = TaskGeneratorBLL.Instance.DeleteSubTaskChild(ChildId)
            };

            return result;
        }

        private object SaveSubTask(int ParentTaskId, String Title, String URL, String Desc, String Status, String Priority, String DueDate, String TaskHours, String InstallID, String Attachments, String TaskType, String TaskDesignations, int[] TaskAssignedUsers, string TaskLvl, bool blTechTask, Int64? Sequence)
        {
            bool blnReturnVal = false;
            Task objTask = null;

            objTask = new Task();
            objTask.Mode = 0;

            objTask.Title = Title;
            objTask.Url = URL;
            objTask.Description = Desc;
            objTask.IsTechTask = blTechTask;

            // Convert Task Status string to int, if invalid value passed, set it to default "Open" status
            int inttaskStatus = ParseTaskStatus(Status);

            objTask.Status = inttaskStatus;

            if (Priority.Equals("0"))
            {
                objTask.TaskPriority = null;
            }
            else
            {
                objTask.TaskPriority = ParseTaskPriority(Priority);
            }

            objTask.DueDate = DueDate;
            objTask.Hours = TaskHours;
            objTask.CreatedBy = Convert.ToInt16(Session[JG_Prospect.Common.SessionKey.Key.UserId.ToString()]);
            objTask.InstallId = InstallID.Trim();
            objTask.ParentTaskId = ParentTaskId;
            objTask.Attachment = Attachments;
            objTask.Sequence = Sequence;
            int maintaskid = Convert.ToInt32(Context.Request.QueryString["TaskId"]);

            if (!String.IsNullOrEmpty(TaskType))
            {
                objTask.TaskType = ParseTaskType(TaskType);
            }

            int TaskLevel = Convert.ToInt32(TaskLvl);

            // save task master details to database.
            long TaskId = TaskGeneratorBLL.Instance.SaveOrDeleteTask(objTask, TaskLevel, maintaskid);

            // If Task is saved successfully and its level 1 & 2 task then proceed further to save its related data like attachments and designations.
            if (TaskId > 0 && !String.IsNullOrEmpty(TaskDesignations) && !String.IsNullOrEmpty(TaskDesignations))
            {
                // save assgined designation.
                SaveTaskDesignations(TaskId, InstallID.Trim(), TaskDesignations);
                // save attached file by user to database.
                UploadUserAttachements(Convert.ToInt64(TaskId), Attachments, JGConstant.TaskFileDestination.SubTask);

                blnReturnVal = true;
            }
            if (TaskId > 0 && TaskAssignedUsers.Length > 0)
            {
                SaveAssignedTaskUsers(int.Parse(TaskId.ToString()), 1/*OpenStatus*/, TaskAssignedUsers, null);
            }
            if (TaskId > 0)
            {
                blnReturnVal = true;
            }
            var result = new
            {
                Success = blnReturnVal,
                TaskId = TaskId
            };

            return result;
        }

        /// <summary>
        /// Convert task status string to int constant to save in database.
        /// if no proper string sent for respective status constant it will default set as OPEN.
        /// </summary>
        /// <param name="TaskStatus"></param>
        /// <returns></returns>
        private static int ParseTaskStatus(string TaskStatus)
        {
            int inttaskStatus = 0;

            int.TryParse(TaskStatus, out inttaskStatus);

            inttaskStatus = (inttaskStatus > 0) == true ? inttaskStatus : Convert.ToInt32(JGConstant.TaskStatus.Open);
            return inttaskStatus;
        }

        /// <summary>
        ///  Convert task priority string to int constant to save in database.
        /// if no proper string sent for respective priority constant it will default set as LOW.
        /// </summary>
        /// <param name="TaskPriority"></param>
        /// <returns></returns>
        private static byte ParseTaskPriority(string TaskPriority)
        {
            byte inttaskPriority = 0;

            byte.TryParse(TaskPriority, out inttaskPriority);

            inttaskPriority = (inttaskPriority > 0) == true ? inttaskPriority : Convert.ToByte(JGConstant.TaskPriority.Low);

            return inttaskPriority;
        }

        /// <summary>
        ///  Convert task type string to int constant to save in database.
        /// if no proper string sent for respective task type constant it will default set as ENHANCEMENT.
        /// </summary>
        /// <param name="TaskType"></param>
        /// <returns></returns>
        private static Int16 ParseTaskType(string TaskType)
        {
            Int16 inttaskType = 0;

            Int16.TryParse(TaskType, out inttaskType);

            inttaskType = (inttaskType > 0) == true ? inttaskType : Convert.ToByte(JGConstant.TaskType.Enhancement);

            return inttaskType;
        }

        private void SaveTaskDesignations(long TaskId, String InstallID, String SubTaskDesignations)
        {
            //if task id is available to save its note and attachement.
            if (!string.IsNullOrEmpty(SubTaskDesignations))
            {

                int indexofComma = SubTaskDesignations.IndexOf(',');
                int copyTill = indexofComma > 0 ? indexofComma : SubTaskDesignations.Length;

                //string designationcode = GetInstallIdFromDesignation(designations.Substring(0, copyTill));
                string designationcode = InstallID;

                TaskGeneratorBLL.Instance.SaveTaskDesignations(Convert.ToUInt64(TaskId), SubTaskDesignations, designationcode);

            }
        }

        private static void UploadUserAttachements(long TaskId, string attachments, JG_Prospect.Common.JGConstant.TaskFileDestination objTaskFileDestination)
        {
            //User has attached file than save it to database.
            if (!String.IsNullOrEmpty(attachments))
            {
                TaskUser taskUserFiles = new TaskUser();

                if (!string.IsNullOrEmpty(attachments))
                {
                    String[] files = attachments.Split(new char[] { '^' }, StringSplitOptions.RemoveEmptyEntries);

                    foreach (String attachment in files)
                    {
                        String[] attachements = attachment.Split('@');

                        taskUserFiles.Attachment = attachements[0];
                        taskUserFiles.OriginalFileName = attachements[1];
                        taskUserFiles.Mode = 0; // insert data.
                        taskUserFiles.TaskId = TaskId;
                        taskUserFiles.UserId = Convert.ToInt32(HttpContext.Current.Session[JG_Prospect.Common.SessionKey.Key.UserId.ToString()]);
                        taskUserFiles.TaskUpdateId = null;
                        taskUserFiles.UserType = JGSession.IsInstallUser ?? false;
                        taskUserFiles.TaskFileDestination = objTaskFileDestination;
                        TaskGeneratorBLL.Instance.SaveOrDeleteTaskUserFiles(taskUserFiles);  // save task files
                    }
                }
            }
        }

        private void SendEmailToAssignedUsers(int intTaskId, string strInstallUserIDs)
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
                    string strTaskLinkTitle = CommonFunction.GetTaskLinkTitleForAutoEmail(intTaskId);

                    strBody = strBody.Replace("#Fname#", fullname);
                    strBody = strBody.Replace("#TaskLink#", string.Format("{0}/sr_app/TaskGenerator.aspx?TaskId={1}&{2}", JGApplicationInfo.GetSiteURL(), intTaskId, strTaskLinkTitle));


                    strBody = strBody.Replace("#TaskTitle#", string.Format("{0}/sr_app/TaskGenerator.aspx?TaskId={1}", JGApplicationInfo.GetSiteURL(), intTaskId));
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

            }
        }


        #endregion

        #region "-- PayRates --"
        [WebMethod(EnableSession = true)]
        public bool AddDesignationPayRate(int DesignationId, int EmpType, Decimal BaseRate, Decimal DisplayRate, String DisplayCurrencyCode)
        {
            int CreatedByUserId = Convert.ToInt32(Session[JG_Prospect.Common.SessionKey.Key.UserId.ToString()]);

            bool returnVal = true;
            PayRateBLL.Instance.AddDesignationPayRate(DesignationId, EmpType, BaseRate, DisplayRate, DisplayCurrencyCode, CreatedByUserId);
            return returnVal;

        }

        [WebMethod(EnableSession = true)]
        public string GetDesignationPayRate(int DesignationId, int EmpType)
        {
            String DesignationPaymentRate = string.Empty;

            DataSet returnDataSet = PayRateBLL.Instance.GetDesignationPayRate(DesignationId, EmpType);

            if (returnDataSet != null && returnDataSet.Tables.Count > 0)
            {
                returnDataSet.Tables[0].TableName = "DesignationRate";

                DataTable dtResult = returnDataSet.Tables[0];

                DesignationPaymentRate = JsonConvert.SerializeObject(dtResult, Formatting.Indented);

            }

            return DesignationPaymentRate;


        }

        [WebMethod(EnableSession = true)]
        public string GetDesignationPayrates(int DesignationId)
        {
            String DesignationPaymentRate = string.Empty;

            DataSet returnDataSet = PayRateBLL.Instance.GetDesignationPayRates(DesignationId);

            if (returnDataSet != null && returnDataSet.Tables.Count > 0)
            {

                DataTable dtResult = returnDataSet.Tables[0];

                dtResult.TableName = "PayratesData";

                DesignationPaymentRate = JsonConvert.SerializeObject(dtResult, Formatting.Indented);

            }

            return DesignationPaymentRate;


        }




        #endregion

        #region "-- Apptitude Test --"

        [WebMethod(EnableSession = true)]
        public bool SaveExamDesignation(Int64 intExamId, string Designations)
        {
            bool returnVal = true;
            AptitudeTestBLL.Instance.UpdateMCQ_ExamDesignations(intExamId, Designations);
            return returnVal;
        }

        [WebMethod(EnableSession = true)]
        public String GetTestResultsByUserID(Int32 UserID)
        {
            DataTable dtResult = AptitudeTestBLL.Instance.GetPerformanceByUserID(UserID);
            String ExamResults;


            if (dtResult != null)
            {
                ExamResults = JsonConvert.SerializeObject(dtResult, Formatting.Indented);
            }
            else
            {
                ExamResults = String.Empty;
            }

            return ExamResults;

        }

        [WebMethod(EnableSession = true)]
        public static Int32 ExamTimeLeft()
        {
            int secondLeft = 0;

            // if exam start registration time available.
            if (JGSession.ExamTimerSetTime != null)
            {
                // Subtract Registered time from time now will yeild total time taken so far.
                TimeSpan TimeTaken = DateTime.Now.Subtract(Convert.ToDateTime(JGSession.ExamTimerSetTime));

                // Subtract total exam alloted time from time taken will yeild Time left to give exam.
                Double MilliSecondLeft = (JGSession.CurrentExamTime * 60000) - TimeTaken.TotalMilliseconds;

                //TODO: If timeup then call time up methods.

                // If time left to give exam then show that time.
                if (MilliSecondLeft > 0)
                {
                    secondLeft = Convert.ToInt32(MilliSecondLeft * 0.001);
                    //ScriptManager.RegisterStartupScript(this,this.Page.GetType(), "timerDisplay", "startExamTimer(" + secondLeft.ToString() + ");", true); 
                }

            }

            return secondLeft;

        }

        #endregion

        #region "-- Auto Email/SMS Templates --"

        [WebMethod(EnableSession = true)]
        public bool UpdateHTMLTemplateFromId(Int32 TemplateId, String FromID)
        {
            return HTMLTemplateBLL.Instance.UpdateHTMLTemplateFromId(TemplateId, FromID);
        }

        [WebMethod(EnableSession = true)]
        public bool UpdateHTMLTemplateSubject(Int32 TemplateId, String Subject)
        {
            return HTMLTemplateBLL.Instance.UpdateHTMLTemplateSubject(TemplateId, Subject);
        }

        [WebMethod(EnableSession = true)]
        public bool UpdateHTMLTemplateTriggerText(Int32 TemplateId, String TriggerText)
        {
            return HTMLTemplateBLL.Instance.UpdateHTMLTemplateTriggerText(TemplateId, TriggerText);
        }

        [WebMethod(EnableSession = true)]
        public bool UpdateHTMLTemplateFreQuency(Int32 TemplateId, Int32 FrequencyInDays, DateTime FrequencyStartDate, DateTime FrequencyTime)
        {
            // Send only date part to database
            FrequencyStartDate = FrequencyStartDate.Date;

            return HTMLTemplateBLL.Instance.UpdateHTMLTemplateFreQuency(TemplateId, FrequencyInDays, FrequencyStartDate, FrequencyTime);

        }


        [WebMethod(EnableSession = true)]
        public void TriggerBulkAutoEmail(Int32 TemplateId, string EmailType)
        {
            DataSet Designation = CommonFunction.GetDesignations();

            if (Designation != null && Designation.Tables.Count > 0 && Designation.Tables[0].Rows.Count > 0)
            {
                foreach (DataRow RowItem in Designation.Tables[0].Rows)
                {
                    Int32 DesignationId = Convert.ToInt32(RowItem["ID"]);

                    CommonFunction.BulkEmail(EmailType, (HTMLTemplates)Enum.Parse(typeof(HTMLTemplates), TemplateId.ToString()), DesignationId);
                }
            }


        }



        #endregion

        #region "-- HR Module Methods --"

        [WebMethod(EnableSession = true)]
        public bool SendOfferMadeToCandidate(string UserEmail, Int32 UserID, string DesignationID, string branchLocationId)
        {
            int EditId = UserID;

            //Yogesh Keraliya: Default password reset is stopped, as user changes password of their choice in Opportunity Page.
            InstallUserBLL.Instance.UpdateOfferMade(EditId, UserEmail, "jmgrove", branchLocationId);


            //Add User to GitHub Live Repository
            String DesignationCode = InstallUserBLL.Instance.GetUserDesignationCode(EditId);
            if (DesignationCode.Equals(CommonFunction.GetDesignationCode(JGConstant.DesignationType.IT_Sr_Net_Developer))
                || DesignationCode.Equals(CommonFunction.GetDesignationCode(JGConstant.DesignationType.IT_Jr_Net_Developer))
                || DesignationCode.Equals(CommonFunction.GetDesignationCode(JGConstant.DesignationType.IT_Android_Developer))
                || DesignationCode.Equals(CommonFunction.GetDesignationCode(JGConstant.DesignationType.IT_PHP_Developer))
                || DesignationCode.Equals(CommonFunction.GetDesignationCode(JGConstant.DesignationType.IT_Jr_PHP_Developer))
                || DesignationCode.Equals(CommonFunction.GetDesignationCode(JGConstant.DesignationType.IT_Network_Admin))
                )
            {
                String gitUserName = InstallUserBLL.Instance.GetUserGithubUserName(EditId);
                CommonFunction.AddUserAsGitcollaborator(gitUserName, JGConstant.GitRepo.Live);
            }
            DataSet ds = new DataSet();
            string email, HireDate, EmpType, PayRates, Desig, LastName, Address, FirstName;
            email = HireDate = EmpType = PayRates = Desig = LastName = Address = FirstName = String.Empty;

            ds = InstallUserBLL.Instance.ChangeStatus(Convert.ToInt32(JGConstant.InstallUserStatus.OfferMade).ToString(), EditId, DateTime.Today, DateTime.Now.ToShortTimeString(), Convert.ToInt32(Session[JG_Prospect.Common.SessionKey.Key.UserId.ToString()]), JGSession.IsInstallUser.Value, "Offer Made from HR page - " + CommonFunction.FormatDateTimeString(DateTime.Now));

            if (ds.Tables.Count > 0)
            {
                if (ds.Tables[0].Rows.Count > 0)
                {
                    if (Convert.ToString(ds.Tables[0].Rows[0]["Email"]) != "")
                    {
                        email = Convert.ToString(ds.Tables[0].Rows[0]["Email"]);
                    }
                    if (Convert.ToString(ds.Tables[0].Rows[0]["HireDate"]) != "")
                    {
                        HireDate = Convert.ToString(ds.Tables[0].Rows[0]["HireDate"]);
                    }
                    if (Convert.ToString(ds.Tables[0].Rows[0]["EmpType"]) != "")
                    {
                        EmpType = Convert.ToString(ds.Tables[0].Rows[0]["EmpType"]);
                    }
                    if (Convert.ToString(ds.Tables[0].Rows[0]["PayRates"]) != "")
                    {
                        PayRates = Convert.ToString(ds.Tables[0].Rows[0]["PayRates"]);
                    }
                    if (Convert.ToString(ds.Tables[0].Rows[0]["Designation"]) != "")
                    {
                        Desig = Convert.ToString(ds.Tables[0].Rows[0]["Designation"]);
                    }
                    if (!String.IsNullOrEmpty(ds.Tables[0].Rows[0]["FristName"].ToString()))
                    {
                        FirstName = ds.Tables[0].Rows[0]["FristName"].ToString();
                    }
                    if (!String.IsNullOrEmpty(ds.Tables[0].Rows[0]["LastName"].ToString()))
                    {
                        LastName = ds.Tables[0].Rows[0]["LastName"].ToString();
                    }
                    if (!String.IsNullOrEmpty(ds.Tables[0].Rows[0]["Address"].ToString()))
                    {
                        Address = ds.Tables[0].Rows[0]["Address"].ToString();
                    }
                }
            }
            //string strHtml = JG_Prospect.App_Code.CommonFunction.GetContractTemplateContent(199, 0, Desig);
            DesignationHTMLTemplate objHTMLTemplate = HTMLTemplateBLL.Instance.GetDesignationHTMLTemplate(HTMLTemplates.Offer_Made_Attachment_Template, DesignationID);
            string strHtml = objHTMLTemplate.Header + objHTMLTemplate.Body + objHTMLTemplate.Footer;
            strHtml = strHtml.Replace("#CurrentDate#", DateTime.Now.ToShortDateString());
            strHtml = strHtml.Replace("#FirstName#", FirstName);
            strHtml = strHtml.Replace("#LastName#", LastName);
            strHtml = strHtml.Replace("#Address#", Address);
            strHtml = strHtml.Replace("#Designation#", Desig);

            if (!string.IsNullOrEmpty(EmpType))
            {
                int intEmpType = 0;
                int.TryParse(EmpType, out intEmpType);

                if (intEmpType > 0)
                {
                    EmpType = CommonFunction.GetEnumDescription((JGConstant.EmploymentType)intEmpType);
                }

                strHtml = strHtml.Replace("#EmpType#", EmpType);

            }
            else
            {
                strHtml = strHtml.Replace("#EmpType#", "________________");
            }
            strHtml = strHtml.Replace("#JoiningDate#", HireDate);
            if (!string.IsNullOrEmpty(PayRates))
            {
                strHtml = strHtml.Replace("#RatePerHour#", PayRates);
            }
            else
            {
                strHtml = strHtml.Replace("#RatePerHour#", "____");
            }
            DateTime dtPayCheckDate;
            if (!string.IsNullOrEmpty(HireDate))
            {
                dtPayCheckDate = Convert.ToDateTime(HireDate);
            }
            else
            {
                dtPayCheckDate = DateTime.Now;
            }
            dtPayCheckDate = new DateTime(dtPayCheckDate.Year, dtPayCheckDate.Month, DateTime.DaysInMonth(dtPayCheckDate.Year, dtPayCheckDate.Month));
            strHtml = strHtml.Replace("#PayCheckDate#", dtPayCheckDate.ToShortDateString());

            #region "-- Commented By: Yogesh Keraliya: Offer Made Email don't have attachment now, Contract will be displayed inside software only.  --"
            //string strPath = JG_Prospect.App_Code.CommonFunction.ConvertHtmlToPdf(strHtml, Server.MapPath(@"~\Sr_App\MailDocument\MailAttachments\"), "Job acceptance letter");
            //List<Attachment> lstAttachments = new List<Attachment>();
            //if (File.Exists(strPath))
            //{
            //    Attachment attachment = new Attachment(strPath);
            //    attachment.Name = Path.GetFileName(strPath);
            //    lstAttachments.Add(attachment);
            //} 
            #endregion

            SendEmail(JGConstant.EmailTypes.OfferMadeEmail.ToString(), email, FirstName, LastName, "Offer Made", "", Desig, Convert.ToInt32(DesignationID), HireDate, EmpType, PayRates,
                HTMLTemplates.Offer_Made_Auto_Email);

            //binddata();
            //GetSalesUsersStaticticsAndData();
            //ScriptManager.RegisterStartupScript(this, this.GetType(), "Overlay", "ClosePopupOfferMade()", true);

            return true;

        }

        [WebMethod(EnableSession = true)]
        public bool SendInterviewDatetoCandidate(string UserEmail, Int32 UserID, string DesignationID, String InterviewDate, String InterviewTime, UInt64 TaskId)
        {
            int EditId = UserID;

            DataSet dsUser = InstallUserBLL.Instance.ChangeStatus
                                                   (
                                                      Convert.ToInt32(JGConstant.InstallUserStatus.InterviewDate).ToString(),
                                                      EditId,
                                                      Convert.ToDateTime(InterviewDate),
                                                      InterviewTime,
                                                      Convert.ToInt32(Session[JG_Prospect.Common.SessionKey.Key.UserId.ToString()]),
                                                      JGSession.IsInstallUser.Value,
                                                      "Interview Date setup from HR page popup - " + CommonFunction.FormatDateTimeString(DateTime.Now)
                                                   );
            String FirstName = string.Empty, LastName = string.Empty, Designation = string.Empty, EmployeeType = string.Empty;

            if (dsUser.Tables.Count > 0 && dsUser.Tables[0].Rows.Count > 0)
            {
                FirstName = Convert.ToString(dsUser.Tables[0].Rows[0]["FristName"]);

                LastName = Convert.ToString(dsUser.Tables[0].Rows[0]["LastName"]);
                Designation = Convert.ToString(dsUser.Tables[0].Rows[0]["Designation"]);
                EmployeeType = Convert.ToString(dsUser.Tables[0].Rows[0]["EmpType"]);
            }

            SendEmail(JGConstant.EmailTypes.InterviewEmail.ToString(),
                                    UserEmail,
                                    FirstName,
                                    LastName,
                                    "Interview Date Auto Email",
                                    "",
                                    Designation,
                                    Convert.ToInt32(DesignationID),
                                    InterviewDate,
                                    EmployeeType,
                                    "",
                                    HTMLTemplates.InterviewDateAutoEmail,
                                    null,
                                    "JMGC-PC"
                                );

            //AssignedTask if any or Default
            if (TaskId > 0)
            {
                AssignedTaskToUser(UserID, TaskId);
            }

            return true;

        }

        [WebMethod(EnableSession = true)]
        public string GetEditSalesPopupUsersWithPaging(int PageIndex, int PageSize, String UserIds, String Status, int DesignationId, String SortExpression)
        {
            string strMessage = string.Empty;
            DataSet dtResult = InstallUserBLL.Instance.GetPopupEditUsers(UserIds, Status, DesignationId, PageIndex, PageSize, SortExpression);

            if (dtResult != null && dtResult.Tables.Count > 0)
            {

                dtResult.Tables[0].TableName = "EditSalesUsers";

                strMessage = JsonConvert.SerializeObject(dtResult.Tables[0], Formatting.Indented);
            }
            else
            {
                strMessage = String.Empty;
            }

            return strMessage;

        }

        [WebMethod(EnableSession = true)]
        public string GetInterviewDateSequences(Int32 DesignationId, Int32 UserCount)
        {

            string strMessage = string.Empty;
            DataSet dtResult = TaskGeneratorBLL.Instance.GetInterviewDateSequences(DesignationId, UserCount);

            if (dtResult != null && dtResult.Tables.Count > 0)
            {
                dtResult.Tables[0].TableName = "Sequences";
                strMessage = JsonConvert.SerializeObject(dtResult.Tables[0], Formatting.Indented);
            }
            else
            {
                strMessage = String.Empty;
            }

            return strMessage;
        }

        [WebMethod(EnableSession = true)]
        public bool AcceptInterviewTask(string Password)
        {
            int UserId = Convert.ToInt32(Session[JG_Prospect.Common.SessionKey.Key.UserId.ToString()]);

            Boolean boolResult = InstallUserBLL.Instance.ChangeInstallerPassword(UserId, Password);

            return true;

        }

        [WebMethod(EnableSession = true)]
        public String GetOfferMadeContract()
        {

            String strContract = string.Empty;

            string email, HireDate, EmpType, PayRates, Desig, LastName, FirstName;

            String DesignationID = JGSession.DesignationId.ToString();
            int UserId = Convert.ToInt32(JGSession.LoginUserID);

            SetUsertoOfferMadeandGetContract(DesignationID, UserId, out email, out HireDate, out EmpType, out PayRates, out Desig, out LastName, out FirstName, out strContract);


            return strContract;

        }

        private void SetUsertoOfferMadeandGetContract(string DesignationID, int EditId, out string email, out string HireDate, out string EmpType, out string PayRates, out string Desig, out string LastName, out string FirstName, out string strHtml)
        {
            DataSet ds = new DataSet();
            string Address;
            email = HireDate = EmpType = PayRates = Desig = LastName = Address = FirstName = String.Empty;

            ds = InstallUserBLL.Instance.ChangeStatus(Convert.ToInt32(JGConstant.InstallUserStatus.OfferMade).ToString(), EditId, DateTime.Today, DateTime.Now.ToShortTimeString(), Convert.ToInt32(Session[JG_Prospect.Common.SessionKey.Key.UserId.ToString()]), JGSession.IsInstallUser.Value, "Offer Made from HR page - " + CommonFunction.FormatDateTimeString(DateTime.Now));

            if (ds.Tables.Count > 0)
            {
                if (ds.Tables[0].Rows.Count > 0)
                {
                    if (Convert.ToString(ds.Tables[0].Rows[0]["Email"]) != "")
                    {
                        email = Convert.ToString(ds.Tables[0].Rows[0]["Email"]);
                    }
                    if (Convert.ToString(ds.Tables[0].Rows[0]["HireDate"]) != "")
                    {
                        HireDate = Convert.ToString(ds.Tables[0].Rows[0]["HireDate"]);
                    }
                    if (Convert.ToString(ds.Tables[0].Rows[0]["EmpType"]) != "")
                    {
                        EmpType = Convert.ToString(ds.Tables[0].Rows[0]["EmpType"]);
                    }
                    if (Convert.ToString(ds.Tables[0].Rows[0]["PayRates"]) != "")
                    {
                        PayRates = Convert.ToString(ds.Tables[0].Rows[0]["PayRates"]);
                    }
                    if (Convert.ToString(ds.Tables[0].Rows[0]["Designation"]) != "")
                    {
                        Desig = Convert.ToString(ds.Tables[0].Rows[0]["Designation"]);
                    }
                    if (!String.IsNullOrEmpty(ds.Tables[0].Rows[0]["FristName"].ToString()))
                    {
                        FirstName = ds.Tables[0].Rows[0]["FristName"].ToString();
                    }
                    if (!String.IsNullOrEmpty(ds.Tables[0].Rows[0]["LastName"].ToString()))
                    {
                        LastName = ds.Tables[0].Rows[0]["LastName"].ToString();
                    }
                    if (!String.IsNullOrEmpty(ds.Tables[0].Rows[0]["Address"].ToString()))
                    {
                        Address = ds.Tables[0].Rows[0]["Address"].ToString();
                    }
                }
            }
            //string strHtml = JG_Prospect.App_Code.CommonFunction.GetContractTemplateContent(199, 0, Desig);
            DesignationHTMLTemplate objHTMLTemplate = HTMLTemplateBLL.Instance.GetDesignationHTMLTemplate(HTMLTemplates.Offer_Made_Attachment_Template, DesignationID);
            strHtml = objHTMLTemplate.Header + objHTMLTemplate.Body + objHTMLTemplate.Footer;
            strHtml = strHtml.Replace("#CurrentDate#", DateTime.Now.ToShortDateString());
            strHtml = strHtml.Replace("#FirstName#", FirstName);
            strHtml = strHtml.Replace("#LastName#", LastName);
            strHtml = strHtml.Replace("#Address#", Address);
            strHtml = strHtml.Replace("#Designation#", Desig);

            if (!string.IsNullOrEmpty(EmpType))
            {
                int intEmpType = 0;
                int.TryParse(EmpType, out intEmpType);

                if (intEmpType > 0)
                {
                    EmpType = CommonFunction.GetEnumDescription((JGConstant.EmploymentType)intEmpType);
                }

                strHtml = strHtml.Replace("#EmpType#", EmpType);

            }
            else
            {
                strHtml = strHtml.Replace("#EmpType#", "________________");
            }
            strHtml = strHtml.Replace("#JoiningDate#", HireDate);
            if (!string.IsNullOrEmpty(PayRates))
            {
                strHtml = strHtml.Replace("#RatePerHour#", PayRates);
            }
            else
            {
                strHtml = strHtml.Replace("#RatePerHour#", "____");
            }
            DateTime dtPayCheckDate;
            if (!string.IsNullOrEmpty(HireDate))
            {
                dtPayCheckDate = Convert.ToDateTime(HireDate);
            }
            else
            {
                dtPayCheckDate = DateTime.Now;
            }
            dtPayCheckDate = new DateTime(dtPayCheckDate.Year, dtPayCheckDate.Month, DateTime.DaysInMonth(dtPayCheckDate.Year, dtPayCheckDate.Month));
            strHtml = strHtml.Replace("#PayCheckDate#", dtPayCheckDate.ToShortDateString());
        }

        #region "-- Private Methods --"

        private void SendEmail(string EmailType, string emailId, string FName, string LName, string status, string Reason, string Designition, int DesignitionId, string HireDate, string EmpType, string PayRates, HTMLTemplates objHTMLTemplateType, List<Attachment> Attachments = null, string strManager = "")
        {
            DesignationHTMLTemplate objHTMLTemplate = HTMLTemplateBLL.Instance.GetDesignationHTMLTemplate(objHTMLTemplateType, DesignitionId.ToString());

            //DataSet ds = AdminBLL.Instance.GetEmailTemplate(Designition, htmlTempID);// AdminBLL.Instance.FetchContractTemplate(104);
            //if (ds == null)
            //{
            //    ds = AdminBLL.Instance.GetEmailTemplate("Admin", htmlTempID);
            //}
            //else if (ds.Tables[0].Rows.Count == 0)
            //{
            //    ds = AdminBLL.Instance.GetEmailTemplate("Admin", htmlTempID);
            //}

            //string strHeader = ds.Tables[0].Rows[0]["HTMLHeader"].ToString(); //GetEmailHeader(status);
            //string strBody = ds.Tables[0].Rows[0]["HTMLBody"].ToString(); //GetEmailBody(status);
            //string strFooter = ds.Tables[0].Rows[0]["HTMLFooter"].ToString(); // GetFooter(status);
            //string strsubject = ds.Tables[0].Rows[0]["HTMLSubject"].ToString();

            string userName = ConfigurationManager.AppSettings["VendorCategoryUserName"].ToString();
            string password = ConfigurationManager.AppSettings["VendorCategoryPassword"].ToString();
            string fullname = FName + " " + LName;

            string strHeader = objHTMLTemplate.Header;
            string strBody = objHTMLTemplate.Body;
            string strFooter = objHTMLTemplate.Footer;
            string strsubject = objHTMLTemplate.Subject;

            strBody = strBody.Replace("#Email#", emailId).Replace("#email#", emailId);
            strBody = strBody.Replace("#FirstName#", FName);
            strBody = strBody.Replace("#LastName#", LName);
            strBody = strBody.Replace("#F&L name#", FName + " " + LName).Replace("#F&amp;L name#", FName + " " + LName);

            strBody = strBody.Replace("#Name#", FName).Replace("#name#", FName);
            strBody = strBody.Replace("#Date#", "").Replace("#date#", "");
            strBody = strBody.Replace("#Time#", "").Replace("#time#", "");
            strBody = strBody.Replace("#Designation#", Designition).Replace("#designation#", Designition);

            strFooter = strFooter.Replace("#Name#", FName).Replace("#name#", FName);
            strFooter = strFooter.Replace("#Date#", "").Replace("#date#", "");
            strFooter = strFooter.Replace("#Time#", "").Replace("#time#", "");
            strFooter = strFooter.Replace("#Designation#", Designition).Replace("#designation#", Designition);

            strBody = strBody.Replace("Lbl Full name", fullname);
            strBody = strBody.Replace("LBL position", Designition);
            //strBody = strBody.Replace("lbl: start date", txtHireDate.Text);
            //strBody = strBody.Replace("($ rate","$"+ txtHireDate.Text);
            strBody = strBody.Replace("Reason", Reason);

            strBody = strBody.Replace("#manager#", strManager);

            strBody = strHeader + strBody + strFooter;

            //Hi #lblFName#, <br/><br/>You are requested to appear for an interview on #lblDate# - #lblTime#.<br/><br/>Regards,<br/>

            if (status == "OfferMade")
            {
                //TODO : commented code for missing directive using Word = Microsoft.Office.Interop.Word;
                //createForeMenForJobAcceptance(strBody, FName, LName, Designition, emailId, HireDate, EmpType, PayRates);
            }
            if (status == "Deactive")
            {
                //TODO : commented code for missing directive using Word = Microsoft.Office.Interop.Word;
                //CreateDeactivationAttachment(strBody, FName, LName, Designition, emailId, HireDate, EmpType, PayRates);
            }

            List<Attachment> lstAttachments = objHTMLTemplate.Attachments;

            //for (int i = 0; i < lstAttachments.Count; i++)
            //{
            //    string sourceDir = Server.MapPath(ds.Tables[1].Rows[i]["DocumentPath"].ToString());
            //    if (File.Exists(sourceDir))
            //    {
            //        Attachment attachment = new Attachment(sourceDir);
            //        attachment.Name = Path.GetFileName(sourceDir);
            //        lstAttachments.Add(attachment);
            //    }
            //}

            if (Attachments != null)
            {
                lstAttachments.AddRange(Attachments);
            }

            try
            {
                JG_Prospect.App_Code.CommonFunction.SendEmail(EmailType, Designition, emailId, strsubject, strBody, lstAttachments);

                //ScriptManager.RegisterStartupScript(this, this.GetType(), "UserMsg", "alert('An email notification has sent on " + emailId + ".');", true);
            }
            catch
            {
                //ScriptManager.RegisterStartupScript(this, this.GetType(), "UserMsg", "alert('Error while sending email notification on " + emailId + ".');", true);
            }
        }

        private long SendInterviewEmail(string EmailType, string emailId, string FName, string LName, string status, string Reason, string Designition, int DesignitionId,
                                            string date, string time, string EmpType, string PayRates, HTMLTemplates objHTMLTemplateType,
                                            List<Attachment> Attachments = null, string strManager = "")
        {
            DesignationHTMLTemplate objHTMLTemplate = HTMLTemplateBLL.Instance.GetDesignationHTMLTemplate(objHTMLTemplateType, DesignitionId.ToString());

            string userName = ConfigurationManager.AppSettings["VendorCategoryUserName"].ToString();
            string password = ConfigurationManager.AppSettings["VendorCategoryPassword"].ToString();
            string fullname = FName + " " + LName;

            string strHeader = objHTMLTemplate.Header;
            string strBody = objHTMLTemplate.Body;
            string strFooter = objHTMLTemplate.Footer;
            string strsubject = objHTMLTemplate.Subject;

            strBody = strBody.Replace("#Email#", emailId).Replace("#email#", emailId);
            strBody = strBody.Replace("#FirstName#", FName);
            strBody = strBody.Replace("#LastName#", LName);
            strBody = strBody.Replace("#Name#", FName).Replace("#name#", FName);
            strBody = strBody.Replace("#Date#", date).Replace("#date#", date);
            strBody = strBody.Replace("#Time#", time).Replace("#time#", time);
            strBody = strBody.Replace("#Designation#", Designition).Replace("#designation#", Designition);

            strFooter = strFooter.Replace("#Name#", FName).Replace("#name#", FName);
            strFooter = strFooter.Replace("#Date#", date).Replace("#date#", date);
            strFooter = strFooter.Replace("#Time#", time).Replace("#time#", time);
            strFooter = strFooter.Replace("#Designation#", Designition).Replace("#designation#", Designition);

            strBody = strBody.Replace("Lbl Full name", fullname);
            strBody = strBody.Replace("LBL position", Designition);
            strBody = strBody.Replace("Reason", Reason);

            strBody = strBody.Replace("#manager#", strManager);

            strBody = strHeader + strBody + strFooter;


            if (status == "OfferMade")
            {
                //TODO : commented code for missing directive using Word = Microsoft.Office.Interop.Word;
                //createForeMenForJobAcceptance(strBody, FName, LName, Designition, emailId, HireDate, EmpType, PayRates);
            }
            if (status == "Deactive")
            {
                //TODO : commented code for missing directive using Word = Microsoft.Office.Interop.Word;
                //CreateDeactivationAttachment(strBody, FName, LName, Designition, emailId, HireDate, EmpType, PayRates);
            }

            List<Attachment> lstAttachments = objHTMLTemplate.Attachments;

            if (Attachments != null)
            {
                lstAttachments.AddRange(Attachments);
            }

            try
            {
                return JG_Prospect.App_Code.CommonFunction.SendEmail(EmailType, Designition, emailId, strsubject, strBody, lstAttachments);

                //ScriptManager.RegisterStartupScript(this, this.GetType(), "UserMsg", "alert('An email notification has sent on " + emailId + ".');", true);
            }
            catch
            {
                return 0;
                //ScriptManager.RegisterStartupScript(this, this.GetType(), "UserMsg", "alert('Error while sending email notification on " + emailId + ".');", true);
            }
        }

        private void AssignedTaskToUser(int UserID, UInt64 TaskId)
        {
            string ApplicantId = UserID.ToString();

            //If dropdown has any value then assigned it to user else. return 
            if (TaskId > 0)
            {
                // save (insert / delete) assigned users.
                //bool isSuccessful = TaskGeneratorBLL.Instance.SaveTaskAssignedUsers(Convert.ToUInt64(ddlTechTask.SelectedValue), Session["EditId"].ToString());

                // save assigned user a TASK.
                bool isSuccessful = TaskGeneratorBLL.Instance.SaveTaskAssignedToMultipleUsers(TaskId, ApplicantId);

                // Change task status to assigned = 3.
                if (isSuccessful)
                    UpdateTaskStatus(Convert.ToInt32(TaskId), Convert.ToUInt16(JGConstant.TaskStatus.Assigned));

                SendEmailToAssignedUsers(Convert.ToInt32(TaskId), UserID.ToString());
            }
        }

        private void UpdateTaskStatus(Int32 taskId, UInt16 Status)
        {
            Task task = new Task();
            task.TaskId = taskId;
            task.Status = Status;

            int result = TaskGeneratorBLL.Instance.UpdateTaskStatus(task);    // save task master details

            //String AlertMsg;

            //if (result > 0)
            //{
            //    AlertMsg = "Status changed successfully!";
            //}
            //else
            //{
            //    AlertMsg = "Status change was not successfull, Please try again later.";
            //}
        }

        private void SendHRWelcomeEmail(string emailId, string FName, string LName, string Designition, string Phone, int DesignitionId, HTMLTemplates objHTMLTemplateType, List<Attachment> Attachments = null, string strManager = "")
        {
            DesignationHTMLTemplate objHTMLTemplate = HTMLTemplateBLL.Instance.GetDesignationHTMLTemplate(objHTMLTemplateType, DesignitionId.ToString());

            string userName = ConfigurationManager.AppSettings["VendorCategoryUserName"].ToString();
            string password = ConfigurationManager.AppSettings["VendorCategoryPassword"].ToString();
            string fullname = FName + " " + LName;

            string strHeader = objHTMLTemplate.Header;
            string strBody = objHTMLTemplate.Body;
            string strFooter = objHTMLTemplate.Footer;
            string strsubject = objHTMLTemplate.Subject;

            strBody = strBody.Replace("#Email#", emailId).Replace("#email#", emailId);
            strBody = strBody.Replace("#FirstName#", FName);
            strBody = strBody.Replace("#LastName#", LName);
            strBody = strBody.Replace("#F&L name#", FName + " " + LName).Replace("#F&amp;L name#", FName + " " + LName);

            strBody = strBody.Replace("#Phone number#", String.IsNullOrEmpty(Phone) == true ? Phone : String.Concat("OR ", Phone));

            strBody = strBody.Replace("#Name#", FName).Replace("#name#", FName);
            strBody = strBody.Replace("#Date#", "").Replace("#date#", "");
            strBody = strBody.Replace("#Time#", "").Replace("#time#", "");
            //strBody = strBody.Replace("#Designation#", Designition).Replace("#designation#", Designition);

            strFooter = strFooter.Replace("#Name#", FName).Replace("#name#", FName);
            strFooter = strFooter.Replace("#Date#", "").Replace("#date#", "");
            strFooter = strFooter.Replace("#Time#", "").Replace("#time#", "");
            strFooter = strFooter.Replace("#Designation#", Designition).Replace("#designation#", Designition);

            strBody = strBody.Replace("Lbl Full name", fullname);
            strBody = strBody.Replace("LBL position", Designition);

            strBody = strBody.Replace("#manager#", strManager);

            strBody = strHeader + strBody + strFooter;

            List<Attachment> lstAttachments = objHTMLTemplate.Attachments;

            if (Attachments != null)
            {
                lstAttachments.AddRange(Attachments);
            }

            try
            {
                JG_Prospect.App_Code.CommonFunction.SendEmail(JGConstant.EmailTypes.Welcome.ToString(), Designition, emailId, strsubject, strBody, lstAttachments);
            }
            catch
            {

            }
        }

        #endregion

        #endregion

        #region "-- Employee Legal Desclaimer --"

        [WebMethod(EnableSession = true)]
        public String GetEmployeeLegalDesclaimer(Int32 DesignationId, JGConstant.EmployeeLegalDesclaimerUsedFor UsedFor)
        {

            String strLegalDesclaimer = string.Empty;

            DataSet LegalDesclaimer = EmployeeLegalDesclaimerBLL.Instance.GetEmployeeLegalDesclaimerByDesignationId(DesignationId, UsedFor);

            if (LegalDesclaimer != null && LegalDesclaimer.Tables.Count > 0)
            {
                DataTable dtResult = LegalDesclaimer.Tables[0];


                if (dtResult != null)
                {
                    strLegalDesclaimer = JsonConvert.SerializeObject(dtResult, Formatting.Indented);
                }
                else
                {
                    strLegalDesclaimer = String.Empty;
                }
            }

            return strLegalDesclaimer;

        }

        #endregion

        #region "-- Employee Instructions --"
        [WebMethod(EnableSession = true)]
        public String GetEmployeeInstructionByDesignationId(Int32 DesignationId, JGConstant.EmployeeInstructionUsedFor UsedFor)
        {

            String strInstruction = string.Empty;

            DesignationHTMLTemplate objHTMLTemplate = HTMLTemplateBLL.Instance.GetDesignationHTMLTemplate(HTMLTemplates.InterviewDateAutoEmail, DesignationId.ToString());

            //DataSet EmployeeInstruction = EmployeeInstructionBLL.Instance.GetEmployeeInstructionByDesignationId(DesignationId, UsedFor);


            //if (EmployeeInstruction != null && EmployeeInstruction.Tables.Count > 0)

            if (objHTMLTemplate != null)
            {
                //DataTable dtResult = EmployeeInstruction.Tables[0];


                //if (dtResult != null)
                //{
                //    strInstruction = JsonConvert.SerializeObject(dtResult, Formatting.Indented);
                //}

                strInstruction = objHTMLTemplate.Body;

            }
            else
            {
                strInstruction = String.Empty;
            }

            return strInstruction;

        }


        #endregion

        #region "-- User Interview Details --"

        [WebMethod(EnableSession = true)]
        public String GetEmployeeInterviewDetails(Int32 UserId)
        {

            String strInterviewDetails = string.Empty;

            DataSet InterviewDetails = InstallUserBLL.Instance.GetEmployeeInterviewDetails(UserId);

            if (InterviewDetails != null && InterviewDetails.Tables.Count > 0)
            {
                DataTable dtResult = InterviewDetails.Tables[0];


                if (dtResult != null)
                {
                    strInterviewDetails = JsonConvert.SerializeObject(dtResult, Formatting.Indented);
                }
                else
                {
                    strInterviewDetails = String.Empty;
                }
            }

            return strInterviewDetails;

        }


        #endregion

        [WebMethod(EnableSession = true)]
        public string SetEmployeeType(int id, string type)
        {
            InstallUserBLL.Instance.UpdateEmpType(id, type);
            return new JavaScriptSerializer().Serialize(new ActionOutput { Status = ActionStatus.Successfull });
        }

        #region Chat Section
        [WebMethod(EnableSession = true)]
        public string GetOnlineActiveCount()
        {
            return new JavaScriptSerializer().Serialize(new ActionOutput<int>
            {
                Status = ActionStatus.Successfull,
                Object = ChatBLL.Instance.GetActiveUsersByLoggedInUser(SingletonGlobal.Instance.ConnectedUsers, JGSession.UserId).Where(m => m != JGSession.UserId).Count()
            });
        }

        [WebMethod(EnableSession = true)]
        public string InitiateBlankChat(string sortBy = "recent", string filterBy = "", int pageNumber = 1,
                                            int pageSize = 20, int? departmentId = null, string type = "all",
                                            bool markAllRead = false, int? userStatus = null)
        {
            // Update ActiveUsers in SingletonUserChatGroups
            var onlineChats = ChatBLL.Instance.GetOnlineUsers(JGSession.UserId, sortBy, filterBy, pageNumber,
                                                    pageSize, departmentId, type, markAllRead, userStatus);
            var users = onlineChats.Results;
            var oldOnlineUers = SingletonUserChatGroups.Instance.ActiveUsers;
            SingletonUserChatGroups.Instance.ActiveUsers = users;
            if (oldOnlineUers != null && SingletonUserChatGroups.Instance.ActiveUsers != null && SingletonUserChatGroups.Instance.ActiveUsers.Count() > 0)
                foreach (var item in oldOnlineUers)
                {
                    if (SingletonUserChatGroups.Instance.ActiveUsers.Where(m => m.UserId == item.UserId)
                                                    .FirstOrDefault() != null)
                        SingletonUserChatGroups.Instance.ActiveUsers.Where(m => m.UserId == item.UserId)
                                                        .FirstOrDefault().Status = item.Status;
                }
            if (SingletonUserChatGroups.Instance.ActiveUsers != null)
                foreach (var item in SingletonUserChatGroups.Instance.ActiveUsers)
                {
                    if (SingletonGlobal.Instance.ConnectedUsers.Where(x => x == item.UserId).Any())
                    {
                        SingletonUserChatGroups.Instance.ActiveUsers.Where(x => x.UserId == item.UserId).First().Status = (int)ChatUserStatus.Active;
                        SingletonUserChatGroups.Instance.ActiveUsers.Where(x => x.UserId == item.UserId).First().LastActivityAt = DateTime.UtcNow;
                    }
                }

            if (SingletonUserChatGroups.Instance.ActiveUsers != null)
            {
                if (type.ToLower() == "online")
                {
                    SingletonUserChatGroups.Instance.ActiveUsers = SingletonUserChatGroups.Instance.ActiveUsers
                                                                            // .Where(m => m.Status == (int)ChatUserStatus.Active)
                                                                            //.OrderBy(m=>m.InstallUserStatusId.Value)
                                                                            //.ThenBy(m => m.Status)
                                                                            .ToList();
                    var actives = SingletonUserChatGroups.Instance.ActiveUsers.Where(x => x.InstallUserStatusId == (int)InstallUserStatus.Active)
                                                         .OrderBy(x => x.Status).ToList();
                    var offerMade = SingletonUserChatGroups.Instance.ActiveUsers.Where(x => x.InstallUserStatusId == (int)InstallUserStatus.OfferMade)
                                                         .OrderBy(x => x.Status).ToList();
                    var interviewDate = SingletonUserChatGroups.Instance.ActiveUsers.Where(x => x.InstallUserStatusId == (int)InstallUserStatus.InterviewDate)
                                                         .OrderBy(x => x.Status).ToList();
                    var applicant = SingletonUserChatGroups.Instance.ActiveUsers.Where(x => x.InstallUserStatusId == (int)InstallUserStatus.Applicant)
                                                         .OrderBy(x => x.Status).ToList();
                    var referralApplicant = SingletonUserChatGroups.Instance.ActiveUsers.Where(x => x.InstallUserStatusId == (int)InstallUserStatus.ReferralApplicant)
                                                         .OrderBy(x => x.Status).ToList();

                    SingletonUserChatGroups.Instance.ActiveUsers = new List<ActiveUser>();
                    SingletonUserChatGroups.Instance.ActiveUsers.AddRange(actives);
                    SingletonUserChatGroups.Instance.ActiveUsers.AddRange(offerMade);
                    SingletonUserChatGroups.Instance.ActiveUsers.AddRange(interviewDate);
                    SingletonUserChatGroups.Instance.ActiveUsers.AddRange(applicant);
                    SingletonUserChatGroups.Instance.ActiveUsers.AddRange(referralApplicant);
                }
                return new JavaScriptSerializer().Serialize(new ActionOutput<ActiveUser>
                {
                    Results = SingletonUserChatGroups.Instance.ActiveUsers/*.OrderByDescending(m => m.LastMessageAt)*/.ToList(),
                    Status = ActionStatus.Successfull,
                    Message = onlineChats.Message // totalCalls Count
                });
            }
            else
            {
                return string.Empty;
            }

        }

        [WebMethod(EnableSession = true)]
        public string InitiateChat(string receiverIds, string chatGroupId, int chatSourceId, int taskId = 0,
                                    int taskMultilevelListId = 0, int userChatGroupId = 0)
        {
            if (chatGroupId.ToLower() == "undefind" || chatGroupId.ToLower() == "null")
                chatGroupId = null;
            // Add Loggedin user into receiverIds
            //receiverIds += "," + JGSession.UserId;
            List<int> usrs = new List<int>();
            List<int> userIds = receiverIds.Split(new char[] { ',' }, StringSplitOptions.RemoveEmptyEntries)
                                           .Select(m => Convert.ToInt32(m))
                                           .ToList();
            userIds.Add(JGSession.UserId);
            userIds = userIds.Distinct().OrderBy(m => m).ToList();
            userIds = userIds.Where(x => x != JGSession.UserId).ToList();
            if (userIds.Count() == 0)
                userIds.Add(JGSession.UserId);
            usrs.AddRange(userIds);
            List<ChatUser> receivers = ChatBLL.Instance.GetChatUsers(usrs).Results;

            #region Chat Messages
            List<ChatMessage> messages = taskId == 0 ? ChatBLL.Instance.GetChatMessages(JGSession.UserId, chatGroupId,
                string.Join(",", userIds.OrderBy(m => m).ToList()), chatSourceId, userChatGroupId, 1, 50).Results
                                            :
                                            ChatBLL.Instance.GetTaskChatMessages(JGSession.UserId, chatSourceId, taskId,
                                                                                    1, 50, taskMultilevelListId).Results;
            #endregion
            // Create TaskGroup if taskId is not null and userChatGroupId is null/0
            if (taskId > 0 && userChatGroupId <= 0)
            {
                userChatGroupId = ChatBLL.Instance.CreateTaskChatGroup(taskId, taskMultilevelListId);
            }
            string ChatGroupName = string.Empty;
            var sender = ChatBLL.Instance.GetChatUser(JGSession.UserId).Object;
            //var receiver = ChatBLL.Instance.GetChatUser(userID).Object;
            if (receivers != null && receivers.Count > 0)
            {
                //ChatGroupId = Guid.NewGuid().ToString();
                List<ChatUser> chatUsers = new List<ChatUser>();
                #region Chat Users
                chatUsers.Add(new ChatUser // Set Sender
                {
                    ConnectionIds = sender.ConnectionIds,
                    //Email = sender.Email,
                    GroupOrUsername = sender.GroupOrUsername,
                    ProfilePic = sender.ProfilePic,
                    OnlineAt = sender.OnlineAt,
                    UserId = sender.UserId,
                    UserInstallId = sender.UserInstallId,
                    OnlineAtFormatted = sender.OnlineAtFormatted,
                    ChatClosed = false
                });

                foreach (var receiver in receivers.Where(m => m.UserId != JGSession.UserId))
                {
                    chatUsers.Add(new ChatUser // Set Receiver
                    {
                        ConnectionIds = receiver.ConnectionIds,
                        //Email = receiver.Email,
                        GroupOrUsername = receiver.GroupOrUsername,
                        ProfilePic = receiver.ProfilePic,
                        OnlineAt = receiver.OnlineAt,
                        UserId = receiver.UserId,
                        UserInstallId = receiver.UserInstallId,
                        OnlineAtFormatted = receiver.OnlineAtFormatted,
                        ChatClosed = false
                    });
                }
                #endregion
                DataSet taskDetail = TaskGeneratorBLL.Instance.GetTaskDetails(taskId, JGSession.UserId);
                DataSet taskMultilevelListItem = TaskGeneratorBLL.Instance.GetTaskMultilevelListItem(taskMultilevelListId, JGSession.UserId);
                ChatGroupName = taskId == 0 ? string.Join(", ", chatUsers.Select(m => "<span class=\"user-name\">" + m.GroupOrUsername + ":<a target=\"_blank\" uid=\"" + m.UserId + "\" href=\"/Sr_App/ViewSalesUser.aspx?id=" + m.UserId + "\">" + m.UserInstallId + "</a></span>").ToList())
                                : taskMultilevelListId == 0 ? taskDetail.Tables[6].Rows[0]["TaskTitle"].ToString()
                                : taskMultilevelListItem.Tables[0].Rows[0]["FormattedTitle"].ToString();

                // Check if ChatGroupId is already exists
                var existing = SingletonUserChatGroups.Instance.ChatGroups.Where(m => m.ChatGroupId == chatGroupId).FirstOrDefault();
                if (existing != null)
                {
                    ChatGroupName = taskId == 0 ? ChatGroupName
                                    : taskMultilevelListId == 0 ? taskDetail.Tables[6].Rows[0]["TaskTitle"].ToString()
                                    : taskMultilevelListItem.Tables[0].Rows[0]["FormattedTitle"].ToString();
                    existing.ChatUsers.Where(m => userIds.Contains(m.UserId.Value)).ToList().ForEach(m => m.ChatClosed = false);

                    SingletonUserChatGroups.Instance.ChatGroups.Where(m => m.ChatGroupId == chatGroupId)
                                                           .Where(m => m.ChatUsers.Where(x => userIds.Contains(x.UserId.Value)).Any())
                                                           .Select(m => m.ChatUsers)
                                                           .FirstOrDefault()
                                                           .ForEach(m => m.ChatClosed = false);
                }
                else
                {
                    if (string.IsNullOrEmpty(chatGroupId) && receivers.Count() == 1)
                    {
                        // ChatGroupId is null means, 1-1 chat
                        // Check if sender/receiver has previous chat exists, if yes, then fetch existing ChatGroupId
                        messages = taskId == 0 ? ChatBLL.Instance.GetChatMessagesByUsers(sender.UserId.Value, Convert.ToInt32(receiverIds), chatSourceId, 1, 50).Results
                                            :
                                            ChatBLL.Instance.GetTaskChatMessages(JGSession.UserId, chatSourceId, taskId, 1, 50, taskMultilevelListId).Results;

                        if (messages != null && messages.Count() > 0)
                            chatGroupId = messages.FirstOrDefault().ChatGroupId;
                    }
                    // check if chatGroupId is still null, then create new chatGroupId (first time chatting)
                    if (string.IsNullOrEmpty(chatGroupId))
                    {
                        chatGroupId = Guid.NewGuid().ToString();
                    }

                    SingletonUserChatGroups.Instance.ChatGroups.Add(new ChatGroup
                    {
                        SenderId = JGSession.UserId,
                        ChatGroupId = chatGroupId,
                        ChatGroupName = ChatGroupName,
                        ChatUsers = chatUsers,
                        ChatMessages = new List<ChatMessage>()
                    });
                }

                // Update ActiveUsers in SingletonUserChatGroups
                // Update ActiveUsers in SingletonUserChatGroups
                var users = ChatBLL.Instance.GetOnlineUsers(JGSession.UserId).Results;
                var oldOnlineUers = SingletonUserChatGroups.Instance.ActiveUsers;
                SingletonUserChatGroups.Instance.ActiveUsers = users;
                if (oldOnlineUers != null && SingletonUserChatGroups.Instance.ActiveUsers != null && SingletonUserChatGroups.Instance.ActiveUsers.Count() > 0)
                    foreach (var item in oldOnlineUers)
                    {
                        if (SingletonUserChatGroups.Instance.ActiveUsers.Where(m => m.UserId == item.UserId)
                                                    .FirstOrDefault() != null)
                            SingletonUserChatGroups.Instance.ActiveUsers.Where(m => m.UserId == item.UserId)
                                                            .FirstOrDefault().Status = item.Status;
                    }
            }

            #region Update ConnectionId
            ChatGroup chatGroup = SingletonUserChatGroups.Instance.ChatGroups.Where(m => m.ChatGroupId == chatGroupId).FirstOrDefault();
            // Checking in database to fetch all connectionIds of browser of this chat group
            // FYI: Everytime, we reload a web page, SignalR brower connectionId gets changed, So
            // we have to always look database for correct connectionIds
            var newConnections = ChatBLL.Instance.GetChatUsers(chatGroup.ChatUsers.Select(m => m.UserId.Value).ToList()).Results;
            List<int> onlineUserIds = newConnections.Select(m => m.UserId.Value).ToList();
            // Modify existing connectionIds into particular ChatGroup and save into static "UserChatGroups" object
            foreach (var user in chatGroup.ChatUsers.Where(m => onlineUserIds.Contains(m.UserId.Value)))
            {
                if (newConnections.Where(m => m.UserId == user.UserId).Any())
                {
                    user.ConnectionIds = newConnections.Where(m => m.UserId == user.UserId).Select(m => m.ConnectionIds).FirstOrDefault();
                    user.OnlineAt = newConnections.Where(m => m.UserId == user.UserId).OrderByDescending(m => m.OnlineAt).Select(m => m.OnlineAt).FirstOrDefault();
                    user.OnlineAtFormatted = user.OnlineAt.HasValue ? user.OnlineAt.Value.ToEST().ToString() : null;
                }
            }
            #endregion
            ChatMessageActiveUser obj = new ChatMessageActiveUser();
            obj.ChatGroupId = chatGroupId;
            obj.ChatGroupName = ChatGroupName;
            obj.ChatMessages = messages;
            obj.ActiveUsers = SingletonUserChatGroups.Instance.ActiveUsers/*.OrderByDescending(m => m.LastMessageAt)*/.ToList();
            // Set LastSeen
            int SenderUserId = userChatGroupId == 0 ? Convert.ToInt32(receiverIds) : 0;
            ChatBLL.Instance.SaveLastChatSeen(SenderUserId, userChatGroupId, JGSession.UserId);

            DateTime? LastSeenAt = ChatBLL.Instance.GetLastChatSeen(JGSession.UserId, userChatGroupId, SenderUserId);
            obj.LastSeenAt = LastSeenAt.HasValue ? (DateTime?)LastSeenAt.Value : null;
            obj.LastSeenAtFormated = obj.LastSeenAt.HasValue ? obj.LastSeenAt.Value.ToString() : "";

            UserChatGroup userChatGroup = new UserChatGroup();
            if (userChatGroupId > 0)
            {
                userChatGroup = ChatBLL.Instance.GetChatGroup(userChatGroupId);
            }
            else
            {
                userChatGroup.ChatGroupType = 1;
            }
            return new JavaScriptSerializer().Serialize(new ActionOutput<ChatMessageActiveUser>
            {
                Object = obj,
                Message = userChatGroupId.ToString() + ":" + userChatGroup.ChatGroupType,
                Status = ActionStatus.Successfull
            });
        }

        [WebMethod(EnableSession = true)]
        public string GetUsers(string keyword = null, int userChatGroupId = 0)
        {
            string baseUrl = System.Web.HttpContext.Current.Request.Url.Scheme + "://" +
                                System.Web.HttpContext.Current.Request.Url.Authority +
                                System.Web.HttpContext.Current.Request.ApplicationPath.TrimEnd('/') + "/";
            List<ChatUser> existingUsers = ChatBLL.Instance.GetChatGroupMembers(userChatGroupId);
            string existingUserIds = existingUsers != null && existingUsers.Count() > 0 ? string.Join(",", existingUsers.Select(m => m.UserId).ToList()) : "";

            List<ChatMentionUser> users = new List<ChatMentionUser>();
            ActionOutput<LoginUser> op = InstallUserBLL.Instance.GetUsers(keyword, existingUserIds, JGSession.UserId);
            if (op != null && op.Status == ActionStatus.Successfull)
            {
                users = op.Results.Select(m => new ChatMentionUser
                {
                    id = m.ID,
                    name = m.FirstName + "(" + m.Email + ")",
                    type = "contact",
                    avatar = baseUrl + "ProfilePictures/" + (string.IsNullOrEmpty(m.ProfilePic) ? "default.jpg"
                                : m.ProfilePic.Replace("~/ProfilePictures/", ""))
                }).ToList();
            }
            return new JavaScriptSerializer().Serialize(new ActionOutput<ChatMentionUser>
            {
                Status = ActionStatus.Successfull,
                Results = users
            });
        }

        [WebMethod(EnableSession = true)]
        public string LoadPreviousChat(string chatGroupId, string receiverIds, int chatSourceId, int userChatGroupId,
                                                    int? taskId, int? taskMultilevelListId,
                                                    int pageNumber, int pageSize)
        {
            List<int> userIds = receiverIds.Split(new char[] { ',' }, StringSplitOptions.RemoveEmptyEntries)
                                           .Select(m => Convert.ToInt32(m))
                                           .ToList();
            userIds.Add(JGSession.UserId);
            userIds = userIds.Distinct().OrderBy(m => m).ToList();

            receiverIds = string.Join(",", userIds.OrderBy(m => m).ToList());

            List<ChatMessage> messages = taskId == 0 ? ChatBLL.Instance.GetChatMessages(JGSession.UserId, chatGroupId,
                                                            receiverIds, chatSourceId, userChatGroupId, pageNumber, pageSize).Results
                                            : ChatBLL.Instance.GetTaskChatMessages(JGSession.UserId, chatSourceId, taskId ?? 0, pageNumber, pageSize, taskMultilevelListId ?? 0).Results;

            return new JavaScriptSerializer().Serialize(new ActionOutput<ChatMessage>
            {
                Results = messages,
                Status = ActionStatus.Successfull
            });
        }

        [WebMethod(EnableSession = true)]
        public string ChatHistory(string chatGroupId, string receiverIds, int chatSourceId, int userChatGroupId,
                                    int pageNumber, int pageSize)
        {
            List<int> userIds = receiverIds.Split(new char[] { ',' }, StringSplitOptions.RemoveEmptyEntries)
                                           .Select(m => Convert.ToInt32(m))
                                           .ToList();
            userIds = userIds.Distinct().OrderBy(m => m).ToList();

            receiverIds = string.Join(",", userIds.OrderBy(m => m).ToList());

            List<ChatMessage> messages = ChatBLL.Instance.GetChatMessages(JGSession.UserId, chatGroupId, receiverIds,
                                    chatSourceId, userChatGroupId, pageNumber, pageSize).Results;
            return new JavaScriptSerializer().Serialize(new ActionOutput<ChatMessage>
            {
                Results = messages,
                Status = ActionStatus.Successfull
            });
        }

        [WebMethod(EnableSession = true)]
        public string ChangeTaskChatTitle(int TaskId, int TaskMultilevelListId, string Title)
        {
            ChatBLL.Instance.ChangeTaskChatTitle(JGSession.UserId, TaskId, TaskMultilevelListId, Title);
            return new JavaScriptSerializer().Serialize(new ActionOutput<ChatMessage>
            {
                Status = ActionStatus.Successfull
            });
        }

        [WebMethod(EnableSession = true)]
        public string GetChatUnReadCount()
        {
            return new JavaScriptSerializer().Serialize(ChatBLL.Instance.GetChatUnReadCount(JGSession.UserId));
        }

        [WebMethod(EnableSession = true)]
        public string GetChatGroupMembers(int? UserChatGroupId, string SenderUserId)
        {
            List<ChatUser> members = ChatBLL.Instance.GetChatGroupMembers(JGSession.UserId, UserChatGroupId);
            var loggedInUser = members.Where(m => m.UserId == JGSession.UserId).FirstOrDefault();
            if (loggedInUser != null)
                members.Remove(loggedInUser);

            int senderUserId = 0;
            List<int> Ids = SenderUserId.Split(new char[] { ',' }, StringSplitOptions.RemoveEmptyEntries).Select(m => Convert.ToInt32(m)).ToList();
            Ids.Remove(JGSession.UserId);

            if (UserChatGroupId.HasValue & UserChatGroupId.Value == 0)
            {
                int.TryParse(Ids.First().ToString(), out senderUserId);
            }

            // Set LastSeen
            //int SenderUserId = userChatGroupId == 0 ? Convert.ToInt32(receiverIds) : 0;
            ChatBLL.Instance.SaveLastChatSeen(senderUserId, UserChatGroupId.Value, JGSession.UserId);


            DateTime? LastSeenAt = ChatBLL.Instance.GetLastChatSeen(JGSession.UserId, UserChatGroupId.Value, senderUserId);
            LastSeenAt = LastSeenAt.HasValue ? (DateTime?)LastSeenAt.Value : null;

            return new JavaScriptSerializer().Serialize(new ActionOutput<ChatUser>
            {
                Results = members,
                Status = ActionStatus.Successfull,
                Message = LastSeenAt.HasValue ? LastSeenAt.Value.ToString() : ""
            });
        }

        [WebMethod(EnableSession = true)]
        public string RemoveChatGroupMember(int UserChatGroupId, int UserId)
        {
            ChatBLL.Instance.RemoveChatGroupMember(UserChatGroupId, UserId);

            return new JavaScriptSerializer().Serialize(new ActionOutput<ChatUser>
            {
                Status = ActionStatus.Successfull
            });
        }

        #endregion

        #region Phone
        [WebMethod(EnableSession = true)]
        public string GetCallPosition()
        {
            return new JavaScriptSerializer().Serialize(new ActionOutput<int>
            {
                Status = ActionStatus.Successfull,
                Object = UserBLL.Instance.GetCallPosition(JGSession.UserId)
            });
        }

        [WebMethod(EnableSession = true)]
        public string SaveCallPosition(int candidateUserId)
        {
            UserBLL.Instance.SaveCallPosition(JGSession.UserId, candidateUserId);
            return new JavaScriptSerializer().Serialize(new ActionOutput { Status = ActionStatus.Successfull });
        }

        [WebMethod(EnableSession = true)]
        public string GetPhoneScriptHeader()
        {
            Dictionary<int, string> types = Extensions.ToDictionary<ScriptType>();
            Dictionary<int, string> subTypes = Extensions.ToDictionary<ScriptSubType>();
            List<PhoneScriptType> phoneScriptTypes = new List<PhoneScriptType>();
            foreach (var item in types)
            {
                var type = new PhoneScriptType
                {
                    Type = item.Key,
                    TypeName = item.Value
                };
                foreach (var sub in subTypes)
                {
                    type.SubTypes.Add(new PhoneScriptSubType
                    {
                        SubType = sub.Key,
                        SubTypeName = sub.Value
                    });
                }
                phoneScriptTypes.Add(type);
            }
            return new JavaScriptSerializer().Serialize(new ActionOutput<PhoneScriptType>
            {
                Status = ActionStatus.Successfull,
                Results = phoneScriptTypes
            });
        }

        [WebMethod(EnableSession = true)]
        public string GetPhoneScripts(int designationId, int type, int subType)
        {
            List<PhoneScript> scripts = UserBLL.Instance.GetPhoneScripts(designationId, type, subType);
            return new JavaScriptSerializer().Serialize(new ActionOutput<PhoneScript>
            {
                Status = ActionStatus.Successfull,
                Results = scripts
            });
        }

        [WebMethod(EnableSession = true)]
        public string UpdatePhoneScript(int id, int type, int subType, string title, string desc, int did, string scriptType)
        {
            return new JavaScriptSerializer().Serialize(new ActionOutput<int>
            {
                Status = ActionStatus.Successfull,
                Object = UserBLL.Instance.UpdatePhoneScript(id, type, subType, title, desc, did, scriptType)
            });
        }

        [WebMethod(EnableSession = true)]
        public string UpdatePhoneScriptFAQ(int id, string title, string desc, int did)
        {
            UserBLL.Instance.UpdatePhoneScriptFAQ(id, title, desc, did);
            return new JavaScriptSerializer().Serialize(new ActionOutput { Status = ActionStatus.Successfull });
        }


        [WebMethod(EnableSession = true)]
        public string GetSalesUsers(string keyword, string status, string secondaryStatus, string designationId, string source,
                                        DateTime from, DateTime to, string addedByUserId, int startIndex, int pageSize,
                                        string sortBY, bool FirstTimeOpen = false)
        {
            PagingResult<SalesUser, UserEmail, UserPhone> list = new PagingResult<SalesUser, UserEmail, UserPhone>();
            List<SalesUser> salesUsers = new List<SalesUser>();
            DataSet dsSalesUserData = ChatBLL.Instance.GetSalesUsersStaticticsAndData
                                                        (
                                                            keyword,
                                                            status,
                                                            secondaryStatus,
                                                            designationId,
                                                            source,
                                                            from,
                                                            to,
                                                            addedByUserId,
                                                            startIndex,
                                                            pageSize,
                                                            sortBY,
                                                            JGSession.UserId,
                                                            FirstTimeOpen
                                                        );
            if (dsSalesUserData != null)
            {
                DataTable dtSalesUser_Statictics_Status = dsSalesUserData.Tables[0];
                DataTable dtSalesUser_Statictics_AddedBy = dsSalesUserData.Tables[1];
                DataTable dtSalesUser_Statictics_Designation = dsSalesUserData.Tables[2];
                DataTable dtSalesUser_Statictics_Source = dsSalesUserData.Tables[3];
                DataTable dtSalesUser_Grid = dsSalesUserData.Tables[4];

                DataTable dt_UserEmails = dsSalesUserData.Tables[7];
                DataTable dt_UserPhones = dsSalesUserData.Tables[8];
                startIndex = Convert.ToInt32(dsSalesUserData.Tables[10].Rows[0]["PageIndex"]);

                if (dtSalesUser_Grid.Rows.Count > 0)
                {
                    #region Sales User List
                    //Session["UserGridData"] = dtSalesUser_Grid;
                    //BindUsers(dtSalesUser_Grid);
                    foreach (DataRow dr in dtSalesUser_Grid.Rows)
                    {
                        salesUsers.Add(new SalesUser
                        {
                            Id = Convert.ToInt32(dr["Id"].ToString()),
                            UserInstallId = dr["UserInstallId"].ToString(),
                            AddedOnFormatted = dr["CreatedDateTime"].ToString(),
                            AddedBy = dr["AddedBy"].ToString(),
                            AddedByInstallId = dr["AddedByUserInstallId"].ToString(),
                            AddedOn = Convert.ToDateTime(dr["CreatedDateTime"].ToString()),
                            City = dr["City"].ToString(),
                            Country = dr["CountryCode"].ToString(),
                            DesignationId = string.IsNullOrEmpty(dr["DesignationID"].ToString()) ? null : (int?)Convert.ToInt32(dr["DesignationID"].ToString()),
                            Designation = dr["Designation"].ToString(),
                            Email = dr["Email"].ToString(),
                            FirstName = dr["FristName"].ToString(),
                            JobType = dr["EmpType"].ToString(),
                            LastName = dr["LastName"].ToString(),
                            Phone = dr["Phone"].ToString(),
                            ProfilePic = string.IsNullOrEmpty(dr["picture"].ToString()) ? "default.jpg" : dr["picture"].ToString(),
                            ResumeFileSavedName = dr["Resumepath"].ToString(),
                            ResumeFileDisplayName = dr["Resumepath"].ToString().Length > 14 ? dr["Resumepath"].ToString().Substring(14) : dr["Resumepath"].ToString(),
                            Source = dr["Source"].ToString(),
                            Status = Convert.ToInt32(dr["Status"].ToString()),
                            StatusName = ((InstallUserStatus)Convert.ToInt32(dr["Status"].ToString())).ToEnumDescription(),
                            StatusReason = dr["StatusReason"].ToString(),
                            RejectDetail = dr["RejectDetail"].ToString(),
                            RejectedByUserName = dr["RejectedByUserName"].ToString(),
                            RejectedByUserInstallId = dr["RejectedByUserInstallId"].ToString(),
                            RejectedUserId = string.IsNullOrEmpty(dr["RejectedUserId"].ToString()) ? null : (int?)Convert.ToInt32(dr["RejectedUserId"].ToString()),
                            InterviewDetail = dr["InterviewDetail"].ToString(),
                            Zip = dr["Zip"].ToString(),
                            LastCalledAt = !string.IsNullOrEmpty(dr["LastCalledAt"].ToString()) ? (DateTime?)Convert.ToDateTime(dr["LastCalledAt"].ToString()) : null,
                            LastCalledAtFormatted = !string.IsNullOrEmpty(dr["LastCalledAt"].ToString()) ? Convert.ToDateTime(dr["LastCalledAt"].ToString()).ToEST().ToString() : "",
                            PhoneCode = dr["PhoneCode"].ToString(),
                            SecondaryStatus = !string.IsNullOrEmpty(dr["SecondaryStatus"].ToString()) ? (int?)Convert.ToInt32(dr["SecondaryStatus"].ToString()) : null,
                            Aggregate = !string.IsNullOrEmpty(dr["Aggregate"].ToString()) ? (float?)Math.Round(Convert.ToDouble(dr["Aggregate"].ToString()), MidpointRounding.AwayFromZero) : null,
                            SalaryReq = dr["SalaryReq"].ToString(),
                            CurrencyName = dr["CurrencyName"].ToString()
                        });
                    }
                    #endregion

                    #region User Emails
                    list.QData = new List<UserEmail>();
                    foreach (DataRow item in dt_UserEmails.Rows)
                    {
                        list.QData.Add(new UserEmail
                        {
                            UserId = Convert.ToInt32(item["UserID"].ToString()),
                            Email = item["emailID"].ToString()
                        });
                    }
                    #endregion

                    #region User Phones
                    list.RData = new List<UserPhone>();
                    foreach (DataRow item in dt_UserPhones.Rows)
                    {
                        list.RData.Add(new UserPhone
                        {
                            UserId = Convert.ToInt32(item["UserID"].ToString()),
                            //PhoneTypeId = Convert.ToInt32(item["PhoneTypeID"].ToString()),
                            Phone = item["Phone"].ToString()
                        });
                    }
                    #endregion
                    list.Data = salesUsers;
                    list.Status = ActionStatus.Successfull;
                    list.TotalResults = Convert.ToInt32(dsSalesUserData.Tables[6].Rows[0][0].ToString());
                    list.NextCallingCandidateUserId = UserBLL.Instance.GetCallPosition(JGSession.UserId);
                    list.StartIndex = startIndex;
                    return new JavaScriptSerializer().Serialize(list);
                }
            }
            return new JavaScriptSerializer().Serialize(new PagingResult<SalesUser>
            {
                Status = ActionStatus.Successfull,
                TotalResults = 0
            });
        }

        [WebMethod(EnableSession = true)]
        public string DeleteSelected(string userIds)
        {
            List<int> UserIds = string.IsNullOrEmpty(userIds) ? new List<int>() :
                            userIds.Split(new char[] { ',' }, StringSplitOptions.RemoveEmptyEntries)
                                    .Select(m => Convert.ToInt32(m))
                                    .ToList();
            if (UserIds.Count > 0)
            {
                if (InstallUserBLL.Instance.DeleteInstallUsers(UserIds))
                {
                    return new JavaScriptSerializer().Serialize(new ActionOutput
                    {
                        Status = ActionStatus.Successfull,
                        Message = "User deleted Successfully."
                    });
                }
                else
                {
                    return new JavaScriptSerializer().Serialize(new ActionOutput
                    {
                        Status = ActionStatus.Successfull,
                        Message = "User can not be deleted. Please try again."
                    });
                }
            }
            else
            {
                return new JavaScriptSerializer().Serialize(new ActionOutput
                {
                    Status = ActionStatus.Successfull,
                    Message = "Please select user(s) to deleted."
                });
            }
        }

        [WebMethod(EnableSession = true)]
        public string AddSocial(int userId, int type, string phone, bool primary)
        {
            InstallUserBLL.Instance.AddUserEmailOrPhone(userId, phone.Trim(), (type == 7 ? 2 : 1), type.ToString(), "", primary);
            return new JavaScriptSerializer().Serialize(new ActionOutput { Status = ActionStatus.Successfull });
        }

        [WebMethod(EnableSession = true)]
        public string ChangeUserDesignation(int userId, int designationId)
        {
            InstallUserBLL.Instance.ChangeDesignition(userId, designationId);
            return new JavaScriptSerializer().Serialize(new ActionOutput { Status = ActionStatus.Successfull });
        }

        [WebMethod(EnableSession = true)]
        public string ChangeUserStatus(int userId, int newStatus, int oldStatus)
        {
            if (oldStatus == (int)JGConstant.InstallUserStatus.Active &&
                                (!(Convert.ToString(Session["usertype"]).Contains("Admin")) &&
                                !(Convert.ToString(Session["usertype"]).Contains("SM"))))
            {
                return new JavaScriptSerializer().Serialize(new ActionOutput
                {
                    Status = ActionStatus.Error,
                    Message = "You do not have rights to change the status."
                });
            }
            else if ((
                         oldStatus == (int)JGConstant.InstallUserStatus.Active &&
                         newStatus != (int)JGConstant.InstallUserStatus.Deactive
                    ) && ((Convert.ToString(Session["usertype"]).Contains("Admin")) ||
                            (Convert.ToString(Session["usertype"]).Contains("SM")))
                    )
            {
                return new JavaScriptSerializer().Serialize(new ActionOutput<string>
                {
                    Status = ActionStatus.Successfull,
                    Message = userId + "," + newStatus + "," + oldStatus,
                    Object = "overlayPassword" // not found on edituser.aspx
                });
            }
            bool status = CheckRequiredFields(newStatus.ToString(), userId);
            DataRow user = InstallUserBLL.Instance.getuserdetails(userId).Tables[0].Rows[0];
            if (!status)
            {
                if (newStatus == (int)JGConstant.InstallUserStatus.OfferMade)
                {
                    var branches = InstallUserBLL.Instance.GetBranchLocations();
                    return new JavaScriptSerializer().Serialize(new ActionOutput<string>
                    {
                        Status = ActionStatus.Successfull,
                        Message = userId + "," + newStatus + "," + oldStatus + ","
                                    + user["FristName"].ToString() + " " + user["LastName"].ToString()
                                    + "," + user["Designation"].ToString()
                                    + "," + user["Email"].ToString() + "," + "jmgrove"
                                    + "," + user["DesignationId"].ToString(),
                        Object = "OverlayPopupOfferMade",
                        Results = new List<string> { new JavaScriptSerializer().Serialize(branches) }
                    });
                    /*
                    hdnFirstName.Value = lblFirstName.Text;
                    hdnLastName.Value = lblLastName.Text;
                    txtEmail.Text = lbtnEmail.Text;
                    txtPassword1.Attributes.Add("value", "jmgrove");
                    txtpassword2.Attributes.Add("value", "jmgrove");
                    ScriptManager.RegisterStartupScript(this, this.GetType(), "Overlay", "OverlayPopupOfferMade();", true);
                    return;
                    */
                }
                else
                {
                    return new JavaScriptSerializer().Serialize(new ActionOutput
                    {
                        Status = ActionStatus.Error,
                        Message = "Status cannot be changed as required field for selected status are not field"
                    });
                    /*
                    //binddata();
                    GetSalesUsersStaticticsAndData();
                    ScriptManager.RegisterStartupScript(this, this.GetType(), "alert", "alert('Status cannot be changed as required field for selected status are not field')", true);
                    return;
                    */
                }
            }
            if (
                (
                    newStatus == (int)JGConstant.InstallUserStatus.Active ||
                    newStatus == (int)JGConstant.InstallUserStatus.Deactive
                ) &&
                (
                    !(Convert.ToString(Session["usertype"]).Contains("Admin")) &&
                    !(Convert.ToString(Session["usertype"]).Contains("SM"))
                )
            )
            {
                return new JavaScriptSerializer().Serialize(new ActionOutput
                {
                    Status = ActionStatus.Error,
                    Message = "You do not have permission to Activate or Deactivate user"
                });
            }
            else if (newStatus == (int)JGConstant.InstallUserStatus.Rejected)
            {
                return new JavaScriptSerializer().Serialize(new ActionOutput<string>
                {
                    Status = ActionStatus.Successfull,
                    Message = userId + "," + newStatus + "," + oldStatus,
                    Object = "overlay"
                });
            }
            else if (newStatus == (int)JGConstant.InstallUserStatus.InterviewDate ||
                            newStatus == (int)JGConstant.InstallUserStatus.ReferralInterviewDate)
            {
                return new JavaScriptSerializer().Serialize(new ActionOutput<string>
                {
                    Status = ActionStatus.Successfull,
                    Message = userId + "," + newStatus + "," + oldStatus + ","
                                    + user["FristName"].ToString() + " " + user["LastName"].ToString()
                                    + "," + user["Designation"].ToString()
                                    + "," + user["Email"].ToString() + "," + "jmgrove"
                                    + "," + user["DesignationId"].ToString(),
                    Object = "overlayInterviewDate"
                });
                /*
                LoadUsersByRecruiterDesgination(ddlUsers);
                FillTechTaskDropDown(ddlTechTask, ddlTechSubTask, Convert.ToInt32(ddlDesignationForTask.SelectedValue));
                ddlInsteviewtime.DataSource = GetTimeIntervals();
                ddlInsteviewtime.DataBind();
                dtInterviewDate.Text = DateTime.Now.AddDays(1).ToShortDateString();
                ddlInsteviewtime.SelectedValue = "10:00 AM";
                ScriptManager.RegisterStartupScript(this, this.GetType(), "Overlay", "overlayInterviewDate()", true);
                return;
                */
            }
            else if (
                        newStatus == (int)JGConstant.InstallUserStatus.Deactive &&
                        (
                            (Convert.ToString(Session["usertype"]).Contains("Admin")) &&
                            (Convert.ToString(Session["usertype"]).Contains("SM"))
                        )
                    )
            {
                Session["DeactivationStatus"] = "Deactive";
                return new JavaScriptSerializer().Serialize(new ActionOutput<string>
                {
                    Status = ActionStatus.Successfull,
                    Message = userId + "," + newStatus + "," + oldStatus,
                    Object = "overlay"
                });
            }
            else if (newStatus == (int)JGConstant.InstallUserStatus.OfferMade ||
                        newStatus == (int)JGConstant.InstallUserStatus.ReferralOfferMade)
            {
                var branches = InstallUserBLL.Instance.GetBranchLocations();
                return new JavaScriptSerializer().Serialize(new ActionOutput<string>
                {
                    Status = ActionStatus.Successfull,
                    Message = userId + "," + newStatus + "," + oldStatus + ","
                                    + user["FristName"].ToString() + " " + user["LastName"].ToString()
                                    + "," + user["Designation"].ToString()
                                    + "," + user["Email"].ToString() + "," + "jmgrove"
                                    + "," + user["DesignationId"].ToString(),
                    Object = "OverlayPopupOfferMade",
                    Results = new List<string> { new JavaScriptSerializer().Serialize(branches) }
                });
                /*
                txtEmail.Text = lbtnEmail.Text;
                txtPassword1.Attributes.Add("value", "jmgrove");
                txtpassword2.Attributes.Add("value", "jmgrove");
                ScriptManager.RegisterStartupScript(this, this.GetType(), "Overlay", "OverlayPopupOfferMade();", true);
                return;
                */
            }
            /* Hide InstallProspect Status for now as per instruction by Justin on 12-September-2018
            if (newStatus == (int)JGConstant.InstallUserStatus.InstallProspect)
            {
                return new JavaScriptSerializer().Serialize(new ActionOutput
                {
                    Status = ActionStatus.Error,
                    Message = "Status cannot be changed to Install Prospect"
                });
            }
            */
            if (oldStatus == (int)JGConstant.InstallUserStatus.Active &&
                (!(Convert.ToString(Session["usertype"]).Contains("Admin"))))
            {
                return new JavaScriptSerializer().Serialize(new ActionOutput
                {
                    Status = ActionStatus.Error,
                    Message = "Status cannot be changed to any other status other than Deactive once user is Active"
                });
            }
            else
            {
                // Adding a popUp...
                InstallUserBLL.Instance.ChangeStatus(newStatus.ToString(), userId, DateTime.Today, DateTime.Now.ToShortTimeString(),
                                                    Convert.ToInt32(Session[JG_Prospect.Common.SessionKey.Key.UserId.ToString()]), JGSession.IsInstallUser.Value, "txtReason.Text");

                //Remove user from GitHub Repository
                if (newStatus == (int)JGConstant.InstallUserStatus.Deactive)
                {
                    String GitUserName = InstallUserBLL.Instance.GetUserGithubUserName(userId);
                    if (!string.IsNullOrEmpty(GitUserName.Trim()))
                    {
                        CommonFunction.DeleteUserFromGit(GitUserName, JGConstant.GitRepo.Interview);
                    }
                }

                //binddata();
                //GetSalesUsersStaticticsAndData();

                if (newStatus == (int)JGConstant.InstallUserStatus.Active ||
                    newStatus == (int)JGConstant.InstallUserStatus.Deactive)
                    return new JavaScriptSerializer().Serialize(new ActionOutput<string>
                    {
                        Status = ActionStatus.Successfull,
                        Message = userId + "," + newStatus + "," + oldStatus,
                        Object = "showStatusChangePopUp" // not found on edituser.aspx
                    });
                return new JavaScriptSerializer().Serialize(new ActionOutput
                {
                    Status = ActionStatus.Successfull,
                    Message = "Status Changed"
                });
            }
        }

        [WebMethod(EnableSession = true)]
        public string bulkDeactivateUsers(string userIds)
        {
            //if ((!(Convert.ToString(Session["usertype"]).Contains("Admin")) &&
            //                    !(Convert.ToString(Session["usertype"]).Contains("SM"))))
            //{
            //    return new JavaScriptSerializer().Serialize(new ActionOutput
            //    {
            //        Status = ActionStatus.Error,
            //        Message = "You do not have rights to change the status."
            //    });
            //}
            List<int> Ids = string.IsNullOrEmpty(userIds) ? new List<int>() :
                            userIds.Split(new char[] { ',' }, StringSplitOptions.RemoveEmptyEntries)
                                    .Select(m => Convert.ToInt32(m))
                                    .ToList();
            if (Ids.Count() > 0)
            {
                if (InstallUserBLL.Instance.DeactivateInstallUsers(Ids))
                {
                    return new JavaScriptSerializer().Serialize(new ActionOutput
                    {
                        Status = ActionStatus.Successfull,
                        Message = "User deactivated Successfully."
                    });
                }
                else
                {
                    return new JavaScriptSerializer().Serialize(new ActionOutput
                    {
                        Status = ActionStatus.Successfull,
                        Message = "User can not be deactivated. Please try again."
                    });
                }
            }
            return new JavaScriptSerializer().Serialize(new ActionOutput
            {
                Status = ActionStatus.Error,
                Message = "Please select user(s) to deactivated."
            });
        }

        [WebMethod(EnableSession = true)]
        public string ChangeUserStatusWithReason(int userId, int newStatus, string reason)
        {
            if (Convert.ToString(Session["DeactivationStatus"]) == "Deactive")
            {
                DataSet ds = new DataSet();
                string email = "";
                string HireDate = "";
                string EmpType = "";
                string PayRates = "";
                ds = InstallUserBLL.Instance.ChangeStatus(newStatus.ToString(), userId, DateTime.Today,
                        DateTime.Now.ToShortTimeString(),
                        Convert.ToInt32(Session[JG_Prospect.Common.SessionKey.Key.UserId.ToString()]),
                        JGSession.IsInstallUser.Value, reason);
                if (ds.Tables.Count > 0)
                {
                    if (ds.Tables[0].Rows.Count > 0)
                    {
                        if (Convert.ToString(ds.Tables[0].Rows[0][0]) != "")
                        {
                            email = Convert.ToString(ds.Tables[0].Rows[0][0]);
                        }
                        if (Convert.ToString(ds.Tables[0].Rows[0][1]) != "")
                        {
                            HireDate = Convert.ToString(ds.Tables[0].Rows[0][1]);
                        }
                        if (Convert.ToString(ds.Tables[0].Rows[0][2]) != "")
                        {
                            EmpType = Convert.ToString(ds.Tables[0].Rows[0][2]);
                        }
                        if (Convert.ToString(ds.Tables[0].Rows[0][3]) != "")
                        {
                            PayRates = Convert.ToString(ds.Tables[0].Rows[0][3]);
                        }
                    }
                }
                DataRow user = InstallUserBLL.Instance.getuserdetails(userId).Tables[0].Rows[0];
                SendEmail(JGConstant.EmailTypes.UserStatusChange.ToString(), email, user["FristName"].ToString(), user["LastName"].ToString(),
                            "Deactivation", reason, user["Designation"].ToString(),
                            Convert.ToInt32(user["DesignationId"].ToString()), HireDate, EmpType, PayRates, 0);
            }
            else
            {
                InstallUserBLL.Instance.ChangeStatus(newStatus.ToString(), userId, DateTime.Today, DateTime.Now.ToShortTimeString(), Convert.ToInt32(Session[JG_Prospect.Common.SessionKey.Key.UserId.ToString()]), JGSession.IsInstallUser.Value, reason);
            }

            //Remove user from GitHub Repository
            if (newStatus == (int)JGConstant.InstallUserStatus.Rejected)
            {
                String GitUserName = InstallUserBLL.Instance.GetUserGithubUserName(userId);
                if (!string.IsNullOrEmpty(GitUserName.Trim()))
                {
                    CommonFunction.DeleteUserFromGit(GitUserName, JGConstant.GitRepo.Interview);
                }
            }
            return new JavaScriptSerializer().Serialize(new ActionOutput
            {
                Status = ActionStatus.Successfull,
                Message = "Status Changed"
            });
        }

        [WebMethod(EnableSession = true)]
        public string UpdateEmpType(int userId, string empType)
        {
            InstallUserBLL.Instance.UpdateEmpType(userId, empType);
            return new JavaScriptSerializer().Serialize(new ActionOutput
            {
                Status = ActionStatus.Successfull,
                Message = "Status Changed"
            });
        }

        [WebMethod(EnableSession = true)]
        public string ChangeUserStatusOfferMade(int userId, int newStatus, string newEmail, string password, string branchLocationId)
        {
            InstallUserBLL.Instance.UpdateOfferMade(userId, newEmail, password, branchLocationId);

            DataSet ds = new DataSet();
            string email, HireDate, EmpType, PayRates, Desig, LastName, Address, FirstName;
            email = HireDate = EmpType = PayRates = Desig = LastName = Address = FirstName = String.Empty;

            ds = InstallUserBLL.Instance.ChangeStatus(newStatus.ToString(), userId, DateTime.Today, DateTime.Now.ToShortTimeString(), Convert.ToInt32(Session[JG_Prospect.Common.SessionKey.Key.UserId.ToString()]), JGSession.IsInstallUser.Value, "");
            if (ds.Tables.Count > 0)
            {
                if (ds.Tables[0].Rows.Count > 0)
                {
                    if (Convert.ToString(ds.Tables[0].Rows[0]["Email"]) != "")
                    {
                        email = Convert.ToString(ds.Tables[0].Rows[0]["Email"]);
                    }
                    if (Convert.ToString(ds.Tables[0].Rows[0]["HireDate"]) != "")
                    {
                        HireDate = Convert.ToString(ds.Tables[0].Rows[0]["HireDate"]);
                    }
                    if (Convert.ToString(ds.Tables[0].Rows[0]["EmpType"]) != "")
                    {
                        EmpType = Convert.ToString(ds.Tables[0].Rows[0]["EmpType"]);
                    }
                    if (Convert.ToString(ds.Tables[0].Rows[0]["PayRates"]) != "")
                    {
                        PayRates = Convert.ToString(ds.Tables[0].Rows[0]["PayRates"]);
                    }
                    if (Convert.ToString(ds.Tables[0].Rows[0]["Designation"]) != "")
                    {
                        Desig = Convert.ToString(ds.Tables[0].Rows[0]["Designation"]);
                    }
                    if (!String.IsNullOrEmpty(ds.Tables[0].Rows[0]["FristName"].ToString()))
                    {
                        FirstName = ds.Tables[0].Rows[0]["FristName"].ToString();
                    }
                    if (!String.IsNullOrEmpty(ds.Tables[0].Rows[0]["LastName"].ToString()))
                    {
                        LastName = ds.Tables[0].Rows[0]["LastName"].ToString();
                    }
                    if (!String.IsNullOrEmpty(ds.Tables[0].Rows[0]["Address"].ToString()))
                    {
                        Address = ds.Tables[0].Rows[0]["Address"].ToString();
                    }
                }
            }
            DataRow user = InstallUserBLL.Instance.getuserdetails(userId).Tables[0].Rows[0];
            //string strHtml = JG_Prospect.App_Code.CommonFunction.GetContractTemplateContent(199, 0, Desig);
            DesignationHTMLTemplate objHTMLTemplate = HTMLTemplateBLL.Instance.GetDesignationHTMLTemplate(HTMLTemplates.Offer_Made_Attachment_Template, user["DesignationId"].ToString());
            string strHtml = objHTMLTemplate.Header + objHTMLTemplate.Body + objHTMLTemplate.Footer;
            strHtml = strHtml.Replace("#CurrentDate#", DateTime.Now.ToShortDateString());
            strHtml = strHtml.Replace("#FirstName#", FirstName);
            strHtml = strHtml.Replace("#LastName#", LastName);
            strHtml = strHtml.Replace("#Address#", Address);
            strHtml = strHtml.Replace("#Designation#", Desig);
            if (!string.IsNullOrEmpty(EmpType))
            {
                int intEmpType = 0;
                int.TryParse(EmpType, out intEmpType);

                if (intEmpType > 0)
                {
                    EmpType = CommonFunction.GetEnumDescription((JGConstant.EmploymentType)intEmpType);
                }

                strHtml = strHtml.Replace("#EmpType#", EmpType);

            }
            else
            {
                strHtml = strHtml.Replace("#EmpType#", "________________");
            }
            strHtml = strHtml.Replace("#JoiningDate#", HireDate);
            if (!string.IsNullOrEmpty(PayRates))
            {
                strHtml = strHtml.Replace("#RatePerHour#", PayRates);
            }
            else
            {
                strHtml = strHtml.Replace("#RatePerHour#", "____");
            }
            DateTime dtPayCheckDate;
            if (!string.IsNullOrEmpty(HireDate))
            {
                dtPayCheckDate = Convert.ToDateTime(HireDate);
            }
            else
            {
                dtPayCheckDate = DateTime.Now;
            }
            dtPayCheckDate = new DateTime(dtPayCheckDate.Year, dtPayCheckDate.Month, DateTime.DaysInMonth(dtPayCheckDate.Year, dtPayCheckDate.Month));
            strHtml = strHtml.Replace("#PayCheckDate#", dtPayCheckDate.ToShortDateString());

            string strPath = JG_Prospect.App_Code.CommonFunction.ConvertHtmlToPdf(strHtml, Server.MapPath(@"~\Sr_App\MailDocument\MailAttachments\"), "Job acceptance letter");
            List<Attachment> lstAttachments = new List<Attachment>();
            if (File.Exists(strPath))
            {
                Attachment attachment = new Attachment(strPath);
                attachment.Name = Path.GetFileName(strPath);
                lstAttachments.Add(attachment);
            }

            SendEmail(JGConstant.EmailTypes.OfferMadeEmail.ToString(), email, FirstName, LastName, "Offer Made", "", Desig, Convert.ToInt32(user["DesignationId"].ToString()), HireDate, EmpType, PayRates,
                HTMLTemplates.Offer_Made_Auto_Email, lstAttachments);

            return new JavaScriptSerializer().Serialize(new ActionOutput { Status = ActionStatus.Successfull });
        }

        [WebMethod(EnableSession = true)]
        public string GetTechTasks(int designationId)
        {
            DataSet dsTechTask;
            if (designationId == 0)
            {
                dsTechTask = TaskGeneratorBLL.Instance.GetAllActiveTechTask();
            }
            else
            {
                dsTechTask = TaskGeneratorBLL.Instance.GetAllActiveTechTaskForDesignationID(designationId);
            }
            List<TechTask> tasks = new List<TechTask>();
            if (dsTechTask != null && dsTechTask.Tables[0] != null && dsTechTask.Tables[0].Rows.Count > 0)
            {
                foreach (DataRow item in dsTechTask.Tables[0].Rows)
                {
                    tasks.Add(new TechTask
                    {
                        Id = Convert.ToInt32(item["TaskId"].ToString()),
                        Title = item["Title"].ToString()
                    });
                }
            }
            return new JavaScriptSerializer().Serialize(new ActionOutput<TechTask>
            {
                Status = ActionStatus.Successfull,
                Results = tasks
            });
        }

        [WebMethod(EnableSession = true)]
        public string GetSubTechTasks(int taskId)
        {
            List<SubTechTask> subTasks = new List<SubTechTask>();
            DataSet dsSubTasks = TaskGeneratorBLL.Instance.GetTaskHierarchy(taskId, CommonFunction.CheckAdminAndItLeadMode());
            DataTable dtLevel1SubTasks = null;
            DataTable dtLevel2SubTasks = null;
            DataTable dtLevel3SubTasks = null;

            if (dsSubTasks != null && dsSubTasks.Tables.Count > 0 && dsSubTasks.Tables[0].Rows.Count > 0)
            {
                DataView dvSubTasks = dsSubTasks.Tables[0].DefaultView;

                dvSubTasks.RowFilter = string.Format("TaskId <> {0} AND TaskLevel = 1", taskId);
                dtLevel1SubTasks = dvSubTasks.ToTable();

                foreach (DataRow drSubTask1 in dtLevel1SubTasks.Rows)
                {
                    string strTaskId = Convert.ToString(drSubTask1["TaskId"]);
                    string strTitle = Convert.ToString(drSubTask1["Title"]);

                    subTasks.Add(new SubTechTask
                    {
                        Id = Convert.ToInt32(drSubTask1["TaskId"].ToString()),
                        Title = drSubTask1["Title"].ToString()
                    });

                    dvSubTasks.RowFilter = string.Format("ParentTaskId = {0} AND TaskLevel = 2", strTaskId);
                    dtLevel2SubTasks = dvSubTasks.ToTable();

                    foreach (DataRow drSubTask2 in dtLevel2SubTasks.Rows)
                    {
                        strTaskId = Convert.ToString(drSubTask2["TaskId"]);
                        strTitle = "|--" + Convert.ToString(drSubTask2["Title"]);

                        subTasks.Add(new SubTechTask
                        {
                            Id = Convert.ToInt32(drSubTask2["TaskId"].ToString()),
                            Title = "|--" + drSubTask2["Title"].ToString()
                        });

                        dvSubTasks.RowFilter = string.Format("ParentTaskId = {0} AND TaskLevel = 3", strTaskId);
                        dtLevel3SubTasks = dvSubTasks.ToTable();

                        foreach (DataRow drSubTask3 in dtLevel3SubTasks.Rows)
                        {
                            strTaskId = Convert.ToString(drSubTask3["TaskId"]);
                            strTitle = "|----" + Convert.ToString(drSubTask3["Title"]);

                            subTasks.Add(new SubTechTask
                            {
                                Id = Convert.ToInt32(drSubTask3["TaskId"].ToString()),
                                Title = "|----" + drSubTask3["Title"].ToString()
                            });
                        }
                    }
                }
            }

            return new JavaScriptSerializer().Serialize(new ActionOutput<SubTechTask>
            {
                Status = ActionStatus.Successfull,
                Results = subTasks
            });
        }

        [WebMethod(EnableSession = true)]
        public string GetRecruiters()
        {
            List<Recruiter> recruiters = new List<Recruiter>();
            DataSet dsUsers = TaskGeneratorBLL.Instance.GetInstallUsers(2, "Admin,Admin Recruiter,Office Manager,Recruiter,ITLead,");
            if (dsUsers != null && dsUsers.Tables.Count > 0)
            {
                DataView dvUsers = dsUsers.Tables[0].DefaultView;
                dvUsers.RowFilter = string.Format(
                                                    "[Status] IN ('{0}','{1}')",
                                                    Convert.ToByte(JGConstant.InstallUserStatus.Active).ToString(),
                                                    Convert.ToByte(JGConstant.InstallUserStatus.OfferMade).ToString()
                                                );
                dvUsers.Sort = "[Status] ASC";

                DataTable dtUsers = dvUsers.ToTable();

                for (int i = 0; i < dtUsers.Rows.Count; i++)
                {
                    DataRow objUser = dtUsers.Rows[i];
                    recruiters.Add(new Recruiter
                    {
                        Id = Convert.ToInt32(objUser["Id"].ToString()),
                        Name = objUser["FristName"].ToString(),
                        optionCss = Convert.ToInt32(objUser["Status"].ToString()) == (int)JGConstant.InstallUserStatus.Active ? "color-red" : ""
                    });
                }
            }

            return new JavaScriptSerializer().Serialize(new ActionOutput<Recruiter>
            {
                Status = ActionStatus.Successfull,
                Results = recruiters
            });
        }

        [WebMethod(EnableSession = true)]
        public string ChangeUserStatusToInterviewDate(string date, int status, int userId, string time,
                                                        int recruiterId, int taskId, int subTaskId, string recruiterName, string taskName,
                                                        int designationId, string designationName)
        {
            DataRow user = InstallUserBLL.Instance.getuserdetails(userId).Tables[0].Rows[0];
            DataSet ds = new DataSet();
            string email = "";
            string HireDate = "";
            string EmpType = "";
            string PayRates = "";
            string gitusername = string.Empty;


            //string InterviewDate = dtInterviewDate.Text;
            DateTime interviewDate;
            DateTime.TryParse(date, out interviewDate);
            if (interviewDate == null)
            {
                return new JavaScriptSerializer().Serialize(new ActionOutput
                {
                    Status = ActionStatus.Error,
                    Message = "Invalid Interview Date, Please verify"
                });
            }

            ds = InstallUserBLL.Instance.ChangeStatus(status.ToString(), userId, interviewDate, time, Convert.ToInt32(Session[JG_Prospect.Common.SessionKey.Key.UserId.ToString()]), JGSession.IsInstallUser.Value, "", recruiterId.ToString());
            if (ds.Tables.Count > 0)
            {
                if (ds.Tables[0].Rows.Count > 0)
                {
                    if (Convert.ToString(ds.Tables[0].Rows[0][0]) != "")
                    {
                        email = Convert.ToString(ds.Tables[0].Rows[0][0]);
                    }
                    if (Convert.ToString(ds.Tables[0].Rows[0][1]) != "")
                    {
                        HireDate = Convert.ToString(ds.Tables[0].Rows[0][1]);
                    }
                    if (Convert.ToString(ds.Tables[0].Rows[0][2]) != "")
                    {
                        EmpType = Convert.ToString(ds.Tables[0].Rows[0][2]);
                    }
                    if (Convert.ToString(ds.Tables[0].Rows[0][3]) != "")
                    {
                        PayRates = Convert.ToString(ds.Tables[0].Rows[0][3]);
                    }
                    if (ds.Tables[0].Rows[0]["GitUserName"] != null)
                    {
                        gitusername = ds.Tables[0].Rows[0]["GitUserName"].ToString();
                    }
                }
            }

            long EmailStatusId = SendInterviewEmail(JGConstant.EmailTypes.InterviewEmail.ToString(), email, user["FristName"].ToString(), user["LastName"].ToString(),
                "Interview Date Auto Email", "", user["Designation"].ToString(), Convert.ToInt32(user["DesignationId"].ToString()), date, time, EmpType,
                PayRates, HTMLTemplates.InterviewDateAutoEmail
                , null, recruiterName);
            string message = user["FristName"] + " " + user["LastName"] + "-" + user["UserInstallId"] + " has been assigned default interview date of - " + string.Format("{0:MMM d, yyyy, h:mm tt}", DateTime.Now.ToEST()) + "(EST)";
            message = "<span class='auto-entry'>" + message + "</span>";
            ChatBLL.Instance.AddHRChatMessage(userId, message, null);

            message = "Auto Email sent by JMGC PC-AREC-A0011 - Interview Date Reminder - " + string.Format("{0:MMM d, yyyy, h:mm tt}", DateTime.Now.ToEST()) + "(EST)";
            message = "<span class='auto-entry'>" + message + "</span>";
            ChatBLL.Instance.AddHRChatMessage(userId, message, EmailStatusId);
            if (!string.IsNullOrEmpty(gitusername))
            {
                CommonFunction.AddUserAsGitcollaborator(gitusername, JGConstant.GitRepo.Interview);
            }

            //AssignedTask if any or Default
            //AssignedTaskToUser(Convert.ToInt32(Session["EditId"]), ddlTechTask, ddlTechSubTask);
            // save assigned user a TASK.
            bool isSuccessful = TaskGeneratorBLL.Instance.SaveTaskAssignedToMultipleUsers(Convert.ToUInt64(subTaskId), userId.ToString());
            // Change task status to assigned = 3.
            if (isSuccessful)
                UpdateTaskStatus(Convert.ToInt32(subTaskId), Convert.ToUInt16(JGConstant.TaskStatus.Assigned));

            EmailStatusId = SendEmailToAssignedUsers(userId.ToString(), taskId.ToString(), subTaskId.ToString(), taskName,
                                                            designationId, designationName);

            // Send interview task assigned, with link.
            string strTaskLinkTitle = CommonFunction.GetTaskLinkTitleForAutoEmail(taskId);
            string taskUrl = string.Format("{0}?TaskId={1}&hstid={2}&{3}",
                                            string.Concat(HttpContext.Current.Request.Url.Scheme,
                                                          Uri.SchemeDelimiter,
                                                          HttpContext.Current.Request.Url.Host.Split('?')[0],
                                                          "/Sr_App/TaskGenerator.aspx"
                                                          ),
                                            taskId,
                                            subTaskId,
                                            strTaskLinkTitle);

            message = user["FristName"] + " " + user["LastName"] + "-" + user["UserInstallId"] +
                        " has been assigned with interview task " + taskName + "-<a target='_blank' href='" + taskUrl + "'>" + taskUrl + "</a> on - " + string.Format("{0:MMM d, yyyy, h:mm tt}", DateTime.Now.ToEST()) + " (EST)";
            message = "<span class='auto-entry'>" + message + "</span>";
            ChatBLL.Instance.AddHRChatMessage(userId, message, EmailStatusId);

            return new JavaScriptSerializer().Serialize(new ActionOutput
            {
                Status = ActionStatus.Successfull
            });
            // Response.Redirect(JG_Prospect.Common.JGConstant.PG_PATH_MASTER_CALENDAR);
        }

        private long SendEmailToAssignedUsers(string userID, string strTaskId, string strSubTaskId,
            string strTaskTitle, int designationId, string designationName)
        {
            try
            {
                DesignationHTMLTemplate objHTMLTemplate = HTMLTemplateBLL.Instance.GetDesignationHTMLTemplate(HTMLTemplates.Task_Generator_Auto_Email, JGSession.DesignationId.ToString());

                //foreach (string userID in strInstallUserIDs.Split(new char[] { ',' }, StringSplitOptions.RemoveEmptyEntries))
                //{
                DataSet dsUser = TaskGeneratorBLL.Instance.GetInstallUserDetails(Convert.ToInt32(userID));

                string emailId = dsUser.Tables[0].Rows[0]["Email"].ToString();
                string FName = dsUser.Tables[0].Rows[0]["FristName"].ToString();
                string LName = dsUser.Tables[0].Rows[0]["LastName"].ToString();
                string fullname = FName + " " + LName;

                string strHeader = objHTMLTemplate.Header;
                string strBody = objHTMLTemplate.Body;
                string strFooter = objHTMLTemplate.Footer;
                string strsubject = objHTMLTemplate.Subject;
                string strTaskLinkTitle = CommonFunction.GetTaskLinkTitleForAutoEmail(int.Parse(strTaskId));

                strsubject = strsubject.Replace("#ID#", strTaskId);
                strsubject = strsubject.Replace("#TaskTitleID#", strTaskTitle);
                strsubject = strsubject.Replace("#TaskTitle#", strTaskTitle);

                strBody = strBody.Replace("#ID#", strTaskId);
                strBody = strBody.Replace("#TaskTitleID#", strTaskTitle);
                strBody = strBody.Replace("#TaskTitle#", strTaskTitle);
                strBody = strBody.Replace("#Fname#", fullname);
                strBody = strBody.Replace("#email#", emailId);
                strBody = strBody.Replace("#Designation(s)#", designationName);
                strBody = strBody.Replace("#TaskLink#", string.Format(
                                                                        "{0}?TaskId={1}&hstid={2}&{3}",
                                                                        string.Concat(
                                                                                         HttpContext.Current.Request.Url.Scheme,
                                                                                        Uri.SchemeDelimiter,
                                                                                        HttpContext.Current.Request.Url.Host.Split('?')[0],
                                                                                        "/Sr_App/TaskGenerator.aspx"
                                                                                     ),
                                                                        strTaskId,
                                                                        strSubTaskId,
                                                                        strTaskLinkTitle
                                                                    )
                                        );


                strBody = strBody.Replace("#TaskTitle#", string.Format("{0}?TaskId={1}", HttpContext.Current.Request.Url.ToString().Split('?')[0], strTaskId));

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

                return CommonFunction.SendEmail(JGConstant.EmailTypes.TaskAutoEmail.ToString(), HTMLTemplates.Task_Generator_Auto_Email.ToString(), emailId, strsubject, strBody, lstAttachments);
                //}
            }
            catch (Exception ex)
            {
                return 0;
                //Console.WriteLine("{0} Exception caught.", ex);
            }
        }

        public bool CheckRequiredFields(string SelectedStatus, int Id)
        {
            DataSet dsNew = new DataSet();
            dsNew = InstallUserBLL.Instance.getuserdetails(Id);
            if (dsNew.Tables.Count > 0)
            {
                if (dsNew.Tables[0].Rows.Count > 0)
                {
                    if (SelectedStatus == "Applicant")
                    {
                        if (Convert.ToString(dsNew.Tables[0].Rows[0][1]) == "" || Convert.ToString(dsNew.Tables[0].Rows[0][2]) == "" || Convert.ToString(dsNew.Tables[0].Rows[0][3]) == "" || Convert.ToString(dsNew.Tables[0].Rows[0][8]) == "" || Convert.ToString(dsNew.Tables[0].Rows[0][38]) == "")
                        {
                            //ScriptManager.RegisterStartupScript(this, this.GetType(), "alert", "alert('Status cannot be changed to Applicant as required fields for it are not filled.')", true);
                            return false;
                        }
                    }
                    else if (SelectedStatus == "OfferMade" || SelectedStatus == "Offer Made")
                    {
                        //if (Convert.ToString(dsNew.Tables[0].Rows[0][1]) == "" || Convert.ToString(dsNew.Tables[0].Rows[0][2]) == "" || Convert.ToString(dsNew.Tables[0].Rows[0][4]) == "" || Convert.ToString(dsNew.Tables[0].Rows[0][5]) == "" || Convert.ToString(dsNew.Tables[0].Rows[0][11]) == "" || Convert.ToString(dsNew.Tables[0].Rows[0][12]) == "" || Convert.ToString(dsNew.Tables[0].Rows[0][13]) == "" || Convert.ToString(dsNew.Tables[0].Rows[0][3]) == "" || Convert.ToString(dsNew.Tables[0].Rows[0][8]) == "" || Convert.ToString(dsNew.Tables[0].Rows[0][38]) == "" || Convert.ToString(dsNew.Tables[0].Rows[0][44]) == "" || Convert.ToString(dsNew.Tables[0].Rows[0][46]) == "" || Convert.ToString(dsNew.Tables[0].Rows[0][48]) == "" || Convert.ToString(dsNew.Tables[0].Rows[0][50]) == "" || Convert.ToString(dsNew.Tables[0].Rows[0][100]) == "")
                        if (Convert.ToString(dsNew.Tables[0].Rows[0]["Email"]) == "" || Convert.ToString(dsNew.Tables[0].Rows[0]["Password"]) == "")
                        {
                            // txtEmail.Text = Convert.ToString(dsNew.Tables[0].Rows[0]["Email"]);
                            //ScriptManager.RegisterStartupScript(this, this.GetType(), "alert", "alert('Status cannot be changed to Offer Made as required fields for it are not filled.')", true);
                            return false;
                        }
                    }
                    else if (SelectedStatus == "Active")
                    {
                        if (Convert.ToString(dsNew.Tables[0].Rows[0][1]) == "" || Convert.ToString(dsNew.Tables[0].Rows[0][2]) == "" || Convert.ToString(dsNew.Tables[0].Rows[0][3]) == "" || Convert.ToString(dsNew.Tables[0].Rows[0][4]) == "" || Convert.ToString(dsNew.Tables[0].Rows[0][5]) == "" || Convert.ToString(dsNew.Tables[0].Rows[0][7]) == "" || Convert.ToString(dsNew.Tables[0].Rows[0][9]) == "" || Convert.ToString(dsNew.Tables[0].Rows[0][11]) == "" || Convert.ToString(dsNew.Tables[0].Rows[0][12]) == "" || Convert.ToString(dsNew.Tables[0].Rows[0][13]) == "" || Convert.ToString(dsNew.Tables[0].Rows[0][17]) == "" || Convert.ToString(dsNew.Tables[0].Rows[0][16]) == "" || Convert.ToString(dsNew.Tables[0].Rows[0][17]) == "" || Convert.ToString(dsNew.Tables[0].Rows[0][8]) == "" || Convert.ToString(dsNew.Tables[0].Rows[0][18]) == "" || Convert.ToString(dsNew.Tables[0].Rows[0][19]) == "" || Convert.ToString(dsNew.Tables[0].Rows[0][20]) == "" || Convert.ToString(dsNew.Tables[0].Rows[0][35]) == "" || Convert.ToString(dsNew.Tables[0].Rows[0][38]) == "" || Convert.ToString(dsNew.Tables[0].Rows[0][39]) == "" || Convert.ToString(dsNew.Tables[0].Rows[0][44]) == "" || Convert.ToString(dsNew.Tables[0].Rows[0][46]) == "" || Convert.ToString(dsNew.Tables[0].Rows[0][48]) == "" || Convert.ToString(dsNew.Tables[0].Rows[0][50]) == "" || Convert.ToString(dsNew.Tables[0].Rows[0][100]) == "")
                        {
                            //ScriptManager.RegisterStartupScript(this, this.GetType(), "alert", "alert('Status cannot be changed to Offer Made as required fields for it are not filled.')", true); 
                            return false;
                        }
                    }
                }
            }
            return true;
        }

        [WebMethod(EnableSession = true)]
        public string savePhoneCallLog(string mode, string num, string dur, int? userId,
            int? nextUserId, string chatGroupId, int UserChatGroupId)
        {
            PhoneCallLog phLog = new PhoneCallLog()
            {
                CreatedBy = JGSession.UserId,
                ReceiverNumber = num,
                Mode = mode,
                ReceiverUserId = userId,
                NextReceiverUserId = nextUserId,
                CallerNumber = "12154833098",
                CallDurationInSeconds = TimeSpan.Parse(dur).TotalSeconds
            };
            InstallUserBLL.Instance.SavePhoneCallLog(phLog);
            // Send Auto Email

            if (userId.HasValue)
            {
                string estTime = string.Format("{0:MMM d, yyyy, h:mm tt}", DateTime.UtcNow.ToEST()) + "(EST)";

                DataRow sender = InstallUserBLL.Instance.getuserdetails(JGSession.UserId).Tables[0].Rows[0];
                DataRow receiver = InstallUserBLL.Instance.getuserdetails(userId.Value).Tables[0].Rows[0];


                string senderUsername = sender["FristName"].ToString() + " " + sender["LastName"].ToString();
                string senderInstallId = sender["UserInstallId"].ToString();

                string receiverUsername = receiver["FristName"].ToString() + " " + receiver["LastName"].ToString();
                string receiverInstallId = receiver["UserInstallId"].ToString();

                string callNote = TimeSpan.Parse(dur).TotalSeconds > 0 ?
                    "Call Connected: JMGC PC-AREC-A0011 auto dialed " + receiverUsername + "-" + receiverInstallId + " on " + estTime :
                    "Call Not Connected: JMGC PC-AREC-A0011 auto dialed " + receiverUsername + "-" + receiverInstallId + " on " + estTime;
                callNote = "<span class='auto-entry'>" + callNote + "</span>";

                // Get Managers of the user
                List<LoginUser> managers = InstallUserBLL.Instance.GetUserManagers(userId.Value);
                List<int> managerIds = managers.Select(m => m.ID).OrderBy(m => m).ToList();
                List<int> allReceivers = managers.Select(m => m.ID).OrderBy(m => m).ToList();
                allReceivers.Add(userId.Value);
                string receivers = string.Join(",", allReceivers.OrderBy(m => m).ToList());
                var chat = ChatBLL.Instance.GetChatMessages(JGSession.UserId, chatGroupId,
                                    userId.Value.ToString(), (int)JG_Prospect.Common.ChatSource.EditUserPage, UserChatGroupId,
                                    1, 5);
                if (chat != null && chat.Results != null && chat.Results.Count() > 0)
                {
                    //  ChatGroupId = chat.Results[0].ChatGroupId;
                    // UserChatGroupId = UserChatGroupId;
                    List<int> oldReceivers = chat.Results[0].ReceiverIds.Split(new string[] { "," }, StringSplitOptions.RemoveEmptyEntries)
                                                        .Select(m => Convert.ToInt32(m)).ToList();
                    if (oldReceivers.Count > 1)
                    {
                        allReceivers = oldReceivers;
                    }
                    allReceivers.Add(userId.Value);
                    receivers = string.Join(",", allReceivers.OrderBy(m => m).ToList());
                }
                else
                {
                    chatGroupId = Guid.NewGuid().ToString();
                    // create chat group
                    //  UserChatGroupId = ChatBLL.Instance.AddMemberToChatGroup(ChatGroupId, id, JGSession.UserId, string.Join(",", managerIds.OrderBy(m => m).ToList()), UserChatGroupId);
                }
                if (TimeSpan.Parse(dur).TotalSeconds > 0)
                {
                    string baseurl = HttpContext.Current.Request.Url.Scheme + "://" +
                                        HttpContext.Current.Request.Url.Authority +
                                        HttpContext.Current.Request.ApplicationPath.TrimEnd('/') + "/";
                    int oldSecondaryStatus = string.IsNullOrEmpty(receiver["SecondaryStatus"].ToString()) ? 0 : Convert.ToInt32(receiver["SecondaryStatus"]);
                    string oldSecondaryStatusText = oldSecondaryStatus > 0 ? ((UserSecondaryStatus)oldSecondaryStatus).GetTypeText() : "";
                    string newSecondaryStatusText = UserSecondaryStatus.A_AutoEmailSent.GetTypeText();

                    string statusNote = InstallUserBLL.Instance.UpdateSecondaryStatus(userId.Value, (int)UserSecondaryStatus.A_AutoEmailSent,
                                                             newSecondaryStatusText, oldSecondaryStatus, oldSecondaryStatusText, JGSession.UserId, false);

                    long EmailStatusId = InstallUserBLL.Instance.SendCallConnectedAutoEmail(JGSession.UserId, userId.Value, sender["UserInstallId"].ToString(),
                        "", (int)ChatSource.PhoneCallLog, baseurl, chatGroupId, UserChatGroupId, receivers);

                    ChatParameter para = InstallUserBLL.Instance.GetChatParametersByUser(userId.Value, JGSession.UserId);
                    // make auto entry in hr chats
                    // call connected entry
                    //ChatBLL.Instance.AddHRChatMessage(userId.Value, note, null);

                    // make auto entry in hr chats
                    string emailNote = "Auto Email sent by JMGC PC-AREC-A0011 - Call Connected Email - " + estTime;
                    emailNote = "<span class='auto-entry'>" + emailNote + "</span>";

                    string note = callNote + "<br/>" + emailNote + "<br/>" + statusNote;

                    ChatBLL.Instance.AddHRChatMessage(userId.Value, note, EmailStatusId);
                }
                else
                {
                    // call not connected entry
                    ChatBLL.Instance.AddHRChatMessage(userId.Value, callNote, null);
                }
            }
            return new JavaScriptSerializer().Serialize(new ActionOutput { Status = ActionStatus.Successfull });
        }

        [WebMethod(EnableSession = true)]
        public string UpdateSecondaryStatus(int userId, int newStatus)
        {
            DataRow user = InstallUserBLL.Instance.getuserdetails(userId).Tables[0].Rows[0];
            int oldSecondaryStatus = string.IsNullOrEmpty(user["SecondaryStatus"].ToString()) ? 0 : Convert.ToInt32(user["SecondaryStatus"]);
            string oldSecondaryStatusText = oldSecondaryStatus > 0 ? ((UserSecondaryStatus)oldSecondaryStatus).GetTypeText() : "";
            string newSecondaryStatusText = ((UserSecondaryStatus)newStatus).GetTypeText();
            InstallUserBLL.Instance.UpdateSecondaryStatus(userId, newStatus, newSecondaryStatusText, oldSecondaryStatus, oldSecondaryStatusText, JGSession.UserId);
            return new JavaScriptSerializer().Serialize(new ActionOutput { Status = ActionStatus.Successfull });
        }

        [WebMethod(EnableSession = true)]
        public string GetPhoneCallLog(string callType, int index = 1, int pageSize = 5)
        {
            return new JavaScriptSerializer().Serialize(
                new ActionOutput<PhoneCallLog>
                {
                    Results = InstallUserBLL.Instance.GetPhoneCallLog(JGSession.UserId, callType, index, pageSize),
                    Status = ActionStatus.Successfull
                });
        }

        [WebMethod(EnableSession = true)]
        public string GetPhoneCallStatistics()
        {
            return new JavaScriptSerializer().Serialize(
                new ActionOutput<PhoneCallStatistics>
                {
                    Object = InstallUserBLL.Instance.GetPhoneCallStatistics(),
                    Status = ActionStatus.Successfull
                });
        }

        [WebMethod(EnableSession = true)]
        public string GetReminderEmailContent(int userId)
        {
            DataRow user = InstallUserBLL.Instance.getuserdetails(userId).Tables[0].Rows[0];
            DesignationHTMLTemplate objHTMLTemplate = HTMLTemplateBLL.Instance.GetDesignationHTMLTemplate(HTMLTemplates.InterviewDateAutoEmail, JGSession.DesignationId.ToString());

            string subject = objHTMLTemplate.Subject;
            string strBody = string.Concat(
                                                //objHTMLTemplate.Designation + " --- ",
                                                objHTMLTemplate.Header,
                                                objHTMLTemplate.Body,
                                                objHTMLTemplate.Footer
                                            );

            string strEmail = user["Email"].ToString();
            string strFirstName = user["FristName"].ToString();
            string strLastName = user["Lastname"].ToString();
            string strDesignation = user["Designation"].ToString();

            strBody = strBody.Replace("#Email#", strEmail).Replace("#email#", strEmail);
            strBody = strBody.Replace("#FirstName#", strFirstName);
            strBody = strBody.Replace("#LastName#", strLastName);
            strBody = strBody.Replace("#Name#", strFirstName).Replace("#name#", strFirstName);
            strBody = strBody.Replace("#Designation#", strDesignation).Replace("#designation#", strDesignation);

            return new JavaScriptSerializer().Serialize(new ActionOutput<ReminderEmail>
            {
                Status = ActionStatus.Successfull,
                Object = new ReminderEmail
                {
                    Body = strBody,
                    CustomMessage = "",
                    Email = strEmail,
                    Subject = subject,
                    UserId = Convert.ToInt32(user["Id"].ToString())
                }
            });
        }

        [WebMethod(EnableSession = true)]
        public string SendReminderEmailContent(int userId, string subject, string body, string customMessage)
        {
            subject = subject.Replace("Subject:", "").Trim();
            DataRow user = InstallUserBLL.Instance.getuserdetails(userId).Tables[0].Rows[0];
            DataSet ds = AdminBLL.Instance.GetEmailTemplate(JGSession.Designation, 110);

            if (ds == null)
            {
                ds = AdminBLL.Instance.GetEmailTemplate("Admin");
            }
            else if (ds.Tables[0].Rows.Count == 0)
            {
                ds = AdminBLL.Instance.GetEmailTemplate("Admin");
            }

            List<Attachment> lstAttachments = new List<Attachment>();

            for (int i = 0; i < ds.Tables[1].Rows.Count; i++)
            {
                string sourceDir = Server.MapPath(ds.Tables[1].Rows[i]["DocumentPath"].ToString());
                if (File.Exists(sourceDir))
                {
                    Attachment attachment = new Attachment(sourceDir);
                    attachment.Name = Path.GetFileName(sourceDir);
                    lstAttachments.Add(attachment);
                }
            }

            string strBody = body + customMessage;
            try
            {
                CommonFunction.SendEmail(JGConstant.EmailTypes.ReminderEmail.ToString(), JGSession.Designation, user["Email"].ToString(), subject, strBody, lstAttachments);
                return new JavaScriptSerializer().Serialize(
                    new ActionOutput
                    {
                        Status = ActionStatus.Successfull,
                        Message = "Email has been sent."
                    });
            }
            catch (Exception ex)
            {
                return new JavaScriptSerializer().Serialize(
                    new ActionOutput
                    {
                        Status = ActionStatus.Successfull,
                        Message = ex.Message
                    });
            }
        }
        #endregion

        [WebMethod(EnableSession = true)]
        public String GetMultiLevelList(string ParentTaskId, int chatSourceId)
        {
            string strMessage = string.Empty;
            DataSet dtResult = null;

            dtResult = TaskGeneratorBLL.Instance.GetMultilevelChildren(ParentTaskId);
            List<TaskMultiLevelList> list = new List<TaskMultiLevelList>();
            if (dtResult != null && dtResult.Tables.Count > 0)
            {
                var users = ChatBLL.Instance.GetTaskUsers(Convert.ToInt32(ParentTaskId)).Results;
                string receiverId = string.Empty;
                if (users != null && users.Count() > 0)
                {
                    receiverId = string.Join(",", users.OrderBy(m => m).ToList());
                }
                //if (dtResult != null && dtResult.Tables.Count > 0)
                //{
                //    dtResult.DataSetName = "ChildrenData";
                //    dtResult.Tables[0].TableName = "Children";
                //    System.Xml.XmlDocument doc = new System.Xml.XmlDocument();
                //    doc.LoadXml(dtResult.GetXml());
                //    strMessage = JsonConvert.SerializeXmlNode(doc);
                //}
                //else
                //{
                //    strMessage = String.Empty;
                //}
                foreach (DataRow item in dtResult.Tables[0].Rows)
                {
                    list.Add(new TaskMultiLevelList
                    {
                        ReceiverIds = receiverId,
                        Id = Convert.ToInt32(item["Id"].ToString()),
                        ParentTaskId = Convert.ToInt32(item["ParentTaskId"].ToString()),
                        Title = item["Title"] == null ? "" : item["Title"].ToString(),
                        Description = item["Description"].ToString(),
                        IndentLevel = Convert.ToInt32(item["IndentLevel"].ToString()),
                        InstallId = item["InstallId"].ToString(),
                        Label = item["Label"].ToString(),
                        StartDate = string.IsNullOrEmpty(item["StartDate"].ToString()) ? null :
                                        (DateTime?)(Convert.ToDateTime(item["StartDate"].ToString())),
                        EndDate = string.IsNullOrEmpty(item["EndDate"].ToString()) ? null :
                                        (DateTime?)(Convert.ToDateTime(item["EndDate"].ToString())),
                        UserChatGroupId = string.IsNullOrEmpty(item["UserChatGroupId"].ToString()) ? 0
                                            : Convert.ToInt32(item["UserChatGroupId"].ToString()),

                        EstimatedHoursITLead = string.IsNullOrEmpty(item["EstimatedHoursITLead"].ToString()) ? false : true,
                        EstimatedHoursUser = string.IsNullOrEmpty(item["EstimatedHoursUser"].ToString()) ? false : true,
                        DateCreated = string.IsNullOrEmpty(item["DateCreated"].ToString()) ? null :
                                        (DateTime?)(Convert.ToDateTime(item["DateCreated"].ToString())),
                        DateUpdatedITLead = string.IsNullOrEmpty(item["DateUpdatedITLead"].ToString()) ? null :
                                        (DateTime?)(Convert.ToDateTime(item["DateUpdatedITLead"].ToString())),
                        ITLeadId = string.IsNullOrEmpty(item["ITLeadId"].ToString()) ? 1 : 0,
                        DateUpdatedUser = string.IsNullOrEmpty(item["DateUpdatedUser"].ToString()) ? null :
                                        (DateTime?)(Convert.ToDateTime(item["DateUpdatedUser"].ToString())),
                        UserId = string.IsNullOrEmpty(item["UserId"].ToString()) ? 1 : 0,
                        DisplayOrder = string.IsNullOrEmpty(item["DisplayOrder"].ToString()) ? 1 : int.Parse(item["DisplayOrder"].ToString()),
                        Status = string.IsNullOrEmpty(item["Status"].ToString()) ? 0 : int.Parse(item["Status"].ToString()),
                        ITLeadName = item["ITLeadName"].ToString(),
                        UserName = item["UserName"].ToString(),
                        TaskAssignedUserIds = item["TaskAssignedUserIds"].ToString(),
                    });
                }
                foreach (var row in list)
                {
                    List<ChatMessage> chatMessages = ChatBLL.Instance.GetTaskChatMessages(JGSession.UserId, chatSourceId, row.ParentTaskId, 1, 5, row.Id).Results;
                    row.Notes = chatMessages.Select(m => new Notes
                    {
                        UserChatGroupId = m.UserChatGroupId,
                        TaskMultilevelListId = row.Id,
                        TaskId = row.ParentTaskId,
                        UpdatedByUserID = m.UserId,
                        UpdatedUserInstallID = m.UserInstallId,
                        ChangeDateTime = m.MessageAt,
                        LogDescription = m.Message,
                        UpdatedByFirstName = m.UserFullname.Split(new char[] { ' ' }, StringSplitOptions.RemoveEmptyEntries)[0],
                        UpdatedByLastName = m.UserFullname.Split(new char[] { ' ' }, StringSplitOptions.RemoveEmptyEntries).Count() > 1 ? m.UserFullname.Split(new char[] { ' ' }, StringSplitOptions.RemoveEmptyEntries)[1] : "",
                        UpdatedByEmail = "",
                        FristName = m.UserFullname.Split(new char[] { ' ' }, StringSplitOptions.RemoveEmptyEntries)[0],
                        LastName = m.UserFullname.Split(new char[] { ' ' }, StringSplitOptions.RemoveEmptyEntries).Count() > 1 ? m.UserFullname.Split(new char[] { ' ' }, StringSplitOptions.RemoveEmptyEntries)[1] : "",
                        Email = "",
                        Phone = "",
                        ChangeDateTimeFormatted = m.MessageAtFormatted,
                        SourceUser = m.UserFullname.Split(new char[] { ' ' }, StringSplitOptions.RemoveEmptyEntries)[0],
                        SourceUserInstallId = m.UserInstallId,
                        SourceUsername = m.UserFullname,
                        TouchPointSource = m.ChatSourceId
                    }).OrderByDescending(x => x.ChangeDateTime).OrderByDescending(x => x.ChangeDateTime).ToList();
                }
                return new JavaScriptSerializer().Serialize(new ActionOutput<TaskMultiLevelList>
                {
                    Status = ActionStatus.Successfull,
                    Results = list
                });
            }
            else
            {
                return new JavaScriptSerializer().Serialize(new ActionOutput { Status = ActionStatus.Successfull });
            }
        }

        #region Manage Resources
        [WebMethod(EnableSession = true)]
        public string GetDesignations()
        {
            string strMessage = string.Empty;
            DataSet dtDesig = CommonFunction.GetDesignations();
            //DataSet dtDesig = FoldersBLL.Instance.GetFoldersByDesgId(9);
            if (dtDesig != null && dtDesig.Tables.Count > 0 && dtDesig.Tables[0].Rows.Count > 0)
            {
                strMessage = JsonConvert.SerializeObject(dtDesig.Tables[0], Formatting.Indented);
            }
            else
            {
                strMessage = String.Empty;
            }
            return strMessage;
        }

        [WebMethod(EnableSession = true)]
        public string GetSources(string data)
        {
            string strMessage = string.Empty;
            DataSet dtDesig = CommonFunction.GetDesignations();
            //DataSet dtDesig = FoldersBLL.Instance.GetFoldersByDesgId(9);
            if (dtDesig != null && dtDesig.Tables.Count > 0 && dtDesig.Tables[0].Rows.Count > 0)
            {
                strMessage = JsonConvert.SerializeObject(dtDesig.Tables[0], Formatting.Indented);
            }
            else
            {
                strMessage = String.Empty;
            }
            return strMessage;
        }

        [WebMethod(EnableSession = true)]
        public string GetLocation(string data)
        {
            string strMessage = string.Empty;
            List<ListResult> locations = new List<ListResult>();
            foreach (Enums.Location foo in Enum.GetValues(typeof(Enums.Location)))
            {
                locations.Add(new ListResult() { Id = (int)foo, Value = foo.ToEnumDescription() });
            }

            strMessage = JsonConvert.SerializeObject(locations, Formatting.Indented);
            return strMessage;
        }

        [WebMethod(EnableSession = true)]
        public string GetResourceTypes(string data)
        {
            string strMessage = string.Empty;
            List<ListResult> resourceTypes = new List<ListResult>();
            foreach (Enums.ResourceType foo in Enum.GetValues(typeof(Enums.ResourceType)))
            {
                resourceTypes.Add(new ListResult() { Id = (int)foo, Value = foo.ToString() });
            }

            strMessage = JsonConvert.SerializeObject(resourceTypes, Formatting.Indented);
            return strMessage;
        }


        [WebMethod(EnableSession = true)]
        public string GetFolders(int designationId, int locationid)
        {
            List<Folders> folders = new List<Folders>();
            string strMessage = string.Empty;
            DataSet dtFolders = FoldersBLL.Instance.GetFoldersByDesgId(designationId, locationid);

            if (dtFolders != null && dtFolders.Tables.Count > 0 && dtFolders.Tables[0].Rows.Count > 0)
            {
                strMessage = JsonConvert.SerializeObject(dtFolders.Tables[0], Formatting.Indented);
            }
            else
            {
                strMessage = String.Empty;
            }
            return strMessage;
        }

        [WebMethod(EnableSession = true)]
        public string SaveFolders(string name, int designationId, int locationid)
        {
            int result = 0;
            try
            {
                result = FoldersBLL.Instance.InsertFolders(name, designationId, locationid, JGSession.UserId);

                var originalDirectory = new DirectoryInfo(Server.MapPath(JGConstant.ResourceFilePath));
                JGCommon.CreateIfNotExists(Convert.ToString(originalDirectory));

                // Create Designation Folder
                var desigFolderPath = originalDirectory + "\\" + designationId.ToString();
                JGCommon.CreateIfNotExists(Convert.ToString(desigFolderPath));

                var folderPath = desigFolderPath + "\\" + name;
                JGCommon.CreateIfNotExists(Convert.ToString(folderPath));
            }
            catch (Exception ex)
            {
                return new JavaScriptSerializer().Serialize(new ActionOutput { Status = ActionStatus.Error });
            }

            return new JavaScriptSerializer().Serialize(new ActionOutput { Status = ActionStatus.Successfull, ID = result });
        }

        [WebMethod(EnableSession = true)]
        public string SaveFiles(string name, int folderId, int designationId, int locationId)
        {
            if (!string.IsNullOrEmpty(name) && name.Split('^').Length > 0)
            {
                foreach (var item in name.Split('^'))
                {
                    if (!string.IsNullOrEmpty(item))
                    {
                        string strFilePath = Server.MapPath("~/UploadedExcel/" + item.Split('@')[0]);
                        string uniqueFileName = Path.GetFileName(strFilePath);
                        string fileName = item.Split('@')[1];
                        string Extension = Path.GetExtension(strFilePath);
                        if (File.Exists(strFilePath))
                        {
                            DataSet dsFolder = FoldersBLL.Instance.GetFoldersByd(folderId);
                            if (dsFolder != null && dsFolder.Tables.Count > 0 && dsFolder.Tables[0] != null && dsFolder.Tables[0].Rows.Count > 0)
                            {
                                var folderName = Convert.ToString(dsFolder.Tables[0].Rows[0]["Name"]);
                                var originalDirectory = new DirectoryInfo(Server.MapPath(JGConstant.ResourceFilePath));
                                JGCommon.CreateIfNotExists(Convert.ToString(originalDirectory));

                                // Create Designation Folder
                                var desigFolderPath = originalDirectory + "\\" + designationId.ToString();
                                JGCommon.CreateIfNotExists(Convert.ToString(desigFolderPath));

                                var folderPath = desigFolderPath + "\\" + folderName;
                                JGCommon.CreateIfNotExists(Convert.ToString(folderPath));
                                var filePath = folderPath + "\\" + uniqueFileName;

                                File.Move(strFilePath, filePath);

                                int resourceTypeId = Convert.ToInt32(CommonFunction.GetFileType(fileName));

                                FilesBLL.Instance.InsertFiles(fileName, uniqueFileName, folderId, JGSession.UserId, designationId, resourceTypeId, locationId);
                            }
                        }
                    }
                }
            }

            return new JavaScriptSerializer().Serialize(new ActionOutput { Status = ActionStatus.Successfull });
        }

        [WebMethod(EnableSession = true)]
        public string DeleteFolders(int folderId, int locationid)
        {
            try
            {
                string name = FoldersBLL.Instance.DeleteFolders(folderId, locationid);

                var originalDirectory = new DirectoryInfo(Server.MapPath(JGConstant.ResourceFilePath));
                var folderPath = Convert.ToString(originalDirectory) + "\\" + name;
                bool isExists = System.IO.Directory.Exists(folderPath);
                if (isExists)
                {
                    DirectoryInfo d = new DirectoryInfo(folderPath);//Assuming Test is your Folder
                    FileInfo[] Files = d.GetFiles(); //Getting Text files
                    foreach (FileInfo file in Files)
                    {
                        file.Delete();
                    }
                    System.IO.Directory.Delete(folderPath);
                }
            }
            catch (Exception ex)
            {
                return new JavaScriptSerializer().Serialize(new ActionOutput { Status = ActionStatus.Error });
            }

            return new JavaScriptSerializer().Serialize(new ActionOutput { Status = ActionStatus.Successfull });
        }

        [WebMethod(EnableSession = true)]
        public string DeleteFiles(int fileId, int folderid, int designationid, int locationid)
        {
            try
            {
                string name = FilesBLL.Instance.DeleteFiles(fileId, folderid, designationid, locationid);
                var originalDirectory = new DirectoryInfo(Server.MapPath(JGConstant.ResourceFilePath));
                var filePath = Convert.ToString(originalDirectory) + "\\" + name;
                bool isExists = System.IO.File.Exists(filePath);
                if (isExists)
                {
                    File.Delete(filePath);
                }
            }
            catch (Exception ex)
            {
                return new JavaScriptSerializer().Serialize(new ActionOutput { Status = ActionStatus.Error });
            }

            return new JavaScriptSerializer().Serialize(new ActionOutput { Status = ActionStatus.Successfull });
        }
        [WebMethod(EnableSession = true)]
        public string SwapFolderOrder(int currentfolderid, int folderToSwapid)
        {
            try
            {
                FoldersBLL.Instance.SwapFolderOrder(currentfolderid, folderToSwapid);
            }
            catch (Exception ex)
            {
                return new JavaScriptSerializer().Serialize(new ActionOutput { Status = ActionStatus.Error });
            }

            return new JavaScriptSerializer().Serialize(new ActionOutput { Status = ActionStatus.Successfull });
        }

        [WebMethod(EnableSession = true)]
        public string SwapFileOrder(int currentfileid, int fileToSwapid)
        {
            try
            {
                FilesBLL.Instance.SwapFileOrder(currentfileid, fileToSwapid);
            }
            catch (Exception ex)
            {
                return new JavaScriptSerializer().Serialize(new ActionOutput { Status = ActionStatus.Error });
            }

            return new JavaScriptSerializer().Serialize(new ActionOutput { Status = ActionStatus.Successfull });
        }
        [WebMethod(EnableSession = true)]
        public string GetFiles(int locationId)
        {
            List<Folders> folders = new List<Folders>();
            string strMessage = string.Empty;
            DataSet dtFolders = FilesBLL.Instance.GetFilesTreeView(locationId);

            List<FilesTreeViewCategoriesNested> lstFilesTreeViewCategoriesNested = new List<FilesTreeViewCategoriesNested>();
            foreach (DataRow dr in dtFolders.Tables[0].Rows)
            {
                lstFilesTreeViewCategoriesNested.Add(new FilesTreeViewCategoriesNested() { Title = dr["Name"].ToString(), UniqueName = dr["UniqueName"].ToString(), ID = int.Parse(dr["ID"].ToString()), FolderId = int.Parse(dr["FolderId"].ToString()), Type = int.Parse(dr["ResourceTypeId"].ToString()), DesignationId = int.Parse(dr["DesignationId"].ToString()) });
            }

            List<FilesTreeViewCategories> lstFilesTreeViewCategories = new List<FilesTreeViewCategories>();
            foreach (DataRow dr in dtFolders.Tables[1].Rows)
            {
                lstFilesTreeViewCategories.Add(new FilesTreeViewCategories() { Title = dr["Name"].ToString(), Id = int.Parse(dr["FolderId"].ToString()), DesignationId = int.Parse(dr["DesignationId"].ToString()), Categories = lstFilesTreeViewCategoriesNested.Where(x => x.FolderId == int.Parse(dr["FolderId"].ToString())).ToList() });
            }

            List<FilesTreeView> lstFilesTreeViews = new List<FilesTreeView>();
            foreach (DataRow dr in dtFolders.Tables[2].Rows)
            {
                lstFilesTreeViews.Add(new FilesTreeView() { Title = dr["DesignationName"].ToString(), Categories = lstFilesTreeViewCategories.Where(x => x.DesignationId == int.Parse(dr["DesignationId"].ToString())).ToList() });
            }

            //if (dtFolders != null && dtFolders.Tables.Count > 0 && dtFolders.Tables[0].Rows.Count > 0)
            //{

            //    dtFolders.Tables[0].AsEnumerable().Select(d => d.Field<string>("DesignationName")).Distinct().ToList().ForEach(d =>
            //    {
            //        FilesTreeView filesTreeView = new FilesTreeView();
            //        filesTreeView.Title = d;
            //        List<FilesTreeViewCategories> lstFilesTreeViewCategories = new List<FilesTreeViewCategories>();
            //        dtFolders.Tables[0].AsEnumerable().Where(k => k.Field<string>("DesignationName") == d).Select(k => k.Field<string>("FolderName")).Distinct().ToList().ForEach(k =>
            //        {

            //            List<FilesTreeViewCategoriesNested> lstFilesTreeViewCategoriesNested = new List<FilesTreeViewCategoriesNested>();
            //            dtFolders.Tables[0].AsEnumerable().Where(x => x.Field<string>("FolderName") == k).Select(x => new { Id = x.Field<int>("ID"), Name = x.Field<string>("Name"), Type = x.Field<int>("ResourceTypeId") }).ToList().ForEach(x =>
            //            {
            //                lstFilesTreeViewCategoriesNested.Add(new FilesTreeViewCategoriesNested() { Title = x.Name, ID = x.Id, Type = x.Type });
            //            });
            //            lstFilesTreeViewCategories.Add(new FilesTreeViewCategories() { Title = k,  Categories = lstFilesTreeViewCategoriesNested.Distinct().ToList() });
            //        });
            //        filesTreeView.Categories = lstFilesTreeViewCategories.Distinct().ToList();
            //        lstFilesTreeViews.Add(filesTreeView);
            //    });

            //List<FilesTreeView> lstFilesTreeViewsnew = new List<FilesTreeView>();
            //List<FilesTreeViewCategories> lstFilesTreeViewCategoriesnew = new List<FilesTreeViewCategories>();
            //List<FilesTreeViewCategoriesNested> lstFilesTreeViewCategoriesNestednew = new List<FilesTreeViewCategoriesNested>();

            //foreach(FilesTreeView filesTreeView in lstFilesTreeViews)
            //{
            //    foreach(FilesTreeViewCategories FilesTreeViewCategories in filesTreeView.Categories)
            //    {
            //        for(FilesTreeViewCategoriesNested FilesTreeViewCategoriesNested in FilesTreeViewCategories.Categories)
            //        {
            //            var objFilesTreeViewCategoriesNested = lstFilesTreeViewCategoriesNestednew.Where(x => x.ID == FilesTreeViewCategoriesNested.ID);
            //            lstFilesTreeViewCategoriesNestednew.Add(FilesTreeViewCategoriesNested);
            //        }
            //    }
            //}
            strMessage = JsonConvert.SerializeObject(lstFilesTreeViews, Formatting.Indented);
            //}
            //else
            //{
            //    strMessage = String.Empty;
            //}
            return strMessage;
        }

        [WebMethod(EnableSession = true)]
        public string GetFilesByDesignationId(int locationId, int DesignationId)
        {
            List<Folders> folders = new List<Folders>();
            string strMessage = string.Empty;
            DataSet dtFolders = FilesBLL.Instance.GetFilesTreeViewByDesignationId(locationId, DesignationId);

            if (dtFolders != null && dtFolders.Tables.Count > 0 && dtFolders.Tables[0].Rows.Count > 0)
            {
                List<FilesTreeView> lstFilesTreeViews = new List<FilesTreeView>();
                dtFolders.Tables[0].AsEnumerable().Select(d => d.Field<string>("DesignationName")).Distinct().ToList().ForEach(d =>
                {
                    FilesTreeView filesTreeView = new FilesTreeView();
                    filesTreeView.Title = d;
                    List<FilesTreeViewCategories> lstFilesTreeViewCategories = new List<FilesTreeViewCategories>();
                    dtFolders.Tables[0].AsEnumerable().Where(k => k.Field<string>("DesignationName") == d).Select(k => k.Field<string>("FolderName")).Distinct().ToList().ForEach(k =>
                    {

                        List<FilesTreeViewCategoriesNested> lstFilesTreeViewCategoriesNested = new List<FilesTreeViewCategoriesNested>();
                        dtFolders.Tables[0].AsEnumerable().Where(x => x.Field<string>("FolderName") == k).Select(x => new { Id = x.Field<int>("ID"), Name = x.Field<string>("Name"), Type = x.Field<int>("ResourceTypeId"), UniqueName = x.Field<string>("UniqueName"), DesignationId = x.Field<int>("DesignationId") }).ToList().ForEach(x =>
                        {
                            lstFilesTreeViewCategoriesNested.Add(new FilesTreeViewCategoriesNested() { Title = x.Name, UniqueName = x.UniqueName, DesignationId = x.DesignationId, ID = x.Id, Type = x.Type });
                        });
                        lstFilesTreeViewCategories.Add(new FilesTreeViewCategories() { Title = k, Categories = lstFilesTreeViewCategoriesNested });
                    });
                    filesTreeView.Categories = lstFilesTreeViewCategories;
                    lstFilesTreeViews.Add(filesTreeView);
                });
                strMessage = JsonConvert.SerializeObject(lstFilesTreeViews, Formatting.Indented);
            }
            else
            {
                strMessage = String.Empty;
            }
            return strMessage;
        }

        [WebMethod(EnableSession = true)]
        public string SaveFilesForMultipleDesignations(string Foldername, int LocationId, string designationIds, string FileNames)
        {
            String Result = String.Empty;

            if (!String.IsNullOrEmpty(designationIds))
            {
                //1. Create folder for all given designations and save folder id for respective designation.
                Dictionary<int, int> dicDesFolder = CreateFoldersForMultipleDesignations(designationIds, Foldername, LocationId);

                //2. Save file for each designations from its respective folderid saved in dictonary.
                SaveFilesForMultipleDesignations(LocationId, FileNames, dicDesFolder);

                Result = new JavaScriptSerializer().Serialize(new ActionOutput { Status = ActionStatus.Successfull });
            }
            else
            {
                Result = new JavaScriptSerializer().Serialize(new ActionOutput { Status = ActionStatus.Error });
            }

            return Result;
        }

        private void SaveFilesForMultipleDesignations(int LocationId, string FileNames, Dictionary<int, int> dicDesFolder)
        {
            // Copy files under each designations.
            foreach (KeyValuePair<int, int> DesgNFolderId in dicDesFolder)
            {
                if (!string.IsNullOrEmpty(FileNames) && FileNames.Split('^').Length > 0)
                {
                    // for all uplaoded files iterate through and save under each desination. 
                    foreach (var item in FileNames.Split('^'))
                    {
                        if (!string.IsNullOrEmpty(item))
                        {
                            string strFilePath = Server.MapPath("~/UploadedExcel/" + item.Split('@')[0]);
                            string uniqueFileName = Path.GetFileName(strFilePath);
                            string fileName = item.Split('@')[1];
                            string Extension = Path.GetExtension(strFilePath);
                            if (File.Exists(strFilePath))
                            {
                                DataSet dsFolder = FoldersBLL.Instance.GetFoldersByd(DesgNFolderId.Value);
                                if (dsFolder != null && dsFolder.Tables.Count > 0 && dsFolder.Tables[0] != null && dsFolder.Tables[0].Rows.Count > 0)
                                {
                                    var folderName = Convert.ToString(dsFolder.Tables[0].Rows[0]["Name"]);
                                    var originalDirectory = new DirectoryInfo(Server.MapPath(JGConstant.ResourceFilePath));
                                    JGCommon.CreateIfNotExists(Convert.ToString(originalDirectory));

                                    // Create Designation Folder
                                    var desigFolderPath = originalDirectory + "\\" + DesgNFolderId.Key.ToString();
                                    JGCommon.CreateIfNotExists(Convert.ToString(desigFolderPath));

                                    var folderPath = desigFolderPath + "\\" + folderName;
                                    JGCommon.CreateIfNotExists(Convert.ToString(folderPath));

                                    var filePath = folderPath + "\\" + uniqueFileName;
                                    File.Copy(strFilePath, filePath);
                                    FilesBLL.Instance.InsertFiles(fileName, uniqueFileName, DesgNFolderId.Value, JGSession.UserId, DesgNFolderId.Key, Convert.ToInt16(CommonFunction.GetFileType(fileName)), LocationId);
                                }
                            }
                        }
                    }
                }
            }

            // Clear all files from temp uploaded folders.
            if (!string.IsNullOrEmpty(FileNames) && FileNames.Split('^').Length > 0)
            {
                // for all uplaoded files iterate through and save under each desination. 
                foreach (var item in FileNames.Split('^'))
                {
                    if (!string.IsNullOrEmpty(item))
                    {
                        string strFilePath = Server.MapPath("~/UploadedExcel/" + item.Split('@')[0]);
                        string uniqueFileName = Path.GetFileName(strFilePath);
                        string fileName = item.Split('@')[1];
                        string Extension = Path.GetExtension(strFilePath);
                        if (File.Exists(strFilePath))
                        {
                            File.Delete(strFilePath);
                        }
                    }
                }
            }

        }

        private Dictionary<int, int> CreateFoldersForMultipleDesignations(string designationIds, string Foldername, int locationid)
        {
            Dictionary<int, int> dicDesFolder = new Dictionary<int, int>();
            // Prepare total designations for which folder and files needs to be saved.
            String[] DesignationIds = designationIds.Split(new char[] { ',' }, StringSplitOptions.RemoveEmptyEntries);

            foreach (String DesgId in DesignationIds)
            {
                //1. Create folder for all given designations and save folder id for respective designation.
                int result = 0;
                try
                {
                    int DesigId = Convert.ToInt32(DesgId);

                    result = FoldersBLL.Instance.InsertFolders(Foldername, DesigId, locationid, JGSession.UserId);

                    var originalDirectory = new DirectoryInfo(Server.MapPath(JGConstant.ResourceFilePath));

                    JGCommon.CreateIfNotExists(Convert.ToString(originalDirectory));

                    // Create Designation Folder
                    var desigFolderPath = originalDirectory + "\\" + DesigId.ToString();
                    JGCommon.CreateIfNotExists(Convert.ToString(desigFolderPath));

                    var folderPath = desigFolderPath + "\\" + Foldername;
                    JGCommon.CreateIfNotExists(Convert.ToString(folderPath));

                    dicDesFolder.Add(DesigId, result);
                }
                catch (Exception ex)
                {

                }
            }

            return dicDesFolder;
        }

        #endregion

        [WebMethod(EnableSession = true)]
        public string GlobalSearch(string keyword)
        {
            return new JavaScriptSerializer().Serialize(
                new ActionOutput<GlobalSearchModel>
                {
                    Object = InstallUserBLL.Instance.GlobalSearch(keyword, JGSession.UserId),
                    Status = ActionStatus.Successfull
                });
        }

        #region Web to Web Calling
        [WebMethod(EnableSession = true)]
        public string InitiateWebToWebCall(bool IsGroupCall, int? userchatgroupid, int? userid)
        {
            var onlineChats = ChatBLL.Instance.GetOnlineUsers(JGSession.UserId, "active", "", 1,
                                                    20, null, "chats", false, null);
            SingletonUserChatGroups.Instance.ActiveUsers = onlineChats.Results;
            if (SingletonUserChatGroups.Instance.ActiveUsers != null)
            {
                SingletonUserChatGroups.Instance.ActiveUsers = SingletonUserChatGroups.Instance.ActiveUsers
                                                                            // .Where(m => m.Status == (int)ChatUserStatus.Active)
                                                                            //.OrderBy(m=>m.InstallUserStatusId.Value)
                                                                            //.ThenBy(m => m.Status)
                                                                            .ToList();
                var actives = SingletonUserChatGroups.Instance.ActiveUsers.Where(x => x.InstallUserStatusId == (int)InstallUserStatus.Active)
                                                     .OrderBy(x => x.Status).ToList();
                var offerMade = SingletonUserChatGroups.Instance.ActiveUsers.Where(x => x.InstallUserStatusId == (int)InstallUserStatus.OfferMade)
                                                     .OrderBy(x => x.Status).ToList();
                var interviewDate = SingletonUserChatGroups.Instance.ActiveUsers.Where(x => x.InstallUserStatusId == (int)InstallUserStatus.InterviewDate)
                                                     .OrderBy(x => x.Status).ToList();
                var applicant = SingletonUserChatGroups.Instance.ActiveUsers.Where(x => x.InstallUserStatusId == (int)InstallUserStatus.Applicant)
                                                     .OrderBy(x => x.Status).ToList();
                var referralApplicant = SingletonUserChatGroups.Instance.ActiveUsers.Where(x => x.InstallUserStatusId == (int)InstallUserStatus.ReferralApplicant)
                                                     .OrderBy(x => x.Status).ToList();

                SingletonUserChatGroups.Instance.ActiveUsers = new List<ActiveUser>();
                SingletonUserChatGroups.Instance.ActiveUsers.AddRange(actives);
                SingletonUserChatGroups.Instance.ActiveUsers.AddRange(offerMade);
                SingletonUserChatGroups.Instance.ActiveUsers.AddRange(interviewDate);
                SingletonUserChatGroups.Instance.ActiveUsers.AddRange(applicant);
                SingletonUserChatGroups.Instance.ActiveUsers.AddRange(referralApplicant);

                foreach (var item in SingletonUserChatGroups.Instance.ActiveUsers)
                {
                    if (SingletonGlobal.Instance.ConnectedUsers.Where(x => x == item.UserId).Any())
                    {
                        SingletonUserChatGroups.Instance.ActiveUsers.Where(x => x.UserId == item.UserId).First().Status = (int)ChatUserStatus.Active;
                        SingletonUserChatGroups.Instance.ActiveUsers.Where(x => x.UserId == item.UserId).First().LastActivityAt = DateTime.UtcNow;
                    }
                }
            }
            else
            {
                SingletonUserChatGroups.Instance.ActiveUsers = new List<ActiveUser>();
            }
            var groupMembers = userchatgroupid.HasValue && userchatgroupid.Value > 0 ? ChatBLL.Instance.GetChatGroupMembers(0, userchatgroupid.Value) : null;
            if (groupMembers != null)
            {
                groupMembers = groupMembers.Where(m => m.UserId != JGSession.UserId).ToList();
            }
            string receiverIds = userid.HasValue && userid.Value > 0 ? userid.ToString() : string.Join(",", groupMembers.Select(x => x.UserId)).ToString();
            string webGroupName = userid.HasValue && userid.Value > 0 ? userid.ToString() : userchatgroupid.Value.ToString();


            if (IsGroupCall)
                webGroupName = "Group" + userchatgroupid.Value;
            else
                webGroupName = "Single" + userid.Value;

            // Check if it's one to one call and user is offline
            if (userid.HasValue && userid.Value > 0)
            {
                ActiveUser offlineUser = SingletonUserChatGroups.Instance.ActiveUsers
                                                                .Where(m => m.UserId == userid.Value && m.Status != (int)ChatUserStatus.Active)
                                                                .FirstOrDefault();

                if (offlineUser != null)
                {
                    DataRow callee = InstallUserBLL.Instance.getuserdetails(userid.Value).Tables[0].Rows[0];
                    // Return to caller and ask to record audio/video message and send to callee.
                    return new JavaScriptSerializer().Serialize(new ActionOutput<WebToWebCallUser>
                    {
                        Object = new WebToWebCallUser
                        {
                            UserId = Convert.ToInt32(callee["Id"]),
                            FirstName = callee["FristName"].ToString(),
                            LastName = callee["Lastname"].ToString(),
                            UserInstallId = callee["UserInstallID"].ToString(),
                            ProfilePic = callee["Picture"].ToString()
                        },
                        Results = null,
                        Status = ActionStatus.Successfull
                    });
                }
            }
            CallUserOrGroup(IsGroupCall, webGroupName, receiverIds, userchatgroupid, userid);

            return new JavaScriptSerializer().Serialize(new ActionOutput<ActiveUser>
            {
                Object = null,
                Results = SingletonUserChatGroups.Instance.ActiveUsers/*.OrderByDescending(m => m.LastMessageAt)*/.ToList(),
                Status = ActionStatus.Successfull
            });
        }

        [WebMethod(EnableSession = true)]
        public string GetWebCallingUsers()
        {
            var onlineChats = ChatBLL.Instance.GetOnlineUsers(JGSession.UserId, "active", "", 1,
                                                    20, null, "chats", false, null);
            SingletonUserChatGroups.Instance.ActiveUsers = onlineChats.Results;
            if (SingletonUserChatGroups.Instance.ActiveUsers != null)
            {
                SingletonUserChatGroups.Instance.ActiveUsers = SingletonUserChatGroups.Instance.ActiveUsers
                                                                            // .Where(m => m.Status == (int)ChatUserStatus.Active)
                                                                            //.OrderBy(m=>m.InstallUserStatusId.Value)
                                                                            //.ThenBy(m => m.Status)
                                                                            .ToList();
                var actives = SingletonUserChatGroups.Instance.ActiveUsers.Where(x => x.InstallUserStatusId == (int)InstallUserStatus.Active)
                                                     .OrderBy(x => x.Status).ToList();
                var offerMade = SingletonUserChatGroups.Instance.ActiveUsers.Where(x => x.InstallUserStatusId == (int)InstallUserStatus.OfferMade)
                                                     .OrderBy(x => x.Status).ToList();
                var interviewDate = SingletonUserChatGroups.Instance.ActiveUsers.Where(x => x.InstallUserStatusId == (int)InstallUserStatus.InterviewDate)
                                                     .OrderBy(x => x.Status).ToList();
                var applicant = SingletonUserChatGroups.Instance.ActiveUsers.Where(x => x.InstallUserStatusId == (int)InstallUserStatus.Applicant)
                                                     .OrderBy(x => x.Status).ToList();
                var referralApplicant = SingletonUserChatGroups.Instance.ActiveUsers.Where(x => x.InstallUserStatusId == (int)InstallUserStatus.ReferralApplicant)
                                                     .OrderBy(x => x.Status).ToList();

                SingletonUserChatGroups.Instance.ActiveUsers = new List<ActiveUser>();
                SingletonUserChatGroups.Instance.ActiveUsers.AddRange(actives);
                SingletonUserChatGroups.Instance.ActiveUsers.AddRange(offerMade);
                SingletonUserChatGroups.Instance.ActiveUsers.AddRange(interviewDate);
                SingletonUserChatGroups.Instance.ActiveUsers.AddRange(applicant);
                SingletonUserChatGroups.Instance.ActiveUsers.AddRange(referralApplicant);
            }
            else
            {
                SingletonUserChatGroups.Instance.ActiveUsers = new List<ActiveUser>();
            }
            return new JavaScriptSerializer().Serialize(new ActionOutput<ActiveUser>
            {
                Results = SingletonUserChatGroups.Instance.ActiveUsers/*.OrderByDescending(m => m.LastMessageAt)*/.ToList(),
                Status = ActionStatus.Successfull
            });
        }

        public void CallUserOrGroup(bool IsGroupCall, string webGroupName, string ReceiverIds, int? userchatgroupid, int? userid)
        {
            var httpContext = GlobalHost.ConnectionManager.GetHubContext<ChatHub>();

            List<int> userIds = ReceiverIds.Split(new string[] { "," }, StringSplitOptions.RemoveEmptyEntries).Select(x => Convert.ToInt32(x)).ToList();
            var chatUsers = ChatBLL.Instance.GetChatUsers(userIds).Results;
            // Adding each connection into SignalR Group, so that we can send messages to all connected users.
            foreach (var item in chatUsers)
            {
                foreach (string connectionId in item.ConnectionIds)
                {
                    httpContext.Groups.Add(connectionId, webGroupName);
                }
            }
            DataRow caller = InstallUserBLL.Instance.getuserdetails(JGSession.UserId).Tables[0].Rows[0];

            httpContext.Clients.Group(webGroupName).ringClient(new ActionOutput<WebToWebCall>
            {
                Status = ActionStatus.Successfull,
                Object = new WebToWebCall
                {
                    GroupNameID = webGroupName,
                    UserIds = userIds,
                    CallerUserId = JGSession.UserId,
                    CallerUsername = caller["FristName"].ToString() + " " + caller["Lastname"].ToString(),
                    CallerProfilePic = caller["Picture"].ToString(),
                    CallerUserInstallId = caller["UserInstallID"].ToString(),
                    CallGroupURL = CommonFunction.JGPA.Trim(new char[] { '/' }) + "/" + webGroupName,
                    UserChatGroupId = userchatgroupid,
                    UserId = userid,
                    IsGroupCall = IsGroupCall
                }
            });
        }

        [WebMethod(EnableSession = true)]
        public string RejectAndNotify(string GroupNameID, int CallerUserId, bool IsGroupCall)
        {
            var httpContext = GlobalHost.ConnectionManager.GetHubContext<ChatHub>();
            if (IsGroupCall)
            {
                // Group Call
                httpContext.Clients.Group(GroupNameID).rejectGroupCall(new ActionOutput
                {
                    Status = ActionStatus.Successfull
                });
            }
            else
            {
                // One to One Call

                var chatUsers = ChatBLL.Instance.GetChatUsers(new List<int>() { CallerUserId }).Results;
                //string randomString = Guid.NewGuid().ToString();
                // Adding each connection into SignalR Group, so that we can send messages to all connected users.
                foreach (var item in chatUsers)
                {
                    httpContext.Clients.Clients(item.ConnectionIds).rejectOneToOneCall(new ActionOutput
                    {
                        Status = ActionStatus.Successfull
                    });
                }
            }
            return new JavaScriptSerializer().Serialize(new ActionOutput<ActiveUser>
            {
                Results = SingletonUserChatGroups.Instance.ActiveUsers/*.OrderByDescending(m => m.LastMessageAt)*/.ToList(),
                Status = ActionStatus.Successfull
            });
        }

        [WebMethod(EnableSession = true)]
        public void SendMissedCallAlert(int CalleeUserId)
        {
            DataRow caller = InstallUserBLL.Instance.getuserdetails(JGSession.UserId).Tables[0].Rows[0];
            DataRow callee = InstallUserBLL.Instance.getuserdetails(CalleeUserId).Tables[0].Rows[0];

            ChatParameter chatParam = InstallUserBLL.Instance.GetChatParametersByUser(CalleeUserId, JGSession.UserId);
            // Add Auto Entry into HR Groupchat
            string log = "Missed call from " + caller["FristName"] + " " + caller["LastName"] +
                            "-<a href=\"\">" + caller["UserInstallId"] + "</a> at " +
                            string.Format("{0:MMM d, yyyy, h:mm tt}", DateTime.Now.ToEST()) + "(EST)";
            log = "<span class='auto-entry-missed-call'>" + log + "</span>";

            long EmailStatusId = SendMissedCallAlertEmail(JGSession.UserId, CalleeUserId, caller["UserInstallId"].ToString(),
                                                                chatParam.ChatGroupId, chatParam.UserChatGroupId);
            if (callee["Status"] != null && Convert.ToInt32(callee["Status"]) != (int)InstallUserStatus.Active)
            {
                // Send notification in HR Group Chat
                ChatBLL.Instance.AddHRChatMessage(CalleeUserId, log, EmailStatusId);
            }
            else
            {
                // Send Notification in Personal Chat
                string pic = string.IsNullOrEmpty(caller["Picture"].ToString()) ? "default.jpg"
                                    : caller["Picture"].ToString().Replace("~/UploadeProfile/", "");
                pic = /*baseUrl +*/ "Employee/ProfilePictures/" + pic;

                string chatGroupId = string.Empty;
                List<ChatMessage> messages = ChatBLL.Instance.GetChatMessagesByUsers(JGSession.UserId, CalleeUserId, (int)ChatSource.WebToWebCall, 1, 1).Results;
                if (messages != null && messages.Count() > 0)
                {
                    chatGroupId = messages.First().ChatGroupId;
                }
                else
                {
                    chatGroupId = Guid.NewGuid().ToString();
                }
                ChatBLL.Instance.SaveChatMessage(new ChatMessage
                {
                    UserChatGroupId = 0,
                    TaskId = null,
                    TaskMultilevelListId = null,
                    Message = log,
                    FileId = null,
                    ChatSourceId = (int)ChatSource.WebToWebCall,
                    UserId = JGSession.UserId,
                    UserProfilePic = pic,
                    UserFullname = caller["FristName"].ToString() + " " + caller["Lastname"].ToString(),
                    UserInstallId = caller["UserInstallID"].ToString(),
                    MessageAt = DateTime.UtcNow.ToEST(),
                    MessageAtFormatted = DateTime.UtcNow.ToEST().ToString(),
                    ChatGroupId = chatGroupId
                }, chatGroupId, CalleeUserId.ToString(), JGSession.UserId);
            }
        }

        private long SendMissedCallAlertEmail(int LoginUserID, int UserID, string LoginUserInstallID,
                                                    string chatGroupId, int userChatGroupId, string AudioVideoFile = null, string contentType = "video/webm")
        {
            // Get Html Template
            string messageUrl = string.Empty, toEmail = string.Empty, body = string.Empty;
            string baseurl = HttpContext.Current.Request.Url.Scheme + "://" +
                                        HttpContext.Current.Request.Url.Authority +
                                        HttpContext.Current.Request.ApplicationPath.TrimEnd('/') + "/";

            DesignationHTMLTemplate html = string.IsNullOrEmpty(AudioVideoFile) ? HTMLTemplateBLL.Instance.GetDesignationHTMLTemplate(HTMLTemplates.Missed_Call_Alert_Email, "") :
                                                    HTMLTemplateBLL.Instance.GetDesignationHTMLTemplate(HTMLTemplates.Missed_Call_Alert_Email_With_Attachment, "");
            // sender details
            var sender = InstallUserBLL.Instance.getuserdetails(LoginUserID).Tables[0].Rows[0];
            string pic = string.IsNullOrEmpty(sender["Picture"].ToString()) ? "default.jpg"
                                : sender["Picture"].ToString().Replace("~/UploadeProfile/", "");
            pic = baseurl + "Employee/ProfilePictures/" + pic;
            html.Body = html.Body.Replace("{ImageUrl}", pic);
            html.Body = html.Body.Replace("{SenderName}", sender["FristName"].ToString() + " " + sender["LastName"].ToString());
            html.Body = html.Body.Replace("{SenderDesignation}", sender["Designation"].ToString());
            html.Body = html.Body.Replace("{SenderUserInstallID}", sender["UserInstallID"].ToString());
            html.Body = html.Body.Replace("{ProfileUrl}", baseurl + "Sr_App/ViewSalesUser.aspx?id=" + sender["Id"].ToString());
            html.Body = html.Body.Replace("{MissedCallTime}", string.Format("{0:MMM d, yyyy, h:mm tt}", DateTime.Now.ToEST()) + "(EST)");
            html.Body = html.Body.Replace("{AudioVideoUrl}", baseurl + "Chat/Attachments/" + AudioVideoFile);

            // Generate auto login code
            string loginCode = InstallUserDAL.Instance.GenerateLoginCode(UserID).Object;
            var receiver = InstallUserBLL.Instance.getuserdetails(UserID).Tables[0].Rows[0];
            toEmail = receiver["Email"].ToString();
            messageUrl = baseurl + "Sr_App/TouchPointLog.aspx?TUID=" + UserID + "&CGID=" + chatGroupId +
                                    "&auth=" + loginCode + "&RcvrID=" + LoginUserID + "&Src=" + (int)ChatSource.WebToWebCall +
                                    "&ugid=" + userChatGroupId;

            body = (html.Header + html.Body + html.Footer).Replace("{MessageUrl}", messageUrl);
            return EmailManager.SendEmail(JGConstant.EmailTypes.MissedCallAlert.ToString(), "New Message", toEmail, html.Subject, body, null);
        }

        [WebMethod(EnableSession = true)]
        public void AddUserIntoCall(string GroupName, int UserId)
        {
            var httpContext = GlobalHost.ConnectionManager.GetHubContext<ChatHub>();
            var chatUsers = ChatBLL.Instance.GetChatUsers(new List<int> { UserId }).Results;
            // Adding each connection into SignalR Group, so that we can send messages to all connected users.
            foreach (var item in chatUsers)
            {
                foreach (string connectionId in item.ConnectionIds)
                {
                    httpContext.Groups.Add(connectionId, GroupName);
                }
            }
            DataRow caller = InstallUserBLL.Instance.getuserdetails(JGSession.UserId).Tables[0].Rows[0];

            httpContext.Clients.Group(GroupName).ringClient(new ActionOutput<WebToWebCall>
            {
                Status = ActionStatus.Successfull,
                Object = new WebToWebCall
                {
                    GroupNameID = GroupName,
                    //UserIds = userIds,
                    CallerUserId = JGSession.UserId,
                    CallerUsername = caller["FristName"].ToString() + " " + caller["Lastname"].ToString(),
                    CallerProfilePic = caller["Picture"].ToString(),
                    CallerUserInstallId = caller["UserInstallID"].ToString(),
                    CallGroupURL = CommonFunction.JGPA.Trim(new char[] { '/' }) + "/" + GroupName,
                    //UserChatGroupId = userchatgroupid,
                    UserId = UserId,
                    IsGroupCall = true
                }
            });
        }

        [WebMethod(EnableSession = true)]
        //public void SendRecordedNote(int CalleeUserId, string originalName, int fileId, string contentType, bool normalVoice)
        public void SendRecordedNote(string ReceiverIds, int? UserChatGroupId, string ChatGroupId, int? TaskId, int? TaskMultilevelListId,
                                        string originalName, int fileId, string contentType, bool normalVoice)
        {
            List<int> userIds = ReceiverIds.Split(new char[] { ',' }, StringSplitOptions.RemoveEmptyEntries).Select(x => Convert.ToInt32(x)).Distinct().ToList();
            DataRow caller = InstallUserBLL.Instance.getuserdetails(JGSession.UserId).Tables[0].Rows[0];
            //DataRow callee = userIds.Count() == 1 ? InstallUserBLL.Instance.getuserdetails(userIds[0]).Tables[0].Rows[0] : null;
            //ChatParameter chatParam = InstallUserBLL.Instance.GetChatParametersByUser(CalleeUserId, JGSession.UserId);
            // Add Auto Entry into HR Groupchat
            string log = "Missed call from " + caller["FristName"] + " " + caller["LastName"] +
                            "-<a href=\"\">" + caller["UserInstallId"] + "</a> at " +
                            string.Format("{0:MMM d, yyyy, h:mm tt}", DateTime.Now.ToEST()) + "(EST)";
            if (normalVoice)
            {
                log = "Voice message from " + caller["FristName"] + " " + caller["LastName"] +
                            "-<a href=\"\">" + caller["UserInstallId"] + "</a> at " +
                            string.Format("{0:MMM d, yyyy, h:mm tt}", DateTime.Now.ToEST()) + "(EST)";
            }
            if (contentType == "video/webm")
            {
                log = "<span class='auto-entry-missed-call'>" + log + "</span><span class=\"audio-video\"><video controls=\"\"><source src=\"/chat/attachments/" + originalName + "\" type=\"video/webm; codecs=\"vp8, vorbis\"></video></span>";
            }
            else if (contentType == "audio/webm")
            {
                log = "<span class='auto-entry-missed-call'>" + log + "</span><span class=\"audio-video\"><audio controls=\"\"><source src=\"/chat/attachments/" + originalName + "\" type=\"audio/webm; codecs=\"vp8, vorbis\"></audio></span>";
            }
            long EmailStatusId = 0;
            DataRow callee = null;
            foreach (int userid in userIds)
            {
                callee = InstallUserBLL.Instance.getuserdetails(userid).Tables[0].Rows[0];
                EmailStatusId = SendMissedCallAlertEmail(JGSession.UserId, userid, caller["UserInstallId"].ToString(),
                                                                ChatGroupId, UserChatGroupId ?? 0, originalName, contentType);
            }
            callee = userIds.Count() == 1 ? InstallUserBLL.Instance.getuserdetails(userIds[0]).Tables[0].Rows[0] : null;
            if (callee != null && callee["Status"] != null && Convert.ToInt32(callee["Status"]) != (int)InstallUserStatus.Active)
            {
                // Send notification in HR Group Chat
                ChatBLL.Instance.AddHRChatMessage(userIds[0], log, EmailStatusId);
            }
            else
            {
                // Send Notification in Personal Chat
                string pic = string.IsNullOrEmpty(caller["Picture"].ToString()) ? "default.jpg"
                                    : caller["Picture"].ToString().Replace("~/UploadeProfile/", "");
                pic = /*baseUrl +*/ "Employee/ProfilePictures/" + pic;

                //string chatGroupId = string.Empty;
                //List<ChatMessage> messages = ChatBLL.Instance.GetChatMessagesByUsers(JGSession.UserId, CalleeUserId, (int)ChatSource.WebToWebCall, 1, 1).Results;
                //if (messages != null && messages.Count() > 0)
                //{
                //    chatGroupId = messages.First().ChatGroupId;
                //}
                //else
                //{
                //    chatGroupId = Guid.NewGuid().ToString();
                //}

                if (string.IsNullOrEmpty(ChatGroupId))
                {
                    ChatGroupId = Guid.NewGuid().ToString();
                }

                ChatBLL.Instance.SaveChatMessage(new ChatMessage
                {
                    UserChatGroupId = UserChatGroupId,
                    TaskId = TaskId,
                    TaskMultilevelListId = TaskMultilevelListId,
                    Message = log,
                    FileId = null,
                    ChatSourceId = (int)ChatSource.WebToWebCall,
                    UserId = JGSession.UserId,
                    UserProfilePic = pic,
                    UserFullname = caller["FristName"].ToString() + " " + caller["Lastname"].ToString(),
                    UserInstallId = caller["UserInstallID"].ToString(),
                    MessageAt = DateTime.UtcNow.ToEST(),
                    MessageAtFormatted = DateTime.UtcNow.ToEST().ToString(),
                    ChatGroupId = ChatGroupId,
                    EmailStatusId = userIds.Count() > 1 ? 0 : EmailStatusId
                }, ChatGroupId, ReceiverIds, JGSession.UserId);
            }
        }
        #endregion
    }
}
