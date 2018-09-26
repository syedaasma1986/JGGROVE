using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

using JG_Prospect.DAL;
using JG_Prospect.Common;
using JG_Prospect.Common.modal;
using System.Data;
using Microsoft.Practices.EnterpriseLibrary.Data.Sql;
using System.Data.Common;
using JG_Prospect.DAL.Database;

namespace JG_Prospect.BLL
{
    public class TaskGeneratorBLL
    {
        private static TaskGeneratorBLL m_TaskGeneratorBLL = new TaskGeneratorBLL();

        private TaskGeneratorBLL()
        {

        }

        public static TaskGeneratorBLL Instance
        {
            get { return m_TaskGeneratorBLL; }
            set {; }
        }

        #region "-- Task Sequences --"

        public DataSet GetAllTasksforSubSequencing(Int32 DesignationId, String DesiSeqCode, bool IsTechTask, Int64 TaskId)
        {
            return TaskGeneratorDAL.Instance.GetAllTasksforSubSequencing(DesignationId, DesiSeqCode, IsTechTask, TaskId);

        }

        public DataSet GetLatestTaskSequence(Int32 DesignationId, bool IsTechTask)
        {
            return TaskGeneratorDAL.Instance.GetLatestTaskSequence(DesignationId, IsTechTask);
        }

        public DataSet GetAllTaskWithSequence(Int32 page, Int32 pageSize, String DesignationIds, bool IsTechTask, Int64 HighlightedTaskID)
        {
            return TaskGeneratorDAL.Instance.GetAllTaskWithSequence(page, pageSize, DesignationIds, IsTechTask, HighlightedTaskID);
        }

        public DataSet GetAllInProAssReqTaskWithSequence(Int32 page, Int32 pageSize, String DesignationIds, string TaskUserStatus, string UserIds, string StartDate, string EndDate, bool ForInProgress)
        {
            return TaskGeneratorDAL.Instance.GetAllInProAssReqTaskWithSequence(page, pageSize, DesignationIds, TaskUserStatus, UserIds, StartDate, EndDate, ForInProgress);
        }

        public DataSet GetAllPartialFrozenTaskWithSequence(Int32 page, Int32 pageSize, String DesignationIds, bool IsTechTask)
        {
            return TaskGeneratorDAL.Instance.GetAllPartialFrozenTaskWithSequence(page, pageSize, DesignationIds, IsTechTask);
        }

        public DataSet GetFrozenNonFrozenTaskCount()
        {
            return TaskGeneratorDAL.Instance.GetFrozenNonFrozenTaskCount();
        }


        public DataSet GetAllNonFrozenTaskWithSequence(Int32 page, Int32 pageSize, String DesignationIds, bool IsTechTask)
        {
            return TaskGeneratorDAL.Instance.GetAllNonFrozenTaskWithSequence(page, pageSize, DesignationIds, IsTechTask);
        }

        public DataSet GetAllNonFrozenUserTaskWithSequence(Int32 page, Int32 pageSize, bool IsTechTask, string UserId)
        {
            return TaskGeneratorDAL.Instance.GetAllNonFrozenUserTaskWithSequence(page, pageSize, IsTechTask, UserId);
        }

        public DataSet GetAllInProAssReqUserTaskWithSequence(Int32 page, Int32 pageSize, bool IsTechTask, string UserId, bool ForDashboard, string StartDate, string EndDate, bool ForInProgress)
        {
            return TaskGeneratorDAL.Instance.GetAllInProAssReqUserTaskWithSequence(page, pageSize, IsTechTask, UserId, ForDashboard, StartDate, EndDate, ForInProgress);
        }

        public DataSet GetAllPartialFrozenUserTaskWithSequence(Int32 page, Int32 pageSize, bool IsTechTask, string UserId)
        {
            return TaskGeneratorDAL.Instance.GetAllPartialFrozenUserTaskWithSequence(page, pageSize, IsTechTask, UserId);
        }

        public int UpdateTaskSequence(Int64 Sequence, Int64 TaskID, Int32 DesignationID, bool IsTechTask)
        {
            return TaskGeneratorDAL.Instance.UpdateTaskSequence(Sequence, TaskID, DesignationID, IsTechTask);

        }

        public DataSet GetInterviewDateSequences(Int32 DesignationId, Int32 UserCount)
        {
            return TaskGeneratorDAL.Instance.GetInterviewDateSequences(DesignationId, UserCount);

        }

        public bool UpdateTaskSubSequence(Int64 TaskID, Int64 TaskIdSeq, Int64 SubSeqTaskId, Int64 DesignationId)
        {
            return TaskGeneratorDAL.Instance.UpdateTaskSubSequence(TaskID, TaskIdSeq, SubSeqTaskId, DesignationId);

        }

        #endregion
        public bool DeleteSubTaskChild(int Id)
        {
            return TaskGeneratorDAL.Instance.DeleteSubTaskChild(Id);
        }

        public Int64 SaveOrDeleteTask(Task objTask, int TaskLevel, int maintaskid)
        {
            return TaskGeneratorDAL.Instance.SaveOrDeleteTask(objTask, TaskLevel, maintaskid);
        }

        public DataSet GetTaskByMaxId(string parentTaskid, short taskLVL)
        {
            return TaskGeneratorDAL.Instance.GetTaskByMaxId(parentTaskid, taskLVL);
        }

        public DataSet GetMultilevelChildren(string ParentTaskId)
        {
            return TaskGeneratorDAL.Instance.GetMultilevelChildren(ParentTaskId);
        }

        public DataSet GetTaskMultilevelListItem(int taskMultilevelListId, int? loggedInUserId=null)
        {
            return TaskGeneratorDAL.Instance.GetTaskMultilevelListItem(taskMultilevelListId, loggedInUserId);
        }

        public DataSet GetRootTasks(int ExcludedTaskId)
        {
            return TaskGeneratorDAL.Instance.GetRootTasks(ExcludedTaskId);
        }

        public DataSet GetChildTasks(int ParentTaskId)
        {
            return TaskGeneratorDAL.Instance.GetChildTasks(ParentTaskId);
        }

        //GetMultilevelChildren

        public bool SaveTaskDesignations(UInt64 TaskId, String strDesignations, String TaskIDCode)
        {
            return TaskGeneratorDAL.Instance.SaveTaskDesignations(TaskId, strDesignations, TaskIDCode);
        }
        public bool SaveTaskAssignedUsers(UInt64 TaskId, String UserIds)
        {
            return TaskGeneratorDAL.Instance.SaveTaskAssignedUsers(TaskId, UserIds);
        }

        public bool SaveTaskAssignedUsersRoman(UInt64 TaskId, String UserIds)
        {
            return TaskGeneratorDAL.Instance.SaveTaskAssignedUsersRoman(TaskId, UserIds);
        }

        public bool SaveTaskQuery(int TaskId, string QueryDesc, int QueryTypeId, int QueryStatusId, int CreatedById)
        {
            return TaskGeneratorDAL.Instance.SaveTaskQuery(TaskId, QueryDesc, QueryTypeId, QueryStatusId, CreatedById);
        }

        public bool SetTaskStatus(int TaskId, string TaskStatus)
        {
            return TaskGeneratorDAL.Instance.SetTaskStatus(TaskId, TaskStatus);
        }

        public bool SetRomanTaskStatus(int TaskId, int TaskStatus)
        {
            return TaskGeneratorDAL.Instance.SetRomanTaskStatus(TaskId, TaskStatus);
        }

        public bool SaveTaskMultiLevelChild(int ParentTaskId, string InstallId, string Title, string Description, int IndentLevel, string Class, int UserId)
        {
            return TaskGeneratorDAL.Instance.SaveTaskMultiLevelChild(ParentTaskId, InstallId, Title, Description, IndentLevel, Class, UserId);
        }

        public bool SaveTaskAssignedToMultipleUsers(UInt64 TaskId, String UserId)
        {
            return TaskGeneratorDAL.Instance.SaveTaskAssignedToMultipleUsers(TaskId, UserId);
        }
        public bool SaveTaskAssignmentRequests(UInt64 TaskId, String UserIds)
        {
            return TaskGeneratorDAL.Instance.SaveTaskAssignmentRequests(TaskId, UserIds);
        }
        public bool AcceptTaskAssignmentRequests(UInt64 TaskId, String UserIds)
        {
            return TaskGeneratorDAL.Instance.AcceptTaskAssignmentRequests(TaskId, UserIds);
        }

        public DataSet GetTasksInformation(Int32 TaskId)
        {
            return TaskGeneratorDAL.Instance.GetTasksInformation(TaskId);
        }

        public bool UpdateTaskAcceptance(ref TaskUser objTaskUser)
        {
            return TaskGeneratorDAL.Instance.UpdateTaskUserAcceptance(ref objTaskUser);
        }

        public bool TaskSwapSequence(Int64 FirstSequenceId, Int64 SecondSequenceId, Int64 FirstTaskId, Int64 SecondTaskId)
        {
            return TaskGeneratorDAL.Instance.TaskSwapSequence(FirstSequenceId, SecondSequenceId, FirstTaskId, SecondTaskId);
        }

        public bool TaskSwapSubSequence(Int64 FirstSequenceId, Int64 SecondSequenceId, Int64 FirstTaskId, Int64 SecondTaskId)
        {
            return TaskGeneratorDAL.Instance.TaskSwapSubSequence(FirstSequenceId, SecondSequenceId, FirstTaskId, SecondTaskId);
        }

        public bool TaskSwapRoman(Int64 FirstRomanId, Int64 SecondRomanId)
        {
            return TaskGeneratorDAL.Instance.TaskSwapRoman(FirstRomanId, SecondRomanId);
        }
        public bool DeleteTaskSequence(Int64 TaskId)
        {
            return TaskGeneratorDAL.Instance.DeleteTaskSequence(TaskId);
        }

        public bool MoveTask(int TaskId, int FromTaskId, int ToTaskId)
        {
            return TaskGeneratorDAL.Instance.MoveTask(TaskId, FromTaskId, ToTaskId);
        }

        public bool DeleteTaskSubSequence(Int64 TaskId)
        {
            return TaskGeneratorDAL.Instance.DeleteTaskSubSequence(TaskId);
        }
        public bool SaveOrDeleteTaskUserFiles(TaskUser objTaskUser)
        {
            return TaskGeneratorDAL.Instance.SaveOrDeleteTaskUserFiles(objTaskUser);
        }

        public bool DeleteTaskUserFile(Int64 Id)
        {
            return TaskGeneratorDAL.Instance.DeleteTaskUserFile(Id);
        }

        public DataSet GetTaskDetails(Int32 TaskId, int? loggedInUserId = null)
        {
            return TaskGeneratorDAL.Instance.GetTaskDetails(TaskId, loggedInUserId);
        }

        public DataSet GetSubTasks(Int32 TaskId, bool blIsAdmin, string strSortExpression, string vsearch = "", Int32? intPageIndex = 0, Int32? intPageSize = 0, int intHighlightTaskId = 0)
        {
            return TaskGeneratorDAL.Instance.GetSubTasks(TaskId, blIsAdmin, strSortExpression, vsearch, intPageIndex, intPageSize, intHighlightTaskId);
        }

        public DataSet GetTaskUserFileByFileName(string FileName)
        {
            return TaskGeneratorDAL.Instance.GetTaskUserFileByFileName(FileName);
        }

        public DataSet GetTaskMultilevelChildInfo(int TaskId)
        {
            return TaskGeneratorDAL.Instance.GetTaskMultilevelChildInfo(TaskId);
        }

        public DataSet GetCalendarTasksByDate(string StartDate, string EndDate, string userid, String DesignationIDs, string TaskUserStatus)
        {
            return TaskGeneratorDAL.Instance.GetCalendarTasksByDate(StartDate, EndDate, userid, DesignationIDs, TaskUserStatus);
        }

        public DataSet GetCalendarUsersByDate(string Date, string TaskUserStatus, string UserId)
        {
            return TaskGeneratorDAL.Instance.GetCalendarUsersByDate(Date, TaskUserStatus, UserId);
        }

        public DataSet GetFreezedRomanData(long RomanId)
        {
            return TaskGeneratorDAL.Instance.GetFreezedRomanData(RomanId);
        }

        public DataSet GetTaskUserFiles(Int32 TaskId, JGConstant.TaskFileDestination? objTaskFileDestination, Int32? intPageIndex, Int32? intPageSize)
        {
            return TaskGeneratorDAL.Instance.GetTaskUserFiles(TaskId, objTaskFileDestination, intPageIndex, intPageSize);
        }

        public DataSet GetTaskUserDetails(Int16 Mode)
        {
            return TaskGeneratorDAL.Instance.GetTaskUserDetails(Mode);
        }

        public DataSet GetInstallUsers(int key, string Designation)
        {
            return TaskGeneratorDAL.Instance.GetInstallUsers(key, Designation);
        }

        public List<Designation> GetAllActiveDesignation()
        {
            return TaskGeneratorDAL.Instance.GetAllActiveDesignation();
        }

        public DataSet GetInstallUsers(int key, string Designation, string userstatus)
        {
            return TaskGeneratorDAL.Instance.GetInstallUsers(key, Designation, userstatus);
        }

        public DataSet GetInstallUserswithIds(int key, string Designation, string TaskId)
        {
            return TaskGeneratorDAL.Instance.GetInstallUserswithIds(key, Designation, TaskId);
        }

        public DataSet GetAllActiveTechTask()
        {
            return TaskGeneratorDAL.Instance.GetAllActiveTechTask();
        }

        public DataSet GetUserDetails(Int32 Id)
        {
            return TaskGeneratorDAL.Instance.GetUserDetails(Id);
        }

        public DataSet GetInstallUserDetails(Int32 Id)
        {
            return TaskGeneratorDAL.Instance.GetInstallUserDetails(Id);
        }

        public DataTable GetTaskDetailsForMail(Int32 Id)
        {
            return TaskGeneratorDAL.Instance.GetTaskDetailsForMail(Id);
        }

        public DataSet GetTaskSearchAutoSuggestion(String searchTerm)
        {
            return TaskGeneratorDAL.Instance.GetTaskSearchAutoSuggestion(searchTerm);
        }

        public DataSet GetTasksList(int? UserID, string Title, string Designation, Int16? Status, DateTime? CreatedFrom, DateTime? CreatedTo, string Statuses, string Designations, bool isAdmin, int Start, int PageLimit, string strSortExpression)
        {
            return TaskGeneratorDAL.Instance.GetTasksList(UserID, Title, Designation, Status, CreatedFrom, CreatedTo, Statuses, Designations, isAdmin, Start, PageLimit, strSortExpression);
        }

        public ActionOutput<LoginUser> GetInstallUsersByPrefix(string Prefix)
        {
            return TaskGeneratorDAL.Instance.GetInstallUsersByPrefix(Prefix);
        }

        public DataSet GetAllUsersNDesignationsForFilter()
        {
            return TaskGeneratorDAL.Instance.GetAllUsersNDesignationsForFilter();
        }

        public int UpdateTaskStatus(Task objTask)
        {
            return TaskGeneratorDAL.Instance.UpdateTaskStatus(objTask);
        }

        public DataSet GetAllActiveTechTaskForDesignationID(int iDesignationID)
        {
            return TaskGeneratorDAL.Instance.GetAllActiveTechTaskForDesignationID(iDesignationID);
        }

        public int UpdateTaskPriority(Task objTask)
        {
            return TaskGeneratorDAL.Instance.UpdateTaskPriority(objTask);
        }

        public bool DeleteTask(UInt64 TaskId)
        {
            return TaskGeneratorDAL.Instance.DeleteTask(TaskId);
        }

        public bool SaveOrDeleteTaskNotes(ref TaskUser objTaskUser)
        {
            return TaskGeneratorDAL.Instance.SaveOrDeleteTaskNotes(ref objTaskUser);
        }

        public bool SaveTaskDescription(Int64 TaskId, String TaskDescription)
        {
            return TaskGeneratorDAL.Instance.SaveTaskDescription(TaskId, TaskDescription);
        }

        public bool UpadateTaskNotes(ref TaskUser objTaskUser)
        {
            return TaskGeneratorDAL.Instance.UpadateTaskNotes(ref objTaskUser);
        }

        public bool UpdateTaskUiRequested(Int64 intTaskId, bool blUiRequesed)
        {
            return TaskGeneratorDAL.Instance.UpdateTaskUiRequested(intTaskId, blUiRequesed);
        }

        public bool UpdateTaskTechTask(Int64 intTaskId, bool blTechTask)
        {
            return TaskGeneratorDAL.Instance.UpdateTaskTechTask(intTaskId, blTechTask);
        }

        #region TaskWorkSpecification

        public int InsertTaskWorkSpecification(TaskWorkSpecification objTaskWorkSpecification)
        {
            return TaskGeneratorDAL.Instance.InsertTaskWorkSpecification(objTaskWorkSpecification);
        }

        public int UpdateTaskWorkSpecification(TaskWorkSpecification objTaskWorkSpecification)
        {
            return TaskGeneratorDAL.Instance.UpdateTaskWorkSpecification(objTaskWorkSpecification);
        }

        public int UpdateTaskTitleById(string tid, string title)
        {
            return TaskGeneratorDAL.Instance.UpdateTaskTitleById(tid, title);
        }

        public int UpdateTaskURLById(string tid, string URL)
        {
            return TaskGeneratorDAL.Instance.UpdateTaskURLById(tid, URL);
        }

        public int UpdateTaskDescriptionChildById(string tid, string Description)
        {
            return TaskGeneratorDAL.Instance.UpdateTaskDescriptionChildById(tid, Description);
        }

        public int UpdateRomanTitle(string RomanId, string Title)
        {
            return TaskGeneratorDAL.Instance.UpdateRomanTitle(RomanId, Title);
        }

        public int UpdateTaskDescriptionById(string tid, string Description)
        {
            return TaskGeneratorDAL.Instance.UpdateTaskDescriptionById(tid, Description);
        }

        public int DeleteTaskWorkSpecification(long intTaskWorkSpecification)
        {
            return TaskGeneratorDAL.Instance.DeleteTaskWorkSpecification(intTaskWorkSpecification);
        }

        public DataSet GetTaskWorkSpecifications(Int32 TaskId, bool blIsAdmin, Int64? intParentTaskWorkSpecificationId, Int32? intPageIndex, Int32? intPageSize)
        {
            return TaskGeneratorDAL.Instance.GetTaskWorkSpecifications(TaskId, blIsAdmin, intParentTaskWorkSpecificationId, intPageIndex, intPageSize);
        }

        public TaskWorkSpecification GetTaskWorkSpecificationById(Int64 Id)
        {
            return TaskGeneratorDAL.Instance.GetTaskWorkSpecificationById(Id);
        }

        public int UpdateTaskWorkSpecificationStatusByTaskId(TaskWorkSpecification objTaskWorkSpecification, bool blIsAdmin, bool blIsTechLead, bool blIsUser)
        {
            return TaskGeneratorDAL.Instance.UpdateTaskWorkSpecificationStatusByTaskId(objTaskWorkSpecification, blIsAdmin, blIsTechLead, blIsUser);
        }

        public int UpdateTaskWorkSpecificationStatusById(TaskWorkSpecification objTaskWorkSpecification, bool blIsAdmin, bool blIsTechLead, bool blIsUser)
        {
            return TaskGeneratorDAL.Instance.UpdateTaskWorkSpecificationStatusById(objTaskWorkSpecification, blIsAdmin, blIsTechLead, blIsUser);
        }

        public DataSet GetPendingTaskWorkSpecificationCount(Int32 TaskId)
        {
            return TaskGeneratorDAL.Instance.GetPendingTaskWorkSpecificationCount(TaskId);
        }

        public bool IsTaskWorkSpecificationApproved(Int32 TaskId)
        {
            int intPendingCount = 0;

            DataSet dsTaskSpecificationStatus = TaskGeneratorBLL.Instance.GetPendingTaskWorkSpecificationCount(TaskId);
            if (dsTaskSpecificationStatus.Tables.Count > 1 && dsTaskSpecificationStatus.Tables[1].Rows.Count > 0)
            {
                intPendingCount = Convert.ToInt32(dsTaskSpecificationStatus.Tables[1].Rows[0]["PendingRecordCount"]);
            }

            return (intPendingCount == 0);
        }

        #endregion

        public int UpdateSubTaskStatusById(Task objTask, bool blIsAdmin, bool blIsTechLead, bool blIsUser)
        {
            return TaskGeneratorDAL.Instance.UpdateSubTaskStatusById(objTask, blIsAdmin, blIsTechLead, blIsUser);
        }

        public DataSet GetPendingSubTaskCount(Int32 TaskId)
        {
            return TaskGeneratorDAL.Instance.GetPendingSubTaskCount(TaskId);
        }


        public DataSet GetTaskHierarchy(long? intTaskID, bool isAdmin)
        {
            return TaskGeneratorDAL.Instance.GetTaskHierarchy(intTaskID, isAdmin);
        }

        public bool AcceptUserAssignedWithSequence(Int64 SequenceId)
        {
            return TaskGeneratorDAL.Instance.AcceptUserAssignedWithSequence(SequenceId);
        }

        public Int32 GetTaskIdByTaskSequence(Int64 SequenceId)
        {
            return TaskGeneratorDAL.Instance.GetTaskIdByTaskSequence(SequenceId);
        }

        public DataSet GetDesignationTaskToAssignWithSequence(Int32 DesignationId, bool IsTechTask)
        {
            return TaskGeneratorDAL.Instance.GetDesignationTaskToAssignWithSequence(DesignationId, IsTechTask);
        }

        public DataSet GetUserAssignedWithSequence(Int32 DesignationId, bool IsTechTask, Int32 UserID)
        {
            return TaskGeneratorDAL.Instance.GetUserAssignedWithSequence(DesignationId, IsTechTask, UserID);
        }
        public DataSet GetUserAssignedTaskHistory(Int32 UserID)
        {
            return TaskGeneratorDAL.Instance.GetUserAssignedTaskHistory(UserID);
        }
        public DataSet RejectUserAssignedWithSequence(Int64 SequenceID, Int32 UserID, Int32 RejectedUserID)
        {
            return TaskGeneratorDAL.Instance.RejectUserAssignedWithSequence(SequenceID, UserID, RejectedUserID);
        }

        public Boolean InsertAssignedDesignationTaskWithSequence(Int32 DesignationId, bool IsTechTask, Int64 AssignedSequence, Int64 TaskId, Int32 UserId)
        {
            return TaskGeneratorDAL.Instance.InsertAssignedDesignationTaskWithSequence(DesignationId, IsTechTask, AssignedSequence, TaskId, UserId);

        }
        public String HardDeleteTask(Int64 maintaskid)
        {
            return TaskGeneratorDAL.Instance.HardDeleteTask(maintaskid);
        }

        public bool UpdateTaskReassignable(Int64 intTaskId, bool blIsReassignable)
        {
            return TaskGeneratorDAL.Instance.UpdateTaskReassignable(intTaskId, blIsReassignable);
        }


        #region TaskAcceptance

        public DataSet GetTaskAcceptances(Int64 TaskId)
        {
            return TaskGeneratorDAL.Instance.GetTaskAcceptances(TaskId);
        }

        public int InsertTaskAcceptance(TaskAcceptance objTaskAcceptance)
        {
            return TaskGeneratorDAL.Instance.InsertTaskAcceptance(objTaskAcceptance);
        }

        #endregion

        #region TaskApprovals

        public int InsertTaskApproval(TaskApproval objTaskApproval)
        {
            return TaskGeneratorDAL.Instance.InsertTaskApproval(objTaskApproval);
        }

        public int UpdateTaskApproval(TaskApproval objTaskApproval)
        {
            return TaskGeneratorDAL.Instance.UpdateTaskApproval(objTaskApproval);
        }

        public bool UpdateFeedbackTask(int EstimatedHours, string Password, string StartDate, string EndDate, int TaskId, bool IsITLead, int UserId)
        {
            return TaskGeneratorDAL.Instance.UpdateFeedbackTask(EstimatedHours, Password, StartDate, EndDate, TaskId, IsITLead, UserId);
        }

        //--------- Start DP -----------
        public DataSet GetInProgressTasks(string userid, string desigid, string vSearch, int pageindex, int pagesize)
        {
            return TaskGeneratorDAL.Instance.GetInProgressTasks(userid, desigid, vSearch, pageindex, pagesize);
        }

        public DataSet GetClosedTasks(string userid, string desigid, string TaskUserStatus, string vSearch, int pageindex, int pagesize)
        {
            return TaskGeneratorDAL.Instance.GetClosedTasks(userid, desigid, TaskUserStatus, vSearch, pageindex, pagesize);
        }
        //------- End DP ----------

        #endregion
    }
}
