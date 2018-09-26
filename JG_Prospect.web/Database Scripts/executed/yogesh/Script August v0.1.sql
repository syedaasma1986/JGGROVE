-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
    
-- =============================================                      
-- Author:  Yogesh Keraliya                      
-- Create date: 05222017                      
-- Description: This will load all tasks with title and sequence                      
-- =============================================                      
-- usp_GetAllTaskWithSequence 0,20,'',10,575                

IF EXISTS (SELECT * FROM sysobjects WHERE id = object_id(N'[dbo].[usp_GetAllTaskWithSequence]') AND OBJECTPROPERTY(id, N'IsProcedure') = 1)
	BEGIN
 
	DROP PROCEDURE usp_GetAllTaskWithSequence   

	END  
GO    

CREATE PROCEDURE usp_GetAllTaskWithSequence                       
(                      
                     
 @PageIndex INT = 0,                       
 @PageSize INT =20,                
 @DesignationIds VARCHAR(20) = NULL,                
 @IsTechTask BIT = 0,                
 @HighLightedTaskID BIGINT = NULL                
                        
)                      
As                      
BEGIN                      
                
                
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
  --(SELECT TOP 1 DesignationID                   
  --         FROM tblTaskdesignations td                     
  --         WHERE td.TaskID = a.TaskId ) AS DesignationId                   
   from  tbltask a                      
   --LEFT OUTER JOIN tblTaskdesignations as b ON a.TaskId = b.TaskId                       
   --LEFT OUTER JOIN tbltaskassignedusers as c ON a.TaskId = c.TaskId                      
   LEFT OUTER JOIN tblInstallUsers as ta ON a.[AdminUserId] = ta.Id       
   LEFT OUTER JOIN tblInstallUsers as tT ON a.[TechLeadUserId] = tT.Id       
   LEFT OUTER JOIN tblInstallUsers as tU ON a.[OtherUserId] = tU.Id   
  -- LEFT OUTER JOIN tbltaskassignedusers as tau ON a.TaskId = tau.TaskId                      
   WHERE                 
  (                 
    (a.[Sequence] IS NOT NULL)                 
    AND (a.[SequenceDesignationId] IN (SELECT * FROM [dbo].[SplitString](ISNULL(@DesignationIds,a.[SequenceDesignationId]),',') ) )                 
    AND (ISNULL(a.[IsTechTask],@IsTechTask) = @IsTechTask)                
                   
   )                 
   OR                
   (                
     a.TaskId = @HighLightedTaskID  AND IsTechTask = @IsTechTask              
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
 ORDER BY CASE WHEN (TaskId = @HighLightedTaskID) THEN 0 ELSE 1 END , [Sequence]  DESC                    
    
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
 ORDER BY CASE WHEN (TaskId = @HighLightedTaskID) THEN 0 ELSE 1 END , [Sequence]  DESC                    
    
    
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
                
                    
END 
----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

/****** Object:  View [dbo].[TaskListView]    Script Date: 8/13/2017 6:17:35 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


ALTER VIEW [dbo].[TaskListView] 
AS
SELECT 
	Tasks.*,

	TaskCreator.Id AS TaskCreatorId,
	TaskCreator.InstallId AS TaskCreatorInstallId,
	TaskCreator.FristName AS TaskCreatorUsername, 
	TaskCreator.FristName AS TaskCreatorFirstName, 
	TaskCreator.LastName AS TaskCreatorLastName, 
	TaskCreator.Email AS TaskCreatorEmail,

	--AdminUser.Id AS AdminUserId,
	AdminUser.InstallId AS AdminUserInstallId,
	AdminUser.Username AS AdminUsername,
	AdminUser.FirstName AS AdminUserFirstName,
	AdminUser.LastName AS AdminUserLastName,
	AdminUser.Email AS AdminUserEmail,
			
	--TechLeadUser.Id AS TechLeadUserId,
	TechLeadUser.InstallId AS TechLeadUserInstallId,
	TechLeadUser.Username AS TechLeadUsername,
	TechLeadUser.FirstName AS TechLeadUserFirstName,
	TechLeadUser.LastName AS TechLeadUserLastName,
	TechLeadUser.Email AS TechLeadUserEmail,

	--OtherUser.Id AS OtherUserId,
	OtherUser.InstallId AS OtherUserInstallId,
	OtherUser.Username AS OtherUsername,
	OtherUser.FirstName AS OtherUserFirstName,
	OtherUser.LastName AS OtherUserLastName,
	OtherUser.Email AS OtherUserEmail,
	STUFF
	(
		(SELECT  CAST(', ' + td.Designation as VARCHAR) AS Designation
		FROM tblTaskDesignations td
		WHERE td.TaskId = Tasks.TaskId
		FOR XML PATH(''), TYPE).value('.','NVARCHAR(MAX)')
		,1
		,2
		,' '
	) AS TaskDesignations,
	STUFF
	(
		(SELECT  CAST(', ' + CONVERT(VARCHAR(5), td.DesignationID) as VARCHAR)
		FROM tblTaskDesignations td
		WHERE td.TaskId = Tasks.TaskId
		FOR XML PATH(''), TYPE).value('.','NVARCHAR(MAX)')
		,1
		,2
		,' '
	) AS TaskDesignationIds,
	STUFF
	(
		(SELECT  CAST(', ' + u.FristName + ' ' + u.LastName as VARCHAR) AS Name
		FROM tblTaskAssignedUsers tu
			INNER JOIN tblInstallUsers u ON tu.UserId = u.Id
		WHERE tu.TaskId = Tasks.TaskId
		FOR XML PATH(''), TYPE).value('.','NVARCHAR(MAX)')
		,1
		,2
		,' '
	) AS TaskAssignedUsers,
	STUFF
	(
		(SELECT  ',' + CAST(tu.UserId as VARCHAR) AS Id
		FROM tblTaskAssignedUsers tu
		WHERE tu.TaskId = Tasks.TaskId
		FOR XML PATH(''), TYPE).value('.','NVARCHAR(MAX)')
		,1
		,1
		,''
	) AS TaskAssignedUserIds,
	STUFF
	(
		(SELECT  CAST(', ' + CAST(tu.UserId AS VARCHAR) + ':' + u.FristName as VARCHAR) AS Name
		FROM tblTaskAssignmentRequests tu
			INNER JOIN tblInstallUsers u ON tu.UserId = u.Id
		WHERE tu.TaskId = Tasks.TaskId
		FOR XML PATH(''), TYPE).value('.','NVARCHAR(MAX)')
		,1
		,2
		,' '
	) AS TaskAssignmentRequestUsers,
	STUFF
	(
		(SELECT  ', ' + CAST(tu.UserId AS VARCHAR) AS UserId
		FROM tblTaskAcceptance tu
		WHERE tu.TaskId = Tasks.TaskId
		FOR XML PATH(''), TYPE).value('.','NVARCHAR(MAX)')
		,1
		,2
		,' '
	) AS TaskAcceptanceUsers,
	STUFF
	(
		(SELECT  CAST(
						', ' + CAST(tuf.[Id] AS VARCHAR) + 
						'@' + tuf.[Attachment] + 
						'@' + tuf.[AttachmentOriginal]  + 
						'@' + CAST( tuf.[AttachedFileDate] AS VARCHAR(100)) + 
						'@' + (
								CASE 
									WHEN ctuser.Id IS NULL THEN 'N.A.' 
									ELSE ISNULL(ctuser.FirstName,'') + ' ' + ISNULL(ctuser.LastName ,'')
								END
							) as VARCHAR(max)) AS attachment
		FROM dbo.tblTaskUserFiles tuf  
			OUTER APPLY
			(
				SELECT TOP 1 iu.Id, iu.FristName AS Username, iu.FristName AS FirstName, iu.LastName, iu.Email
				FROM tblInstallUsers iu
				WHERE iu.Id = tuf.UserId
			
				UNION

				SELECT TOP 1 u.Id,u.Username AS Username, u.FirstName AS FirstName, u.LastName, u.Email
				FROM tblUsers u
				WHERE u.Id = tuf.UserId
			) AS ctuser
		WHERE tuf.TaskId = Tasks.TaskId AND tuf.IsDeleted <> 1
		FOR XML PATH(''), TYPE).value('.','NVARCHAR(MAX)')
		,1
		,2
		,' '
	) AS TaskUserFiles
FROM          
	tblTask AS Tasks
		LEFT JOIN tblInstallUsers TaskCreator ON TaskCreator.Id = Tasks.CreatedBy
		OUTER APPLY
		(
			SELECT TOP 1 iu.Id, iu.InstallId ,iu.FristName AS Username, iu.FristName AS FirstName, iu.LastName, iu.Email
			FROM tblInstallUsers iu
			WHERE iu.Id = Tasks.AdminUserId AND Tasks.IsAdminInstallUser = 1
			
			UNION

			SELECT TOP 1 u.Id, '' AS InstallId ,u.Username AS Username, u.FirstName AS FirstName, u.LastName, u.Email
			FROM tblUsers u
			WHERE u.Id = Tasks.AdminUserId AND Tasks.IsAdminInstallUser = 0
		) AS AdminUser
		OUTER APPLY
		(
			SELECT TOP 1 iu.Id, iu.InstallId ,iu.FristName AS Username, iu.FristName AS FirstName, iu.LastName, iu.Email
			FROM tblInstallUsers iu
			WHERE iu.Id = Tasks.TechLeadUserId AND Tasks.IsTechLeadInstallUser = 1
			
			UNION

			SELECT TOP 1 u.Id, '' AS InstallId ,u.Username AS Username, u.FirstName AS FirstName, u.LastName, u.Email
			FROM tblUsers u
			WHERE u.Id = Tasks.TechLeadUserId AND Tasks.IsTechLeadInstallUser = 0
		) AS TechLeadUser
		OUTER APPLY
		(
			SELECT TOP 1 iu.Id, iu.InstallId ,iu.FristName AS Username, iu.FristName AS FirstName, iu.LastName, iu.Email
			FROM tblInstallUsers iu
			WHERE iu.Id = Tasks.OtherUserId AND Tasks.IsOtherUserInstallUser = 1
			
			UNION

			SELECT TOP 1 u.Id, '' AS InstallId ,u.Username AS Username, u.FirstName AS FirstName, u.LastName, u.Email
			FROM tblUsers u
			WHERE u.Id = Tasks.OtherUserId AND Tasks.IsOtherUserInstallUser = 0
		) AS OtherUser

---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

IF EXISTS (SELECT * FROM sysobjects WHERE id = object_id(N'[dbo].[sp_GetHrData]') AND OBJECTPROPERTY(id, N'IsProcedure') = 1)
	BEGIN
 
	DROP PROCEDURE [sp_GetHrData]   

	END  
GO    

 
-- [sp_GetHrData] NULL,'0',0,0, 0, NULL, NULL,0,20, 'CreatedDateTime DESC','5','9','6','1'  
CREATE PROCEDURE [dbo].[sp_GetHrData]  
 @SearchTerm VARCHAR(15) = NULL, @Status VARCHAR(50), @DesignationId INT, @SourceId INT, @AddedByUserId INT, @FromDate DATE = NULL,  
 @ToDate DATE = NULL, @PageIndex INT = NULL,  @PageSize INT = NULL, @SortExpression VARCHAR(50), @InterviewDateStatus VARChAR(5) = '5',  
 @RejectedStatus VARChAR(5) = '9', @OfferMadeStatus VARChAR(5) = '6', @ActiveStatus VARChAR(5) = '1'   
AS  
BEGIN   
SET NOCOUNT ON;  
  
 IF @Status = '0'  
 BEGIN  
  SET @Status = NULL  
 END  
 IF @DesignationId = '0'  
 BEGIN  
  SET @DesignationId = NULL  
 END  
 IF @SourceId = '0'  
 BEGIN  
  SET @SourceId = NULL  
 END  
 IF @AddedByUserId = 0  
 BEGIN  
  SET @AddedByUserId = NULL  
 END  
   
 SET @PageIndex = isnull(@PageIndex,0)  
 SET @PageSize = isnull(@PageSize,0)  
   
 DECLARE @StartIndex INT  = 0  
 SET @StartIndex = (@PageIndex * @PageSize) + 1  
    
  -- get statistics (Status) - Table 0   
  SELECT t.Status, COUNT(*) [Count]  
  FROM tblInstallUsers t   
   LEFT OUTER JOIN tblUsers U ON U.Id = t.SourceUser  
   LEFT OUTER JOIN tblUsers ru on t.RejectedUserId=ru.Id  
   WHERE   
  (t.UserType = 'SalesUser' OR t.UserType = 'sales')  
  AND CAST(t.CreatedDateTime as date) >= CAST(ISNULL(@FromDate,t.CreatedDateTime) as date)   
  AND CAST(t.CreatedDateTime as date) <= CAST(ISNULL(@ToDate,t.CreatedDateTime) as date)  
 GROUP BY t.status  
  
 -- get statistics (AddedBy) - Table 1  
 SELECT ISNULL(U.Username, t2.FristName + '' + t2.LastName)  AS AddedBy, COUNT(*) [Count]   
 FROM tblInstallUsers t  
   LEFT OUTER JOIN tblUsers U ON U.Id = t.SourceUser  
   LEFT OUTER JOIN tblInstallUsers t2 ON t2.Id = t.SourceUser  
   LEFT OUTER JOIN tblUsers ru on t.RejectedUserId=ru.Id  
   LEFT OUTER JOIN tblInstallUsers t1 ON t1.Id= U.Id  
 WHERE (t.UserType = 'SalesUser' OR t.UserType = 'sales')  
  AND CAST(t.CreatedDateTime as date) >= CAST(ISNULL(@FromDate,t.CreatedDateTime) as date)  
  AND CAST(t.CreatedDateTime as date) <= CAST(ISNULL(@ToDate,t.CreatedDateTime) as date)  
 GROUP BY U.Username,t2.FristName,t2.LastName  
  
 -- get statistics (Designation) - Table 2  
 SELECT t.Designation, COUNT(*) [Count]   
 FROM tblInstallUsers t  
   LEFT OUTER JOIN tblUsers U ON U.Id = t.SourceUser  
   LEFT OUTER JOIN tblUsers ru on t.RejectedUserId=ru.Id  
   LEFT OUTER JOIN tblInstallUsers t1 ON t1.Id= U.Id  
 WHERE (t.UserType = 'SalesUser' OR t.UserType = 'sales')  
  AND CAST(t.CreatedDateTime as date) >= CAST(ISNULL(@FromDate,t.CreatedDateTime) as date)  
  AND CAST(t.CreatedDateTime as date) <= CAST(ISNULL(@ToDate,t.CreatedDateTime) as date)  
 GROUP BY t.Designation  
  
 -- get statistics (Source) - Table 3  
 SELECT t.Source, COUNT(*) [Count]  
 FROM tblInstallUsers t  
   LEFT OUTER JOIN tblUsers U ON U.Id = t.SourceUser  
   LEFT OUTER JOIN tblUsers ru on t.RejectedUserId=ru.Id  
   LEFT OUTER JOIN tblInstallUsers t1 ON t1.Id= U.Id  
 WHERE (t.UserType = 'SalesUser' OR t.UserType = 'sales')  
  AND CAST(t.CreatedDateTime as date) >= CAST(ISNULL(@FromDate,t.CreatedDateTime) as date)  
  AND CAST(t.CreatedDateTime as date) <= CAST(ISNULL(@ToDate,t.CreatedDateTime) as date)  
 GROUP BY t.Source  
  
 -- get records - Table 4  
 ;WITH SalesUsers  
 AS  
 (SELECT t.Id, t.FristName, t.LastName, t.Phone, t.Zip, t.City, d.DesignationName AS Designation, t.Status, t.HireDate, t.InstallId,  
 t.picture, t.CreatedDateTime, Isnull(s.Source,'') AS Source, t.SourceUser, ISNULL(U.Username,t2.FristName + ' ' + t2.LastName)  
 AS AddedBy, ISNULL (t.UserInstallId,t.id) As UserInstallId,  
 InterviewDetail = case when (t.Status=@InterviewDateStatus) then CAST(coalesce(t.RejectionDate,'') AS VARCHAR)  + ' ' + coalesce(t.InterviewTime,'')   
       else '' end,  
 RejectDetail = case when (t.[Status]=@RejectedStatus ) then CAST(coalesce(t.RejectionDate,'') AS VARCHAR) + ' ' + coalesce(t.RejectionTime,'')   
       else '' end,  
 CASE when (t.[Status]= @RejectedStatus ) THEN t.RejectedUserId ELSE NULL END AS RejectedUserId,  
 CASE when (t.[Status]= @RejectedStatus ) THEN ru.FristName + ' ' + ru.LastName ELSE NULL END AS RejectedByUserName,  
 CASE when (t.[Status]= @RejectedStatus ) THEN ru.[UserInstallId]  ELSE NULL END AS RejectedByUserInstallId,  
 t.Email, t.DesignationID, ISNULL(t1.[UserInstallId], t2.[UserInstallId]) As AddedByUserInstallId,  
 ISNULL(t1.Id,t2.Id) As AddedById, t.emptype as 'EmpType', t.Phone As PrimaryPhone, t.CountryCode, t.Resumepath,  
 --ISNULL (ISNULL (t1.[UserInstallId],t1.id),t.Id) As AddedByUserInstallId,  
 Task.TaskId AS 'TechTaskId', Task.ParentTaskId AS 'ParentTechTaskId', Task.InstallId as 'TechTaskInstallId', bm.bookmarkedUser,  
 t.[StatusReason], dbo.udf_GetUserExamPercentile(t.Id) AS [Aggregate],  
 ROW_NUMBER() OVER(ORDER BY  
   CASE WHEN @SortExpression = 'Id ASC' THEN t.Id END ASC,  
   CASE WHEN @SortExpression = 'Id DESC' THEN t.Id END DESC,  
   CASE WHEN @SortExpression = 'Status ASC' THEN t.Status END ASC,  
   CASE WHEN @SortExpression = 'Status DESC' THEN t.Status END DESC,  
   CASE WHEN @SortExpression = 'FristName ASC' THEN t.FristName END ASC,  
   CASE WHEN @SortExpression = 'FristName DESC' THEN t.FristName END DESC,  
   CASE WHEN @SortExpression = 'Designation ASC' THEN d.DesignationName END ASC,  
   CASE WHEN @SortExpression = 'Designation DESC' THEN d.DesignationName END DESC,  
   CASE WHEN @SortExpression = 'Source ASC' THEN s.Source END ASC,  
   CASE WHEN @SortExpression = 'Source DESC' THEN s.Source END DESC,  
   CASE WHEN @SortExpression = 'Phone ASC' THEN t.Phone END ASC,  
   CASE WHEN @SortExpression = 'Phone DESC' THEN t.Phone END DESC,  
   CASE WHEN @SortExpression = 'Zip ASC' THEN t.Phone END ASC,  
   CASE WHEN @SortExpression = 'Zip DESC' THEN t.Phone END DESC,   
   CASE WHEN @SortExpression = 'City ASC' THEN t.City END ASC,  
   CASE WHEN @SortExpression = 'City DESC' THEN t.City END DESC,   
   CASE WHEN @SortExpression = 'CreatedDateTime ASC' THEN t.CreatedDateTime END ASC,  
   CASE WHEN @SortExpression = 'CreatedDateTime DESC' THEN t.CreatedDateTime END DESC   
       ) AS RowNumber,  
    '' as Country  
  FROM tblInstallUsers t  
  LEFT OUTER JOIN tblUsers U ON U.Id = t.SourceUser  
  LEFT OUTER JOIN tblInstallUsers t2 ON t2.Id = t.SourceUser  
  LEFT OUTER JOIN tblInstallUsers ru on t.RejectedUserId= ru.Id  
  LEFT OUTER JOIN tblInstallUsers t1 ON t1.Id= U.Id  
  LEFT OUTER JOIN tbl_Designation d ON t.DesignationId = d.Id  
  LEFT JOIN tblSource s ON t.SourceId = s.Id  
  left outer join InstallUserBMLog as bm on t.id  =bm.bookmarkedUser and bm.isDeleted=0  
  OUTER APPLY  
 (   
 SELECT tsk.TaskId, tsk.ParentTaskId, tsk.InstallId, ROW_NUMBER() OVER(ORDER BY u.TaskUserId DESC) AS RowNo  
 FROM tblTaskAssignedUsers u  
 INNER JOIN tblTask tsk ON u.TaskId = tsk.TaskId AND  
 (tsk.ParentTaskId IS NOT NULL OR tsk.IsTechTask = 1)  
 WHERE u.UserId = t.Id  
 ) AS Task  
 WHERE (t.UserType = 'SalesUser' OR t.UserType = 'sales') AND (@SearchTerm IS NULL OR   
    1 = CASE WHEN t.InstallId LIKE '%'+ @SearchTerm + '%' THEN 1  
  WHEN t.FristName LIKE '%'+ @SearchTerm + '%' THEN 1  
  WHEN t.LastName LIKE '%'+ @SearchTerm + '%' THEN 1  
  WHEN t.Email LIKE '%'+ @SearchTerm + '%' THEN 1  
  WHEN t.Phone LIKE '%'+ @SearchTerm + '%' THEN 1  
  WHEN t.CountryCode LIKE '%'+ @SearchTerm + '%' THEN 1  
  WHEN t.Zip LIKE '%'+ @SearchTerm + '%' THEN 1  
  WHEN t.City LIKE '%'+ @SearchTerm + '%' THEN 1  
  ELSE 0  
  END  
  )  
 AND ISNULL(t.Status,'') = ISNULL(@Status, ISNULL(t.Status,''))  
 AND t.Status NOT IN (@OfferMadeStatus, @ActiveStatus)  
 AND ISNULL(d.Id,'') = ISNULL(@DesignationId, ISNULL(d.Id,''))  
 AND ISNULL(s.Id,'') = ISNULL(@SourceId, ISNULL(s.Id,''))  
 --AND ISNULL(U.Id,'')=ISNULL(@AddedByUserId,ISNULL(U.Id,''))  
 AND ISNULL(t1.Id,t2.Id)=ISNULL(@AddedByUserId,ISNULL(t1.Id,t2.Id))  
 AND CAST(t.CreatedDateTime as date) >= CAST(ISNULL(@FromDate,t.CreatedDateTime) as date)  
 AND CAST(t.CreatedDateTime as date) <= CAST(ISNULL(@ToDate,t.CreatedDateTime) as date)  
)  
SELECT  Id, FristName, LastName, Phone, Zip, Designation, Status, HireDate, InstallId, picture, CreatedDateTime, Source, SourceUser,  
AddedBy, UserInstallId, InterviewDetail, RejectDetail, RejectedUserId, RejectedByUserName, RejectedByUserInstallId, Email, DesignationID,  
AddedByUserInstallId, AddedById, EmpType, [Aggregate], PrimaryPhone, CountryCode, Resumepath, TechTaskId, ParentTechTaskId,  
TechTaskInstallId, bookmarkedUser,  [StatusReason], Country, City  
FROM SalesUsers  
WHERE RowNumber >= @StartIndex AND (@PageSize = 0 OR RowNumber < (@StartIndex + @PageSize))  
group by Id, FristName, LastName, Phone, Zip, Designation, Status, HireDate, InstallId, picture, CreatedDateTime, Source, SourceUser,  
AddedBy, UserInstallId, InterviewDetail, RejectDetail, RejectedUserId, RejectedByUserName, RejectedByUserInstallId, Email, DesignationID,  
AddedByUserInstallId, AddedById, EmpType, [Aggregate], PrimaryPhone, CountryCode, Resumepath, TechTaskId, ParentTechTaskId,  
TechTaskInstallId, bookmarkedUser,  [StatusReason], Country, City  
ORDER BY CASE WHEN @SortExpression = 'Id ASC' THEN Id END ASC,  
   CASE WHEN @SortExpression = 'Id DESC' THEN Id END DESC,  
   CASE WHEN @SortExpression = 'Status ASC' THEN Status END ASC,  
   CASE WHEN @SortExpression = 'Status DESC' THEN Status END DESC,  
   CASE WHEN @SortExpression = 'FristName ASC' THEN FristName END ASC,  
   CASE WHEN @SortExpression = 'FristName DESC' THEN FristName END DESC,  
   CASE WHEN @SortExpression = 'Designation ASC' THEN Designation END ASC,  
   CASE WHEN @SortExpression = 'Designation DESC' THEN Designation END DESC,  
   CASE WHEN @SortExpression = 'Source ASC' THEN Source END ASC,  
   CASE WHEN @SortExpression = 'Source DESC' THEN Source END DESC,  
   CASE WHEN @SortExpression = 'Phone ASC' THEN Phone END ASC,  
   CASE WHEN @SortExpression = 'Phone DESC' THEN Phone END DESC,  
   CASE WHEN @SortExpression = 'Zip ASC' THEN Phone END ASC,  
   CASE WHEN @SortExpression = 'Zip DESC' THEN Phone END DESC,  
   CASE WHEN @SortExpression = 'CreatedDateTime ASC' THEN CreatedDateTime END ASC,  
   CASE WHEN @SortExpression = 'CreatedDateTime DESC' THEN CreatedDateTime END DESC  
  
 -- get record count - Table 5  
 SELECT COUNT(*) AS TotalRecordCount  
 FROM tblInstallUsers t  
 LEFT OUTER JOIN tblUsers U ON U.Id = t.SourceUser  
 LEFT OUTER JOIN tblUsers ru on t.RejectedUserId=ru.Id  
 LEFT OUTER JOIN tblInstallUsers t1 ON t1.Id= U.Id  
 LEFT OUTER JOIN tbl_Designation d ON t.DesignationId = d.Id  
 LEFT JOIN tblSource s ON t.SourceId = s.Id  
 WHERE (t.UserType = 'SalesUser' OR t.UserType = 'sales') AND (@SearchTerm IS NULL OR  
   1 = CASE WHEN t.InstallId LIKE '%'+ @SearchTerm + '%' THEN 1  
    WHEN t.FristName LIKE '%'+ @SearchTerm + '%' THEN 1  
    WHEN t.LastName LIKE '%'+ @SearchTerm + '%' THEN 1  
    WHEN t.Email LIKE '%'+ @SearchTerm + '%' THEN 1  
    WHEN t.Phone LIKE '%'+ @SearchTerm + '%' THEN 1  
    WHEN t.CountryCode LIKE '%'+ @SearchTerm + '%' THEN 1  
    WHEN t.Zip LIKE '%'+ @SearchTerm + '%' THEN 1  
    ELSE 0 END)  
  AND ISNULL(t.Status,'') = ISNULL(@Status, ISNULL(t.Status,''))  
  AND t.Status NOT IN (@OfferMadeStatus, @ActiveStatus)  
  AND ISNULL(d.Id,'') = ISNULL(@DesignationId, ISNULL(d.Id,''))  
  AND ISNULL(s.Id,'') = ISNULL(@SourceId, ISNULL(s.Id,''))  
  AND ISNULL(U.Id,'')=ISNULL(@AddedByUserId,ISNULL(U.Id,''))  
  AND CAST(t.CreatedDateTime as date) >= CAST(ISNULL(@FromDate,t.CreatedDateTime) as date)  
  AND CAST(t.CreatedDateTime as date) <= CAST(ISNULL(@ToDate,t.CreatedDateTime) as date)  
  
  -- Get the Total Count - Table 6  
   SELECT Count(*) as TCount  
  FROM tblInstallUsers t  
  LEFT OUTER JOIN tblUsers U ON U.Id = t.SourceUser  
  LEFT OUTER JOIN tblInstallUsers t2 ON t2.Id = t.SourceUser  
  LEFT OUTER JOIN tblInstallUsers ru on t.RejectedUserId= ru.Id  
  LEFT OUTER JOIN tblInstallUsers t1 ON t1.Id= U.Id  
  LEFT OUTER JOIN tbl_Designation d ON t.DesignationId = d.Id  
  LEFT JOIN tblSource s ON t.SourceId = s.Id  
  left outer join InstallUserBMLog as bm on t.id  =bm.bookmarkedUser and bm.isDeleted=0  
  OUTER APPLY(    SELECT TOP 1 tsk.TaskId, tsk.ParentTaskId, tsk.InstallId, ROW_NUMBER() OVER(ORDER BY u.TaskUserId DESC) AS RowNo  
  FROM tblTaskAssignedUsers u  
  INNER JOIN tblTask tsk ON u.TaskId = tsk.TaskId AND (tsk.ParentTaskId IS NOT NULL OR tsk.IsTechTask = 1)  
  WHERE u.UserId = t.Id  
   ) AS Task  
  WHERE (t.UserType = 'SalesUser' OR t.UserType = 'sales') AND (@SearchTerm IS NULL OR  
    1 = CASE WHEN t.InstallId LIKE '%'+ @SearchTerm + '%' THEN 1  
  WHEN t.FristName LIKE '%'+ @SearchTerm + '%' THEN 1  
  WHEN t.LastName LIKE '%'+ @SearchTerm + '%' THEN 1  
  WHEN t.Email LIKE '%'+ @SearchTerm + '%' THEN 1  
  WHEN t.Phone LIKE '%'+ @SearchTerm + '%' THEN 1  
  WHEN t.CountryCode LIKE '%'+ @SearchTerm + '%' THEN 1  
  WHEN t.Zip LIKE '%'+ @SearchTerm + '%' THEN 1  
  WHEN t.City LIKE '%'+ @SearchTerm + '%' THEN 1  
  ELSE 0 END)  
   AND ISNULL(t.Status,'') = ISNULL(@Status, ISNULL(t.Status,''))  
   AND t.Status NOT IN (@OfferMadeStatus, @ActiveStatus)  
   AND ISNULL(d.Id,'') = ISNULL(@DesignationId, ISNULL(d.Id,''))  
   AND ISNULL(s.Id,'') = ISNULL(@SourceId, ISNULL(s.Id,''))  
   --AND ISNULL(U.Id,'')=ISNULL(@AddedByUserId,ISNULL(U.Id,''))  
   AND ISNULL(t1.Id,t2.Id)=ISNULL(@AddedByUserId,ISNULL(t1.Id,t2.Id))  
   AND CAST(t.CreatedDateTime as date) >= CAST(ISNULL(@FromDate,t.CreatedDateTime) as date)  
   AND CAST(t.CreatedDateTime as date) <= CAST(ISNULL(@ToDate,t.CreatedDateTime) as date)  
     
     -- Get the Total Count - Table 7  
 select * from tblUserEmail  
  
   -- Get the Total Count - Table 8  
 select * from tblUserPhone  
  
  -- Get Notes from tblUserNotes - Table 9  
--  SELECT I.FristName+' - '+CAST(I.ID as varchar) as [AddedBy],N.AddedOn,N.Notes, N.UserID from tblInstallUsers I INNER JOIN tblUserNotes N ON  
--(I.ID = N.UserID)  
  
 SELECt UserTouchPointLogID , UserID, UpdatedByUserID, UpdatedUserInstallID, replace(LogDescription,'Note : ','') LogDescription, CurrentUserGUID,  
 CONVERT(VARCHAR,ChangeDateTime,101) + ' ' + convert(varchar, ChangeDateTime, 108) as CreatedDate  
 FROM tblUserTouchPointLog n WITH (NOLOCK)  
 --inner join tblinstallusers I on I.id=n.userid  
 where isnull(UserId,0)>0 and LogDescription like 'Note :%'  
 order by ChangeDateTime desc  
END


------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

IF EXISTS (SELECT * FROM sysobjects WHERE id = object_id(N'[dbo].[SP_InsertPerfomace]') AND OBJECTPROPERTY(id, N'IsProcedure') = 1)
	BEGIN
 
	DROP PROCEDURE [SP_InsertPerfomace]   

	END  
GO    
    
-- =============================================      
-- Author: Yogesh Keraliya      
-- Create date: 05262017      
-- Description: Update users exam performance.      
-- =============================================      
CREATE PROCEDURE [dbo].[SP_InsertPerfomace]       
 (
 -- Add the parameters for the stored procedure here      
 @installUserID varchar(20),       
 @examID int = 0      
 ,@marksEarned int
)
AS      
BEGIN      
 -- SET NOCOUNT ON added to prevent extra result sets from      
 -- interfering with SELECT statements.      
 SET NOCOUNT ON;      
    
 DECLARE @totalMarks INT      
 DECLARE @Aggregate REAL      
 DECLARE @PassPercentage REAL    
        
 DECLARE @ExamPerformanceStatus INT      

 -- Get total marks for exam.
 SELECT @totalMarks = SUM(PositiveMarks) FROM MCQ_Question WHERE ExamID = @examID    
 
 -- User obtained percentage.
 SET @Aggregate =  (@marksEarned/@totalMarks) * 100
 
 -- Get total pass percentage for exam.    
 SELECT @PassPercentage = [PassPercentage] FROM MCQ_Exam WHERE [ExamID] = @examID    
 

 -- Add user pass and fail result.    
 IF(@PassPercentage < @Aggregate)    
	 BEGIN    
    
	 SET @ExamPerformanceStatus = 1    
    
	 END    
 ELSE    
	 BEGIN    
     
	  SET @ExamPerformanceStatus = 0    
    
	 END    
   
     
    -- Insert user exam result
 INSERT INTO [MCQ_Performance]      
           ([UserID]      
           ,[ExamID]      
           ,[MarksEarned]      
           ,[TotalMarks]      
           ,[Aggregate]      
     ,[ExamPerformanceStatus]                 
     )      
     VALUES      
           (@installUserID      
           ,@examID      
           ,@marksEarned      
           ,@totalMarks      
           ,@Aggregate      
          ,@ExamPerformanceStatus      
           )      
END      


---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------


IF EXISTS (SELECT * FROM sysobjects WHERE id = object_id(N'[dbo].[usp_isAllExamsGivenByUser]') AND OBJECTPROPERTY(id, N'IsProcedure') = 1)
	BEGIN
 
	DROP PROCEDURE [usp_isAllExamsGivenByUser]   

	END  
GO    

-- =============================================      
-- Author:  Yogesh Keraliya      
-- Create date: 05302017      
-- Description: This will load exam result for user based on his designation      
-- =============================================      
-- usp_isAllExamsGivenByUser 3555      
CREATE PROCEDURE [dbo].[usp_isAllExamsGivenByUser]       
(      
 @UserID bigint ,     
 @AggregateScored FLOAT= 0 OUTPUT,    
 @AllExamsGiven BIT = 0 OUTPUT    
)         
AS      
BEGIN      
       
  DECLARE @DesignationID INT      
      
  -- Get users designation based on its user id.      
  SELECT        @DesignationID = DesignationID      
  FROM            tblInstallUsers      
  WHERE        (Id = @UserID)      
      
      
IF(@DesignationID IS NOT NULL)      
    BEGIN      
      
	   DECLARE @ExamCount INT    
	   DECLARE @GivenExamCount INT    
    
	   -- check exams available for existing designation    
	   SELECT      @ExamCount = COUNT(MCQ_Exam.ExamID)    
		FROM          MCQ_Exam     
		WHERE        (@DesignationID IN     
		   (SELECT   Item   FROM  dbo.SplitString(MCQ_Exam.DesignationID, ',') AS SplitString_1)) AND  MCQ_Exam.IsActive = 1     
    
	-- check exams given by user    
	SELECT @GivenExamCount = COUNT(ExamID) FROM MCQ_Performance WHERE UserID = @UserID    
    
    -- IF all exam given, calcualte result.       
    IF( @ExamCount = @GivenExamCount AND @GivenExamCount > 0)    
		BEGIN    
    
		 SELECT @AggregateScored = (SUM([Aggregate])/@GivenExamCount) FROM MCQ_Performance  WHERE UserID = @UserID    
    
		 SET @AllExamsGiven = 1    
    
		END    
    ELSE    
		BEGIN    
		 SET @AllExamsGiven = 0    
		END    
    
    
 END      
      
RETURN @AggregateScored    
      

END      
  
----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

-- Live publish 08 15 2017

-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
SET NOCOUNT ON;  

DECLARE @UserID INT, @Email VARCHAR(250), @EmailCount INT = 0 ;


DECLARE email_cursor CURSOR FOR   
SELECT Id, Email
FROM tblInstallUsers  
WHERE Email IS NOT NULL OR Email <> ''  
 

OPEN email_cursor  

FETCH NEXT FROM email_cursor   
INTO @UserID, @Email  

WHILE @@FETCH_STATUS = 0  
BEGIN  

-- If no email exist then only insert.
IF NOT EXISTS( SELECT emailID FROM tblUserEmail WHERE emailID = @Email)
BEGIN

SET @EmailCount = @EmailCount + 1


-- if there are already other email exist for user than set it to non primary and then add existing email from install users table as a primary.

UPDATE tblUserEmail SET IsPrimary = 0 WHERE UserID = @UserID

INSERT INTO tblUserEmail
                         (emailID, IsPrimary, UserID)
VALUES        (@Email, 1,@UserID)


END

-- Get the next vendor.  
FETCH NEXT FROM email_cursor   
INTO @UserID, @Email  

END   

PRINT 'Total email inserted --- '

PRINT @EmailCount 

CLOSE email_cursor;  
DEALLOCATE email_cursor;  

------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------


SET NOCOUNT ON;  

DECLARE @UserID INT, @Phone VARCHAR(25),@CountryCode VARCHAR(15), @PhoneCount INT = 0 ;


DECLARE phone_cursor CURSOR FOR   
SELECT Id, Phone,CountryCode
FROM tblInstallUsers  
WHERE Phone IS NOT NULL OR Phone <> ''  
 

OPEN phone_cursor  

FETCH NEXT FROM phone_cursor   
INTO @UserID, @Phone , @CountryCode

WHILE @@FETCH_STATUS = 0  
BEGIN  

-- If no email exist then only insert.
IF NOT EXISTS( SELECT Phone FROM tblUserPhone WHERE Phone = @Phone)
BEGIN

SET @PhoneCount = @PhoneCount + 1


-- if there are already other email exist for user than set it to non primary and then add existing email from install users table as a primary.

UPDATE tblUserPhone SET IsPrimary = 0 WHERE UserID = @UserID

INSERT INTO tblUserPhone
                         (Phone, IsPrimary, UserID,PhoneTypeID)
VALUES        (@Phone, 1,@UserID,1)


END

-- Get the next vendor.  
FETCH NEXT FROM phone_cursor   
INTO @UserID, @Phone , @CountryCode 

END   

PRINT 'Total phone inserted --- '

PRINT @PhoneCount 

CLOSE phone_cursor;  
DEALLOCATE phone_cursor;  

------------------------------------------------------------------------------------------------------------------------------------------------------------- 

IF EXISTS (SELECT * FROM sysobjects WHERE id = object_id(N'[dbo].[sp_AddUserEmailOrPhone]') AND OBJECTPROPERTY(id, N'IsProcedure') = 1)
	BEGIN
 
	DROP PROCEDURE [sp_AddUserEmailOrPhone]   

	END  
GO 

CREATE procedure sp_AddUserEmailOrPhone  
(  
 @UserID int, @DataForValidation VARCHAR(256), @DataType INT, @PhoneTypeID varchar(10), @PhoneExt varchar(10), @IsPrimary bit  
)  
as  
begin  
 declare @DataExists VARCHAR(256)  
  
 if(@DataType = 1) --#Check Phone Number  
 begin  
  
  SELECT @DataExists = Phone FROM tblUserPhone WHERE Phone = @DataForValidation --AND UserID = @UserID  
  
  IF (isnull(@DataExists, '') <> '')  
  BEGIN  
   SET @DataExists = CONVERT(VARCHAR(256), @DataExists)+'# Contact number already exists'  
  END  
  else  
  begin  
   if(@IsPrimary = 1)  
   begin  
    update tblUserPhone set IsPrimary = 0 where UserID = @UserID  
    update tblUserEmail set IsPrimary = 0 where UserID = @UserID  
   end  
   insert into tblUserPhone(Phone, IsPrimary, PhoneTypeID, UserID, PhoneExtNo)  
   values(@DataForValidation, @IsPrimary, @PhoneTypeID, @UserID, @PhoneExt)  
  
   update tab set Phone = @DataForValidation, IsPhonePrimaryPhone = 1, IsEmailPrimaryEmail = 0, PhoneExtNo = @PhoneExt,  
   --PhoneISDCode = ph.PhoneISDCode,  
   phonetype = (select case when @PhoneTypeID in (1,2,3,4,7) then ContactName + ' #'  
      when @PhoneTypeID in (5,6,8) then ContactName  
      else '' end from tblUsercontact where UserContactId = @PhoneTypeID)  
   from tblInstallUsers tab  
   where tab.Id = @UserID and @IsPrimary = 1  
  
  end  
 end  
 else if(@DataType = 2) --#Check email  
 begin  
  SELECT @DataExists = emailID FROM tblUserEmail WHERE emailID = @DataForValidation --AND UserID = @UserID  
  
  IF (isnull(@DataExists, '') <> '')  
  BEGIN  
   SET @DataExists = CONVERT(VARCHAR(256), @DataExists)+'# Email already exists'  
  END  
  else  
  begin  
   if(@IsPrimary = 1)  
   begin  
    update tblUserEmail set IsPrimary = 0 where UserID = @UserID  
    update tblUserPhone set IsPrimary = 0 where UserID = @UserID  
   end  
   insert into tblUserEmail(emailID, IsPrimary, UserID)  
   values(@DataForValidation, @IsPrimary, @UserID)  
  
   update tab set Email = @DataForValidation, IsPhonePrimaryPhone = 0, IsEmailPrimaryEmail = 1  
   from tblInstallUsers tab  
   where tab.Id = @UserID and @IsPrimary = 1  
  end  
 end  
  
 select isnull(@DataExists, '')  
end       


--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

-- Live publish on 08212017

--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

IF EXISTS (SELECT * FROM sysobjects WHERE id = object_id(N'[dbo].[usp_SearchUsersForPopup]') AND OBJECTPROPERTY(id, N'IsProcedure') = 1)
	BEGIN
 
	DROP PROCEDURE [usp_SearchUsersForPopup]   

	END  
GO 

CREATE PROCEDURE [dbo].[usp_SearchUsersForPopup]    
 (
	 @UserIds VARCHAR(MAX),
	 @Status VARCHAR(50) = NULL, 
	 @DesignationId INT = NULL, 
	 @PageIndex INT = 0,  
	 @PageSize INT = 0, 
	 @SortExpression VARCHAR(50), 
	 @InterviewDateStatus VARChAR(5) = '5',    
	 @RejectedStatus VARChAR(5) = '9', 
	 @OfferMadeStatus VARChAR(5) = '6', 
	 @ActiveStatus VARChAR(5) = '1'     
 )
AS    

BEGIN     

SET NOCOUNT ON;    
   
  IF (@DesignationId = 0)
     BEGIN
	 SET @DesignationId = NULL
	 END  
 IF (@Status = '')
     BEGIN
	 SET @Status = NULL
	 END  
     
 DECLARE @StartIndex INT  = 0    
 SET @StartIndex = (@PageIndex * @PageSize) + 1    
      
    
 -- get records - Table 4    
 ;WITH SalesUsers    
 AS    
 (
 SELECT t.Id, t.FristName, t.LastName, t.Phone, t.Zip, t.City, d.DesignationName AS Designation, t.Status, t.HireDate, t.InstallId, t.[StatusReason],    
 t.picture, t.CreatedDateTime, Isnull(s.Source,'') AS Source, t.SourceUser, ISNULL(U.Username,t2.FristName + ' ' + t2.LastName) AddedBy, ISNULL (t.UserInstallId,t.id) As UserInstallId,    
 InterviewDetail = case when (t.Status=@InterviewDateStatus) then CAST(coalesce(t.RejectionDate,'') AS VARCHAR)  + ' ' + coalesce(t.InterviewTime,'') else '' end,    
 RejectDetail = case when (t.[Status]=@RejectedStatus ) then CAST(coalesce(t.RejectionDate,'') AS VARCHAR) + ' ' + coalesce(t.RejectionTime,'')  else '' end,    
 CASE when (t.[Status]= @RejectedStatus ) THEN t.RejectedUserId ELSE NULL END AS RejectedUserId,    
 CASE when (t.[Status]= @RejectedStatus ) THEN ru.FristName + ' ' + ru.LastName ELSE NULL END AS RejectedByUserName,    
 CASE when (t.[Status]= @RejectedStatus ) THEN ru.[UserInstallId]  ELSE NULL END AS RejectedByUserInstallId,    
 t.Email, t.DesignationID, ISNULL(t1.[UserInstallId], t2.[UserInstallId]) As AddedByUserInstallId,    
 ISNULL(t1.Id,t2.Id) As AddedById, t.emptype as 'EmpType', t.Phone As PrimaryPhone, t.CountryCode, t.Resumepath,    
 Task.TaskId AS 'TechTaskId', Task.ParentTaskId AS 'ParentTechTaskId', Task.InstallId as 'TechTaskInstallId',  
 dbo.udf_GetUserExamPercentile(t.Id) AS [Aggregate],    
 ROW_NUMBER() OVER(ORDER BY    
   CASE WHEN @SortExpression = 'Id ASC' THEN t.Id END ASC,    
   CASE WHEN @SortExpression = 'Id DESC' THEN t.Id END DESC,    
   CASE WHEN @SortExpression = 'Status ASC' THEN t.Status END ASC,    
   CASE WHEN @SortExpression = 'Status DESC' THEN t.Status END DESC,    
   CASE WHEN @SortExpression = 'FristName ASC' THEN t.FristName END ASC,    
   CASE WHEN @SortExpression = 'FristName DESC' THEN t.FristName END DESC,    
   CASE WHEN @SortExpression = 'Designation ASC' THEN d.DesignationName END ASC,    
   CASE WHEN @SortExpression = 'Designation DESC' THEN d.DesignationName END DESC,    
   CASE WHEN @SortExpression = 'Source ASC' THEN s.Source END ASC,    
   CASE WHEN @SortExpression = 'Source DESC' THEN s.Source END DESC,    
   CASE WHEN @SortExpression = 'Phone ASC' THEN t.Phone END ASC,    
   CASE WHEN @SortExpression = 'Phone DESC' THEN t.Phone END DESC,    
   CASE WHEN @SortExpression = 'Zip ASC' THEN t.Phone END ASC,    
   CASE WHEN @SortExpression = 'Zip DESC' THEN t.Phone END DESC,     
   CASE WHEN @SortExpression = 'City ASC' THEN t.City END ASC,    
   CASE WHEN @SortExpression = 'City DESC' THEN t.City END DESC,     
   CASE WHEN @SortExpression = 'CreatedDateTime ASC' THEN t.CreatedDateTime END ASC,    
   CASE WHEN @SortExpression = 'CreatedDateTime DESC' THEN t.CreatedDateTime END DESC     
       ) AS RowNumber

  FROM tblInstallUsers t    
  LEFT OUTER JOIN tblUsers U ON U.Id = t.SourceUser    
  LEFT OUTER JOIN tblInstallUsers t2 ON t2.Id = t.SourceUser    
  LEFT OUTER JOIN tblInstallUsers ru on t.RejectedUserId= ru.Id    
  LEFT OUTER JOIN tblInstallUsers t1 ON t1.Id= U.Id    
  LEFT OUTER JOIN tbl_Designation d ON t.DesignationId = d.Id    
  LEFT JOIN tblSource s ON t.SourceId = s.Id    
  OUTER APPLY    
 (     
 SELECT tsk.TaskId, tsk.ParentTaskId, tsk.InstallId, ROW_NUMBER() OVER(ORDER BY u.TaskUserId DESC) AS RowNo    
 FROM tblTaskAssignedUsers u    
 INNER JOIN tblTask tsk ON u.TaskId = tsk.TaskId AND    
 (tsk.ParentTaskId IS NOT NULL OR tsk.IsTechTask = 1)    
 WHERE u.UserId = t.Id    
 ) AS Task    
 WHERE (t.UserType = 'SalesUser' OR t.UserType = 'sales') 
 AND ISNULL(t.[Status],'') = ISNULL(@Status, ISNULL(t.[Status],''))    
 AND t.[Status] NOT IN (@OfferMadeStatus, @ActiveStatus)    
 AND ISNULL(d.Id,'') = ISNULL(@DesignationId, ISNULL(d.Id,''))    
 AND t.Id IN (SELECT   Item   FROM  dbo.SplitString(@UserIds, ',') AS UserId)
 
)    


SELECT  Id, FristName, LastName, Phone, Zip, Designation, Status, HireDate, InstallId, picture, CreatedDateTime, Source, SourceUser,    
AddedBy, UserInstallId, InterviewDetail, RejectDetail, RejectedUserId, RejectedByUserName, RejectedByUserInstallId, Email, DesignationID,    
AddedByUserInstallId, AddedById, EmpType, [Aggregate], PrimaryPhone, CountryCode, Resumepath, TechTaskId, ParentTechTaskId,    
TechTaskInstallId, [StatusReason], City    
FROM SalesUsers    
WHERE RowNumber >= @StartIndex AND (@PageSize = 0 OR RowNumber < (@StartIndex + @PageSize))    
GROUP BY Id, FristName, LastName, Phone, Zip, Designation, Status, HireDate, InstallId, picture, CreatedDateTime, Source, SourceUser,    
AddedBy, UserInstallId, InterviewDetail, RejectDetail, RejectedUserId, RejectedByUserName, RejectedByUserInstallId, Email, DesignationID,    
AddedByUserInstallId, AddedById, EmpType, [Aggregate], PrimaryPhone, CountryCode, Resumepath, TechTaskId, ParentTechTaskId,    
TechTaskInstallId, [StatusReason], City    
    
 -- get record count - Table 5    
 SELECT COUNT(t.Id)  FROM tblInstallUsers t    
  LEFT OUTER JOIN tblUsers U ON U.Id = t.SourceUser    
  LEFT OUTER JOIN tblInstallUsers t2 ON t2.Id = t.SourceUser    
  LEFT OUTER JOIN tblInstallUsers ru on t.RejectedUserId= ru.Id    
  LEFT OUTER JOIN tblInstallUsers t1 ON t1.Id= U.Id    
  LEFT OUTER JOIN tbl_Designation d ON t.DesignationId = d.Id    
  LEFT JOIN tblSource s ON t.SourceId = s.Id    
  OUTER APPLY    
 (     
	 SELECT tsk.TaskId, tsk.ParentTaskId, tsk.InstallId, ROW_NUMBER() OVER(ORDER BY u.TaskUserId DESC) AS RowNo    
	 FROM tblTaskAssignedUsers u    
	 INNER JOIN tblTask tsk ON u.TaskId = tsk.TaskId AND    
	 (tsk.ParentTaskId IS NOT NULL OR tsk.IsTechTask = 1)    
	 WHERE u.UserId = t.Id    
 ) AS Task    
 WHERE (t.UserType = 'SalesUser' OR t.UserType = 'sales') 
 AND ISNULL(t.[Status],'') = ISNULL(@Status, ISNULL(t.[Status],''))    
 AND t.[Status] NOT IN (@OfferMadeStatus, @ActiveStatus)    
 AND ISNULL(d.Id,'') = ISNULL(@DesignationId, ISNULL(d.Id,''))
 AND t.Id IN (SELECT   Item   FROM  dbo.SplitString(@UserIds, ',') AS UserId)


END

-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

IF EXISTS (SELECT * FROM sysobjects WHERE id = object_id(N'[dbo].[usp_GetAssignedDesigSequenceForInterviewDatePopup]') AND OBJECTPROPERTY(id, N'IsProcedure') = 1)
	BEGIN
 
	DROP PROCEDURE [usp_GetAssignedDesigSequenceForInterviewDatePopup]   

	END  
GO 

-- =============================================      
-- Author:  Yogesh Keraliya      
-- Create date: 08232017      
-- Description: This will fetch tentative sequence to be assigned to users.      
-- =============================================      
-- [dbo].[usp_GetAssignedDesigSequenceForInterviewDatePopup] 9,1,3
      
CREATE PROCEDURE [dbo].[usp_GetAssignedDesigSequenceForInterviewDatePopup]       
( 
 @DesignationId INT,      
 @IsTechTask BIT,    
 @UserCount  INT      
)      
AS      
BEGIN      
    
SELECT  TOP (@UserCount) ISNULL([Sequence],1) AS SequenceNo, TaskId, dbo.udf_GetParentTaskId(TaskId) AS ParentTaskId,dbo.udf_GetCombineInstallId(TaskId) AS InstallId FROM tblTask       
WHERE (AdminUserId IS NOT NULL AND TechLeadUserId IS NOT NULL ) AND [SequenceDesignationId] = @DesignationID AND IsTechTask = @IsTechTask AND [Sequence] IS NOT NULL AND [Sequence] > (         
      
  SELECT       ISNULL(MAX(AssignedDesigSeq),0) AS LastAssignedSequence      
   FROM            tblAssignedSequencing      
  WHERE        (DesignationId = @DesignationId) AND (IsTechTask = @IsTechTask)      
      
)       
ORDER BY [Sequence] ASC      

      
END

--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
IF EXISTS (SELECT * FROM sysobjects WHERE id = object_id(N'[dbo].[usp_GetAllTasksforSubSequencing]') AND OBJECTPROPERTY(id, N'IsProcedure') = 1)
	BEGIN
 
	DROP PROCEDURE usp_GetAllTasksforSubSequencing   

	END  
GO    
-- usp_GetAllTasksforSubSequencing '9','-ITJN:SS',0, 556  
CREATE PROCEDURE usp_GetAllTasksforSubSequencing
(                                    
 @DesignationId INT = 0,
 @DesiSeqCode VARCHAR(20),                  
 @IsTechTask BIT = 0,
 @TaskId   BIGINT    
)                        
As                        
BEGIN                        
                

SELECT DISTINCT TaskId,[Sequence],CONVERT(VARCHAR(20),[Sequence]) + @DesiSeqCode AS SeqLable                    
           
FROM  tbltask a                        
                    
WHERE                   
  (                   
    (a.[Sequence] IS NOT NULL)  
	AND a.[SubSequence] IS NULL                
    AND (a.[SequenceDesignationId] = @DesignationId  )                
    AND (ISNULL(a.[IsTechTask],@IsTechTask) = @IsTechTask)   
	AND TaskId <> @TaskId               
                     
  )               
ORDER BY a.[Sequence] DESC                  
                      
END 

-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
  

------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------


-- Live publish 08262017


------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------


IF EXISTS (SELECT * FROM sysobjects WHERE id = object_id(N'[dbo].[usp_DeleteTaskSubSequenceByTaskId]') AND OBJECTPROPERTY(id, N'IsProcedure') = 1)
	BEGIN
 
	DROP PROCEDURE usp_DeleteTaskSubSequenceByTaskId   

	END  
GO    

-- =============================================      
-- Author:  Yogesh      
-- Create date: 01 Sep 17      
-- Description: Delete Task Sequence Task by Id.      
-- =============================================      
CREATE PROCEDURE [dbo].[usp_DeleteTaskSubSequenceByTaskId]      
 @TaskId  BIGINT           
AS      
BEGIN      
    
BEGIN TRANSACTION        

DECLARE @OriginalSeq BIGINT    
DECLARE @OriginalSubSeq BIGINT  
DECLARE @OriginalDesignationID INT      
DECLARE @IsTechTask BIT  
  
-- Get Sequence, SequenceDesignation, IsTechTask flag from tak   
SELECT  @OriginalSeq = [Sequence] ,@OriginalSubSeq = [SubSequence], @OriginalDesignationID = [SequenceDesignationId], @IsTechTask = IsTechTask FROM tblTask WHERE TaskId = @TaskId  
  
UPDATE tblTask      
   SET                [Sequence] = NULL , [SubSequence] = NULL , [SequenceDesignationId] = NULL  
WHERE        (TaskId = @TaskId)     
  
  
-- IF SEQ DESIGNATION IS CHANGED THAN UPDATE ORIGINAL SEQUENCE SERIES OF DESIGNATION.  
  
-- if 2 is removed from sequence than all sequence will greater than 2 for that designation will be shifted up by 1.   
 UPDATE       tblTask      
     SET                [SubSequence] = [SubSequence] - 1         
 WHERE        ([SubSequence] >= @OriginalSubSeq) AND [Sequence] = @OriginalSeq AND ([SequenceDesignationId] = @OriginalDesignationID) AND IsTechTask = @IsTechTask    
   
  
  IF (@@Error <> 0)   -- Check if any error  
     BEGIN            
        ROLLBACK TRANSACTION         
     END   
   ELSE   
       COMMIT TRANSACTION      
END         


------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

IF EXISTS (SELECT * FROM sysobjects WHERE id = object_id(N'[dbo].[usp_SwapSubTaskSequences]') AND OBJECTPROPERTY(id, N'IsProcedure') = 1)
	BEGIN
 
	DROP PROCEDURE usp_SwapSubTaskSequences   

	END  
GO    
  
    
-- =============================================                  
-- Author:  Yogesh Keraliya                  
-- Create date: 09012017                  
-- Description: This will swap sub sequence between two tasks.                  
-- =============================================                  
-- 
CREATE PROCEDURE [dbo].[usp_SwapSubTaskSequences]                   
(                  
                
 @FirstTaskID BIGINT = 0,                   
 @SecondTaskID BIGINT = 0,                   
 @FirstSubSeq BIGINT = 0,            
 @SecondSubSeq BIGINT = 0                    
)                  
As                  
BEGIN                  
     
  UPDATE       tblTask  
  SET                [SubSequence] = @SecondSubSeq  
  WHERE        (TaskId = @FirstTaskID)          
    
  UPDATE       tblTask  
  SET                [SubSequence] = @FirstSubSeq  
  WHERE        (TaskId = @SecondTaskID)          
    
                
END   
  
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------      

IF EXISTS (SELECT * FROM sysobjects WHERE id = object_id(N'[dbo].[usp_DeleteTaskSequenceByTaskId]') AND OBJECTPROPERTY(id, N'IsProcedure') = 1)
	BEGIN
 
	DROP PROCEDURE [usp_DeleteTaskSequenceByTaskId]   

	END  
GO    

  
-- =============================================      
-- Author:  Yogesh      
-- Create date: 31 July 17      
-- Description: Delete Task Sequence Task by Id.      
-- =============================================      
CREATE PROCEDURE [dbo].[usp_DeleteTaskSequenceByTaskId]      
 @TaskId  BIGINT           
AS      
BEGIN      
    
BEGIN TRANSACTION        
    
DECLARE @OriginalSeq BIGINT  
DECLARE @OriginalDesignationID INT      
DECLARE @IsTechTask BIT  
  
-- Get Sequence, SequenceDesignation, IsTechTask flag from tak   
SELECT @OriginalSeq = [Sequence], @OriginalDesignationID = [SequenceDesignationId], @IsTechTask = IsTechTask FROM tblTask WHERE TaskId = @TaskId  


-- Remove all task subsequences and sequence
UPDATE tblTask      
   SET  [Sequence] = NULL, [SubSequence] = NULL , [SequenceDesignationId] = NULL  
WHERE [Sequence] = @OriginalSeq AND [SequenceDesignationId] = @OriginalDesignationID AND  @IsTechTask = IsTechTask
  
  
-- IF SEQ DESIGNATION IS CHANGED THAN UPDATE ORIGINAL SEQUENCE SERIES OF DESIGNATION.  
  
-- if 2 is removed from sequence than all sequence will greater than 2 for that designation will be shifted up by 1.   
 UPDATE       tblTask      
     SET                [Sequence] = [Sequence] - 1         
 WHERE        ([Sequence] >= @OriginalSeq) AND ([SequenceDesignationId] = @OriginalDesignationID) AND IsTechTask = @IsTechTask    
   
  
  IF (@@Error <> 0)   -- Check if any error  
     BEGIN            
        ROLLBACK TRANSACTION         
     END   
   ELSE   
       COMMIT TRANSACTION      
END


--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------




IF EXISTS (SELECT * FROM sysobjects WHERE id = object_id(N'[dbo].[usp_UpdateTaskSequence]') AND OBJECTPROPERTY(id, N'IsProcedure') = 1)
	BEGIN
 
	DROP PROCEDURE [usp_UpdateTaskSequence]   

	END  
GO   
  
-- =============================================      
-- Author:  Yogesh Keraliya      
-- Create date: 05162017      
-- Description: This will update task sequence      
-- =============================================      
CREATE PROCEDURE [dbo].[usp_UpdateTaskSequence]       
(       
 @Sequence bigint ,    
 @DesignationID int,       
 @TaskId bigint,    
 @IsTechTask bit   
)      
AS      
BEGIN      
  
  
BEGIN TRANSACTION        
    
DECLARE @OriginalSeq BIGINT  
DECLARE @OriginalDesignationID INT      
  
SELECT @OriginalSeq = [Sequence],@OriginalDesignationID =  [SequenceDesignationId] FROM tblTask WHERE TaskId = @TaskId  
  
 UPDATE tblTask      
   SET                [Sequence] = @Sequence , [SequenceDesignationId] = @DesignationID    
 WHERE  ([Sequence] = @OriginalSeq) AND ([SequenceDesignationId] = @OriginalDesignationID) AND IsTechTask = @IsTechTask    
  
  
-- IF SEQ DESIGNATION IS CHANGED THAN UPDATE ORIGINAL SEQUENCE SERIES OF DESIGNATION.  
IF ( @OriginalDesignationID IS NOT  NULL AND @OriginalDesignationID <> @DesignationID)  
BEGIN  
  
-- if 2 is removed from sequence than all sequence will greater than 2 for that designation will be shifted up by 1.   
 UPDATE       tblTask      
     SET                [Sequence] = [Sequence] - 1         
 WHERE        ([Sequence] >= @OriginalSeq) AND ([SequenceDesignationId] = @OriginalDesignationID) AND IsTechTask = @IsTechTask    
  
  
END      
    
  
  IF (@@Error <> 0)   -- Check if any error  
     BEGIN            
        ROLLBACK TRANSACTION         
     END   
   ELSE   
       COMMIT TRANSACTION    
  
---- if sequence is already assigned to some other task with same designation, all sequence will push back by 1 from alloted sequence for that designation.      
--IF EXISTS(SELECT   T.TaskId    
--FROM            tblTask AS T     
--WHERE        (T.[Sequence] = @Sequence) AND (T.TaskId <> @TaskId) AND (T.[SequenceDesignationId] = @DesignationID) AND T.IsTechTask = @IsTechTask)      
--  BEGIN      
      
--  -- push back all task sequence for 1 from sequence assigned in between.    
--     UPDATE       tblTask      
--     SET                [Sequence] = [Sequence] + 1         
--     WHERE        ([Sequence] >= @Sequence) AND ([SequenceDesignationId] = @DesignationID) AND IsTechTask = @IsTechTask    
      
--  END      
      
  -- Update task sequence and its respective designationid.    
   
    
    
END   


------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

-- Live publish 09022017

------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------     

------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------     


    
-- =============================================        
-- Author:  Yogesh Keraliya        
-- Create date: 05162017        
-- Description: This will update task sequence        
-- =============================================       
-- [dbo].[usp_UpdateTaskSequence]    8,702,12, 0      
ALTER PROCEDURE [dbo].[usp_UpdateTaskSequence]         
(         
 @Sequence bigint ,      
 @DesignationID int,         
 @TaskId bigint,      
 @IsTechTask bit     
)        
AS        
BEGIN        
    
    
BEGIN TRANSACTION          
      
DECLARE @OriginalSeq BIGINT    
DECLARE @OriginalDesignationID INT        
    
SELECT @OriginalSeq = [Sequence],@OriginalDesignationID =  [SequenceDesignationId] FROM tblTask WHERE TaskId = @TaskId    
    
 
-- IF TASK HAS NO SEQUENCE ASSIGNED PREVIOUSLY 
IF( @OriginalSeq IS NULL )
        BEGIN

        UPDATE tblTask        
           SET                [Sequence] = @Sequence , [SequenceDesignationId] = @DesignationID      
         WHERE  ([Sequence] = @OriginalSeq) AND ([SequenceDesignationId] = @OriginalDesignationID) AND IsTechTask = @IsTechTask       

        END

                -- IF SEQ DESIGNATION IS CHANGED THAN UPDATE ORIGINAL SEQUENCE SERIES OF DESIGNATION.    
        IF ( @OriginalDesignationID IS NOT  NULL AND @OriginalDesignationID <> @DesignationID)    
        BEGIN    
    
            -- if 2 is removed from sequence than all sequence will greater than 2 for that designation will be shifted up by 1.     
             UPDATE       tblTask        
                 SET                [Sequence] = [Sequence] - 1           
             WHERE        ([Sequence] > @OriginalSeq) AND ([SequenceDesignationId] = @OriginalDesignationID) AND IsTechTask = @IsTechTask      
    
    
        END       

ELSE
        BEGIN

            UPDATE tblTask        
               SET                [Sequence] = @Sequence , [SequenceDesignationId] = @DesignationID   
             WHERE TaskId = @TaskId 

        END
      
    
  IF (@@Error <> 0)   -- Check if any error    
     BEGIN              
        ROLLBACK TRANSACTION           
     END     
   ELSE     
       COMMIT TRANSACTION         
      
      
END     


-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

IF EXISTS (SELECT * FROM sysobjects WHERE id = object_id(N'[dbo].[usp_DeleteTaskSequenceByTaskId]') AND OBJECTPROPERTY(id, N'IsProcedure') = 1)
    BEGIN
 
    DROP PROCEDURE [usp_DeleteTaskSequenceByTaskId]   

    END  
GO    

  
-- =============================================      
-- Author:  Yogesh      
-- Create date: 31 July 17      
-- Description: Delete Task Sequence Task by Id.      
-- =============================================      
CREATE PROCEDURE [dbo].[usp_DeleteTaskSequenceByTaskId]      
 @TaskId  BIGINT           
AS      
BEGIN      
    
BEGIN TRANSACTION        
    
DECLARE @OriginalSeq BIGINT  
DECLARE @OriginalDesignationID INT      
DECLARE @IsTechTask BIT  
  
-- Get Sequence, SequenceDesignation, IsTechTask flag from tak   
SELECT @OriginalSeq = [Sequence], @OriginalDesignationID = [SequenceDesignationId], @IsTechTask = IsTechTask FROM tblTask WHERE TaskId = @TaskId  


-- Remove all task subsequences and sequence
UPDATE tblTask      
   SET  [Sequence] = NULL, [SubSequence] = NULL , [SequenceDesignationId] = NULL  
WHERE [Sequence] = @OriginalSeq AND [SequenceDesignationId] = @OriginalDesignationID AND  @IsTechTask = IsTechTask
  
  
-- IF SEQ DESIGNATION IS CHANGED THAN UPDATE ORIGINAL SEQUENCE SERIES OF DESIGNATION.  
  
-- if 2 is removed from sequence than all sequence will greater than 2 for that designation will be shifted up by 1.   
 UPDATE       tblTask      
     SET                [Sequence] = [Sequence] - 1         
 WHERE        ([Sequence] > @OriginalSeq) AND ([SequenceDesignationId] = @OriginalDesignationID) AND IsTechTask = @IsTechTask    
   
  
  IF (@@Error <> 0)   -- Check if any error  
     BEGIN            
        ROLLBACK TRANSACTION         
     END   
   ELSE   
       COMMIT TRANSACTION      
END

-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

IF EXISTS (SELECT * FROM sysobjects WHERE id = object_id(N'[dbo].[usp_GetAllTasksforSubSequencing]') AND OBJECTPROPERTY(id, N'IsProcedure') = 1)
    BEGIN
 
    DROP PROCEDURE usp_GetAllTasksforSubSequencing   

    END  
GO    
-- usp_GetAllTasksforSubSequencing 12,'-ITSPH:SS',0, 556    
CREATE PROCEDURE usp_GetAllTasksforSubSequencing  
(                                      
 @DesignationId INT = 0,  
 @DesiSeqCode VARCHAR(20),                    
 @IsTechTask BIT = 0,  
 @TaskId   BIGINT      
)                          
As                          
BEGIN                          
                  
  
SELECT DISTINCT TaskId,[Sequence],CONVERT(VARCHAR(20),[Sequence]) + @DesiSeqCode AS SeqLable                      
             
FROM  tbltask a                          
                      
WHERE                     
  (                     
    (a.[Sequence] IS NOT NULL)    
    AND (a.[SequenceDesignationId] = @DesignationId  )                  
    AND (ISNULL(a.[IsTechTask],@IsTechTask) = @IsTechTask)     
    AND TaskId <> @TaskId                 
    AND NOT EXISTS (SELECT 1 FROM tblTask as t WHERE  t.[Sequence] = a.[Sequence] AND t.[SequenceDesignationId] = a.[SequenceDesignationId] AND t.SubSequence IS NOT NULL AND IsTechTask = @IsTechTask)                   
  )                 
ORDER BY a.[Sequence] DESC                    
                        
END   

-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

/****** Object:  UserDefinedFunction [dbo].[udf_GetUserExamPercentile]    Script Date: 9/10/2017 1:18:58 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:        Yogesh Keraliya
-- Create date: 060212017
-- Description:    This will get aggregate % for user's given exam if any
-- =============================================
CREATE FUNCTION [dbo].[udf_IsUserAssigned] 
(    
    @UserID INT
)
RETURNS BIT
AS
BEGIN
    -- Declare the return variable here
    DECLARE @UserAssigned BIT = 0
    
    
IF EXISTS (SELECT AssignedDesigSeq FROM tblAssignedSequencing WHERE UserId = @UserID)
BEGIN

SET @UserAssigned = 1

END



-- Return the result of the function
RETURN @UserAssigned

END

------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

-- =============================================        
-- Author:  Yogesh        
-- Create date: 23 Feb 2017      
-- Updated By : Yogesh      
--     Added applicant status to allow applicant to login.      
-- Updated By : Nand Chavan (Task ID#: REC001-XIII)    
--                  Replace Source with SourceID    
-- Description: Get an install user by email and status.      
-- =============================================      
-- [dbo].[UDP_GetInstallerUserDetailsByLoginId]  'Surmca17@gmail.com' 
ALTER PROCEDURE [dbo].[UDP_GetInstallerUserDetailsByLoginId]      
 @loginId varchar(50) ,      
 @ActiveStatus varchar(5) = '1',      
 @ApplicantStatus varchar(5) = '2',      
 @InterviewDateStatus varchar(5) = '5',      
 @OfferMadeStatus varchar(5) = '6'      
AS      
BEGIN      
    
 DECLARE @phone varchar(1000) = @loginId    
    
 --REC001-XIII - create formatted phone#    
 IF ISNUMERIC(@loginId) = 1 AND LEN(@loginId) > 5    
 BEGIN    
  SET @phone =  '(' + SUBSTRING(@phone, 1, 3) + ')-' + SUBSTRING(@phone, 4, 3) + '-' + SUBSTRING(@phone, 7, LEN(@phone))    
 END    
        
  SELECT Id,FristName,Lastname,Email,[Address],Designation,[Status],      
   [Password],[Address],Phone,Picture,Attachements,usertype, Picture,IsFirstTime,DesignationID,  
   CASE WHEN  [Status] = '5' THEN [dbo].[udf_IsUserAssigned](tbi.Id) ELSE 0 END AS AssignedSequence  
  FROM tblInstallUsers  AS tbi 
  WHERE       
   (Email = @loginId OR Phone = @loginId  OR Phone = @phone)     
   AND ISNULL(@loginId, '') != ''   AND    
   (      
    [Status] = @ActiveStatus OR       
    [Status] = @ApplicantStatus OR      
    [Status] = @OfferMadeStatus OR       
    [Status] = @InterviewDateStatus      
   )      
    
END


------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

---------------------- Live Publish 09102017

------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
