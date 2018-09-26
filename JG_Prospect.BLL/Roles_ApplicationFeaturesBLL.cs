using JG_Prospect.Common.modal;
using JG_Prospect.DAL;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace JG_Prospect.BLL
{
    public class Roles_ApplicationFeaturesBLL
    {
        private static Roles_ApplicationFeaturesBLL m_Roles_ApplicationFeaturesBLL = new Roles_ApplicationFeaturesBLL();

        private Roles_ApplicationFeaturesBLL()
        {

        }

        public static Roles_ApplicationFeaturesBLL Instance
        {
            get { return m_Roles_ApplicationFeaturesBLL; }
            set { ; }
        }

        public List<Roles_ApplicationFeatures> GetApplicationFeaturesByRoleId(JG_Prospect.Common.JGConstant.UserRoles objUserRole)
        {
            return Roles_ApplicationFeaturesDAL.Instance.GetApplicationFeaturesByRoleId(objUserRole);
        }
    }
}
