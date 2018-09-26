using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace JG_Prospect.Common.modal
{
    [Serializable]
    public class Folders
    {
        public int ID { get; set; }
        public string Name { get; set; }

        public int DesignationId { get; set; }

        public int ModifiedBy { get; set; }
        public DateTime ModifiedDate { get; set; }
    }
}
