﻿using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using JG_Prospect.Common;

namespace JG_Prospect.Installer
{
    public partial class InstallerHeader : System.Web.UI.UserControl
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (Session["loginid"] != null)
            {
                lbluser.Text = Session["Username"].ToString();

                if ((string)Session["loginid"] == JGConstant.JUSTIN_LOGIN_ID)
                {
                    Li_sr_app.Visible = true;
                }
                else
                {
                    Li_sr_app.Visible = false;
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
            Response.Redirect("/stafflogin.aspx");
        }
    }
}