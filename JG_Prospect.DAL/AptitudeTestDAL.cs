using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Data;
using System.Data.OleDb;

using System.Data.Common;
using Microsoft.Practices.EnterpriseLibrary.Data.Sql;
using JG_Prospect.DAL.Database;
using JG_Prospect.Common.modal;
using JG_Prospect.Common;
using System.Configuration;
using System.Data.SqlClient;

namespace JG_Prospect.DAL
{
    public class AptitudeTestDAL
    {
        private static AptitudeTestDAL m_AptitudeTestDAL = new AptitudeTestDAL();
        string constr = ConfigurationManager.ConnectionStrings["JGPA"].ConnectionString;

        private AptitudeTestDAL()
        {

        }

        public static AptitudeTestDAL Instance
        {
            get { return m_AptitudeTestDAL; }
            private set {; }
        }

        public DataTable GetPerformanceByUserID(int userID)
        {
            //string SQL = "select * from [MCQ_Performance] where UserID = '" + userID.ToString() + "'";

            //using (SqlConnection con = new SqlConnection(constr))
            //{
            //    using (SqlCommand cmd = new SqlCommand())
            //    {
            //        cmd.CommandText = SQL;
            //        using (SqlDataAdapter sda = new SqlDataAdapter())
            //        {
            //            cmd.Connection = con;
            //            sda.SelectCommand = cmd;
            //            using (DataSet ds = new DataSet())
            //            {
            //                DataTable dt = new DataTable();
            //                sda.Fill(dt);
            //                return dt;
            //            }
            //        }
            //    }
            //}
            DataTable dt = null;

            try
            {
                SqlDatabase database = MSSQLDataBase.Instance.GetDefaultDatabase();
                {
                    DbCommand command = database.GetStoredProcCommand("usp_GetCandidateTestsResults");
                    command.CommandType = CommandType.StoredProcedure;
                    database.AddInParameter(command, "@UserID", DbType.String, userID.ToString());
                    DataSet dsResult =  database.ExecuteDataSet(command);
                    

                    if ( dsResult != null && dsResult.Tables.Count > 0)
                    {
                        dt = dsResult.Tables[0];
                    }
                    
                }
            }
            catch (Exception ex)
            {
                
            }

            return dt;
        }

        public double GetExamsResultByUserID(int userID, ref bool isAllExamGiven)
        {
            Double aggregateResult = 0;
            try
            {
                SqlDatabase database = MSSQLDataBase.Instance.GetDefaultDatabase();
                {
                    DbCommand command = database.GetStoredProcCommand("usp_isAllExamsGivenByUser");
                    command.CommandType = CommandType.StoredProcedure;
                    database.AddInParameter(command, "@UserID", DbType.Int64, userID);
                    database.AddOutParameter(command, "@AggregateScored",DbType.Double,8);
                    database.AddOutParameter(command, "@AllExamsGiven", DbType.Boolean,1);
                    database.ExecuteNonQuery(command);

                    aggregateResult = Convert.ToDouble(database.GetParameterValue(command, "@AggregateScored"));

                        isAllExamGiven = Convert.ToBoolean(database.GetParameterValue(command, "@AllExamsGiven")); 
                }
            }
            catch (Exception ex)
            {

            }

            return aggregateResult;
        }
        public bool IsExamGivenByUserByExamId(int userID, int examId)
        {
            bool isExamGiven = false;
            try
            {
                SqlDatabase database = MSSQLDataBase.Instance.GetDefaultDatabase();
                {
                    DbCommand command = database.GetStoredProcCommand("usp_isExamsGivenByUser");
                    command.CommandType = CommandType.StoredProcedure;
                    database.AddInParameter(command, "@UserID", DbType.Int64, userID);
                    database.AddInParameter(command, "@examId", DbType.Int64, examId);
                    database.AddOutParameter(command, "@ExamGiven", DbType.Boolean, 1);
                    database.ExecuteNonQuery(command);
                    isExamGiven = Convert.ToBoolean(database.GetParameterValue(command, "@ExamGiven"));
                }

            }
            catch (Exception ex)
            {

            }

            return isExamGiven;
        }
        public bool IsAllExamGivenByUserId(int userID)
        {
            bool isExamGiven = false;
            try
            {
                SqlDatabase database = MSSQLDataBase.Instance.GetDefaultDatabase();
                {
                    DbCommand command = database.GetStoredProcCommand("usp_isAllExamsGivenByUserId");
                    command.CommandType = CommandType.StoredProcedure;
                    database.AddInParameter(command, "@UserID", DbType.Int64, userID);
                    database.AddOutParameter(command, "@ExamGiven", DbType.Boolean, 1);
                    database.ExecuteNonQuery(command);
                    isExamGiven = Convert.ToBoolean(database.GetParameterValue(command, "@ExamGiven"));
                }

            }
            catch (Exception ex)
            {

            }

            return isExamGiven;
        }

        public DataTable GetcorrectAnswerByQuestionID(int questionID)
        {
            string SQL = "select *, (select top 1 OptionText FROM MCQ_Option where OptionID=ma.OptionID AND QuestionID=ma.QuestionID) AS AnswerText from MCQ_CorrectAnswer ma where ma.QuestionId = " + questionID.ToString();
            using (SqlConnection con = new SqlConnection(constr))
            {
                using (SqlCommand cmd = new SqlCommand())
                {
                    cmd.CommandText = SQL;
                    using (SqlDataAdapter sda = new SqlDataAdapter())
                    {
                        cmd.Connection = con;
                        sda.SelectCommand = cmd;
                        using (DataSet ds = new DataSet())
                        {
                            DataTable dt = new DataTable();
                            sda.Fill(dt);
                            return dt;
                        }
                    }
                }
            }
        }

        public bool InsertPerformance(int installUserID, int examID, int marksEarned)
        {
            try
            {
                SqlDatabase database = MSSQLDataBase.Instance.GetDefaultDatabase();
                {
                    DbCommand command = database.GetStoredProcCommand("SP_InsertPerfomace");
                    command.CommandType = CommandType.StoredProcedure;

                    database.AddInParameter(command, "@installUserID", DbType.String, installUserID.ToString());
                    database.AddInParameter(command, "@examID", DbType.Int32, examID);
                    database.AddInParameter(command, "@marksEarned", DbType.Int32, marksEarned);
                    

                    database.ExecuteScalar(command);
                    //int res = Convert.ToInt32(database.GetParameterValue(command, "@result"));
                    return true;
                }
            }
            catch (Exception ex)
            {
                return false;

            }
        }

        public DataTable GetQuestionsoptionByQustionID(int questionID)
        {
            string SQL = "SELECT *  FROM [MCQ_Option] WHERE QuestionID = " + questionID.ToString();
            using (SqlConnection con = new SqlConnection(constr))
            {
                using (SqlCommand cmd = new SqlCommand())
                {
                    cmd.CommandText = SQL;
                    using (SqlDataAdapter sda = new SqlDataAdapter())
                    {
                        cmd.Connection = con;
                        sda.SelectCommand = cmd;
                        using (DataSet ds = new DataSet())
                        {
                            DataTable dt = new DataTable();
                            sda.Fill(dt);
                            return dt;
                        }
                    }
                }
            }
        }

        public DataTable GetQuestionsByID(int questionID)
        {
            string SQL = "SELECT *  FROM [MCQ_Question] where QuestionID = " + questionID.ToString();
            using (SqlConnection con = new SqlConnection(constr))
            {
                using (SqlCommand cmd = new SqlCommand())
                {
                    cmd.CommandText = SQL;
                    using (SqlDataAdapter sda = new SqlDataAdapter())
                    {
                        cmd.Connection = con;
                        sda.SelectCommand = cmd;
                        using (DataSet ds = new DataSet())
                        {
                            DataTable dt = new DataTable();
                            sda.Fill(dt);
                            return dt;
                        }
                    }
                }
            }
        }

        public DataTable GetQuestionsForExamByID(string examID)
        {
            DataTable dtResult = new DataTable();

            try
            {
                SqlDatabase database = MSSQLDataBase.Instance.GetDefaultDatabase();
                {
                    DbCommand command = database.GetStoredProcCommand("usp_GetQuestionsByExamID");
                    command.CommandType = CommandType.StoredProcedure;

                    database.AddInParameter(command, "@ExamId", DbType.Int32, examID);                  
                     
                  DataSet dsResult = database.ExecuteDataSet(command);

                    if (dsResult.Tables.Count > 0)
                    {
                        dtResult = dsResult.Tables[0];
                    }

                    return dtResult;
                }
            }
            catch (Exception ex)
            {
                return dtResult;

            }

        }

        public DataTable GetExamsByUserID(int userID)
        {
            try
            {
                SqlDatabase database = MSSQLDataBase.Instance.GetDefaultDatabase();
                {
                    DbCommand command = database.GetStoredProcCommand("usp_GetAptTestsByUserID");
                    command.CommandType = CommandType.StoredProcedure;
                    //if (intDesignationID.HasValue)
                    //{
                    database.AddInParameter(command, "@UserID", DbType.Int32, userID);
                    //}
                    return database.ExecuteDataSet(command).Tables[0];
                }
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }
        public DataTable GetExamByExamID(Enums.Aptitude_ExamType examType, int userID)
        {
            var UserDetails = UserDAL.Instance.getInstalluserDetails(userID);
            var _designationId = "0";
            if (UserDetails.Tables[0].Rows.Count > 0)
            {
                if (!string.IsNullOrEmpty(Convert.ToString(UserDetails.Tables[0].Rows[0]["DesignationID"])))
                {
                    _designationId = Convert.ToString(UserDetails.Tables[0].Rows[0]["DesignationID"]);
                }
            }

            string SQL = @"SELECT * FROM [MCQ_Exam] Ex WHERE
                (',' + RTRIM(Ex.DesignationID) + ',') LIKE '%," + _designationId + ",%' AND ExamID NOT IN ( "
                        + "select ExamID from [MCQ_Performance] where UserID = "
                        + "'" + userID + "'" + ")";

            using (SqlConnection con = new SqlConnection(constr))
            {
                using (SqlCommand cmd = new SqlCommand())
                {
                    cmd.CommandText = SQL;
                    using (SqlDataAdapter sda = new SqlDataAdapter())
                    {
                        cmd.Connection = con;
                        sda.SelectCommand = cmd;
                        using (DataSet ds = new DataSet())
                        {
                            DataTable dt = new DataTable();
                            sda.Fill(dt);
                            return dt;
                        }
                    }
                }
            }
        }

        public string GetExamDurationByID(string examID)
        {
            return "15";
        }

        public string GetExamNameByExamID(string examId)
        {
            string SQL = "select * from [MCQ_Exam] WHERE ExamID =" + examId;
            DataTable dt = new DataTable();
            using (SqlConnection con = new SqlConnection(constr))
            {
                using (SqlCommand cmd = new SqlCommand())
                {
                    cmd.CommandText = SQL;
                    using (SqlDataAdapter sda = new SqlDataAdapter())
                    {
                        cmd.Connection = con;
                        sda.SelectCommand = cmd;
                        using (DataSet ds = new DataSet())
                        {
                            sda.Fill(dt);
                        }
                    }
                }
            }
            if (dt.Rows.Count > 0)
            {
              return  dt.Rows[0]["ExamDescription"].ToString();
            }
            else
            {
                return "";
            }
        }

        public DataTable GetMCQ_Exams(string intDesignationID)
        {
            try
            {
                SqlDatabase database = MSSQLDataBase.Instance.GetDefaultDatabase();
                {
                    DbCommand command = database.GetStoredProcCommand("GetMCQ_Exams");
                    command.CommandType = CommandType.StoredProcedure;
                    //if (intDesignationID.HasValue)
                    //{
                    database.AddInParameter(command, "@DesignationID", DbType.String, intDesignationID);
                    //}
                    return database.ExecuteDataSet(command).Tables[0];
                }
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }

        public DataSet GetMCQ_ExamByID(Int64 intExamID)
        {
            try
            {
                SqlDatabase database = MSSQLDataBase.Instance.GetDefaultDatabase();
                {
                    DbCommand command = database.GetStoredProcCommand("GetMCQ_ExamByID");
                    command.CommandType = CommandType.StoredProcedure;
                    database.AddInParameter(command, "@ExamID", DbType.Int64, intExamID);
                    return database.ExecuteDataSet(command);
                }
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }

        public long InsertMCQ_Exam(MCQ_Exam objMCQ_Exam)
        {
            try
            {
                SqlDatabase database = MSSQLDataBase.Instance.GetDefaultDatabase();
                {
                    DbCommand command = database.GetStoredProcCommand("InsertMCQ_Exam");
                    command.CommandType = CommandType.StoredProcedure;

                    database.AddInParameter(command, "@ExamTitle", DbType.String, objMCQ_Exam.ExamTitle);
                    database.AddInParameter(command, "@ExamDescription", DbType.String, objMCQ_Exam.ExamDescription);
                    database.AddInParameter(command, "@IsActive", DbType.Boolean, objMCQ_Exam.IsActive);
                    database.AddInParameter(command, "@CourseID", DbType.Int64, objMCQ_Exam.CourseID);
                    database.AddInParameter(command, "@ExamDuration", DbType.Int32, objMCQ_Exam.ExamDuration);
                    database.AddInParameter(command, "@PassPercentage", DbType.Decimal, objMCQ_Exam.PassPercentage);
                    database.AddInParameter(command, "@DesignationID", DbType.String, objMCQ_Exam.DesignationID);

                    return Convert.ToInt64(database.ExecuteScalar(command));
                }
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }

        public void UpdateMCQ_Exam(MCQ_Exam objMCQ_Exam)
        {
            try
            {
                SqlDatabase database = MSSQLDataBase.Instance.GetDefaultDatabase();
                {
                    DbCommand command = database.GetStoredProcCommand("UpdateMCQ_Exam");
                    command.CommandType = CommandType.StoredProcedure;

                    database.AddInParameter(command, "@ExamID", DbType.Int64, objMCQ_Exam.ExamID);
                    database.AddInParameter(command, "@ExamTitle", DbType.String, objMCQ_Exam.ExamTitle);
                    database.AddInParameter(command, "@ExamDescription", DbType.String, objMCQ_Exam.ExamDescription);
                    database.AddInParameter(command, "@IsActive", DbType.Boolean, objMCQ_Exam.IsActive);
                    database.AddInParameter(command, "@CourseID", DbType.Int64, objMCQ_Exam.CourseID);
                    database.AddInParameter(command, "@ExamDuration", DbType.Int32, objMCQ_Exam.ExamDuration);
                    database.AddInParameter(command, "@PassPercentage", DbType.Decimal, objMCQ_Exam.PassPercentage);
                    database.AddInParameter(command, "@DesignationID", DbType.String, objMCQ_Exam.DesignationID);

                    database.ExecuteNonQuery(command);
                }
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }

        public long InsertMCQ_Question(MCQ_Question objMCQ_Question)
        {
            try
            {
                SqlDatabase database = MSSQLDataBase.Instance.GetDefaultDatabase();
                {
                    DbCommand command = database.GetStoredProcCommand("InsertMCQ_Question");
                    command.CommandType = CommandType.StoredProcedure;

                    database.AddInParameter(command, "@Question", DbType.String, objMCQ_Question.Question);
                    database.AddInParameter(command, "@QuestionType", DbType.Int64, objMCQ_Question.QuestionType);
                    database.AddInParameter(command, "@PositiveMarks", DbType.Int64, objMCQ_Question.PositiveMarks);
                    database.AddInParameter(command, "@NegetiveMarks", DbType.Int64, objMCQ_Question.NegetiveMarks);
                    database.AddInParameter(command, "@PictureURL", DbType.String, objMCQ_Question.PictureURL);
                    database.AddInParameter(command, "@ExamID", DbType.Int64, objMCQ_Question.ExamID);
                    database.AddInParameter(command, "@AnswerTemplate", DbType.String, objMCQ_Question.AnswerTemplate);

                    return Convert.ToInt64(database.ExecuteScalar(command));
                }
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }

        public void UpdateMCQ_Question(MCQ_Question objMCQ_Question)
        {
            try
            {
                SqlDatabase database = MSSQLDataBase.Instance.GetDefaultDatabase();
                {
                    DbCommand command = database.GetStoredProcCommand("UpdateMCQ_Question");
                    command.CommandType = CommandType.StoredProcedure;

                    database.AddInParameter(command, "@QuestionID", DbType.Int64, objMCQ_Question.QuestionID);
                    database.AddInParameter(command, "@Question", DbType.String, objMCQ_Question.Question);
                    database.AddInParameter(command, "@QuestionType", DbType.Int64, objMCQ_Question.QuestionType);
                    database.AddInParameter(command, "@PositiveMarks", DbType.Int64, objMCQ_Question.PositiveMarks);
                    database.AddInParameter(command, "@NegetiveMarks", DbType.Int64, objMCQ_Question.NegetiveMarks);
                    database.AddInParameter(command, "@PictureURL", DbType.String, objMCQ_Question.PictureURL);
                    database.AddInParameter(command, "@ExamID", DbType.Int64, objMCQ_Question.ExamID);
                    database.AddInParameter(command, "@AnswerTemplate", DbType.String, objMCQ_Question.AnswerTemplate);

                    database.ExecuteNonQuery(command);
                }
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }

        public void DeleteMCQ_Question(long intQuestionID)
        {
            try
            {
                SqlDatabase database = MSSQLDataBase.Instance.GetDefaultDatabase();
                {
                    DbCommand command = database.GetStoredProcCommand("DeleteMCQ_Question");
                    command.CommandType = CommandType.StoredProcedure;

                    database.AddInParameter(command, "@QuestionID", DbType.Int64, intQuestionID);

                    database.ExecuteNonQuery(command);
                }
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }

        public long InsertMCQ_Option(MCQ_Option objMCQ_Option)
        {
            try
            {
                SqlDatabase database = MSSQLDataBase.Instance.GetDefaultDatabase();
                {
                    DbCommand command = database.GetStoredProcCommand("InsertMCQ_Option");
                    command.CommandType = CommandType.StoredProcedure;

                    database.AddInParameter(command, "@OptionText", DbType.String, objMCQ_Option.OptionText);
                    database.AddInParameter(command, "@QuestionID", DbType.Int64, objMCQ_Option.QuestionID);

                    return Convert.ToInt64(database.ExecuteScalar(command));
                }
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }

        public void UpdateMCQ_Option(MCQ_Option objMCQ_Option)
        {
            try
            {
                SqlDatabase database = MSSQLDataBase.Instance.GetDefaultDatabase();
                {
                    DbCommand command = database.GetStoredProcCommand("UpdateMCQ_Option");
                    command.CommandType = CommandType.StoredProcedure;

                    database.AddInParameter(command, "@OptionText", DbType.String, objMCQ_Option.OptionText);
                    database.AddInParameter(command, "@QuestionID", DbType.Int64, objMCQ_Option.QuestionID);
                    database.AddInParameter(command, "@OptionID", DbType.Int64, objMCQ_Option.OptionID);

                    database.ExecuteNonQuery(command);
                }
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }

        public long InsertMCQ_CorrectAnswer(MCQ_Option objMCQ_Option)
        {
            try
            {
                SqlDatabase database = MSSQLDataBase.Instance.GetDefaultDatabase();
                {
                    DbCommand command = database.GetStoredProcCommand("InsertMCQ_CorrectAnswer");
                    command.CommandType = CommandType.StoredProcedure;

                    database.AddInParameter(command, "@OptionText", DbType.String, objMCQ_Option.OptionText);
                    database.AddInParameter(command, "@QuestionID", DbType.Int64, objMCQ_Option.QuestionID);

                    return Convert.ToInt64(database.ExecuteScalar(command));
                }
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }

        public void UpdateMCQ_CorrectAnswer(MCQ_Option objMCQ_Option)
        {
            try
            {
                SqlDatabase database = MSSQLDataBase.Instance.GetDefaultDatabase();
                {
                    DbCommand command = database.GetStoredProcCommand("UpdateMCQ_CorrectAnswer");
                    command.CommandType = CommandType.StoredProcedure;

                    database.AddInParameter(command, "@OptionID", DbType.String, objMCQ_Option.OptionID);
                    database.AddInParameter(command, "@QuestionID", DbType.Int64, objMCQ_Option.QuestionID);

                    database.ExecuteNonQuery(command);
                }
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }

        public void UpdateMCQ_ExamDesignations(Int64 intExamId, string Designations)
        {
            try
            {
                SqlDatabase database = MSSQLDataBase.Instance.GetDefaultDatabase();
                {
                    DbCommand command = database.GetStoredProcCommand("usp_UpdateExamDesignation");
                    command.CommandType = CommandType.StoredProcedure;

                    database.AddInParameter(command, "@ExamID", DbType.Int64, intExamId);
                    database.AddInParameter(command, "@DesigantionIDs", DbType.String, Designations);
                    
                    database.ExecuteNonQuery(command);
                }
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }
    }
}
