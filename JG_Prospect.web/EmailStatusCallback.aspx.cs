using JG_Prospect.BLL;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace JG_Prospect
{
    public partial class EmailStatusCallback : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            /*
             http://www.somehost.com/can/be/anything?
                            transaction=a58d3de8-b003-48ba-8e0e-9877c70d264f&
                            to=someone@somehost.com&
                            date=3/10/2012 10:20:30 AM&
                            status=Clicked&
                            channel=your channel name&
                            account=your@account.email.com 
            */
            //
            //ErrorLogBLL.Instance.SaveApplicationError("EmailStatusCallback Start",
            //    "EmailStatusCallback function called by ElasticEmail on status change", "", "/EmailStatusCallback.aspx");
            try
            {
                string transaction = string.IsNullOrEmpty(Request.QueryString["transaction"]) ? "" : Request.QueryString["transaction"].ToString();
                string to = string.IsNullOrEmpty(Request.QueryString["to"]) ? "" : Request.QueryString["to"].ToString();
                string date = string.IsNullOrEmpty(Request.QueryString["date"]) ? "" : Request.QueryString["date"].ToString();
                string status = string.IsNullOrEmpty(Request.QueryString["status"]) ? "" : Request.QueryString["status"].ToString();
                string channel = string.IsNullOrEmpty(Request.QueryString["channel"]) ? "" : Request.QueryString["channel"].ToString();
                string account = string.IsNullOrEmpty(Request.QueryString["account"]) ? "" : Request.QueryString["account"].ToString();
                string category = string.IsNullOrEmpty(Request.QueryString["category"]) ? "" : Request.QueryString["category"].ToString();
                string target = string.IsNullOrEmpty(Request.QueryString["target"]) ? "" : Request.QueryString["target"].ToString();
                /*
                ErrorLogBLL.Instance.SaveApplicationError("EmailStatusCallback End",
                    "EmailStatusCallback function called by ElasticEmail on status change",
                    "transaction:" + transaction + ", " +
                    "to:" + to + ", " +
                    "date:" + date + ", " +
                    "status:" + status + ", " +
                    "channel:" + channel + ", " +
                    "account:" + account + ", " +
                    "category:" + category + ", " +
                    "target:" + target
                    , Request.Url.ToString());
                    */
                EmailManager.UpdateEmailStatus(transaction, to, date, status, channel, account, category, target);
            }
            catch (Exception ex)
            {
                ErrorLogBLL.Instance.SaveApplicationError("EmailStatusCallback", ex.Message, ex.ToString(), Request.Url.ToString());
            }
        }
    }
}