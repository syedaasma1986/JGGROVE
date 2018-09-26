-- =============================================              
-- Author: Kapil Pancholi  
-- Create date: 12/7/2017  
-- Updated By: Kapil Pancholi     
-- Updated date: 12/7/2017  
-- Description: SP_GetInstallUsers              
--[dbo].[SP_GetInstallUsersWithStatus] 2,'10',''  
-- =============================================              
ALTER PROCEDURE [dbo].[SP_GetInstallUsersWithStatus]  
 @Key int,            
 @Designations varchar(4000),          
 @UserStatus varchar(500)              
AS              
BEGIN              
IF @UserStatus = ''  
BEGIN  
 SET @UserStatus = null  
END          
 IF @Key = 1            
 BEGIN          
  SELECT          
   DISTINCT(Designation) AS Designation           
  FROM tblinstallUsers           
  WHERE Designation IS NOT NULL               
  ORDER BY Designation          
 END          
 ELSE IF @Key = 2            
 BEGIN          
 IF @Designations = ''    
 BEGIN    
 SELECT FristName + ' ' + ISNULL(NameMiddleInitial + '. ','') + LastName + ' - ' + ISNULL(UserInstallId,'') as FristName,Id , [Status],ISNULL(UserInstallId,'') as  UserInstallId          
  FROM tblinstallUsers           
  WHERE            
   (FristName IS NOT NULL AND RTRIM(LTRIM(FristName)) <> '' )  AND           
   (          
    tblinstallUsers.[Status] in (SELECT * FROM [dbo].[SplitString](ISNULL(@UserStatus,tblinstallUsers.[Status]),','))  
   )          
  ORDER BY CASE WHEN [Status] = '1' THEN 1 ELSE 2 END, [Status], DesignationID ,FristName + ' ' + LastName          
 END    
 ELSE    
 BEGIN    
  SELECT FristName + ' ' + ISNULL(NameMiddleInitial + '. ','') + LastName + ' - ' + ISNULL(UserInstallId,'') as FristName,Id , [Status],ISNULL(UserInstallId,'') as  UserInstallId          
  FROM tblinstallUsers           
  WHERE            
   (FristName IS NOT NULL AND RTRIM(LTRIM(FristName)) <> '' )  AND           
   (          
    tblinstallUsers.[Status] in (SELECT * FROM [dbo].[SplitString](ISNULL(@UserStatus,tblinstallUsers.[Status]),','))  
   ) AND           
   (          
    Designation IN (SELECT Item FROM dbo.SplitString(@Designations,','))          
    OR          
    Convert(Nvarchar(max),DesignationID)  IN (SELECT Item FROM dbo.SplitString(@Designations,','))          
   )          
  ORDER BY CASE WHEN [Status] = '1' THEN 1 ELSE 2 END, [Status], DesignationID ,FristName + ' ' + LastName          
  END    
 END          
END 
GO

ALTER PROCEDURE [dbo].[usp_GetAllInProAssReqTaskWithSequence]                                 
(                                
                               
 @PageIndex INT = 0,                                   
 @PageSize INT = 20,                            
 @DesignationIds VARCHAR(200) = NULL,                                       
 @TaskStatus VARCHAR(100) = NULL,      
 @UserStatus VARCHAR(100) = NULL,          
 @StartDate datetime = NULL,          
 @EndDate datetime = NULL,      
 @UserIds varchar(100) = NULL,    
 @ForInProgress BIT = 0       
)                                
As                                
BEGIN                                
                          
                          
IF @StartDate=''        
BEGIN        
SET @StartDate = (SELECT TOP 1 CreatedOn FROM tblTask ORDER BY TASKID ASC)        
END        
        
IF @EndDate = ''        
BEGIN        
 SET @EndDate = (SELECT TOP 1 CreatedOn FROM tblTask ORDER BY TASKID DESC)        
END        
        
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
                                
;WITH                                 
 Tasklist AS                                
 (                                 
  SELECT DISTINCT TaskId ,[Status],[SequenceDesignationId],[Sequence], [SubSequence],                              
  Title,ParentTaskId,IsTechTask,ParentTaskTitle,InstallId as InstallId1,(select * from [GetParent](TaskId)) as MainParentId,  TaskDesignation,                
  [AdminStatus] , [TechLeadStatus], [OtherUserStatus],[AdminStatusUpdated],[TechLeadStatusUpdated],[OtherUserStatusUpdated],[AdminUserId],[TechLeadUserId],[OtherUserId],                 
  AdminUserInstallId, AdminUserFirstName, AdminUserLastName,                
  TechLeadUserInstallId,ITLeadHours,UserHours, TechLeadUserFirstName, TechLeadUserLastName,                
  OtherUserInstallId, OtherUserFirstName,OtherUserLastName,TaskAssignedUserIDs,CreatedOn,                
  case                                 
   when (ParentTaskId is null and  TaskLevel=1) then InstallId                                 
   when (tasklevel =1 and ParentTaskId>0) then                                 
    (select installid from tbltask where taskid=x.parenttaskid) +'-'+InstallId                                  
   when (tasklevel =2 and ParentTaskId>0) then                                
    (select InstallId from tbltask where taskid in (                                
   (select parentTaskId from tbltask where   taskid=x.parenttaskid) ))                                
   +'-'+ (select InstallId from tbltask where   taskid=x.parenttaskid) + '-' +InstallId                                 
                                     
   when (tasklevel =3 and ParentTaskId>0) then                                
   (select InstallId from tbltask where taskid in (                                
   (select parenttaskid from tbltask where taskid in (                                
   (select parentTaskId from tbltask where   taskid=x.parenttaskid) ))))                                
   +'-'+                                
    (select InstallId from tbltask where taskid in (                                
   (select parentTaskId from tbltask where   taskid=x.parenttaskid) ))              
   +'-'+ (select InstallId from tbltask where   taskid=x.parenttaskid) + '-' +InstallId                                 
  end as 'InstallId' ,Row_number() OVER (order by x.TaskId ) AS RowNo_Order                                
  from (                                
   select DISTINCT a.*                                
   ,(select Title from tbltask where TaskId=(select * from [GetParent](a.TaskId))) AS ParentTaskTitle,                
   (SELECT EstimatedHours FROM [dbo].[tblTaskApprovals] WHERE TaskId = a.TaskId AND UserId = a.TechLeadUserId) AS ITLeadHours ,   
   (SELECT EstimatedHours FROM [dbo].[tblTaskApprovals] WHERE TaskId = a.TaskId AND UserId = a.OtherUserId) AS UserHours,           
    
      
      
      
       
   ta.InstallId AS AdminUserInstallId, ta.FristName AS AdminUserFirstName, ta.LastName AS AdminUserLastName,                
   tT.InstallId AS TechLeadUserInstallId, tT.FristName AS TechLeadUserFirstName, tT.LastName AS TechLeadUserLastName,                
   tU.InstallId AS OtherUserInstallId, tU.FristName AS OtherUserFirstName, tU.LastName AS OtherUserLastName,                
   --,t.FristName + ' ' + t.LastName AS Assigneduser,                              
   (                              
   STUFF((SELECT ', {"Name": "' + Designation +'","Id":'+ CONVERT(VARCHAR(5),DesignationID)+'}'                            
           FROM tblTaskdesignations td                               
           WHERE td.TaskID = a.TaskId                               
          FOR XML PATH('')), 1, 2, '')                              
  )  AS TaskDesignation,            
  (            
    STUFF((SELECT ', {"Id" : "'+ CONVERT(VARCHAR(5),UserId) + '"}'                            
           FROM tbltaskassignedusers as tau            
           WHERE tau.TaskId = a.TaskId                               
          FOR XML PATH('')), 1, 2, '')                              
  ) AS TaskAssignedUserIDs                     
  --(SELECT TOP 1 DesignationID                             
  --         FROM tblTaskdesignations td                               
  --         WHERE td.TaskID = a.TaskId ) AS DesignationId                             
   from  tbltask a                                
   --LEFT OUTER JOIN tblTaskdesignations as b ON a.TaskId = b.TaskId                                 
   --LEFT OUTER JOIN tbltaskassignedusers as c ON a.TaskId = c.TaskId                                
   LEFT OUTER JOIN tblInstallUsers as ta ON a.[AdminUserId] = ta.Id                 
   LEFT OUTER JOIN tblInstallUsers as tT ON a.[TechLeadUserId] = tT.Id                 
   LEFT OUTER JOIN tblInstallUsers as tU ON a.[OtherUserId] = tU.Id             
   JOIN tbltaskassignedusers as tau ON a.TaskId = tau.TaskId        
   JOIN tblInstallUsers as iu ON tau.[UserId] = iu.[Id]        
  -- LEFT OUTER JOIN tbltaskassignedusers as tau ON a.TaskId = tau.TaskId                                
   WHERE                           
  (                         
    (a.[Sequence] IS NOT NULL)                            
    AND (a.[SequenceDesignationId] IN (SELECT * FROM [dbo].[SplitString](ISNULL(@DesignationIds,a.[SequenceDesignationId]),',') ) )                               
 AND a.[Status] in (SELECT * FROM [dbo].[SplitString](ISNULL(@TaskStatus,a.[Status]),','))        
 AND ((a.[Status] in (3,4) AND @ForInProgress=1) OR (a.[Status] in (7,11,12,14) AND @ForInProgress=0))      
 AND iu.[Status] in( SELECT * FROM [dbo].[SplitString](ISNULL(@UserStatus,iu.[Status]),','))        
 AND iu.[Id] in ( SELECT * FROM [dbo].[SplitString](ISNULL(@UserIds,iu.[Id]),','))        
 AND CreatedOn between @StartDate and @EndDate        
   )                           
                              
   --and (CreatedOn >=@startdate and CreatedOn <= @enddate )                                 
  ) as x                                
 )                      
                                
 ---- get CTE data into temp table                                
 SELECT *                                
 INTO #Tasks                                
 FROM Tasklist                                
                          
---- find page number to show taskid sent.                          
DECLARE @StartIndex INT  = 0                                
                          
                                
--IF @HighLightedTaskID  > 0                         
-- BEGIN                          
--  DECLARE @RowNumber BIGINT = NULL                          
                          
--  -- Find in which rownumber highlighter taskid is.                          
--  SELECT @RowNumber = RowNo_Order                           
--  FROM #Tasks                           
--  WHERE TaskId = @HighLightedTaskID                          
                     
--  -- if row number found then divide it with page size and round it to nearest integer , so will found pagenumber to be selected.                          
--  -- for ex. if total 60 records are there,pagesize is 20 and highlighted task id is at 42 row number than.                           
--  -- 42/20 = 2.1 ~ 3 - 1 = 2 = @Page Index                          
--  -- StartIndex = (2*20)+1 = 41, so records 41 to 60 will be fetched.                          
                             
--  IF @RowNumber IS NOT NULL                          
--  BEGIN                          
--   SELECT @PageIndex = (CEILING(@RowNumber / CAST(@PageSize AS FLOAT))) - 1                          
--  END                          
-- END                            
                          
 -- Set start index to fetch record.                          
 SET @StartIndex = (@PageIndex * @PageSize) + 1                                
                           
 ----missing rows bug solution BEGIN: kapil pancholi        
 --create temp table for Sequences        
 CREATE TABLE #S (TASKID INT, ROW_ID INT,[SEQUENCE] INT, [Status] INT)        
         
 INSERT INTO #S (TASKID,ROW_ID,[SEQUENCE],[Status])         
 SELECT TASKID, Row_Number() over (order by [Sequence]),[SEQUENCE],[Status] FROM #TASKS WHERE SubSequence IS NULL        
        
 update #Tasks set #Tasks.RowNo_Order = #S.ROW_ID        
 from #Tasks,#S        
 where #Tasks.TaskId=#S.TASKID        
        
 --create temp table for SubSequences        
 CREATE TABLE #SS (TASKID INT, ROW_ID INT,[SUB_SEQUENCE] INT,[Status] INT)        
         
 INSERT INTO #SS (TASKID,ROW_ID,[SUB_SEQUENCE],[Status])         
 SELECT TASKID, Row_Number() over (order by [SUBSEQUENCE]),[SUBSEQUENCE],[Status] FROM #TASKS WHERE SubSequence IS NOT NULL        
        
 update #Tasks set #Tasks.RowNo_Order = #SS.ROW_ID        
 from #Tasks,#SS        
 where #Tasks.TaskId=#SS.TASKID        
 ----missing rows bug solution END: kapil pancholi        
        
 -- fetch parent sequence records from temptable                          
 SELECT *                                 
 FROM #Tasks                                 
 WHERE                                 
 (RowNo_Order >= @StartIndex AND                                 
 (                                
  @PageSize = 0 OR                                 
  RowNo_Order < (@StartIndex + @PageSize)                                
 ))              
 AND SubSequence IS NULL              
-- ORDER BY  [SequenceDesignationId], [Sequence]  DESC                              
ORDER BY   
CASE [Status]         
    WHEN 11 THEN 1       --TestCommit  
    WHEN 12 THEN 2       --LiveCommit  
    WHEN 7 THEN 3        --Closed  
 WHEN 14 THEN 4       --Billed  
   
 WHEN 4 THEN 5   --InProgress  
 WHEN 3 THEN 6   --Request-Assigned  
    END         
              
 -- fetch sub sequence records from temptable                          
 SELECT *                                 
 FROM #Tasks                                 
 WHERE                                 
 (RowNo_Order >= @StartIndex AND                                 
 (                                
  @PageSize = 0 OR                                 
  RowNo_Order < (@StartIndex + @PageSize)                                
 ))              
 AND                       
 SubSequence IS NOT NULL              
-- ORDER BY  [SequenceDesignationId], [Sequence]  DESC                                                    
order by  
CASE [Status]         
    WHEN 11 THEN 1       --TestCommit  
    WHEN 12 THEN 2       --LiveCommit  
    WHEN 7 THEN 3        --Closed  
 WHEN 14 THEN 4       --Billed  
   
 WHEN 4 THEN 5   --InProgress  
 WHEN 3 THEN 6   --Request-Assigned  
    END         
              
              
 --or                      
 --(                      
 -- TaskId = @HighLightedTaskID                  
 --)                                
 --ORDER BY CASE WHEN (TaskId = @HighLightedTaskID) THEN 0 ELSE 1 END , [Sequence]  DESC                              
                                
 -- fetch other statistics, total records, total pages, pageindex to highlighted.                               
 SELECT                                
 COUNT(*) AS TotalRecords, CEILING(COUNT(*)/CAST(@PageSize AS FLOAT)) AS TotalPages, @PageIndex AS PageIndex                               
  FROM #Tasks  WHERE SubSequence IS NULL                         
  
  Select sum(convert(float,ITLeadHours)) as TotalITLeadHours, sum(convert(float,UserHours)) as TotalUserHours from #Tasks  
  WHERE  
 (RowNo_Order >= @StartIndex AND                                 
 (                                
  @PageSize = 0 OR                                 
  RowNo_Order < (@StartIndex + @PageSize)                                
 ))              
    
  --select * from #Tasks  
                          
 DROP TABLE #Tasks                          
 DROP TABLE #S            
 DROP TABLE #SS         
                              
END   
  
GO  
  CREATE PROCEDURE [dbo].[usp_GetAllInProAssReqUserTaskWithSequence]                               
(                              
                             
 @PageIndex INT = 0,                               
 @PageSize INT =20,                                      
 @UserId VARCHAR(MAX),                     
 @IsTechTask BIT = 0,      
 @ForDashboard BIT = 0,    
 @ForInProgress BIT = 0,  
 @StartDate datetime = NULL,            
 @EndDate datetime = NULL                        
)                              
As                              
BEGIN                                              
      
IF @StartDate=''          
BEGIN          
SET @StartDate = (SELECT TOP 1 CreatedOn FROM tblTask ORDER BY TASKID ASC)          
END          
          
IF @EndDate = ''          
BEGIN          
 SET @EndDate = (SELECT TOP 1 CreatedOn FROM tblTask ORDER BY TASKID DESC)          
END    
  
;WITH                               
 Tasklist AS                              
 (                               
  SELECT DISTINCT TaskId ,[Status],[SequenceDesignationId],[Sequence], [SubSequence],                            
  Title,ParentTaskId,IsTechTask,ParentTaskTitle,InstallId as InstallId1,(select * from [GetParent](TaskId)) as MainParentId,  TaskDesignation,              
  [AdminStatus] , [TechLeadStatus], [OtherUserStatus],[AdminStatusUpdated],[TechLeadStatusUpdated],[OtherUserStatusUpdated],[AdminUserId],[TechLeadUserId],[OtherUserId],               
  AdminUserInstallId, AdminUserFirstName, AdminUserLastName,              
  TechLeadUserInstallId,ITLeadHours,UserHours, TechLeadUserFirstName, TechLeadUserLastName,              
  OtherUserInstallId, OtherUserFirstName,OtherUserLastName,TaskAssignedUserIDs,              
  case                               
   when (ParentTaskId is null and  TaskLevel=1) then InstallId                               
   when (tasklevel =1 and ParentTaskId>0) then                               
    (select installid from tbltask where taskid=x.parenttaskid) +'-'+InstallId                                
   when (tasklevel =2 and ParentTaskId>0) then                              
    (select InstallId from tbltask where taskid in (                              
   (select parentTaskId from tbltask where   taskid=x.parenttaskid) ))                              
   +'-'+ (select InstallId from tbltask where   taskid=x.parenttaskid) + '-' +InstallId                               
                                   
   when (tasklevel =3 and ParentTaskId>0) then                              
   (select InstallId from tbltask where taskid in (                              
   (select parenttaskid from tbltask where taskid in (                              
   (select parentTaskId from tbltask where   taskid=x.parenttaskid) ))))                              
   +'-'+                              
    (select InstallId from tbltask where taskid in (                              
   (select parentTaskId from tbltask where   taskid=x.parenttaskid) ))                              
   +'-'+ (select InstallId from tbltask where   taskid=x.parenttaskid) + '-' +InstallId                               
  end as 'InstallId' ,Row_number() OVER (order by x.TaskId ) AS RowNo_Order                              
  from (                              
   select DISTINCT a.*                              
   ,(select Title from tbltask where TaskId=(select * from [GetParent](a.TaskId))) AS ParentTaskTitle,              
   (SELECT EstimatedHours FROM [dbo].[tblTaskApprovals] WHERE TaskId = a.TaskId AND UserId = a.TechLeadUserId) AS ITLeadHours , (SELECT EstimatedHours FROM [dbo].[tblTaskApprovals] WHERE TaskId = a.TaskId AND UserId = a.OtherUserId) AS UserHours,         
  
    
     
   ta.InstallId AS AdminUserInstallId, ta.FristName AS AdminUserFirstName, ta.LastName AS AdminUserLastName,              
   tT.InstallId AS TechLeadUserInstallId, tT.FristName AS TechLeadUserFirstName, tT.LastName AS TechLeadUserLastName,              
   tU.InstallId AS OtherUserInstallId, tU.FristName AS OtherUserFirstName, tU.LastName AS OtherUserLastName,              
   --,t.FristName + ' ' + t.LastName AS Assigneduser,                            
   (                            
   STUFF((SELECT ', {"Name": "' + Designation +'","Id":'+ CONVERT(VARCHAR(5),DesignationID)+'}'                          
           FROM tblTaskdesignations td                             
           WHERE td.TaskID = a.TaskId                             
          FOR XML PATH('')), 1, 2, '')                            
  )  AS TaskDesignation,          
  (          
    STUFF((SELECT ', {"Id" : "'+ CONVERT(VARCHAR(5),UserId) + '"}'                          
           FROM tbltaskassignedusers as tau          
           WHERE tau.TaskId = a.TaskId                             
          FOR XML PATH('')), 1, 2, '')                            
  ) AS TaskAssignedUserIDs        
  ,      
  tau.UserId as AssignedUserId      
  --(SELECT TOP 1 DesignationID                           
  --         FROM tblTaskdesignations td                             
  --         WHERE td.TaskID = a.TaskId ) AS DesignationId                           
   from  tbltask a                              
   --LEFT OUTER JOIN tblTaskdesignations as b ON a.TaskId = b.TaskId                               
   --LEFT OUTER JOIN tbltaskassignedusers as c ON a.TaskId = c.TaskId                              
   LEFT OUTER JOIN tblInstallUsers as ta ON a.[AdminUserId] = ta.Id               
   LEFT OUTER JOIN tblInstallUsers as tT ON a.[TechLeadUserId] = tT.Id               
   LEFT OUTER JOIN tblInstallUsers as tU ON a.[OtherUserId] = tU.Id           
   JOIN tbltaskassignedusers as tau ON a.TaskId = tau.TaskId                              
   WHERE                         
  (                         
    (a.[Sequence] IS NOT NULL)                                       
    --AND (ISNULL(a.[IsTechTask],@IsTechTask) = @IsTechTask)                        
 AND (tau.UserId in(select * from [dbo].[SplitString](@UserId,',')))      
 AND ((a.[Status] in (3,4) AND @ForInProgress=1) OR (a.[Status] in (7,11,12,14) AND @ForInProgress=0))        
 AND      
 (      
  (@ForDashboard=0 AND IsTechTask=@IsTechTask)      
  OR      
  (@ForDashboard=1 AND IsTechTask IN(0,1))      
 )  
 AND CreatedOn between @StartDate and @EndDate    
      
   )                                               
   --and (CreatedOn >=@startdate and CreatedOn <= @enddate )                               
  ) as x                              
 )                    
                              
 ---- get CTE data into temp table                              
 SELECT *                              
 INTO #Tasks                              
 FROM Tasklist                              
                        
---- find page number to show taskid sent.                        
DECLARE @StartIndex INT  = 0                              
                        
                              
--IF @HighLightedTaskID  > 0                        
-- BEGIN                        
--  DECLARE @RowNumber BIGINT = NULL                        
                        
--  -- Find in which rownumber highlighter taskid is.                        
--  SELECT @RowNumber = RowNo_Order                         
--  FROM #Tasks                         
--  WHERE TaskId = @HighLightedTaskID                        
                        
--  -- if row number found then divide it with page size and round it to nearest integer , so will found pagenumber to be selected.                        
--  -- for ex. if total 60 records are there,pagesize is 20 and highlighted task id is at 42 row number than.                         
--  -- 42/20 = 2.1 ~ 3 - 1 = 2 = @Page Index                        
--  -- StartIndex = (2*20)+1 = 41, so records 41 to 60 will be fetched.                        
                           
--  IF @RowNumber IS NOT NULL                        
--  BEGIN                        
--   SELECT @PageIndex = (CEILING(@RowNumber / CAST(@PageSize AS FLOAT))) - 1            
--  END                        
-- END                          
                        
 -- Set start index to fetch record.                        
 SET @StartIndex = (@PageIndex * @PageSize) + 1                              
      
 ----missing rows bug solution BEGIN: kapil pancholi      
 --create temp table for Sequences      
 CREATE TABLE #S (TASKID INT, ROW_ID INT,[SEQUENCE] INT,[Status] INT)      
       
 INSERT INTO #S (TASKID,ROW_ID,[SEQUENCE],[Status])       
 SELECT TASKID, Row_Number() over (order by [Sequence]),[SEQUENCE],[Status] FROM #TASKS WHERE SubSequence IS NULL      
      
 update #Tasks set #Tasks.RowNo_Order = #S.ROW_ID     from #Tasks,#S      
 where #Tasks.TaskId=#S.TASKID      
      
 --create temp table for SubSequences      
 CREATE TABLE #SS (TASKID INT, ROW_ID INT,[SUB_SEQUENCE] INT,[Status] INT)      
       
 INSERT INTO #SS (TASKID,ROW_ID,[SUB_SEQUENCE],[Status])       
 SELECT TASKID, Row_Number() over (order by [SUBSEQUENCE]),[SUBSEQUENCE],[Status] FROM #TASKS WHERE SubSequence IS NOT NULL      
      
 update #Tasks set #Tasks.RowNo_Order = #SS.ROW_ID      
 from #Tasks,#SS      
 where #Tasks.TaskId=#SS.TASKID      
 ----missing rows bug solution END: kapil pancholi      
      
 -- fetch parent sequence records from temptable                        
 SELECT *                               
 FROM #Tasks                               
 WHERE                               
 (RowNo_Order >= @StartIndex AND                               
 (                              
  @PageSize = 0 OR                               
  RowNo_Order < (@StartIndex + @PageSize)                              
 ))            
 AND                       
 SubSequence IS NULL            
 --ORDER BY  [Sequence]  DESC                            
ORDER BY     
CASE [Status]           
    WHEN 11 THEN 1       --TestCommit    
    WHEN 12 THEN 2       --LiveCommit    
    WHEN 7 THEN 3        --Closed    
 WHEN 14 THEN 4       --Billed    
     
 WHEN 4 THEN 5   --InProgress    
 WHEN 3 THEN 6   --Request-Assigned    
    END                       
            
 -- fetch sub sequence records from temptable                        
 SELECT *                               
 FROM #Tasks                               
 WHERE                               
 (RowNo_Order >= @StartIndex AND                               
 (                              
  @PageSize = 0 OR                               
  RowNo_Order < (@StartIndex + @PageSize)                              
 ))            
 AND                     
 SubSequence IS NOT NULL            
 --ORDER BY  [Sequence]  DESC                            
ORDER BY     
CASE [Status]           
    WHEN 11 THEN 1       --TestCommit    
    WHEN 12 THEN 2       --LiveCommit    
    WHEN 7 THEN 3        --Closed    
 WHEN 14 THEN 4       --Billed    
     
 WHEN 4 THEN 5   --InProgress    
 WHEN 3 THEN 6   --Request-Assigned    
    END       
            
 --or                    
 --(                    
 -- TaskId = @HighLightedTaskID                
 --)                              
 --ORDER BY CASE WHEN (TaskId = @HighLightedTaskID) THEN 0 ELSE 1 END , [Sequence]  DESC                            
                              
 -- fetch other statistics, total records, total pages, pageindex to highlighted.                             
 SELECT                              
 COUNT(*) AS TotalRecords, CEILING(COUNT(*)/CAST(@PageSize AS FLOAT)) AS TotalPages, @PageIndex AS PageIndex                             
  FROM #Tasks  WHERE SubSequence IS NULL                       
                        
Select sum(convert(float,ITLeadHours)) as TotalITLeadHours, sum(convert(float,UserHours)) as TotalUserHours from #Tasks    
  WHERE    
 (RowNo_Order >= @StartIndex AND                                   
 (                                  
  @PageSize = 0 OR                                   
  RowNo_Order < (@StartIndex + @PageSize)                                  
 ))                
      
 DROP TABLE #Tasks                        
 DROP TABLE #S      
 DROP TABLE #SS         
                            
END 

GO
ALTER PROCEDURE [dbo].[GetClosedTasks]   
 -- Add the parameters for the stored procedure here  
 --@userid int,  
 @userid nvarchar(MAX)='0',  
 @desigid nvarchar(MAX)='',  
 @TaskStatus VARCHAR(100) = NULL,  
 @UserStatus VARCHAR(100) = NULL,      
 @search varchar(100),  
 @PageIndex INT,   
 @PageSize INT  
AS  
BEGIN  
DECLARE @StartIndex INT  = 0  
IF( @TaskStatus = '' )                      
BEGIN                      
                      
 SET @TaskStatus = NULL                      
                      
END  
IF( @UserStatus = '' )                      
BEGIN                      
                      
 SET @UserStatus = NULL                      
                      
END  
IF( @userid = '' )                      
BEGIN                      
                      
 SET @userid = NULL                      
                      
END   
  
SET @StartIndex = (@PageIndex * @PageSize) + 1  
  
 -- SET NOCOUNT ON added to prevent extra result sets from  
 -- interfering with SELECT statements.  
 SET NOCOUNT ON;  
 declare @str nvarchar(700)  
 set @str = ''  
 if @search<>''  
  begin  
   ;WITH   
  Tasklist AS  
  (  
   select  TaskId ,[Description],[Status],convert(Date,DueDate ) as DueDate,  
   Title,[Hours],ParentTaskId,TaskLevel,Assigneduser,InstallId as InstallId1,(select * from [GetParent](TaskId)) as MainParentId,  
   case   
    when (ParentTaskId is null and  TaskLevel=1) then InstallId   
    when (tasklevel =1 and ParentTaskId>0) then   
     (select installid from tbltask where taskid=x.parenttaskid) +'-'+InstallId    
    when (tasklevel =2 and ParentTaskId>0) then  
     (select InstallId from tbltask where taskid in (  
    (select parentTaskId from tbltask where   taskid=x.parenttaskid) ))  
    +'-'+ (select InstallId from tbltask where   taskid=x.parenttaskid) + '-' +InstallId   
       
    when (tasklevel =3 and ParentTaskId>0) then  
    (select InstallId from tbltask where taskid in (  
    (select parenttaskid from tbltask where taskid in (  
    (select parentTaskId from tbltask where   taskid=x.parenttaskid) ))))  
    +'-'+  
     (select InstallId from tbltask where taskid in (  
    (select parentTaskId from tbltask where   taskid=x.parenttaskid) ))  
    +'-'+ (select InstallId from tbltask where   taskid=x.parenttaskid) + '-' +InstallId   
   end as 'InstallId',Row_number() OVER (  ORDER BY CASE [Status]   
             WHEN 12 THEN 1   
             WHEN 11 THEN 2   
             WHEN 7 THEN 3   
             WHEN 14 THEN 4  
             WHEN 9 THEN 5  
  
                WHEN 10 THEN 6  
             WHEN 8 THEN 7  
             WHEN 6 THEN 8  
             WHEN 5 THEN 9  
             WHEN 4 THEN 10  
             WHEN 3 THEN 11  
             WHEN 2 THEN 12  
             WHEN 1 THEN 13  
             END )   
             AS RowNo_Order,     
  
   (STUFF((  
     SELECT ', ' + case            
         WHEN inu.Designation = 'ITLead' THEN 'ITLead'  
         WHEN inu.Designation = 'Admin' THEN 'Admin'  
         ELSE 'User' END  
         + ': '+EstimatedHours  
     FROM [tblTaskApprovals] tapp join tblInstallUsers inu on tapp.UserId=inu.Id  
     Where tapp.TaskId = x.TaskId  
     FOR XML PATH('')  
     ), 1, 2, '')  
    ) AS EstimatedHours  
   from (  
  
   SELECT a.TaskId,[Description],a.[Status],convert(Date,DueDate ) as DueDate,  
   Title,[Hours],a.InstallId ,ParentTaskId,TaskLevel,t.FristName + ' ' + t.LastName AS Assigneduser  
   from dbo.tblTask as a  
   Left Join tbltaskassignedusers as b ON a.TaskId=b.TaskId  
    Left Join tblInstallUsers as t ON b.UserId=t.Id  
   --where a.[Status]  in (7,8,9,10,11,12,14)  
   where a.[Status]  in (SELECT * FROM [dbo].[SplitString](ISNULL(@TaskStatus,a.[Status]),',')) AND a.[Status] not in (1,2,3,4,8)     
   AND t.[Status] in (SELECT * FROM [dbo].[SplitString](ISNULL(@UserStatus,t.[Status]),','))  
   AND  (  
   t.FristName LIKE '%'+ @search + '%'  or  
   t.LastName LIKE '%'+ @search + '%'  or  
   t.Email LIKE '%' + @search +'%'    
   )   
   and parenttaskid is not null  
   ) as x  
   )  
     
  SELECT *  
  INTO #temp1  
  FROM Tasklist  
  
   SELECT  
   *  
   FROM #temp1  
   WHERE   
   RowNo_Order >= @StartIndex AND   
   (  
    @PageSize = 0 OR   
    RowNo_Order < (@StartIndex + @PageSize)  
   )  
  
  SELECT  
  COUNT(*) AS TotalRecords, CEILING(COUNT(*)/CAST(@PageSize AS FLOAT)) AS TotalPages, @PageIndex AS PageIndex   
  FROM #temp1  
  
  end  
   else if @userid='0' and @desigid=''  
  begin  
  ;WITH   
  Tasklist AS  
  (  
   select  TaskId ,[Description],[Status],convert(Date,DueDate ) as DueDate,  
   Title,[Hours],ParentTaskId,TaskLevel,Assigneduser,InstallId as InstallId1,(select * from [GetParent](TaskId)) as MainParentId,  
   case   
    when (ParentTaskId is null and  TaskLevel=1) then InstallId   
    when (tasklevel =1 and ParentTaskId>0) then   
     (select installid from tbltask where taskid=x.parenttaskid) +'-'+InstallId    
    when (tasklevel =2 and ParentTaskId>0) then  
     (select InstallId from tbltask where taskid in (  
    (select parentTaskId from tbltask where   taskid=x.parenttaskid) ))  
    +'-'+ (select InstallId from tbltask where   taskid=x.parenttaskid) + '-' +InstallId   
       
    when (tasklevel =3 and ParentTaskId>0) then  
    (select InstallId from tbltask where taskid in (  
    (select parenttaskid from tbltask where taskid in (  
    (select parentTaskId from tbltask where   taskid=x.parenttaskid) ))))  
    +'-'+  
     (select InstallId from tbltask where taskid in (  
    (select parentTaskId from tbltask where   taskid=x.parenttaskid) ))  
    +'-'+ (select InstallId from tbltask where   taskid=x.parenttaskid) + '-' +InstallId   
   end as 'InstallId',Row_number() OVER (  ORDER BY CASE [Status]   
             WHEN 12 THEN 1   
             WHEN 11 THEN 2   
             WHEN 7 THEN 3   
             WHEN 14 THEN 4  
             WHEN 9 THEN 5  
  
                WHEN 10 THEN 6  
             WHEN 8 THEN 7  
             WHEN 6 THEN 8  
             WHEN 5 THEN 9  
             WHEN 4 THEN 10  
             WHEN 3 THEN 11  
             WHEN 2 THEN 12  
             WHEN 1 THEN 13  
             END )   
             AS RowNo_Order,     
  
   (STUFF((  
     SELECT ', ' + case            
         WHEN inu.Designation = 'ITLead' THEN 'ITLead'  
         WHEN inu.Designation = 'Admin' THEN 'Admin'  
         ELSE 'User' END  
         + ': '+EstimatedHours  
     FROM [tblTaskApprovals] tapp join tblInstallUsers inu on tapp.UserId=inu.Id  
     Where tapp.TaskId = x.TaskId  
     FOR XML PATH('')  
     ), 1, 2, '')  
    ) AS EstimatedHours  
  
  
  
   from (  
   SELECT a.TaskId,a.[Description],a.[Status],convert(Date,DueDate ) as DueDate,  
   Title,[Hours],a.InstallId,ParentTaskId,TaskLevel,t.FristName + ' ' + t.LastName AS Assigneduser  
   from dbo.tblTask  as a  
   LEFT OUTER JOIN tbltaskassignedusers as b ON a.TaskId = b.TaskId  
   LEFT OUTER JOIN tblInstallUsers as t ON t.Id = b.UserId  
   where a.[Status]  in (SELECT * FROM [dbo].[SplitString](ISNULL(@TaskStatus,a.[Status]),',')) AND a.[Status] not in (1,2,3,4,8)    
   AND t.[Status] in (SELECT * FROM [dbo].[SplitString](ISNULL(@UserStatus,t.[Status]),','))  
     
   and a.parenttaskid is not null  
   )  as x   
   )  
  
     
  SELECT *  
  INTO #temp2  
  FROM Tasklist  
  
   SELECT  
   *  
   FROM #temp2  
   WHERE   
   RowNo_Order >= @StartIndex AND   
   (  
    @PageSize = 0 OR   
    RowNo_Order < (@StartIndex + @PageSize)  
   )  
     
     
  SELECT  
  COUNT(*) AS TotalRecords, CEILING(COUNT(*)/CAST(@PageSize AS FLOAT)) AS TotalPages, @PageIndex AS PageIndex   
  FROM #temp2  
  
  end  
 else if @userid<>'0'    
  begin  
   ;WITH   
  Tasklist AS  
  (  
   select  TaskId ,[Description],[Status],convert(Date,DueDate ) as DueDate,  
   Title,[Hours],ParentTaskId,TaskLevel,Assigneduser,InstallId as InstallId1,(select * from [GetParent](TaskId)) as MainParentId,  
   case   
    when (ParentTaskId is null and  TaskLevel=1) then InstallId   
    when (tasklevel =1 and ParentTaskId>0) then   
     (select installid from tbltask where taskid=x.parenttaskid) +'-'+InstallId    
    when (tasklevel =2 and ParentTaskId>0) then  
     (select InstallId from tbltask where taskid in (  
    (select parentTaskId from tbltask where   taskid=x.parenttaskid) ))  
    +'-'+ (select InstallId from tbltask where   taskid=x.parenttaskid) + '-' +InstallId   
       
    when (tasklevel =3 and ParentTaskId>0) then  
    (select InstallId from tbltask where taskid in (  
    (select parenttaskid from tbltask where taskid in (  
    (select parentTaskId from tbltask where   taskid=x.parenttaskid) ))))  
    +'-'+  
     (select InstallId from tbltask where taskid in (  
    (select parentTaskId from tbltask where   taskid=x.parenttaskid) ))  
    +'-'+ (select InstallId from tbltask where   taskid=x.parenttaskid) + '-' +InstallId   
   end as 'InstallId',Row_number() OVER (  ORDER BY CASE [Status]   
             WHEN 12 THEN 1   
             WHEN 11 THEN 2   
             WHEN 7 THEN 3   
             WHEN 14 THEN 4  
             WHEN 9 THEN 5  
  
                WHEN 10 THEN 6  
             WHEN 8 THEN 7  
             WHEN 6 THEN 8  
             WHEN 5 THEN 9  
             WHEN 4 THEN 10  
             WHEN 3 THEN 11  
             WHEN 2 THEN 12  
             WHEN 1 THEN 13  
             END )   
             AS RowNo_Order,     
  
   (STUFF((  
     SELECT ', ' + case            
         WHEN inu.Designation = 'ITLead' THEN 'ITLead'  
         WHEN inu.Designation = 'Admin' THEN 'Admin'  
         ELSE 'User' END  
         + ': '+EstimatedHours  
     FROM [tblTaskApprovals] tapp join tblInstallUsers inu on tapp.UserId=inu.Id  
     Where tapp.TaskId = x.TaskId  
     FOR XML PATH('')  
     ), 1, 2, '')  
    ) AS EstimatedHours  
   from (  
  
   SELECT a.TaskId,[Description],a.[Status],convert(Date,DueDate ) as DueDate,  
   Title,[Hours],a.InstallId ,ParentTaskId,TaskLevel,t.FristName + ' ' + t.LastName AS Assigneduser  
   from dbo.tblTask as a  
   left outer join tbltaskassignedusers as b on a.TaskId=b.TaskId  
   LEFT OUTER JOIN tblInstallUsers as t ON t.Id = b.UserId  
   where a.[Status]  in (SELECT * FROM [dbo].[SplitString](ISNULL(@TaskStatus,a.[Status]),',')) AND a.[Status] not in (1,2,3,4,8)  
   AND t.[Status] in (SELECT * FROM [dbo].[SplitString](ISNULL(@UserStatus,t.[Status]),','))  
   and b.UserId in (select * from [dbo].[SplitString](@userid,','))  
   and parenttaskid is not null  
   ) as x  
   )  
     
  SELECT *  
  INTO #temp3  
  FROM Tasklist  
  
    
   SELECT  
   *  
   FROM #temp3  
   WHERE   
   RowNo_Order >= @StartIndex AND   
   (  
    @PageSize = 0 OR   
    RowNo_Order < (@StartIndex + @PageSize)  
   )  
      
  SELECT  
  COUNT(*) AS TotalRecords, CEILING(COUNT(*)/CAST(@PageSize AS FLOAT)) AS TotalPages, @PageIndex AS PageIndex   
  FROM #temp3  
  
  end  
 else if @userid='0' and @desigid<>''  
  begin  
  ;WITH   
  Tasklist AS  
  (   
   select  TaskId ,[Description],[Status],convert(Date,DueDate ) as DueDate,  
   Title,[Hours],ParentTaskId,TaskLevel,Assigneduser,InstallId as InstallId1,(select * from [GetParent](TaskId)) as MainParentId,  
   case   
    when (ParentTaskId is null and  TaskLevel=1) then InstallId   
    when (tasklevel =1 and ParentTaskId>0) then   
     (select installid from tbltask where taskid=x.parenttaskid) +'-'+InstallId    
    when (tasklevel =2 and ParentTaskId>0) then  
     (select InstallId from tbltask where taskid in (  
    (select parentTaskId from tbltask where   taskid=x.parenttaskid) ))  
    +'-'+ (select InstallId from tbltask where   taskid=x.parenttaskid) + '-' +InstallId   
       
    when (tasklevel =3 and ParentTaskId>0) then  
    (select InstallId from tbltask where taskid in (  
    (select parenttaskid from tbltask where taskid in (  
    (select parentTaskId from tbltask where   taskid=x.parenttaskid) ))))  
    +'-'+  
     (select InstallId from tbltask where taskid in (  
    (select parentTaskId from tbltask where   taskid=x.parenttaskid) ))  
    +'-'+ (select InstallId from tbltask where   taskid=x.parenttaskid) + '-' +InstallId   
   end as 'InstallId',Row_number() OVER (  ORDER BY CASE [Status]   
             WHEN 12 THEN 1   
             WHEN 11 THEN 2   
             WHEN 7 THEN 3   
             WHEN 14 THEN 4  
             WHEN 9 THEN 5  
  
                WHEN 10 THEN 6  
             WHEN 8 THEN 7  
             WHEN 6 THEN 8  
             WHEN 5 THEN 9  
             WHEN 4 THEN 10  
             WHEN 3 THEN 11  
             WHEN 2 THEN 12  
             WHEN 1 THEN 13  
             END )   
             AS RowNo_Order,     
  
   (STUFF((  
     SELECT ', ' + case            
         WHEN inu.Designation = 'ITLead' THEN 'ITLead'  
         WHEN inu.Designation = 'Admin' THEN 'Admin'  
         ELSE 'User' END  
         + ': '+EstimatedHours  
     FROM [tblTaskApprovals] tapp join tblInstallUsers inu on tapp.UserId=inu.Id  
     Where tapp.TaskId = x.TaskId  
     FOR XML PATH('')  
     ), 1, 2, '')  
    ) AS EstimatedHours  
   from (  
  
   SELECT a.TaskId,[Description],a.[Status],convert(Date,DueDate ) as DueDate,  
   Title,[Hours],a.InstallId,ParentTaskId,TaskLevel, t.FristName + ' ' + t.LastName AS Assigneduser  
   from dbo.tblTask as a   
   LEFT JOIN tbltaskassignedusers as c ON a.TaskId = c.TaskId  
   LEFT JOIN tblTaskdesignations as b ON b.TaskId = c.TaskId  
   LEFT JOIN tblInstallUsers as t ON t.Id = c.UserId  
   where a.[Status]  in (SELECT * FROM [dbo].[SplitString](ISNULL(@TaskStatus,a.[Status]),',')) AND a.[Status] not in (1,2,3,4,8)  
   AND t.[Status] in (SELECT * FROM [dbo].[SplitString](ISNULL(@UserStatus,t.[Status]),','))  
   and b.DesignationID in (select * from [dbo].[SplitString](@desigid,','))   
   and parenttaskid is not null  
  
   ) as x  
   )  
     
  SELECT *  
  INTO #temp4  
  FROM Tasklist  
  
   SELECT  
   *  
   FROM #temp4  
   WHERE   
   RowNo_Order >= @StartIndex AND   
   (  
    @PageSize = 0 OR   
    RowNo_Order < (@StartIndex + @PageSize)  
   )  
     
  SELECT  
  COUNT(*) AS TotalRecords, CEILING(COUNT(*)/CAST(@PageSize AS FLOAT)) AS TotalPages, @PageIndex AS PageIndex   
  FROM #temp4  
  
  end  
END  
  
GO

alter table [tblTaskApprovals]
add StartDate datetime

GO

alter table [tblTaskApprovals]
add EndDate datetime

GO

CREATE PROCEDURE usp_GetCalendarTasksByDate  
(@StartDate datetime, @EndDate datetime,@userid nvarchar(MAX)='0')  
AS  
BEGIN  
  
 IF( @userid = '' )                      
 BEGIN                                          
  SET @userid = NULL                                         
 END  
    
 SELECT a.TaskId, t.Title ,StartDate,EndDate+1 as EndDate, ParentTaskId,a.UserId,  
   
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
   when (ParentTaskId is null and  TaskLevel=1) then InstallId                             
   when (tasklevel =1 and ParentTaskId>0) then                             
    (select installid from tbltask where taskid=t.parenttaskid) +'-'+InstallId                              
   when (tasklevel =2 and ParentTaskId>0) then                            
    (select InstallId from tbltask where taskid in (                            
   (select parentTaskId from tbltask where   taskid=t.parenttaskid) ))                            
   +'-'+ (select InstallId from tbltask where   taskid=t.parenttaskid) + '-' +InstallId                             
                                 
   when (tasklevel =3 and ParentTaskId>0) then                            
   (select InstallId from tbltask where taskid in (                            
   (select parenttaskid from tbltask where taskid in (                            
   (select parentTaskId from tbltask where   taskid=t.parenttaskid) ))))                            
   +'-'+                            
    (select InstallId from tbltask where taskid in (                            
   (select parentTaskId from tbltask where   taskid=t.parenttaskid) ))                            
   +'-'+ (select InstallId from tbltask where   taskid=t.parenttaskid) + '-' +InstallId                             
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
 WHERE StartDate BETWEEN @StartDate AND @EndDate  
 AND a.[UserId] in (SELECT * FROM [dbo].[SplitString](ISNULL(@userid,a.[UserId]),','))  
END  

GO

alter PROCEDURE [dbo].[usp_GetSubTasks_New]           
(          
 @TaskId INT,          
 @Admin BIT,          
 @SortExpression VARCHAR(250) = 'TaskLevel ASC',          
 @searchterm  as varchar(300),          
 @OpenStatus  TINYINT = 1,          
    @RequestedStatus TINYINT = 2,          
    @AssignedStatus TINYINT = 3,          
    @InProgressStatus TINYINT = 4,          
    @PendingStatus TINYINT = 5,          
    @ReOpenedStatus TINYINT = 6,          
    @ClosedStatus TINYINT = 7,          
    @SpecsInProgressStatus TINYINT = 8,          
    @DeletedStatus TINYINT = 9,          
 @PageIndex INT = NULL,           
 @PageSize INT = NULL,          
 @HighlightTaskId INT = 0          
)          
AS          
BEGIN          
 -- SET NOCOUNT ON added to prevent extra result sets from          
 -- interfering with SELECT statements.          
 SET NOCOUNT ON;          
          
 DECLARE @strt INT          
 DECLARE @StartIndex INT  = 0          
          
 IF @searchterm = ''           
 BEGIN          
  SET @searchterm = NULL          
 END          
          
 IF @PageIndex IS NULL          
 BEGIN          
  SET @PageIndex = 0          
 END          
          
 IF @PageSize IS NULL          
 BEGIN          
  SET @PageSize = 0          
 END          
          
 ;WITH          
 cteTaskList AS          
 (          
  SELECT           
   DISTINCT Tasks.*,          
   CASE Tasks.[Status]          
    WHEN @AssignedStatus THEN 1          
    WHEN @RequestedStatus THEN 1          
          
    WHEN @InProgressStatus THEN 2          
    WHEN @PendingStatus THEN 2          
    WHEN @ReOpenedStatus THEN 2          
          
    WHEN @OpenStatus THEN           
     CASE           
      WHEN ISNULL([TaskPriority],'') <> '' THEN 3          
      ELSE 4          
     END          
          
    WHEN @SpecsInProgressStatus THEN 4          
          
    WHEN @ClosedStatus THEN 5          
          
    WHEN @DeletedStatus THEN 6          
          
    ELSE 7          
   END AS StatusOrder
     
   --,
   --u.FristName + u.LastName as FLName,  
   --u.UserInstallId as AssignedUserId           
  FROM           
   [TaskListView] Tasks           
    LEFT JOIN [tbltaskassignedusers] tu ON Tasks.TaskId = tu.TaskId          
    LEFT JOIN [tblInstallUsers] u ON tu.UserId = u.Id           
  WHERE          
   Tasks.ParentTaskId = @TaskId           
   AND (          
     @searchterm IS NULL           
     OR u.Fristname like '%'+@searchterm+'%'          
    )          
   -- condition added by DP 23-jan-17 ---          
   --AND Tasks.TaskLevel=1          
 ),           
 cteSortedTaskList AS          
 (           
  SELECT          
   Tasks.*,          
   Row_number() OVER          
   (          
    ORDER BY          
     CASE WHEN @SortExpression = 'InstallId DESC' THEN Tasks.InstallId END DESC,          
     CASE WHEN @SortExpression = 'InstallId ASC' THEN Tasks.InstallId END ASC,          
     CASE WHEN @SortExpression = 'TaskLevel DESC' THEN Tasks.TaskLevel END DESC,          
     CASE WHEN @SortExpression = 'TaskLevel ASC' THEN Tasks.TaskLevel END ASC,          
     CASE WHEN @SortExpression = 'TaskId DESC' THEN Tasks.TaskId END DESC,          
     CASE WHEN @SortExpression = 'TaskId ASC' THEN Tasks.TaskId END ASC,          
     CASE WHEN @SortExpression = 'Title DESC' THEN Tasks.Title END DESC,          
     CASE WHEN @SortExpression = 'Title ASC' THEN Tasks.Title END ASC,          
     CASE WHEN @SortExpression = 'Description DESC' THEN Tasks.Description END DESC,          
     CASE WHEN @SortExpression = 'Description ASC' THEN Tasks.Description END ASC,          
     CASE WHEN @SortExpression = 'TaskDesignations DESC' THEN Tasks.TaskDesignations END DESC,          
     CASE WHEN @SortExpression = 'TaskDesignations ASC' THEN Tasks.TaskDesignations END ASC,          
     CASE WHEN @SortExpression = 'TaskAssignedUsers DESC' THEN Tasks.TaskAssignedUsers END DESC,          
     CASE WHEN @SortExpression = 'TaskAssignedUsers ASC' THEN Tasks.TaskAssignedUsers END ASC,          
     CASE WHEN @SortExpression = 'Status ASC' THEN Tasks.StatusOrder END ASC,          
     CASE WHEN @SortExpression = 'Status DESC' THEN Tasks.StatusOrder END DESC,          
     CASE WHEN @SortExpression = 'CreatedOn DESC' THEN Tasks.CreatedOn END DESC,          
     CASE WHEN @SortExpression = 'CreatedOn ASC' THEN Tasks.CreatedOn END ASC          
   ) AS RowNo_Order
      
  FROM          
   cteTaskList Tasks          
 )          
 ,          
 cteTasks          
 AS     (          
  SELECT           
   t1.*,           
   1 AS NestLevel          
  FROM cteSortedTaskList t1          
          
  UNION ALL          
          
  SELECT Tasks.*,          
   cteTasks.StatusOrder AS StatusOrder,          
   cteTasks.RowNo_Order,          
   (cteTasks.NestLevel + 1) AS NestLevel          
  FROM [TaskListView] Tasks           
    INNER JOIN cteTasks ON Tasks.ParentTaskId = cteTasks.TaskId          
 )          
          
 -- add records to temp table          
 SELECT *          
 INTO #Tasks          
 FROM cteTasks          
           
 -- update page index as per task to be highlighted          
 IF @HighlightTaskId > 0          
 BEGIN          
  DECLARE @RowNumber BIGINT = NULL          
          
  SELECT @RowNumber = RowNo_Order           
  FROM #Tasks           
  WHERE TaskId = @HighlightTaskId          
          
  IF @RowNumber IS NOT NULL          
  BEGIN          
   SELECT @PageIndex = (CEILING(@RowNumber / CAST(@PageSize AS FLOAT))) - 1          
  END          
 END            
          
 SET @StartIndex = (@PageIndex * @PageSize) + 1          
  
 -- get records          
 SELECT           
  Tasks.* ,          
  TaskApprovals.Id AS TaskApprovalId,          
  TaskApprovals.EstimatedHours AS TaskApprovalEstimatedHours,          
  TaskApprovals.Description AS TaskApprovalDescription,          
  TaskApprovals.UserId AS TaskApprovalUserId,          
  TaskApprovals.IsInstallUser AS TaskApprovalIsInstallUser,          
  (SELECT TOP 1 EstimatedHours           
   FROM [TaskApprovalsView] TaskApprovals           
   WHERE Tasks.TaskId = TaskApprovals.TaskId AND TaskApprovals.IsAdminOrITLead = 1) AS AdminOrITLeadEstimatedHours,          
  (SELECT TOP 1 EstimatedHours           
   FROM [TaskApprovalsView] TaskApprovals          
   WHERE Tasks.TaskId = TaskApprovals.TaskId AND TaskApprovals.IsAdminOrITLead = 0) AS UserEstimatedHours,          
  (SELECT TOP 1 InstallId           
   FROM tblTask t           
   WHERE ParentTaskId = Tasks.TaskId           
   ORDER BY t.TaskId DESC) AS LastSubTaskInstallId,    
   (SELECT Label from tblTaskMultilevelList     
      WHERE Id = (SELECT MAX(Id) FROM tblTaskMultilevelList WHERE ParentTaskId=Tasks.TaskId)    
   ) as LastChild      ,    
   (SELECT IndentLevel from tblTaskMultilevelList     
      WHERE Id = (SELECT MAX(Id) FROM tblTaskMultilevelList WHERE ParentTaskId=Tasks.TaskId)    
   ) as Indent    
  --,  
  -- case                             
  -- when (ParentTaskId is null and  TaskLevel=1) then Tasks.InstallId                             
  -- when (tasklevel =1 and ParentTaskId>0) then                             
  --  (select installid from tbltask where taskid=Tasks.parenttaskid) +'-'+Tasks.InstallId                              
  -- when (tasklevel =2 and ParentTaskId>0) then                            
  --  (select InstallId from tbltask where taskid in (                            
  -- (select parentTaskId from tbltask where   taskid=Tasks.parenttaskid) ))                            
  -- +'-'+ (select InstallId from tbltask where   taskid=Tasks.parenttaskid) + '-' +Tasks.InstallId                             
                                 
  -- when (tasklevel =3 and ParentTaskId>0) then                            
  -- (select InstallId from tbltask where taskid in (                   
  -- (select parenttaskid from tbltask where taskid in (                            
  -- (select parentTaskId from tbltask where   taskid=Tasks.parenttaskid) ))))                            
  -- +'-'+                            
  --  (select InstallId from tbltask where taskid in (                            
  -- (select parentTaskId from tbltask where   taskid=Tasks.parenttaskid) ))                            
  -- +'-'+ (select InstallId from tbltask where   taskid=Tasks.parenttaskid) + '-' +Tasks.InstallId                             
  --end as 'InstallId1'       ,  
  --iu.FristName + iu.LastName as FLName,  
  --iu.UserInstallId as AssignedUserId  
 FROM #Tasks AS Tasks          
   LEFT JOIN [TaskApprovalsView] TaskApprovals ON Tasks.TaskId = TaskApprovals.TaskId AND TaskApprovals.IsAdminOrITLead = @Admin          
   --left join [tblTaskAssignedUsers] tau on Tasks.TaskId = tau.TaskId  
   --left join tblInstallUsers iu on iu.id = tau.UserId  
 WHERE           
  RowNo_Order >= @StartIndex AND           
  (          
   @PageSize = 0 OR           
   RowNo_Order < (@StartIndex + @PageSize)          
  )          
 ORDER BY RowNo_Order          
      
 -- get records count          
 SELECT          
  COUNT(*) AS TotalRecords          
 FROM          
  [TaskListView] Tasks           
   LEFT JOIN [TaskApprovalsView] TaskApprovals ON Tasks.TaskId = TaskApprovals.TaskId AND TaskApprovals.IsAdminOrITLead = @Admin          
   LEFT JOIN [tbltaskassignedusers] tu ON Tasks.TaskId = tu.TaskId          
   LEFT JOIN [tblInstallUsers] u ON tu.UserId = u.Id           
 WHERE          
  Tasks.ParentTaskId = @TaskId           
  AND (          
    @searchterm IS NULL           
    OR u.Fristname like '%'+@searchterm+'%'          
   )          
  -- condition added by DP 23-jan-17 ---          
  --AND Tasks.TaskLevel=1          
          
 -- get page index          
 SELECT @PageIndex AS PageIndex          
    --get user files      
 SELECT       
   tuf.Id,      
   tuf.TaskId,      
   CAST(      
     tuf.[Attachment] + '@' + tuf.[AttachmentOriginal]       
     AS VARCHAR(MAX)      
 ) AS attachment,      
   ISNULL(u.FirstName,iu.FristName) AS FirstName,      
   UpdatedOn,      
   ROW_NUMBER() OVER(ORDER BY tuf.ID ASC) AS RowNumber      
  FROM dbo.tblTaskUserFiles tuf      
    LEFT JOIN tblUsers u ON tuf.UserId = u.Id --AND tuf.UserType = u.Usertype      
    LEFT JOIN tblInstallUsers iu ON tuf.UserId = iu.Id --AND tuf.UserType = u.UserType      
  WHERE       
   tuf.TaskId in (Select TaskId from #Tasks) AND       
   tuf.FileDestination = 2      
          
 DROP TABLE #Tasks          
           
 -- gets last sub task installId          
 SELECT TOP 1 InstallId AS LastSubTaskInstallId          
 FROM tblTask t           
 WHERE ParentTaskId = @TaskId          
 ORDER BY t.TaskId DESC          
           
END 