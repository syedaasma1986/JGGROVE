using System.Data;
using JG_Prospect.DAL;
using JG_Prospect.Common.modal;

namespace JG_Prospect.BLL
{
    public class CurrencyBLL
    {
        private static CurrencyBLL m_CurrencyBLL = new CurrencyBLL();

        private CurrencyBLL()
        {
        }

        public static CurrencyBLL Instance
        {
            get { return m_CurrencyBLL; }
            set {; }
        }

        public DataSet GetAllCurrency()
        {
            return CurrencyDAL.Instance.GetAllCurrency();
        }
    }
}