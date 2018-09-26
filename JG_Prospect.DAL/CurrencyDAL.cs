using System;
using System.Data;
using System.Data.Common;
using Microsoft.Practices.EnterpriseLibrary.Data.Sql;
using JG_Prospect.DAL.Database;

namespace JG_Prospect.DAL
{
    public class CurrencyDAL
    {
        private static CurrencyDAL m_CurrencyDAL = new CurrencyDAL();
        public static CurrencyDAL Instance
        {
            get { return m_CurrencyDAL; }
            private set {; }
        }

        private DataSet returndata;


        public DataSet GetAllCurrency()
        {
            try
            {
                SqlDatabase database = MSSQLDataBase.Instance.GetDefaultDatabase();
                {
                    returndata = new DataSet();
                    DbCommand command = database.GetStoredProcCommand("SP_GetAllCurrency");
                    command.CommandType = CommandType.StoredProcedure;
                    returndata = database.ExecuteDataSet(command);

                    return returndata;
                }
            }
            catch (Exception ex)
            {
                return null;
            }
        }

    }
}