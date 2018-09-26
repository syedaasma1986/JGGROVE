--GetFilesTM 1    
Alter procedure dbo.GetFilesTM      
(         
 @locationid int        
)        
As        
Begin        
 declare @tempDesig table(DesignationId int,DesignationName varchar(200))        
 declare @tempFolder table(FolderId int,Name varchar(200),Designationid int)        
 declare @tempDesig1 table(DesignationId int,DesignationName varchar(200))        
 declare @tempFolder1 table(FolderId int,Name varchar(200),Designationid int)        
     
 declare @tempFiles table(RowId int,ID int,Name varchar(200),UniqueName varchar(200),ResourceTypeId int,FolderId int,FolderName varchar(200),        
  DesignationId int,DesignationName varchar(200),LocationId int,DisplayOrder int)        
        
 insert into @tempDesig         
 select distinct t1.ID as DesignationId,t1.DesignationName from tbl_Designation t1        
 inner join Folders t2 on t1.ID = t2.DesignationId where IsActive =1     
 and t2.LocationId = @locationid   
  
 insert into @tempDesig1    
 select distinct t1.ID as DesignationId,t1.DesignationName from tbl_Designation t1        
 inner join Folders t2 on t1.ID = t2.DesignationId where IsActive =1     
 and t2.LocationId = @locationid    
  
declare @RowId int=1        
 declare @dcount int = (select count(DesignationId) from @tempDesig)        
 while((select count(DesignationId) from @tempDesig) > 0)        
 Begin        
  declare @topdid int = (select top 1 DesignationId from @tempDesig)        
  declare @DesignationName varchar(200) = (select top 1 DesignationName from @tempDesig)        
  insert into @tempFolder        
  select ID,Name,DesignationId from Folders where Designationid = @topdid and LocationId = @locationid order by DisplayOrder        
      
  insert into @tempFolder1        
  select ID,Name,DesignationId from Folders where Designationid = @topdid and LocationId = @locationid order by DisplayOrder        
      
  while((select count(FolderId) from @tempFolder) > 0)        
  Begin        
   declare @topfolderid int = (select top 1 FolderId from @tempFolder)        
   declare @FolderName varchar(200) = (select top 1 Name from @tempFolder)        
        
   insert into @tempFiles         
   select @RowId,f.ID,Name,UniqueName,df.ResourceTypeId,FolderId,@FolderName,@topdid,@DesignationName,@locationid,f.DisplayOrder         
   from Files f        
   inner join DesignationFiles df on f.ID = df.FileId        
   where FolderId = @topfolderid and df.LocationId = @locationid order by DisplayOrder        
       
   set @RowId = @RowId + 1     
   delete from @tempFolder where FolderId = @topfolderid        
  End        
  delete from @tempDesig where DesignationId = @topdid      
 End        
         
 select distinct * from @tempFiles order by RowId,DisplayOrder     
     
 select * from @tempFolder1    
     
 select * from @tempDesig1     
End