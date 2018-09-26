using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace JG_Prospect.Common.modal
{
    public class Roles_ApplicationFeatures
    {
        public int Id { get; set; }
        public JG_Prospect.Common.JGConstant.UserRoles Role { get; set; }
        public JG_Prospect.Common.JGConstant.ApplicationFeatures ApplicationFeature { get; set; }
        public bool IsEnabled { get; set; }
    }
}
