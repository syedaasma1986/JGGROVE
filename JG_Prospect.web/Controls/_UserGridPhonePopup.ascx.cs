using JG_Prospect.BLL;
using JG_Prospect.Common;
using JG_Prospect.Utilits;
using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using static JG_Prospect.Common.JGCommon;
using static JG_Prospect.Common.JGConstant;

namespace JG_Prospect.Controls
{
    public partial class _UserGridPhonePopup : System.Web.UI.UserControl
    {
        public string loggedInUsername;
        public string loggedInUserInstallId;
        public List<EnumWitAttributes> userStatuses;
        public List<EnumWitAttributes> userSecondaryStatuses;
        public List<UserDesignation> userDesignations;
        public List<FilterDesignation> filterDesignations;
        public List<UserAddedBy> userAddedBy;
        public List<UserSource> sources;
        public Dictionary<int, string> employmentTypes;
        public Dictionary<int, string> dsPhoneType;
        public bool IsManager;
        protected void Page_Load(object sender, EventArgs e)
        {
            IsManager = InstallUserBLL.Instance.IsManager(JGSession.UserId);
            filterDesignations = new List<FilterDesignation>();
            DataSet dsDesignation = DesignationBLL.Instance.GetAllDesignationsForHumanResource();
            if (dsDesignation.Tables.Count > 0)
            {
                foreach (DataRow item in dsDesignation.Tables[0].Rows)
                {
                    filterDesignations.Add(new FilterDesignation
                    {
                        Id = Convert.ToInt32(item["ID"]),
                        DesignationName = item["DesignationName"].ToString()
                    });
                }
            }
            userStatuses = Extensions.GetListOf<InstallUserStatus>(); //FullDropDown.GetUserStatuses(false);
            userSecondaryStatuses = Extensions.GetListOf<UserSecondaryStatus>();

            userDesignations = FullDropDown.GetUserDesignation(null);

            userAddedBy = InstallUserBLL.Instance.GeAddedBytUsersFormatted();
            sources = InstallUserBLL.Instance.GetSourceList();
            employmentTypes = Extensions.ToDictionary<EmploymentType>();
            var rows = InstallUserBLL.Instance.GetAllUserPhoneType().Tables[0].Rows;
            dsPhoneType = new Dictionary<int, string>();
            foreach (DataRow item in rows)
            {
                dsPhoneType.Add(Convert.ToInt32(item["UserContactID"].ToString()), item["ContactName"].ToString());
            }
            
        }
    }
}