using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Configuration;
using JG_Prospect.BLL;

namespace JG_Prospect
{
    public partial class JG : System.Web.UI.MasterPage
    {
        public int UserId;
        public int LoggedInUserDesginationId;
        public int loggedInUserPrimaryStatus;

        protected void Page_Load(object sender, EventArgs e)
        {
            if (Session["loginid"] == null && JGSession.UserId > 0)
            {
                UserId = JGSession.UserId;
                LoggedInUserDesginationId = JGSession.DesignationId;
                var user = InstallUserBLL.Instance.getuserdetails(UserId);
                loggedInUserPrimaryStatus = Convert.ToInt32(user.Tables[0].Rows[0]["Status"]);

                

                Session["PopUpOnSessionExpire"] = null;
                ScriptManager.RegisterStartupScript(this, GetType(), "alsert", "alert('Your session has expired,login to continue');window.location='stafflogin.aspx;')", true);
            }
        }
    }
}