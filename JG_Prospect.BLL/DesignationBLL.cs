using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using JG_Prospect.DAL;
using JG_Prospect.Common;
using JG_Prospect.Common.modal;
using System.Data;

namespace JG_Prospect.BLL
{
    public class DesignationBLL
    {
        private static DesignationBLL m_DesignationBLL = new DesignationBLL();

        private DesignationBLL()
        {

        }

        public static DesignationBLL Instance
        {
            get { return m_DesignationBLL; }
            set {; }
        }

        public DataSet GetAllDesignationsForHumanResource()
        {
            return DesignationDAL.Instance.GetAllDesignationsForHumanResource();
        }


        public List<Designation> GetAllDesignation()
        {
            return DesignationDAL.Instance.GetDesignationByFilter(0, 0);
        }

        public List<Designation> GetAllDesignationByDepartmentID(int? DepartmentID)
        {
            return DesignationDAL.Instance.GetDesignationByFilter(0, DepartmentID);
        }

        public List<Designation> GetDesignationByID(int? DesignationID, int? DepartmentID)
        {
            return DesignationDAL.Instance.GetDesignationByFilter(DesignationID, DepartmentID);
        }

        public DataSet GetActiveDesignationByID(int? DesignationID, int? DepartmentID)
        {
            return DesignationDAL.Instance.GetActiveDesignationByFilter(DesignationID, DepartmentID);
        }

        public int DesignationInsertUpdate(Designation objDep)
        {
            return DesignationDAL.Instance.DesignationInsertUpdate(objDep);
        }
        public DataSet GetDesignationByTaskID(Int64 TaskID)
        {
            return DesignationDAL.Instance.GetDesignationByTaskID(TaskID);
        }

        public DataSet getParentTaskDesignation(UInt64 ParentTaskId)
        {
            return DesignationDAL.Instance.getParentTaskDesignation(ParentTaskId);
        }
    }
}
