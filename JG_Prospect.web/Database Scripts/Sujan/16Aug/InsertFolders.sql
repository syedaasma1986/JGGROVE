    
ALTER Procedure InsertFolders      
(      
 @Name nvarchar(100) = NULL, 
 @locationid int = NULL,     
 @DesignationId int = NULL,      
 @ModifiedBy int = NULL,      
 @ModifiedDate Datetime = getdate,    
 @FolderId  int OUTPUT      
)      
As      
Begin      
 if Exists(Select 1 from folders where name = @Name and designationId = @DesignationId)      
 Begin      
  Select @FolderId = ID  from folders where name = @Name and designationId = @DesignationId    
 End      
 Else      
 Begin    
 declare @displayorder int  
 set @displayorder = (select max(DisplayOrder) from Folders)  
 set @displayorder = isnull(@displayorder,0) + 1  
  Insert into Folders      
  Values      
  (      
  @Name,      
  @DesignationId,      
  @ModifiedBy,      
  @ModifiedDate,      
  @displayorder,
  @locationid  
  )      
      
  Select @FolderId = Scope_Identity()    
        
 End   
   
End 