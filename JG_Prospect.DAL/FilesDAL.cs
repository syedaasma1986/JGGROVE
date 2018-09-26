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
    public class FilesDAL
    {
        private static FilesDAL m_FilesDAL = new FilesDAL();
        private DataSet returndata;

        private FilesDAL()
        {

        }

        public static FilesDAL Instance
        {
            get { return m_FilesDAL; }
            private set {; }
        }

        /// <summary>
        /// Method will return all folders by designation Id
        /// </summary>
        /// <param name="locationId"></param>
        /// <returns></returns>
        public DataSet GetFilesTreeView(int locationId)
        {
            DataSet result = new DataSet();
            try
            {
                SqlDatabase database = MSSQLDataBase.Instance.GetDefaultDatabase();
                {
                    DbCommand command = database.GetStoredProcCommand("GetFilesTM");
                    database.AddInParameter(command, "@LocationId", DbType.Int32, locationId);
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

        /// <summary>
        /// This will delete files by file Id
        /// </summary>
        /// <param name="fileId"></param>
        /// <returns></returns>
        public string DeleteFiles(int fileId, int folderid, int designationid, int locationid)
        {
            try
            {
                SqlDatabase database = MSSQLDataBase.Instance.GetDefaultDatabase();
                {
                    DbCommand command = database.GetStoredProcCommand("DeleteFiles");
                    command.CommandType = CommandType.StoredProcedure;
                    database.AddInParameter(command, "@FileId", DbType.Int32, fileId);
                    //database.AddInParameter(command, "@folderid", DbType.Int32, folderid);
                    //database.AddInParameter(command, "@designationid", DbType.Int32, designationid);
                    //database.AddInParameter(command, "@locationid", DbType.Int32, locationid);
                    return (string)database.ExecuteScalar(command);
                }
            }
            catch (Exception ex)
            {
                return "";
            }
        }

        public DataSet GetFilesTreeViewByDesignationId(int locationId, int designationId)
        {
            DataSet result = new DataSet();
            try
            {
                SqlDatabase database = MSSQLDataBase.Instance.GetDefaultDatabase();
                {
                    DbCommand command = database.GetStoredProcCommand("usp_GetFilesforDesignation");
                    database.AddInParameter(command, "@LocationId", DbType.Int32, locationId);
                    database.AddInParameter(command, "@DesignationId", DbType.Int32, designationId);
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

        /// <summary>
        /// This method will insert files
        /// </summary>
        /// <param name="name"></param>
        /// <param name="designationId"></param>
        /// <param name="userId"></param>
        /// <returns></returns>
        public int InsertFiles(string name, string uniqueName, int folderId, int modifiedBy,
            int designationId, int resourceTypeId, int locationId)
        {
            try
            {
                SqlDatabase database = MSSQLDataBase.Instance.GetDefaultDatabase();
                {
                    DbCommand command = database.GetStoredProcCommand("InsertFiles");
                    command.CommandType = CommandType.StoredProcedure;
                    database.AddInParameter(command, "@Name", DbType.String, name);
                    database.AddInParameter(command, "@UniqueName", DbType.String, uniqueName);
                    database.AddInParameter(command, "@FolderId", DbType.Int32, folderId);
                    database.AddInParameter(command, "@ModifiedBy", DbType.Int32, modifiedBy);
                    database.AddInParameter(command, "@ModifiedDate", DbType.DateTime, DateTime.Now);
                    database.AddInParameter(command, "@DesignationId", DbType.Int32, designationId);
                    database.AddInParameter(command, "@ResourceTypeId", DbType.Int32, resourceTypeId);
                    database.AddInParameter(command, "@LocationId", DbType.Int32, locationId);
                    return (int)database.ExecuteScalar(command);
                }
            }
            catch (Exception ex)
            {
                //LogManager.Instance.WriteToFlatFile(ex);
                return 0;
            }

        }

        public void SwapFileOrder(int currentfileid, int fileToSwapid)
        {
            try
            {
                SqlDatabase database = MSSQLDataBase.Instance.GetDefaultDatabase();
                {
                    DbCommand command = database.GetStoredProcCommand("SwapFileOrder");
                    command.CommandType = CommandType.StoredProcedure;
                    database.AddInParameter(command, "@currentfileid", DbType.Int32, currentfileid);
                    database.AddInParameter(command, "@fileToSwapid", DbType.Int32, fileToSwapid);
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
