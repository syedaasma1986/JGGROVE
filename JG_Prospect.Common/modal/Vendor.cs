using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Data;

namespace JG_Prospect.Common.modal
{
    public class Vendor
    {
        public int vendor_id;
        public string vendor_name;
        public int vendor_category_id;
        public string contract_person;
        public string contract_number;
        public string fax;
        public string mail;
        public string address;
        public string notes;
        public string ManufacturerType;
        public string BillingAddress;
        public string TaxId;
        public string ExpenseCategory;
        public string AutoTruckInsurance;
        public int vendor_subcategory_id;
        public string VendorStatus;
        public string Website;
        public string ContactExten;
        public DataTable tblVendorEmail;
        public DataTable tblVendorAddress;
        public string Vendrosource;
        public Nullable<int> AddressID;
        public string PaymentTerms;
        public string PaymentMethod;
        public string TempID;
        public string NotesTempID;
        public string VendorCategories;
        public string VendorSubCategories;
        public string UserID;

        public decimal DeliveryFee;
        public decimal StockingReturnFee;
        public decimal MiscFee;
        public string DeliveryMethod;
        public string FreightTerms;
        public decimal Tax;
        public string VendorQuote;
        public string AttachVendorQuote;
        public string Revision;
        public string VendorInvoice;
        public string JGCustomerPO;
        public DateTime LeadTimeDueDate;
        public int EconimicalOrderQuantity;
        public decimal DiscountPerUnit;
        public decimal ReOrderPoint;
        public int OrderQTY;
        public string GeneralPhone;
        public string HoursOfOperation;
        public bool ContactPreferenceEmail;
        public bool ContactPreferenceCall;
        public bool ContactPreferenceText;
        public bool ContactPreferenceMail;

    }
}