--usp_GetCalenderUsersByDate '2018-04-20'    
ALTER procedure usp_GetCalenderUsersByDate                
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
                
 create table #Users (UserId int, Picture varchar(max), FullName varchar(max))                  
              
 insert into #Users                  
 select UserId,Picture,(FristName + ' ' + LastName +'('+UserInstallId+')') as FullName from [tblTaskApprovals]  tapp                  
 join tblInstallUsers tiu on tapp.UserId = tiu.Id                  
 join tblTask t on t.TaskId = tapp.TaskId                
 where (cast(@Date as Date) between cast(tapp.StartDate as Date) and cast(tapp.EndDate as Date))                
 AND tiu.[Status] in (SELECT * FROM [dbo].[SplitString](ISNULL(@UserStatus,tiu.[Status]),','))                
 AND t.[Status] in (SELECT * FROM [dbo].[SplitString](ISNULL(@TaskStatus,t.[Status]),','))                
 --AND tiu.[Id] in ( SELECT * FROM [dbo].[SplitString](ISNULL(@UserIds,tiu.[Id]),','))        
        
  insert into #Users        
  select tiu.Id,tiu.Picture,(FristName + ' ' + LastName +'('+UserInstallId+')') as FullName from tblTaskMultiLevelList M        
  join tblTaskMultiLevelAssignedUsers MU on M.Id = MU.TaskId        
 join tblInstallUsers tiu on MU.UserId = tiu.Id        
 where (cast(@Date as Date) between cast(M.StartDate as Date) and cast(M.EndDate as Date))                
 AND tiu.[Status] in (SELECT * FROM [dbo].[SplitString](ISNULL(@UserStatus,tiu.[Status]),','))                
 AND M.[Status] in (SELECT * FROM [dbo].[SplitString](ISNULL(@TaskStatus,M.[Status]),','))           
                
 select distinct * from #Users where [UserId] in (SELECT * FROM [dbo].[SplitString](ISNULL(@UserIds,[UserId]),','))            
 drop table #Users                  
end 

GO

--sp_helptext usp_GetCalendarTasksByDate      '2018-04-22','2018-04-25','8,9,10,11,12,13,24,25,26,27','4,3','1',''
--sp_helptext usp_GetCalenderUsersByDate '2018-04-20','4,3','1','3697,901,3797'

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
IF @StartDate IS NULL Begin Set @StartDate = '01/01/2000'          End          
                             
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
IF OBJECT_ID('tempdb..#Tasks') IS NOT NULL DROP TABLE #Tasks             
 Create Table #Tasks(TaskId int, Title varchar(max), StartDate datetime, EndDate datetime, ParentTaskId int,      
 UserId int, [Status] varchar(max), TextColor varchar(max), InstallId varchar(200), AssignedUsers Varchar(max), IsRoman bit, MainTaskId int)       
insert into #Tasks      
      
 SELECT a.TaskId, t.Title ,a.StartDate, a.EndDate+1, ParentTaskId,a.UserId,                                 
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
    ) AS AssignedUsers, 0, 0                          
      
 FROM [dbo].[tblTaskApprovals] a                          
                           
 JOIN tblTask t on t.TaskId=a.TaskId                          
 JOIN tbltaskassignedusers as tau ON a.TaskId = tau.TaskId                      
 JOIN tblInstallUsers as iu ON tau.[UserId] = iu.[Id]                      
                      
 WHERE     
  a.StartDate >= cast(@StartDate as Date) and a.StartDate <= cast(@EndDate as Date) OR     
 a.EndDate >= cast(@StartDate as Date) and a.StartDate <= cast(@EndDate as Date)                   
 --AND a.[UserId] in (SELECT * FROM [dbo].[SplitString](ISNULL(@userid,a.[UserId]),','))                          
 AND (t.[SequenceDesignationId] IN (SELECT * FROM [dbo].[SplitString](ISNULL(@DesignationIds,t.[SequenceDesignationId]),',') ) )                                                        
 AND iu.[Status] in( SELECT * FROM [dbo].[SplitString](ISNULL(@UserStatus,iu.[Status]),','))                                
--AND iu.[Id] in ( SELECT * FROM [dbo].[SplitString](ISNULL(@UserIds,iu.[Id]),','))                               
 AND t.[Status] in ( SELECT * FROM [dbo].[SplitString](ISNULL(@TaskStatus,t.[Status]),','))                               
            
--select * from #Temp where UserId in ( SELECT * FROM [dbo].[SplitString](ISNULL(@UserIds,#Temp.[UserId]),','))          
  Declare @TitleMaxLen int = 0          
Select @TitleMaxLen = Max(Len(Title)) From #Tasks           
         
      
       
--print @TitleMaxLen          
--Insert Into #Temp          
Insert Into #Tasks      
Select M.Id as Id, SubString(ISNull(M.Title,SUBSTRING(M.[Description],0,@TitleMaxLen)+'...'),0,@TitleMaxLen+3) as Title, M.StartDate, M.EndDate+1, M.ParentTaskId, tmu.UserID,          
 CASE M.Status When 2 THEN 'YELLOW' When 3 THEN 'YELLOW' When 4 THEN 'ORANGE' When 5 THEN 'YELLOW' When 6 THEN 'YELLOW' When 7 THEN 'BLACK' When 8 THEN 'lightgray' When 9 THEN 'GRAY'                          
 When 10 THEN 'YELLOW'       When 11 THEN 'YELLOW'       When 12 THEN 'RED'       When 13 THEN 'RED'       When 14 THEN 'GREEN'       END AS Status                          
 ,                          
 CASE M.Status       When 2 THEN 'BLACK'       When 3 THEN 'BLACK'       When 4 THEN 'WHITE'       When 5 THEN 'BLACK'       When 6 THEN 'BLACK'       When 7 THEN 'WHITE'       When 8 THEN 'BLACK'                          
 When 9 THEN 'WHITE'       When 10 THEN 'BLACK'       When 11 THEN 'BLACK'       When 12 THEN 'WHITE'       When 13 THEN 'WHITE'       When 14 THEN 'WHITE'       END AS TextColor,          
 M.InstallId,       
 (STUFF((                          
     SELECT ', ' + inu.FristName + ' ' + inu.LastName + ' - ' + inu.UserInstallId                          
     FROM tblTaskMultiLevelAssignedUsers tapp join tblInstallUsers inu on tapp.UserId=inu.Id                          
     Where tapp.TaskId = M.Id                          
     FOR XML PATH('')                           ), 1, 2, '')                          
    ) AS AssignedUsers,1,(select ParentTaskId from tblTask where TaskId=M.ParentTaskId) as MainTaskId  
 From tblTaskMultiLevelList M       
 join tblTaskMultiLevelAssignedUsers tmu On M.Id = tmu.TaskId          
 Where       
        
 M.StartDate >= cast(@StartDate as Date) and M.StartDate <= cast(@EndDate as Date) OR     
 M.EndDate >= cast(@StartDate as Date) and M.StartDate <= cast(@EndDate as Date)        
            
  select * from #Tasks where UserId in ( SELECT * FROM [dbo].[SplitString](ISNULL(@UserIds,#Tasks.[UserId]),','))          
                   
END 

GO

--Freeze Process Step 1
create table tblTaskQueries
(
ID int identity(1,1),
TaskID int,
TaskInstallId varchar(max),
QueryDesc varchar(max),
QueryTypeID int,
QueryStatusID int,
CreatedByUserId int,
CreatedTimestamp datetime
)
GO
create table tblTaskQueryType
(
Id int identity(1,1),
TypeName varchar(50)
)
GO

create procedure usp_CreateTaskQuery
(@TaskId int, @QueryDesc varchar(max), @QueryTypeID int, @QueryStatusID int, @CreatedByUserId int)
as
begin
	declare @TaskInstallId varchar(max)
	declare @CreatedByTimestamp datetime
	declare @QueryCount int
	declare @QueryLabel varchar(10)

	if @QueryTypeID = 1 -- Business Query Count
	begin
		set @QueryCount = (select count(Id)+1 from tblTaskQueries where TaskId=@TaskId and QueryTypeID =1)
		set @QueryLabel = 'BQ'
	end

	if @QueryTypeID = 2 -- Technical Query Count
	begin
		set @QueryCount = (select count(Id)+1 from tblTaskQueries where TaskId=@TaskId and QueryTypeID =2)
		set @QueryLabel = 'TQ'
	end

	set @TaskInstallId = (select @QueryLabel + convert(varchar(50), @QueryCount) + '-' + 
	case                                       
	   when (x.ParentTaskId is null and  TaskLevel=1) then x.InstallId                                       
	   when (tasklevel =1 and x.ParentTaskId>0) then                                       
		(select installid from tbltask where taskid=x.parenttaskid) +'-'+x.InstallId                                        
	   when (tasklevel =2 and x.ParentTaskId>0) then                                      
		(select InstallId from tbltask where taskid in (                                      
	   (select parentTaskId from tbltask where   taskid=x.parenttaskid) ))                                      
	   +'-'+ (select InstallId from tbltask where   taskid=x.parenttaskid) + '-' +x.InstallId                                       
                                           
	   when (tasklevel =3 and x.ParentTaskId>0) then                                      
	   (select InstallId from tbltask where taskid in (                                      
	   (select parenttaskid from tbltask where taskid in (                   
	   (select parentTaskId from tbltask where   taskid=x.parenttaskid) ))))                                      
	   +'-'+                                      
		(select InstallId from tbltask where taskid in (                                      
	   (select parentTaskId from tbltask where   taskid=x.parenttaskid) ))                    
	   +'-'+ (select InstallId from tbltask where   taskid=x.parenttaskid) + '-' + x.InstallId                                       
	end
	
	+'-'+m.Label from tblTask x join tblTaskMultilevelList m on
	m.ParentTaskId=x.TaskId where m.Id=@TaskId)

	set @CreatedByTimestamp = (Select CONVERT(datetime, SWITCHOFFSET(getDate(), DATEPART(TZOFFSET, 
								getDate() AT TIME ZONE 'Eastern Standard Time'))))
	insert into tblTaskQueries
	values(@TaskId, @TaskInstallId, @QueryDesc, @QueryTypeID, @QueryStatusID, @CreatedByUserId, @CreatedByTimestamp)
end

GO

alter procedure usp_GetTaskQueries
(@TaskId int)
as
begin
	select (u.FristName + ' ' + u.LastName) as FullName, q.ID,q.TaskInstallId,
			q.QueryDesc,t.TypeName,q.CreatedTimestamp
	from tblTaskQueries q
	join tblTaskQueryType t on q.QueryTypeID = t.Id
	join tblInstallUsers u on q.CreatedByUserId = u.Id
end
--Freeze Process Step 1