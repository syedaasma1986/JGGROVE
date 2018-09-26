using JG_Prospect.BLL;
using JG_Prospect.Common.modal;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace JG_Prospect.Sr_App
{
    public partial class TouchPointLog : System.Web.UI.Page
    {
        public int loggedInUserId = 0;
        protected void Page_Load(object sender, EventArgs e)
        {
            JG_Prospect.App_Code.CommonFunction.AuthenticateUser();

            loggedInUserId = JGSession.UserId;
        }        
    }
}