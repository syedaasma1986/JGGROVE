using JG_Prospect.App_Code;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace JG_Prospect.Sr_App
{
    public partial class JabbRChat : System.Web.UI.Page
    {
        protected string UserName
        {
            get
            {
                return JG_Prospect.JGSession.UserLoginId.Replace("@", ".");
            }
        }

        public string Password
        {
            get
            {
                return JGSession.UserPassword;
            }
        }

        protected void Page_Load(object sender, EventArgs e)
        {
            CommonFunction.AuthenticateUser();
        }
    }
}