CREATE procedure dbo.GetFilesTM  
(  
 @locationid int  
)  
As  
Begin  
 declare @tempDesig table(DesignationId int,DesignationName varchar(200))  
 declare @tempFolder table(FolderId int,Name varchar(200),Designationid int)  
 declare @tempFiles table(ID int,Name varchar(200),UniqueName varchar(200),ResourceTypeId int,FolderId int,FolderName varchar(200),  
  DesignationId int,DesignationName varchar(200),LocationId int)  
  
 insert into @tempDesig   
 select t1.ID as DesignationId,t1.DesignationName from tbl_Designation t1  
 inner join Folders t2 on t1.ID = t2.DesignationId where IsActive =1  
  
 declare @dcount int = (select count(DesignationId) from @tempDesig)  
 while(@dcount > 0)  
 Begin  
  declare @topdid int = (select top 1 DesignationId from @tempDesig)  
  declare @DesignationName varchar(200) = (select top 1 DesignationName from @tempDesig)  
  insert into @tempFolder  
  select ID,Name,DesignationId from Folders where Designationid = @topdid order by DisplayOrder  
    
  declare @foldercount int = (select count(FolderId) from @tempFolder)  
  while(@foldercount > 0)  
  Begin  
   declare @topfolderid int = (select top 1 FolderId from @tempFolder)  
   declare @FolderName varchar(200) = (select top 1 Name from @tempFolder)  
  
   insert into @tempFiles   
   select f.ID,Name,UniqueName,df.ResourceTypeId,FolderId,@FolderName,@topdid,@DesignationName,@locationid   
   from Files f  
   inner join DesignationFiles df on f.ID = df.FileId  
   where FolderId = @topfolderid and df.LocationId = @locationid order by DisplayOrder  
  
   set @foldercount = @foldercount - 1  
  End  
  set @dcount = @dcount - 1  
 End  
   
 select * from @tempFiles  
End