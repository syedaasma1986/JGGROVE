using JG_Prospect.DAL;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace JobScheduler
{
    class Program
    {
        static void Main(string[] args)
        {
            // Call RunJobs
            JobSchedulerDAL.m_JobSchedulerDAL.RunJobs();
        }
    }
}
