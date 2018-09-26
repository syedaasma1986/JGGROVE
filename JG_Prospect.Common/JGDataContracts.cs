using System;

namespace JG_Prospect.Common.RestServiceJSONParser
{
    public class EmailCounter
    {
       public int newone { get; set; }
      public int unread { get; set; }
       
    }

    public class YandexEmailCountersResponse
    {
        public string success { get; set; }
        public string login { get; set; }
        public Int64 uid { get; set; }
        public string domain { get; set; }
        public EmailCounter counters { get; set; }

    }
}

