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

CREATE PROCEDURE USP_GetTasksByRoot
(@TaskId INT)
AS
BEGIN
	SELECT TaskId,InstallId+' - '+Title AS Title FROM tblTask
	WHERE ParentTaskId = @TaskId
END

GO

--Kapil Pancholi    
alter procedure sp_AddMultiLevelChlild    
@ParentTaskId int,@InstallId varchar(max),@Description varchar(MAX),@IndentLevel int,@Class varchar(50)    
as    
insert into tblTaskMultilevelList    
values    
(@ParentTaskId ,@InstallId ,@Description ,@IndentLevel ,@Class,null,null,null,null,getDate(),getDate(),null,null,null)

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
 where (@Date between tapp.StartDate and tapp.EndDate)  
 AND tiu.[Status] in (SELECT * FROM [dbo].[SplitString](ISNULL(@UserStatus,tiu.[Status]),','))  
 AND t.[Status] in (SELECT * FROM [dbo].[SplitString](ISNULL(@TaskStatus,t.[Status]),','))  
 --AND tiu.[Id] in ( SELECT * FROM [dbo].[SplitString](ISNULL(@UserIds,tiu.[Id]),','))              
  
 select * from #Users    
 drop table #Users    
end 