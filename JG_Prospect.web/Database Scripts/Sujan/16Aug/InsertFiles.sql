Alter Procedure InsertFiles    
(    
@Name nvarchar(100) = NULL,    
@UniqueName nvarchar(100) = NULL,    
@FolderId int = NULL,    
@ModifiedBy int = NULL,    
@ModifiedDate Datetime = getdate,    
@DesignationId int = NULL,    
@ResourceTypeId int = NULL,    
@LocationId int = NULL    
)    
As    
Begin    
 Declare @FileId int    
  declare @displayorder int   
  set @displayorder = (select Max(DisplayOrder) from Files)  
  set @displayorder = isnull(@displayorder,0) + 1  
 Insert into Files    
 Values    
 (    
 @Name,    
 @UniqueName,    
 @FolderId,    
 @ModifiedBy,    
 @ModifiedDate,  
 @displayorder   
 )    
    
 Select @FileId = SCOPE_IDENTITY()    
    
 Insert into DesignationFiles    
 Values    
 (    
 @DesignationId,    
 @ResourceTypeId,    
 @LocationId,    
 @FileId    
 )    
 Select @FileId as result    
End     
    
    