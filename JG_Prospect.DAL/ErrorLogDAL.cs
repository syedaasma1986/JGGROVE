using JG_Prospect.DAL.Database;
using Microsoft.Practices.EnterpriseLibrary.Data.Sql;
using System;
using System.Collections.Generic;
using System.Data;
using System.Data.Common;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace JG_Prospect.DAL
{
    public class ErrorLogDAL
    {
        public static ErrorLogDAL m_ErrorLogDAL = new ErrorLogDAL();

        public static ErrorLogDAL Instance
        {
            get { return m_ErrorLogDAL; }
            private set {; }
        }
        public DataSet returndata;

        public void SaveApplicationError(string type, string message, string stacktrace, string pageUrl)
        {
            try
            {
                SqlDatabase database = MSSQLDataBase.Instance.GetDefaultDatabase();
                {
                    DbCommand command = database.GetStoredProcCommand("SaveApplicationError");
                    command.CommandType = CommandType.StoredProcedure;
                    database.AddInParameter(command, "@Type", DbType.String, type);
                    database.AddInParameter(command, "@Message", DbType.String, message);
                    database.AddInParameter(command, "@StackTrace", DbType.String, stacktrace);
                    database.AddInParameter(command, "@PageUrl", DbType.String, pageUrl);
                    database.ExecuteNonQuery(command);
                }
            }
            catch (Exception ex)
            { Console.Write(ex.Message); }
        }
    }
}
