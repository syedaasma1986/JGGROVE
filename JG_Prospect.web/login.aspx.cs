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
using JG_Prospect.Common;
//using Owin;
//using Microsoft.Owin.Builder;
using System.Globalization;
//using Microsoft.Owin.Security;
using DotNetOpenAuth.AspNet.Clients;
using System.Text.RegularExpressions;
using Newtonsoft.Json;
using JG_Prospect.App_Code;

namespace JG_Prospect
{
    public partial class login : System.Web.UI.Page
    {
        #region '--Members--'

        static int c = 0;
        ErrorLog logErr = new ErrorLog();

        #endregion

        #region '-- Page methods --'

        protected void Page_Load(object sender, EventArgs e)
        {

            //if (Session["PopUpOnSessionExpire"] == null)
            //{
            //    if (c != 0 && Session["LogOut"]!=null)
            //    {
            //        ScriptManager.RegisterStartupScript(this, GetType(), "overlay", "SessionExpire();", true);                    
            //    }
            //    c++;
            //}
            //facebook login
            FaceBookConnect.API_Key = "1617979618482118";
            FaceBookConnect.API_Secret = "1b8ede82b0adbebb2282934247773490";
            //google plus login
            //GoogleConnect.ClientId = "356184594367-5iu5qlbe4ddgtst0p6teae8r2s0b5a6n.apps.googleusercontent.com";
            //GoogleConnect.ClientSecret = "rVkwAed1NzC_-F3Z6yUFiFQ_";
            //GoogleConnect.RedirectUri = Request.Url.AbsoluteUri.Split('?')[0];
            GoogleConnect.ClientId = "230635153352-67pgqgc8n4ao9dhnnr3plb1sbnvga1tu.apps.googleusercontent.com";
            GoogleConnect.ClientSecret = "4t6zZfPMfgLVxSRSItsWeOGo";
            GoogleConnect.RedirectUri = Request.Url.AbsoluteUri.Split('?')[0];


            //Login with Twitter
            // TwitterConnect.API_Key = " hlFND0IQOjA7hMPVmVvKKVlzI";
            // TwitterConnect.API_Secret = "NNL9H5GCNSvNH0XJv4ax2wh9iWbqmqTxO9ydR7ewcX1l7XMY5o";
            TwitterConnect.API_Key = "SWPrFVQ6o5q2f2Zjo5R4iNeFv";
            TwitterConnect.API_Secret = "sHRhjjETwXOF5LwxYvK7yk5jz81OchC7IFSyQGWTKzpVeoWOkd";
            //  CalendarExtender2.EndDate = DateTime.Today;
            //txtDateOfBith.Attributes.Add("readonly", "readonly");
            if (!IsPostBack)
            {
              rdCustomer.Checked = true;
                JGSession.Designation = "";
                JGSession.DesignationId = 0;
                btnSignUp.Visible = true;
                if (Request.Cookies["UserName"] != null && Request.Cookies["Password"] != null)
                {
                    txtloginid.Text = Request.Cookies["UserName"].Value;
                    txtpassword.Attributes["value"] = Request.Cookies["Password"].Value;
                    chkRememberMe.Checked = true;
                }

                #region Twitter  login
                if (TwitterConnect.IsAuthorized)
                {
                    TwitterConnect twitter = new TwitterConnect();
                    DataTable dt = twitter.FetchProfile();
                    string email = dt.Rows[0]["screen_name"].ToString();
                    string name = dt.Rows[0]["name"].ToString();
                    //pradip sir code

                    //Procedure prObj = new Procedure();
                    //Generic gnObj = new Generic();
                    //gnObj.Username1 = dt.Rows[0]["Id"].ToString();                    
                    //gnObj.StatementName = "Student";
                    //int count = prObj.InsertFacebookUser(gnObj);
                    //if (count == 1)
                    //{
                    //    ScriptManager.RegisterStartupScript(this.Page, GetType(), "duplicatI", "Student();", true);
                    //    return;
                    //}
                    //else if (count == 2)
                    //{
                    //    ScriptManager.RegisterStartupScript(this.Page, GetType(), "register", "Register();", true);
                    //    return;
                    //}
                    try
                    {
                        int isvaliduser = 0;
                        DataSet ds = new DataSet();
                        ds = UserBLL.Instance.getUser(email);
                        string AdminId = string.Empty;
                        if (ds.Tables[0].Rows.Count > 0)
                        {
                            if (ds.Tables[0].Rows.Count > 0)
                            {
                                JGSession.Username = ds.Tables[0].Rows[0]["Username"].ToString().Trim();
                                JGSession.UserPassword = ds.Tables[0].Rows[0]["Password"].ToString().Trim();
                                Session[JG_Prospect.Common.SessionKey.Key.UserId.ToString()] = ds.Tables[0].Rows[0]["Id"].ToString().Trim();
                                AdminId = ConfigurationManager.AppSettings["AdminUserId"].ToString();
                                isvaliduser = UserBLL.Instance.chklogin(email, txtpassword.Text);
                            }

                            if (isvaliduser > 0)
                            {
                                JGSession.UserLoginId = email;
                                JGSession.GuIdAtLogin = Guid.NewGuid().ToString(); // Adding GUID for Audit Track
                                //JGSession.UserPassword = txtpassword.Text.Trim();
                                RememberMe();
                                if (txtloginid.Text.Trim() == AdminId)
                                {
                                    JGSession.AdminUserId = AdminId;
                                    JGSession.UserType = "Admin";
                                    Response.Redirect("~/Sr_App/home.aspx", true);
                                }

                                if (isvaliduser == 1)
                                {
                                    JGSession.UserType = "Admin";
                                    Response.Redirect("~/Sr_App/home.aspx", true);
                                }
                                else if (isvaliduser == 2)
                                {
                                    JGSession.UserType = "JSE";
                                    Response.Redirect("~/home.aspx", true);
                                }
                                else if (isvaliduser == 3)
                                {
                                    JGSession.UserType = "SSE";
                                    Response.Redirect("~/Sr_App/home.aspx", true);
                                }
                                else if (isvaliduser == 4)
                                {
                                    JGSession.UserType = "MM";
                                    Response.Redirect("~/home.aspx", true);
                                }
                                else if (isvaliduser == 5)
                                {
                                    JGSession.UserType = "SM";
                                    Response.Redirect("~/Sr_App/home.aspx", true);
                                }
                                else if (isvaliduser == 6)
                                {
                                    JGSession.UserType = "AdminSec";
                                    Response.Redirect("~/home.aspx", true);
                                }
                                else if (isvaliduser == 7)
                                {
                                    JGSession.UserType = "Employee";
                                    Response.Redirect("~/home.aspx", true);
                                }
                            }
                            else  // if installer
                            {
                                ds = null;
                                ds = InstallUserBLL.Instance.getInstallerUserDetailsByLoginId(txtloginid.Text.Trim());
                                JGSession.Username = ds.Tables[0].Rows[0]["FristName"].ToString().Trim();
                                JGSession.UserPassword = ds.Tables[0].Rows[0]["Password"].ToString().Trim();
                                Session[JG_Prospect.Common.SessionKey.Key.UserId.ToString()] = ds.Tables[0].Rows[0]["Id"].ToString().Trim();
                                string AdminInstallerId = ConfigurationManager.AppSettings["AdminUserId"].ToString();
                                int IsValidInstallerUser = InstallUserBLL.Instance.IsValidInstallerUser(txtloginid.Text.Trim(), txtpassword.Text);
                                if (IsValidInstallerUser > 0)
                                {
                                    JGSession.UserLoginId = txtloginid.Text.Trim();
                                    JGSession.GuIdAtLogin = Guid.NewGuid().ToString(); // Adding GUID for Audit Track

                                    //JGSession.UserPassword = txtpassword.Text.Trim();
                                    if (txtloginid.Text.Trim() == AdminInstallerId)
                                    {
                                        JGSession.AdminUserId = AdminInstallerId;
                                    }
                                    JGSession.UserType = "Installer";
                                    RememberMe();
                                    Response.Redirect("~/Installer/InstallerHome.aspx", true);
                                }
                                //else
                                //{
                                //    JGSession.UserLoginId = null;
                                //    ScriptManager.RegisterStartupScript(this, this.GetType(), "AlertBox", "alert('Please enter a valid Loginid and password!');", true);
                                //}
                            }
                        }
                        else
                        {
                            string username = email;
                            //string password = txtSignupPassword.Text;
                            string password = "";
                            try
                            {
                                InstallUserBLL.Instance.AddUserFB(username);
                                btnSignUp.Visible = false;
                                Response.Redirect("~/home.aspx", true);
                                //SendActivationLink(username);
                                //ScriptManager.RegisterStartupScript(this, this.GetType(), "alert", "alert('Your account is successfully created')", true);
                            }
                            catch (Exception ex)
                            {

                            }
                        }
                    }
                    catch (Exception ex)
                    {
                        //logErr.writeToLog(ex, this.Page.ToString(), Request.ServerVariables["remote_addr"].ToString());
                        ScriptManager.RegisterStartupScript(this, this.GetType(), "AlertBox", "alert('Please enter a valid Loginid and password!');", true);
                        //  Response.Redirect("ErrorPage.aspx");
                    }

                }
                if (TwitterConnect.IsDenied)
                {
                    ClientScript.RegisterStartupScript(this.GetType(), "key", "alert('User has denied access.')", true);
                }
                #endregion

                #region google + login

                if (!string.IsNullOrEmpty(Request.QueryString["code"]) && JGSession.IsGooglePlus == true)
                {
                    string code = Request.QueryString["code"];
                    string json = GoogleConnect.Fetch("me", code);
                    string name, emailGPlus;
                    GoogleProfile profile = new JavaScriptSerializer().Deserialize<GoogleProfile>(json);
                    //lblId.Text = profile.Id;
                    name = profile.DisplayName;
                    emailGPlus = profile.Emails.Find(email => email.Type == "account").Value;
                    try
                    {
                        int isvaliduser = 0;
                        DataSet ds = new DataSet();
                        ds = UserBLL.Instance.getUser(emailGPlus);
                        string AdminId = string.Empty;
                        if (ds.Tables[0].Rows.Count > 0)
                        {
                            if (ds.Tables[0].Rows.Count > 0)
                            {
                                JGSession.Username = ds.Tables[0].Rows[0]["Username"].ToString().Trim();
                                JGSession.UserPassword = ds.Tables[0].Rows[0]["Password"].ToString().Trim();
                                Session[JG_Prospect.Common.SessionKey.Key.UserId.ToString()] = ds.Tables[0].Rows[0]["Id"].ToString().Trim();
                                AdminId = ConfigurationManager.AppSettings["AdminUserId"].ToString();
                                isvaliduser = UserBLL.Instance.chklogin(emailGPlus, txtpassword.Text);
                            }

                            if (isvaliduser > 0)
                            {
                                JGSession.UserLoginId = emailGPlus;
                                JGSession.GuIdAtLogin = Guid.NewGuid().ToString(); // Adding GUID for Audit Track
                                //JGSession.UserPassword = txtpassword.Text.Trim();
                                RememberMe();
                                if (txtloginid.Text.Trim() == AdminId)
                                {
                                    JGSession.AdminUserId = AdminId;
                                    JGSession.UserType = "Admin";
                                    Response.Redirect("~/Sr_App/home.aspx", true);
                                }

                                if (isvaliduser == 1)
                                {
                                    JGSession.UserType = "Admin";
                                    Response.Redirect("~/Sr_App/home.aspx", true);
                                }
                                else if (isvaliduser == 2)
                                {
                                    JGSession.UserType = "JSE";
                                    Response.Redirect("~/home.aspx", true);
                                }
                                else if (isvaliduser == 3)
                                {
                                    JGSession.UserType = "SSE";
                                    Response.Redirect("~/Sr_App/home.aspx", true);
                                }
                                else if (isvaliduser == 4)
                                {
                                    JGSession.UserType = "MM";
                                    Response.Redirect("~/home.aspx", true);
                                }
                                else if (isvaliduser == 5)
                                {
                                    JGSession.UserType = "SM";
                                    Response.Redirect("~/Sr_App/home.aspx", true);
                                }
                                else if (isvaliduser == 6)
                                {
                                    JGSession.UserType = "AdminSec";
                                    Response.Redirect("~/home.aspx", true);
                                }
                                else if (isvaliduser == 7)
                                {
                                    JGSession.UserType = "Employee";
                                    Response.Redirect("~/home.aspx", true);
                                }
                            }
                            else  // if installer
                            {
                                ds = null;
                                ds = InstallUserBLL.Instance.getInstallerUserDetailsByLoginId(txtloginid.Text.Trim());
                                JGSession.Username = ds.Tables[0].Rows[0]["FristName"].ToString().Trim();
                                JGSession.UserPassword = ds.Tables[0].Rows[0]["Password"].ToString().Trim();
                                Session[JG_Prospect.Common.SessionKey.Key.UserId.ToString()] = ds.Tables[0].Rows[0]["Id"].ToString().Trim();
                                string AdminInstallerId = ConfigurationManager.AppSettings["AdminUserId"].ToString();
                                int IsValidInstallerUser = InstallUserBLL.Instance.IsValidInstallerUser(txtloginid.Text.Trim(), txtpassword.Text);
                                if (IsValidInstallerUser > 0)
                                {
                                    JGSession.UserLoginId = txtloginid.Text.Trim();
                                    JGSession.GuIdAtLogin = Guid.NewGuid().ToString(); // Adding GUID for Audit Track

                                    //JGSession.UserPassword = txtpassword.Text.Trim();
                                    if (txtloginid.Text.Trim() == AdminInstallerId)
                                    {
                                        JGSession.AdminUserId = AdminInstallerId;
                                    }
                                    JGSession.UserType = "Installer";
                                    RememberMe();
                                    Response.Redirect("~/Installer/InstallerHome.aspx", true);
                                }
                                //else
                                //{
                                //    JGSession.UserLoginId = null;
                                //    ScriptManager.RegisterStartupScript(this, this.GetType(), "AlertBox", "alert('Please enter a valid Loginid and password!');", true);
                                //}
                            }
                        }
                        else
                        {
                            string username = emailGPlus;
                            //string password = txtSignupPassword.Text;
                            string password = "";
                            try
                            {
                                InstallUserBLL.Instance.AddUserFB(username);
                                btnSignUp.Visible = false;
                                Response.Redirect("~/home.aspx", true);
                                //SendActivationLink(username);
                                //ScriptManager.RegisterStartupScript(this, this.GetType(), "alert", "alert('Your account is successfully created')", true);
                            }
                            catch (Exception ex)
                            {

                            }
                        }
                    }
                    catch (Exception ex)
                    {
                        //logErr.writeToLog(ex, this.Page.ToString(), Request.ServerVariables["remote_addr"].ToString());
                        ScriptManager.RegisterStartupScript(this, this.GetType(), "AlertBox", "alert('Please enter a valid Loginid and password!');", true);
                        //  Response.Redirect("ErrorPage.aspx");
                    }
                }
                #endregion

                #region Facebook login

                if (JGSession.IsFacebook == true)
                {

                    if (Request.QueryString["error"] == "access_denied")
                    {
                        ClientScript.RegisterStartupScript(this.GetType(), "alert", "alert('User has denied access.')", true);
                        return;
                    }

                    string code = Request.QueryString["code"];
                    if (!string.IsNullOrEmpty(code))
                    {
                        string email, name, user, firstName, lastName;
                        string data = FaceBookConnect.Fetch(code, "me");
                        FaceBookUser faceBookUser = new JavaScriptSerializer().Deserialize<FaceBookUser>(data);
                        faceBookUser.PictureUrl = string.Format("https://graph.facebook.com/{0}/picture", faceBookUser.Id);
                        //pnlFaceBookUser.Visible = true;
                        //save data in database
                        user = faceBookUser.Name;
                        email = faceBookUser.Email;
                        try
                        {
                            int isvaliduser = 0;
                            DataSet ds = new DataSet();
                            ds = UserBLL.Instance.getUser(email);
                            string AdminId = string.Empty;
                            if (ds.Tables[0].Rows.Count > 0)
                            {
                                if (ds.Tables[0].Rows.Count > 0)
                                {
                                    JGSession.Username = ds.Tables[0].Rows[0]["Username"].ToString().Trim();
                                    JGSession.UserPassword = ds.Tables[0].Rows[0]["Password"].ToString().Trim();
                                    Session[JG_Prospect.Common.SessionKey.Key.UserId.ToString()] = ds.Tables[0].Rows[0]["Id"].ToString().Trim();
                                    AdminId = ConfigurationManager.AppSettings["AdminUserId"].ToString();
                                    isvaliduser = UserBLL.Instance.chklogin(email, txtpassword.Text);
                                }

                                if (isvaliduser > 0)
                                {
                                    JGSession.UserLoginId = email;
                                    JGSession.GuIdAtLogin = Guid.NewGuid().ToString(); // Adding GUID for Audit Track
                                    //JGSession.UserPassword = txtpassword.Text.Trim();
                                    RememberMe();
                                    if (txtloginid.Text.Trim() == AdminId)
                                    {
                                        JGSession.AdminUserId = AdminId;
                                        JGSession.UserType = "Admin";
                                        Response.Redirect("~/Sr_App/home.aspx", true);
                                    }

                                    if (isvaliduser == 1)
                                    {
                                        JGSession.UserType = "Admin";
                                        Response.Redirect("~/Sr_App/home.aspx", true);
                                    }
                                    else if (isvaliduser == 2)
                                    {
                                        JGSession.UserType = "JSE";
                                        Response.Redirect("~/home.aspx", true);
                                    }
                                    else if (isvaliduser == 3)
                                    {
                                        JGSession.UserType = "SSE";
                                        Response.Redirect("~/Sr_App/home.aspx", true);
                                    }
                                    else if (isvaliduser == 4)
                                    {
                                        JGSession.UserType = "MM";
                                        Response.Redirect("~/home.aspx", true);
                                    }
                                    else if (isvaliduser == 5)
                                    {
                                        JGSession.UserType = "SM";
                                        Response.Redirect("~/Sr_App/home.aspx", true);
                                    }
                                    else if (isvaliduser == 6)
                                    {
                                        JGSession.UserType = "AdminSec";
                                        Response.Redirect("~/home.aspx", true);
                                    }
                                    else if (isvaliduser == 7)
                                    {
                                        JGSession.UserType = "Employee";
                                        Response.Redirect("~/home.aspx", true);
                                    }
                                }
                                else  // if installer
                                {
                                    ds = null;
                                    ds = InstallUserBLL.Instance.getInstallerUserDetailsByLoginId(txtloginid.Text.Trim());
                                    JGSession.Username = ds.Tables[0].Rows[0]["FristName"].ToString().Trim();
                                    JGSession.UserPassword = ds.Tables[0].Rows[0]["Password"].ToString().Trim();
                                    Session[JG_Prospect.Common.SessionKey.Key.UserId.ToString()] = ds.Tables[0].Rows[0]["Id"].ToString().Trim();
                                    string AdminInstallerId = ConfigurationManager.AppSettings["AdminUserId"].ToString();
                                    int IsValidInstallerUser = InstallUserBLL.Instance.IsValidInstallerUser(txtloginid.Text.Trim(), txtpassword.Text);
                                    if (IsValidInstallerUser > 0)
                                    {
                                        JGSession.UserLoginId = txtloginid.Text.Trim();
                                        JGSession.GuIdAtLogin = Guid.NewGuid().ToString(); // Adding GUID for Audit Track

                                        //JGSession.UserPassword = txtpassword.Text.Trim();
                                        if (txtloginid.Text.Trim() == AdminInstallerId)
                                        {
                                            JGSession.AdminUserId = AdminInstallerId;
                                        }
                                        JGSession.UserType = "Installer";
                                        RememberMe();
                                        Response.Redirect("~/Installer/InstallerHome.aspx", true);
                                    }
                                    //else
                                    //{
                                    //    JGSession.UserLoginId = null;
                                    //    ScriptManager.RegisterStartupScript(this, this.GetType(), "AlertBox", "alert('Please enter a valid Loginid and password!');", true);
                                    //}
                                }
                            }
                            else
                            {
                                string username = email;
                                //string password = txtSignupPassword.Text;
                                string password = "";
                                try
                                {
                                    InstallUserBLL.Instance.AddUserFB(username);
                                    btnSignUp.Visible = false;
                                    Response.Redirect("~/home.aspx", true);
                                    //SendActivationLink(username);
                                    //ScriptManager.RegisterStartupScript(this, this.GetType(), "alert", "alert('Your account is successfully created')", true);
                                }
                                catch (Exception ex)
                                {

                                }
                            }
                        }
                        catch (Exception ex)
                        {
                            //logErr.writeToLog(ex, this.Page.ToString(), Request.ServerVariables["remote_addr"].ToString());
                            ScriptManager.RegisterStartupScript(this, this.GetType(), "AlertBox", "alert('Please enter a valid Loginid and password!');", true);
                            //  Response.Redirect("ErrorPage.aspx");
                        }
                    }
                }
                #endregion

                #region Yahoo login
                if (JGSession.IsYahoo == true)
                {
                    try
                    {
                        YahooOpenIdClient yahoo = new DotNetOpenAuth.AspNet.Clients.YahooOpenIdClient();
                        var httpContextBase = new HttpContextWrapper(HttpContext.Current);
                        var res = yahoo.VerifyAuthentication(httpContextBase);
                        if (res.IsSuccessful)
                        {
                            string name, emailyahoo;
                            name = res.ExtraData["fullName"];
                            emailyahoo = res.ExtraData["email"];

                            int isvaliduser = 0;
                            DataSet ds = new DataSet();
                            ds = UserBLL.Instance.getUser(emailyahoo);
                            string AdminId = string.Empty;
                            if (ds.Tables[0].Rows.Count > 0)
                            {
                                if (ds.Tables[0].Rows.Count > 0)
                                {
                                    JGSession.Username = ds.Tables[0].Rows[0]["Username"].ToString().Trim();
                                    JGSession.UserPassword = ds.Tables[0].Rows[0]["Password"].ToString().Trim();
                                    Session[JG_Prospect.Common.SessionKey.Key.UserId.ToString()] = ds.Tables[0].Rows[0]["Id"].ToString().Trim();
                                    AdminId = ConfigurationManager.AppSettings["AdminUserId"].ToString();
                                    isvaliduser = UserBLL.Instance.chklogin(emailyahoo, txtpassword.Text);
                                }

                                if (isvaliduser > 0)
                                {
                                    JGSession.UserLoginId = emailyahoo;
                                    JGSession.GuIdAtLogin = Guid.NewGuid().ToString(); // Adding GUID for Audit Track
                                    //JGSession.UserPassword = txtpassword.Text.Trim();
                                    RememberMe();
                                    if (txtloginid.Text.Trim() == AdminId)
                                    {
                                        JGSession.AdminUserId = AdminId;
                                        JGSession.UserType = "Admin";
                                        Response.Redirect("~/Sr_App/home.aspx", true);
                                    }

                                    if (isvaliduser == 1)
                                    {
                                        JGSession.UserType = "Admin";
                                        Response.Redirect("~/Sr_App/home.aspx", true);
                                    }
                                    else if (isvaliduser == 2)
                                    {
                                        JGSession.UserType = "JSE";
                                        Response.Redirect("~/home.aspx", true);
                                    }
                                    else if (isvaliduser == 3)
                                    {
                                        JGSession.UserType = "SSE";
                                        Response.Redirect("~/Sr_App/home.aspx", true);
                                    }
                                    else if (isvaliduser == 4)
                                    {
                                        JGSession.UserType = "MM";
                                        Response.Redirect("~/home.aspx", true);
                                    }
                                    else if (isvaliduser == 5)
                                    {
                                        JGSession.UserType = "SM";
                                        Response.Redirect("~/Sr_App/home.aspx", true);
                                    }
                                    else if (isvaliduser == 6)
                                    {
                                        JGSession.UserType = "AdminSec";
                                        Response.Redirect("~/home.aspx", true);
                                    }
                                    else if (isvaliduser == 7)
                                    {
                                        JGSession.UserType = "Employee";
                                        Response.Redirect("~/home.aspx", true);
                                    }
                                }
                                else  // if installer
                                {
                                    ds = null;
                                    ds = InstallUserBLL.Instance.getInstallerUserDetailsByLoginId(txtloginid.Text.Trim());
                                    JGSession.Username = ds.Tables[0].Rows[0]["FristName"].ToString().Trim();
                                    JGSession.UserPassword = ds.Tables[0].Rows[0]["Password"].ToString().Trim();
                                    Session[JG_Prospect.Common.SessionKey.Key.UserId.ToString()] = ds.Tables[0].Rows[0]["Id"].ToString().Trim();
                                    string AdminInstallerId = ConfigurationManager.AppSettings["AdminUserId"].ToString();
                                    int IsValidInstallerUser = InstallUserBLL.Instance.IsValidInstallerUser(txtloginid.Text.Trim(), txtpassword.Text);
                                    if (IsValidInstallerUser > 0)
                                    {
                                        JGSession.UserLoginId = txtloginid.Text.Trim();
                                        JGSession.GuIdAtLogin = Guid.NewGuid().ToString(); // Adding GUID for Audit Track

                                        //JGSession.UserPassword = txtpassword.Text.Trim();
                                        if (txtloginid.Text.Trim() == AdminInstallerId)
                                        {
                                            JGSession.AdminUserId = AdminInstallerId;
                                        }
                                        JGSession.UserType = "Installer";
                                        RememberMe();
                                        Response.Redirect("~/Installer/InstallerHome.aspx", true);
                                    }
                                    //else
                                    //{
                                    //    JGSession.UserLoginId = null;
                                    //    ScriptManager.RegisterStartupScript(this, this.GetType(), "AlertBox", "alert('Please enter a valid Loginid and password!');", true);
                                    //}
                                }
                            }
                            else
                            {
                                string username = emailyahoo;
                                //string password = txtSignupPassword.Text;
                                string password = "";
                                try
                                {
                                    InstallUserBLL.Instance.AddUserFB(username);
                                    btnSignUp.Visible = false;
                                    Response.Redirect("~/home.aspx", true);
                                    //SendActivationLink(username);
                                    //ScriptManager.RegisterStartupScript(this, this.GetType(), "alert", "alert('Your account is successfully created')", true);
                                }
                                catch (Exception ex)
                                {

                                }
                            }
                        }
                        JGSession.IsYahoo = false;
                    }
                    catch (Exception ex)
                    {
                        //logErr.writeToLog(ex, this.Page.ToString(), Request.ServerVariables["remote_addr"].ToString());
                        ScriptManager.RegisterStartupScript(this, this.GetType(), "AlertBox", "alert('Please enter a valid Loginid and password!');", true);
                        //  Response.Redirect("ErrorPage.aspx");
                        JGSession.IsYahoo = false;
                    }
                }
                #endregion

                #region Microsoft login
                if (JGSession.IsMicrosoft == true)
                {
                    try
                    {
                        if (Request.QueryString["error"] == "unauthorized_client")
                        {
                            ClientScript.RegisterStartupScript(this.GetType(), "alert", "alert('" + Request.QueryString["error_description"] + "')", true);
                            return;
                        }

                        string appId = "00000000481C1797";
                        string appSecrets = "cec1ShT5FFjexbtm08qv0w8";

                        MicrosoftClient ms = new MicrosoftClient(appId, appSecrets);
                        var httpContextBase = new HttpContextWrapper(HttpContext.Current);
                        string returnUrl = Request.Url.AbsoluteUri.Split('?')[0];
                        Uri authUrl = new Uri(returnUrl);

                        var res = ms.VerifyAuthentication(httpContextBase, authUrl);

                        if (res.IsSuccessful)
                        {
                            string name, emailyahoo, token;
                            token = res.ExtraData["accesstoken"];
                            //userData = GetUserData(token);

                            name = res.ExtraData["name"];
                            emailyahoo = res.ExtraData["username"];

                            int isvaliduser = 0;
                            DataSet ds = new DataSet();
                            ds = UserBLL.Instance.getUser(emailyahoo);
                            string AdminId = string.Empty;
                            if (ds.Tables[0].Rows.Count > 0)
                            {
                                if (ds.Tables[0].Rows.Count > 0)
                                {
                                    JGSession.Username = ds.Tables[0].Rows[0]["Username"].ToString().Trim();
                                    JGSession.UserPassword = ds.Tables[0].Rows[0]["Password"].ToString().Trim();
                                    Session[JG_Prospect.Common.SessionKey.Key.UserId.ToString()] = ds.Tables[0].Rows[0]["Id"].ToString().Trim();
                                    AdminId = ConfigurationManager.AppSettings["AdminUserId"].ToString();
                                    isvaliduser = UserBLL.Instance.chklogin(emailyahoo, txtpassword.Text);
                                }

                                if (isvaliduser > 0)
                                {
                                    JGSession.UserLoginId = emailyahoo;
                                    JGSession.GuIdAtLogin = Guid.NewGuid().ToString(); // Adding GUID for Audit Track
                                    //JGSession.UserPassword = txtpassword.Text.Trim();
                                    RememberMe();
                                    if (txtloginid.Text.Trim() == AdminId)
                                    {
                                        JGSession.AdminUserId = AdminId;
                                        JGSession.UserType = "Admin";
                                        Response.Redirect("~/Sr_App/home.aspx", true);
                                    }

                                    if (isvaliduser == 1)
                                    {
                                        JGSession.UserType = "Admin";
                                        Response.Redirect("~/Sr_App/home.aspx", true);
                                    }
                                    else if (isvaliduser == 2)
                                    {
                                        JGSession.UserType = "JSE";
                                        Response.Redirect("~/home.aspx", true);
                                    }
                                    else if (isvaliduser == 3)
                                    {
                                        JGSession.UserType = "SSE";
                                        Response.Redirect("~/Sr_App/home.aspx", true);
                                    }
                                    else if (isvaliduser == 4)
                                    {
                                        JGSession.UserType = "MM";
                                        Response.Redirect("~/home.aspx", true);
                                    }
                                    else if (isvaliduser == 5)
                                    {
                                        JGSession.UserType = "SM";
                                        Response.Redirect("~/Sr_App/home.aspx", true);
                                    }
                                    else if (isvaliduser == 6)
                                    {
                                        JGSession.UserType = "AdminSec";
                                        Response.Redirect("~/home.aspx", true);
                                    }
                                    else if (isvaliduser == 7)
                                    {
                                        JGSession.UserType = "Employee";
                                        Response.Redirect("~/home.aspx", true);
                                    }
                                }
                                else  // if installer
                                {
                                    ds = null;
                                    ds = InstallUserBLL.Instance.getInstallerUserDetailsByLoginId(txtloginid.Text.Trim());
                                    JGSession.Username = ds.Tables[0].Rows[0]["FristName"].ToString().Trim();
                                    JGSession.UserPassword = ds.Tables[0].Rows[0]["Password"].ToString().Trim();
                                    Session[JG_Prospect.Common.SessionKey.Key.UserId.ToString()] = ds.Tables[0].Rows[0]["Id"].ToString().Trim();
                                    string AdminInstallerId = ConfigurationManager.AppSettings["AdminUserId"].ToString();
                                    int IsValidInstallerUser = InstallUserBLL.Instance.IsValidInstallerUser(txtloginid.Text.Trim(), txtpassword.Text);
                                    if (IsValidInstallerUser > 0)
                                    {
                                        JGSession.UserLoginId = txtloginid.Text.Trim();
                                        JGSession.GuIdAtLogin = Guid.NewGuid().ToString(); // Adding GUID for Audit Track

                                        //JGSession.UserPassword = txtpassword.Text.Trim();
                                        if (txtloginid.Text.Trim() == AdminInstallerId)
                                        {
                                            JGSession.AdminUserId = AdminInstallerId;
                                        }
                                        JGSession.UserType = "Installer";
                                        RememberMe();
                                        Response.Redirect("~/Installer/InstallerHome.aspx", true);
                                    }
                                    //else
                                    //{
                                    //    JGSession.UserLoginId = null;
                                    //    ScriptManager.RegisterStartupScript(this, this.GetType(), "AlertBox", "alert('Please enter a valid Loginid and password!');", true);
                                    //}
                                }
                            }
                            else
                            {
                                string username = emailyahoo;
                                //string password = txtSignupPassword.Text;
                                string password = "";
                                try
                                {
                                    InstallUserBLL.Instance.AddUserFB(username);
                                    btnSignUp.Visible = false;
                                    Response.Redirect("~/home.aspx", true);
                                    //SendActivationLink(username);
                                    //ScriptManager.RegisterStartupScript(this, this.GetType(), "alert", "alert('Your account is successfully created')", true);
                                }
                                catch (Exception ex)
                                {

                                }
                            }
                        }
                        JGSession.IsMicrosoft = false;
                    }
                    catch (Exception ex)
                    {
                        //logErr.writeToLog(ex, this.Page.ToString(), Request.ServerVariables["remote_addr"].ToString());
                        ScriptManager.RegisterStartupScript(this, this.GetType(), "AlertBox", "alert('Please enter a valid Loginid and password!');", true);
                        //  Response.Redirect("ErrorPage.aspx");
                        JGSession.IsMicrosoft = false;
                    }
                }
                #endregion

                //if (!JGSession.IsActive)
                {
                    //if (JGSession.IsCustomer)
                    //{
                    //    rdCustomer.Checked = true;
                    //    rdSalesIns.Checked = false;
                    //    rdUserType_CheckedChanged(rdCustomer, e);
                    //}
                    //else
                    //{
                    //    rdCustomer.Checked = false;
                    //    rdSalesIns.Checked = true;
                    //    rdUserType_CheckedChanged(rdSalesIns, e);
                    //}

                    txtloginid.Text = JGSession.UserLoginId;
                    txtpassword.Text = JGSession.UserPassword;
                    txtpassword.Attributes.Add("value", JGSession.UserPassword);

                    if (!string.IsNullOrEmpty(txtloginid.Text) && !string.IsNullOrEmpty(txtpassword.Text))
                    {
                        btnsubmit_Click(sender, e);
                    }
                }

                // Auto login from Free Project Quote Flow
                //Modified By Yogesh Keraliya
                // Check if request is coming from www.jmgroveconstruction.com's Employment page, for new applicant user.
                Uri UrlReferer = Request.UrlReferrer;

                CommonFunction.UpdateLog("URL Referal is: ");
                if (UrlReferer != null)
                {
                    CommonFunction.UpdateLog(UrlReferer.Host);
                    CommonFunction.UpdateLog(UrlReferer.AbsoluteUri);
                }

                if (UrlReferer != null && UrlReferer.Host.Contains("jmgroveconstruction.com"))
                {
                    // New user request : Welcome email and Login
                    if (!string.IsNullOrEmpty(Request.QueryString["ID"]) && !string.IsNullOrEmpty(Request.QueryString["Email"]))
                    {
                        CommonFunction.UpdateLog("Reached Query String check");
                        CheckForNewCustomerFromOtherSite(Convert.ToString(Request.QueryString["Email"]), Convert.ToInt32(Request.QueryString["ID"]));
                    }
                }

            }
        }


        #endregion

        #region '-- Control Events --'

        protected void btnsubmit_Click(object sender, EventArgs e)
        {
            try
            {
                JGSession.DesignationId = 0;
                string strRedirectUrl = string.Empty;
                int isvaliduser = 0;
                DataSet ds = new DataSet();
                //if (rdSalesIns.Checked)
                //{

                //    ds = UserBLL.Instance.getUser(txtloginid.Text.Trim());
                //    string AdminId = string.Empty;
                //    if (ds.Tables[0].Rows.Count > 0)
                //    {
                //        JGSession.Username = ds.Tables[0].Rows[0]["Username"].ToString().Trim();
                //        //JGSession.UserProfileImg = ds.Tables[0].Rows[0]["Picture"].ToString().Trim();
                //        Session[JG_Prospect.Common.SessionKey.Key.UserId.ToString()] = ds.Tables[0].Rows[0]["Id"].ToString().Trim();
                //        AdminId = ConfigurationManager.AppSettings["AdminUserId"].ToString();
                //        JGSession.Designation = ds.Tables[0].Rows[0]["Designation"].ToString().Trim();
                //        if (!string.IsNullOrEmpty(ds.Tables[0].Rows[0]["DesignationId"].ToString()))
                //        {
                //            JGSession.DesignationId = Convert.ToInt32(ds.Tables[0].Rows[0]["DesignationId"].ToString().Trim());
                //        }
                //        isvaliduser = UserBLL.Instance.chklogin(txtloginid.Text.Trim(), txtpassword.Text);
                //    }

                //    if (isvaliduser > 0)
                //    {
                //        JGSession.IsInstallUser = false;

                //        #region 'Admin User'

                //        JGSession.UserLoginId = txtloginid.Text.Trim();
                //        JGSession.GuIdAtLogin = Guid.NewGuid().ToString(); // Adding GUID for Audit Track
                //        JGSession.UserPassword = txtpassword.Text.Trim();
                //        RememberMe();

                //        #region Redirect to home Or Sr_App/home

                //        if (txtloginid.Text.Trim() == AdminId)
                //        {
                //            JGSession.AdminUserId = AdminId;
                //            JGSession.UserType = "Admin";
                //            // strRedirectUrl = "~/Sr_App/home.aspx";
                //            strRedirectUrl = "~/Sr_App/GoogleCalendarView.aspx?lastpage=login";
                //        }
                //        else if (isvaliduser == 1)
                //        {
                //            JGSession.UserType = "Admin";
                //            // strRedirectUrl = "~/Sr_App/home.aspx";
                //            strRedirectUrl = "~/Sr_App/GoogleCalendarView.aspx?lastpage=login";
                //        }
                //        else if (isvaliduser == 2)
                //        {
                //            JGSession.UserType = "JSE";
                //            strRedirectUrl = "~/home.aspx";
                //        }
                //        else if (isvaliduser == 3)
                //        {
                //            JGSession.UserType = "SSE";
                //            strRedirectUrl = "~/Sr_App/home.aspx";
                //        }
                //        else if (isvaliduser == 4)
                //        {
                //            JGSession.UserType = "MM";
                //            strRedirectUrl = "~/home.aspx";
                //        }
                //        else if (isvaliduser == 5)
                //        {
                //            JGSession.UserType = "SM";
                //            strRedirectUrl = "~/Sr_App/home.aspx";
                //        }
                //        else if (isvaliduser == 6)
                //        {
                //            JGSession.UserType = "AdminSec";
                //            strRedirectUrl = "~/home.aspx";
                //        }
                //        else if (isvaliduser == 7)
                //        {
                //            JGSession.UserType = "Employee";
                //            strRedirectUrl = "~/home.aspx";
                //        }

                //        #endregion

                //        #endregion
                //    }
                //    else // added this else clause if user is admin and found earlier.
                //    {
                //        JGSession.IsInstallUser = true;

                //        #region 'Install User'

                //        ds = InstallUserBLL.Instance.getInstallerUserDetailsByLoginId(txtloginid.Text.Trim());
                //        if (ds.Tables[0].Rows.Count > 0)
                //        {
                //            if (ds.Tables[0].Rows.Count > 0)
                //            {
                //                JGSession.Username = ds.Tables[0].Rows[0]["FristName"].ToString().Trim();
                //                Session[JG_Prospect.Common.SessionKey.Key.UserId.ToString()] = ds.Tables[0].Rows[0]["Id"].ToString().Trim();
                //                // Session["UserTypeNew"] = ds.Tables[0].Rows[0]["usertype"].ToString().Trim();
                //                JGSession.Designation = ds.Tables[0].Rows[0]["Designation"].ToString().Trim();
                //            }
                //            string AdminInstallerId = ConfigurationManager.AppSettings["AdminUserId"].ToString();
                //            int IsValidInstallerUser = InstallUserBLL.Instance.IsValidInstallerUser(txtloginid.Text.Trim(), txtpassword.Text);
                //            if (IsValidInstallerUser > 0)
                //            {
                //                JGSession.UserLoginId = txtloginid.Text.Trim();
                //                JGSession.GuIdAtLogin = Guid.NewGuid().ToString(); // Adding GUID for Audit Track
                //                JGSession.UserPassword = txtpassword.Text.Trim();


                //                if (txtloginid.Text.Trim() == AdminInstallerId)
                //                {
                //                    JGSession.AdminUserId = AdminInstallerId;
                //                }

                //                JGSession.UserType = "Installer";

                //                RememberMe();

                //                if (Convert.ToString(JGSession.Designation) != "")
                //                {
                //                    #region Redirect to home Or Sr_App/home Or Installer/InstallerHome

                //                    if (Convert.ToString(JGSession.Designation) == "Jr. Sales" || Convert.ToString(JGSession.Designation) == "Jr Project Manager")
                //                    {
                //                        strRedirectUrl = "~/home.aspx";
                //                    }
                //                    else if (Convert.ToString(JGSession.Designation) == "sales" || Convert.ToString(JGSession.Designation).Trim() == "Admin Recruiter" || Convert.ToString(JGSession.Designation) == "SalesUser" || Convert.ToString(JGSession.Designation) == "SSE")
                //                    {
                //                        strRedirectUrl = "~/Sr_App/home.aspx";
                //                    }
                //                    else if (Convert.ToString(JGSession.Designation) == "Sr. Sales" || Convert.ToString(JGSession.Designation) == "Admin" || Convert.ToString(JGSession.Designation) == "Office Manager" || Convert.ToString(JGSession.Designation) == "Recruiter" || Convert.ToString(JGSession.Designation) == "Sales Manager" || Convert.ToString(JGSession.Designation).Contains("IT"))
                //                    {
                //                        if (Convert.ToString(JGSession.Designation) == "Admin" || Convert.ToString(JGSession.Designation) == "Recruiter" || Convert.ToString(JGSession.Designation) == "Office Manager")
                //                        {
                //                            strRedirectUrl = "~/Sr_App/GoogleCalendarView.aspx?lastpage=login";
                //                        }
                //                        else
                //                        {
                //                            strRedirectUrl = "~/Sr_App/home.aspx";
                //                        }

                //                    }
                //                    else if (Convert.ToString(JGSession.Designation).StartsWith("Installer"))
                //                    {
                //                        Response.Redirect("~/Installer/InstallerHome.aspx", false);
                //                    }
                //                    else if (Convert.ToString(JGSession.Designation) == "SSE")
                //                    {
                //                        strRedirectUrl = "~/Sr_App/home.aspx";
                //                    }
                //                    else if (Convert.ToString(JGSession.Designation) == "Forman" || Convert.ToString(JGSession.Designation) == "ForeMan")
                //                    {
                //                        strRedirectUrl = "~/Installer/InstallerHome.aspx";
                //                    }
                //                    else if (Convert.ToString(JGSession.Designation) == "SubContractor")
                //                    {
                //                        strRedirectUrl = "~/Installer/InstallerHome.aspx";
                //                    }
                //                    else
                //                    {
                //                        strRedirectUrl = "~/Installer/InstallerHome.aspx";
                //                    }

                //                    #endregion
                //                }
                //                else if (Convert.ToString(JGSession.Designation) == "Installer")
                //                {
                //                    strRedirectUrl = "~/Installer/InstallerHome.aspx";
                //                }
                //                else if (Convert.ToString(JGSession.Designation) == "Jr. Sales")
                //                {
                //                    strRedirectUrl = "~/home.aspx";
                //                }
                //                else if (Convert.ToString(JGSession.Designation) == "SSE")
                //                {
                //                    strRedirectUrl = "~/Sr_App/home.aspx";
                //                }
                //                else if (Convert.ToString(JGSession.Designation) == "Forman" || Convert.ToString(JGSession.Designation) == "ForeMan")
                //                {
                //                    strRedirectUrl = "~/Installer/InstallerHome.aspx";
                //                }
                //                else
                //                {
                //                    // Response.Redirect("~/Installer/InstallerHome.aspx");//
                //                }
                //            }
                //            else
                //            {
                //                JGSession.UserLoginId = null;
                //                JGSession.GuIdAtLogin = null;
                //                ScriptManager.RegisterStartupScript(this, this.GetType(), "AlertBox", "alert('Check the UserName,password or its status to login.');", true);
                //            }
                //        }
                //        #endregion
                //    }

                //    // redirects user to the last accessed page.
                //    if (!string.IsNullOrEmpty(strRedirectUrl))
                //    {
                //        if (!string.IsNullOrEmpty(Request.QueryString["returnurl"]))
                //        {
                //            if (strRedirectUrl.ToLower().Contains("sr_app") && Request.QueryString["returnurl"].ToLower().Contains("sr_app"))
                //            {
                //                strRedirectUrl = HttpUtility.UrlDecode(Request.Url.Query.Replace("?returnurl=", ""));
                //            }
                //            else if (!strRedirectUrl.ToLower().Contains("sr_app") && !Request.QueryString["returnurl"].ToLower().Contains("sr_app"))
                //            {
                //                strRedirectUrl = HttpUtility.UrlDecode(Request.Url.Query.Replace("?returnurl=", ""));
                //            }
                //        }
                //        Response.Redirect(strRedirectUrl);
                //    }
                //    else
                //    {
                //        JGSession.UserLoginId = null;
                //        JGSession.GuIdAtLogin = null;
                //        ScriptManager.RegisterStartupScript(this, this.GetType(), "AlertBox", "alert('Check the UserName,password or its status to login.');", true);
                //    }
                //}
                //else if (rdCustomer.Checked)
                //{
                    #region Customer User

                    ds = null;
                    ds = InstallUserBLL.Instance.getCustomerUserLogin(txtloginid.Text.Trim(), txtpassword.Text.Trim());
                    if (ds.Tables[0].Rows.Count > 0)
                    {
                        if (Convert.ToString(ds.Tables[0].Rows[0][0]) != "")
                        {
                            JGSession.UserLoginId = txtloginid.Text.Trim();
                            JGSession.GuIdAtLogin = Guid.NewGuid().ToString(); // Adding GUID for Audit Track
                            JGSession.UserPassword = txtpassword.Text.Trim();
                            JGSession.Username = ds.Tables[0].Rows[0]["CustomerName"].ToString();
                            Session[JG_Prospect.Common.SessionKey.Key.UserId.ToString()] = ds.Tables[0].Rows[0]["Id"].ToString().Trim();
                            // Response.Redirect("~/Customer_Panel.aspx?Cust_Id=" + Convert.ToString(ds.Tables[0].Rows[0][0]), false);
                            // Response.Redirect("50.191.13.206/JGP/Customer_Panel.aspx?Cust_Id=" + Convert.ToString(ds.Tables[0].Rows[0][0]), false);
                            // Uri url = new Uri("http://50.191.13.206:82/JGP/Customer_Panel.aspx");                          
                            Uri uri = Context.Request.Url;
                            string host = uri.Scheme + Uri.SchemeDelimiter + uri.Host + ":82";
                            //  Response.Redirect(host + "/JGP/Customer_Panel.aspx?Cust_Id=" + Convert.ToString(ds.Tables[0].Rows[0][0]), false);
                            JGSession.IsCustomer = true;
                            if (ds.Tables[0].Rows[0]["IsFirstTime"] != null && ds.Tables[0].Rows[0]["IsFirstTime"].ToString().ToLower() == "true")
                            {
                                JGSession.IsFirstTime = true;
                            }

                            //TODO: When full flow will be implemented customer will be redirected to change password first if they are first time registered with us.
                            //if (JGSession.IsFirstTime == true)
                            //{
                            //    Response.Redirect("~/changepassword.aspx", false);
                            //}
                            //else
                            //{
                                Response.Redirect("~/Customer_Panel.aspx?Cust_Id=" + Convert.ToString(ds.Tables[0].Rows[0][0]), false);
                                //Response.Redirect("~/Sr_App/Customer_Profile.aspx?CustomerId=" + Convert.ToString(ds.Tables[0].Rows[0][0]), false);
                            //}
                        }
                    }
                    else
                    {
                        JGSession.UserLoginId = null;
                        JGSession.GuIdAtLogin = null;
                        //ScriptManager.RegisterStartupScript(this, this.GetType(), "AlertBox", "alert('User Name or Password is incorrect');", true);
                        ScriptManager.RegisterStartupScript(this, this.GetType(), "AlertBox", "loginFailMessage();", true);
                    }

                    #endregion
               // }
            }
            catch (Exception ex)
            {
                //logErr.writeToLog(ex, this.Page.ToString(), Request.ServerVariables["remote_addr"].ToString());
                //ScriptManager.RegisterStartupScript(this, this.GetType(), "AlertBox", "alert('Please enter a valid Loginid and password!');", true);
                ScriptManager.RegisterStartupScript(this, this.GetType(), "AlertBox", "loginFailMessage();", true);
                //  Response.Redirect("ErrorPage.aspx");
            }
        }

        protected void lblForgotUserId_Click(object sender, EventArgs e)
        {
            Response.Redirect("ForgotuserId.aspx");
        }

        protected void lnkForgotPassword_Click(object sender, EventArgs e)
        {
            //forgotpassword.Show();
            Response.Redirect("ForgotPassword.aspx");
        }

        protected void btnSignUp_Click(object sender, EventArgs e)
        {
            string username = txtSignupEmail.Text;
            string password = txtSignupPassword.Text;
            string PhoneNo = txtPhoneNumber.Text;
            string DOB = "";//txtDateOfBith.Text;
            try
            {
                if (rdoEmp.Checked)
                {
                    DataSet ds = InstallUserBLL.Instance.CheckRegistration(username, PhoneNo);
                    if (ds.Tables[0].Rows.Count > 0)
                    {
                        ScriptManager.RegisterStartupScript(this, this.GetType(), "alert", "alert('User name or phone number already exists')", true);
                        return;
                    }
                    else
                    {
                        InstallUserBLL.Instance.AddUser(username, password, PhoneNo, DOB);
                        btnSignUp.Visible = false;
                        SendActivationLink(username);
                        ScriptManager.RegisterStartupScript(this, this.GetType(), "alert", "alert('Your account is successfully created')", true);
                        return;
                    }
                }
                else if (rdoCustomer.Checked)
                {
                    DataSet ds = InstallUserBLL.Instance.CheckCustomerRegistration(username, PhoneNo);
                    if (ds.Tables[0].Rows.Count > 0)
                    {
                        ScriptManager.RegisterStartupScript(this, this.GetType(), "alert", "alert('User name or phone number already exists')", true);
                        return;
                    }
                    else
                    {
                        InstallUserBLL.Instance.AddCustomer(username, password, PhoneNo, DOB);
                        btnSignUp.Visible = false;
                        SendActivationLink(username);

                        //Clear All field after registration....
                        txtSignupEmail.Text = string.Empty;
                        txtPhoneNumber.Text = string.Empty;
                        txtSignupPassword.Text = string.Empty;
                        txtSignupCPassword.Text = string.Empty;
                        //txtDateOfBith.Text = string.Empty;
                        ScriptManager.RegisterStartupScript(this, this.GetType(), "alert", "alert('Your account is successfully created')", true);
                        return;
                    }
                }
            }
            catch (Exception ex)
            {
                ScriptManager.RegisterStartupScript(this, this.GetType(), "alert", "alert('Your account is successfully created')", true);
                return;
            }
        }

        protected void btnSubForgotPassword_Click(object sender, EventArgs e)
        {

        }

        protected void btnForgotEmail_Click(object sender, EventArgs e)
        {
            //string password = "";
            //password = InstallUserBLL.Instance.GetPassword(txtFPEmail.Text);
            //if (password != "")
            //{
            //    string str_Body = "<table><tr><td>Hello,</td></tr><tr><td>your password for the GM Grove Construction is:" + password;
            //    str_Body = str_Body + "</td></tr>";
            //    str_Body = str_Body + "<tr><td></td></tr>";
            //    str_Body = str_Body + "<tr><td>Thanks & Regards.</td></tr>";
            //    str_Body = str_Body + "<tr><td>JM Grove Constructions</td></tr></table>";
            //    using (MailMessage mm = new MailMessage("hr@jmgrove.com", txtFPEmail.Text))
            //    {
            //        mm.Subject = "Foreman Job Acceptance";
            //        mm.Body = str_Body;
            //        mm.IsBodyHtml = false;
            //        SmtpClient smtp = new SmtpClient();
            //        smtp.Host = "smtp.gmail.com";
            //        smtp.EnableSsl = true;
            //        NetworkCredential NetworkCred = new NetworkCredential("Customsofttest@gmail.com", "customsoft567");
            //        smtp.UseDefaultCredentials = true;
            //        smtp.Credentials = NetworkCred;
            //        smtp.Port = 587;
            //        smtp.Send(mm);
            //        //ClientScript.RegisterStartupScript(GetType(), "alert", "alert('Email sent.');", true);
            //    }
            //    ScriptManager.RegisterStartupScript(this, this.GetType(), "alert", "alert('Password send to your registered email id.')", true);
            //    forgotpassword.Hide();
            //    return;
            //}
            //else
            //{
            //    ScriptManager.RegisterStartupScript(this, this.GetType(), "alert", "alert('Email Id does not exists.')", true);
            //    forgotpassword.Hide();
            //    return;
            //}
        }

        protected void ImageButton1_Click(object sender, ImageClickEventArgs e)
        {
            JGSession.IsFacebook = true;
            FaceBookConnect.Authorize("user_photos,email", Request.Url.AbsoluteUri.Split('?')[0]);
        }

        protected void ImageButton2_Click(object sender, ImageClickEventArgs e)
        {
            JGSession.IsGooglePlus = true;
            GoogleConnect.Authorize("profile", "email");
        }

        protected void ImageButton3_Click(object sender, ImageClickEventArgs e)
        {
            if (!TwitterConnect.IsAuthorized)
            {
                TwitterConnect twitter = new TwitterConnect();
                twitter.Authorize(Request.Url.AbsoluteUri.Split('?')[0]);
            }
        }

        protected void ImageButton5_Click(object sender, ImageClickEventArgs e)
        {
            JGSession.IsMicrosoft = true;
            string appId = "00000000481C1797";
            string appSecrets = "cec1ShT5FFjexbtm08qv0w8";
            string returnUrl = Request.Url.AbsoluteUri.Split('?')[0];

            MicrosoftClient ms = new DotNetOpenAuth.AspNet.Clients.MicrosoftClient(appId, appSecrets);
            Uri authUrl = new Uri(returnUrl);
            var httpContextBase = new HttpContextWrapper(HttpContext.Current);
            ms.RequestAuthentication(httpContextBase, authUrl);
        }

        protected void ImageButton4_Click(object sender, ImageClickEventArgs e)
        {
            JGSession.IsYahoo = true;
            string consumerKey = ConfigurationManager.AppSettings["YahooConsumerKey"];
            string consumerSecret = ConfigurationManager.AppSettings["YahooConsumerSecret"];
            string returnUrl = Request.Url.AbsoluteUri.Split('?')[0];

            YahooOpenIdClient yahoo = new DotNetOpenAuth.AspNet.Clients.YahooOpenIdClient();
            Uri authUrl = new Uri(returnUrl);
            var httpContextBase = new HttpContextWrapper(HttpContext.Current);
            yahoo.RequestAuthentication(httpContextBase, authUrl);
        }

        protected void rdUserType_CheckedChanged(object sender, EventArgs e)
        {
            string returnUrl = string.Empty;
            if (!string.IsNullOrEmpty(Request.QueryString["returnurl"]))
            {
                returnUrl = HttpUtility.UrlDecode(Request.Url.Query);
            }

            RadioButton rb = (RadioButton)sender;
            string pageName = Path.GetFileName(Request.Url.AbsolutePath);
            if (rb.Text == "Customer" && pageName == "stafflogin.aspx")
            {
                Response.Redirect("login.aspx" + returnUrl, false);
            }
            if (rb.Text == "Staff" && pageName == "login.aspx")
            {
                Response.Redirect("stafflogin.aspx" + returnUrl, false);
            }
        }

        #endregion

        #region '-- Methods --'


        private void CheckForNewCustomerFromOtherSite(string UserEmail, int CustomerID)
        {
            Boolean blnIsNewCustomer = new_customerBLL.Instance.CheckForNewCustomerByEmaiID(UserEmail);

            if(blnIsNewCustomer)
            {

                CommonFunction.UpdateLog("FirstTime user check passed");

                //DataSet ds = InstallUserBLL.Instance.getuserdetails(UserID);
                //DataRow drUser = null;
                //if (ds != null && ds.Tables.Count > 0 && ds.Tables[0].Rows.Count > 0)
                //{
                //drUser = ds.Tables[0].Rows[0];

                //string strName = Convert.ToString(drUser["FristName"]) + " " + Convert.ToString(drUser["Lastname"]);
                //string strUserDesignation = Convert.ToString(drUser["Designation"]);
                //string strUserDesignationId = Convert.ToString(drUser["DesignationId"]);
                //string strUserEmail = Convert.ToString(drUser["Email"]);
                //string strUserPhone = Convert.ToString(drUser["Phone"]);

                //string strDesignationCode = JG_Prospect.App_Code.CommonFunction.GetDesignationCode((JGConstant.DesignationType)Convert.ToByte(strUserDesignationId));

                //InstallUserBLL.Instance.SetUserDisplayID(UserID, strDesignationCode, "YES");

                //TODO: Send AUTO Email
                // SendWelcomeEmail(strUserEmail, UserID, strName, strUserDesignation, strUserDesignationId, strUserPhone);

                //string strPopupText = "";
                //strPopupText += "You have successfully been entered into JMGrove Customer Database and should have also received an email with login details. ";
                //strPopupText += "Your username is the phone #: {0} or Email: {1} you have entered, your default password is \"jmgrove\". ";
                //strPopupText += "Select continue to proceed with application process or cancel. Save your username and password for future use. ";
                //strPopupText = string.Format(strPopupText, strUserPhone, strUserEmail);

                string strPopupText = "";
                strPopupText += "You have successfully been entered into JMGrove Customer Database. ";
                strPopupText += "Your username is the Email: {0} you have entered, your default password is \"jmgrove\". ";
                strPopupText += "Select continue to proceed to your personalised dashboard. Save your username and password for future use. ";
                strPopupText = string.Format(strPopupText, UserEmail);
                

                Page.ClientScript.RegisterStartupScript
                            (
                                Page.GetType(),
                                "TheConfirm_Ok_Cancel",
                                string.Format(
                                                "TheConfirm_Ok_Cancel('{0}',{1},{2},'{3}');",
                                                strPopupText,
                                                String.Concat("\"", UserEmail, "^", JG_Prospect.Common.JGConstant.Default_PassWord, "\""),
                                                "function () {}",
                                                "Customer Login Guidance"
                                             ),
                                true
                            );
                //}
            }
        }

        private string Encrypt(string clearText)
        {
            string EncryptionKey = "MAKV2SPBNI99212";
            byte[] clearBytes = Encoding.Unicode.GetBytes(clearText);
            using (Aes encryptor = Aes.Create())
            {
                Rfc2898DeriveBytes pdb = new Rfc2898DeriveBytes(EncryptionKey, new byte[] { 0x49, 0x76, 0x61, 0x6e, 0x20, 0x4d, 0x65, 0x64, 0x76, 0x65, 0x64, 0x65, 0x76 });
                encryptor.Key = pdb.GetBytes(32);
                encryptor.IV = pdb.GetBytes(16);
                using (MemoryStream ms = new MemoryStream())
                {
                    using (CryptoStream cs = new CryptoStream(ms, encryptor.CreateEncryptor(), CryptoStreamMode.Write))
                    {
                        cs.Write(clearBytes, 0, clearBytes.Length);
                        cs.Close();
                    }
                    clearText = Convert.ToBase64String(ms.ToArray());
                }
            }
            return clearText;
        }

        public void RememberMe()
        {
            if (chkRememberMe.Checked)
            {
                Response.Cookies["UserName"].Expires = DateTime.Now.AddDays(30);
                Response.Cookies["Password"].Expires = DateTime.Now.AddDays(30);
            }
            else
            {
                Response.Cookies["UserName"].Expires = DateTime.Now.AddDays(-1);
                Response.Cookies["Password"].Expires = DateTime.Now.AddDays(-1);

            }
            Response.Cookies["UserName"].Value = txtloginid.Text.Trim();
            Response.Cookies["Password"].Value = txtpassword.Text.Trim();
        }

        private void SendActivationLink(string username)
        {
            string str_Body = "";
            string activationLink = "";
            string strEmailId = System.Configuration.ConfigurationManager.AppSettings["ForgotPassEmail"].ToString();
            string strPass = System.Configuration.ConfigurationManager.AppSettings["ForgotPass"].ToString();
            username = HttpUtility.UrlEncode(Encrypt(username));
            str_Body = "Hello,</br></br>Your registration to the JM Grove Construction is successful.To activate your account click on the following link</br>";
            activationLink = System.Configuration.ConfigurationManager.AppSettings["Activation"].ToString() + "?UserId=" + username;
            str_Body = str_Body + "<a href = '" + activationLink + "'>Click here to activate your account.</a>";
            str_Body = str_Body + "</br></br>Thanks & Regards";
            str_Body = str_Body + "</br></br>JM Grove Constructions";
            //using (MailMessage mm = new MailMessage("hr@jmgrove.com", txtSignupEmail.Text.Trim()))
            using (MailMessage mm = new MailMessage(strEmailId, txtSignupEmail.Text))
            {
                mm.Subject = "JM Grove Construction:Forgot Password";
                mm.Body = str_Body;
                mm.IsBodyHtml = true;
                SmtpClient smtp = new SmtpClient();
                //smtp.Host = "mail.jmgroveconstruction.com";
                smtp.Host = "smtp.gmail.com";
                smtp.EnableSsl = true;
                NetworkCredential NetworkCred = new NetworkCredential(strEmailId, strPass);
                smtp.UseDefaultCredentials = true;
                smtp.Credentials = NetworkCred;
                //smtp.Port = 25;
                smtp.Port = 25;
                smtp.Send(mm);
                //ClientScript.RegisterStartupScript(GetType(), "alert", "alert('Email sent.');", true);
            }
        }

        #endregion

        #region '-- Classes --'
        public class GoogleProfile
        {
            public string Id { get; set; }
            public string DisplayName { get; set; }
            public Image Image { get; set; }
            public List<Email> Emails { get; set; }
            public string Gender { get; set; }
            public string ObjectType { get; set; }
        }

        public class Email
        {
            public string Value { get; set; }
            public string Type { get; set; }
        }

        public class Image
        {
            public string Url { get; set; }
        }
        #endregion
    }
}

public class FaceBookUser
{
    public string Id { get; set; }
    public string Name { get; set; }
    public string UserName { get; set; }
    public string PictureUrl { get; set; }
    public string Email { get; set; }
}
