--Author: Kapil Pancholi  
create procedure GetRootTasks  
(@TaskId int)  
as  
begin  
 select  TaskId,InstallId+' - '+Title as Title from tblTask  
 where ParentTaskId is null  
 and TaskId <> @TaskId  
end

GO

--Author: Kapil Pancholi
CREATE PROCEDURE USP_GetTasksByRoot
(@TaskId INT)
AS
BEGIN
	SELECT TaskId,InstallId+' - '+Title AS Title FROM tblTask
	WHERE ParentTaskId = @TaskId
END

GO

alter table tblTaskMultilevelList
add StartDate datetime
alter table tblTaskMultilevelList
add EndDate datetime
alter table tblTaskMultilevelList
add EstimatedHoursITLead int
alter table tblTaskMultilevelList
add EstimatedHoursUser int
alter table tblTaskMultilevelList
add DateCreated datetime,
DateUpdatedITLead datetime,
DateUpdatedUser datetime 
alter table [tblTaskMultilevelList]
add ITLeadId int, UserId int
alter table tblTaskMultilevelList
add [Status] int
GO

--Kapil Pancholi  
alter procedure sp_AddMultiLevelChlild  
@ParentTaskId int,@InstallId varchar(max),@Description varchar(MAX),@IndentLevel int,@Class varchar(50)  
as  
insert into tblTaskMultilevelList  
values  
(@ParentTaskId ,@InstallId ,@Description ,@IndentLevel ,@Class,null,null,null,null,getDate(),getDate(),null,null)

GO
create procedure usp_FreezeFeedbackTask
(@TaskId int, @StartDate datetime, @EndDate datetime, @EstimatedHours int, @IsITLead bit, @UId int)
as
begin
	if @IsITLead=1
	begin
		update tblTaskMultilevelList
		set EstimatedHoursITLead=@EstimatedHours,
			StartDate=@StartDate,
			EndDate=@EndDate,
			DateUpdatedITLead=getDate(),
			ITLeadId = @UId
		where Id=@TaskId
	end
	else
	begin
		update tblTaskMultilevelList
		set EstimatedHoursUser=@EstimatedHours,
			StartDate=@StartDate,
			EndDate=@EndDate,
			DateUpdatedUser=getDate(),
			UserId=@UId
		where Id=@TaskId
	end
end

GO

alter procedure sp_GetMultiLevelList 
@ParentTaskId varchar(max)  
as  
begin
	select m.*, (u.FristName + ' ' + u.LastName) as ITLeadName
			  , (u1.FristName + ' ' + u1.LastName) as UserName
	 from tblTaskMultilevelList m 
	left join tblInstallUsers u on
	m.ITLeadId = u.Id
	left join tblInstallUsers u1 on
	m.UserId = u1.Id
	where ParentTaskId in   
	(SELECT * FROM [dbo].[SplitString](ISNULL(@ParentTaskId,m.ParentTaskId),',') )
end

GO

CREATE PROCEDURE usp_GetCalendarTasksByDate      
(  
@StartDate datetime,   
@EndDate datetime,  
@DesignationIds VARCHAR(200) = NULL,                                           
@TaskStatus VARCHAR(100) = NULL,          
@UserStatus VARCHAR(100) = NULL,  
@UserIds varchar(100) = NULL  
)      
AS      
BEGIN      
         
IF( @DesignationIds = '' )                              
BEGIN                              
                              
 SET @DesignationIds = NULL                              
                              
END          
IF( @TaskStatus = '' )                              
BEGIN                              
                              
 SET @TaskStatus = NULL                              
                              
END          
IF( @UserStatus = '' )                              
BEGIN                              
                              
 SET @UserStatus = NULL                              
                              
END          
IF( @UserIds = '' )                              
BEGIN                              
                              
 SET @UserIds = NULL                              
                              
END           
        
 SELECT a.TaskId, t.Title ,a.StartDate,a.EndDate+1 as EndDate, ParentTaskId,a.UserId,      
       
 CASE t.Status      
 When 2 THEN 'YELLOW'      
 When 3 THEN 'YELLOW'      
 When 4 THEN 'ORANGE'      
 When 5 THEN 'YELLOW'      
 When 6 THEN 'YELLOW'      
 When 7 THEN 'BLACK'      
 When 8 THEN 'lightgray'      
 When 9 THEN 'GRAY'      
 When 10 THEN 'YELLOW'      
 When 11 THEN 'YELLOW'      
 When 12 THEN 'RED'      
 When 13 THEN 'RED'      
 When 14 THEN 'GREEN'      
 END AS Status      
 ,      
 CASE t.Status      
 When 2 THEN 'BLACK'      
 When 3 THEN 'BLACK'      
 When 4 THEN 'WHITE'      
 When 5 THEN 'BLACK'      
 When 6 THEN 'BLACK'      
 When 7 THEN 'WHITE'      
 When 8 THEN 'BLACK'      
 When 9 THEN 'WHITE'      
 When 10 THEN 'BLACK'      
 When 11 THEN 'BLACK'      
 When 12 THEN 'WHITE'      
 When 13 THEN 'WHITE'      
 When 14 THEN 'WHITE'      
 END AS TextColor      
 ,      
 case                                 
   when (ParentTaskId is null and  TaskLevel=1) then t.InstallId                                 
   when (tasklevel =1 and ParentTaskId>0) then                                 
    (select installid from tbltask where taskid=t.parenttaskid) +'-'+t.InstallId                                  
   when (tasklevel =2 and ParentTaskId>0) then                                
    (select InstallId from tbltask where taskid in (                                
   (select parentTaskId from tbltask where   taskid=t.parenttaskid) ))                                
   +'-'+ (select InstallId from tbltask where   taskid=t.parenttaskid) + '-' +t.InstallId                                 
                                     
   when (tasklevel =3 and ParentTaskId>0) then                                
   (select InstallId from tbltask where taskid in (                                
   (select parenttaskid from tbltask where taskid in (                                
   (select parentTaskId from tbltask where   taskid=t.parenttaskid) ))))                                
   +'-'+                                
    (select InstallId from tbltask where taskid in (                                
   (select parentTaskId from tbltask where   taskid=t.parenttaskid) ))                                
   +'-'+ (select InstallId from tbltask where   taskid=t.parenttaskid) + '-' +t.InstallId                                 
 end as 'InstallId'      
 ,      
 (STUFF((      
     SELECT ', ' + inu.FristName + ' ' + inu.LastName + ' - ' + inu.UserInstallId      
     FROM [tblTaskApprovals] tapp join tblInstallUsers inu on tapp.UserId=inu.Id      
     Where tapp.TaskId = a.TaskId      
     FOR XML PATH('')      
     ), 1, 2, '')      
    ) AS AssignedUsers      
      
 FROM [dbo].[tblTaskApprovals] a      
       
 JOIN tblTask t on t.TaskId=a.TaskId      
 JOIN tbltaskassignedusers as tau ON a.TaskId = tau.TaskId  
 JOIN tblInstallUsers as iu ON tau.[UserId] = iu.[Id]  
  
 WHERE a.StartDate BETWEEN @StartDate AND @EndDate OR a.EndDate BETWEEN @StartDate AND @EndDate      
 --AND a.[UserId] in (SELECT * FROM [dbo].[SplitString](ISNULL(@userid,a.[UserId]),','))      
 AND (t.[SequenceDesignationId] IN (SELECT * FROM [dbo].[SplitString](ISNULL(@DesignationIds,t.[SequenceDesignationId]),',') ) )                                   
 AND t.[Status] in (SELECT * FROM [dbo].[SplitString](ISNULL(@TaskStatus,t.[Status]),','))               
 AND iu.[Status] in( SELECT * FROM [dbo].[SplitString](ISNULL(@UserStatus,iu.[Status]),','))            
 AND iu.[Id] in ( SELECT * FROM [dbo].[SplitString](ISNULL(@UserIds,iu.[Id]),','))           
END 

GO

CREATE TABLE [dbo].[tblTaskMultiLevelAssignedUsers](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[TaskId] [int] NULL,
	[UserId] [int] NULL,
	[CreatedDate] [datetime] NULL,
 CONSTRAINT [PK_tblTaskMultiLevelAssignedUsers] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO

--FOR Sequencing popup upgrade  
CREATE PROCEDURE [dbo].[usp_InsertTaskAssignedUsersRoman]  
(     
 @TaskId int ,     
 @UserIds VARCHAR(4000)     
)    
AS    
BEGIN    
     
	-- delete users, which are not in provided new user list.    
	DELETE     
	FROM  [tblTaskMultiLevelAssignedUsers]  
	WHERE     
	 TaskId = @TaskId   
    
	-- insert users, which are not already present in database but are provided in new user list.    
	INSERT INTO [tblTaskMultiLevelAssignedUsers]  
	SELECT @TaskId , CAST(ss.Item AS BIGINT)   , getDate() 
	FROM dbo.SplitString(@UserIds,',') ss  
   
   --Set TaskStatus to Assigned-Requested:3
   UPDATE tblTaskMultilevelList SET [Status]=3 WHERE Id = @TaskId
END

GO

ALTER procedure [dbo].[sp_GetMultiLevelList]
@ParentTaskId varchar(max)  
as  
begin
	select m.*, (u.FristName + ' ' + u.LastName) as ITLeadName
			  , (u1.FristName + ' ' + u1.LastName) as UserName,
			  (
			  STUFF((SELECT ', {"Id" : "'+ CONVERT(VARCHAR(5),UserId) + '"}'                                  
           FROM tblTaskMultiLevelAssignedUsers as tau                  
           WHERE tau.TaskId = m.Id                                     
          FOR XML PATH('')), 1, 2, '')                                    
  ) AS TaskAssignedUserIDs         
	 from tblTaskMultilevelList m 
	left join tblInstallUsers u on
	m.ITLeadId = u.Id
	left join tblInstallUsers u1 on
	m.UserId = u1.Id
	where ParentTaskId in   
	(SELECT * FROM [dbo].[SplitString](ISNULL(@ParentTaskId,m.ParentTaskId),',') )
end

GO

alter table tblTaskMultilevelList
add DisplayOrder int

GO

--Kapil Pancholi    
alter procedure sp_AddMultiLevelChlild    
@ParentTaskId int,@InstallId varchar(max),@Description varchar(MAX),@IndentLevel int,@Class varchar(50)    
as
begin    
	declare @DisplayOrder int
	set @DisplayOrder = (select max(DisplayOrder) from tblTaskMultilevelList where ParentTaskId=@ParentTaskId)+1
	insert into tblTaskMultilevelList    
	values (@ParentTaskId ,@InstallId ,@Description ,@IndentLevel ,@Class,null,null,null,null,getDate(),getDate(),null,null,null,@DisplayOrder)
end

GO

ALTER procedure [dbo].[usp_SwapRomans]
(
	@FirstRomanId int,
	@SecondRomanId int
)
as
begin
	declare @DOFirst int
	declare @DOSecond int
	declare @LabelFirst varchar(max)
	declare @LabelSecond varchar(max)
	declare @ParentTaskId int

	select @DOFirst=DisplayOrder,@LabelFirst=Label,@ParentTaskId=ParentTaskId from tblTaskMultilevelList where id=@FirstRomanId
	select @DOSecond=DisplayOrder,@LabelSecond=Label from tblTaskMultilevelList where id=@SecondRomanId

	--Update DisplayOrder & Label
	update tblTaskMultilevelList set DisplayOrder=@DOSecond,Label=@LabelSecond where id = @FirstRomanId
	update tblTaskMultilevelList set DisplayOrder=@DOFirst,Label=@LabelFirst where id = @SecondRomanId	

	select * into #tempChild1 from tblTaskMultiLevelList where ParentTaskId=@ParentTaskId order by DisplayOrder

create table #Childs1
(Id int, Label varchar(10), Indent int, DisplayOrder int)
create table #Childs2
(Id int, Label varchar(10), Indent int, DisplayOrder int)

	declare @id int declare @Indent int
	declare @FirstFound bit
	
	--Get children for First Roman
	set @FirstFound=0
	while exists(select id from #tempChild1)
	begin
		select top 1 @id=id,@Indent=IndentLevel from #tempChild1
		if @id=@FirstRomanId
		begin
			set @FirstFound = 1
			delete from #tempChild1 where id=@id
		end		

		if @FirstFound = 1
		begin			
			insert into #Childs1 select Id,Label,IndentLevel,DisplayOrder from #tempChild1 where id=@id and IndentLevel<>1
			if @Indent=1 and @id<>@FirstRomanId
				break;			
		end		
		delete from #tempChild1 where id=@id
	end

	--select * from #Childs1	
	drop table #tempChild1	
	

	--Get children for Second Roman
	select * into #tempChild2 from tblTaskMultiLevelList where ParentTaskId=@ParentTaskId order by DisplayOrder
	set @FirstFound=0	
	while exists(select id from #tempChild2)
	begin
		select top 1 @id=id,@Indent=IndentLevel from #tempChild2
		if @id=@SecondRomanId
		begin
			set @FirstFound = 1
			delete from #tempChild2 where id=@id
		end		

		if @FirstFound = 1
		begin			
			insert into #Childs2 select Id,Label,IndentLevel,DisplayOrder from #tempChild2 where id=@id and IndentLevel<>1
			if @Indent=1 and @id<>@SecondRomanId
				break;			
		end		
		delete from #tempChild2 where id=@id
	end

	--select * from #Childs2	
	drop table #tempChild2


	declare @SCDO int --FirstChildDisplayOrder
	set @SCDO = (select top 1 DisplayOrder-1 from #Childs2)
	declare @FCDO int --FirstChildDisplayOrder
	set @FCDO = (select top 1 DisplayOrder-1 from #Childs1)

	--Change order for First Roman Children
	update tblTaskMultilevelList set DisplayOrder = @SCDO, @SCDO = @SCDO + 1
	where Id in (select Id from #Childs1)
	--select * from #Childs1
	--Change order for Second Roman Children
	
	update tblTaskMultilevelList set DisplayOrder = @FCDO, @FCDO = @FCDO + 1
	where Id in (select Id from #Childs2)
	--select * from #Childs2

	drop table #Childs1
	drop table #Childs2

end

GO

create procedure usp_UpdateRomanTaskStatus
(
@TaskId int,
@TaskStatus int
)
as
begin
	update tblTaskMultilevelList set [Status] = @TaskStatus where Id = @TaskId
end

GO

alter procedure sp_AddMultiLevelChlild      
@ParentTaskId int,@InstallId varchar(max),@Description varchar(MAX),@IndentLevel int,@Class varchar(50)      
as  
begin      
 declare @DisplayOrder int  
 set @DisplayOrder = (select max(DisplayOrder) from tblTaskMultilevelList where ParentTaskId=@ParentTaskId)+1  
 insert into tblTaskMultilevelList      
 values (@ParentTaskId ,@InstallId ,@Description ,@IndentLevel ,@Class,null,null,null,null,getDate(),getDate(),null,null,null,@DisplayOrder,0)  
end

GO

create procedure usp_GetFreezedRomanData
(
@RomanId bigint
)
as
begin

	select EstimatedHoursITLead,EstimatedHoursUser,
			ITLeadId,UserId,
			DateUpdatedITLead,DateUpdatedUser,
			(select FristName + ' ' + LastName from tblInstallUsers where Id=ITLeadId) as ITLeadName,
			(select FristName + ' ' + LastName from tblInstallUsers where Id=UserId) as UserName
	from tblTaskMultilevelList m
	where m.Id=@RomanId
end

GO

alter procedure usp_GetCalenderUsersByDate  
(  
@Date varchar(max),  
@TaskStatus VARCHAR(100) = NULL,            
@UserStatus VARCHAR(100) = NULL,  
@UserIds VARCHAR(100) = NULL  
)    
as    
begin  
 IF( @TaskStatus = '' )                                
 BEGIN                                                              
  SET @TaskStatus = NULL                                                              
 END            
 IF( @UserStatus = '' )                                
 BEGIN                                                              
  SET @UserStatus = NULL                                                              
 END            
 IF( @UserIds = '' )                                
 BEGIN                                                              
  SET @UserIds = NULL                                                              
 END   
  
 create table #Users (UserId int, Picture varchar(max))    

 insert into #Users    
 select UserId,Picture from [tblTaskApprovals]  tapp    
 join tblInstallUsers tiu on tapp.UserId = tiu.Id    
 join tblTask t on t.TaskId = tapp.TaskId  
 where (cast(@Date as Date) between cast(tapp.StartDate as Date) and cast(tapp.EndDate as Date))  
 AND tiu.[Status] in (SELECT * FROM [dbo].[SplitString](ISNULL(@UserStatus,tiu.[Status]),','))  
 AND t.[Status] in (SELECT * FROM [dbo].[SplitString](ISNULL(@TaskStatus,t.[Status]),','))  
 --AND tiu.[Id] in ( SELECT * FROM [dbo].[SplitString](ISNULL(@UserIds,tiu.[Id]),','))              
  
 select * from #Users    
 drop table #Users    
end 

GO

alter PROCEDURE usp_GetCalendarTasksByDate          
(      
@StartDate datetime,       
@EndDate datetime,      
@DesignationIds VARCHAR(200) = NULL,                                               
@TaskStatus VARCHAR(100) = NULL,              
@UserStatus VARCHAR(100) = NULL,      
@UserIds varchar(100) = NULL      
)          
AS          
BEGIN          
             
IF( @DesignationIds = '' )                                  
BEGIN                                  
                                  
 SET @DesignationIds = NULL                                  
                                  
END              
IF( @TaskStatus = '' )                                  
BEGIN                                  
                                  
 SET @TaskStatus = NULL                                  
                                  
END              
IF( @UserStatus = '' )                                  
BEGIN                                  
                                  
 SET @UserStatus = NULL                                  
                                  
END              
IF( @UserIds = '' )                                  
BEGIN                                  
                                  
 SET @UserIds = NULL                                  
                                  
END               
            
 SELECT a.TaskId, t.Title ,a.StartDate, a.EndDate, ParentTaskId,a.UserId,                 
 CASE t.Status When 2 THEN 'YELLOW' When 3 THEN 'YELLOW' When 4 THEN 'ORANGE' When 5 THEN 'YELLOW' When 6 THEN 'YELLOW' When 7 THEN 'BLACK' When 8 THEN 'lightgray' When 9 THEN 'GRAY'          
 When 10 THEN 'YELLOW'       When 11 THEN 'YELLOW'       When 12 THEN 'RED'       When 13 THEN 'RED'       When 14 THEN 'GREEN'       END AS Status          
 ,          
 CASE t.Status       When 2 THEN 'BLACK'       When 3 THEN 'BLACK'       When 4 THEN 'WHITE'       When 5 THEN 'BLACK'       When 6 THEN 'BLACK'       When 7 THEN 'WHITE'       When 8 THEN 'BLACK'          
 When 9 THEN 'WHITE'       When 10 THEN 'BLACK'       When 11 THEN 'BLACK'       When 12 THEN 'WHITE'       When 13 THEN 'WHITE'       When 14 THEN 'WHITE'       END AS TextColor          
 ,          
 case                                     
   when (ParentTaskId is null and  TaskLevel=1) then t.InstallId                                     
   when (tasklevel =1 and ParentTaskId>0) then                                     
    (select installid from tbltask where taskid=t.parenttaskid) +'-'+t.InstallId                                      
   when (tasklevel =2 and ParentTaskId>0) then                                    
    (select InstallId from tbltask where taskid in (                                    
   (select parentTaskId from tbltask where   taskid=t.parenttaskid) ))                                    
   +'-'+ (select InstallId from tbltask where   taskid=t.parenttaskid) + '-' +t.InstallId                                     
                                         
   when (tasklevel =3 and ParentTaskId>0) then                                    
   (select InstallId from tbltask where taskid in (                                    
   (select parenttaskid from tbltask where taskid in (                                    
   (select parentTaskId from tbltask where   taskid=t.parenttaskid) ))))                                    
   +'-'+                                    
    (select InstallId from tbltask where taskid in (                                    
   (select parentTaskId from tbltask where   taskid=t.parenttaskid) ))                                    
   +'-'+ (select InstallId from tbltask where   taskid=t.parenttaskid) + '-' +t.InstallId                                     
 end as 'InstallId'          
 ,          
 (STUFF((          
     SELECT ', ' + inu.FristName + ' ' + inu.LastName + ' - ' + inu.UserInstallId          
     FROM [tblTaskApprovals] tapp join tblInstallUsers inu on tapp.UserId=inu.Id          
     Where tapp.TaskId = a.TaskId          
     FOR XML PATH('')          
     ), 1, 2, '')          
    ) AS AssignedUsers          
          
 FROM [dbo].[tblTaskApprovals] a          
           
 JOIN tblTask t on t.TaskId=a.TaskId          
 JOIN tbltaskassignedusers as tau ON a.TaskId = tau.TaskId      
 JOIN tblInstallUsers as iu ON tau.[UserId] = iu.[Id]      
      
 WHERE (cast(a.StartDate as Date) BETWEEN cast(@StartDate as Date) AND cast(@EndDate as Date)
  OR cast(a.EndDate as Date) BETWEEN cast(@StartDate as Date) AND cast(@EndDate as Date))    
 --AND a.[UserId] in (SELECT * FROM [dbo].[SplitString](ISNULL(@userid,a.[UserId]),','))          
 AND (t.[SequenceDesignationId] IN (SELECT * FROM [dbo].[SplitString](ISNULL(@DesignationIds,t.[SequenceDesignationId]),',') ) )                                        
 AND iu.[Status] in( SELECT * FROM [dbo].[SplitString](ISNULL(@UserStatus,iu.[Status]),','))                
 AND iu.[Id] in ( SELECT * FROM [dbo].[SplitString](ISNULL(@UserIds,iu.[Id]),','))               
 AND t.[Status] in ( SELECT * FROM [dbo].[SplitString](ISNULL(@TaskStatus,t.[Status]),','))               
END     
    
    
GO

alter procedure usp_GetFreezedRomanData  
(  
@RomanId bigint  
)  
as  
begin  
  
 select EstimatedHoursITLead,EstimatedHoursUser,  
   ITLeadId,UserId,  
   DateUpdatedITLead,DateUpdatedUser,  
   (select FristName + ' ' + LastName from tblInstallUsers where Id=ITLeadId) as ITLeadName,  
   (select FristName + ' ' + LastName from tblInstallUsers where Id=UserId) as UserName,
   [Status]
 from tblTaskMultilevelList m  
 where m.Id=@RomanId  
end

GO

alter table tblTaskMultiLevelList

add Title varchar(max), DateUpdated datetime, UpdatedByUserId bigint

GO

--Kapil Pancholi        
alter procedure sp_AddMultiLevelChlild        
@ParentTaskId int,@InstallId varchar(max), @Title varchar(max), @Description varchar(MAX),@IndentLevel int,@Class varchar(50)        
as    
begin        
 declare @DisplayOrder int    
 set @DisplayOrder = (select max(DisplayOrder) from tblTaskMultilevelList where ParentTaskId=@ParentTaskId)+1    
 insert into tblTaskMultilevelList        
 values (@ParentTaskId ,@InstallId ,@Title ,@Description ,@IndentLevel ,@Class,null,null,null,null,getDate(),getDate(),null,null,null,@DisplayOrder,0)    
end

GO

-- sp_GetMultiLevelList 523  
alter procedure [dbo].[sp_GetMultiLevelList]       
@ParentTaskId varchar(max)        
as        
begin      
 select m.*, (u.FristName + ' ' + u.LastName) as ITLeadName      
     , (u1.FristName + ' ' + u1.LastName) as UserName,      
	 (u2.FristName + ' ' + u2.LastName) as UpdatedBy,
     (      
     STUFF((SELECT ', {"Id" : "'+ CONVERT(VARCHAR(5),UserId) + '"}'                                        
           FROM tblTaskMultiLevelAssignedUsers as tau                        
           WHERE tau.TaskId = m.Id                                           
          FOR XML PATH('')), 1, 2, '')                                          
  ) AS TaskAssignedUserIDs,  
  UCG.Id As UserChatGroupId  
  from tblTaskMultilevelList m       
  left join tblInstallUsers u on      
  m.ITLeadId = u.Id      
  left join tblInstallUsers u1 on      
  m.UserId = u1.Id      
  left join tblInstallUsers u2 on
  m.UpdatedByUserId = u2.Id
  Left Join UserChatGroup UCG on m.Id = UCG.TaskMultilevelListId And m.ParentTaskId = UCG.TaskId  
 where ParentTaskId in (SELECT * FROM [dbo].[SplitString](ISNULL(@ParentTaskId,m.ParentTaskId),',') )      
 order by DisplayOrder    
end  

GO

CREATE PROCEDURE [UpdateRomanTitle]  
 @RomanId bigint,    
 @Title varchar(max)    
AS    
BEGIN    
    
 SET NOCOUNT ON;    
    
 UPDATE tblTaskMultilevelList    
 SET     
  [Title] = @Title
      
 WHERE Id = @RomanId    
    
END 

GO

CREATE PROCEDURE [UpdateRomanTitle]  
 @RomanId bigint,    
 @Title varchar(max)    
AS    
BEGIN    
    
 SET NOCOUNT ON;    
    
 UPDATE tblTaskMultilevelList    
 SET     
  [Title] = @Title
      
 WHERE Id = @RomanId    
    
END 