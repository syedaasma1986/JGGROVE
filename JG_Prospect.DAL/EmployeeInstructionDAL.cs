using JG_Prospect.Common.modal;
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
    public class EmployeeInstructionDAL
    {
        private static EmployeeInstructionDAL m_EmployeeInstructionDAL = new EmployeeInstructionDAL();
        public static EmployeeInstructionDAL Instance
        {
            get { return m_EmployeeInstructionDAL; }
            private set { ; }
        }

        public DataSet GetEmployeeInstructionByDesignationId(int DesignationId, Common.JGConstant.EmployeeInstructionUsedFor UsedFor)
        {
            try
            {
                SqlDatabase database = MSSQLDataBase.Instance.GetDefaultDatabase();
                {
                    DbCommand command = database.GetStoredProcCommand("usp_GetEmpInstructionByDesignationId");
                    command.CommandType = CommandType.StoredProcedure;
                    database.AddInParameter(command, "@DesignationId", DbType.Int32, DesignationId);
                    database.AddInParameter(command, "@UsedFor", DbType.Int16, Convert.ToInt16(UsedFor));

                    DataSet dsEmpInstruction = database.ExecuteDataSet(command);

                    return dsEmpInstruction;
                }
            }
            catch (Exception ex)
            {
                return null;
            }
        }

    }
}
