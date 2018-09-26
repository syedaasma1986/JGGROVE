using JG_Prospect.Common.modal;
using JG_Prospect.DAL.Database;
using Microsoft.Practices.EnterpriseLibrary.Data.Sql;
using System;
using System.Collections.Generic;
using System.Data;
using System.Data.Common;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace JG_Prospect.DAL
{
    public class Roles_ApplicationFeaturesDAL
    {
        public static Roles_ApplicationFeaturesDAL m_Roles_ApplicationFeaturesDAL = new Roles_ApplicationFeaturesDAL();

        private Roles_ApplicationFeaturesDAL()
        {

        }

        public static Roles_ApplicationFeaturesDAL Instance
        {
            get { return m_Roles_ApplicationFeaturesDAL; }
            private set { ; }
        }

        public List<Roles_ApplicationFeatures> GetApplicationFeaturesByRoleId(JG_Prospect.Common.JGConstant.UserRoles objUserRole)
        {
            try
            {
                SqlDatabase database = MSSQLDataBase.Instance.GetDefaultDatabase();
                {
                    DbCommand command = database.GetStoredProcCommand("GetApplicationFeaturesByRoleId");
                    command.CommandType = CommandType.StoredProcedure;
                    database.AddInParameter(command, "@RoleId", DbType.Int32, (byte)objUserRole);

                    DataSet dsRoles_ApplicationFeatures = database.ExecuteDataSet(command);
                    List<Roles_ApplicationFeatures> lstRoles_ApplicationFeatures = new List<Roles_ApplicationFeatures>();
                    if (
                        dsRoles_ApplicationFeatures != null &&
                        dsRoles_ApplicationFeatures.Tables.Count > 0 &&
                        dsRoles_ApplicationFeatures.Tables[0].Rows.Count > 0
                       )
                    {
                        DataRow dr = dsRoles_ApplicationFeatures.Tables[0].Rows[0];

                        Roles_ApplicationFeatures objRoles_ApplicationFeatures = new Roles_ApplicationFeatures();

                        objRoles_ApplicationFeatures.Id = Convert.ToInt32(dr["Id"]);
                        objRoles_ApplicationFeatures.Role = (JG_Prospect.Common.JGConstant.UserRoles)Convert.ToByte(dr["RoleId"]);
                        objRoles_ApplicationFeatures.ApplicationFeature = (JG_Prospect.Common.JGConstant.ApplicationFeatures)Convert.ToByte(dr["ApplicationFeatureId"]);
                        objRoles_ApplicationFeatures.IsEnabled = Convert.ToBoolean(dr["IsEnabled"]);

                        lstRoles_ApplicationFeatures.Add(objRoles_ApplicationFeatures);
                    }
                    return lstRoles_ApplicationFeatures;
                }
            }
            catch (Exception ex)
            {
                return null;
            }
        }
    }
}
