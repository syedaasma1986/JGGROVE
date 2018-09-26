using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Data;
using JG_Prospect.Common.Logger;
using JG_Prospect.BLL;
using System.Configuration;
using System.Net.Mail;
using System.Net;
using System.IO;
using System.Text;
using System.Security.Cryptography;
using ASPSnippets.FaceBookAPI;
using System.Web.Script.Serialization;
using ASPSnippets.GoogleAPI;
using ASPSnippets.TwitterAPI;
using DotNetOpenAuth.AspNet.Clients;
using JG_Prospect.Common;
using System.Web.Services;
using JG_Prospect.Common.modal;
using System.Collections.Specialized;

namespace JG_Prospect
{
    public partial class unsubscribe : System.Web.UI.Page
    {
        #region '--Members--'


        #endregion

        #region '-- Page methods --'

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                if (Request.QueryString.Count > 0 && !String.IsNullOrEmpty(Request.QueryString["e"]))
                {
                    unsubscribeemail(Request.QueryString);
                }
                else if (Request.QueryString.Count > 0 && !String.IsNullOrEmpty(Request.QueryString["m"]))
                {
                    unsubscribeSMS(Request.QueryString);
                }
            }
        }



        #endregion

        #region '-- Control Events --'

        protected void lbtnReSub_Click(object sender, EventArgs e)
        {
            if (Request.QueryString.Count > 0 && !String.IsNullOrEmpty(Request.QueryString["e"]))
            {

                String strEmail = Server.UrlDecode(Request.QueryString["e"].ToString());

                UnsubscribeBLL.Instance.DeleteUnSubscribeEmail(strEmail);
            }
            else if (Request.QueryString.Count > 0 && !String.IsNullOrEmpty(Request.QueryString["m"]))
            {
                String strMobile = Server.UrlDecode(Request.QueryString["m"].ToString());

                UnsubscribeBLL.Instance.DeleteUnSubscribeEmail(strMobile);
            }
        }

        #endregion

        #region '-- Methods --'

        private void unsubscribeSMS(NameValueCollection queryString)
        {
            if (Request.QueryString.Count > 0 && !String.IsNullOrEmpty(Request.QueryString["m"]))
            {

                String strMobile = Server.UrlDecode(Request.QueryString["m"].ToString());

                UnsubscribeBLL.Instance.DeleteUnSubscribeMobile(strMobile);

                ltlUnSEmail.Text = String.Concat("Mobile : \"", strMobile, "\" is unsubscribed successfully.");

                // Set user status to rejected.
                updateUserStatus(strMobile, false);
            }
        }

        /// <summary>
        /// Update user status to Rejected with reason "Opt out"
        /// </summary>
        /// <param name="strKey"></param>
        /// <param name="isEmail"></param>
        private void updateUserStatus(string strKey, bool isEmail)
        {
            if (isEmail)
            {
                InstallUserBLL.Instance.ChangeUserStatusToRejectByEmail(Convert.ToInt32(JGConstant.InstallUserStatus.Rejected), DateTime.Now.Date, DateTime.Now.ToShortTimeString(), JGApplicationInfo.GetJMGCAutoUserID(), strKey, "Email Opt Out");
            }
            else
            {
                InstallUserBLL.Instance.ChangeUserStatusToRejectByMobile(Convert.ToInt32(JGConstant.InstallUserStatus.Rejected), DateTime.Now.Date, DateTime.Now.ToShortTimeString(), JGApplicationInfo.GetJMGCAutoUserID(), strKey, "Mobile Opt Out");
            }

        }

        private void unsubscribeemail(NameValueCollection queryString)
        {
            if (queryString.Count > 0 && !String.IsNullOrEmpty(queryString["e"]))
            {
                String strEmail = Server.UrlDecode(queryString["e"].ToString());

                UnsubscribeBLL.Instance.InsertUnSubscribeEmail(strEmail);

                ltlUnSEmail.Text = String.Concat("Email : \"", strEmail, "\" is unsubscribed successfully.");

                // Set user status to rejected.
                // Set user status to rejected.
                updateUserStatus(strEmail, true);

            }
        }

        #endregion

        #region '-- Classes --'

        #endregion


    }
}
