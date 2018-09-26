ALTER PROCEDURE [dbo].[usp_GetAllInProAssReqTaskWithSequence]                           
(                          
                         
 @PageIndex INT = 0,                           
 @PageSize INT =20,                    
 @DesignationIds VARCHAR(200) = NULL,                               
 @UserStatus INT = NULL,  
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
  
IF( @DesignationIds = '' )                    
BEGIN                    
                    
 SET @DesignationIds = NULL                    
                    
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
 AND a.[Status] in (1,2,3,4)  
 AND iu.[Status] = @UserStatus  
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
 --ORDER BY  [Sequence]  DESC                        
ORDER BY CASE [Status]   
    WHEN 4 THEN 1   
    WHEN 3 THEN 2   
    WHEN 2 THEN 3   
 WHEN 1 THEN 4  
 WHEN 8 THEN 5  
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
ORDER BY CASE [Status]   
    WHEN 4 THEN 1   
    WHEN 3 THEN 2   
    WHEN 2 THEN 3   
 WHEN 1 THEN 4  
 WHEN 8 THEN 5  
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
                    
 DROP TABLE #Tasks                    
 DROP TABLE #S      
 DROP TABLE #SS   
                        
END   
GO

      
ALTER PROCEDURE [dbo].[SP_GetInstallUsers]          
 @Key int,        
 @Designations varchar(4000),      
 @ActiveStatus varchar(5) = '1',      
 @InterviewDateStatus varchar(5) = '5',      
 @OfferMadeStatus varchar(5) = '6'      
AS          
BEGIN          
      
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
  SELECT FristName + ' ' + ISNULL(NameMiddleInitial + '. ','') + LastName + ' - ' + ISNULL(UserInstallId,'') as FristName,Id , [Status],ISNULL(UserInstallId,'') as  UserInstallId      
  FROM tblinstallUsers       
  WHERE        
   (FristName IS NOT NULL AND RTRIM(LTRIM(FristName)) <> '' )  AND       
   (      
    tblinstallUsers.[Status] = @ActiveStatus OR       
    tblinstallUsers.[Status] = @OfferMadeStatus OR       
    tblinstallUsers.[Status] = @InterviewDateStatus      
   ) AND       
   (      
    Designation IN (SELECT Item FROM dbo.SplitString(@Designations,','))      
    OR      
    Convert(Nvarchar(max),DesignationID)  IN (SELECT Item FROM dbo.SplitString(@Designations,','))      
   )      
  ORDER BY CASE WHEN [Status] = '1' THEN 1 ELSE 2 END, [Status], DesignationID ,FristName + ' ' + LastName      
  
 END      
END       

GO

create procedure sp_AddMultiLevelChlild  
@ParentTaskId int,@InstallId varchar(max),@Description varchar(MAX),@IndentLevel int,@Class varchar(50)  
as  
insert into tblTaskMultilevelList  
values  
(@ParentTaskId ,@InstallId ,@Description ,@IndentLevel ,@Class )

GO

CREATE procedure sp_GetMultiLevelList  
@ParentTaskId varchar(max)  
as  
select * from tblTaskMultilevelList m where ParentTaskId in   
(SELECT * FROM [dbo].[SplitString](ISNULL(@ParentTaskId,m.ParentTaskId),',') )

GO

CREATE PROCEDURE [dbo].[UpdateTaskDescriptionChildById]  
 @TaskId bigint,    
 @Description varchar(max)    
AS    
BEGIN    
    
 SET NOCOUNT ON;    
    
 UPDATE tblTaskMultilevelList    
 SET     
  [Description] = @Description    
      
 WHERE Id = @TaskId    
    
END 

GO

CREATE procedure usp_GetInstallUsersByPrefix  
(@Prefix varchar(max))  
as  
begin  
select Id,(UserInstallId + ' - ' + FristName + ' ' + LastName) as Name,Email from tblInstallUsers  
where UserInstallId like @Prefix+'%' or FristName like @Prefix +'%'  or LastName like @Prefix +'%'  
or FristName+' '+LastName like @Prefix +'%'  
end  

GO

       
ALTER PROCEDURE [dbo].[usp_GetSubTasks_New]           
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
   ,  
   case                             
   when (ParentTaskId is null and  TaskLevel=1) then Tasks.InstallId                             
   when (tasklevel =1 and ParentTaskId>0) then                             
    (select installid from tbltask where taskid=Tasks.parenttaskid) +'-'+Tasks.InstallId                              
   when (tasklevel =2 and ParentTaskId>0) then                            
    (select InstallId from tbltask where taskid in (                            
   (select parentTaskId from tbltask where   taskid=Tasks.parenttaskid) ))                            
   +'-'+ (select InstallId from tbltask where   taskid=Tasks.parenttaskid) + '-' +Tasks.InstallId                             
                                 
   when (tasklevel =3 and ParentTaskId>0) then                            
   (select InstallId from tbltask where taskid in (                   
   (select parenttaskid from tbltask where taskid in (                            
   (select parentTaskId from tbltask where   taskid=Tasks.parenttaskid) ))))                            
   +'-'+                            
    (select InstallId from tbltask where taskid in (                            
   (select parentTaskId from tbltask where   taskid=Tasks.parenttaskid) ))                            
   +'-'+ (select InstallId from tbltask where   taskid=Tasks.parenttaskid) + '-' +Tasks.InstallId                             
  end as 'InstallId1'       ,  
  iu.FristName + iu.LastName as FLName,  
  iu.UserInstallId as AssignedUserId  
 FROM #Tasks AS Tasks          
   LEFT JOIN [TaskApprovalsView] TaskApprovals ON Tasks.TaskId = TaskApprovals.TaskId AND TaskApprovals.IsAdminOrITLead = @Admin          
   left join [tblTaskAssignedUsers] tau on Tasks.TaskId = tau.TaskId  
   left join tblInstallUsers iu on iu.id = tau.UserId  
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

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[tblTaskMultilevelList](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[ParentTaskId] [int] NULL,
	[InstallId] [varchar](50) NULL,
	[Description] [varchar](max) NULL,
	[IndentLevel] [int] NULL,
	[Label] [varchar](50) NULL,
 CONSTRAINT [PK_tblTaskMultilevelList] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO


------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

-- Live publish 13 Nove 2017

------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------