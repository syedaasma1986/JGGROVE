using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using JG_Prospect.DAL;
using JG_Prospect.Common;
using JG_Prospect.Common.modal;
using System.Data;

namespace JG_Prospect.BLL
{
    public class PayRateBLL
    {
        private static PayRateBLL m_PayRateBLL = new PayRateBLL();

        private PayRateBLL()
        {

        }

        public static PayRateBLL Instance
        {
            get { return m_PayRateBLL; }
            set {; }
        }

        public Int32 AddDesignationPayRate(int DesignationId, int EmpType, Decimal BaseRate, Decimal DisplayRate, String DisplayCurrencyCode, int CreatedBy)
        {
            return PayRateDAL.Instance.AddDesignationPayRate(DesignationId,EmpType,BaseRate, DisplayRate,  DisplayCurrencyCode, CreatedBy);
        }

        public DataSet GetDesignationPayRate(int DesignationId, int EmploymentTypeId)
        {
            return PayRateDAL.Instance.GetDesignationPayRate(DesignationId,EmploymentTypeId);
        }

        public DataSet GetDesignationPayRates(int DesignationId)
        {
            return PayRateDAL.Instance.GetDesignationPayRates(DesignationId);
        }

    }
}
