using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using JG_Prospect.Common.modal;
using JG_Prospect.DAL;
using System.Data;
using JG_Prospect.Common;

namespace JG_Prospect.BLL
{
   public class AptitudeTestBLL
    {
        private static AptitudeTestBLL m_AptitudeTestBLL = new AptitudeTestBLL();

        private AptitudeTestBLL()
        {
        }

        public static AptitudeTestBLL Instance
        {
            get { return m_AptitudeTestBLL; }
            set {; }
        }

        public DataTable GetPerformanceByUserID(int userID)
        {
            return AptitudeTestDAL.Instance.GetPerformanceByUserID(userID);
        }

        public DataTable GetExamByExamID(Enums.Aptitude_ExamType ExamType, int userID)
        {
            return AptitudeTestDAL.Instance.GetExamByExamID(ExamType,userID);
        }

        public DataTable GetExamsByUserID(int userID)
        {
            return AptitudeTestDAL.Instance.GetExamsByUserID(userID);
        }

        public Double GetExamsResultByUserID(int userID, ref bool isAllExamGiven)
        {
            return AptitudeTestDAL.Instance.GetExamsResultByUserID(userID, ref isAllExamGiven);
        }
        public bool IsAllExamGivenByUserId(int userID)
        {
            return AptitudeTestDAL.Instance.IsAllExamGivenByUserId(userID);
        }
        public bool IsExamGivenByUserByExamId(int userID, int examId)
        {
            return AptitudeTestDAL.Instance.IsExamGivenByUserByExamId(userID, examId);
        }

        public string GetExamNameByExamID(string ExamId)
        {
            return AptitudeTestDAL.Instance.GetExamNameByExamID(ExamId);
        }

        public DataTable GetMCQ_Exams(string intDesignationID)
        {
            return AptitudeTestDAL.Instance.GetMCQ_Exams(intDesignationID);
        }

        public DataSet GetMCQ_ExamByID(Int64 intExamID)
        {
            return AptitudeTestDAL.Instance.GetMCQ_ExamByID(intExamID);
        }

        public string GetExamDurationByID(string examID)
        {
            return AptitudeTestDAL.Instance.GetExamDurationByID(examID);
        }

        public DataTable GetQuestionsForExamByID(string examID)
        {
            return AptitudeTestDAL.Instance.GetQuestionsForExamByID(examID);
        }

        public DataTable GetQuestionsByID(int questionID)
        {
            return AptitudeTestDAL.Instance.GetQuestionsByID(questionID);
        }

        public DataTable GetcorrectAnswerByQuestionID(int questionID)
        {
            return AptitudeTestDAL.Instance.GetcorrectAnswerByQuestionID(questionID);
        }

        public DataTable GetQuestionsoptionByQustionID(int questionID)
        {
            return AptitudeTestDAL.Instance.GetQuestionsoptionByQustionID(questionID);
        }

        public bool InsertPerformance(int InstallUserID, int ExamID, int marksEarned)
        {
            return AptitudeTestDAL.Instance.InsertPerformance(InstallUserID, ExamID, marksEarned);
        }


        public long InsertMCQ_Exam(MCQ_Exam objMCQ_Exam)
        {
            return AptitudeTestDAL.Instance.InsertMCQ_Exam(objMCQ_Exam);
        }

        public void UpdateMCQ_Exam(MCQ_Exam objMCQ_Exam)
        {
            AptitudeTestDAL.Instance.UpdateMCQ_Exam(objMCQ_Exam);
        }

        public long InsertMCQ_Question(MCQ_Question objMCQ_Question)
        {
            return AptitudeTestDAL.Instance.InsertMCQ_Question(objMCQ_Question);
        }

        public void UpdateMCQ_Question(MCQ_Question objMCQ_Question)
        {
            AptitudeTestDAL.Instance.UpdateMCQ_Question(objMCQ_Question);
        }

        public void DeleteMCQ_Question(long intQuestionID)
        {
            AptitudeTestDAL.Instance.DeleteMCQ_Question(intQuestionID);
        }

        public long InsertMCQ_Option(MCQ_Option objMCQ_Option)
        {
            return AptitudeTestDAL.Instance.InsertMCQ_Option(objMCQ_Option);
        }

        public void UpdateMCQ_Option(MCQ_Option objMCQ_Option)
        {
            AptitudeTestDAL.Instance.UpdateMCQ_Option(objMCQ_Option);
        }

        public long InsertMCQ_CorrectAnswer(MCQ_Option objMCQ_Option)
        {
            return AptitudeTestDAL.Instance.InsertMCQ_CorrectAnswer(objMCQ_Option);
        }

        public void UpdateMCQ_CorrectAnswer(MCQ_Option objMCQ_Option)
        {
            AptitudeTestDAL.Instance.UpdateMCQ_CorrectAnswer(objMCQ_Option);
        }

        public void UpdateMCQ_ExamDesignations(Int64 intExamId, string Designations)
        {
            AptitudeTestDAL.Instance.UpdateMCQ_ExamDesignations(intExamId,Designations);
        }

    }
}
