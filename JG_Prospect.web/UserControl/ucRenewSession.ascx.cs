using JG_Prospect.App_Code;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace JG_Prospect.UserControl
{
    public partial class ucRenewSession : System.Web.UI.UserControl
    {
        public bool IsCustomer
        {
            get
            {
                if (ViewState["IsCustomer"] == null)
                    return false;
                return Convert.ToBoolean(ViewState["IsCustomer"]);
            }
            set
            {
                ViewState["IsCustomer"] = value;
            }
        }

        public string Username
        {
            get
            {
                if (ViewState["Username"] == null)
                {
                    return null;
                }
                return Convert.ToString(ViewState["Username"]);
            }
            set
            {
                ViewState["Username"] = value;
            }
        }

        public string UserLoginId
        {
            get
            {
                if (ViewState["loginid"] == null)
                {
                    return null;
                }
                return Convert.ToString(ViewState["loginid"]);
            }
            set
            {
                ViewState["loginid"] = value;
            }
        }

        public string UserPassword
        {
            get
            {
                if (ViewState["loginpassword"] == null)
                {
                    return null;
                }
                return Convert.ToString(ViewState["loginpassword"]);
            }
            set
            {
                ViewState["loginpassword"] = value;
            }
        }

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                JG_Prospect.JGSession.StartDateTime = DateTime.Now;
                this.IsCustomer = JGSession.IsCustomer;
                this.Username = JGSession.Username;
                this.UserLoginId = JGSession.UserLoginId;
                this.UserPassword = JGSession.UserPassword;
            }
            else
            {
                // set session values from veiw state to prevent any redirectes made from individual page load event.
                // master page should not redirect user to login page. individual page should contain check for re-login.
                if (_hdnRenewSession.Value == "1") 
                {
                    btnYes_Click(sender, e);
                }
            }
        }

        protected void btnYes_Click(object sender, EventArgs e)
        {
            JGSession.IsCustomer = this.IsCustomer;
            JGSession.Username = this.Username;
            JGSession.UserLoginId = this.UserLoginId;
            JGSession.UserPassword = this.UserPassword;
            JGSession.UserId = 0;

            //_hdnRenewSession.Value = "0";

            //CommonFunction.AuthenticateUser();

            HttpContext.Current.Response.Redirect("~/stafflogin.aspx?returnurl=" + HttpContext.Current.Request.Url.PathAndQuery); 
        }

        protected void btnNo_Click(object sender, EventArgs e)
        {
            Session.Clear();

            CommonFunction.AuthenticateUser();
        }
        
        protected int GetSessionTimeoutSeconds()
        {
            return Convert.ToInt32((Session.Timeout * 60) - DateTime.Now.Subtract(JG_Prospect.JGSession.StartDateTime).TotalSeconds);
        }
    }
}