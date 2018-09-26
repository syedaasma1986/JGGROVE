using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Globalization;
using System.Linq;
using System.Reflection;
using System.Text;
using System.Text.RegularExpressions;
using System.Threading.Tasks;
using System.Web.ModelBinding;
using static JG_Prospect.Common.JGConstant;

namespace JG_Prospect.Common
{
    public static class Extensions
    {
        /// <summary>
        /// Converts UTC DateTime to EST DateTime
        /// </summary>
        /// <param name="dateTime"></param>
        /// <returns></returns>
        public static DateTime ToEST(this DateTime dateTime)
        {
            DateTime utcDateTime = DateTime.Parse(dateTime.ToString(), CultureInfo.InvariantCulture, DateTimeStyles.RoundtripKind);
            TimeZoneInfo easternTimeZone = TimeZoneInfo.FindSystemTimeZoneById("Eastern Standard Time");
            return TimeZoneInfo.ConvertTimeFromUtc(utcDateTime, easternTimeZone);
        }

        public static string ToEnumDescription(this Enum en) //ext method
        {
            Type type = en.GetType();
            MemberInfo[] memInfo = type.GetMember(en.ToString());
            if (memInfo != null && memInfo.Length > 0)
            {
                object[] attrs = memInfo[0].GetCustomAttributes(typeof(DescriptionAttribute), false);
                if (attrs != null && attrs.Length > 0)
                    return ((DescriptionAttribute)attrs[0]).Description;
            }
            return en.ToString();
        }

        public static string ToEnumWordify(this Enum en)
        {
            Type type = en.GetType();
            MemberInfo[] memInfo = type.GetMember(en.ToString());
            string pascalCaseString = memInfo[0].Name;
            Regex r = new Regex("(?<=[a-z])(?<x>[A-Z])|(?<=.)(?<x>[A-Z])(?=[a-z])");
            return r.Replace(pascalCaseString, " ${x}");
        }

        public static List<KeyValuePair<TEnum, string>> GetList<TEnum>()
        where TEnum : struct
        {
            if (!typeof(TEnum).IsEnum) throw new InvalidOperationException();
            return ((TEnum[])Enum.GetValues(typeof(TEnum)))
               .ToDictionary(k => k, v => ((Enum)(object)v).ToEnumDescription())
               .ToList();
        }

        public static Dictionary<int, string> ToDictionary<T>()
        {
            // Ensure T is an enumerator
            if (!typeof(T).IsEnum)
            {
                throw new ArgumentException("T must be an enumerator type.");
            }

            // Return Enumertator as a Dictionary
            return Enum.GetValues(typeof(T)).Cast<T>()
                       .ToDictionary(i => (int)Convert.ChangeType(i, i.GetType()), t => GetDescription<T>(t.ToString()));
        }

        //public static Dictionary<int, string> ToRequiredStatusDictionary<T>()
        //{
        //    // Ensure T is an enumerator
        //    if (!typeof(T).IsEnum)
        //    {
        //        throw new ArgumentException("T must be an enumerator type.");
        //    }

        //    // Return Enumertator as a Dictionary
        //    return Enum.GetValues(typeof(T)).Cast<T>()
        //               //.Where(x => (int)Convert.ChangeType(x, x.GetType()) != 4)
        //               .Select(x => new EnumWitAttributes
        //               {
        //                   EnumText = (T)Convert.ChangeType(x, x.GetType())
        //               })
        //               .ToDictionary(i => (int)Convert.ChangeType(i, i.GetType()), t => GetDescription<T>(t.ToString()));
        //}

        public static List<EnumWitAttributes> GetListOf<TEnum>()
                    where TEnum : struct // can't constrain to enums so closest thing
        {
            int excludedStatus = (int)InstallUserStatus.InstallProspect;
            return Enum.GetValues(typeof(TEnum)).Cast<Enum>()
                        .Select(x => new EnumWitAttributes
                        {
                            Order = x.GetEnumAttribute<OrderAttribute>().Order,
                            EnumCssClass = x.GetEnumAttribute<StatusIconAttribute>().StatusIcon,
                            EnumText = x.GetEnumAttribute<TypeTextAttribute>().TypeText,
                            EnumValue = (int)Convert.ChangeType(x, x.GetType())
                        })
                        .Where(x=> x.EnumValue != excludedStatus)
                        .OrderBy(x => x.Order)
                        .ToList();
        }

        public static string GetDescription<T>(string value)
        {
            Type type = typeof(T);
            if (typeof(T).IsGenericType && typeof(T).GetGenericTypeDefinition() == typeof(Nullable<>))
            {
                type = Nullable.GetUnderlyingType(type);
            }

            T enumerator = (T)Enum.Parse(type, value);

            FieldInfo fi = enumerator.GetType().GetField(enumerator.ToString());

            DescriptionAttribute[] attributtes =
                (DescriptionAttribute[])fi.GetCustomAttributes(typeof(DescriptionAttribute), false);

            if (attributtes != null && attributtes.Length > 0)
                return attributtes[0].Description;
            else
                return enumerator.ToString();
        }

        public static T ToEnum<T>(this string value)
        {
            return (T)Enum.Parse(typeof(T), value, true);
        }

        public static string RemoveAllSpecialCharaters(this string input)
        {
            return Regex.Replace(input, @"[^0-9a-zA-Z]+", "");
        }

        public static TAttribute GetEnumAttribute<TAttribute>(this Enum value)
                        where TAttribute : Attribute
        {
            var type = value.GetType();
            var name = Enum.GetName(type, value);
            return type.GetField(name) // I prefer to get attributes this way
                .GetCustomAttributes(false)
                .OfType<TAttribute>()
                .SingleOrDefault();
        }
    }

    public class StatusIconAttribute : Attribute
    {
        public string StatusIcon;
        public StatusIconAttribute(string statusIcon) { StatusIcon = statusIcon; }
    }

    public class StatusTextAttribute : Attribute
    {
        public string StatusText;
        public StatusTextAttribute(string statusText) { StatusText = statusText; }
    }

    public class TypeTextAttribute : Attribute
    {
        public string TypeText;
        public TypeTextAttribute(string typeText) { TypeText = typeText; }
    }

    public class OrderAttribute : Attribute
    {
        public int Order;
        public OrderAttribute(int order) { Order = order; }
    }

    public static class EnumExtensions
    {
        public static string GetStatusIcon(this Enum value)
        {
            var type = value.GetType();

            string name = Enum.GetName(type, value);
            if (name == null) { return null; }

            var field = type.GetField(name);
            if (field == null) { return null; }

            var attr = Attribute.GetCustomAttribute(field, typeof(StatusIconAttribute)) as StatusIconAttribute;
            if (attr == null) { return null; }

            return attr.StatusIcon;
        }

        public static string GetOrder(this Enum value)
        {
            var type = value.GetType();

            string name = Enum.GetName(type, value);
            if (name == null) { return null; }

            var field = type.GetField(name);
            if (field == null) { return null; }

            var attr = Attribute.GetCustomAttribute(field, typeof(StatusIconAttribute)) as StatusIconAttribute;
            if (attr == null) { return null; }

            return attr.StatusIcon;
        }

        public static string GetStatusText(this Enum value)
        {
            var type = value.GetType();

            string name = Enum.GetName(type, value);
            if (name == null) { return null; }

            var field = type.GetField(name);
            if (field == null) { return null; }

            var attr = Attribute.GetCustomAttribute(field, typeof(StatusTextAttribute)) as StatusTextAttribute;
            if (attr == null) { return null; }

            return attr.StatusText;
        }

        public static string GetTypeText(this Enum value)
        {
            var type = value.GetType();

            string name = Enum.GetName(type, value);
            if (name == null) { return null; }

            var field = type.GetField(name);
            if (field == null) { return null; }

            var attr = Attribute.GetCustomAttribute(field, typeof(TypeTextAttribute)) as TypeTextAttribute;
            if (attr == null) { return null; }

            return attr.TypeText;
        }
    }
}
