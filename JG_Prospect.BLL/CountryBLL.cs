using System.Data;
using JG_Prospect.DAL;
using JG_Prospect.Common.modal;

namespace JG_Prospect.BLL
{
    public class CountryBLL
    {
        private static CountryBLL m_CountryBLL = new CountryBLL();

        private CountryBLL()
        { 
        }

        public static CountryBLL Instance
        {
            get { return m_CountryBLL; }
            set {; }
        }

        public DataSet GetAllCountry()
        {
            return CountryDAL.Instance.GetDepartmentsByFilter(0);
        }
    }
}
