using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace JG_Prospect.Common.modal
{
    [Serializable]
    public class FilesTreeView
    {
        public string Title { get; set; }
        public List<FilesTreeViewCategories> Categories { get; set; }
    }

    public class FilesTreeViewCategories
    {
        public string Title { get; set; }
        public int Id { get; set; }
        public int DesignationId { get; set; }
        public List<FilesTreeViewCategoriesNested> Categories { get; set; }
    }

    public class FilesTreeViewCategoriesNested
    {
        public string Title { get; set; }
        public string UniqueName { get; set; }
        public int DesignationId { get; set; }
        public int ID { get; set; }
        public int FolderId { get; set; }
        public int Type { get; set; }
    }
}
