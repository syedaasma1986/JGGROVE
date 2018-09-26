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
    public class EmployeeInstructionBLL
    {
        private static EmployeeInstructionBLL m_EmployeeInstructionBLL = new EmployeeInstructionBLL();

        public static EmployeeInstructionBLL Instance
        {
            get { return m_EmployeeInstructionBLL; }
            set { ; }
        }

        public DataSet GetEmployeeInstructionByDesignationId(int DesignationId, Common.JGConstant.EmployeeInstructionUsedFor UsedFor)
        {
            return EmployeeInstructionDAL.Instance.GetEmployeeInstructionByDesignationId(DesignationId,UsedFor);

        }


    }
}
