using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace JG_Prospect.Common.modal
{
    [Serializable]
    public partial class TaskComment
    {
        public long Id { get; set; }
        public string Comment { get; set; }
        public long TaskId { get; set; }
        public long? ParentCommentId { get; set; }
        public int UserId { get; set; }
        public DateTime DateCreated { get; set; }

        public int TotalChildRecords { get; set; }

        public string UserName { get; set; }
        public string UserFirstName { get; set; }
        public string UserLastName { get; set; }
        public string UserInstallId { get; set; }
        public string UserEmail { get; set; }
    }
}
