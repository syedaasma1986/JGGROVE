using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Web;
using System.Web.Services;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace JG_Prospect.Sr_App
{
    public partial class chunkuploadhandler : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            bool completed = (Request["completed"] == null) ? false : bool.Parse(Request["completed"].ToString());
            string filename = (Request["filename"] == null) ? "" : Request["filename"].ToString();
            string foldername = (Request["foldername"] == null) ? "" : Request["foldername"].ToString();
            if (!IsPostBack)
            {

                if (completed)
                {
                    UploadComplete(foldername, filename);
                }
                else
                {
                    //if(Request.Files[0].ContentLength > 1000000)
                    //{
                    //    ChunkFileUploaded(Request.Files, foldername);
                    //}
                    //else
                    //{
                        SaveUploadedFile(Request.Files, foldername);
                    //}
                }
            }
        }
        public void SaveUploadedFile(HttpFileCollection httpFileCollection, string foldername)
        {
            foreach (string fileName in httpFileCollection)
            {
                HttpPostedFile file = httpFileCollection.Get(fileName);
                UploadAttachment(file, foldername);
            }
        }

        public void UploadAttachment(HttpPostedFile file, string foldername)
        {

            if (file != null && file.ContentLength > 0)
            {
                string strFolderName = foldername; // DateTime.Now.Month.ToString() + DateTime.Now.Day.ToString() + DateTime.Now.Second.ToString();
                var originalDirectory = new DirectoryInfo(Server.MapPath("~/UploadedExcel/" + strFolderName + "/"));

                string strFileName = Path.GetFileName(file.FileName);
                string strNewFileName = Guid.NewGuid() + "-" + strFileName.Replace(",", "-").Replace("@", "-");

                string strPath = Path.Combine(originalDirectory.ToString(), strNewFileName);

                if (!Directory.Exists(originalDirectory.ToString()))
                {
                    System.IO.Directory.CreateDirectory(originalDirectory.ToString());
                }

                file.SaveAs(strPath);
                Response.Write(strFolderName + "/" + strNewFileName + "^");
            }
        }
        /// <summary>
        /// Save all uploaded image
        /// </summary>
        /// <param name="httpFileCollection"></param>
        public void ChunkFileUploaded(HttpFileCollection httpFileCollection, string foldername)
        {
            string strFolderName = foldername; // DateTime.Now.Month.ToString() + DateTime.Now.Day.ToString() + DateTime.Now.Second.ToString();
            var originalDirectory = new DirectoryInfo(Server.MapPath("~/UploadedExcel/" + strFolderName + "/"));

            string strPath = Path.Combine(originalDirectory.ToString(), Path.GetRandomFileName());

            if (!Directory.Exists(originalDirectory.ToString()))
            {
                System.IO.Directory.CreateDirectory(originalDirectory.ToString());
            }

            var chunks = Request.InputStream;

            using (System.IO.FileStream fs = System.IO.File.Create(strPath))
            {
                byte[] bytes = new byte[1000000];
                int bytesRead;
                while ((bytesRead = Request.InputStream.Read(bytes, 0, bytes.Length)) > 0)
                {
                    fs.Write(bytes, 0, bytesRead);
                }
            }
        }
        
        public void UploadComplete(string foldername, string fileName)
        {
            var info = new DirectoryInfo(HttpContext.Current.Server.MapPath("~/UploadedExcel/" + foldername + "/"));
            FileInfo[] files = info.GetFiles().OrderBy(p => p.CreationTime).ToArray();

            string strNewFileName = Guid.NewGuid() + "-" + fileName.Replace(",", "-").Replace("@", "-");

            string path = HttpContext.Current.Server.MapPath("~/UploadedExcel/" + foldername + "/");
            string newpath = Path.Combine(path, strNewFileName);
            foreach (FileInfo item in files)
            {
                MergeFiles(newpath, item.FullName);
            }
            Response.Write(foldername + "/" + strNewFileName + "^");
            Response.End();
        }

        private static void MergeFiles(string file1, string file2)
        {
            FileStream fs1 = null;
            FileStream fs2 = null;
            try
            {
                fs1 = System.IO.File.Open(file1, FileMode.Append);
                fs2 = System.IO.File.Open(file2, FileMode.Open);
                byte[] fs2Content = new byte[fs2.Length];
                fs2.Read(fs2Content, 0, (int)fs2.Length);
                fs1.Write(fs2Content, 0, (int)fs2.Length);
            }
            catch (Exception ex)
            {
                Console.WriteLine(ex.Message + " : " + ex.StackTrace);
            }
            finally
            {
                if(fs1 != null)
                    fs1.Close();
                if(fs2 != null)
                    fs2.Close();
                System.IO.File.Delete(file2);
            }
        }

        [WebMethod]
        public static string RemoveUploadedattachment(string serverfilename)
        {
            var originalDirectory = new DirectoryInfo(HttpContext.Current.Server.MapPath("~/TaskAttachments"));

            string pathString = System.IO.Path.Combine(originalDirectory.ToString(), serverfilename);

            bool isExists = System.IO.File.Exists(pathString);

            if (isExists)
                File.Delete(pathString);

            return serverfilename;
        }
    
    }
}