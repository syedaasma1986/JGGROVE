using JG_Prospect.App_Code;
using JG_Prospect.BLL;
using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace JG_Prospect.Sr_App
{
    public partial class ITDashboardCalendar : System.Web.UI.Page
    {
        public static bool IsSuperUser = false;
        public int UserDesignationId = 0;

        protected void Page_Load(object sender, EventArgs e)
        {
            IsSuperUser = CommonFunction.CheckAdminAndItLeadMode();
            UserDesignationId = JGSession.DesignationId;
            //if (IsSuperUser)
            //{
            //    lblalertpopup.Visible = true;
            //    DataSet ds = TaskGeneratorBLL.Instance.GetFrozenNonFrozenTaskCount();
            //    if (ds != null && ds.Tables.Count > 0 && ds.Tables[0].Rows.Count > 0)
            //    {
            //        lblFrozenTaskCounter.InnerHtml = "Partial Frozen Tasks :<div class='badge1 badge-error' style='width:20px;'>" + ds.Tables[0].Rows[0][0].ToString() + "</div>";
            //        lblNonFrozenTaskCounter.InnerHtml = "Non Frozen Tasks :<div class='badge1 badge-error' style='width:20px;'>" + ds.Tables[1].Rows[0][0].ToString() + "</div>";
            //    }
            //}
            //else
            //{
            //    lblalertpopup.Visible = false;
            //}
        }
    }
}