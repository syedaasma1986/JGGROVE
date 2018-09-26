using JG_Prospect.Common.modal;
using JG_Prospect.DAL.Database;
using Microsoft.Practices.EnterpriseLibrary.Data.Sql;
using System;
using System.Collections.Generic;
using System.Data;
using System.Data.Common;

namespace JG_Prospect.DAL
{
    public class EmployeeLegalDesclaimerDAL
    {
        private static EmployeeLegalDesclaimerDAL m_EmployeeLegalDesclaimerDAL = new EmployeeLegalDesclaimerDAL();
        public static EmployeeLegalDesclaimerDAL Instance
        {
            get { return m_EmployeeLegalDesclaimerDAL; }
            private set { ; }
        }

        public DataSet GetEmployeeLegalDesclaimerByDesignationId(int DesignationId, Common.JGConstant.EmployeeLegalDesclaimerUsedFor UsedFor)
        {
            try
            {
                SqlDatabase database = MSSQLDataBase.Instance.GetDefaultDatabase();
                {
                    DbCommand command = database.GetStoredProcCommand("usp_GetEmpLegalDesclaimerByDesignationId");
                    command.CommandType = CommandType.StoredProcedure;
                    database.AddInParameter(command, "@DesignationId", DbType.Int32, DesignationId);
                    database.AddInParameter(command, "@UsedFor", DbType.Int16, Convert.ToInt16(UsedFor));

                    DataSet dsEmpLegalDesclaimer = database.ExecuteDataSet(command);
                    
                    return dsEmpLegalDesclaimer;
                }
            }
            catch (Exception ex)
            {
                return null;
            }
        }
        
    }
}
