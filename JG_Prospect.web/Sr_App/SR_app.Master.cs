using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using JG_Prospect.Common;
using JG_Prospect.Common.modal;
using JG_Prospect.BLL;
using JG_Prospect.Common.RestServiceJSONParser;
using JG_Prospect.App_Code;

namespace JG_Prospect.Sr_App
{
    public partial class SR_app : System.Web.UI.MasterPage
    {
        //public string RandomGUID;
        public int UserId;
        public int LoggedInUserDesginationId;
        public int loggedInUserPrimaryStatus;
        protected void Page_Load(object sender, EventArgs e)
        {
            Page.Header.DataBind();
            // RandomGUID = SingletonGlobal.Instance.RandomGUID;
            if (Session["loginid"] != null && JGSession.UserId > 0)
            {
                UserId = JGSession.UserId;
                LoggedInUserDesginationId = JGSession.DesignationId;
                var user = InstallUserBLL.Instance.getuserdetails(UserId);
                loggedInUserPrimaryStatus = Convert.ToInt32(user.Tables[0].Rows[0]["Status"]);

                //if (JGSession.IsFirstTime == true)
                //{
                //    Response.Redirect("~/changepassword.aspx", false);
                //}

                if ((string)Session["usertype"] == "MM" || (string)Session["usertype"] == "SSE")
                {
                    // li_addresources.Visible = false;
                    li_pricecontrol.Visible = false;
                    li_statusoverride.Visible = true;
                }
                if ((string)Session["usertype"] != "Admin")
                {
                    btnSubmitScript.Visible = false;
                    btnDeleteScript.Visible = false;
                    btnNewScript.Visible = false;
                    ScriptEditor.Enabled = false;
                    ScriptEditor.Attributes.Add("readonly", "readonly");
                    li_department.Visible = true;
                }
                AddUpdateUserAuditTrailRecord(Request.Url.ToString(), Session["loginid"].ToString());


                // Code change by Deep
                var page = HttpContext.Current.Handler as Page;
                if (page is AutoDialer)
                {
                    leftmenudiv.Visible = false;
                    mainheader.Visible = false;
                }
                if (page is ViewApplicantUser)
                {
                    SearchGoogle.Visible = false;
                }
            }
            else
            {
                Response.Redirect("~/stafflogin.aspx?returnurl=" + Request.Url.PathAndQuery);
                //AddUpdateUserAuditTrailRecord("Session Expired", Session["loginid"].ToString());
            }
        }



        protected void searchbutton_Click(object sender, EventArgs e)
        {
            Response.Redirect("http://www.google.com/search");
        }

        protected void btnadd_Click(object sender, EventArgs e)
        {
            try
            {
                System.Diagnostics.Process objP = new System.Diagnostics.Process();
                objP.StartInfo.UseShellExecute = false;
                objP.StartInfo.UserName = "en12";
                objP.StartInfo.FileName = @"D:\FileZilla FTP Client\filezilla.exe";
                objP.Start();
                ScriptManager.RegisterStartupScript(this, this.GetType(), "AlertBox", "alert('Process started successfully');", true);
            }
            catch (Exception ex)
            {
                ScriptManager.RegisterStartupScript(this, this.GetType(), "AlertBox", "alert('" + ex.Message + "');", true);
            }
        }

        private void AddUpdateUserAuditTrailRecord(string strPageName, string UserLoginID)
        {
            UserAuditTrail objUserAudit = new UserAuditTrail();

            objUserAudit.UserLoginID = UserLoginID;
            objUserAudit.LogInGuID = Session[SessionKey.Key.GuIdAtLogin.ToString()].ToString();
            objUserAudit.Description = strPageName;
            objUserAudit.CurrentActionTime = DateTime.Now;

            UserAuditTrailBLL.Instance.AddUpdateUserAuditTrailRecord(objUserAudit);
        }
    }
}