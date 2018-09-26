using JG_Prospect.BLL;
using System;
using System.Data;
using System.IO;
using System.Net;
using System.Web;

namespace JG_Prospect
{
    public partial class updateuserdetails : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            Response.AppendHeader("Access-Control-Allow-Origin", "*");

            string USERID = Request.Form["USERID"];
            string RESUMEFILE = Request.Form["RESUMEFILE"];
            string PICTUREFILE = Request.Form["PROFILEPICTURE"];

            if (!string.IsNullOrEmpty(USERID))
            {
                //Check if user exists
                DataSet ds = InstallUserBLL.Instance.getuserdetailsbyId(int.Parse(USERID));
                if (ds.Tables[0].Rows.Count > 0)
                {
                    string dbResumeFile = ds.Tables[0].Rows[0][1].ToString();
                    string dbPicture = ds.Tables[0].Rows[0][0].ToString();

                    
                    if (RESUMEFILE != null)
                    {
                        //Save Resume File                        
                        //if (dbResumeFile.Equals(resume.FileName))
                        {
                            if (!Directory.Exists(Server.MapPath("~/Employee")))
                            {
                                Directory.CreateDirectory(Server.MapPath("~/") + "Employee");
                            }
                            if (!Directory.Exists(Server.MapPath("~/Employee/Resume/")))
                            {
                                Directory.CreateDirectory(Server.MapPath("~/Employee/") + "Resume");
                            }

                            var fileName = Path.GetFileName(RESUMEFILE);                           
                            var path = Path.Combine(Server.MapPath("~/Employee/Resume/"), fileName);

                            WebClient wc = new WebClient();

                            wc.DownloadFile(RESUMEFILE, path);
                        }
                    }

                    if (PICTUREFILE != null)
                    {
                        if (!Directory.Exists(Server.MapPath("~/Employee")))
                        {
                            Directory.CreateDirectory(Server.MapPath("~/") + "Employee");
                        }
                        if (!Directory.Exists(Server.MapPath("~/Employee/ProfilePictures/")))
                        {
                            Directory.CreateDirectory(Server.MapPath("~/Employee/") + "ProfilePictures");
                        }

                        //Save Picture File
                        //if (dbPicture.Equals(picture.FileName))
                        {
                            var fileName = Path.GetFileName(PICTUREFILE);
                            var path = Path.Combine(Server.MapPath("~/Employee/ProfilePictures/"), fileName);

                            WebClient wc = new WebClient();

                            wc.DownloadFile(PICTUREFILE, path);
                        }
                    }
                }
            }
        }
    }
}