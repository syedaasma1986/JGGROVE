using JG_Prospect.App_Code;
using JG_Prospect.Common;
using Microsoft.AspNet.SignalR;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Routing;
using System.Web.Security;
using System.Web.SessionState;

namespace JG_Prospect
{
    public class Global : System.Web.HttpApplication
    {

        //void Application_AuthenticateRequest(object sender, EventArgs e)
        //{
        //    if (!JGSession.IsActive)
        //    {
        //        if (Request.Url.AbsolutePath.EndsWith(".aspx") && !Request.Url.AbsolutePath.EndsWith("login.aspx"))
        //        {
        //            Response.Redirect("~/login.aspx?returnurl=" + Request.Url.PathAndQuery);
        //        }
        //    }
        //}

        void Application_Start(object sender, EventArgs e)
        {
            // Code that runs on application startup

            
        }

        void Application_End(object sender, EventArgs e)
        {
            //  Code that runs on application shutdown

        }

        void Application_Error(object sender, EventArgs e)
        {
            CommonFunction.SendExceptionEmail(Context.Error);
        }

   
        void Session_Start(object sender, EventArgs e)
        {
            // Code that runs when a new session is started
            JGSession.StartDateTime = DateTime.Now;
        }

        void Session_End(object sender, EventArgs e)
        {
            // Code that runs when a session ends. 
            // Note: The Session_End event is raised only when the sessionstate mode
            // is set to InProc in the Web.config file. If session mode is set to StateServer 
            // or SQLServer, the event is not raised.

        }

    }
}
