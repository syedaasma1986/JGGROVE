using JG_Prospect.Common.modal;
using JG_Prospect.DAL;
using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace JG_Prospect.BLL
{
    public class EmployeeLegalDesclaimerBLL
    {
        private static EmployeeLegalDesclaimerBLL m_EmployeeLegalDesclaimerBLL = new EmployeeLegalDesclaimerBLL();

        public static EmployeeLegalDesclaimerBLL Instance
        {
            get { return m_EmployeeLegalDesclaimerBLL; }
            set { ; }
        }
        

        public DataSet GetEmployeeLegalDesclaimerByDesignationId(int DesignationId, Common.JGConstant.EmployeeLegalDesclaimerUsedFor UsedFor)
        {
            return EmployeeLegalDesclaimerDAL.Instance.GetEmployeeLegalDesclaimerByDesignationId(DesignationId, UsedFor);
        }
        
    }
}
