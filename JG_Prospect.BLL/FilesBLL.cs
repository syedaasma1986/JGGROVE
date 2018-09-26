using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

using JG_Prospect.DAL;
using JG_Prospect.Common;
using JG_Prospect.Common.modal;
using System.Data;
using System.Configuration;
using System.Data.SqlClient;

namespace JG_Prospect.BLL
{
    public class FilesBLL
    {
        private static FilesBLL m_FilesBLL = new FilesBLL();


        private FilesBLL()
        {

        }

        public static FilesBLL Instance
        {
            get { return m_FilesBLL; }
            set {; }
        }

        /// <summary>
        /// Method will return all files by location Id
        /// </summary>
        /// <param name="locationId"></param>
        /// <returns></returns>
        public DataSet GetFilesTreeView(int locationId)
        {
            return FilesDAL.Instance.GetFilesTreeView(locationId);
        }

        /// <summary>
        /// This will delete file by file Id
        /// </summary>
        /// <param name="folderId"></param>
        /// <returns></returns>
        public string DeleteFiles(int fileId,int folderid,int designationid,int locationid)
        {
            return FilesDAL.Instance.DeleteFiles(fileId, folderid, designationid, locationid);
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
            return FilesDAL.Instance.InsertFiles(name, uniqueName, folderId, modifiedBy,
            designationId, resourceTypeId, locationId);
        }

        public DataSet GetFilesTreeViewByDesignationId(int locationId, int designationId)
        {
            return FilesDAL.Instance.GetFilesTreeViewByDesignationId(locationId,designationId);
        }
        public void SwapFileOrder(int currentfileid, int fileToSwapid)
        {
            FilesDAL.Instance.SwapFileOrder(currentfileid, fileToSwapid);
        }
    }
}
