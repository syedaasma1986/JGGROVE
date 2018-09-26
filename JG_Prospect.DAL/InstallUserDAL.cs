using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Data;
using System.Data.Common;
using Microsoft.Practices.EnterpriseLibrary.Data.Sql;

using JG_Prospect.DAL.Database;
using JG_Prospect.Common;
using JG_Prospect.Common.modal;
using System.Xml;
using System.Web.UI.HtmlControls;
using System.Data.SqlClient;
using static JG_Prospect.Common.JGCommon;

namespace JG_Prospect.DAL
{
    public class InstallUserDAL
    {
        public static InstallUserDAL m_InstallUserDAL = new InstallUserDAL();
        private InstallUserDAL()
        {
        }
        public static InstallUserDAL Instance
        {
            get { return m_InstallUserDAL; }
            private set {; }
        }

        public DataSet returndata;

        public void AddUserNotes(string Notes, int UserID, int AddedByID)
        {
            try
            {
                SqlDatabase database = MSSQLDataBase.Instance.GetDefaultDatabase();
                {
                    DbCommand command = database.GetStoredProcCommand("AddUserNotes");
                    command.CommandType = CommandType.StoredProcedure;
                    database.AddInParameter(command, "@UserID", DbType.Int32, UserID);
                    database.AddInParameter(command, "@Notes", DbType.String, Notes);
                    database.AddInParameter(command, "@AddedByID", DbType.Int32, AddedByID);
                    database.AddInParameter(command, "@AddedOn", DbType.DateTime, DateTime.Now);
                    database.ExecuteNonQuery(command);
                }
            }
            catch (Exception ex)
            { Console.Write(ex.Message); }
        }

        public bool IsManager(int userID)
        {
            try
            {
                returndata = new DataSet();
                SqlDatabase database = MSSQLDataBase.Instance.GetDefaultDatabase();
                {
                    DbCommand command = database.GetStoredProcCommand("IsManager");
                    command.CommandType = CommandType.StoredProcedure;
                    database.AddInParameter(command, "@UserID", DbType.Int32, userID);
                    returndata = database.ExecuteDataSet(command);
                    return Convert.ToBoolean(returndata.Tables[0].Rows[0]["IsManager"]);
                }
            }
            catch (Exception ex)
            {
                return false;
            }
        }

        public DataSet GetUserEmailAndPhone(int UserID)
        {
            returndata = new DataSet();

            try
            {
                SqlDatabase database = MSSQLDataBase.Instance.GetDefaultDatabase();
                {
                    DbCommand command = database.GetStoredProcCommand("sp_GetUserEmailAndPhone");
                    command.CommandType = CommandType.StoredProcedure;
                    database.AddInParameter(command, "@UserID", DbType.Int32, UserID);
                    returndata = database.ExecuteDataSet(command);
                }
            }
            catch (Exception ex)
            { Console.Write(ex.Message); }

            return returndata;
        }

        public void SetPrimaryContactOfUser(int DataID, int UserID, int DataType, bool IsPrimary)
        {
            try
            {
                SqlDatabase database = MSSQLDataBase.Instance.GetDefaultDatabase();
                {
                    DbCommand command = database.GetStoredProcCommand("sp_SetPrimaryContactOfUser");
                    command.CommandType = CommandType.StoredProcedure;
                    database.AddInParameter(command, "@DataID", DbType.Int32, DataID);
                    database.AddInParameter(command, "@UserID", DbType.Int32, UserID);
                    database.AddInParameter(command, "@DataType", DbType.Int32, DataType);
                    database.AddInParameter(command, "@IsPrimary", DbType.Boolean, IsPrimary);
                    database.ExecuteNonQuery(command);
                }
            }
            catch (Exception ex)
            { Console.Write(ex.Message); }
        }

        public string AddUserEmailOrPhone(int UserID, string DataForValidation, int DataType, string PhoneTypeID, string PhoneExt, bool IsPrimary)
        {
            string res = "";

            try
            {
                SqlDatabase database = MSSQLDataBase.Instance.GetDefaultDatabase();
                {
                    DbCommand command = database.GetStoredProcCommand("sp_AddUserEmailOrPhone");
                    command.CommandType = CommandType.StoredProcedure;
                    database.AddInParameter(command, "@UserID", DbType.Int32, UserID);
                    database.AddInParameter(command, "@DataForValidation", DbType.String, DataForValidation);
                    database.AddInParameter(command, "@DataType", DbType.Int32, DataType);
                    database.AddInParameter(command, "@PhoneTypeID", DbType.String, PhoneTypeID);
                    database.AddInParameter(command, "@PhoneExt", DbType.String, PhoneExt);
                    database.AddInParameter(command, "@IsPrimary", DbType.Boolean, IsPrimary);
                    res = database.ExecuteScalar(command).ToString();
                }
            }
            catch (Exception ex)
            { Console.Write(ex.Message); res = "error"; }

            return res;
        }

        #region userlogin

        public bool BulkUpdateIntsallUser(string xmlDoc, string UpdatedBy)
        {
            DataSet dsTemp = new DataSet();

            try
            {
                SqlDatabase database = MSSQLDataBase.Instance.GetDefaultDatabase();
                {
                    DbCommand command = database.GetStoredProcCommand("UDP_BulkUpdateInstallUser");
                    database.AddInParameter(command, "@XMLDOC2", DbType.Xml, xmlDoc);
                    database.AddInParameter(command, "@UpdatedBy", DbType.String, UpdatedBy);
                    database.AddOutParameter(command, "@result", DbType.Int32, 1);
                    database.ExecuteScalar(command);
                    int res = Convert.ToInt32(database.GetParameterValue(command, "@result"));

                    return res == 1 ? true : false;
                }
            }
            catch (Exception ex)
            {
                return false;
            }
        }

        public DataSet BulkIntsallUser(string xmlDoc)
        {
            DataSet dsTemp = new DataSet();

            try
            {
                SqlDatabase database = MSSQLDataBase.Instance.GetDefaultDatabase();
                {
                    DbCommand command = database.GetStoredProcCommand("UDP_BulkInstallUser");
                    database.AddInParameter(command, "@XMLDOC2", SqlDbType.Xml, xmlDoc);
                    dsTemp = database.ExecuteDataSet(command);
                    return dsTemp;
                }
            }
            catch (Exception ex)
            {
            }
            return dsTemp;
        }

        public Tuple<bool, Int32> AddIntsallUser(user objuser)
        {
            var tupResult = Tuple.Create<bool, Int32>(false, 0);
            try
            {
                SqlDatabase database = MSSQLDataBase.Instance.GetDefaultDatabase();
                {
                    DbCommand command = database.GetStoredProcCommand("UDP_AddInstallUser");
                    command.CommandType = CommandType.StoredProcedure;
                    #region SP Parameters

                    database.AddInParameter(command, "@FristName", DbType.String, objuser.fristname);
                    database.AddInParameter(command, "@LastName", DbType.String, objuser.lastname);
                    database.AddInParameter(command, "@Email", DbType.String, objuser.email);
                    database.AddInParameter(command, "@phone", DbType.String, objuser.phone);
                    database.AddInParameter(command, "@phonetype", DbType.String, objuser.phonetype);
                    database.AddInParameter(command, "@Address", DbType.String, objuser.address);
                    database.AddInParameter(command, "@Zip", DbType.String, objuser.zip);
                    database.AddInParameter(command, "@State", DbType.String, objuser.state);
                    database.AddInParameter(command, "@City", DbType.String, objuser.city);

                    database.AddInParameter(command, "@password", DbType.String, objuser.password);
                    database.AddInParameter(command, "@designation", DbType.String, objuser.designation);
                    database.AddInParameter(command, "@status", DbType.String, objuser.status);
                    database.AddInParameter(command, "@Picture", DbType.String, objuser.picture);
                    database.AddInParameter(command, "@Attachements", DbType.String, objuser.attachements);
                    database.AddInParameter(command, "@bussinessname", DbType.String, objuser.businessname);
                    database.AddInParameter(command, "@ssn", DbType.String, objuser.ssn);
                    database.AddInParameter(command, "@ssn1", DbType.String, objuser.ssn1);
                    database.AddInParameter(command, "@ssn2", DbType.String, objuser.ssn2);
                    database.AddInParameter(command, "@signature", DbType.String, objuser.signature);
                    database.AddInParameter(command, "@dob", DbType.String, objuser.dob);
                    database.AddInParameter(command, "@citizenship", DbType.String, objuser.citizenship);
                    database.AddInParameter(command, "@ein1 ", DbType.String, objuser.ein1);
                    database.AddInParameter(command, "@ein2 ", DbType.String, objuser.ein2);
                    database.AddInParameter(command, "@a", DbType.String, objuser.a);
                    database.AddInParameter(command, "@b", DbType.String, objuser.b);
                    database.AddInParameter(command, "@c", DbType.String, objuser.c);
                    database.AddInParameter(command, "@d", DbType.String, objuser.d);
                    database.AddInParameter(command, "@e", DbType.String, objuser.e);
                    database.AddInParameter(command, "@f", DbType.String, objuser.f);
                    database.AddInParameter(command, "@g", DbType.String, objuser.g);
                    database.AddInParameter(command, "@h", DbType.String, objuser.h);
                    database.AddInParameter(command, "@i", DbType.String, objuser.i);
                    database.AddInParameter(command, "@j", DbType.String, objuser.j);
                    database.AddInParameter(command, "@k", DbType.String, objuser.k);
                    database.AddInParameter(command, "@maritalstatus", DbType.String, objuser.maritalstatus);
                    database.AddInParameter(command, "@PrimeryTradeId", DbType.Int32, objuser.PrimeryTradeId);
                    //database.AddInParameter(command, "@SecondoryTradeId", DbType.Int32, objuser.SecondoryTradeId);

                    database.AddInParameter(command, "@Source", DbType.String, objuser.Source);
                    database.AddInParameter(command, "@Notes", DbType.String, objuser.Notes);
                    database.AddInParameter(command, "@StatusReason", DbType.String, objuser.Reason);
                    database.AddInParameter(command, "@GeneralLiability", DbType.String, objuser.GeneralLiability);
                    database.AddInParameter(command, "@PCLiscense", DbType.String, objuser.PqLicense);
                    database.AddInParameter(command, "@WorkerComp", DbType.String, objuser.WorkersComp);
                    database.AddInParameter(command, "@HireDate", DbType.String, objuser.HireDate);
                    database.AddInParameter(command, "@TerminitionDate", DbType.String, objuser.TerminitionDate);
                    database.AddInParameter(command, "@WorkersCompCode", DbType.String, objuser.WorkersCompCode);
                    database.AddInParameter(command, "@NextReviewDate", DbType.String, objuser.NextReviewDate);
                    database.AddInParameter(command, "@EmpType", DbType.String, objuser.EmpType);
                    database.AddInParameter(command, "@LastReviewDate", DbType.String, objuser.LastReviewDate);
                    database.AddInParameter(command, "@PayRates", DbType.String, objuser.PayRates);
                    database.AddInParameter(command, "@ExtraEarning", DbType.String, objuser.ExtraEarning);
                    database.AddInParameter(command, "@ExtraIncomeType", DbType.String, objuser.ExtraIncomeType);
                    database.AddInParameter(command, "@ExtraEarningAmt", DbType.String, objuser.ExtraEarningAmt);
                    database.AddInParameter(command, "@PayMethod", DbType.String, objuser.PayMethod);
                    database.AddInParameter(command, "@Deduction", DbType.String, objuser.Deduction);
                    database.AddInParameter(command, "@DeductionType", DbType.String, objuser.DeductionType);
                    database.AddInParameter(command, "@AbaAccountNo", DbType.String, objuser.AbaAccountNo);
                    database.AddInParameter(command, "@AccountNo", DbType.String, objuser.AccountNo);
                    database.AddInParameter(command, "@AccountType", DbType.String, objuser.AccountType);
                    //database.AddInParameter(command, "@StatusReason", DbType.String, objuser.Reason);
                    database.AddInParameter(command, "@InstallId", DbType.String, objuser.InstallId);
                    database.AddInParameter(command, "@PTradeOthers", DbType.String, objuser.PTradeOthers);
                    database.AddInParameter(command, "@STradeOthers", DbType.String, objuser.STradeOthers);
                    database.AddInParameter(command, "@DeductionReason", DbType.String, objuser.DeductionReason);
                    database.AddInParameter(command, "@SuiteAptRoom", DbType.String, objuser.str_SuiteAptRoom);


                    database.AddInParameter(command, "@FullTimePosition", DbType.Int32, objuser.FullTimePosition);
                    database.AddInParameter(command, "@ContractorsBuilderOwner", DbType.String, objuser.ContractorsBuilderOwner);
                    database.AddInParameter(command, "@MajorTools", DbType.String, objuser.MajorTools);
                    database.AddInParameter(command, "@DrugTest", DbType.Boolean, objuser.DrugTest);
                    database.AddInParameter(command, "@ValidLicense", DbType.Boolean, objuser.ValidLicense);
                    database.AddInParameter(command, "@TruckTools", DbType.Boolean, objuser.TruckTools);
                    database.AddInParameter(command, "@PrevApply", DbType.Boolean, objuser.PrevApply);
                    database.AddInParameter(command, "@LicenseStatus", DbType.Boolean, objuser.LicenseStatus);
                    database.AddInParameter(command, "@CrimeStatus", DbType.Boolean, objuser.CrimeStatus);
                    database.AddInParameter(command, "@StartDate", DbType.String, objuser.StartDate);
                    database.AddInParameter(command, "@SalaryReq", DbType.String, objuser.SalaryReq);
                    database.AddInParameter(command, "@Avialability", DbType.String, objuser.Avialability);
                    database.AddInParameter(command, "@ResumePath", DbType.String, objuser.ResumePath);
                    database.AddInParameter(command, "@skillassessmentstatus", DbType.Boolean, objuser.skillassessmentstatus);
                    database.AddInParameter(command, "@assessmentPath", DbType.String, objuser.assessmentPath);
                    database.AddInParameter(command, "@WarrentyPolicy", DbType.String, objuser.WarrentyPolicy);
                    database.AddInParameter(command, "@CirtificationTraining", DbType.String, objuser.CirtificationTraining);
                    database.AddInParameter(command, "@businessYrs", DbType.Decimal, objuser.businessYrs);
                    database.AddInParameter(command, "@underPresentComp", DbType.Decimal, objuser.underPresentComp);
                    database.AddInParameter(command, "@websiteaddress", DbType.String, objuser.websiteaddress);
                    database.AddInParameter(command, "@PersonName", DbType.String, objuser.PersonName);
                    database.AddInParameter(command, "@PersonType", DbType.String, objuser.PersonType);
                    database.AddInParameter(command, "@CompanyPrinciple", DbType.String, objuser.CompanyPrinciple);
                    database.AddInParameter(command, "@UserType", DbType.String, objuser.UserType);
                    database.AddInParameter(command, "@Email2", DbType.String, objuser.Email2);
                    database.AddInParameter(command, "@Phone2", DbType.String, objuser.Phone2);
                    database.AddInParameter(command, "@CompanyName", DbType.String, objuser.CompanyName);
                    database.AddInParameter(command, "@SourceUser", DbType.String, objuser.SourceUser);
                    database.AddInParameter(command, "@DateSourced", DbType.String, objuser.DateSourced);
                    database.AddInParameter(command, "@InstallerType", DbType.String, objuser.InstallerType);

                    database.AddInParameter(command, "@BusinessType", DbType.String, objuser.BusinessType);
                    database.AddInParameter(command, "@CEO", DbType.String, objuser.CEO);
                    database.AddInParameter(command, "@LegalOfficer", DbType.String, objuser.LegalOfficer);
                    database.AddInParameter(command, "@President", DbType.String, objuser.President);
                    database.AddInParameter(command, "@Owner", DbType.String, objuser.Owner);
                    database.AddInParameter(command, "@AllParteners", DbType.String, objuser.AllParteners);
                    database.AddInParameter(command, "@MailingAddress", DbType.String, objuser.MailingAddress);
                    database.AddInParameter(command, "@Warrantyguarantee", DbType.Boolean, objuser.Warrantyguarantee);
                    database.AddInParameter(command, "@WarrantyYrs", DbType.Int32, objuser.WarrantyYrs);
                    database.AddInParameter(command, "@MinorityBussiness", DbType.Boolean, objuser.MinorityBussiness);
                    database.AddInParameter(command, "@WomensEnterprise", DbType.Boolean, objuser.WomensEnterprise);
                    database.AddInParameter(command, "@InterviewTime", DbType.String, objuser.InterviewTime);
                    database.AddInParameter(command, "@ActivationDate", DbType.String, objuser.ActivationDate);
                    database.AddInParameter(command, "@UserActivated", DbType.String, objuser.UserActivated);
                    database.AddInParameter(command, "@LIBC", DbType.String, objuser.UserActivated);

                    database.AddInParameter(command, "@CruntEmployement", DbType.Boolean, objuser.CruntEmployement);
                    database.AddInParameter(command, "@CurrentEmoPlace", DbType.String, objuser.CurrentEmoPlace);
                    database.AddInParameter(command, "@LeavingReason", DbType.String, objuser.LeavingReason);
                    database.AddInParameter(command, "@CompLit", DbType.Boolean, objuser.CompLit);
                    database.AddInParameter(command, "@FELONY", DbType.Boolean, objuser.FELONY);
                    database.AddInParameter(command, "@shortterm", DbType.String, objuser.shortterm);
                    database.AddInParameter(command, "@LongTerm", DbType.String, objuser.LongTerm);
                    database.AddInParameter(command, "@BestCandidate", DbType.String, objuser.BestCandidate);
                    database.AddInParameter(command, "@TalentVenue", DbType.String, objuser.TalentVenue);
                    database.AddInParameter(command, "@Boardsites", DbType.String, objuser.Boardsites);
                    database.AddInParameter(command, "@NonTraditional", DbType.String, objuser.NonTraditional);
                    database.AddInParameter(command, "@ConSalTraning", DbType.String, objuser.ConSalTraning);
                    database.AddInParameter(command, "@BestTradeOne", DbType.String, objuser.BestTradeOne);
                    database.AddInParameter(command, "@BestTradeTwo", DbType.String, objuser.BestTradeTwo);
                    database.AddInParameter(command, "@BestTradeThree", DbType.String, objuser.BestTradeThree);

                    database.AddInParameter(command, "@aOne", DbType.String, objuser.aOne);
                    database.AddInParameter(command, "@aOneTwo", DbType.String, objuser.aOneTwo);
                    database.AddInParameter(command, "@bOne", DbType.String, objuser.bOne);
                    database.AddInParameter(command, "@cOne", DbType.String, objuser.cOne);
                    database.AddInParameter(command, "@aTwo", DbType.String, objuser.aTwo);
                    database.AddInParameter(command, "@aTwoTwo", DbType.String, objuser.aTwoTwo);
                    database.AddInParameter(command, "@bTwo", DbType.String, objuser.bTwo);
                    database.AddInParameter(command, "@cTwo", DbType.String, objuser.cTwo);
                    database.AddInParameter(command, "@aThree", DbType.String, objuser.aThree);
                    database.AddInParameter(command, "@aThreeTwo", DbType.String, objuser.aThreeTwo);
                    database.AddInParameter(command, "@bThree", DbType.String, objuser.bThree);
                    database.AddInParameter(command, "@cThree", DbType.String, objuser.cThree);

                    database.AddInParameter(command, "@RejectionDate", DbType.String, objuser.RejectionDate);
                    database.AddInParameter(command, "@RejectionTime", DbType.String, objuser.RejectionTime);

                    database.AddInParameter(command, "@RejectedUserId", DbType.Int32, objuser.RejectedUserId);
                    database.AddInParameter(command, "@TC", DbType.Boolean, objuser.TC);
                    database.AddInParameter(command, "@AddedBy", DbType.Int32, objuser.AddedBy);

                    database.AddInParameter(command, "@PositionAppliedFor", DbType.String, objuser.PositionAppliedFor);
                    database.AddInParameter(command, "@DesignationID", DbType.Int32, objuser.DesignationID);
                    database.AddInParameter(command, "@PhoneISDCode", DbType.String, objuser.PhoneISDCode);
                    database.AddInParameter(command, "@PhoneExtNo", DbType.String, objuser.PhoneExtNo);
                    database.AddInParameter(command, "@CountryCode", DbType.String, objuser.CountryCode);

                    database.AddInParameter(command, "@NameMiddleInitial", DbType.String, objuser.NameMiddleInitial);
                    database.AddInParameter(command, "@IsEmailPrimaryEmail", DbType.Boolean, objuser.IsEmailPrimaryEmail);
                    database.AddInParameter(command, "@IsPhonePrimaryPhone", DbType.Boolean, objuser.IsPhonePrimaryPhone);
                    database.AddInParameter(command, "@IsEmailContactPreference", DbType.Boolean, objuser.IsEmailContactPreference);
                    database.AddInParameter(command, "@IsCallContactPreference", DbType.Boolean, objuser.IsCallContactPreference);
                    database.AddInParameter(command, "@IsTextContactPreference", DbType.Boolean, objuser.IsTextContactPreference);
                    database.AddInParameter(command, "@IsMailContactPreference", DbType.Boolean, objuser.IsMailContactPreference);
                    database.AddInParameter(command, "@SourceID", DbType.Int32, objuser.SourceId);

                    database.AddOutParameter(command, "@result", DbType.Int32, 1);
                    database.AddOutParameter(command, "@Id", DbType.Int32, 0);

                    #endregion
                    database.ExecuteScalar(command);
                    bool blSuccess = Convert.ToInt32(database.GetParameterValue(command, "@result")) == 1 ? true : false;
                    int id = Convert.ToInt32(database.GetParameterValue(command, "@Id"));
                    tupResult = Tuple.Create<bool, Int32>(blSuccess, id);
                }
            }
            catch (Exception ex)
            {

            }
            return tupResult;
        }

        public bool CheckUnsubscribedEmail(string strToAddress)
        {
            try
            {
                SqlDatabase database = MSSQLDataBase.Instance.GetDefaultDatabase();
                {
                    DbCommand command = database.GetStoredProcCommand("usp_CheckEmailSubscription");
                    command.CommandType = CommandType.StoredProcedure;
                    database.AddInParameter(command, "@Email", DbType.String, strToAddress);


                    SqlDataReader dr = (SqlDataReader)database.ExecuteReader(command);

                    return dr.HasRows;
                }
            }
            catch (Exception ex)
            {
                return false;
            }
        }

        public int AddTouchPointLogRecord(int loginUserID, int userID, string loginUserInstallID, DateTime LogTime, string changeLog, string strGUID, int touchPointSource)
        {
            try
            {
                SqlDatabase database = MSSQLDataBase.Instance.GetDefaultDatabase();
                {
                    DbCommand command = database.GetStoredProcCommand("Sp_InsertTouchPointLog");
                    command.CommandType = CommandType.StoredProcedure;
                    database.AddInParameter(command, "@userID", DbType.Int32, userID);
                    database.AddInParameter(command, "@loginUserID", DbType.Int32, loginUserID);
                    database.AddInParameter(command, "@loginUserInstallID", DbType.String, loginUserInstallID);
                    database.AddInParameter(command, "@LogTime", DbType.DateTime, LogTime);
                    database.AddInParameter(command, "@changeLog", DbType.String, changeLog);
                    database.AddInParameter(command, "@CurrGUID", DbType.String, strGUID);
                    database.AddInParameter(command, "@TouchPointSource", DbType.Int32, touchPointSource);
                    DataSet dsTemp = database.ExecuteDataSet(command);
                    return Convert.ToInt32(dsTemp.Tables[0].Rows[0]["UserTouchPointLogID"]);
                }
            }
            catch (Exception ex)
            {
                return 0;
            }
        }

        public ChatParameter GetChatParametersByUser(int userId, int loggedInUserId, int? taskId, int? taskMultilevelListId)
        {
            SqlDatabase database = MSSQLDataBase.Instance.GetDefaultDatabase();
            {
                DbCommand command = database.GetStoredProcCommand("GetChatParametersByUser");
                command.CommandType = CommandType.StoredProcedure;
                database.AddInParameter(command, "@UserId", DbType.Int32, userId);
                database.AddInParameter(command, "@LoggedInUserId", DbType.Int32, loggedInUserId);
                database.AddInParameter(command, "@TaskId", DbType.Int32, taskId);
                database.AddInParameter(command, "@TaskMultilevelListId", DbType.Int32, taskMultilevelListId);

                returndata = database.ExecuteDataSet(command);
                DataRow row = returndata.Tables[0].Rows[0];
                return new ChatParameter
                {
                    ChatGroupId = row["ChatGroupId"].ToString(),
                    ReceiverIds = row["ReceiverIds"].ToString(),
                    UserChatGroupId = Convert.ToInt32(row["UserChatGroupId"])
                };
            }
        }

        public void UpdateTouchPointLog(string strGUID, int installUserID)
        {
            try
            {
                SqlDatabase database = MSSQLDataBase.Instance.GetDefaultDatabase();
                {
                    DbCommand command = database.GetStoredProcCommand("Sp_UpdateNewUserIDInTouchPointLog");
                    command.CommandType = CommandType.StoredProcedure;
                    database.AddInParameter(command, "@NewuserID", DbType.Int32, installUserID);
                    database.AddInParameter(command, "@CurrGUID", DbType.String, strGUID);

                    string lResult = database.ExecuteScalar(command).ToString();
                }
            }
            catch (Exception ex)
            {

            }
        }

        public string CheckForNewUserByEmaiID(string userEmail, int userID, string DefaultPW)
        {
            DataSet dsResult = new DataSet();
            try
            {
                SqlDatabase database = MSSQLDataBase.Instance.GetDefaultDatabase();
                {
                    DbCommand command = database.GetStoredProcCommand("SP_CheckNewUserFromOtherSite");
                    command.CommandType = CommandType.StoredProcedure;
                    database.AddInParameter(command, "@userEmail", DbType.String, userEmail);
                    database.AddInParameter(command, "@userID", DbType.Int32, userID);
                    database.AddInParameter(command, "@DefaultPassWord", DbType.String, DefaultPW);


                    //dsResult = database.ExecuteDataSet(command);

                    string lResult = database.ExecuteScalar(command).ToString();
                    return lResult;
                }
            }
            catch (Exception ex)
            {
                return ex.Message;
            }
        }

        public DataSet GetTouchPointLogDataByUserID(int userID)
        {
            try
            {
                SqlDatabase database = MSSQLDataBase.Instance.GetDefaultDatabase();
                {
                    returndata = new DataSet();
                    DbCommand command = database.GetStoredProcCommand("Sp_GetTouchPointLogDataByUserID");
                    database.AddInParameter(command, "@userID", DbType.Int32, userID);
                    command.CommandType = CommandType.StoredProcedure;
                    returndata = database.ExecuteDataSet(command);
                    return returndata;
                }
            }
            catch (Exception ex)
            {
                return null;
            }
        }

        public PagingResult<Notes> GetUserTouchPointLogs(int pageNumber, int pageSize, int userId)
        {
            try
            {
                List<Notes> notes = new List<Notes>();
                SqlDatabase database = MSSQLDataBase.Instance.GetDefaultDatabase();
                {
                    returndata = new DataSet();
                    DbCommand command = database.GetStoredProcCommand("GetUserTouchPointLogs");
                    database.AddInParameter(command, "@UserID", DbType.Int32, userId);
                    database.AddInParameter(command, "@PageNumber", DbType.Int32, pageNumber);
                    database.AddInParameter(command, "@PageSize", DbType.Int32, pageSize);
                    database.AddOutParameter(command, "@TotalResults", DbType.Int32, 0);

                    command.CommandType = CommandType.StoredProcedure;
                    returndata = database.ExecuteDataSet(command);

                    int TotalResults = Convert.ToInt32(database.GetParameterValue(command, "@TotalResults"));

                    if (returndata != null && returndata.Tables[0] != null && returndata.Tables[0].Rows.Count > 0)
                    {
                        foreach (DataRow item in returndata.Tables[0].Rows)
                        {
                            notes.Add(new Notes
                            {
                                UserTouchPointLogID = Convert.ToInt32(item["UserTouchPointLogID"]),
                                UserID = Convert.ToInt32(item["UserID"]),
                                UpdatedByUserID = Convert.ToInt32(item["UpdatedByUserID"]),
                                UpdatedUserInstallID = item["UpdatedUserInstallID"].ToString(),
                                ChangeDateTime = Convert.ToDateTime(item["ChangeDateTime"]).ToEST(),
                                LogDescription = item["LogDescription"].ToString(),
                                UpdatedByFirstName = item["UpdatedByFirstName"].ToString(),
                                UpdatedByLastName = item["UpdatedByLastName"].ToString(),
                                UpdatedByEmail = item["UpdatedByEmail"].ToString(),
                                FristName = item["FristName"].ToString(),
                                LastName = item["LastName"].ToString(),
                                Email = item["Email"].ToString(),
                                Phone = item["Phone"].ToString(),
                                ChangeDateTimeFormatted = Convert.ToDateTime(item["ChangeDateTime"]).ToEST().ToString(),
                                SourceUser = item["SourceUser"].ToString(),
                                SourceUserInstallId = item["SourceUserInstallId"].ToString(),
                                SourceUsername = item["SourceUsername"].ToString(),
                                TouchPointSource = item["TouchPointSource"] != null ? Convert.ToInt32(item["TouchPointSource"]) : 0
                            });
                        }
                    }
                    return new PagingResult<Notes>
                    {
                        Data = notes,
                        Status = ActionStatus.Successfull,
                        TotalResults = TotalResults
                    };
                }
            }
            catch (Exception ex)
            {
                return null;
            }
        }

        public ActionOutput<string> GenerateLoginCode(int userId)
        {
            try
            {
                SqlDatabase database = MSSQLDataBase.Instance.GetDefaultDatabase();
                {
                    returndata = new DataSet();
                    DbCommand command = database.GetStoredProcCommand("GenerateLoginCode");
                    database.AddInParameter(command, "@UserId", DbType.Int32, userId);

                    command.CommandType = CommandType.StoredProcedure;
                    returndata = database.ExecuteDataSet(command);
                }
                return new ActionOutput<string>
                {
                    Object = returndata.Tables[0].Rows[0]["Id"].ToString(),
                    Status = ActionStatus.Successfull
                };
            }
            catch (Exception ex)
            {
                return new ActionOutput<string>
                {
                    Status = ActionStatus.Error,
                    Object = ex.ToString(),
                    Message = ex.Message
                };
            }
        }

        public ActionOutput<string> GenerateLoginCode(string Email)
        {
            try
            {
                SqlDatabase database = MSSQLDataBase.Instance.GetDefaultDatabase();
                {
                    returndata = new DataSet();
                    DbCommand command = database.GetStoredProcCommand("GenerateLoginCodeByEmail");
                    database.AddInParameter(command, "@Email", DbType.String, Email);

                    command.CommandType = CommandType.StoredProcedure;
                    returndata = database.ExecuteDataSet(command);
                }
                return new ActionOutput<string>
                {
                    Object = returndata.Tables[0].Rows[0]["Id"].ToString(),
                    Status = ActionStatus.Successfull
                };
            }
            catch (Exception ex)
            {
                return new ActionOutput<string>
                {
                    Status = ActionStatus.Error,
                    Object = ex.ToString(),
                    Message = ex.Message
                };
            }
        }

        public ActionOutput<string> ExpireLoginCode(string Id)
        {
            try
            {
                SqlDatabase database = MSSQLDataBase.Instance.GetDefaultDatabase();
                {
                    returndata = new DataSet();
                    DbCommand command = database.GetStoredProcCommand("ExpireLoginCode");
                    database.AddInParameter(command, "@Id", DbType.String, Id);

                    command.CommandType = CommandType.StoredProcedure;
                    returndata = database.ExecuteDataSet(command);
                }
                return new ActionOutput<string>
                {
                    Status = ActionStatus.Successfull,
                    Object = returndata.Tables[0].Rows[0]["Email"].ToString()
                };
            }
            catch (Exception ex)
            {
                return new ActionOutput<string>
                {
                    Status = ActionStatus.Error,
                    Message = ex.Message
                };
            }
        }

        public PhoneCallStatistics GetPhoneCallStatistics()
        {
            PhoneCallStatistics stats = new PhoneCallStatistics();
            try
            {
                SqlDatabase database = MSSQLDataBase.Instance.GetDefaultDatabase();
                {
                    returndata = new DataSet();
                    DbCommand command = database.GetStoredProcCommand("GetPhoneCallStatistics");

                    command.CommandType = CommandType.StoredProcedure;
                    returndata = database.ExecuteDataSet(command);
                    if (returndata != null && returndata.Tables[0] != null && returndata.Tables[0].Rows.Count > 0)
                    {
                        DataRow dr = returndata.Tables[0].Rows[0];
                        {
                            stats.Mode = dr["Mode"].ToString();
                            stats.TotalApplicantCalled = Convert.ToInt32(dr["TotalApplicantCalled"]);
                            stats.TotalApplicantDuration = Convert.ToDouble(dr["TotalApplicantDuration"]);
                            stats.TotalApplicantDurationFormatted = (TimeSpan.FromSeconds(Convert.ToInt32(dr["TotalApplicantDuration"]))).ToString(@"hh\:mm\:ss");

                            stats.TotalOutbound = Convert.ToInt32(dr["TotalOutbound"]);
                            stats.TotalCallDurationInSeconds = Convert.ToDouble(dr["TotalCallDurationInSeconds"]);
                            stats.TotalCallDurationFormatted = (TimeSpan.FromSeconds(Convert.ToInt32(dr["TotalCallDurationInSeconds"]))).ToString(@"hh\:mm\:ss");

                            stats.TotalInterviewDateCalled = Convert.ToInt32(dr["TotalInterviewDateCalled"]);
                            stats.TotalInterviewDateDuration = Convert.ToDouble(dr["TotalInterviewDateDuration"]);
                            stats.TotalInterviewDateFormatted = (TimeSpan.FromSeconds(Convert.ToInt32(dr["TotalInterviewDateDuration"]))).ToString(@"hh\:mm\:ss");

                            stats.TotalReferralApplicantCalled = Convert.ToInt32(dr["TotalReferralApplicantCalled"]);
                            stats.TotalReferralApplicantDuration = Convert.ToDouble(dr["TotalReferralApplicantDuration"]);
                            stats.TotalReferralApplicantFormatted = (TimeSpan.FromSeconds(Convert.ToInt32(dr["TotalReferralApplicantDuration"]))).ToString(@"hh\:mm\:ss");
                        }
                    }
                }
                return stats;
            }
            catch (Exception ex)
            {
                return stats;
            }
        }

        public GlobalSearchModel GlobalSearch(string keyword, int LoggedInUserId)
        {
            List<SearchUser> one = new List<SearchUser>();
            List<SearchUser> two = new List<SearchUser>();
            List<SearchUser> three = new List<SearchUser>();
            try
            {
                SqlDatabase database = MSSQLDataBase.Instance.GetDefaultDatabase();
                {
                    returndata = new DataSet();
                    DbCommand command = database.GetStoredProcCommand("GlobalSearch");
                    database.AddInParameter(command, "@Keyword", DbType.String, keyword);
                    database.AddInParameter(command, "@LoggedInUserId", DbType.Int32, LoggedInUserId);

                    command.CommandType = CommandType.StoredProcedure;
                    returndata = database.ExecuteDataSet(command);
                    if (returndata.Tables[0] != null && returndata.Tables[0].Rows.Count > 0)
                    {
                        foreach (DataRow item in returndata.Tables[0].Rows)
                        {
                            one.Add(new SearchUser
                            {
                                Id = Convert.ToInt32(item["Id"].ToString()),
                                Email = item["Email"].ToString(),
                                Fullname = item["FristName"].ToString() + " " + item["LastName"].ToString(),
                            });
                        }
                    }
                    if (returndata.Tables[1] != null && returndata.Tables[1].Rows.Count > 0)
                    {
                        foreach (DataRow item in returndata.Tables[1].Rows)
                        {
                            two.Add(new SearchUser
                            {
                                Id = Convert.ToInt32(item["Id"].ToString()),
                                Email = item["Email"].ToString(),
                                Fullname = item["FristName"].ToString() + " " + item["LastName"].ToString(),
                            });
                        }
                    }
                    if (returndata.Tables[2] != null && returndata.Tables[2].Rows.Count > 0)
                    {
                        foreach (DataRow item in returndata.Tables[2].Rows)
                        {
                            three.Add(new SearchUser
                            {
                                Id = Convert.ToInt32(item["Id"].ToString()),
                                Email = item["Email"].ToString(),
                                Fullname = item["FristName"].ToString() + " " + item["LastName"].ToString(),
                            });
                        }
                    }
                    return new GlobalSearchModel
                    {
                        SearchUsersByFirstName = one,
                        SearchUsersByLastName = two,
                        SearchUsersByEmail = three
                    };
                }

            }
            catch (Exception ex)
            {
                return new GlobalSearchModel();
            }
        }

        public List<LoginUser> GetUserManagers(int userId)
        {
            List<LoginUser> users = new List<LoginUser>();
            try
            {
                SqlDatabase database = MSSQLDataBase.Instance.GetDefaultDatabase();
                {
                    returndata = new DataSet();
                    DbCommand command = database.GetStoredProcCommand("GetUserManagers");
                    database.AddInParameter(command, "@UserId", DbType.Int32, userId);

                    command.CommandType = CommandType.StoredProcedure;
                    returndata = database.ExecuteDataSet(command);
                    foreach (DataRow item in returndata.Tables[0].Rows)
                    {
                        users.Add(new LoginUser
                        {
                            ID = Convert.ToInt32(item["Id"].ToString()),
                            Email = item["Email"].ToString(),
                            FirstName = item["FirstName"].ToString(),
                            LastName = item["LastName"].ToString()
                        });
                    }
                    return users;
                }

            }
            catch (Exception ex)
            {
                return users;
            }
        }

        public string UpdateSecondaryStatus(int userId, int newStatus, string newStatusText, int oldStatus, 
                                                string oldStatusText, int loggedInUserId, bool AddHrChatLog = true)
        {
            try
            {
                SqlDatabase database = MSSQLDataBase.Instance.GetDefaultDatabase();
                {
                    returndata = new DataSet();
                    DbCommand command = database.GetStoredProcCommand("UpdateSecondaryStatus");
                    database.AddInParameter(command, "@SecondaryStatus", DbType.Int32, newStatus);
                    database.AddInParameter(command, "@OldSecondaryStatus", DbType.Int32, oldStatus);
                    database.AddInParameter(command, "@OldSecondaryStatusText", DbType.String, oldStatusText);
                    database.AddInParameter(command, "@SecondaryStatusText", DbType.String, newStatusText);
                    database.AddInParameter(command, "@UserId", DbType.Int32, userId);
                    database.AddInParameter(command, "@LoggedInUserId", DbType.Int32, loggedInUserId);
                    database.AddInParameter(command, "@AddHrChatLog", DbType.Boolean, AddHrChatLog);

                    command.CommandType = CommandType.StoredProcedure;
                    DataSet dr= database.ExecuteDataSet(command);
                    if(dr!=null && dr.Tables[0]!=null && dr.Tables[0].Rows.Count > 0)
                    {
                        return dr.Tables[0].Rows[0]["LogNote"].ToString();
                    }
                    return null;
                }
            }
            catch (Exception ex)
            {
                return null;
            }
        }

        public List<PhoneCallLog> GetPhoneCallLog(int loggedInUserId, string callType, int index = 1, int pageSize = 5)
        {
            List<PhoneCallLog> logs = new List<PhoneCallLog>();
            try
            {
                SqlDatabase database = MSSQLDataBase.Instance.GetDefaultDatabase();
                {
                    returndata = new DataSet();
                    DbCommand command = database.GetStoredProcCommand("GetPhoneCallLog");
                    database.AddInParameter(command, "@PageIndex", DbType.Int32, index);
                    database.AddInParameter(command, "@PageSize", DbType.Int32, pageSize);
                    database.AddInParameter(command, "@CallType", DbType.String, callType);
                    database.AddInParameter(command, "@LoggedInUserId", DbType.Int32, loggedInUserId);

                    command.CommandType = CommandType.StoredProcedure;
                    returndata = database.ExecuteDataSet(command);
                    if (returndata != null && returndata.Tables[0] != null && returndata.Tables[0].Rows.Count > 0)
                    {
                        foreach (DataRow dr in returndata.Tables[0].Rows)
                        {
                            logs.Add(new PhoneCallLog
                            {
                                CallDurationInSeconds = Convert.ToDouble(dr["CallDurationInSeconds"]),
                                CallDurationFormatted = (TimeSpan.FromSeconds(Convert.ToInt32(dr["CallDurationInSeconds"]))).ToString(@"hh\:mm\:ss"),
                                CallerNumber = dr["CallerNumber"].ToString(),
                                CallStartTime = Convert.ToDateTime(dr["CallStartTime"]),
                                CallStartTimeFormatted = Convert.ToDateTime(dr["CallStartTime"]).ToString(),
                                CreatedBy = Convert.ToInt32(dr["CreatedBy"]),
                                CreatedOn = Convert.ToDateTime(dr["CreatedOn"]),
                                Id = Convert.ToInt32(dr["Id"]),
                                Mode = dr["Mode"].ToString(),
                                ReceiverUserId = string.IsNullOrEmpty(dr["ReceiverUserId"].ToString()) ? null : (int?)Convert.ToInt32(dr["ReceiverUserId"]),
                                ReceiverNumber = dr["ReceiverNumber"].ToString(),
                                ReceiverProfilePic = dr["ReceiverProfilePic"].ToString(),
                                ReceiverFullName = string.IsNullOrEmpty(dr["ReceiverUserId"].ToString()) ?
                                                        dr["ReceiverNumber"].ToString() : dr["FristName"].ToString() + " " + dr["LastName"].ToString(),
                                CallerFullName = dr["CallerFristName"].ToString() + " " + dr["CallerLastName"].ToString(),
                                CallerProfilePic = dr["CallerProfilePic"].ToString(),
                                CallerUserInstallId = dr["CallerUserInstallId"].ToString(),
                                ReceiverUserInstallId = dr["UserInstallId"].ToString()
                            });
                        }
                    }
                }
                return logs;
            }
            catch (Exception ex)
            {
                return logs;
            }
        }

        public void SavePhoneCallLog(PhoneCallLog phLog)
        {
            try
            {
                SqlDatabase database = MSSQLDataBase.Instance.GetDefaultDatabase();
                {
                    returndata = new DataSet();
                    DbCommand command = database.GetStoredProcCommand("SavePhoneCallLog");
                    database.AddInParameter(command, "@CallDurationInSeconds", DbType.Decimal, phLog.CallDurationInSeconds);
                    database.AddInParameter(command, "@CallerNumber", DbType.String, phLog.CallerNumber);
                    database.AddInParameter(command, "@Mode", DbType.String, phLog.Mode);
                    database.AddInParameter(command, "@CreatedBy", DbType.Int32, phLog.CreatedBy);
                    database.AddInParameter(command, "@ReceiverNumber", DbType.String, phLog.ReceiverNumber);
                    database.AddInParameter(command, "@ReceiverUserId", DbType.Int32, phLog.ReceiverUserId);
                    database.AddInParameter(command, "@NextReceiverUserId", DbType.Int32, phLog.NextReceiverUserId);

                    command.CommandType = CommandType.StoredProcedure;
                    returndata = database.ExecuteDataSet(command);

                }
            }
            catch (Exception ex)
            {

            }
        }

        public ActionOutput<LoginUser> GetUsers(string keyword, string exceptUserIds = null, int? LoggedInUserId = null)
        {
            try
            {
                List<LoginUser> users = new List<LoginUser>();
                SqlDatabase database = MSSQLDataBase.Instance.GetDefaultDatabase();
                {
                    returndata = new DataSet();
                    DbCommand command = database.GetStoredProcCommand("GetUsersByKeyword");
                    database.AddInParameter(command, "@Keyword", DbType.String, keyword);
                    database.AddInParameter(command, "@ExceptUserIds", DbType.String, exceptUserIds);
                    database.AddInParameter(command, "@LoggedInUserId", DbType.Int32, LoggedInUserId);

                    command.CommandType = CommandType.StoredProcedure;
                    returndata = database.ExecuteDataSet(command);

                    if (returndata != null && returndata.Tables[0] != null && returndata.Tables[0].Rows.Count > 0)
                    {
                        foreach (DataRow item in returndata.Tables[0].Rows)
                        {
                            users.Add(new LoginUser
                            {
                                ID = Convert.ToInt32(item["Id"].ToString()),
                                FirstName = item["FirstName"].ToString(),
                                LastName = item["LastName"].ToString(),
                                Email = item["Email"].ToString(),
                                Phone = item["Phone"].ToString(),
                                ProfilePic = item["Picture"].ToString()
                            });
                        }
                    }
                    return new ActionOutput<LoginUser>
                    {
                        Results = users,
                        Status = ActionStatus.Successfull
                    };
                }
            }
            catch (Exception ex)
            {
                return null;
            }
        }

        public DataSet GetUsersByIds(List<int> userIds = null)
        {
            try
            {
                List<LoginUser> users = new List<LoginUser>();
                SqlDatabase database = MSSQLDataBase.Instance.GetDefaultDatabase();
                {
                    returndata = new DataSet();
                    DbCommand command = database.GetStoredProcCommand("GetUsersByIds");
                    database.AddInParameter(command, "@UserIds", DbType.String, string.Join(",", userIds));

                    command.CommandType = CommandType.StoredProcedure;
                    return database.ExecuteDataSet(command);
                }
            }
            catch (Exception ex)
            {
                return null;
            }
        }

        public DataSet GetTouchPointLogDataByGUID(string strGUID)
        {
            try
            {
                SqlDatabase database = MSSQLDataBase.Instance.GetDefaultDatabase();
                {
                    returndata = new DataSet();
                    DbCommand command = database.GetStoredProcCommand("Sp_GetTouchPointLogDataByGUID");
                    database.AddInParameter(command, "@CurrentGID", DbType.String, strGUID);
                    command.CommandType = CommandType.StoredProcedure;
                    returndata = database.ExecuteDataSet(command);
                    return returndata;
                }
            }
            catch (Exception ex)
            {
                return null;
            }
        }

        public string AddUserEmail(bool isPrimaryEmail, string strEmail, int UserID, bool ClearDataBeforInsert)
        {
            try
            {
                SqlDatabase database = MSSQLDataBase.Instance.GetDefaultDatabase();
                {
                    DbCommand command = database.GetStoredProcCommand("Sp_InsertUpdateUserEmail");
                    command.CommandType = CommandType.StoredProcedure;
                    database.AddInParameter(command, "@isPrimaryEmail", DbType.Boolean, isPrimaryEmail);
                    database.AddInParameter(command, "@UserID", DbType.Int32, UserID);
                    database.AddInParameter(command, "@strEmail", DbType.String, strEmail);
                    database.AddInParameter(command, "@ClearDataBeforInsert", DbType.Boolean, ClearDataBeforInsert);

                    string lResult = database.ExecuteScalar(command).ToString();
                    return lResult;
                }
            }
            catch (Exception ex)
            {
                return ex.Message;
            }
        }

        public string AddUserPhone(bool isPrimaryPhone, string phoneText, int phoneType, int userID,
                                    string PhoneExtNo, string PhoneISDCode, bool ClearDataBeforInsert)
        {
            try
            {
                SqlDatabase database = MSSQLDataBase.Instance.GetDefaultDatabase();
                {
                    DbCommand command = database.GetStoredProcCommand("Sp_InsertUpdateUserPhone");
                    command.CommandType = CommandType.StoredProcedure;
                    database.AddInParameter(command, "@isPrimaryPhone", DbType.Boolean, isPrimaryPhone);
                    database.AddInParameter(command, "@phoneText", DbType.String, phoneText);
                    database.AddInParameter(command, "@phoneType", DbType.Int32, phoneType);
                    database.AddInParameter(command, "@UserID", DbType.Int32, userID);
                    database.AddInParameter(command, "@PhoneExtNo", DbType.String, PhoneExtNo);
                    database.AddInParameter(command, "@PhoneISDCode", DbType.String, PhoneISDCode);
                    database.AddInParameter(command, "@ClearPastRecord", DbType.Boolean, ClearDataBeforInsert);

                    string lResult = database.ExecuteScalar(command).ToString();
                    return lResult;
                }
            }
            catch (Exception ex)
            {
                return ex.Message;
            }
        }

        public DataSet GetUserEmailByUseId(int userId)
        {
            try
            {
                SqlDatabase database = MSSQLDataBase.Instance.GetDefaultDatabase();
                {
                    returndata = new DataSet();
                    DbCommand command = database.GetStoredProcCommand("SP_GetUserEmailByUserId");
                    database.AddInParameter(command, "@UserId", DbType.Int32, userId);
                    command.CommandType = CommandType.StoredProcedure;
                    returndata = database.ExecuteDataSet(command);
                    return returndata;
                }
            }
            catch (Exception ex)
            {
                return null;
            }
        }

        public DataSet GetUserPhoneByUseId(int userId)
        {
            try
            {
                SqlDatabase database = MSSQLDataBase.Instance.GetDefaultDatabase();
                {
                    returndata = new DataSet();
                    DbCommand command = database.GetStoredProcCommand("SP_GetUserPhoneUserId");
                    database.AddInParameter(command, "@UserId", DbType.Int32, userId);
                    command.CommandType = CommandType.StoredProcedure;
                    returndata = database.ExecuteDataSet(command);
                    return returndata;
                }
            }
            catch (Exception ex)
            {
                return null;
            }
        }

        public string GetUserGitUserName(int UserID)
        {
            try
            {
                SqlDatabase database = MSSQLDataBase.Instance.GetDefaultDatabase();
                {
                    String returndata = string.Empty;
                    DbCommand command = database.GetStoredProcCommand("UDP_GETUserGithubUsername");
                    command.CommandType = CommandType.StoredProcedure;
                    database.AddInParameter(command, "@id", DbType.String, UserID);
                    returndata = database.ExecuteScalar(command).ToString();

                    return returndata;
                }
            }

            catch (Exception ex)
            {
                return ex.Message;
                //LogManager.Instance.WriteToFlatFile(ex);
            }
        }

        public string GetUserDesignationCode(int UserID)
        {
            try
            {
                SqlDatabase database = MSSQLDataBase.Instance.GetDefaultDatabase();
                {
                    DataSet returndata = new DataSet();
                    DbCommand command = database.GetStoredProcCommand("UDP_GETInstallUserDesignationCode");
                    command.CommandType = CommandType.StoredProcedure;
                    database.AddInParameter(command, "@UserID", DbType.String, UserID);
                    returndata = database.ExecuteDataSet(command);
                    if (returndata != null && returndata.Tables[0] != null && returndata.Tables[0].Rows.Count > 0)
                    {
                        return returndata.Tables[0].Rows[0]["DesignationCode"].ToString();
                    }
                    return "";
                }
            }

            catch (Exception ex)
            {
                return ex.Message;
                //LogManager.Instance.WriteToFlatFile(ex);
            }
        }

        public string GetDesignationCode(int designationId)
        {
            try
            {
                SqlDatabase database = MSSQLDataBase.Instance.GetDefaultDatabase();
                {
                    String returndata = string.Empty;
                    DbCommand command = database.GetStoredProcCommand("GetDesignationById");
                    command.CommandType = CommandType.StoredProcedure;
                    database.AddInParameter(command, "@DesignationId", DbType.String, designationId);
                    returndata = database.ExecuteScalar(command).ToString();

                    return returndata;
                }
            }

            catch (Exception ex)
            {
                return ex.Message;
                //LogManager.Instance.WriteToFlatFile(ex);
            }
        }

        public string AddUserEmails(string ExtEmail, int userId)
        {
            try
            {
                SqlDatabase database = MSSQLDataBase.Instance.GetDefaultDatabase();
                {
                    DbCommand command = database.GetStoredProcCommand("SP_InsertUserEmail");
                    command.CommandType = CommandType.StoredProcedure;
                    database.AddInParameter(command, "@EmailID", DbType.String, ExtEmail);
                    database.AddInParameter(command, "@UserID", DbType.Int32, userId);

                    string lResult = database.ExecuteScalar(command).ToString();
                    return lResult;
                }
            }
            catch (Exception ex)
            {
                return ex.Message;
            }
        }

        public string AddNewEmailForUser(string EmailID, bool IsPrimary, int UserID)
        {
            try
            {
                SqlDatabase database = MSSQLDataBase.Instance.GetDefaultDatabase();
                {
                    DbCommand command = database.GetStoredProcCommand("SP_InsertUserEmailByUserID");
                    command.CommandType = CommandType.StoredProcedure;
                    database.AddInParameter(command, "@EmailID", DbType.String, EmailID);
                    database.AddInParameter(command, "@IsPrimary", DbType.Boolean, IsPrimary);
                    database.AddInParameter(command, "@UserID", DbType.Int32, UserID);

                    string lResult = database.ExecuteScalar(command).ToString();
                    return lResult;
                }
            }
            catch (Exception ex)
            {
                return ex.Message;
            }
        }

        public string AddNewPhoneType(string NewPhoneType, int AddedByID)
        {

            try
            {
                SqlDatabase database = MSSQLDataBase.Instance.GetDefaultDatabase();
                {
                    DbCommand command = database.GetStoredProcCommand("SP_AddNewPhoneType");
                    command.CommandType = CommandType.StoredProcedure;
                    database.AddInParameter(command, "@NewPhoneType", DbType.String, NewPhoneType);
                    database.AddInParameter(command, "@AddedByID", DbType.Int32, AddedByID);

                    string lResult = database.ExecuteScalar(command).ToString();
                    return lResult;
                }
            }
            catch (Exception ex)
            {
                return ex.Message;
            }
        }

        public DataSet GetAllUserPhoneType()
        {
            try
            {
                SqlDatabase database = MSSQLDataBase.Instance.GetDefaultDatabase();
                {
                    returndata = new DataSet();
                    DbCommand command = database.GetStoredProcCommand("SP_GetUserPhoneType");
                    command.CommandType = CommandType.StoredProcedure;
                    returndata = database.ExecuteDataSet(command);
                    return returndata;
                }
            }

            catch (Exception ex)
            {
                return null;

            }
        }

        public DataSet GetTechTaskByUser(int UserId)
        {
            DataSet dsTemp = new DataSet();
            try
            {
                SqlDatabase database = MSSQLDataBase.Instance.GetDefaultDatabase();
                {
                    DbCommand command = database.GetStoredProcCommand("sp_Get_TaskAssignByUserID");
                    command.CommandType = CommandType.StoredProcedure;
                    database.AddInParameter(command, "@UserId", DbType.Int32, UserId);

                    dsTemp = database.ExecuteDataSet(command);
                    return dsTemp;
                }
            }
            catch (Exception ex)
            {

            }
            return dsTemp;
        }

        public void UpdateProspect(user objuser)
        {
            try
            {
                SqlDatabase database = MSSQLDataBase.Instance.GetDefaultDatabase();
                {
                    DbCommand command = database.GetStoredProcCommand("USP_UpdateInstallUserFromProspect");
                    command.CommandType = CommandType.StoredProcedure;
                    database.AddInParameter(command, "@Id", DbType.Int32, objuser.id);
                    database.AddInParameter(command, "@FristName", DbType.String, objuser.fristname);
                    database.AddInParameter(command, "@LastName", DbType.String, objuser.lastname);
                    database.AddInParameter(command, "@Email", DbType.String, objuser.email);
                    database.AddInParameter(command, "@phone", DbType.String, objuser.phone);
                    database.AddInParameter(command, "@Attachements", DbType.String, objuser.attachements);
                    database.AddInParameter(command, "@PrimeryTradeId", DbType.Int32, objuser.PrimeryTradeId);
                    database.AddInParameter(command, "@SecondoryTradeId", DbType.Int32, objuser.SecondoryTradeId);
                    database.AddInParameter(command, "@Notes", DbType.String, objuser.Notes);
                    //database.AddInParameter(command, "@StatusReason", DbType.String, objuser.Reason);
                    database.AddInParameter(command, "@PTradeOthers", DbType.String, objuser.PTradeOthers);
                    database.AddInParameter(command, "@STradeOthers", DbType.String, objuser.STradeOthers);
                    database.AddInParameter(command, "@UserType", DbType.String, objuser.UserType);
                    database.AddInParameter(command, "@Email2", DbType.String, objuser.Email2);
                    database.AddInParameter(command, "@Phone2", DbType.String, objuser.Phone2);
                    database.AddInParameter(command, "@CompanyName", DbType.String, objuser.CompanyName);
                    database.AddInParameter(command, "@SourceUser", DbType.String, objuser.SourceUser);
                    database.AddInParameter(command, "@DateSourced", DbType.String, objuser.DateSourced);
                    database.ExecuteScalar(command);
                }
            }
            catch (Exception ex)
            {
            }
        }

        public DataSet ChangeDesignition(int EditId, int DesignitionID)
        {
            DataSet dsTemp = new DataSet();
            try
            {
                SqlDatabase database = MSSQLDataBase.Instance.GetDefaultDatabase();
                {
                    DbCommand command = database.GetStoredProcCommand("UDP_ChangeDesignition");
                    command.CommandType = CommandType.StoredProcedure;
                    database.AddInParameter(command, "@Id", DbType.Int32, EditId);
                    database.AddInParameter(command, "@DesignationID", DbType.String, DesignitionID);

                    dsTemp = database.ExecuteDataSet(command);
                    return dsTemp;
                }
            }
            catch (Exception ex)
            {
            }
            return dsTemp;
        }

        public DataSet ChangeSatatus(string Status, int StatusId, DateTime RejectionDate, string RejectionTime, int RejectedUserId, bool IsInstallUser, string StatusReason = "", string UserIds = "")
        {
            DataSet dsTemp = new DataSet();
            try
            {
                SqlDatabase database = MSSQLDataBase.Instance.GetDefaultDatabase();
                {
                    DbCommand command = database.GetStoredProcCommand("UDP_ChangeStatus");
                    command.CommandType = CommandType.StoredProcedure;
                    database.AddInParameter(command, "@Id", DbType.Int32, StatusId);
                    database.AddInParameter(command, "@Status", DbType.String, Status);
                    database.AddInParameter(command, "@RejectionDate", DbType.Date, RejectionDate);
                    database.AddInParameter(command, "@RejectionTime", DbType.String, RejectionTime);
                    database.AddInParameter(command, "@RejectedUserId", DbType.Int32, RejectedUserId);
                    database.AddInParameter(command, "@StatusReason", DbType.String, StatusReason);
                    database.AddInParameter(command, "@IsInstallUser", DbType.Boolean, IsInstallUser);
                    database.AddInParameter(command, "@InterviewDateStatus", DbType.String, Convert.ToByte(JGConstant.InstallUserStatus.InterviewDate).ToString());

                    if (!string.IsNullOrEmpty(UserIds))
                    {
                        database.AddInParameter(command, "@UserIds", DbType.String, UserIds);
                    }

                    dsTemp = database.ExecuteDataSet(command);
                    return dsTemp;
                }
            }
            catch (Exception ex)
            {
            }
            return dsTemp;
        }

        public DataSet ChangeUserSatatus(Int32 UserId, int StatusId, DateTime RejectionDate, string RejectionTime, int RejectedUserId, bool IsInstallUser, string StatusReason = "", string UserIds = "")
        {
            DataSet dsTemp = new DataSet();
            try
            {
                SqlDatabase database = MSSQLDataBase.Instance.GetDefaultDatabase();
                {
                    DbCommand command = database.GetStoredProcCommand("UDP_ChangeStatus");
                    command.CommandType = CommandType.StoredProcedure;
                    database.AddInParameter(command, "@Id", DbType.Int32, UserId);
                    database.AddInParameter(command, "@Status", DbType.String, StatusId.ToString());
                    database.AddInParameter(command, "@RejectionDate", DbType.Date, RejectionDate);
                    database.AddInParameter(command, "@RejectionTime", DbType.String, RejectionTime);
                    database.AddInParameter(command, "@RejectedUserId", DbType.Int32, RejectedUserId);
                    database.AddInParameter(command, "@StatusReason", DbType.String, StatusReason);
                    database.AddInParameter(command, "@IsInstallUser", DbType.Boolean, IsInstallUser);
                    database.AddInParameter(command, "@InterviewDateStatus", DbType.String, Convert.ToByte(JGConstant.InstallUserStatus.InterviewDate).ToString());

                    if (!string.IsNullOrEmpty(UserIds))
                    {
                        database.AddInParameter(command, "@UserIds", DbType.String, UserIds);
                    }

                    dsTemp = database.ExecuteDataSet(command);
                    return dsTemp;
                }
            }
            catch (Exception ex)
            {
            }
            return dsTemp;
        }


        public DataSet ChangeUserStatusToReject(int StatusId, DateTime RejectionDate, string RejectionTime, int RejectedUserId, Int64 UserId, string StatusReason = "")
        {
            DataSet dsTemp = new DataSet();
            try
            {
                SqlDatabase database = MSSQLDataBase.Instance.GetDefaultDatabase();
                {
                    DbCommand command = database.GetStoredProcCommand("[USP_ChangeUserStatusToReject]");
                    command.CommandType = CommandType.StoredProcedure;
                    database.AddInParameter(command, "@UserID", DbType.Int64, UserId);
                    database.AddInParameter(command, "@StatusId", DbType.Int32, StatusId);
                    database.AddInParameter(command, "@RejectionDate", DbType.Date, RejectionDate);
                    database.AddInParameter(command, "@RejectionTime", DbType.String, RejectionTime);
                    database.AddInParameter(command, "@RejectedUserId", DbType.Int32, RejectedUserId);
                    database.AddInParameter(command, "@StatusReason", DbType.String, StatusReason);

                    dsTemp = database.ExecuteDataSet(command);
                    return dsTemp;
                }
            }
            catch (Exception ex)
            {
            }
            return dsTemp;
        }

        public bool ChangeUserStatusToRejectByEmail(int StatusId, DateTime RejectionDate, string RejectionTime, int RejectedUserId, String UserEmail, string StatusReason = "")
        {
            //DataSet dsTemp = new DataSet();
            try
            {
                SqlDatabase database = MSSQLDataBase.Instance.GetDefaultDatabase();
                {
                    DbCommand command = database.GetStoredProcCommand("[USP_ChangeUserStatusToRejectByEmail]");
                    command.CommandType = CommandType.StoredProcedure;
                    database.AddInParameter(command, "@UserEmail", DbType.String, UserEmail);
                    database.AddInParameter(command, "@StatusId", DbType.Int32, StatusId);
                    database.AddInParameter(command, "@RejectionDate", DbType.Date, RejectionDate);
                    database.AddInParameter(command, "@RejectionTime", DbType.String, RejectionTime);
                    database.AddInParameter(command, "@RejectedUserId", DbType.Int32, RejectedUserId);
                    database.AddInParameter(command, "@StatusReason", DbType.String, StatusReason);

                    database.ExecuteNonQuery(command);
                    return true;
                }
            }
            catch (Exception ex)
            {
                return false;
            }

        }

        public bool ChangeUserStatusToRejectByMobile(int StatusId, DateTime RejectionDate, string RejectionTime, int RejectedUserId, String UserMobile, string StatusReason = "")
        {
            // DataSet dsTemp = new DataSet();
            try
            {
                SqlDatabase database = MSSQLDataBase.Instance.GetDefaultDatabase();
                {
                    DbCommand command = database.GetStoredProcCommand("[USP_ChangeUserStatusToRejectByMobile]");
                    command.CommandType = CommandType.StoredProcedure;
                    database.AddInParameter(command, "@UserMobile", DbType.String, UserMobile);
                    database.AddInParameter(command, "@StatusId", DbType.Int32, StatusId);
                    database.AddInParameter(command, "@RejectionDate", DbType.Date, RejectionDate);
                    database.AddInParameter(command, "@RejectionTime", DbType.String, RejectionTime);
                    database.AddInParameter(command, "@RejectedUserId", DbType.Int32, RejectedUserId);
                    database.AddInParameter(command, "@StatusReason", DbType.String, StatusReason);

                    database.ExecuteNonQuery(command);
                    return true;
                }
            }
            catch (Exception ex)
            {
                return false;
            }

        }

        public DataSet GetAllInterivewUserByPastDate()
        {
            DataSet dsTemp = new DataSet();
            try
            {
                SqlDatabase database = MSSQLDataBase.Instance.GetDefaultDatabase();
                {
                    DbCommand command = database.GetStoredProcCommand("SP_GetAllInterivewUser");
                    command.CommandType = CommandType.StoredProcedure;

                    dsTemp = database.ExecuteDataSet(command);
                    return dsTemp;
                }
            }
            catch (Exception ex)
            {
            }
            return dsTemp;
        }

        public DataSet ReSchedule_Interivew(int applicantId, string reSheduleDate, string reSheduleTime, int reSheduleByUserId)
        {
            DataSet dsTemp = new DataSet();
            try
            {
                SqlDatabase database = MSSQLDataBase.Instance.GetDefaultDatabase();
                {
                    DbCommand command = database.GetStoredProcCommand("Sp_ReSchedule_Interivew");
                    command.CommandType = CommandType.StoredProcedure;
                    database.AddInParameter(command, "@ApplicantId", DbType.Int32, applicantId);
                    database.AddInParameter(command, "@ReSheduleDate", DbType.String, reSheduleDate);
                    database.AddInParameter(command, "@ReSheduleTime", DbType.String, reSheduleTime);
                    database.AddInParameter(command, "@ReSheduleByUserId", DbType.Int32, reSheduleByUserId);

                    dsTemp = database.ExecuteDataSet(command);
                    return dsTemp;
                }
            }
            catch (Exception ex)
            {
            }
            return dsTemp;
        }

        public DataSet addSkillUser(string Name, string Type, string PerOwner, string Phone, string Email, string Address, string UserId)
        {
            DataSet dsTemp = new DataSet();
            try
            {
                SqlDatabase database = MSSQLDataBase.Instance.GetDefaultDatabase();
                {
                    DbCommand command = database.GetStoredProcCommand("UDP_AddSkillUser");
                    command.CommandType = CommandType.StoredProcedure;
                    database.AddInParameter(command, "@Name", DbType.String, Name);
                    database.AddInParameter(command, "@Title", DbType.String, Type);
                    database.AddInParameter(command, "@PerOwnership", DbType.String, PerOwner);
                    database.AddInParameter(command, "@Phone", DbType.String, Phone);
                    database.AddInParameter(command, "@EMail", DbType.String, Email);
                    database.AddInParameter(command, "@Address", DbType.String, Address);
                    database.AddInParameter(command, "@UserId", DbType.String, UserId);
                    dsTemp = database.ExecuteDataSet(command);
                    return dsTemp;
                }
            }
            catch (Exception ex)
            {

            }
            return dsTemp;
        }

        public DataSet GetSkillUser(string UserId, string Id)
        {
            DataSet dsTemp = new DataSet();
            try
            {
                SqlDatabase database = MSSQLDataBase.Instance.GetDefaultDatabase();
                {
                    DbCommand command = database.GetStoredProcCommand("USP_GetNewSkillUserById");
                    command.CommandType = CommandType.StoredProcedure;
                    database.AddInParameter(command, "@UserId", DbType.String, UserId);
                    database.AddInParameter(command, "@Id", DbType.String, Id);
                    dsTemp = database.ExecuteDataSet(command);
                    return dsTemp;
                }
            }
            catch (Exception ex)
            {

            }
            return dsTemp;
        }

        public string GetPassword(string UserName)
        {
            string password = "";
            try
            {
                SqlDatabase database = MSSQLDataBase.Instance.GetDefaultDatabase();
                {

                    returndata = new DataSet();
                    DbCommand command = database.GetStoredProcCommand("USP_GetPassword");
                    command.CommandType = CommandType.StoredProcedure;
                    database.AddInParameter(command, "@Login_Id", DbType.String, UserName);
                    returndata = database.ExecuteDataSet(command);
                    if (returndata.Tables[0].Rows.Count > 0)
                    {
                        password = Convert.ToString(returndata.Tables[0].Rows[0][0]);
                    }
                    else
                    {
                        password = "";
                    }
                    return password;
                }
            }
            catch (Exception ex)
            {
                return password;
            }
        }

        public string GetCustomerPassword(string UserName)
        {
            string password = "";
            try
            {
                SqlDatabase database = MSSQLDataBase.Instance.GetDefaultDatabase();
                {

                    returndata = new DataSet();
                    DbCommand command = database.GetStoredProcCommand("USP_GetCustomerPassword");
                    command.CommandType = CommandType.StoredProcedure;
                    database.AddInParameter(command, "@Login_Id", DbType.String, UserName);
                    returndata = database.ExecuteDataSet(command);
                    if (returndata.Tables[0].Rows.Count > 0)
                    {
                        password = Convert.ToString(returndata.Tables[0].Rows[0][0]);
                    }
                    else
                    {
                        password = "";
                    }
                    return password;
                }
            }
            catch (Exception ex)
            {
                return password;
            }
        }

        public string GetUserName(string PhoneNumber)
        {
            string LoginName = "";
            try
            {
                SqlDatabase database = MSSQLDataBase.Instance.GetDefaultDatabase();
                {

                    returndata = new DataSet();
                    DbCommand command = database.GetStoredProcCommand("USP_GetUserNameByPhoneNumber");
                    command.CommandType = CommandType.StoredProcedure;
                    database.AddInParameter(command, "@Phone", DbType.String, PhoneNumber);
                    returndata = database.ExecuteDataSet(command);
                    if (returndata.Tables[0].Rows.Count > 0)
                    {
                        LoginName = Convert.ToString(returndata.Tables[0].Rows[0][0]);
                    }
                    else
                    {
                        LoginName = "";
                    }
                    return LoginName;
                }
            }
            catch (Exception ex)
            {
                return LoginName;
            }
        }

        public string GetCustomerName(string PhoneNumber)
        {
            string LoginName = "";
            try
            {
                SqlDatabase database = MSSQLDataBase.Instance.GetDefaultDatabase();
                {

                    returndata = new DataSet();
                    DbCommand command = database.GetStoredProcCommand("USP_GetCustomerNameByPhoneNumber");
                    command.CommandType = CommandType.StoredProcedure;
                    database.AddInParameter(command, "@Phone", DbType.String, PhoneNumber);
                    returndata = database.ExecuteDataSet(command);
                    if (returndata.Tables[0].Rows.Count > 0)
                    {
                        LoginName = Convert.ToString(returndata.Tables[0].Rows[0][0]);
                    }
                    else
                    {
                        LoginName = "";
                    }
                    return LoginName;
                }
            }
            catch (Exception ex)
            {
                return LoginName;
            }
        }

        public bool AddCustomer(string UserName, string Password, string PhoneNo, string dob)
        {
            try
            {
                SqlDatabase database = MSSQLDataBase.Instance.GetDefaultDatabase();
                {
                    DateTime EstDate = DateTime.Now.AddDays(+7);
                    DbCommand command = database.GetStoredProcCommand("UDP_AddSignUpCustom");
                    command.CommandType = CommandType.StoredProcedure;
                    database.AddInParameter(command, "@CellPh", DbType.String, PhoneNo);
                    database.AddInParameter(command, "@Email", DbType.String, UserName);
                    database.AddInParameter(command, "@Password", DbType.String, Password);
                    database.AddInParameter(command, "@DateOfBirth", DbType.Date, Convert.ToDateTime(EstDate, JGConstant.CULTURE));
                    database.ExecuteScalar(command);
                    return true;
                }
            }
            catch (Exception ex)
            {
                return false;
            }
        }

        public bool AddUser(string UserName, string Password, string PhoneNo, string DOB)
        {
            try
            {
                SqlDatabase database = MSSQLDataBase.Instance.GetDefaultDatabase();
                {
                    DbCommand command = database.GetStoredProcCommand("USP_Registration");
                    command.CommandType = CommandType.StoredProcedure;
                    database.AddInParameter(command, "@Login_Id", DbType.String, UserName);
                    database.AddInParameter(command, "@Password", DbType.String, Password);
                    database.AddInParameter(command, "@Phone", DbType.String, PhoneNo);
                    database.AddInParameter(command, "@DOB", DbType.String, DOB);
                    database.ExecuteScalar(command);
                    return true;
                }
            }
            catch (Exception ex)
            {
                return false;
            }
        }

        public bool AddUserFB(string UserName)
        {
            try
            {
                SqlDatabase database = MSSQLDataBase.Instance.GetDefaultDatabase();
                {
                    DbCommand command = database.GetStoredProcCommand("USP_RegistrationFB");
                    command.CommandType = CommandType.StoredProcedure;
                    database.AddInParameter(command, "@Login_Id", DbType.String, UserName);
                    database.ExecuteScalar(command);
                    return true;
                }
            }
            catch (Exception ex)
            {
                return false;
            }
        }

        public DataSet CheckDuplicateInstaller(string UserName, string PhoneNo)
        {
            try
            {
                SqlDatabase database = MSSQLDataBase.Instance.GetDefaultDatabase();
                {
                    returndata = new DataSet();
                    DbCommand command = database.GetStoredProcCommand("USp_CheckDuplicate");
                    command.CommandType = CommandType.StoredProcedure;
                    database.AddInParameter(command, "@Email", DbType.String, UserName);
                    database.AddInParameter(command, "@Phone", DbType.String, PhoneNo);
                    returndata = database.ExecuteDataSet(command);
                    return returndata;
                }
            }
            catch (Exception ex)
            {
                return null;

            }
        }

        public DataSet CheckDuplicateInstallerOnEdit(string UserName, string PhoneNo, int Id)
        {
            try
            {
                SqlDatabase database = MSSQLDataBase.Instance.GetDefaultDatabase();
                {
                    returndata = new DataSet();
                    //  DbCommand command = database.GetStoredProcCommand("USp_CheckDuplicateOnEdit");
                    //Altetred by Neeta...
                    DbCommand command = database.GetStoredProcCommand("USp_CheckDuplicateOn Edit");
                    command.CommandType = CommandType.StoredProcedure;
                    database.AddInParameter(command, "@Id", DbType.Int32, Id);
                    database.AddInParameter(command, "@Email", DbType.String, UserName);
                    database.AddInParameter(command, "@Phone", DbType.String, PhoneNo);
                    returndata = database.ExecuteDataSet(command);
                    return returndata;
                }
            }
            catch (Exception ex)
            {
                return null;

            }
        }

        public DataSet CheckRegistration(string UserName, string PhoneNo)
        {
            try
            {
                SqlDatabase database = MSSQLDataBase.Instance.GetDefaultDatabase();
                {
                    returndata = new DataSet();
                    DbCommand command = database.GetStoredProcCommand("USP_CheckUserName");
                    command.CommandType = CommandType.StoredProcedure;
                    database.AddInParameter(command, "@Login_Id", DbType.String, UserName);
                    database.AddInParameter(command, "@Phone", DbType.String, PhoneNo);
                    returndata = database.ExecuteDataSet(command);
                    return returndata;
                }
            }

            catch (Exception ex)
            {
                return null;

            }
        }

        public DataSet CheckCustomerRegistration(string UserName, string PhoneNo)
        {
            try
            {
                SqlDatabase database = MSSQLDataBase.Instance.GetDefaultDatabase();
                {
                    returndata = new DataSet();
                    DbCommand command = database.GetStoredProcCommand("USP_CheckCustomerEmail");
                    command.CommandType = CommandType.StoredProcedure;
                    database.AddInParameter(command, "@Email", DbType.String, UserName);
                    database.AddInParameter(command, "@CellPh", DbType.String, PhoneNo);
                    returndata = database.ExecuteDataSet(command);
                    return returndata;
                }
            }

            catch (Exception ex)
            {
                return null;

            }
        }

        public DataSet GetProspectCount(int Id, string dt1, string dt2)
        {
            try
            {
                SqlDatabase database = MSSQLDataBase.Instance.GetDefaultDatabase();
                {
                    returndata = new DataSet();
                    DbCommand command = database.GetStoredProcCommand("UDP_GetAddedProspectCount");
                    command.CommandType = CommandType.StoredProcedure;
                    database.AddInParameter(command, "@Id", DbType.Int32, Id);
                    database.AddInParameter(command, "@DateSourced1", DbType.String, dt1);
                    database.AddInParameter(command, "@DateSourced2", DbType.String, dt2);
                    returndata = database.ExecuteDataSet(command);
                    return returndata;
                }
            }

            catch (Exception ex)
            {
                return null;

            }
        }

        public DataSet AddSource(string Source)
        {
            try
            {
                SqlDatabase database = MSSQLDataBase.Instance.GetDefaultDatabase();
                {
                    returndata = new DataSet();
                    DbCommand command = database.GetStoredProcCommand("UDP_AddSource");
                    command.CommandType = CommandType.StoredProcedure;
                    database.AddInParameter(command, "@Source", DbType.String, Source);
                    returndata = database.ExecuteDataSet(command);
                    return returndata;
                }
            }

            catch (Exception ex)
            {
                return null;

            }
        }

        public bool DeleteSource(string Source)
        {
            try
            {
                SqlDatabase database = MSSQLDataBase.Instance.GetDefaultDatabase();
                {
                    DbCommand command = database.GetStoredProcCommand("UDP_DeleteSource");
                    command.CommandType = CommandType.StoredProcedure;
                    database.AddInParameter(command, "@Source", DbType.String, Source);
                    database.ExecuteScalar(command);
                    return true;
                }
            }
            catch (Exception ex)
            {
                return false;
            }
        }

        public void DeleteImage(string Source)
        {
            try
            {
                SqlDatabase database = MSSQLDataBase.Instance.GetDefaultDatabase();
                {
                    DbCommand command = database.GetStoredProcCommand("UDP_DeleteImagePath");
                    command.CommandType = CommandType.StoredProcedure;
                    database.AddInParameter(command, "@Picture", DbType.String, Source);
                    database.ExecuteScalar(command);
                }
            }
            catch (Exception ex)
            {

            }

        }

        public void DeletePLLicense(string Source)
        {
            try
            {
                SqlDatabase database = MSSQLDataBase.Instance.GetDefaultDatabase();
                {
                    DbCommand command = database.GetStoredProcCommand("UDP_DeletePLLicense");
                    command.CommandType = CommandType.StoredProcedure;
                    database.AddInParameter(command, "@PCLiscense", DbType.String, Source);
                    database.ExecuteScalar(command);
                }
            }
            catch (Exception ex)
            {
            }
        }

        public void DeleteAssessment(string Source)
        {
            try
            {
                SqlDatabase database = MSSQLDataBase.Instance.GetDefaultDatabase();
                {
                    DbCommand command = database.GetStoredProcCommand("UDP_DeleteAssessment");
                    command.CommandType = CommandType.StoredProcedure;
                    database.AddInParameter(command, "@assessmentPath", DbType.String, Source);
                    database.ExecuteScalar(command);
                }
            }
            catch (Exception ex)
            {
            }
        }

        public void DeleteResume(string Source)
        {
            try
            {
                SqlDatabase database = MSSQLDataBase.Instance.GetDefaultDatabase();
                {
                    DbCommand command = database.GetStoredProcCommand("UDP_DeleteResume");
                    command.CommandType = CommandType.StoredProcedure;
                    database.AddInParameter(command, "@ResumePath", DbType.String, Source);
                    database.ExecuteScalar(command);
                }
            }
            catch (Exception ex)
            {
            }
        }

        public void UpdatePath(string NewPath, string OldPath)
        {
            try
            {
                SqlDatabase database = MSSQLDataBase.Instance.GetDefaultDatabase();
                {
                    DbCommand command = database.GetStoredProcCommand("UDP_UpdateDocPath");
                    command.CommandType = CommandType.StoredProcedure;
                    database.AddInParameter(command, "@ResumePathNew", DbType.String, NewPath);
                    database.AddInParameter(command, "@ResumePathOld", DbType.String, OldPath);
                    database.ExecuteScalar(command);
                }
            }
            catch (Exception ex)
            {
            }
        }

        public void DeleteCirtification(string Source)
        {
            try
            {
                SqlDatabase database = MSSQLDataBase.Instance.GetDefaultDatabase();
                {
                    DbCommand command = database.GetStoredProcCommand("UDP_DeleteCirtification");
                    command.CommandType = CommandType.StoredProcedure;
                    database.AddInParameter(command, "@CirtificationTraining", DbType.String, Source);
                    database.ExecuteScalar(command);
                }
            }
            catch (Exception ex)
            {
            }
        }

        public void DeleteWorkerComp(string Source)
        {
            try
            {
                SqlDatabase database = MSSQLDataBase.Instance.GetDefaultDatabase();
                {
                    DbCommand command = database.GetStoredProcCommand("UDP_DELETEWorkerComp");
                    command.CommandType = CommandType.StoredProcedure;
                    database.AddInParameter(command, "@WorkerComp", DbType.String, Source);
                    database.ExecuteScalar(command);
                }
            }
            catch (Exception ex)
            {
            }
        }

        public void DeleteLibilities(string Source)
        {
            try
            {
                SqlDatabase database = MSSQLDataBase.Instance.GetDefaultDatabase();
                {
                    DbCommand command = database.GetStoredProcCommand("UDP_DeleteGeneralLiability");
                    command.CommandType = CommandType.StoredProcedure;
                    database.AddInParameter(command, "@GeneralLiability", DbType.String, Source);
                    database.ExecuteScalar(command);
                }
            }
            catch (Exception ex)
            {
            }
        }

        public DataSet getSource()
        {
            try
            {
                SqlDatabase database = MSSQLDataBase.Instance.GetDefaultDatabase();
                {
                    returndata = new DataSet();
                    DbCommand command = database.GetStoredProcCommand("UDP_GetSource");
                    command.CommandType = CommandType.StoredProcedure;
                    returndata = database.ExecuteDataSet(command);
                    return returndata;
                }
            }

            catch (Exception ex)
            {
                return null;

            }
        }

        public List<UserSource> GetSourceList()
        {
            List<UserSource> list = new List<UserSource>();
            try
            {
                SqlDatabase database = MSSQLDataBase.Instance.GetDefaultDatabase();
                {
                    returndata = new DataSet();
                    DbCommand command = database.GetStoredProcCommand("UDP_GetSource");
                    command.CommandType = CommandType.StoredProcedure;
                    returndata = database.ExecuteDataSet(command);
                    if (returndata != null && returndata.Tables[0] != null)
                    {
                        foreach (DataRow item in returndata.Tables[0].Rows)
                        {
                            list.Add(new UserSource
                            {
                                Id = Convert.ToInt32(item["Id"].ToString()),
                                Source = item["Source"].ToString()
                            });
                        }
                    }
                }
            }
            catch (Exception ex)
            {
            }
            return list;
        }

        public DataSet CheckDuplicateSource(string Source)
        {
            try
            {
                SqlDatabase database = MSSQLDataBase.Instance.GetDefaultDatabase();
                {
                    returndata = new DataSet();
                    DbCommand command = database.GetStoredProcCommand("UDP_CheckDuplicateSource");
                    command.CommandType = CommandType.StoredProcedure;
                    database.AddInParameter(command, "@Source", DbType.String, Source);
                    returndata = database.ExecuteDataSet(command);
                    return returndata;
                }
            }

            catch (Exception ex)
            {
                return null;

            }
        }

        public DataSet getZip(string zip)
        {
            try
            {
                SqlDatabase database = MSSQLDataBase.Instance.GetDefaultDatabase();
                {
                    returndata = new DataSet();
                    DbCommand command = database.GetStoredProcCommand("UDP_getcitybyzip");
                    command.CommandType = CommandType.StoredProcedure;
                    database.AddInParameter(command, "@zipcode", DbType.String, zip);

                    returndata = database.ExecuteDataSet(command);

                    return returndata;
                }
            }

            catch (Exception ex)
            {
                return null;

            }

        }

        public bool UpdateConfirmInstallUser(user objuser)
        {
            try
            {
                SqlDatabase database = MSSQLDataBase.Instance.GetDefaultDatabase();
                {
                    DbCommand command = database.GetStoredProcCommand("usp_UpdateInstallUserConfirmDetails");
                    command.CommandType = CommandType.StoredProcedure;
                    database.AddInParameter(command, "@UserId", DbType.Int32, objuser.id);
                    database.AddInParameter(command, "@Address", DbType.String, objuser.MailingAddress);
                    database.AddInParameter(command, "@DOB", DbType.String, objuser.dob);
                    database.AddInParameter(command, "@maritalstatus", DbType.String, objuser.maritalstatus);
                    database.AddInParameter(command, "@Attachements", DbType.String, objuser.attachements);
                    database.AddInParameter(command, "@PCLiscense", DbType.String, objuser.PqLicense);
                    database.AddInParameter(command, "@Citizenship", DbType.String, objuser.citizenship);
                    database.AddInParameter(command, "@GithubUsername", DbType.String, objuser.GitUserName);
                    database.ExecuteScalar(command);

                    return true;
                }
            }

            catch (Exception ex)
            {
                return false;

            }
        }

        public bool UpdateInstallUser(user objuser, int id, int loggedInUserId)
        {
            try
            {
                SqlDatabase database = MSSQLDataBase.Instance.GetDefaultDatabase();
                {
                    DbCommand command = database.GetStoredProcCommand("UDP_UpdateInstallUsers");
                    command.CommandType = CommandType.StoredProcedure;
                    database.AddInParameter(command, "@id", DbType.String, Convert.ToInt32(id));
                    database.AddInParameter(command, "@FristName", DbType.String, objuser.fristname);
                    database.AddInParameter(command, "@LastName", DbType.String, objuser.lastname);
                    database.AddInParameter(command, "@Email", DbType.String, objuser.email);
                    database.AddInParameter(command, "@phone", DbType.String, objuser.phone);
                    database.AddInParameter(command, "@Address", DbType.String, objuser.address);
                    database.AddInParameter(command, "@Zip", DbType.String, objuser.zip);
                    database.AddInParameter(command, "@State", DbType.String, objuser.state);
                    database.AddInParameter(command, "@City", DbType.String, objuser.city);
                    database.AddInParameter(command, "@password", DbType.String, objuser.password);
                    database.AddInParameter(command, "@designation", DbType.String, objuser.designation);
                    database.AddInParameter(command, "@status", DbType.String, objuser.status);
                    database.AddInParameter(command, "@Picture", DbType.String, objuser.picture);
                    database.AddInParameter(command, "@attachement", DbType.String, objuser.attachements);
                    database.AddInParameter(command, "@bussinessname", DbType.String, objuser.businessname);
                    database.AddInParameter(command, "@ssn", DbType.String, objuser.ssn);
                    database.AddInParameter(command, "@ssn1", DbType.String, objuser.ssn1);
                    database.AddInParameter(command, "@ssn2", DbType.String, objuser.ssn2);
                    database.AddInParameter(command, "@signature", DbType.String, objuser.signature);
                    database.AddInParameter(command, "@dob", DbType.String, objuser.dob);
                    database.AddInParameter(command, "@citizenship", DbType.String, objuser.citizenship);
                    //database.AddInParameter(command, "@tin ", DbType.String, objuser.tin);
                    database.AddInParameter(command, "@ein1 ", DbType.String, objuser.ein1);
                    database.AddInParameter(command, "@ein2 ", DbType.String, objuser.ein2);
                    database.AddInParameter(command, "@a", DbType.String, objuser.a);
                    database.AddInParameter(command, "@b", DbType.String, objuser.b);
                    database.AddInParameter(command, "@c", DbType.String, objuser.c);
                    database.AddInParameter(command, "@d", DbType.String, objuser.d);
                    database.AddInParameter(command, "@e", DbType.String, objuser.e);
                    database.AddInParameter(command, "@f", DbType.String, objuser.f);
                    database.AddInParameter(command, "@g", DbType.String, objuser.g);
                    database.AddInParameter(command, "@h", DbType.String, objuser.h);
                    database.AddInParameter(command, "@i", DbType.String, objuser.i);
                    database.AddInParameter(command, "@j", DbType.String, objuser.j);
                    database.AddInParameter(command, "@k", DbType.String, objuser.k);
                    database.AddInParameter(command, "@maritalstatus", DbType.String, objuser.maritalstatus);
                    database.AddInParameter(command, "@PrimeryTradeId", DbType.Int32, objuser.PrimeryTradeId);
                    database.AddInParameter(command, "@SecondoryTradeId", DbType.Int32, objuser.SecondoryTradeId);
                    database.AddInParameter(command, "@Source", DbType.String, objuser.Source);
                    database.AddInParameter(command, "@Notes", DbType.String, objuser.Notes);
                    database.AddInParameter(command, "@StatusReason", DbType.String, objuser.Reason);
                    database.AddInParameter(command, "@GeneralLiability", DbType.String, objuser.GeneralLiability);
                    database.AddInParameter(command, "@PCLiscense", DbType.String, objuser.PqLicense);
                    database.AddInParameter(command, "@WorkerComp", DbType.String, objuser.WorkersComp);
                    database.AddInParameter(command, "@HireDate", DbType.String, objuser.HireDate);
                    database.AddInParameter(command, "@TerminitionDate", DbType.String, objuser.TerminitionDate);
                    database.AddInParameter(command, "@WorkersCompCode", DbType.String, objuser.WorkersCompCode);
                    database.AddInParameter(command, "@NextReviewDate", DbType.String, objuser.NextReviewDate);
                    database.AddInParameter(command, "@EmpType", DbType.String, objuser.EmpType);
                    database.AddInParameter(command, "@LastReviewDate", DbType.String, objuser.LastReviewDate);
                    database.AddInParameter(command, "@PayRates", DbType.String, objuser.PayRates);
                    database.AddInParameter(command, "@ExtraEarning", DbType.String, objuser.ExtraEarning);
                    database.AddInParameter(command, "@ExtraIncomeType", DbType.String, objuser.ExtraIncomeType);
                    database.AddInParameter(command, "@ExtraEarningAmt", DbType.String, objuser.ExtraEarningAmt);
                    database.AddInParameter(command, "@PayMethod", DbType.String, objuser.PayMethod);
                    database.AddInParameter(command, "@Deduction", DbType.String, objuser.Deduction);
                    database.AddInParameter(command, "@DeductionType", DbType.String, objuser.DeductionType);
                    database.AddInParameter(command, "@AbaAccountNo", DbType.String, objuser.AbaAccountNo);
                    database.AddInParameter(command, "@AccountNo", DbType.String, objuser.AccountNo);
                    database.AddInParameter(command, "@AccountType", DbType.String, objuser.AccountType);
                    database.AddInParameter(command, "@PTradeOthers", DbType.String, objuser.PTradeOthers);
                    database.AddInParameter(command, "@STradeOthers", DbType.String, objuser.STradeOthers);
                    database.AddInParameter(command, "@DeductionReason", DbType.String, objuser.DeductionReason);
                    database.AddInParameter(command, "@SuiteAptRoom", DbType.String, objuser.str_SuiteAptRoom);

                    database.AddInParameter(command, "@FullTimePosition", DbType.Int32, objuser.FullTimePosition);
                    database.AddInParameter(command, "@ContractorsBuilderOwner", DbType.String, objuser.ContractorsBuilderOwner);
                    database.AddInParameter(command, "@MajorTools", DbType.String, objuser.MajorTools);
                    database.AddInParameter(command, "@DrugTest", DbType.Boolean, objuser.DrugTest);
                    database.AddInParameter(command, "@ValidLicense", DbType.Boolean, objuser.ValidLicense);
                    database.AddInParameter(command, "@TruckTools", DbType.Boolean, objuser.TruckTools);
                    database.AddInParameter(command, "@PrevApply", DbType.Boolean, objuser.PrevApply);
                    database.AddInParameter(command, "@LicenseStatus", DbType.Boolean, objuser.LicenseStatus);
                    database.AddInParameter(command, "@CrimeStatus", DbType.Boolean, objuser.CrimeStatus);
                    database.AddInParameter(command, "@StartDate", DbType.String, objuser.StartDate);
                    database.AddInParameter(command, "@SalaryReq", DbType.String, objuser.SalaryReq);
                    database.AddInParameter(command, "@Avialability", DbType.String, objuser.Avialability);
                    database.AddInParameter(command, "@ResumePath", DbType.String, objuser.ResumePath);
                    database.AddInParameter(command, "@skillassessmentstatus", DbType.Boolean, objuser.skillassessmentstatus);
                    database.AddInParameter(command, "@assessmentPath", DbType.String, objuser.assessmentPath);
                    database.AddInParameter(command, "@WarrentyPolicy", DbType.String, objuser.WarrentyPolicy);
                    database.AddInParameter(command, "@CirtificationTraining", DbType.String, objuser.CirtificationTraining);
                    database.AddInParameter(command, "@businessYrs", DbType.Decimal, objuser.businessYrs);
                    database.AddInParameter(command, "@underPresentComp", DbType.Decimal, objuser.underPresentComp);
                    database.AddInParameter(command, "@websiteaddress", DbType.String, objuser.websiteaddress);
                    database.AddInParameter(command, "@PersonName", DbType.String, objuser.PersonName);
                    database.AddInParameter(command, "@PersonType", DbType.String, objuser.PersonType);
                    database.AddInParameter(command, "@CompanyPrinciple", DbType.String, objuser.CompanyPrinciple);
                    database.AddInParameter(command, "@UserType", DbType.String, objuser.UserType);
                    database.AddInParameter(command, "@Email2", DbType.String, objuser.Email2);
                    database.AddInParameter(command, "@Phone2", DbType.String, objuser.Phone2);
                    database.AddInParameter(command, "@CompanyName", DbType.String, objuser.CompanyName);
                    database.AddInParameter(command, "@SourceUser", DbType.String, objuser.SourceUser);
                    database.AddInParameter(command, "@DateSourced", DbType.String, objuser.DateSourced);
                    database.AddInParameter(command, "@InstallerType", DbType.String, objuser.InstallerType);

                    database.AddInParameter(command, "@BusinessType", DbType.String, objuser.BusinessType);
                    database.AddInParameter(command, "@CEO", DbType.String, objuser.CEO);
                    database.AddInParameter(command, "@LegalOfficer", DbType.String, objuser.LegalOfficer);
                    database.AddInParameter(command, "@President", DbType.String, objuser.President);
                    database.AddInParameter(command, "@Owner", DbType.String, objuser.Owner);
                    database.AddInParameter(command, "@AllParteners", DbType.String, objuser.AllParteners);
                    database.AddInParameter(command, "@MailingAddress", DbType.String, objuser.MailingAddress);
                    database.AddInParameter(command, "@Warrantyguarantee", DbType.Boolean, objuser.Warrantyguarantee);
                    database.AddInParameter(command, "@WarrantyYrs", DbType.Int32, objuser.WarrantyYrs);
                    database.AddInParameter(command, "@MinorityBussiness", DbType.Boolean, objuser.MinorityBussiness);
                    database.AddInParameter(command, "@WomensEnterprise", DbType.Boolean, objuser.WomensEnterprise);
                    database.AddInParameter(command, "@InterviewTime", DbType.String, objuser.InterviewTime);
                    database.AddInParameter(command, "@LIBC", DbType.String, objuser.UserActivated);
                    database.AddInParameter(command, "@Flag", DbType.Int32, objuser.Flag);

                    database.AddInParameter(command, "@CruntEmployement", DbType.Boolean, objuser.CruntEmployement);
                    database.AddInParameter(command, "@CurrentEmoPlace", DbType.String, objuser.CurrentEmoPlace);
                    database.AddInParameter(command, "@LeavingReason", DbType.String, objuser.LeavingReason);
                    database.AddInParameter(command, "@CompLit", DbType.Boolean, objuser.CompLit);
                    database.AddInParameter(command, "@FELONY", DbType.Boolean, objuser.FELONY);
                    database.AddInParameter(command, "@shortterm", DbType.String, objuser.shortterm);
                    database.AddInParameter(command, "@LongTerm", DbType.String, objuser.LongTerm);
                    database.AddInParameter(command, "@BestCandidate", DbType.String, objuser.BestCandidate);
                    database.AddInParameter(command, "@TalentVenue", DbType.String, objuser.TalentVenue);
                    database.AddInParameter(command, "@Boardsites", DbType.String, objuser.Boardsites);
                    database.AddInParameter(command, "@NonTraditional", DbType.String, objuser.NonTraditional);
                    database.AddInParameter(command, "@ConSalTraning", DbType.String, objuser.ConSalTraning);
                    database.AddInParameter(command, "@BestTradeOne", DbType.String, objuser.BestTradeOne);
                    database.AddInParameter(command, "@BestTradeTwo", DbType.String, objuser.BestTradeTwo);
                    database.AddInParameter(command, "@BestTradeThree", DbType.String, objuser.BestTradeThree);


                    database.AddInParameter(command, "@aOne", DbType.String, objuser.aOne);
                    database.AddInParameter(command, "@aOneTwo", DbType.String, objuser.aOneTwo);
                    database.AddInParameter(command, "@bOne", DbType.String, objuser.bOne);
                    database.AddInParameter(command, "@cOne", DbType.String, objuser.cOne);
                    database.AddInParameter(command, "@aTwo", DbType.String, objuser.aTwo);
                    database.AddInParameter(command, "@aTwoTwo", DbType.String, objuser.aTwoTwo);
                    database.AddInParameter(command, "@bTwo", DbType.String, objuser.bTwo);
                    database.AddInParameter(command, "@cTwo", DbType.String, objuser.cTwo);
                    database.AddInParameter(command, "@aThree", DbType.String, objuser.aThree);
                    database.AddInParameter(command, "@aThreeTwo", DbType.String, objuser.aThreeTwo);
                    database.AddInParameter(command, "@bThree", DbType.String, objuser.bThree);
                    database.AddInParameter(command, "@cThree", DbType.String, objuser.cThree);

                    database.AddInParameter(command, "@AddedBy", DbType.Int32, objuser.AddedBy);

                    database.AddInParameter(command, "@RejectionDate", DbType.String, objuser.RejectionDate);
                    database.AddInParameter(command, "@RejectionTime", DbType.String, objuser.RejectionTime);

                    database.AddInParameter(command, "@RejectedUserId", DbType.Int32, objuser.RejectedUserId);
                    database.AddInParameter(command, "@TC", DbType.Boolean, objuser.TC);

                    database.AddInParameter(command, "@PositionAppliedFor", DbType.String, objuser.PositionAppliedFor);
                    database.AddInParameter(command, "@DesignationID", DbType.Int32, objuser.DesignationID);
                    database.AddInParameter(command, "@PhoneISDCode", DbType.String, objuser.PhoneISDCode);
                    database.AddInParameter(command, "@PhoneExtNo", DbType.String, objuser.PhoneExtNo);
                    database.AddInParameter(command, "@CountryCode", DbType.String, objuser.CountryCode);

                    database.AddInParameter(command, "@NameMiddleInitial", DbType.String, objuser.NameMiddleInitial);
                    database.AddInParameter(command, "@IsEmailPrimaryEmail", DbType.Boolean, objuser.IsEmailPrimaryEmail);
                    database.AddInParameter(command, "@IsPhonePrimaryPhone", DbType.Boolean, objuser.IsPhonePrimaryPhone);
                    database.AddInParameter(command, "@IsEmailContactPreference", DbType.Boolean, objuser.IsEmailContactPreference);
                    database.AddInParameter(command, "@IsCallContactPreference", DbType.Boolean, objuser.IsCallContactPreference);
                    database.AddInParameter(command, "@IsTextContactPreference", DbType.Boolean, objuser.IsTextContactPreference);
                    database.AddInParameter(command, "@IsMailContactPreference", DbType.Boolean, objuser.IsMailContactPreference);
                    database.AddInParameter(command, "@SourceID", DbType.Int32, objuser.SourceId == 0 ? DBNull.Value : (object)objuser.SourceId);

                    database.AddOutParameter(command, "@result", DbType.Int32, 1);
                    database.AddOutParameter(command, "@loggedInUserId", DbType.Int32, loggedInUserId);
                    database.ExecuteScalar(command);
                    int res = Convert.ToInt32(database.GetParameterValue(command, "@result"));
                    if (res == 1)
                        return true;
                    else
                        return false;
                }
            }

            catch (Exception ex)
            {
                return false;

            }
        }

        public bool UpdateInstallUserStatus(string Status, int id, int loggedInUserId)
        {
            try
            {
                SqlDatabase database = MSSQLDataBase.Instance.GetDefaultDatabase();
                {
                    DbCommand command = database.GetStoredProcCommand("UDP_UpdateStatus");
                    command.CommandType = CommandType.StoredProcedure;
                    database.AddInParameter(command, "@id", DbType.String, Convert.ToInt32(id));
                    database.AddInParameter(command, "@status", DbType.String, Status);
                    database.AddOutParameter(command, "@result", DbType.Int32, 1);
                    database.AddOutParameter(command, "@loggedInUserId", DbType.Int32, loggedInUserId);
                    database.ExecuteScalar(command);
                    int res = Convert.ToInt32(database.GetParameterValue(command, "@result"));
                    if (res == 1)
                        return true;
                    else
                        return false;
                }
            }

            catch (Exception ex)
            {
                return false;

            }
        }

        public void ChangeStatus(string Status, int id, string RejectionDate, string RejectionTime, int RejectedUserId, string StatusReason = "")
        {
            try
            {
                SqlDatabase database = MSSQLDataBase.Instance.GetDefaultDatabase();
                {
                    DbCommand command = database.GetStoredProcCommand("USP_AddIntalledStatus");
                    command.CommandType = CommandType.StoredProcedure;
                    database.AddInParameter(command, "@id", DbType.String, Convert.ToInt32(id));
                    database.AddInParameter(command, "@status", DbType.String, Status);
                    database.AddInParameter(command, "@RejectionDate", DbType.String, RejectionDate);
                    database.AddInParameter(command, "@RejectionTime", DbType.String, RejectionTime);
                    database.AddInParameter(command, "@RejectedUserId", DbType.Int32, RejectedUserId);
                    database.AddInParameter(command, "@StatusReason", DbType.String, StatusReason);
                    database.ExecuteScalar(command);
                    //int res = Convert.ToInt32(database.GetParameterValue(command, "@result"));
                }
            }

            catch (Exception ex)
            {
            }
        }

        public void ChangeStatusToInterviewDate(string Status, int id, string RejectionDate, string RejectionTime, int RejectedUserId, string time, string StatusReason = "")
        {
            try
            {
                SqlDatabase database = MSSQLDataBase.Instance.GetDefaultDatabase();
                {
                    DbCommand command = database.GetStoredProcCommand("USP_UpdateToInterviewDateFromEdit");
                    command.CommandType = CommandType.StoredProcedure;
                    database.AddInParameter(command, "@id", DbType.String, Convert.ToInt32(id));
                    database.AddInParameter(command, "@status", DbType.String, Status);
                    database.AddInParameter(command, "@RejectionDate", DbType.String, RejectionDate);
                    database.AddInParameter(command, "@RejectionTime", DbType.String, RejectionTime);
                    database.AddInParameter(command, "@RejectedUserId", DbType.Int32, RejectedUserId);
                    database.AddInParameter(command, "@StatusReason", DbType.String, StatusReason);
                    database.AddInParameter(command, "@InterviewTime", DbType.Int32, time);
                    database.ExecuteScalar(command);
                    //int res = Convert.ToInt32(database.GetParameterValue(command, "@result"));
                }
            }

            catch (Exception ex)
            {
            }
        }

        public bool InsertIntoHRReport(int SourceId, int InstallerId, string Status)
        {
            try
            {
                SqlDatabase database = MSSQLDataBase.Instance.GetDefaultDatabase();
                {
                    DbCommand command = database.GetStoredProcCommand("Usp_UpdateInstallStatus");
                    command.CommandType = CommandType.StoredProcedure;
                    database.AddInParameter(command, "@SourceId", DbType.Int32, SourceId);
                    database.AddInParameter(command, "@InstallerId", DbType.Int32, InstallerId);
                    database.AddInParameter(command, "@Status", DbType.String, Status);
                    database.ExecuteScalar(command);
                    int res = Convert.ToInt32(database.GetParameterValue(command, "@result"));
                    if (res == 1)
                        return true;
                    else
                        return false;
                }
            }

            catch (Exception ex)
            {
                return false;

            }
        }

        public DataSet getallInstallusers()
        {
            try
            {
                SqlDatabase database = MSSQLDataBase.Instance.GetDefaultDatabase();
                {
                    returndata = new DataSet();
                    DbCommand command = database.GetStoredProcCommand("UDP_GetallInstallusersdataNew");
                    command.CommandType = CommandType.StoredProcedure;
                    returndata = database.ExecuteDataSet(command);

                    return returndata;
                }
            }

            catch (Exception ex)
            {
                return null;
            }
        }

        public DataSet GetAllEditSalesUser()
        {
            DataSet returndata = new DataSet();
            try
            {
                SqlDatabase database = MSSQLDataBase.Instance.GetDefaultDatabase();
                {

                    DbCommand command = database.GetStoredProcCommand("GetAllEditSalesUser");
                    command.CommandType = CommandType.StoredProcedure;
                    returndata = database.ExecuteDataSet(command);
                }
            }

            catch
            {
                throw;
            }

            return returndata;
        }

        public DataSet ExportAllInstallUsersData()
        {
            DataSet returndata = new DataSet();
            try
            {
                SqlDatabase database = MSSQLDataBase.Instance.GetDefaultDatabase();
                {

                    // DbCommand command = database.GetStoredProcCommand("[jgrov_User].[ExportAllInstallUsersData]");
                    DbCommand command = database.GetStoredProcCommand("ExportAllInstallUsersData");

                    command.CommandType = CommandType.StoredProcedure;
                    returndata = database.ExecuteDataSet(command);


                }
            }

            catch
            {
                throw;
            }
            return returndata;
        }

        public DataSet ExportAllSalesUsersData()
        {
            try
            {
                SqlDatabase database = MSSQLDataBase.Instance.GetDefaultDatabase();
                {
                    returndata = new DataSet();
                    DbCommand command = database.GetStoredProcCommand("[ExportAllSalesUsersData]");
                    command.CommandType = CommandType.StoredProcedure;
                    returndata = database.ExecuteDataSet(command);

                    return returndata;
                }
            }

            catch (Exception ex)
            {
                return null;
            }
        }

        public DataSet getTrade()
        {
            try
            {
                SqlDatabase database = MSSQLDataBase.Instance.GetDefaultDatabase();
                {
                    returndata = new DataSet();
                    DbCommand command = database.GetStoredProcCommand("UDP_GetTrade");
                    command.CommandType = CommandType.StoredProcedure;
                    returndata = database.ExecuteDataSet(command);

                    return returndata;
                }
            }

            catch (Exception ex)
            {
                return null;

            }
        }

        public DataSet getUserList()
        {
            try
            {
                SqlDatabase database = MSSQLDataBase.Instance.GetDefaultDatabase();
                {
                    returndata = new DataSet();
                    DbCommand command = database.GetStoredProcCommand("UDP_GetUserList");
                    command.CommandType = CommandType.StoredProcedure;
                    returndata = database.ExecuteDataSet(command);

                    return returndata;
                }
            }

            catch (Exception ex)
            {
                return null;

            }
        }

        public bool DeactivateInstallUsers(List<Int32> lstIDs)
        {
            try
            {
                DataTable dtIDs = new DataTable();
                dtIDs.Columns.Add(new DataColumn("ID", typeof(Int32)));

                foreach (var item in lstIDs)
                {
                    dtIDs.Rows.Add(item);
                }

                SqlDatabase database = MSSQLDataBase.Instance.GetDefaultDatabase();
                {
                    DbCommand command = database.GetStoredProcCommand("DeactivateInstallUsers");
                    command.CommandType = CommandType.StoredProcedure;
                    database.AddInParameter(command, "@IDs", SqlDbType.Structured, dtIDs);
                    database.AddInParameter(command, "@DeactiveStatus", DbType.String, Convert.ToByte(JGConstant.InstallUserStatus.Deactive).ToString());
                    database.ExecuteNonQuery(command);
                }
                return true;
            }
            catch (Exception ex)
            {
                return false;
            }
        }

        public bool DeleteInstallUsers(List<Int32> lstIDs)
        {
            try
            {
                DataTable dtIDs = new DataTable();
                dtIDs.Columns.Add(new DataColumn("ID", typeof(Int32)));

                foreach (var item in lstIDs)
                {
                    dtIDs.Rows.Add(item);
                }

                SqlDatabase database = MSSQLDataBase.Instance.GetDefaultDatabase();
                {
                    DbCommand command = database.GetStoredProcCommand("DeleteInstallUsers");
                    command.CommandType = CommandType.StoredProcedure;
                    database.AddInParameter(command, "@IDs", SqlDbType.Structured, dtIDs);
                    database.ExecuteNonQuery(command);
                }
                return true;
            }
            catch (Exception ex)
            {
                return false;
            }
        }
        public DataSet getuserdetailsbyId(int id)
        {
            try
            {
                SqlDatabase database = MSSQLDataBase.Instance.GetDefaultDatabase();
                {
                    returndata = new DataSet();
                    DbCommand command = database.GetStoredProcCommand("GetInstallUserById");
                    command.CommandType = CommandType.StoredProcedure;
                    database.AddInParameter(command, "@UserId", DbType.Int32, id);
                    returndata = database.ExecuteDataSet(command);

                    return returndata;
                }
            }

            catch (Exception ex)
            {
                return null;

            }
        }
        public DataSet getuserdetails(int id)
        {
            try
            {
                SqlDatabase database = MSSQLDataBase.Instance.GetDefaultDatabase();
                {
                    returndata = new DataSet();
                    DbCommand command = database.GetStoredProcCommand("UDP_GETInstallUserDetails");
                    command.CommandType = CommandType.StoredProcedure;
                    database.AddInParameter(command, "@id", DbType.Int32, id);
                    returndata = database.ExecuteDataSet(command);

                    return returndata;
                }
            }

            catch (Exception ex)
            {
                return null;

            }
        }

        public DataSet getalluserdetails()
        {
            try
            {
                SqlDatabase database = MSSQLDataBase.Instance.GetDefaultDatabase();
                {
                    returndata = new DataSet();
                    DbCommand command = database.GetStoredProcCommand("UDP_GETAllInstallUserDetails");
                    command.CommandType = CommandType.StoredProcedure;
                    returndata = database.ExecuteDataSet(command);
                    return returndata;
                }
            }

            catch (Exception ex)
            {
                return null;

            }
        }

        public DataTable getMaxId(string userType, string userStatus)
        {
            try
            {
                SqlDatabase database = MSSQLDataBase.Instance.GetDefaultDatabase();
                {
                    DataTable dtId = new DataTable();
                    DbCommand command = database.GetStoredProcCommand("UDP_GEtMaxId");
                    command.CommandType = CommandType.StoredProcedure;
                    database.AddInParameter(command, "@designation", DbType.String, userType);
                    database.AddInParameter(command, "@status", DbType.String, userStatus);
                    dtId = database.ExecuteDataSet(command).Tables[0];
                    return dtId;
                }
            }
            catch (Exception ex)
            {
                return null;
            }
        }

        public DataTable GetMaxSalesId(string Designition)
        {
            try
            {
                SqlDatabase database = MSSQLDataBase.Instance.GetDefaultDatabase();
                {
                    DataTable dtId = new DataTable();
                    DbCommand command = database.GetStoredProcCommand("UDP_GetSalesMaxId");
                    command.CommandType = CommandType.StoredProcedure;
                    database.AddInParameter(command, "@designation", DbType.String, Designition);
                    dtId = database.ExecuteDataSet(command).Tables[0];
                    return dtId;
                }
            }
            catch (Exception ex)
            {
                return null;
            }
        }

        public DataSet getInstallerUserDetailsByLoginId(string loginid, bool blIncludeRejected = false)
        {
            try
            {
                SqlDatabase database = MSSQLDataBase.Instance.GetDefaultDatabase();
                {
                    returndata = new DataSet();
                    DbCommand command = database.GetStoredProcCommand("UDP_GetInstallerUserDetailsByLoginId");
                    command.CommandType = CommandType.StoredProcedure;
                    database.AddInParameter(command, "@loginid", DbType.String, loginid);
                    database.AddInParameter(command, "@ActiveStatus", DbType.String, Convert.ToByte(JGConstant.InstallUserStatus.Active).ToString());
                    database.AddInParameter(command, "@ApplicantStatus", DbType.String, Convert.ToByte(JGConstant.InstallUserStatus.Applicant).ToString());
                    database.AddInParameter(command, "@InterviewDateStatus", DbType.String, Convert.ToByte(JGConstant.InstallUserStatus.InterviewDate).ToString());
                    database.AddInParameter(command, "@OfferMadeStatus", DbType.String, Convert.ToByte(JGConstant.InstallUserStatus.OfferMade).ToString());
                    if (blIncludeRejected)
                    {
                        database.AddInParameter(command, "@RejectedStatus", DbType.String, Convert.ToByte(JGConstant.InstallUserStatus.Rejected).ToString());
                    }
                    returndata = database.ExecuteDataSet(command);

                    return returndata;
                }
            }

            catch (Exception ex)
            {
                return null;

            }
        }

        public DataSet getInstallerUserDetailsByLoginId(string Email, string Password)
        {
            try
            {
                SqlDatabase database = MSSQLDataBase.Instance.GetDefaultDatabase();
                {
                    returndata = new DataSet();
                    DbCommand command = database.GetStoredProcCommand("UDP_GetCustomerDetailsByLoginId");
                    command.CommandType = CommandType.StoredProcedure;
                    database.AddInParameter(command, "@Email", DbType.String, Email);
                    database.AddInParameter(command, "@Password", DbType.String, Password);
                    returndata = database.ExecuteDataSet(command);

                    return returndata;
                }
            }

            catch (Exception ex)
            {
                return null;

            }
        }

        public DataSet getCustomerLogin(string Email, string Password)
        {
            try
            {
                SqlDatabase database = MSSQLDataBase.Instance.GetDefaultDatabase();
                {
                    returndata = new DataSet();
                    DbCommand command = database.GetStoredProcCommand("UDP_CUSTOMERLOGIN");
                    command.CommandType = CommandType.StoredProcedure;
                    database.AddInParameter(command, "@Email", DbType.String, Email);
                    database.AddInParameter(command, "@Password", DbType.String, Password);
                    returndata = database.ExecuteDataSet(command);

                    return returndata;
                }
            }

            catch (Exception ex)
            {
                return null;

            }
        }

        public void Activateuser(string loginid)
        {
            try
            {
                SqlDatabase database = MSSQLDataBase.Instance.GetDefaultDatabase();
                {
                    returndata = new DataSet();
                    DbCommand command = database.GetStoredProcCommand("USP_ActivateUser");
                    command.CommandType = CommandType.StoredProcedure;
                    database.AddInParameter(command, "@Login_Id", DbType.String, loginid);
                    returndata = database.ExecuteDataSet(command);
                }
            }
            catch (Exception ex)
            {
            }
        }

        public DataSet GetAttachment(int id)
        {

            try
            {
                SqlDatabase database = MSSQLDataBase.Instance.GetDefaultDatabase();
                {
                    returndata = new DataSet();
                    DbCommand command = database.GetStoredProcCommand("UDP_GetAttachments");
                    command.CommandType = CommandType.StoredProcedure;
                    database.AddInParameter(command, "@id", DbType.Int32, id);
                    returndata = database.ExecuteDataSet(command);

                    return returndata;
                }
            }

            catch (Exception ex)
            {
                return null;

            }
        }

        public int IsValidInstallerUser(string userid, string password)
        {
            try
            {
                SqlDatabase database = MSSQLDataBase.Instance.GetDefaultDatabase();
                {
                    DbCommand command = database.GetStoredProcCommand("UDP_IsValidInstallerUser");
                    command.CommandType = CommandType.StoredProcedure;
                    database.AddInParameter(command, "@userid", DbType.String, userid);
                    database.AddInParameter(command, "@password", DbType.String, password);
                    database.AddInParameter(command, "@ActiveStatus", DbType.String, Convert.ToByte(JGConstant.InstallUserStatus.Active).ToString());
                    database.AddInParameter(command, "@ApplicantStatus", DbType.String, Convert.ToByte(JGConstant.InstallUserStatus.Applicant).ToString());
                    database.AddInParameter(command, "@InterviewDateStatus", DbType.String, Convert.ToByte(JGConstant.InstallUserStatus.InterviewDate).ToString());
                    database.AddInParameter(command, "@OfferMadeStatus", DbType.String, Convert.ToByte(JGConstant.InstallUserStatus.OfferMade).ToString());
                    database.AddOutParameter(command, "@result", DbType.Int32, 1);
                    database.ExecuteScalar(command);
                    int res = Convert.ToInt32(database.GetParameterValue(command, "@result"));

                    return res;
                }
            }

            catch (Exception ex)
            {
                return 0;
                //LogManager.Instance.WriteToFlatFile(ex);
            }

        }

        public DataSet GetJobsForInstaller()
        {
            returndata = new DataSet();
            try
            {
                SqlDatabase database = MSSQLDataBase.Instance.GetDefaultDatabase();
                {
                    DbCommand command = database.GetStoredProcCommand("UDP_GetJobsForInstaller");
                    command.CommandType = CommandType.StoredProcedure;
                    returndata = database.ExecuteDataSet(command);
                    return returndata;
                }
            }

            catch (Exception ex)
            {
                //LogManager.Instance.WriteToFlatFile(ex);
            }
            return returndata;
        }

        public string GetAllCategoriesForReferenceId(string refId)
        {
            string result = string.Empty;
            try
            {
                SqlDatabase database = MSSQLDataBase.Instance.GetDefaultDatabase();
                {
                    DbCommand command = database.GetStoredProcCommand("UDP_GetAllCategoriesForSoldJobId");
                    command.CommandType = CommandType.StoredProcedure;
                    database.AddInParameter(command, "@refId", DbType.String, refId);
                    database.AddOutParameter(command, "@result", DbType.String, 500);
                    returndata = database.ExecuteDataSet(command);
                    result = returndata.Tables[0].Rows[0][0].ToString();
                    //result = Convert.ToString(database.GetParameterValue(command, "@result"));
                }
            }

            catch (Exception ex)
            {
                //LogManager.Instance.WriteToFlatFile(ex);
            }
            return result;
        }

        public string Update_ForgotPassword(string loginId, string newPassword, bool isCustomer)
        {
            string result = string.Empty;
            try
            {
                SqlDatabase database = MSSQLDataBase.Instance.GetDefaultDatabase();
                {
                    DbCommand command = database.GetStoredProcCommand("UDP_ForgotPasswordReset");
                    command.CommandType = CommandType.StoredProcedure;
                    database.AddInParameter(command, "@Login_Id", DbType.String, loginId);
                    database.AddInParameter(command, "@NewPassword", DbType.String, newPassword);
                    database.AddInParameter(command, "@IsCustomer", DbType.Byte, isCustomer);
                    database.AddOutParameter(command, "@result", DbType.String, 1);
                    database.ExecuteScalar(command);
                    result = database.GetParameterValue(command, "@result").ToString();
                }
            }
            catch (Exception ex)
            {
                //LogManager.Instance.WriteToFlatFile(ex);
            }
            return result;
        }

        public int InsertUserOTP(int userID, int userType, string OTP)
        {
            try
            {
                SqlDatabase database = MSSQLDataBase.Instance.GetDefaultDatabase();
                {
                    DbCommand command = database.GetStoredProcCommand("InsertUserOTP");
                    command.CommandType = CommandType.StoredProcedure;
                    database.AddInParameter(command, "@OTP", DbType.String, OTP);
                    database.AddInParameter(command, "@UserID", DbType.Int32, userID);
                    database.AddInParameter(command, "@UserType", DbType.Int32, userType);
                    database.AddOutParameter(command, "@result", DbType.Int32, 1);
                    database.ExecuteScalar(command);
                    int res = Convert.ToInt32(database.GetParameterValue(command, "@result"));

                    return res;
                }
            }

            catch (Exception ex)
            {
                return 0;
                //LogManager.Instance.WriteToFlatFile(ex);
            }

        }

        #endregion

        public DataSet GetInstallerAvailability(string referenceId, int installerId)
        {
            returndata = new DataSet();
            try
            {
                SqlDatabase database = MSSQLDataBase.Instance.GetDefaultDatabase();
                {
                    DbCommand command = database.GetStoredProcCommand("UDP_GetInstallerAvailability");
                    database.AddInParameter(command, "@referenceId", DbType.String, referenceId);
                    database.AddInParameter(command, "@installerId", DbType.Int16, installerId);
                    command.CommandType = CommandType.StoredProcedure;
                    returndata = database.ExecuteDataSet(command);
                    return returndata;
                }
            }

            catch (Exception ex)
            {
                //LogManager.Instance.WriteToFlatFile(ex);
            }
            return returndata;
        }

        public void AddEditInstallerAvailability(Availability a)
        {
            try
            {
                SqlDatabase database = MSSQLDataBase.Instance.GetDefaultDatabase();
                {
                    DbCommand command = database.GetStoredProcCommand("UDP_AddEditInstallerAvailability");
                    command.CommandType = CommandType.StoredProcedure;
                    database.AddInParameter(command, "@installerId", DbType.Int16, a.InstallerId);
                    database.AddInParameter(command, "@primary", DbType.String, a.Primary);
                    database.AddInParameter(command, "@secondary1", DbType.String, a.Secondary1);
                    database.AddInParameter(command, "@secondary2", DbType.String, a.Secondary2);
                    database.AddInParameter(command, "@referenceId", DbType.String, a.ReferenceId);
                    // database.AddInParameter(command, "@jobSequenceId", DbType.Int16, a.JobSequenceId);
                    database.ExecuteDataSet(command);
                }
            }

            catch (Exception ex)
            {
            }

        }

        public bool ChangeInstallerPassword(int loginid, string password)
        {
            try
            {
                SqlDatabase database = MSSQLDataBase.Instance.GetDefaultDatabase();
                {
                    DbCommand command = database.GetStoredProcCommand("UDP_ChangeInstallerPassword");
                    command.CommandType = CommandType.StoredProcedure;
                    database.AddInParameter(command, "@loginid", DbType.Int16, loginid);
                    database.AddInParameter(command, "@password", DbType.String, password);

                    database.AddOutParameter(command, "@result", DbType.Int32, 1);
                    database.ExecuteScalar(command);
                    int res = Convert.ToInt32(database.GetParameterValue(command, "@result"));
                    if (res == 1)
                        return true;
                    else
                        return false;
                }
            }

            catch (Exception ex)
            {
                return false;
            }

        }

        public DataTable getEmailTemplate(string status, string Part)
        {
            try
            {
                SqlDatabase database = MSSQLDataBase.Instance.GetDefaultDatabase();
                {
                    DataTable dtId = new DataTable();
                    DbCommand command = database.GetStoredProcCommand("usp_GetTemplate");
                    command.CommandType = CommandType.StoredProcedure;
                    database.AddInParameter(command, "@status", DbType.String, status);
                    database.AddInParameter(command, "@Part", DbType.String, Part);
                    dtId = database.ExecuteDataSet(command).Tables[0];
                    return dtId;
                }
            }
            catch (Exception ex)
            {
                return null;
            }
        }

        public DataSet GetSalesTouchPointLogData(int CustomerId, int userid)
        {
            returndata = new DataSet();
            try
            {
                SqlDatabase database = MSSQLDataBase.Instance.GetDefaultDatabase();
                {
                    DbCommand command = database.GetStoredProcCommand("UDP_FetchSalesUserTouchPointLogData");
                    command.CommandType = CommandType.StoredProcedure;
                    database.AddInParameter(command, "@customerId", DbType.Int32, CustomerId);
                    database.AddInParameter(command, "@userid", DbType.Int32, userid);
                    returndata = database.ExecuteDataSet(command);
                    return returndata;
                }
            }

            catch (Exception ex)
            {
                //LogManager.Instance.WriteToFlatFile(ex);
            }
            return returndata;
        }

        public DataSet GetInstallUsersForBulkEmail(Int32 DesignationId)
        {
            returndata = new DataSet();
            try
            {
                SqlDatabase database = MSSQLDataBase.Instance.GetDefaultDatabase();
                {
                    DbCommand command = database.GetStoredProcCommand("[GetInstallUsersForBulkEmail]");
                    command.CommandType = CommandType.StoredProcedure;
                    database.AddInParameter(command, "@DesignationId", DbType.Int32, DesignationId);
                    returndata = database.ExecuteDataSet(command);
                    return returndata;
                }
            }

            catch (Exception ex)
            {
                //LogManager.Instance.WriteToFlatFile(ex);
            }
            return returndata;
        }

        public void UpdateGithubUserName(int UserId, String GithubUsername)
        {
            try
            {
                SqlDatabase database = MSSQLDataBase.Instance.GetDefaultDatabase();
                {
                    DbCommand command = database.GetStoredProcCommand("UpdateGithubUsername");
                    command.CommandType = CommandType.StoredProcedure;
                    database.AddInParameter(command, "@GithubUsername", DbType.String, GithubUsername);
                    database.AddInParameter(command, "@UserId", DbType.Int32, UserId);
                    database.ExecuteNonQuery(command);
                }
            }

            catch (Exception ex)
            {
                //LogManager.Instance.WriteToFlatFile(ex);
            }
        }

        public int AddSalesFollowUp(int customerid, DateTime meetingdate, string Status, int userId)
        {
            int result = 0;
            try
            {
                SqlDatabase database = MSSQLDataBase.Instance.GetDefaultDatabase();
                {
                    DbCommand command = database.GetStoredProcCommand("UDP_AddEntryInSalesUser_followup");
                    command.CommandType = CommandType.StoredProcedure;
                    database.AddInParameter(command, "@custId", DbType.Int32, customerid);
                    database.AddInParameter(command, "@MeetingDate", DbType.DateTime, meetingdate);
                    database.AddInParameter(command, "@MeetingStatus", DbType.String, Status);
                    database.AddInParameter(command, "@UserId", DbType.Int32, userId);

                    database.ExecuteNonQuery(command);
                }
                return result;
            }
            catch (Exception ex)
            {
                //LogManager.Instance.WriteToFlatFile(ex);
                return 0;
            }
        }

        public bool UpdateOfferMade(int Id, string Email, string password, string branchLocationId)
        {
            StringBuilder strerr = new StringBuilder();

            try
            {
                SqlDatabase database = MSSQLDataBase.Instance.GetDefaultDatabase();
                {
                    DbCommand command = database.GetStoredProcCommand("UDP_UpdateInstallUserOfferMade");
                    command.CommandType = CommandType.StoredProcedure;
                    database.AddInParameter(command, "@Id", DbType.Int32, Id);
                    database.AddInParameter(command, "@Email", DbType.String, Email);
                    database.AddInParameter(command, "@password", DbType.String, password);
                    database.AddInParameter(command, "@branchLocationId", DbType.String, branchLocationId);
                    database.ExecuteNonQuery(command);
                    return true;
                }
            }
            catch (Exception ex)
            {
                return false;
            }
        }

        /// <summary>
        /// Load auto search suggestion as user types in search box for sales users.
        /// </summary>
        /// <param name="searchTerm"></param>
        /// <returns> categorised search suggestions for sales users</returns>
        public DataSet GetSalesUserAutoSuggestion(String searchTerm)
        {
            try
            {
                DataSet result = null;

                SqlDatabase database = MSSQLDataBase.Instance.GetDefaultDatabase();
                {
                    DbCommand command = database.GetStoredProcCommand("GetSalesUserAutoSuggestion");
                    command.CommandType = CommandType.StoredProcedure;
                    database.AddInParameter(command, "@SearchTerm", DbType.String, searchTerm);
                    result = database.ExecuteDataSet(command);
                }

                return result;
            }
            catch (Exception ex)
            {
                return null;
            }
        }

        //------------ start DP ------------
        public DataSet GetTaskUsers(String searchTerm)
        {
            try
            {
                DataSet result = null;

                SqlDatabase database = MSSQLDataBase.Instance.GetDefaultDatabase();
                {
                    DbCommand command = database.GetStoredProcCommand("GetTaskUsers");
                    command.CommandType = CommandType.StoredProcedure;
                    database.AddInParameter(command, "@SearchTerm", DbType.String, searchTerm);
                    result = database.ExecuteDataSet(command);
                }

                return result;
            }
            catch (Exception ex)
            {
                return null;
            }
        }

        public DataSet GetEmployeeInterviewDetails(int UserID)
        {
            try
            {
                DataSet result = null;

                SqlDatabase database = MSSQLDataBase.Instance.GetDefaultDatabase();
                {
                    DbCommand command = database.GetStoredProcCommand("usp_GetEmployeeInterviewDetails");
                    command.CommandType = CommandType.StoredProcedure;
                    database.AddInParameter(command, "@UserId", DbType.Int32, UserID);
                    result = database.ExecuteDataSet(command);
                }

                return result;
            }
            catch (Exception ex)
            {
                return null;
            }
        }

        public DataSet GetTaskUsersForDashBoard(String searchTerm)
        {
            try
            {
                DataSet result = null;

                SqlDatabase database = MSSQLDataBase.Instance.GetDefaultDatabase();
                {
                    DbCommand command = database.GetStoredProcCommand("GetTaskUsersForDashboard");
                    command.CommandType = CommandType.StoredProcedure;
                    database.AddInParameter(command, "@SearchTerm", DbType.String, searchTerm);
                    result = database.ExecuteDataSet(command);
                }

                return result;
            }
            catch (Exception ex)
            {
                return null;
            }
        }

        public string GetStarBookMarkUsers(int bookmarkingUser, int bookmarkedUser, int isdelete)
        {
            try
            {
                SqlDatabase database = MSSQLDataBase.Instance.GetDefaultDatabase();
                {
                    DbCommand command = database.GetStoredProcCommand("GetStarBookMarkUsers");
                    command.CommandType = CommandType.StoredProcedure;
                    database.AddInParameter(command, "@bookmarkedUser", DbType.String, bookmarkedUser);
                    database.AddInParameter(command, "@bookmarkingUser", DbType.String, bookmarkingUser);
                    database.AddInParameter(command, "@isdelete", DbType.String, isdelete);
                    database.ExecuteDataSet(command);
                }

                return "true";
            }
            catch (Exception ex)
            {
                return "false";
            }
        }
        public DataSet GetBookMarkingUserDetails(int bookmarkedUser)
        {
            DataSet result = null;
            try
            {
                SqlDatabase database = MSSQLDataBase.Instance.GetDefaultDatabase();
                {
                    DbCommand command = database.GetStoredProcCommand("GetBookMarkingUserDetails");
                    command.CommandType = CommandType.StoredProcedure;
                    database.AddInParameter(command, "@Id", DbType.Int32, bookmarkedUser);
                    result = database.ExecuteDataSet(command);
                }

                return result;
            }
            catch (Exception ex)
            {
                return null;
            }
        }


        //------------- end DP -------------

        public DataSet GetSalesUsersStaticticsAndData(string strSearchTerm, string strStatus, string strDesignationId, string strSourceId, DateTime? fromdate, DateTime? todate, string struserid, int intPageIndex, int intPageSize, string strSortExpression)
        {
            DataSet dsResult = null;
            try
            {
                SqlDatabase database = MSSQLDataBase.Instance.GetDefaultDatabase();
                {
                    DbCommand command = database.GetStoredProcCommand("sp_GetHrData");
                    command.CommandType = CommandType.StoredProcedure;
                    if (!string.IsNullOrEmpty(strSearchTerm))
                    {
                        database.AddInParameter(command, "@SearchTerm", DbType.String, strSearchTerm);
                    }
                    database.AddInParameter(command, "@Status", DbType.String, String.IsNullOrEmpty(strStatus.Trim()) == true ? null : strStatus);
                    database.AddInParameter(command, "@DesignationId", DbType.String, String.IsNullOrEmpty(strDesignationId.Trim()) == true ? null : strDesignationId);
                    database.AddInParameter(command, "@SourceId", DbType.String, String.IsNullOrEmpty(strSourceId.Trim()) == true ? null : strSourceId);
                    database.AddInParameter(command, "@AddedByUserId", DbType.String, String.IsNullOrEmpty(struserid.Trim()) == true ? null : struserid);
                    if (fromdate != null)
                    {
                        database.AddInParameter(command, "@FromDate", DbType.Date, fromdate);
                    }
                    else
                    {
                        database.AddInParameter(command, "@FromDate", DbType.Date, DBNull.Value);
                    }
                    if (todate != null)
                    {
                        database.AddInParameter(command, "@ToDate", DbType.Date, todate);
                    }
                    else
                    {
                        database.AddInParameter(command, "@ToDate", DbType.Date, DBNull.Value);
                    }

                    database.AddInParameter(command, "@PageIndex", DbType.Int16, intPageIndex);
                    database.AddInParameter(command, "@PageSize", DbType.Int16, intPageSize);
                    database.AddInParameter(command, "@SortExpression", DbType.String, strSortExpression);

                    database.AddInParameter(command, "@InterviewDateStatus", DbType.String, Convert.ToByte(JGConstant.InstallUserStatus.InterviewDate).ToString());
                    database.AddInParameter(command, "@RejectedStatus", DbType.String, Convert.ToByte(JGConstant.InstallUserStatus.Rejected).ToString());

                    database.AddInParameter(command, "@OfferMadeStatus", DbType.String, Convert.ToByte(JGConstant.InstallUserStatus.OfferMade).ToString());
                    database.AddInParameter(command, "@ActiveStatus", DbType.String, Convert.ToByte(JGConstant.InstallUserStatus.Active).ToString());

                    dsResult = database.ExecuteDataSet(command);
                }
                return dsResult;
            }
            catch (Exception ex)
            {
                return dsResult;
            }
        }

        public DataSet GetHrData(DateTime? fromdate, DateTime? todate, int userid)
        {
            returndata = new DataSet();
            try
            {
                SqlDatabase database = MSSQLDataBase.Instance.GetDefaultDatabase();
                {
                    DbCommand command = database.GetStoredProcCommand("sp_GetHrData");
                    command.CommandType = CommandType.StoredProcedure;
                    database.AddInParameter(command, "@UserId", DbType.Int16, userid);
                    if (fromdate != null)
                    {
                        database.AddInParameter(command, "@FromDate", DbType.Date, fromdate);
                    }
                    else
                    {
                        database.AddInParameter(command, "@FromDate", DbType.Date, DBNull.Value);
                    }
                    if (todate != null)
                    {
                        database.AddInParameter(command, "@ToDate", DbType.Date, todate);
                    }
                    else
                    {
                        database.AddInParameter(command, "@ToDate", DbType.Date, DBNull.Value);
                    }
                    returndata = database.ExecuteDataSet(command);
                    return returndata;
                }
            }
            catch (Exception ex)
            {

            }
            return returndata;
        }

        public DataSet GetHrDataForHrReports(DateTime fromdate, DateTime todate, int userid)
        {
            returndata = new DataSet();
            try
            {
                SqlDatabase database = MSSQLDataBase.Instance.GetDefaultDatabase();
                {
                    DbCommand command = database.GetStoredProcCommand("sp_HrDataForHrReports");
                    command.CommandType = CommandType.StoredProcedure;
                    database.AddInParameter(command, "@UserId", DbType.Int16, userid);
                    database.AddInParameter(command, "@FromDate", DbType.Date, fromdate);
                    database.AddInParameter(command, "@ToDate", DbType.Date, todate);
                    returndata = database.ExecuteDataSet(command);
                    return returndata;
                }
            }
            catch (Exception ex)
            {

            }
            return returndata;
        }

        public DataSet FilteHrData(DateTime fromDate, DateTime toDate, string designation, string status)
        {
            returndata = new DataSet();
            try
            {
                SqlDatabase database = MSSQLDataBase.Instance.GetDefaultDatabase();
                {
                    DbCommand command = database.GetStoredProcCommand("sp_FilterHrData");
                    command.CommandType = CommandType.StoredProcedure;
                    database.AddInParameter(command, "@status", DbType.String, status);
                    database.AddInParameter(command, "@designation", DbType.String, designation);
                    if (fromDate == DateTime.MinValue)
                    {
                        database.AddInParameter(command, "@fromdate", DbType.Date, DBNull.Value);
                    }
                    else
                    {
                        database.AddInParameter(command, "@fromdate", DbType.Date, fromDate);
                    }
                    database.AddInParameter(command, "@todate", DbType.Date, toDate);
                    returndata = database.ExecuteDataSet(command);
                    return returndata;
                }
            }
            catch (Exception ex)
            {

            }
            return returndata;
        }

        public DataSet GetActiveUsers()
        {
            returndata = new DataSet();
            try
            {
                SqlDatabase database = MSSQLDataBase.Instance.GetDefaultDatabase();
                {
                    DbCommand command = database.GetStoredProcCommand("sp_GetActiveUserContractor");
                    command.CommandType = CommandType.StoredProcedure;
                    database.AddInParameter(command, "@action", DbType.String, "1");
                    database.AddInParameter(command, "@ActiveStatus", DbType.String, Convert.ToByte(JGConstant.InstallUserStatus.Active).ToString());
                    returndata = database.ExecuteDataSet(command);
                    return returndata;
                }
            }
            catch (Exception ex)
            {

            }
            return returndata;
        }

        public DataSet GetActiveContractors()
        {
            returndata = new DataSet();
            try
            {
                SqlDatabase database = MSSQLDataBase.Instance.GetDefaultDatabase();
                {
                    DbCommand command = database.GetStoredProcCommand("sp_GetActiveUserContractor");
                    command.CommandType = CommandType.StoredProcedure;
                    database.AddInParameter(command, "@action", DbType.String, "2");
                    database.AddInParameter(command, "@ActiveStatus", DbType.String, Convert.ToByte(JGConstant.InstallUserStatus.Active).ToString());
                    returndata = database.ExecuteDataSet(command);
                    return returndata;
                }
            }
            catch (Exception ex)
            {

            }
            return returndata;
        }


        public void SetUserDisplayID(int UserId, string strUserDesignationId, string UpdateCurrentSequence)
        {
            try
            {
                SqlDatabase database = MSSQLDataBase.Instance.GetDefaultDatabase();
                {
                    DbCommand command = database.GetStoredProcCommand("USP_SetUserDisplayID");
                    command.CommandType = CommandType.StoredProcedure;
                    database.AddInParameter(command, "@InstallUserID", DbType.String, UserId);
                    database.AddInParameter(command, "@DesignationId", DbType.String, strUserDesignationId);
                    database.AddInParameter(command, "@UpdateCurrentSequence", DbType.String, UpdateCurrentSequence);
                    database.ExecuteNonQuery(command);
                }
            }
            catch (Exception ex)
            {

            }
        }

        /// <summary>
        /// Get all Users and their designtions in system 
        /// <returns></returns>
        public DataSet GetUsersNDesignationForSalesFilter()
        {
            returndata = new DataSet();
            try
            {
                SqlDatabase database = MSSQLDataBase.Instance.GetDefaultDatabase();
                {
                    DbCommand command = database.GetStoredProcCommand("usp_GetUsersNDesignationForSalesFilter");

                    command.CommandType = CommandType.StoredProcedure;
                    returndata = database.ExecuteDataSet(command);
                    return returndata;
                }
            }

            catch (Exception ex)
            {
                //LogManager.Instance.WriteToFlatFile(ex);
            }
            return returndata;
        }

        /// <summary>
        /// Get all Users for AddedBy filter, with html tags
        /// <returns>DataSet</returns>
        public DataSet GeAddedBytUsers()
        {
            returndata = new DataSet();
            try
            {
                SqlDatabase database = MSSQLDataBase.Instance.GetDefaultDatabase();
                {
                    DbCommand command = database.GetStoredProcCommand("usp_GeAddedBytUsersFilter");

                    command.CommandType = CommandType.StoredProcedure;
                    returndata = database.ExecuteDataSet(command);
                    return returndata;
                }
            }

            catch (Exception ex)
            {
                //LogManager.Instance.WriteToFlatFile(ex);
            }
            return returndata;
        }

        public List<UserAddedBy> GeAddedBytUsersFormatted()
        {
            List<UserAddedBy> list = new List<UserAddedBy>();
            returndata = new DataSet();
            try
            {
                SqlDatabase database = MSSQLDataBase.Instance.GetDefaultDatabase();
                {
                    DbCommand command = database.GetStoredProcCommand("usp_GeAddedBytUsersFilter");

                    command.CommandType = CommandType.StoredProcedure;
                    returndata = database.ExecuteDataSet(command);
                    if (returndata != null && returndata.Tables[0] != null)
                    {
                        foreach (DataRow item in returndata.Tables[0].Rows)
                        {
                            list.Add(new UserAddedBy
                            {
                                UserId = Convert.ToInt32(item["Id"].ToString()),
                                FormattedName = item["FirstName"].ToString()
                            });
                        }
                    }
                }
            }
            catch (Exception ex)
            {

                //LogManager.Instance.WriteToFlatFile(ex);
            }
            return list;
        }

        public void UpdateEmpType(int ID, string EmpType)
        {
            try
            {
                SqlDatabase database = MSSQLDataBase.Instance.GetDefaultDatabase();
                {
                    DbCommand command = database.GetStoredProcCommand("UpdateEmpType");
                    command.CommandType = CommandType.StoredProcedure;
                    database.AddInParameter(command, "@ID", DbType.Int32, ID);
                    database.AddInParameter(command, "@EmpType", DbType.String, EmpType);
                    database.ExecuteScalar(command);
                }

            }
            catch (Exception ex)
            {
            }
        }

        public DataSet GetPopupEditUsers(String UserIds, String Status, int DesignationId, int PageIndex, int PageSize, String SortExpression)
        {
            returndata = new DataSet();
            try
            {
                SqlDatabase database = MSSQLDataBase.Instance.GetDefaultDatabase();
                {
                    DbCommand command = database.GetStoredProcCommand("usp_SearchUsersForPopup");

                    command.CommandType = CommandType.StoredProcedure;

                    database.AddInParameter(command, "@UserIds", DbType.String, UserIds);
                    database.AddInParameter(command, "@Status", DbType.String, Status);
                    database.AddInParameter(command, "@DesignationId", DbType.Int32, DesignationId);
                    database.AddInParameter(command, "@PageIndex", DbType.Int32, PageIndex);
                    database.AddInParameter(command, "@PageSize", DbType.Int32, PageSize);
                    database.AddInParameter(command, "@SortExpression", DbType.String, SortExpression);

                    returndata = database.ExecuteDataSet(command);

                    return returndata;
                }
            }

            catch (Exception ex)
            {
                //LogManager.Instance.WriteToFlatFile(ex);
            }
            return returndata;
        }

        public int UpdateUsersLastLoginTime(int loginUserID, DateTime LogInTime)
        {
            try
            {
                SqlDatabase database = MSSQLDataBase.Instance.GetDefaultDatabase();
                {
                    DbCommand command = database.GetStoredProcCommand("usp_UpdateUserLoginTimeStamp");
                    command.CommandType = CommandType.StoredProcedure;
                    database.AddInParameter(command, "@Id", DbType.Int32, loginUserID);
                    database.AddInParameter(command, "@LastLoginTimeStamp", DbType.DateTime, LogInTime);
                    int retrunVal = database.ExecuteNonQuery(command);
                    return retrunVal;
                }
            }
            catch (Exception ex)
            {
                return 0;
            }
        }

        public Int32 QuickSaveInstallUser(user objuser)
        {
            try
            {
                SqlDatabase database = MSSQLDataBase.Instance.GetDefaultDatabase();
                {
                    DbCommand command = database.GetStoredProcCommand("usp_QuickSaveInstallUser");
                    command.CommandType = CommandType.StoredProcedure;

                    database.AddInParameter(command, "@FirstName", DbType.String, objuser.fristname);
                    database.AddInParameter(command, "@NameMiddleInitial", DbType.String, objuser.NameMiddleInitial);
                    database.AddInParameter(command, "@LastName", DbType.String, objuser.lastname);
                    database.AddInParameter(command, "@Email", DbType.String, objuser.email);
                    database.AddInParameter(command, "@Phone", DbType.String, objuser.phone);
                    database.AddInParameter(command, "@Zip", DbType.String, objuser.zip);
                    database.AddInParameter(command, "@DesignationText", DbType.String, objuser.designation);
                    database.AddInParameter(command, "@DesignationID", DbType.String, objuser.DesignationID);
                    database.AddInParameter(command, "@Status", DbType.String, objuser.status);
                    database.AddInParameter(command, "@SourceText", DbType.String, objuser.Source);
                    database.AddInParameter(command, "@EmpType", DbType.String, objuser.EmpType);
                    database.AddInParameter(command, "@StartDate", DbType.String, objuser.StartDate);
                    database.AddInParameter(command, "@SalaryReq", DbType.String, objuser.SalaryReq);
                    database.AddInParameter(command, "@SourceUserId", DbType.String, objuser.SourceUser);
                    database.AddInParameter(command, "@PositionAppliedForDesignationId", DbType.String, objuser.PositionAppliedFor);
                    database.AddInParameter(command, "@SourceID", DbType.Int32, objuser.SourceId == 0 ? DBNull.Value : (object)objuser.SourceId);
                    database.AddInParameter(command, "@AddedByUserId", DbType.Int32, objuser.AddedBy);
                    database.AddInParameter(command, "@IsEmailContactPreference", DbType.Boolean, objuser.IsEmailContactPreference);
                    database.AddInParameter(command, "@IsCallContactPreference", DbType.Boolean, objuser.IsCallContactPreference);
                    database.AddInParameter(command, "@IsTextContactPreference", DbType.Boolean, objuser.IsTextContactPreference);
                    database.AddInParameter(command, "@IsMailContactPreference", DbType.Boolean, objuser.IsMailContactPreference);

                    database.AddOutParameter(command, "@Id", DbType.Int32, 1);

                    database.ExecuteScalar(command);

                    int UserId = Convert.ToInt32(database.GetParameterValue(command, "@Id"));

                    return UserId;
                }
            }

            catch (Exception ex)
            {
                return 0;

            }
        }

        public DataSet QuickSaveUserWithEmailorPhone(user objuser)
        {
            try
            {
                SqlDatabase database = MSSQLDataBase.Instance.GetDefaultDatabase();
                {
                    DbCommand command = database.GetStoredProcCommand("usp_QuickSaveUserWithEmailorPhone");
                    command.CommandType = CommandType.StoredProcedure;

                    database.AddInParameter(command, "@FirstName", DbType.String, objuser.fristname);
                    database.AddInParameter(command, "@LastName", DbType.String, objuser.lastname);
                    database.AddInParameter(command, "@Email", DbType.String, objuser.email);
                    database.AddInParameter(command, "@Phone", DbType.String, objuser.phone);
                    //database.AddInParameter(command, "@DesignationText", DbType.String, objuser.designation);
                    //database.AddInParameter(command, "@DesignationID", DbType.String, objuser.DesignationID);
                    database.AddInParameter(command, "@AddedByUserId", DbType.Int32, objuser.AddedBy);
                    database.AddInParameter(command, "@Status", DbType.String, objuser.status);
                    database.AddOutParameter(command, "@Id", DbType.Int32, 1);
                    database.AddOutParameter(command, "@EmailExists", DbType.Binary, 1);
                    database.AddOutParameter(command, "@PhoneExists", DbType.Binary, 1);

                    DataSet ds = database.ExecuteDataSet(command);

                    //bool EmailExists = Convert.ToBoolean(database.GetParameterValue(command, "@EmailExists"));
                    //bool PhoneExists = Convert.ToBoolean(database.GetParameterValue(command, "@PhoneExists"));

                    return ds;
                }
            }

            catch (Exception ex)
            {
                return null;

            }
        }



        public Boolean UpdateUserProfile(user objuser)
        {
            try
            {
                SqlDatabase database = MSSQLDataBase.Instance.GetDefaultDatabase();
                {
                    DbCommand command = database.GetStoredProcCommand("usp_UpdateInstallUserDetailsById");
                    command.CommandType = CommandType.StoredProcedure;

                    database.AddInParameter(command, "@UserId", DbType.Int32, objuser.id);
                    database.AddInParameter(command, "@PositionAppliedFor", DbType.String, objuser.PositionAppliedFor);
                    database.AddInParameter(command, "@Designation", DbType.String, objuser.designation);
                    database.AddInParameter(command, "@DesignationId", DbType.String, objuser.DesignationID);
                    database.AddInParameter(command, "@SourceID", DbType.Int32, objuser.SourceId);
                    database.AddInParameter(command, "@Source", DbType.String, objuser.Source);
                    database.AddInParameter(command, "@FristName", DbType.String, objuser.fristname);
                    database.AddInParameter(command, "@NameMiddleInitial", DbType.String, objuser.NameMiddleInitial);
                    database.AddInParameter(command, "@LastName", DbType.String, objuser.lastname);
                    database.AddInParameter(command, "@CountryCode", DbType.String, objuser.CountryCode);
                    database.AddInParameter(command, "@Zip", DbType.String, objuser.zip);
                    database.AddInParameter(command, "@City", DbType.String, objuser.city);
                    database.AddInParameter(command, "@State", DbType.String, objuser.state);
                    database.AddInParameter(command, "@Address", DbType.String, objuser.address);
                    database.AddInParameter(command, "@LeavingReason", DbType.String, objuser.LeavingReason);
                    database.AddInParameter(command, "@Phone", DbType.String, objuser.phone);
                    database.AddInParameter(command, "@Email", DbType.String, objuser.email);
                    database.AddInParameter(command, "@IsEmailContactPreference", DbType.Boolean, objuser.IsEmailContactPreference);
                    database.AddInParameter(command, "@IsCallContactPreference", DbType.Boolean, objuser.IsCallContactPreference);
                    database.AddInParameter(command, "@IsTextContactPreference", DbType.Boolean, objuser.IsTextContactPreference);
                    database.AddInParameter(command, "@IsMailContactPreference", DbType.Boolean, objuser.IsMailContactPreference);
                    database.AddInParameter(command, "@Start_Date", DbType.String, objuser.StartDate);
                    database.AddInParameter(command, "@EmpType", DbType.String, objuser.EmpType);
                    database.AddInParameter(command, "@SalaryReq", DbType.String, objuser.SalaryReq);
                    database.AddInParameter(command, "@CruntEmployement", DbType.Boolean, Convert.ToBoolean(objuser.CruntEmployement));
                    database.AddInParameter(command, "@DrugTest", DbType.Boolean, Convert.ToBoolean(objuser.DrugTest));
                    database.AddInParameter(command, "@FELONY", DbType.Boolean, Convert.ToBoolean(objuser.FELONY));
                    database.AddInParameter(command, "@PrevApply", DbType.Boolean, Convert.ToBoolean(objuser.PrevApply));
                    database.AddInParameter(command, "@Notes", DbType.String, objuser.Notes);
                    database.AddInParameter(command, "@Picture", DbType.String, objuser.picture);
                    database.AddInParameter(command, "@ResumePath", DbType.String, objuser.picture);
                    database.AddInParameter(command, "@CurrencyId", DbType.Int32, objuser.CurrencyId);

                    database.ExecuteScalar(command);

                    return true;
                }
            }

            catch (Exception ex)
            {
                return false;

            }
        }

        public DataSet getInstallUserDetailsById(Int32 UserId)
        {
            try
            {
                SqlDatabase database = MSSQLDataBase.Instance.GetDefaultDatabase();
                {
                    returndata = new DataSet();
                    DbCommand command = database.GetStoredProcCommand("usp_GetInstallUserDetailsById");
                    command.CommandType = CommandType.StoredProcedure;
                    database.AddInParameter(command, "@UserId", DbType.Int32, UserId);
                    returndata = database.ExecuteDataSet(command);

                    return returndata;
                }
            }

            catch (Exception ex)
            {
                return null;

            }
        }

        public DataSet BulkIntsallUserDuplicateCheck(String xmlDoc)
        {
            DataSet dsTemp = new DataSet();

            try
            {
                SqlDatabase database = MSSQLDataBase.Instance.GetDefaultDatabase();
                {
                    DbCommand command = database.GetStoredProcCommand("UDP_BulkInstallUserDuplicateCheck");
                    database.AddInParameter(command, "@XMLDOC2", SqlDbType.Xml, xmlDoc);
                    dsTemp = database.ExecuteDataSet(command);
                    return dsTemp;
                }
            }
            catch (Exception ex)
            {
            }
            return dsTemp;
        }

        public BranchLocation GetUserBranchLocation(int userId)
        {
            DataSet dsTemp = new DataSet();

            try
            {
                SqlDatabase database = MSSQLDataBase.Instance.GetDefaultDatabase();
                {
                    DbCommand command = database.GetStoredProcCommand("GetUserBranchLocation");
                    database.AddInParameter(command, "@UserId", SqlDbType.Int, userId);
                    dsTemp = database.ExecuteDataSet(command);
                    if (dsTemp != null && dsTemp.Tables[0] != null && dsTemp.Tables[0].Rows.Count > 0)
                    {
                        DataRow row = dsTemp.Tables[0].Rows[0];
                        return new BranchLocation
                        {
                            BranchAddress1 = row["BranchAddress1"].ToString(),
                            BranchAddress2 = row["BranchAddress2"].ToString(),
                            CreatedOn = Convert.ToDateTime(row["CreatedOn"]),
                            Department = row["DepartmentName"].ToString(),
                            DepartmentId = Convert.ToInt32(row["DepartmentId"]),
                            Email = row["Email"].ToString(),
                            Id = Convert.ToInt32(row["Id"]),
                            PhoneNumber = row["PhoneNumber"].ToString().Replace("(", "").Replace(")", "").Replace("-", "").Trim()
                        };
                    }
                    return null;
                }
            }
            catch (Exception ex)
            {
            }
            return null;
        }

        public List<BranchLocation> GetBranchLocations()
        {
            DataSet dsTemp = new DataSet();
            List<BranchLocation> branches = new List<BranchLocation>();
            try
            {
                SqlDatabase database = MSSQLDataBase.Instance.GetDefaultDatabase();
                {
                    DbCommand command = database.GetStoredProcCommand("GetBranchLocations");
                    dsTemp = database.ExecuteDataSet(command);
                    if (dsTemp != null && dsTemp.Tables[0] != null && dsTemp.Tables[0].Rows.Count > 0)
                    {
                        foreach (DataRow row in dsTemp.Tables[0].Rows)
                        {
                            branches.Add(new BranchLocation
                            {
                                BranchLocationTitle = row["BranchLocationTitle"].ToString(),
                                BranchAddress1 = row["BranchAddress1"].ToString(),
                                BranchAddress2 = row["BranchAddress2"].ToString(),
                                CreatedOn = Convert.ToDateTime(row["CreatedOn"]),
                                //Department = row["DepartmentName"].ToString(),
                                DepartmentId = Convert.ToInt32(row["DepartmentId"]),
                                Email = row["Email"].ToString(),
                                Id = Convert.ToInt32(row["Id"]),
                                PhoneNumber = row["PhoneNumber"].ToString().Replace("(", "").Replace(")", "").Replace("-", "").Trim()
                            });
                        }
                    }
                    return branches;
                }
            }
            catch (Exception ex)
            {
                return branches;
            }
        }

        public DataSet GetBranchLocationsDataSet()
        {
            DataSet dsTemp = new DataSet();
            try
            {
                SqlDatabase database = MSSQLDataBase.Instance.GetDefaultDatabase();
                {
                    DbCommand command = database.GetStoredProcCommand("GetBranchLocations");
                    return database.ExecuteDataSet(command);
                }
            }
            catch (Exception ex)
            {
                return null;
            }
        }
        public int UserExists(int userId, string email, string phone)
        {
            try
            {
                SqlDatabase database = MSSQLDataBase.Instance.GetDefaultDatabase();
                {
                    DbCommand command = database.GetStoredProcCommand("usp_UserExists");
                    command.CommandType = CommandType.StoredProcedure;
                    database.AddInParameter(command, "@UserId", DbType.Int32, userId);
                    database.AddInParameter(command, "@Email", DbType.String, email);
                    database.AddInParameter(command, "@Phone", DbType.String, phone);
                    var returndata = database.ExecuteScalar(command);
                    return (int)returndata;
                }
            }

            catch (Exception ex)
            {
                return -1;
            }
        }
    }
}
