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
    public class FoldersBLL
    {
        private static FoldersBLL m_FoldersBLL = new FoldersBLL();


        private FoldersBLL()
        {

        }

        public static FoldersBLL Instance
        {
            get { return m_FoldersBLL; }
            set {; }
        }

        /// <summary>
        /// Method will return all folders by designation Id
        /// </summary>
        /// <param name="designationId"></param>
        /// <returns></returns>
        public DataSet GetFoldersByDesgId(int designationId,int locationid)
        {
            return FoldersDAL.Instance.GetFoldersByDesgId(designationId, locationid);
        }

        /// <summary>
        /// Method will return all folders by folderId 
        /// </summary>
        /// <param name="folderId"></param>
        /// <returns></returns>
        public DataSet GetFoldersByd(int folderId)
        {
            return FoldersDAL.Instance.GetFoldersById(folderId);
        }

        /// <summary>
        /// This will delete folder by Folder Id
        /// </summary>
        /// <param name="folderId"></param>
        /// <returns></returns>
        public string DeleteFolders(int folderId,int locationid)
        {
            return FoldersDAL.Instance.DeleteFolders(folderId, locationid);
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
            return FoldersDAL.Instance.InsertFolders(name, designationId, locationid ,userId);
        }

        public void SwapFolderOrder(int currentfolderid, int folderToSwapid)
        {
            FoldersDAL.Instance.SwapFolderOrder(currentfolderid, folderToSwapid);
        }
    }
}
