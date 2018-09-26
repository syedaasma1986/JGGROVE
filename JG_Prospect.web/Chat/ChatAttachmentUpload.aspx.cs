using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Web;
using System.Web.Services;
using System.Web.UI;
using System.Web.UI.WebControls;
using JG_Prospect.Common;
using JG_Prospect.BLL;

namespace JG_Prospect.Chat
{
    public partial class ChatAttachmentUpload : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                SaveUploadedFile(Request.Files);
            }
        }

        /// <summary>
        /// Save all uploaded image
        /// </summary>
        /// <param name="httpFileCollection"></param>
        public void SaveUploadedFile(HttpFileCollection httpFileCollection)
        {
            //bool isSavedSuccessfully = true;
            //string fName = "";
            foreach (string fileName in httpFileCollection)
            {
                HttpPostedFile file = httpFileCollection.Get(fileName);
                UploadAttachment(file);
            }
        }

        public void UploadAttachment(HttpPostedFile file)
        {

            if (file != null && file.ContentLength > 0)
            {
                string ext = string.Empty;
                string imageName = string.Empty;
                string NewImageName = string.Empty;
                var originalDirectory = new DirectoryInfo(Server.MapPath(JGConstant.ChatFilePath));
                if (file.ContentType == "video/webm" || file.ContentType == "audio/webm")
                {
                    imageName = Guid.NewGuid().ToString() + ".webm";
                    NewImageName = imageName;
                }
                else
                {
                    ext = file.FileName.Substring(file.FileName.LastIndexOf("."));
                    imageName = Path.GetFileName(file.FileName.RemoveAllSpecialCharaters() + ext);
                    NewImageName = Guid.NewGuid() + ext;
                }

                string pathString = System.IO.Path.Combine(originalDirectory.ToString(), NewImageName);
                bool isExists = System.IO.Directory.Exists(originalDirectory.ToString());
                if (!isExists)
                    System.IO.Directory.CreateDirectory(originalDirectory.ToString());

                file.SaveAs(pathString);
                // Make entry into database for this attachment
                int fileId = ChatBLL.Instance.SaveChatFile(imageName, NewImageName, file.ContentType);

                Response.Write(NewImageName + "^" + fileId + "^" + imageName + "^" + file.ContentType + "^");
            }
        }

        [WebMethod]
        public static string RemoveUploadedattachment(string serverfilename)
        {
            var originalDirectory = new DirectoryInfo(HttpContext.Current.Server.MapPath("~/Attachments"));

            string pathString = System.IO.Path.Combine(originalDirectory.ToString(), serverfilename);

            bool isExists = System.IO.File.Exists(pathString);

            if (isExists)
                File.Delete(pathString);

            return serverfilename;
        }

        /// <summary>
        /// Save all uploaded image
        /// </summary>
        /// <param name="httpFileCollection"></param>
        public void PostRecordedAudioVideo(HttpFileCollection httpFileCollection)
        {
            //bool isSavedSuccessfully = true;
            //string fName = "";
            foreach (string fileName in httpFileCollection)
            {
                HttpPostedFile file = httpFileCollection.Get(fileName);
                UploadAttachment(file);
            }
        }

        public void PostRecordedAudioVideoq(HttpPostedFile file)
        {

            if (file != null && file.ContentLength > 0)
            {
                var originalDirectory = new DirectoryInfo(Server.MapPath(JGConstant.ChatFilePath));
                string ext = file.FileName.Substring(file.FileName.LastIndexOf("."));
                string imageName = Path.GetFileName(file.FileName.RemoveAllSpecialCharaters() + ext);
                string NewImageName = Guid.NewGuid() + ext;

                string pathString = System.IO.Path.Combine(originalDirectory.ToString(), NewImageName);

                bool isExists = System.IO.Directory.Exists(originalDirectory.ToString());

                if (!isExists)
                    System.IO.Directory.CreateDirectory(originalDirectory.ToString());

                file.SaveAs(pathString);

                // Make entry into database for this attachment
                int fileId = ChatBLL.Instance.SaveChatFile(imageName, NewImageName, file.ContentType);

                Response.Write(NewImageName + "^" + fileId + "^" + imageName + "^");
            }
        }

    }
}