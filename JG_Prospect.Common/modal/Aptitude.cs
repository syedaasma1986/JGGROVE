using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace JG_Prospect.Common.modal
{
    [Serializable]
    public class Aptitude
    {
        public class Exam
        {
            
        }

        public partial class QuestionRow 
        {
            //private QuestionDataTable tableQuestion;
            
            public long QuestionID
            {
                get; set;
            }
            public string Question{get; set;}
            public long QuestionType{ get; set; }
            public long PositiveMarks{ get; set; }
            public long NegetiveMarks{ get; set; }
            public string PictureURL { get; set; }
            public long ExamID { get; set; }
            public string AnswerTemplate{ get; set; }
            //public bool IsPositiveMarksNull()
            //{
            //    return this.IsNull(this.tableQuestion.PositiveMarksColumn);
            //}
            //public void SetPositiveMarksNull()
            //{
            //    this[this.tableQuestion.PositiveMarksColumn] = global::System.Convert.DBNull;
            //}



            //public bool IsPictureURLNull()
            //{
            //    return this.IsNull(this.tableQuestion.PictureURLColumn);
            //}



            //public void SetPictureURLNull()
            //{
            //    this[this.tableQuestion.PictureURLColumn] = global::System.Convert.DBNull;
            //}



            //public bool IsExamIDNull()
            //{
            //    return this.IsNull(this.tableQuestion.ExamIDColumn);
            //}
            //public void SetExamIDNull()
            //{
            //    this[this.tableQuestion.ExamIDColumn] = global::System.Convert.DBNull;
            //}
            //public bool IsAnswerTemplateNull()
            //{
            //    return this.IsNull(this.tableQuestion.AnswerTemplateColumn);
            //}            public void SetAnswerTemplateNull()
            //{
            //    this[this.tableQuestion.AnswerTemplateColumn] = global::System.Convert.DBNull;
            //}
        }
    }
}
