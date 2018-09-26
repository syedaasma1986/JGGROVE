using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace JG_Prospect.Common.modal
{
    public class MCQ_Question
    {
        public long QuestionID { get; set; }
        public string Question { get; set; }
        public long QuestionType { get; set; }
        public long PositiveMarks { get; set; }
        public long NegetiveMarks { get; set; }
        public string PictureURL { get; set; }
        public long ExamID { get; set; }
        public string AnswerTemplate { get; set; }
    }
}
