using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using JG_Prospect.BLL;
using JG_Prospect.Common;
using JG_Prospect.Common.modal;

namespace JG_Prospect.Sr_App
{
    public partial class ChatHistory : System.Web.UI.Page
    {
        public List<ActiveUser> users;
        protected void Page_Load(object sender, EventArgs e)
        {
            users = ChatBLL.Instance.GetAllChatHistory().Results;
        }
    }
}