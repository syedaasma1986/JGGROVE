using System;
using System.Data;

using System.Data.Common;
using Microsoft.Practices.EnterpriseLibrary.Data.Sql;
using JG_Prospect.DAL.Database;


namespace JG_Prospect.DAL
{
    public class CountryDAL
    {
        private static CountryDAL m_CountryDAL = new CountryDAL();
        public static CountryDAL Instance
        {
            get { return m_CountryDAL; }
            private set {; }
        }

        private DataSet returndata;


        public DataSet GetDepartmentsByFilter(int? DepartmentID)
        {
            try
            {
                SqlDatabase database = MSSQLDataBase.Instance.GetDefaultDatabase();
                {
                    returndata = new DataSet();
                    DbCommand command = database.GetStoredProcCommand("SP_GetAllCountry");                    
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
