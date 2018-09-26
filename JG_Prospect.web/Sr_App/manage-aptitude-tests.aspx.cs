using JG_Prospect.App_Code;
using JG_Prospect.BLL;
using JG_Prospect.Common.modal;
using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Text;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace JG_Prospect.Sr_App
{
    public partial class manage_aptitude_tests : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            CommonFunction.AuthenticateUser();

            if (!IsPostBack)
            {
                FillddlDesignation();
                FillrepExams();
            }
        }

        private void FillddlDesignation()
        {
            List<Designation> lstDesignations = DesignationBLL.Instance.GetAllDesignation();
            if (lstDesignations != null && lstDesignations.Any())
            {
                ddlDesigAptitude.Items.Clear();
                ddlDesigAptitude.DataSource = lstDesignations;
                ddlDesigAptitude.DataTextField = "DesignationName";
                ddlDesigAptitude.DataValueField = "ID";
                ddlDesigAptitude.DataBind();

                //ddlDesignation.DataSource = lstDesignations;
                //ddlDesignation.DataTextField = "DesignationName";
                //ddlDesignation.DataValueField = "ID";
                //ddlDesignation.DataBind();
            }
            //ddlDesignation.Items.Insert(0, new ListItem("--All--", "0"));
        }

        private void FillrepExams()
        {
            string desigID = GetSelectedDesignationsString(ddlDesigAptitude);

            DataTable dtExams = null;
            //if (ddlDesignation.SelectedValue == "0")
            //{
            //    dtExams = AptitudeTestBLL.Instance.GetMCQ_Exams(null);
            //}
            //else
            //{
            dtExams = AptitudeTestBLL.Instance.GetMCQ_Exams(desigID);
            //}

            grdExams.DataSource = dtExams;
            grdExams.DataBind();

            upExams.Update();
        }

        protected void ddlDesignation_SelectedIndexChanged(object sender, EventArgs e)
        {
            FillrepExams();
        }

        protected void ddlDesigAptitude_SelectedIndexChanged(object sender, EventArgs e)
        {
            string designations = GetSelectedDesignationsString(ddlDesigAptitude);

            FillrepExams();

            ddlDesigAptitude.Texts.SelectBoxCaption = "Select";
            foreach (ListItem item in ddlDesigAptitude.Items)
            {
                if (item.Selected)
                {
                    ddlDesigAptitude.Texts.SelectBoxCaption = item.Text;
                    break;
                }
            }
        }

        private string GetSelectedDesignationsString(Saplin.Controls.DropDownCheckBoxes drpChkBoxes)
        {
            String returnVal = string.Empty;
            StringBuilder sbDesignations = new StringBuilder();

            foreach (ListItem item in drpChkBoxes.Items)
            {
                if (item.Selected)
                {
                    sbDesignations.Append(String.Concat(item.Value, ","));
                }
            }

            if (sbDesignations.Length > 0)
            {
                returnVal = sbDesignations.ToString().Substring(0, sbDesignations.ToString().Length - 1);
            }

            return returnVal;
        }

        protected void grdExams_RowDataBound(object sender, GridViewRowEventArgs e)
        {
            if (e.Row.RowType == DataControlRowType.DataRow)
            {
                String DesignID = DataBinder.Eval(e.Row.DataItem, "DesignationID").ToString();

                if (!String.IsNullOrEmpty(DesignID))
                {
                    ListBox ddcbDesig = (ListBox)e.Row.FindControl("ddcbDesig");
                    String ExamID = DataBinder.Eval(e.Row.DataItem, "ExamID").ToString();

                    BindDesignationDropdown(DesignID, ddcbDesig,ExamID);
                }

            }
        }

        private void BindDesignationDropdown(string designID, ListBox ddcbDesig, String ExamID)
        {
            List<Designation> lstDesignations = (List<Designation>)ddlDesigAptitude.DataSource;

            if (lstDesignations != null && lstDesignations.Any())
            {
                ddcbDesig.Items.Clear();
                ddcbDesig.DataSource = lstDesignations;
                ddcbDesig.DataTextField = "DesignationName";
                ddcbDesig.DataValueField = "ID";
                ddcbDesig.DataBind();

                ddcbDesig.Attributes.Add("data-examid", ExamID);

                ddcbDesig.Attributes.Add("onchange", "javascript:EditTestsDesignations(this);");

            }

            String[] strDesignIds = designID.Split(new char[] { ',' }, StringSplitOptions.RemoveEmptyEntries);

            foreach (string DesignId in strDesignIds)
            {
                ListItem item = ddcbDesig.Items.FindByValue(DesignId);

                if (item != null)
                {
                    item.Selected = true;
                }
            }
        }
    }
}