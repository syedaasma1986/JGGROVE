using JG_Prospect.BLL;
using JG_Prospect.Common.RestServiceJSONParser;
using JG_Prospect.Utilits;
using Newtonsoft.Json;
using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Web;
using System.Web.Services;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Web.Script.Serialization;
using System.Web.Script.Services;
using JG_Prospect.Common.modal;

namespace JG_Prospect.Sr_App
{
    public partial class ajaxcalls : System.Web.UI.Page
    {

        #region "-- Web Methods --"

        /// <summary>
        /// Get auto search suggestions for task generator search box.
        /// </summary>
        /// <param name="searchterm"></param>
        /// <returns>categorised search suggestions for Users, Designations, Task Title, Task Ids</returns>
        [WebMethod]
        public static string GetSearchSuggestions(string searchterm)
        {
            DataSet dsSuggestions;

            string SearchSuggestions = string.Empty;

            dsSuggestions = TaskGeneratorBLL.Instance.GetTaskSearchAutoSuggestion(searchterm);

            if (dsSuggestions != null && dsSuggestions.Tables.Count > 0 && dsSuggestions.Tables[0].Rows.Count > 0)
            {
                SearchSuggestions = JsonConvert.SerializeObject(dsSuggestions.Tables[0]);
            }

            return SearchSuggestions;
        }

        /// <summary>
        /// Load auto search suggestion as user types in search box for sales users.
        /// </summary>
        /// <param name="searchTerm"></param>
        /// <returns> categorised search suggestions for sales users</returns>
        [WebMethod]
        public static string GetSalesUserAutoSuggestion(string searchterm)
        {
            DataSet dsSuggestions;

            string SearchSuggestions = string.Empty;

            dsSuggestions = InstallUserBLL.Instance.GetSalesUserAutoSuggestion(searchterm);

            if (dsSuggestions != null && dsSuggestions.Tables.Count > 0 && dsSuggestions.Tables[0].Rows.Count > 0)
            {
                SearchSuggestions = JsonConvert.SerializeObject(dsSuggestions.Tables[0]);
            }

            return SearchSuggestions;
        }

        [WebMethod]
        public static string GetEmailCounters()
        {
            String Result = String.Empty;
            YandexEmailCountersResponse EmailCounters = YandexManager.GetUnreadEmailCount(AppSettingsValues.GetDomainActiveUserEmailCreation, "jgrove@jmgroveconstruction.com");
            if (EmailCounters != null)
            {
               Result =  JsonConvert.SerializeObject(EmailCounters.counters, Formatting.Indented);
            }
            return Result;

        }

        //---------- Start DP ---------
        [WebMethod]
        public static string GetTaskUsers(string searchterm)
        {
            DataSet dsSuggestions;

            string SearchSuggestions = string.Empty;

            dsSuggestions = InstallUserBLL.Instance.GetTaskUsers(searchterm);

            if (dsSuggestions != null && dsSuggestions.Tables.Count > 0 && dsSuggestions.Tables[0].Rows.Count > 0)
            {
                SearchSuggestions = JsonConvert.SerializeObject(dsSuggestions.Tables[0]);
            }

            return SearchSuggestions;
        }

        [WebMethod]
        public static string GetTaskUsersForDashBoard(string searchterm)
        {
            DataSet dsSuggestions;

            string SearchSuggestions = string.Empty;

            dsSuggestions = InstallUserBLL.Instance.GetTaskUsersForDashBoard(searchterm);

            if (dsSuggestions != null && dsSuggestions.Tables.Count > 0 && dsSuggestions.Tables[0].Rows.Count > 0)
            {
                SearchSuggestions = JsonConvert.SerializeObject(dsSuggestions.Tables[0]);
            }

            return SearchSuggestions;
        }

        [WebMethod]
        public static string GetUsersByDesignationId(string designationId)
        {
            DataSet dsUsers = TaskGeneratorBLL.Instance.GetInstallUsers(2, designationId);
            string SearchSuggestions = string.Empty;

            if (dsUsers != null && dsUsers.Tables.Count > 0 && dsUsers.Tables[0].Rows.Count > 0)
            {
                SearchSuggestions = JsonConvert.SerializeObject(dsUsers.Tables[0]);
            }

            return SearchSuggestions;
        }

        [WebMethod]
        public static string GetUsersByDesignationIdWithUserStatus(string designationId, string userStatus)
        {
            DataSet dsUsers = TaskGeneratorBLL.Instance.GetInstallUsers(2, designationId, userStatus);
            string SearchSuggestions = string.Empty;

            if (dsUsers != null && dsUsers.Tables.Count > 0 && dsUsers.Tables[0].Rows.Count > 0)
            {
                SearchSuggestions = JsonConvert.SerializeObject(dsUsers.Tables[0]);
            }

            return SearchSuggestions;
        }

        [WebMethod]
        public static string GetInstallUsersByPrefix(string keyword)
        {
            ActionOutput<LoginUser> users = TaskGeneratorBLL.Instance.GetInstallUsersByPrefix(keyword);
            return new JavaScriptSerializer().Serialize(users);
        }

        [WebMethod]
        public static string StarBookMarkUsers(int bookmarkedUser,   int isdelete)
        {
            string strReturn = "true";
            try
            {
                int userId = Convert.ToInt16(HttpContext.Current.Session[JG_Prospect.Common.SessionKey.Key.UserId.ToString()]);
                strReturn = InstallUserBLL.Instance.GetStarBookMarkUsers(userId, bookmarkedUser, isdelete);
            }
            catch(Exception ex)
            {
                strReturn = "false";
            }
            return strReturn;
        }


        [WebMethod]

        public static string GetBookMarkingUserDetails(int bookmarkedUser)
        {
            DataSet dsBook = new DataSet();
            try
            {
                dsBook = InstallUserBLL.Instance.GetBookMarkingUserDetails(bookmarkedUser);
            }
            catch (Exception ex)
            {
                dsBook = null;
            }

            List<object> listdata = new List<object>();
            for (int i = 0; i < dsBook.Tables[0].Rows.Count;i++ )
            {
                listdata.Add(new
                {
                    Id = dsBook.Tables[0].Rows[i]["Id"],
                    FristName = dsBook.Tables[0].Rows[i]["FristName"],
                    LastName = dsBook.Tables[0].Rows[i]["LastName"],
                    Designation = dsBook.Tables[0].Rows[i]["Designation"],
                    Email = dsBook.Tables[0].Rows[i]["Email"],
                    UserInstallId = dsBook.Tables[0].Rows[i]["UserInstallId"],
                    createdDateTime = dsBook.Tables[0].Rows[i]["createdDateTime"]
                });
            }

            return new JavaScriptSerializer().Serialize(listdata); 
        }

        //---------- End DP ---------


        #endregion

        #region "-- Chat --"

        [WebMethod]
        public static string LogintoChat()
        {
            string returnval = string.Empty;

            string server = "http://chat.jmgrovebuildingsupply.com";

            var strPostData = string.Format("username={0}&email={1}&password={2}&confirmPassword={2}", JGSession.UserLoginId.Replace("@", "."), JGSession.UserLoginId, JGSession.UserPassword);
            var arrPostData = System.Text.Encoding.ASCII.GetBytes(strPostData);

            if (SendHttpWebRequest(server + "/account/create", arrPostData).StatusCode == System.Net.HttpStatusCode.OK)
            {
                strPostData = string.Format("username={0}&password={1}", JGSession.UserLoginId.Replace("@", "."), JGSession.UserPassword);
                arrPostData = System.Text.Encoding.ASCII.GetBytes(strPostData);

                if (SendHttpWebRequest(server + "/account/login", arrPostData).StatusCode == System.Net.HttpStatusCode.OK)
                {
                    returnval = "1"; 
                }
            }

            return returnval;
        }

        private static System.Net.HttpWebResponse SendHttpWebRequest(string strUrl, byte[] arrPostData)
        {
            var objRequest = (System.Net.HttpWebRequest)System.Net.WebRequest.Create(strUrl);

            objRequest.Method = "POST";
            objRequest.ContentType = "application/x-www-form-urlencoded";
            objRequest.ContentLength = arrPostData.Length;

            objRequest.Headers.Add("sec-jabbr-client", "1");

            using (var stream = objRequest.GetRequestStream())
            {
                stream.Write(arrPostData, 0, arrPostData.Length);
            }

            return (System.Net.HttpWebResponse)objRequest.GetResponse();
        }

        #endregion


    }
}