using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Data;
using System.Data.Common;
using JG_Prospect.DAL.Database;
using Microsoft.Practices.EnterpriseLibrary.Data.Sql;
using System.Configuration;
using JG_Prospect.Common.modal;

namespace JG_Prospect.DAL
{
    public class FoldersDAL
    {
        private static FoldersDAL m_FoldersDAL = new FoldersDAL();
        private DataSet returndata;

        private FoldersDAL()
        {

        }

        public static FoldersDAL Instance
        {
            get { return m_FoldersDAL; }
            private set {; }
        }

        /// <summary>
        /// Method will return all folders by designation Id
        /// </summary>
        /// <param name="designationId"></param>
        /// <returns></returns>
        public DataSet GetFoldersByDesgId(int designationId,int locationid)
        {
            DataSet result = new DataSet();
            try
            {
                SqlDatabase database = MSSQLDataBase.Instance.GetDefaultDatabase();
                {
                    DbCommand command = database.GetStoredProcCommand("GetFolders");
                    command.CommandType = CommandType.StoredProcedure;
                    database.AddInParameter(command, "@DesignationId", DbType.String, designationId);
                    database.AddInParameter(command, "@locationid", DbType.String, locationid);
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
        /// Method will return all folders by folderId
        /// </summary>
        /// <param name="folderId"></param>
        /// <returns></returns>
        public DataSet GetFoldersById(int folderId)
        {
            DataSet result = new DataSet();
            try
            {
                SqlDatabase database = MSSQLDataBase.Instance.GetDefaultDatabase();
                {
                    DbCommand command = database.GetStoredProcCommand("GetFolderById");
                    command.CommandType = CommandType.StoredProcedure;
                    database.AddInParameter(command, "@FolderId", DbType.Int32, folderId);
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
        /// This will delete folder by Folder Id
        /// </summary>
        /// <param name="folderId"></param>
        /// <returns></returns>
        public string DeleteFolders(int folderId,int locationid)
        {
            try
            {
                SqlDatabase database = MSSQLDataBase.Instance.GetDefaultDatabase();
                {
                    DbCommand command = database.GetStoredProcCommand("DeleteFolders");
                    command.CommandType = CommandType.StoredProcedure;
                    database.AddInParameter(command, "@FolderId", DbType.Int32, folderId);
                    database.AddInParameter(command, "@locationid", DbType.Int32, locationid);
                    return (string)database.ExecuteScalar(command);
                }
            }
            catch (Exception ex)
            {
                return "";
            }
        }

        /// <summary>
        /// This method will insert folders
        /// </summary>
        /// <param name="name"></param>
        /// <param name="designationId"></param>
        /// <param name="userId"></param>
        /// <returns></returns>
        public int InsertFolders(string name, int designationId,int locationid, int userId)
        {
            try
            {
                SqlDatabase database = MSSQLDataBase.Instance.GetDefaultDatabase();
                {
                    DbCommand command = database.GetStoredProcCommand("InsertFolders");
                    command.CommandType = CommandType.StoredProcedure;
                    database.AddInParameter(command, "@Name", DbType.String, name);
                    database.AddInParameter(command, "@locationid", DbType.String, locationid);
                    database.AddInParameter(command, "@DesignationId", DbType.Int32, designationId);
                    database.AddInParameter(command, "@ModifiedBy", DbType.Int32, userId);
                    database.AddInParameter(command, "@ModifiedDate", DbType.DateTime, DateTime.Now);
                    database.AddOutParameter(command, "@FolderId", DbType.Int32,-1);
                    database.ExecuteScalar(command);
                    
                    return Convert.ToInt32(database.GetParameterValue(command, "@FolderId"));
                }
            }
            catch (Exception ex)
            {
                //LogManager.Instance.WriteToFlatFile(ex);
                return 0;
            }

        }
        public void SwapFolderOrder(int currentfolderid, int folderToSwapid)
        {
            try
            {
                SqlDatabase database = MSSQLDataBase.Instance.GetDefaultDatabase();
                {
                    DbCommand command = database.GetStoredProcCommand("SwapFolderOrder");
                    command.CommandType = CommandType.StoredProcedure;
                    database.AddInParameter(command, "@currentfolderid", DbType.Int32, currentfolderid);
                    database.AddInParameter(command, "@folderToSwapid", DbType.Int32, folderToSwapid);
                    database.ExecuteScalar(command);
                }
            }
            catch (Exception ex)
            {
                //LogManager.Instance.WriteToFlatFile(ex);
            }

        }
    }

}
