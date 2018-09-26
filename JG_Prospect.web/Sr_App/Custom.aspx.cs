using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using JG_Prospect.Common.modal;
using JG_Prospect.BLL;
using System.IO;
using JG_Prospect.Common.Logger;
using System.Data;
using JG_Prospect.Common;
using System.Web.Services;
using System.Web.Script.Services;
using AjaxControlToolkit;
using System.Text.RegularExpressions;
using System.Web.UI.HtmlControls;
using JG_Prospect.App_Code;

namespace JG_Prospect.Sr_App.Product_Line
{
    public partial class Custom : System.Web.UI.Page
    {
        ErrorLog logManager = new ErrorLog();
        string previousPage = string.Empty;
        private static string OtherText = string.Empty;
        int userId = 0;
        protected int ProductTypeId
        {
            get
            {
                return ViewState[QueryStringKey.Key.ProductTypeId.ToString()] == null ? 0 : Convert.ToInt32(ViewState[QueryStringKey.Key.ProductTypeId.ToString()]);
            }
            set { ViewState[QueryStringKey.Key.ProductTypeId.ToString()] = value; }
        }

        //public List<CustomerLocationPic> CustomerLocationPicturesList
        //{
        //    get
        //    {
        //        return ViewState[SessionKey.Key.PagedataTable.ToString()] == null ? null : (List<CustomerLocationPic>)ViewState[SessionKey.Key.PagedataTable.ToString()];
        //    }
        //    set
        //    {
        //        ViewState[SessionKey.Key.PagedataTable.ToString()] = value;
        //    }
        //}


        protected void Page_Load(object sender, EventArgs e)
        {

            int ProductId = 0, CustomerId = 0, CustomId = 0;
            if (Request.QueryString[QueryStringKey.Key.Other.ToString()] != null)
            {
                OtherText = Request.QueryString[QueryStringKey.Key.Other.ToString()].ToString();
            }
            ViewState["PreviousPage"] = Request.UrlReferrer;
            userId = Convert.ToInt16(Session[JG_Prospect.Common.SessionKey.Key.UserId.ToString()]);
            if (ViewState["PreviousPage"] != null)
            {
                previousPage = ViewState["PreviousPage"].ToString();
            }

            //if (Request.QueryString[QueryStringKey.Key.ProductTypeIdFrom.ToString()] != null)
            //{
            //    ProductTypeIdFrom = Convert.ToInt32(Request.QueryString[QueryStringKey.Key.ProductTypeIdFrom.ToString()]);
            //}
            if (Request.QueryString[QueryStringKey.Key.CustomerId.ToString()] != null)
            {
                lblmsg.Text = Request.QueryString[QueryStringKey.Key.CustomerId.ToString()].ToString();
            }

            //DataSet dsCustomer=new_customerBLL.Instance.GetCustomerDetails(Convert.ToInt16(Request.QueryString[1]));
            DataSet dsCustomer = new_customerBLL.Instance.GetCustomerDetails(Convert.ToInt16(Request.QueryString[QueryStringKey.Key.CustomerId.ToString()].ToString()));
            if (dsCustomer.Tables[0].Rows.Count > 0)
            {
                txtCustomer.Text = dsCustomer.Tables[0].Rows[0]["CustomerName"].ToString();
                txtCustomer.Enabled = false;
            }
            DataSet dsTerms;
            if (Request.QueryString[QueryStringKey.Key.ProductTypeId.ToString()] != null)
            {
                ProductTypeId = Convert.ToInt16(Request.QueryString[QueryStringKey.Key.ProductTypeId.ToString()]);

                if (ProductTypeId != 0)
                {
                    string productName = UserBLL.Instance.GetProductNameByProductId(ProductTypeId);
                    string ProposalTerm = string.Empty;
                    dsTerms = new_customerBLL.Instance.GetProposalTerm(Convert.ToInt32(ProductTypeId));
                    if (dsTerms.Tables.Count > 0)
                    {
                        if (dsTerms.Tables[0].Rows.Count > 0)
                        {
                            if (Convert.ToString(dsTerms.Tables[0].Rows[0][1]) != "")
                            {
                                ProposalTerm = Convert.ToString(dsTerms.Tables[0].Rows[0][1]);
                                ProposalTerm = Regex.Replace(ProposalTerm, "<.*?>|&.*?;", string.Empty);
                                if (!IsPostBack)
                                {
                                    txtProposalTerm.Text = ProposalTerm;
                                }
                            }
                        }
                    }
                    h1Heading.InnerText = "Details:" + productName;
                }
            }
            if (ViewState[QueryStringKey.Key.Edit.ToString()] == null)
            {
                if (Request.QueryString[QueryStringKey.Key.CustomerId.ToString()] != null
                    && Request.QueryString[QueryStringKey.Key.ProductTypeId.ToString()] != null
                    && Request.QueryString[QueryStringKey.Key.ProductId.ToString()] != null
                    )
                {
                    if (previousPage.Contains("Procurement.aspx"))
                    {
                        CustomerId = Convert.ToInt32(Request.QueryString[QueryStringKey.Key.CustomerId.ToString()]);
                        ProductId = Convert.ToInt32(Request.QueryString[QueryStringKey.Key.ProductTypeId.ToString()]);
                        CustomId = Convert.ToInt32(Request.QueryString[QueryStringKey.Key.ProductId.ToString()]);
                        fillCusromDetails(CustomerId, CustomId, ProductId);
                        lnkDownload.Visible = true;
                        DisableControls();
                        btnexit.Text = "Go Back";
                    }
                    else
                    {
                        CustomerId = Convert.ToInt32(Request.QueryString[QueryStringKey.Key.CustomerId.ToString()]);
                        ProductId = Convert.ToInt32(Request.QueryString[QueryStringKey.Key.ProductTypeId.ToString()]);
                        CustomId = Convert.ToInt32(Request.QueryString[QueryStringKey.Key.ProductId.ToString()]);

                        hidProdType.Value = ProductId.ToString();
                        btnsave.Text = JGConstant.UPDATE;
                        lnkDownload.Visible = true;

                        fillCusromDetails(CustomerId, CustomId, ProductId);
                        ViewState[QueryStringKey.Key.Edit.ToString()] = JGConstant.TRUE;
                    }

                }
                else { btnsave.Text = JGConstant.SAVE; }

            }
        }

        private void DisableControls()
        {
            txtProposalTerm.Enabled = false;
            txtProposalCost.Enabled = false;
            txtCustSupMaterial.Enabled = false;
            chkCustSupMaterial.Enabled = false;
            txtStorage.Enabled = false;
            chkStorage.Enabled = false;
            txtspecialIns.Enabled = false;
            chkPermit.Enabled = false;
            chkHabitat.Enabled = false;
        }
        [WebMethod]
        public static string Exists(string value)
        {
            if (value == AdminBLL.Instance.GetAdminCode())
            {
                return "True";
            }
            else
            {
                return "false";
            }
        }

        private void fillCusromDetails(int CustomerId, int CustomId, int ProductTypeId)
        {
            Customs custom = new Customs();
            string locPics = "";
            custom.ProductTypeId = ProductTypeId;
            custom.CustomerId = CustomerId;
            custom.Id = CustomId;


            custom = CustomBLL.Instance.GetCustomDetail(custom);
            if (custom != null)
            {
                locPics = Convert.ToString(custom.CustomerLocationPics.Count);

                if (locPics != "")
                {
                    hidCount.Value = Convert.ToString(custom.CustomerLocationPics.Count);
                }
                hidProdId.Value = custom.Id.ToString();
                txtCustomer.Text = custom.Customer;
                txtProposalCost.Text = custom.ProposalCost.ToString();
                txtProposalTerm.Text = custom.ProposalTerms;
                txtspecialIns.Text = custom.SpecialInstruction;
                txtworkarea.Text = custom.WorkArea;
                txtCustSupMaterial.Text = custom.CustSuppliedMaterial;
                chkCustSupMaterial.Checked = custom.IsCustSupMatApplicable;
                txtStorage.Text = custom.MaterialStorage;
                chkStorage.Checked = custom.IsMatStorageApplicable;
                chkPermit.Checked = custom.IsPermitRequired;
                chkHabitat.Checked = custom.IsHabitat;
                lnkDownload.Text = custom.Attachment;
                //ViewState[SessionKey.Key.PagedataTable.ToString()] = custom.CustomerLocationPics;
                //gvCategory.DataSource = custom.CustomerLocationPics;
                //gvCategory.DataBind();

                if (custom.CustomerLocationPics.Count > 0)
                {
                    var attachment = custom.CustomerLocationPics.Select(c => c.LocationPicture);
                    if (attachment != null && attachment.Count() > 0)
                    {
                        rptAttachment.DataSource = attachment;
                        rptAttachment.DataBind();
                    }
                }
                else
                {
                    rptAttachment.DataSource = "";
                    rptAttachment.DataBind();
                }
            }
        }

        private void ClearCustomData()
        {
            hidProdId.Value = null;
            hidProdType.Value = null;
            hidCount.Value = null;
            txtCustomer.Text = string.Empty;
            txtProposalCost.Text = string.Empty;
            txtProposalTerm.Text = string.Empty;
            txtspecialIns.Text = string.Empty;
            txtworkarea.Text = string.Empty;
            txtCustSupMaterial.Text = string.Empty;
            chkCustSupMaterial.Checked = false;
            txtStorage.Text = string.Empty;
            chkStorage.Checked = false;
            chkPermit.Checked = false;
            chkHabitat.Checked = false;
            lnkDownload.Visible = false;
            //ViewState[SessionKey.Key.PagedataTable.ToString()] = null;
            ViewState[QueryStringKey.Key.ProductTypeId.ToString()] = null;
            rptAttachment.DataSource = null;
            rptAttachment.DataBind();
            //gvCategory.DataSource = null;
            //gvCategory.DataBind();
        }

        protected void btnexit_Click(object sender, EventArgs e)
        {
            if (btnexit.Text == "Go Back")
            {
                Response.Redirect("~/Sr_App/Procurement.aspx");
            }
            else
            {
                Response.RedirectPermanent("~/Sr_App/home.aspx");
            }

        }

        protected void btnsave_Click(object sender, EventArgs e)
        {
            try
            {
                if (Page.IsValid)
                {
                    Customs custom = new Customs();
                    if (hidProdId.Value != "")
                    { custom.Id = Convert.ToInt32(hidProdId.Value); }
                    else { custom.Id = 0; }

                    // custom.CustomerId = Convert.ToInt16(Request.QueryString[2]);// Convert.ToInt32(Session[SessionKey.Key.CustomerId.ToString()]);
                    custom.CustomerId = Convert.ToInt32(Request.QueryString[SessionKey.Key.CustomerId.ToString()]);
                    custom.Customer = txtCustomer.Text.Trim();
                    custom.ProposalCost = decimal.Parse(txtProposalCost.Text);
                    custom.ProposalTerms = txtProposalTerm.Text.Trim();
                    custom.SpecialInstruction = txtspecialIns.Text;
                    custom.WorkArea = txtworkarea.Text;
                    custom.UserId = userId;
                    custom.ProductTypeId = this.ProductTypeId;

                    string xml = "<root>";
                    string mainImage = "";
                    //List<CustomerLocationPic> pics = (List<CustomerLocationPic>)ViewState[SessionKey.Key.PagedataTable.ToString()];

                    //var image = pics.AsEnumerable().Take(1);
                    //string mainImage = image.FirstOrDefault().LocationPicture;

                    //for (int i = 0; i < pics.Count; i++)
                    //{
                    //    xml += "<pics><pic>" + pics[i].LocationPicture + "</pic></pics>";
                    //}
                    //xml += "</root>";

                    foreach (RepeaterItem item in rptAttachment.Items)
                    {
                        if (item.ItemType == ListItemType.Item || item.ItemType == ListItemType.AlternatingItem)
                        {
                            var imag = (HtmlImage)item.FindControl("imgIcon");
                            xml += "<pics><pic>" + ".." + Server.UrlDecode(imag.Src) + "</pic></pics>";
                            if (CommonFunction.IsImageFile(".." + Server.UrlDecode(imag.Src)))
                            {
                                mainImage = ".." + Server.UrlDecode(imag.Src);
                            }
                        }
                    }
                    xml += "</root>";
                    custom.LocationImage = xml;
                    custom.MainImage = mainImage;

                    #region commentedArea
                    //if (fileAttachment.HasFile)
                    //{
                    //    if (fileAttachment.PostedFile.FileName != "")
                    //    {
                    //        custom.Attachment = fileAttachment.PostedFile.FileName;

                    //        string strFileNameWithPath = fileAttachment.PostedFile.FileName;
                    //        string strExtensionName = System.IO.Path.GetExtension(strFileNameWithPath);
                    //        string strFileName = System.IO.Path.GetFileName(strFileNameWithPath);
                    //        custom.Attachment = strFileName;
                    //        int intFileSize = fileAttachment.PostedFile.ContentLength;

                    //        if (intFileSize > 0)
                    //        {
                    //            if (File.Exists(Server.MapPath("~/UploadedFiles/") + strFileName) == true)
                    //            {
                    //                File.Delete(Server.MapPath("~/UploadedFiles/") + strFileName);
                    //                fileAttachment.PostedFile.SaveAs(Server.MapPath("~/UploadedFiles/") + strFileName);
                    //            }
                    //            else
                    //            {
                    //                fileAttachment.PostedFile.SaveAs(Server.MapPath("~/UploadedFiles/") + strFileName);
                    //            }
                    //        }
                    //    }
                    //}
                    //else
                    //{
                    //    if (lnkDownload.Visible)
                    //    {
                    //        custom.Attachment = lnkDownload.Text;
                    //    }
                    //    else { custom.Attachment = string.Empty; }
                    //}
                    #endregion

                    if (lnkDownload.Text != "")
                    {
                        custom.Attachment = lnkDownload.Text;
                    }
                    else { custom.Attachment = string.Empty; }
                    custom.CustSuppliedMaterial = txtCustSupMaterial.Text.Trim();
                    custom.IsCustSupMatApplicable = chkCustSupMaterial.Checked;
                    custom.MaterialStorage = txtStorage.Text.Trim();
                    custom.IsMatStorageApplicable = chkStorage.Checked;
                    custom.IsPermitRequired = chkPermit.Checked;
                    custom.IsHabitat = chkHabitat.Checked;
                    custom.Others = OtherText;
                    bool result = CustomBLL.Instance.AddCustom(custom);

                    Session["Proposal"] = txtProposalTerm.Text;

                    if (result && custom.Id == 0)
                    {
                        ScriptManager.RegisterStartupScript(this, this.GetType(), "AlertBox", "alert('Product has been added successfully.');", true);
                        ClearCustomData();
                        // Response.Redirect("~/Sr_App/ProductEstimate.aspx?CustomerId=" + custom.CustomerId, false);
                        Response.Redirect("~/Sr_App/ProductEstimate.aspx", false);
                    }
                    else if (result && custom.Id > 0)
                    {

                        ScriptManager.RegisterStartupScript(this, this.GetType(), "AlertBox", "alert('Product has been updated successfully.');", true);
                        ClearCustomData();
                        // Response.Redirect("~/Sr_App/ProductEstimate.aspx?CustomerId=" + custom.CustomerId, false);
                        Response.Redirect("~/Sr_App/ProductEstimate.aspx", false);
                    }
                    else
                    {
                        ScriptManager.RegisterStartupScript(this, this.GetType(), "AlertBox", "alert('Unable to add Product.');", true);
                        ClearCustomData();
                    }

                }
            }
            catch (Exception ex)
            {
                logManager.writeToLog(ex, "Custom", Request.ServerVariables["remote_addr"].ToString());
            }
        }

        protected void btnImageUploadClick_Click(object sender, EventArgs e)
        {
            //var ImageList = CustomerLocationPicturesList;
        }
        protected void AsyncFileUploadCustomerAttachment_UploadedComplete(object sender, AsyncFileUploadEventArgs e)
        {
            string imageName = Path.GetFileName(AsyncFileUploadCustomerAttachment.FileName);

            if (File.Exists(Server.MapPath("~/UploadedFiles/") + imageName) == true)
            {
                File.Delete(Server.MapPath("~/UploadedFiles/") + imageName);
            }
            AsyncFileUploadCustomerAttachment.SaveAs(Server.MapPath("~/UploadedFiles/" + imageName));
            lnkDownload.Visible = true;
            lnkDownload.Text = imageName;

        }
        protected void ajaxFileUpload_UploadedComplete(object sender, AsyncFileUploadEventArgs e)
        {
            //if (ValidateImageUpload(Path.GetFileName(ajaxFileUpload.FileName)))
            //{
            //    int srNo = 1;
            //    List<CustomerLocationPic> pics = null;
            //    string imageName = Path.GetFileName(ajaxFileUpload.FileName);
            //    string tempImageName = Guid.NewGuid() + "-" + imageName;
            //    ajaxFileUpload.SaveAs(Server.MapPath("~/CustomerDocs/LocationPics/" + tempImageName));
            //    tempImageName = "../CustomerDocs/LocationPics/" + tempImageName;
            //    imageName = tempImageName;
            //    //ajaxFileUpload.SaveAs(Server.MapPath("~/CustomerDocs/LocationPics/" + tempImageName));

            //    if (ViewState[SessionKey.Key.PagedataTable.ToString()] != null)
            //    {
            //        pics = (List<CustomerLocationPic>)ViewState[SessionKey.Key.PagedataTable.ToString()];
            //    }
            //    else
            //    {
            //        pics = new List<CustomerLocationPic>();
            //    }
            //    if (pics.Count > 0)
            //    {
            //        srNo = pics.Count + 1;
            //    }
            //    pics.Add(new CustomerLocationPic { RowSerialNo = srNo, LocationPicture = tempImageName });

            //    CustomerLocationPicturesList = pics;
            //    hidCount.Value = pics.Count == 0 ? string.Empty : pics.Count.ToString();
            //    gvCategory.DataSource = pics;
            //    gvCategory.DataBind();
            //}
        }
        private bool ValidateImageUpload(string fileName)
        {
            string[] extensions = { ".gif", ".png", ".jpg", ".jpeg", ".bmp", ".tif", ".tiff" };
            bool flag = false;
            for (int counter = 0; counter < extensions.Length; counter++)
            {
                if (fileName.ToLower().Contains(extensions[counter]))
                {
                    flag = true;
                    break;
                }
            }
            List<CustomerLocationPic> pics = null; // CustomerLocationPicturesList;
            if (pics != null && Convert.ToInt32(pics.Count) >= 5)
            {
                ScriptManager.RegisterStartupScript(this, GetType(), "showalert", "alert('" + "You can not upload image more than five." + "');", true);
                return false;
            }
            if (!flag)
            {
                ScriptManager.RegisterStartupScript(this, GetType(), "showalert", "alert('" + "Invalid formats are not allowed." + "');", true);
                return false;
            }
            return flag;
        }
        protected void bntAdd_Click(object sender, EventArgs e)
        {
            //LoadImage();
        }

        protected void gvCategory_RowCommand(object sender, GridViewCommandEventArgs e)
        {
            //if (e.CommandName == "DeleteRec")
            //{
            //    int Id = Convert.ToInt32(e.CommandArgument.ToString());
            //    List<CustomerLocationPic> pics = (List<CustomerLocationPic>)ViewState[SessionKey.Key.PagedataTable.ToString()];
            //    pics.Remove(pics.FirstOrDefault(id => id.RowSerialNo == Id));
            //    ViewState[SessionKey.Key.PagedataTable.ToString()] = pics;
            //    hidCount.Value = "";
            //    hidCount.Value = pics.Count.ToString();
            //    gvCategory.DataSource = pics;
            //    gvCategory.DataBind();
            //}
        }

        protected void gvCategory_RowDataBound(object sender, GridViewRowEventArgs e)
        {
            if (e.Row.RowType == DataControlRowType.DataRow)
            {
                CustomerLocationPic dr = (CustomerLocationPic)e.Row.DataItem;
                string strImage = dr.LocationPicture;
                //((Image)(e.Row.FindControl("imglocation"))).ImageUrl = "~/CustomerDocs/LocationPics/" + strImage;
            }
        }

        protected void gvCategory_PageIndexChanging(object sender, GridViewPageEventArgs e)
        {
            //gvCategory.PageIndex = e.NewPageIndex;
            //gvCategory.DataSource = ViewState[SessionKey.Key.PagedataTable.ToString()];
            //gvCategory.DataBind();
        }

        protected void lnkDownload_Click(object sender, EventArgs e)
        {
            string fileName = lnkDownload.Text.Trim();

            Response.ContentType = "application/octet-stream";
            Response.AddHeader("Content-Disposition", "attachment;filename=\"" + fileName + "\"");
            Response.TransmitFile("~/UploadedFiles/" + fileName);
            Response.End();
        }

        protected void chkCustSupMaterial_CheckedChanged(object sender, EventArgs e)
        {
            if (chkCustSupMaterial.Checked == true)
            {
                txtCustSupMaterial.Enabled = false;
                txtCustSupMaterial.Text = "";
            }
            else
            {
                txtCustSupMaterial.Enabled = true;
                txtCustSupMaterial.Text = "";
            }
        }

        protected void chkStorage_CheckedChanged(object sender, EventArgs e)
        {
            if (chkStorage.Checked == true)
            {
                txtStorage.Enabled = false;
                txtStorage.Text = "";
            }
            else
            {
                txtStorage.Enabled = true;
                txtStorage.Text = "";
            }
        }

        protected void btnSaveGridAttachment_Click(object sender, EventArgs e)
        {
            Button lnkpop = (Button)sender;
            //int vTaskid = Convert.ToInt32(hdDropZoneTaskId.Value.ToString());
            //UploadUserAttachements(null, Convert.ToInt64(vTaskid), hdnGridAttachment.Value, JGConstant.TaskFileDestination.SubTask);
            //hdnGridAttachment.Value = hdDropZoneTaskId.Value = string.Empty;
            //SetSubTaskDetails();
            var CustomerId = Convert.ToInt32(Request.QueryString[QueryStringKey.Key.CustomerId.ToString()]);
            var ProductId = Convert.ToInt32(Request.QueryString[QueryStringKey.Key.ProductTypeId.ToString()]);
            var CustomId = Convert.ToInt32(Request.QueryString[QueryStringKey.Key.ProductId.ToString()]);

            //var _data = hdnWorkFiles.Value;
            string[] files = hdnWorkFiles.Value.Split(new char[] { '^' }, StringSplitOptions.RemoveEmptyEntries);
            List<string> attachment = new List<string>();
            foreach (string f in files)
            {
                attachment.Add("../CustomerDocs/LocationPics/" + f.Split('@')[0]);
            }

            foreach (RepeaterItem item in rptAttachment.Items)
            {
                if (item.ItemType == ListItemType.Item || item.ItemType == ListItemType.AlternatingItem)
                {
                    var imag = (HtmlImage)item.FindControl("imgIcon");
                    attachment.Add(".." + Server.UrlDecode(imag.Src));
                }
            }

            var _attachment = attachment.Distinct();
            rptAttachment.DataSource = _attachment;
            rptAttachment.DataBind();

            //fillCusromDetails(CustomerId, CustomId, ProductId);
        }

        #region '--Attachment--'

        protected void rptAttachment_ItemCommand(object source, RepeaterCommandEventArgs e)
        {
            if (e.CommandName == "DownloadFile")
            {
                string[] files = e.CommandArgument.ToString().Split(new char[] { '@' }, StringSplitOptions.RemoveEmptyEntries);

                DownloadUserAttachment(files[0].Trim(), files[1].Trim());
            }
            else if (e.CommandName == "delete-attachment")
            {
                DeleteWorkSpecificationFile(e.CommandArgument.ToString());
                
                List<string> attachment = new List<string>();
                //string[] files = hdnWorkFiles.Value.Split(new char[] { '^' }, StringSplitOptions.RemoveEmptyEntries);
                //foreach (var item in files)
                //{
                //    hdnWorkFiles.Value = "";
                //    if (item.Contains(e.CommandArgument.ToString()) == true)
                //    {
                //        hdnWorkFiles.Value += item + "^";
                //    }
                //}

                foreach (RepeaterItem item in rptAttachment.Items)
                {
                    if (item.ItemType == ListItemType.Item || item.ItemType == ListItemType.AlternatingItem)
                    {
                        var imag = (HtmlImage)item.FindControl("imgIcon");
                        if ((".." + Server.UrlDecode(imag.Src)) != e.CommandArgument.ToString())
                        {
                            attachment.Add(".." + Server.UrlDecode(imag.Src));
                        }
                    }
                }
                var _attachment = attachment.Distinct();
                rptAttachment.DataSource = _attachment;
                rptAttachment.DataBind();
            }
        }

        private void DownloadUserAttachment(String File, String OriginalFileName)
        {
            Response.Clear();
            Response.ContentType = "application/octet-stream";
            Response.AppendHeader("Content-Disposition", String.Concat("attachment; filename=", OriginalFileName));
            Response.WriteFile(Server.MapPath("~/TaskAttachments/" + File));
            Response.Flush();
            Response.End();
        }

        private void DeleteWorkSpecificationFile(string parameter)
        {
            if (!string.IsNullOrEmpty(parameter))
            {
                CustomBLL.Instance.DeleteCustomerLocationPicsByName(parameter);
                DeletefilefromServer(parameter);
            }
        }

        private void DeletefilefromServer(string filetodelete)
        {
            if (!String.IsNullOrEmpty(filetodelete))
            {
                var originalDirectory = new DirectoryInfo(Server.MapPath("~/CustomerDocs/LocationPics"));


                string pathString = System.IO.Path.Combine(originalDirectory.ToString(), filetodelete.Replace("../CustomerDocs/LocationPics/",""));

                bool isExists = System.IO.File.Exists(pathString);

                if (isExists)
                    File.Delete(pathString);
            }
        }

        protected void rptAttachment_ItemDataBound(object sender, RepeaterItemEventArgs e)
        {
            if (e.Item.ItemType == ListItemType.Item || e.Item.ItemType == ListItemType.AlternatingItem)
            {
                string file = Convert.ToString(e.Item.DataItem);

                string[] files = file.Split(new char[] { '@' }, StringSplitOptions.RemoveEmptyEntries);

                LinkButton lbtnDelete = (LinkButton)e.Item.FindControl("lbtnDelete");
                LinkButton lbtnAttchment = (LinkButton)e.Item.FindControl("lbtnDownload");
                //Literal ltlFileName = (Literal)e.Item.FindControl("ltlFileName");
                Literal ltlUpdateTime = (Literal)e.Item.FindControl("ltlUpdateTime");
                Literal ltlCreatedUser = (Literal)e.Item.FindControl("ltlCreatedUser");

                //lbtnDelete.CommandArgument = files[4] + "|" + files[1];

                //if (files[1].Length > 13)// sort name with ....
                //{
                //    lbtnAttchment.Text = files[1];// String.Concat(files[2].Substring(0, 12), "..");
                //    lbtnAttchment.Attributes.Add("title", files[1]);

                //    //ltlFileName.Text = lbtnAttchment.Text;
                //}
                //else
                //{
                //    lbtnAttchment.Text = files[1];
                //    //ltlFileName.Text = lbtnAttchment.Text;
                //}

                ScriptManager.GetCurrent(this.Page).RegisterPostBackControl(lbtnAttchment);

                HtmlImage imgIcon = e.Item.FindControl("imgIcon") as HtmlImage;

                lbtnDelete.CommandArgument = files[0].Trim();
                if (CommonFunction.IsImageFile(files[0].Trim()))
                {
                    imgIcon.Src = Page.ResolveUrl(string.Concat("~/", CommonFunction.ReplaceEncodeWhiteSpace(Server.UrlEncode(Convert.ToString(files[0].Trim()).Replace("../", "")))));
                }
                else
                {
                    imgIcon.Src = CommonFunction.GetFileTypeIcon(files[0].Trim(), this.Page);
                }

                ((HtmlGenericControl)e.Item.FindControl("liImage")).Attributes.Add("data-thumb", imgIcon.Src);

                lbtnAttchment.CommandArgument = file;

                if (files.Length > 3)// if there are attachements available.
                {
                    ltlCreatedUser.Text = files[2]; // created user name
                    ltlUpdateTime.Text = string.Concat(
                                                        "<span>",
                                                        string.Format(
                                                                        "{0:M/d/yyyy}",
                                                                        Convert.ToDateTime(files[3])
                                                                     ),
                                                        "</span>&nbsp",
                                                        "<span style=\"color: red\">",
                                                        string.Format(
                                                                        "{0:hh:mm:ss tt}",
                                                                        Convert.ToDateTime(files[3])
                                                                        ),
                                                        "</span>&nbsp<span>(EST)</span>"
                                                     );
                }
            }
        }

        #endregion

    }
}
