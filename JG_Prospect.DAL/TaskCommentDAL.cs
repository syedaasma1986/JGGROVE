using JG_Prospect.Common.modal;
using JG_Prospect.DAL.Database;
using Microsoft.Practices.EnterpriseLibrary.Data.Sql;
using System;
using System.Collections.Generic;
using System.Data;
using System.Data.Common;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace JG_Prospect.DAL
{
    public class TaskCommentDAL
    {
        private static TaskCommentDAL m_TaskCommentDAL = new TaskCommentDAL();
        public static TaskCommentDAL Instance
        {
            get { return m_TaskCommentDAL; }
            private set { ; }
        }

        public List<TaskComment> GetTaskCommentsList(long intTaskId, long? intParentCommentId, int? intStartIndex, int? intPageSize)
        {
            try
            {
                SqlDatabase database = MSSQLDataBase.Instance.GetDefaultDatabase();
                {
                    DbCommand command = database.GetStoredProcCommand("GetTaskComments");
                    command.CommandType = CommandType.StoredProcedure;
                    database.AddInParameter(command, "@TaskId", DbType.Int64, intTaskId);
                    if (intParentCommentId.HasValue)
                    {
                        database.AddInParameter(command, "@ParentCommentId", DbType.Int64, intParentCommentId.Value);
                    }
                    if (intStartIndex.HasValue)
                    {
                        database.AddInParameter(command, "@StartIndex", DbType.Int32, intStartIndex.Value);
                    }
                    if (intPageSize.HasValue)
                    {
                        database.AddInParameter(command, "@PageSize", DbType.Int32, intPageSize.Value);
                    }

                    DataSet dsTaskComments = database.ExecuteDataSet(command);

                    List<TaskComment> lstTaskComments = new List<TaskComment>();

                    if (dsTaskComments != null && dsTaskComments.Tables.Count > 0)
                    {
                        foreach (DataRow drTaskComment in dsTaskComments.Tables[0].Rows)
                        {
                            TaskComment objTaskComment = new TaskComment();
                            objTaskComment.Id = Convert.ToInt64(drTaskComment["Id"]);
                            objTaskComment.Comment = Convert.ToString(drTaskComment["Comment"]);
                            if (!string.IsNullOrEmpty(Convert.ToString(drTaskComment["ParentCommentId"])))
                            {
                                objTaskComment.ParentCommentId = Convert.ToInt64(drTaskComment["ParentCommentId"]);
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
                    }

                    return lstTaskComments;
                }
            }
            catch (Exception ex)
            {
                return null;
            }
        }

        public DataSet GetTaskCommentsDataSet(long intTaskId, long? intParentCommentId, int? intStartIndex, int? intPageSize)
        {
            try
            {
                SqlDatabase database = MSSQLDataBase.Instance.GetDefaultDatabase();
                {
                    DbCommand command = database.GetStoredProcCommand("GetTaskComments");
                    command.CommandType = CommandType.StoredProcedure;
                    database.AddInParameter(command, "@TaskId", DbType.Int64, intTaskId);
                    if (intParentCommentId.HasValue)
                    {
                        database.AddInParameter(command, "@ParentCommentId", DbType.Int64, intParentCommentId.Value);
                    }
                    if (intStartIndex.HasValue)
                    {
                        database.AddInParameter(command, "@StartIndex", DbType.Int32, intStartIndex.Value);
                    }
                    if (intPageSize.HasValue)
                    {
                        database.AddInParameter(command, "@PageSize", DbType.Int32, intPageSize.Value);
                    }

                    return database.ExecuteDataSet(command);
                }
            }
            catch (Exception ex)
            {
                return null;
            }
        }

        public bool InsertTaskComment(TaskComment objTaskComment)
        {
            try
            {
                SqlDatabase database = MSSQLDataBase.Instance.GetDefaultDatabase();
                {
                    DbCommand command = database.GetStoredProcCommand("InsertTaskComment");
                    command.CommandType = CommandType.StoredProcedure;
                    database.AddInParameter(command, "@Comment", DbType.String, objTaskComment.Comment);
                    database.AddInParameter(command, "@TaskId", DbType.Int64, objTaskComment.TaskId);
                    if (objTaskComment.ParentCommentId.HasValue)
                    {
                        database.AddInParameter(command, "@ParentCommentId", DbType.Int64, objTaskComment.ParentCommentId.Value);
                    }
                    else
                    {
                        database.AddInParameter(command, "@ParentCommentId", DbType.Int64, DBNull.Value);
                    }
                    database.AddInParameter(command, "@UserId", DbType.Int32, objTaskComment.UserId);

                    return (database.ExecuteNonQuery(command) > 0);
                }
            }
            catch (Exception ex)
            {
                return false;
            }
        }

        public bool UpdateTaskComment(TaskComment objTaskComment)
        {
            try
            {
                SqlDatabase database = MSSQLDataBase.Instance.GetDefaultDatabase();
                {
                    DbCommand command = database.GetStoredProcCommand("UpdateTaskComment");
                    command.CommandType = CommandType.StoredProcedure;
                    database.AddInParameter(command, "@Id", DbType.String, objTaskComment.Id);
                    database.AddInParameter(command, "@Comment", DbType.String, objTaskComment.Comment);
                    database.AddInParameter(command, "@TaskId", DbType.Int64, objTaskComment.TaskId);
                    if (objTaskComment.ParentCommentId.HasValue)
                    {
                        database.AddInParameter(command, "@ParentCommentId", DbType.Int64, objTaskComment.ParentCommentId.Value);
                    }
                    else
                    {
                        database.AddInParameter(command, "@ParentCommentId", DbType.Int64, DBNull.Value);
                    }
                    database.AddInParameter(command, "@UserId", DbType.Int32, objTaskComment.UserId);

                    return (database.ExecuteNonQuery(command) > 0);
                }
            }
            catch (Exception ex)
            {
                return false;
            }
        }

        public bool DeleteTaskComment(TaskComment objTaskComment)
        {
            try
            {
                SqlDatabase database = MSSQLDataBase.Instance.GetDefaultDatabase();
                {
                    DbCommand command = database.GetStoredProcCommand("DeleteTaskComment");
                    command.CommandType = CommandType.StoredProcedure;
                    database.AddInParameter(command, "@Id", DbType.String, objTaskComment.Id);

                    return (database.ExecuteNonQuery(command) > 0);
                }
            }
            catch (Exception ex)
            {
                return false;
            }
        }
    }
}
