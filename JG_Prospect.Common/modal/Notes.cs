using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace JG_Prospect.Common.modal
{
    public class Notes
    {
        public int? UserChatGroupId { get; set; }
        public int TaskId { get; set; }
        public int TaskMultilevelListId { get; set; }
        public int UserTouchPointLogID { get; set; }
        public int UserID { get; set; }
        public int UpdatedByUserID { get; set; }
        public string UpdatedUserInstallID { get; set; }
        public DateTime ChangeDateTime { get; set; }
        public string ChangeDateTimeFormatted { get; set; }
        public string LogDescription { get; set; }
        public string UpdatedByFirstName { get; set; }
        public string UpdatedByLastName { get; set; }
        public string UpdatedByEmail { get; set; }
        public string FristName { get; set; }
        public string LastName { get; set; }
        public string Email { get; set; }
        public string Phone { get; set; }
        public string SourceUser { get; set; }
        public string SourceUsername { get; set; }
        public string SourceUserInstallId { get; set; }
        public int TouchPointSource { get; set; }
        public bool IsRead { get; set; }

        public string ChatGroupId { get; set; }
        public string ReceiverIds { get; set; }
    }


}
