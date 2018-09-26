using System.Configuration;

namespace JG_Prospect.Utilits
{
    public static class AppSettingsValues
    {
        public static string GetDomainActiveUserEmailCreation
        {
            get
            {
                return ConfigurationManager.AppSettings["CreateActiveUserEmailForDomain"].ToString();
            }

        }
    }
}