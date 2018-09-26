using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Data;
using System.Data.Common;

using Microsoft.Practices.EnterpriseLibrary.Data.Sql;
using JG_Prospect.DAL.Database;

namespace JG_Prospect.DAL
{
    public class JobSchedulerDAL
    {
        public static JobSchedulerDAL m_JobSchedulerDAL = new JobSchedulerDAL();
        private JobSchedulerDAL()
        {
        }
        public static JobSchedulerDAL Instance
        {
            get { return m_JobSchedulerDAL; }
            private set {; }
        }

        public void RunJobs()
        {
            try
            {
                SqlDatabase database = MSSQLDataBase.Instance.GetDefaultDatabase();
                {
                    DbCommand command = database.GetStoredProcCommand("RunJobs");
                    command.CommandType = CommandType.StoredProcedure;
                    database.ExecuteDataSet(command);
                }
            }
            catch (Exception ex)
            {
                
            }

        }
    }
}
