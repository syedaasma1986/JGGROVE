using JG_Prospect.App_Code;
using JG_Prospect.BLL;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace JG_Prospect.Sr_App
{
    public partial class email_template_maintainance : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            CommonFunction.AuthenticateUser();

            if (!IsPostBack)
            {
                FillHtmlTemplates();
            }
        }

        private void FillHtmlTemplates()
        {
            grdHtmlTemplates.DataSource = HTMLTemplateBLL.Instance.GetHTMLTemplateMasters(1);
            grdHtmlTemplates.DataBind();
        }

        protected void grdHtmlTemplates_RowCommand(object sender, GridViewCommandEventArgs e)
        {
            
        }
    }
}