using System;
using System.Collections.Generic;
using System.Linq;
using System.Net;
using System.Net.Http;
using System.Web.Http;
using JG_Prospect.Common;
using JG_Prospect.Common.modal;
using JG_Prospect.WebAPI.Models;
using System.Data;
using JG_Prospect.BLL;
using JG_Prospect.WebAPI;
using System.Net.Mail;
using JG_Prospect.WebAPI.App_Code;

namespace JG_Prospect.WebAPI.Controllers
{
    public class ValidateStaffController : ApiController
    {
        // GET api/validatestaff
        public IEnumerable<string> Get()
        {
            return new string[] { "value1", "value2" };
        }

        // GET api/validatestaff/5
        public string Get(int id)
        {
            return "value";
        }

        // POST api/validatestaff
        public ResultClass Post([FromBody]LoginUser value)
        {
            ResultClass Result = new ResultClass();
            Result.Message = "User is not valid";
            Result.Status = false;
            Result.Result = 0;

            if (value != null)
            {
                if ((!string.IsNullOrWhiteSpace(value.Email) || !string.IsNullOrWhiteSpace(value.Phone)) && !string.IsNullOrWhiteSpace(value.Password))
                {
                    DataSet ds = InstallUserBLL.Instance.CheckRegistration(value.Email.Trim(), value.Phone.Trim());
                    if (ds != null && ds.Tables[0].Rows.Count > 0)
                    {
                        value.FirstName = ds.Tables[0].Rows[0]["FristName"].ToString().Trim();
                        value.LastName = ds.Tables[0].Rows[0]["LastName"].ToString().Trim();
                        value.ID = Convert.ToInt32(ds.Tables[0].Rows[0]["Id"].ToString().Trim());

                        if (string.IsNullOrWhiteSpace(value.Email))
                        {
                            value.Email = ds.Tables[0].Rows[0]["Email"].ToString().Trim();
                        }

                        int IsValidInstallerUser = InstallUserBLL.Instance.IsValidInstallerUser(value.Email.Trim(), value.Password);
                        if (IsValidInstallerUser > 0)
                        {
                            var OTP = JGCommon.GenerateOTP(6);

                            int res = InstallUserBLL.Instance.InsertUserOTP(value.ID, 1, OTP);

                            if (res > 0)
                            {
                                string str_Body = "<table><tr><td>Hello,<span style=\"background-color: orange;\">User</span></td></tr><tr><td>your OTP for access api : " + OTP;
                                str_Body = str_Body + "</td></tr>";
                                str_Body = str_Body + "<tr><td></td></tr>";
                                str_Body = str_Body + "<tr><td>Thanks & Regards.</td></tr>";
                                str_Body = str_Body + "<tr><td><span style=\"background-color: orange;\">JM Grove Constructions</span></td></tr></table>";

                                CommonFunction.SendEmail("", value.Email, "JM Grove Construction:API OTP", str_Body, new List<Attachment>());

                                Result.Message = "User is valid and OTP is generated";
                                Result.Status = true;
                                Result.Result = 1;
                            }
                            else
                            {
                                Result.Message = "User is valid but OTP is not generated";
                            }

                        }
                        else
                        {
                            Result.Message = "Password is incorrect";
                        }
                    }
                    else
                    {
                        Result.Message = "Please check your user details";
                    }
                }
            }

            return Result;
        }

        // PUT api/validatestaff/5
        public void Put(int id, [FromBody]string value)
        {
        }

        // DELETE api/validatestaff/5
        public void Delete(int id)
        {
        }
    }
}
