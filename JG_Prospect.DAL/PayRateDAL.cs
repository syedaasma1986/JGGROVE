using JG_Prospect.DAL.Database;
using Microsoft.Practices.EnterpriseLibrary.Data.Sql;
using System;
using System.Data;
using System.Data.Common;

namespace JG_Prospect.DAL
{
    public class PayRateDAL
    {
        public static PayRateDAL m_PayRateDAL = new PayRateDAL();
        private PayRateDAL()
        {
        }
        public static PayRateDAL Instance
        {
            get { return m_PayRateDAL; }
            private set {; }
        }

        public DataSet returndata;

        public Int32 AddDesignationPayRate(int DesignationId, int EmpType, Decimal BaseRate, Decimal DisplayRate, String DisplayCurrencyCode, int CreatedBy)
        {
            Int32 intReturn = 0;

            try
            {
                SqlDatabase database = MSSQLDataBase.Instance.GetDefaultDatabase();
                {
                    DbCommand command = database.GetStoredProcCommand("usp_InsertPayRate");
                    command.CommandType = CommandType.StoredProcedure;
                    database.AddInParameter(command, "@DesigntionId", DbType.Int32, DesignationId);
                    database.AddInParameter(command, "@EmploymentType", DbType.Int32, EmpType);
                    database.AddInParameter(command, "@BaseRate", DbType.Decimal, BaseRate);
                    database.AddInParameter(command, "@DisplayRate", DbType.Decimal, DisplayRate);
                    database.AddInParameter(command, "@DisplayRateCurrencyCode", DbType.String, DisplayCurrencyCode);
                    database.AddInParameter(command, "@CreatedDate", DbType.DateTime, DateTime.Now);
                    database.AddInParameter(command, "@CreatedBy", DbType.Int32, CreatedBy);
                    intReturn = database.ExecuteNonQuery(command);
                }
            }
            catch (Exception ex)
            {  }

            return intReturn;

        }

        public DataSet GetDesignationPayRate(int DesignationId, int EmploymentTypeId )
        {
            returndata = new DataSet();

            try
            {
                SqlDatabase database = MSSQLDataBase.Instance.GetDefaultDatabase();
                {
                    DbCommand command = database.GetStoredProcCommand("usp_GetDesignationPayRate");
                    command.CommandType = CommandType.StoredProcedure;
                    database.AddInParameter(command, "@DesignationId", DbType.Int32, DesignationId);
                    database.AddInParameter(command, "@EmploymentType", DbType.Int32, EmploymentTypeId);
                    returndata = database.ExecuteDataSet(command);
                }
            }
            catch (Exception ex)
            { Console.Write(ex.Message); }

            return returndata;
        }

        public DataSet GetDesignationPayRates(int DesignationId)
        {
            returndata = new DataSet();

            try
            {
                SqlDatabase database = MSSQLDataBase.Instance.GetDefaultDatabase();
                {
                    DbCommand command = database.GetStoredProcCommand("usp_GetDesignationPayRates");
                    command.CommandType = CommandType.StoredProcedure;
                    database.AddInParameter(command, "@DesignationId", DbType.Int32, DesignationId);
                    
                    returndata = database.ExecuteDataSet(command);
                }
            }
            catch (Exception ex)
            { Console.Write(ex.Message); }

            return returndata;
        }

    } 
}
