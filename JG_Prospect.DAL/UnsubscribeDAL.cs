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
    public class UnsubscribeDAL
    {
        private static UnsubscribeDAL m_UnsubscribeDAL = new UnsubscribeDAL();
        public static UnsubscribeDAL Instance
        {
            get { return m_UnsubscribeDAL; }
            private set {; }
        }

        public bool InsertUnSubscribeEmail(String Email)
        {
            try
            {
                SqlDatabase database = MSSQLDataBase.Instance.GetDefaultDatabase();
                {
                    DbCommand command = database.GetStoredProcCommand("usp_AddUnsubscribeEmail");
                    command.CommandType = CommandType.StoredProcedure;

                    database.AddInParameter(command, "@EmailId", DbType.String, Email);

                    return (database.ExecuteNonQuery(command) > 0);
                }
            }
            catch (Exception ex)
            {
                return false;
            }
        }

        public bool DeleteUnSubscribeEmail(String Email)
        {
            try
            {
                SqlDatabase database = MSSQLDataBase.Instance.GetDefaultDatabase();
                {
                    DbCommand command = database.GetStoredProcCommand("usp_RemoveUnsubscribeEmail");
                    command.CommandType = CommandType.StoredProcedure;

                    database.AddInParameter(command, "@EmailId", DbType.String, Email);

                    return (database.ExecuteNonQuery(command) > 0);
                }
            }
            catch (Exception ex)
            {
                return false;
            }
        }

        public bool InsertUnSubscribeMobile(String Mobile)
        {
            try
            {
                SqlDatabase database = MSSQLDataBase.Instance.GetDefaultDatabase();
                {
                    DbCommand command = database.GetStoredProcCommand("usp_AddUnsubscribeMobile");
                    command.CommandType = CommandType.StoredProcedure;

                    database.AddInParameter(command, "@Mobile", DbType.String, Mobile);

                    return (database.ExecuteNonQuery(command) > 0);
                }
            }
            catch (Exception ex)
            {
                return false;
            }
        }

        public bool DeleteUnSubscribeMobile(String Mobile)
        {
            try
            {
                SqlDatabase database = MSSQLDataBase.Instance.GetDefaultDatabase();
                {
                    DbCommand command = database.GetStoredProcCommand("usp_RemoveUnsubscribeMobile");
                    command.CommandType = CommandType.StoredProcedure;

                    database.AddInParameter(command, "@Mobile", DbType.String, Mobile);

                    return (database.ExecuteNonQuery(command) > 0);
                }
            }
            catch (Exception ex)
            {
                return false;
            }
        }
    }
}
