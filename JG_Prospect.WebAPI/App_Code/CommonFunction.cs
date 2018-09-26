using System;
using System.Collections.Generic;
using System.Configuration;
using System.Linq;
using System.Net;
using System.Net.Mail;
using System.Web;

namespace JG_Prospect.WebAPI.App_Code
{
    public static class CommonFunction
    {
        /// <summary>
        /// Sends an email.
        /// </summary>
        /// <param name="strEmailTemplate"></param>
        /// <param name="strToAddress">it will receive email.</param>
        /// <param name="strSubject">subject line of email.</param>
        /// <param name="strBody">contect / body of email.</param>
        /// <param name="lstAttachments">any files to be attached to email.</param>
        public static void SendEmail(string strEmailTemplate, string strToAddress, string strSubject, string strBody, List<Attachment> lstAttachments)
        {
            try
            {
                /* Sample HTML Template
                 * *****************************************************************************
                 * Hi #lblFName#,
                 * <br/>
                 * <br/>
                 * You are requested to appear for an interview on #lblDate# - #lblTime#.
                 * <br/>
                 * <br/>
                 * Regards,
                 * <br/>
                */

                string userName = ConfigurationManager.AppSettings["VendorCategoryUserName"].ToString();
                string password = ConfigurationManager.AppSettings["VendorCategoryPassword"].ToString();

                MailMessage Msg = new MailMessage();
                Msg.From = new MailAddress(userName, "JGrove Construction");
                Msg.To.Add(strToAddress);
                Msg.CC.Add(new MailAddress("jgrove.georgegrove@gmail.com", "Justin Grove"));
                Msg.Subject = strSubject;// "JG Prospect Notification";
                Msg.Body = strBody;
                Msg.IsBodyHtml = true;

                //ds = AdminBLL.Instance.GetEmailTemplate('');
                //// your remote SMTP server IP.
                foreach (Attachment objAttachment in lstAttachments)
                {
                    Msg.Attachments.Add(objAttachment);
                }
                SmtpClient sc = new SmtpClient(
                                                ConfigurationManager.AppSettings["smtpHost"].ToString(),
                                                Convert.ToInt32(ConfigurationManager.AppSettings["smtpPort"].ToString())
                                              );
                NetworkCredential ntw = new NetworkCredential(userName, password);
                sc.UseDefaultCredentials = false;
                sc.Credentials = ntw;
                sc.DeliveryMethod = SmtpDeliveryMethod.Network;
                sc.EnableSsl = Convert.ToBoolean(ConfigurationManager.AppSettings["enableSSL"].ToString()); // runtime encrypt the SMTP communications using SSL
                try
                {
                    sc.Send(Msg);
                }
                catch (Exception ex)
                {
                    // throw will call application error event, which will log error details.
                    throw ex;
                }

                Msg = null;
                sc.Dispose();
                sc = null;
            }
            catch (Exception ex)
            {
                // throw will call application error event, which will log error details.
                throw ex;
            }
        }
    }
}