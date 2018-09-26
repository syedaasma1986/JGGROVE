using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Data;
using System.Data.Common;
using Microsoft.Practices.EnterpriseLibrary.Data.Sql;

using JG_Prospect.DAL.Database;
using JG_Prospect.Common.modal;
using JG_Prospect.Common;


namespace JG_Prospect.DAL
{
    public class TaskGeneratorDAL
    {
        public static TaskGeneratorDAL m_TaskGeneratorDAL = new TaskGeneratorDAL();
        private TaskGeneratorDAL()
        {
        }
        public static TaskGeneratorDAL Instance
        {
            get { return m_TaskGeneratorDAL; }
            private set {; }
        }

        private DataSet returndata;

        #region "-- Sequence Related --"
        public DataSet GetAllTaskWithSequence(Int32 page, Int32 pageSize, String DesignationIds, bool IsTechTask, Int64 HighlightedTaskID)
        {
            try
            {
                SqlDatabase database = MSSQLDataBase.Instance.GetDefaultDatabase();
                {
                    DbCommand command = database.GetStoredProcCommand("usp_GetAllTaskWithSequence");

                    database.AddInParameter(command, "@PageIndex", SqlDbType.Int, page);
                    database.AddInParameter(command, "@PageSize", SqlDbType.Int, pageSize);
                    database.AddInParameter(command, "@DesignationIds", SqlDbType.VarChar, DesignationIds);
                    database.AddInParameter(command, "@IsTechTask", SqlDbType.Bit, IsTechTask);
                    database.AddInParameter(command, "@HighLightedTaskID", SqlDbType.BigInt, HighlightedTaskID);
                    command.CommandType = CommandType.StoredProcedure;

                    DataSet result = database.ExecuteDataSet(command);

                    return result;

                }
            }

            catch (Exception ex)
            {
                return null;
            }

        }

        public DataSet GetAllInProAssReqTaskWithSequence(Int32 page, Int32 pageSize, String DesignationIds, string TaskUserStatus, string UserIds, string StartDate, string EndDate, bool ForInProgress)
        {
            try
            {
                SqlDatabase database = MSSQLDataBase.Instance.GetDefaultDatabase();
                {
                    DbCommand command = database.GetStoredProcCommand("usp_GetAllInProAssReqTaskWithSequence");

                    database.AddInParameter(command, "@PageIndex", SqlDbType.Int, page);
                    database.AddInParameter(command, "@PageSize", SqlDbType.Int, pageSize);
                    database.AddInParameter(command, "@DesignationIds", SqlDbType.VarChar, DesignationIds);
                    database.AddInParameter(command, "@TaskStatus", SqlDbType.VarChar, TaskUserStatus.Split(":".ToCharArray())[0]);
                    database.AddInParameter(command, "@UserStatus", SqlDbType.VarChar, TaskUserStatus.Split(":".ToCharArray())[1]);
                    database.AddInParameter(command, "@StartDate", SqlDbType.VarChar, StartDate.Equals("All") ? "" : StartDate);
                    database.AddInParameter(command, "@EndDate", SqlDbType.VarChar, EndDate);
                    database.AddInParameter(command, "@UserIds", SqlDbType.VarChar, UserIds);
                    database.AddInParameter(command, "@ForInProgress", SqlDbType.Bit, ForInProgress);
                    command.CommandType = CommandType.StoredProcedure;

                    DataSet result = database.ExecuteDataSet(command);

                    return result;

                }
            }

            catch (Exception ex)
            {
                return null;
            }

        }

        public DataSet GetAllPartialFrozenTaskWithSequence(Int32 page, Int32 pageSize, String DesignationIds, bool IsTechTask)
        {
            try
            {
                SqlDatabase database = MSSQLDataBase.Instance.GetDefaultDatabase();
                {
                    DbCommand command = database.GetStoredProcCommand("usp_GetAllPartialFrozenTaskWithSequence");
                    database.AddInParameter(command, "@PageIndex", SqlDbType.Int, page);
                    database.AddInParameter(command, "@PageSize", SqlDbType.Int, pageSize);
                    database.AddInParameter(command, "@DesignationIds", SqlDbType.VarChar, DesignationIds);
                    database.AddInParameter(command, "@IsTechTask", SqlDbType.Bit, IsTechTask);
                    command.CommandType = CommandType.StoredProcedure;

                    DataSet result = database.ExecuteDataSet(command);

                    return result;

                }
            }

            catch (Exception ex)
            {
                return null;
            }

        }
        public DataSet GetAllNonFrozenTaskWithSequence(Int32 page, Int32 pageSize, String DesignationIds, bool IsTechTask)
        {
            try
            {
                SqlDatabase database = MSSQLDataBase.Instance.GetDefaultDatabase();
                {
                    DbCommand command = database.GetStoredProcCommand("usp_GetAllNonFrozenTaskWithSequence");
                    database.AddInParameter(command, "@PageIndex", SqlDbType.Int, page);
                    database.AddInParameter(command, "@PageSize", SqlDbType.Int, pageSize);
                    database.AddInParameter(command, "@DesignationIds", SqlDbType.VarChar, DesignationIds);
                    database.AddInParameter(command, "@IsTechTask", SqlDbType.Bit, IsTechTask);
                    command.CommandType = CommandType.StoredProcedure;

                    DataSet result = database.ExecuteDataSet(command);

                    return result;

                }
            }

            catch (Exception ex)
            {
                return null;
            }

        }
        public DataSet GetFrozenNonFrozenTaskCount()
        {
            try
            {
                SqlDatabase database = MSSQLDataBase.Instance.GetDefaultDatabase();
                {
                    DbCommand command = database.GetStoredProcCommand("GetFrozenNonFrozenTaskCount");
                    command.CommandType = CommandType.StoredProcedure;
                    DataSet result = database.ExecuteDataSet(command);
                    return result;
                }
            }

            catch (Exception ex)
            {
                return null;
            }

        }
        public DataSet GetAllNonFrozenUserTaskWithSequence(Int32 page, Int32 pageSize, bool IsTechTask, string UserId)
        {
            try
            {
                SqlDatabase database = MSSQLDataBase.Instance.GetDefaultDatabase();
                {
                    DbCommand command = database.GetStoredProcCommand("usp_GetAllNonFrozenUserTaskWithSequence");

                    database.AddInParameter(command, "@PageIndex", SqlDbType.Int, page);
                    database.AddInParameter(command, "@PageSize", SqlDbType.Int, pageSize);
                    database.AddInParameter(command, "@UserId", SqlDbType.VarChar, UserId);
                    database.AddInParameter(command, "@IsTechTask", SqlDbType.Bit, IsTechTask);
                    command.CommandType = CommandType.StoredProcedure;

                    DataSet result = database.ExecuteDataSet(command);

                    return result;

                }
            }

            catch (Exception ex)
            {
                return null;
            }

        }
        public DataSet GetAllPartialFrozenUserTaskWithSequence(Int32 page, Int32 pageSize, bool IsTechTask, string UserId)
        {
            try
            {
                SqlDatabase database = MSSQLDataBase.Instance.GetDefaultDatabase();
                {
                    DbCommand command = database.GetStoredProcCommand("usp_GetAllPartialFrozenUserTaskWithSequence");

                    database.AddInParameter(command, "@PageIndex", SqlDbType.Int, page);
                    database.AddInParameter(command, "@PageSize", SqlDbType.Int, pageSize);
                    database.AddInParameter(command, "@UserId", SqlDbType.VarChar, UserId);
                    database.AddInParameter(command, "@IsTechTask", SqlDbType.Bit, IsTechTask);
                    command.CommandType = CommandType.StoredProcedure;

                    DataSet result = database.ExecuteDataSet(command);

                    return result;

                }
            }

            catch (Exception ex)
            {
                return null;
            }

        }


        public DataSet GetAllInProAssReqUserTaskWithSequence(Int32 page, Int32 pageSize, bool IsTechTask, string UserId, bool ForDashboard, string StartDate, string EndDate, bool ForInProgress)
        {
            try
            {
                SqlDatabase database = MSSQLDataBase.Instance.GetDefaultDatabase();
                {
                    DbCommand command = database.GetStoredProcCommand("usp_GetAllInProAssReqUserTaskWithSequence");

                    database.AddInParameter(command, "@PageIndex", SqlDbType.Int, page);
                    database.AddInParameter(command, "@PageSize", SqlDbType.Int, pageSize);
                    database.AddInParameter(command, "@UserId", SqlDbType.VarChar, UserId);
                    database.AddInParameter(command, "@IsTechTask", SqlDbType.Bit, IsTechTask);
                    database.AddInParameter(command, "@ForDashboard", SqlDbType.Bit, ForDashboard);
                    database.AddInParameter(command, "@ForInProgress", SqlDbType.Bit, ForInProgress);
                    database.AddInParameter(command, "@StartDate", SqlDbType.VarChar, StartDate.Equals("All") ? "" : StartDate);
                    database.AddInParameter(command, "@EndDate", SqlDbType.VarChar, EndDate);
                    command.CommandType = CommandType.StoredProcedure;

                    DataSet result = database.ExecuteDataSet(command);

                    return result;

                }
            }

            catch (Exception ex)
            {
                return null;
            }

        }

        public DataSet GetAllTasksforSubSequencing(Int32 DesignationId, String DesiSeqCode, bool IsTechTask, Int64 TaskId)
        {
            try
            {
                SqlDatabase database = MSSQLDataBase.Instance.GetDefaultDatabase();
                {
                    DbCommand command = database.GetStoredProcCommand("usp_GetAllTasksforSubSequencing");

                    database.AddInParameter(command, "@DesignationId", SqlDbType.Int, DesignationId);
                    database.AddInParameter(command, "@DesiSeqCode", SqlDbType.VarChar, DesiSeqCode);
                    database.AddInParameter(command, "@IsTechTask", SqlDbType.Bit, IsTechTask);
                    database.AddInParameter(command, "@TaskId", SqlDbType.BigInt, TaskId);



                    command.CommandType = CommandType.StoredProcedure;

                    DataSet result = database.ExecuteDataSet(command);

                    return result;

                }
            }

            catch (Exception ex)
            {
                return null;
            }

        }

        public DataSet GetDesignationTaskToAssignWithSequence(Int32 DesignationId, bool IsTechTask)
        {
            try
            {
                SqlDatabase database = MSSQLDataBase.Instance.GetDefaultDatabase();
                {
                    DbCommand command = database.GetStoredProcCommand("usp_GetLastAssignedDesigSequencnce");

                    database.AddInParameter(command, "@DesignationId", SqlDbType.Int, DesignationId);
                    database.AddInParameter(command, "@IsTechTask", SqlDbType.Bit, IsTechTask);

                    command.CommandType = CommandType.StoredProcedure;

                    DataSet result = database.ExecuteDataSet(command);

                    return result;

                }
            }

            catch (Exception ex)
            {
                return null;
            }

        }

        public DataSet GetUserAssignedWithSequence(Int32 DesignationId, bool IsTechTask, Int32 UserID)
        {
            try
            {
                SqlDatabase database = MSSQLDataBase.Instance.GetDefaultDatabase();
                {
                    DbCommand command = database.GetStoredProcCommand("usp_GetUserAssignedDesigSequencnce");

                    database.AddInParameter(command, "@DesignationId", SqlDbType.Int, DesignationId);
                    database.AddInParameter(command, "@IsTechTask", SqlDbType.Bit, IsTechTask);
                    database.AddInParameter(command, "@UserID", SqlDbType.Int, UserID);

                    command.CommandType = CommandType.StoredProcedure;

                    DataSet result = database.ExecuteDataSet(command);

                    return result;

                }
            }

            catch (Exception ex)
            {
                return null;
            }

        }

        public DataSet GetUserAssignedTaskHistory(Int32 UserID)
        {
            try
            {
                SqlDatabase database = MSSQLDataBase.Instance.GetDefaultDatabase();
                {
                    DbCommand command = database.GetStoredProcCommand("GetUserAssignedTaskHistory");
                    database.AddInParameter(command, "@UserID", SqlDbType.Int, UserID);
                    command.CommandType = CommandType.StoredProcedure;

                    DataSet result = database.ExecuteDataSet(command);

                    return result;

                }
            }

            catch (Exception ex)
            {
                return null;
            }

        }

        public DataSet RejectUserAssignedWithSequence(Int64 SequenceID, Int32 UserID, Int32 RejectedUserID)
        {
            try
            {
                SqlDatabase database = MSSQLDataBase.Instance.GetDefaultDatabase();
                {
                    DbCommand command = database.GetStoredProcCommand("usp_RemoveUserAssignedSeq");

                    database.AddInParameter(command, "@AssignedSeqID", SqlDbType.BigInt, SequenceID);
                    database.AddInParameter(command, "@UserId", SqlDbType.Int, UserID);
                    database.AddInParameter(command, "@RejectedUserID", SqlDbType.Int, RejectedUserID);

                    command.CommandType = CommandType.StoredProcedure;

                    DataSet result = database.ExecuteDataSet(command);

                    return result;

                }
            }

            catch (Exception ex)
            {
                return null;
            }

        }

        public bool AcceptUserAssignedWithSequence(Int64 SequenceId)
        {
            try
            {
                SqlDatabase database = MSSQLDataBase.Instance.GetDefaultDatabase();
                {
                    DbCommand command = database.GetStoredProcCommand("usp_UpdateUserAssignedSeqAcceptance");

                    database.AddInParameter(command, "@AssignedSeqID", SqlDbType.BigInt, SequenceId);

                    command.CommandType = CommandType.StoredProcedure;

                    database.ExecuteNonQuery(command);

                    return true;

                }
            }

            catch (Exception ex)
            {
                return false;
            }

        }

        public Int32 GetTaskIdByTaskSequence(Int64 SequenceId)
        {
            try
            {
                SqlDatabase database = MSSQLDataBase.Instance.GetDefaultDatabase();
                {
                    DbCommand command = database.GetStoredProcCommand("GetTaskIdByTaskSequence");

                    database.AddInParameter(command, "@AssignedSeqID", SqlDbType.BigInt, SequenceId);

                    command.CommandType = CommandType.StoredProcedure;

                    returndata= database.ExecuteDataSet(command);
                    return Convert.ToInt32(returndata.Tables[0].Rows[0]["TaskId"]);
                }
            }

            catch (Exception ex)
            {
                return 0;
            }

        }

        public bool TaskSwapSequence(Int64 FirstSequenceId, Int64 SecondSequenceId, Int64 FirstTaskId, Int64 SecondTaskId)
        {
            try
            {
                SqlDatabase database = MSSQLDataBase.Instance.GetDefaultDatabase();
                {
                    DbCommand command = database.GetStoredProcCommand("usp_SwapTaskSequences");

                    database.AddInParameter(command, "@FirstTaskID", SqlDbType.BigInt, FirstTaskId);
                    database.AddInParameter(command, "@SecondTaskID", SqlDbType.BigInt, SecondTaskId);
                    database.AddInParameter(command, "@FirstSeq", SqlDbType.BigInt, FirstSequenceId);
                    database.AddInParameter(command, "@SecondSeq", SqlDbType.BigInt, SecondSequenceId);

                    command.CommandType = CommandType.StoredProcedure;

                    database.ExecuteNonQuery(command);

                    return true;

                }
            }

            catch (Exception ex)
            {
                return false;
            }

        }

        public bool TaskSwapSubSequence(Int64 FirstSequenceId, Int64 SecondSequenceId, Int64 FirstTaskId, Int64 SecondTaskId)
        {
            try
            {
                SqlDatabase database = MSSQLDataBase.Instance.GetDefaultDatabase();
                {
                    DbCommand command = database.GetStoredProcCommand("usp_SwapSubTaskSequences");

                    database.AddInParameter(command, "@FirstTaskID", SqlDbType.BigInt, FirstTaskId);
                    database.AddInParameter(command, "@SecondTaskID", SqlDbType.BigInt, SecondTaskId);
                    database.AddInParameter(command, "@FirstSubSeq", SqlDbType.BigInt, FirstSequenceId);
                    database.AddInParameter(command, "@SecondSubSeq", SqlDbType.BigInt, SecondSequenceId);

                    command.CommandType = CommandType.StoredProcedure;

                    database.ExecuteNonQuery(command);

                    return true;

                }
            }

            catch (Exception ex)
            {
                return false;
            }

        }

        public bool TaskSwapRoman(Int64 FirstRomanId, Int64 SecondRomanId)
        {
            try
            {
                SqlDatabase database = MSSQLDataBase.Instance.GetDefaultDatabase();
                {
                    DbCommand command = database.GetStoredProcCommand("usp_SwapRomans");

                    database.AddInParameter(command, "@FirstRomanId", SqlDbType.BigInt, FirstRomanId);
                    database.AddInParameter(command, "@SecondRomanId", SqlDbType.BigInt, SecondRomanId);

                    command.CommandType = CommandType.StoredProcedure;

                    database.ExecuteNonQuery(command);

                    return true;

                }
            }

            catch (Exception ex)
            {
                return false;
            }

        }



        public bool DeleteTaskSequence(Int64 TaskId)
        {
            try
            {
                SqlDatabase database = MSSQLDataBase.Instance.GetDefaultDatabase();
                {
                    DbCommand command = database.GetStoredProcCommand("usp_DeleteTaskSequenceByTaskId");

                    database.AddInParameter(command, "@TaskId", SqlDbType.BigInt, TaskId);

                    command.CommandType = CommandType.StoredProcedure;

                    database.ExecuteNonQuery(command);

                    return true;

                }
            }

            catch (Exception ex)
            {
                return false;
            }

        }

        public bool MoveTask(int TaskId, int FromTaskId, int ToTaskId)
        {
            try
            {
                SqlDatabase database = MSSQLDataBase.Instance.GetDefaultDatabase();
                {
                    DbCommand command = database.GetStoredProcCommand("usp_MoveTask");

                    database.AddInParameter(command, "@TaskId", SqlDbType.BigInt, TaskId);
                    database.AddInParameter(command, "@FromTaskId", SqlDbType.BigInt, FromTaskId);
                    database.AddInParameter(command, "@ToTaskId", SqlDbType.BigInt, ToTaskId);

                    command.CommandType = CommandType.StoredProcedure;

                    int retVal = database.ExecuteNonQuery(command);

                    return retVal > 0;

                }
            }

            catch (Exception ex)
            {
                return false;
            }

        }


        public bool DeleteTaskSubSequence(Int64 TaskId)
        {
            try
            {
                SqlDatabase database = MSSQLDataBase.Instance.GetDefaultDatabase();
                {
                    DbCommand command = database.GetStoredProcCommand("usp_DeleteTaskSubSequenceByTaskId");

                    database.AddInParameter(command, "@TaskId", SqlDbType.BigInt, TaskId);

                    command.CommandType = CommandType.StoredProcedure;

                    database.ExecuteNonQuery(command);

                    return true;

                }
            }

            catch (Exception ex)
            {
                return false;
            }

        }

        public Boolean InsertAssignedDesignationTaskWithSequence(Int32 DesignationId, bool IsTechTask, Int64 AssignedSequence, Int64 TaskId, Int32 UserId)
        {
            try
            {
                SqlDatabase database = MSSQLDataBase.Instance.GetDefaultDatabase();
                {
                    DbCommand command = database.GetStoredProcCommand(" ");

                    database.AddInParameter(command, "@AssignedSequence", SqlDbType.BigInt, AssignedSequence);
                    database.AddInParameter(command, "@DesignationId", SqlDbType.Int, DesignationId);
                    database.AddInParameter(command, "@IsTechTask", SqlDbType.Bit, IsTechTask);
                    database.AddInParameter(command, "@TaskId", SqlDbType.BigInt, TaskId);
                    database.AddInParameter(command, "@UserId", SqlDbType.Int, UserId);
                    command.CommandType = CommandType.StoredProcedure;

                    Int32 result = database.ExecuteNonQuery(command);

                    return result > 0 ? true : false;

                }
            }

            catch (Exception ex)
            {
                return false;
            }

        }

        public DataSet GetLatestTaskSequence(Int32 DesignationId, bool IsTechTask)
        {
            try
            {
                SqlDatabase database = MSSQLDataBase.Instance.GetDefaultDatabase();
                {
                    DbCommand command = database.GetStoredProcCommand("usp_GetLastAvailableSequence");

                    command.CommandType = CommandType.StoredProcedure;

                    database.AddInParameter(command, "@DesignationID", DbType.Int32, DesignationId);
                    database.AddInParameter(command, "@IsTechTask", DbType.Boolean, IsTechTask);

                    DataSet result = database.ExecuteDataSet(command);

                    return result;

                }
            }

            catch (Exception ex)
            {
                return null;
            }

        }

        public int UpdateTaskSequence(Int64 Sequence, Int64 TaskID, Int32 DesignationID, bool IsTechTask)
        {
            try
            {
                SqlDatabase database = MSSQLDataBase.Instance.GetDefaultDatabase();
                {
                    DbCommand command = database.GetStoredProcCommand("usp_UpdateTaskSequence");

                    command.CommandType = CommandType.StoredProcedure;

                    database.AddInParameter(command, "@Sequence", DbType.Int64, Sequence);
                    database.AddInParameter(command, "@DesignationID", DbType.Int32, DesignationID);
                    database.AddInParameter(command, "@TaskId", DbType.Int64, TaskID);
                    database.AddInParameter(command, "@IsTechTask", DbType.Boolean, IsTechTask);

                    int result = database.ExecuteNonQuery(command);

                    return result;

                }
            }

            catch (Exception ex)
            {
                return 0;
            }

        }

        public DataSet GetInterviewDateSequences(Int32 DesignationId, Int32 UserCount)
        {

            try
            {
                SqlDatabase database = MSSQLDataBase.Instance.GetDefaultDatabase();
                {
                    DbCommand command = database.GetStoredProcCommand("usp_GetAssignedDesigSequenceForInterviewDatePopup");

                    database.AddInParameter(command, "@DesignationId", SqlDbType.Int, DesignationId);
                    database.AddInParameter(command, "@IsTechTask", SqlDbType.Bit, true);
                    database.AddInParameter(command, "@UserCount", SqlDbType.Int, UserCount);

                    command.CommandType = CommandType.StoredProcedure;

                    DataSet result = database.ExecuteDataSet(command);

                    return result;

                }
            }

            catch (Exception ex)
            {
                return null;
            }

        }

        public bool UpdateTaskSubSequence(Int64 TaskID, Int64 TaskIdSeq, Int64 SubSeqTaskId, Int64 DesignationId)
        {
            try
            {
                SqlDatabase database = MSSQLDataBase.Instance.GetDefaultDatabase();
                {
                    DbCommand command = database.GetStoredProcCommand("usp_UpdateTaskForSubSequencing");

                    command.CommandType = CommandType.StoredProcedure;

                    database.AddInParameter(command, "@TaskId", DbType.Int64, TaskID);
                    database.AddInParameter(command, "@TaskIdSeq", DbType.Int64, TaskIdSeq);
                    database.AddInParameter(command, "@SubSeqTaskId", DbType.Int64, SubSeqTaskId);
                    database.AddInParameter(command, "@DesignationId", DbType.Int32, DesignationId);

                    database.ExecuteNonQuery(command);

                    return true;

                }
            }

            catch (Exception ex)
            {
                return false;
            }

        }

        #endregion
        public Int64 SaveOrDeleteTask(Task objTask, int TaskLevel, int maintaskid)
        {
            try
            {
                SqlDatabase database = MSSQLDataBase.Instance.GetDefaultDatabase();
                {
                    DbCommand command = database.GetStoredProcCommand("SP_SaveOrDeleteTask");

                    command.CommandType = CommandType.StoredProcedure;
                    database.AddInParameter(command, "@Mode", DbType.Int16, objTask.Mode);
                    database.AddInParameter(command, "@TaskId", DbType.Int64, objTask.TaskId);
                    database.AddInParameter(command, "@Title", DbType.String, objTask.Title);
                    database.AddInParameter(command, "@Url", DbType.String, objTask.Url);
                    database.AddInParameter(command, "@Description", DbType.String, objTask.Description);
                    database.AddInParameter(command, "@Status", DbType.Int16, objTask.Status);

                    if (!string.IsNullOrEmpty(objTask.DueDate))
                    {
                        database.AddInParameter(command, "@DueDate", DbType.DateTime, Convert.ToDateTime(objTask.DueDate));
                    }

                    database.AddInParameter(command, "@Hours", DbType.String, objTask.Hours);
                    database.AddInParameter(command, "@CreatedBy", DbType.Int32, objTask.CreatedBy);

                    if (objTask.ParentTaskId.HasValue)
                    {
                        database.AddInParameter(command, "@InstallId", DbType.String, objTask.InstallId);
                        database.AddInParameter(command, "@ParentTaskId", DbType.Int32, objTask.ParentTaskId.Value);
                    }

                    if (objTask.TaskType.HasValue)
                    {
                        database.AddInParameter(command, "@TaskType", DbType.Int16, objTask.TaskType.Value);
                    }

                    if (objTask.TaskPriority.HasValue)
                    {
                        database.AddInParameter(command, "@TaskPriority", DbType.Int16, objTask.TaskPriority.Value);
                    }
                    database.AddInParameter(command, "@IsTechTask", DbType.Int16, objTask.IsTechTask);
                    database.AddInParameter(command, "@DeletedStatus", SqlDbType.SmallInt, (byte)Common.JGConstant.TaskStatus.Deleted);
                    database.AddInParameter(command, "@TaskLevel", DbType.Int32, TaskLevel);
                    database.AddInParameter(command, "@MainTaskId", DbType.Int32, maintaskid);
                    database.AddInParameter(command, "@Sequence", DbType.Int64, objTask.Sequence);

                    database.AddOutParameter(command, "@Result", DbType.Int32, 0);

                    int result = database.ExecuteNonQuery(command);

                    if (objTask.Mode == 0)
                    {
                        Int64 Identity = 0;
                        Identity = Convert.ToInt64(database.GetParameterValue(command, "@Result"));
                        return Identity;
                    }
                    else
                    {
                        return Convert.ToInt64(result);
                    }

                }
            }

            catch (Exception ex)
            {
                return 0;
            }

        }

        public String HardDeleteTask(Int64 maintaskid)
        {
            String filesToDelete = String.Empty;

            try
            {
                SqlDatabase database = MSSQLDataBase.Instance.GetDefaultDatabase();
                {
                    DbCommand command = database.GetStoredProcCommand("usp_HardDeleteTask");

                    command.CommandType = CommandType.StoredProcedure;
                    database.AddInParameter(command, "@TaskId", DbType.Int64, maintaskid);
                    database.AddOutParameter(command, "@TaskAttachments", DbType.String, -1);
                    database.AddOutParameter(command, "@AllDeleted", DbType.Boolean, -1);

                    int result = database.ExecuteNonQuery(command);

                    if (result > 0)
                    {
                        Boolean allDeleted = Convert.ToBoolean(database.GetParameterValue(command, "@AllDeleted"));

                        if (allDeleted)
                        {
                            filesToDelete = Convert.ToString(database.GetParameterValue(command, "@TaskAttachments"));
                        }
                    }

                }
            }

            catch (Exception ex)
            {

            }

            return filesToDelete;

        }

        public int UpdateTaskStatus(Task objTask)
        {
            try
            {
                SqlDatabase database = MSSQLDataBase.Instance.GetDefaultDatabase();
                {
                    DbCommand command = database.GetStoredProcCommand("usp_UpdateTaskStatus");

                    command.CommandType = CommandType.StoredProcedure;

                    database.AddInParameter(command, "@TaskId", DbType.Int64, objTask.TaskId);
                    database.AddInParameter(command, "@Status", DbType.Int16, objTask.Status);

                    int result = database.ExecuteNonQuery(command);

                    return result;

                }
            }

            catch (Exception ex)
            {
                return 0;
            }

        }

        public int UpdateTaskPriority(Task objTask)
        {
            try
            {
                SqlDatabase database = MSSQLDataBase.Instance.GetDefaultDatabase();
                {
                    DbCommand command = database.GetStoredProcCommand("usp_UpdateTaskPriority");

                    command.CommandType = CommandType.StoredProcedure;

                    database.AddInParameter(command, "@TaskId", DbType.Int64, objTask.TaskId);
                    database.AddInParameter(command, "@TaskPriority", DbType.Int16, objTask.TaskPriority);

                    int result = database.ExecuteNonQuery(command);

                    return result;

                }
            }

            catch (Exception ex)
            {
                return 0;
            }

        }

        public bool DeleteTask(UInt64 taskId)
        {
            try
            {
                SqlDatabase database = MSSQLDataBase.Instance.GetDefaultDatabase();
                {
                    DbCommand command = database.GetStoredProcCommand("usp_DeleteTask");

                    command.CommandType = CommandType.StoredProcedure;
                    database.AddInParameter(command, "@TaskId", SqlDbType.BigInt, taskId);
                    database.AddInParameter(command, "@DeletedStatus", SqlDbType.SmallInt, (byte)Common.JGConstant.TaskStatus.Deleted);

                    int result = database.ExecuteNonQuery(command);

                    if (result > 0)
                    {
                        return true;
                    }
                    else
                    {
                        return false;
                    }
                }
            }
            catch (Exception ex)
            {
                return false;
            }

        }

        public bool SaveTaskDesignations(UInt64 TaskId, String strDesignations, String TaskIDCode)
        {
            try
            {
                SqlDatabase database = MSSQLDataBase.Instance.GetDefaultDatabase();
                {
                    DbCommand command = database.GetStoredProcCommand("usp_InsertTaskDesignations");

                    command.CommandType = CommandType.StoredProcedure;
                    database.AddInParameter(command, "@TaskId", SqlDbType.BigInt, TaskId);
                    database.AddInParameter(command, "@Designations", SqlDbType.VarChar, strDesignations);
                    database.AddInParameter(command, "@TaskIDCode", SqlDbType.VarChar, TaskIDCode);

                    int result = database.ExecuteNonQuery(command);

                    if (result > 0)
                    {
                        return true;
                    }
                    else
                    {
                        return false;
                    }
                }
            }
            catch (Exception ex)
            {
                return false;
            }

        }

        public bool SaveTaskQuery(int TaskId, string QueryDesc, int QueryTypeId, int QueryStatusId, int CreatedById)
        {
            try
            {
                SqlDatabase database = MSSQLDataBase.Instance.GetDefaultDatabase();
                {
                    DbCommand command = database.GetStoredProcCommand("usp_CreateTaskQuery");

                    command.CommandType = CommandType.StoredProcedure;
                    database.AddInParameter(command, "@TaskId", SqlDbType.Int, TaskId);
                    database.AddInParameter(command, "@QueryDesc", SqlDbType.VarChar, QueryDesc);
                    database.AddInParameter(command, "@QueryTypeId", SqlDbType.Int, QueryTypeId);
                    database.AddInParameter(command, "@QueryStatusId", SqlDbType.Int, QueryStatusId);
                    database.AddInParameter(command, "@CreatedByUserId", SqlDbType.Int, CreatedById);

                    int result = database.ExecuteNonQuery(command);

                    if (result > 0)
                    {
                        return true;
                    }
                    else
                    {
                        return false;
                    }
                }
            }

            catch (Exception ex)
            {
                return false;
            }
        }

        public bool SaveTaskAssignedUsersRoman(UInt64 TaskId, String UserIds)
        {
            try
            {
                SqlDatabase database = MSSQLDataBase.Instance.GetDefaultDatabase();
                {
                    DbCommand command = database.GetStoredProcCommand("usp_InsertTaskAssignedUsersRoman");

                    command.CommandType = CommandType.StoredProcedure;
                    database.AddInParameter(command, "@TaskId", SqlDbType.BigInt, TaskId);
                    database.AddInParameter(command, "@UserIds", SqlDbType.VarChar, UserIds);

                    int result = database.ExecuteNonQuery(command);

                    //if (result > 0)
                    //{
                    return true;
                    //}
                    //else
                    //{
                    //    return false;
                    //}
                }
            }

            catch (Exception ex)
            {
                return false;
            }
        }

        public bool SaveTaskAssignedUsers(UInt64 TaskId, String UserIds)
        {
            try
            {
                SqlDatabase database = MSSQLDataBase.Instance.GetDefaultDatabase();
                {
                    DbCommand command = database.GetStoredProcCommand("usp_InsertTaskAssignedUsers");

                    command.CommandType = CommandType.StoredProcedure;
                    database.AddInParameter(command, "@TaskId", SqlDbType.BigInt, TaskId);
                    database.AddInParameter(command, "@UserIds", SqlDbType.VarChar, UserIds);

                    int result = database.ExecuteNonQuery(command);

                    //if (result > 0)
                    //{
                    return true;
                    //}
                    //else
                    //{
                    //    return false;
                    //}
                }
            }

            catch (Exception ex)
            {
                return false;
            }
        }

        public bool SaveTaskMultiLevelChild(int ParentTaskId, string InstallId, string Title, string Description, int IndentLevel, string Class, int UserId)
        {
            try
            {
                SqlDatabase database = MSSQLDataBase.Instance.GetDefaultDatabase();
                {
                    DbCommand command = database.GetStoredProcCommand("sp_AddMultiLevelChlild");

                    command.CommandType = CommandType.StoredProcedure;
                    database.AddInParameter(command, "@ParentTaskId", SqlDbType.Int, ParentTaskId);
                    database.AddInParameter(command, "@InstallId", SqlDbType.VarChar, InstallId);
                    database.AddInParameter(command, "@Title", SqlDbType.VarChar, Title);
                    database.AddInParameter(command, "@Description", SqlDbType.VarChar, Description);
                    database.AddInParameter(command, "@IndentLevel", SqlDbType.Int, IndentLevel);
                    database.AddInParameter(command, "@Class", SqlDbType.VarChar, Class);
                    database.AddInParameter(command, "@UserId", SqlDbType.VarChar, UserId);

                    int result = database.ExecuteNonQuery(command);

                    //if (result > 0)
                    //{
                    return true;
                    //}
                    //else
                    //{
                    //    return false;
                    //}
                }
            }

            catch (Exception ex)
            {
                return false;
            }
        }

        public bool SetTaskStatus(int TaskId, string taskStatus)
        {
            try
            {
                SqlDatabase database = MSSQLDataBase.Instance.GetDefaultDatabase();
                {
                    DbCommand command = database.GetSqlStringCommand("update  tblTask set [status]=" + taskStatus + " where TaskId=" + TaskId);
                    command.CommandType = CommandType.Text;
                    database.ExecuteNonQuery(command);
                }
                return true;
            }

            catch (Exception ex)
            {
                return false;
            }
        }

        public bool SetRomanTaskStatus(int TaskId, int TaskStatus)
        {
            try
            {
                SqlDatabase database = MSSQLDataBase.Instance.GetDefaultDatabase();
                {
                    DbCommand command = database.GetStoredProcCommand("usp_UpdateRomanTaskStatus");

                    command.CommandType = CommandType.StoredProcedure;
                    database.AddInParameter(command, "@TaskId", SqlDbType.BigInt, TaskId);
                    database.AddInParameter(command, "@TaskStatus", SqlDbType.BigInt, TaskStatus);

                    int result = database.ExecuteNonQuery(command);

                    if (result > 0)
                    {
                        return true;
                    }
                    else
                    {
                        return false;
                    }
                }
            }

            catch (Exception ex)
            {
                return false;
            }
        }

        public bool SaveTaskAssignedToMultipleUsers(UInt64 TaskId, String UserId)
        {
            try
            {
                SqlDatabase database = MSSQLDataBase.Instance.GetDefaultDatabase();
                {
                    DbCommand command = database.GetStoredProcCommand("usp_InsertTaskAssignedToMultipleUsers");

                    command.CommandType = CommandType.StoredProcedure;
                    database.AddInParameter(command, "@TaskId", SqlDbType.BigInt, TaskId);
                    database.AddInParameter(command, "@UserIds", SqlDbType.VarChar, UserId);

                    int result = database.ExecuteNonQuery(command);

                    if (result > 0)
                    {
                        return true;
                    }
                    else
                    {
                        return false;
                    }
                }
            }

            catch (Exception ex)
            {
                return false;
            }
        }

        public bool SaveTaskAssignmentRequests(UInt64 TaskId, String UserIds)
        {
            try
            {
                SqlDatabase database = MSSQLDataBase.Instance.GetDefaultDatabase();
                {
                    DbCommand command = database.GetStoredProcCommand("usp_InsertTaskAssignmentRequests");

                    command.CommandType = CommandType.StoredProcedure;
                    database.AddInParameter(command, "@TaskId", SqlDbType.BigInt, TaskId);
                    database.AddInParameter(command, "@UserIds", SqlDbType.VarChar, UserIds);

                    int result = database.ExecuteNonQuery(command);

                    if (result > 0)
                    {
                        return true;
                    }
                    else
                    {
                        return false;
                    }
                }
            }

            catch (Exception ex)
            {
                return false;
            }
        }

        public bool AcceptTaskAssignmentRequests(UInt64 TaskId, String UserIds)
        {
            try
            {
                SqlDatabase database = MSSQLDataBase.Instance.GetDefaultDatabase();
                {
                    DbCommand command = database.GetStoredProcCommand("usp_AcceptTaskAssignmentRequests");

                    command.CommandType = CommandType.StoredProcedure;
                    database.AddInParameter(command, "@TaskId", SqlDbType.BigInt, TaskId);
                    database.AddInParameter(command, "@UserIds", SqlDbType.VarChar, UserIds);

                    int result = database.ExecuteNonQuery(command);

                    if (result > 0)
                    {
                        return true;
                    }
                    else
                    {
                        return false;
                    }
                }
            }

            catch (Exception ex)
            {
                return false;
            }
        }

        //Get details for task with user and attachments
        public DataSet GetTasksInformation(Int32 TaskId)
        {
            try
            {
                SqlDatabase database = MSSQLDataBase.Instance.GetDefaultDatabase();
                {
                    returndata = new DataSet();
                    DbCommand command = database.GetStoredProcCommand("GetTasksInformation");
                    command.CommandType = CommandType.StoredProcedure;

                    database.AddInParameter(command, "@TaskId", DbType.Int32, TaskId);

                    returndata = database.ExecuteDataSet(command);

                    return returndata;
                }
            }

            catch (Exception ex)
            {
                return null;
            }
        }



        public bool SaveOrDeleteTaskNotes(ref TaskUser objTaskUser)
        {
            try
            {
                SqlDatabase database = MSSQLDataBase.Instance.GetDefaultDatabase();
                {
                    DbCommand command = database.GetStoredProcCommand("SP_SaveOrDeleteTaskUser");

                    command.CommandType = CommandType.StoredProcedure;
                    database.AddInParameter(command, "@Mode", DbType.Int16, objTaskUser.Mode);
                    database.AddInParameter(command, "@Id", DbType.Int64, objTaskUser.Id);
                    database.AddInParameter(command, "@TaskId", DbType.Int64, objTaskUser.TaskId);
                    database.AddInParameter(command, "@UserId", DbType.String, objTaskUser.UserId);
                    database.AddInParameter(command, "@UserType", DbType.Boolean, objTaskUser.UserType);
                    database.AddInParameter(command, "@Status", DbType.Int16, objTaskUser.Status);
                    database.AddInParameter(command, "@Notes", DbType.String, objTaskUser.Notes);
                    database.AddInParameter(command, "@UserAcceptance", DbType.Boolean, objTaskUser.UserAcceptance);
                    database.AddOutParameter(command, "@TaskUpdateId", SqlDbType.BigInt, Int32.MaxValue);
                    database.AddInParameter(command, "@IsCreatorUser", DbType.Boolean, objTaskUser.IsCreatorUser);
                    database.AddInParameter(command, "@UserFirstName", DbType.String, objTaskUser.UserFirstName);


                    int result = database.ExecuteNonQuery(command);

                    objTaskUser.TaskUpdateId = Convert.ToInt32(database.GetParameterValue(command, "@TaskUpdateId"));

                    if (result > 0)
                    {
                        return true;
                    }
                    else
                    {
                        return false;
                    }

                }
            }

            catch (Exception ex)
            {
                return false;
            }

        }

        public bool SaveTaskDescription(Int64 TaskId, String TaskDescription)
        {
            try
            {
                SqlDatabase database = MSSQLDataBase.Instance.GetDefaultDatabase();
                {
                    DbCommand command = database.GetStoredProcCommand("usp_SaveTaskDescription");

                    command.CommandType = CommandType.StoredProcedure;

                    database.AddInParameter(command, "@TaskId", DbType.Int64, TaskId);

                    database.AddInParameter(command, "@Description", DbType.String, TaskDescription);

                    int result = database.ExecuteNonQuery(command);

                    if (result > 0)
                    {
                        return true;
                    }
                    else
                    {
                        return false;
                    }

                }
            }

            catch (Exception ex)
            {
                return false;
            }

        }

        public bool UpdateTaskUserAcceptance(ref TaskUser objTaskUser)
        {
            try
            {
                SqlDatabase database = MSSQLDataBase.Instance.GetDefaultDatabase();
                {
                    DbCommand command = database.GetStoredProcCommand("usp_UpdateTaskAcceptance");

                    command.CommandType = CommandType.StoredProcedure;

                    database.AddInParameter(command, "@TaskId", DbType.Int64, objTaskUser.TaskId);
                    database.AddInParameter(command, "@UserId", DbType.String, objTaskUser.UserId);
                    database.AddInParameter(command, "@Acceptance", DbType.Boolean, objTaskUser.UserAcceptance);

                    int result = database.ExecuteNonQuery(command);

                    if (result > 0)
                    {
                        return true;
                    }
                    else
                    {
                        return false;
                    }

                }
            }

            catch (Exception ex)
            {
                return false;
            }

        }

        public bool DeleteTaskUserFile(Int64 Id)
        {
            try
            {
                SqlDatabase database = MSSQLDataBase.Instance.GetDefaultDatabase();
                {
                    DbCommand command = database.GetStoredProcCommand("usp_DeleteTaskAttachmentFile");

                    command.CommandType = CommandType.StoredProcedure;
                    database.AddInParameter(command, "@Id", SqlDbType.BigInt, Id);

                    int result = database.ExecuteNonQuery(command);



                    if (result > 0)
                    {
                        return true;
                    }
                    else
                    {
                        return false;
                    }
                }
            }

            catch (Exception ex)
            {
                return false;
            }

        }

        public bool DeleteSubTaskChild(int Id)
        {
            try
            {
                SqlDatabase database = MSSQLDataBase.Instance.GetDefaultDatabase();
                {
                    DbCommand command = database.GetStoredProcCommand("usp_DeleteSubTaskChild");

                    command.CommandType = CommandType.StoredProcedure;
                    database.AddInParameter(command, "@Id", SqlDbType.BigInt, Id);

                    int result = database.ExecuteNonQuery(command);



                    if (result > 0)
                    {
                        return true;
                    }
                    else
                    {
                        return false;
                    }
                }
            }

            catch (Exception ex)
            {
                return false;
            }

        }
        public bool DeleteTaskUserFile(int AttachmentId)
        {
            try
            {
                SqlDatabase database = MSSQLDataBase.Instance.GetDefaultDatabase();
                {
                    DbCommand command = database.GetStoredProcCommand("usp_DeleteAttachment");
                    command.CommandType = CommandType.StoredProcedure;
                    database.AddInParameter(command, "@Id", SqlDbType.Int, AttachmentId);
                    int result = database.ExecuteNonQuery(command);
                    if (result > 0)
                    {
                        return true;
                    }
                    else
                    {
                        return false;
                    }
                }
            }

            catch (Exception ex)
            {
                return false;
            }

        }
        public bool SaveOrDeleteTaskUserFiles(TaskUser objTaskUser)
        {
            try
            {
                SqlDatabase database = MSSQLDataBase.Instance.GetDefaultDatabase();
                {
                    DbCommand command = database.GetStoredProcCommand("SP_SaveOrDeleteTaskUserFiles");

                    command.CommandType = CommandType.StoredProcedure;
                    database.AddInParameter(command, "@Mode", SqlDbType.TinyInt, objTaskUser.Mode);


                    if (objTaskUser.TaskUpdateId != null)
                    {
                        database.AddInParameter(command, "@TaskUpDateId", SqlDbType.BigInt, objTaskUser.TaskUpdateId);
                    }
                    else
                    {
                        database.AddInParameter(command, "@TaskUpDateId", SqlDbType.BigInt, DBNull.Value);
                    }

                    if (objTaskUser.TaskFileDestination.HasValue)
                    {
                        database.AddInParameter(command, "@FileDestination", SqlDbType.TinyInt, Convert.ToByte(objTaskUser.TaskFileDestination.Value));
                    }

                    database.AddInParameter(command, "@TaskId", SqlDbType.BigInt, objTaskUser.TaskId);
                    database.AddInParameter(command, "@UserId", SqlDbType.Int, objTaskUser.UserId);
                    database.AddInParameter(command, "@Attachment", DbType.String, objTaskUser.Attachment);
                    database.AddInParameter(command, "@OriginalFileName", DbType.String, objTaskUser.OriginalFileName);
                    database.AddInParameter(command, "@UserType", DbType.String, objTaskUser.UserType);
                    database.AddInParameter(command, "@FileType", DbType.String, objTaskUser.FileType);

                    int result = database.ExecuteNonQuery(command);

                    if (result > 0)
                    {
                        return true;
                    }
                    else
                    {
                        return false;
                    }
                }
            }

            catch (Exception ex)
            {
                return false;
            }

        }

        //Get details for task with user and attachments
        public DataSet GetTaskDetails(Int32 TaskId, int? loggedInUserId = null)
        {
            try
            {
                SqlDatabase database = MSSQLDataBase.Instance.GetDefaultDatabase();
                {
                    returndata = new DataSet();
                    DbCommand command = database.GetStoredProcCommand("usp_GetTaskDetails");
                    command.CommandType = CommandType.StoredProcedure;

                    database.AddInParameter(command, "@TaskId", DbType.Int32, TaskId);
                    database.AddInParameter(command, "@LoggedInUserId", DbType.Int32, loggedInUserId);

                    returndata = database.ExecuteDataSet(command);

                    return returndata;
                }
            }

            catch (Exception ex)
            {
                return null;
            }
        }

        public DataSet GetTaskByMaxId(string parentTaskid, short taskLVL)
        {
            try
            {
                SqlDatabase database = MSSQLDataBase.Instance.GetDefaultDatabase();
                {
                    returndata = new DataSet();
                    DbCommand command = database.GetStoredProcCommand("usp_GetTaskByaxId");
                    command.CommandType = CommandType.StoredProcedure;

                    database.AddInParameter(command, "@parentTaskId", DbType.Int64, parentTaskid);
                    database.AddInParameter(command, "@taskLVL", DbType.Int16, taskLVL);

                    returndata = database.ExecuteDataSet(command);

                    return returndata;
                }
            }

            catch (Exception ex)
            {
                return null;
            }
        }

        //Get details for sub tasks with user and attachments
        public DataSet GetSubTasks(Int32 TaskId, bool blIsAdmin, string strSortExpression, string vsearch = "", Int32? intPageIndex = 0, Int32? intPageSize = 0, int intHighlightTaskId = 0)
        {
            try
            {
                SqlDatabase database = MSSQLDataBase.Instance.GetDefaultDatabase();
                {
                    returndata = new DataSet();
                    DbCommand command = database.GetStoredProcCommand("usp_GetSubTasks_New");
                    command.CommandType = CommandType.StoredProcedure;

                    database.AddInParameter(command, "@TaskId", DbType.Int32, TaskId);
                    database.AddInParameter(command, "@Admin", DbType.Boolean, blIsAdmin);

                    database.AddInParameter(command, "@SortExpression", DbType.String, strSortExpression);
                    database.AddInParameter(command, "@searchterm", DbType.String, vsearch);

                    database.AddInParameter(command, "@OpenStatus", SqlDbType.SmallInt, (byte)Common.JGConstant.TaskStatus.Open);
                    database.AddInParameter(command, "@RequestedStatus", SqlDbType.SmallInt, (byte)Common.JGConstant.TaskStatus.Requested);
                    database.AddInParameter(command, "@AssignedStatus", SqlDbType.SmallInt, (byte)Common.JGConstant.TaskStatus.Assigned);
                    database.AddInParameter(command, "@InProgressStatus", SqlDbType.SmallInt, (byte)Common.JGConstant.TaskStatus.InProgress);
                    database.AddInParameter(command, "@PendingStatus", SqlDbType.SmallInt, (byte)Common.JGConstant.TaskStatus.Pending);
                    database.AddInParameter(command, "@ReOpenedStatus", SqlDbType.SmallInt, (byte)Common.JGConstant.TaskStatus.ReOpened);
                    database.AddInParameter(command, "@ClosedStatus", SqlDbType.SmallInt, (byte)Common.JGConstant.TaskStatus.Closed);
                    database.AddInParameter(command, "@SpecsInProgressStatus", SqlDbType.SmallInt, (byte)Common.JGConstant.TaskStatus.SpecsInProgress);
                    database.AddInParameter(command, "@DeletedStatus", SqlDbType.SmallInt, (byte)Common.JGConstant.TaskStatus.Deleted);
                    if (intPageIndex.HasValue)
                    {
                        database.AddInParameter(command, "@PageIndex", DbType.Int32, intPageIndex.Value);
                    }
                    if (intPageSize.HasValue)
                    {
                        database.AddInParameter(command, "@PageSize", DbType.Int32, intPageSize);
                    }

                    database.AddInParameter(command, "@HighlightTaskId", DbType.Int32, intHighlightTaskId);

                    returndata = database.ExecuteDataSet(command);

                    return returndata;
                }
            }

            catch (Exception ex)
            {
                return null;
            }
        }
        public DataSet GetCalendarTasksByDate(string StartDate, string EndDate, string userid, String DesignationIDs, string TaskUserStatus)
        {
            try
            {
                SqlDatabase database = MSSQLDataBase.Instance.GetDefaultDatabase();
                {
                    returndata = new DataSet();
                    DbCommand command = database.GetStoredProcCommand("usp_GetCalendarTasksByDate");
                    command.CommandType = CommandType.StoredProcedure;

                    database.AddInParameter(command, "@StartDate", DbType.String, StartDate.Equals("All") ? "" : StartDate);
                    database.AddInParameter(command, "@EndDate", DbType.String, EndDate);
                    database.AddInParameter(command, "@UserIds", SqlDbType.VarChar, userid);
                    database.AddInParameter(command, "@DesignationIds", SqlDbType.VarChar, DesignationIDs);
                    database.AddInParameter(command, "@TaskStatus", SqlDbType.VarChar, TaskUserStatus.Split(":".ToCharArray())[0]);
                    database.AddInParameter(command, "@UserStatus", SqlDbType.VarChar, TaskUserStatus.Split(":".ToCharArray())[1]);
                    returndata = database.ExecuteDataSet(command);

                    return returndata;
                }
            }

            catch (Exception ex)
            {
                return null;
            }
        }
        public DataSet GetCalendarUsersByDate(string Date, string TaskUserStatus, string UserId)
        {
            try
            {
                SqlDatabase database = MSSQLDataBase.Instance.GetDefaultDatabase();
                {
                    returndata = new DataSet();
                    DbCommand command = database.GetStoredProcCommand("usp_GetCalenderUsersByDate");
                    command.CommandType = CommandType.StoredProcedure;

                    database.AddInParameter(command, "@Date", DbType.String, Date);
                    database.AddInParameter(command, "@UserIds", SqlDbType.VarChar, UserId);
                    database.AddInParameter(command, "@TaskStatus", SqlDbType.VarChar, TaskUserStatus.Split(":".ToCharArray())[0]);
                    database.AddInParameter(command, "@UserStatus", SqlDbType.VarChar, TaskUserStatus.Split(":".ToCharArray())[1]);
                    returndata = database.ExecuteDataSet(command);

                    return returndata;
                }
            }

            catch (Exception ex)
            {
                return null;
            }
        }

        public DataSet GetFreezedRomanData(long RomanId)
        {
            try
            {
                SqlDatabase database = MSSQLDataBase.Instance.GetDefaultDatabase();
                {
                    returndata = new DataSet();
                    DbCommand command = database.GetStoredProcCommand("usp_GetFreezedRomanData");
                    command.CommandType = CommandType.StoredProcedure;

                    database.AddInParameter(command, "@RomanId", SqlDbType.BigInt, RomanId);
                    returndata = database.ExecuteDataSet(command);

                    return returndata;
                }
            }

            catch (Exception ex)
            {
                return null;
            }
        }

        public DataSet GetTaskMultilevelChildInfo(int TaskId)
        {
            try
            {
                SqlDatabase database = MSSQLDataBase.Instance.GetDefaultDatabase();
                {
                    returndata = new DataSet();
                    DbCommand command = database.GetStoredProcCommand("usp_GetTaskMultilevelChildInfo");
                    command.CommandType = CommandType.StoredProcedure;

                    database.AddInParameter(command, "@TaskId", DbType.Int32, TaskId);


                    returndata = database.ExecuteDataSet(command);

                    return returndata;
                }
            }

            catch (Exception ex)
            {
                return null;
            }
        }

        public DataSet GetTaskUserFileByFileName(string FileName)
        {
            try
            {
                SqlDatabase database = MSSQLDataBase.Instance.GetDefaultDatabase();
                {
                    returndata = new DataSet();
                    DbCommand command = database.GetStoredProcCommand("usp_GetTaskUserFilesByFileName");
                    command.CommandType = CommandType.StoredProcedure;

                    database.AddInParameter(command, "@FileName", DbType.String, FileName);


                    returndata = database.ExecuteDataSet(command);

                    return returndata;
                }
            }

            catch (Exception ex)
            {
                return null;
            }
        }

        public DataSet GetTaskUserFiles(Int32 TaskId, JGConstant.TaskFileDestination? objTaskFileDestination, Int32? intPageIndex, Int32? intPageSize)
        {
            try
            {
                SqlDatabase database = MSSQLDataBase.Instance.GetDefaultDatabase();
                {
                    returndata = new DataSet();
                    DbCommand command = database.GetStoredProcCommand("usp_GetTaskUserFiles");
                    command.CommandType = CommandType.StoredProcedure;

                    database.AddInParameter(command, "@TaskId", DbType.Int32, TaskId);

                    if (objTaskFileDestination.HasValue)
                    {
                        database.AddInParameter(command, "@FileDestination", DbType.Int32, Convert.ToByte(objTaskFileDestination.Value));
                    }

                    if (intPageIndex.HasValue)
                    {
                        database.AddInParameter(command, "@PageIndex", DbType.Int32, intPageIndex.Value);
                    }
                    if (intPageSize.HasValue)
                    {
                        database.AddInParameter(command, "@PageSize", DbType.Int32, intPageSize);
                    }

                    returndata = database.ExecuteDataSet(command);

                    return returndata;
                }
            }

            catch (Exception ex)
            {
                return null;
            }
        }

        public DataSet GetInstallUsers(int Key, string Designastion, string userstatus)
        {
            DataSet result = new DataSet();
            try
            {

                string[] arrDesignation = Designastion.Split(new char[] { ',' }, StringSplitOptions.RemoveEmptyEntries);

                for (int i = 0; i < arrDesignation.Length; i++)
                {
                    arrDesignation[i] = arrDesignation[i].Trim();
                }

                SqlDatabase database = MSSQLDataBase.Instance.GetDefaultDatabase();
                {
                    DbCommand command = database.GetStoredProcCommand("SP_GetInstallUsersWithStatus");
                    command.CommandType = CommandType.StoredProcedure;
                    database.AddInParameter(command, "@Key", DbType.Int16, Key); ;
                    database.AddInParameter(command, "@Designations", DbType.String, string.Join(",", arrDesignation));
                    database.AddInParameter(command, "@UserStatus", DbType.String, userstatus);
                    result = database.ExecuteDataSet(command);
                }
                return result;
            }
            catch (Exception ex)
            {
                return null;
            }

        }

        public DataSet GetInstallUsers(int Key, string Designastion)
        {
            DataSet result = new DataSet();
            try
            {

                string[] arrDesignation = Designastion.Split(new char[] { ',' }, StringSplitOptions.RemoveEmptyEntries);

                for (int i = 0; i < arrDesignation.Length; i++)
                {
                    arrDesignation[i] = arrDesignation[i].Trim();
                }

                SqlDatabase database = MSSQLDataBase.Instance.GetDefaultDatabase();
                {
                    DbCommand command = database.GetStoredProcCommand("SP_GetInstallUsers");
                    command.CommandType = CommandType.StoredProcedure;
                    database.AddInParameter(command, "@Key", DbType.Int16, Key);
                    database.AddInParameter(command, "@ActiveStatus", DbType.String, Convert.ToByte(JGConstant.InstallUserStatus.Active).ToString());
                    database.AddInParameter(command, "@InterviewDateStatus", DbType.String, Convert.ToByte(JGConstant.InstallUserStatus.InterviewDate).ToString());
                    database.AddInParameter(command, "@OfferMadeStatus", DbType.String, Convert.ToByte(JGConstant.InstallUserStatus.OfferMade).ToString());
                    database.AddInParameter(command, "@Designations", DbType.String, string.Join(",", arrDesignation));
                    result = database.ExecuteDataSet(command);
                }
                return result;
            }
            catch (Exception ex)
            {
                return null;
            }

        }

        public List<Designation> GetAllActiveDesignation()
        {
            List<Designation> designations = new List<Designation>();
            DataSet result = new DataSet();
            try
            {
                SqlDatabase database = MSSQLDataBase.Instance.GetDefaultDatabase();
                {
                    DbCommand command = database.GetStoredProcCommand("GetAllActiveDesignation");
                    command.CommandType = CommandType.StoredProcedure;
                    result = database.ExecuteDataSet(command);
                    foreach (DataRow item in result.Tables[0].Rows)
                    {
                        designations.Add(new Designation
                        {
                            DepartmentID = Convert.ToInt32(item["DepartmentID"]),
                            ID = Convert.ToInt32(item["ID"]),
                            DesignationName = item["DesignationName"].ToString(),
                            DesignationCode = item["DesignationCode"].ToString(),
                            IsActive = Convert.ToBoolean(item["IsActive"].ToString())
                        });
                    }
                }
                return designations;
            }
            catch (Exception ex)
            {
                return designations;
            }

        }

        public DataSet GetInstallUserswithIds(int Key, string Designastion, string TaskId)
        {
            DataSet result = new DataSet();
            try
            {

                string[] arrDesignation = Designastion.Split(new char[] { ',' }, StringSplitOptions.RemoveEmptyEntries);

                for (int i = 0; i < arrDesignation.Length; i++)
                {
                    arrDesignation[i] = arrDesignation[i].Trim();
                }

                SqlDatabase database = MSSQLDataBase.Instance.GetDefaultDatabase();
                {
                    DbCommand command = database.GetStoredProcCommand("SP_GetInstallUserswithId");
                    command.CommandType = CommandType.StoredProcedure;
                    database.AddInParameter(command, "@Key", DbType.Int16, Key);
                    database.AddInParameter(command, "@ActiveStatus", DbType.String, Convert.ToByte(JGConstant.InstallUserStatus.Active).ToString());
                    database.AddInParameter(command, "@InterviewDateStatus", DbType.String, Convert.ToByte(JGConstant.InstallUserStatus.InterviewDate).ToString());
                    database.AddInParameter(command, "@OfferMadeStatus", DbType.String, Convert.ToByte(JGConstant.InstallUserStatus.OfferMade).ToString());
                    database.AddInParameter(command, "@Designations", DbType.String, string.Join(",", arrDesignation));
                    database.AddInParameter(command, "@TaskId", DbType.Int32, int.Parse(TaskId));
                    result = database.ExecuteDataSet(command);
                }
                return result;
            }
            catch (Exception ex)
            {
                return null;
            }

        }

        public ActionOutput<LoginUser> GetInstallUsersByPrefix(string Prefix)
        {
            List<LoginUser> users = new List<LoginUser>();
            try
            {
                SqlDatabase database = MSSQLDataBase.Instance.GetDefaultDatabase();
                {
                    DbCommand command = database.GetStoredProcCommand("usp_GetInstallUsersByPrefix");
                    command.CommandType = CommandType.StoredProcedure;
                    database.AddInParameter(command, "@Prefix", DbType.String, Prefix);
                    returndata = database.ExecuteDataSet(command);

                    if (returndata != null && returndata.Tables[0] != null && returndata.Tables[0].Rows.Count > 0)
                    {
                        foreach (DataRow item in returndata.Tables[0].Rows)
                        {
                            users.Add(new LoginUser
                            {
                                ID = Convert.ToInt32(item["Id"].ToString()),
                                FirstName = item["Name"].ToString(),
                                Email = item["Email"].ToString(),
                            });
                        }
                    }
                    return new ActionOutput<LoginUser>
                    {
                        Results = users,
                        Status = ActionStatus.Successfull
                    };
                }

            }
            catch (Exception ex)
            {
                return null;
            }

        }

        public DataSet GetAllActiveTechTask()
        {
            DataSet result = new DataSet();
            try
            {
                SqlDatabase database = MSSQLDataBase.Instance.GetDefaultDatabase();
                {
                    DbCommand command = database.GetStoredProcCommand("SP_GetAllActiveTechTask");
                    command.CommandType = CommandType.StoredProcedure;
                    result = database.ExecuteDataSet(command);
                }
                return result;
            }
            catch (Exception ex)
            {
                return null;
            }

        }

        public DataSet GetMultilevelChildren(string ParentTaskId)
        {
            DataSet result = new DataSet();
            try
            {
                SqlDatabase database = MSSQLDataBase.Instance.GetDefaultDatabase();
                {
                    DbCommand command = database.GetStoredProcCommand("sp_GetMultiLevelList");
                    command.CommandType = CommandType.StoredProcedure;
                    database.AddInParameter(command, "@ParentTaskId", DbType.String, ParentTaskId);
                    result = database.ExecuteDataSet(command);
                }
                return result;
            }
            catch (Exception ex)
            {
                return null;
            }

        }

        public DataSet GetRootTasks(int ExcludedTaskId)
        {
            DataSet result = new DataSet();
            try
            {
                SqlDatabase database = MSSQLDataBase.Instance.GetDefaultDatabase();
                {
                    DbCommand command = database.GetStoredProcCommand("GetRootTasks");
                    command.CommandType = CommandType.StoredProcedure;
                    database.AddInParameter(command, "@TaskId", DbType.String, ExcludedTaskId);
                    result = database.ExecuteDataSet(command);
                }
                return result;
            }
            catch (Exception ex)
            {
                return null;
            }

        }

        public DataSet GetChildTasks(int ParentTaskId)
        {
            DataSet result = new DataSet();
            try
            {
                SqlDatabase database = MSSQLDataBase.Instance.GetDefaultDatabase();
                {
                    DbCommand command = database.GetStoredProcCommand("USP_GetTasksByRoot");
                    command.CommandType = CommandType.StoredProcedure;
                    database.AddInParameter(command, "@TaskId", DbType.String, ParentTaskId);
                    result = database.ExecuteDataSet(command);
                }
                return result;
            }
            catch (Exception ex)
            {
                return null;
            }

        }

        public DataSet GetTaskUserDetails(Int16 TaskID)
        {
            try
            {
                SqlDatabase database = MSSQLDataBase.Instance.GetDefaultDatabase();
                {
                    returndata = new DataSet();
                    DbCommand command = database.GetStoredProcCommand("SP_GetTaskUserDetailsByTaskId");
                    command.CommandType = CommandType.StoredProcedure;

                    database.AddInParameter(command, "@TaskId", DbType.Int16, TaskID);

                    returndata = database.ExecuteDataSet(command);

                    return returndata;
                }
            }

            catch (Exception ex)
            {
                return null;
            }
        }

        public DataSet GetAllActiveTechTaskForDesignationID(int iDesignationID)
        {
            DataSet result = new DataSet();
            try
            {
                SqlDatabase database = MSSQLDataBase.Instance.GetDefaultDatabase();
                {
                    DbCommand command = database.GetStoredProcCommand("UDP_GetAllActiveTechTaskForDesignationID");
                    command.CommandType = CommandType.StoredProcedure;
                    database.AddInParameter(command, "@DesignationID", DbType.Int32, iDesignationID);
                    result = database.ExecuteDataSet(command);
                }
                return result;
            }
            catch (Exception ex)
            {
                return null;
            }

        }


        /// <summary>
        /// to GetUserDetails by Id
        /// </summary>
        /// <param name="Id"></param>
        /// <returns></returns>
        public DataSet GetUserDetails(Int32 Id)
        {
            DataSet result = new DataSet();
            try
            {
                SqlDatabase database = MSSQLDataBase.Instance.GetDefaultDatabase();
                {
                    DbCommand command = database.GetStoredProcCommand("usp_GetUserDetails");
                    command.CommandType = CommandType.StoredProcedure;
                    database.AddInParameter(command, "@Id", DbType.Int16, Id);
                    result = database.ExecuteDataSet(command);
                }
                return result;
            }
            catch (Exception ex)
            {
                return null;
            }
        }

        /// <summary>
        /// to GetInstallUserDetails by Id
        /// </summary>
        /// <param name="Id"></param>
        /// <returns></returns>
        public DataSet GetInstallUserDetails(Int32 Id)
        {
            DataSet result = new DataSet();
            try
            {
                SqlDatabase database = MSSQLDataBase.Instance.GetDefaultDatabase();
                {
                    DbCommand command = database.GetStoredProcCommand("usp_GetInstallUserDetails");
                    command.CommandType = CommandType.StoredProcedure;
                    database.AddInParameter(command, "@Id", DbType.Int16, Id);
                    result = database.ExecuteDataSet(command);
                }
                return result;
            }
            catch (Exception ex)
            {
                return null;
            }
        }

        /// <summary>
        /// to GetInstallUserDetails by Id
        /// </summary>
        /// <param name="Id"></param>
        /// <returns></returns>
        public DataTable GetTaskDetailsForMail(int TaskId)
        {
            DataTable result = new DataTable();
            try
            {
                SqlDatabase database = MSSQLDataBase.Instance.GetDefaultDatabase();
                {
                    DbCommand command = database.GetStoredProcCommand("sp_GetTaskDetailsForMail");
                    command.CommandType = CommandType.StoredProcedure;
                    database.AddInParameter(command, "@TaskId", DbType.Int16, TaskId);
                    result = (database.ExecuteDataSet(command)).Tables[0];
                }
                return result;
            }
            catch (Exception ex)
            {
                return null;
            }
        }

        /// <summary>
        /// Load auto search suggestion as user types in search box for task generator.
        /// </summary>
        /// <param name="searchTerm"></param>
        /// <returns> categorised search suggestions for Users, Designations, Task Title, Task Ids </returns>
        public DataSet GetTaskSearchAutoSuggestion(String searchTerm)
        {
            DataSet result = new DataSet();
            try
            {
                SqlDatabase database = MSSQLDataBase.Instance.GetDefaultDatabase();
                {
                    DbCommand command = database.GetStoredProcCommand("usp_LoadSearchTaskAutoSuggestion");
                    command.CommandType = CommandType.StoredProcedure;
                    database.AddInParameter(command, "@SearchTerm", DbType.String, searchTerm);
                    result = database.ExecuteDataSet(command);
                }
                return result;
            }
            catch (Exception ex)
            {
                return null;
            }
        }

        /// <summary>
        /// Will fetch task lists based on various filter parameters provided.
        /// </summary>
        /// <param name="UserID"></param>
        /// <param name="Title"></param>
        /// <param name="Designation"></param>
        /// <param name="Status"></param>
        /// <param name="CreatedOn"></param>
        /// <param name="Start"></param>
        /// <param name="PageLimit"></param>
        /// <returns></returns>
        public DataSet GetTasksList(int? UserID, string Title, string Designation, Int16? Status, DateTime? CreatedFrom, DateTime? CreatedTo, string Statuses, string Designations, bool isAdmin, int Start, int PageLimit, string strSortExpression)
        {
            returndata = new DataSet();

            try
            {
                SqlDatabase database = MSSQLDataBase.Instance.GetDefaultDatabase();
                {
                    DbCommand command = database.GetStoredProcCommand("uspSearchTasks");

                    if (!String.IsNullOrEmpty(Designations))
                    {
                        database.AddInParameter(command, "@Designations", DbType.String, Designation);
                    }
                    else
                    {
                        database.AddInParameter(command, "@Designations", DbType.String, DBNull.Value);
                    }

                    if (UserID.HasValue)
                    {
                        database.AddInParameter(command, "@UserId", DbType.Int32, UserID.Value);
                    }
                    else
                    {
                        database.AddInParameter(command, "@UserId", DbType.Int32, DBNull.Value);
                    }

                    if (Status.HasValue)
                    {
                        database.AddInParameter(command, "@Status", DbType.Int16, Status.Value);
                    }
                    else
                    {
                        database.AddInParameter(command, "@Status", DbType.Int16, DBNull.Value);
                    }

                    if (CreatedFrom.HasValue)
                    {
                        database.AddInParameter(command, "@CreatedFrom", DbType.DateTime, CreatedFrom.Value);
                    }
                    else
                    {
                        database.AddInParameter(command, "@CreatedFrom", DbType.DateTime, DBNull.Value);
                    }

                    if (CreatedTo.HasValue)
                    {
                        database.AddInParameter(command, "@CreatedTo", DbType.DateTime, CreatedTo.Value);
                    }
                    else
                    {
                        database.AddInParameter(command, "@CreatedTo", DbType.DateTime, DBNull.Value);
                    }

                    if (!String.IsNullOrEmpty(Title))
                    {
                        database.AddInParameter(command, "@SearchTerm", DbType.String, Title);
                    }
                    else
                    {
                        database.AddInParameter(command, "@SearchTerm", DbType.String, DBNull.Value);
                    }

                    //database.AddInParameter(command, "@ExcludeStatus", DbType.Int16, Convert.ToInt16(JG_Prospect.Common.JGConstant.TaskStatus.SpecsInProgress));
                    database.AddInParameter(command, "@ExcludeStatus", DbType.Int16, DBNull.Value);

                    database.AddInParameter(command, "@Admin", DbType.Boolean, isAdmin);

                    database.AddInParameter(command, "@PageIndex", DbType.Int32, Start);
                    database.AddInParameter(command, "@PageSize", DbType.Int32, PageLimit);
                    database.AddInParameter(command, "@SortExpression", DbType.String, strSortExpression);

                    database.AddInParameter(command, "@OpenStatus", SqlDbType.SmallInt, (byte)Common.JGConstant.TaskStatus.Open);
                    database.AddInParameter(command, "@RequestedStatus", SqlDbType.SmallInt, (byte)Common.JGConstant.TaskStatus.Requested);
                    database.AddInParameter(command, "@AssignedStatus", SqlDbType.SmallInt, (byte)Common.JGConstant.TaskStatus.Assigned);
                    database.AddInParameter(command, "@InProgressStatus", SqlDbType.SmallInt, (byte)Common.JGConstant.TaskStatus.InProgress);
                    database.AddInParameter(command, "@PendingStatus", SqlDbType.SmallInt, (byte)Common.JGConstant.TaskStatus.Pending);
                    database.AddInParameter(command, "@ReOpenedStatus", SqlDbType.SmallInt, (byte)Common.JGConstant.TaskStatus.ReOpened);
                    database.AddInParameter(command, "@ClosedStatus", SqlDbType.SmallInt, (byte)Common.JGConstant.TaskStatus.Closed);
                    database.AddInParameter(command, "@SpecsInProgressStatus", SqlDbType.SmallInt, (byte)Common.JGConstant.TaskStatus.SpecsInProgress);
                    database.AddInParameter(command, "@DeletedStatus", SqlDbType.SmallInt, (byte)Common.JGConstant.TaskStatus.Deleted);

                    command.CommandType = CommandType.StoredProcedure;
                    returndata = database.ExecuteDataSet(command);
                    return returndata;
                }
            }

            catch (Exception ex)
            {
                //LogManager.Instance.WriteToFlatFile(ex);
            }
            return returndata;
        }

        /// <summary>
        /// Get one or all tasks with all sub tasks from all levels.
        /// </summary>
        /// <param name="intTaskID">optional taskid to get hierarchy. if it is null, all tasks will be returned in response.</param>
        /// <returns></returns>
        public DataSet GetTaskHierarchy(long? intTaskID, bool isAdmin)
        {
            try
            {
                SqlDatabase database = MSSQLDataBase.Instance.GetDefaultDatabase();
                {
                    returndata = new DataSet();
                    DbCommand command = database.GetStoredProcCommand("GetTaskHierarchy");
                    command.CommandType = CommandType.StoredProcedure;

                    if (intTaskID.HasValue)
                    {
                        database.AddInParameter(command, "@TaskId", DbType.Int64, intTaskID);
                    }

                    database.AddInParameter(command, "@Admin", DbType.Boolean, isAdmin);

                    return database.ExecuteDataSet(command);
                }
            }
            catch (Exception)
            {
                return null;
            }
        }

        /// <summary>


        /// <summary>
        /// Get all Users and their designtions in system for whom tasks are available in system.
        /// <returns></returns>
        public DataSet GetAllUsersNDesignationsForFilter()
        {
            returndata = new DataSet();

            try
            {
                SqlDatabase database = MSSQLDataBase.Instance.GetDefaultDatabase();
                {
                    DbCommand command = database.GetStoredProcCommand("usp_GetUsersNDesignationForTaskFilter");

                    command.CommandType = CommandType.StoredProcedure;
                    returndata = database.ExecuteDataSet(command);
                    return returndata;
                }
            }

            catch (Exception ex)
            {
                //LogManager.Instance.WriteToFlatFile(ex);
            }
            return returndata;
        }

        public bool UpadateTaskNotes(ref TaskUser objTaskUser)
        {
            try
            {
                SqlDatabase database = MSSQLDataBase.Instance.GetDefaultDatabase();
                {
                    DbCommand command = database.GetStoredProcCommand("usp_UpadateTaskNotes");

                    command.CommandType = CommandType.StoredProcedure;
                    database.AddInParameter(command, "@Id", DbType.Int64, objTaskUser.Id);
                    database.AddInParameter(command, "@Notes", DbType.String, objTaskUser.Notes);


                    int result = database.ExecuteNonQuery(command);


                    if (result > 0)
                    {
                        return true;
                    }
                    else
                    {
                        return false;
                    }

                }
            }

            catch (Exception ex)
            {
                return false;
            }

        }

        public bool UpdateTaskUiRequested(Int64 intTaskId, bool blUiRequesed)
        {
            try
            {
                SqlDatabase database = MSSQLDataBase.Instance.GetDefaultDatabase();
                {
                    returndata = new DataSet();
                    DbCommand command = database.GetStoredProcCommand("UpdateTaskUiRequestedById");
                    command.CommandType = CommandType.StoredProcedure;

                    database.AddInParameter(command, "@TaskId", DbType.Int64, intTaskId);
                    database.AddInParameter(command, "@IsUiRequested", DbType.Boolean, blUiRequesed);

                    database.ExecuteNonQuery(command);
                }

                return true;
            }
            catch (Exception ex)
            {
                return false;
            }
        }

        public bool UpdateTaskTechTask(Int64 intTaskId, bool blTechTask)
        {
            try
            {
                SqlDatabase database = MSSQLDataBase.Instance.GetDefaultDatabase();
                {
                    returndata = new DataSet();
                    DbCommand command = database.GetStoredProcCommand("UpdateTaskTechTaskById");
                    command.CommandType = CommandType.StoredProcedure;

                    database.AddInParameter(command, "@TaskId", DbType.Int64, intTaskId);
                    database.AddInParameter(command, "@IsTechTask", DbType.Boolean, blTechTask);

                    database.ExecuteNonQuery(command);
                }

                return true;
            }
            catch (Exception ex)
            {
                return false;
            }
        }

        public bool UpdateTaskReassignable(Int64 intTaskId, bool blIsReassignable)
        {
            try
            {
                SqlDatabase database = MSSQLDataBase.Instance.GetDefaultDatabase();
                {
                    returndata = new DataSet();
                    DbCommand command = database.GetStoredProcCommand("usp_UpdateTaskReassignableStatus");
                    command.CommandType = CommandType.StoredProcedure;

                    database.AddInParameter(command, "@TaskId", DbType.Int64, intTaskId);
                    database.AddInParameter(command, "@IsReassignable", DbType.Boolean, blIsReassignable);

                    database.ExecuteNonQuery(command);
                }

                return true;
            }
            catch (Exception ex)
            {
                return false;
            }
        }

        #region TaskWorkSpecification

        public int InsertTaskWorkSpecification(TaskWorkSpecification objTaskWorkSpecification)
        {
            try
            {
                SqlDatabase database = MSSQLDataBase.Instance.GetDefaultDatabase();
                {
                    DbCommand command = database.GetStoredProcCommand("InsertTaskWorkSpecification");

                    command.CommandType = CommandType.StoredProcedure;
                    database.AddInParameter(command, "@CustomId", DbType.String, objTaskWorkSpecification.CustomId);
                    database.AddInParameter(command, "@TaskId", DbType.Int64, objTaskWorkSpecification.TaskId);
                    database.AddInParameter(command, "@Description", DbType.String, objTaskWorkSpecification.Description);
                    database.AddInParameter(command, "@Title", DbType.String, objTaskWorkSpecification.Title);
                    database.AddInParameter(command, "@URL", DbType.String, objTaskWorkSpecification.URL);

                    database.AddInParameter(command, "@AdminStatus", DbType.Boolean, objTaskWorkSpecification.AdminStatus);
                    database.AddInParameter(command, "@AdminUserId", DbType.Int32, objTaskWorkSpecification.AdminUserId);
                    database.AddInParameter(command, "@IsAdminInstallUser", DbType.Boolean, objTaskWorkSpecification.IsAdminInstallUser);

                    database.AddInParameter(command, "@TechLeadStatus", DbType.Boolean, objTaskWorkSpecification.TechLeadStatus);
                    database.AddInParameter(command, "@TechLeadUserId", DbType.Int32, objTaskWorkSpecification.TechLeadUserId);
                    database.AddInParameter(command, "@IsTechLeadInstallUser", DbType.Boolean, objTaskWorkSpecification.IsTechLeadInstallUser);

                    database.AddInParameter(command, "@OtherUserStatus", DbType.Boolean, objTaskWorkSpecification.OtherUserStatus);
                    database.AddInParameter(command, "@OtherUserId", DbType.Int32, objTaskWorkSpecification.OtherUserId);
                    database.AddInParameter(command, "@IsOtherUserInstallUser", DbType.Boolean, objTaskWorkSpecification.IsOtherUserInstallUser);

                    if (objTaskWorkSpecification.ParentTaskWorkSpecificationId.HasValue)
                    {
                        database.AddInParameter(command, "@ParentTaskWorkSpecificationId", SqlDbType.BigInt, objTaskWorkSpecification.ParentTaskWorkSpecificationId.Value);
                    }

                    return database.ExecuteNonQuery(command);
                }
            }
            catch
            {
                return -1;
            }
        }

        public int UpdateTaskWorkSpecification(TaskWorkSpecification objTaskWorkSpecification)
        {
            try
            {
                SqlDatabase database = MSSQLDataBase.Instance.GetDefaultDatabase();
                {
                    DbCommand command = database.GetStoredProcCommand("UpdateTaskWorkSpecification");

                    command.CommandType = CommandType.StoredProcedure;

                    database.AddInParameter(command, "@Id", DbType.Int64, objTaskWorkSpecification.Id);
                    database.AddInParameter(command, "@CustomId", DbType.String, objTaskWorkSpecification.CustomId);
                    database.AddInParameter(command, "@TaskId", DbType.Int64, objTaskWorkSpecification.TaskId);
                    database.AddInParameter(command, "@Description", DbType.String, objTaskWorkSpecification.Description);
                    database.AddInParameter(command, "@Title", DbType.String, objTaskWorkSpecification.Title);
                    database.AddInParameter(command, "@URL", DbType.String, objTaskWorkSpecification.URL);

                    if (objTaskWorkSpecification.ParentTaskWorkSpecificationId.HasValue)
                    {
                        database.AddInParameter(command, "@ParentTaskWorkSpecificationId", SqlDbType.BigInt, objTaskWorkSpecification.ParentTaskWorkSpecificationId.Value);
                    }

                    return database.ExecuteNonQuery(command);
                }
            }
            catch
            {
                return -1;
            }
        }

        public int UpdateTaskTitleById(string tid, string title)
        {
            try
            {
                SqlDatabase database = MSSQLDataBase.Instance.GetDefaultDatabase();
                {
                    DbCommand command = database.GetStoredProcCommand("UpdateTaskTitleById");

                    command.CommandType = CommandType.StoredProcedure;

                    database.AddInParameter(command, "@TaskId", DbType.Int64, tid);
                    database.AddInParameter(command, "@Title", DbType.String, title);

                    return database.ExecuteNonQuery(command);
                }
            }
            catch
            {
                return -1;
            }
        }

        public int UpdateTaskURLById(string tid, string URL)
        {
            try
            {
                SqlDatabase database = MSSQLDataBase.Instance.GetDefaultDatabase();
                {
                    DbCommand command = database.GetStoredProcCommand("UpdateTaskURLById");

                    command.CommandType = CommandType.StoredProcedure;

                    database.AddInParameter(command, "@TaskId", DbType.Int64, tid);
                    database.AddInParameter(command, "@URL", DbType.String, URL);

                    return database.ExecuteNonQuery(command);
                }
            }
            catch
            {
                return -1;
            }
        }
        public int UpdateTaskDescriptionChildById(string tid, string Description)
        {
            try
            {
                SqlDatabase database = MSSQLDataBase.Instance.GetDefaultDatabase();
                {
                    DbCommand command = database.GetStoredProcCommand("UpdateTaskDescriptionChildById");

                    command.CommandType = CommandType.StoredProcedure;

                    database.AddInParameter(command, "@TaskId", DbType.Int64, tid);
                    database.AddInParameter(command, "@Description", DbType.String, Description);

                    return database.ExecuteNonQuery(command);
                }
            }
            catch
            {
                return -1;
            }
        }

        public int UpdateRomanTitle(string RomanId, string Title)
        {
            try
            {
                SqlDatabase database = MSSQLDataBase.Instance.GetDefaultDatabase();
                {
                    DbCommand command = database.GetStoredProcCommand("UpdateRomanTitle");

                    command.CommandType = CommandType.StoredProcedure;

                    database.AddInParameter(command, "@RomanId", DbType.Int64, RomanId);
                    database.AddInParameter(command, "@Title", DbType.String, Title);

                    return database.ExecuteNonQuery(command);
                }
            }
            catch
            {
                return -1;
            }
        }

        public int UpdateTaskDescriptionById(string tid, string Description)
        {
            try
            {
                SqlDatabase database = MSSQLDataBase.Instance.GetDefaultDatabase();
                {
                    DbCommand command = database.GetStoredProcCommand("UpdateTaskDescriptionById");

                    command.CommandType = CommandType.StoredProcedure;

                    database.AddInParameter(command, "@TaskId", DbType.Int64, tid);
                    database.AddInParameter(command, "@Description", DbType.String, Description);

                    return database.ExecuteNonQuery(command);
                }
            }
            catch
            {
                return -1;
            }
        }
        public int DeleteTaskWorkSpecification(long intTaskWorkSpecification)
        {
            try
            {
                SqlDatabase database = MSSQLDataBase.Instance.GetDefaultDatabase();
                {
                    DbCommand command = database.GetStoredProcCommand("DeleteTaskWorkSpecification");

                    command.CommandType = CommandType.StoredProcedure;

                    database.AddInParameter(command, "@Id", DbType.Int64, intTaskWorkSpecification);

                    return database.ExecuteNonQuery(command);
                }
            }
            catch
            {
                return -1;
            }
        }

        public DataSet GetTaskWorkSpecifications(Int32 TaskId, bool blIsAdmin, Int64? intParentTaskWorkSpecificationId, Int32? intPageIndex, Int32? intPageSize)
        {
            try
            {
                SqlDatabase database = MSSQLDataBase.Instance.GetDefaultDatabase();
                {
                    DbCommand command = database.GetStoredProcCommand("GetTaskWorkSpecifications");
                    command.CommandType = CommandType.StoredProcedure;

                    database.AddInParameter(command, "@TaskId", DbType.Int32, TaskId);
                    database.AddInParameter(command, "@Admin", DbType.Boolean, blIsAdmin);

                    if (intParentTaskWorkSpecificationId.HasValue)
                    {
                        database.AddInParameter(command, "@ParentTaskWorkSpecificationId", DbType.Int64, intParentTaskWorkSpecificationId.Value);
                    }

                    if (intPageIndex.HasValue)
                    {
                        database.AddInParameter(command, "@PageIndex", DbType.Int32, intPageIndex.Value);
                    }
                    if (intPageSize.HasValue)
                    {
                        database.AddInParameter(command, "@PageSize", DbType.Int32, intPageSize);
                    }

                    return database.ExecuteDataSet(command);
                }
            }
            catch
            {
                return null;
            }
        }

        public TaskWorkSpecification GetTaskWorkSpecificationById(Int64 Id)
        {
            TaskWorkSpecification objTaskWorkSpecification = null;

            try
            {
                SqlDatabase database = MSSQLDataBase.Instance.GetDefaultDatabase();
                {
                    DbCommand command = database.GetStoredProcCommand("GetTaskWorkSpecificationById");
                    command.CommandType = CommandType.StoredProcedure;

                    database.AddInParameter(command, "@Id", DbType.Int64, Id);

                    DataSet dsTaskWorkSpecification = database.ExecuteDataSet(command);

                    if (
                        dsTaskWorkSpecification != null &&
                        dsTaskWorkSpecification.Tables.Count > 0 &&
                        dsTaskWorkSpecification.Tables[0].Rows.Count > 0
                       )
                    {
                        objTaskWorkSpecification = GetTaskWorkSpecification(dsTaskWorkSpecification.Tables[0].Rows[0]);
                    }

                    return objTaskWorkSpecification;
                }
            }
            catch
            {
                return objTaskWorkSpecification;
            }
        }

        public int UpdateTaskWorkSpecificationStatusByTaskId(TaskWorkSpecification objTaskWorkSpecification, bool blIsAdmin, bool blIsTechLead, bool blIsUser)
        {
            try
            {
                SqlDatabase database = MSSQLDataBase.Instance.GetDefaultDatabase();
                {
                    DbCommand command = database.GetStoredProcCommand("UpdateTaskWorkSpecificationStatusByTaskId");

                    command.CommandType = CommandType.StoredProcedure;

                    database.AddInParameter(command, "@TaskId", DbType.Int64, objTaskWorkSpecification.TaskId);
                    if (blIsAdmin)
                    {
                        database.AddInParameter(command, "@AdminStatus", DbType.Boolean, objTaskWorkSpecification.AdminStatus);
                        database.AddInParameter(command, "@UserId", DbType.Int32, objTaskWorkSpecification.AdminUserId);
                        database.AddInParameter(command, "@IsInstallUser", DbType.Boolean, objTaskWorkSpecification.IsAdminInstallUser);
                    }
                    else if (blIsTechLead)
                    {
                        database.AddInParameter(command, "@TechLeadStatus", DbType.Boolean, objTaskWorkSpecification.TechLeadStatus);
                        database.AddInParameter(command, "@UserId", DbType.Int32, objTaskWorkSpecification.TechLeadUserId);
                        database.AddInParameter(command, "@IsInstallUser", DbType.Boolean, objTaskWorkSpecification.IsTechLeadInstallUser);
                    }
                    else if (blIsUser)
                    {
                        database.AddInParameter(command, "@OtherUserStatus", DbType.Boolean, objTaskWorkSpecification.OtherUserStatus);
                        database.AddInParameter(command, "@UserId", DbType.Int32, objTaskWorkSpecification.OtherUserId);
                        database.AddInParameter(command, "@IsInstallUser", DbType.Boolean, objTaskWorkSpecification.IsOtherUserInstallUser);
                    }

                    return database.ExecuteNonQuery(command);
                }
            }
            catch
            {
                return -1;
            }
        }

        public int UpdateTaskWorkSpecificationStatusById(TaskWorkSpecification objTaskWorkSpecification, bool blIsAdmin, bool blIsTechLead, bool blIsUser)
        {
            try
            {
                SqlDatabase database = MSSQLDataBase.Instance.GetDefaultDatabase();
                {
                    DbCommand command = database.GetStoredProcCommand("UpdateTaskWorkSpecificationStatusById");

                    command.CommandType = CommandType.StoredProcedure;

                    database.AddInParameter(command, "@Id", DbType.Int64, objTaskWorkSpecification.Id);
                    if (blIsAdmin)
                    {
                        database.AddInParameter(command, "@AdminStatus", DbType.Boolean, objTaskWorkSpecification.AdminStatus);
                        database.AddInParameter(command, "@UserId", DbType.Int32, objTaskWorkSpecification.AdminUserId);
                        database.AddInParameter(command, "@IsInstallUser", DbType.Boolean, objTaskWorkSpecification.IsAdminInstallUser);
                    }
                    else if (blIsTechLead)
                    {
                        database.AddInParameter(command, "@TechLeadStatus", DbType.Boolean, objTaskWorkSpecification.TechLeadStatus);
                        database.AddInParameter(command, "@UserId", DbType.Int32, objTaskWorkSpecification.TechLeadUserId);
                        database.AddInParameter(command, "@IsInstallUser", DbType.Boolean, objTaskWorkSpecification.IsTechLeadInstallUser);
                    }
                    else if (blIsUser)
                    {
                        database.AddInParameter(command, "@OtherUserStatus", DbType.Boolean, objTaskWorkSpecification.OtherUserStatus);
                        database.AddInParameter(command, "@UserId", DbType.Int32, objTaskWorkSpecification.OtherUserId);
                        database.AddInParameter(command, "@IsInstallUser", DbType.Boolean, objTaskWorkSpecification.IsOtherUserInstallUser);
                    }

                    return database.ExecuteNonQuery(command);
                }
            }
            catch
            {
                return -1;
            }
        }

        public DataSet GetPendingTaskWorkSpecificationCount(Int32 TaskId)
        {
            try
            {
                SqlDatabase database = MSSQLDataBase.Instance.GetDefaultDatabase();
                {
                    returndata = new DataSet();
                    DbCommand command = database.GetStoredProcCommand("GetPendingTaskWorkSpecificationCount");
                    command.CommandType = CommandType.StoredProcedure;

                    database.AddInParameter(command, "@TaskId", DbType.Int32, TaskId);
                    return database.ExecuteDataSet(command);
                }
            }
            catch (Exception ex)
            {
                return null;
            }
        }

        /// <summary>
        /// Get a TaskWorkSpecification object based on values in DataRow.
        /// </summary>
        /// <param name="drTaskWorkSpecification">possible DataRow containing TaskWorkSpecification data.</param>
        /// <returns></returns>
        private TaskWorkSpecification GetTaskWorkSpecification(DataRow drTaskWorkSpecification)
        {
            TaskWorkSpecification objTaskWorkSpecification = new TaskWorkSpecification();

            #region Prepare TaskWorkSpecification Object

            objTaskWorkSpecification.Id = Convert.ToInt64(drTaskWorkSpecification["Id"]);
            objTaskWorkSpecification.CustomId = Convert.ToString(drTaskWorkSpecification["CustomId"]);
            objTaskWorkSpecification.TaskId = Convert.ToInt64(drTaskWorkSpecification["TaskId"]);
            objTaskWorkSpecification.Description = Convert.ToString(drTaskWorkSpecification["Description"]);
            objTaskWorkSpecification.Title = Convert.ToString(drTaskWorkSpecification["Title"]);
            objTaskWorkSpecification.URL = Convert.ToString(drTaskWorkSpecification["URL"]);

            if (!string.IsNullOrEmpty(Convert.ToString(drTaskWorkSpecification["AdminUserId"])))
            {
                objTaskWorkSpecification.AdminUserId = Convert.ToInt32(drTaskWorkSpecification["AdminUserId"]);
                objTaskWorkSpecification.IsAdminInstallUser = Convert.ToBoolean(drTaskWorkSpecification["IsAdminInstallUser"]);
                objTaskWorkSpecification.AdminUsername = Convert.ToString(drTaskWorkSpecification["AdminUsername"]);
                objTaskWorkSpecification.AdminUserFirstname = Convert.ToString(drTaskWorkSpecification["AdminUserFirstName"]);
                objTaskWorkSpecification.AdminUserLastname = Convert.ToString(drTaskWorkSpecification["AdminUserLastName"]);
                objTaskWorkSpecification.AdminUserEmail = Convert.ToString(drTaskWorkSpecification["AdminUserEmail"]);
            }

            if (!string.IsNullOrEmpty(Convert.ToString(drTaskWorkSpecification["TechLeadUserId"])))
            {
                objTaskWorkSpecification.AdminUserId = Convert.ToInt32(drTaskWorkSpecification["TechLeadUserId"]);
                objTaskWorkSpecification.IsAdminInstallUser = Convert.ToBoolean(drTaskWorkSpecification["IsTechLeadInstallUser"]);
                objTaskWorkSpecification.TechLeadUsername = Convert.ToString(drTaskWorkSpecification["TechLeadUsername"]);
                objTaskWorkSpecification.TechLeadUserFirstname = Convert.ToString(drTaskWorkSpecification["TechLeadUserFirstName"]);
                objTaskWorkSpecification.TechLeadUserLastname = Convert.ToString(drTaskWorkSpecification["TechLeadUserLastName"]);
                objTaskWorkSpecification.TechLeadUserEmail = Convert.ToString(drTaskWorkSpecification["TechLeadUserEmail"]);
            }

            if (!string.IsNullOrEmpty(Convert.ToString(drTaskWorkSpecification["OtherUserId"])))
            {
                objTaskWorkSpecification.OtherUserId = Convert.ToInt32(drTaskWorkSpecification["OtherUserId"]);
                objTaskWorkSpecification.IsOtherUserInstallUser = Convert.ToBoolean(drTaskWorkSpecification["IsOtherUserInstallUser"]);
                objTaskWorkSpecification.OtherUsername = Convert.ToString(drTaskWorkSpecification["OtherUsername"]);
                objTaskWorkSpecification.OtherUserFirstname = Convert.ToString(drTaskWorkSpecification["OtherUserFirstName"]);
                objTaskWorkSpecification.OtherUserLastname = Convert.ToString(drTaskWorkSpecification["OtherUserLastName"]);
                objTaskWorkSpecification.OtherUserEmail = Convert.ToString(drTaskWorkSpecification["OtherUserEmail"]);
            }

            objTaskWorkSpecification.AdminStatus = Convert.ToBoolean(drTaskWorkSpecification["AdminStatus"]);
            objTaskWorkSpecification.TechLeadStatus = Convert.ToBoolean(drTaskWorkSpecification["TechLeadStatus"]);
            objTaskWorkSpecification.OtherUserStatus = Convert.ToBoolean(drTaskWorkSpecification["OtherUserStatus"]);
            objTaskWorkSpecification.DateCreated = Convert.ToDateTime(drTaskWorkSpecification["DateCreated"]);
            objTaskWorkSpecification.DateUpdated = Convert.ToDateTime(drTaskWorkSpecification["DateUpdated"]);

            #endregion

            return objTaskWorkSpecification;
        }


        #endregion

        public int UpdateSubTaskStatusById(Task objTask, bool blIsAdmin, bool blIsTechLead, bool blIsUser)
        {
            try
            {
                SqlDatabase database = MSSQLDataBase.Instance.GetDefaultDatabase();
                {
                    DbCommand command = database.GetStoredProcCommand("UpdateSubTaskStatusById");

                    command.CommandType = CommandType.StoredProcedure;

                    database.AddInParameter(command, "@TaskId", DbType.Int64, objTask.TaskId);
                    if (blIsAdmin)
                    {
                        database.AddInParameter(command, "@AdminStatus", DbType.Boolean, objTask.AdminStatus);
                        database.AddInParameter(command, "@UserId", DbType.Int32, objTask.AdminUserId);
                        database.AddInParameter(command, "@IsInstallUser", DbType.Boolean, objTask.IsAdminInstallUser);
                    }
                    else if (blIsTechLead)
                    {
                        database.AddInParameter(command, "@TechLeadStatus", DbType.Boolean, objTask.TechLeadStatus);
                        database.AddInParameter(command, "@UserId", DbType.Int32, objTask.TechLeadUserId);
                        database.AddInParameter(command, "@IsInstallUser", DbType.Boolean, objTask.IsTechLeadInstallUser);
                    }
                    else if (blIsUser)
                    {
                        database.AddInParameter(command, "@OtherUserStatus", DbType.Boolean, objTask.OtherUserStatus);
                        database.AddInParameter(command, "@UserId", DbType.Int32, objTask.OtherUserId);
                        database.AddInParameter(command, "@IsInstallUser", DbType.Boolean, objTask.IsOtherUserInstallUser);
                    }

                    return database.ExecuteNonQuery(command);
                }
            }
            catch
            {
                return -1;
            }
        }

        public DataSet GetPendingSubTaskCount(Int32 TaskId)
        {
            try
            {
                SqlDatabase database = MSSQLDataBase.Instance.GetDefaultDatabase();
                {
                    returndata = new DataSet();
                    DbCommand command = database.GetStoredProcCommand("GetPendingSubTaskCount");
                    command.CommandType = CommandType.StoredProcedure;

                    database.AddInParameter(command, "@TaskId", DbType.Int32, TaskId);
                    return database.ExecuteDataSet(command);
                }
            }
            catch (Exception ex)
            {
                return null;
            }
        }

        #region TaskAcceptance

        public DataSet GetTaskAcceptances(Int64 TaskId)
        {
            try
            {
                SqlDatabase database = MSSQLDataBase.Instance.GetDefaultDatabase();
                {
                    returndata = new DataSet();
                    DbCommand command = database.GetStoredProcCommand("GetTaskAcceptances");
                    command.CommandType = CommandType.StoredProcedure;

                    database.AddInParameter(command, "@TaskId", DbType.Int64, TaskId);
                    return database.ExecuteDataSet(command);
                }
            }
            catch (Exception ex)
            {
                return null;
            }
        }

        public int InsertTaskAcceptance(TaskAcceptance objTaskAcceptance)
        {
            try
            {
                SqlDatabase database = MSSQLDataBase.Instance.GetDefaultDatabase();
                {
                    DbCommand command = database.GetStoredProcCommand("InsertTaskAcceptance");

                    command.CommandType = CommandType.StoredProcedure;
                    database.AddInParameter(command, "@TaskId", DbType.Int64, objTaskAcceptance.TaskId);
                    database.AddInParameter(command, "@UserId", DbType.Int64, objTaskAcceptance.UserId);
                    database.AddInParameter(command, "@IsInstallUser", DbType.Boolean, objTaskAcceptance.IsInstallUser);
                    database.AddInParameter(command, "@IsAccepted", DbType.Boolean, objTaskAcceptance.IsAccepted);

                    return database.ExecuteNonQuery(command);
                }
            }
            catch
            {
                return -1;
            }
        }

        #endregion

        #region TaskApprovals

        public int InsertTaskApproval(TaskApproval objTaskApproval)
        {
            try
            {
                SqlDatabase database = MSSQLDataBase.Instance.GetDefaultDatabase();
                {
                    DbCommand command = database.GetStoredProcCommand("InsertTaskApproval");

                    command.CommandType = CommandType.StoredProcedure;
                    database.AddInParameter(command, "@TaskId", DbType.Int64, objTaskApproval.TaskId);
                    database.AddInParameter(command, "@EstimatedHours", DbType.String, objTaskApproval.EstimatedHours);
                    database.AddInParameter(command, "@Description", DbType.String, objTaskApproval.Description);
                    database.AddInParameter(command, "@UserId", DbType.Int32, objTaskApproval.UserId);
                    database.AddInParameter(command, "@IsInstallUser", DbType.Boolean, objTaskApproval.IsInstallUser);

                    return database.ExecuteNonQuery(command);
                }
            }
            catch
            {
                return -1;
            }
        }

        public int UpdateTaskApproval(TaskApproval objTaskApproval)
        {
            try
            {
                SqlDatabase database = MSSQLDataBase.Instance.GetDefaultDatabase();
                {
                    DbCommand command = database.GetStoredProcCommand("UpdateTaskApproval");

                    command.CommandType = CommandType.StoredProcedure;

                    database.AddInParameter(command, "@Id", DbType.Int64, objTaskApproval.Id);
                    database.AddInParameter(command, "@TaskId", DbType.Int64, objTaskApproval.TaskId);
                    database.AddInParameter(command, "@EstimatedHours", DbType.String, objTaskApproval.EstimatedHours);
                    database.AddInParameter(command, "@Description", DbType.String, objTaskApproval.Description);
                    database.AddInParameter(command, "@UserId", DbType.Int32, objTaskApproval.UserId);
                    database.AddInParameter(command, "@IsInstallUser", DbType.Boolean, objTaskApproval.IsInstallUser);

                    return database.ExecuteNonQuery(command);
                }
            }
            catch
            {
                return -1;
            }
        }

        public bool UpdateFeedbackTask(int EstimatedHours, string Password, string StartDate, string EndDate, int TaskId, bool IsITLead, int UserId)
        {
            try
            {
                SqlDatabase database = MSSQLDataBase.Instance.GetDefaultDatabase();
                {
                    DbCommand command = database.GetStoredProcCommand("usp_FreezeFeedbackTask");

                    command.CommandType = CommandType.StoredProcedure;

                    database.AddInParameter(command, "@TaskId", DbType.Int32, TaskId);
                    database.AddInParameter(command, "@EstimatedHours", DbType.Int32, EstimatedHours);
                    database.AddInParameter(command, "@StartDate", DbType.String, StartDate);
                    database.AddInParameter(command, "@EndDate", DbType.String, EndDate);
                    database.AddInParameter(command, "@IsITLead", DbType.Boolean, IsITLead);
                    database.AddInParameter(command, "@UId", DbType.Int32, UserId);

                    return database.ExecuteNonQuery(command) > 0;
                }
            }
            catch
            {
                return false;
            }
        }

        //------------ Start DP ------------

        public DataSet GetInProgressTasks(string userid, string desigid, string vSearch, int pageindex = 0, int pagesize = 0)
        {
            try
            {
                DataSet result = new DataSet();
                SqlDatabase database = MSSQLDataBase.Instance.GetDefaultDatabase();
                {
                    DbCommand command = database.GetStoredProcCommand("GetInProgressTasks");
                    command.CommandType = CommandType.StoredProcedure;
                    database.AddInParameter(command, "@userid", DbType.String, userid);
                    database.AddInParameter(command, "@desigid", DbType.String, desigid);
                    database.AddInParameter(command, "@search", DbType.String, vSearch);
                    database.AddInParameter(command, "@PageIndex", DbType.Int32, pageindex);
                    database.AddInParameter(command, "@PageSize", DbType.Int32, pagesize);
                    result = database.ExecuteDataSet(command);
                    return result;
                }
            }
            catch
            {
                return null;
            }
        }

        public DataSet GetClosedTasks(string userid, string desigid, string TaskUserStatus, string vSearch, int pageindex = 0, int pagesize = 0)
        {
            try
            {
                DataSet result = new DataSet();
                SqlDatabase database = MSSQLDataBase.Instance.GetDefaultDatabase();
                {
                    DbCommand command = database.GetStoredProcCommand("GetClosedTasks");
                    command.CommandType = CommandType.StoredProcedure;
                    database.AddInParameter(command, "@userid", DbType.String, userid);
                    database.AddInParameter(command, "@desigid", DbType.String, desigid);
                    database.AddInParameter(command, "@TaskStatus", SqlDbType.VarChar, TaskUserStatus.Split(":".ToCharArray())[0]);
                    database.AddInParameter(command, "@UserStatus", SqlDbType.VarChar, TaskUserStatus.Split(":".ToCharArray())[1]);
                    database.AddInParameter(command, "@search", DbType.String, vSearch);
                    database.AddInParameter(command, "@PageIndex", DbType.Int32, pageindex);
                    database.AddInParameter(command, "@PageSize", DbType.Int32, pagesize);
                    result = database.ExecuteDataSet(command);
                    return result;
                }
            }
            catch
            {
                return null;
            }
        }
        //------------- End DP--------------

        #endregion

        public DataSet GetTaskMultilevelListItem(int taskMultilevelListId, int? loggedInUserId = null)
        {
            try
            {
                SqlDatabase database = MSSQLDataBase.Instance.GetDefaultDatabase();
                {
                    returndata = new DataSet();
                    DbCommand command = database.GetStoredProcCommand("GetTaskMultilevelListItem");
                    command.CommandType = CommandType.StoredProcedure;

                    database.AddInParameter(command, "@TaskMultilevelListId", DbType.Int32, taskMultilevelListId);
                    database.AddInParameter(command, "@LoggedInUserId", DbType.Int32, loggedInUserId);
                    return database.ExecuteDataSet(command);
                }
            }
            catch (Exception ex)
            {
                return null;
            }
        }
    }
}
