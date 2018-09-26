using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace JG_Prospect.Common.modal
{
    public class HTMLTemplatesMaster
    {
        public int Id { get; set; }
        public int Type { get; set; }
        public byte? Category { get; set; }
        public string Name { get; set; }
        public string Subject { get; set; }
        public string Header { get; set; }
        public string Body { get; set; }
        public string Footer { get; set; }
        public DateTime DateUpdated { get; set; }
    }

    public class EMailSchedularModel
    {
        public int Id { get; set; }
        public int TemplateId { get; set; }
        public int Frequency { get; set; }
        public DateTime RunsOn { get; set; }
    }
}
