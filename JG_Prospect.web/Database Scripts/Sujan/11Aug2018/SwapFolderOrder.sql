CREATE procedure SwapFolderOrder  
(  
 @currentfolderid int,  
 @folderToSwapid int  
)  
As  
Begin  
 declare @currentfolderidDisplayOrder int   
 declare @folderToSwapidDisplayOrder int   
 set @currentfolderidDisplayOrder = (select top 1 DisplayOrder from Folders where ID = @currentfolderid)  
 set @folderToSwapidDisplayOrder = (select top 1 DisplayOrder from Folders where ID = @folderToSwapid)  
 Update Folders set DisplayOrder = @folderToSwapidDisplayOrder where ID = @currentfolderid  
 Update Folders set DisplayOrder = @currentfolderidDisplayOrder where ID = @folderToSwapid  
End  