using JG_Prospect.App_Code;
using JG_Prospect.BLL;
using JG_Prospect.Common;
using JG_Prospect.Common.modal;
using JG_Prospect.DAL.Database;
using Microsoft.Practices.EnterpriseLibrary.Data.Sql;
using System;
using System.Collections.Generic;
using System.Data;
using System.Data.Common;
using System.Linq;
using System.Text;
using System.Web;
using System.Web.Script.Serialization;
using System.Web.Services;
using System.Web.UI;
using System.Web.UI.HtmlControls;
using System.Web.UI.WebControls;

namespace JG_Prospect.Sr_App
{
    public partial class ITDashboard : System.Web.UI.Page
    {
        #region Page Variables
        public static bool IsSuperUser = false;
        public int loggedInUserId = 0;
        public bool TaskListView = true;
        public int UserDesignationId = 0;
        //public string RandomGUID;
        #endregion

        protected void Page_Load(object sender, EventArgs e)
        {
            // RandomGUID = SingletonGlobal.Instance.RandomGUID;
            JG_Prospect.App_Code.CommonFunction.AuthenticateUser();
            UserDesignationId = JGSession.DesignationId;
            hdnUDID.Value = UserDesignationId.ToString();
            IsSuperUser = CommonFunction.CheckAdminAndItLeadMode();
            if (Request.QueryString["View"] != null && Request.QueryString["View"] == "C")
                TaskListView = false;

            if (!Page.IsPostBack)
            {
                hdnUserId.Value = JGSession.UserId.ToString();
                loggedInUserId = JGSession.UserId;
                //Session["AppType"] = "SrApp";
                //if ((string)Session["usertype"] == "SM" || (string)Session["usertype"] == "SSE" || (string)Session["usertype"] == "MM")
                //{
                //    li_AnnualCalender.Visible = true;
                //}
                //if ((string)Session["usertype"] == "Admin")
                //{
                //    pnlTestEmail.Visible = true;
                //}

                //----------------- Start DP ------------
                FillDesignation();

                //if ((string)Session["DesigNew"] == "ITLead" || (string)Session["DesigNew"] == "Admin" || (string)Session["DesigNew"] == "Office Manager")
                if (UserDesignationId == 4 || UserDesignationId == 6 || UserDesignationId == 18 || UserDesignationId == 21 || IsSuperUser)
                {
                    IsSuperUser = true;
                    lblalertpopup.Visible = true;
                    DataSet ds = TaskGeneratorBLL.Instance.GetFrozenNonFrozenTaskCount();
                    if (ds != null && ds.Tables.Count > 0 && ds.Tables[0].Rows.Count > 0)
                    {
                        lblFrozenTaskCounter.InnerHtml = "Partial Frozen Tasks :<div class='badge1 badge-error' style='width:20px;'>" + ds.Tables[0].Rows[0][0].ToString() + "</div>";
                        lblNonFrozenTaskCounter.InnerHtml = "Non Frozen Tasks :<div class='badge1 badge-error' style='width:20px;'>" + ds.Tables[1].Rows[0][0].ToString() + "</div>";
                    }
                }
                else
                {
                    //txtSearchClosedTasks.Visible = ddlDesigClosedTask.Visible = false;
                    lblalertpopup.Visible = false;

                    //For ng-repeat
                    //tableFilter.Visible = false;
                    seqArrowDown.Visible = seqArrowUp.Visible = false;
                }
                //LoadFilterUsersByDesginationFrozen("", drpUserFrozen);
                //LoadFilterUsersByDesgination("", drpUserNew);                

                // ----- get NEW and FROZEN task counts for current payperiod
                DateTime firstOfThisMonth = new DateTime(DateTime.Now.Year, DateTime.Now.Month, 1);
                DateTime firstOfNextMonth = new DateTime(DateTime.Now.Year, DateTime.Now.Month, 1).AddMonths(1);
                DateTime lastOfThisMonth = firstOfNextMonth.AddDays(-1);
                //DateTime MiddleDate = Convert.ToDateTime("15-" + DateTime.Now.Month + "-" + DateTime.Now.Year);
                DateTime MiddleDate = new DateTime(DateTime.Now.Year, DateTime.Now.Month, 1).AddDays(14);
                string strnew = "";
                //try
                //{
                //    SqlDatabase database = MSSQLDataBase.Instance.GetDefaultDatabase();
                //    {
                //        DataSet result = new DataSet();
                //        //if (DateTime.Now.Date >= firstOfThisMonth && DateTime.Now.Date <= MiddleDate)
                //        //{
                //        //    strnew = "select count(TaskId) as cntnew from tbltask where [Status]=1 ";
                //        //    strnew = strnew + " and (CreatedOn >='" + firstOfThisMonth.ToString("dd-MMM-yyy") + "' and CreatedOn <= '" + MiddleDate.ToString("dd-MMM-yyy") + "') ";
                //        //}
                //        //else if (DateTime.Now.Date >= MiddleDate && DateTime.Now.Date <= lastOfThisMonth)
                //        //{
                //        //    strnew = "select count(TaskId) as cntnew from tbltask where [Status]=1 ";
                //        //    strnew = strnew + " and (CreatedOn >='" + MiddleDate.ToString("dd-MMM-yyy") + "' and CreatedOn <= '" + lastOfThisMonth.ToString("dd-MMM-yyy") + "') ";
                //        //}

                //        strnew = "select count(TaskId) as cntnew from tbltask where [Status]=1 ";

                //        DbCommand command = database.GetSqlStringCommand(strnew);
                //        command.CommandType = CommandType.Text;
                //        result = database.ExecuteDataSet(command);
                //        lblNewCounter.Visible = false;
                //        lblNewCounter0.Visible = true;
                //        lblNewCounter0.Text = " Non Frozen Tasks :<div class='badge1 badge-error' style='width:20px;'>0</div>";
                //        if (result.Tables[0].Rows.Count > 0)
                //        {
                //            if (result.Tables[0].Rows[0]["cntnew"].ToString() != "0")
                //            {
                //                lblNewCounter.Visible = true;
                //                lblNewCounter0.Visible = false;
                //                lblNewCounter.Text = " Non Frozen Tasks :<div class='badge1 badge-error' style='width:20px;'>" + result.Tables[0].Rows[0]["cntnew"].ToString() + "</div>";
                //            }
                //        }
                //        result.Dispose();
                //    }
                //}
                //catch (Exception ex)
                //{
                //}

                //string strfrozen = "";
                //try
                //{
                //    SqlDatabase database = MSSQLDataBase.Instance.GetDefaultDatabase();
                //    {
                //        DataSet result = new DataSet();

                //        //if (DateTime.Now.Date >= firstOfThisMonth && DateTime.Now.Date <= MiddleDate)
                //        //{
                //        //    strfrozen = "select count(a.TaskId) as cntnew from tbltask as a,tbltaskapprovals as b where a.TaskId=b.TaskId  ";
                //        //    strfrozen = strfrozen + " and  (DateCreated >='" + firstOfThisMonth.ToString("dd-MMM-yyy") + "' and DateCreated <= '" + MiddleDate.ToString("dd-MMM-yyy") + "') ";
                //        //}
                //        //else if (DateTime.Now.Date >= MiddleDate && DateTime.Now.Date <= lastOfThisMonth)
                //        //{
                //        //    strfrozen = "select count(a.TaskId) as cntnew from tbltask as a,tbltaskapprovals as b where a.TaskId=b.TaskId  ";
                //        //    strfrozen = strfrozen + " and  (DateCreated >='" + MiddleDate.ToString("dd-MMM-yyy") + "' and DateCreated <= '" + lastOfThisMonth.ToString("dd-MMM-yyy") + "') ";
                //        //}

                //        strfrozen = "select count(a.TaskId) as cntnew from tbltask as a,tbltaskapprovals as b where a.TaskId=b.TaskId  ";

                //        DbCommand command = database.GetSqlStringCommand(strfrozen);
                //        command.CommandType = CommandType.Text;
                //        result = database.ExecuteDataSet(command);

                //        lblFrozenCounter.Visible = false;
                //        lblFrozenCounter0.Visible = true;
                //        lblFrozenCounter0.Text = "Partial Frozen Tasks :<div class='badge1 badge-error' style='width:20px;'>0</div>";
                //        if (result.Tables[0].Rows.Count > 0)
                //        {
                //            if (result.Tables[0].Rows[0]["cntnew"].ToString() != "0")
                //            {
                //                lblFrozenCounter.Visible = true;
                //                lblFrozenCounter0.Visible = false;
                //                lblFrozenCounter.Text = "Partial Frozen Tasks :<div class='badge1 badge-error' style='width:20px;'>" + result.Tables[0].Rows[0]["cntnew"].ToString() + "</div>";
                //            }
                //        }
                //        result.Dispose();
                //    }
                //}
                //catch (Exception ex)
                //{
                //}

                //----------------- End DP ------------
            }
        }



        protected void grdTaskPending_PreRender(object sender, EventArgs e)
        {
            GridView gv = (GridView)sender;

            if (gv.Rows.Count > 0)
            {
                gv.UseAccessibleHeader = true;
                gv.HeaderRow.TableSection = TableRowSection.TableHeader;
                gv.FooterRow.TableSection = TableRowSection.TableFooter;
            }

            if (gv.TopPagerRow != null)
            {
                gv.TopPagerRow.TableSection = TableRowSection.TableHeader;
            }
            if (gv.BottomPagerRow != null)
            {
                gv.BottomPagerRow.TableSection = TableRowSection.TableFooter;
            }
        }
        protected void grdTaskClosed_PreRender(object sender, EventArgs e)
        {
            GridView gv = (GridView)sender;

            if (gv.Rows.Count > 0)
            {
                gv.UseAccessibleHeader = true;
                gv.HeaderRow.TableSection = TableRowSection.TableHeader;
                gv.FooterRow.TableSection = TableRowSection.TableFooter;
            }

            if (gv.TopPagerRow != null)
            {
                gv.TopPagerRow.TableSection = TableRowSection.TableHeader;
            }
            if (gv.BottomPagerRow != null)
            {
                gv.BottomPagerRow.TableSection = TableRowSection.TableFooter;
            }
        }

        protected void grdFrozenTask_PreRender(object sender, EventArgs e)
        {
            GridView gv = (GridView)sender;

            if (gv.Rows.Count > 0)
            {
                gv.UseAccessibleHeader = true;
                gv.HeaderRow.TableSection = TableRowSection.TableHeader;
                gv.FooterRow.TableSection = TableRowSection.TableFooter;
            }

            if (gv.TopPagerRow != null)
            {
                gv.TopPagerRow.TableSection = TableRowSection.TableHeader;
            }
            if (gv.BottomPagerRow != null)
            {
                gv.BottomPagerRow.TableSection = TableRowSection.TableFooter;
            }
        }

        protected void grdNewTask_PreRender(object sender, EventArgs e)
        {
            GridView gv = (GridView)sender;

            if (gv.Rows.Count > 0)
            {
                gv.UseAccessibleHeader = true;
                gv.HeaderRow.TableSection = TableRowSection.TableHeader;
                gv.FooterRow.TableSection = TableRowSection.TableFooter;
            }

            if (gv.TopPagerRow != null)
            {
                gv.TopPagerRow.TableSection = TableRowSection.TableHeader;
            }
            if (gv.BottomPagerRow != null)
            {
                gv.BottomPagerRow.TableSection = TableRowSection.TableFooter;
            }
        }

        protected void btnCalClose_Click(object sender, EventArgs e)
        {
            //mpNewFrozenTask.Hide();
            //ScriptManager.RegisterStartupScript(this.Page, GetType(), "al1", "$('#lnkNNewCounter').click(function () {callpopupscript();   });", true);

        }
        //protected void drpDesigInProgress_SelectedIndexChanged(object sender, EventArgs e)
        //{
        //    string designation = drpDesigInProgress.SelectedValue;
        //    LoadFilterUsersByDesgination(designation, drpUsersInProgress);
        //    //SearchTasks(null);
        //    BindTaskInProgressGrid();
        //}


        //protected void drpDesigNew_SelectedIndexChanged(object sender, EventArgs e)
        //{
        //    string designation = drpDesigNew.SelectedValue;
        //    LoadFilterUsersByDesgination(designation, drpUserNew);
        //    BindNewTasks();
        //}

        protected void drpDesigFrozen_SelectedIndexChanged(object sender, EventArgs e)
        {
            //string designation = drpDesigFrozen.SelectedValue;
            //LoadFilterUsersByDesginationFrozen(designation, drpUserFrozen);
            //BindFrozenTasks();
            //upAlerts.Update();
            //mpNewFrozenTask.Show();
        }
        //protected void drpDesigClosed_SelectedIndexChanged(object sender, EventArgs e)
        //{
        //    string designation = drpDesigClosed.SelectedValue;
        //    LoadFilterUsersByDesgination(designation, drpUsersClosed);
        //    //SearchTasks(null);
        //    BindTaskClosedGrid();
        //}
        //protected void drpDesigFrozen_SelectedIndexChanged(object sender, EventArgs e)
        //{
        //    string designation = drpDesigInProgress.SelectedValue;
        //    LoadFilterUsersByDesgination(designation, drpUserFrozen);
        //    BindFrozenTasks();
        //}
        //protected void drpDesigNew_SelectedIndexChanged(object sender, EventArgs e)
        //{
        //    string designation = drpDesigInProgress.SelectedValue;
        //    LoadFilterUsersByDesgination(designation,drpUserNew );
        //    BindNewTasks();
        //}

        private void LoadFilterUsersByDesgination(string designation, ListBox drp)
        {
            DataSet dsUsers;
            // DropDownCheckBoxes ddlAssign = (FindControl("ddcbAssigned") as DropDownCheckBoxes);
            // DropDownList ddlDesignation = (DropDownList)sender;
            dsUsers = TaskGeneratorBLL.Instance.GetInstallUsers(2, designation);
            //drpUsersInProgress.Items.Clear();

            drp.Items.Clear();
            drp.DataSource = dsUsers;
            drp.DataTextField = "FristName";
            drp.DataValueField = "Id";
            drp.DataBind();
            drp.Items.Insert(0, new ListItem("--All--", "0"));
            drp.SelectedIndex = 0;

            HighlightInterviewUsers(dsUsers.Tables[0], drp, null);
        }

        private void LoadFilterUsersByDesgination(string designation, Saplin.Controls.DropDownCheckBoxes drp)
        {
            DataSet dsUsers;
            // DropDownCheckBoxes ddlAssign = (FindControl("ddcbAssigned") as DropDownCheckBoxes);
            // DropDownList ddlDesignation = (DropDownList)sender;
            dsUsers = TaskGeneratorBLL.Instance.GetInstallUsers(2, designation);
            //drpUsersInProgress.Items.Clear();

            drp.Items.Clear();
            drp.DataSource = dsUsers;
            drp.DataTextField = "FristName";
            drp.DataValueField = "Id";
            drp.DataBind();
            drp.Items.Insert(0, new ListItem("--All--", "0"));
            drp.SelectedIndex = 0;
            HighlightInterviewUsers(dsUsers.Tables[0], drp, null);
        }

        private void HighlightInterviewUsers(DataTable dtUsers, Saplin.Controls.DropDownCheckBoxes ddlUsers, DropDownList ddlFilterUsers)
        {
            #region Commented
            //if (dtUsers.Rows.Count > 0)
            //{
            //    var rows = dtUsers.AsEnumerable();

            //    //get all users comma seperated ids with interviewdate status
            //    String InterviewDateUsers = String.Join(",", (from r in rows where (r.Field<string>("Status") == "InterviewDate" || r.Field<string>("Status") == "Interview Date") select r.Field<Int32>("Id").ToString()));

            //    // for each userid find it into user dropdown list and apply red color to it.
            //    foreach (String user in InterviewDateUsers.Split(new char[] { ',' }, StringSplitOptions.RemoveEmptyEntries))
            //    {
            //        ListItem item;

            //        if (ddlUsers != null)
            //        {
            //            item = ddlUsers.Items.FindByValue(user);
            //        }
            //        else
            //        {
            //            item = ddlFilterUsers.Items.FindByValue(user);
            //        }

            //        if (item != null)
            //        {
            //            item.Attributes.Add("style", "color:red;");
            //        }
            //    }

            //} 
            #endregion
            HyperLink lnkUserId = new HyperLink();
            ListItem lstUserId = new ListItem();

            if (dtUsers.Rows.Count > 0)
            {
                var rows = dtUsers.AsEnumerable();

                //get all users comma seperated ids with Active status
                String InterviewDateUsers = String.Join(",", (from r in rows where (r.Field<string>("Status") == "1") select r.Field<Int32>("Id").ToString()));

                // for each userid find it into user dropdown list and apply red color to it.
                foreach (String user in InterviewDateUsers.Split(new char[] { ',' }, StringSplitOptions.RemoveEmptyEntries))
                {
                    ListItem item;

                    if (ddlUsers != null)
                    {
                        item = ddlUsers.Items.FindByValue(user);
                    }
                    else
                    {
                        item = ddlFilterUsers.Items.FindByValue(user);
                    }

                    if (item != null)
                    {
                        item.Attributes.Add("style", "color:red;");

                    }
                }

                InterviewDateUsers = string.Empty;

                //get all users comma seperated ids with interviewdate and Offer Made status
                InterviewDateUsers = String.Join(",", (from r in rows where (r.Field<string>("Status") == "5" || r.Field<string>("Status") == "6") select r.Field<Int32>("Id").ToString()));

                // for each userid find it into user dropdown list and apply blue color to it.
                foreach (String user in InterviewDateUsers.Split(new char[] { ',' }, StringSplitOptions.RemoveEmptyEntries))
                {
                    ListItem item;

                    if (ddlUsers != null)
                    {
                        item = ddlUsers.Items.FindByValue(user);
                    }
                    else
                    {
                        item = ddlFilterUsers.Items.FindByValue(user);
                    }

                    if (item != null)
                    {
                        item.Attributes.Add("style", "color:blue;");
                    }
                }
            }
        }

        private void HighlightInterviewUsers(DataTable dtUsers, ListBox ddlUsers, DropDownList ddlFilterUsers)
        {
            #region Commented
            //if (dtUsers.Rows.Count > 0)
            //{
            //    var rows = dtUsers.AsEnumerable();

            //    //get all users comma seperated ids with interviewdate status
            //    String InterviewDateUsers = String.Join(",", (from r in rows where (r.Field<string>("Status") == "InterviewDate" || r.Field<string>("Status") == "Interview Date") select r.Field<Int32>("Id").ToString()));

            //    // for each userid find it into user dropdown list and apply red color to it.
            //    foreach (String user in InterviewDateUsers.Split(new char[] { ',' }, StringSplitOptions.RemoveEmptyEntries))
            //    {
            //        ListItem item;

            //        if (ddlUsers != null)
            //        {
            //            item = ddlUsers.Items.FindByValue(user);
            //        }
            //        else
            //        {
            //            item = ddlFilterUsers.Items.FindByValue(user);
            //        }

            //        if (item != null)
            //        {
            //            item.Attributes.Add("style", "color:red;");
            //        }
            //    }

            //} 
            #endregion

            if (dtUsers != null && dtUsers.Rows.Count > 0)
            {
                CommonFunction.ApplyColorCodeToAssignUserDropdown(dtUsers, ddlUsers);
            }
        }

        private void LoadFilterUsersByDesginationFrozen(string designation, DropDownList drp)
        {
            DataSet dsUsers;
            dsUsers = TaskGeneratorBLL.Instance.GetInstallUsers(2, designation);

            drp.DataSource = dsUsers;
            drp.DataTextField = "FristName";
            drp.DataValueField = "Id";
            drp.DataBind();
            drp.Items.Insert(0, new ListItem("--All--", "0"));
            drp.SelectedIndex = 0;
        }

        private void FillDesignation()
        {
            DataSet dsDesignation = DesignationBLL.Instance.GetActiveDesignationByID(0, 1);

            //ddlDesigSeq.Items.Clear();
            //ddlDesigSeq.DataSource = dsDesignation.Tables[0];
            //ddlDesigSeq.DataTextField = "DesignationName";
            //ddlDesigSeq.DataValueField = "ID";
            //ddlDesigSeq.DataBind();

            //ddlDesigIdsFrozenTasks
            //ddlDesigIdsFrozenTasks.Items.Clear();
            //ddlDesigIdsFrozenTasks.DataSource = dsDesignation.Tables[0];
            //ddlDesigIdsFrozenTasks.DataTextField = "DesignationName";
            //ddlDesigIdsFrozenTasks.DataValueField = "ID";
            //ddlDesigIdsFrozenTasks.DataBind();

            //drpDesigInProgress .Items.Clear();

            //drpDesigInProgress.DataValueField = "Id";
            //drpDesigInProgress.DataTextField = "DesignationName";
            //drpDesigInProgress.DataSource = dsDesignation.Tables[0];
            //drpDesigInProgress.DataBind();
            //drpDesigInProgress.Items.Insert(0, new ListItem("--All--", "0"));
            //drpDesigInProgress.SelectedIndex = 0;

            //DataSet ds = DesignationBLL.Instance.GetActiveDesignationByID(0, 1);

            //drpDesigClosed.DataValueField = "Id";
            //drpDesigClosed.DataTextField = "DesignationName";
            //drpDesigClosed.DataSource = dsDesignation.Tables[0];
            //drpDesigClosed.DataBind();
            //drpDesigClosed.Items.Insert(0, new ListItem("--All--", "0"));
            //drpDesigClosed.SelectedIndex = 0;

            //drpDesigFrozen.DataValueField = "Id";
            //drpDesigFrozen.DataTextField = "DesignationName";
            //drpDesigFrozen.DataSource = dsDesignation.Tables[0];
            //drpDesigFrozen.DataBind();
            //drpDesigFrozen.Items.Insert(0, new ListItem("--All--", "0"));
            //drpDesigFrozen.SelectedIndex = 0;

            //ddlFrozenUserDesignation.Items.Clear();
            //ddlFrozenUserDesignation.DataSource = dsDesignation.Tables[0];
            //ddlFrozenUserDesignation.DataTextField = "DesignationName";
            //ddlFrozenUserDesignation.DataValueField = "ID";
            //ddlFrozenUserDesignation.DataBind();

            //drpDesigNew.DataValueField = "Id";
            //drpDesigNew.DataTextField = "DesignationName";
            //drpDesigNew.DataSource = dsDesignation.Tables[0];
            //drpDesigNew.DataBind();
            //drpDesigNew.Items.Insert(0, new ListItem("--All--", "0"));
            //drpDesigNew.SelectedIndex = 0;
        }

        protected void grdTaskPending_RowDataBound(object sender, GridViewRowEventArgs e)
        {
            if (e.Row.RowType == DataControlRowType.DataRow)
            {
                HiddenField lblStatus = e.Row.FindControl("lblStatus") as HiddenField;
                //Label lblDueDate = e.Row.FindControl("lblDueDate") as Label;
                DropDownList drpStatusInPro = e.Row.FindControl("drpStatusInPro") as DropDownList;
                HiddenField lblTaskIdInPro = e.Row.FindControl("lblTaskIdInPro") as HiddenField;
                Label lblHoursLead = e.Row.FindControl("lblHoursLeadInPro") as Label;
                Label lblHoursDev = e.Row.FindControl("lblHoursDevInPro") as Label;
                LinkButton lnkInstallId = e.Row.FindControl("lnkInstallId") as LinkButton;
                HiddenField lblParentTaskIdInPro = e.Row.FindControl("lblParentTaskIdInPro") as HiddenField;
                HiddenField hdMainParentId = e.Row.FindControl("hdMainParentId") as HiddenField;

                //lnkInstallId.PostBackUrl = "~/Sr_App/TaskGenerator.aspx?TaskId=" + hdMainParentId.Value + "&hstid=" + lblTaskIdInPro.Value;
                lnkInstallId.PostBackUrl = "javascript:w= window.open('" + System.Configuration.ConfigurationManager.AppSettings["UrlToReplaceForTemplates"] + "Sr_App/TaskGenerator.aspx?TaskId=" + hdMainParentId.Value + "&hstid=" + lblTaskIdInPro.Value + "','JG Sales','left=20,top=20,width=1000,height=600,toolbar=0,resizable=0');";

                //if (lblDueDate.Text != "")
                //{
                //    DateTime dtDue = new DateTime();
                //    dtDue = Convert.ToDateTime(lblDueDate.Text);
                //    lblDueDate.Text = dtDue.ToString("dd-MMM-yyyy");
                //}

                if (lblStatus.Value == "4")
                {
                    //lblStatus.Value = "In Progress";
                    e.Row.BackColor = System.Drawing.Color.Orange;
                }
                else if (lblStatus.Value == "3")
                {
                    //lblStatus.Value = "Assigned";
                    //lblStatus.ForeColor = System.Drawing.Color.LawnGreen;
                    e.Row.BackColor = System.Drawing.Color.Yellow;
                }
                else if (lblStatus.Value == "2")
                {
                    //lblStatus.Value = "Requested";
                    //lblStatus.ForeColor = System.Drawing.Color.Red;
                    e.Row.BackColor = System.Drawing.Color.Yellow;
                }
                else
                {
                    ////lblStatus.Value = "Open";
                    System.Drawing.Color clr = System.Drawing.ColorTranslator.FromHtml("#f6f1f3");
                    e.Row.BackColor = clr;
                    //e.Row.BorderColor = System.Drawing.Color.Black;
                    //foreach (TableCell cell in e.Row.Cells)
                    //{
                    //    cell.BorderColor = System.Drawing.Color.Black;
                    //}
                }

                try
                {
                    int vTaskId = Convert.ToInt32(lblTaskIdInPro.Value);
                    SqlDatabase database = MSSQLDataBase.Instance.GetDefaultDatabase();
                    {
                        DataSet result = new DataSet();
                        DbCommand command = database.GetSqlStringCommand("select a.* ,b.Designation from tbltaskapprovals as a,tblInstallusers as b where a.UserId=b.Id and  a.TaskId=" + vTaskId);
                        command.CommandType = CommandType.Text;
                        result = database.ExecuteDataSet(command);
                        if (result.Tables[0].Rows.Count > 0)
                        {
                            for (int i = 0; i < result.Tables[0].Rows.Count; i++)
                            {
                                if (result.Tables[0].Rows[i]["EstimatedHours"] != null && result.Tables[0].Rows[i]["EstimatedHours"] != "")
                                {
                                    if (result.Tables[0].Rows[i]["Designation"].ToString() == "ITLead" || result.Tables[0].Rows[i]["Designation"].ToString() == "Admin")
                                    {
                                        lblHoursLead.Text = "ITLead : " + result.Tables[0].Rows[i]["EstimatedHours"].ToString() + " Hrs";
                                    }
                                    else
                                    {
                                        lblHoursDev.Text = "Developer : " + result.Tables[0].Rows[i]["EstimatedHours"].ToString() + " Hrs";
                                    }
                                }
                            }
                        }
                        result.Dispose();
                    }
                    lblHoursDev.Visible = false;
                    lblHoursLead.Visible = false;
                }

                catch (Exception ex)
                {
                    // return 0;
                    //LogManager.Instance.WriteToFlatFile(ex);
                }

                // fill status dropdowns
                //----- If manager level then show all statuses
                if ((string)Session["DesigNew"] == "ITLead" || (string)Session["DesigNew"] == "Admin" || (string)Session["DesigNew"] == "Office Manager")
                {
                    drpStatusInPro.DataSource = CommonFunction.GetTaskStatusList();
                    //string[] arrStatus = new string[] { JGConstant.TaskStatus.Open.ToString(),JGConstant.TaskStatus.Requested.ToString(), 
                    //    JGConstant.TaskStatus.Assigned.ToString(), JGConstant.TaskStatus.InProgress.ToString(),
                    //    JGConstant.TaskStatus.Pending.ToString(),  JGConstant.TaskStatus.ReOpened.ToString(),
                    //    JGConstant.TaskStatus.Closed.ToString() ,JGConstant.TaskStatus.SpecsInProgress.ToString(),
                    //    JGConstant.TaskStatus.Deleted.ToString(),JGConstant.TaskStatus.Finished.ToString(),
                    //    JGConstant.TaskStatus.Test.ToString(),JGConstant.TaskStatus.Live.ToString(),JGConstant.TaskStatus.Billed.ToString(),
                    //};
                    //drpStatusInPro.DataSource = FillStatusDropDowns(arrStatus); 
                    drpStatusInPro.DataTextField = "Text";
                    drpStatusInPro.DataValueField = "Value";
                    drpStatusInPro.DataBind();
                    drpStatusInPro.Items.Insert(0, new ListItem("--All--", "0"));

                    for (int i = 0; i < drpStatusInPro.Items.Count; i++)
                    {
                        if (drpStatusInPro.Items[i].Text == "Assigned")
                        {
                            drpStatusInPro.Items[i].Attributes.CssStyle.Add("color", "LawnGreen");
                        }
                        if (drpStatusInPro.Items[i].Text == "Requested")
                        {
                            drpStatusInPro.Items[i].Attributes.CssStyle.Add("color", "Red");
                        }

                        if (lblStatus.Value == drpStatusInPro.Items[i].Value)
                        {
                            drpStatusInPro.SelectedIndex = i;
                        }

                    }

                }
                else
                {
                    //----- If user level then show Test,Live,Finished statuses
                    string[] arrStatus = new string[] { JGConstant.TaskStatus.Requested.ToString(), JGConstant.TaskStatus.Assigned.ToString(), JGConstant.TaskStatus.Open.ToString(), JGConstant.TaskStatus.InProgress.ToString(), JGConstant.TaskStatus.Test.ToString(), JGConstant.TaskStatus.Finished.ToString() };
                    drpStatusInPro.DataSource = FillStatusDropDowns(arrStatus);  //objListItemCollection;
                    drpStatusInPro.DataTextField = "Text";
                    drpStatusInPro.DataValueField = "Value";
                    drpStatusInPro.DataBind();
                    drpStatusInPro.Items.Insert(0, new ListItem("--All--", "0"));
                    for (int i = 0; i < drpStatusInPro.Items.Count; i++)
                    {
                        if (drpStatusInPro.Items[i].Text == "Assigned")
                        {
                            drpStatusInPro.Items[i].Attributes.CssStyle.Add("color", "LawnGreen");
                        }
                        if (drpStatusInPro.Items[i].Text == "Requested")
                        {
                            drpStatusInPro.Items[i].Attributes.CssStyle.Add("color", "Red");
                        }

                        if (lblStatus.Value == drpStatusInPro.Items[i].Value)
                        {
                            drpStatusInPro.SelectedIndex = i;
                        }
                    }
                }
            }
        }
        protected void grdTaskClosed_RowDataBound(object sender, GridViewRowEventArgs e)
        {
            if (e.Row.RowType == DataControlRowType.DataRow)
            {
                HiddenField lblStatus = e.Row.FindControl("lblStatus") as HiddenField;
                //Label lblDueDate = e.Row.FindControl("lblDueDate") as Label;
                DropDownList drpStatusClosed = e.Row.FindControl("drpStatusClosed") as DropDownList;
                HiddenField lblTaskIdClosed = e.Row.FindControl("lblTaskIdClosed") as HiddenField;
                HiddenField hdnMainParentId = e.Row.FindControl("hdnMainParentId") as HiddenField;

                LinkButton lnkInstallId = e.Row.FindControl("lnkInstallId") as LinkButton;
                HiddenField lblParentTaskIdClosed = e.Row.FindControl("lblParentTaskIdClosed") as HiddenField;

                //lnkInstallId.PostBackUrl = "~/Sr_App/TaskGenerator.aspx?TaskId=" + hdnMainParentId.Value + "&hstid=" + lblTaskIdClosed.Value;
                lnkInstallId.PostBackUrl = "javascript:w= window.open('" + System.Configuration.ConfigurationManager.AppSettings["UrlToReplaceForTemplates"] + "Sr_App/TaskGenerator.aspx?TaskId=" + hdnMainParentId.Value + "&hstid=" + lblTaskIdClosed.Value + "','JG Sales','left=20,top=20,width=1000,height=600,toolbar=0,resizable=0');";
                //if (lblDueDate.Text != "")
                //{
                //    DateTime dtDue = new DateTime();
                //    dtDue = Convert.ToDateTime(lblDueDate.Text);
                //    lblDueDate.Text = dtDue.ToString("dd-MMM-yyyy");
                //}

                if (lblStatus.Value == "7")
                {
                    //lblStatus.Value = "In Progress"
                    e.Row.BackColor = System.Drawing.Color.LightGray;
                }
                else if (lblStatus.Value == "13")
                {
                    //lblStatus.Value = "Assigned";
                    //lblStatus.ForeColor = System.Drawing.Color.LawnGreen;
                    e.Row.BackColor = System.Drawing.Color.Green;
                }
                else if (lblStatus.Value == "9")
                {
                    //lblStatus.Value = "Requested";
                    //lblStatus.ForeColor = System.Drawing.Color.Red;
                    e.Row.BackColor = System.Drawing.Color.Gray;
                }
                else
                {
                    System.Drawing.Color clr = System.Drawing.ColorTranslator.FromHtml("#f6f1f3");
                    e.Row.BackColor = clr;
                }

                int vTaskId = Convert.ToInt32(lblTaskIdClosed.Value);

                // fill status dropdowns
                //----- If manager level then show all statuses

                string[] arrStatus;
                if ((string)Session["DesigNew"] == "Admin")
                {
                    drpStatusClosed.DataSource = CommonFunction.GetTaskStatusList();
                }
                else if ((string)Session["DesigNew"] == "ITLead" || (string)Session["DesigNew"] == "Office Manager")
                {
                    arrStatus = new string[] { JGConstant.TaskStatus.Open.ToString(),JGConstant.TaskStatus.Requested.ToString(),
                        JGConstant.TaskStatus.Assigned.ToString(), JGConstant.TaskStatus.InProgress.ToString(),
                        JGConstant.TaskStatus.Pending.ToString(),  JGConstant.TaskStatus.ReOpened.ToString(),
                        JGConstant.TaskStatus.SpecsInProgress.ToString(),
                        JGConstant.TaskStatus.Finished.ToString(),
                        JGConstant.TaskStatus.Test.ToString(),JGConstant.TaskStatus.Live.ToString()
                    };
                    drpStatusClosed.DataSource = FillStatusDropDowns(arrStatus);
                }
                else
                {
                    //----- If user level then show Test,Live,Finished statuses
                    arrStatus = new string[] { JGConstant.TaskStatus.Test.ToString(), JGConstant.TaskStatus.Live.ToString() };
                    drpStatusClosed.DataSource = FillStatusDropDowns(arrStatus);
                }


                drpStatusClosed.DataTextField = "Text";
                drpStatusClosed.DataValueField = "Value";
                drpStatusClosed.DataBind();
                drpStatusClosed.Items.Insert(0, new ListItem("--All--", "0"));
                for (int i = 0; i < drpStatusClosed.Items.Count; i++)
                {

                    if (lblStatus.Value == drpStatusClosed.Items[i].Value)
                    {
                        drpStatusClosed.SelectedIndex = i;
                    }
                }

            }
        }

        protected void grdFrozenTask_RowDataBound(object sender, GridViewRowEventArgs e)
        {
            if (e.Row.RowType == DataControlRowType.DataRow)
            {
                HiddenField lblStatus = e.Row.FindControl("lblStatus") as HiddenField;
                //Label lblDueDate = e.Row.FindControl("lblDueDate") as Label;
                DropDownList drpStatusFrozen = e.Row.FindControl("drpStatusFrozen") as DropDownList;
                HiddenField lblTaskIdInPro = e.Row.FindControl("lblTaskIdInPro") as HiddenField;
                HiddenField frozenMainParentId = e.Row.FindControl("frozenMainParentId") as HiddenField;
                Label lblHoursLead = e.Row.FindControl("lblHoursLeadInPro") as Label;
                Label lblHoursDev = e.Row.FindControl("lblHoursDevInPro") as Label;
                LinkButton lnkInstallId = e.Row.FindControl("lnkInstallId") as LinkButton;
                HiddenField lblParentTaskIdInPro = e.Row.FindControl("lblParentTaskIdInPro") as HiddenField;
                HtmlGenericControl divAdmin = (HtmlGenericControl)e.Row.FindControl("divAdmin");
                HtmlGenericControl divITLead = (HtmlGenericControl)e.Row.FindControl("divITLead");
                HtmlGenericControl divUser = (HtmlGenericControl)e.Row.FindControl("divUser");

                //lnkInstallId.PostBackUrl = "~/Sr_App/TaskGenerator.aspx?TaskId=" + lblParentTaskIdInPro.Value + "&hstid=" + lblTaskIdInPro.Value;
                lnkInstallId.PostBackUrl = "javascript:w= window.open('" + System.Configuration.ConfigurationManager.AppSettings["UrlToReplaceForTemplates"] + "Sr_App/TaskGenerator.aspx?TaskId=" + frozenMainParentId.Value + "&hstid=" + lblTaskIdInPro.Value + "','JG Sales','left=20,top=20,width=1000,height=600,toolbar=0,resizable=0');";

                //if (lblDueDate.Text != "")
                //{
                //    DateTime dtDue = new DateTime();
                //    dtDue = Convert.ToDateTime(lblDueDate.Text);
                //    lblDueDate.Text = dtDue.ToString("dd-MMM-yyyy");
                //}

                bool blAdminStatus = false, blTechLeadStatus = false, blOtherUserStatus = false;

                if (!string.IsNullOrEmpty(DataBinder.Eval(e.Row.DataItem, "AdminStatus").ToString()))
                {
                    blAdminStatus = Convert.ToBoolean(DataBinder.Eval(e.Row.DataItem, "AdminStatus"));
                }
                if (!string.IsNullOrEmpty(DataBinder.Eval(e.Row.DataItem, "TechLeadStatus").ToString()))
                {
                    blTechLeadStatus = Convert.ToBoolean(DataBinder.Eval(e.Row.DataItem, "TechLeadStatus"));
                }
                if (!string.IsNullOrEmpty(DataBinder.Eval(e.Row.DataItem, "OtherUserStatus").ToString()))
                {
                    blOtherUserStatus = Convert.ToBoolean(DataBinder.Eval(e.Row.DataItem, "OtherUserStatus"));
                }

                if (blAdminStatus || blTechLeadStatus)
                {
                    lblHoursLead.Text = "Admin: " + Convert.ToString(DataBinder.Eval(e.Row.DataItem, "AdminOrITLeadEstimatedHours"));
                }
                if (blOtherUserStatus)
                {
                    lblHoursDev.Text = "Dev: " + Convert.ToString(DataBinder.Eval(e.Row.DataItem, "UserEstimatedHours"));
                }


                if (lblStatus.Value == "4")
                {
                    //lblStatus.Value = "In Progress";
                    e.Row.BackColor = System.Drawing.Color.Orange;
                }
                else if (lblStatus.Value == "3")
                {
                    //lblStatus.Value = "Assigned";
                    e.Row.BackColor = System.Drawing.Color.Yellow;
                }
                else if (lblStatus.Value == "2")
                {
                    //lblStatus.Value = "Requested";
                    e.Row.BackColor = System.Drawing.Color.Yellow;
                }
                else
                {
                    ////lblStatus.Value = "Open";
                    System.Drawing.Color clr = System.Drawing.ColorTranslator.FromHtml("#f6f1f3");
                    e.Row.BackColor = clr;
                }



                // fill status dropdowns
                //----- If manager level then show all statuses
                if ((string)Session["DesigNew"] == "ITLead" || (string)Session["DesigNew"] == "Admin" || (string)Session["DesigNew"] == "Office Manager")
                {
                    drpStatusFrozen.DataSource = CommonFunction.GetTaskStatusList();
                    drpStatusFrozen.DataTextField = "Text";
                    drpStatusFrozen.DataValueField = "Value";
                    drpStatusFrozen.DataBind();
                    drpStatusFrozen.Items.Insert(0, new ListItem("--All--", "0"));

                    for (int i = 0; i < drpStatusFrozen.Items.Count; i++)
                    {
                        if (drpStatusFrozen.Items[i].Text == "Assigned")
                        {
                            drpStatusFrozen.Items[i].Attributes.CssStyle.Add("color", "LawnGreen");
                        }
                        if (drpStatusFrozen.Items[i].Text == "Requested")
                        {
                            drpStatusFrozen.Items[i].Attributes.CssStyle.Add("color", "Red");
                        }

                        if (lblStatus.Value == drpStatusFrozen.Items[i].Value)
                        {
                            drpStatusFrozen.SelectedIndex = i;
                        }

                    }

                }
                else
                {
                    //----- If user level then show Test,Live,Finished statuses
                    string[] arrStatus = new string[] { JGConstant.TaskStatus.Requested.ToString(), JGConstant.TaskStatus.Assigned.ToString(), JGConstant.TaskStatus.Open.ToString(), JGConstant.TaskStatus.InProgress.ToString(), JGConstant.TaskStatus.Test.ToString(), JGConstant.TaskStatus.Finished.ToString() };
                    drpStatusFrozen.DataSource = FillStatusDropDowns(arrStatus);  //objListItemCollection;
                    drpStatusFrozen.DataTextField = "Text";
                    drpStatusFrozen.DataValueField = "Value";
                    drpStatusFrozen.DataBind();
                    drpStatusFrozen.Items.Insert(0, new ListItem("--All--", "0"));
                    for (int i = 0; i < drpStatusFrozen.Items.Count; i++)
                    {
                        if (drpStatusFrozen.Items[i].Text == "Assigned")
                        {
                            drpStatusFrozen.Items[i].Attributes.CssStyle.Add("color", "LawnGreen");
                        }
                        if (drpStatusFrozen.Items[i].Text == "Requested")
                        {
                            drpStatusFrozen.Items[i].Attributes.CssStyle.Add("color", "Red");
                        }

                        if (lblStatus.Value == drpStatusFrozen.Items[i].Value)
                        {
                            drpStatusFrozen.SelectedIndex = i;
                        }
                    }
                }

                drpStatusFrozen.Attributes.Add("data-task-id", lblTaskIdInPro.Value);
            }
        }

        protected void grdNewTask_RowDataBound(object sender, GridViewRowEventArgs e)
        {
            if (e.Row.RowType == DataControlRowType.DataRow)
            {
                HiddenField lblStatus = e.Row.FindControl("lblStatus") as HiddenField;
                //Label lblDueDate = e.Row.FindControl("lblDueDate") as Label;
                DropDownList drpStatusInPro = e.Row.FindControl("drpStatusInPro") as DropDownList;
                DropDownList drpStatusFrozen = e.Row.FindControl("drpStatusFrozen") as DropDownList;
                HiddenField lblTaskIdInPro = e.Row.FindControl("lblTaskIdInPro") as HiddenField;
                HiddenField nonfrozenMainParentId = e.Row.FindControl("nonfrozenMainParentId") as HiddenField;
                Label lblHoursLead = e.Row.FindControl("lblHoursLeadInPro") as Label;
                Label lblHoursDev = e.Row.FindControl("lblHoursDevInPro") as Label;
                LinkButton lnkInstallId = e.Row.FindControl("lnkInstallId") as LinkButton;
                HiddenField lblParentTaskIdInPro = e.Row.FindControl("lblParentTaskIdInPro") as HiddenField;

                //lnkInstallId.PostBackUrl = "~/Sr_App/TaskGenerator.aspx?TaskId=" + lblParentTaskIdInPro.Value + "&hstid=" + lblTaskIdInPro.Value;
                lnkInstallId.PostBackUrl = "javascript:w= window.open('" + System.Configuration.ConfigurationManager.AppSettings["UrlToReplaceForTemplates"] + "Sr_App/TaskGenerator.aspx?TaskId=" + nonfrozenMainParentId.Value + "&hstid=" + lblTaskIdInPro.Value + "','JG Sales','left=20,top=20,width=1000,height=600,toolbar=0,resizable=0');";

                //if (lblDueDate.Text != "")
                //{
                //    DateTime dtDue = new DateTime();
                //    dtDue = Convert.ToDateTime(lblDueDate.Text);
                //    lblDueDate.Text = dtDue.ToString("dd-MMM-yyyy");
                //}

                if (lblStatus.Value == "4")
                {
                    //lblStatus.Value = "In Progress";
                    e.Row.BackColor = System.Drawing.Color.Orange;
                }
                else if (lblStatus.Value == "3")
                {
                    //lblStatus.Value = "Assigned";
                    e.Row.BackColor = System.Drawing.Color.Yellow;
                }
                else if (lblStatus.Value == "2")
                {
                    //lblStatus.Value = "Requested";
                    e.Row.BackColor = System.Drawing.Color.Yellow;
                }
                else
                {
                    ////lblStatus.Value = "Open";
                    System.Drawing.Color clr = System.Drawing.ColorTranslator.FromHtml("#f6f1f3");
                    e.Row.BackColor = clr;
                }



                // fill status dropdowns
                //----- If manager level then show all statuses
                if ((string)Session["DesigNew"] == "ITLead" || (string)Session["DesigNew"] == "Admin" || (string)Session["DesigNew"] == "Office Manager")
                {
                    drpStatusFrozen.DataSource = CommonFunction.GetTaskStatusList();
                    drpStatusFrozen.DataTextField = "Text";
                    drpStatusFrozen.DataValueField = "Value";
                    drpStatusFrozen.DataBind();
                    drpStatusFrozen.Items.Insert(0, new ListItem("--All--", "0"));

                    for (int i = 0; i < drpStatusFrozen.Items.Count; i++)
                    {
                        if (drpStatusFrozen.Items[i].Text == "Assigned")
                        {
                            drpStatusFrozen.Items[i].Attributes.CssStyle.Add("color", "LawnGreen");
                        }
                        if (drpStatusFrozen.Items[i].Text == "Requested")
                        {
                            drpStatusFrozen.Items[i].Attributes.CssStyle.Add("color", "Red");
                        }

                        if (lblStatus.Value == drpStatusFrozen.Items[i].Value)
                        {
                            drpStatusFrozen.SelectedIndex = i;
                        }

                    }

                }
                else
                {
                    //----- If user level then show Test,Live,Finished statuses
                    string[] arrStatus = new string[] { JGConstant.TaskStatus.Requested.ToString(), JGConstant.TaskStatus.Assigned.ToString(), JGConstant.TaskStatus.Open.ToString(), JGConstant.TaskStatus.InProgress.ToString(), JGConstant.TaskStatus.Test.ToString(), JGConstant.TaskStatus.Finished.ToString() };
                    drpStatusFrozen.DataSource = FillStatusDropDowns(arrStatus);  //objListItemCollection;
                    drpStatusFrozen.DataTextField = "Text";
                    drpStatusFrozen.DataValueField = "Value";
                    drpStatusFrozen.DataBind();
                    drpStatusFrozen.Items.Insert(0, new ListItem("--All--", "0"));
                    for (int i = 0; i < drpStatusFrozen.Items.Count; i++)
                    {
                        if (drpStatusFrozen.Items[i].Text == "Assigned")
                        {
                            drpStatusFrozen.Items[i].Attributes.CssStyle.Add("color", "LawnGreen");
                        }
                        if (drpStatusFrozen.Items[i].Text == "Requested")
                        {
                            drpStatusFrozen.Items[i].Attributes.CssStyle.Add("color", "Red");
                        }

                        if (lblStatus.Value == drpStatusFrozen.Items[i].Value)
                        {
                            drpStatusFrozen.SelectedIndex = i;
                        }
                    }
                }

                drpStatusFrozen.Attributes.Add("data-task-id", lblTaskIdInPro.Value);
            }
        }

        private string GetSelectedDesignationsString(ListBox drpChkBoxes)
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

        private System.Web.UI.WebControls.ListItemCollection FillStatusDropDowns(string[] lst)
        {
            ListItemCollection objListItemCollection = new ListItemCollection();
            int enumlen = Enum.GetNames(typeof(JGConstant.TaskStatus)).Length;

            foreach (var item in Enum.GetNames(typeof(JGConstant.TaskStatus)))
            {
                for (int j = 0; j < lst.Length; j++)
                {
                    if (lst[j] == item)
                    {
                        int enumval = (int)Enum.Parse(typeof(JGConstant.TaskStatus), item);
                        objListItemCollection.Add(new ListItem(item, enumval.ToString()));

                        break;
                    }
                }
            }
            return objListItemCollection;
        }

        [WebMethod]
        public static string GetTaskChatMessages(int taskId, int chatSourceId, int taskMultilevelListId = 0)
        {
            var users = ChatBLL.Instance.GetTaskUsers(taskId).Results;
            string receiverId = string.Empty;
            if (users != null && users.Count() > 0)
            {
                receiverId = string.Join(",", users.OrderBy(m => m).ToList());
            }
            List<ChatMessage> chatMessages = ChatBLL.Instance.GetTaskChatMessages(JGSession.UserId, chatSourceId, taskId,1,5, taskMultilevelListId).Results;
            PagingResult<Notes> notes = new PagingResult<Notes>();
            notes.Status = ActionStatus.Successfull;
            notes.TotalResults = chatMessages.Count();
            notes.Message = receiverId;
            notes.Data = chatMessages.Select(m => new Notes
            {
                UserChatGroupId = m.UserChatGroupId,
                TaskMultilevelListId = taskMultilevelListId,
                TaskId = taskId,
                UpdatedByUserID = m.UserId,
                UpdatedUserInstallID = m.UserInstallId,
                ChangeDateTime = m.MessageAt,
                LogDescription = m.Message,
                UpdatedByFirstName = m.UserFullname.Split(new char[] { ' ' }, StringSplitOptions.RemoveEmptyEntries)[0],
                UpdatedByLastName = m.UserFullname.Split(new char[] { ' ' }, StringSplitOptions.RemoveEmptyEntries).Count() > 1 ? m.UserFullname.Split(new char[] { ' ' }, StringSplitOptions.RemoveEmptyEntries)[1] : "",
                UpdatedByEmail = "",
                FristName = m.UserFullname.Split(new char[] { ' ' }, StringSplitOptions.RemoveEmptyEntries)[0],
                LastName = m.UserFullname.Split(new char[] { ' ' }, StringSplitOptions.RemoveEmptyEntries).Count() > 1 ? m.UserFullname.Split(new char[] { ' ' }, StringSplitOptions.RemoveEmptyEntries)[1] : "",
                Email = "",
                Phone = "",
                ChangeDateTimeFormatted = m.MessageAtFormatted,
                SourceUser = m.UserFullname.Split(new char[] { ' ' }, StringSplitOptions.RemoveEmptyEntries)[0],
                SourceUserInstallId = m.UserInstallId,
                SourceUsername = m.UserFullname,
                TouchPointSource = m.ChatSourceId,
                IsRead = m.IsRead
            }).OrderByDescending(x => x.ChangeDateTime).OrderByDescending(x => x.ChangeDateTime).ToList();
            //PagingResult<Notes> notes = InstallUserBLL.Instance.GetUserTouchPointLogs(pageNumber, pageSize, userId);
            return new JavaScriptSerializer().Serialize(notes);
        }

        [WebMethod]
        public static string AddNotes(int taskId, int taskMultilevelListId, string note, int touchPointSource)
        {
            var users = ChatBLL.Instance.GetTaskUsers(taskId).Results;
            string receiverId = string.Empty;
            if (users != null && users.Count() > 0)
            {
                receiverId = string.Join(",", users.OrderBy(m => m).ToList());
            }
            if (string.IsNullOrEmpty(note) || string.IsNullOrEmpty(receiverId))
            {
                return new JavaScriptSerializer().Serialize(new ActionOutput { Status = ActionStatus.Successfull });
            }
            string strUserInstallId = JGSession.Username + " - " + JGSession.LoginUserID;
            int userID = Convert.ToInt32(JGSession.LoginUserID);
            string ChatGroupId = string.Empty;
            //InstallUserBLL.Instance.AddTouchPointLogRecord(userID, id, strUserInstallId, DateTime.UtcNow, "Note : " + note, "", touchPointSource);
            var chat = ChatBLL.Instance.GetTaskChatMessages(JGSession.UserId, touchPointSource, taskId,1,5, taskMultilevelListId);
            if (chat != null && chat.Results != null && chat.Results.Count() > 0)
            {
                ChatGroupId = chat.Results[0].ChatGroupId;
            }
            else
            {
                ChatGroupId = Guid.NewGuid().ToString();
            }
            ChatBLL.Instance.SaveChatMessage(new ChatMessage
            {
                TaskId = taskId,
                TaskMultilevelListId = taskMultilevelListId,
                Message = note,
                FileId = null,
                ChatSourceId = touchPointSource,
                UserId = userID,
                UserProfilePic = "",
                UserFullname = "",
                UserInstallId = "",
                MessageAt = DateTime.UtcNow.ToEST(),
                MessageAtFormatted = DateTime.UtcNow.ToEST().ToString()
            }, ChatGroupId, receiverId, JGSession.UserId);

            bool sendEmail = false;
            // sort ReceiverIds into Asc
            List<int?> ids = receiverId.Split(new char[] { ',' }, StringSplitOptions.RemoveEmptyEntries)
                                       .Select(m => (int?)Convert.ToInt32(m))
                                       .Distinct()
                                       .ToList();

            // Remove SenderId From ReceiverIds
            if (ids.Count() > 0 && ids.Contains(JGSession.UserId))
                ids.Remove(JGSession.UserId);
            // Send Email notification to all offline users
            if (SingletonUserChatGroups.Instance.ActiveUsers.Where(m => ids.Contains(m.UserId)).Any())
            {
                string baseurl = HttpContext.Current.Request.Url.Scheme + "://" +
                                    HttpContext.Current.Request.Url.Authority +
                                    HttpContext.Current.Request.ApplicationPath.TrimEnd('/') + "/";
                foreach (ActiveUser item in SingletonUserChatGroups.Instance.ActiveUsers.Where(m => ids.Contains(m.UserId) && !m.OnlineAt.HasValue).ToList())
                {
                    ChatBLL.Instance.SendOfflineChatEmail(userID, item.UserId.Value, strUserInstallId,
                                                            note, touchPointSource, baseurl, ChatGroupId, touchPointSource);
                }
            }

            return new JavaScriptSerializer().Serialize(new ActionOutput { Status = ActionStatus.Successfull });
        }
    }

}