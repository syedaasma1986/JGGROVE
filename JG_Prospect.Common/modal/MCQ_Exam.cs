using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace JG_Prospect.Common.modal
{
    public class MCQ_Exam
    {
        public long ExamID { get; set; }
        public string ExamTitle { get; set; }
        public string ExamDescription { get; set; }
        public bool IsActive { get; set; }
        public long CourseID { get; set; }
        public int ExamDuration { get; set; }
        public float PassPercentage { get; set; }
        public string DesignationID { get; set; }
    }
}
