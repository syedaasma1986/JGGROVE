using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Xml.Linq;

namespace JG_Prospect
{
    public partial class callingXML : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            string number = Request["to"].ToString();
            string xml = "<Response><Dial callerId=\"12154833098\"><Number>{number}</Number></Dial></Response>"
                                .Replace("{number}", number);
            XDocument xd = XDocument.Parse(xml);
            Response.ContentType = "text/xml"; //Must be 'text/xml'
            Response.ContentEncoding = System.Text.Encoding.UTF8; //We'd like UTF-8
            Response.Write(xd.ToString()); ;
        }
    }
}