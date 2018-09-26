using JG_Prospect.DAL;
using System;

namespace JG_Prospect.BLL
{
    public class UnsubscribeBLL
    {
        private static UnsubscribeBLL m_UnsubscribeBLL = new UnsubscribeBLL();
        public static UnsubscribeBLL Instance
        {
            get { return m_UnsubscribeBLL; }
            private set {; }
        }

        public bool InsertUnSubscribeEmail(String Email)
        {
            return UnsubscribeDAL.Instance.InsertUnSubscribeEmail(Email);
        }

        public bool DeleteUnSubscribeEmail(String Email)
        {
            return UnsubscribeDAL.Instance.DeleteUnSubscribeEmail(Email);
        }

        public bool InsertUnSubscribeMobile(String Mobile)
        {
            return UnsubscribeDAL.Instance.InsertUnSubscribeMobile(Mobile);
        }

        public bool DeleteUnSubscribeMobile(String Mobile)
        {
            return UnsubscribeDAL.Instance.DeleteUnSubscribeMobile(Mobile);
        }

    }
}
