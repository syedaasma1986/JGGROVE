using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Services;
using JG_Prospect.Common;
using JG_Prospect.DAL.Database;
using Microsoft.Practices.EnterpriseLibrary.Data.Sql;
using System.Data;
using System.Data.SqlClient;
using System.Data.Common;
using System.Web.Script.Serialization;

namespace JG_Prospect.Sr_App
{
    /// <summary>
    /// Summary description for AnnualEventWebService
    /// </summary>
    [WebService(Namespace = "http://tempuri.org/")]
    [WebServiceBinding(ConformsTo = WsiProfiles.BasicProfile1_1)]
    [System.ComponentModel.ToolboxItem(false)]
    // To allow this Web Service to be called from script, using ASP.NET AJAX, uncomment the following line. 
     [System.Web.Script.Services.ScriptService]
    public class AnnualEventWebService : System.Web.Services.WebService
    {

        [WebMethod]
        public string GetAnnualEventById(int vEventId)
        {

            List<object> listdata = new List<object>();

            SqlDatabase database = MSSQLDataBase.Instance.GetDefaultDatabase();
            {
                DataSet ds = new DataSet();
                string str = "select  Id,EventName,EventLoc,EventDesc,EventStartTime,EventEndTime,Interval,Recurrencerule,EventFile,EventDate,EventColor,EventType,EventCal,EventRepeat,EventEndDate,MaxOccurance from tbl_AnnualEvents where ID=" + vEventId;
                DbCommand command = database.GetSqlStringCommand(str);
                command.CommandType = CommandType.Text;
                ds = database.ExecuteDataSet(command);
                if (ds.Tables[0].Rows.Count > 0)
                {
                    //txtEventName.Text = result.Tables[0].Rows[0]["EventName"].ToString();
                    listdata.Add(new
                    {
                        Id = ds.Tables[0].Rows[0]["Id"],
                        eventname = ds.Tables[0].Rows[0]["EventName"],
                        eventloc = ds.Tables[0].Rows[0]["EventLoc"],
                        eventdesc = ds.Tables[0].Rows[0]["EventDesc"],
                        eventstarttime = ds.Tables[0].Rows[0]["EventStartTime"],
                        eventendtime = ds.Tables[0].Rows[0]["EventEndTime"],
                        eventdate = ds.Tables[0].Rows[0]["EventDate"],
                        eventenddate = ds.Tables[0].Rows[0]["EventEndDate"],
                        eventcolor = ds.Tables[0].Rows[0]["EventColor"],
                        eventtype = ds.Tables[0].Rows[0]["EventType"],
                        eventcal = ds.Tables[0].Rows[0]["EventCal"],
                        eventrepeat = ds.Tables[0].Rows[0]["EventRepeat"],
                        eventfile = ds.Tables[0].Rows[0]["EventFile"],
                        recurrencerule = ds.Tables[0].Rows[0]["Recurrencerule"],
                        maxoccurance = ds.Tables[0].Rows[0]["MaxOccurance"],
                        interval = ds.Tables[0].Rows[0]["Interval"]

                    });

                }
            }

            return (new JavaScriptSerializer().Serialize(listdata));
        }
    }
}
