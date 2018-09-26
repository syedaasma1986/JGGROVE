using JG_Prospect.BLL;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace EmailSchedular
{
    class Program
    {
        static void Main(string[] args)
        {
            EmailSchedularManager.SendScheduledEmails();
        }
    }
}
