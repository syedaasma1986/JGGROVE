using JG_Prospect.BLL;
using System;
using System.Collections.Generic;
using System.Data;
using System.IO;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace JG_Prospect.Sr_App
{
    public partial class ManageResources : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!Page.IsPostBack)
            {
                fillDropdown();
            }
        }

        private void fillDropdown()
        {
            DataSet dsDesignation = new DataSet();
            dsDesignation = DesignationBLL.Instance.GetAllDesignationsForHumanResource();
            if (dsDesignation != null && dsDesignation.Tables.Count > 0)
            {
                ddlDesignations.DataSource = dsDesignation.Tables[0];
                ddlDesignations.DataTextField = "DesignationName";
                ddlDesignations.DataValueField = "ID";
                ddlDesignations.DataBind();
            }

            ddlDesignations.Items.Insert(0, new ListItem("Select Designation", "0"));
        }

        private void Tst_Click(object sender, EventArgs e)
        {
            if (!string.IsNullOrEmpty(hdnBulkUploadFile.Value))
            {
                string strFilePath = Server.MapPath("~/UploadedExcel/" + hdnBulkUploadFile.Value.Split('^')[0].Split('@')[0]);

                string FileName = Path.GetFileName(strFilePath);
                string Extension = Path.GetExtension(strFilePath);

                if (File.Exists(strFilePath))
                {
                }
            }
                }
    }
}