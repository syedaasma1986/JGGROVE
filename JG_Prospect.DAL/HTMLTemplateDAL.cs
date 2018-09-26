using JG_Prospect.Common;
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
    public class HTMLTemplateDAL
    {
        public static HTMLTemplateDAL m_HTMLTemplateDAL = new HTMLTemplateDAL();

        private HTMLTemplateDAL()
        {

        }

        public static HTMLTemplateDAL Instance
        {
            get { return m_HTMLTemplateDAL; }
            private set {; }
        }

        public DataSet GetHTMLTemplateMasters(Int32 TemplateUsedFor)
        {
            try
            {
                SqlDatabase database = MSSQLDataBase.Instance.GetDefaultDatabase();
                {
                    DbCommand command = database.GetStoredProcCommand("GetHTMLTemplateMasters");
                    database.AddInParameter(command, "@UsedFor", DbType.Int32, TemplateUsedFor);
                    command.CommandType = CommandType.StoredProcedure;
                    return database.ExecuteDataSet(command);
                }
            }
            catch (Exception ex)
            {
                return null;
            }
        }

        public DataSet GetSMSTemplateMasters(Int32 TemplateUsedFor)
        {
            try
            {
                SqlDatabase database = MSSQLDataBase.Instance.GetDefaultDatabase();
                {
                    DbCommand command = database.GetStoredProcCommand("GetSMSTemplateMasters");
                    database.AddInParameter(command, "@UsedFor", DbType.Int32, TemplateUsedFor);
                    command.CommandType = CommandType.StoredProcedure;
                    return database.ExecuteDataSet(command);
                }
            }
            catch (Exception ex)
            {
                return null;
            }
        }

        public HTMLTemplatesMaster GetHTMLTemplateMasterById(HTMLTemplates objHTMLTemplates)
        {
            try
            {
                SqlDatabase database = MSSQLDataBase.Instance.GetDefaultDatabase();
                {
                    DbCommand command = database.GetStoredProcCommand("GetHTMLTemplateMasterById");
                    command.CommandType = CommandType.StoredProcedure;
                    database.AddInParameter(command, "@Id", DbType.Int16, (byte)objHTMLTemplates);

                    DataSet dsHTMLTemplate = database.ExecuteDataSet(command);
                    HTMLTemplatesMaster objHTMLTemplate = null;
                    if (
                        dsHTMLTemplate != null &&
                        dsHTMLTemplate.Tables.Count > 0 &&
                        dsHTMLTemplate.Tables[0].Rows.Count > 0
                       )
                    {
                        DataRow dr = dsHTMLTemplate.Tables[0].Rows[0];

                        objHTMLTemplate = new HTMLTemplatesMaster();

                        objHTMLTemplate.Id = Convert.ToInt32(dr["Id"]);
                        objHTMLTemplate.Type = Convert.ToByte(dr["Type"]);
                        if (!string.IsNullOrEmpty(Convert.ToString(dr["Category"])))
                        {
                            objHTMLTemplate.Category = Convert.ToByte(dr["Category"]);
                        }
                        else
                        {
                            objHTMLTemplate.Category = null;
                        }
                        objHTMLTemplate.Name = Convert.ToString(dr["Name"]);
                        objHTMLTemplate.Subject = Convert.ToString(dr["Subject"]);
                        objHTMLTemplate.Header = Convert.ToString(dr["Header"]);
                        objHTMLTemplate.Body = Convert.ToString(dr["Body"]);
                        objHTMLTemplate.Footer = Convert.ToString(dr["Footer"]);
                        objHTMLTemplate.DateUpdated = Convert.ToDateTime(dr["DateUpdated"]);
                    }

                    return objHTMLTemplate;
                }
            }
            catch (Exception ex)
            {
                return null;
            }
        }

        public HTMLTemplatesMaster GetSMSTemplateMasterById(HTMLTemplates objHTMLTemplates)
        {
            try
            {
                SqlDatabase database = MSSQLDataBase.Instance.GetDefaultDatabase();
                {
                    DbCommand command = database.GetStoredProcCommand("GetHTMLTemplateMasterById");
                    command.CommandType = CommandType.StoredProcedure;
                    database.AddInParameter(command, "@Id", DbType.Int16, (byte)objHTMLTemplates);

                    DataSet dsHTMLTemplate = database.ExecuteDataSet(command);
                    HTMLTemplatesMaster objHTMLTemplate = null;
                    if (
                        dsHTMLTemplate != null &&
                        dsHTMLTemplate.Tables.Count > 0 &&
                        dsHTMLTemplate.Tables[0].Rows.Count > 0
                       )
                    {
                        DataRow dr = dsHTMLTemplate.Tables[0].Rows[0];

                        objHTMLTemplate = new HTMLTemplatesMaster();

                        objHTMLTemplate.Id = Convert.ToInt32(dr["Id"]);
                        objHTMLTemplate.Type = Convert.ToByte(dr["Type"]);
                        if (!string.IsNullOrEmpty(Convert.ToString(dr["Category"])))
                        {
                            objHTMLTemplate.Category = Convert.ToByte(dr["Category"]);
                        }
                        else
                        {
                            objHTMLTemplate.Category = null;
                        }
                        objHTMLTemplate.Name = Convert.ToString(dr["Name"]);
                        objHTMLTemplate.Subject = Convert.ToString(dr["Subject"]);
                        objHTMLTemplate.Header = Convert.ToString(dr["Header"]);
                        objHTMLTemplate.Body = Convert.ToString(dr["Body"]);
                        objHTMLTemplate.Footer = Convert.ToString(dr["Footer"]);
                        objHTMLTemplate.DateUpdated = Convert.ToDateTime(dr["DateUpdated"]);
                    }

                    return objHTMLTemplate;
                }
            }
            catch (Exception ex)
            {
                return null;
            }
        }

        public DesignationHTMLTemplate GetDesignationSMSTemplate(HTMLTemplates objHTMLTemplates, string strDesignation)
        {
            try
            {
                SqlDatabase database = MSSQLDataBase.Instance.GetDefaultDatabase();
                {
                    DbCommand command = database.GetStoredProcCommand("GetDesignationHTMLTemplate");
                    command.CommandType = CommandType.StoredProcedure;
                    database.AddInParameter(command, "@Id", DbType.Int16, (byte)objHTMLTemplates);
                    if (!string.IsNullOrEmpty(strDesignation))
                    {
                        database.AddInParameter(command, "@Designation", DbType.String, strDesignation);
                    }

                    DataSet dsHTMLTemplate = database.ExecuteDataSet(command);
                    DesignationHTMLTemplate objHTMLTemplate = null;
                    if (
                        dsHTMLTemplate != null &&
                        dsHTMLTemplate.Tables.Count > 0 &&
                        dsHTMLTemplate.Tables[0].Rows.Count > 0
                       )
                    {
                        DataRow dr = dsHTMLTemplate.Tables[0].Rows[0];

                        objHTMLTemplate = new DesignationHTMLTemplate();

                        objHTMLTemplate.Id = Convert.ToInt32(dr["Id"]);
                        objHTMLTemplate.HTMLTemplatesMasterId = Convert.ToInt32(dr["HTMLTemplatesMasterId"]);
                        objHTMLTemplate.Subject = Convert.ToString(dr["Subject"]);
                        objHTMLTemplate.Header = Convert.ToString(dr["Header"]);

                        String BodyText = Convert.ToString(dr["Body"]);
                        objHTMLTemplate.Body = BodyText;
                        //if (BodyText.IndexOf("#UNSEMAIL#") > 0)
                        //{
                        //    objHTMLTemplate.Body = BodyText;
                        //}
                        //else
                        //{
                        //    objHTMLTemplate.Body = String.Concat(BodyText, JGCommon.GetEmailUnSubscribeSection());
                        //}

                        objHTMLTemplate.Footer = Convert.ToString(dr["Footer"]);
                        objHTMLTemplate.DateUpdated = Convert.ToDateTime(dr["DateUpdated"]);
                    }

                    return objHTMLTemplate;
                }
            }
            catch (Exception ex)
            {
                return null;
            }
        }

        public bool RevertDesignationSMSTemplatesByMasterTemplateId(object masterTemplateId)
        {
            try
            {
                SqlDatabase database = MSSQLDataBase.Instance.GetDefaultDatabase();
                {
                    DbCommand command = database.GetStoredProcCommand("usp_RevertTemplatesToMasterSMSTemplate");
                    command.CommandType = CommandType.StoredProcedure;
                    database.AddInParameter(command, "@MasterTemplateID", DbType.Int32, masterTemplateId);

                    database.ExecuteNonQuery(command);

                    return true;
                }
            }
            catch (Exception ex)
            {
                return false;
            }
        }

        public bool SaveMasterSMSTemplate(DesignationHTMLTemplate objDesignationHTMLTemplate)
        {
            try
            {
                SqlDatabase database = MSSQLDataBase.Instance.GetDefaultDatabase();
                {
                    DbCommand command = database.GetStoredProcCommand("usp_updateMasterSMSTemplate");
                    command.CommandType = CommandType.StoredProcedure;
                    database.AddInParameter(command, "@MasterTemplateID", DbType.Int16, objDesignationHTMLTemplate.HTMLTemplatesMasterId);
                    database.AddInParameter(command, "@Body", DbType.String, objDesignationHTMLTemplate.Body);

                    database.ExecuteNonQuery(command);

                    return true;
                }
            }
            catch (Exception ex)
            {
                return false;
            }
        }

        public bool SaveDesignationSMSTemplate(DesignationHTMLTemplate objDesignationHTMLTemplate, byte? intMasterCategory)
        {
            try
            {
                SqlDatabase database = MSSQLDataBase.Instance.GetDefaultDatabase();
                {
                    DbCommand command = database.GetStoredProcCommand("SaveDesignationSMSTemplate");
                    command.CommandType = CommandType.StoredProcedure;
                    database.AddInParameter(command, "@HTMLTemplatesMasterId", DbType.Int16, objDesignationHTMLTemplate.HTMLTemplatesMasterId);
                    if (intMasterCategory.HasValue)
                    {
                        database.AddInParameter(command, "@MasterCategory", DbType.Byte, intMasterCategory);
                    }
                    else
                    {
                        database.AddInParameter(command, "@MasterCategory", DbType.Byte, DBNull.Value);
                    }
                    database.AddInParameter(command, "@Designation", DbType.String, objDesignationHTMLTemplate.Designation);
                    //database.AddInParameter(command, "@Subject", DbType.String, objDesignationHTMLTemplate.Subject);
                    //database.AddInParameter(command, "@Header", DbType.String, objDesignationHTMLTemplate.Header);
                    database.AddInParameter(command, "@Body", DbType.String, objDesignationHTMLTemplate.Body);
                    //database.AddInParameter(command, "@Footer", DbType.String, objDesignationHTMLTemplate.Footer);

                    database.ExecuteNonQuery(command);

                    return true;
                }
            }
            catch (Exception ex)
            {
                return false;
            }
        }

        public bool RevertDesignationHTMLTemplatesByMasterTemplateId(int masterTemplateId)
        {
            try
            {
                SqlDatabase database = MSSQLDataBase.Instance.GetDefaultDatabase();
                {
                    DbCommand command = database.GetStoredProcCommand("usp_RevertTemplatesToMasterHTMLTemplate");
                    command.CommandType = CommandType.StoredProcedure;
                    database.AddInParameter(command, "@MasterTemplateID", DbType.Int32, masterTemplateId);

                    database.ExecuteNonQuery(command);

                    return true;
                }
            }
            catch (Exception ex)
            {
                return false;
            }
        }

        public DesignationHTMLTemplate GetDesignationHTMLTemplate(HTMLTemplates objHTMLTemplates, string strDesignation)
        {
            try
            {
                SqlDatabase database = MSSQLDataBase.Instance.GetDefaultDatabase();
                {
                    DbCommand command = database.GetStoredProcCommand("GetDesignationHTMLTemplate");
                    command.CommandType = CommandType.StoredProcedure;
                    database.AddInParameter(command, "@Id", DbType.Int16, (byte)objHTMLTemplates);
                    if (!string.IsNullOrEmpty(strDesignation))
                    {
                        database.AddInParameter(command, "@Designation", DbType.String, strDesignation);
                    }

                    DataSet dsHTMLTemplate = database.ExecuteDataSet(command);
                    DesignationHTMLTemplate objHTMLTemplate = null;
                    if (
                        dsHTMLTemplate != null &&
                        dsHTMLTemplate.Tables.Count > 0 &&
                        dsHTMLTemplate.Tables[0].Rows.Count > 0
                       )
                    {
                        DataRow dr = dsHTMLTemplate.Tables[0].Rows[0];

                        objHTMLTemplate = new DesignationHTMLTemplate();

                        objHTMLTemplate.Id = Convert.ToInt32(dr["Id"]);
                        objHTMLTemplate.HTMLTemplatesMasterId = Convert.ToInt32(dr["HTMLTemplatesMasterId"]);
                        objHTMLTemplate.Subject = Convert.ToString(dr["Subject"]);
                        objHTMLTemplate.Header = Convert.ToString(dr["Header"]);

                        String BodyText = Convert.ToString(dr["Body"]);

                        if (BodyText.IndexOf("#UNSEMAIL#") > 0)
                        {
                            objHTMLTemplate.Body = BodyText;
                        }
                        else
                        {
                            objHTMLTemplate.Body = String.Concat(BodyText, JGCommon.GetEmailUnSubscribeSection());
                        }

                        objHTMLTemplate.Footer = Convert.ToString(dr["Footer"]);
                        objHTMLTemplate.DateUpdated = Convert.ToDateTime(dr["DateUpdated"]);
                    }

                    return objHTMLTemplate;
                }
            }
            catch (Exception ex)
            {
                return null;
            }
        }

        public bool SaveDesignationHTMLTemplate(DesignationHTMLTemplate objDesignationHTMLTemplate, byte? intMasterCategory)
        {
            try
            {
                SqlDatabase database = MSSQLDataBase.Instance.GetDefaultDatabase();
                {
                    DbCommand command = database.GetStoredProcCommand("SaveDesignationHTMLTemplate");
                    command.CommandType = CommandType.StoredProcedure;
                    database.AddInParameter(command, "@HTMLTemplatesMasterId", DbType.Int16, objDesignationHTMLTemplate.HTMLTemplatesMasterId);
                    if (intMasterCategory.HasValue)
                    {
                        database.AddInParameter(command, "@MasterCategory", DbType.Byte, intMasterCategory);
                    }
                    else
                    {
                        database.AddInParameter(command, "@MasterCategory", DbType.Byte, DBNull.Value);
                    }
                    database.AddInParameter(command, "@Designation", DbType.String, objDesignationHTMLTemplate.Designation);
                    database.AddInParameter(command, "@Subject", DbType.String, objDesignationHTMLTemplate.Subject);
                    database.AddInParameter(command, "@Header", DbType.String, objDesignationHTMLTemplate.Header);
                    database.AddInParameter(command, "@Body", DbType.String, objDesignationHTMLTemplate.Body);
                    database.AddInParameter(command, "@Footer", DbType.String, objDesignationHTMLTemplate.Footer);

                    database.ExecuteNonQuery(command);

                    return true;
                }
            }
            catch (Exception ex)
            {
                return false;
            }
        }

        public bool SaveMasterHTMLTemplate(DesignationHTMLTemplate objDesignationHTMLTemplate)
        {
            try
            {
                SqlDatabase database = MSSQLDataBase.Instance.GetDefaultDatabase();
                {
                    DbCommand command = database.GetStoredProcCommand("usp_updateMasterHTMLTemplate");
                    command.CommandType = CommandType.StoredProcedure;
                    database.AddInParameter(command, "@MasterTemplateID", DbType.Int16, objDesignationHTMLTemplate.HTMLTemplatesMasterId);
                    database.AddInParameter(command, "@Subject", DbType.String, objDesignationHTMLTemplate.Subject);
                    database.AddInParameter(command, "@Header", DbType.String, objDesignationHTMLTemplate.Header);
                    database.AddInParameter(command, "@Body", DbType.String, objDesignationHTMLTemplate.Body);
                    database.AddInParameter(command, "@Footer", DbType.String, objDesignationHTMLTemplate.Footer);

                    database.ExecuteNonQuery(command);

                    return true;
                }
            }
            catch (Exception ex)
            {
                return false;
            }
        }

        public bool DeleteDesignationHTMLTemplate(HTMLTemplates objHTMLTemplates, string strDesignation)
        {
            try
            {
                SqlDatabase database = MSSQLDataBase.Instance.GetDefaultDatabase();
                {
                    DbCommand command = database.GetStoredProcCommand("DeleteDesignationHTMLTemplate");
                    command.CommandType = CommandType.StoredProcedure;
                    database.AddInParameter(command, "@Id", DbType.Int16, (byte)objHTMLTemplates);
                    if (!string.IsNullOrEmpty(strDesignation))
                    {
                        database.AddInParameter(command, "@Designation", DbType.String, strDesignation);
                    }

                    database.ExecuteNonQuery(command);

                    return true;
                }
            }
            catch (Exception ex)
            {
                return false;
            }
        }

        public bool UpdateHTMLTemplateFromId(Int32 TemplateId, String FromID)
        {
            try
            {
                SqlDatabase database = MSSQLDataBase.Instance.GetDefaultDatabase();
                {
                    DbCommand command = database.GetStoredProcCommand("[usp_UpdateTemplateFromID]");
                    command.CommandType = CommandType.StoredProcedure;
                    database.AddInParameter(command, "@Id", DbType.Int32, TemplateId);
                    database.AddInParameter(command, "@FromID", DbType.String, FromID);

                    database.ExecuteNonQuery(command);

                    return true;
                }
            }
            catch (Exception ex)
            {
                return false;
            }
        }

        public bool UpdateHTMLTemplateSubject(Int32 TemplateId, String Subject)
        {
            try
            {
                SqlDatabase database = MSSQLDataBase.Instance.GetDefaultDatabase();
                {
                    DbCommand command = database.GetStoredProcCommand("[usp_UpdateTemplateSubject]");
                    command.CommandType = CommandType.StoredProcedure;
                    database.AddInParameter(command, "@Id", DbType.Int32, TemplateId);
                    database.AddInParameter(command, "@Subject", DbType.String, Subject);

                    database.ExecuteNonQuery(command);

                    return true;
                }
            }
            catch (Exception ex)
            {
                return false;
            }
        }

        public bool UpdateHTMLTemplateTriggerText(Int32 TemplateId, String TriggerText)
        {
            try
            {
                SqlDatabase database = MSSQLDataBase.Instance.GetDefaultDatabase();
                {
                    DbCommand command = database.GetStoredProcCommand("usp_UpdateTemplateTriggerText");
                    command.CommandType = CommandType.StoredProcedure;
                    database.AddInParameter(command, "@Id", DbType.Int32, TemplateId);
                    database.AddInParameter(command, "@TriggerText", DbType.String, TriggerText);

                    database.ExecuteNonQuery(command);

                    return true;
                }
            }
            catch (Exception ex)
            {
                return false;
            }
        }

        public bool UpdateHTMLTemplateFreQuency(Int32 TemplateId, Int32 FrequencyInDays, DateTime FrequencyStartDate, DateTime FrequenchTime)
        {
            try
            {
                SqlDatabase database = MSSQLDataBase.Instance.GetDefaultDatabase();
                {
                    DbCommand command = database.GetStoredProcCommand("[usp_UpdateTemplateFrequency]");
                    command.CommandType = CommandType.StoredProcedure;

                    database.AddInParameter(command, "@Id", DbType.Int32, TemplateId);
                    database.AddInParameter(command, "@FrequencyInDays", DbType.Int32, FrequencyInDays);
                    database.AddInParameter(command, "@FrequencyStartDate", DbType.DateTime, FrequencyStartDate);
                    database.AddInParameter(command, "@FrequencyStartTime", DbType.DateTime, FrequenchTime);

                    database.ExecuteNonQuery(command);

                    return true;
                }
            }
            catch (Exception ex)
            {
                return false;
            }
        }

        public List<EMailSchedularModel> GetCurrentScheduledHtmlTemplates()
        {
            try
            {
                SqlDatabase database = MSSQLDataBase.Instance.GetDefaultDatabase();
                {
                    DbCommand command = database.GetStoredProcCommand("GetCurrentScheduledHtmlTemplates");
                    command.CommandType = CommandType.StoredProcedure;
                    DataSet dt = database.ExecuteDataSet(command);
                    if (dt != null && dt.Tables[0] != null && dt.Tables[0].Rows.Count > 0)
                    {
                        List<EMailSchedularModel> model = new List<EMailSchedularModel>();
                        foreach (DataRow row in dt.Tables[0].Rows)
                        {
                            model.Add(new EMailSchedularModel
                            {
                                Id = Convert.ToInt32(row["Id"]),
                                Frequency = Convert.ToInt32(row["Frequency"]),
                                RunsOn = Convert.ToDateTime(row["RunsOn"]),
                                TemplateId = Convert.ToInt32(row["TemplateId"])
                            });
                        }
                        return model;
                    }
                    else
                        return null;
                }
            }
            catch (Exception ex)
            {
                return null;
            }
        }

    }
}
