using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace JG_Prospect.Common.modal
{
    public class DesignationHTMLTemplate
    {
        public DesignationHTMLTemplate()
        {
            Attachments = new List<System.Net.Mail.Attachment>();
        }

        public int Id { get; set; }
        public int HTMLTemplatesMasterId { get; set; }
        public string Designation { get; set; }
        public string Subject { get; set; }
        public string Header { get; set; }
        public string Body { get; set; }
        public string Footer { get; set; }
        public DateTime DateUpdated { get; set; }
        public List<System.Net.Mail.Attachment> Attachments { get; set; }
    }
}
