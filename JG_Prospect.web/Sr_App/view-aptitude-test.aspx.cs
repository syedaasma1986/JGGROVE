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
    public partial class view_aptitude_test : System.Web.UI.Page
    {
        DataTable dtExam = null;
        DataTable dtQuestions = null;
        DataTable dtOptions = null;

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

        protected void Page_Load(object sender, EventArgs e)
        {
            CommonFunction.AuthenticateUser();

            if (!IsPostBack)
            {
                DataSet dsExam = AptitudeTestBLL.Instance.GetMCQ_ExamByID(this.ExamID);

                if (dsExam != null && dsExam.Tables.Count > 0)
                {
                    dtExam = dsExam.Tables[0];

                    if (dtExam.Rows.Count > 0)
                    {
                        ltrlTitle.Text = Convert.ToString(dtExam.Rows[0]["ExamTitle"]);
                        ltrlDescription.Text = Convert.ToString(dtExam.Rows[0]["ExamDescription"]);
                        ltrlDuration.Text = Convert.ToString(dtExam.Rows[0]["ExamDuration"]);
                        ltrlPassPercentage.Text = Convert.ToString(dtExam.Rows[0]["PassPercentage"]);
                        imgActive.Visible = Convert.ToBoolean(dtExam.Rows[0]["IsActive"]);
                        ltrlDesignation.Text = Convert.ToString(dtExam.Rows[0]["DesignationName"]);

                        if (imgActive.Visible)
                        {
                            imgActive.Src = Page.ResolveUrl("~/img/success.png");
                        }

                        if (dsExam.Tables.Count > 1)
                        {
                            dtQuestions = dsExam.Tables[1];

                            if (dsExam.Tables.Count > 2)
                            {
                                dtOptions = dsExam.Tables[2];
                            }

                            repQuestions.DataSource = dtQuestions;
                            repQuestions.DataBind();
                        } 
                    }
                }
            }
        }

        protected DataTable GetOptionsByQuestionID(Int64 intQuestionID)
        {
            if (dtOptions != null)
            {
                DataView dvOptions = dtOptions.DefaultView;

                dvOptions.RowFilter = string.Format("QuestionID = {0}", intQuestionID);

                return dvOptions.ToTable();
            }

            return null;
        }

        protected bool IsCorrectAnswer(Int64 intQuestionID, Int64 intOptionID)
        {
            if (dtOptions != null)
            {
                DataView dvQuestions = dtQuestions.DefaultView;

                dvQuestions.RowFilter = string.Format("QuestionID = {0} AND AnswerOptionID = {1}", intQuestionID, intOptionID);

                return (dvQuestions.ToTable().Rows.Count == 1);
            }

            return false;
        }
    }
}