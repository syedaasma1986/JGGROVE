using JG_Prospect.Common.RestServiceJSONParser;
using Newtonsoft.Json;
using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Net;
using System.Web;

namespace JG_Prospect.Utilits
{
    public class YandexManager
    {
        public static bool CheckDomain(string strDomain)
        {
            bool IsValidDomain = true;
            string strURL = "https://pddimp.yandex.ru/api2/admin/domain/details?domain=" + strDomain;
            string response = "";
            response = HttpGet(strURL);
            

            return IsValidDomain;
        }

        public static string CreateEmailUser(string strDomain, string strEmailId, string PassWord)
        {
            string AoutCode = "e5a3d8edd42d424e83b0cf9d62a09a0f";
            string strURL = "https://pddimp.yandex.ru/api2/admin/email/add?Authorization=" + AoutCode + "&domain=" + strDomain + "&login=" + strEmailId + "&password=" + PassWord;
            string response = "";
            HttpPost(strURL, "");
            return "User Create";
        }

        public static YandexEmailCountersResponse GetUnreadEmailCount(string strDomain, string strEmailId)
        {
            string AoutCode = "e5a3d8edd42d424e83b0cf9d62a09a0f";
            string strURL = "https://pddimp.yandex.ru/api2/admin/email/counters?Authorization=" + AoutCode + "&domain=" + strDomain + "&login=" + strEmailId;
            string response = "";
            response = HttpGet(strURL);

            if (response.IndexOf("new")> -1)
            {
                response = response.Replace("new", "newone");
            }
            YandexEmailCountersResponse EmailCounters = JsonConvert.DeserializeObject<YandexEmailCountersResponse>(response);
            return EmailCounters;
        }

        public static string HttpGet(string URI)
        {
            System.Net.WebRequest req = System.Net.WebRequest.Create(URI);
            //req.Proxy = new System.Net.WebProxy(ProxyString, true); //true means no proxy

            req.Headers.Add("PddToken", "NZD67PSLWTTG7UM7ALB2OZ2ZYBEQ2CATCT25RRSEWS4GB4IT6NMQ");
            try
            {
                System.Net.WebResponse resp = req.GetResponse();


                System.IO.StreamReader sr = new System.IO.StreamReader(resp.GetResponseStream());
                return sr.ReadToEnd().Trim();
            }
            catch (Exception ex)
            {
                return string.Empty;                
            }
        }

        public static string HttpPost(string URI, string Parameters)
        {
            System.Net.WebRequest req = System.Net.WebRequest.Create(URI);
            //req.Proxy = new System.Net.WebProxy(ProxyString, true);
            //Add these, as we're doing a POST
            req.Headers.Add("PddToken", "NZD67PSLWTTG7UM7ALB2OZ2ZYBEQ2CATCT25RRSEWS4GB4IT6NMQ");
            req.ContentType = "application/x-www-form-urlencoded";
            req.Method = "POST";
            //We need to count how many bytes we're sending. Post'ed Faked Forms should be name=value&
            byte[] bytes = System.Text.Encoding.ASCII.GetBytes(Parameters);
            req.ContentLength = bytes.Length;
            System.IO.Stream os = req.GetRequestStream();
            os.Write(bytes, 0, bytes.Length); //Push it out there
            os.Close();
            System.Net.WebResponse resp = req.GetResponse();
            if (resp == null) return null;
            System.IO.StreamReader sr = new System.IO.StreamReader(resp.GetResponseStream());
            return sr.ReadToEnd().Trim();
        }

    }
}