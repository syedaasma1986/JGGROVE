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
using System.Web.UI.HtmlControls;
using System.Web.UI.WebControls;

namespace JG_Prospect.Sr_App
{
    public partial class add_edit_aptitude_test : System.Web.UI.Page
    {
        #region '--Members--'

        DataTable dtExam = null;

        #endregion

        #region '--Properties--'

        public DataTable Questions
        {
            get
            {
                if (ViewState["Questions"] == null)
                {
                    DataTable dtQuestion = new DataTable();

                    dtQuestion.Columns.Add("QuestionID", typeof(long));
                    dtQuestion.Columns.Add("Question", typeof(string));
                    dtQuestion.Columns.Add("QuestionType", typeof(long));
                    dtQuestion.Columns.Add("PositiveMarks", typeof(long));
                    dtQuestion.Columns.Add("NegetiveMarks", typeof(long));
                    dtQuestion.Columns.Add("ExamID", typeof(long));
                    dtQuestion.Columns.Add("AnswerOptionID", typeof(long));

                    dtQuestion.Columns.Add("QuestionUniqueID", typeof(string));
                    dtQuestion.Columns.Add("AnswerOptionUniqueID", typeof(string));

                    ViewState["Questions"] = dtQuestion;
                }

                return (DataTable)ViewState["Questions"];
            }
            set
            {
                ViewState["Questions"] = value;
            }
        }

        public DataTable Options
        {
            get
            {
                if (ViewState["Options"] == null)
                {
                    DataTable dtOptions = new DataTable();

                    dtOptions.Columns.Add("OptionID", typeof(long));
                    dtOptions.Columns.Add("OptionText", typeof(string));
                    dtOptions.Columns.Add("QuestionID", typeof(long));
                    dtOptions.Columns.Add("QuestionUniqueID", typeof(string));
                    dtOptions.Columns.Add("OptionUniqueID", typeof(string));

                    ViewState["Options"] = dtOptions;
                }

                return (DataTable)ViewState["Options"];
            }
            set
            {
                ViewState["Options"] = value;
            }
        }

        public Int64 ExamID
        {
            get
            {

                if (string.IsNullOrEmpty(Request.QueryString["ExamID"]))
                {
                    return 0;
                }

                return Convert.ToInt64(Request.QueryString["ExamID"]);
            }
        }

        #endregion

        #region '--Page Events--'

        protected void Page_Load(object sender, EventArgs e)
        {
            CommonFunction.AuthenticateUser();

            if (!IsPostBack)
            {
                FillddlDesignation();

                if (this.ExamID > 0)
                {
                    ltrlPageHeader.Text = "Edit Aptitude Test";

                    FillMCQ_ExamDetails();
                }
                else
                {
                    ltrlPageHeader.Text = "Add Aptitude Test";
                }
            }
        }

        #endregion

        #region '--Control Events--'

        protected void lbtnAddQuestion_Click(object sender, EventArgs e)
        {
            // clear rows, to refresh from repeater.
            Questions.Rows.Clear();
            Options.Rows.Clear();

            DataRow drQuestion = null;

            // get updated data from repeater.
            foreach (RepeaterItem objItem in repQuestions.Items)
            {
                HiddenField hdnQuestionID = objItem.FindControl("hdnQuestionID") as HiddenField;
                HiddenField hdnQuestionUniqueID = objItem.FindControl("hdnQuestionUniqueID") as HiddenField;
                TextBox txtQuestion = objItem.FindControl("txtQuestion") as TextBox;
                TextBox txtPositiveMarks = objItem.FindControl("txtPositiveMarks") as TextBox;
                TextBox txtNegetiveMarks = objItem.FindControl("txtNegetiveMarks") as TextBox;
                Repeater repOptions = objItem.FindControl("repOptions") as Repeater;

                string strAnswerOptionUniqueID = string.Empty;
                long intAnswerOptionID = 0;
                DataRow drOption = null;
                foreach (RepeaterItem objOption in repOptions.Items)
                {
                    RadioButton rdoIsAnswer = objOption.FindControl("rdoIsAnswer") as RadioButton;
                    HiddenField hdnOptionID = objOption.FindControl("hdnOptionID") as HiddenField;
                    HiddenField hdnOptionUniqueID = objOption.FindControl("hdnOptionUniqueID") as HiddenField;
                    TextBox txtOptionText = objOption.FindControl("txtOptionText") as TextBox;

                    if (rdoIsAnswer.Checked)
                    {
                        intAnswerOptionID = Convert.ToInt64(hdnOptionID.Value);
                        strAnswerOptionUniqueID = hdnOptionUniqueID.Value;
                    }

                    drOption = Options.NewRow();
                    drOption["OptionID"] = Convert.ToInt64(hdnOptionID.Value);
                    drOption["QuestionID"] = Convert.ToInt64(hdnQuestionID.Value);
                    drOption["OptionText"] = txtOptionText.Text.Trim();
                    drOption["QuestionUniqueID"] = hdnQuestionUniqueID.Value;
                    drOption["OptionUniqueID"] = hdnOptionUniqueID.Value;
                    Options.Rows.Add(drOption);
                }

                drQuestion = Questions.NewRow();
                drQuestion["QuestionID"] = Convert.ToInt64(hdnQuestionID.Value);
                drQuestion["Question"] = txtQuestion.Text.Trim();
                drQuestion["QuestionType"] = 1;
                drQuestion["PositiveMarks"] = Convert.ToInt64(txtPositiveMarks.Text);
                drQuestion["NegetiveMarks"] = Convert.ToInt64(txtNegetiveMarks.Text);
                drQuestion["AnswerOptionID"] = intAnswerOptionID;
                drQuestion["AnswerOptionUniqueID"] = strAnswerOptionUniqueID;
                drQuestion["QuestionUniqueID"] = Convert.ToString(hdnQuestionUniqueID.Value);
                Questions.Rows.Add(drQuestion);
            }

            // add new blank row.
            drQuestion = Questions.NewRow();
            drQuestion["QuestionID"] = 0;
            drQuestion["Question"] = string.Empty;
            drQuestion["QuestionType"] = 1;
            drQuestion["PositiveMarks"] = 1;
            drQuestion["NegetiveMarks"] = 1;
            drQuestion["AnswerOptionID"] = 0;
            drQuestion["AnswerOptionUniqueID"] = string.Empty;
            drQuestion["QuestionUniqueID"] = Guid.NewGuid().ToString();
            Questions.Rows.Add(drQuestion);

            repQuestions.DataSource = Questions;
            repQuestions.DataBind();

            upQuestions.Update();
        }

        protected void repQuestions_ItemCommand(object source, RepeaterCommandEventArgs e)
        {
            if (e.CommandName == "SaveMcQ")
            {
                SaveMCQ(e.Item);

                FillMCQ_ExamDetails();
            }
        }

        protected void btnSaveExam_Click(object sender, EventArgs e)
        {
            MCQ_Exam objMCQ_Exam = GetMCQ_Exam();

            #region MCQ_Exam

            if (objMCQ_Exam.ExamID > 0)
            {
                AptitudeTestBLL.Instance.UpdateMCQ_Exam(objMCQ_Exam);
            }
            else
            {
                objMCQ_Exam.ExamID = AptitudeTestBLL.Instance.InsertMCQ_Exam(objMCQ_Exam);
            }

            #endregion

            foreach (RepeaterItem riQuestion in repQuestions.Items)
            {
                #region MCQ_Question

                MCQ_Question objMCQ_Question = new MCQ_Question();
                objMCQ_Question.ExamID = objMCQ_Exam.ExamID;
                objMCQ_Question.QuestionID = Convert.ToInt64((riQuestion.FindControl("hdnQuestionID") as HiddenField).Value.Trim());
                objMCQ_Question.Question = (riQuestion.FindControl("txtQuestion") as TextBox).Text.Trim();
                objMCQ_Question.PositiveMarks = Convert.ToInt64((riQuestion.FindControl("txtPositiveMarks") as TextBox).Text.Trim());
                objMCQ_Question.NegetiveMarks = Convert.ToInt64((riQuestion.FindControl("txtNegetiveMarks") as TextBox).Text.Trim());
                objMCQ_Question.QuestionType = 1;

                if (objMCQ_Question.QuestionID > 0)
                {
                    AptitudeTestBLL.Instance.UpdateMCQ_Question(objMCQ_Question);
                }
                else
                {
                    objMCQ_Question.QuestionID = AptitudeTestBLL.Instance.InsertMCQ_Question(objMCQ_Question);
                }

                #endregion

                Repeater repOptions = (riQuestion.FindControl("repOptions") as Repeater);

                foreach (RepeaterItem riOptions in repOptions.Items)
                {
                    #region MCQ_Option & Answer

                    MCQ_Option objMCQ_Option = new MCQ_Option();
                    objMCQ_Option.OptionID = Convert.ToInt64((riOptions.FindControl("hdnOptionID") as HiddenField).Value.Trim());
                    objMCQ_Option.OptionText = (riOptions.FindControl("txtOptionText") as TextBox).Text.Trim();
                    objMCQ_Option.QuestionID = objMCQ_Question.QuestionID;

                    if (objMCQ_Option.OptionID > 0)
                    {
                        AptitudeTestBLL.Instance.UpdateMCQ_Option(objMCQ_Option);

                        HtmlInputHidden hdnIsAnswer = (HtmlInputHidden) riOptions.FindControl("hdnIsAnswer") ;

                        if (hdnIsAnswer.Value.Equals("1"))
                        {
                            AptitudeTestBLL.Instance.UpdateMCQ_CorrectAnswer(objMCQ_Option);
                        }
                    }
                    else
                    {
                        objMCQ_Option.OptionID = AptitudeTestBLL.Instance.InsertMCQ_Option(objMCQ_Option);

                        HtmlInputHidden hdnIsAnswer = (HtmlInputHidden)riOptions.FindControl("hdnIsAnswer");

                        if (hdnIsAnswer.Value.Equals("1"))
                        {
                            AptitudeTestBLL.Instance.InsertMCQ_CorrectAnswer(objMCQ_Option);
                        }
                    }

                    #endregion
                }
            }

            Response.Redirect("~/sr_app/view-aptitude-test.aspx?ExamID=" + objMCQ_Exam.ExamID);
        }
        
        protected void repQuestions_ItemCreated(object sender, RepeaterItemEventArgs e)
        {
            ScriptManager scriptMan = ScriptManager.GetCurrent(this);
            LinkButton btn = e.Item.FindControl("lbtnSaveMCQ") as LinkButton;
            if (btn != null)
            {
                //btn.Click += LinkButton1_Click;
                scriptMan.RegisterAsyncPostBackControl(btn);
            }
        }

        #endregion

        #region '--Methods--'

        private void FillMCQ_ExamDetails()
        {
            DataSet dsExam = AptitudeTestBLL.Instance.GetMCQ_ExamByID(this.ExamID);

            if (dsExam != null && dsExam.Tables.Count > 0)
            {
                dtExam = dsExam.Tables[0];

                if (dtExam.Rows.Count > 0)
                {
                    #region '--Exam--'

                    txtTitle.Text = Convert.ToString(dtExam.Rows[0]["ExamTitle"]);
                    txtDescription.Text = Convert.ToString(dtExam.Rows[0]["ExamDescription"]);
                    txtDuration.Text = Convert.ToString(dtExam.Rows[0]["ExamDuration"]);
                    txtPassPercentage.Text = Convert.ToString(dtExam.Rows[0]["PassPercentage"]);
                    chkActive.Checked = Convert.ToBoolean(dtExam.Rows[0]["IsActive"]);

                    if (!string.IsNullOrEmpty(Convert.ToString(dtExam.Rows[0]["DesignationID"])))
                    {
                        foreach (String DIds in Convert.ToString(dtExam.Rows[0]["DesignationID"]).Split(','))
                        {
                            ListItem item = ddlDesigAptitude.Items.FindByValue(DIds);

                            if (item != null)
                            {
                                item.Selected = true;
                            }
                        }
                    }

                    #endregion

                    #region '--Questions & Options--'

                    if (dsExam.Tables.Count > 1)
                    {
                        Questions = dsExam.Tables[1];
                        Questions.Columns.Add("QuestionUniqueID", typeof(string));
                        Questions.Columns.Add("AnswerOptionUniqueID", typeof(string));

                        for (int i = 0; i < Questions.Rows.Count; i++)
                        {
                            Questions.Rows[i]["QuestionUniqueID"] = Convert.ToString(Questions.Rows[i]["QuestionID"]);
                            Questions.Rows[i]["AnswerOptionUniqueID"] = Convert.ToString(Questions.Rows[i]["AnswerOptionID"]);
                        }

                        if (dsExam.Tables.Count > 2)
                        {
                            Options = dsExam.Tables[2];
                            Options.Columns.Add("QuestionUniqueID", typeof(string));
                            Options.Columns.Add("OptionUniqueID", typeof(string));

                            for (int i = 0; i < Options.Rows.Count; i++)
                            {
                                Options.Rows[i]["OptionUniqueID"] = Convert.ToString(Options.Rows[i]["OptionID"]);
                                Options.Rows[i]["QuestionUniqueID"] = Convert.ToString(Options.Rows[i]["QuestionID"]);
                            }
                        }

                        repQuestions.DataSource = Questions;
                        repQuestions.DataBind();
                    }

                    #endregion
                }
            }
        }

        protected bool IsCorrectAnswer(string strQuestionUniqueID, string strOptionUniqueID)
        {
            if (Options != null)
            {
                DataView dvQuestions = Questions.DefaultView;

                dvQuestions.RowFilter = string.Format("QuestionUniqueID = '{0}' AND AnswerOptionUniqueID = '{1}'", strQuestionUniqueID, strOptionUniqueID);

                return (dvQuestions.ToTable().Rows.Count == 1);
            }

            return false;
        }

        protected DataTable GetOptionsByQuestionID(string strQuestionUniqueID)
        {
            var _dataTable = new DataTable();
            if (Options != null)
            {
                DataView dvOptions = Options.DefaultView;
                dvOptions.RowFilter = string.Format("QuestionUniqueID = '{0}'", strQuestionUniqueID);
                _dataTable = dvOptions.ToTable();
            }

            if (_dataTable.Rows.Count <= 0)
            {
                for (var i = 0; i < 4; i++)
                {
                    DataRow drOption = Options.NewRow();
                    drOption["OptionID"] = 0;
                    drOption["QuestionID"] = 0;
                    drOption["OptionText"] = "";
                    drOption["QuestionUniqueID"] = strQuestionUniqueID.ToString();
                    drOption["OptionUniqueID"] = Guid.NewGuid().ToString();
                    Options.Rows.Add(drOption);
                }

                return Options;
            }
            else
            {
                DataView dvOptions = Options.DefaultView;

                dvOptions.RowFilter = string.Format("QuestionUniqueID = '{0}'", strQuestionUniqueID);

                return dvOptions.ToTable();
            }
        }

        private void FillddlDesignation()
        {
            List<Designation> lstDesignations = DesignationBLL.Instance.GetAllDesignation();
            if (lstDesignations != null && lstDesignations.Any())
            {
                //ddlDesignation.DataSource = lstDesignations;
                //ddlDesignation.DataTextField = "DesignationName";
                //ddlDesignation.DataValueField = "ID";
                //ddlDesignation.DataBind();

                ddlDesigAptitude.Items.Clear();
                ddlDesigAptitude.DataSource = lstDesignations;
                ddlDesigAptitude.DataTextField = "DesignationName";
                ddlDesigAptitude.DataValueField = "ID";
                ddlDesigAptitude.DataBind();

            }
            //ddlDesignation.Items.Insert(0, new ListItem("--All--", "0"));
        }

        private MCQ_Exam GetMCQ_Exam()
        {
            MCQ_Exam objMCQ_Exam = new MCQ_Exam();
            objMCQ_Exam.ExamID = this.ExamID;
            objMCQ_Exam.CourseID = 0;
            //objMCQ_Exam.DesignationID = Convert.ToInt32(ddlDesignation.SelectedValue);
            objMCQ_Exam.DesignationID = GetSelectedDesignationsString(ddlDesigAptitude);
            objMCQ_Exam.ExamDescription = txtDescription.Text.Trim();
            objMCQ_Exam.ExamDuration = Convert.ToInt32(txtDuration.Text.Trim());
            objMCQ_Exam.ExamTitle = txtTitle.Text.Trim();
            objMCQ_Exam.IsActive = chkActive.Checked;
            objMCQ_Exam.PassPercentage = (float)Convert.ToDecimal(txtPassPercentage.Text.Trim());
            return objMCQ_Exam;
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

        private void SaveMCQ(RepeaterItem questionItem)
        {
            MCQ_Question objMCQ_Question = new MCQ_Question();
            objMCQ_Question.ExamID = this.ExamID;
            objMCQ_Question.QuestionID = Convert.ToInt64((questionItem.FindControl("hdnQuestionID") as HiddenField).Value.Trim());
            objMCQ_Question.Question = (questionItem.FindControl("txtQuestion") as TextBox).Text.Trim();
            objMCQ_Question.PositiveMarks = Convert.ToInt64((questionItem.FindControl("txtPositiveMarks") as TextBox).Text.Trim());
            objMCQ_Question.NegetiveMarks = Convert.ToInt64((questionItem.FindControl("txtNegetiveMarks") as TextBox).Text.Trim());
            objMCQ_Question.QuestionType = 1;

            if (objMCQ_Question.QuestionID > 0)
            {
                AptitudeTestBLL.Instance.UpdateMCQ_Question(objMCQ_Question);
            }
            else
            {
                objMCQ_Question.QuestionID = AptitudeTestBLL.Instance.InsertMCQ_Question(objMCQ_Question);
            }

            Repeater repOptions = (questionItem.FindControl("repOptions") as Repeater);
            SaveMCQOptions(objMCQ_Question.QuestionID, repOptions);
        }

        private static void SaveMCQOptions(long QuestionID, Repeater repOptions)
        {
            foreach (RepeaterItem riOptions in repOptions.Items)
            {
                MCQ_Option objMCQ_Option = new MCQ_Option();
                objMCQ_Option.OptionID = Convert.ToInt64((riOptions.FindControl("hdnOptionID") as HiddenField).Value.Trim());
                objMCQ_Option.OptionText = (riOptions.FindControl("txtOptionText") as TextBox).Text.Trim();
                objMCQ_Option.QuestionID = QuestionID;

                if (objMCQ_Option.OptionID > 0)
                {
                    AptitudeTestBLL.Instance.UpdateMCQ_Option(objMCQ_Option);


                    HtmlInputHidden hdnIsAnswer = (riOptions.FindControl("hdnIsAnswer") as HtmlInputHidden);

                    if (hdnIsAnswer != null && hdnIsAnswer.Value.Equals("1"))
                    {
                        AptitudeTestBLL.Instance.UpdateMCQ_CorrectAnswer(objMCQ_Option);
                    }
                }
                else
                {
                    objMCQ_Option.OptionID = AptitudeTestBLL.Instance.InsertMCQ_Option(objMCQ_Option);

                    HtmlInputHidden hdnIsAnswer = (riOptions.FindControl("hdnIsAnswer") as HtmlInputHidden);

                    if (hdnIsAnswer != null && hdnIsAnswer.Value.Equals("1"))
                    {
                        AptitudeTestBLL.Instance.InsertMCQ_CorrectAnswer(objMCQ_Option);
                    }
                }
            }
        }

        #endregion

    }
}
