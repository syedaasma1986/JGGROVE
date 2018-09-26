using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Configuration;
using JG_Prospect.BLL;
using JG_Prospect.Common.modal;

namespace JG_Prospect.Controls
{
    public partial class Header : System.Web.UI.UserControl
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (Session["loginid"] != null)
            {
                // branch location on header
                BranchLocation loc = InstallUserBLL.Instance.GetUserBranchLocation(JGSession.UserId);
                if (loc != null)
                {
                    BranchAddress1.InnerText = loc.BranchAddress1;
                    BranchAddress2.InnerText = loc.BranchAddress2;
                    Department.InnerText = loc.Department;
                    Phone.InnerText = loc.PhoneNumber;
                    Email.InnerText = loc.Email;
                }

                hLnkEditProfil.Text = JGSession.UserInstallId;
                if (JGSession.LoginUserID != null)
                    hLnkEditProfil.NavigateUrl = "/Sr_App/CreateSalesUser.aspx?ID=" + JGSession.LoginUserID;
                else
                    hLnkEditProfil.NavigateUrl = "#";


                lbluser.Text = Session["Username"].ToString().Trim();
                string AdminId = ConfigurationManager.AppSettings["AdminUserId"].ToString();
                imgProfile.ImageUrl = JGSession.UserProfileImg;

                if ((string)Session["AdminUserId"] == AdminId)
                {
                    Lidashboard.Visible = true;
                    Lihome.Visible = true;
                    Liprogress.Visible = true;
                    Li_sr_app.Visible = true;
                    //Licreateuser.Visible = true;
                    //Liedituser.Visible = true;
                    Lidefineperiod.Visible = true;
                    LiUploadprospect.Visible = true;
                    //Li_AssignProspect.Visible = true;
                }
                else
                {
                    if ((string)Session["usertype"] == "Admin" || (string)Session["usertype"] == "SM")
                    {
                        Lidashboard.Visible = true;
                        Lihome.Visible = true;
                        Liprogress.Visible = true;
                        Li_sr_app.Visible = true;
                    }
                    else if ((string)Session["usertype"] == "MM")
                    {
                        LiUploadprospect.Visible = true;
                        //Li_AssignProspect.Visible = true;
                        Li_sr_app.Visible = true;
                        //Licreateuser.Visible = true;
                        //Liedituser.Visible = true;
                    }
                    else
                    {
                        Lidefineperiod.Visible = false;
                        LiUploadprospect.Visible = false;
                        //Li_AssignProspect.Visible = false;
                    }
                }

            }
            else
            {
                Response.Redirect("/stafflogin.aspx?returnurl=" + Request.Url.PathAndQuery);
            }
        }

        protected void btnlogout_Click(object sender, EventArgs e)
        {
            Session.Clear();
            Response.Redirect("~/stafflogin.aspx");
        }

        public bool ShowTaskList
        {
            set
            {
                TaskGenerator.Visible = value;
            }
        }

        public bool ShowMenu
        {
            set
            {
                divMenu.Visible = value;
            }
        }
    }
}