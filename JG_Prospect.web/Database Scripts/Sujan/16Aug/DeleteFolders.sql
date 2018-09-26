--    
Alter Procedure [dbo].[DeleteFolders]    
(    
@FolderId int,  
@locationid int   
)    
As    
Begin    
 Declare @Name nvarchar(50)    
 Select @Name = Name  from Folders    
 Where Id = @FolderId    
    
 Delete From DesignationFiles    
 Where FileId in (Select Id From Files     
 Where FolderId = @FolderId)    
    
 Delete From Files     
 Where FolderId = @FolderId    
    
 Delete From Folders    
 Where Id = @FolderId   and LocationId = @locationid  
    
 Select @Name    
End    
    