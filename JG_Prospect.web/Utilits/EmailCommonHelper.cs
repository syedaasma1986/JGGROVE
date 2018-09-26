using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace JG_Prospect.Utilits
{
    public static class EmailCommonHelper
    {
        #region Public Methods

        public static string CreateUserEmailAccount(string strUserName)
        {
            strUserName =  ValidateAndGetEmailIDBeforCreating(strUserName);

            string strDomainName = Utilits.AppSettingsValues.GetDomainActiveUserEmailCreation;

            if (Utilits.YandexManager.CheckDomain(strDomainName))
            {
                Utilits.YandexManager.CreateEmailUser(strDomainName, strUserName, Common.JGConstant.Default_PassWord);
            }

            return strUserName;
        }

        #endregion

        #region Private Methods

        /// <summary>
        /// Validate if email Id Exist or so.. 
        /// if exist then will generate a new one Before Creating.
        /// </summary>
        /// <param name="strNewEmailId"></param>
        /// <returns></returns>
        private static string ValidateAndGetEmailIDBeforCreating(string strNewEmailId)
        {
            return strNewEmailId;
        }

        #endregion
    }
}