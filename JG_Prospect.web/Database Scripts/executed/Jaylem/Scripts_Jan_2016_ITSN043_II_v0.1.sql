USE [JGBS_Dev]
GO
/****** Object:  StoredProcedure [dbo].[USP_GetVendorList]    Script Date: 10-01-2017 06:15:41 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		-
-- Create date: -
-- Description:	-
-- Updated By : Jaylem
-- Updated Date : 10-Jan-2016
-- =============================================
ALTER PROCEDURE [dbo].[USP_GetVendorList]  
@FilterParams nvarchar(Max)=null,  
@FilterBy nvarchar(50)=null,  
@ManufacturerType nvarchar(20)=null,  
@VendorCategoryId nvarchar(10)=null,
@VendorStatus nvarchar(20)=null  
as  
BEGIN  
 Declare @BaseQuery nvarchar(max)=null  
  if(@FilterBy='VendorSubCategory')  
  begin  
   set @BaseQuery= 'select distinct v.VendorName as VendorName,v.VendorId as VendorId,tvAdd.Id as AddressId,tvAdd.Zip '  
          +'from tbl_Vendor_VendorSubCat V_Vsc '  
          +'inner join tblVendors v '  
          +'on V_Vsc.VendorId = v.VendorId '  
          +'inner join tbl_VendorCat_VendorSubCat Vc_Vsc '  
          +'on Vc_Vsc.VendorSubCategoryId=V_Vsc.VendorSubCatId '
		  +' left outer join tblVendorAddress tvAdd on v.VendorId=tvAdd.VendorId '
		  
		  if(@VendorStatus='All' OR @VendorStatus=null)
		  Begin
			set @BaseQuery=@BaseQuery+' where V_Vsc.VendorSubCatId=@FilterParams order by VendorName'
		  End
		  else
		  Begin
			set @BaseQuery=@BaseQuery+' where V_Vsc.VendorSubCatId=@FilterParams And vendorStatus=@VendorStatus order by VendorName' 
		  End
		   
  end  
  else if(@FilterBy='VendorCategory')  
  begin  
   set @BaseQuery='select tv.VendorName as VendorName,tv.VendorId as VendorId,tvAdd.Id as AddressId,tvAdd.Zip from tblvendors tv '  
      +'inner join tbl_Vendor_VendorCat tvVcat '  
      +'on tv.VendorId=tvVcat.Vendorid '
      +' left outer join tblVendorAddress tvAdd on tv.VendorId=tvAdd.VendorId '
       if(@VendorStatus='All' OR @VendorStatus=null OR @VendorStatus='')
		  Begin
			set @BaseQuery=@BaseQuery +' where tvVcat.VendorCatId=@FilterParams order by VendorName' 
		  End
		  else
		  Begin
			set @BaseQuery=@BaseQuery +' where tvVcat.VendorCatId=@FilterParams And vendorStatus=@VendorStatus order by VendorName'  
		  End
       
   --set @WhereClause= @WhereClause +' AND Vc_Vsc.VendorCategoryId=@FilterParams'  
  end  
  else if(@FilterBy='ProductCategory')  
  begin  
  set @BaseQuery='select tv.VendorName as VendorName,tv.VendorId as VendorId,tvAdd.Id as AddressId,tvAdd.Zip from tblvendors tv '  
      +'inner join tbl_Vendor_VendorCat tvVcat '  
      +'on tv.VendorId=tvVcat.Vendorid '
      +' left outer join tblVendorAddress tvAdd on tv.VendorId=tvAdd.VendorId '
       if(@VendorStatus='All' OR @VendorStatus=null)
		  Begin
			set @BaseQuery=@BaseQuery +' where tvVcat.VendorCatId in (select * from dbo.split(@FilterParams,'','')) And order by VendorName'
		  End
		  else
		  Begin
			set @BaseQuery=@BaseQuery +' where tvVcat.VendorCatId in (select * from dbo.split(@FilterParams,'','')) And vendorStatus=@VendorStatus order by VendorName'
		  End
     
   --set @WhereClause= @WhereClause +' And Vc_Vsc.VendorCategoryId in (select * from dbo.split(@FilterParams,'',''))';  
  end  
  else if(@FilterBy='ProductCategoryAll')  
  begin  
  set @BaseQuery='select tv.VendorName as VendorName,tv.VendorId as VendorId,tvAdd.Id as AddressId,tvAdd.Zip from tblvendors tv '  
      +'inner join tbl_Vendor_VendorCat tvVcat '  
      +'on tv.VendorId=tvVcat.Vendorid '
      +' left outer join tblVendorAddress tvAdd on tv.VendorId=tvAdd.VendorId'
       if(@VendorStatus='All' OR @VendorStatus=null)
		  Begin
			set @BaseQuery=@BaseQuery +' order by VendorName' 
		  End
		  else
		  Begin
			set @BaseQuery=@BaseQuery +' where tv.vendorStatus=@VendorStatus order by VendorName' 
		  End
           
  end    
 --else if(@FilterBy='ManufacturerType')  
 -- begin  
 --  set @WhereClause= @WhereClause +' And (ManufacturerType=''Retail'' OR ManufacturerType=''Wholesale'')';  
 -- end  
    
 print @BaseQuery  
 EXECUTE sp_executesql @BaseQuery,N'@FilterParams nvarchar(max),@FilterBy nvarchar(50),@ManufacturerType nvarchar(20),@VendorCategoryId nvarchar(10),@VendorStatus nvarchar(20)',
       @FilterParams,@FilterBy,@ManufacturerType,@VendorCategoryId,@VendorStatus 
END  
  



