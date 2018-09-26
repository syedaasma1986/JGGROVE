using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Services;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace JG_Prospect.Sr_App
{
    public partial class AutoDialer : System.Web.UI.Page
    {
        public int DesignationId;
        protected void Page_Load(object sender, EventArgs e)
        {
            DesignationId = JG_Prospect.JGSession.DesignationId;
        }
    }
}