using JG_Prospect.App_Code;
using JG_Prospect.BLL;
using JG_Prospect.Common;
using JG_Prospect.Common.modal;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace JG_Prospect.Sr_App
{
    public partial class edit_SMS_template : System.Web.UI.Page
    {
        protected HTMLTemplates? HTMLTemplate
        {
            get
            {
                HTMLTemplates objHTMLTemplate;
                if (Enum.TryParse<HTMLTemplates>(Request["MasterId"], out objHTMLTemplate))
                {
                    return objHTMLTemplate;
                }
                return null;
            }
        }

        //protected HTMLTemplateCategories? HTMLTemplateCategory
        //{
        //    get
        //    {
        //        HTMLTemplateCategories objHTMLTemplateCategory;
        //        if (Enum.TryParse<HTMLTemplateCategories>(Request["Category"], out objHTMLTemplateCategory))
        //        {
        //            return objHTMLTemplateCategory;
        //        }
        //        return null;
        //    }
        //}

        protected HTMLTemplateTypes? HTMLTemplateType
        {
            get
            {
                HTMLTemplateTypes objHTMLTemplateTypes;
                if (Enum.TryParse<HTMLTemplateTypes>(Request["Type"], out objHTMLTemplateTypes))
                {
                    return objHTMLTemplateTypes;
                }
                return null;
            }
        }

        protected void Page_Load(object sender, EventArgs e)
        {
            CommonFunction.AuthenticateUser();

            if (!IsPostBack)
            {
                if (this.HTMLTemplate.HasValue)
                {
                    ddlCategory.DataSource = CommonFunction.GetHTMLTemplateCategoryList();
                    ddlCategory.DataTextField = "Text";
                    ddlCategory.DataValueField = "Value";
                    ddlCategory.DataBind();
                    ddlCategory.Items.Insert(0, new ListItem("--Select--", "0"));
                    //if (this.HTMLTemplateCategory.HasValue)
                    //{
                    //    ddlCategory.SelectedValue = Convert.ToByte(this.HTMLTemplateCategory.Value).ToString();
                    //}

                    ddlDesignation.DataSource = DesignationBLL.Instance.GetAllDesignation();
                    ddlDesignation.DataTextField = "DesignationName";
                    ddlDesignation.DataValueField = "ID";
                    ddlDesignation.DataBind();
                    ddlDesignation.Items.Insert(0, new ListItem("--Select--", "0"));

                    HTMLTemplatesMaster objHTMLTemplatesMaster = HTMLTemplateBLL.Instance.GetSMSTemplateMasterById(this.HTMLTemplate.Value);

                    txtName.Text = objHTMLTemplatesMaster.Name;
                   // txtSubject.Text = objHTMLTemplatesMaster.Subject;
                    //txtHeader.Content = objHTMLTemplatesMaster.Header;
                    txtBody.Text = objHTMLTemplatesMaster.Body;
                    //txtFooter.Content = objHTMLTemplatesMaster.Footer;

                    if (objHTMLTemplatesMaster.Category.HasValue)
                    {
                        ddlCategory.SelectedValue = objHTMLTemplatesMaster.Category.Value.ToString();
                    }
                    trMasterCopy.Visible = true;
                }
            }

            if (this.HTMLTemplateType.HasValue && this.HTMLTemplateType.Value == HTMLTemplateTypes.Template)
            {
                trCategory.Visible = false;
                // trSubject.Visible = false;
            }
        }

        protected void ddlDesignation_SelectedIndexChanged(object sender, EventArgs e)
        {
            if (ddlDesignation.SelectedIndex > 0)
            {
                DesignationHTMLTemplate objDesignationHTMLTemplate = HTMLTemplateBLL.Instance.GetDesignationSMSTemplate(this.HTMLTemplate.Value, ddlDesignation.SelectedValue);

                //txtSubject.Text = objDesignationHTMLTemplate.Subject;
                //txtHeader.Content = objDesignationHTMLTemplate.Header;
                txtBody.Text = objDesignationHTMLTemplate.Body;
                //txtFooter.Content = objDesignationHTMLTemplate.Footer;
                trMasterCopy.Visible = (objDesignationHTMLTemplate.Id == 0);
            }
            else
            {
             //   txtHeader.Content =
                txtBody.Text = string.Empty;
                // txtFooter.Content =
                //txtSubject.Text = string.Empty;
                trMasterCopy.Visible = false;
            }
        }

        protected void btnSaveTemplate_Click(object sender, EventArgs e)
        {
            DesignationHTMLTemplate objDesignationHTMLTemplate = new DesignationHTMLTemplate();
            objDesignationHTMLTemplate.HTMLTemplatesMasterId = (byte)this.HTMLTemplate.Value;

            if (ddlDesignation.SelectedIndex > 0)// update individual designation html template.
            {
                objDesignationHTMLTemplate.Designation = ddlDesignation.SelectedValue;

                byte? intMasterCategory = null;
                // category field is visible and used only for auto email template type.
                // so, we are setting it to 0 for rest of the types.
                if (ddlCategory.SelectedIndex > 0)
                {
                    intMasterCategory = Convert.ToByte(ddlCategory.SelectedValue);
                }

                //objDesignationHTMLTemplate.Subject = txtSubject.Text;
                //objDesignationHTMLTemplate.Header = txtHeader.Content;
                objDesignationHTMLTemplate.Body = txtBody.Text;
                //objDesignationHTMLTemplate.Footer = txtFooter.Content;

                if (HTMLTemplateBLL.Instance.SaveDesignationSMSTemplate(objDesignationHTMLTemplate, intMasterCategory))
                {
                    CommonFunction.ShowAlertFromUpdatePanel(this, "Designation template updated.");
                    Response.Redirect(Request.Url.ToString());
                }
                else
                {
                    CommonFunction.ShowAlertFromUpdatePanel(this, "Designation template can not be updated! Please try again later.");
                } 
            }
            else // update master html template.
            {
               // objDesignationHTMLTemplate.Subject = txtSubject.Text;
                //objDesignationHTMLTemplate.Header = txtHeader.Content;
                objDesignationHTMLTemplate.Body = txtBody.Text;
                //objDesignationHTMLTemplate.Footer = txtFooter.Content;

                if (HTMLTemplateBLL.Instance.SaveMasterSMSTemplate(objDesignationHTMLTemplate))
                {
                    CommonFunction.ShowAlertFromUpdatePanel(this, "Master template updated successfully.");
                    Response.Redirect(Request.Url.ToString());
                }
                else
                {
                    CommonFunction.ShowAlertFromUpdatePanel(this, "Master template can not be updated right now! Please try again later.");
                }
            }
        }

        protected void btnRevertToMaster_Click(object sender, EventArgs e)
        {
            if (ddlDesignation.SelectedIndex > 0)
            {
                if (HTMLTemplateBLL.Instance.DeleteDesignationHTMLTemplate(this.HTMLTemplate.Value, ddlDesignation.SelectedValue))
                {
                    CommonFunction.ShowAlertFromUpdatePanel(this, "Designation template deleted.");
                    Response.Redirect(Request.Url.ToString());
                }
                else
                {
                    CommonFunction.ShowAlertFromUpdatePanel(this, "Designation template can not be deleted! Please try again later.");
                }
            }
            else
            {
                if (HTMLTemplateBLL.Instance.RevertDesignationSMSTemplatesByMasterTemplateId(Convert.ToInt32(this.HTMLTemplate.Value)))
                {                
                    CommonFunction.ShowAlertFromUpdatePanel(this, "All Designation templates are updated to Master SMS template.");
                }
                else
                {
                    CommonFunction.ShowAlertFromUpdatePanel(this, "Sorry error occured while updating Designation templates to Master SMS template.");
                }
            }
        }

        protected void btnCancel_Click(object sender, EventArgs e)
        {
            Response.Redirect("~/Sr_App/html-template-maintainance.aspx");
        }
    }
}