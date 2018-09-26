using JG_Prospect.DAL;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace JG_Prospect.BLL
{
    public class ErrorLogBLL
    {
        private static ErrorLogBLL m_ErrorLogBLL = new ErrorLogBLL();

        private ErrorLogBLL()
        {
        }
        public static ErrorLogBLL Instance
        {
            get { return m_ErrorLogBLL; }
            private set {; }
        }

        public void SaveApplicationError(string type, string message, string stacktrace, string pageUrl)
        {
            ErrorLogDAL.Instance.SaveApplicationError(type, message, stacktrace, pageUrl);
        }
    }
}
