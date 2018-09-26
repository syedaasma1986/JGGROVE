using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using JG_Prospect.Common.Logger;
using JG_Prospect.BLL;
using System.Net.Mail;
using System.Net;
using JG_Prospect.App_Code;
using JG_Prospect.Common;

namespace JG_Prospect
{
    public partial class ForgotPassword : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                txtloginid.Text = "";
                rdSalesIns.Checked = true;
            }
        }

        protected void btnsubmit_Click(object sender, EventArgs e)
        {
            string newPassword = "";
            newPassword = CommonFunction.CreatePassword(6);
            string toEmail = txtloginid.Text;
            
            if (newPassword != "")
            {
                string str_Body = "<table><tr><td>Hello,<span style=\"background-color: orange;\">User</span></td></tr><tr><td>your password for the JM Grove Construction is : " + newPassword;
                str_Body = str_Body + "</td></tr>";
                str_Body = str_Body + "<tr><td></td></tr>";
                str_Body = str_Body + "<tr><td>Click <a href='http://web.jmgrovebuildingsupply.com/stafflogin.aspx'>web.jmgrovebuildingsupply.com</a> for login with your new password</td></tr>";
                str_Body = str_Body + "<tr><td>Thanks & Regards.</td></tr>";
                str_Body = str_Body + "<tr><td><span style=\"background-color: orange;\">JM Grove Constructions</span></td></tr></table>";
                if (!string.IsNullOrWhiteSpace(toEmail))
                {
                    try
                    {
                        string res = InstallUserBLL.Instance.Update_ForgotPassword(toEmail, newPassword, rdCustomer.Checked);
                        if (res == "1")
                        {
                            JG_Prospect.App_Code.CommonFunction.SendEmail(JGConstant.EmailTypes.None.ToString(), "",toEmail, "JM Grove Construction:Forgot Password", str_Body, new List<Attachment>());
                            ScriptManager.RegisterStartupScript(this, this.GetType(), "alert", "alert('Password send to your registered email id.'); window.parent.location.href = \"stafflogin.aspx\";", true);
                        }
                    }
                    catch(Exception ex)
                    {
                        ScriptManager.RegisterStartupScript(this, this.GetType(), "alert", "alert('Sorry we can not process your request right now, Please try again later.');", true);
                    }
                }
            }
            else
            {
                ScriptManager.RegisterStartupScript(this, this.GetType(), "alert", "alert('Email Id does not exists.')", true);
                return;
            }
        }
    }
}