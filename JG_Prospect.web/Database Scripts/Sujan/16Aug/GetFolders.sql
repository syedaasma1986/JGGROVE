Alter Procedure GetFolders  
(  
@DesignationId int = NULL,
@locationid int = NULL  
)  
As  
Begin  
 Select * from FOlders Where DesignationId = @DesignationId and LocationId = @locationid 
End