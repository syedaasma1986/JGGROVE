using JG_Prospect.App_Code;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace JG_Prospect.Controls
{
    public partial class _WebToWebCaller : System.Web.UI.UserControl
    {
        public string JGPA;
        protected void Page_Load(object sender, EventArgs e)
        {
            JGPA = CommonFunction.JGPA.Trim(new char[] { '/' });
        }
    }
}