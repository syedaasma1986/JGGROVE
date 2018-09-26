using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using JG_Prospect.Common;
using JG_Prospect.BLL;
using JG_Prospect.App_Code;
using JG_Prospect.Common.RestServiceJSONParser;
using JG_Prospect.Utilits;
using Newtonsoft.Json;
using JG_Prospect.Chat.Hubs;
using JG_Prospect.Common.modal;

namespace JG_Prospect.Sr_App
{
    public partial class SRAppHeader : System.Web.UI.UserControl
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            var page = HttpContext.Current.Handler as Page;
            if(page is ViewApplicantUser)
            {
                NavMenuLeft.Visible = false;
                divTask.Visible = false;
            }

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

                    lbluser.Text = Session["Username"].ToString() + " " + Session["LastName"].ToString();
                    lblDesignation.Text = JGSession.Designation;
                    imgProfile.ImageUrl = JGSession.UserProfileImg;
                    hLnkEditProfil.Text = JGSession.UserInstallId;
                    if (JGSession.LoginUserID != null)
                        hLnkEditProfil.NavigateUrl = "/Sr_App/CreateSalesUser.aspx?ID=" + JGSession.LoginUserID;
                    else
                        hLnkEditProfil.NavigateUrl = "#";

                    if ((string)Session["usertype"] == "SSE")
                    {
                        Li_Jr_app.Visible = false;
                    }
                    if ((string)Session["loginid"] == JGConstant.JUSTIN_LOGIN_ID)
                    {
                        // Li_Installer.Visible = true;
                    }
                    else
                    {
                        // Li_Installer.Visible = false;
                    } 
                }
                //SetEmailCountersAccess();
            }
            else
            {
                //Session["PopUpOnSessionExpire"] = "Expire";
                //// Response.Redirect("/login.aspx");
                //ScriptManager.RegisterStartupScript(this, GetType(), "alsert", "alert('Your session has expired,login to continue');window.location='../login.aspx?returnurl=" + Request.Url.PathAndQuery + ";')", true);
            }

        }

        protected void btnlogout_Click(object sender, EventArgs e)
        {
            // Remove user from ChatUser
            //ChatHub chatHub = new Chat.Hubs.ChatHub();

            HttpCookie auth_cookie = Request.Cookies[Cookies.UserId];
            if (auth_cookie != null)
            {
                auth_cookie.Expires = DateTime.Now.AddDays(-2);
                Response.Cookies.Add(auth_cookie);
            }

            UpdateAudiTrailForLogout();
            Session.Clear();
            Session["LogOut"] = 1;
            Response.Redirect("~/stafflogin.aspx");
        }

        /// <summary>
        /// User Audi Trail Entry for Logout
        /// </summary>
        private void UpdateAudiTrailForLogout()
        {
            if (!string.IsNullOrEmpty(SessionKey.Key.GuIdAtLogin.ToString()))
            {
                Common.modal.UserAuditTrail objUserAudit = new Common.modal.UserAuditTrail();

                objUserAudit.LogOutTime = DateTime.Now;
                objUserAudit.LogInGuID = Session[SessionKey.Key.GuIdAtLogin.ToString()].ToString();

                UserAuditTrailBLL.Instance.UpdateUserLogOutTime(objUserAudit);
            }
        }

        protected void lbtWeather_Click(object sender, EventArgs e)
        {



            //RadWindow2.VisibleOnPageLoad = true;

            // ScriptManager.RegisterStartupScript(this, this.GetType(), "Overlay", "overlayPassword();", true);
            // return;
        }


        // Created By: Yogesh Keraliya
        // TODO: If user is admin then only show email link as of now.
        //private void SetEmailCountersAccess()
        //{
        //    //if (JGSession.UserLoginId == CommonFunction.PreConfiguredAdminUserId)
        //    //{
        //    hypEmail.HRef = "javascript:window.open('/webmail/checkemail.aspx','mywindow','width=900,height=600')";
        //    this.Page.ClientScript.RegisterStartupScript(this.Page.GetType(), "EmailCount", "SetEmailCounts();", true);
        //    idPhoneLink.Visible = true;

        //    //}
        //    //else
        //    //{
        //    //    idPhoneLink.Visible = false;
        //    //}
        //}

    }
}